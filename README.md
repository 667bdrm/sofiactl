# sofiactl

sofiactl is an open source cross-platform tool and sdk to control Sofia powered Hi35xx DVR devices 
using hybrid JSON/binary communication protocol used by original CMS software (default port 34567)


## Usage

sofiactl.pl --user username --pass password --host 192.168.0.1 --port 34567 --command command [ --of output_file ] [ -d] [ --help]

## WARNING

ALWAYS BACKUP your configuration with OEM CMS software before using this tool

supported commands:

|command | description |
|--|--|
OPTimeSetting | Set device time to the current time
Users | Get users info
Groups | Get groups info
SystemInfo | Get system info
StorageInfo | Get storage info
OEMInfo | Get OEM info
WorkState | Get work state
LogExport | Download logs to the output file specified by --of parameter
ConfigExport | Download configuration files to the output file specified by --of parameter
OPStorageManagerClear | Format storage (remove all recording)
OPStorageManagerRO | Switch partition 0 to read-only mode (not tested!)
OPStorageManagerRW | Switch partition 0 to read/write mode (not tested!)
OPFileQuery | Search records. Requires --bt, --et, --ch parameters
OPLogQuery | Search logs. Requires --bt, --et parameters
ConfigGet | Get configuration of specified by --co parameter section
AuthorityList | Get authenticated user access permissions
OPTimeQuery | Get device date and time
Ability | Get device eatures
User | Add new user. Requires --username, --newuserpass and --newusergroup parameters
DeleteUser | Delete existing user
ChannelTitle | Show channel titles
ChannelTitleSet | Set channel titles. Pass comma separated channel titles for all device channels
ConfigSet | Set configuration section (--co) value from set data (--sd) or  input json file (--if). WARNING!!! There are reports about settings break using thius command. Hold on with use this option until resolution confirm.
Reboot | Reboot the device

parameters:

|parameter | description |
|--|--|
--help | Print a brief help message and exits
--of | Path to output file filename
--user | Username
--pass | Password
--hashtype | Hash type. "md5based" - md5 based hash calculation (modified md5, default), "plain" - password hash as-is (plain text) 
--host | DVR/NVR hostname or ip address
--port | DVR/NVR CMS port
--bt | Search begin time, ISO 8601 format (example: 2018-01-29T17:00:00Z)
--et | Search end time, ISO 8601 format
--ch | Channel
--co | Config option. Sections:  AVEnc, Ability, Alarm, BrowserLanguage, Detect, General, Guide, NetWork, Profuce, Record, Storage, System, fVideo, Uart. Subsection could be requested in as object property, example: Uart.Comm
--dl | Download found files
--c | DVR/NVR command: OPTimeSetting, Users, Groups, WorkState, StorageInfo, SystemInfo, OEMInfo, LogExport, ConfigExport, OPStorageManagerClear, OPStorageManagerRO, OPStorageManagerRW, OPFileQuery, OPLogQuery, ConfigGet, AuthorityList, OPTimeQuery, Ability, User, DeleteUser, ChannelTitle
--username | Name of user to add/edit/delete
--newuserpass | Password for new user
--newusergroup | Group of new user. Must exists, permissions (authorities) will be copied from that group
--if | Input file for setting data
--sd | Set data
--d | Debug output
--jp | JSON pretty print
--fd | Dsconnect immediately after sending the command without getting a reply


## Tested hardware

[DVR HJCCTV HJ-H4808BW](http://www.aliexpress.com/item/Hybird-NVR-8chs-H-264DVR-8chs-onvif-2-3-Economical-DVR-8ch-Video-4-AUDIO-AND/1918734952.html) (XiongMai, Hi3520, MBD6304T)

[IP Camera PBFZ TCV-UTH200](http://www.aliexpress.com/item/Free-shipping-2014-NEW-IP-camera-CCTV-2-0MP-HD-1080P-IP-Network-Security-CCTV-Waterproof/1958962188.html) (XiongMai, Hi3518, 50H20L_S39)

[SANNCE 4CH 1080P PoE NVR](https://www.amazon.co.uk/gp/product/B017DCMB22) (XiongMai, NBD6904T-F)

[3516EV200+SC4239P Module](https://www.aliexpress.com/item/4000062673175.html) (XiongMai, IVG85HF30PS-S)

[Sony IMX307+3516EV200 Module](https://www.aliexpress.com/item/32961415959.html) (XiongMai, IVG-85HF20PYA-S)

## Author and License

Copyright (C) 2014-2020 667bdrm

Dual licensed under GNU General Public License 2 and commercial license

Commercial license available by request

## References

vendor: http://www.xiongmaitech.com

vendor specifications: http://wiki.xm030.com:81/

vendor sdk: https://github.com/mondwan/cpp-surveillance-cli

Additional protocol reference : https://github.com/charmyin/IPCTimeLapse

password hashing: https://github.com/tothi/pwn-hisilicon-dvr
