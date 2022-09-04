unit pascal_compiler;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, MainForm;

var
  SourceCode : String;
  ErrorName : String;

  procedure CompileFile(FileName : String);

implementation

  procedure CompileFile(FileName : String);
  var
    f : TextFile;
    buffer,s : string;
  begin
    With Form1 do
    begin
      TreeView1.Items.Clear;
      TreeView1.FullExpand;
      MenuFileSave.Enabled := False;
    end;
    AssignFile(F,FileName);
    try
      reset(f);
      buffer := '';
      while not eof(f) do
      begin
        readln(f,s);
        buffer := buffer+s+#10;
      end;
      close(f);
      ErrorName := '';
    except
      on e:Exception do
        ErrorName := E.Message;
    end;
    SourceCode := Buffer;
    Form1.TreeView1.Items.Add(Nil,SourceCode);
  end; // CompileFile

end.

