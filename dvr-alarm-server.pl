#!/usr/bin/perl

#
# Simple log/alarm server receiving and printing to console remote dvr/camera events. Tested with:
#
# HJCCTV HJ-H4808BW
# http://www.aliexpress.com/item/Hybird-NVR-8chs-H-264DVR-8chs-onvif-2-3-Economical-DVR-8ch-Video-4-AUDIO-AND/1918734952.html
#
# PBFZ TCV-UTH200
# http://www.aliexpress.com/item/Free-shipping-2014-NEW-IP-camera-CCTV-2-0MP-HD-1080P-IP-Network-Security-CCTV-Waterproof/1958962188.html

$SIG{CHLD} = 'IGNORE';

use Module::Load::Conditional qw[can_load check_install requires];
my $use_list = {
  'IO::Socket'        => undef,
  'IO::Socket::INET'  => undef,
  'Time::Local'       => undef,
  JSON                => undef,
  'Data::Dumper'      => undef,
  'Net::MQTT::Simple' => undef,
  'Getopt::Long'      => undef,
  'Pod::Usage'        => undef,
};

if ( !can_load( modules => $use_list, autoload => true ) ) {
  my @deps;
  for $module (keys %{$use_list}) {
    if (!check_install(module => $module)) {
      push(@deps, $module);
    }
  }

  print STDERR "Failed to load required modules. Try to install the missing dependencies manually by executing:\n\n \$ sudo cpan " . join( ' ', @deps) . "\n";
  exit(1);
}

use IO::Socket;
use IO::Socket::INET;
use Sys::Syslog;
use Sys::Syslog qw(:DEFAULT setlogsock);
use Sys::Syslog qw(:standard :macros);
use Time::Local;
use JSON;
use Data::Dumper;
use Getopt::Long;
use Pod::Usage;

setlogsock("console");
openlog("dvr-alarm-server", "cons,pid", LOG_USER);

sub BuildPacket {
  my ($type, $params) = ($_[0], $_[1]);
  my @pkt_prefix_1;
  my @pkt_prefix_2;
  my @pkt_type;
  my $sid = 0;
  my $json = JSON->new;

  @pkt_prefix_1 = (0xff, 0x00, 0x00, 0x00);
  @pkt_prefix_2 =  (0x00, 0x00, 0x00, 0x00);
 
  if ($type eq 'login') {
    @pkt_type = (0x00, 0x00, 0xe8, 0x03);
  } elsif ($type eq 'info') {
    @pkt_type = (0x00, 0x00, 0xfc, 0x03);
  }
 
  $sid = hex($params->{'SessionID'});
 
  my $pkt_prefix_data =  pack('c*', @pkt_prefix_1) . pack('i', $sid) . pack('c*', @pkt_prefix_2). pack('c*', @pkt_type);
  my $pkt_params_data =  $json->encode($params);
  my $pkt_data = $pkt_prefix_data . pack('i', length($pkt_params_data)) . $pkt_params_data;

  return $pkt_data;
}

sub GetReplyHead {
  my $sock = $_[0];
  my @reply_head_array;

  for (my $i = 0; $i < 5; $i++) {
    $sock->recv($data, 4);
    $reply_head[$i]  = unpack('i', $data);
    print OUT $data;
  }

  my $reply_head = {
    Prefix1 => $reply_head[0],
    Prefix2 => $reply_head[1],
    Prefix3 => $reply_head[2],
    Prefix4 => $reply_head[3],
    Content_Length => $reply_head[4]
  };

  return $reply_head;
}

my $cfgFile = "";
my $cfgUser = "";
my $cfgPass = "";
my $cfgHost = "0.0.0.0";
my $cfgPort = "15002";
my $cfgMQTTHost = "";
my $cfgMQTTPort = 1883;
my $cfgMQTTUser = "";
my $cfgMQTTPass = "";
my $cfgCmd = undef;
my $cfgLog = "syslog";
my $cfgDebugPath = "/var/log/pgsmgate/debug";
my $help = 0;
my $result = GetOptions(
  "help|h"            => \$help,
  "outputfile|of|o=s" => \$cfgFile,
  "user|u=s"          => \$cfgUser,
  "pass|p=s"          => \$cfgPass,
  "host|hst=s"        => \$cfgHost,
  "port|prt=s"        => \$cfgPort,
  "mqttuser|u=s"      => \$cfgMQTTUser,
  "mqttpass|p=s"      => \$cfgMQTTPass,
  "mqtthost|hst=s"    => \$cfgMQTTHost,
  "mqttport|prt=s"    => \$cfgMQTTPort,
  "command|cmd|c=s"   => \$cfgCmd,
  "log|l=s"           => \$cfgLog,
  "debugpath|dp=s"    => \$cfgDebugPath,
);

pod2usage(1) if ($help);

if (!($cfgHost or $cfgPort)) {
  print STDERR "You must set host and port!\n";
  exit(0);
}

my $sock = new IO::Socket::INET ( LocalHost => $cfgHost, LocalPort => $cfgPort, Proto => 'tcp',  Listen => 1, Reuse => 1 ); die "Could not create socket: $!\n" unless $sock;
die "Could not create socket: $!\n" unless $sock;

my $mqtt = undef;
my $json = JSON->new;

if ($cfgMQTTHost) {
  $mqtt = Net::MQTT::Simple->new($cfgMQTTHost);
}

while (my ($client,$clientaddr) = $sock->accept()) {
  write_log("Connected from ".$client->peerhost());
  $pid = fork();
  local $SIG{CHLD} = 'IGNORE';
  die "Cannot fork: $!" unless defined($pid);

  if ($pid == 0) {
    my $data = '';
    my $topic = 'dvr-alarm-server';
    my $reply = GetReplyHead($client);
    # Client protocol detection
    $client->recv($data, $reply->{'Content_Length'});
    my $decoded_data =  decode_json($data);

    print STDERR $json->encode($decoded_data);

    if ($mqtt) {
      $mqtt->publish("$topic/events", $json->encode($decoded_data));
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/events", $json->encode($decoded_data));
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/type", $decoded_data->{Type});
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/id", $decoded_data->{SerialID});
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/event", $decoded_data->{Event});
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/address", inet_ntoa(pack('V', hex($decoded_data->{Address}))));
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/channel", $decoded_data->{Channel});
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/start_time", $decoded_data->{StartTime});
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/status", $decoded_data->{Status});
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/description", $decoded_data->{Descrip});
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/type/" . $decoded_data->{Type}, $json->encode($decoded_data));
      $mqtt->publish("$topic/devices/" . $decoded_data->{SerialID} . "/event/" . $decoded_data->{Event}, $json->encode($decoded_data));
    }

    exit(0);
  }
}
close($sock);

sub write_log() {
  #syslog('info', $_[0]);
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time());
  my $timestamp = sprintf("%02d.%02d.%4d %02d:%02d:%02d",$mday,$mon+1,$year+1900,$hour,$min,$sec);
  print STDERR "$timestamp dvr-alarm-server[] " . $_[0] ."\n";
}


__END__

=head1 NAME

./dvr-alarm-server.pl - alarm server for DVR/IPCAM with XM Sofia firmware

=head1 SYNOPSIS

./dvr-alarm-server.pl [options]

=head1 OPTIONS

=over 8

=item B<-help>

Print a brief help message and exits.

=item B<-of>

Path to output file filename.

=item B<-u>

username

=item B<-p>

password

=item B<-host>

hostname or ip address

=item B<-port>

alarm server listening port

=item B<-c>

command

=back

=head1 DESCRIPTION

B<This program> is a alarm server for DVR/IPCAM with XM Sofia firmware

=cut
