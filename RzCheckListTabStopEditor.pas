{===============================================================================
  RzCheckListTabStopEditor Unit

  Raize Components - Design Editor Source Unit


  Design Editors                 Description
  ------------------------------------------------------------------------------
  TRzCheckListTabStopProperty    Displays special dialog to manage tabstops for
                                   the TRzCheckList.


  Modification History
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Added TabStopsMode options to Tab Stop dialog box.
    * Added "Manual Tab Stops" and "Automatic Tab Stops" items to context menu
      for TRzTabbedListBox.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Initial release. Created a separate editor (from the TRzTabStopProperty)
      so that the preview list box can be a TRzCheckList rather than the
      inherited TRzTabbedListBox.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzCheckListTabStopEditor;

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
  RzChkLst,
  RzRadGrp;

type
  TRzCheckListTabStopProperty = class( TPropertyEditor )
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;


  TRzCheckListTabStopEditDlg = class(TForm)
    BtnOK: TRzButton;
    BtnCancel: TRzButton;
    GrpPreview: TRzGroupBox;
    GrpTabStops: TRzGroupBox;
    LstTabs: TRzListBox;
    LblMin: TRzLabel;
    LblMax: TRzLabel;
    Label3: TRzLabel;
    LblTabNum: TRzLabel;
    LstPreview: TRzCheckList;
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

{=================================}
{== TRzCheckListTabStopProperty ==}
{=================================}

function TRzCheckListTabStopProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paDialog ];
end;


function TRzCheckListTabStopProperty.GetValue: string;
begin
  Result := Format( '(%s)', [ GetPropType^.Name ] );       // Display Type Name in Object Inspector
end;


procedure TRzCheckListTabStopProperty.Edit;
var
  Dlg: TRzCheckListTabStopEditDlg;
  OwnerName: string;
  I: Integer;

  procedure CopyCheckList( Dest, Source: TRzCheckList );
  begin
    { Set Preview List Box strings and Font to be same as component's }
    Dest.AllowGrayed := Source.AllowGrayed;
    Dest.Items := Source.Items;
    Dest.Font := Source.Font;
    Dest.GroupFont := Source.GroupFont;
    Dest.GroupColor := Source.GroupColor;
    Dest.UseGradients := Source.UseGradients;
    Dest.TabStopsMode := Source.TabStopsMode;
  end;

begin
  Dlg := TRzCheckListTabStopEditDlg.Create( Application );
  try
    if TComponent( GetComponent( 0 ) ).Owner <> nil then
      OwnerName := TComponent( GetComponent(0) ).Owner.Name + '.'
    else
      OwnerName := '';
    Dlg.Caption := OwnerName + TComponent( GetComponent(0) ).Name + '.' + GetName + ' - ' + Dlg.Caption;

    CopyCheckList( Dlg.LstPreview, TRzCheckList( GetComponent( 0 ) ) );

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
end; {= TRzCheckListTabStopProperty.Edit =}



{========================================}
{== TRzCheckListTabStopEditDlg Methods ==}
{========================================}

procedure TRzCheckListTabStopEditDlg.FormCreate(Sender: TObject);
begin
  FUpdating := False;
end;


procedure TRzCheckListTabStopEditDlg.BtnAddClick(Sender: TObject);
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


procedure TRzCheckListTabStopEditDlg.BtnDeleteClick(Sender: TObject);
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

procedure TRzCheckListTabStopEditDlg.LstTabsClick(Sender: TObject);
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


procedure TRzCheckListTabStopEditDlg.FormShow(Sender: TObject);
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

procedure TRzCheckListTabStopEditDlg.TrkTabPosChange(Sender: TObject);
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

procedure TRzCheckListTabStopEditDlg.ChkRightAlignedClick(Sender: TObject);
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


procedure TRzCheckListTabStopEditDlg.GrpTabStopsModeClick(Sender: TObject);
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



