unit DDV.Visualizer.TComponent;

interface

uses
  DDV.Visualizers.Common;

const
  ComponentVisualizerTypes: array [0 .. 0] of TCommonDebuggerVisualizerType = (
    (TypeName: 'TComponent'; AllDescendants: True));

resourcestring
  ComponentVisualizerName = 'TComponent visualizer';
  ComponentVisualizerDescription = 'Visualizes a TComponent to give some more information than all attributes';

type
  TComponentVisualizer = class(TCommonDebuggerEvaluationVisualizer)
  protected
    function GetSupportedTypesList: TArray<TCommonDebuggerVisualizerType>; override;
    function GetEvaluationCall(const Expression, TypeName, EvalResult: string): string; override;
    function GetReplacementValue(const Expression, TypeName, EvalResult: string): string; override;

    function GetVisualizerName: string; override;
    function GetVisualizerDescription: string; override;
  end;

implementation

uses
  System.SysUtils;

{ TComponentVisualizer }

function TComponentVisualizer.GetEvaluationCall(const Expression, TypeName, EvalResult: string): string;
begin
  Result := Expression + '.ToString';
end;

function TComponentVisualizer.GetReplacementValue(const Expression, TypeName, EvalResult: string): string;
var
  vEvaluatedData: string;
  vName: string;
begin
  if (EvalResult = 'nil') then
    Exit('nil');

  vEvaluatedData := inherited GetReplacementValue(Expression, TypeName, EvalResult);
  vName := GetEvaluator.ExecuteEvaluation(Expression + '.Name', '<Unnamed>');

  Result := Format('%s.%s' + sLineBreak + '%s', [vEvaluatedData.DeQuotedString, vName.DeQuotedString, EvalResult]);
end;

function TComponentVisualizer.GetSupportedTypesList: TArray<TCommonDebuggerVisualizerType>;
begin
  Result := ConvertStaticToDynamicArray(ComponentVisualizerTypes);
end;

function TComponentVisualizer.GetVisualizerDescription: String;
begin
  Result := ComponentVisualizerDescription;
end;

function TComponentVisualizer.GetVisualizerName: String;
begin
  Result := ComponentVisualizerName;
end;

end.
