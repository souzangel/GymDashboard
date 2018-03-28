object GDWSDMSC: TGDWSDMSC
  OldCreateOrder = False
  Height = 271
  Width = 415
  object DSServer: TDSServer
    AutoStart = False
    ChannelResponseTimeout = 0
    Left = 96
    Top = 17
  end
  object DSAuthenticationManager: TDSAuthenticationManager
    OnUserAuthenticate = DSAuthenticationManagerUserAuthenticate
    OnUserAuthorize = DSAuthenticationManagerUserAuthorize
    Roles = <>
    Left = 312
    Top = 21
  end
  object DSTCPServerTransp: TDSTCPServerTransport
    Server = DSServer
    Filters = <>
    AuthenticationManager = DSAuthenticationManager
    Left = 192
    Top = 16
  end
end
