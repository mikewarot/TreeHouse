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
    MenuExit: TMenuItem;
    MenuDelete: TMenuItem;
    MenuItem3: TMenuItem;
    MenuAbout: TMenuItem;
    MenuFileOpen: TMenuItem;
    MenuFileSave: TMenuItem;
    MenuAdd: TMenuItem;
    MenuAddChild: TMenuItem;
    MenuSaveAs: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    Separator1: TMenuItem;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuAddChildClick(Sender: TObject);
    procedure MenuAddClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuFileOpenClick(Sender: TObject);
    procedure MenuFileSaveClick(Sender: TObject);
    procedure MenuDeleteClick(Sender: TObject);
    procedure MenuSaveAsClick(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
  private

  public

  end;

var
  Form1: TForm1;
  FileName : String;

implementation

{$R *.lfm}

uses
  mystrings;
Const
  crlf = #13#10;

procedure ShowNode(const current: TTreeNode);
var
  ProgramString : String;
  CurrentString : String;
  NodeType : String;

  Procedure ViewNode(CurrentNode : TTreeNode; Indent : String);
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
                   ProgramString := ProgramString + Indent + 'Program '+CurrentString+';'+CrLf;
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child,Indent);
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       ViewNode(Child,Indent);
                       Child := CurrentNode.GetNextChild(Child);
                     end;
                   end; // if HasChildren
                   ProgramString := ProgramString + '.';
                 end; // @Entry
      '@Block' : Begin
                   ProgramString := ProgramString + Indent + 'Begin'+CrLf;
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child,Indent+'  ');
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       ProgramString := ProgramString + ';'+CrLf;
                       ViewNode(Child,Indent+'  ');
                       Child := CurrentNode.GetNextChild(Child);
                     end;
                   end; // if HasChildren
                   ProgramString := ProgramString + CrLf + 'End';
                 end; // @Block
      '@Print' : Begin
                   ProgramString := ProgramString + Indent + 'Write(';
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child,'');
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       ProgramString := ProgramString + ',';
                       ViewNode(Child,'');
                       Child := CurrentNode.GetNextChild(Child);
                     end;
                   end; // if HasChildren
                   ProgramString := ProgramString + ')';
                 end; // @Print
      '@Expression' : Begin
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child,'');
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       ProgramString := ProgramString + ' ';
                       ViewNode(Child,'');
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
  Form1.Memo1.Clear;
  ProgramString := '';
  ViewNode(Current,'');
  Form1.Memo1.Append(ProgramString);
end;


{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  current : TTreeNode;
begin
  Current := TreeView1.Selected;
  If Current = Nil then
    ShowMessage('No Node Selected!')
  else
    ShowNode(current);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FileName := '';
end;

procedure TForm1.MenuAddChildClick(Sender: TObject);
var
  current : TTreeNode;
begin
  Current := TreeView1.Selected;
  Current := TreeView1.Items.AddChildFirst(Current,'');
  TreeView1.Selected := Current;
  TreeView1.MakeSelectionVisible;
  TreeView1.Selected.EditText;
end;

procedure TForm1.MenuAddClick(Sender: TObject);
var
  current : TTreeNode;
begin
  Current := TreeView1.Selected;
  Current := TreeView1.Items.InsertBehind(Current,'');
  TreeView1.Selected := Current;
  TreeView1.MakeSelectionVisible;
  TreeView1.Selected.EditText;
end;

procedure TForm1.MenuExitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.MenuAboutClick(Sender: TObject);
begin
  ShowMessage('Treehouse is a program for building habitable spaces in trees');
end;

procedure TForm1.MenuFileOpenClick(Sender: TObject);
begin
  If OpenDialog1.Execute then
  begin
    FileName := OpenDialog1.FileName;
    MenuFileSave.Enabled := True;
    TreeView1.LoadFromFile(OpenDialog1.FileName);
    TreeView1.FullExpand;
  end;
end;

procedure TForm1.MenuFileSaveClick(Sender: TObject);
begin
  If FileName <> '' then
    TreeView1.SaveToFile(FileName)
  else
    ShowMessage('No FileName Set, can not save!');
end;

procedure TForm1.MenuDeleteClick(Sender: TObject);
var
  current : TTreeNode;
begin
  Current := TreeView1.Selected;
  TreeView1.Selected := Current.GetPrevSibling;
  Current.Delete;
end;

procedure TForm1.MenuSaveAsClick(Sender: TObject);
begin
  If SaveDialog1.Execute then
  begin
    FileName := SaveDialog1.FileName;
    TreeView1.SaveToFile(SaveDialog1.FileName);
    MenuFileSave.Enabled := True;
  end;
end;

procedure TForm1.TreeView1Change(Sender: TObject; Node: TTreeNode);
var
  current : TTreeNode;
begin
  Current := TreeView1.Selected;
  If Current <> Nil then
    ShowNode(current);
end;

end.

