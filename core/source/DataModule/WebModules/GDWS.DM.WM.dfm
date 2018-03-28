object GDWSDMWM: TGDWSDMWM
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  Actions = <>
  BeforeDispatch = WebModuleBeforeDispatch
  Height = 366
  Width = 463
  object ServerFunctionInvoker: TPageProducer
    HTMLFile = 'Templates\ServerFunctionInvoker.html'
    OnHTMLTag = ServerFunctionInvokerHTMLTag
    Left = 56
    Top = 184
  end
  object ReverseString: TPageProducer
    HTMLFile = 'templates\ReverseString.html'
    OnHTMLTag = ServerFunctionInvokerHTMLTag
    Left = 168
    Top = 184
  end
  object WebFileDispatcher: TWebFileDispatcher
    WebFileExtensions = <
      item
        MimeType = 'text/css'
        Extensions = 'css'
      end
      item
        MimeType = 'text/javascript'
        Extensions = 'js'
      end
      item
        MimeType = 'image/x-png'
        Extensions = 'png'
      end
      item
        MimeType = 'text/html'
        Extensions = 'htm;html'
      end
      item
        MimeType = 'image/jpeg'
        Extensions = 'jpg;jpeg;jpe'
      end
      item
        MimeType = 'image/gif'
        Extensions = 'gif'
      end>
    BeforeDispatch = WebFileDispatcherBeforeDispatch
    WebDirectories = <
      item
        DirectoryAction = dirInclude
        DirectoryMask = '*'
      end
      item
        DirectoryAction = dirExclude
        DirectoryMask = '\templates\*'
      end>
    RootDirectory = '.'
    Left = 64
    Top = 128
  end
  object DSProxyGenerator: TDSProxyGenerator
    ExcludeClasses = 'DSMetadata'
    MetaDataProvider = DSServerMetaDataProvider
    Writer = 'Java Script REST'
    Left = 48
    Top = 248
  end
  object DSServerMetaDataProvider: TDSServerMetaDataProvider
    Server = GDWSDMSC.DSServer
    Left = 208
    Top = 248
  end
  object DSProxyDispatcher: TDSProxyDispatcher
    DSProxyGenerator = DSProxyGenerator
    Left = 264
    Top = 128
  end
  object DSRESTWebDispatcher: TDSRESTWebDispatcher
    DSContext = 'api/'
    RESTContext = 'gdws/'
    Server = GDWSDMSC.DSServer
    AuthenticationManager = GDWSDMSC.DSAuthenticationManager
    SessionLifetime = Request
    Left = 176
    Top = 56
  end
end
