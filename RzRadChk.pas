{===============================================================================
  RzRadChk Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzRadioButton        Custom radio button control--supports multi-line
                          captions, 3D text styles, custom glyphs
  TRzCheckBox           Custom check box control--supports multi-line captions,
                          3D text styles, custom glyphs


  Modification History
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * Fixed display problems when running under Right-To-Left locales.
    * Fixed display problems when running under 256 and 16-bit color depths.
    * Fixed problem of disappearing check marks and radio button circles when
      Highlight color is clTeal as is used in the Dessert color scheme.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Added GetHotTrackRect override.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Added HotTrack property.
    * Fixed problem with OnExit event not firing.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzRadChk;

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
  RzCommon,
  RzButton,
  ActnList,
  Menus;

type
  {============================================}
  {== TRzCustomGlyphButton Class Declaration ==}
  {============================================}

  TRzCustomGlyphButton = class;

  TRzCheckedActionLink = class( TWinControlActionLink )
  protected
    FClient: TRzCustomGlyphButton;
    procedure AssignClient( AClient: TObject ); override;
    function IsCheckedLinked: Boolean; override;
    procedure SetChecked( Value: Boolean ); override;
  end;

  TRzCheckedActionLinkClass = class of TRzCheckedActionLink;

  TRzCustomGlyphButton = class( TRzCustomButton, IRzCustomFramingNotification )
  private
    FAlignment: TLeftRight;
    FFrameColor: TColor; 
    FNumStates: Integer;
    FCustomGlyphs: TBitmap;
    FUseCustomGlyphs: Boolean;
    FTransparentColor: TColor;
    FWinMaskColor: TColor;
    FDisabledColor: TColor;
    FGlyphWidth: Integer;
    FGlyphHeight: Integer;
    FTabOnEnter: Boolean;

    FFrameController: TRzFrameController;

    procedure ReadOldFrameFlatProp( Reader: TReader );

    function IsCheckedStored: Boolean;

    { Internal Event Handlers }
    procedure CustomGlyphsChanged( Sender: TObject );

    { Message Handling Methods }
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure CMParentColorChanged( var Msg: TMessage ); message cm_ParentColorChanged;
    procedure WMEraseBkgnd( var Msg: TWMEraseBkgnd ); message wm_EraseBkgnd;
    procedure WMSize( var Msg: TWMSize ); message wm_Size;
  protected
    FBackgroundBmp: TBitmap;
    FUpdateBg: Boolean;

    procedure DefineProperties( Filer: TFiler ); override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    procedure ActionChange( Sender: TObject; CheckDefaults: Boolean ); override;
    function GetActionLinkClass: TControlActionLinkClass; override;

    procedure CustomFramingChanged; virtual;

    function CheckColor( Value: TColor ): TColor; virtual;
    procedure SelectGlyph( Glyph: TBitmap ); virtual; abstract;
    procedure UpdateDisplay; override;
    procedure RepaintDisplay; override;
    function GetHotTrackRect: TRect; override;

    procedure DrawGlyph( ACanvas: TCanvas ); virtual;
    procedure UpdateBackground;
    procedure Paint; override;

    procedure ExtractGlyph( Index: Integer; Bitmap, Source: TBitmap; W, H: Integer ); virtual;

    { Event Dispatch Methods }
    procedure KeyPress( var Key: Char ); override;

    { Property Access Methods }
    procedure SetAlignment( Value: TLeftRight ); virtual;
    function GetChecked: Boolean; virtual;
    procedure SetChecked( Value: Boolean ); virtual;
    procedure SetCustomGlyphs( Value: TBitmap ); virtual;
    procedure SetFrameColor( Value: TColor ); virtual;
    procedure SetFrameController( Value: TRzFrameController ); virtual;
    procedure SetUseCustomGlyphs( Value: Boolean ); virtual;
    procedure SetDisabledColor( Value: TColor ); virtual;
    procedure SetTransparent( Value: Boolean ); override;
    procedure SetTransparentColor( Value: TColor ); virtual;
    procedure SetWinMaskColor( Value: TColor ); virtual;

    { Property Declarations }
    property Alignment: TLeftRight
      read FAlignment
      write SetAlignment
      default taRightJustify;

    property Checked: Boolean
      read GetChecked
      write SetChecked
      stored IsCheckedStored
      default False;

    property CustomGlyphs: TBitmap
      read FCustomGlyphs
      write SetCustomGlyphs;

    property DisabledColor: TColor
      read FDisabledColor
      write SetDisabledColor
      default clBtnFace;

    property FrameColor: TColor
      read FFrameColor
      write SetFrameColor
      default clBtnShadow;

    property FrameController: TRzFrameController
      read FFrameController
      write SetFrameController;

    property TabOnEnter: Boolean
      read FTabOnEnter
      write FTabOnEnter
      default False;

    property TransparentColor: TColor
      read FTransparentColor
      write SetTransparentColor
      default clOlive;

    property UseCustomGlyphs: Boolean
      read FUseCustomGlyphs
      write SetUseCustomGlyphs
      default False;

    property WinMaskColor: TColor
      read FWinMaskColor
      write SetWinMaskColor
      default clLime;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function GetControlsAlignment: TAlignment; override;
  end;


  {======================================}
  {== TRzRadioButton Class Declaration ==}
  {======================================}

  TRzRadioButton = class( TRzCustomGlyphButton )
  private
    FAboutInfo: TRzAboutInfo;
    FUsingMouse: Boolean;
    FChecked: Boolean;

    { Message Handling Methods }
    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;
    procedure CMDialogKey( var Msg: TCMDialogKey ); message cm_DialogKey;
    procedure WMSetFocus( var Msg: TWMSetFocus ); message wm_SetFocus;
    procedure WMLButtonDblClk( var Msg: TWMLButtonDblClk ); message wm_LButtonDblClk;
  protected
    procedure ChangeState; override;
    procedure SelectGlyph( Glyph: TBitmap ); override;

    { Event Dispatch Methods }
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;

    { Property Access Methods }
    function GetChecked: Boolean; override;
    procedure SetChecked( Value: Boolean ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    { Inherited Properties & Events }
    property Action;
    property Alignment;
    property AlignmentVertical default avTop;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Checked;
    property Color;
    property Constraints;
    property CustomGlyphs;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FrameColor;
    property Font;
    property FrameController;
    property Height;
    property HelpContext;
    property HighlightColor;
    property Hint;
    property HotTrack;
    property HotTrackColor;
    property HotTrackColorType;
    property LightTextStyle;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property TextHighlightColor;
    property TextShadowColor;
    property TextShadowDepth;
    property ShowHint;
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property TextStyle;
    property Transparent;
    property TransparentColor;
    property UseCustomGlyphs;
    property Visible;
    property Width;
    property WinMaskColor;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;


  {=========================================}
  {== TRzCustomCheckBox Class Declaration ==}
  {=========================================}

  TRzCustomCheckBox = class( TRzCustomGlyphButton )
  private
    FAllowGrayed: Boolean;
    FState: TCheckBoxState;
    FKeyToggle: Boolean;

    { Message Handling Methods }
    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;
  protected
    procedure ChangeState; override;
    procedure SelectGlyph( Glyph: TBitmap ); override;

    { Event Dispatch Methods }
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure KeyUp( var Key: Word; Shift: TShiftState ); override;
    procedure DoExit; override;

    { Property Access Methods }
    function GetChecked: Boolean; override;
    procedure SetChecked( Value: Boolean ); override;
    procedure SetState( Value: TCheckBoxState ); virtual;

    { Property Declarations }
    property AllowGrayed: Boolean
      read FAllowGrayed
      write FAllowGrayed
      default False;

    property State: TCheckBoxState
      read FState
      write SetState;

  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure InitState( Value: TCheckBoxState );
  end;


  {== TRzCheckBox Class Declaration ==}

  TRzCheckBox = class( TRzCustomCheckBox )
  private
    FAboutInfo: TRzAboutInfo;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    { Inherited Properties & Events }
    property Action;
    property Alignment;
    property AlignmentVertical default avTop;
    property AllowGrayed;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Checked;
    property Color;
    property Constraints;
    property CustomGlyphs;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FrameColor;
    property Font;
    property FrameController;
    property Height;
    property HelpContext;
    property HighlightColor;
    property Hint;
    property HotTrack;
    property HotTrackColor;
    property HotTrackColorType;
    property LightTextStyle;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property TextHighlightColor;
    property TextShadowColor;
    property TextShadowDepth;
    property ShowHint;
    property State;
    property TabOnEnter;
    property TabOrder;
    property TabStop default True;
    property TextStyle;
    property Transparent;
    property TransparentColor;
    property UseCustomGlyphs;
    property Visible;
    property Width;
    property WinMaskColor;

    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

implementation

uses
  {$IFDEF VCL70_OR_HIGHER}
  Themes,
  {$ELSE}
  RzThemeSrv,
  {$ENDIF}
  RzCommonBitmaps,
  RzGrafx;

const
  DefaultGlyphWidth  = 13;
  DefaultGlyphHeight = 13;


{==================================}
{== TRzCheckedActionLink Methods ==}
{==================================}

procedure TRzCheckedActionLink.AssignClient( AClient: TObject );
begin
  inherited;
  FClient := AClient as TRzCustomGlyphButton;
end;

function TRzCheckedActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and
    ( FClient.Checked = ( Action as TCustomAction ).Checked );
end;

procedure TRzCheckedActionLink.SetChecked( Value: Boolean );
begin
  if IsCheckedLinked then
    FClient.Checked := Value;
end;


{&RT}
{==================================}
{== TRzCustomGlyphButton Methods ==}
{==================================}

constructor TRzCustomGlyphButton.Create( AOwner: TComponent );
begin
  inherited;
  FNumStates := 2;

  FGlyphWidth := DefaultGlyphWidth;
  FGlyphHeight := DefaultGlyphHeight;

  FCustomGlyphs := TBitmap.Create;
  FCustomGlyphs.OnChange := CustomGlyphsChanged;
  FUseCustomGlyphs := False;

  FTabOnEnter := False;

  FFrameColor := clBtnShadow;
  FDisabledColor := clBtnFace;
  FTransparentColor := clOlive;
  FWinMaskColor := clLime;

  FBackgroundBmp := TBitmap.Create;
  FUpdateBg := True;

  FAlignment := taRightJustify;
  ControlStyle := ControlStyle + [ csSetCaption, csReplicatable ];
end;


destructor TRzCustomGlyphButton.Destroy;
begin
  if FFrameController <> nil then
    FFrameController.RemoveControl( Self );

  FCustomGlyphs.Free;
  FBackgroundBmp.Free;
  inherited;
end;


procedure TRzCustomGlyphButton.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the Flat property was renamed to HotTrack
  Filer.DefineProperty( 'Flat', ReadOldFrameFlatProp, nil, False );
end;


procedure TRzCustomGlyphButton.ReadOldFrameFlatProp( Reader: TReader );
begin
  HotTrack := Reader.ReadBoolean;
end;


procedure TRzCustomGlyphButton.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( AComponent = FFrameController ) then
    FFrameController := nil;
end;


procedure TRzCustomGlyphButton.CustomFramingChanged;
begin
  if FFrameController.FrameVisible then
  begin
    FFrameColor := FFrameController.FrameColor;
    FDisabledColor := FFrameController.DisabledColor;
    Invalidate;
  end;
end;


function TRzCustomGlyphButton.GetControlsAlignment: TAlignment;
begin
  if not UseRightToLeftAlignment then
    Result := taRightJustify
  else if FAlignment = taRightJustify then
    Result := taLeftJustify
  else
    Result := taRightJustify;
end;


procedure TRzCustomGlyphButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited;

  if Sender is TCustomAction then
  begin
    with TCustomAction( Sender ) do
    begin
      if not CheckDefaults or ( Self.Checked = False ) then
        Self.Checked := Checked;
    end;
  end;
end;


function TRzCustomGlyphButton.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TRzCheckedActionLink;
end;


function TRzCustomGlyphButton.IsCheckedStored: Boolean;
begin
  Result := ( ActionLink = nil ) or not TRzCheckedActionLink( ActionLink ).IsCheckedLinked;
end;


function TRzCustomGlyphButton.GetChecked: Boolean;
begin
  Result := False;
end;

procedure TRzCustomGlyphButton.SetChecked( Value: Boolean );
begin
end;

procedure TRzCustomGlyphButton.CustomGlyphsChanged( Sender: TObject );
begin
  UseCustomGlyphs := not FCustomGlyphs.Empty;
  FUpdateBg := True;
  Invalidate;
end;


procedure TRzCustomGlyphButton.ExtractGlyph( Index: Integer; Bitmap, Source: TBitmap; W, H: Integer );
var
  DestRct: TRect;
begin
  DestRct := Rect( 0, 0, W, H );

  Bitmap.Width := W;
  Bitmap.Height := H;
  Bitmap.Canvas.CopyRect( DestRct, Source.Canvas, Rect( Index * W, 0, (Index + 1 ) * W, H ) );
end;


procedure TRzCustomGlyphButton.SetAlignment( Value: TLeftRight );
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;


procedure TRzCustomGlyphButton.SetCustomGlyphs( Value: TBitmap );
begin
  FCustomGlyphs.Assign( Value );
end;


procedure TRzCustomGlyphButton.SetFrameColor( Value: TColor );
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomGlyphButton.SetFrameController( Value: TRzFrameController );
begin
  if FFrameController <> nil then
    FFrameController.RemoveControl( Self );
  FFrameController := Value;
  if Value <> nil then
  begin
    Value.AddControl( Self );
    Value.FreeNotification( Self );
  end;
end;


procedure TRzCustomGlyphButton.SetUseCustomGlyphs( Value: Boolean );
begin
  if FUseCustomGlyphs <> Value then
  begin
    FUseCustomGlyphs := Value;
    if FUseCustomGlyphs then
    begin
      FGlyphWidth := FCustomGlyphs.Width div FNumStates;
      FGlyphHeight := FCustomGlyphs.Height;
    end
    else
    begin
      FGlyphWidth := DefaultGlyphWidth;
      FGlyphHeight := DefaultGlyphHeight;
    end;
    Invalidate;
  end;
end;


procedure TRzCustomGlyphButton.SetDisabledColor( Value: TColor );
begin
  if FDisabledColor <> Value then
  begin
    FDisabledColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomGlyphButton.SetTransparent( Value: Boolean );
begin
  FUpdateBg := True;
  inherited;
end;


procedure TRzCustomGlyphButton.SetTransparentColor( Value: TColor );
begin
  if FTransparentColor <> Value then
  begin
    FTransparentColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomGlyphButton.SetWinMaskColor( Value: TColor );
begin
  if FWinMaskColor <> Value then
  begin
    FWinMaskColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomGlyphButton.RepaintDisplay;
begin
  Paint;
end;


procedure TRzCustomGlyphButton.UpdateDisplay;
begin
  Paint;
end;


function TRzCustomGlyphButton.GetHotTrackRect: TRect;
var
  X, Y: Integer;
begin
  if FAlignment = taRightJustify then
    X := 0
  else
    X := Width - FGlyphWidth;

  Y := 0;
  case AlignmentVertical of
    avTop:
      Y := 2;

    avCenter:
      Y := ( Height - FGlyphHeight ) div 2;

    avBottom:
      Y := Height - FGlyphHeight - 2;
  end;

  Result := Rect( X, Y, X + FGlyphWidth, Y + FGlyphHeight );
end;


function TRzCustomGlyphButton.CheckColor( Value: TColor ): TColor;
begin
  // Need to check color against TransparentColor and WinMaskColor
  if ( ColorToRGB( Value ) = ColorToRGB( FTransparentColor ) ) or
     ( ColorToRGB( Value ) = ColorToRGB( FWinMaskColor ) ) or
     ( ColorToRGB( Value ) = ColorToRGB( clGray ) ) then
  begin
    Result := ColorToRGB( Value ) + 1;
  end
  else
    Result := Value;
end;


procedure TRzCustomGlyphButton.DrawGlyph( ACanvas: TCanvas );
var
  R, SrcRect: TRect;
  FGlyph, DestBmp, Dest2Bmp, TempBmp: TBitmap;
  X, Y: Integer;
begin
  if ACanvas = nil then
    ACanvas := Canvas;
  FGlyph := TBitmap.Create;
  FGlyph.Width := FGlyphWidth;
  FGlyph.Height := FGlyphHeight;
  try
    SelectGlyph( FGlyph );

    DestBmp := TBitmap.Create;
    Dest2Bmp := TBitmap.Create;
    TempBmp := TBitmap.Create;
    try
      if FAlignment = taRightJustify then
        X := 0
      else
        X := Width - FGlyphWidth;

      Y := 0;
      case AlignmentVertical of
        avTop:
          Y := 2;

        avCenter:
          Y := ( Height - FGlyphHeight ) div 2;

        avBottom:
          Y := Height - FGlyphHeight - 2;
      end;

      { Don't Forget to Set the Width and Height of Destination Bitmap }
      TempBmp.Width := FGlyphWidth;
      TempBmp.Height := FGlyphHeight;

      R := Rect( 0, 0, FGlyphWidth, FGlyphHeight );

      if FTransparent then
      begin
        SrcRect := Bounds( X, Y, FGlyphWidth, FGlyphHeight );
        TempBmp.Canvas.CopyMode := cmSrcCopy;
        TempBmp.Canvas.CopyRect( R, ACanvas, SrcRect );
        if ThemeServices.ThemesEnabled then
          DrawFullTransparentBitmap( TempBmp.Canvas, FGlyph, R, R, clBtnFace )
        else
          DrawFullTransparentBitmap( TempBmp.Canvas, FGlyph, R, R, FTransparentColor );
      end
      else
      begin
        TempBmp.Canvas.Brush.Color := Color;
        TempBmp.Canvas.BrushCopy( R, FGlyph, R, FTransparentColor );
      end;

      DestBmp.Width := FGlyphWidth;
      DestBmp.Height := FGlyphHeight;
      DestBmp.Canvas.Brush.Color := clWindow;
      DestBmp.Canvas.BrushCopy( R, TempBmp, R, FWinMaskColor );

      // Replace clGreen with alpha blend of background color
      Dest2Bmp.Width := FGlyphWidth;
      Dest2Bmp.Height := FGlyphHeight;
      Dest2Bmp.Canvas.Brush.Color := BlendColors( FFrameColor, ACanvas.Pixels[ 0, 0 ], 128 );
      Dest2Bmp.Canvas.BrushCopy( R, DestBmp, R, clGreen );

      ACanvas.Draw( X, Y, Dest2Bmp );
    finally
      DestBmp.Free;
      Dest2Bmp.Free;
      TempBmp.Free;
    end;
  finally
    FGlyph.Free;
  end;
end; {= TRzCustomGlyphButton.DrawGlyph =}


procedure TRzCustomGlyphButton.UpdateBackground;
begin
  // Save background image of entire control
  FBackgroundBmp.Width := Width;
  FBackgroundBmp.Height := Height;

  if FTransparent then
  begin
    // Parent image has already been copied to Canvas via TRzCustomButton.WMEraseBkgnd
    // So, simply copy current Canvas image into the FBackgroundBmp.Canvas
    FBackgroundBmp.Canvas.CopyRect( ClientRect, Canvas, ClientRect );
  end
  else
  begin
    FBackgroundBmp.Canvas.Brush.Color := Color;
    FBackgroundBmp.Canvas.FillRect( ClientRect );
  end;
  FUpdateBg := False;
end;


procedure TRzCustomGlyphButton.Paint;
var
  R: TRect;
  W: Integer;
  MemImage: TBitmap;
begin
  MemImage := TBitmap.Create;
  try
    { Make memory Bitmap same size as client rect }
    MemImage.Height := Height;
    MemImage.Width := Width;

    MemImage.Canvas.Font := Font;
    MemImage.Canvas.Brush.Color := Color;

    if FUpdateBg then
      UpdateBackground;
    MemImage.Canvas.CopyRect( ClientRect, FBackgroundBmp.Canvas, ClientRect );

    DrawGlyph( MemImage.Canvas );

    R := ClientRect;
    InflateRect( R, -1, -1 );
    if FAlignment = taRightJustify then
      Inc( R.Left, FGlyphWidth + 4 )
    else
      Dec( R.Right, FGlyphWidth + 4 );

    { Draw Caption }
    Draw3DText( MemImage.Canvas, R, dt_WordBreak or dt_ExpandTabs );

    InflateRect( R, 1, 1 );
    if Focused and ( Caption <> '' ) then
    begin
      W := Min( R.Right - R.Left, MemImage.Canvas.TextWidth( Trim( Caption ) ) + 3 );
      if not UseRightToLeftAlignment then
        R.Right := R.Left + W
      else
        R.Left := R.Right - W;
      DrawFocusBorder( MemImage.Canvas, R );
    end;

    Canvas.CopyMode := cmSrcCopy;
    Canvas.Draw( 0, 0, MemImage );
  finally
    MemImage.Free;
  end;
end; {= TRzCustomGlyphButton.Paint =}


procedure TRzCustomGlyphButton.KeyPress( var Key: Char );
begin
  if FTabOnEnter and ( Ord( Key ) = vk_Return ) then
  begin
    Key := #0;
    PostMessage( Handle, wm_KeyDown, vk_Tab, 0 );
  end
  else
    inherited;
end;


procedure TRzCustomGlyphButton.WMEraseBkgnd( var Msg: TWMEraseBkgnd );
begin
  inherited;
  FUpdateBg := True;
end;


procedure TRzCustomGlyphButton.WMSize( var Msg: TWMSize );
begin
  inherited;
  FUpdateBg := True;
end;


procedure TRzCustomGlyphButton.CMEnabledChanged( var Msg: TMessage );
begin
  inherited;
  FUpdateBg := True;
  Invalidate;
end;


procedure TRzCustomGlyphButton.CMParentColorChanged( var Msg: TMessage );
begin
  inherited;
  FUpdateBg := True;
  Invalidate;
end;


{============================}
{== TRzRadioButton Methods ==}
{============================}

constructor TRzRadioButton.Create( AOwner: TComponent );
begin
  inherited;
  AlignmentVertical := avTop;
  FChecked := False;
  FUsingMouse := False;
  FNumStates := 6;
  TabStop := False;
  {&RCI}
end;


destructor TRzRadioButton.Destroy;
begin
  inherited;
end;


function TRzRadioButton.GetChecked: Boolean;
begin
  Result := FChecked;
end;

procedure TRzRadioButton.SetChecked( Value: Boolean );

  procedure TurnSiblingsOff;
  var
    I: Integer;
    Sibling: TControl;
  begin
    if Parent <> nil then
      with Parent do
      begin
        for I := 0 to ControlCount - 1 do
        begin
          Sibling := Controls[ I ];
          if ( Sibling <> Self ) and ( Sibling is TRzRadioButton ) then
            TRzRadioButton( Sibling ).SetChecked( False );
        end;
      end;
  end;

begin
  {&RV}
  if FChecked <> Value then
  begin
    FChecked := Value;
    TabStop := Value;
    UpdateDisplay;
    if Value then
    begin
      TurnSiblingsOff;
      Click;
    end;
  end;
end;


procedure TRzRadioButton.ChangeState;
begin
  if not FChecked then
    SetChecked( True );
end;


procedure TRzRadioButton.SelectGlyph( Glyph: TBitmap );
const
  BaseColors: array[ 0..12 ] of TColor = ( clWhite,   // Interior (i.e. clWindow)
                                           clBlack,   // Main Border
                                           clGreen,   // Border Lighter
                                           clGray,    // Border Alpha 1 with DarkHotTrack
                                           clPurple,  // Border Alpha 1 with LightHotTrack
                                           clMaroon,  // Border Alpha 2 with DarkHotTrack
                                           clLime,    // Border Alpha 2 with LightHotTrack
                                           clRed,     // DarkHotTrack
                                           clFuchsia, // LightHotTrack
                                           clYellow,  // LightHotTrack Alpha with Interior
                                           clNavy,    // HighlightColor
                                           clBlue,    // HighlightColor Alpha with Interior
                                           clAqua );  // Border Alpha with background

  ResNames: array[ Boolean ] of PChar = ( 'RZCOMMON_RADIOBUTTON_UNCHECKED',
                                          'RZCOMMON_RADIOBUTTON_CHECKED' );
var
  R: TRect;
  Flags: Integer;
  DestBmp, SourceBmp: TBitmap;
  HotTrackLight, HotTrackDark, DownColor: TColor;
  ReplaceColors: array[ 0..12 ] of TColor;
  H: Byte;
  ElementDetails: TThemedElementDetails;
begin
  R := Rect( 0, 0, FGlyphWidth, FGlyphHeight );

  if not FUseCustomGlyphs then
  begin
    // Test for XP themes first...
    if ThemeServices.ThemesEnabled then
    begin
      if FChecked then
      begin
        if Enabled then
        begin
          if FShowDownVersion then
            ElementDetails := ThemeServices.GetElementDetails( tbRadioButtonCheckedPressed )
          else if FMouseOverButton then
            ElementDetails := ThemeServices.GetElementDetails( tbRadioButtonCheckedHot )
          else
            ElementDetails := ThemeServices.GetElementDetails( tbRadioButtonCheckedNormal );
        end
        else
        begin
          ElementDetails := ThemeServices.GetElementDetails( tbRadioButtonCheckedDisabled );
        end;
      end
      else
      begin
        if Enabled then
        begin
          if FShowDownVersion then
            ElementDetails := ThemeServices.GetElementDetails( tbRadioButtonUncheckedPressed )
          else if FMouseOverButton then
            ElementDetails := ThemeServices.GetElementDetails( tbRadioButtonUncheckedHot )
          else
            ElementDetails := ThemeServices.GetElementDetails( tbRadioButtonUncheckedNormal );
        end
        else
        begin
          ElementDetails := ThemeServices.GetElementDetails( tbRadioButtonUncheckedDisabled );
        end;
      end;

      Glyph.Canvas.Brush.Color := Self.Color;
      Glyph.Canvas.FillRect( R );
      ThemeServices.DrawElement( Glyph.Canvas.Handle, ElementDetails, R );
    end
    else if HotTrack then
    begin
      if FullColorSupport then
      begin
        H := ColorHue( HotTrackColor );
        if HotTrackColorType = htctComplement then
        begin
          if H >= 120 then
            H := H - 120
          else
            H := H + 120;
          HotTrackLight := HSLToColor( H, 220, 180 );
          HotTrackDark := DarkerColor( HotTrackLight, 30 );
        end
        else
        begin
          HotTrackLight := LighterColor( HotTrackColor, 30 );
          HotTrackDark := DarkerColor( HotTrackColor, 30 );
        end;

        DownColor := DarkerColor( clWindow, 20 );

        ReplaceColors[ 0 ] := clWindow;                                                // Interior (i.e. clWindow)
        ReplaceColors[ 1 ] := CheckColor( FFrameColor );                               // Main Border
        ReplaceColors[ 2 ] := LighterColor( FFrameColor, 10 );                         // Border Lighter
        ReplaceColors[ 3 ] := BlendColors( FFrameColor, clWindow, 128 );               // Border Alpha 1 with DarkHotTrack
        ReplaceColors[ 4 ] := ReplaceColors[ 3 ];                                      // Border Alpha 1 with LightHotTrack
        ReplaceColors[ 5 ] := BlendColors( FFrameColor, clWindow, 80 );                // Border Alpha 2 with DarkHotTrack
        ReplaceColors[ 6 ] := ReplaceColors[ 5 ];                                      // Border Alpha 2 with LightHotTrack
        ReplaceColors[ 7 ] := clWindow;                                                // DarkHotTrack
        ReplaceColors[ 8 ] := clWindow;                                                // LightHotTrack
        ReplaceColors[ 9 ] := clWindow;                                                // LightHotTrack Alpha with Interior
        ReplaceColors[ 10 ] := CheckColor( HighlightColor );                           // HighlightColor
        ReplaceColors[ 11 ] := BlendColors( HighlightColor, clWindow, 153 );           // HighlightColor Alpha with Interior
        ReplaceColors[ 12 ] := clGreen;                                                // Border Alpha with background
      end
      else
      begin
        HotTrackLight := clWindow;
        HotTrackDark := clWindow;
        DownColor := clWindow;
        ReplaceColors[ 0 ] := clWindow;                                                // Interior (i.e. clWindow)
        ReplaceColors[ 1 ] := CheckColor( FFrameColor );                               // Main Border
        ReplaceColors[ 2 ] := ReplaceColors[ 1 ];                                      // Border Lighter
        ReplaceColors[ 3 ] := clWindow;                                                // Border Alpha 1 with DarkHotTrack
        ReplaceColors[ 4 ] := clWindow;                                                // Border Alpha 1 with LightHotTrack
        ReplaceColors[ 5 ] := clWindow;                                                // Border Alpha 2 with DarkHotTrack
        ReplaceColors[ 6 ] := clWindow;                                                // Border Alpha 2 with LightHotTrack
        ReplaceColors[ 7 ] := clWindow;                                                // DarkHotTrack
        ReplaceColors[ 8 ] := clWindow;                                                // LightHotTrack
        ReplaceColors[ 9 ] := clWindow;                                                // LightHotTrack Alpha with Interior
        ReplaceColors[ 10 ] := CheckColor( HighlightColor );                           // HighlightColor
        ReplaceColors[ 11 ] := ReplaceColors[ 10 ];                                    // HighlightColor Alpha with Interior
        ReplaceColors[ 12 ] := ReplaceColors[ 1 ];                                     // Border Alpha with background
      end;

      if Enabled then
      begin
        if FullColorSupport then
        begin
          if FShowDownVersion then
          begin
            ReplaceColors[ 0 ] := DownColor;
            ReplaceColors[ 3 ] := BlendColors( FFrameColor, DownColor, 128 );
            ReplaceColors[ 4 ] := ReplaceColors[ 3 ];
            ReplaceColors[ 5 ] := BlendColors( FFrameColor, DownColor, 80 );
            ReplaceColors[ 6 ] := ReplaceColors[ 5 ];
            ReplaceColors[ 7 ] := DownColor;
            ReplaceColors[ 8 ] := DownColor;
            ReplaceColors[ 9 ] := DownColor;
            ReplaceColors[ 11 ] := BlendColors( HighlightColor, DownColor, 153 );
          end
          else if FMouseOverButton then
          begin
            ReplaceColors[ 3 ] := BlendColors( FFrameColor, HotTrackDark, 128 );        // Border Alpha 1 with DarkHotTrack
            ReplaceColors[ 4 ] := BlendColors( FFrameColor, HotTrackLight, 128 );       // Border Alpha 1 with LightHotTrack
            ReplaceColors[ 5 ] := BlendColors( FFrameColor, HotTrackDark, 80 );        // Border Alpha 2 with DarkHotTrack
            ReplaceColors[ 6 ] := BlendColors( FFrameColor, HotTrackLight, 80 );       // Border Alpha 2 with LightHotTrack
            ReplaceColors[ 7 ] := HotTrackDark;                                        // DarkHotTrack
            ReplaceColors[ 8 ] := HotTrackLight;                                       // LightHotTrack
            ReplaceColors[ 9 ] := BlendColors( HotTrackLight, clWindow, 128 );         // LightHotTrack Alpha with Interior
          end;
        end;
      end
      else // Disabled
      begin
        ReplaceColors[ 0 ] := FDisabledColor;
        ReplaceColors[ 3 ] := BlendColors( FFrameColor, FDisabledColor, 128 );
        ReplaceColors[ 4 ] := ReplaceColors[ 3 ];
        ReplaceColors[ 5 ] := BlendColors( FFrameColor, FDisabledColor, 80 );
        ReplaceColors[ 6 ] := ReplaceColors[ 5 ];
        ReplaceColors[ 7 ] := FDisabledColor;
        ReplaceColors[ 8 ] := FDisabledColor;
        ReplaceColors[ 9 ] := FDisabledColor;
        ReplaceColors[ 10 ] := clBtnShadow;
        ReplaceColors[ 11 ] := BlendColors( HighlightColor, FDisabledColor, 128 );
      end;

      Glyph.Handle := CreateMappedRes( HInstance, ResNames[ Checked ], BaseColors, ReplaceColors  );
    end
    else // Default
    begin
      if FChecked then
        Flags := dfcs_ButtonRadio or dfcs_Checked
      else
        Flags := dfcs_ButtonRadio;

      if FShowDownVersion then
        Flags := Flags or dfcs_Pushed;
      if not Enabled then
        Flags := Flags or dfcs_Inactive;

      Flags := Flags or dfcs_Transparent;

      Glyph.Canvas.Brush.Color := FTransparentColor;
      Glyph.Canvas.FillRect( R );
      DrawFrameControl( Glyph.Canvas.Handle, R, dfc_Button, Flags );
    end;
  end
  else // Using Custom Glyphs
  begin
    SourceBmp := FCustomGlyphs;

    DestBmp := TBitmap.Create;
    try
      if Enabled then
      begin
        if FChecked then
          if FShowDownVersion then
            ExtractGlyph( 3, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight )
          else
            ExtractGlyph( 1, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight )
        else
          if FShowDownVersion then
            ExtractGlyph( 2, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight )
          else
            ExtractGlyph( 0, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );
      end
      else
      begin
        if FChecked then
          ExtractGlyph( 5, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight )
        else
          ExtractGlyph( 4, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );
      end;

      Glyph.Assign( DestBmp );

    finally
      DestBmp.Free;
    end;
  end;
end; {= TRzRadioButton.SelectGlyph =}


procedure TRzRadioButton.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  FUsingMouse := True;
  inherited;
end;


procedure TRzRadioButton.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  FUsingMouse := False;
end;


procedure TRzRadioButton.CMDialogChar( var Msg: TCMDialogChar );
begin
  with Msg do
  begin
    if IsAccel( CharCode, Caption ) and CanFocus then
    begin
      SetFocus;
      Result := 1;
    end
    else
      inherited;
  end;
end;


procedure TRzRadioButton.CMDialogKey( var Msg: TCMDialogKey );
begin
  with Msg do
  begin
    if ( CharCode = vk_Down ) and ( KeyDataToShiftState( KeyData ) = [] ) and CanFocus then
    begin
      Click;
      Result := 1;
    end
    else
      inherited;
  end;
end;


procedure TRzRadioButton.WMSetFocus( var Msg: TWMSetFocus );
begin
  inherited;
  if not FUsingMouse then
    SetChecked( True );
end;

procedure TRzRadioButton.WMLButtonDblClk( var Msg: TWMLButtonDblClk );
begin
  inherited;
  DblClick;
end;


{===============================}
{== TRzCustomCheckBox Methods ==}
{===============================}

constructor TRzCustomCheckBox.Create( AOwner: TComponent );
begin
  inherited;
  AlignmentVertical := avTop;
  FNumStates := 9;
  FState := cbUnchecked;
  FAllowGrayed := False;
  {&RCI}
end;


destructor TRzCustomCheckBox.Destroy;
begin
  inherited;
end;


procedure TRzCustomCheckBox.ChangeState;
begin
  {&RV}
  case State of
    cbUnchecked:
      if FAllowGrayed then
        State := cbGrayed
      else
        State := cbChecked;

    cbChecked:
      State := cbUnchecked;

    cbGrayed:
      State := cbChecked;
  end;
end;


function TRzCustomCheckBox.GetChecked: Boolean;
begin
  Result := FState = cbChecked;
end;


procedure TRzCustomCheckBox.SetChecked( Value: Boolean );
begin
  if Value then
    State := cbChecked
  else
    State := cbUnchecked;
end;


procedure TRzCustomCheckBox.SetState( Value: TCheckBoxState );
begin
  if FState <> Value then
  begin
    FState := Value;
    UpdateDisplay;
    Click;
  end;
end;


procedure TRzCustomCheckBox.InitState( Value: TCheckBoxState );
begin
  if FState <> Value then
  begin
    FState := Value;
    UpdateDisplay;
    { This method does not generate the OnClick event }
  end;
end;


procedure TRzCustomCheckBox.KeyDown( var Key: Word; Shift: TShiftState );
begin
  inherited;
  if Key = vk_Escape then
  begin
    FKeyToggle := False;
    FShowDownVersion := False;
    UpdateDisplay;
  end
  else if Key = vk_Space then
  begin
    FKeyToggle := True;
    FShowDownVersion := True;
    UpdateDisplay;
  end;
end;


procedure TRzCustomCheckBox.KeyUp( var Key: Word; Shift: TShiftState );
begin
  inherited;
  if Key = vk_Space then
  begin
    FShowDownVersion := False;
    if FKeyToggle then
      ChangeState;
    UpdateDisplay;
  end;
end;


procedure TRzCustomCheckBox.DoExit;
begin
  inherited;
  FShowDownVersion := False;
  UpdateDisplay;
end;


procedure TRzCustomCheckBox.SelectGlyph( Glyph: TBitmap );
const
  BaseColors: array[ 0..4 ] of TColor = ( clWhite, clGray, clRed, clFuchsia, clBlue );
  ResNames: array[ TCheckBoxState ] of PChar = ( 'RZCOMMON_CHECKBOX_UNCHECKED',
                                                 'RZCOMMON_CHECKBOX_CHECKED',
                                                 'RZCOMMON_CHECKBOX_GRAYED' );
var
  R: TRect;
  Flags: Integer;
  DestBmp, SourceBmp: TBitmap;
  HotTrackLight, HotTrackDark, DownColor: TColor;
  ReplaceColors: array[ 0..4 ] of TColor;
  H: Byte;
  ElementDetails: TThemedElementDetails;
begin
  R := Rect( 0, 0, FGlyphWidth, FGlyphHeight );

  if not FUseCustomGlyphs then
  begin
    // Test for XP Themes first...
    if ThemeServices.ThemesEnabled then
    begin
      case FState of
        cbUnchecked:
        begin
          if Enabled then
          begin
            if FShowDownVersion then
              ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxUncheckedPressed )
            else if FMouseOverButton then
              ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxUncheckedHot )
            else
              ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxUncheckedNormal );
          end
          else
          begin
            ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxUncheckedDisabled );
          end;
        end;

        cbChecked:
        begin
          if Enabled then
          begin
            if FShowDownVersion then
              ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxCheckedPressed )
            else if FMouseOverButton then
              ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxCheckedHot )
            else
              ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxCheckedNormal );
          end
          else
          begin
            ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxCheckedDisabled );
          end;
        end;

        cbGrayed:
        begin
          if Enabled then
          begin
            if FShowDownVersion then
              ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxMixedPressed )
            else if FMouseOverButton then
              ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxMixedHot )
            else
              ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxMixedNormal );
          end
          else
          begin
            ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxMixedDisabled );
          end;
        end;
      end;

      ThemeServices.DrawParentBackground( Handle, Glyph.Canvas.Handle, @ElementDetails, True, @R );
      ThemeServices.DrawElement( Glyph.Canvas.Handle, ElementDetails, R );
    end
    else if HotTrack then
    begin
      if FullColorSupport then
      begin
        H := ColorHue( HotTrackColor );
        if HotTrackColorType = htctComplement then
        begin
          if H >= 120 then
            H := H - 120
          else
            H := H + 120;
          HotTrackLight := HSLToColor( H, 220, 180 );
          HotTrackDark := DarkerColor( HotTrackLight, 30 );
        end
        else
        begin
          HotTrackLight := LighterColor( HotTrackColor, 30 );
          HotTrackDark := DarkerColor( HotTrackColor, 30 );
        end;

        DownColor := DarkerColor( clWindow, 20 );
      end
      else
      begin
        HotTrackLight := clWindow;
        HotTrackDark := clWindow;
        DownColor := clWindow;
      end;

      ReplaceColors[ 0 ] := clWindow;
      ReplaceColors[ 1 ] := FFrameColor;
      ReplaceColors[ 2 ] := clWindow;
      ReplaceColors[ 3 ] := clWindow;
      ReplaceColors[ 4 ] := CheckColor( HighlightColor );

      if Enabled then
      begin
        if FShowDownVersion then
        begin
          ReplaceColors[ 0 ] := DownColor;
          ReplaceColors[ 2 ] := DownColor;
          ReplaceColors[ 3 ] := DownColor;
        end
        else if FMouseOverButton then
        begin
          ReplaceColors[ 2 ] := HotTrackDark;
          ReplaceColors[ 3 ] := HotTrackLight;
        end;
      end
      else // Disabled
      begin
        ReplaceColors[ 0 ] := FDisabledColor;
        ReplaceColors[ 2 ] := FDisabledColor;
        ReplaceColors[ 3 ] := FDisabledColor;
        ReplaceColors[ 4 ] := clBtnShadow;
      end;

      Glyph.Handle := CreateMappedRes( HInstance, ResNames[ FState ], BaseColors, ReplaceColors  );
    end
    else // Default
    begin
      Flags := 0;
      case FState of
        cbUnchecked: Flags := dfcs_ButtonCheck;
        cbChecked: Flags := dfcs_ButtonCheck or dfcs_Checked;
        cbGrayed: Flags := dfcs_Button3State or dfcs_Checked;
      end;
      if FShowDownVersion then
        Flags := Flags or dfcs_Pushed;
      if not Enabled then
        Flags := Flags or dfcs_Inactive;

      DrawFrameControl( Glyph.Canvas.Handle, R, dfc_Button, Flags );
    end;
  end
  else // Use Custom Glyphs
  begin
    SourceBmp := FCustomGlyphs;

    DestBmp := TBitmap.Create;
    try
      if Enabled then
      begin
        case FState of
          cbUnchecked:
            if FShowDownVersion then
              ExtractGlyph( 3, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight )
            else
              ExtractGlyph( 0, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );

          cbChecked:
            if FShowDownVersion then
              ExtractGlyph( 4, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight )
            else
              ExtractGlyph( 1, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );

          cbGrayed:
            if FShowDownVersion then
              ExtractGlyph( 5, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight )
            else
              ExtractGlyph( 2, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );
        end;
      end
      else
      begin
        case FState of
          cbUnchecked:
            ExtractGlyph( 6, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );

          cbChecked:
            ExtractGlyph( 7, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );

          cbGrayed:
            ExtractGlyph( 8, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );
        end;
      end;

      Glyph.Assign( DestBmp );

    finally
      DestBmp.Free;
    end;
  end;
end; {= TRzCustomCheckBox.SelectGlyph =}



procedure TRzCustomCheckBox.CMDialogChar( var Msg: TCMDialogChar );
begin
  with Msg do
  begin
    if IsAccel( CharCode, Caption ) and CanFocus then
    begin
      Windows.SetFocus( Handle );
      if Focused then
      begin
        ChangeState;
        UpdateDisplay;
      end;
      Result := 1;
    end
    else
      inherited;
  end;
end;


{&RUIF}
end.
