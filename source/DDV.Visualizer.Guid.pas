unit DDV.Visualizer.Guid;

interface

uses
  DDV.Visualizers.Common;

const
  GuidVisualizerTypes: array [0 .. 1] of TCommonDebuggerVisualizerType = (
    (TypeName: 'TGUID'), (TypeName: 'System::TGUID'));

resourcestring
  GuidVisualizerName = 'TGUID visualizer';
  GuidVisualizerDescription = 'Visualizes a GUID to a human readable format';

type
  TGuidVisualizer = class(TCommonDebuggerEvaluationVisualizer)
  protected
    function GetSupportedTypesList: TArray<TCommonDebuggerVisualizerType>; override;
    function GetReplacementValue(const Expression, TypeName, EvalResult: string): string; override;
    function GetEvaluationCall(const Expression, TypeName, EvalResult: string): string; override;

    function GetVisualizerName: string; override;
    function GetVisualizerDescription: string; override;
  end;

implementation

uses
  System.SysUtils, Winapi.Windows;

{ TGuidVisualizer }

function TGuidVisualizer.GetEvaluationCall(const Expression, TypeName, EvalResult: string): string;
begin
  Result := Format('GUIDToString(%s)', [Expression]);
end;

function TGuidVisualizer.GetReplacementValue(const Expression, TypeName, EvalResult: string): string;
var
  vEvaluatedData: string;
begin
  vEvaluatedData := inherited GetReplacementValue(Expression, TypeName, EvalResult);
  vEvaluatedData := AnsiDequotedStr(vEvaluatedData, '''');
  Result := Format('%s' + sLineBreak + '%s', [vEvaluatedData, EvalResult]);
end;

function TGuidVisualizer.GetSupportedTypesList: TArray<TCommonDebuggerVisualizerType>;
begin
  Result := ConvertStaticToDynamicArray(GuidVisualizerTypes);
end;

function TGuidVisualizer.GetVisualizerDescription: String;
begin
  Result := GuidVisualizerDescription;
end;

function TGuidVisualizer.GetVisualizerName: String;
begin
  Result := GuidVisualizerName;
end;

end.
