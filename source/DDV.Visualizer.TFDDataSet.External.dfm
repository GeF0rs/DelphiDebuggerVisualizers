inherited FDDataSetViewerFrame: TFDDataSetViewerFrame
  Width = 763
  Height = 491
  ParentFont = False
  ExplicitWidth = 763
  ExplicitHeight = 491
  object PageControl: TPageControl
    Left = 0
    Top = 41
    Width = 763
    Height = 450
    ActivePage = TabRecords
    Align = alClient
    TabOrder = 0
    OnChange = PageControlChange
    object TabRecords: TTabSheet
      Caption = 'Records'
      object dbGrid: TDBGrid
        Left = 0
        Top = 0
        Width = 755
        Height = 422
        Align = alClient
        DataSource = gridDataSource
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
      end
    end
    object TabSQL: TTabSheet
      Caption = 'SQL text'
      ImageIndex = 1
      object Splitter1: TSplitter
        Left = 559
        Top = 0
        Height = 422
        Align = alRight
        ExplicitLeft = 433
        ExplicitHeight = 239
      end
      object memSQL: TMemo
        Left = 0
        Top = 0
        Width = 559
        Height = 422
        Align = alClient
        Lines.Strings = (
          'memSQL')
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object StrGridParams: TStringGrid
        Left = 562
        Top = 0
        Width = 193
        Height = 422
        Align = alRight
        ColCount = 2
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
        TabOrder = 1
        ColWidths = (
          96
          64)
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 763
    Height = 41
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object lbRecordCount: TLabel
      Left = 7
      Top = 22
      Width = 88
      Height = 14
      Caption = 'RecordCount = '
    end
    object lbRecNo: TLabel
      Left = 7
      Top = 5
      Width = 48
      Height = 14
      Caption = 'RecNo ='
    end
    object lbState: TLabel
      Left = 303
      Top = 5
      Width = 47
      Height = 14
      Caption = 'State = '
    end
    object btnOpenDataSet: TButton
      Left = 501
      Top = 5
      Width = 77
      Height = 25
      Caption = 'Open'
      TabOrder = 0
      OnClick = btnOpenDataSetClick
    end
    object btnSaveAs: TButton
      Left = 584
      Top = 5
      Width = 77
      Height = 25
      Caption = 'Save As'
      TabOrder = 1
      OnClick = btnSaveAsClick
    end
  end
  object gridDataSource: TDataSource
    DataSet = gridMemTable
    Left = 48
    Top = 152
  end
  object gridMemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate, uvCountUpdatedRecords]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.CountUpdatedRecords = False
    Left = 132
    Top = 152
  end
  object SaveDialog1: TSaveDialog
    Left = 228
    Top = 153
  end
  object ActionList1: TActionList
    Left = 228
    Top = 249
    object EditSelectAll1: TEditSelectAll
      Category = 'Edit'
      Caption = 'Select &All'
      Hint = 'Select All|Selects the entire document'
      ShortCut = 16449
    end
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 0
      ShortCut = 16472
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 2
      ShortCut = 16470
    end
    object EditUndo1: TEditUndo
      Category = 'Edit'
      Caption = '&Undo'
      Hint = 'Undo|Reverts the last action'
      ImageIndex = 3
      ShortCut = 16474
    end
    object EditDelete1: TEditDelete
      Category = 'Edit'
      Caption = '&Delete'
      Hint = 'Delete|Erases the selection'
      ImageIndex = 5
      ShortCut = 46
    end
  end
end
