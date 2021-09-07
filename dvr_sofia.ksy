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
        doc: >
           0x8000 on some video response frames
      - id: session_id
        type: u4
      - id: sequence
        type: u4
      - id: total_packet
        type: u1
        doc: >
          channel in stream data headers
      - id: cur_packet
        type: u1
        doc: >
          end_flag in stream data headers, 0x01 for EOF
      - id: message_id
        type: u2
        enum: commands
      - id: size
        type: u4
      - id: data
        size: size
        type:
          switch-on: message_id
          cases:
            'commands::talk_cu_pu_data': stream_packet
            'commands::talk_pu_cu_data': stream_packet
            'commands::monitor_data': stream_packet
            '_': json_packet

  json_packet:
    seq:
      - id: raw_data
        size: _parent.size
        type: str
        encoding: ASCII

  audio_packet:
    seq:
      - id: magic
        size: 3
      - id: type
        type: u1
        enum: frame_types
      - id: audio_data
        type: audio_data

  audio_data:
    seq:
      - id: audio_codec
        type: u1
        enum: audio_codecs
      - id: sampling_rate
        type: u1
        enum: sampling_rates
      - id: size
        type: u2
      - id: audio_data
        size: size

  frame_raw_data:
    seq:
      - id: data
        size-eos: true

  timestamp:
    seq:
      - id: seconds
        type: b6le
      - id: minutes
        type: b6le
      - id: hour
        type: b5le
      - id: day
        type: b5le
      - id: month
        type: b4le
      - id: year
        type: b6le
    instances:
      year_human:
        value: (year + 2000)

  video_iframe_data:
    seq:
      - id: type
        type: u1
        enum: video_codecs
      - id: frame_rate
        type: u1
      - id: width
        type: u1
      - id: height
        type: u1
      - id: timestamp
        size: 4
        type: timestamp
      - id: total_length
        type: u4
        doc: includes next frames data too
      - id: data
        size-eos: true

  video_pframe_data:
    seq:
      - id: size
        type: u4
      - id: data
        size: size

  stream_frame:
    seq:
      - id: frame_type
        type: u1
        enum: frame_types
      - id: frame_data
        type:
          switch-on: frame_type
          cases:
            'frame_types::video_iframe': video_iframe_data
            'frame_types::video_pframe': video_pframe_data
            'frame_types::audio': audio_data
            _: frame_raw_data

  stream_packet:
    seq:
      - id: firstbytes
        size: 3
      - id: nextbytes
        size: _parent.size - 3
        if: firstbytes != [0, 0, 1]
      - id: frame_data
        size: _parent.size - 3
        type: stream_frame
        if: firstbytes == [0, 0, 1]


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
    1010: encryption_info_req
    1011: encryption_info_rsp
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
    1446: opcalendar1_req
    1447: opcalendar1_rsp
    1448: unknown_search1_req
    1449: unknown_search1_rsp
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
    1507: net_alarm_rsp
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
    1610: optupdata1_req
    1611: optupdata1_rsp
    1612: optupdata2_req
    1613: optupdata2_rsp
    1636: unknown_search_req
    1637: unknown_search_rsp
    1642: opnetfilecontral_req
    1643: opnetfilecontral_rsp
    1644: unknown_custom_export_req
    2000: version_list_req
    2001: version_list_rsp
    2012: opconsumerprocmd_req
    2013: opconsumerprocmd_rsp
    2016: opversionrep_req
    2017: opversionrep_rsp
    2026: opscalendar_req
    2027: opscalendar_rsp
    2038: opbreviarypic_req
    2039: opbreviarypic_rsp
    2040: optelnetcontrol_req
    2041: optelnetcontrol_rsp
    2062: unknown_2062_req
    2063: unknown_2062_rsp
    2122: unknown_2122_raw_data
    2210: opggetpgsstate_req
    2211: oppggetpgsstate_rsp
    2212: oppggetimg_req
    2213: oppggetimg_rsp
    2214: opsetcustomdata_req
    2215: opsetcustomdata_rsp
    2216: opgetcustomdata_req
    2217: opgetcustomdata_rsp
    2218: opgetactivationcode_req
    2219: opgetactivationcode_rsp
    2220: opctrldvrinfo_req
    2221: opctrldvrinfo_rsp
    3502: opfile_req
    3503: opfile_rsp

  protocols:
    0xff: protocol_sofia

  directions:
    0x00: client_request
    0x01: server_response

  frame_types:
    0xfc: video_iframe
    0xfd: video_pframe
    0xf9: car_info
    0xfa: audio
    0xfe: image

  audio_codecs:
    0x0e: g711a

  sampling_rates:
    0x02: sampling_8k

  video_codecs:
    0x01: mpeg4
    0x02: h264

  image_formats:
    0x00: jpg

  info_types:
    0x01: car_info
