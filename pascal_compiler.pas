unit pascal_compiler;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, MainForm;

var
  SourceCode : String;

  procedure CompileFile(FileName : String);

implementation

  procedure CompileFile(FileName : String);
  begin
    With Form1 do
    begin
      TreeView1.Items.Clear;
      TreeView1.FullExpand;
      MenuFileSave.Enabled := False;
    end;
  end;

end.

