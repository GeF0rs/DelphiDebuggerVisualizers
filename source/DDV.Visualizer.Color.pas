unit DDV.Visualizer.Color;

interface

uses
  DDV.Visualizers.Common;

const
  ColorVisualizerTypes: array [0 .. 1] of TCommonDebuggerVisualizerType = (
    (TypeName: 'TColor'), (TypeName: 'Graphics::TColor'));

resourcestring
  ColorVisualizerName = 'TColor visualizer';
  ColorVisualizerDescription = 'Visualizes a TColor to a HTML and Pascal format';

type
  TColorVisualizer = class(TCommonDebuggerVisualizerValueReplacer)
  protected
    function GetSupportedTypesList: TArray<TCommonDebuggerVisualizerType>; override;
    function GetReplacementValue(const Expression, TypeName, EvalResult: string): string; override;

    function GetVisualizerName: string; override;
    function GetVisualizerDescription: string; override;
  end;

implementation

uses
  System.SysUtils,
  Vcl.Graphics,
  Windows;

{ TColorVisualizer }

function ColorToHex(Color: integer) : string;
begin
  Result := '#' +
    IntToHex(GetRValue(ColorToRGB(Color)), 2) +
    IntToHex(GetGValue(ColorToRGB(Color)), 2) +
    IntToHex(GetBValue(ColorToRGB(Color)), 2);
end;

function TColorVisualizer.GetReplacementValue(const Expression, TypeName, EvalResult: string): string;
var
  hexHtmlColor, strColor: string;
  Color: integer;
begin
  Result := EvalResult;
  if not TryStrToInt(EvalResult, Color) then exit;

  hexhtmlColor := ColorToHex(Color);
  strColor := ColorToString(Color);

  Result := Format('%s' + sLineBreak + '%s' + sLineBreak + '%s', [hexhtmlColor, strColor, EvalResult]);
end;

function TColorVisualizer.GetSupportedTypesList: TArray<TCommonDebuggerVisualizerType>;
begin
  Result := ConvertStaticToDynamicArray(ColorVisualizerTypes);
end;

function TColorVisualizer.GetVisualizerDescription: String;
begin
  Result := ColorVisualizerDescription;
end;

function TColorVisualizer.GetVisualizerName: String;
begin
  Result := ColorVisualizerName;
end;

end.
