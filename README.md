# sofiactl

sofiactl is an open source cross-platform tool and sdk to control Sofia powered Hi35xx DVR devices 
using hybrid JSON/binary communication protocol used by original CMS software (default port 34567)


## Usage

sofiactl.pl --user username --pass password --host 192.168.0.1 --port 34567 --command command [ --of output_file ] [ -d] [ --help]

## WARNING

ALWAYS BACKUP your configuration with OEM CMS software before using this tool

### Supported commands

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
ConfigImport | Import configuration from previously exported file specified by --if parameter. Needs reboot after.
ConfigExport | Download configuration files to the output file specified by --of parameter
CustomExport | Download additional configuration files (maybe OEM) to the output file specified by --of parameter
OPStorageManagerClear | Format storage (remove all recording)
OPStorageManagerRO | Switch partition 0 to read-only mode (not tested!)
OPStorageManagerRW | Switch partition 0 to read/write mode (not tested!)
OPFileQuery | Search records. Requires --bt, --et, --ch parameters
OPLogQuery | Search logs. Requires --bt, --et parameters
OPPTZControl | Execute PTZ command. Requires parameter --sd CommandName; available PTZ commands: DirectionRight, DirectionLeft, DirectionUp, DirectionDown, ZoomWide, ZoomTile, IrisLarge, IrisSmall, FocusNear, FocusFar. These require also parameter --pn PresetNumber; SetPreset, GotoPreset, ClearPreset
ConfigGet | Get configuration of specified by --co parameter section
AuthorityList | Get authenticated user access permissions
OPTimeQuery | Get device date and time
Ability | Get device features. Features group must be specified by --co parameter (SystemFunction, BlindCapability, Camera, Encode264ability, MultiLanguage, MultiVstd, SupportExtRecord, VencMaxFps)
User | Add new user. Requires --username, --newuserpass and --newusergroup parameters
DeleteUser | Delete existing user
ChannelTitle | Show channel titles
ChannelTitleSet | Set channel titles. Pass comma separated channel titles for all device channels
ConfigSet | Set configuration section (--co) value from set data (--sd) or  input json file (--if). WARNING!!! There are reports about settings break using thius command. Hold on with use this option until resolution confirm.
Reboot | Reboot the device
Talk | Play file specified by --if parameter for the devices supporting talk feature. File must be in headless G711 alaw format. Use snd2pcm.sh for conversion.
Upgrade | Upgrade the device firmware. Firmware file name should be passed with (--if) parameter.
ProbeCommand | !!! DANGER !!! Execute custom protocol command (2 byte message id) specified by --co parameter, response will be decoded from json
ProbeCommandRaw | !!! DANGER !!! Execute custom protocol command (2 byte message id) specified by --co parameter, response will be dumped as-is to file
EncryptionInfo | Get encryption public key and alogrithm info on some devices
OPTelnetControl | Control telnet functionality (not tested!). Options: TelnetEnable, TelnetDisEnable - !!!DANGER!!! there are info that TelnetDisEnable disable telnet forever if succeed.
OPGetCustomData | Get channel custom data
OPSetCustomData | Set channel custom data
OPDefaultConfig | Reset the comma separated configuration sections specified by --co parameter to default settings (Preview,CommPtz,General,Account,NetCommon,Record,Encode,NetServer,Factory,CameraPARAM,Alarm)
OPNetModeSwitch | Switch networking mode for wireless devices to the specified by --co parameter. Options: ToAP - disconnect from wlan, enable configuration access point. ToRoute - disable configuration access point, connect to configured WLAN (!!! WARNING !!! you will lose the control if not configured access point)
OPLogManager | Remove all logs

### Parameters

