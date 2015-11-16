{===============================================================================
  RzCheckListEditor Unit

  Raize Components - Design Editor Source Unit


  Design Editors        Description
  ------------------------------------------------------------------------------
  TRzCheckListEditor    Adds context menu to edit the list's check states, the
                          list's tab stops, and the list's Align property.


  Modification History
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Added "Manual Tab Stops" and "Automatic Tab Stops" items to context menu
      for TRzCheckList.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Updated form to use custom framing editing controls and HotTrack style
      buttons, radio buttons, and check boxes.
    * Added Clear button.
    * Added Save button.
    * Added Convert to Group checkbox.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzCheckListEditor;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Forms,
  Controls,
  Classes,
  StdCtrls,
  Menus,
  RzChkLst,
  RzDesignEditors,
  {$IFDEF VCL60_OR_HIGHER}
  DesignIntf,
  DesignEditors,
  DesignMenus,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  RzLstBox,
  Dialogs,
  RzButton,
  RzRadChk,
  ExtCtrls,
  RzPanel, RzShellDialogs;

type
  TRzCheckListProperty = class( TPropertyEditor )
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;


  TRzCheckListEditor = class( TRzDefaultEditor )
  protected
    function CheckList: TRzCheckList;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  TRzCheckListEditDlg = class(TForm)
    GrpPreview: TRzGroupBox;
    BtnClose: TRzButton;
    LstPreview: TRzCheckList;
    ChkItemEnabled: TRzCheckBox;
    ChkAllowGrayed: TRzCheckBox;
    BtnAdd: TRzButton;
    BtnEdit: TRzButton;
    BtnDelete: TRzButton;
    BtnMoveUp: TRzButton;
    BtnMoveDown: TRzButton;
    BtnLoad: TRzButton;
    ChkConvertToGroup: TRzCheckBox;
    BtnSave: TRzButton;
    BtnClear: TRzButton;
    DlgOpen: TRzOpenDialog;
    DlgSave: TRzSaveDialog;
    procedure LstPreviewClick(Sender: TObject);
    procedure ChkItemEnabledClick(Sender: TObject);
    procedure ChkAllowGrayedClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure BtnMoveUpClick(Sender: TObject);
    procedure BtnMoveDownClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure ChkConvertToGroupClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
  private
    procedure EnableButtons( Enable: Boolean );
    procedure EnableMoveButtons( Idx: Integer );
  public
    procedure UpdateControls;
  end;


implementation

{$R *.DFM}

uses
  RzCommon,
  SysUtils,
  Buttons,
  RzCheckListItemForm;

resourcestring
  sRzDeleteCheckItem  = 'Delete "%s"?';
  sRzAddCheckItem     = 'Add Item';
  sRzEditCheckItem    = 'Edit Item';


{==================================}
{== TRzCheckListProperty Methods ==}
{==================================}


function TRzCheckListProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paDialog ];
end;


function TRzCheckListProperty.GetValue: string;
begin
  FmtStr( Result, '(%s)', [ GetPropType^.Name ] );
end;


procedure TRzCheckListProperty.Edit;
var
  Component: TComponent;
  Dlg: TRzCheckListEditDlg;
  OwnerName: string;

  procedure CopyCheckList( Dest, Source: TRzCheckList );
  var
    I: Integer;
  begin
    Dest.AllowGrayed := Source.AllowGrayed;
    Dest.Items.Assign( Source.Items );
    Dest.Sorted := Source.Sorted;
    Dest.Font := Source.Font;
    Dest.GroupFont := Source.GroupFont;
    Dest.GroupColor := Source.GroupColor;
    Dest.UseGradients := Source.UseGradients;
    Dest.TabStops := Source.TabStops;
    for I := 0 to Source.Items.Count - 1 do
    begin
      Dest.ItemEnabled[ I ] := Source.ItemEnabled[ I ];
      Dest.ItemState[ I ] := Source.ItemState[ I ];
    end;
  end;

