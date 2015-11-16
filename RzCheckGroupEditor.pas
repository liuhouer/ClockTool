{===============================================================================
  RzCheckGroupEditor Unit

  Raize Components - Design Editor Source Unit


  Design Editors        Description
  ------------------------------------------------------------------------------
  TRzCheckGroupEditor   Adds context menu to TRzCheckGroup to quickly add items


  Modification History
  ------------------------------------------------------------------------------
  3.0.6  (11 Apr 2003)
    * In XP Colors context menu item event handler set ItemHotTrackColorType to
      htctActual.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Initial release.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzCheckGroupEditor;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Windows,
  Controls,
  Graphics,
  Forms,
  Menus,
  StdCtrls,
  ExtCtrls,
  ComCtrls,
  Classes,
  Dialogs,
  {$IFDEF VCL60_OR_HIGHER}
  DesignIntf,
  DesignEditors,
  DesignMenus,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  RzDesignEditors,
  RzRadGrp,
  RzPanel,
  RzTrkBar,
  RzEdit,
  Mask,
  RzLabel,
  RzButton;


type
  TRzCheckGroupEditor = class( TRzDefaultEditor )
  protected
    function CheckGroup: TRzCheckGroup; virtual;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;

    procedure ItemsMenuHandler( Sender: TObject );
  end;


  TRzCheckGroupEditDlg = class(TForm)
    PnlButtons: TRzPanel;
    PnlOptions: TRzPanel;
    EdtCaption: TRzEdit;
    Label1: TRzLabel;
    EdtItems: TRzMemo;
    Label2: TRzLabel;
    BtnLoad: TRzButton;
    Label3: TRzLabel;
    BtnClear: TRzButton;
    DlgOpen: TOpenDialog;
    TrkColumns: TRzTrackBar;
    PnlPreview: TRzPanel;
    GrpPreview: TRzCheckGroup;
    RzPanel1: TRzPanel;
    BtnOk: TRzButton;
    BtnCancel: TRzButton;
    procedure EdtCaptionChange(Sender: TObject);
    procedure TrkColumnsChange(Sender: TObject);
    procedure EdtItemsChange(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure TrkColumnsDrawTick(TrackBar: TRzTrackBar; Canvas: TCanvas;
      Location: TPoint; Index: Integer);
    procedure FormCreate(Sender: TObject);
  private
    FUpdating: Boolean;
  public
    procedure UpdateControls;
  end;


implementation

{$R *.dfm}

uses
  SysUtils,
  RzCommon;

{=================================}
{== TRzCheckGroupEditor Methods ==}
{=================================}

function TRzCheckGroupEditor.CheckGroup: TRzCheckGroup;
begin
  // Helper function to provide quick access to component being edited.
  // Also makes sure Component is a TRzCheckGroup
  Result := Component as TRzCheckGroup;
end;


function TRzCheckGroupEditor.GetVerbCount: Integer;
begin
  // Return the number of new menu items to display
  if CheckGroup.Items.Count > 0 then
    Result := 10
  else
    Result := 8;
end;


function TRzCheckGroupEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Edit Items...';
    1: Result := 'HotTrack Items';
    2: Result := 'XP Colors';
    3: Result := '-';
    4: Result := 'Flat Border';
    5: Result := 'Top Line';
    6: Result := 'Standard';
    7: Result := 'Custom';
    8: Result := '-';
    9: Result := 'Check Item';

  end;
end;


function TRzCheckGroupEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT';
    1: Result := 'RZDESIGNEDITORS_HOTTRACK';
    2: Result := 'RZDESIGNEDITORS_XPCOLORS';
    4: Result := 'RZDESIGNEDITORS_GROUPBOX_FLAT';
    5: Result := 'RZDESIGNEDITORS_GROUPBOX_TOPLINE';
    6: Result := 'RZDESIGNEDITORS_GROUPBOX_STANDARD';
    7: Result := 'RZDESIGNEDITORS_GROUPBOX_CUSTOM';
  end;
end;


procedure TRzCheckGroupEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
var
  I: Integer;

  procedure CreateItemMenu( Index: Integer; const Caption: string; Checked: Boolean );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Index;
    NewItem.Checked := Checked;
    NewItem.OnClick := ItemsMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  if Index = 1 then
    Item.Checked := CheckGroup.ItemHotTrack;

  if Index = 9 then
  begin
    for I := 0 to CheckGroup.Items.Count - 1 do
      CreateItemMenu( I, CheckGroup.Items[ I ], CheckGroup.ItemChecked[ I ] );
  end;

end;


procedure TRzCheckGroupEditor.ExecuteVerb( Index: Integer );
var
  D: TRzCheckGroupEditDlg;

  procedure CopyCheckGroup( Dest, Source: TRzCheckGroup );
  var
    I: Integer;
  begin
    Dest.Caption := Source.Caption;
    Dest.Columns := Source.Columns;
    Dest.Items := Source.Items;
    Dest.GroupStyle := Source.GroupStyle;
    Dest.ItemFrameColor := Source.ItemFrameColor;
    Dest.ItemHotTrack := Source.ItemHotTrack;
    Dest.ItemHighlightColor := Source.ItemHighlightColor;
    Dest.ItemHotTrackColor := Source.ItemHotTrackColor;
    for I := 0 to Dest.Items.Count - 1 do
      Dest.ItemChecked[ I ] := Source.ItemChecked[ I ];
  end;

begin
  case Index of
    0:
    begin
      D := TRzCheckGroupEditDlg.Create( Application );
      try
        // Copy component attributes to the GrpPreview component
        CopyCheckGroup( D.GrpPreview, CheckGroup );

        // Set the dialog's Caption to reflect component being edited
        D.Caption := Component.Owner.Name +'.'+ Component.Name + D.Caption;

        D.UpdateControls;              // Update all controls on dialog box

        if D.ShowModal = mrOK then
        begin
          CopyCheckGroup( CheckGroup, D.GrpPreview );
          // Tell the Form Designer to set the Modified flag for the form
          Designer.Modified;
        end;
      finally
        D.Free;
      end;
    end;

    1:
    begin
      CheckGroup.ItemHotTrack := not CheckGroup.ItemHotTrack;
      Designer.Modified;
    end;

    2: // XP Colors
    begin
      CheckGroup.ItemHotTrack := True;
      CheckGroup.ItemHotTrackColorType := htctActual;
      CheckGroup.ItemHighlightColor := $0021A121;
      CheckGroup.ItemHotTrackColor := $003CC7FF;
      CheckGroup.ItemFrameColor := $0080511C;
      Designer.Modified;
    end;

    4:
    begin
      CheckGroup.GroupStyle := gsFlat;
      Designer.Modified;
    end;

    5:
    begin
      CheckGroup.GroupStyle := gsTopLine;
      Designer.Modified;
    end;

    6:
    begin
      CheckGroup.GroupStyle := gsStandard;
      Designer.Modified;
    end;

    7:
    begin
      CheckGroup.GroupStyle := gsCustom;
      Designer.Modified;
    end;

  end;
end; {= TRzCheckGroupEditor.ExecuteVerb =}


procedure TRzCheckGroupEditor.ItemsMenuHandler( Sender: TObject );
var
  Idx: Integer;
begin
  Idx := TMenuItem( Sender ).Tag;
  CheckGroup.ItemChecked[ Idx ] := not CheckGroup.ItemChecked[ Idx ];
  Designer.Modified;
end;


{==================================}
{== TRzCheckGroupEditDlg Methods ==}
{==================================}

procedure TRzCheckGroupEditDlg.UpdateControls;
begin
  FUpdating := True;
  try
    EdtCaption.Text := GrpPreview.Caption;
    TrkColumns.Position := GrpPreview.Columns;
    EdtItems.Lines := GrpPreview.Items;
  finally
    FUpdating := False;
  end;
end;

procedure TRzCheckGroupEditDlg.EdtCaptionChange(Sender: TObject);
begin
  GrpPreview.Caption := EdtCaption.Text;
end;


procedure TRzCheckGroupEditDlg.TrkColumnsChange(Sender: TObject);
begin
  GrpPreview.Columns := TrkColumns.Position;
end;


procedure TRzCheckGroupEditDlg.EdtItemsChange(Sender: TObject);
begin
  if not FUpdating then
    GrpPreview.Items := EdtItems.Lines;
end;


procedure TRzCheckGroupEditDlg.BtnLoadClick(Sender: TObject);
begin
  if DlgOpen.Execute then
    EdtItems.Lines.LoadFromFile( DlgOpen.FileName );
end;


procedure TRzCheckGroupEditDlg.BtnClearClick(Sender: TObject);
begin
  EdtItems.Lines.Clear;
  GrpPreview.Items.Clear;
end;


procedure TRzCheckGroupEditDlg.TrkColumnsDrawTick(TrackBar: TRzTrackBar;
  Canvas: TCanvas; Location: TPoint; Index: Integer);
var
  S: string;
  W: Integer;
begin
  Canvas.Brush.Color := TrackBar.Color;
  Canvas.Font.Name := 'Tahoma';
  Canvas.Font.Size := 7;
  Canvas.Font.Style := [];
  S := IntToStr( Index );
  W := Canvas.TextWidth( S );
  Canvas.TextOut( Location.X - (W div 2), 1, S );
end;

procedure TRzCheckGroupEditDlg.FormCreate(Sender: TObject);
begin
  Icon.Handle := LoadIcon( HInstance, 'RZDESIGNEDITORS_EDIT_ICON' );

  Width := MulDiv( Width, Screen.PixelsPerInch, 96 );
  Height := MulDiv( Height, Screen.PixelsPerInch, 96 );

  EdtItems.Anchors := [ akLeft, akTop, akBottom];
end;

end.

