unit pascal_compiler;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, MainForm;

var
  SourceCode : String;
  SourceBuffer : String;
  ErrorName : String;

  procedure CompileFile(FileName : String);

implementation

  {--------------------------------------------------------------}
  { Constant Declarations }

  const TAB = ^I;

  {--------------------------------------------------------------}
  { Variable Declarations }

  var Look: char;              { Lookahead Character }

  {--------------------------------------------------------------}
  { Read New Character From Input Stream }

  procedure GetChar;
  begin
     Look := SourceBuffer[1];
     Delete(SourceBuffer,1,1);
  end;

  {--------------------------------------------------------------}
  { Report an Error }

  procedure Error(s: string);
  begin
     Form1.MemoLog.Append('');
     Form1.MemoLog.Append('Error: '+ s + '.');
  end;


  {--------------------------------------------------------------}
  { Report Error and Halt }

  procedure Abort(s: string);
  begin
     Error(s);
     Halt;
  end;


  {--------------------------------------------------------------}
  { Report What Was Expected }

  procedure Expected(s: string);
  begin
     Abort(s + ' Expected');
  end;

  {--------------------------------------------------------------}
  { Match a Specific Input Character }

  procedure Match(x: char);
  begin
     if Look = x then GetChar
     else Expected('''' + x + '''');
  end;


  {--------------------------------------------------------------}
  { Recognize an Alpha Character }

  function IsAlpha(c: char): boolean;
  begin
     IsAlpha := upcase(c) in ['A'..'Z'];
  end;


  {--------------------------------------------------------------}

  { Recognize a Decimal Digit }

  function IsDigit(c: char): boolean;
  begin
     IsDigit := c in ['0'..'9'];
  end;


  {--------------------------------------------------------------}
  { Get an Identifier }

  function GetName: char;
  begin
     if not IsAlpha(Look) then Expected('Name');
     GetName := UpCase(Look);
     GetChar;
  end;


  {--------------------------------------------------------------}
  { Get a Number }

  function GetNum: char;
  begin
     if not IsDigit(Look) then Expected('Integer');
     GetNum := Look;
     GetChar;
  end;


  {--------------------------------------------------------------}
  { Output a String with Tab }

  procedure Emit(s: string);
  begin
     Form1.MemoLog.Append(TAB + s);
  end;

  {--------------------------------------------------------------}
  { Output a String with Tab and CRLF }

  procedure EmitLn(s: string);
  begin
     Emit(s);
  end;

  {--------------------------------------------------------------}
  { Initialize }

  procedure Init;
  begin
     SourceBuffer := SourceCode;
     GetChar;
  end;

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
    Init;
    Form1.TreeView1.Items.Add(Nil,SourceCode);
  end; // CompileFile

end.