begin
  Component := TComponent( GetComponent( 0 ) );

  Dlg := TRzCheckListEditDlg.Create( Application );
  try
    CopyCheckList( Dlg.LstPreview, TRzCheckList( GetComponent( 0 ) ) );

    if Component.Owner <> nil then
      OwnerName := Component.Owner.Name + '.'
    else
      OwnerName := '';
    Dlg.Caption := OwnerName + Component.Name + Dlg.Caption;
    Dlg.UpdateControls;

    if Dlg.ShowModal = mrOK then                          { Display Dialog Box }
    begin
      CopyCheckList( TRzCheckList( GetComponent( 0 ) ), Dlg.LstPreview );
      Designer.Modified;
    end;
  finally
    Dlg.Free;
  end;
end;



{================================}
{== TRzCheckListEditor Methods ==}
{================================}

function TRzCheckListEditor.CheckList: TRzCheckList;
begin
  Result := Component as TRzCheckList;
end;


function TRzCheckListEditor.GetVerbCount: Integer;
begin
  Result := 7;
end;


function TRzCheckListEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Edit Check List...';
    1: Result := '-';
    2: Result := 'Edit Tab Stops...';
    3: Result := 'Manual Tab Stops';
    4: Result := 'Automatic Tab Stops';
    5: Result := '-';
    6: Result := 'Align';
  end;
end;


function TRzCheckListEditor.AlignMenuIndex: Integer;
begin
  Result := 6;
end;


function TRzCheckListEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT_ITEMS';
    2: Result := 'RZDESIGNEDITORS_TABSTOPS';
  end;
end;


procedure TRzCheckListEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    3: Item.Checked := CheckList.TabStopsMode = tsmManual;
    4: Item.Checked := CheckList.TabStopsMode = tsmAutomatic;
  end;
end;


procedure TRzCheckListEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'Items' );
    2: EditPropertyByName( 'TabStops' );

    3: CheckList.TabStopsMode := tsmManual;
    4: CheckList.TabStopsMode := tsmAutomatic;
  end;
  if Index in [ 3, 4 ] then
    Designer.Modified;
end;


{=================================}
{== TRzCheckListEditDlg Methods ==}
{=================================}

procedure TRzCheckListEditDlg.UpdateControls;
begin
  ChkAllowGrayed.Checked := LstPreview.AllowGrayed;
  EnableButtons( LstPreview.Items.Count > 0 );
  if LstPreview.Items.Count > 0 then
  begin
    LstPreview.ItemIndex := 0;
    EnableMoveButtons( 0 );
  end;
end;


procedure TRzCheckListEditDlg.EnableButtons( Enable: Boolean );
begin
  BtnDelete.Enabled := Enable;
  BtnEdit.Enabled := Enable;
  BtnMoveUp.Enabled := Enable;
  BtnMoveDown.Enabled := Enable;
end;


procedure TRzCheckListEditDlg.EnableMoveButtons( Idx: Integer );
begin
  BtnMoveUp.Enabled := Idx > 0;
  BtnMoveDown.Enabled := Idx < LstPreview.Items.Count - 1;
end;


