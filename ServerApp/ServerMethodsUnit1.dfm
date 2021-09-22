object ServerMethods1: TServerMethods1
  OldCreateOrder = False
  Height = 283
  Width = 382
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Protocol=TCPIP'
      'Server=192.168.0.10'
      'User_Name=SYSDBA'
      'Password=nasa030904'
      'Database=D:\Datos\AZTLAN.FDB'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 56
    Top = 40
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    Left = 176
    Top = 40
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 288
    Top = 40
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 176
    Top = 120
  end
  object FDStanStorageJSONLink1: TFDStanStorageJSONLink
    Left = 288
    Top = 120
  end
end
