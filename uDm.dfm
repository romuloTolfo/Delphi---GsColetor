object dm: Tdm
  Height = 272
  Width = 334
  object conn: TFDConnection
    Params.Strings = (
      'OpenMode=ReadWrite'
      'DriverID=SQLite')
    LoginPrompt = False
    AfterConnect = connAfterConnect
    BeforeConnect = connBeforeConnect
    Left = 40
    Top = 48
  end
  object qry: TFDQuery
    Connection = conn
    Left = 120
    Top = 32
  end
end
