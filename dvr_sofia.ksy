meta:
  id: sofia
  file-extension: sofia
  endian: le
seq:
  - id: sofia_packet
    type: sofia_packet
    repeat: eos

types:
  sofia_packet:
    seq:
      - id: head_flag
        type: u1
        enum: protocols
      - id: version
        type: u1
        enum: directions
      - id: reserved
        type: u2
      - id: session_id
        type: u4
      - id: sequence
        type: u4
      - id: channel
        type: u1
      - id: end_flag
        type: u1
      - id: message_id
        type: u2
        enum: commands
      - id: size
        type: u4
      - id: data
        size: size
        type: str
        encoding: ASCII
 
enums:
  commands:
    999: login_req1
    1000: login_req2
    1000: login_rsp
    1001: logout_req
    1002: logout_rsp
    1003: forcelogout_req
    1004: forcelogout_rsp
    1006: keepalive_req
    1007: keepalive_rsp  
    1020: sysinfo_req
    1021: sysinfo_rsp  
    1040: config_set
    1041: config_set_rsp
    1042: config_get
    1043: config_get_rsp
    1044: default_config_get
    1045: default_config_get_rsp
    1046: config_channeltile_set
    1047: config_channeltile_set_rsp
    1048: config_channeltile_get
    1049: config_channeltile_get_rsp
    1050: config_channeltile_dot_set
    1051: config_channeltile_dot_set_rsp
    1052: system_debug_req
    1053: system_debug_rsp
    1360: ability_get
    1361: ability_get_rsp
    1400: ptz_req
    1401: ptz_rsp
    1410: monitor_req
    1411: monitor_rsp
    1412: monitor_data
    1413: monitor_claim
    1414: monitor_claim_rsp
    1420: play_req
    1421: play_rsp
    1422: play_data
    1423: play_eof
    1424: play_claim
    1425: play_claim_rsp
    1426: download_data
    1430: talk_req
    1431: talk_rsp
    1432: talk_cu_pu_data
    1433: talk_pu_cu_data
    1434: talk_claim
    1435: talk_claim_rsp
    1440: filesearch_req
    1441: filesearch_rsp
    1442: logsearch_req
    1443: logsearch_rsp
    1444: filesearch_bytime_req
    1445: filesearch_bytime_rsp
    1450: sysmanager_req
    1451: sysmanager_rsp
    1452: timequery_req
    1453: timequery_rsp
    1460: diskmanager_req
    1461: diskmanager_rsp
    1470: fullauthoritylist_get
    1471: fullauthoritylist_get_rsp
    1472: users_get
    1473: users_get_rsp
    1474: groups_get
    1475: groups_get_rsp
    1476: addgroup_req
    1477: addgroup_rsp
    1478: modifygroup_req
    1479: modifygroup_rsp
    1480: deletegroup_req
    1481: deletegroup_rsp
    1482: adduser_req
    1483: adduser_rsp
    1484: modifyuser_req
    1485: modifyuser_rsp
    1486: deleteuser_req
    1487: deleteuser_rsp
    1488: modifypassword_req
    1489: modifypassword_rsp
    1500: guard_req
    1501: guard_rsp
    1502: unguard_req
    1503: unguard_rsp
    1504: alarm_req
    1505: alarm_rsp
    1506: net_alarm_req
    1507: net_alarm_req
    1508: alarmcenter_msg_req
    1520: upgrade_req
    1521: upgrade_rsp
    1522: upgrade_data
    1523: upgrade_data_rsp
    1524: upgrade_progress
    1525: upgrade_info_req
    1526: upgrade_info_rsq
    1530: ipsearch_req
    1531: ipsearch_rsp
    1532: ip_set_req
    1533: ip_set_rsp 
    1540: config_import_req
    1541: config_import_rsp
    1542: config_export_req
    1543: config_export_rsp
    1544: log_export_req
    1545: log_export_rsp
    1550: net_keyboard_req
    1551: net_keyboard_rsp
    1560: net_snap_req
    1561: net_snap_rsp
    1562: set_iframe_req
    1563: set_iframe_rsp
    1570: rs232_read_req
    1571: rs232_read_rsp
    1572: rs232_write_req
    1573: rs232_write_rsp
    1574: rs485_read_req
    1575: rs485_read_rsp
    1576: rs485_write_req
    1577: rs485_write_rsp
    1578: transparent_comm_req
    1579: transparent_comm_rsp
    1580: rs485_transparent_data_req
    1581: rs485_transparent_data_rsp
    1582: rs232_transparent_data_req
    1583: rs232_transparent_data_rsp
    1590: sync_time_req
    1591: sync_time_rsp
    1600: photo_get_req
    1601: photo_get_rsp
    
  protocols:
    0xff: protocol_sofia
    
  directions:
    0x00: client_request
    0x01: server_response