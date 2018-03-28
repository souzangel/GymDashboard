object GDWSDMConnection: TGDWSDMConnection
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 269
  Width = 360
  object FDConn: TFDConnection
    Params.Strings = (
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    FetchOptions.AssignedValues = [evAutoClose]
    FetchOptions.AutoClose = False
    FormatOptions.AssignedValues = [fvMapRules, fvFmtDisplayDate]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <
      item
        PrecMax = 18
        PrecMin = 2
        ScaleMax = 10
        ScaleMin = 2
        SourceDataType = dtDouble
        TargetDataType = dtBCD
      end
      item
        PrecMax = 18
        PrecMin = 2
        ScaleMax = 10
        ScaleMin = 2
        SourceDataType = dtExtended
        TargetDataType = dtBCD
      end
      item
        PrecMax = 18
        PrecMin = 2
        ScaleMax = 10
        ScaleMin = 2
        SourceDataType = dtCurrency
        TargetDataType = dtBCD
      end
      item
        PrecMax = 18
        PrecMin = 2
        ScaleMax = 10
        ScaleMin = 2
        SourceDataType = dtFmtBCD
        TargetDataType = dtBCD
      end>
    FormatOptions.FmtDisplayDate = 'DD-MM-YYYY'
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvCountUpdatedRecords, uvFetchGeneratorsPoint, uvCheckRequired, uvCheckReadOnly]
    UpdateOptions.UpdateChangedFields = False
    UpdateOptions.CountUpdatedRecords = False
    UpdateOptions.CheckRequired = False
    UpdateOptions.CheckReadOnly = False
    TxOptions.Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    LoginPrompt = False
    Transaction = FDTrans
    UpdateTransaction = FDTrans
    Left = 56
    Top = 32
  end
  object FDTrans: TFDTransaction
    Options.Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Connection = FDConn
    Left = 104
    Top = 32
  end
  object FDWCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    ScreenCursor = gcrAppWait
    Left = 176
    Top = 32
  end
  object FDLinkMySQL: TFDPhysMySQLDriverLink
    Left = 176
    Top = 88
  end
  object FDLinkFB: TFDPhysFBDriverLink
    Left = 200
    Top = 152
  end
end
