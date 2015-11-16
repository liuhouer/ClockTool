{===============================================================================
  RzTabStopEditor Unit

  Raize Components - Design Editor Source Unit


  Design Editors          Description
  ------------------------------------------------------------------------------
  TRzTabStopProperty      Displays special dialog to manage tabstops for the
                            TRzTabbedListBox.
  TRzTabbedListBoxEditor  Adds context menu to edit the tab stops, add items,
                            and set the Align property.


  Modification History
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Added TabStopsMode options to Tab Stop dialog box.
    * Added "Manual Tab Stops" and "Automatic Tab Stops" items to context menu
      for TRzTabbedListBox.
    * Added "Show Groups" item to context menu for TRzTabbedListBox.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Updated form to use custom framing editing controls and HotTrack style
      buttons, radio buttons, and check boxes.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzTabStopEditor;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  SysUtils,
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  Buttons,
  Menus,
  RzDesignEditors,
  RzTrkBar,
  {$IFDEF VCL60_OR_HIGHER}
  DesignIntf,
  DesignEditors,
  DesignMenus,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  RzLstBox,
  RzRadChk,
  RzLabel,
  RzButton,
  ExtCtrls,
  RzPanel,
  RzRadGrp;

type
  TRzTabStopProperty = class( TPropertyEditor )
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;


  TRzTabbedListBoxEditor = class( TRzDefaultEditor )
  protected
    function ListBox: TRzTabbedListBox;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  TRzTabStopEditDlg = class(TForm)
    BtnOK: TRzButton;
    BtnCancel: TRzButton;
    GrpPreview: TRzGroupBox;
    GrpTabStops: TRzGroupBox;
    LstTabs: TRzListBox;
    LblMin: TRzLabel;
    LblMax: TRzLabel;
    Label3: TRzLabel;
    LblTabNum: TRzLabel;
    LstPreview: TRzTabbedListBox;
    BtnAdd: TRzButton;
    BtnDelete: TRzButton;
    ChkRightAligned: TRzCheckBox;
    TrkTabPos: TRzTrackBar;
    GrpTabStopsMode: TRzRadioGroup;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure LstTabsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TrkTabPosChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ChkRightAlignedClick(Sender: TObject);
    procedure GrpTabStopsModeClick(Sender: TObject);
  private
    FUpdating: Boolean;
  end;


implementation

{$R *.DFM}

uses
  RzCommon;

{========================}
{== TRzTabStopProperty ==}
{========================}

function TRzTabStopProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paDialog ];
end;


function TRzTabStopProperty.GetValue: string;
begin
  Result := Format( '(%s)', [ GetPropType^.Name ] );       // Display Type Name in Object Inspector
end;


