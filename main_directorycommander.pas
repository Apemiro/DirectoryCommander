//{$define insert}

unit main_directorycommander;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, StdCtrls, ShellCtrls, Menus, LazUTF8, Windows,
  {$ifndef insert}
  Apiglio_Useful, AufScript_Frame,
  {$endif}
  DC_Operation, frame_fileselection;

const
  version_number='0.0.6-wp';

type

  { TForm_DirectoryCommander }

  TForm_DirectoryCommander = class(TForm)
    CheckGroup_OptTreeView: TCheckGroup;
    FileSelectionFrame1: TFileSelectionFrame;
    Frame_AufScript1: TFrame_AufScript;
    MenuItem_div01: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem_openDir: TMenuItem;
    MenuItem_Flatten: TMenuItem;
    MenuItem_RegexpRen: TMenuItem;
    MenuItem_DecRank: TMenuItem;
    MenuItem_SimpleRen: TMenuItem;
    MenuItem_HexRank: TMenuItem;
    MenuItem_rename: TMenuItem;
    MenuItem_Numberization: TMenuItem;
    MenuItem_Flatten_To_Parent: TMenuItem;
    MenuItem_Hierarchy: TMenuItem;
    MenuItem_Hierarchization: TMenuItem;
    MenuItem_Cd: TMenuItem;
    MenuItem_refresh: TMenuItem;
    Panel_TreeView: TPanel;
    PopupMenu_TreeView: TPopupMenu;
    Splitter_CodeH: TSplitter;
    Splitter_FileTree_H: TSplitter;
    Splitter_Vert: TSplitter;
    StatusBar: TStatusBar;
    TreeView_Directory: TShellTreeView;
    procedure CheckGroup_OptTreeViewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Frame_AufScript1Resize(Sender: TObject);
    procedure ListBoxMouseEnter(Sender: TObject);
    procedure ListBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MenuItem_CdClick(Sender: TObject);
    procedure MenuItem_FlattenClick(Sender: TObject);
    procedure MenuItem_Flatten_To_ParentClick(Sender: TObject);
    procedure MenuItem_HierarchyClick(Sender: TObject);
    procedure MenuItem_openDirClick(Sender: TObject);
    procedure MenuItem_SelWin_OpenClick(Sender: TObject);
    procedure TreeView_DirectoryChange(Sender: TObject; Node: TTreeNode);
    procedure TreeView_DirectoryMouseEnter(Sender: TObject);
    procedure TreeView_DirectoryMouseLeave(Sender: TObject);
    procedure TreeView_DirectoryMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreeView_DirectorySelectionChanged(Sender: TObject);
  private

  public
    procedure ShowManual(str:string);
  end;

var
  Form_DirectoryCommander: TForm_DirectoryCommander;
  //RegExpr:TRegExpr;

implementation

{$R *.lfm}

procedure p_about(Sender:TObject);
var AufScpt:TAufScript;
begin
  AufScpt := Sender as TAufScript;
  AufSCpt.writeln('- Apiglio Directory Commander');
  AufSCpt.writeln('- version '+version_number);
