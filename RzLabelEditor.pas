{===============================================================================
  RzLabelEditor Unit

  Raize Components - Design Editor Source Unit


  Design Editors        Description
  ------------------------------------------------------------------------------
  TRzLableEditor        Adds context menu and advanced editing dialog.


  Modification History
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Updated form to use custom framing editing controls and HotTrack style
      buttons, radio buttons, and check boxes. Also uses the TRzPageControl.



  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzLabelEditor;

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
  Menus,
  Forms,
  Dialogs,
  StdCtrls,
  Rzlabel,
  ExtCtrls,
  Buttons,
  RzTrkBar,
  {$IFDEF VCL60_OR_HIGHER}
  DesignIntf,
  DesignEditors,
  DesignMenus,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  RzDesignEditors,
  RzCmboBx,
  Tabs,
  RzPanel,
  RzRadGrp,
  RzTabs,
  RzRadChk,
  Mask,
  RzEdit,
  RzButton,
  RzCommon;

type
  TRzLabelEditor = class( TRzComponentEditor )
  protected
    function LabelControl: TRzLabel;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure TextStyleMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  TRzLabelEditDlg = class(TForm)
    GrpPreview: TRzGroupBox;
    LblPreview: TRzLabel;
    BtnOK: TRzButton;
    BtnCancel: TRzButton;
    Label1: TRzLabel;
    EdtCaption: TRzEdit;
    PgcFormat: TRzPageControl;
    TabTextStyle: TRzTabSheet;
    TabOptions: TRzTabSheet;
    Label2: TRzLabel;
    Label3: TRzLabel;
    Label6: TRzLabel;
    TrkPointSize: TRzTrackBar;
    GrpFontStyle: TRzGroupBox;
    ChkBold: TRzCheckBox;
    ChkItalic: TRzCheckBox;
    ChkStrikeout: TRzCheckBox;
    ChkUnderline: TRzCheckBox;
    CbxFonts: TRzFontComboBox;
    GrpTextStyle: TRzRadioGroup;
    ChkLightStyle: TRzCheckBox;
    GrpShadow: TRzGroupBox;
    Label4: TRzLabel;
    Label5: TRzLabel;
    Label7: TRzLabel;
    LblShadowDepth: TRzLabel;
    TrkShadow: TRzTrackBar;
    GrpRotation: TRzGroupBox;
    LblAngle: TRzLabel;
    BtnNone: TSpeedButton;
    BtnFlat: TSpeedButton;
    BtnCurve: TSpeedButton;
    TrkAngle: TRzTrackBar;
    Chk15Degrees: TRzCheckBox;
    OptUpperLeft: TRzRadioButton;
    OptUpperCenter: TRzRadioButton;
    OptUpperRight: TRzRadioButton;
    OptLeftCenter: TRzRadioButton;
    OptCenter: TRzRadioButton;
    OptRightCenter: TRzRadioButton;
    OptLowerLeft: TRzRadioButton;
    OptLowerCenter: TRzRadioButton;
    OptLowerRight: TRzRadioButton;
    RzRegIniFile1: TRzRegIniFile;
    EdtFontColor: TRzColorEdit;
    EdtHighlightColor: TRzColorEdit;
    EdtShadowColor: TRzColorEdit;
    RzCustomColors1: TRzCustomColors;
    procedure EdtCaptionChange(Sender: TObject);
    procedure GrpTextStyleClick(Sender: TObject);
    procedure TrkPointSizeDrawTick( TrackBar: TRzTrackBar; Canvas: TCanvas; Location: TPoint; Index: Integer );
    procedure TrkPointSizeChange(Sender: TObject);
    procedure TrkShadowChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CbxFontsChange(Sender: TObject);
    procedure ChkBoldClick(Sender: TObject);
    procedure ChkItalicClick(Sender: TObject);
    procedure ChkStrikeoutClick(Sender: TObject);
    procedure ChkUnderlineClick(Sender: TObject);
    procedure TrkAngleDrawTick(TrackBar: TRzTrackBar; Canvas: TCanvas; Location: TPoint; Index: Integer );
    procedure Chk15DegreesClick(Sender: TObject);
    procedure TrkAngleChange(Sender: TObject);
    procedure BtnRotationClick(Sender: TObject);
    procedure OptCenterPointClick(Sender: TObject);
    procedure ChkLightStyleClick(Sender: TObject);
    procedure PgcFormatChanging(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
    procedure EdtFontColorChange(Sender: TObject);
    procedure EdtHighlightColorChange(Sender: TObject);
    procedure EdtShadowColorChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FUpdatingControls: Boolean;
    FNoAngleUpdate: Boolean;
  public
    procedure UpdateControls;
  end;


implementation

{$R *.DFM}


{============================}
{== TRzLabelEditor Methods ==}
{============================}

function TRzLabelEditor.LabelControl: TRzLabel;
begin
  Result := Component as TRzLabel;
end;


function TRzLabelEditor.GetVerbCount: Integer;
begin
  Result := 8;
end;


function TRzLabelEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Edit Label...';
    1: Result := 'Align';
    2: Result := '-';
    3: Result := 'AutoSize';
    4: Result := 'WordWrap';
    5: Result := 'Transparent';
    6: Result := '-';
    7: Result := 'Text Style';
  end;
end;


function TRzLabelEditor.AlignMenuIndex: Integer;
begin
  Result := 1;
end;


function TRzLabelEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT';
    4: Result := 'RZDESIGNEDITORS_WORDWRAP';
    5: Result := 'RZDESIGNEDITORS_TEXT_TRANSPARENT';
    7: Result := 'RZDESIGNEDITORS_TEXT_RAISED';
  end;
end;


procedure TRzLabelEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateTextStyleMenu( Style: TTextStyle; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Style );
    NewItem.Checked := LabelControl.TextStyle = Style;
    case Style of
      tsNormal:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TEXT_NORMAL' );
      tsRaised:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TEXT_RAISED' );
      tsRecessed: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TEXT_RECESSED' );
      tsShadow:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TEXT_SHADOW' );
    end;
    NewItem.OnClick := TextStyleMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    3: Item.Checked := LabelControl.AutoSize;
    4: Item.Checked := LabelControl.WordWrap;
    5: Item.Checked := LabelControl.Transparent;

    7:
    begin
      CreateTextStyleMenu( tsNormal, 'Normal' );
      CreateTextStyleMenu( tsRaised, 'Raised' );
      CreateTextStyleMenu( tsRecessed, 'Recessed' );
      CreateTextStyleMenu( tsShadow, 'Shadow' );
    end;
  end;
end;


procedure TRzLabelEditor.ExecuteVerb( Index: Integer );
var
  Dlg: TRzLabelEditDlg;
  OwnerName: string;

  procedure CopyLabel( Dest, Source: TRzLabel );
  begin
    Dest.Caption := Source.Caption;
    Dest.Font := Source.Font;
    Dest.TextStyle := Source.TextStyle;
    Dest.LightTextStyle := Source.LightTextStyle;
    Dest.HighlightColor := Source.HighlightColor;
    Dest.ShadowColor := Source.ShadowColor;
    Dest.ShadowDepth := Source.ShadowDepth;
    Dest.Rotation := Source.Rotation;
    Dest.Angle := Source.Angle;
    Dest.CenterPoint := Source.CenterPoint;
  end;

begin
  case Index of
    0:                                                         { Edit Label... }
    begin
      Dlg := TRzLabelEditDlg.Create( Application );

      try
        { Copy Attributes to Dialog Box LblPreview Component }
        CopyLabel( Dlg.LblPreview, Component as TRzLabel );

        if Component.Owner <> nil then
          OwnerName := Component.Owner.Name + '.'
        else
          OwnerName := '';
        Dlg.Caption := OwnerName + Component.Name + Dlg.Caption;
        Dlg.UpdateControls;

        if Dlg.ShowModal = mrOK then
        begin
          CopyLabel( Component as TRzLabel, Dlg.LblPreview );
          Designer.Modified;
        end;
      finally
        Dlg.Free;
      end;
    end;

    3:                                                     // AutoSize
    begin
      LabelControl.AutoSize := not LabelControl.AutoSize;
      Designer.Modified;
    end;

    4:                                                     // WordWrap
    begin
      LabelControl.WordWrap := not LabelControl.WordWrap;
      Designer.Modified;
    end;

    5:                                                     // Transparent
    begin
      LabelControl.Transparent := not LabelControl.Transparent;
      Designer.Modified;
    end;
  end; { case }
end; {= TRzLabelEditor.ExecuteVerb =}



procedure TRzLabelEditor.TextStyleMenuHandler( Sender: TObject );
begin
  LabelControl.TextStyle := TTextStyle( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;



{=================================================}
{== Implementation Specific Types and Constants ==}
{=================================================}

const                                           { Support Point Size Track Bar }
  PointSizes: array[ 0..18 ] of string[ 2 ] =
    ( '6', '7', '8', '9', '10', '11', '12', '14', '16', '18', '20',
      '22', '24', '28', '32', '40', '48', '64', '72' );


{=============================}
{== TRzLabelEditDlg Methods ==}
{=============================}

{= NOTE:  All changes made through the control on this dialog box affect only =}
{=        the preview label (LblPreview).  Only if the OK button is pressed   =}
{=        are the changes reflected in the selected component.                =}


procedure TRzLabelEditDlg.FormCreate(Sender: TObject);
begin
  PgcFormat.ActivePage := TabTextStyle;
  FNoAngleUpdate := False;

  RzRegIniFile1.Path := RC_SettingsKey;

  RzCustomColors1.Load( 'Custom Colors' );
end;


procedure TRzLabelEditDlg.FormClose( Sender: TObject; var Action: TCloseAction );
begin
  RzCustomColors1.Save( 'Custom Colors' );
end;


procedure TRzLabelEditDlg.UpdateControls;

  function PositionFromPointSize( P: Integer ): Integer;
  var
    I: Integer;
  begin
    I := 0;
    while ( I < 18 ) and ( StrToInt( PointSizes[ I ] ) <> P ) do
      Inc( I );
    if I = 18 then
      Result := 2
    else
      Result := I;
  end;

begin {= TRzLabelEditDlg.UpdateControls =}
  FUpdatingControls := True;
  try
    EdtCaption.Text := LblPreview.Caption;
    CbxFonts.SelectedFont := LblPreview.Font;
    EdtFontColor.SelectedColor := LblPreview.Font.Color;
    TrkPointSize.Position := PositionFromPointSize( LblPreview.Font.Size );

    { Font Styles }
    ChkBold.Checked := fsBold in LblPreview.Font.Style;
    ChkItalic.Checked := fsItalic in LblPreview.Font.Style;
    ChkStrikeout.Checked := fsStrikeout in LblPreview.Font.Style;
    ChkUnderline.Checked := fsUnderline in LblPreview.Font.Style;

    { Text Style }
    GrpTextStyle.ItemIndex := Ord( LblPreview.TextStyle );
    ChkLightStyle.Checked := LblPreview.LightTextStyle;

    { Shadow Options }
    EdtHighlightColor.SelectedColor := LblPreview.HighlightColor;
    EdtShadowColor.SelectedColor := LblPreview.ShadowColor;
    TrkShadow.Position := LblPreview.ShadowDepth;

    { Rotation Options }
    TrkAngle.Position := LblPreview.Angle;

    case LblPreview.Rotation of
      roNone: BtnNone.Down := True;
      roFlat: BtnFlat.Down := True;
      roCurve: BtnCurve.Down := True;
    end;
    case LblPreview.CenterPoint of
      cpUpperLeft: OptUpperLeft.Checked := True;
      cpUpperCenter: OptUpperCenter.Checked := True;
      cpUpperRight: OptUpperRight.Checked := True;
      cpLeftCenter: OptLeftCenter.Checked := True;
      cpCenter: OptCenter.Checked := True;
      cpRightCenter: OptRightCenter.Checked := True;
      cpLowerLeft: OptLowerLeft.Checked := True;
      cpLowerCenter: OptLowerCenter.Checked := True;
      cpLowerRight: OptLowerRight.Checked := True;
    end;
  finally
    FUpdatingControls := False;
  end;
end; {= TRzLabelEditDlg.UpdateControls =}


procedure TRzLabelEditDlg.EdtCaptionChange(Sender: TObject);
begin
  LblPreview.Caption := EdtCaption.Text;
end;


procedure TRzLabelEditDlg.CbxFontsChange(Sender: TObject);
begin
  LblPreview.Font.Name := CbxFonts.FontName;
end;

procedure TRzLabelEditDlg.ChkLightStyleClick(Sender: TObject);
begin
  LblPreview.LightTextStyle := ChkLightStyle.Checked;
end;



{= TRzLabelEditDlg.TrkPointSizeDrawTick                                       =}
{=   Owner draw method is used to display point values at each tick mark.     =}

procedure TRzLabelEditDlg.TrkPointSizeDrawTick(TrackBar: TRzTrackBar;
  Canvas: TCanvas; Location: TPoint; Index: Integer);
var
  W: Integer;
begin
  Canvas.Brush.Color := TrackBar.Color;
  Canvas.Font.Name := 'Tahoma';
  Canvas.Font.Size := 7;
  Canvas.Font.Style := [];
  W := Canvas.TextWidth( PointSizes[ Index ] );
  Canvas.TextOut( Location.X - (W div 2), 1, PointSizes[ Index ] );
end;


procedure TRzLabelEditDlg.TrkPointSizeChange(Sender: TObject);
begin
  LblPreview.Font.Size := StrToInt( PointSizes[ TrkPointSize.Position ] );
end;


procedure TRzLabelEditDlg.ChkBoldClick(Sender: TObject);
begin
  if ChkBold.Checked then
    LblPreview.Font.Style := LblPreview.Font.Style + [ fsBold ]
  else
    LblPreview.Font.Style := LblPreview.Font.Style - [ fsBold ]
end;


procedure TRzLabelEditDlg.ChkItalicClick(Sender: TObject);
begin
  if ChkItalic.Checked then
    LblPreview.Font.Style := LblPreview.Font.Style + [ fsItalic ]
  else
    LblPreview.Font.Style := LblPreview.Font.Style - [ fsItalic ]
end;


procedure TRzLabelEditDlg.ChkStrikeoutClick(Sender: TObject);
begin
  if ChkStrikeout.Checked then
    LblPreview.Font.Style := LblPreview.Font.Style + [ fsStrikeout ]
  else
    LblPreview.Font.Style := LblPreview.Font.Style - [ fsStrikeout ]
end;


procedure TRzLabelEditDlg.ChkUnderlineClick(Sender: TObject);
begin
  if ChkUnderline.Checked then
    LblPreview.Font.Style := LblPreview.Font.Style + [ fsUnderline ]
  else
    LblPreview.Font.Style := LblPreview.Font.Style - [ fsUnderline ]
end;


procedure TRzLabelEditDlg.GrpTextStyleClick(Sender: TObject);
begin
  LblPreview.TextStyle := TTextStyle( GrpTextStyle.ItemIndex );

  TrkShadow.Enabled := LblPreview.TextStyle = tsShadow;
  LblShadowDepth.Enabled := LblPreview.TextStyle = tsShadow;
end;


procedure TRzLabelEditDlg.TrkShadowChange(Sender: TObject);
begin
  LblPreview.ShadowDepth := TrkShadow.Position;
  LblShadowDepth.Caption := IntToStr( TrkShadow.Position );
end;


procedure TRzLabelEditDlg.EdtFontColorChange(Sender: TObject);
begin
  LblPreview.Font.Color := EdtFontColor.SelectedColor;
end;


procedure TRzLabelEditDlg.EdtHighlightColorChange(Sender: TObject);
begin
  LblPreview.HighlightColor := EdtHighlightColor.SelectedColor;
end;


procedure TRzLabelEditDlg.EdtShadowColorChange(Sender: TObject);
begin
  LblPreview.ShadowColor := EdtShadowColor.SelectedColor;
end;



procedure TRzLabelEditDlg.TrkAngleDrawTick(TrackBar: TRzTrackBar;
  Canvas: TCanvas; Location: TPoint; Index: Integer);
var
  W, Degree: Integer;
begin
  if Chk15Degrees.Checked then
    Degree := Index * 15
  else
    Degree := Index;

  if ( Degree mod 90 ) = 0 then
  begin
    Canvas.Brush.Color := TrackBar.Color;
    Canvas.Font.Name := 'Small Fonts';
    Canvas.Font.Size := 7;
    Canvas.Font.Style := [];
    W := Canvas.TextWidth( IntToStr( Degree ) );
    Canvas.TextOut( Location.X - (W div 2), 1, IntToStr( Degree ) );
  end;
end;


procedure TRzLabelEditDlg.Chk15DegreesClick(Sender: TObject);
begin
  if Chk15Degrees.Checked then
  begin
    TrkAngle.Position := TrkAngle.Position div 15;
    TrkAngle.Max := 24;
  end
  else
  begin
    TrkAngle.Max := 360;
    TrkAngle.Position := TrkAngle.Position * 15;
  end;
end;


procedure TRzLabelEditDlg.TrkAngleChange(Sender: TObject);
var
  Angle: Integer;
begin
  if Chk15Degrees.Checked then
    Angle := TrkAngle.Position * 15
  else
    Angle := TrkAngle.Position;
  LblAngle.Caption := IntToStr( Angle ) + '°';
  if not FNoAngleUpdate then
  begin
    if BtnNone.Down and not FUpdatingControls then
    begin
      BtnFlat.Down := True;
      BtnRotationClick( BtnFlat );
    end;
    LblPreview.Angle := Angle;
  end;
  CbxFonts.SelectedFont := LblPreview.Font;
end;


procedure TRzLabelEditDlg.BtnRotationClick(Sender: TObject);
var
  Enable: Boolean;
begin
  with TSpeedButton( Sender ) do
  begin
    LblPreview.Rotation := TRotation( Tag );

    if LblPreview.Rotation = roNone then
    begin
      FNoAngleUpdate := True;
      try
        TrkAngle.Position := 0;
      finally
        FNoAngleUpdate := False;
      end;
    end;

    if Tag <> 2 then
      OptCenter.Checked := True;

    Enable := Tag = 2;
    OptUpperLeft.Enabled := Enable;
    OptUpperCenter.Enabled := Enable;
    OptUpperRight.Enabled := Enable;
    OptLeftCenter.Enabled := Enable;
    OptCenter.Enabled := Enable;
    OptRightCenter.Enabled := Enable;
    OptLowerLeft.Enabled := Enable;
    OptLowerCenter.Enabled := Enable;
    OptLowerRight.Enabled := Enable;
  end;
end;


procedure TRzLabelEditDlg.OptCenterPointClick(Sender: TObject);
begin
  LblPreview.CenterPoint := TCenterPoint( TRadioButton( Sender ).Tag );
end;


procedure TRzLabelEditDlg.PgcFormatChanging(Sender: TObject;
  NewIndex: Integer; var AllowChange: Boolean);
begin
  if NewIndex = 1 then
  begin
    if Chk15Degrees.Checked then
      TrkAngle.Position := LblPreview.Angle div 15
    else
      TrkAngle.Position := LblPreview.Angle;
  end;
end;


end.
