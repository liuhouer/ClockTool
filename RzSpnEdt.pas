{===============================================================================
  RzSpnEdt Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzRapidFireButton    TSpeedButton descendant that generates OnClick events as
                          button is held down.
  TRzSpinButtons        Compound component with two TRzRapidFireButtons--Up/Down
                          or Left/Right.
  TRzSpinEdit           Enhanced TRzEdit that embeds a TRzSpinButtons component.
                          Used for cycling through numeric values (Integer and
                          Floating-point).
  TRzSpinner            Alternate control for cycling through integer values.
                          Buttons are on left and right sides of display area.


  Modification History
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Fixed problem in CMFontChanged method where SetEditRect could be called
      before a window handle has been allocated for the TRzSpinEdit.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * System cursor (IDC_HAND) is now used in TRzSpinner instead of the custom
      hand cursor when running under Windows 98 or higher.
  ------------------------------------------------------------------------------
  3.0.5  (24 Mar 2003)
    * The color of flat buttons in TRzSpinEdit are now adjusted appropriately
      when the control is disabled and re-enabled.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Added IsColorStored and IsFocusColorStored methods so that if control is
      disabled at design-time the Color and FocusColor properties are not
      streamed with the disabled color value.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    << TRzSpinEdit >>
    * Fixed display problem when button clicked and focus taken away by an
      exception.
    * Fixed problem where changing the font color in the OnExit and OnEnter
      events caused the text to disappear.
    * The OnChange event is no longer fired when the TRzDBSpinEdit control
      receives the keyboard focus.
    * The Buttons are now placed on the left side of the control for
      Right-To-Left locales.
    * Fixed problem where disabling the control did not cause the buttons to
      appear disabled.

    << TRzRapidFireButton >>
    * Added ScrollStyle property, which allows the user to easily set the glyph
      of the button to a scroll arrow.

    << TRzSpinButtons >>
    * Fixed display problem when button clicked and focus taken away by an
      exception.

    << TRzSpinner >>
    * Redesigned TRzSpinner to remove embedded controls. Also can use an image
      for button images.
    * Fixed display problem when button clicked and focus taken away by an
      exception.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzSpnEdt;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Messages,
  Windows,
  Classes,
  StdCtrls,
  ExtCtrls,
  Controls,
  SysUtils,
  Forms,
  Graphics,
  Menus,
  Mask,
  RzEdit,
  Buttons,
  ImgList,
  RzButton,
  RzCommon;


type
  {==========================================}
  {== TRzRapidFireButton Class Declaration ==}
  {==========================================}

  TRzRapidFireStyle = ( rfFocusRect, rfAllowTimer );
  TRzRapidFireStyles = set of TRzRapidFireStyle;

  TRzRapidFireButton = class( TSpeedButton )
  private
    FAboutInfo: TRzAboutInfo;
    FRepeatTimer: TTimer;
    FInitialDelay: Word;
    FDelay: Word;
    FStyle: TRzRapidFireStyles;
    FScrollStyle: TRzScrollStyle;

    { Internal Event Handlers }
    procedure TimerExpired( Sender: TObject );
  protected
    procedure Paint; override;
    procedure AssignArrowGlyph;

    { Event Dispatch Methods }
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;

    { Property Access Methods }
    procedure SetScrollStyle( Value: TRzScrollStyle ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    property Style: TRzRapidFireStyles
      read FStyle
      write FStyle;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Delay: Word
      read FDelay
      write FDelay
      default 100;

    property InitialDelay: Word
      read FInitialDelay
      write FInitialDelay
      default 400;

    property ScrollStyle: TRzScrollStyle
      read FScrollStyle
      write SetScrollStyle
      default scsNone;
  end;


  {======================================}
  {== TRzSpinButtons Class Declaration ==}
  {======================================}

  TSpinDirection = ( sdUpDown, sdLeftRight );
  TSpinButtonType = ( sbUp, sbDown );
  TSpinChangingEvent = procedure( Sender: TObject;
                                  var AllowChange: Boolean ) of object;
  TSpinButtonEvent = procedure( Sender: TObject;
                                Button: TSpinButtonType ) of object;

  TRzSpinButtons = class( TWinControl )
  private
    FAboutInfo: TRzAboutInfo;
    FDirection: TSpinDirection;
    FOrientation: TOrientation;
    FUpRightButton: TRzControlButton;
    FDownLeftButton: TRzControlButton;
    FFocusedButton: TRzControlButton;

    FFocusControl: TWinControl;
    FFlat: Boolean;
    FOnUpRightClick: TNotifyEvent;
    FOnDownLeftClick: TNotifyEvent;

    { Message Handling Methods }
    procedure WMSize( var Msg: TWMSize );  message wm_Size;
    procedure WMGetDlgCode( var Msg: TWMGetDlgCode ); message wm_GetDlgCode;
  protected
    FCustomUpRightGlyph: Boolean;
    FCustomDownLeftGlyph: Boolean;

    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    function CreateButton: TRzControlButton; virtual;
    procedure BtnClickHandler( Sender: TObject ); virtual;
    procedure BtnMouseDownHandler( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); virtual;
    procedure BtnGlyphChangeHandler( Sender: TObject ); virtual;

    procedure AdjustDimensions( var W, H: Integer ); virtual;

    { Event Dispatch Methods }
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure UpRightClick; dynamic;
    procedure DownLeftClick; dynamic;

    { Property Access Methods }
    procedure SetDirection( Value: TSpinDirection ); virtual;
    function GetAllEnabled: Boolean; virtual;
    procedure SetAllEnabled( Value: Boolean ); virtual;
    function GetColor: TColor; virtual;
    procedure SetColor( Value: TColor ); virtual;
    procedure SetFlat( Value: Boolean ); virtual;
    procedure SetOrientation( Value: TOrientation ); virtual;

    function GetUpRightGlyph: TBitmap; virtual;
    procedure SetUpRightGlyph( Value: TBitmap ); virtual;
    function GetDownLeftGlyph: TBitmap; virtual;
    procedure SetDownLeftGlyph( Value: TBitmap ); virtual;
    function GetUpRightNumGlyphs: TNumGlyphs; virtual;
    procedure SetUpRightNumGlyphs( Value: TNumGlyphs ); virtual;
    function GetDownLeftNumGlyphs: TNumGlyphs; virtual;
    procedure SetDownLeftNumGlyphs( Value: TNumGlyphs ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure SetBounds( ALeft, ATop, AWidth, AHeight: Integer ); override;

    property UpRightButton: TRzControlButton
      read FUpRightButton;

    property DownLeftButton: TRzControlButton
      read FDownLeftButton;

    property CustomUpRightGlyph: Boolean
      read FCustomUpRightGlyph;

    property CustomDownLeftGlyph: Boolean
      read FCustomDownLeftGlyph;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Color: TColor
      read GetColor
      write SetColor
      default clBtnFace;

    property Direction: TSpinDirection
      read FDirection
      write SetDirection
      default sdUpDown;

    property Enabled: Boolean
      read GetAllEnabled
      write SetAllEnabled
      default True;

    property Flat: Boolean
      read FFlat
      write SetFlat
      default False;

    property FocusControl: TWinControl
      read FFocusControl
      write FFocusControl;

    property GlyphUpRight: TBitmap
      read GetUpRightGlyph
      write SetUpRightGlyph
      stored FCustomUpRightGlyph;

    property GlyphDownLeft: TBitmap
      read GetDownLeftGlyph
      write SetDownLeftGlyph
      stored FCustomDownLeftGlyph;

    property NumGlyphsUpRight: TNumGlyphs
      read GetUpRightNumGlyphs
      write SetUpRightNumGlyphs
      stored FCustomUpRightGlyph
      default 2;

    property NumGlyphsDownLeft: TNumGlyphs
      read GetDownLeftNumGlyphs
      write SetDownLeftNumGlyphs
      stored FCustomDownLeftGlyph
      default 2;

    property Orientation: TOrientation
      read FOrientation
      write SetOrientation
      default orVertical;

    property OnDownLeftClick: TNotifyEvent
      read FOnDownLeftClick
      write FOnDownLeftClick;

    property OnUpRightClick: TNotifyEvent
      read FOnUpRightClick
      write FOnUpRightClick;

    { Inherited Properties & Events }
    property Align;
    property Anchors;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnStartDock;
    property OnStartDrag;
  end;


  {===================================}
  {== TRzSpinEdit Class Declaration ==}
  {===================================}

  TRzSpinEdit = class( TRzCustomEdit )
  private
    FAboutInfo: TRzAboutInfo;
    FAllowKeyEdit: Boolean;
    FAllowBlank: Boolean;
    FBlankValue: Extended;
    FButtons: TRzSpinButtons;
    FButtonWidth: Integer;
    FCheckRange: Boolean;
    FDecimals: Byte;
    FIncrement: Extended;
    FIntegersOnly: Boolean;
    FMin: Extended;
    FMax: Extended;
    FPageSize: Extended;
    FFlatButtonColor: TColor;

    FOnChanging: TSpinChangingEvent;
    FOnButtonClick: TSpinButtonEvent;

    { Message Handling Methods }
    procedure WMSize( var Msg: TWMSize ); message wm_Size;
    procedure CMEnter( var Msg: TCMEnter ); message cm_Enter;
    procedure CMExit( var Msg: TCMExit ); message cm_Exit;
    procedure WMPaste( var Msg: TWMPaste ); message wm_Paste;
    procedure WMCut( var Msg: TWMCut ); message wm_Cut;
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
  protected
    procedure CreateParams( var Params: TCreateParams ); override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure DefineProperties( Filer: TFiler ); override;

    procedure UpdateFrame( ViaMouse, InFocus: Boolean ); override;

    function IsCustomDownGlyph: Boolean;
    function IsCustomUpGlyph: Boolean;
    procedure GetChildren( Proc: TGetChildProc; Root: TComponent ); override;

    procedure ResizeButtons; virtual;
    function GetEditRect: TRect; override;
    procedure SetEditRect; virtual;

    function IsValidChar( Key: Char ): Boolean; virtual;
    procedure UpRightClickHandler( Sender: TObject ); virtual;
    procedure DownLeftClickHandler( Sender: TObject ); virtual;

    { Event Dispatch Methods }
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure KeyPress(var Key: Char); override;
    function CanChange: Boolean; dynamic;
    procedure DoButtonClick( S: TSpinButtonType ); dynamic;
    procedure IncValue( const Amount: Extended ); virtual;
    procedure DecValue( const Amount: Extended ); virtual;

    function DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean; override;
    function DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean; override;

    { Property Access Methods }
    procedure SetFrameStyle( Value: TFrameStyle ); override;
    procedure SetButtonWidth( Value: Integer ); virtual;
    procedure SetDecimals( Value: Byte ); virtual;
    procedure SetIntegersOnly( Value: Boolean ); virtual;

    function GetButton( Index: Integer ): TRzControlButton; virtual;

    function GetButtonUpGlyph: TBitmap; virtual;
    procedure SetButtonUpGlyph( Value: TBitmap ); virtual;
    function GetButtonUpNumGlyphs: TNumGlyphs; virtual;
    procedure SetButtonUpNumGlyphs( Value: TNumGlyphs ); virtual;
    function GetButtonDownGlyph: TBitmap; virtual;
    procedure SetButtonDownGlyph( Value: TBitmap ); virtual;
    function GetButtonDownNumGlyphs: TNumGlyphs; virtual;
    procedure SetButtonDownNumGlyphs( Value: TNumGlyphs ); virtual;

    function GetDirection: TSpinDirection; virtual;
    procedure SetDirection( Value: TSpinDirection ); virtual;
    procedure SetFlatButtons( Value: Boolean ); override;
    function GetOrientation: TOrientation; virtual;
    procedure SetOrientation( Value: TOrientation ); virtual;

    procedure SetCheckRange( Value: Boolean ); virtual;
    procedure SetMin( const Value: Extended ); virtual;
    procedure SetMax( const Value: Extended ); virtual;

    function GetIntValue: Integer; virtual;
    procedure SetIntValue( Value: Integer ); virtual;
    function GetValue: Extended; virtual;
    function CheckValue( const Value: Extended ): Extended; virtual;
    procedure SetValue( const Value: Extended); virtual;

    function StoreIncrement: Boolean;
    function StoreMax: Boolean;
    function StoreMin: Boolean;
    function StorePageSize: Boolean;
  public
    constructor Create( AOwner: TComponent ); override;

    property Buttons: TRzSpinButtons
      read FButtons;

    property DownLeftButton: TRzControlButton
      index 1
      read GetButton;

    property UpRightButton: TRzControlButton
      index 2
      read GetButton;

    property IntValue: Integer
      read GetIntValue
      write SetIntValue;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property AllowBlank: Boolean
      read FAllowBlank
      write FAllowBlank
      default False;

    property BlankValue: Extended
      read FBlankValue
      write FBlankValue;

    property AllowKeyEdit: Boolean
      read FAllowKeyEdit
      write FAllowKeyEdit
      default False;

    property ButtonDownGlyph: TBitmap
      read GetButtonDownGlyph
      write SetButtonDownGlyph
      stored IsCustomDownGlyph;

    property ButtonDownNumGlyphs: TNumGlyphs
      read GetButtonDownNumGlyphs
      write SetButtonDownNumGlyphs
      stored IsCustomDownGlyph;

    property ButtonUpGlyph: TBitmap
      read GetButtonUpGlyph
      write SetButtonUpGlyph
      stored IsCustomUpGlyph;

    property ButtonUpNumGlyphs: TNumGlyphs
      read GetButtonUpNumGlyphs
      write SetButtonUpNumGlyphs
      stored IsCustomUpGlyph;

    property ButtonWidth: Integer
      read FButtonWidth
      write SetButtonWidth
      default 17;

    property CheckRange: Boolean
      read FCheckRange
      write SetCheckRange
      default False;

    property Decimals: Byte
      read FDecimals
      write SetDecimals
      default 0;

    property Direction: TSpinDirection
      read GetDirection
      write SetDirection
      default sdUpDown;

    property FlatButtonColor: TColor
      read FFlatButtonColor
      write FFlatButtonColor
      default clBtnFace;

    property Increment: Extended
      read FIncrement
      write FIncrement
      stored StoreIncrement;

    property IntegersOnly: Boolean
      read FIntegersOnly
      write SetIntegersOnly
      default True;

    property Max: Extended
      read FMax
      write SetMax
      stored StoreMax;

    property Min: Extended
      read FMin
      write SetMin
      stored StoreMin;

    property Orientation: TOrientation
      read GetOrientation
      write SetOrientation
      default orVertical;

    property PageSize: Extended
      read FPageSize
      write FPageSize
      stored StorePageSize;

    property Value: Extended
      read GetValue
      write SetValue;

    property OnChanging: TSpinChangingEvent
      read FOnChanging
      write FOnChanging;

    property OnButtonClick: TSpinButtonEvent
      read FOnButtonClick
      write FOnButtonClick;

    { Inherited Properties & Events }
    property Align;
    property Alignment default taRightJustify;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatButtons;
    property Font;
    property FocusColor;
    property FrameColor;
    property FrameController;
    property FrameHotColor;
    property FrameHotTrack;
    property FrameHotStyle;
    property FrameSides;
    property FrameStyle;
    property FrameVisible;
    property FramingPreference;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnChange;
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
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnStartDock;
    property OnStartDrag;
  end;


  {==================================}
  {== TRzSpinner Class Declaration ==}
  {==================================}

  TRzButtonType = ( btMinus, btPlus );
  TRzSpinnerEvent = procedure ( Sender: TObject; NewValue: Integer; var AllowChange: Boolean ) of object;

  TRzSpinner = class( TCustomControl )
  private
    FAboutInfo: TRzAboutInfo;
    FValue: Integer;
    FMin: Integer;
    FMax: Integer;
    FIncrement: Integer;
    FPageSize: Integer;
    FCheckRange: Boolean;
    FTabOnEnter: Boolean;
    FThumbCursor: HCursor;

    FFrameColor: TColor;
    FButtonColor: TColor;
    FButtonWidth: Integer;
    FMinusBtnDown: Boolean;
    FPlusBtnDown: Boolean;

    FRepeatTimer: TTimer;
    FInitialDelay: Word;
    FDelay: Word;

    // FGlyphBitmap is used to hold old glyph data from Spinners stored in RC 2.x format
    FGlyphBitmap: TBitmap;

    FImages: TCustomImageList;
    FImageIndexes: array[ 1..2 ] of TImageIndex;
    FImageChangeLink: TChangeLink;

    FOnChange: TNotifyEvent;
    FOnChanging: TRzSpinnerEvent;

    { Internal Event Handlers }
    procedure TimerExpired( Sender: TObject );
    procedure ImageListChange( Sender: TObject );

    { Message Handling Methods }
    procedure WMGetDlgCode( var Msg: TWMGetDlgCode ); message wm_GetDlgCode;
    procedure WMSetCursor( var Msg : TWMSetCursor ); message wm_SetCursor;
    procedure CMDesignHitTest( var Msg: TCMDesignHitTest ); message cm_DesignHitTest;
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
  protected
    procedure Notification( AComponent : TComponent; Operation : TOperation ); override;
    procedure DefineProperties( Filer: TFiler ); override;

    procedure Paint; override;
    procedure DrawButton( Button: TRzButtonType; Down: Boolean; Bounds: TRect ); virtual;
    procedure CalcCenterOffsets( Bounds: TRect; var L, T: Integer);
    procedure CheckMinSize;

    // Support Methods
    procedure DecValue( Amount: Integer ); virtual;
    procedure IncValue( Amount: Integer ); virtual;

    function CursorPosition: TPoint;
    function MouseOverButton( Btn: TRzButtonType ): Boolean;

    // New Event Dispatch Methods
    procedure Change; dynamic;
    function CanChange( NewValue: Integer ): Boolean; dynamic;

    // Overridden Event Dispatch Methods
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyPress( var Key: Char ); override;
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;

    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;

    function DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean; override;
    function DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean; override;

    { Property Access Methods }
    procedure SetButtonColor( Value: TColor ); virtual;
    procedure SetButtonWidth( Value: Integer ); virtual;
    procedure SetCheckRange( Value: Boolean ); virtual;
    procedure SetFrameColor( Value: TColor ); virtual;
    procedure SetImages( Value: TCustomImageList ); virtual;
    function GetImageIndex( PropIndex: Integer ): TImageIndex; virtual;
    procedure SetImageIndex( PropIndex: Integer; Value: TImageIndex ); virtual;
    procedure SetMax( Value: Integer ); virtual;
    procedure SetMin( Value: Integer ); virtual;
    function CheckValue( Value: Integer ): Integer; virtual;
    procedure SetValue( Value: Integer ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property ButtonColor: TColor
      read FButtonColor
      write SetButtonColor
      default clBtnFace;

    property ButtonWidth: Integer
      read FButtonWidth
      write SetButtonWidth
      default 18;

    property CheckRange: Boolean
      read FCheckRange
      write SetCheckRange
      default False;

    property FrameColor: TColor
      read FFrameColor
      write SetFrameColor
      default clBtnShadow;

    property GlyphMinus: TBitmap
      read FGlyphBitmap
      stored False;

    property GlyphPlus: TBitmap
      read FGlyphBitmap
      stored False;

    property Increment: Integer
      read FIncrement
      write FIncrement
      default 1;

    property Images: TCustomImageList
      read FImages
      write SetImages;

    property ImageIndexMinus: TImageIndex
      index 1
      read GetImageIndex
      write SetImageIndex
      default -1;

    property ImageIndexPlus: TImageIndex
      index 2
      read GetImageIndex
      write SetImageIndex
      default -1;

    property Max: Integer
      read FMax
      write SetMax
      default 100;

    property Min: Integer
      read FMin
      write SetMin
      default 0;

    property PageSize: Integer
      read FPageSize
      write FPageSize
      default 10;

    property TabOnEnter: Boolean
      read FTabOnEnter
      write FTabOnEnter
      default False;

    property Value: Integer
      read FValue
      write SetValue
      default 0;

    property OnChange: TNotifyEvent
      read FOnChange
      write FOnChange;

    property OnChanging: TRzSpinnerEvent
      read FOnChanging
      write FOnChanging;

    { Inherited Properties & Events }
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Height default 18;
    property HelpContext;
    property Hint;
    property ParentColor;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property Width default 80;

    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;


implementation

uses
  {$IFDEF VCL70_OR_HIGHER}
  Themes,
  {$ELSE}
  RzThemeSrv,
  {$ENDIF}
  RzCommonCursors;

const
  DefaultIncrement: Extended = 1.0;
  DefaultPageSize: Extended  = 10.0;
  DefaultMin: Extended       = 0.0;
  DefaultMax: Extended       = 100.0;


{&RT}
{================================}
{== TRzRapidFireButton Methods ==}
{================================}

constructor TRzRapidFireButton.Create( AOwner: TComponent );
begin
  inherited;
  FInitialDelay := 400;                                     { 400 milliseconds }
  FDelay := 100;                                            { 100 milliseconds }
  FStyle := [ rfAllowTimer ];
  {&RCI}
  {&RV}
end;

destructor TRzRapidFireButton.Destroy;
begin
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited;
end;


procedure TRzRapidFireButton.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;

  if rfAllowTimer in FStyle then
  begin
    if FRepeatTimer = nil then
    begin
      FRepeatTimer := TTimer.Create( Self );
      FRepeatTimer.OnTimer := TimerExpired;
    end;
    FRepeatTimer.Interval := FInitialDelay;
    FRepeatTimer.Enabled := True;
  end;
end;


procedure TRzRapidFireButton.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled := False;
end;


procedure TRzRapidFireButton.TimerExpired( Sender: TObject );
begin
  FRepeatTimer.Interval := FDelay;
  if ( FState = bsDown ) and MouseCapture then
  begin
    try
      Click;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;


procedure TRzRapidFireButton.Paint;
var
  R: TRect;
begin
  inherited;

  if rfFocusRect in FStyle then
  begin
    R := Bounds( 0, 0, Width, Height );
    InflateRect( R, -3, -3 );
    if FState = bsDown then
      OffsetRect( R, 1, 1 );
    DrawFocusRect( Canvas.Handle, R );
  end;
end;


procedure TRzRapidFireButton.AssignArrowGlyph;
var
  DestRect, SrcRect, FrameRect: TRect;
  Flags: Integer;
  ArrowGlyph, B: TBitmap;
begin
  ArrowGlyph := TBitmap.Create;
  try
    if FScrollStyle in [ scsLeft, scsRight ] then
    begin
      ArrowGlyph.Width := 9;
      ArrowGlyph.Height := 9;
    end
    else
    begin
      ArrowGlyph.Width := 9;
      ArrowGlyph.Height := 6;
    end;

    DestRect := Bounds( 0, 0, ArrowGlyph.Width, ArrowGlyph.Height );
    FrameRect := Rect( 0, 0, 17, 17 );

    B := TBitmap.Create;
    try
      B.Width := 17;
      B.Height := 17;

      Flags := 0;
      case FScrollStyle of
        scsLeft:
        begin
          Flags := dfcs_ScrollLeft;
          SrcRect := Bounds( 4, 4, ArrowGlyph.Width, ArrowGlyph.Height );
        end;

        scsUp:
        begin
          Flags := dfcs_ScrollUp;
          SrcRect := Bounds( 4, 5, ArrowGlyph.Width, ArrowGlyph.Height );
        end;

        scsRight:
        begin
          Flags := dfcs_ScrollRight;
          SrcRect := Bounds( 6, 4, ArrowGlyph.Width, ArrowGlyph.Height );
        end;

        scsDown:
        begin
          Flags := dfcs_ScrollDown;
          SrcRect := Bounds( 4, 6, ArrowGlyph.Width, ArrowGlyph.Height );
        end;
      end;

      if Down then
        Flags := Flags or dfcs_Pushed;
      if not Enabled then
        Flags := Flags or dfcs_Inactive;

      DrawFrameControl( B.Canvas.Handle, FrameRect, dfc_Scroll, Flags );

      // Copy only the arrow and not the border
      ArrowGlyph.Canvas.CopyRect( DestRect, B.Canvas, SrcRect );
    finally
      B.Free;
    end;

    Glyph.Assign( ArrowGlyph );
  finally
    ArrowGlyph.Free;
  end;
end; {= TRzRapidFireButton.AssignArrowGlyph =}



procedure TRzRapidFireButton.SetScrollStyle( Value: TRzScrollStyle );
begin
  if FScrollStyle <> Value then
  begin
    FScrollStyle := Value;

    Glyph := nil;  // Delphi 6 requires this statement

    if FScrollStyle <> scsNone then
      AssignArrowGlyph;

    Invalidate;
  end;
end;


{============================}
{== TRzSpinButtons Methods ==}
{============================}

constructor TRzSpinButtons.Create( AOwner: TComponent );
begin
  inherited;
  ControlStyle := ControlStyle - [ csAcceptsControls, csSetCaption ];

  FOrientation := orVertical;
  FFlat := False;

  FUpRightButton := CreateButton;
  FDownLeftButton := CreateButton;
  GlyphUpRight := nil;
  GlyphDownLeft := nil;

  Width := 16;
  Height := 25;
  FCustomUpRightGlyph := False;
  FCustomDownLeftGlyph := False;

  FFocusedButton := FUpRightButton;
  {&RCI}
end;


function TRzSpinButtons.CreateButton: TRzControlButton;
begin
  Result := TRzControlButton.Create( Self );
  Result.Parent := Self;
  Result.OnClick := BtnClickHandler;
  Result.OnMouseDown := BtnMouseDownHandler;
  Result.Visible := True;
  Result.Enabled := True;
  Result.RepeatClicks := True;
  Result.Glyph.OnChange := BtnGlyphChangeHandler;
  Result.NumGlyphs := 2;
end;


procedure TRzSpinButtons.Loaded;
var
  W, H: Integer;
begin
  {&RV}
  inherited;
  W := Width;
  H := Height;
  AdjustDimensions( W, H );
  if ( W <> Width ) or ( H <> Height ) then
    inherited SetBounds( Left, Top, W, H );
end;


procedure TRzSpinButtons.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( AComponent = FFocusControl ) then
    FFocusControl := nil;
end;

procedure TRzSpinButtons.AdjustDimensions( var W, H: Integer );
var
  Mid: Integer;
begin
  if ( FUpRightButton = nil ) or ( csLoading in ComponentState ) then
    Exit;

  if FOrientation = orVertical then
  begin
    Mid := H div 2;
    FUpRightButton.SetBounds( 0, 0, W, Mid );
    FDownLeftButton.SetBounds( 0, Mid, W, H - Mid - 1 );
  end
  else
  begin
    Mid := W div 2;
    FUpRightButton.SetBounds( Mid, 0, W - Mid, H - 1 );
    FDownLeftButton.SetBounds( 0, 0, Mid, H - 1 );
  end;
end; {= TRzSpinButtons.AdjustDimensions =}


procedure TRzSpinButtons.SetBounds( ALeft, ATop, AWidth, AHeight: Integer );
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustDimensions( W, H );
  inherited SetBounds( ALeft, ATop, W, H );
end;


procedure TRzSpinButtons.KeyDown( var Key: Word; Shift: TShiftState );
begin
  case Key of
    vk_Up:
      FUpRightButton.Click;

    vk_Down:
      FDownLeftButton.Click;
  end;
  inherited;
end;


procedure TRzSpinButtons.BtnMouseDownHandler( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  if Button = mbLeft then
  begin
    if ( FFocusControl <> nil ) and FFocusControl.TabStop and
       FFocusControl.CanFocus and
       ( GetFocus <> FFocusControl.Handle ) then
    begin
      Windows.SetFocus( FFocusControl.Handle );
      if not FFocusControl.Focused then
      begin
        // If FFocusControl is not focused, which may happen as the result
        // of a validation exception on a data-aware control, then abort
        // the clicking process of this button.  The call to Abort will
        // prevent the button from being drawn in the down state and not
        // being repainted after the exception message is closed.
        Abort;
      end;
    end
    else if TabStop and ( GetFocus <> Handle ) and CanFocus then
    begin
      Windows.SetFocus( Handle );
      if not Focused then
        Abort;
    end;
  end;
end;


procedure TRzSpinButtons.UpRightClick;
begin
  if Assigned( FOnUpRightClick ) then
    FOnUpRightClick( Self );
end;


procedure TRzSpinButtons.DownLeftClick;
begin
  if Assigned( FOnDownLeftClick ) then
    FOnDownLeftClick( Self );
end;


procedure TRzSpinButtons.BtnClickHandler( Sender: TObject );
begin
  if Sender = FUpRightButton then
    UpRightClick
  else
    DownLeftClick;
end;


procedure TRzSpinButtons.BtnGlyphChangeHandler( Sender: TObject );
begin
  if Sender = FUpRightButton.Glyph then
  begin
    FCustomUpRightGlyph := not FUpRightButton.Glyph.Empty;
    if FCustomUpRightGlyph then
      FUpRightButton.Style := cbsNone
    else
    begin
      if FDirection = sdUpDown then
        FUpRightButton.Style := cbsUp
      else
        FUpRightButton.Style := cbsRight;
    end;
  end
  else
  begin
    FCustomDownLeftGlyph := not FDownLeftButton.Glyph.Empty;
    if FCustomDownLeftGlyph then
      FDownLeftButton.Style := cbsNone
    else
    begin
      if FDirection = sdUpDown then
        FDownLeftButton.Style := cbsDown
      else
        FDownLeftButton.Style := cbsLeft;
    end;
  end;
end;


function TRzSpinButtons.GetUpRightGlyph: TBitmap;
begin
  Result := FUpRightButton.Glyph
end;


procedure TRzSpinButtons.SetUpRightGlyph( Value: TBitmap );
begin
  if Value <> nil then
  begin
    FUpRightButton.Glyph := Value;
    FCustomUpRightGlyph := True;
    FUpRightButton.Style := cbsNone;
  end
  else
  begin
    FUpRightButton.Glyph := nil;  // Delphi 6 requires this statement

    if FDirection = sdUpDown then
      FUpRightButton.Style := cbsUp
    else
      FUpRightButton.Style := cbsRight;

    FCustomUpRightGlyph := False;
  end;
end;


function TRzSpinButtons.GetUpRightNumGlyphs: TNumGlyphs;
begin
  Result := FUpRightButton.NumGlyphs;
end;


procedure TRzSpinButtons.SetUpRightNumGlyphs( Value: TNumGlyphs );
begin
  FUpRightButton.NumGlyphs := Value;
end;


function TRzSpinButtons.GetDownLeftGlyph: TBitmap;
begin
  Result := FDownLeftButton.Glyph;
end;


procedure TRzSpinButtons.SetDownLeftGlyph( Value: TBitmap );
begin
  if Value <> nil then
  begin
    FDownLeftButton.Glyph := Value;
    FCustomDownLeftGlyph := True;
    FDownLeftButton.Style := cbsNone;
  end
  else
  begin
    FDownLeftButton.Glyph := nil;  // Delphi 6 requires this statement

    if FDirection = sdUpDown then
      FDownLeftButton.Style := cbsDown
    else
      FDownLeftButton.Style := cbsLeft;
    FCustomDownLeftGlyph := False;
  end;
end;


function TRzSpinButtons.GetDownLeftNumGlyphs: TNumGlyphs;
begin
  Result := FDownLeftButton.NumGlyphs;
end;


procedure TRzSpinButtons.SetDownLeftNumGlyphs( Value: TNumGlyphs );
begin
  FDownLeftButton.NumGlyphs := Value;
end;


procedure TRzSpinButtons.SetDirection( Value: TSpinDirection );
begin
  if FDirection <> Value then
  begin
    FDirection := Value;
    { Update the glyphs }
    SetUpRightGlyph( nil );
    SetDownLeftGlyph( nil );
    Invalidate;
  end;
end;


function TRzSpinButtons.GetAllEnabled: Boolean;
begin
  Result := inherited Enabled;
end;


procedure TRzSpinButtons.SetAllEnabled( Value: Boolean );
begin
  if inherited Enabled <> Value then
  begin
    inherited Enabled := Value;
    FUpRightButton.Enabled := Value;
    FDownLeftButton.Enabled := Value;
  end;
end;


function TRzSpinButtons.GetColor: TColor;
begin
  Result := inherited Color;
end;


procedure TRzSpinButtons.SetColor( Value: TColor );
begin
  inherited Color := Value;
  FUpRightButton.Color := Value;
  FDownLeftButton.Color := Value;
end;


procedure TRzSpinButtons.SetFlat( Value: Boolean );
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    FUpRightButton.Flat := Value;
    FDownLeftButton.Flat := Value;
  end;
end;


procedure TRzSpinButtons.SetOrientation( Value: TOrientation );
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    if not ( csLoading in ComponentState ) then
    begin
      if FOrientation = orVertical then
        Width := Width div 2
      else
        Width := 2 * Width;
    end;
    Invalidate;
  end;
end;


procedure TRzSpinButtons.WMSize( var Msg: TWMSize );
var
  W, H: Integer;
begin
  inherited;

  { Check for minimum size }
  W := Width;
  H := Height;
  AdjustDimensions( W, H );
  if ( W <> Width ) or ( H <> Height ) then
    inherited SetBounds( Left, Top, W, H );

  Msg.Result := 0;
end;


procedure TRzSpinButtons.WMGetDlgCode( var Msg: TWMGetDlgCode );
begin
  Msg.Result := dlgc_WantArrows;
end;


{=========================}
{== TRzSpinEdit Methods ==}
{=========================}

constructor TRzSpinEdit.Create( AOwner: TComponent );
begin
  inherited;

  FButtons := TRzSpinButtons.Create( Self );
  FButtons.Parent := Self;
  FButtons.Width := 17;
  FButtons.Height := 17;
  FButtons.Visible := True;
  FButtons.FocusControl := Self;
  FButtons.OnUpRightClick := UpRightClickHandler;
  FButtons.OnDownLeftClick := DownLeftClickHandler;

  ControlStyle := ControlStyle - [ csSetCaption ];

  FFlatButtonColor := clBtnFace;

  FButtonWidth := 17;
  Width := 47;
  FIntegersOnly := True;
  FAllowBlank := False;
  FBlankValue := 0;
  FAllowKeyEdit := False;
  FIncrement := DefaultIncrement;
  FPageSize := DefaultPageSize;
  FDecimals := 0;
  FCheckRange := False;
  FMin := DefaultMin;
  FMax := DefaultMax;

  Alignment := taRightJustify;
  SetValue( 0 );
  {&RCI}
end;


procedure TRzSpinEdit.CreateParams( var Params: TCreateParams );
begin
  inherited;
  Params.Style := Params.Style or ws_ClipChildren;
end;


procedure TRzSpinEdit.CreateWnd;
begin
  inherited;
  SetEditRect;
  {&RV}
end;


procedure TRzSpinEdit.Loaded;
begin
  inherited;
  ResizeButtons;
end;


procedure TRzSpinEdit.GetChildren( Proc: TGetChildProc; Root: TComponent );
begin
end;


procedure TRzSpinEdit.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the FlatButtonParentColor was published in version 2.x
  Filer.DefineProperty( 'FlatButtonParentColor', TRzOldPropReader.ReadOldBooleanProp, nil, False );
end;


procedure TRzSpinEdit.UpdateFrame( ViaMouse, InFocus: Boolean );
begin
  inherited;

  if FlatButtons then
  begin
    if ThemeServices.ThemesEnabled then
    begin
      if InFocus or Focused then
        FButtons.Flat := False
      else
        FButtons.Flat := True;
      FButtons.Color := Color;
    end
    else // No Themes
    begin
      if InFocus or Focused then
        FButtons.Color := FFlatButtonColor
      else
        FButtons.Color := Color;
    end;
  end;
end;


function TRzSpinEdit.CanChange: Boolean;
begin
  Result := True;
  if Assigned( FOnChanging ) then
    FOnChanging( Self, Result );
end;


procedure TRzSpinEdit.DoButtonClick( S: TSpinButtonType );
begin
  if Assigned( FOnButtonClick ) then
    FOnButtonClick( Self, S );
end;


procedure TRzSpinEdit.IncValue( const Amount: Extended );
begin
  if ReadOnly then
    MessageBeep( 0 )
  else if CanChange then
  begin
    Value := Value + Amount;
    DoButtonClick( sbUp );
  end;
end;


procedure TRzSpinEdit.DecValue( const Amount: Extended );
begin
  if ReadOnly then
    MessageBeep( 0 )
  else if CanChange then
  begin
    Value := Value - Amount;
    DoButtonClick( sbDown );
  end;
end;


function TRzSpinEdit.DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean;
begin
  inherited DoMouseWheelDown( Shift, MousePos );
  if ssCtrl in Shift then
    DecValue( FPageSize )
  else
    DecValue( FIncrement );
  Result := True;
end;


function TRzSpinEdit.DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean;
begin
  inherited DoMouseWheelUp( Shift, MousePos );
  if ssCtrl in Shift then
    IncValue( FPageSize )
  else
    IncValue( FIncrement );
  Result := True;
end;


procedure TRzSpinEdit.KeyDown( var Key: Word; Shift: TShiftState );
begin
  inherited;

  if not FAllowKeyEdit and ( Key = vk_Delete ) then
  begin
    Key := 0;
    MessageBeep( 0 );
  end;

  case Key of
    vk_Prior:
      IncValue( FPageSize );
    vk_Next:
      DecValue( FPageSize );
    vk_Up:
      IncValue( FIncrement );
    vk_Down:
      DecValue( FIncrement );
  end;
end;


procedure TRzSpinEdit.KeyPress( var Key: Char );
begin
  inherited;

  if not IsValidChar( Key ) then
  begin
    Key := #0;
    MessageBeep( 0 )
  end;
  {&RV}
end;


function TRzSpinEdit.IsValidChar( Key: Char ): Boolean;
var
  ValidCharSet: set of Char;
begin
  if FIntegersOnly then
    ValidCharSet := [ '+', '-', '0'..'9' ]
  else
    ValidCharSet := [ DecimalSeparator, '+', '-', '0'..'9' ];

  Result := ( Key in ValidCharSet ) or ( ( Key < #32 ) and ( Key <> Chr( vk_Return ) ) );

  if Result then
  begin
    if Key = DecimalSeparator then
    begin
      if SelLength = 0 then
        Result := Pos( DecimalSeparator, Text ) = 0
      else
      begin
        Result := Pos( DecimalSeparator, Text ) = 0;
        if not Result then
          Result := Pos( DecimalSeparator, SelText ) <> 0;
      end;
    end
    else if ( Key = '+' ) or ( Key = '-' ) then
      Result := ( ( SelStart = 0 ) and
                  ( Pos( '+', Text ) = 0 ) and
                  ( Pos( '-', Text ) = 0 ) ) or
                ( SelLength = Length( Text ) );
  end;

  if not FAllowKeyEdit and Result and
     ( ( Key >= #32 ) or
       ( Key = Char( vk_Back ) ) or
       ( Key = Char( vk_Delete ) ) ) then
    Result := False;
end;


procedure TRzSpinEdit.UpRightClickHandler( Sender: TObject );
begin
  IncValue( FIncrement );
end;


procedure TRzSpinEdit.DownLeftClickHandler( Sender: TObject );
begin
  DecValue( FIncrement )
end;


procedure TRzSpinEdit.SetFrameStyle( Value: TFrameStyle );
begin
  inherited;
  ResizeButtons;
end;


procedure TRzSpinEdit.SetButtonWidth( Value: Integer );
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    if FButtonWidth < 0 then
      FButtonWidth := 0;

    if Orientation = orVertical then
      FButtons.Width := FButtonWidth
    else
      FButtons.Width := 2 * FButtonWidth;
    ResizeButtons;
    Invalidate;
  end;
end;


procedure TRzSpinEdit.SetDecimals( Value: Byte );
begin
  if FDecimals <> Value then
  begin
    FDecimals := Value;
    SetValue( GetValue );
  end;
end;


function TRzSpinEdit.GetButton( Index: Integer ): TRzControlButton;
begin
  if Index = 1 then
    Result := FButtons.DownLeftButton
  else
    Result := FButtons.UpRightButton;
end;


function TRzSpinEdit.IsCustomUpGlyph: Boolean;
begin
  Result := FButtons.CustomUpRightGlyph;
end;

function TRzSpinEdit.GetButtonUpGlyph: TBitmap;
begin
    Result := FButtons.GlyphUpRight;
end;

procedure TRzSpinEdit.SetButtonUpGlyph( Value: TBitmap );
begin
  FButtons.GlyphUpRight := Value;
end;


function TRzSpinEdit.GetButtonUpNumGlyphs: TNumGlyphs;
begin
  Result := FButtons.NumGlyphsUpRight;
end;

procedure TRzSpinEdit.SetButtonUpNumGlyphs( Value: TNumGlyphs );
begin
  FButtons.NumGlyphsUpRight := Value;
end;


function TRzSpinEdit.IsCustomDownGlyph: Boolean;
begin
  Result := FButtons.CustomDownLeftGlyph;
end;

function TRzSpinEdit.GetButtonDownGlyph: TBitmap;
begin
  Result := FButtons.GlyphDownLeft;
end;

procedure TRzSpinEdit.SetButtonDownGlyph( Value: TBitmap );
begin
  FButtons.GlyphDownLeft := Value;
end;


function TRzSpinEdit.GetButtonDownNumGlyphs: TNumGlyphs;
begin
  Result := FButtons.NumGlyphsDownLeft;
end;

procedure TRzSpinEdit.SetButtonDownNumGlyphs( Value: TNumGlyphs );
begin
  FButtons.NumGlyphsDownLeft := Value;
end;


function TRzSpinEdit.GetDirection: TSpinDirection;
begin
  Result := FButtons.Direction;
end;

procedure TRzSpinEdit.SetDirection( Value: TSpinDirection );
begin
  FButtons.Direction := Value;
end;


procedure TRzSpinEdit.SetFlatButtons( Value: Boolean );
begin
  inherited;
  FButtons.Flat := Value;
  ResizeButtons;
end;


function TRzSpinEdit.GetOrientation: TOrientation;
begin
  Result := FButtons.Orientation;
end;

procedure TRzSpinEdit.SetOrientation( Value: TOrientation );
begin
  FButtons.Orientation := Value;
  ResizeButtons;
  Invalidate;
end;


procedure TRzSpinEdit.SetIntegersOnly( Value: Boolean );
begin
  if FIntegersOnly <> Value then
  begin
    FIntegersOnly := Value;
    if FIntegersOnly then
    begin
      Decimals := 0;
      SetValue( Round( GetValue ) );
    end;
  end;
end;


procedure TRzSpinEdit.SetCheckRange( Value: Boolean );
begin
  if FCheckRange <> Value then
  begin
    FCheckRange := Value;
    SetValue( GetValue );
  end;
end;


procedure TRzSpinEdit.SetMin( const Value: Extended );
begin
  if FMin <> Value then
  begin
    FMin := Value;
    if FMax < FMin then
      FMax := FMin;
    SetValue( GetValue ); // Reapply range
    Invalidate;
  end;
end;


procedure TRzSpinEdit.SetMax( const Value: Extended );
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if FMin > FMax then
      FMin := FMax;
    SetValue( GetValue ); // Reapply range
    Invalidate;
  end;
end;


function TRzSpinEdit.GetIntValue: Integer;
begin
  Result := Round( GetValue );
end;


procedure TRzSpinEdit.SetIntValue( Value: Integer );
begin
  SetValue( Value );
end;


function TRzSpinEdit.GetValue: Extended;
begin
  try
    if Text = '' then
    begin
      if FAllowBlank then
        Result := FBlankValue
      else
      begin
        Text := FloatToStr( FMin );
        Result := StrToFloat( Text );
      end;
    end
    else
    begin
      Result := StrToFloat( Text );
    end;
  except
    Result := FMin;
  end;
end;


function TRzSpinEdit.CheckValue( const Value: Extended ): Extended;
begin
  Result := Value;
  if ( FMax <> FMin ) or FCheckRange then
  begin
    if Value < FMin then
      Result := FMin
    else if Value > FMax then
      Result := FMax;
  end;
end;


procedure TRzSpinEdit.SetValue( const Value: Extended );
begin
  Text := FloatToStrF( CheckValue( Value ), ffFixed, 18, FDecimals );
end;


function TRzSpinEdit.StoreIncrement: Boolean;
begin
  Result := FIncrement <> DefaultIncrement;
end;


function TRzSpinEdit.StoreMax: Boolean;
begin
  Result := FMax <> DefaultMax;
end;


function TRzSpinEdit.StoreMin: Boolean;
begin
  Result := FMin <> DefaultMin;
end;


function TRzSpinEdit.StorePageSize: Boolean;
begin
  Result := FPageSize <> DefaultPageSize;
end;


procedure TRzSpinEdit.WMPaste( var Msg: TWMPaste );
begin
  if not FAllowKeyEdit or ReadOnly then
    Exit;
  inherited;
end;

procedure TRzSpinEdit.WMCut( var Msg: TWMPaste );
begin
  if not FAllowKeyEdit or ReadOnly then
    Exit;
  inherited;
end;


procedure TRzSpinEdit.CMEnter( var Msg: TCMEnter );
begin
  // Moved inherited to beginning b/c any changes made in OnEnter event handler that recreate the window does not
  // cause the EditRect to be updated.
  inherited;
  SetEditRect;
  if AutoSelect and not ( csLButtonDown in ControlState ) then
    SelectAll;
end;


procedure TRzSpinEdit.CMExit( var Msg: TCMExit );
var
  N: Extended;
begin
  inherited;
  SetEditRect;

  if FAllowBlank and ( Text = '' ) then
    Exit;

  try
    N := StrToFloat( Text );
  except
    N := FMin;
  end;
  SetValue( N );
end;


function TRzSpinEdit.GetEditRect: TRect;
begin
  Result := inherited GetEditRect;
  Dec( Result.Right, FButtons.Width + 2 );
end;


procedure TRzSpinEdit.SetEditRect;
begin
  if not ( csLoading in ComponentState ) then
  begin
    if not UseRightToLeftAlignment then
    begin
      SendMessage( Handle, em_SetMargins, ec_LeftMargin, 0 );
      SendMessage( Handle, em_SetMargins, ec_RightMargin, MakeLong( 0, FButtons.Width + 2 ) );
    end
    else
    begin
      SendMessage( Handle, em_SetMargins, ec_LeftMargin, MakeLong( FButtons.Width + 2, 0 ) );
      SendMessage( Handle, em_SetMargins, ec_RightMargin, 0 );
    end;
  end;
end;


procedure TRzSpinEdit.ResizeButtons;
var
  W, MinHeight: Integer;
begin
  if not ( csLoading in ComponentState ) then
  begin
    MinHeight := GetMinFontHeight( Font );
    if Height < MinHeight then
      Height := MinHeight
    else if FButtons <> nil then
    begin
      W := FButtons.Width;

      if not UseRightToLeftAlignment then
      begin
        if not FrameVisible then
        begin
          if Ctl3D then
          begin
            if ThemeServices.ThemesEnabled then
              FButtons.SetBounds( Width - W - 3, -1, W, Height - 1 )
            else
              FButtons.SetBounds( Width - W - 4, 0, W, Height - 3 );
          end
          else
            FButtons.SetBounds( Width - W - 1, 1, W, Height - 3 );
        end
        else
        begin
          if ThemeServices.ThemesEnabled then
            FButtons.SetBounds( Width - W - 3, -1, W, Height - 1 )
          else
            FButtons.SetBounds( Width - W - 4, 0, W, Height - 3 );
        end;
      end
      else
      begin
        FButtons.SetBounds( 0, 0, W, Height - 3 );
      end;

      SetEditRect;
    end;
  end;
end; {= TRzSpinEdit.ResizeButtons =}


procedure TRzSpinEdit.WMSize( var Msg: TWMSize );
begin
  inherited;
  ResizeButtons;
end;


procedure TRzSpinEdit.CMEnabledChanged( var Msg: TMessage );
begin
  inherited;
  SetEditRect;
  FButtons.Enabled := Enabled;
  if FlatButtons then
    FButtons.Color := Color;
end;


procedure TRzSpinEdit.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  if HandleAllocated then
    SetEditRect;
  FButtons.Enabled := Enabled;
end;


{========================}
{== TRzSpinner Methods ==}
{========================}

constructor TRzSpinner.Create( AOwner: TComponent );
begin
  inherited;

  FButtonColor := clBtnFace;
  FButtonWidth := 18;
  FFrameColor := clBtnShadow;

  FValue := 0;
  FIncrement := 1;
  FPageSize := 10;
  FMin := 0;
  FMax := 100;
  FCheckRange := False;
  FTabOnEnter := False;

  FMinusBtnDown := False;
  FPlusBtnDown := False;

  FInitialDelay := 400;   // 400 milliseconds
  FDelay := 100;          // 100 milliseconds

  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FImageIndexes[ 1 ] := -1;
  FImageIndexes[ 2 ] := -1;

  // Initializing inherited properties
  Width := 80;
  Height := 18;
  TabStop := True;
  ParentColor := False;

  if RunningUnder( WinNT ) or RunningUnder( Win95 ) then
    FThumbCursor := LoadCursor( HInstance, 'RZCOMMON_HANDCURSOR' )
  else
    FThumbCursor := LoadCursor( 0, IDC_HAND );
  FGlyphBitmap := TBitmap.Create;
end;


destructor TRzSpinner.Destroy;
begin
  FImageChangeLink.Free;
  if RunningUnder( WinNT ) or RunningUnder( Win95 ) then
    DestroyCursor( FThumbCursor );       // Release GDI cursor object
  FGlyphBitmap.Free;
  inherited;
end;


procedure TRzSpinner.DefineProperties( Filer: TFiler );
begin
  inherited;

  // Handle the fact that the NumGlyphsMinus, NumGlyphsPlus, and Flat properties were  published in version 2.x
  Filer.DefineProperty( 'NumGlyphsMinus', TRzOldPropReader.ReadOldIntegerProp, nil, False );
  Filer.DefineProperty( 'NumGlyphsPlus', TRzOldPropReader.ReadOldIntegerProp, nil, False );
  Filer.DefineProperty( 'Flat', TRzOldPropReader.ReadOldBooleanProp, nil, False );
end;


procedure TRzSpinner.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( AComponent = FImages ) then
    SetImages( nil );
end;


procedure TRzSpinner.Paint;
var
  R: TRect;
  YOffset: Integer;
  S: string;
begin
  inherited;

  Canvas.Font := Self.Font;
  Canvas.Pen.Color := FFrameColor;

  if Enabled then
    Canvas.Brush.Color := Self.Color
  else
  begin
    Canvas.Brush.Color := clBtnFace;
    Canvas.Font.Color := clBtnShadow;
  end;

  // Display Value
  SetTextAlign( Canvas.Handle, ta_Center or ta_Top );
  R := Rect( FButtonWidth - 1, 0, Width - FButtonWidth + 1, Height );
  Canvas.Rectangle( R.Left, R.Top, R.Right, R.Bottom );
  InflateRect( R, -1, -1 );
  S := IntToStr( FValue );
  YOffset := R.Top + ( R.Bottom - R.Top - Canvas.TextHeight( S ) ) div 2;

  Canvas.TextRect( R, Width div 2, YOffset, S );

  DrawButton( btMinus, FMinusBtnDown, Rect( 0, 0, FButtonWidth, Height ) );
  DrawButton( btPlus, FPlusBtnDown, Rect( Width - FButtonWidth, 0, Width, Height ) );

  if Focused then
  begin
    Brush.Color := Self.Color;
    Canvas.DrawFocusRect( R );
  end;
end; {= TRzSpinner.Paint =}


procedure TRzSpinner.DrawButton( Button: TRzButtonType; Down: Boolean; Bounds: TRect );
var
  L, T: Integer;
begin
  if Down then                            // Set background color
    Canvas.Brush.Color := clBtnShadow
  else
    Canvas.Brush.Color := FButtonColor;
  Canvas.Pen.Color := FFrameColor;
  Canvas.Rectangle( Bounds.Left, Bounds.Top, Bounds.Right, Bounds.Bottom );

  if Enabled then
  begin
    Canvas.Pen.Color := clActiveCaption;
    Canvas.Brush.Color := clActiveCaption;
  end
  else
  begin
    Canvas.Pen.Color := clBtnShadow;
    Canvas.Brush.Color := clBtnShadow;
  end;

  if Button = btMinus then               // Draw the Minus Button
  begin
    if ( Images <> nil ) and ( ImageIndexMinus <> -1 ) then
    begin
      CalcCenterOffsets( Bounds, L, T );

      if Down then
        Canvas.Brush.Color := clBtnShadow
      else
        Canvas.Brush.Color := FButtonColor;
      Canvas.Pen.Color := FFrameColor;
      Canvas.Rectangle( Bounds.Left, Bounds.Top, Bounds.Right, Bounds.Bottom );

      FImages.Draw( Canvas, L, T, ImageIndexMinus, Enabled );
    end
    else
      Canvas.Rectangle( 4, Height div 2 - 1, FButtonWidth - 4, Height div 2 + 1 );
  end
  else                                    // Draw the Plus Button
  begin
    if ( Images <> nil ) and ( ImageIndexPlus <> -1 ) then
    begin
      CalcCenterOffsets( Bounds, L, T );

      if Down then
        Canvas.Brush.Color := clBtnShadow
      else
        Canvas.Brush.Color := ButtonColor;
      Canvas.Pen.Color := FFrameColor;
      Canvas.Rectangle( Bounds.Left, Bounds.Top, Bounds.Right, Bounds.Bottom );

      FImages.Draw( Canvas, L, T, ImageIndexPlus, Enabled );
    end
    else
    begin
      Canvas.Rectangle( Width - FButtonWidth + 4, Height div 2 - 1, Width - 4, Height div 2 + 1 );
      Canvas.Rectangle( Width - FButtonWidth div 2 - 1, ( Height div 2 ) - (FButtonWidth div 2 - 4),
                        Width - FButtonWidth div 2 + 1, ( Height div 2 ) + (FButtonWidth div 2 - 4)  );
    end;
  end;
  Canvas.Pen.Color := clWindowText;
  Canvas.Brush.Color := clWindow;
end; {= TRzSpinner.DrawButton =}


procedure TRzSpinner.CalcCenterOffsets( Bounds: TRect; var L, T: Integer );
begin
  if FImages <> nil then
  begin
    L := Bounds.Left + ( Bounds.Right - Bounds.Left ) div 2 -  ( FImages.Width div 2 );
    T := Bounds.Top + ( Bounds.Bottom - Bounds.Top ) div 2 - ( FImages.Height div 2 );
  end;
end;


procedure TRzSpinner.DoEnter;
begin
  inherited;
  // When control gets focus, update display to show focus border
  Repaint;
end;


procedure TRzSpinner.DoExit;
begin
  inherited;
  // When control loses focus, update display to remove focus border
  Repaint;
end;


function TRzSpinner.CanChange( NewValue: Integer ): Boolean;
var
  AllowChange: Boolean;
begin
  AllowChange := True;
  if Assigned( FOnChanging ) then
    FOnChanging( Self, NewValue, AllowChange );
  Result := AllowChange;
end;


procedure TRzSpinner.Change;
begin
  if Assigned( FOnChange ) then
    FOnChange( Self );
end;


procedure TRzSpinner.DecValue( Amount: Integer );
begin
  SetValue( Value - Amount );
end;

procedure TRzSpinner.IncValue( Amount: Integer );
begin
  SetValue( Value + Amount );
end;


procedure TRzSpinner.WMGetDlgCode( var Msg: TWMGetDlgCode );
begin
  inherited;
  Msg.Result := dlgc_WantArrows;   
end;


procedure TRzSpinner.KeyPress( var Key: Char );
begin
  if FTabOnEnter and ( Ord( Key ) = vk_Return ) then
  begin
    Key := #0;
    PostMessage( Handle, wm_KeyDown, vk_Tab, 0 );
  end
  else
    inherited;
end;


procedure TRzSpinner.KeyDown( var Key: Word; Shift: TShiftState );
begin
  inherited;

  case Key of
    vk_Left, vk_Down, vk_Subtract:
      DecValue( FIncrement );

    vk_Up, vk_Right, vk_Add:
      IncValue( FIncrement );

    vk_Prior:
      IncValue( FPageSize );

    vk_Next:
      DecValue( FPageSize );
  end;
end;


function TRzSpinner.CursorPosition: TPoint;
begin
  GetCursorPos( Result );
  Result := ScreenToClient( Result );
end;


function TRzSpinner.MouseOverButton( Btn: TRzButtonType ): Boolean;
var
  R: TRect;
begin
  // Get bounds of appropriate button
  if Btn = btMinus then
    R := Rect( 0, 0, FButtonWidth, Height )
  else
    R := Rect( Width - FButtonWidth, 0, Width, Height );

  // Is cursor position within bounding rectangle?
  Result := PtInRect( R, CursorPosition );
end;


procedure TRzSpinner.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;

  if not ( csDesigning in ComponentState ) then
    SetFocus;               // Move focus to Spinner only at runtime

  if ( Button = mbLeft ) and ( MouseOverButton( btMinus ) or MouseOverButton( btPlus ) ) then
  begin
    FMinusBtnDown := MouseOverButton( btMinus );
    FPlusBtnDown := MouseOverButton( btPlus );

    if FRepeatTimer = nil then
    begin
      FRepeatTimer := TTimer.Create( Self );
      FRepeatTimer.OnTimer := TimerExpired;
    end;
    FRepeatTimer.Interval := FInitialDelay;
    FRepeatTimer.Enabled := True;

    Repaint;
  end;
end;


procedure TRzSpinner.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;

  if Button = mbLeft then
  begin
    if MouseOverButton( btPlus ) then
      IncValue( FIncrement )
    else if MouseOverButton( btMinus ) then
      DecValue( FIncrement );

    if FRepeatTimer <> nil then
      FRepeatTimer.Enabled := False;

    FMinusBtnDown := False;
    FPlusBtnDown := False;
    Repaint;
  end;
end;


procedure TRzSpinner.TimerExpired( Sender: TObject );
begin
  FRepeatTimer.Interval := FDelay;

  try
    if MouseOverButton( btPlus ) then
      IncValue( FIncrement )
    else if MouseOverButton( btMinus ) then
      DecValue( FIncrement );
  except
    FRepeatTimer.Enabled := False;
    raise;
  end;
end;


function TRzSpinner.DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean;
begin
  inherited DoMouseWheelDown( Shift, MousePos );
  if ssCtrl in Shift then
    DecValue( FPageSize )
  else
    DecValue( FIncrement );
  Result := True;
end;


function TRzSpinner.DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean;
begin
  inherited DoMouseWheelUp( Shift, MousePos );
  if ssCtrl in Shift then
    IncValue( FPageSize )
  else
    IncValue( FIncrement );
  Result := True;
end;


procedure TRzSpinner.SetButtonColor( Value: TColor );
begin
  if FButtonColor <> Value then
  begin
    FButtonColor := Value;
    Invalidate;
  end;
end;


procedure TRzSpinner.SetButtonWidth( Value: Integer );
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    Invalidate;
  end;
end;


procedure TRzSpinner.SetFrameColor( Value: TColor );
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Invalidate;
  end;
end;


function TRzSpinner.GetImageIndex( PropIndex: Integer ): TImageIndex;
begin
  Result := FImageIndexes[ PropIndex ];
end;


procedure TRzSpinner.SetImageIndex( PropIndex: Integer; Value: TImageIndex );
begin
  if FImageIndexes[ PropIndex ] <> Value then
  begin
    FImageIndexes[ PropIndex ] := Value;
    Invalidate;
  end;
end;


procedure TRzSpinner.SetImages( Value: TCustomImageList );
begin
  if FImages <> nil then
    FImages.UnRegisterChanges( FImageChangeLink );

  FImages := Value;

  if FImages <> nil then
  begin
    FImages.RegisterChanges( FImageChangeLink );
    FImages.FreeNotification( Self );
    CheckMinSize;
  end;
  Invalidate;
end;


procedure TRzSpinner.ImageListChange( Sender: TObject );
begin
  if Sender = Images then
  begin
    CheckMinSize;
    Update; // Call Update instead of Invalidate to prevent flicker
  end;
end;


procedure TRzSpinner.CheckMinSize;
begin
  // Ensures button area will display entire image
  if FImages.Width > ButtonWidth then
    ButtonWidth := FImages.Width + 4;
  if FImages.Height > Height then
    Height := FImages.Height + 4;
end;


procedure TRzSpinner.SetCheckRange( Value: Boolean );
begin
  if FCheckRange <> Value then
  begin
    FCheckRange := Value;
    SetValue( FValue );
  end;
end;


procedure TRzSpinner.SetMax( Value: Integer );
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if FMin > FMax then
      FMin := FMax;
    SetValue( FValue ); // Reapply range
    Invalidate;
  end;
end;

procedure TRzSpinner.SetMin( Value: Integer );
begin
  if FMin <> Value then
  begin
    FMin := Value;
    if FMax < FMin then
      FMax := FMin;
    SetValue( FValue );
    Invalidate;
  end;
end;


function TRzSpinner.CheckValue( Value: Integer ): Integer;
begin
  Result := Value;
  if ( FMax <> FMin ) or FCheckRange then
  begin
    if Value < FMin then
      Result := FMin
    else if Value > FMax then
      Result := FMax;
  end;
end;


procedure TRzSpinner.SetValue( Value: Integer );
var
  TempValue: Integer;
begin
  TempValue := CheckValue( Value );
  if FValue <> TempValue then
  begin
    if CanChange( TempValue ) then
    begin
      FValue := TempValue;
      Invalidate;

      Change;                                           { Trigger Change event }

      UpdateObjectInspector( Self );
    end;
  end;
end;


procedure TRzSpinner.WMSetCursor( var Msg: TWMSetCursor );
begin
  if MouseOverButton( btMinus ) or MouseOverButton( btPlus ) then
    SetCursor( FThumbCursor )
  else
    inherited;
end;


procedure TRzSpinner.CMDesignHitTest( var Msg: TCMDesignHitTest );
begin
  // Handling this component message allows the Value of the spinner to be changed at design-time using the left mouse
  // button.  If the mouse is positioned over one of the buttons, then set the Msg.Result value to 1. This instructs
  // Delphi to allow mouse events to "get through to" the component.

  if MouseOverButton( btMinus ) or MouseOverButton( btPlus ) then
    Msg.Result := 1
  else
    Msg.Result := 0;
end;


procedure TRzSpinner.CMEnabledChanged( var Msg: TMessage );
begin
  inherited;

  // Repaint the component so that it reflects the state change
  Repaint;
end;


{&RUIF}
end.