end;
procedure p_changedir(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    addr:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if AAuf.ArgsCount<2 then
  begin
    AufSCpt.writeln('当前操作目录：'+wincptoutf8(DCOP.RunEnvironment));
    exit;
  end;
  if not AAuf.TryArgToString(1,addr) then exit;

  DCOP.RunEnvironment:={utf8towincp}(addr);
  AufSCpt.writeln('当前操作目录已修改为：'+{wincptoutf8}(DCOP.RunEnvironment));
end;
procedure p_intodir(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    folder:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(2) then exit;
  if not AAuf.TryArgToString(1,folder) then exit;
  if DCOP.EnvIntoDir(folder) then AufSCpt.writeln('当前操作目录已修改为：'+{wincptoutf8}(DCOP.RunEnvironment))
  else AufSCpt.writeln('未找到给定的子目录。');
end;
procedure p_backdir(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    addr:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if DCOP.EnvBackDir then AufSCpt.writeln('当前操作目录已修改为：'+{wincptoutf8}(DCOP.RunEnvironment))
  else AufSCpt.writeln('当前目录不能继续后退。');
end;
procedure p_moveto(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    ori,dest:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(3) then exit;
  if not AAuf.TryArgToString(1,ori) then exit;
  if not AAuf.TryArgToString(2,dest) then exit;
  FileMoveTo(utf8towincp(ori),utf8towincp(dest));
end;
procedure p_copyto(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    ori,dest:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(3) then exit;
  if not AAuf.TryArgToString(1,ori) then exit;
  if not AAuf.TryArgToString(2,dest) then exit;
  FileCopyTo(utf8towincp(ori),utf8towincp(dest));
end;
procedure p_renameinto(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    ori,dest:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(3) then exit;
  if not AAuf.TryArgToString(1,ori) then exit;
  if not AAuf.TryArgToString(2,dest) then exit;
  FileReName(utf8towincp(ori),utf8towincp(dest));
end;


procedure p_flatten(Sender:TObject);
var AufScpt:TAufScript;
begin
  AufScpt := Sender as TAufScript;
  FlattenDirAllExt('');
  AufScpt.writeln('执行完成。');
end;
procedure p_hierarchy(Sender:TObject);
var AufScpt:TAufScript;
begin
  AufScpt := Sender as TAufScript;
  HierarchyDir('');
  AufScpt.writeln('执行完成。');
end;
procedure p_regexprdir(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    oldp,newp:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(3) then exit;
  if not AAuf.TryArgToString(1,oldp) then exit;
  if not AAuf.TryArgToString(2,newp) then exit;
  RegExprNameFolder('',{utf8towincp}(oldp),{utf8towincp}(newp));
  AufScpt.writeln('执行完成。');
end;
procedure p_regexprsel(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    oldp,newp:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(3) then exit;
  if not AAuf.TryArgToString(1,oldp) then exit;
  if not AAuf.TryArgToString(2,newp) then exit;
  RegExprNameSelect('',{utf8towincp}(oldp),{utf8towincp}(newp));
  AufScpt.writeln('执行完成。');
end;
procedure p_renamedir(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    oldp,newp:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(3) then exit;
  if not AAuf.TryArgToString(1,oldp) then exit;
  if not AAuf.TryArgToString(2,newp) then exit;
  ChangeNameFolder('',{utf8towincp}(oldp),{utf8towincp}(newp));
  AufScpt.writeln('执行完成。');
end;
procedure p_renamesel(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    addr,oldp,newp:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(3) then exit;
  if not AAuf.TryArgToString(1,oldp) then exit;
  if not AAuf.TryArgToString(2,newp) then exit;
  ChangeNameSelect('',{utf8towincp}(oldp),{utf8towincp}(newp));
  AufScpt.writeln('执行完成。');
end;
procedure p_insertLdir(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    oldp:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(2) then exit;
  if not AAuf.TryArgToString(1,oldp) then exit;
  InsertNameLFolder('',{utf8towincp}(oldp));
  AufScpt.writeln('执行完成。');
end;
procedure p_insertLsel(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    oldp:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(2) then exit;
  if not AAuf.TryArgToString(1,oldp) then exit;
  InsertNameLSelect('',{utf8towincp}(oldp));
  AufScpt.writeln('执行完成。');
end;
procedure p_insertRdir(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    oldp:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(2) then exit;
  if not AAuf.TryArgToString(1,oldp) then exit;
  InsertNameRFolder('',{utf8towincp}(oldp));
  AufScpt.writeln('执行完成。');
end;
procedure p_insertRsel(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    oldp:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(2) then exit;
  if not AAuf.TryArgToString(1,oldp) then exit;
  InsertNameRSelect('',{utf8towincp}(oldp));
  AufScpt.writeln('执行完成。');
end;
procedure p_clipnamedir(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    ori,st,en:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(3) then exit;
  if not AAuf.TryArgToString(1,st) then exit;
  if not AAuf.TryArgToString(2,en) then exit;
  ClipNameFolder('',{utf8towincp}(st),{utf8towincp}(en));
  AufScpt.writeln('执行完成。');
end;
procedure p_clipnamesel(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    ori,st,en:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(3) then exit;
  if not AAuf.TryArgToString(1,st) then exit;
  if not AAuf.TryArgToString(2,en) then exit;
  ClipNameSelect('',{utf8towincp}(st),{utf8towincp}(en));
  AufScpt.writeln('执行完成。');
end;


procedure p_reg_select_folder(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    regexpr:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(2) then exit;
  if not AAuf.TryArgToString(1,regexpr) then exit;
  RegExpSelectFolder('',{utf8towincp}(regexpr));
  AufScpt.writeln('执行完成，共找到'+IntToStr(Form_DirectoryCommander.FileSelectionFrame1.ListBox.Count)+'个符合条件的文件。');
end;

procedure p_reg_select_dir(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    regexpr:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(2) then exit;
  if not AAuf.TryArgToString(1,regexpr) then exit;
  RegExpSelectDir('',{utf8towincp}(regexpr));
  AufScpt.writeln('执行完成，共找到'+IntToStr(Form_DirectoryCommander.FileSelectionFrame1.ListBox.Count)+'个符合条件的文件。');
end;


procedure p_test(Sender:TObject);
var AAuf:TAuf;
    AufScpt:TAufScript;
    addr,adr,fil,ext:string;
begin
  AufScpt := Sender as TAufScript;
  AAuf    := AufScpt.Auf as TAuf;
  if not AAuf.CheckArgs(4) then exit;

  if not AAuf.TryArgToString(1,addr) then exit;
  if not AAuf.TryArgToString(2,adr) then exit;
  if not AAuf.TryArgToString(3,fil) then exit;
  AufScpt.writeln(ClipStr(adr,fil,addr));

  {
  pathToAFX(addr,adr,fil,ext);
  addr:='.';
  if adr<>'' then addr:=addr+'\'+adr+'\';
  addr:=addr+fil+RunParameters[0];
  if ext<>'' then addr:=addr+'.'+ext;
  AufScpt.writeln(adr+'||'+fil+'||'+ext);
  AufScpt.writeln(addr);
  }

  //Form_DirectoryCommander.FileSelectionFrame1.Add(addr);
  //Form_DirectoryCommander.FileSelectionFrame1.sort;
  //Form_DirectoryCommander.ListBox_Selection.AddItem(addr,nil);
  //Form_DirectoryCommander.ListBox_Selection.Sort;
end;




{ TForm_DirectoryCommander }

procedure TForm_DirectoryCommander.ShowManual(str:string);
begin
  Self.StatusBar.Panels[0].Text:=str;
end;

procedure TForm_DirectoryCommander.FormCreate(Sender: TObject);
var frm:TFrame_AufScript;
begin
  frm:=Self.Frame_AufScript1;
  frm.AufGenerator;
  frm.onHelper:=@Self.ShowManual;
  frm.Auf.Script.add_func('about',@p_about,'','显示版本信息');
  frm.Auf.Script.add_func('cd,change_dir',@p_changedir,'path','显示或设置当前操作目录');
  frm.Auf.Script.add_func('id,into_dir',@p_intodir,'path','从当前操作目录选择一个文件夹作为新的操作目录');
  frm.Auf.Script.add_func('bd,backto_dir',@p_backdir,'','从当前操作目录返回到上一层目录作为新的操作目录');
  frm.Auf.Script.add_func('moveto',@p_moveto,'oripath,destpath','移动文件');
  frm.Auf.Script.add_func('copyto',@p_copyto,'oripath,destpath','复制文件');
  frm.Auf.Script.add_func('renameinto',@p_renameinto,'oripath,destpath','重命名文件');


  frm.Auf.Script.add_func('flat,flatten',@p_flatten,'','扁平化');
  frm.Auf.Script.add_func('hier,hierarchy',@p_hierarchy,'','层次化');

  frm.Auf.Script.add_func('ren,rename',@p_renamedir,'oldPattern,newPattern','批量替换文件名');
  frm.Auf.Script.add_func('rens,rename_s',@p_renamesel,'oldPattern,newPattern','批量替换文件名(选区)');
  frm.Auf.Script.add_func('clp,clip',@p_clipnamedir,'starting,ending','批量截除部分文件名');
  frm.Auf.Script.add_func('clps,clip_s',@p_clipnamesel,'starting,ending','批量截除部分文件名(选区)');
  frm.Auf.Script.add_func('insl,prev',@p_insertLdir,'content','批量前续文件名');
  frm.Auf.Script.add_func('insls,prev_s',@p_insertLsel,'content','批量前续文件名(选区)');
  frm.Auf.Script.add_func('insr,succ',@p_insertRdir,'content','批量后续文件名');
  frm.Auf.Script.add_func('insrs,succ_s',@p_insertRsel,'content','批量后续文件名(选区)');

  frm.Auf.Script.add_func('reg,regren',@p_regexprdir,'expr,repl','批量使用正则表达式替换文件名');
  frm.Auf.Script.add_func('regs,regren_s',@p_regexprsel,'expr,repl','批量使用正则表达式替换替换文件名(选区)');

  frm.Auf.Script.add_func('sel,select',@p_reg_select_folder,'regexpr','根据正则表达式选择文件');
  frm.Auf.Script.add_func('selx,sel_tree',@p_reg_select_dir,'regexpr','根据正则表达式递归选择文件');



  frm.Auf.Script.add_func('test',@p_test,'','测试');


  frm.HighLighterReNew;
  GlobalExpressionList.TryAddExp('sel',narg('"','','"'));
  GlobalExpressionList.TryAddExp('rsel',narg('"','','"'));


  Self.CheckGroup_OptTreeView.Checked[0]:=true;
  Self.CheckGroup_OptTreeView.Checked[1]:=true;
  Self.CheckGroup_OptTreeView.Checked[2]:=true;

  //RegExpr:=TRegExpr.Create;

end;

procedure TForm_DirectoryCommander.CheckGroup_OptTreeViewClick(Sender: TObject);
var cg:TCheckGroup;
    tmp:TObjectTypes;
begin
  cg:=Sender as TCheckGroup;
  tmp:=[];
  if cg.Checked[0] then tmp:=tmp + [otFolders];
  if cg.Checked[1] then tmp:=tmp + [otHidden];
  if cg.Checked[2] then tmp:=tmp + [otNonFolders];
  Self.TreeView_Directory.ObjectTypes:=tmp;
end;

procedure TForm_DirectoryCommander.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  //RegExpr.Free;
end;

procedure TForm_DirectoryCommander.Frame_AufScript1Resize(Sender: TObject);
var frm:TFrame_AufScript;
begin
  frm:=Sender as TFrame_AufScript;
  frm.Width:=Self.Splitter_Vert.Left;
  frm.Height:=Self.Splitter_CodeH.Top;
  frm.FrameResize(nil);

end;

procedure TForm_DirectoryCommander.ListBoxMouseEnter(Sender: TObject);
begin
  ShowManual('文件选择列表。通过select或sel指令加正则表达式筛选，作为rens、clps、insls等指令的有效修改部分。');
end;

procedure TForm_DirectoryCommander.ListBoxMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var tmpLB:TListBox;
    index:Integer;
begin
  tmpLB:=Sender as TListBox;
  index:=tmpLB.GetIndexAtXY(X,Y);
  if index<0 then exit;
  tmpLB.Selected[index]:=true;
  if (Shift=[]) and (Button=mbRight) then FileSelectionFrame1.PopupMenu_SelWin.PopUp;
end;

procedure TForm_DirectoryCommander.MenuItem_CdClick(Sender: TObject);
begin
  Self.Frame_AufScript1.Auf.Script.command('cd "'+(Self.TreeView_Directory.GetPathFromNode(Self.TreeView_Directory.Selected))+'"');
end;

procedure TForm_DirectoryCommander.MenuItem_FlattenClick(Sender: TObject);
var ntmp:TTreeNode;
    str:TStringList;
    env:string;
begin
  ntmp:=Self.TreeView_Directory.Selected;
  if ntmp=nil then exit;
  if ntmp.Parent=nil then exit;

  env:=Self.TreeView_Directory.GetPathFromNode(ntmp);

  str:=TStringList.Create;
  str.add('cd "'+env+'"');
  str.add('flatten ""');
  Self.Frame_AufScript1.Auf.Script.command(str);
  str.Free;
  ntmp.Collapse(false);
  Application.ProcessMessages;
  ntmp.Expand(false);
end;

procedure TForm_DirectoryCommander.MenuItem_Flatten_To_ParentClick(Sender: TObject);
var ntmp:TTreeNode;
    str:TStringList;
    env,tar:string;
    len:integer;
begin
  ntmp:=Self.TreeView_Directory.Selected;
  if ntmp=nil then exit;
  if ntmp.Parent=nil then exit;

  env:=Self.TreeView_Directory.GetPathFromNode(ntmp.Parent);
  tar:=Self.TreeView_Directory.GetPathFromNode(ntmp);
  tar:=Environmentalization(tar,env);
  while tar<>'' do begin
    len:=length(tar);
    if tar[len]='\' then delete(tar,len,1)
    else break;
  end;

  str:=TStringList.Create;
  str.add('cd "'+env+'"');
  str.add('flatten "'+tar+'"');
  Self.Frame_AufScript1.Auf.Script.command(str);
  str.Free;
  ntmp.Parent.Collapse(false);
  Application.ProcessMessages;
  ntmp.Parent.Expand(false);
end;

procedure TForm_DirectoryCommander.MenuItem_HierarchyClick(Sender: TObject);
var ntmp:TTreeNode;
    str:TStringList;
    env:string;
begin
  ntmp:=Self.TreeView_Directory.Selected;
  if ntmp=nil then exit;
  if ntmp.Parent=nil then exit;

  env:=Self.TreeView_Directory.GetPathFromNode(ntmp);

  str:=TStringList.Create;
  str.add('cd "'+env+'"');
  str.add('hierarchy ""');
  Self.Frame_AufScript1.Auf.Script.command(str);
  str.Free;
  ntmp.Collapse(false);
  Application.ProcessMessages;
  ntmp.Expand(false);
end;

procedure TForm_DirectoryCommander.MenuItem_openDirClick(Sender: TObject);
begin
  ShellExecute(0,'open','explorer',pchar('"'+Utf8toWinCP(Self.TreeView_Directory.GetPathFromNode(Self.TreeView_Directory.Selected))+'"'),nil,SW_NORMAL);
end;

procedure TForm_DirectoryCommander.MenuItem_SelWin_OpenClick(Sender: TObject);
begin
  with Self.FileSelectionFrame1.ListBox do begin
    if ItemIndex>=0 then
      ShellExecute(0,'open',pchar('"'+DCOP.RunEnvironment+Utf8toWinCP(Items[ItemIndex])+'"'),'','',SW_NORMAL);
  end;
end;


procedure TForm_DirectoryCommander.TreeView_DirectoryChange(Sender: TObject;
  Node: TTreeNode);
begin

end;

procedure TForm_DirectoryCommander.TreeView_DirectoryMouseEnter(Sender: TObject
  );
begin
  Self.ShowManual('目录浏览器。按右键选择项目并执行目录操作。');
end;

procedure TForm_DirectoryCommander.TreeView_DirectoryMouseLeave(Sender: TObject
  );
begin
  Self.ShowManual('');
end;

procedure TForm_DirectoryCommander.TreeView_DirectoryMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var tv:TShellTreeView;
begin
  tv:=Sender as TShellTreeView;
  if (Shift=[]) and (Button=mbRight) then PopupMenu_TreeView.PopUp;
end;

procedure TForm_DirectoryCommander.TreeView_DirectorySelectionChanged(
  Sender: TObject);
var dtmp:string;
begin
  dtmp:=utf8towincp(Self.TreeView_Directory.GetPathFromNode(Self.TreeView_Directory.Selected));
  GlobalExpressionList.TryAddExp('sel',narg('"',wincptoutf8(dtmp),'"'));
  GlobalExpressionList.TryAddExp('rsel',narg('"',wincptoutf8(Environmentalization(dtmp,DCOP.RunEnvironment)),'"'));
  //utf8towincp
end;

end.

