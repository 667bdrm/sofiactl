#!/usr/bin/perl

#
# Simple log/alarm server receiving and printing to console remote dvr/camera events. Tested with:
#
# HJCCTV HJ-H4808BW
# http://www.aliexpress.com/item/Hybird-NVR-8chs-H-264DVR-8chs-onvif-2-3-Economical-DVR-8ch-Video-4-AUDIO-AND/1918734952.html
#
# PBFZ TCV-UTH200
# http://www.aliexpress.com/item/Free-shipping-2014-NEW-IP-camera-CCTV-2-0MP-HD-1080P-IP-Network-Security-CCTV-Waterproof/1958962188.html



use IO::Socket;
use IO::Socket::INET;
use Sys::Syslog;
use Sys::Syslog qw(:DEFAULT setlogsock);
use Sys::Syslog qw(:standard :macros);
use Time::Local;
use JSON;
use Data::Dumper;

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
 
 
  #print "$i: " . $reply_head[$i] . "\n";
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


my $sock = new IO::Socket::INET ( LocalHost => '0.0.0.0', LocalPort => '15002', Proto => 'tcp',  Listen => 1, Reuse => 1 ); die "Could not create socket: $!\n" unless $sock;

while (my ($client,$clientaddr) = $sock->accept()) {
 
 write_log("Connected from ".$client->peerhost());
 $pid = fork();
 
 die "Cannot fork: $!" unless defined($pid);
 
 if ($pid == 0) { 
        # Child process
		my $data = '';
		

        
        my $reply = GetReplyHead($client);
        
		# Client protocol detection
		$client->recv($data, $reply->{'Content_Length'});

        print Dumper decode_json($data);
        
		
		my $cproto = $data;
		
		#write_log($client->peerhost() . " proto = '$cproto'");
		

		
		
		
        exit(0);   # Child process exits when it is done.
 } # else 'tis the parent process, which goes back to accept()

}
close($sock);

sub write_log() {
 #syslog('info', $_[0]);
 my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time());
 my $timestamp = sprintf("%02d.%02d.%4d %02d:%02d:%02d",$mday,$mon+1,$year+1900,$hour,$min,$sec);
 
 print "$timestamp dvr-alarm-server[] " . $_[0] ."\n";
 
}