|parameter | description |
|--|--|
--help | Print a brief help message and exits
--of | Path to output file filename
--user | Username
--pass | Password
--hashtype | Hash type. "md5based" - md5 based hash calculation (modified md5, default), "plain" - password hash as-is (plain text) 
--host | DVR/NVR/IPC hostname or ip address
--port | DVR/NVR/IPC CMS port
--bt | Search begin time, ISO 8601 format (example: 2018-01-29T17:00:00Z)
--et | Search end time, ISO 8601 format
--ch | Channel
--co | Config option. Sections:  AVEnc, AVEnc.VideoWidget, AVEnc.SmartH264V2.[0], Ability, Alarm, BrowserLanguage, Detect, General, General.AutoMaintain, General.General, General.Location, Guide, NetWork, NetWork.DigManagerShow, NetWork.OnlineUpgrade, NetWork.Wifi, Profuce, Record, Status.NatInfo, Storage, System, fVideo, fVideo.GUISet, Uart. Subsection could be requested in as object property, example: Uart.Comm; Ability options: SystemFunction, Camera, Ability options: SystemFunction, BlindCapability, Camera, Encode264ability, MultiLanguage, MultiVstd, SupportExtRecord, VencMaxFps
--dl | Download found files
--c | DVR/NVR/IPC command: OPTimeSetting, OPDefaultConfig, Users, Groups, WorkState, StorageInfo, SystemInfo, OEMInfo, LogExport, ConfigExport, ConfigImport, CustomExport, OPStorageManagerClear, OPStorageManagerRO, OPStorageManagerRW, OPVersionList, OPFileQuery, OPLogQuery, OPNetModeSwitch,  ConfigGet, AuthorityList, OPTimeQuery, Ability, User, DeleteUser, ChannelTitle, ProbeCommand, ProbeCommandRaw
--username | Name of user to add/edit/delete
--newuserpass | Password for new user
--newusergroup | Group of new user. Must exists, permissions (authorities) will be copied from that group
--if | Input file for setting data/to upgrade firmware from
--sd | Set data
--pn | Preset number (PTZ preset commands)
--d | Debug output
--jp | JSON pretty print
--fd | Dsconnect immediately after sending the command without getting a reply


## Tested hardware

[DVR HJCCTV HJ-H4808BW](http://www.aliexpress.com/item/Hybird-NVR-8chs-H-264DVR-8chs-onvif-2-3-Economical-DVR-8ch-Video-4-AUDIO-AND/1918734952.html) (XiongMai, Hi3520, MBD6304T)

[IP Camera PBFZ TCV-UTH200](http://www.aliexpress.com/item/Free-shipping-2014-NEW-IP-camera-CCTV-2-0MP-HD-1080P-IP-Network-Security-CCTV-Waterproof/1958962188.html) (XiongMai, Hi3518, 50H20L_S39)

[SANNCE 4CH 1080P PoE NVR](https://www.amazon.co.uk/gp/product/B017DCMB22) (XiongMai, NBD6904T-F)

[3516EV200+SC4239P Module](https://www.aliexpress.com/item/4000062673175.html) (XiongMai, IVG85HF30PS-S)

[Sony IMX307+3516EV200 Module](https://www.aliexpress.com/item/32961415959.html) (XiongMai, IVG-85HF20PYA-S)

[USAFEQLO USA-IPT-Y307/335](http://www.aliexpress.com/item/4000078604009.html) (XiongMai, NRW4X-5274P-5X, XM530_80X50_8M)

[GS-2AD178WTCMF/GS-2AD21WTC](https://www.aliexpress.com/item/4001221668994.html) (XiongMai, 50X20-WG, XM530_50X20-WG_8M)

[ANBIUX 3MP Outdoor IP Camera](https://www.aliexpress.com/item/4000669887458.html) (XiongMai, R80X30-PQL, XM530_R80X30-PQL_8M)

## Author and License

Copyright (C) 2014-2021 667bdrm

Dual licensed under GNU General Public License 2 and commercial license

Commercial license available by request

## References

vendor: http://www.xiongmaitech.com

vendor specifications: http://wiki.xm030.com:81/

vendor sdk: https://github.com/mondwan/cpp-surveillance-cli

Additional protocol reference : https://github.com/charmyin/IPCTimeLapse

password hashing: https://github.com/tothi/pwn-hisilicon-dvr

python sdk: https://github.com/NeiroNx/python-dvr

xm cam tricks: https://zftlab.org/pages/2018020100.html

more docs: https://github.com/OpenIPC/camerasrnd/tree/master/doc

