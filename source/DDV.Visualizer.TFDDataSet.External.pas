unit DDV.Visualizer.TFDDataSet.External;

interface

uses
  DDV.Visualizers.Common,
  DDV.Visualizers.CommonForm,
  DDV.Visualizers.CommonFrame,
  DDV.Visualizers.Evaluator,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Clipbrd,
  Dialogs, ComCtrls, ToolsAPI, Vcl.StdCtrls, Vcl.ActnList, Vcl.ImgList, Data.DB, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageBin, System.IOUtils, Vcl.ExtCtrls, Math, System.Actions,
  Vcl.StdActns;

const
  FDDataSetVisualizerTypes: array [0 .. 0] of TCommonDebuggerVisualizerType = (//
    (TypeName: 'TFDDataSet'; AllDescendants: True));

resourcestring
  FDDataSetVisualizerName = 'TFDDataSet external visualizer';
  FDDataSetVisualizerDescription = 'Debugger visualizer which displays a TFDDataSet within a DBGrid';
  FDDataSetVisualizerMenuText = 'Show Records';

type
  TDsParams = record
    ParamName: string;
    ParamVal: string;
  end;

  ITFDDataSetExtVisualizerEvaluator = interface(IExternalVisualizerEvaluator)
  ['{E37FA2C9-546C-490F-A8C9-03BD5C64AE58}']
    function GetSQLText: string;
    function TryFillDataFile(const AFileName: string): boolean;
    function GetRecordCount: string;
    function GetRecNo: string;
    function GetState: string;
    function GetParams: TArray<TDsParams>;
    procedure OpenDataSet();
    procedure Log(const AMsg: string);
  end;

  TFDDataSetViewerFrame = class(TCommonVisualizerFrame)
    memSQL: TMemo;
    dbGrid: TDBGrid;
    PageControl: TPageControl;
    TabRecords: TTabSheet;
    TabSQL: TTabSheet;
    gridDataSource: TDataSource;
    gridMemTable: TFDMemTable;
    Panel1: TPanel;
    lbRecordCount: TLabel;
    lbRecNo: TLabel;
    btnOpenDataSet: TButton;
    btnSaveAs: TButton;
    lbState: TLabel;
    SaveDialog1: TSaveDialog;
    StrGridParams: TStringGrid;
    Splitter1: TSplitter;
    ActionList1: TActionList;
    EditSelectAll1: TEditSelectAll;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditUndo1: TEditUndo;
    EditDelete1: TEditDelete;
    procedure PageControlChange(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure btnOpenDataSetClick(Sender: TObject);
  private
    FEvaluator: ITFDDataSetExtVisualizerEvaluator; 
    
    procedure SetSQLText(const ASqlText: string);
    procedure LoadRecords();
    procedure SetParamsList(const AParams: TArray<TDsParams>);
    procedure FitGrid(Grid: TDBGrid);
  public
    procedure SetEvaluator(Evaluator: IExternalVisualizerEvaluator); override;
    procedure Show(); override;
  end;

  TFDDataSetVisualizerForm = class(TCommonVisualizerForm)
  public
    function GetFrameClass: TCustomFrameClass; override;
    //function GetCaption: string; override;
  end;

  TFDDataSetExtVisualizer = class(TCommonDebuggerEvaluationVisualizerExt, ITFDDataSetExtVisualizerEvaluator)
  protected
    function GetSupportedTypesList: TArray<TCommonDebuggerVisualizerType>; override;
    function Show(const Expression, TypeName, EvalResult: string;
      SuggestedLeft, SuggestedTop: Integer): IOTADebuggerVisualizerExternalViewerUpdater; override;

    function GetMenuText: string; override;
    function GetVisualizerName: string; override;
    function GetVisualizerDescription: string; override;

    function GetFormClass(): TCommonVisualizerFormClass; override;
    function GetExternalEvaluator(): IExternalVisualizerEvaluator; override;
    
    procedure Evaluate(const Expression, TypeName, EvalResult: string); override;
  private
    { ITFDDataSetExtVisualizerEvaluator }
    function GetSQLText: string;
    function TryFillDataFile(const AFileName: string): boolean;
    function GetRecordCount: string;
    function GetRecNo: string;
    function GetState: string;
    function GetParams: TArray<TDsParams>;
    procedure OpenDataSet();
    procedure Log(const AMsg: string);
  end;

implementation

{$R *.dfm}

{ TFDDataSetVisualizerForm }

function TFDDataSetVisualizerForm.GetFrameClass: TCustomFrameClass;
begin
  Result := TFDDataSetViewerFrame;
end;

{ TFDDataSetExtVisualizer }

procedure TFDDataSetExtVisualizer.Evaluate(const Expression, TypeName, EvalResult: string);
begin
    
end;

function TFDDataSetExtVisualizer.GetExternalEvaluator: IExternalVisualizerEvaluator;
begin
  Result := self;  
end;

function TFDDataSetExtVisualizer.GetFormClass: TCommonVisualizerFormClass;
begin
  Result := TFDDataSetVisualizerForm;
end;

function TFDDataSetExtVisualizer.GetMenuText: string;
begin
  Result := FDDataSetVisualizerMenuText;
end;

function TFDDataSetExtVisualizer.GetParams: TArray<TDsParams>;
var
  ParamCount: integer;
  I: Integer;
begin
  ParamCount := StrToIntDef(GetEvaluator.ExecuteEvaluation(FExpression + '.ParamCount'), 0);
  SetLength(Result, ParamCount);
  for I := 0 to ParamCount - 1 do
  begin
    Result[i].ParamName := GetEvaluator.ExecuteEvaluation(format('%s.Params[%s].Name', [FExpression, i.ToString]), '');
    Result[i].ParamVal := GetEvaluator.ExecuteEvaluation(format('%s.Params[%s].Value', [FExpression, i.ToString]), '');
  end;
end;

function TFDDataSetExtVisualizer.GetSupportedTypesList: TArray<TCommonDebuggerVisualizerType>;
begin
  Result := ConvertStaticToDynamicArray(FDDataSetVisualizerTypes);
end;

function TFDDataSetExtVisualizer.GetVisualizerDescription: string;
begin
  Result := FDDataSetVisualizerDescription;
end;

function TFDDataSetExtVisualizer.GetVisualizerName: string;
begin
  Result := FDDataSetVisualizerName;
end;

function TFDDataSetExtVisualizer.Show(const Expression, TypeName, EvalResult: string; SuggestedLeft,
  SuggestedTop: Integer): IOTADebuggerVisualizerExternalViewerUpdater;
begin
  inherited;
end;

{ ITFDDataSetExtVisualizerEvaluator }

function TFDDataSetExtVisualizer.GetSQLText(): string;
begin
  Result := GetEvaluator.ExecuteEvaluation(FExpression + '.SQL.Text');
end;

function TFDDataSetExtVisualizer.GetState: string;
begin
  Result := GetEvaluator.ExecuteEvaluation(FExpression + '.State');
end;

function TFDDataSetExtVisualizer.GetRecNo: string;
begin
  Result := GetEvaluator.ExecuteEvaluation(FExpression + '.RecNo');
end;

function TFDDataSetExtVisualizer.GetRecordCount: string;
begin
  Result := GetEvaluator.ExecuteEvaluation(FExpression + '.RecordCount');
end;

procedure TFDDataSetExtVisualizer.OpenDataSet;
begin
  GetEvaluator.ExecuteEvaluation(FExpression + '.Open');
end;

procedure TFDDataSetExtVisualizer.Log(const AMsg: string);
begin
  GetEvaluator.LogString(AMsg, litDefault);
end;

function TFDDataSetExtVisualizer.TryFillDataFile(const AFileName: string): boolean;
var
  ResultExp, DsState: string;
begin
  Result := true;
  DsState := GetState();
  
  if DsState = 'dsBrowse' then
  begin
    if not GetEvaluator.TryExecuteEvaluation(Format('%s.SaveToFile(%s)', [FExpression, QuotedStr(AFileName)]), ResultExp) then
    begin
      Result := false;
      Log('[TFDDataSetExtVisualizer] Не удалось экспортировать данные в файл:' + sLineBreak + ResultExp);
    end;  
  end
  else
  begin
    Result := false;
    Log('[TFDDataSetExtVisualizer] Данные не получены DataSet.State = ' + DsState);  
  end;
end;

procedure TFDDataSetViewerFrame.FitGrid(Grid: TDBGrid);
const
  C_Add = 3;
var
  ds: TDataSet;
  bm: TBookmark;
  i: Integer;
  WidthData, WidthField: Integer;
  a: Array of Integer;
begin
  ds := Grid.DataSource.DataSet;
  if not Assigned(ds) then exit;
  if not ds.Active then exit;

  ds.DisableControls;
  bm := ds.GetBookmark;
  try
    ds.First;
    SetLength(a, Grid.Columns.Count);

    for I := 0 to Grid.Columns.Count - 1 do
    begin
      if Assigned(Grid.Columns[i].Field) then
      begin
        WidthField := Grid.Canvas.TextWidth(Grid.Columns[i].Field.FieldName);

        ds.First;
        while not ds.Eof do
        begin
          WidthData := Grid.Canvas.TextWidth(ds.FieldByName(Grid.Columns[i].Field.FieldName).AsString);

          if a[i] < WidthData  then
             a[i] := WidthData;

          ds.Next;
        end;

        if a[i] < WidthField  then
          a[i] := WidthField;
      end;
    end;

    for I := 0 to Grid.Columns.Count - 1 do
      Grid.Columns[i].Width := a[i] + C_Add;

    ds.GotoBookmark(bm);
  finally
    ds.FreeBookmark(bm);
    ds.EnableControls;
  end;
end;

procedure AutoSizeCol(Grid: TStringGrid; Column: integer);
var
  i, W, WMax: integer;
begin
  WMax := 0;
  for i := 0 to Grid.RowCount - 1 do
  begin
    W := Grid.Canvas.TextWidth(Grid.Cells[Column, i]);
    if W > WMax then
      WMax := W;
  end;
  Grid.ColWidths[Column] := WMax + 10;
end;

procedure TFDDataSetViewerFrame.PageControlChange(Sender: TObject);
begin
  inherited;
  if PageControl.ActivePage = TabSQL then
  begin
    SetSQLText(FEvaluator.GetSQLText);
    SetParamsList(FEvaluator.GetParams);
    AutoSizeCol(StrGridParams, 0);
    AutoSizeCol(StrGridParams, 1);
  end
  else
    if PageControl.ActivePage = TabRecords then
    begin
      LoadRecords();
      FitGrid(dbGrid);
    end;
end;

procedure TFDDataSetViewerFrame.SetParamsList(const AParams: TArray<TDsParams>);
var
  I: Integer;
begin
  StrGridParams.FixedCols := 0;
  StrGridParams.FixedRows := 1;
  StrGridParams.ColCount := 2;
  StrGridParams.Cells[0, 0] := 'Param';
  StrGridParams.Cells[1, 0] := 'Val';

  if Length(AParams) = 0 then
    StrGridParams.RowCount := 2
  else
    StrGridParams.RowCount := Length(AParams) + 1;

  for i := 0 to Length(AParams) - 1 do
  begin
    StrGridParams.Cells[0, i + 1] := AParams[i].ParamName.DeQuotedString;
    StrGridParams.Cells[1, i + 1] := AParams[i].ParamVal;
  end;
end;

procedure TFDDataSetViewerFrame.SetSQLText(const ASqlText: string);
var
  formattedSqlText: string;
begin
  formattedSqlText := ASqlText;
  
  formattedSqlText := StringReplace(formattedSqlText, '#$D#$A', sLineBreak, [rfReplaceAll]);
  while formattedSqlText.EndsWith(sLineBreak) do
  begin
    formattedSqlText := Copy(formattedSqlText, 1, Length(formattedSqlText) - Length(sLineBreak));
  end;
  formattedSqlText := formattedSqlText.DeQuotedString;

  memSQL.Lines.Text := formattedSqlText;
end;

procedure TFDDataSetViewerFrame.Show;
var
  DsState: string;
begin
  PageControl.OnChange(PageControl);
  lbRecordCount.Caption := Format('RecordCount = %s', [FEvaluator.GetRecordCount]); 
  lbRecNo.Caption := Format('RecNo = %s', [FEvaluator.GetRecNo]);
  DsState := FEvaluator.GetState;  
  lbState.Caption := Format('State = %s', [DsState]);
  btnOpenDataSet.Enabled := DsState <> 'dsBrowse';
end;

procedure TFDDataSetViewerFrame.btnOpenDataSetClick(Sender: TObject);
begin
  inherited;
  FEvaluator.OpenDataSet();
  Show();
end;

procedure TFDDataSetViewerFrame.btnSaveAsClick(Sender: TObject);
begin
  inherited;
  if not SaveDialog1.Execute(self.Handle) then
  begin
    Exit;
  end;

  gridMemTable.SaveToFile(SaveDialog1.FileName);
end;

procedure TFDDataSetViewerFrame.LoadRecords();
var
  TempFileName: string;
begin
  try
    TempFileName := TPath.GetTempFileName();
    try
      if FEvaluator.TryFillDataFile(TempFileName) then
        gridMemTable.LoadFromFile(TempFileName);
    finally
      TFile.Delete(TempFileName);
    end;
  except
    FEvaluator.Log('[TFDDataSetExtVisualizer] Не удалось создать временный файл!');
    Exit;
  end;
end;

procedure TFDDataSetViewerFrame.SetEvaluator(Evaluator: IExternalVisualizerEvaluator);
begin
  inherited;
  FEvaluator := Evaluator as ITFDDataSetExtVisualizerEvaluator;
end;

end.