procedure TRzTabStopProperty.Edit;
var
  Dlg: TRzTabStopEditDlg;
  OwnerName: string;
  I: Integer;

  procedure CopyList( Dest, Source: TRzTabbedListBox );
  begin
    { Set Preview List Box strings and Font to be same as component's }
    Dest.Items := Source.Items;
    Dest.Font := Source.Font;
    Dest.GroupFont := Source.GroupFont;
    Dest.GroupColor := Source.GroupColor;
    Dest.UseGradients := Source.UseGradients;
    Dest.TabStopsMode := Source.TabStopsMode;
  end;

begin
  Dlg := TRzTabStopEditDlg.Create( Application );
  try
    if TComponent( GetComponent( 0 ) ).Owner <> nil then
      OwnerName := TComponent( GetComponent(0) ).Owner.Name + '.'
    else
      OwnerName := '';
    Dlg.Caption := OwnerName + TComponent( GetComponent(0) ).Name + '.' + GetName + ' - ' + Dlg.Caption;

    CopyList( Dlg.LstPreview, TRzTabbedListBox( GetComponent( 0 ) ) );

    Dlg.LstPreview.TabStops := TRzTabStopList( GetOrdValue );

    // Add preset tabs to the LstTabs list box
    for I := 0 to Dlg.LstPreview.TabStops.Count - 1 do
      Dlg.LstTabs.Items.Add( IntToStr( Abs( Dlg.LstPreview.TabStops[ I ] ) ) );

    Dlg.GrpTabStopsMode.ItemIndex := Ord( Dlg.LstPreview.TabStopsMode );

    if Dlg.ShowModal = mrOK then
    begin                                                  // If user presses OK, move TabList from Dlg to Property
      SetOrdValue( Longint( Dlg.LstPreview.TabStops ) );
      TRzTabbedListBox( GetComponent( 0 ) ).TabStopsMode := Dlg.LstPreview.TabStopsMode;
    end;
  finally
    Dlg.Free;
  end;
end; {= TRzTabStopProperty.Edit =}



{====================================}
{== TRzTabbedListBoxEditor Methods ==}
{====================================}

function TRzTabbedListBoxEditor.ListBox: TRzTabbedListBox;
begin
  Result := Component as TRzTabbedListBox;
end;


function TRzTabbedListBoxEditor.GetVerbCount: Integer;
begin
  Result := 9;
end;


function TRzTabbedListBoxEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Edit Items...';
    1: Result := '-';
    2: Result := 'Edit Tab Stops...';
    3: Result := 'Manual Tab Stops';
    4: Result := 'Automatic Tab Stops';
    5: Result := '-';
    6: Result := 'Align';
    7: Result := '-';
    8: Result := 'Show Groups';
  end;
end;


function TRzTabbedListBoxEditor.AlignMenuIndex: Integer;
begin
  Result := 6;
end;


function TRzTabbedListBoxEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT_ITEMS';
    2: Result := 'RZDESIGNEDITORS_TABSTOPS';
  end;
end;


procedure TRzTabbedListBoxEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    3: Item.Checked := ListBox.TabStopsMode = tsmManual;
    4: Item.Checked := ListBox.TabStopsMode = tsmAutomatic;
    8: Item.Checked := ListBox.ShowGroups;
  end;
end;


procedure TRzTabbedListBoxEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'Items' );
    2: EditPropertyByName( 'TabStops' );

    3: ListBox.TabStopsMode := tsmManual;
    4: ListBox.TabStopsMode := tsmAutomatic;
    8: ListBox.ShowGroups := not ListBox.ShowGroups;
  end;
  if Index in [ 3, 4, 8 ] then
    Designer.Modified;
end;



{===============================}
{== TRzTabStopEditDlg Methods ==}
{===============================}

procedure TRzTabStopEditDlg.FormCreate(Sender: TObject);
begin
  FUpdating := False;
end;


procedure TRzTabStopEditDlg.BtnAddClick(Sender: TObject);
var
  NewTab: Word;
  Idx   : Integer;
begin
  NewTab := 8;
  if LstPreview.TabStops.Count > 0 then
  begin               { Add a new tab stop 8 positions after the last tab stop }
    NewTab := Abs( LstPreview.TabStops[ LstPreview.TabStops.Count - 1 ] ) + 8;
  end;
  Idx := LstTabs.Items.Add( IntToStr( NewTab ) );{ Add TabStop to Editing List }
  LstPreview.TabStops.Add( NewTab );            { Add Tab stop to Preview list }

  LstTabs.ItemIndex := Idx;                  { Select the newly added tab stop }
  LstTabsClick( nil );                                      { Update Track Bar }
  BtnDelete.Enabled := True;
  TrkTabPos.Enabled := True;
end;


procedure TRzTabStopEditDlg.BtnDeleteClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := LstTabs.ItemIndex;
  LstPreview.TabStops.Delete( Index );              { Remove selected Tab Stop }
  LstTabs.Items.Delete( Index );

  if LstTabs.Items.Count > 0 then
  begin
    if Index = LstTabs.Items.Count then
      Dec( Index );
    LstTabs.ItemIndex := Index;
    LstTabsClick( nil );                                    { Update Track Bar }
  end
  else
  begin
    BtnDelete.Enabled := False;
    TrkTabPos.Enabled := False;
  end;
