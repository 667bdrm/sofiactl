# sofiactl

sofiactl is an open source cross-platform tool and sdk to control Sofia powered Hi35xx DVR devices 
using hybrid JSON/binary communication protocol used by origincal CMS software (default port 34567)


## Usage

sofiactl.pl --user username --pass password --host 192.168.0.1 --port 34567 --command command [ --of output_file ] [ -d] [ --help]

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
LogExport | Download logs to the output file specified by --of paramater
ConfigExport | Download configuration files to the output file specified by --of paramater
OPStorageManagerClear | Format storage (remove all recording)
OPStorageManagerRO | Switch partition 0 to read-only mode (not tested!)
OPStorageManagerRW | Switch partition 0 to read/write mode (not tested!)

parameters:

|parameter | description |
|--|--|
--help | Print a brief help message and exits
--of | Path to output file filename
--user | Username
--pass | Password
--hashtype | Hash type. "plain" - password hash as-is (plain text, default), "md5based" - md5 based hash calculation (modified md5)
--host | DVR/NVR hostname or ip address
--port | DVR/NVR CMS port
--c | DVR/NVR command: OPTimeSetting, Users, Groups, WorkState, StorageInfo, SystemInfo, OEMInfo, LogExport, ConfigExport, OPStorageManagerClear
--d | Debug output


## Tested hardware

[DVR HJCCTV HJ-H4808BW](http://www.aliexpress.com/item/Hybird-NVR-8chs-H-264DVR-8chs-onvif-2-3-Economical-DVR-8ch-Video-4-AUDIO-AND/1918734952.html) (XiongMai, Hi3520, MBD6304T)

[IP Camera PBFZ TCV-UTH200](http://www.aliexpress.com/item/Free-shipping-2014-NEW-IP-camera-CCTV-2-0MP-HD-1080P-IP-Network-Security-CCTV-Waterproof/1958962188.html) (XiongMai, Hi3518, 50H20L_S39)

## Author and License

Copyright (C) 2018 667bdrm

Dual licensed under GNU General Public License 2 and commercial license

Commercial license available by request

## References

vendor: http://www.xiongmaitech.com

vendor specifications: http://wiki.xm030.com:81/

vendor sdk: https://github.com/mondwan/cpp-surveillance-cli

Additional protocol reference : https://github.com/charmyin/IPCTimeLapse

password hashing: https://github.com/tothi/pwn-hisilicon-dvr
