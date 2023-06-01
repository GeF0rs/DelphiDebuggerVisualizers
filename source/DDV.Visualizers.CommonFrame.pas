unit DDV.Visualizers.CommonFrame;

interface

uses
  ToolsAPI,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TAvailableState = (asAvailable, asProcRunning, asOutOfScope, asNotAvailable);

  IExternalVisualizerEvaluator = interface
    ['{B871CD24-F576-4C32-A04E-E9A716D441DE}']
  end;

  TCommonVisualizerFrame = class(TFrame, IOTADebuggerVisualizerExternalViewerUpdater)
  private
    FAvailableState: TAvailableState;
    FClosedProc: TOTAVisualizerClosedProcedure;
    FOwningForm: TCustomForm;
  public
    procedure CloseVisualizer; virtual;
    procedure MarkUnavailable(Reason: TOTAVisualizerUnavailableReason); virtual;
    procedure RefreshVisualizer(const Expression, TypeName, EvalResult: string); virtual;
    procedure SetClosedCallback(ClosedProc: TOTAVisualizerClosedProcedure); virtual;

    procedure SetEvaluator(Evaluator: IExternalVisualizerEvaluator); virtual; abstract;
    procedure SetForm(Form: TCustomForm);
    procedure Show(); virtual;
  end;

implementation

{$R *.dfm}

{ TCommonVisualizerFrame }

procedure TCommonVisualizerFrame.CloseVisualizer;
begin
  if FOwningForm <> nil then
    FOwningForm.Close;
end;

procedure TCommonVisualizerFrame.MarkUnavailable(Reason: TOTAVisualizerUnavailableReason);
begin
  if Reason = ovurProcessRunning then
  begin
    FAvailableState := asProcRunning;
  end
  else
    if Reason = ovurOutOfScope then
      FAvailableState := asOutOfScope;
end;

procedure TCommonVisualizerFrame.RefreshVisualizer(const Expression, TypeName, EvalResult: string);
begin
  FAvailableState := asAvailable;
end;

procedure TCommonVisualizerFrame.SetClosedCallback(ClosedProc: TOTAVisualizerClosedProcedure);
begin
  FClosedProc := ClosedProc;
end;

procedure TCommonVisualizerFrame.SetForm(Form: TCustomForm);
begin
  FOwningForm := Form;
end;

procedure TCommonVisualizerFrame.Show;
begin

end;

end.
