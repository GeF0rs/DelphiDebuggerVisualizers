unit DDV.Visualizers.Registrations;

interface

procedure Register;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  ToolsAPI,
  DDV.Visualizer.Color,
  DDV.Visualizer.Guid,
  DDV.Visualizer.TObject,
  DDV.Visualizer.TComponent,
  DDV.Visualizer.TFDDataSet.External;

var
  StdVisualizers: TList<IOTADebuggerVisualizer>;

procedure RegisterDebuggerVisualizer(const aService: IOTADebuggerServices; const aVisualizer: IOTADebuggerVisualizer);
begin
  aService.RegisterDebugVisualizer(aVisualizer);
  StdVisualizers.Add(aVisualizer);
end;

procedure Register;
var
  DebuggerServices: IOTADebuggerServices;
begin
  if Supports(BorlandIDEServices, IOTADebuggerServices, DebuggerServices) then
  begin
    // The IDE will go through the list of registered visualizers and use the fist match that is found.
    // Meaning if Type A inherits from B then A should be registered before B
    RegisterDebuggerVisualizer(DebuggerServices, TColorVisualizer.Create);
    RegisterDebuggerVisualizer(DebuggerServices, TGuidVisualizer.Create);

    RegisterDebuggerVisualizer(DebuggerServices, TFDDataSetExtVisualizer.Create);
    RegisterDebuggerVisualizer(DebuggerServices, TComponentVisualizer.Create);
    // Keep the TObject last - so inherited classes will be used before
    RegisterDebuggerVisualizer(DebuggerServices, TObjectVisualizer.Create);
  end;
end;

procedure RemoveVisualizer;
var
  DebuggerServices: IOTADebuggerServices;
  vVisualizer: IOTADebuggerVisualizer;
begin
  if Supports(BorlandIDEServices, IOTADebuggerServices, DebuggerServices) then
  begin
    for vVisualizer in StdVisualizers do
      DebuggerServices.UnregisterDebugVisualizer(vVisualizer);
    StdVisualizers.Clear;
  end;
end;

initialization

StdVisualizers := TList<IOTADebuggerVisualizer>.Create;

finalization

RemoveVisualizer;
StdVisualizers.Free;

end.