procedure TRzCheckListEditDlg.LstPreviewClick(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := LstPreview.ItemIndex;
  ChkItemEnabled.Enabled := Idx <> -1;
  ChkConvertToGroup.Enabled := Idx <> -1;
  if Idx <> -1 then
  begin
    ChkItemEnabled.Checked := LstPreview.ItemEnabled[ Idx ];
    ChkConvertToGroup.Checked := LstPreview.ItemIsGroup[ Idx ];
    EnableMoveButtons( Idx );
  end;
end;


procedure TRzCheckListEditDlg.ChkItemEnabledClick(Sender: TObject);
begin
  LstPreview.ItemEnabled[ LstPreview.ItemIndex ] := ChkItemEnabled.Checked;
end;


procedure TRzCheckListEditDlg.ChkConvertToGroupClick(Sender: TObject);
begin
  if ChkConvertToGroup.Checked then
    LstPreview.ItemToGroup( LstPreview.ItemIndex )
  else
    LstPreview.GroupToItem( LstPreview.ItemIndex );
end;


procedure TRzCheckListEditDlg.ChkAllowGrayedClick(Sender: TObject);
begin
  LstPreview.AllowGrayed := ChkAllowGrayed.Checked;
end;


procedure TRzCheckListEditDlg.BtnAddClick(Sender: TObject);
var
  Dlg: TRzCheckItemEditDlg;
  Idx: Integer;
begin
  { add a new entry }
  Dlg := TRzCheckItemEditDlg.Create( Application );
  try
    Dlg.Caption := sRzAddCheckItem;
    Dlg.Item := '';
    if Dlg.ShowModal = mrOK then
    begin
      if Dlg.ChkAsGroup.Checked then
        Idx := LstPreview.AddGroup( Dlg.Item )
      else
        Idx := LstPreview.Items.Add( Dlg.Item );
      LstPreview.ItemIndex := Idx;
      EnableButtons( True );
      LstPreviewClick( nil );                   { Update Item Enabled Checkbox }
    end;
  finally
    Dlg.Free;
  end;
end;


procedure TRzCheckListEditDlg.BtnEditClick(Sender: TObject);
var
  Dlg: TRzCheckItemEditDlg;
  Idx: Integer;
begin
  Dlg := TRzCheckItemEditDlg.Create( Application );
  try
    Idx := LstPreview.ItemIndex;
    Dlg.Caption := sRzEditCheckItem;

    Dlg.Item := LstPreview.ItemCaption( Idx );
    if LstPreview.ItemIsGroup[ Idx ] then
      Dlg.ChkAsGroup.Checked := True;

    if Dlg.ShowModal = mrOK then
    begin
      if Dlg.ChkAsGroup.Checked then
        LstPreview.Items[ Idx ] := strDefaultGroupPrefix + Dlg.Item
      else
        LstPreview.Items[ Idx ] := Dlg.Item;

      LstPreview.ItemIndex := Idx;
    end;
  finally
    Dlg.Free;
  end;
end;


procedure TRzCheckListEditDlg.BtnDeleteClick(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := LstPreview.ItemIndex;
  if MessageDlg( Format( sRzDeleteCheckItem, [ LstPreview.Items[ Idx ] ] ),
                 mtConfirmation, [ mbYes, mbNo ], 0 ) = mrYes then
  begin
    LstPreview.Items.Delete( Idx );

    if LstPreview.Items.Count > 0 then
    begin
      if Idx = LstPreview.Items.Count then
        Dec( Idx );
      LstPreview.ItemIndex := Idx;
    end
    else
      EnableButtons( False );
    LstPreviewClick( nil );                     { Update Item Enabled Checkbox }
  end;
end; {= TRzCheckListEditDlg.BtnDeleteClick =}


procedure TRzCheckListEditDlg.BtnClearClick(Sender: TObject);
begin
  LstPreview.Clear;
  EnableButtons( False );
  EnableMoveButtons( -1 );
end;


procedure TRzCheckListEditDlg.BtnMoveUpClick(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := LstPreview.ItemIndex;
  LstPreview.Items.Move( Idx, Idx - 1 );
  LstPreview.ItemIndex := Idx - 1;
  EnableMoveButtons( Idx - 1 );
end;


procedure TRzCheckListEditDlg.BtnMoveDownClick(Sender: TObject);
var
  Idx: Integer;
begin
  Idx := LstPreview.ItemIndex;
  LstPreview.Items.Move( Idx, Idx + 1 );
  LstPreview.ItemIndex := Idx + 1;
  EnableMoveButtons( Idx + 1 );
end;


procedure TRzCheckListEditDlg.BtnLoadClick(Sender: TObject);
begin
  if DlgOpen.Execute then
  begin
    LstPreview.LoadFromFile( DlgOpen.FileName );
    UpdateControls;
  end;
end;


procedure TRzCheckListEditDlg.BtnSaveClick(Sender: TObject);
begin
  if DlgSave.Execute then
    LstPreview.SaveToFile( DlgSave.FileName );
end;


end.
