unit mainform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, ComCtrls,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

uses
  mystrings;
Const
  crlf = #13#10;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  current : TTreeNode;
  CurrentString : String;
  NodeType : String;
  ProgramString : String;

  Procedure ViewNode(CurrentNode : TTreeNode);
  var
    child : TTreeNode;
  begin
    CurrentString := CurrentNode.Text;
    If (CurrentString <> '') AND (CurrentString[1] = '@') then
      NodeType := GrabString(CurrentString)
    else
      NodeType := '@StringConstant';

    Case NodeType of
      '@Entry' : Begin
                   ProgramString := ProgramString + 'Program '+CurrentString+';'+CrLf;
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child);
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       ViewNode(Child);
                       Child := CurrentNode.GetNextChild(Child);
                     end;
                   end; // if HasChildren
                   ProgramString := ProgramString + '.';
                 end; // @Entry
      '@Block' : Begin
                   ProgramString := ProgramString + 'Begin'+CrLf;
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child);
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       ProgramString := ProgramString + ';'+CrLf;
                       ViewNode(Child);
                       Child := CurrentNode.GetNextChild(Child);
                     end;
                   end; // if HasChildren
                   ProgramString := ProgramString + CrLf + 'End';
                 end; // @Block
      '@Print' : Begin
                   ProgramString := ProgramString + 'Write(';
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child);
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       ProgramString := ProgramString + ',';
                       ViewNode(Child);
                       Child := CurrentNode.GetNextChild(Child);
                     end;
                   end; // if HasChildren
                   ProgramString := ProgramString + ')';
                 end; // @Print
      '@Expression' : Begin
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child);
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       ProgramString := ProgramString + ' ';
                       ViewNode(Child);
                       Child := CurrentNode.GetNextChild(Child);
                     end;
                   end; // if HasChildren
                 end; // @Expression

      '@StringConstant' : ProgramString := ProgramString + '''' + CurrentString + '''';
    else
      ProgramString := ProgramString + NodeType+' : '+CurrentString;
    end; // Case NodeType
  end; // ViewNode

begin
  Current := TreeView1.Selected;
  If Current = Nil then
  begin
    ShowMessage('No Node Selected!');
    Exit;
  end;

  Memo1.Clear;
  ProgramString := '';
  ViewNode(Current);
  Memo1.Append(ProgramString);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  ShowMessage('Treehouse is a program for building habitable spaces in trees');
end;

procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  Button1.Click;
end;

end.

