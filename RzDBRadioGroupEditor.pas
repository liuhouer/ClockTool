{===============================================================================
  RzDBRadioGroupEditor Unit

  Raize Components - Design Editor Source Unit


  Design Editors        Description
  ------------------------------------------------------------------------------
  TRzDBRadioGroupEditor Adds context menu to TRzDBRadioGroup to quickly add
                          items


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

unit RzDBRadioGroupEditor;

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
  RzDBDesignEditors,
  RzRadGrp,
  RzPanel,
  RzTrkBar,
  Grids,
  RzDBRGrp,
  RzEdit,
  Mask,
  RzLabel,
  RzButton;


type
  TRzDBRadioGroupEditor = class( TRzDBControlEditor )
  protected
    function RadioGroup: TRzDBRadioGroup;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  TRzDBRadioGroupEditDlg = class(TForm)
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
    EdtValues: TRzMemo;
    Label4: TRzLabel;
    GrpPreview: TRzDBRadioGroup;
    RzPanel1: TRzPanel;
    BtnOk: TRzButton;
    BtnCancel: TRzButton;
    procedure EdtCaptionChange(Sender: TObject);
    procedure TrkColumnsChange(Sender: TObject);
    procedure EdtItemsChange(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure EdtValuesChange(Sender: TObject);
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

{===================================}
{== TRzDBRadioGroupEditor Methods ==}
{===================================}

function TRzDBRadioGroupEditor.RadioGroup: TRzDBRadioGroup;
begin
  // Helper function to provide quick access to component being edited.
  // Also makes sure Component is a TRzDBRadioGroup
  Result := Component as TRzDBRadioGroup;
end;


function TRzDBRadioGroupEditor.GetVerbCount: Integer;
begin
  // Return the number of new menu items to display
  Result := 11;
end;


function TRzDBRadioGroupEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Set DataSource';
    1: Result := 'Set DataField';
    2: Result := '-';
    3: Result := 'Edit Items && Values...';
    4: Result := 'HotTrack Items';
    5: Result := 'XP Colors';
    6: Result := '-';
    7: Result := 'Flat Border';
    8: Result := 'Top Line';
    9: Result := 'Standard';
    10: Result := 'Custom';
  end;
end;


function TRzDBRadioGroupEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_DATASOURCE';
    1: Result := 'RZDESIGNEDITORS_DATAFIELD';
    3: Result := 'RZDESIGNEDITORS_EDIT';
    4: Result := 'RZDESIGNEDITORS_HOTTRACK';
    5: Result := 'RZDESIGNEDITORS_XPCOLORS';
    7: Result := 'RZDESIGNEDITORS_GROUPBOX_FLAT';
    8: Result := 'RZDESIGNEDITORS_GROUPBOX_TOPLINE';
    9: Result := 'RZDESIGNEDITORS_GROUPBOX_STANDARD';
    10: Result := 'RZDESIGNEDITORS_GROUPBOX_CUSTOM';
  end;
end;


procedure TRzDBRadioGroupEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  if Index = 4 then
    Item.Checked := RadioGroup.ItemHotTrack;
end;


procedure TRzDBRadioGroupEditor.ExecuteVerb( Index: Integer );
var
  D: TRzDBRadioGroupEditDlg;

  procedure CopyRadioGroup( Dest, Source: TRzDBRadioGroup );
  begin
    Dest.Caption := Source.Caption;
    Dest.Columns := Source.Columns;
    Dest.Items := Source.Items;
    Dest.Values := Source.Values;
    Dest.GroupStyle := Source.GroupStyle;
    Dest.ItemFrameColor := Source.ItemFrameColor;
    Dest.ItemHotTrack := Source.ItemHotTrack;
    Dest.ItemHighlightColor := Source.ItemHighlightColor;
    Dest.ItemHotTrackColor := Source.ItemHotTrackColor;
  end;

begin
  case Index of
    3:
    begin
      D := TRzDBRadioGroupEditDlg.Create( Application );
      try
        // Copy component attributes to the GrpPreview component
        CopyRadioGroup( D.GrpPreview, RadioGroup );

        // Set the dialog's Caption to reflect component being edited
        D.Caption := Component.Owner.Name +'.'+ Component.Name + D.Caption;

        D.UpdateControls;              // Update all controls on dialog box

        if D.ShowModal = mrOK then
        begin
          CopyRadioGroup( RadioGroup, D.GrpPreview );
          // Tell the Form Designer to set the Modified flag for the form
          Designer.Modified;
        end;
      finally
        D.Free;
      end;
    end;

    4:
    begin
      RadioGroup.ItemHotTrack := not RadioGroup.ItemHotTrack;
      Designer.Modified;
    end;

    5: // XP Colors
    begin
      RadioGroup.ItemHotTrack := True;
      RadioGroup.ItemHotTrackColorType := htctActual;
      RadioGroup.ItemHighlightColor := $0021A121;
      RadioGroup.ItemHotTrackColor := $003CC7FF;
      RadioGroup.ItemFrameColor := $0080511C;
      Designer.Modified;
    end;

    7:
    begin
      RadioGroup.GroupStyle := gsFlat;
      Designer.Modified;
    end;

    8:
    begin
      RadioGroup.GroupStyle := gsTopLine;
      Designer.Modified;
    end;

    9:
    begin
      RadioGroup.GroupStyle := gsStandard;
      Designer.Modified;
    end;

    10:
    begin
      RadioGroup.GroupStyle := gsCustom;
      Designer.Modified;
    end;

  end;
end; {= TRzDBRadioGroupEditor.ExecuteVerb =}



{==================================}
{== TRzRadioGroupEditDlg Methods ==}
{==================================}

procedure TRzDBRadioGroupEditDlg.UpdateControls;
begin
  FUpdating := True;
  try
    EdtCaption.Text := GrpPreview.Caption;
    TrkColumns.Position := GrpPreview.Columns;
    EdtItems.Lines := GrpPreview.Items;
    EdtValues.Lines := GrpPreview.Values;
  finally
    FUpdating := False;
  end;
end;

procedure TRzDBRadioGroupEditDlg.EdtCaptionChange(Sender: TObject);
begin
  GrpPreview.Caption := EdtCaption.Text;
end;


procedure TRzDBRadioGroupEditDlg.TrkColumnsChange(Sender: TObject);
begin
  GrpPreview.Columns := TrkColumns.Position;
end;


procedure TRzDBRadioGroupEditDlg.EdtItemsChange(Sender: TObject);
begin
  if not FUpdating then
    GrpPreview.Items := EdtItems.Lines;
end;


procedure TRzDBRadioGroupEditDlg.EdtValuesChange(Sender: TObject);
begin
  if not FUpdating then
    GrpPreview.Values := EdtValues.Lines;
end;



procedure TRzDBRadioGroupEditDlg.BtnLoadClick(Sender: TObject);
begin
  if DlgOpen.Execute then
    EdtItems.Lines.LoadFromFile( DlgOpen.FileName );
end;


procedure TRzDBRadioGroupEditDlg.BtnClearClick(Sender: TObject);
begin
  EdtItems.Lines.Clear;
  EdtValues.Lines.Clear;
  GrpPreview.Items.Clear;
  GrpPreview.Items.Clear;
end;

procedure TRzDBRadioGroupEditDlg.TrkColumnsDrawTick(TrackBar: TRzTrackBar;
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

procedure TRzDBRadioGroupEditDlg.FormCreate(Sender: TObject);
begin
  Icon.Handle := LoadIcon( HInstance, 'RZDESIGNEDITORS_EDIT_ICON' );

  Width := MulDiv( Width, Screen.PixelsPerInch, 96 );
  Height := MulDiv( Height, Screen.PixelsPerInch, 96 );

  EdtItems.Anchors := [ akLeft, akTop, akBottom ];
  EdtValues.Anchors := [ akLeft, akTop, akBottom ];
end;

end.