end;


{===============================================================================
  TRzTabStopEditDlg.LstTabsClick

  This method updates the Min and Max values of the track bar to reflect
  the range a particular tab stop may move.  A tab stop may not move past
  a tab stop that exists before or after it in the list.  Setting the
  track bar range ensures that this cannot happen. The FUpdating flag is
  set at the beginning of this method to prevent a change in the
  TrackBar's Min or Max value from causing the TrkTabPosChange event from
  altering the display.
===============================================================================}

procedure TRzTabStopEditDlg.LstTabsClick(Sender: TObject);
var
  I: Integer;
begin
  FUpdating := True;
  I := LstTabs.ItemIndex;
  TrkTabPos.Min := 0;
  TrkTabPos.Max := 100;
  if LstTabs.ItemIndex > 0 then                  { Get Previous Tab Stop Value }
    TrkTabPos.Min := Abs( StrToInt( LstTabs.Items[ I - 1 ] ) )
  else
    TrkTabPos.Min := 0;
  if LstTabs.ItemIndex < LstTabs.Items.Count - 1 then     { Get Next Tab Value }
    TrkTabPos.Max := Abs( StrToInt( LstTabs.Items[ I + 1 ] ) )
  else
    TrkTabPos.Max := 100;

  { Update TrackBar position to reflect currently selected tab stop }
  TrkTabPos.Position := Abs( LstPreview.TabStops[ I ] );
  ChkRightAligned.Checked := LstPreview.TabStops[ I ] < 0;
  LblTabNum.Caption := IntToStr( I + 1 );
  LblMin.Caption := IntToStr( TrkTabPos.Min );
  LblMax.Caption := IntToStr( TrkTabPos.Max );
  BtnDelete.Enabled := True;
  TrkTabPos.Enabled := True;
  FUpdating := False;
end;


procedure TRzTabStopEditDlg.FormShow(Sender: TObject);
begin
  if ( LstTabs.Items.Count > 0 ) and ( LstPreview.TabStopsMode = tsmManual ) then
  begin
    LstTabs.ItemIndex := 0;
    LstTabsClick( nil );
    BtnDelete.Enabled := True;
    TrkTabPos.Enabled := True;
  end;
end;


{===============================================================================
  TRzTabStopEditDlg.TrkTabPosChange

  As the track bar is moved, the value of the selected tab stop is updated.
  The change is immediately reflected in the Tab and Preview List boxes.
===============================================================================}

procedure TRzTabStopEditDlg.TrkTabPosChange(Sender: TObject);
var
  I: Integer;
begin
  if not FUpdating then
  begin
    I := LstTabs.ItemIndex;
    if ChkRightAligned.Checked then
      LstPreview.TabStops[ I ] := -TrkTabPos.Position
    else
      LstPreview.TabStops[ I ] := TrkTabPos.Position;
    LstTabs.Items[ I ] := IntToStr( TrkTabPos.Position );
    LstTabs.ItemIndex := I;
  end;
end;

procedure TRzTabStopEditDlg.ChkRightAlignedClick(Sender: TObject);
var
  I: Integer;
begin
  if not FUpdating then
  begin
    I := LstTabs.ItemIndex;
    if ChkRightAligned.Checked then
      LstPreview.TabStops[ I ] := -TrkTabPos.Position
    else
      LstPreview.TabStops[ I ] := TrkTabPos.Position;
  end;
end;


procedure TRzTabStopEditDlg.GrpTabStopsModeClick(Sender: TObject);
var
  I: Integer;
begin
  LstPreview.TabStopsMode := TRzTabStopsMode( GrpTabStopsMode.ItemIndex );
  GrpTabStops.Enabled := LstPreview.TabStopsMode = tsmManual;

  // Reset TabStops list
  LstTabs.Clear;
  for I := 0 to LstPreview.TabStops.Count - 1 do
    LstTabs.Items.Add( IntToStr( Abs( LstPreview.TabStops[ I ] ) ) );
end;

end.



