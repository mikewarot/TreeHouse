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
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuAbout: TMenuItem;
    MenuFileOpen: TMenuItem;
    MenuFileSave: TMenuItem;
    MenuAdd: TMenuItem;
    MenuAddChild: TMenuItem;
    MenuSaveAs: TMenuItem;
    OpenDialog1: TOpenDialog;
    ImportDialog: TOpenDialog;
    PopupMenu1: TPopupMenu;
    SaveDialog1: TSaveDialog;
    Separator1: TMenuItem;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure MenuAddChildClick(Sender: TObject);
    procedure MenuAddClick(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure MenuAboutClick(Sender: TObject);
    procedure MenuFileOpenClick(Sender: TObject);
    procedure MenuFileSaveClick(Sender: TObject);
    procedure MenuDeleteClick(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
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
  mystrings,pascal_compiler;
Const
  crlf = #13#10;
var
  ProgramString : String;
  SourceCount : integer;
  SourceP     : Array[1..100000] of TTreeNode;

  Procedure AddCode(CodeString : String; Current : TTreeNode);
  begin
    ProgramString := ProgramString + CodeString;
    While SourceCount < Length(programstring) do
    begin
      inc(sourceCount);
      SourceP[SourceCount] := Current;
    end;
  end;

procedure ShowNode(const current: TTreeNode);
var
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
                   AddCode(Indent + 'Program '+CurrentString+';'+CrLf,CurrentNode);
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
                   AddCode('.',CurrentNode);
                 end; // @Entry
      '@Block' : Begin
                   AddCode(Indent + 'Begin'+CrLf,CurrentNode);
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child,Indent+'  ');
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       AddCode(';'+CrLf,CurrentNode);
                       ViewNode(Child,Indent+'  ');
                       Child := CurrentNode.GetNextChild(Child);
                     end;
                   end; // if HasChildren
                   AddCode(CrLf + 'End',CurrentNode);
                 end; // @Block
      '@Print' : Begin
                   AddCode(Indent + 'Write(',CurrentNode);
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child,'');
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       AddCode(',',CurrentNode);
                       ViewNode(Child,'');
                       Child := CurrentNode.GetNextChild(Child);
                     end;
                   end; // if HasChildren
                   AddCode(')',CurrentNode);
                 end; // @Print
      '@Expression' : Begin
                   If CurrentNode.HasChildren then
                   begin
                     Child := CurrentNode.GetFirstChild;
                     ViewNode(Child,'');
                     Child := CurrentNode.GetNextChild(Child);
                     While Child <> nil do
                     begin
                       AddCode(' ',CurrentNode);
                       ViewNode(Child,'');
                       Child := CurrentNode.GetNextChild(Child);
                     end;
                   end; // if HasChildren
                 end; // @Expression

      '@StringConstant' : AddCode('''' + CurrentString + '''',CurrentNode);
    else
      AddCode(NodeType+' : '+CurrentString,CurrentNode);
    end; // Case NodeType
  end; // ViewNode

begin
  Form1.Memo1.Clear;
  ProgramString := '';
  SourceCount := 0;
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

procedure TForm1.Memo1Click(Sender: TObject);
var
  Current : TTreeNode;
begin
  If Memo1.SelStart > 0 then
  begin
    Current := SourceP[Memo1.SelStart];
    TreeView1.Select(Current,[]);
    TreeView1.Repaint;
  end;
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

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  If ImportDialog.Execute then
  begin
    FileName := ImportDialog.FileName;
    CompileFile(FileName);
  end;
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
  If TreeView1.Focused then
  begin
    Current := TreeView1.Selected;
    If Current <> Nil then
      ShowNode(current);
  end;
end;

end.

