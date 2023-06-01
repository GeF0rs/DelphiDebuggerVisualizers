unit DDV.Visualizer.TObject;

interface

uses
  DDV.Visualizers.Common;

const
  ObjectVisualizerTypes: array [0 .. 0] of TCommonDebuggerVisualizerType = (
    (TypeName: 'TObject'; AllDescendants: True));

resourcestring
  ObjectVisualizerName = 'TObject visualizer';
  ObjectVisualizerDescription = 'Visualizes a TObject to give some more information than ()';

type
  TObjectVisualizer = class(TCommonDebuggerEvaluationVisualizer)
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

{ TObjectVisualizer }

function TObjectVisualizer.GetEvaluationCall(const Expression, TypeName, EvalResult: string): string;
begin
  Result := Expression + '.ToString';
end;

function TObjectVisualizer.GetReplacementValue(const Expression, TypeName, EvalResult: string): string;
var
  vEvaluatedData: string;
begin
  if (EvalResult = 'nil') then
    Exit('nil');

  vEvaluatedData := inherited GetReplacementValue(Expression, TypeName, EvalResult);

  Result := Format('%s' + sLineBreak + '%s', [vEvaluatedData.DeQuotedString, EvalResult]);
end;

function TObjectVisualizer.GetSupportedTypesList: TArray<TCommonDebuggerVisualizerType>;
begin
  Result := ConvertStaticToDynamicArray(ObjectVisualizerTypes);
end;

function TObjectVisualizer.GetVisualizerDescription: String;
begin
  Result := ObjectVisualizerDescription;
end;

function TObjectVisualizer.GetVisualizerName: String;
begin
  Result := ObjectVisualizerName;
end;

end.
