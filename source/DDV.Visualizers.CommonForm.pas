unit DDV.Visualizers.CommonForm;

interface

uses
  DDV.Visualizers.CommonFrame,
  ToolsAPI,
  Vcl.Forms, Vcl.StdCtrls, Vcl.ActnList, Vcl.ImgList, Vcl.Menus, Vcl.ComCtrls, System.IniFiles, DesignIntf, dialogs;

type
  TCommonVisualizerFormClass = class of TCommonVisualizerForm;

  TCommonVisualizerForm = class(TInterfacedObject, INTACustomDockableForm)
  private
    FMyForm: TCustomForm;
    FMyFrame: TCommonVisualizerFrame;
    FCaption: string;
  public
    constructor Create(const ACaption: string; SuggestedLeft, SuggestedTop: Integer); virtual;
    { INTACustomDockableForm }
    function GetCaption: string; virtual;
    function GetFrameClass: TCustomFrameClass; virtual;
    procedure FrameCreated(AFrame: TCustomFrame); virtual;
    function GetIdentifier: string; virtual;
    function GetMenuActionList: TCustomActionList; virtual;
    function GetMenuImageList: TCustomImageList; virtual;
    procedure CustomizePopupMenu(PopupMenu: TPopupMenu); virtual;
    function GetToolbarActionList: TCustomActionList; virtual;
    function GetToolbarImageList: TCustomImageList; virtual;
    procedure CustomizeToolBar(ToolBar: TToolBar); virtual;
    procedure LoadWindowState(Desktop: TCustomIniFile; const Section: string); virtual;
    procedure SaveWindowState(Desktop: TCustomIniFile; const Section: string; IsProject: Boolean); virtual;
    function GetEditState: TEditState; virtual;
    function EditAction(Action: TEditAction): Boolean; virtual;

    procedure SetForm(Form: TCustomForm);
    function GetFrame: TCommonVisualizerFrame;
  end;

implementation

{ TCommonVisualizerForm }

constructor TCommonVisualizerForm.Create(const ACaption: string; SuggestedLeft, SuggestedTop: Integer);
var
  Form: TCustomForm;
begin
  inherited Create;
  FCaption := ACaption;
  Form := (BorlandIDEServices as INTAServices).CreateDockableForm(self);
  Form.Left := SuggestedLeft;
  Form.Top := SuggestedTop;

  SetForm(Form);

  if Assigned(FMyFrame) then
    FMyFrame.SetForm(FMyForm);
end;

procedure TCommonVisualizerForm.SetForm(Form: TCustomForm);
begin
  FMyForm := Form;
end;

procedure TCommonVisualizerForm.CustomizePopupMenu(PopupMenu: TPopupMenu);
begin
  // no toolbar
end;

procedure TCommonVisualizerForm.CustomizeToolBar(ToolBar: TToolBar);
begin
  // no toolbar
end;

function TCommonVisualizerForm.EditAction(Action: TEditAction): Boolean;
begin
  Result := False;
  if (Action = eaSelectAll) then
  begin
    Result := True;
  end;
end;

procedure TCommonVisualizerForm.FrameCreated(AFrame: TCustomFrame);
begin
  FMyFrame := AFrame as TCommonVisualizerFrame;
end;

function TCommonVisualizerForm.GetCaption: string;
begin
  Result := FCaption;
end;

function TCommonVisualizerForm.GetEditState: TEditState;
begin
  Result := [esCanUndo, esCanRedo, esCanCut, esCanCopy, esCanPaste,
    esCanDelete, esCanEditOle, esCanPrint, esCanCreateTemplate,
    esCanElide];
end;

function TCommonVisualizerForm.GetFrame: TCommonVisualizerFrame;
begin
  Result := FMyFrame;
end;

function TCommonVisualizerForm.GetFrameClass: TCustomFrameClass;
begin
  Result := TCustomFrame;
end;

function TCommonVisualizerForm.GetIdentifier: string;
begin
  Result := ClassName;
end;

function TCommonVisualizerForm.GetMenuActionList: TCustomActionList;
begin
  Result := nil;
end;

function TCommonVisualizerForm.GetMenuImageList: TCustomImageList;
begin
  Result := nil;
end;

function TCommonVisualizerForm.GetToolbarActionList: TCustomActionList;
begin
  Result := nil;
end;

function TCommonVisualizerForm.GetToolbarImageList: TCustomImageList;
begin
  Result := nil;
end;

procedure TCommonVisualizerForm.LoadWindowState(Desktop: TCustomIniFile; const Section: string);
begin
  //no desktop saving
end;

procedure TCommonVisualizerForm.SaveWindowState(Desktop: TCustomIniFile; const Section: string; IsProject: Boolean);
begin
  //no desktop saving
end;

end.
