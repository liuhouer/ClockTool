{===============================================================================
  RzButton Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzCustomButton       Custom ancestor for all Raize button components
  TRzButton             Standard push button with custom colors, multi-lines
                          captions, 3D text styles
  TRzBitBtn             TRzButton descendant--adds ability to display a glyph
  TRzMenuButton         Descendant of TRzBitBtn--adds ability to display a
                          dropdown menu
  TRzToolbarButton      Custom TSpeedButton that adds features such as HotGlyph,
                          ShowCaption, etc.
  TRzMenuToolbarButton  TRzToolbarButton descendant--adds ability to display a
                          dropdown menu
  TRzToolButton         New improved tool button that is purely custom and
                          combines functionality of TRzToolbarButton and
                          TRzMenuToolbarButton and is designed to work with
                          Actions and ImageLists.
  TRzShapeButton        This component automatically shapes a specified bitmap
                          image into a button by masking out the transparent
                          areas.


  Modification History
  ------------------------------------------------------------------------------
  3.0.10 (26 Dec 2003)
    * Fixed problem where the TRzToolButton would not display the separator line
      when in tsDropDown mode and a Standard Action was assigned to the button.
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Added DropDownOnEnter property to TRzMenuButton. When True, pressing Enter
      while the button has the focus will cause the associated drop down menu to
      be displayed.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Added TRzToolButton.CMDialogChar method to handle accelerator characters
      in TRzToolButton captions.
    * Added ThemeAware property to TRzButton and descendants. This allows a
      developer to use a custom colored button in an application running with
      XP themes.
    * Fixed problem in TRzToolButton where clicking on an already down
      (i.e. exclusive) button would cause an associated action to fire thus
      changing the Checked state of the action.
    * Surfaced TRzToolButton.Font and TRzToolButton.ParentFont.
  ------------------------------------------------------------------------------
  3.0.6  (11 Apr 2003)
    * Fixed problem where TRzToolButtons would not appear correctly in exclusive
      state while running under Windows XP Themes.
    * Added dt_RtlReading flag to DrawText function calls when
      UseRightToLeftAlignment = True.
    * Added BiDiMode and ParentBiDiMode properties to TRzToolButton.
  ------------------------------------------------------------------------------
  3.0.5  (24 Mar 2003)
    * Fixed problem where TRzButton classes would always pickup parent's color.
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * Draw3DText now takes into account Right-To-Left locales.
    * Fixed display of TRzToolButton when in the exclusive down state.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Added GetHotTrackRect virtual method to TRzCustomButton. This function is
      called when control needs to be updated b/c HotTrack = True.  The
      TRzRadioButton and TRzCheckBox override this method so that only the image
      is updated, not the caption.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    << TRzCustomButton and TRzButton >>
    * Fixed problem where drop-down menus where not getting aligned correctly
      when control was positioned close to right edge of screen.
    * Fixed display problem when button clicked and focus taken away by an
      exception.
    * Renamed FrameFlat property to HotTrack.
    * When HotTrack is True, the button has a new appearance--the new
      HotTrackColor and HighlightColor property values are used.
    * Added XP visual style support.

    << TRzMenuButton >>
    * The drop down arrow now correctly reflects the Enabled property. That is,
      when disabled, the arrows is drawn in clBtnShadow.
    * Fixed problem where drop-down menus where not getting aligned correctly
      when control was positioned close to right edge of screen.

    << TRzMenuToolbarButton >>
    * Fixed problem where drop-down menus where not getting aligned correctly
      when control was positioned close to right edge of screen.

    << TRzToolButton >>
    * Initial release.

    << TRzShapeButton >>
    * Initial release.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzButton;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Windows,
  SysUtils,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  Menus,
  StdCtrls,
  ExtCtrls,
  Buttons,
  ActnList,
  ImgList,
  Consts,
  RzCommon;


const
  BitBtnCaptions: array[ TBitBtnKind ] of string = (
    '', SOKButton, SCancelButton, SHelpButton, SYesButton, SNoButton,
    SCloseButton, SAbortButton, SRetryButton, SIgnoreButton, SAllButton );

const
  cm_RzButtonPressed = wm_User + $2021;

type
  {=======================================}
  {== TRzCustomButton Class Declaration ==}
  {=======================================}

  TRzCustomButton = class( TCustomControl )
  private
    FAlignmentVertical: TAlignmentVertical;

    FHotTrackColor: TColor;
    FHotTrackColorType: TRzHotTrackColorType;
    FHighlightColor: TColor;

    FLightTextStyle: Boolean;
    FTextStyle: TTextStyle;
    FTextHighlightColor: TColor;
    FTextShadowColor: TColor;
    FTextShadowDepth: Integer;

    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;

    { Message Handling Methods }
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure CMTextChanged( var Msg: TMessage ); message cm_TextChanged;
    procedure CMMouseEnter( var Msg: TMessage ); message cm_MouseEnter;
    procedure CMMouseLeave( var Msg: TMessage ); message cm_MouseLeave;
    procedure WMEraseBkgnd( var Msg: TWMEraseBkgnd ); message wm_EraseBkgnd;
    procedure WMSetFocus( var Msg: TWMSetFocus ); message wm_SetFocus;
    procedure WMKillFocus( var Msg: TWMKillFocus ); message wm_KillFocus;
  protected
    FAboutInfo: TRzAboutInfo;
    FDragging: Boolean;
    FHotTrack: Boolean;
    FMouseOverButton: Boolean;
    FShowDownVersion: Boolean;
    FTransparent: Boolean;
    FThemeAware: Boolean;

    procedure UpdateDisplay; virtual;
    procedure RepaintDisplay; virtual;
    function GetHotTrackRect: TRect; virtual;

    procedure Draw3DText( Canvas: TCanvas; R: TRect; Flags: DWord ); virtual;

    { Event Dispatch Methods }
    procedure Click; override;
    procedure ChangeState; virtual; abstract;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseMove( Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;

    { Property Access Methods }
    procedure SetAlignmentVertical( Value: TAlignmentVertical ); virtual;

    procedure SetHotTrack( Value: Boolean ); virtual;
    procedure SetHighlightColor( Value: TColor ); virtual;

    procedure SetLightTextStyle( Value: Boolean ); virtual;
    procedure SetTextStyle( Value: TTextStyle ); virtual;
    procedure SetTextHighlightColor( Value: TColor ); virtual;
    procedure SetTextShadowColor( Value: TColor ); virtual;
    procedure SetTextShadowDepth( Value: Integer ); virtual;
    procedure SetThemeAware( Value: Boolean ); virtual;
    procedure SetTransparent( Value: Boolean ); virtual;

    { Property Declarations }
    property AlignmentVertical: TAlignmentVertical
      read FAlignmentVertical
      write SetAlignmentVertical
      default avCenter;

    property HotTrack: Boolean
      read FHotTrack
      write SetHotTrack
      default False;

    property HighlightColor: TColor
      read FHighlightColor
      write SetHighlightColor
      default clHighlight;

    property HotTrackColor: TColor
      read FHotTrackColor
      write FHotTrackColor
      default clHighlight;

    property HotTrackColorType: TRzHotTrackColorType
      read FHotTrackColorType
      write FHotTrackColorType
      default htctComplement;

    property TextHighlightColor: TColor
      read FTextHighlightColor
      write SetTextHighlightColor
      default clBtnHighlight;

    property LightTextStyle: Boolean
      read FLightTextStyle
      write SetLightTextStyle
      default False;

    property TextShadowColor: TColor
      read FTextShadowColor
      write SetTextShadowColor
      default clBtnShadow;

    property TextShadowDepth: Integer
      read FTextShadowDepth
      write SetTextShadowDepth
      default 2;

    property TextStyle: TTextStyle
      read FTextStyle
      write SetTextStyle
      default tsNormal;

    property Transparent: Boolean
      read FTransparent
      write SetTransparent
      default False;

    property ThemeAware: Boolean
      read FThemeAware
      write SetThemeAware
      default True;

    property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter
      write FOnMouseEnter;

    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave
      write FOnMouseLeave;
  public
    constructor Create( AOwner: TComponent ); override;
  end;


  {=================================}
  {== TRzButton Class Declaration ==}
  {=================================}

  TRzButton = class( TRzCustomButton )
  private
    FAlignment: TAlignment;
    FClicking: Boolean;
    FDefault: Boolean;
    FCancel: Boolean;
    FActive: Boolean;
    FModalResult: TModalResult;
    FKeyToggle: Boolean;
    FAllowAllUp: Boolean;
    FDown: Boolean;
    FGroupIndex: Integer;
    FShowDownPattern: Boolean;
    FShowFocusRect: Boolean;
    FDropDownOnEnter: Boolean;

    procedure ReadOldFrameFlatProp( Reader: TReader );

    { Message Handling Methods }
    procedure CMDialogKey( var Msg: TCMDialogKey ); message cm_DialogKey;
    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;
    procedure CMFocusChanged( var Msg: TCMFocusChanged ); message cm_FocusChanged;
    procedure CMRzButtonPressed( var Msg: TMessage ); message cm_RzButtonPressed;
  protected
    FState: TButtonState;
    FKeyWasPressed: Boolean;

    procedure CreateWnd; override;
    procedure DefineProperties( Filer: TFiler ); override;

    procedure UpdateDisplay; override;
    procedure ChangeState; override;
    function GetCaptionRect: TRect; virtual;
    procedure DrawButtonFace; virtual;
    procedure CreateBrushPattern( PatternBmp: TBitmap ); virtual;
    procedure Paint; override;

    procedure UpdateExclusive;

    { Event Dispatch Methods }
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure KeyUp( var Key: Word; Shift: TShiftState ); override;

    { Property Access Methods }
    procedure SetAlignment( Value: TAlignment ); virtual;
    procedure SetDefault( Value: Boolean ); virtual;
    procedure SetAllowAllUp( Value: Boolean ); virtual;
    procedure SetDown( Value: Boolean ); virtual;
    procedure SetGroupIndex( Value: Integer ); virtual;
    procedure SetHotTrack( Value: Boolean ); override;
    procedure SetShowDownPattern( Value: Boolean ); virtual;
    procedure SetShowFocusRect( Value: Boolean ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;

    procedure Click; override;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Alignment: TAlignment
      read FAlignment
      write SetAlignment
      default taCenter;

    property AllowAllUp: Boolean
      read FAllowAllUp
      write SetAllowAllUp
      default False;

    property Cancel: Boolean
      read FCancel
      write FCancel
      default False;

    property Default: Boolean
      read FDefault
      write SetDefault
      default False;

    property DropDownOnEnter: Boolean
      read FDropDownOnEnter
      write FDropDownOnEnter
      default True;

    property GroupIndex: Integer
      read FGroupIndex
      write SetGroupIndex
      default 0;

    { Ensure group index is declared before Down }
    property Down: Boolean
      read FDown
      write SetDown
      default False;

    property ModalResult: TModalResult
      read FModalResult
      write FModalResult
      default mrNone;

    property ShowDownPattern: Boolean
      read FShowDownPattern
      write SetShowDownPattern
      default True;

    property ShowFocusRect: Boolean
      read FShowFocusRect
      write SetShowFocusRect
      default True;

    { Inherited Properties & Events }
    property Action;
    property AlignmentVertical;
    property Anchors;
    property BiDiMode;
    property Caption;
    property Color default clBtnFace;
    property Constraints;
    property DragKind;
    property DragMode;
    property DragCursor;
    property Enabled;
    property Font;
    property HelpContext;
    property Height default 25;
    property HighlightColor;
    property Hint;
    property HotTrack;
    property HotTrackColor;
    property HotTrackColorType;
    property LightTextStyle;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property TextHighlightColor;
    property TextShadowColor;
    property TextShadowDepth;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property TextStyle;
    property ThemeAware;
    property Visible;
    property Width default 75;

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


  {=================================}
  {== TRzBitBtn Class Declaration ==}
  {=================================}

  TRzBitBtn = class( TRzButton )
  private
    FGlyph: TBitmap;
    FKind: TBitBtnKind;
    FLayout: TButtonLayout;
    FMargin: Integer;
    FNumGlyphs: TNumGlyphs;
    FSpacing: Integer;
    FModifiedGlyph: Boolean;

    FImageIndex: TImageIndex;
    FDisabledIndex: TImageIndex;
    FImages: TCustomImageList;
    FImageChangeLink: TChangeLink;

    { Internal Event Handlers }
    procedure GlyphChangedHandler( Sender: TObject );
    procedure ImageListChange( Sender: TObject );
  protected
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;
    procedure ActionChange( Sender: TObject; CheckDefaults: Boolean ); override;

    function GetPalette: HPALETTE; override;
    function GetImageSize: TPoint; virtual;
    function GetCaptionRect: TRect; override;
    function GetGlyphRect: TRect; virtual;
    procedure DrawImage( R: TRect ); virtual;
    procedure DrawGlyph( R: TRect ); virtual;
    procedure DrawButtonFace; override;
    procedure ChangeScale( M, D: Integer ); override;

    function IsCustom: Boolean;
    function IsCustomCaption: Boolean;

    { Property Access Methods }
    procedure SetGlyph( Value: TBitmap ); virtual;
    function GetKind: TBitBtnKind; virtual;
    procedure SetKind( Value: TBitBtnKind ); virtual;
    procedure SetLayout( Value: TButtonLayout ); virtual;
    procedure SetMargin( Value: Integer ); virtual;
    procedure SetNumGlyphs( Value: TNumGlyphs ); virtual;
    procedure SetSpacing( Value: Integer ); virtual;
    procedure SetImageIndex( Value: TImageIndex ); virtual;
    procedure SetDisabledIndex( Value: TImageIndex ); virtual;
    procedure SetImages( Value: TCustomImageList ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Cancel
      stored IsCustom;

    property Caption
      stored IsCustomCaption;

    property Default
      stored IsCustom;

    property Glyph: TBitmap
      read FGlyph
      write SetGlyph
      stored IsCustom;

    property DisabledIndex: TImageIndex
      read FDisabledIndex
      write SetDisabledIndex
      default -1;

    property ImageIndex: TImageIndex
      read FImageIndex
      write SetImageIndex
      default -1;

    property Images: TCustomImageList
      read FImages
      write SetImages;

    property Kind: TBitBtnKind
      read GetKind
      write SetKind
      default bkCustom;

    property Layout: TButtonLayout
      read FLayout
      write SetLayout
      default blGlyphLeft;

    property Margin: Integer
      read FMargin
      write SetMargin
      default 2;

    property ModalResult
      stored IsCustom;

    property NumGlyphs: TNumGlyphs
      read FNumGlyphs
      write SetNumGlyphs
      stored IsCustom
      default 1;

    property Spacing: Integer
      read FSpacing
      write SetSpacing
      default 4;
  end;


  {=====================================}
  {== TRzMenuButton Class Declaration ==}
  {=====================================}

  TRzMenuButton = class( TRzBitBtn )
  private
    FDropped: Boolean;
    FDropDownMenu: TPopupMenu;
    FDropTime: DWord;
    FSkipNextClick: Boolean;
    FShowArrow: Boolean;
    FOnDropDown: TNotifyEvent;
    procedure WMKeyDown( var Msg: TWMKeyDown ); message wm_KeyDown;
  protected
    function GetCaptionRect: TRect; override;
    function GetGlyphRect: TRect; override;
    procedure Paint; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;
    procedure DoDropDown; virtual;

    { Event Dispatch Methods }
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure DropDown; dynamic;

    { Property Access Methods }
    procedure SetDropDownMenu( Value: TPopupMenu );
    procedure SetShowArrow( Value: Boolean ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure Click; override;
  published
    property DropDownMenu: TPopupMenu
      read FDropDownMenu
      write SetDropDownMenu;

    property ShowArrow: Boolean
      read FShowArrow
      write SetShowArrow
      default True;

    property OnDropDown: TNotifyEvent
      read FOnDropDown
      write FOnDropDown;

    { Inherited Properties & Events }
    property Width default 110;
  end;


  {========================================}
  {== TRzToolbarButton Class Declaration ==}
  {========================================}

  TRzToolbarButton = class;

  TRzToolbarButtonActionLink = class( TControlActionLink )
  protected
    FClient: TRzToolbarButton;
    procedure AssignClient( AClient: TObject ); override;
    function IsCheckedLinked: Boolean; override;
    procedure SetChecked( Value: Boolean ); override;
    function IsCaptionLinked: Boolean; override;
  end;

  TRzToolbarButtonActionLinkClass = class of TRzToolbarButtonActionLink;

  TRzToolbarButton = class( TSpeedButton )
  private
    FAboutInfo: TRzAboutInfo;
    FChangingGlyph: Boolean;
    FHotGlyph: TBitmap;
    FHotNumGlyphs: TNumGlyphs;
    FUseHotGlyph: Boolean;
    FStdGlyph: TBitmap;
    FStdNumGlyphs: TNumGlyphs;
    FIgnoreActionCaption: Boolean;
    FSaveCaption: TCaption;
    FShowCaption: Boolean;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;

    procedure ReadSaveCaption( Reader: TReader );
    procedure WriteSaveCaption( Writer: TWriter );

    { Message Handling Methods }
    procedure CMMouseEnter( var Msg: TMessage ); message cm_MouseEnter;
    procedure CMMouseLeave( var Msg: TMessage ); message cm_MouseLeave;
    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;

    { Internal Event Handlers }
    procedure HotGlyphChangedHandler( Sender: TObject );
  protected
    FMouseOverControl: Boolean;
    procedure DefineProperties( Filer: TFiler ); override;

    procedure ActionChange( Sender: TObject; CheckDefaults: Boolean ); override;
    function GetActionLinkClass: TControlActionLinkClass; override;

    { Event Dispatch Methods }
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;

    { Property Access Methods }
    procedure SetHotNumGlyphs( Value: TNumGlyphs ); virtual;
    procedure SetHotGlyph( Value: TBitmap ); virtual;
    function GetCaption: TCaption; virtual;
    procedure SetCaption( const Value: TCaption ); virtual;
    procedure SetShowCaption( Value: Boolean ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property HotGlyph: TBitmap
      read FHotGlyph
      write SetHotGlyph;

    property HotNumGlyphs: TNumGlyphs
      read FHotNumGlyphs
      write SetHotNumGlyphs
      default 1;

    property IgnoreActionCaption: Boolean
      read FIgnoreActionCaption
      write FIgnoreActionCaption
      default False;

    property Caption: TCaption
      read GetCaption
      write SetCaption;

    property ShowCaption: Boolean
      read FShowCaption
      write SetShowCaption
      default True;

    property UseHotGlyph: Boolean
      read FUseHotGlyph
      write FUseHotGlyph
      default False;

    property Flat default True;

    property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter
      write FOnMouseEnter;

    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave
      write FOnMouseLeave;
  end {$IFDEF VCL60_OR_HIGHER} deprecated {$ENDIF};


  {============================================}
  {== TRzMenuToolbarButton Class Declaration ==}
  {============================================}

  TRzMenuToolbarButton = class( TRzToolbarButton )
  private
    FDropped: Boolean;
    FDropDownMenu: TPopupMenu;
    FDropTime: DWord;
    FSkipNextClick: Boolean;
    FShowArrow: Boolean;
    FOnDropDown: TNotifyEvent;
  protected
    procedure Paint; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    { Event Dispatch Methods }
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure DropDown; dynamic;

    { Property Access Methods }
    procedure SetDropDownMenu( Value: TPopupMenu );
    procedure SetShowArrow( Value: Boolean );
  public
    constructor Create( AOwner: TComponent ); override;
    procedure Click; override;
    procedure DoDropDown; virtual;
  published
    property DropDownMenu: TPopupMenu
      read FDropDownMenu
      write SetDropDownMenu;

    property ShowArrow: Boolean
      read FShowArrow
      write SetShowArrow
      default True;

    property OnDropDown: TNotifyEvent
      read FOnDropDown
      write FOnDropDown;

    { Inherited Properties & Events }
    property DragMode default dmManual;
    property Margin default 2;
    property Width default 40;
  end {$IFDEF VCL60_OR_HIGHER} deprecated {$ENDIF};


  {===============================================}
  {== TRzToolButtonActionLink Class Declaration ==}
  {===============================================}

  TRzToolButton = class;

  TRzToolButtonActionLink = class( TControlActionLink )
  protected
    FClient: TRzToolButton;
    procedure AssignClient( AClient: TObject ); override;
    function IsCheckedLinked: Boolean; override;
    function IsImageIndexLinked: Boolean; override;
    procedure SetChecked( Value: Boolean ); override;
    procedure SetImageIndex( Value: Integer ); override;
  end;

  TRzToolButtonActionLinkClass = class of TRzToolButtonActionLink;

  TRzToolButtonState = ( tbsUp, tbsDisabled, tbsDown, tbsExclusive, tbsDropDown );
  TRzToolStyle = ( tsButton, tsDropDown );

  {=====================================}
  {== TRzToolButton Class Declaration ==}
  {=====================================}

  TRzToolButton = class( TGraphicControl )
  private
    FAboutInfo: TRzAboutInfo;
    FAllowAllUp: Boolean;
    FDown: Boolean;
    FDragging: Boolean;
    FFlat: Boolean;
    FGroupIndex: Integer;
    FImageIndex: TImageIndex;
    FDownIndex: TImageIndex;
    FDisabledIndex: TImageIndex;
    FHotIndex: TImageIndex;
    FImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    FLayout: TButtonLayout;
    FMouseOverButton: Boolean;
    FDropDownMenu: TPopupMenu;
    FDropTime: DWord;
    FTreatAsNormal: Boolean;
    FToolStyle: TRzToolStyle;
    FShowCaption: Boolean;
    FTransparent: Boolean;

    FUseToolbarButtonLayout: Boolean;
    FUseToolbarButtonSize: Boolean;
    FUseToolbarShowCaption: Boolean;

    FOnDropDown: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;

    function IsCheckedStored: Boolean;
    function IsImageIndexStored: Boolean;
    procedure UpdateExclusive;
    procedure UpdateTracking;

    { Internal Event Handlers }
    procedure ImageListChange( Sender: TObject );

    { Message Handling Methods }
    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;
    procedure CMMouseEnter( var Msg: TMessage ); message cm_MouseEnter;
    procedure CMMouseLeave( var Msg: TMessage ); message cm_MouseLeave;
    procedure CMButtonPressed( var Msg: TMessage ); message cm_ButtonPressed;
    procedure CMToolbarShowCaptionChanged( var Msg: TMessage ); message cm_ToolbarShowCaptionChanged;
    procedure CMToolbarButtonLayoutChanged( var Msg: TMessage ); message cm_ToolbarButtonLayoutChanged;
    procedure CMToolbarButtonSizeChanged( var Msg: TMessage ); message cm_ToolbarButtonSizeChanged;
    procedure CMTextChanged( var Msg: TMessage ); message cm_TextChanged;
  protected
    FState: TRzToolButtonState;

    procedure Loaded; override;
    procedure PickupToolbarStyles; virtual;
    procedure Notification( AComponent : TComponent; Operation : TOperation ); override;
    procedure DrawBtnBorder( var R: TRect ); virtual;
    procedure DrawImage( R: TRect ); virtual;
    procedure DrawArrow; virtual;
    procedure DrawCaption( R: TRect ); virtual;
    procedure Paint; override;

    procedure DoDropDown; virtual;

    function GetImageSize: TPoint; virtual;
    function GetCaptionRect: TRect; virtual;
    function GetImageRect: TRect; virtual;
    procedure CheckMinSize;
    function CursorPosition: TPoint;

    procedure ActionChange( Sender: TObject; CheckDefaults: Boolean ); override;
    function GetActionLinkClass: TControlActionLinkClass; override;

    procedure AssignTo( Dest: TPersistent ); override;

    { Event Dispatch Methods }
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure DropDown; dynamic;
    procedure MouseMove( Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;

    { Property Access Methods }
    procedure SetAllowAllUp( Value: Boolean ); virtual;
    procedure SetDown( Value: Boolean ); virtual;
    procedure SetDropDownMenu( Value: TPopupMenu ); virtual;
    procedure SetFlat( Value: Boolean ); virtual;
    procedure SetGroupIndex( Value: Integer ); virtual;
    procedure SetHotIndex( Value: TImageIndex ); virtual;
    procedure SetImageIndex( Value: TImageIndex ); virtual;
    procedure SetDownIndex( Value: TImageIndex ); virtual;
    procedure SetDisabledIndex( Value: TImageIndex ); virtual;
    procedure SetImages( Value: TCustomImageList ); virtual;
    function IsLayoutStored: Boolean;
    procedure SetUseToolbarButtonLayout( Value: Boolean ); virtual;
    procedure SetLayout( Value: TButtonLayout ); virtual;
    procedure SetParent( Value: TWinControl ); override;
    function IsSizeStored: Boolean;
    procedure SetUseToolbarButtonSize( Value: Boolean ); virtual;
    function GetWidth: Integer; virtual;
    procedure SetWidth( Value: Integer ); virtual;
    function GetHeight: Integer; virtual;
    procedure SetHeight( Value: Integer ); virtual;
    function IsShowCaptionStored: Boolean;
    procedure SetUseToolbarShowCaption( Value: Boolean ); virtual;
    procedure SetShowCaption( Value: Boolean ); virtual;
    procedure SetToolStyle( Value: TRzToolStyle ); virtual;
    procedure SetTransparent( Value: Boolean ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function ImageList: TCustomImageList;

    procedure Click; override;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property AllowAllUp: Boolean
      read FAllowAllUp
      write SetAllowAllUp
      default False;

    property DisabledIndex: TImageIndex
      read FDisabledIndex
      write SetDisabledIndex
      default -1;

    // GroupIndex must be before Down
    property GroupIndex: Integer
      read FGroupIndex
      write SetGroupIndex
      default 0;

    property Down: Boolean
      read FDown
      write SetDown
      stored IsCheckedStored
      default False;

    property DownIndex: TImageIndex
      read FDownIndex
      write SetDownIndex
      default -1;

    property DropDownMenu: TPopupMenu
      read FDropDownMenu
      write SetDropDownMenu;

    property Flat: Boolean
      read FFlat
      write SetFlat
      default True;

    property Height: Integer
      read GetHeight
      write SetHeight
      stored IsSizeStored
      default 25;

    property HotIndex: TImageIndex
      read FHotIndex
      write SetHotIndex
      default -1;

    property ImageIndex: TImageIndex
      read FImageIndex
      write SetImageIndex
      stored IsImageIndexStored
      default -1;

    property Images: TCustomImageList
      read FImages
      write SetImages;

    property Layout: TButtonLayout
      read FLayout
      write SetLayout
      default blGlyphLeft;

    property ShowCaption: Boolean
      read FShowCaption
      write SetShowCaption
      stored IsShowCaptionStored;

    property Transparent: Boolean
      read FTransparent
      write SetTransparent
      default True;

    property UseToolbarButtonLayout: Boolean
      read FUseToolbarButtonLayout
      write SetUseToolbarButtonLayout
      default True;

    property UseToolbarButtonSize: Boolean
      read FUseToolbarButtonSize
      write SetUseToolbarButtonSize
      default True;

    property UseToolbarShowCaption: Boolean
      read FUseToolbarShowCaption
      write SetUseToolbarShowCaption
      default True;

    property ToolStyle: TRzToolStyle
      read FToolStyle
      write SetToolStyle
      default tsButton;

    property Width: Integer
      read GetWidth
      write SetWidth
      stored IsSizeStored
      default 25;

    property OnDropDown: TNotifyEvent
      read FOnDropDown
      write FOnDropDown;

    property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter
      write FOnMouseEnter;

    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave
      write FOnMouseLeave;


    { Inherited Properties & Events }
    property Action;
    property BiDiMode;
    property Caption;
    property Color default clBtnFace;
    property DragCursor;
    property DragKind;
    property DragMode default dmManual;
    property Enabled;
    property Font;
    property Hint;
    property ParentBiDiMode;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;


  {========================================}
  {== TRzControlButton Class Declaration ==}
  {========================================}

  TRzControlButtonStyle = ( cbsNone, cbsLeft, cbsUp, cbsRight, cbsDown, cbsDropDown );

  TRzControlButton = class( TGraphicControl )
  private
    FDown: Boolean;
    FDragging: Boolean;
    FFlat: Boolean;
    FMouseOverButton: Boolean;
    FGlyph: TBitmap;
    FNumGlyphs: TNumGlyphs;

    FRepeatClicks: Boolean;
    FRepeatTimer: TTimer;
    FInitialDelay: Word;
    FDelay: Word;
    FStyle: TRzControlButtonStyle;

    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;

    procedure UpdateTracking;

    { Internal Event Handlers }
    procedure GlyphChangedHandler( Sender: TObject );
    procedure TimerExpired( Sender: TObject );

    { Message Handling Methods }
    procedure CMMouseEnter( var Msg: TMessage ); message cm_MouseEnter;
    procedure CMMouseLeave( var Msg: TMessage ); message cm_MouseLeave;
  protected
    procedure DrawBtnFace( var R: TRect ); virtual;
    procedure DrawSpinButton( var R: TRect ); virtual;
    procedure DrawDropDownButton( var R: TRect ); virtual;
    procedure DrawGlyph( R: TRect ); virtual;
    procedure Paint; override;

    function GetImageSize: TPoint; virtual;
    function GetPalette: HPALETTE; override;

    function CursorPosition: TPoint;

    { Event Dispatch Methods }
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseEnter; virtual;
    procedure MouseLeave; virtual;

    { Property Access Methods }
    procedure SetFlat( Value: Boolean ); virtual;
    procedure SetGlyph( Value: TBitmap ); virtual;
    procedure SetNumGlyphs( Value: TNumGlyphs ); virtual;
    procedure SetStyle( Value: TRzControlButtonStyle ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure Click; override;
  published
    property Flat: Boolean
      read FFlat
      write SetFlat
      default False;

    property Glyph: TBitmap
      read FGlyph
      write SetGlyph;

    property NumGlyphs: TNumGlyphs
      read FNumGlyphs
      write SetNumGlyphs
      default 1;

    property Delay: Word
      read FDelay
      write FDelay
      default 100;

    property InitialDelay: Word
      read FInitialDelay
      write FInitialDelay
      default 400;

    property RepeatClicks: Boolean
      read FRepeatClicks
      write FRepeatClicks
      default False;

    property Style: TRzControlButtonStyle
      read FStyle
      write SetStyle
      default cbsNone;

    property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter
      write FOnMouseEnter;

    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave
      write FOnMouseLeave;

    { Inherited Properties & Events }
    property Action;
    property Caption;
    property Color default clBtnFace;
    property DragCursor;
    property DragKind;
    property DragMode default dmManual;
    property Enabled;
    property Hint;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;


  {======================================}
  {== TRzShapeButton Class Declaration ==}
  {======================================}

  TRzBevelWidth = 0..2;
  TRzCaptionPosition = ( cpCentered, cpXY );

  TRzShapeButton = class( TGraphicControl )
  private
    FAboutInfo: TRzAboutInfo;
    FAutoSize: Boolean;
    FBevelWidth: TRzBevelWidth;
    FBevelHighlightColor: TColor;
    FBevelShadowColor: TColor;
    FBitmap: TBitmap;
    FBitmapUp: TBitmap;
    FBitmapDown: TBitmap;
    FBorderStyle: TBorderStyle;
    FBorderColor: TColor;
    FDragging: Boolean;
    FHitTestMask: TBitmap;
    FPrevCursorSaved: Boolean;
    FPrevCursor: TCursor;
    FPrevShowHintSaved: Boolean;
    FPrevShowHint: Boolean;
    FPrevParentShowHint: Boolean;
    FPreciseClick: Boolean;
    FPreciseShowHint: Boolean;
    FCaptionPosition: TRzCaptionPosition;
    FCaptionX: Integer;
    FCaptionY: Integer;

    procedure AdjustBounds;
    procedure AdjustButtonSize( var W, H: Integer );
    function BevelColor( const AState: TButtonState; const TopLeft: Boolean ): TColor;
    procedure BitmapChanged( Sender: TObject );
    procedure Create3DBitmap( Source: TBitmap; const AState: TButtonState; Target: TBitmap );
    procedure InitPalette( DC: HDC );

    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
    procedure CMTextChanged( var Msg: TMessage ); message cm_TextChanged;
    procedure CMSysColorChange( var Msg: TMessage ); message cm_SysColorChange;
    procedure CMHitTest( var Msg: TCMHitTest ); message cm_HitTest;
  protected
    FState: TButtonState;

    procedure DefineProperties( Filer: TFiler ); override;
    procedure DrawButtonText( Canvas: TCanvas; const Caption: string;
                              TextBounds: TRect; State: TButtonState ); virtual;
    function GetPalette: HPALETTE; override;
    function GetCaptionRect( Canvas: TCanvas; const Caption: string ): TRect; virtual;

    procedure Loaded; override;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseMove( Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure Paint; override;

    procedure ReadBitmapUpData( Stream: TStream ); virtual;
    procedure WriteBitmapUpData( Stream: TStream ); virtual;
    procedure ReadBitmapDownData( Stream: TStream ); virtual;
    procedure WriteBitmapDownData( Stream: TStream ); virtual;

    { Property Access Methods }
    {$IFDEF VCL60_OR_HIGHER}
    procedure SetAutoSize( Value: Boolean ); override;
    {$ELSE}
    procedure SetAutoSize( Value: Boolean ); virtual;
    {$ENDIF}
    procedure SetBevelHighlightColor( Value: TColor ); virtual;
    procedure SetBevelShadowColor( Value: TColor ); virtual;
    procedure SetBevelWidth( Value: TRzBevelWidth ); virtual;
    procedure SetBitmap( Value: TBitmap ); virtual;
    procedure SetBitmapDown( Value: TBitmap ); virtual;
    procedure SetBitmapUp( Value: TBitmap ); virtual;
    procedure SetBorderColor( Value: TColor ); virtual;
    procedure SetBorderStyle( Value: TBorderStyle ); virtual;
    procedure SetCaptionPosition( Value: TRzCaptionPosition ); virtual;
    procedure SetCaptionX( Value: Integer ); virtual;
    procedure SetCaptionY( Value: Integer ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure Click; override;
    procedure Invalidate; override;
    function PtInMask( const X, Y: Integer ): Boolean; virtual;
    procedure SetBounds( ALeft, ATop, AWidth, AHeight: Integer ); override;
    procedure SetCaptionXY( const X, Y: Integer ); virtual;

    property BitmapUp: TBitmap
      read FBitmapUp;

    property BitmapDown: TBitmap
      read FBitmapDown;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property AutoSize: Boolean
      read FAutoSize
      write SetAutoSize
      default True;

    property BevelHighlightColor: TColor
      read FBevelHighlightColor
      write SetBevelHighlightColor
      default clBtnHighlight;

    property BevelShadowColor: TColor
      read FBevelShadowColor
      write SetBevelShadowColor
      default clBtnShadow;

    property BevelWidth: TRzBevelWidth
      read FBevelWidth
      write SetBevelWidth
      default 2;

    property Bitmap: TBitmap
      read FBitmap
      write SetBitmap;

    // BorderStyle should be bsSingle to get the best effect between
    // the button's up and down 3D images.  However, it can be changed
    // without any negative side-effects.
    property BorderStyle: TBorderStyle
      read FBorderStyle
      write SetBorderStyle
      default bsSingle;

    property BorderColor: TColor
      read FBorderColor
      write SetBorderColor
      default cl3DDkShadow;

    property PreciseClick: Boolean
      read FPreciseClick
      write FPreciseClick
      default True;

    property PreciseShowHint: Boolean
      read FPreciseShowHint
      write FPreciseShowHint
      default True;

    property CaptionPosition: TRzCaptionPosition
      read FCaptionPosition
      write SetCaptionPosition
      default cpCentered;

    property CaptionX: Integer
      read FCaptionX
      write SetCaptionX
      default 0;

    property CaptionY: Integer
      read FCaptionY
      write SetCaptionY
      default 0;

    { Inherited Properties & Events }
    property Anchors;
    property Caption;
    property Constraints;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;



function GetBitBtnGlyph( Kind: TBitBtnKind ): TBitmap;

implementation

uses
  {$IFDEF VCL70_OR_HIGHER}
  Themes,
  {$ELSE}
  RzThemeSrv,
  {$ENDIF}
  RzPanel,
  RzGrafx,
  RzCommonBitmaps;

const
  ArrowRegionWidth = 14;
  MinDelay = 100;
  { This value represents an upper limit for the amount of time it takes
    for the MouseDown method to finish (after displaying the drop down menu)
    and the time it takes for the next MouseDown method to start executing.
    Unfortunately, this value will be processor dependent.  That is, the
    faster the processor, the less this delay needs to be. But, we'll just
    set this to a upper limit. }

const
  BitBtnResNames: array[ TBitBtnKind ] of PChar = ( nil, 'RZCOMMON_OK', 'RZCOMMON_CANCEL', 'RZCOMMON_HELP',
                                                    'RZCOMMON_YES', 'RZCOMMON_NO', 'RZCOMMON_CLOSE', 'RZCOMMON_ABORT',
                                                    'RZCOMMON_RETRY', 'RZCOMMON_IGNORE', 'RZCOMMON_ALL');

  BitBtnModalResults: array[ TBitBtnKind ] of TModalResult = ( 0, mrOk, mrCancel, 0, mrYes, mrNo, 0, mrAbort,
                                                               mrRetry, mrIgnore, mrAll );

var
  BitBtnGlyphs: array[ TBitBtnKind ] of TBitmap;


function GetBitBtnGlyph( Kind: TBitBtnKind ): TBitmap;
begin
  if BitBtnGlyphs[ Kind ] = nil then
  begin
    BitBtnGlyphs[ Kind ] := TBitmap.Create;
    BitBtnGlyphs[ Kind ].LoadFromResourceName( HInstance, BitBtnResNames[ Kind ] );
  end;
  Result := BitBtnGlyphs[ Kind ];
end;


function GetMenuWidth( Control: TControl; DropDownMenu: TPopupMenu ): Integer;
var
  Canvas: TControlCanvas;
  W, I: Integer;
begin
  Canvas := TControlCanvas.Create;
  Canvas.Control := Control;
  try
    Canvas.Font := Screen.MenuFont;
    Result := 0;
    for I := 0 to DropDownMenu.Items.Count - 1 do
    begin
      W := Canvas.TextWidth( DropDownMenu.Items[ I ].Caption );
      if W > Result then
        Result := W;
    end;
    Result := Result + 56;
  finally
    Canvas.Free;
  end;
end;


function GetMonitorContainingPoint( P: TPoint ): TMonitor;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Screen.MonitorCount - 1 do
  begin
    if PtInRect( GetMonitorBoundsRect( Screen.Monitors[ I ] ), P ) then
    begin
      Result := Screen.Monitors[ I ];
      Exit;
    end;
  end;
end;


{&RT}
{=============================}
{== TRzCustomButton Methods ==}
{=============================}

constructor TRzCustomButton.Create( AOwner: TComponent );
begin
  inherited;

  ControlStyle := [ csCaptureMouse, csSetCaption, csDoubleClicks, csReplicatable, csReflector ];

  FTransparent := False;

  Height := 17;
  Width := 115;
  TabStop := True;

  FAlignmentVertical := avCenter;

  FDragging := False;
  FMouseOverButton := False;

  FHotTrack := False;
  FHighlightColor := clHighlight;
  FHotTrackColor := clHighlight;
  FHotTrackColorType := htctComplement;

  FLightTextStyle := False;
  FTextStyle := tsNormal;
  FTextShadowDepth := 2;
  FTextShadowColor := clBtnShadow;
  FTextHighlightColor := clBtnHighlight;

  FThemeAware := True;
  {&RCI}
end;


procedure TRzCustomButton.SetAlignmentVertical( Value: TAlignmentVertical );
begin
  if FAlignmentVertical <> Value then
  begin
    FAlignmentVertical := Value;
    Invalidate;
  end;
end;


procedure TRzCustomButton.SetHotTrack( Value: Boolean );
begin
  if FHotTrack <> Value then
  begin
    FHotTrack := Value;
    Invalidate;
  end;
end;


procedure TRzCustomButton.SetHighlightColor( Value: TColor );
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomButton.SetTextHighlightColor( Value: TColor );
begin
  if FTextHighlightColor <> Value then
  begin
    FTextHighlightColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomButton.SetTextShadowColor( Value: TColor );
begin
  if FTextShadowColor <> Value then
  begin
    FTextShadowColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomButton.SetTextShadowDepth( Value: Integer );
begin
  if FTextShadowDepth <> Value then
  begin
    FTextShadowDepth := Value;
    Invalidate;
  end;
end;


procedure TRzCustomButton.SetLightTextStyle( Value: Boolean );
begin
  if FLightTextStyle <> Value then
  begin
    FLightTextStyle := Value;
    Invalidate;
  end;
end;


procedure TRzCustomButton.SetTextStyle( Value: TTextStyle );
begin
  if FTextStyle <> Value then
  begin
    FTextStyle := Value;
    Invalidate;
  end;
end;


procedure TRzCustomButton.SetThemeAware( Value: Boolean );
begin
  if FThemeAware <> Value then
  begin
    FThemeAware := Value;
    Invalidate;
  end;
end;


procedure TRzCustomButton.SetTransparent( Value: Boolean );
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    Invalidate;
  end;
end;


procedure TRzCustomButton.Click;
begin
  inherited;
  {&RV}
end;


// Process wm_SetFocus and wm_KillFocus messages instead of overriding DoEnter
// and DoExit because the window messages are correctly sent when the form is
// activated and deactivated

procedure TRzCustomButton.WMSetFocus( var Msg: TWMSetFocus );
begin
  inherited;
  // When control gets focus, update display to show focus border
  RepaintDisplay;
end;

procedure TRzCustomButton.WMKillFocus( var Msg: TWMKillFocus );
begin
  inherited;
  // When control loses focus, update display to remove focus border
  RepaintDisplay;
end;


procedure TRzCustomButton.WMEraseBkgnd( var Msg: TWMEraseBkgnd );
begin
  if FTransparent then
  begin
    DrawParentImage( Self, Msg.DC, True );
    Msg.Result := 1;
  end
  else
    inherited;
end;


procedure TRzCustomButton.RepaintDisplay;
begin
  Repaint;
end;


procedure TRzCustomButton.UpdateDisplay;
begin
end;


function TRzCustomButton.GetHotTrackRect: TRect;
begin
  Result := ClientRect;
end;


procedure TRzCustomButton.Draw3DText( Canvas: TCanvas; R: TRect; Flags: DWord );
var
  TempRct: TRect;
  ULColor, LRColor: TColor;
  H: Integer;
begin
  Canvas.Brush.Style := bsClear;

  // For some reason, under WinXP with Visual Styles, if a button is placed on a panel, the font always appears as
  // the System font. Although the Canvas.Font object says that it is not.  We change the name of the font here to
  // and then reset the font back to the control's font.
  Canvas.Font.Name := 'System';
  Canvas.Font := Self.Font;
  TempRct := R;

  H := DrawText( Canvas.Handle, PChar( Caption ), -1, TempRct,
                 dt_CalcRect or dt_WordBreak or dt_ExpandTabs or dt_VCenter or dt_Center );

  if FAlignmentVertical = avCenter then
  begin
    R.Top := ( ( R.Bottom + R.Top ) - H ) shr 1;
    R.Bottom := R.Top + H;
  end
  else if FAlignmentVertical = avBottom then
    R.Top := R.Bottom - H - 1;
  TempRct := R;

  if UseRightToLeftAlignment then
    Flags := Flags or dt_Right or dt_RtlReading;

  if Enabled then
  begin
    if FTextStyle in [ tsRecessed, tsRaised ] then
    begin
      if FTextStyle = tsRaised then
      begin
        ULColor := FTextHighlightColor;
        LRColor := FTextShadowColor;
      end
      else
      begin
        ULColor := FTextShadowColor;
        LRColor := FTextHighlightColor;
      end;

      if ( FTextStyle = tsRecessed ) or not FLightTextStyle then
      begin
        OffsetRect( TempRct, 1, 1 );
        Canvas.Font.Color := LRColor;
        DrawText( Canvas.Handle, PChar( Caption ), -1, TempRct, Flags );
      end;

      if ( FTextStyle = tsRaised ) or not FLightTextStyle then
      begin
        TempRct := R;
        OffsetRect( TempRct, -1, -1 );
        Canvas.Font.Color := ULColor;
        DrawText( Handle, PChar( Caption ), -1, TempRct, Flags );
      end;
    end
    else if FTextStyle = tsShadow then
    begin
      if ( Flags and dt_Right ) = dt_Right then
        OffsetRect( TempRct, 0, FTextShadowDepth )
      else
        OffsetRect( TempRct, FTextShadowDepth, FTextShadowDepth );
      Canvas.Font.Color := FTextShadowColor;
      DrawText( Canvas.Handle, PChar( Caption ), -1, TempRct, Flags )
    end;

    Canvas.Font.Color := Self.Font.Color;
    if ( Flags and dt_Right ) = dt_Right then
      OffsetRect( R, -FTextShadowDepth, 0 );
    DrawText( Canvas.Handle, PChar( Caption ), -1, R, Flags );
  end
  else { if not Enabled }
  begin
    Canvas.Font.Color := clBtnHighlight;
    OffsetRect( R, 1, 1 );
    DrawText( Canvas.Handle, PChar( Caption ), -1, R, Flags );
    Canvas.Font.Color := clBtnShadow;
    OffsetRect( R, -1, -1 );
    DrawText( Canvas.Handle, PChar( Caption ), -1, R, Flags );
  end;

  Canvas.Brush.Style := bsSolid;
end; {= TRzCustomButton.Draw3DText =}


procedure TRzCustomButton.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;

  if ( Button = mbLeft ) and Enabled then
  begin
    // Cannot call SetFocus method b/c if the control is active, it will not change the focus back to this control.
    // This can happen if a dialog is displayed as a result of the clicking the button and the button is disabled.
    Windows.SetFocus( Handle );

    if Focused then
    begin
      FShowDownVersion := True;
      UpdateDisplay;
      FDragging := True;
    end;
  end;
end;


procedure TRzCustomButton.MouseMove( Shift: TShiftState; X, Y: Integer );
var
  NewState: Boolean;
begin
  inherited;

  if FDragging then
  begin
    NewState := ( X >= 0 ) and ( X < ClientWidth ) and ( Y >= 0 ) and ( Y <= ClientHeight );

    if NewState <> FShowDownVersion then
    begin
      FShowDownVersion := NewState;
      UpdateDisplay;
    end;
  end;
end;


procedure TRzCustomButton.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  Pt: TPoint;
begin
  inherited;

  if FDragging then
  begin
    FDragging := False;
    FShowDownVersion := False;
    Pt := Point( X, Y );
    if PtInRect( Rect( 0, 0, ClientWidth, ClientHeight ), Pt ) then
    begin
      ChangeState;
    end;
    UpdateDisplay;
  end;
end;


procedure TRzCustomButton.MouseEnter;
begin
  FMouseOverButton := True;
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
end;


procedure TRzCustomButton.CMMouseEnter( var Msg: TMessage );
var
  R: TRect;
begin
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  MouseEnter;
  if FHotTrack or ( FThemeAware and ThemeServices.ThemesEnabled ) then
  begin
    R := GetHotTrackRect;
    InvalidateRect( Handle, @R, False );
  end;
end;


procedure TRzCustomButton.MouseLeave;
begin
  FMouseOverButton := False;
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
end;


procedure TRzCustomButton.CMMouseLeave( var Msg: TMessage );
var
  R: TRect;
begin
  inherited;
  MouseLeave;
  if FHotTrack or ( FThemeAware and ThemeServices.ThemesEnabled ) then
  begin
    R := GetHotTrackRect;
    InvalidateRect( Handle, @R, False );
  end;
end;


procedure TRzCustomButton.CMEnabledChanged( var Msg: TMessage );
begin
  if HandleAllocated and not ( csDesigning in ComponentState ) then
    EnableWindow( Handle, Enabled );
  Invalidate;
end;


procedure TRzCustomButton.CMTextChanged( var Msg: TMessage );
begin
  inherited;
  Repaint;
end;



{=======================}
{== TRzButton Methods ==}
{=======================}

constructor TRzButton.Create( AOwner: TComponent );
begin
  inherited;
  Height := 25;
  Width := 75;
  FAlignment := taCenter;

  FShowDownPattern := True;
  FShowFocusRect := True;
  FDropDownOnEnter := True;

  Color := clBtnFace;
  {&RCI}
end;


procedure TRzButton.CreateWnd;
begin
  inherited;
  FActive := FDefault;
  {&RV}
end;


procedure TRzButton.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the FrameFlat property was renamed to HotTrack
  Filer.DefineProperty( 'FrameFlat', ReadOldFrameFlatProp, nil, False );
end;


procedure TRzButton.ReadOldFrameFlatProp( Reader: TReader );
begin
  HotTrack := Reader.ReadBoolean;
end;


procedure TRzButton.ChangeState;
begin
  if FGroupIndex = 0 then
    UpdateDisplay
  else
    SetDown( not FDown );

  FClicking := True;
  try
    Click;
  finally
    FClicking := False;
  end;
end;


procedure TRzButton.UpdateDisplay;
begin
  Invalidate;
end;


function TRzButton.GetCaptionRect: TRect;
begin
  Result := ClientRect;
  InflateRect( Result, -5, -5 );

  if not HotTrack and not ( FThemeAware and ThemeServices.ThemesEnabled ) then
  begin
    if FGroupIndex = 0 then
    begin
      if FShowDownVersion then
        OffsetRect( Result, 1, 1 );
    end
    else
    begin
      if ( FState in [ bsDown, bsExclusive ] ) or FShowDownVersion then
        OffsetRect( Result, 1, 1 );
    end;
  end;
end;


procedure TRzButton.DrawButtonFace;
begin
  { Draw Caption }
  Draw3DText( Canvas, GetCaptionRect, dt_WordBreak or dt_ExpandTabs or DrawTextAlignments[ Alignment ] );
end;


procedure TRzButton.CreateBrushPattern( PatternBmp: TBitmap );
var
  X: Integer;
  Y: Integer;
  C: TColor;
begin
  C := clSilver;
  if ColorToRGB( Color) = clSilver then
    C := clGray;

  PatternBmp.Width := 8;
  PatternBmp.Height := 8;
  with PatternBmp.Canvas do
  begin
    Brush.Style := bsSolid;
    Brush.Color := Color;
    FillRect( Rect( 0, 0, PatternBmp.Width, PatternBmp.Height ) );
    for Y := 0 to 7 do
      for X := 0 to 7 do
        if ( Y mod 2 ) = ( X mod 2 ) then
          Pixels[ X, Y ] := C;
  end;
end;


procedure TRzButton.Paint;
var
  FocusRect, R, TempRect: TRect;
  PatternBmp: TBitmap;
  BorderColor, DarkColor, LightColor: TColor;
  H: Byte;
  ElementDetails: TThemedElementDetails;
begin
  inherited;

  FocusRect := ClientRect;
  if FHotTrack or ( FThemeAware and ThemeServices.ThemesEnabled ) then
    InflateRect( FocusRect, -3, -3 )
  else
    InflateRect( FocusRect, -4, -4 );

  if FGroupIndex <> 0 then
  begin
    if ( FState in [ bsDown, bsExclusive ] ) or FShowDownVersion then
      OffsetRect( FocusRect, 1, 1 );
  end;

  R := ClientRect;

  if FThemeAware and ThemeServices.ThemesEnabled then
  begin
    if Enabled then
    begin
      if ( FState in [ bsDown, bsExclusive ] ) or FShowDownVersion then
        ElementDetails := ThemeServices.GetElementDetails( tbPushButtonPressed )
      else
      begin
        if FMouseOverButton then
          ElementDetails := ThemeServices.GetElementDetails( tbPushButtonHot )
        else if ( FGroupIndex = 0 ) and ( ( FActive or Focused ) and not FShowDownVersion ) then
          ElementDetails := ThemeServices.GetElementDetails( tbPushButtonDefaulted )
        else
          ElementDetails := ThemeServices.GetElementDetails( tbPushButtonNormal )
      end;
    end
    else
      ElementDetails := ThemeServices.GetElementDetails( tbPushButtonDisabled );

    ThemeServices.DrawParentBackground( Handle, Canvas.Handle, @ElementDetails, True, @R );
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );
  end
  else if FHotTrack then
  begin
    if Enabled then
    begin
      // Draw Outer Recessed Border
      DarkColor := DarkerColor( clBtnFace, 20 );
      LightColor := LighterColor( clBtnFace, 20 );

      Canvas.Pen.Color := DarkColor;
      // Left side
      Canvas.MoveTo( R.Left, R.Top + 2 );
      Canvas.LineTo( R.Left, R.Bottom - 2 );
      // Top side
      Canvas.MoveTo( R.Left + 2, R.Top );
      Canvas.LineTo( R.Right - 2, R.Top );

      Canvas.Pen.Color := LightColor;
      // Right side
      Canvas.MoveTo( R.Right - 1, R.Top + 2 );
      Canvas.LineTo( R.Right - 1, R.Bottom - 2 );
      // Bottom side
      Canvas.MoveTo( R.Left + 2, R.Bottom - 1 );
      Canvas.LineTo( R.Right - 2, R.Bottom - 1 );

      Canvas.Pixels[ R.Left + 1, R.Top + 1 ] := DarkColor;
      Canvas.Pixels[ R.Right - 2, R.Top + 1 ] := DarkColor;
      Canvas.Pixels[ R.Right - 2, R.Bottom - 2 ] := LightColor;
      Canvas.Pixels[ R.Left + 1, R.Bottom - 2 ] := DarkColor;


      InflateRect( R, -1, -1 );

      // Draw Solid Border
      if Color = clBtnFace then
        BorderColor := cl3DDkShadow
      else
        BorderColor := DarkerColor( Color, 150 );

      Canvas.Pen.Color := BorderColor;
      // Left side
      Canvas.MoveTo( R.Left, R.Top + 1 );
      Canvas.LineTo( R.Left, R.Bottom - 1 );
      // Top side
      Canvas.MoveTo( R.Left + 1, R.Top );
      Canvas.LineTo( R.Right - 1, R.Top );
      // Right side
      Canvas.MoveTo( R.Right - 1, R.Top + 1 );
      Canvas.LineTo( R.Right - 1, R.Bottom - 1 );
      // Bottom side
      Canvas.MoveTo( R.Left + 1, R.Bottom - 1 );
      Canvas.LineTo( R.Right - 1, R.Bottom - 1 );

      InflateRect( R, -1, -1 );

      // Draw Shading

      if ( FState in [ bsDown, bsExclusive ] ) or FShowDownVersion then
      begin
        Canvas.Brush.Color := DarkerColor( Color, 10 );
        Canvas.FillRect( R );
      end
      else
      begin
        if FMouseOverButton then
        begin
          H := ColorHue( FHotTrackColor );
          if FHotTrackColorType = htctComplement then
          begin
            if H >= 120 then
              H := H - 120
            else
              H := H + 120;
            LightColor := HSLToColor( H, 220, 180 );
            DarkColor := DarkerColor( LightColor, 30 );
          end
          else
          begin
            LightColor := LighterColor( FHotTrackColor, 30 );
            DarkColor := DarkerColor( FHotTrackColor, 30 );
          end;

          TempRect := DrawBevel( Canvas, R, LightColor, DarkColor, 1, sdAllSides );

          LightColor := DarkerColor( LightColor, 10 );
          DarkColor := LighterColor( DarkColor, 10 );
          TempRect := DrawBevel( Canvas, TempRect, LightColor, DarkColor, 1, sdAllSides );

          Canvas.Brush.Color := Color;
          Canvas.FillRect( TempRect );
        end
        else if ( FGroupIndex = 0 ) and ( ( FActive or Focused ) and not FShowDownVersion ) then
        begin
          H := ColorHue( FHighlightColor );
          LightColor := HSLToColor( H, 220, 220 );
          DarkColor := DarkerColor( LightColor, 30 );
          TempRect := DrawBevel( Canvas, R, LightColor, DarkColor, 1, sdAllSides );

          LightColor := DarkerColor( LightColor, 10 );
          DarkColor := LighterColor( DarkColor, 10 );
          TempRect := DrawBevel( Canvas, TempRect, LightColor, DarkColor, 1, sdAllSides );

          Canvas.Brush.Color := Color;
          Canvas.FillRect( TempRect );
        end
        else
        begin
          Canvas.Pen.Color := LighterColor( Color, 20 );
          Canvas.MoveTo( R.Left, R.Top );
          Canvas.LineTo( R.Right, R.Top );
          Canvas.Pen.Color := LighterColor( Color, 15 );
          Canvas.MoveTo( R.Left, R.Top + 1 );
          Canvas.LineTo( R.Right, R.Top + 1 );
          Canvas.Pen.Color := LighterColor( Color, 10 );
          Canvas.MoveTo( R.Left, R.Top + 2 );
          Canvas.LineTo( R.Right, R.Top + 2 );

          Canvas.Pen.Color := DarkerColor( Color, 10 );
          Canvas.MoveTo( R.Left, R.Bottom - 3 );
          Canvas.LineTo( R.Right - 2, R.Bottom - 3 );
          Canvas.LineTo( R.Right - 2, R.Top + 2 );
          Canvas.Pen.Color := DarkerColor( Color, 20 );
          Canvas.MoveTo( R.Left, R.Bottom - 2 );
          Canvas.LineTo( R.Right - 1, R.Bottom - 2 );
          Canvas.LineTo( R.Right - 1, R.Top + 2 );
          Canvas.Pen.Color := DarkerColor( Color, 30 );
          Canvas.MoveTo( R.Left, R.Bottom - 1 );
          Canvas.LineTo( R.Right, R.Bottom - 1 );

          // Fill Interior
          TempRect := Rect( R.Left, R.Top + 3, R.Right - 2, R.Bottom - 3 );
          Canvas.Brush.Color := Color;
          Canvas.FillRect( TempRect );
        end;
      end;
    end
    else // Disabled
    begin
      // Draw Solid Border
      if Color = clBtnFace then
        BorderColor := LighterColor( clBtnShadow, 30 )
      else
        BorderColor := DarkerColor( Color, 80 );

      InflateRect( R, -1, -1 );

      Canvas.Pen.Color := BorderColor;
      // Left side
      Canvas.MoveTo( R.Left, R.Top + 1 );
      Canvas.LineTo( R.Left, R.Bottom - 1 );
      // Top side
      Canvas.MoveTo( R.Left + 1, R.Top );
      Canvas.LineTo( R.Right - 1, R.Top );
      // Right side
      Canvas.MoveTo( R.Right - 1, R.Top + 1 );
      Canvas.LineTo( R.Right - 1, R.Bottom - 1 );
      // Bottom side
      Canvas.MoveTo( R.Left + 1, R.Bottom - 1 );
      Canvas.LineTo( R.Right - 1, R.Bottom - 1 );

      InflateRect( R, -1, -1 );

      Canvas.Brush.Color := Color;
      Canvas.FillRect( R );
    end;
  end
  else // Traditional Button appearance
  begin
    if FGroupIndex = 0 then
    begin
      if ( ( FActive or Focused ) and not FShowDownVersion ) or FClicking then
        R := DrawSides( Canvas, R, clWindowFrame, clWindowFrame, sdAllSides );
    end;

    if Color = clBtnFace then
    begin
      if FGroupIndex = 0 then
      begin
        R := DrawButtonBorder( Canvas, R, FShowDownVersion );
      end
      else
      begin
        if ( FState in [ bsDown, bsExclusive ] ) or FShowDownVersion then
          R := DrawBorder( Canvas, R, fsLowered )
        else
          R := DrawBorder( Canvas, R, fsButtonUp );
      end;
    end
    else
    begin
      if FGroupIndex = 0 then
      begin
        R := DrawColorButtonBorder( Canvas, R, Color, FShowDownVersion );
      end
      else
      begin
        if ( FState in [ bsDown, bsExclusive ] ) or FShowDownVersion then
          R := DrawColorBorder( Canvas, R, Color, fsLowered )
        else
          R := DrawColorButtonBorder( Canvas, R, Color, False );
      end;
    end;
  end;


  if ( FGroupIndex <> 0 ) and ( FState = bsExclusive ) and FShowDownPattern then
  begin
    PatternBmp := TBitmap.Create;
    try
      CreateBrushPattern( PatternBmp );
      Canvas.Brush.Bitmap := PatternBmp;
      Canvas.FillRect( R );
    finally
      PatternBmp.Free;
    end;
  end;


  Canvas.Font := Self.Font;
  Canvas.Brush.Color := Color;

  DrawButtonFace;

  if Focused and FShowFocusRect then
    DrawFocusBorder( Canvas, FocusRect )
end; {= TRzButton.Paint =}


procedure TRzButton.Click;
var
  Form: TCustomForm;
begin
  Form := GetParentForm( Self );
  if Form <> nil then
    Form.ModalResult := ModalResult;
  inherited;
end;


procedure TRzButton.KeyDown( var Key: Word; Shift: TShiftState );
begin
  if ( Key = vk_Space ) and not ( ssAlt in Shift ) then
  begin
    FKeyToggle := True;
    FShowDownVersion := True;
    UpdateDisplay;
  end;
  inherited;
end;


procedure TRzButton.KeyUp( var Key: Word; Shift: TShiftState );
begin
  if Key = vk_Space then
  begin
    FShowDownVersion := False;
    if FKeyToggle then
      ChangeState;
    UpdateDisplay;
  end;
  inherited;
end;


procedure TRzButton.SetAlignment( Value: TAlignment );
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TRzButton.SetDefault( Value: Boolean );
var
  Form: TCustomForm;
begin
  FDefault := Value;
  if HandleAllocated then
  begin
    Form := GetParentForm( Self );
    if Form <> nil then
      Form.Perform( cm_FocusChanged, 0, Longint( Form.ActiveControl ) );
  end;
end;


procedure TRzButton.UpdateExclusive;
var
  Msg: TMessage;
begin
  if ( FGroupIndex <> 0 ) and ( Parent <> nil ) then
  begin
    Msg.Msg := cm_RzButtonPressed;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint( Self );
    Msg.Result := 0;
    Parent.Broadcast( Msg );
  end;
end;


procedure TRzButton.SetAllowAllUp( Value: Boolean );
begin
  if FAllowAllUp <> Value then
  begin
    FAllowAllUp := Value;
    UpdateExclusive;
  end;
end;


procedure TRzButton.SetDown( Value: Boolean );
begin
  if FGroupIndex = 0 then
    Value := False;

  if Value <> FDown then
  begin
    if FDown and ( not FAllowAllUp ) and ( FGroupIndex <> 0 ) then
      Exit;

    FDown := Value;
    if Value then
      FState := bsExclusive
    else
      FState := bsUp;

    Invalidate;

    if Value then
      UpdateExclusive;
  end;
end; {= TRzButton.SetDown =}


procedure TRzButton.SetGroupIndex( Value: Integer );
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    UpdateExclusive;
  end;
end;


procedure TRzButton.SetHotTrack( Value: Boolean );
begin
  inherited;
  FTransparent := FHotTrack;
  Invalidate;
end;


procedure TRzButton.SetShowDownPattern( Value: Boolean );
begin
  if FShowDownPattern <> Value then
  begin
    FShowDownPattern := Value;
    Invalidate;
  end;
end;


procedure TRzButton.SetShowFocusRect( Value: Boolean );
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    Invalidate;
  end;
end;


procedure TRzButton.CMDialogKey( var Msg: TCMDialogKey );
begin
  if ( ( ( Msg.CharCode = vk_Return ) and FActive ) or
       ( ( Msg.CharCode = vk_Escape ) and FCancel ) ) and
     ( KeyDataToShiftState( Msg.KeyData ) = [] ) and CanFocus then
  begin
    if not FDropDownOnEnter then
      FKeyWasPressed := True;
    try
      Click;
    finally
      FKeyWasPressed := False;
    end;
    Msg.Result := 1;
  end
  else
    inherited;
end;


procedure TRzButton.CMDialogChar( var Msg: TCMDialogChar );
begin
  if IsAccel( Msg.CharCode, Caption ) and CanFocus then
  begin
    Click;
    Msg.Result := 1;
  end
  else
    inherited;
end;


procedure TRzButton.CMFocusChanged( var Msg: TCMFocusChanged );
var
  MakeActive: Boolean;
begin
  with Msg do
  begin
    if ( Sender is TRzButton ) or ( Sender is TButton ) then
      MakeActive := Sender = Self
    else
      MakeActive := FDefault;
  end;

  if MakeActive <> FActive then
  begin
    FActive := MakeActive;
    Repaint;
  end;
  inherited;
end;


procedure TRzButton.CMRzButtonPressed( var Msg: TMessage );
var
  Sender: TRzButton;
begin
  if Msg.WParam = FGroupIndex then
  begin
    Sender := TRzButton( Msg.LParam );
    if Sender <> Self then
    begin
      if Sender.Down and FDown then
      begin
        FDown := False;
        FState := bsUp;
        Invalidate;
      end;

      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;



{=======================}
{== TRzBitBtn Methods ==}
{=======================}

constructor TRzBitBtn.Create( AOwner: TComponent );
begin
  inherited;

  FGlyph := TBitmap.Create;
  FGlyph.OnChange := GlyphChangedHandler;
  FNumGlyphs := 1;
  FKind := bkCustom;
  FLayout := blGlyphLeft;
  FSpacing := 4;
  FMargin := 2;

  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  FImageIndex := -1;
  FDisabledIndex := -1;
  {&RCI}
end;


destructor TRzBitBtn.Destroy;
begin
  FGlyph.Free;
  FImageChangeLink.Free;
  inherited;
end;


procedure TRzBitBtn.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if ( Operation = opRemove ) and ( AComponent = FImages ) then
    SetImages( nil )  // Call access method so connections to link object can be cleared
end;


function TRzBitBtn.IsCustom: Boolean;
begin
  Result := Kind = bkCustom;
end;


function TRzBitBtn.IsCustomCaption: Boolean;
begin
  Result := AnsiCompareStr( Caption, BitBtnCaptions[ FKind ] ) <> 0;
end;


procedure TRzBitBtn.GlyphChangedHandler( Sender: TObject );
var
  N: Integer;
begin
  if ( FGlyph.Height <> 0 ) and ( FGlyph.Width mod FGlyph.Height = 0 ) then
  begin
    N := FGlyph.Width div FGlyph.Height;
    if N > 4 then
      N := 1;
    SetNumGlyphs( N );
  end;
  Invalidate;
end;


procedure TRzBitBtn.SetGlyph( Value: TBitmap );
begin
  {&RV}
  FGlyph.Assign( Value );
  FModifiedGlyph := True;
end;


function TRzBitBtn.GetKind: TBitBtnKind;
begin
  if FKind <> bkCustom then
  begin
    if ( ( FKind in [ bkOK, bkYes ] ) xor Default ) or
       ( ( FKind in [ bkCancel, bkNo ]) xor Cancel ) or
       ( ModalResult <> BitBtnModalResults[ FKind ] ) or
       FModifiedGlyph then
    begin
      FKind := bkCustom;
    end;
  end;
  Result := FKind;
end;


procedure TRzBitBtn.SetKind( Value: TBitBtnKind );
begin
  if Value <> FKind then
  begin
    if Value <> bkCustom then
    begin
      Default := Value in [ bkOK, bkYes ];
      Cancel := Value in [ bkCancel, bkNo ];

      if ( ( csLoading in ComponentState ) and ( Caption = '' ) ) or
         ( not ( csLoading in ComponentState ) ) then
      begin
        if BitBtnCaptions[ Value ] <> '' then
          Caption := BitBtnCaptions[ Value ];
      end;

      ModalResult := BitBtnModalResults[ Value ];
      FGlyph.Assign( GetBitBtnGlyph( Value ) );
      NumGlyphs := 2;
      FModifiedGlyph := False;
    end;
    FKind := Value;
    Invalidate;
  end;
end; {= TRzBitBtn.SetKind =}


procedure TRzBitBtn.SetLayout( Value: TButtonLayout );
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;


procedure TRzBitBtn.SetMargin( Value: Integer );
begin
  if ( Value <> FMargin ) and ( Value >= -1 ) then
  begin
    FMargin := Value;
    Invalidate;
  end;
end;


procedure TRzBitBtn.SetNumGlyphs( Value: TNumGlyphs );
begin
  if FNumGlyphs <> Value then
  begin
    FNumGlyphs := Value;
    Invalidate;
  end;
end;


procedure TRzBitBtn.SetSpacing( Value: Integer );
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    Invalidate;
  end;
end;


procedure TRzBitBtn.ActionChange( Sender: TObject; CheckDefaults: Boolean );
begin
  inherited;

  if Sender is TCustomAction then
  begin
    if not CheckDefaults or ( Self.ImageIndex = -1 ) then
      Self.ImageIndex := TCustomAction( Sender ).ImageIndex;
  end;
end; {= TRzBitBtn.ActionChange =}


function TRzBitBtn.GetPalette: HPALETTE;
begin
  Result := Glyph.Palette;
end;


function TRzBitBtn.GetImageSize: TPoint;
begin
  if ( FImages <> nil ) and ( FImageIndex <> -1 ) then
    Result := Point( FImages.Width, FImages.Height )
  else if FGlyph <> nil then
    Result := Point( FGlyph.Width div FNumGlyphs, FGlyph.Height )
  else
    Result := Point( 0, 0 );
end;


function TRzBitBtn.GetCaptionRect: TRect;
var
  GlyphSize: TPoint;
  CaptionHeight, Offset, TotalH: Integer;
  TempRct: TRect;
begin
  { Adjust the size of the Text Rectangle based on the size of the Glyph
    and the Layout, Margin, and Spacing properties. }

  Result := inherited GetCaptionRect;

  if ( ( FImages = nil ) or ( FImageIndex = -1 ) ) and FGlyph.Empty then
    Exit;

  GlyphSize := GetImageSize;
  if FMargin >= 0 then
  begin
    case FLayout of
      blGlyphLeft:
        Inc( Result.Left, FMargin + GlyphSize.X + FSpacing );

      blGlyphRight:
        Dec( Result.Right, FMargin + GlyphSize.X + FSpacing );

      blGlyphTop:
        Inc( Result.Top, FMargin + GlyphSize.Y + FSpacing );

      blGlyphBottom:
        Dec( Result.Bottom, FMargin + GlyphSize.Y + FSpacing );
    end;
  end
  else { Margin = -1    Therefore, center the glyph and caption}
  begin
    with Canvas do
    begin
      Font := Self.Font;
      TempRct := Result;

      CaptionHeight := DrawText( Handle, PChar( Caption ), -1, TempRct,
                                 dt_CalcRect or dt_WordBreak or dt_ExpandTabs or dt_VCenter or dt_Center );
    end;

    case FLayout of
      blGlyphLeft:
        Inc( Result.Left, FMargin + GlyphSize.X + FSpacing );

      blGlyphRight:
        Dec( Result.Right, FMargin + GlyphSize.X + FSpacing );

      blGlyphTop:
      begin
        TotalH := CaptionHeight + GlyphSize.Y + FSpacing;
        Offset := ( Height - TotalH ) div 2;
        Inc( Result.Top, Offset + GlyphSize.Y );
        Result.Bottom := Result.Top + CaptionHeight;
      end;

      blGlyphBottom:
      begin
        TotalH := CaptionHeight + GlyphSize.Y + FSpacing;
        Offset := ( Height - TotalH ) div 2;
        Inc( Result.Top, Offset );
        Result.Bottom := Result.Top + CaptionHeight;
      end;
    end;
  end;
end; {= TRzBitBtn.GetCaptionRect =}


function TRzBitBtn.GetGlyphRect: TRect;
var
  GlyphSize: TPoint;
  CaptionHeight, Offset, TotalH: Integer;
  TempRct: TRect;
begin
  Result := inherited GetCaptionRect;
  if FShowDownVersion then
  begin
    if FThemeAware and ThemeServices.ThemesEnabled then
      OffsetRect( Result, -1, 0 )
    else
      OffsetRect( Result, -1, -1 );
  end;

  GlyphSize := GetImageSize;

  if FMargin >= 0 then
  begin
    case FLayout of
      blGlyphLeft:
        Inc( Result.Left, FMargin );

      blGlyphRight:
        Result.Left := Result.Right - FMargin - GlyphSize.X;

      blGlyphTop:
        Inc( Result.Top, FMargin );

      blGlyphBottom:
        Result.Top := Result.Bottom - FMargin - GlyphSize.Y;
    end;
  end
  else  { Margin = -1 }
  begin
    with Canvas do
    begin
      Font := Self.Font;
      TempRct := Result;

      CaptionHeight := DrawText( Handle, PChar( Caption ), -1, TempRct,
                                 dt_CalcRect or dt_WordBreak or dt_ExpandTabs or dt_VCenter or dt_Center );
    end;

    case FLayout of
      blGlyphRight:
        Result.Left := Result.Right - GlyphSize.X;

      blGlyphTop:
      begin
        TotalH := CaptionHeight + GlyphSize.Y + FSpacing;
        Offset := ( Height - TotalH ) div 2;
        Result.Top := Offset;
      end;

      blGlyphBottom:
      begin
        TotalH := CaptionHeight + GlyphSize.Y + FSpacing;
        Offset := ( Height - TotalH ) div 2;
        Inc( Result.Top, Offset + CaptionHeight );
      end;
    end;
  end;

  if FLayout in [ blGlyphLeft, blGlyphRight ] then
    Result.Top := Result.Top + ( Result.Bottom - Result.Top - GlyphSize.Y + 1 ) div 2
  else
    Result.Left := Result.Left + ( Result.Right - Result.Left - GlyphSize.X + 1 ) div 2;

  Result.Right := Result.Left + GlyphSize.X;
  Result.Bottom := Result.Top + GlyphSize.Y;

  if FShowDownVersion then
  begin
    if FThemeAware and ThemeServices.ThemesEnabled then
      OffsetRect( Result, 2, 0 )
    else
      OffsetRect( Result, 1, 1 );
  end;

end; {= TRzBitBtn.GetGlyphRect =}



procedure TRzBitBtn.ChangeScale( M, D: Integer );
begin
  inherited;
  FMargin := MulDiv( FMargin, M, D );
  FSpacing := MulDiv( FSpacing, M, D );
end;


procedure TRzBitBtn.DrawGlyph( R: TRect );
var
  DestRct, SrcRct: TRect;
  DestBmp: TBitmap;
  W, H: Integer;
  TransparentColor: TColor;
begin
  W := R.Right - R.Left;
  H := R.Bottom - R.Top;

  DestRct := Rect( 0, 0, W, H );
  if ( FNumGlyphs > 1 ) and not Enabled then
    SrcRct := Rect( W, 0, W + W, H )
  else
    SrcRct := Rect( 0, 0, W, H );

  // The DestBmp holds the desired region of the FGlyph bitmap

  DestBmp := TBitmap.Create;
  try
    // Don't Forget to Set the Width and Height of Destination Bitmap
    DestBmp.Width := W;
    DestBmp.Height := H;
    DestBmp.Canvas.Brush.Color := Color;
    TransparentColor := FGlyph.Canvas.Pixels[ 0, H - 1 ];

    DestBmp.Canvas.CopyRect( DestRct, Canvas, R );
    DrawFullTransparentBitmap( DestBmp.Canvas, FGlyph, DestRct, SrcRct, TransparentColor );
    Canvas.Draw( R.Left, R.Top, DestBmp );
  finally
    DestBmp.Free;
  end;
end; {= TRzBitBtn.DrawGlyph =}


procedure TRzBitBtn.DrawImage( R: TRect );
begin
  if FImages <> nil then
  begin
    if FDisabledIndex <> -1 then
    begin
      if Enabled then
      begin
        if FImageIndex <> -1 then
          FImages.Draw( Canvas, R.Left, R.Top, FImageIndex );
      end
      else
        FImages.Draw( Canvas, R.Left, R.Top, FDisabledIndex );
    end
    else if FImageIndex <> -1 then
      FImages.Draw( Canvas, R.Left, R.Top, FImageIndex, Enabled );
  end;
end; {= TRzBitBtn.DrawImage =}


procedure TRzBitBtn.DrawButtonFace;
var
  DestRct, GlyphRect, SrcRect, CaptionRect: TRect;
  W, H: Integer;
begin
  inherited;

  // Text display is handled by ancestor class.  Display glyph here.

  CaptionRect := GetCaptionRect;

  W := GetImageSize.X;
  H := GetImageSize.Y;

  DestRct := Rect( 0, 0, W, H );
  if ( FNumGlyphs > 1 ) and not Enabled then
    SrcRect := Rect( W, 0, W + W, H )
  else
    SrcRect := Rect( 0, 0, W, H );

  GlyphRect := GetGlyphRect;

    { The DestBmp holds the desired region of the FGlyph bitmap }

  if ( Kind = bkCustom ) and ( FImages <> nil ) and ( FImageIndex <> -1 ) then
    DrawImage( GlyphRect )
  else if not FGlyph.Empty then
    DrawGlyph( GlyphRect );


end; {= TRzBitBtn.Paint =}


procedure TRzBitBtn.SetImageIndex( Value: TImageIndex );
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Invalidate;
  end;
end;


procedure TRzBitBtn.SetDisabledIndex( Value: TImageIndex );
begin
  if FDisabledIndex <> Value then
  begin
    FDisabledIndex := Value;
    Invalidate;
  end;
end;


procedure TRzBitBtn.SetImages( Value: TCustomImageList );
begin
  if FImages <> nil then
    FImages.UnRegisterChanges( FImageChangeLink );

  FImages := Value;

  if FImages <> nil then
  begin
    FImages.RegisterChanges( FImageChangeLink );
    FImages.FreeNotification( Self );
  end;
  Invalidate;
end;


procedure TRzBitBtn.ImageListChange( Sender: TObject );
begin
  if Sender = Images then
  begin
    Update;         // Call Update instead of Invalidate to prevent flicker
  end;
end;



{===========================}
{== TRzMenuButton Methods ==}
{===========================}

constructor TRzMenuButton.Create( AOwner: TComponent );
begin
  inherited;
  {&RCI}
  ControlStyle := ControlStyle - [ csDoubleClicks ];
  FDropped := False;
  DragMode := dmManual;
  Width := 110;
  FShowArrow := True;
end;


procedure TRzMenuButton.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if ( Operation = opRemove ) and ( AComponent = FDropDownMenu ) then
    FDropDownMenu := nil;
end;


procedure TRzMenuButton.DoDropDown;
var
  P: TPoint;
  MenuWidth, FarRightEdge: Integer;
  Monitor: TMonitor;
begin
  if not Assigned( FDropDownMenu ) then
    Exit;

  DropDown;                                        { Generate OnDropDown event }

  P.X := 0;
  P.Y := Height;
  P := ClientToScreen( P );                    { Convert to screen coordinates }

  MenuWidth := GetMenuWidth( Self, FDropDownMenu );

  Monitor := GetMonitorContainingPoint( P );
  if Assigned( Monitor ) then
    FarRightEdge := GetMonitorWorkArea( Monitor ).Right
  else
    FarRightEdge := GetActiveWorkAreaWidth( Parent );
  if P.X + MenuWidth > FarRightEdge then
    Dec( P.X, MenuWidth - Width );

  FDropDownMenu.PopupComponent := Self;
  FDropDownMenu.Popup( P.X, P.Y );
end;


procedure TRzMenuButton.Click;
begin
  if FSkipNextClick then
    FSkipNextClick := False
  else if ( FDropDownMenu <> nil ) and not FKeyWasPressed then
    MouseDown( mbLeft, [ ssLeft ], 0, 0 )
  else
    inherited;
  {&RV}
end;


procedure TRzMenuButton.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  T: DWord;
begin
  FDropped := not FDropped;
  inherited;

  { Only go further if only left button is pressed }
  if ( FDropDownMenu = nil ) or ( Shift <> [ ssLeft ] ) then
    Exit;

  T := GetTickCount;
  if ( FDropTime > 0 ) and ( T < FDropTime + MinDelay ) then
  begin
    { If GetTickCount < FDropTime + MinDelay then this MouseDown method call
      is resulting from a "second" click on the button }
    if T < FDropTime + MinDelay then
      FSkipNextClick := True;
    FDropTime := 0;
    ReleaseCapture;
  end
  else
  begin
    DoDropDown;
    FSkipNextClick := True;
    FDropTime := GetTickCount;
  end;
  inherited MouseUp( Button, Shift, X, Y );                // Generate MouseUp event
end; {= TRzMenuButton.MouseDown =}


procedure TRzMenuButton.WMKeyDown( var Msg: TWMKeyDown );
begin
  FDropped := not FDropped;

  if Msg.CharCode = vk_F4 then
  begin
    DoDropDown;
    FSkipNextClick := True;
  end;
  inherited;
end;


procedure TRzMenuButton.DropDown;
begin
  if Assigned( FOnDropDown ) then
    FOnDropDown( FDropDownMenu );
end;


procedure TRzMenuButton.SetDropDownMenu( Value: TPopupMenu );
begin
  if FDropDownMenu <> Value then
  begin
    FDropDownMenu := Value;
    if Value <> nil then
      Value.FreeNotification( Self );
  end;
end;


procedure TRzMenuButton.SetShowArrow( Value: Boolean );
begin
  if FShowArrow <> Value then
  begin
    FShowArrow := Value;
    Invalidate;
  end;
end;


function TRzMenuButton.GetCaptionRect: TRect;
begin
  Result := inherited GetCaptionRect;
  if FShowArrow then
    Dec( Result.Right, 14 );
end;


function TRzMenuButton.GetGlyphRect: TRect;
begin
  Result := inherited GetGlyphRect;
  if FShowArrow then
  begin
    case FLayout of
      blGlyphRight:
        OffsetRect( Result, -14, 0 );

      blGlyphTop, blGlyphBottom:
        OffsetRect( Result, -7, 0 );
    end;
  end;
end; {= TRzMenuButton.GetGlyphRect =}


procedure TRzMenuButton.Paint;
var
  X, Y: Integer;
begin
  inherited;

  { Draw Arrow }
  if FShowArrow then
  begin
    if Enabled then
    begin
      Canvas.Brush.Color := clWindowText;
      Canvas.Pen.Color := clWindowText;
    end
    else
    begin
      Canvas.Brush.Color := clBtnShadow;
      Canvas.Pen.Color := clBtnShadow;
    end;
    with ClientRect do
    begin
      X := Right - 12;
      Y := Top + ( Bottom - Top ) div 2 + 2;
      if FShowDownVersion then
      begin
        Inc( X );
        Inc( Y );
      end;
    end;
    Canvas.Polygon( [ Point( X, Y ), Point( X - 3, Y - 3 ), Point( X + 3, Y - 3 ) ] );
  end;
end;



{========================================}
{== TRzToolbarButtonActionLink Methods ==}
{========================================}

procedure TRzToolbarButtonActionLink.AssignClient( AClient: TObject );
begin
  inherited;
  FClient := AClient as TRzToolbarButton;
end;

function TRzToolbarButtonActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and ( FClient.Down = ( Action as TCustomAction ).Checked );
end;

procedure TRzToolbarButtonActionLink.SetChecked( Value: Boolean );
begin
  if IsCheckedLinked then
    FClient.Down := Value;
end;


function TRzToolbarButtonActionLink.IsCaptionLinked: Boolean;
begin
  if FClient.IgnoreActionCaption then
    Result := False
  else
    Result := inherited IsCaptionLinked;
end;


{==============================}
{== TRzToolbarButton Methods ==}
{==============================}

constructor TRzToolbarButton.Create( AOwner: TComponent );
begin
  inherited;
  FIgnoreActionCaption := False;
  FMouseOverControl := False;

  FChangingGlyph := False;
  FUseHotGlyph := False;
  FHotGlyph := TBitmap.Create;
  FHotGlyph.OnChange := HotGlyphChangedHandler;
  FStdGlyph := TBitmap.Create;

  FShowCaption := True;

  {&RCI}
  Flat := True;
end;


destructor TRzToolbarButton.Destroy;
begin
  FHotGlyph.Free;
  FStdGlyph.Free;
  inherited;
end;


procedure TRzToolbarButton.DefineProperties( Filer: TFiler );
begin
  inherited;

  // Save the FSaveCaption field to stream if ShowCaption is False
  Filer.DefineProperty( 'SaveCaption', ReadSaveCaption, WriteSaveCaption, not FShowCaption );
end;


procedure TRzToolbarButton.ReadSaveCaption( Reader: TReader );
begin
  FSaveCaption := Reader.ReadString;
end;


procedure TRzToolbarButton.WriteSaveCaption( Writer: TWriter );
begin
  Writer.WriteString( FSaveCaption );
end;


procedure TRzToolbarButton.ActionChange( Sender: TObject; CheckDefaults: Boolean );
var
  OldCaption: string;

  procedure CopyImage( ImageList: TCustomImageList; Index: Integer );
  begin
    with Glyph do
    begin
      Width := ImageList.Width;
      Height := ImageList.Height;
      Canvas.Brush.Color := clFuchsia;
      Canvas.FillRect( Rect( 0,0, Width, Height ) );
      ImageList.Draw( Canvas, 0, 0, Index );
    end;
  end;

begin
  OldCaption := Caption;
  inherited;

  { Redo inherited version to allow Glyph to change }
  if Sender is TCustomAction then
  begin
    with TCustomAction( Sender ) do
    begin
      { Copy image from action's imagelist }
      if {( Glyph.Empty ) and}
         ( ActionList <> nil ) and
         ( ActionList.Images <> nil ) and
         ( ImageIndex >= 0 ) and
         ( ImageIndex < ActionList.Images.Count ) then
      begin
        CopyImage( ActionList.Images, ImageIndex );
      end;
    end;
  end;


  if FIgnoreActionCaption then
    Caption := OldCaption;

  if Sender is TCustomAction then
  begin
    with TCustomAction( Sender ) do
    begin
      if not CheckDefaults or ( Self.Down = False ) then
        Self.Down := Checked;
    end;
  end;
end;


function TRzToolbarButton.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TRzToolbarButtonActionLink;
end;


procedure TRzToolbarButton.HotGlyphChangedHandler( Sender: TObject );
var
  N: Integer;
begin
  if ( FHotGlyph.Height <> 0 ) and ( FHotGlyph.Width mod FHotGlyph.Height = 0 ) then
  begin
    N := FHotGlyph.Width div FHotGlyph.Height;
    if N > 4 then
      N := 1;
    SetHotNumGlyphs( N );
  end;
  Invalidate;
end;


procedure TRzToolbarButton.SetHotGlyph( Value: TBitmap );
begin
  FHotGlyph.Assign( Value );
  FUseHotGlyph := FHotGlyph <> nil;
end;

procedure TRzToolbarButton.SetHotNumGlyphs( Value: TNumGlyphs );
begin
  if FHotNumGlyphs <> Value then
  begin
    FHotNumGlyphs := Value;
    Invalidate;
  end;
end;


function TRzToolbarButton.GetCaption: TCaption;
begin
  Result := inherited Caption;
end;

procedure TRzToolbarButton.SetCaption( const Value: TCaption );
begin
  if FShowCaption then
    inherited Caption := Value
  else
  begin
    FSaveCaption := GetCaption;
    inherited Caption := '';
  end;
end;


procedure TRzToolbarButton.SetShowCaption( Value: Boolean );
begin
  if FShowCaption <> Value then
  begin
    FShowCaption := Value;
    if FShowCaption then
      Caption := FSaveCaption
    else
      Caption := '';
    Invalidate;
  end;
end;


procedure TRzToolbarButton.CMDialogChar( var Msg: TCMDialogChar );
begin
  with Msg do
  begin
    if IsAccel( CharCode, Caption ) and Enabled and Visible and
      ( Parent <> nil ) and Parent.Showing then
    begin
      if GroupIndex > 0 then
      begin
        Down := not Down;
        if Down then
          Repaint;
      end;
      Click;
      Result := 1;
    end
    else
      inherited;
  end;
end;


procedure TRzToolbarButton.MouseDown( Button: TMouseButton; Shift: TShiftState;
                                      X, Y: Integer );
begin
  inherited;

  // The inherited Click method causes a new cm_MouseEnter message to get sent.
  // We prevent the glyph from changing for this new message by setting FChangingGlyph to True.
  if FUseHotGlyph then
    FChangingGlyph := True;
end;


procedure TRzToolbarButton.MouseEnter;
begin
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
end;

procedure TRzToolbarButton.CMMouseEnter( var Msg: TMessage );
begin
  // Setting FMouseOverControl must occur before inherited because Paint method is called during the call to inherited.
  // If we don't set this flag now, the Paint method will not draw the divider line.

  FMouseOverControl := True;

  {&RV}
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  MouseEnter;

  if FUseHotGlyph and Enabled then
  begin
    if not FChangingGlyph then
    begin
      FChangingGlyph := True;

      FStdGlyph.Assign( Glyph );
      FStdNumGlyphs := NumGlyphs;

      Glyph.Assign( FHotGlyph );
      NumGlyphs := FHotNumGlyphs;
    end
    else
      FChangingGlyph := False;
    Repaint;
  end;
end;


procedure TRzToolbarButton.MouseLeave;
begin
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
end;

procedure TRzToolbarButton.CMMouseLeave( var Msg: TMessage );
begin
  inherited;
  MouseLeave;
  FMouseOverControl := False;

  if FUseHotGlyph and Enabled then
  begin
    { The following test is needed because cm_MouseLeave is sent when
      Enabled property is changed }
    if FStdNumGlyphs <> 0 then
    begin
      Glyph.Assign( FStdGlyph );
      NumGlyphs := FStdNumGlyphs;
    end;

    FChangingGlyph := False;
    Repaint;
  end;
end;


{==================================}
{== TRzMenuToolbarButton Methods ==}
{==================================}

constructor TRzMenuToolbarButton.Create( AOwner: TComponent );
begin
  inherited;
  ControlStyle := ControlStyle - [ csDoubleClicks ];
  FDropped := False;
  DragMode := dmManual;
  FMouseOverControl := False;
  FShowArrow := True;
  Width := 40;
  Margin := 2;
  {&RCI}
end;


procedure TRzMenuToolbarButton.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if ( Operation = opRemove ) and ( AComponent = FDropDownMenu ) then
    FDropDownMenu := nil;
end;


procedure TRzMenuToolbarButton.DoDropDown;
var
  P: TPoint;
  MenuWidth, FarRightEdge: Integer;
  Monitor: TMonitor;
begin
  if not Assigned( FDropDownMenu ) then
    Exit;

  DropDown;                                        { Generate OnDropDown event }

  P.X := 0;
  P.Y := Height;
  P := ClientToScreen( P );                    { Convert to screen coordinates }

  MenuWidth := GetMenuWidth( Self, FDropDownMenu );

  Monitor := GetMonitorContainingPoint( P );
  if Assigned( Monitor ) then
    FarRightEdge := GetMonitorWorkArea( Monitor ).Right
  else
    FarRightEdge := GetActiveWorkAreaWidth( Parent );
  if P.X + MenuWidth > FarRightEdge then
    Dec( P.X, MenuWidth - Width );

  FDropDownMenu.PopupComponent := Self;
  FDropDownMenu.Popup( P.X, P.Y );
  if ( GroupIndex > 0 ) and not Down then
    Click;
end;


procedure TRzMenuToolbarButton.Click;
begin
  if FSkipNextClick then
    FSkipNextClick := False
  else
    inherited;
  {&RV}
end;


procedure TRzMenuToolbarButton.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  T: DWord;
begin
  FDropped := not FDropped;
  inherited;

  { Only go further if only left button is pressed }
  if ( FDropDownMenu = nil ) or ( Shift <> [ ssLeft ] ) or ( FShowArrow and ( X < Width - 15 ) ) then
    Exit;

  T := GetTickCount;
  if ( FDropTime > 0 ) and ( T < FDropTime + MinDelay ) then
  begin
    { If GetTickCount < FDropTime + MinDelay then this MouseDown method call
      is resulting from a "second" click on the button }
    if T < FDropTime + MinDelay then
      FSkipNextClick := True;
    FDropTime := 0;
    ReleaseCapture;
  end
  else
  begin
    DoDropDown;
    FSkipNextClick := True;
    FDropTime := GetTickCount;
  end;
  inherited MouseUp( Button, Shift, X, Y );                // Generate MouseUp event
end; {= TRzMenuToolbarButton.MouseDown =}



procedure TRzMenuToolbarButton.DropDown;
begin
  if Assigned( FOnDropDown ) then
    FOnDropDown( FDropDownMenu );
end;


procedure TRzMenuToolbarButton.SetDropDownMenu( Value: TPopupMenu );
begin
  if FDropDownMenu <> Value then
  begin
    FDropDownMenu := Value;
    if Value <> nil then
      Value.FreeNotification( Self );
  end;
end;


procedure TRzMenuToolbarButton.SetShowArrow( Value: Boolean );
begin
  if FShowArrow <> Value then
  begin
    FShowArrow := Value;
    Invalidate;
  end;
end;



procedure TRzMenuToolbarButton.Paint;
var
  X, Y: Integer;
begin
  inherited;

  { Draw Arrow }
  if FShowArrow then
  begin
    with Canvas do
    begin
      if ( FMouseOverControl and Enabled ) or not Flat then
      begin
        X := Width - 15;
        if FState = bsDown then
          Inc( X );

        if FState <> bsDown then
        begin
          Pen.Color := clBtnHighlight;
          MoveTo( X, 0 );
          LineTo( X, Height );
        end;
        Pen.Color := clBtnShadow;
        MoveTo( X - 1, 0 );
        LineTo( X - 1, Height );
      end;

      if Enabled then
      begin
        Brush.Color := clWindowText;
        Pen.Color := clWindowText;
      end
      else
      begin
        Brush.Color := clBtnShadow;
        Pen.Color := clBtnShadow;
      end;
      with ClientRect do
      begin
        X := Right - 8;
        Y := Top + ( Bottom - Top ) div 2 + 2;
        if FState = bsDown then
        begin
          Inc( X );
          Inc( Y );
        end;
      end;
      Polygon( [ Point( X, Y ), Point( X - 3, Y - 3 ), Point( X + 3, Y - 3 ) ] );
    end;
  end;
end;


{=====================================}
{== TRzToolButtonActionLink Methods ==}
{=====================================}

procedure TRzToolButtonActionLink.AssignClient( AClient: TObject );
begin
  inherited;
  FClient := AClient as TRzToolButton;
end;

function TRzToolButtonActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and ( FClient.Down = ( Action as TCustomAction ).Checked );
end;

function TRzToolButtonActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and ( FClient.ImageIndex = ( Action as TCustomAction ).ImageIndex );
end;

procedure TRzToolButtonActionLink.SetChecked( Value: Boolean );
begin
  if IsCheckedLinked then
    FClient.Down := Value;
end;

procedure TRzToolButtonActionLink.SetImageIndex( Value: Integer );
begin
  if IsImageIndexLinked then
    FClient.ImageIndex := Value;
end;


{===========================}
{== TRzToolButton Methods ==}
{===========================}

constructor TRzToolButton.Create( AOwner: TComponent );
begin
  inherited;

  ControlStyle := [ csCaptureMouse ];

  Width := 25;
  Height := 25;
  FUseToolbarButtonSize := True;

  FLayout := blGlyphLeft;
  FUseToolbarButtonLayout := True;

  FShowCaption := False;
  FUseToolbarShowCaption := True;

  Color := clBtnFace;
  FTransparent := True;

  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;

  FImageIndex := -1;
  FDownIndex := -1;
  FDisabledIndex := -1;
  FHotIndex := -1;

  FMouseOverButton := False;
  FFlat := True;

  DragMode := dmManual;
  FToolStyle := tsButton;
  FTreatAsNormal := True;
end;


destructor TRzToolButton.Destroy;
begin
  FImageChangeLink.Free;
  inherited;
end;


procedure TRzToolButton.Loaded;
begin
  inherited;
  PickupToolbarStyles;
end;


procedure TRzToolButton.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if Operation = opRemove then
  begin
    if AComponent = FImages then
      SetImages( nil )  // Call access method so connections to link object can be cleared
    else if AComponent = FDropDownMenu then
      FDropDownMenu := nil;
  end;
end;


procedure TRzToolButton.PickupToolbarStyles;
begin
  if Parent <> nil then
  begin
    Perform( cm_ToolbarShowCaptionChanged, 0, 0 );
    Perform( cm_ToolbarButtonLayoutChanged, 0, 0 );
    Perform( cm_ToolbarButtonSizeChanged, 0, 0 );
  end;
end;


procedure TRzToolButton.SetParent( Value: TWinControl );
begin
  inherited;
  PickupToolbarStyles;
end;


procedure TRzToolButton.DoDropDown;
var
  P: TPoint;
  MenuWidth, FarRightEdge: Integer;
  Monitor: TMonitor;
begin
  if not Assigned( FDropDownMenu ) then
    Exit;

  DropDown;                                        { Generate OnDropDown event }

  P.X := 0;
  P.Y := Height;
  P := ClientToScreen( P );                    { Convert to screen coordinates }

  MenuWidth := GetMenuWidth( Self, FDropDownMenu );

  Monitor := GetMonitorContainingPoint( P );
  if Assigned( Monitor ) then
    FarRightEdge := GetMonitorWorkArea( Monitor ).Right
  else
    FarRightEdge := GetActiveWorkAreaWidth( Parent );
  if P.X + MenuWidth > FarRightEdge then
    Dec( P.X, MenuWidth - Width );

  FDropDownMenu.PopupComponent := Self;
  FDropDownMenu.Popup( P.X, P.Y );
  if ( GroupIndex > 0 ) and not Down then
    Click;
end;


procedure TRzToolButton.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  T: DWord;
begin
  inherited;

  case FToolStyle of
    tsButton:
    begin
      if ( Button = mbLeft ) and Enabled then
      begin
        if not FDown or ( FState = tbsExclusive ) then
        begin
          FState := tbsDown;
          Invalidate;
        end;
        FDragging := True;
      end;
    end;

    tsDropDown:
    begin
      { Only go further if only left button is pressed }
      if ( FDropDownMenu = nil ) or ( Shift <> [ ssLeft ] ) or
         ( ( X < Width - ArrowRegionWidth ) and
           ( Assigned( OnClick ) or ( Action <> nil ) ) ) then
      begin
        { Treat as a normal button }
        if FTreatAsNormal then
        begin
          if ( Button = mbLeft ) and Enabled then
          begin
            if not FDown then
            begin
              FState := tbsDown;
              Invalidate;
            end;
            FDragging := True;
          end;
        end
        else
          FTreatAsNormal := True;

        Exit;
      end;

      // User clicked on the drop-down arrow.  Check to make sure that
      // there are menu items to display.  If not, then get out.
      if ( FDropDownMenu <> nil ) and ( FDropDownMenu.Items.Count = 0 ) then
        Exit;

      T := GetTickCount;
      if ( FDropTime > 0 ) and ( T < FDropTime + MinDelay ) then
      begin
        { If GetTickCount < FDropTime + MinDelay then this MouseDown method call
          is resulting from a "second" click on the button }
        if T < FDropTime + MinDelay then
        begin
          FTreatAsNormal := True;
        end;
        FDropTime := 0;
        ReleaseCapture;
      end
      else
      begin
        FState := tbsDropDown;
        Repaint;

        DoDropDown;
        FTreatAsNormal := False;
        FDropTime := GetTickCount;
      end;
      MouseUp( Button, Shift, X, Y );
    end;
  end;
end; {= TRzToolButton.MouseDown =}



procedure TRzToolButton.MouseMove( Shift: TShiftState; X, Y: Integer );
var
  NewState: TRzToolButtonState;
begin
  inherited;

  if FDragging then
  begin
    if not FDown then
      NewState := tbsUp
    else
      NewState := tbsExclusive;

    if ( X >= 0 ) and ( X < ClientWidth ) and
       ( Y >= 0 ) and ( Y < ClientHeight ) then
    begin
      if FDown then
        NewState := tbsExclusive
      else
        NewState := tbsDown;
    end;

    if NewState <> FState then
    begin
      FState := NewState;
      Invalidate;
    end;
  end
  else if not FMouseOverButton then
    UpdateTracking;
end; {= TRzToolButton.MouseMove =}


function TRzToolButton.CursorPosition: TPoint;
begin
  GetCursorPos( Result );
  Result := ScreenToClient( Result );
end;


procedure TRzToolButton.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  DoClick, CurrentlyDown: Boolean;
begin
  inherited;
  if FDragging then
  begin
    FDragging := False;
    DoClick := ( X >= 0 ) and ( X < ClientWidth ) and
               ( Y >= 0 ) and ( Y < ClientHeight );

    if FGroupIndex = 0 then
    begin
      { Redraw face in-case mouse is captured }
      FState := tbsUp;
      FMouseOverButton := False;
      if DoClick and not ( FState in [ tbsExclusive, tbsDown ] ) then
        Repaint;
    end
    else
    begin
      if DoClick then
      begin
        CurrentlyDown := FDown;
        SetDown( not FDown );
        // If no change in down state, user clicked on an exclusive button already down. In this case, do not cause
        // OnClick event to fire as this will cause the associated action to fire.
        if CurrentlyDown = FDown then
          DoClick := False;
        if FDown then
          FState := tbsExclusive;
        if FDown then
          Repaint;
      end
      else
      begin
        if FDown then
          FState := tbsExclusive;
        Repaint;
      end;
    end;
    if DoClick then
      Click;
    UpdateTracking;
  end;

  if FToolStyle = tsDropDown then
  begin
    if not PtInRect( ClientRect, CursorPosition ) then
      FTreatAsNormal := True;
    FState := tbsUp;
    Repaint;
    UpdateTracking;
  end;
end; {= TRzToolButton.MouseUp =}


procedure TRzToolButton.Click;
begin
  if FToolStyle = tsDropDown then
  begin
    if FTreatAsNormal then
      inherited Click;
  end
  else
    inherited Click;
end;


procedure TRzToolButton.CMDialogChar( var Msg: TCMDialogChar );
begin
  if IsAccel( Msg.CharCode, Caption ) and Enabled and Visible and ( Parent <> nil ) and Parent.Showing then
  begin
    Click;
    Msg.Result := 1;
  end
  else
    inherited;
end;


procedure TRzToolButton.UpdateTracking;
var
  P: TPoint;
begin
  if FFlat or ThemeServices.ThemesEnabled then
  begin
    if Enabled then
    begin
      GetCursorPos( P );
      FMouseOverButton := not ( FindDragTarget( P, True ) = Self );
      if FMouseOverButton then
        Perform( cm_MouseLeave, 0, 0 )
      else
        Perform( cm_MouseEnter, 0, 0 );
    end;
  end;
end;


procedure TRzToolButton.MouseEnter;
begin
  FMouseOverButton := True;
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
  if FFlat or ThemeServices.ThemesEnabled then
    Refresh;
end;


procedure TRzToolButton.CMMouseEnter( var Msg: TMessage );
begin
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  MouseEnter;
end;


procedure TRzToolButton.MouseLeave;
begin
  FMouseOverButton := False;
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
  if FFlat or ThemeServices.ThemesEnabled then
    Refresh;
end;


procedure TRzToolButton.CMMouseLeave( var Msg: TMessage );
begin
  inherited;
  MouseLeave;
end;


procedure TRzToolButton.DrawBtnBorder( var R: TRect );
var
  ElementDetails: TThemedElementDetails;
  ThemeRect: TRect;
begin
  if ThemeServices.ThemesEnabled then
  begin
    ThemeRect := R;
    if FFlat then
    begin
      if ( FToolStyle = tsButton ) or ( ( FToolStyle = tsDropDown ) and not Assigned( OnClick ) and ( Action = nil ) ) then
      begin
        // Draw as normal tool button if tsButton or no OnClick handler
        if ( FState in [ tbsDown, tbsExclusive, tbsDropDown ] ) or
           ( FMouseOverButton and ( FState <> tbsDisabled ) ) or
           ( csDesigning in ComponentState ) then
        begin
          if FState in [ tbsDown, tbsDropDown ] then
            ElementDetails := ThemeServices.GetElementDetails( ttbButtonPressed )
          else if FState = tbsExclusive then
          begin
            if FMouseOverButton then
              ElementDetails := ThemeServices.GetElementDetails( ttbButtonCheckedHot )
            else
              ElementDetails := ThemeServices.GetElementDetails( ttbButtonChecked );
          end
          else
            ElementDetails := ThemeServices.GetElementDetails( ttbButtonHot );
        end
        else
          ElementDetails := ThemeServices.GetElementDetails( ttbButtonNormal );
      end
      else // FToolStyle = tsDropDown and there is an OnClick event handler
      begin
        ThemeRect.Right := ThemeRect.Right - ArrowRegionWidth;

        if ( FState in [ tbsDown, tbsDropDown, tbsExclusive ] ) or
           ( FMouseOverButton and ( FState <> tbsDisabled ) ) or
           ( csDesigning in ComponentState ) then
        begin
          if FState = tbsDown then
            ElementDetails := ThemeServices.GetElementDetails( ttbSplitButtonPressed )
          else if FState = tbsExclusive then
          begin
            if FMouseOverButton then
              ElementDetails := ThemeServices.GetElementDetails( ttbSplitButtonCheckedHot )
            else
              ElementDetails := ThemeServices.GetElementDetails( ttbSplitButtonChecked );
          end
          else
            ElementDetails := ThemeServices.GetElementDetails( ttbSplitButtonHot );
        end
        else
          ElementDetails := ThemeServices.GetElementDetails( ttbSplitButtonNormal );
      end;
    end
    else // not Flat
    begin
      if Enabled then
      begin
        if ( FState in [ tbsDown, tbsExclusive ] ) or
           ( FMouseOverButton and ( FState <> tbsDisabled ) ) or
           ( csDesigning in ComponentState ) then
        begin
          if FState in [ tbsDown, tbsExclusive ] then
            ElementDetails := ThemeServices.GetElementDetails( tbPushButtonPressed )
          else
            ElementDetails := ThemeServices.GetElementDetails( tbPushButtonHot );
        end
        else
          ElementDetails := ThemeServices.GetElementDetails( tbPushButtonNormal );
      end
      else
        ElementDetails := ThemeServices.GetElementDetails( tbPushButtonDisabled );
    end;

    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, ThemeRect );

  end
  else
  begin
    if FFlat then
    begin
      if ( FState in [ tbsDown, tbsExclusive ] ) or
         ( FMouseOverButton and ( FState <> tbsDisabled ) ) or
         ( csDesigning in ComponentState ) then
      begin
        if FState in [ tbsDown, tbsExclusive ] then
          R := DrawBorder( Canvas, R, fsStatus )
        else
          R := DrawBorder( Canvas, R, fsPopup );
      end;
    end
    else
    begin
       if FState in [ tbsDown, tbsExclusive ] then
        R := DrawBorder( Canvas, R, fsLowered )
      else
        R := DrawBorder( Canvas, R, fsButtonUp );
    end;
  end;
end;


function TRzToolButton.ImageList: TCustomImageList;
begin
  if ( FImages = nil ) and ( Parent <> nil ) and ( Parent is TRzToolbar ) and ( TRzToolbar( Parent ).Images <> nil ) then
    Result := TRzToolbar( Parent ).Images
  else
    Result := FImages;
end;


function TRzToolButton.GetImageSize: TPoint;
begin
  if ImageList <> nil then
    Result := Point( ImageList.Width, ImageList.Height )
  else
    Result := Point( 0, 0 );
end;


function TRzToolButton.GetCaptionRect: TRect;
var
  ImageSize: TPoint;
  CaptionHeight, Offset, TotalH: Integer;
  TempRct: TRect;
begin
  // Adjust the size of the Text Rectangle based on the size of the Image and the Layout
  Result := ClientRect;
  if FToolStyle = tsDropDown then
    Dec( Result.Right, ArrowRegionWidth );
  InflateRect( Result, -2, -2 );

  if FImageIndex = -1 then
    Exit;

  ImageSize := GetImageSize;
  Canvas.Font := Self.Font;
  TempRct := Result;

  CaptionHeight := DrawText( Canvas.Handle, PChar( Caption ), -1, TempRct,
                             dt_CalcRect or dt_WordBreak or dt_ExpandTabs or dt_VCenter or dt_Center );

  case FLayout of
    blGlyphLeft:
      Inc( Result.Left, ImageSize.X + 4 );

    blGlyphRight:
      Dec( Result.Right, ImageSize.X + 4 );

    blGlyphTop:
    begin
      TotalH := CaptionHeight + ImageSize.Y + 4;
      Offset := ( Height - TotalH ) div 2;
      Inc( Result.Top, Offset + ImageSize.Y );
      Result.Bottom := Result.Top + CaptionHeight;
    end;

    blGlyphBottom:
    begin
      TotalH := CaptionHeight + ImageSize.Y + 4;
      Offset := ( Height - TotalH ) div 2;
      Inc( Result.Top, Offset );
      Result.Bottom := Result.Top + CaptionHeight;
    end;
  end;

  if ( FState in [ tbsDown, tbsExclusive ] ) or
     ( ( FState in [ tbsDropDown ] ) and not Assigned( OnClick ) and
       ( Action = nil ) ) then
  begin
    if ThemeServices.ThemesEnabled then
      OffsetRect( Result, 1, 0 )
    else
      OffsetRect( Result, 1, 1 );
  end;
end; {= TRzToolButton.GetCaptionRect =}



function TRzToolButton.GetImageRect: TRect;
var
  ImageSize: TPoint;
  CaptionHeight, Offset, TotalH: Integer;
  TempRct: TRect;
begin
  Result := ClientRect;
  if FToolStyle = tsDropDown then
    Dec( Result.Right, ArrowRegionWidth );
  InflateRect( Result, -2, -2 );

  ImageSize := GetImageSize;

  Canvas.Font := Self.Font;
  TempRct := Result;

  CaptionHeight := DrawText( Canvas.Handle, PChar( Caption ), -1, TempRct,
                             dt_CalcRect or dt_WordBreak or dt_ExpandTabs or dt_VCenter or dt_Center );

  case FLayout of
    blGlyphLeft:
      Inc( Result.Left, 2 );

    blGlyphRight:
      Result.Left := Result.Right - ImageSize.X - 2;

    blGlyphTop:
    begin
      TotalH := CaptionHeight + ImageSize.Y + 4;
      Offset := ( Height - TotalH ) div 2;
      Result.Top := Offset;
    end;

    blGlyphBottom:
    begin
      TotalH := CaptionHeight + ImageSize.Y + 4;
      Offset := ( Height - TotalH ) div 2;
      Inc( Result.Top, Offset + CaptionHeight );
    end;
  end;

  if FLayout in [ blGlyphLeft, blGlyphRight ] then
    Result.Top := Result.Top + ( Result.Bottom - Result.Top - ImageSize.Y ) div 2
  else
    Result.Left := Result.Left + ( Result.Right - Result.Left - ImageSize.X ) div 2;

  Result.Right := Result.Left + ImageSize.X;
  Result.Bottom := Result.Top + ImageSize.Y;

  if ( FState in [ tbsDown, tbsExclusive ] ) or
     ( ( FState in [ tbsDropDown ] ) and not Assigned( OnClick ) and
       ( Action = nil ) ) then
  begin
    if ThemeServices.ThemesEnabled then
      OffsetRect( Result, 1, 0 )
    else
      OffsetRect( Result, 1, 1 );
  end;
end; {= TRzToolButton.GetImageRect =}



procedure TRzToolButton.DrawImage( R: TRect );
var
  L, T: Integer;

  procedure DrawEnabledImage;
  begin
    if FDisabledIndex <> -1 then
    begin
      if Enabled then
      begin
        if ( FHotIndex <> -1 ) and FMouseOverButton then
          ImageList.Draw( Canvas, L, T, FHotIndex )
        else
          ImageList.Draw( Canvas, L, T, FImageIndex );
      end
      else
        ImageList.Draw( Canvas, L, T, FDisabledIndex );
    end
    else
    begin
      if ( FHotIndex <> -1 ) and FMouseOverButton and Enabled then
        ImageList.Draw( Canvas, L, T, FHotIndex, Enabled )
      else
        ImageList.Draw( Canvas, L, T, FImageIndex, Enabled );
    end;
  end;

begin
  if ( ImageList <> nil ) and ( FImageIndex <> -1 ) then
  begin
    L := R.Left;
    T := R.Top;

    if ( FState in [ tbsDown, tbsExclusive ] ) or
       ( ( FState in [ tbsDropDown ] ) and not Assigned( OnClick ) and
         ( Action = nil ) ) then
    begin
      if FDownIndex <> -1 then
        ImageList.Draw( Canvas, L, T, FDownIndex )
      else
        DrawEnabledImage;
    end
    else
      DrawEnabledImage;
  end;
end; {= TRzToolButton.DrawImage =}


procedure TRzToolButton.DrawArrow;
var
  X, Y: Integer;
  R: TRect;
  ElementDetails: TThemedElementDetails;

  procedure DrawTriangle;
  begin
    // Draw Actual Arrow
    if Enabled then
    begin
      Canvas.Brush.Color := clWindowText;
      Canvas.Pen.Color := clWindowText;
    end
    else
    begin
      Canvas.Brush.Color := clBtnShadow;
      Canvas.Pen.Color := clBtnShadow;
    end;

    X := ClientRect.Right - 8;
    Y := ClientRect.Top + ( ClientRect.Bottom - ClientRect.Top ) div 2 + 2;
    if FState in [ tbsDown, tbsDropDown ] then
    begin
      Inc( X );
      Inc( Y );
    end;
    Canvas.Polygon( [ Point( X, Y ), Point( X - 2, Y - 2 ), Point( X + 2, Y - 2 ) ] );
  end;

begin
  X := Width - ArrowRegionWidth;

  if ThemeServices.ThemesEnabled then
  begin
    if ( FToolStyle = tsButton ) or
       ( ( FToolStyle = tsDropDown ) and not Assigned( OnClick ) and
         ( Action = nil ) ) then
    begin
      DrawTriangle;
    end
    else
    begin
      R := ClientRect;
      if Assigned( OnClick ) or ( Action <> nil ) then
        R.Left := R.Right - ArrowRegionWidth;

      if Enabled then
      begin
        if ( FState in [ tbsDown, tbsDropDown ] ) or
           ( FMouseOverButton and ( FState <> tbsDisabled ) ) or
           ( csDesigning in ComponentState ) then
        begin
          if FState in [ tbsDown, tbsDropDown ] then
            ElementDetails := ThemeServices.GetElementDetails( ttbSplitButtonDropDownPressed )
          else
            ElementDetails := ThemeServices.GetElementDetails( ttbSplitButtonDropDownHot );
        end
        else
          ElementDetails := ThemeServices.GetElementDetails( ttbSplitButtonDropDownNormal );
      end
      else
        ElementDetails := ThemeServices.GetElementDetails( ttbSplitButtonDropDownDisabled );
      ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );
    end;
  end
  else // No Themes
  begin
    if FState <> tbsDropDown then
    begin
      if ( FFlat and FMouseOverButton and Enabled ) or ( not FFlat and Enabled ) then
      begin
        if FState in [ tbsDown ] then
          Inc( X );

        if Assigned( OnClick ) or ( Action <> nil ) then
        begin
          // Only show divider line if there is an OnClick event handler
          if FState <> tbsDown then
          begin
            Canvas.Pen.Color := clBtnHighlight;
            Canvas.MoveTo( X, 0 );
            Canvas.LineTo( X, Height );
          end;
          Canvas.Pen.Color := clBtnShadow;
          Canvas.MoveTo( X - 1, 0 );
          Canvas.LineTo( X - 1, Height );
        end;
      end;
    end
    else { FState = tbsDropDown }
    begin
      R := ClientRect;
      if Assigned( OnClick ) or ( Action <> nil ) then
      begin
        R.Left := R.Right - ArrowRegionWidth;
        Canvas.Pen.Color := clBtnShadow;
        Canvas.MoveTo( R.Left - 1, 0 );
        Canvas.LineTo( R.Left - 1, Height );
        DrawBorder( Canvas, R, fsStatus );
      end
      else
        DrawBorder( Canvas, R, fsStatus );
    end;

    DrawTriangle;
  end;

end; {= TRzToolButton.DrawArrow =}


procedure TRzToolButton.DrawCaption( R: TRect );
var
  TempRct: TRect;
  H: Integer;
  Flags: DWord;
begin
  if FShowCaption then
  begin
    Canvas.Brush.Style := bsClear;
    Canvas.Font := Self.Font;
    if FState = tbsDown then
      Canvas.Font.Color := clHighlightText;
      
    TempRct := R;

    Flags := dt_WordBreak or dt_ExpandTabs or dt_VCenter or dt_Center;
    if UseRightToLeftAlignment then
      Flags := Flags or dt_RtlReading;
      
    H := DrawText( Canvas.Handle, PChar( Caption ), -1, TempRct, dt_CalcRect or Flags );

    R.Top := ( ( R.Bottom + R.Top ) - H ) shr 1;
    R.Bottom := R.Top + H;

    if not Enabled then
      Canvas.Font.Color := clBtnShadow;
    DrawText( Canvas.Handle, PChar( Caption ), -1, R, Flags );

    Canvas.Brush.Style := bsSolid;
  end;
end;


procedure TRzToolButton.Paint;
var
  R: TRect;
begin
  if not Enabled then
  begin
    FState := tbsDisabled;
    FDragging := False;
  end
  else if FState = tbsDisabled then
  begin
    if FDown and ( GroupIndex <> 0 ) then
      FState := tbsExclusive
    else
      FState := tbsUp;
  end;

  R := ClientRect;

  DrawBtnBorder( R );

  if not FTransparent then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect( R );
  end;

  // Show dithered background if necessary
  if not ThemeServices.ThemesEnabled then
  begin
    if ( FState = tbsExclusive ) and ( not FFlat or not FMouseOverButton ) then
    begin
      if FTransparent then
        Canvas.Brush.Bitmap := AllocPatternBitmap( clBtnFace, clBtnHighlight )
      else
        Canvas.Brush.Bitmap := AllocPatternBitmap( Color, LighterColor( Color, 20 ) );
      Canvas.FillRect( R );
    end;
  end;

  if FToolStyle = tsDropDown then
    DrawArrow;

  DrawImage( GetImageRect );
  DrawCaption( GetCaptionRect );
end; {= TRzToolButton.Paint =}


procedure TRzToolButton.UpdateExclusive;
var
  Msg: TMessage;
begin
  if ( FGroupIndex <> 0 ) and ( Parent <> nil ) then
  begin
    Msg.Msg := cm_ButtonPressed;
    Msg.WParam := FGroupIndex;
    Msg.LParam := Longint( Self );
    Msg.Result := 0;
    Parent.Broadcast( Msg );
  end;
end;


procedure TRzToolButton.CMButtonPressed( var Msg: TMessage );
var
  Sender: TRzToolButton;
begin
  if Msg.WParam = FGroupIndex then
  begin
    Sender := TRzToolButton( Msg.LParam );
    if Sender <> Self then
    begin
      if Sender.Down and FDown then
      begin
        FDown := False;
        FState := tbsUp;
        Invalidate;
      end;
      FAllowAllUp := Sender.AllowAllUp;
    end;
  end;
end;


procedure TRzToolButton.SetAllowAllUp( Value: Boolean );
begin
  if FAllowAllUp <> Value then
  begin
    FAllowAllUp := Value;
    UpdateExclusive;
  end;
end;


procedure TRzToolButton.SetDown( Value: Boolean );
begin
  if FGroupIndex = 0 then
    Value := False;

  if FDown <> Value then
  begin
    if FDown and ( not FAllowAllUp ) then
      Exit;

    FDown := Value;
    if Value then
    begin
      if FState = tbsUp then
        Invalidate;
      FState := tbsExclusive;
    end
    else
    begin
      FState := tbsUp;
      Repaint;
    end;
    if Value then
      UpdateExclusive;
  end;
end;


procedure TRzToolButton.SetFlat( Value: Boolean );
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    Repaint;
  end;
end;


procedure TRzToolButton.SetGroupIndex( Value: Integer );
begin
  if FGroupIndex <> Value then
  begin
    if FToolStyle = tsDropDown then
      FGroupIndex := 0
    else
      FGroupIndex := Value;
    UpdateExclusive;
  end;
end;


procedure TRzToolButton.SetHotIndex( Value: TImageIndex );
begin
  if FHotIndex <> Value then
  begin
    FHotIndex := Value;
    Invalidate;
  end;
end;


procedure TRzToolButton.SetImageIndex( Value: TImageIndex );
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Invalidate;
  end;
end;


procedure TRzToolButton.SetDownIndex( Value: TImageIndex );
begin
  if FDownIndex <> Value then
  begin
    FDownIndex := Value;
    Invalidate;
  end;
end;


procedure TRzToolButton.SetDisabledIndex( Value: TImageIndex );
begin
  if FDisabledIndex <> Value then
  begin
    FDisabledIndex := Value;
    Invalidate;
  end;
end;


procedure TRzToolButton.DropDown;
begin
  if Assigned( FOnDropDown ) then
    FOnDropDown( FDropDownMenu );
end;


procedure TRzToolButton.SetDropDownMenu( Value: TPopupMenu );
begin
  if FDropDownMenu <> Value then
  begin
    FDropDownMenu := Value;
    if Value <> nil then
      Value.FreeNotification( Self );
  end;
end;


procedure TRzToolButton.SetToolStyle( Value: TRzToolStyle );
var
  SaveFlag: Boolean;
begin
  if FToolStyle <> Value then
  begin
    FToolStyle := Value;
    FGroupIndex := 0;
    if not ( csLoading in ComponentState ) then
    begin
      SaveFlag := FUseToolbarButtonSize;
      if FToolStyle = tsButton then
        Width := Width - ArrowRegionWidth
      else
        Width := Width + ArrowRegionWidth;
      FUseToolbarButtonSize := SaveFlag;
    end;
    Invalidate;
  end;
end;


function TRzToolButton.IsSizeStored: Boolean;
begin
  if not FUseToolbarButtonSize then
    Result := True
  else if FUseToolbarButtonSize and ( Parent <> nil ) and ( Parent is TRzToolbar ) then
  begin
    // Store size if the button is not the same size as the button size defined by the toolbar.
    // This can happen when the text is too long to fit in the display.
    Result := ( Width <> TRzToolbar( Parent ).ButtonWidth ) or ( Height <> TRzToolbar( Parent ).ButtonHeight );
  end
  else
    Result := True;
end;


procedure TRzToolButton.SetTransparent( Value: Boolean );
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    Invalidate;
  end;
end;



procedure TRzToolButton.SetUseToolbarButtonSize( Value: Boolean );
begin
  if FUseToolbarButtonSize <> Value then
  begin
    FUseToolbarButtonSize := Value;
    if ( Parent <> nil ) and not ( csReading in ComponentState ) then
      Perform( cm_ToolbarButtonSizeChanged, 0, 0 );
    Invalidate;
  end;
end;


function TRzToolButton.GetWidth: Integer;
begin
  Result := inherited Width;
end;


procedure TRzToolButton.SetWidth( Value: Integer );
begin
  if Width <> Value then
  begin
    inherited Width := Value;
    if not ( csLoading in ComponentState ) then
      FUseToolbarButtonSize := False;
    Invalidate;
  end;
end;


function TRzToolButton.GetHeight: Integer;
begin
  Result := inherited Height;
end;


procedure TRzToolButton.SetHeight( Value: Integer );
begin
  if Height <> Value then
  begin
    inherited Height := Value;
    if not ( csLoading in ComponentState ) then
      FUseToolbarButtonSize := False;
    Invalidate;
  end;
end;


function TRzToolButton.IsLayoutStored: Boolean;
begin
  Result := not FUseToolbarButtonLayout;
end;


procedure TRzToolButton.SetUseToolbarButtonLayout( Value: Boolean );
begin
  if FUseToolbarButtonLayout <> Value then
  begin
    FUseToolbarButtonLayout := Value;
    if ( Parent <> nil ) and not ( csReading in ComponentState ) then
      Perform( cm_ToolbarButtonLayoutChanged, 0, 0 );
    Invalidate;
  end;
end;



procedure TRzToolButton.SetLayout( Value: TButtonLayout );
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    FUseToolbarButtonLayout := False;
    PickupToolbarStyles;
    Invalidate;
  end;
end;


procedure TRzToolButton.CMToolbarButtonLayoutChanged( var Msg: TMessage );
begin
  if FUseToolbarButtonLayout then
  begin
    if Parent is TRzToolbar then
      SetLayout( TRzToolbar( Parent ).ButtonLayout );
    FUseToolbarButtonLayout := True;
  end;
end;


procedure TRzToolButton.CMToolbarButtonSizeChanged( var Msg: TMessage );
var
  W: Integer;
  R: TRect;
begin
  if FUseToolbarButtonSize then
  begin
    if Parent is TRzToolbar then
    begin
      W := TRzToolbar( Parent ).ButtonWidth;
      if FShowCaption then
      begin
        Canvas.Font := Self.Font;
        if Layout in [ blGlyphTop, blGlyphBottom ] then
          W := Max( W, Canvas.TextWidth( Caption ) + 8 )
        else
        begin
          R := GetImageRect;
          W := Max( W, Canvas.TextWidth( Caption ) + 12 + GetImageSize.X );
        end;
      end;
      if FToolStyle <> tsButton then
        W := W + ArrowRegionWidth;
      SetWidth( W );
      SetHeight( TRzToolbar( Parent ).ButtonHeight );
    end;
    FUseToolbarButtonSize := True; // Calling SetWidth and SetHeight set FUseToolbarButtonSize to False
  end;
end;


procedure TRzToolButton.CMToolbarShowCaptionChanged( var Msg: TMessage );
begin
  if FUseToolbarShowCaption then
  begin
    if Parent is TRzToolbar then
      SetShowCaption( TRzToolbar( Parent ).ShowButtonCaptions );
    FUseToolbarShowCaption := True;
  end;
end;


function TRzToolButton.IsShowCaptionStored: Boolean;
begin
  Result := not UseToolbarShowCaption;
end;


procedure TRzToolButton.SetUseToolbarShowCaption( Value: Boolean );
begin
  if FUseToolbarShowCaption <> Value then
  begin
    FUseToolbarShowCaption := Value;
    if ( Parent <> nil ) and not ( csReading in ComponentState ) then
      Perform( cm_ToolbarShowCaptionChanged, 0, 0 );
    Invalidate;
  end;
end;


procedure TRzToolButton.SetShowCaption( Value: Boolean );
begin
  if FShowCaption <> Value then
  begin
    FShowCaption := Value;
    FUseToolbarShowCaption := False;
    Invalidate;
  end;
end;


procedure TRzToolButton.SetImages( Value: TCustomImageList );
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


procedure TRzToolButton.ImageListChange( Sender: TObject );
begin
  if Sender = Images then
  begin
    CheckMinSize;
    Invalidate; 
  end;
end;


procedure TRzToolButton.CheckMinSize;
begin
  // Ensures button area will display entire image
  if FImages.Width > Width then
    Width := FImages.Width;
  if FImages.Height > Height then
    Height := FImages.Height;
end;


function TRzToolButton.IsCheckedStored: Boolean;
begin
  Result := ( ActionLink = nil ) or not TRzToolButtonActionLink( ActionLink ).IsCheckedLinked;
end;

function TRzToolButton.IsImageIndexStored: Boolean;
begin
  Result := ( ActionLink = nil ) or not TRzToolButtonActionLink( ActionLink ).IsImageIndexLinked;
end;


procedure TRzToolButton.ActionChange( Sender: TObject; CheckDefaults: Boolean );
begin
  inherited;
  if Sender is TCustomAction then
    with TCustomAction (Sender ) do
    begin
      if not CheckDefaults or ( Self.Down = False ) then
        Self.Down := Checked;
      if not CheckDefaults or ( Self.ImageIndex = -1 ) then
        Self.ImageIndex := ImageIndex;
    end;
end;


function TRzToolButton.GetActionLinkClass: TControlActionLinkClass;
begin
  Result := TRzToolButtonActionLink;
end;


procedure TRzToolButton.AssignTo(Dest: TPersistent);
begin
  inherited;
  if Dest is TCustomAction then
    with TCustomAction( Dest ) do
    begin
      Checked := Self.Down;
      ImageIndex := Self.ImageIndex;
    end;
end;


procedure TRzToolButton.CMTextChanged( var Msg: TMessage );
begin
  inherited;
  PickupToolbarStyles;
  Invalidate;
end;


{==============================}
{== TRzControlButton Methods ==}
{==============================}

constructor TRzControlButton.Create( AOwner: TComponent );
begin
  inherited;

  ControlStyle := [ csCaptureMouse ];

  Width := 17;
  Height := 21;

  Color := clBtnFace;
  FMouseOverButton := False;
  FFlat := False;

  DragMode := dmManual;

  FGlyph := TBitmap.Create;
  FGlyph.OnChange := GlyphChangedHandler;
  FNumGlyphs := 1;

  FRepeatClicks := False;
  FInitialDelay := 400;                                    // 400 milliseconds
  FDelay := 100;                                           // 100 milliseconds
  {&RCI}
  {&RV}
end;


destructor TRzControlButton.Destroy;
begin
  FGlyph.Free;
  if FRepeatTimer <> nil then
    FRepeatTimer.Free;
  inherited;
end;


procedure TRzControlButton.Click;
begin
  inherited;
end;


procedure TRzControlButton.GlyphChangedHandler( Sender: TObject );
var
  N: Integer;
begin
  if ( FGlyph.Height <> 0 ) and ( FGlyph.Width mod FGlyph.Height = 0 ) then
  begin
    N := FGlyph.Width div FGlyph.Height;
    if N > 4 then
      N := 1;
    SetNumGlyphs( N );
  end;
  Invalidate;
end;


procedure TRzControlButton.SetGlyph( Value: TBitmap );
begin
  {&RV}
  FGlyph.Assign( Value );
end;


procedure TRzControlButton.SetNumGlyphs( Value: TNumGlyphs );
begin
  if FNumGlyphs <> Value then
  begin
    FNumGlyphs := Value;
    Invalidate;
  end;
end;


function TRzControlButton.GetImageSize: TPoint;
begin
  if FGlyph <> nil then
    Result := Point( FGlyph.Width div FNumGlyphs, FGlyph.Height )
  else
    Result := Point( 0, 0 );
end;


function TRzControlButton.GetPalette: HPALETTE;
begin
  Result := Glyph.Palette;
end;


procedure TRzControlButton.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;

  if ( Button = mbLeft ) and Enabled then
  begin
    if not FDown then
    begin
      FDown := True;
      Invalidate;
    end;
    FDragging := True;
  end;

  if FRepeatClicks then
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


function TRzControlButton.CursorPosition: TPoint;
begin
  GetCursorPos( Result );
  Result := ScreenToClient( Result );
end;


procedure TRzControlButton.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  DoClick: Boolean;
begin
  inherited;
  if FDragging then
  begin
    FDragging := False;
    DoClick := ( X >= 0 ) and ( X < ClientWidth ) and
               ( Y >= 0 ) and ( Y < ClientHeight );

    // Redraw face in-case mouse is captured
    FDown := False;
    FMouseOverButton := False;
    Repaint;
    if DoClick then
      Click;
    UpdateTracking;
  end;

  if FRepeatTimer <> nil then
    FRepeatTimer.Enabled := False;
end;


procedure TRzControlButton.TimerExpired( Sender: TObject );
begin
  FRepeatTimer.Interval := FDelay;
  if FDown and MouseCapture then
  begin
    try
      Click;
    except
      FRepeatTimer.Enabled := False;
      raise;
    end;
  end;
end;


procedure TRzControlButton.UpdateTracking;
var
  P: TPoint;
begin
  if FFlat or ThemeServices.ThemesEnabled then
  begin
    if Enabled then
    begin
      GetCursorPos( P );
      FMouseOverButton := not ( FindDragTarget( P, True ) = Self );
      if FMouseOverButton then
        Perform( cm_MouseLeave, 0, 0 )
      else
        Perform( cm_MouseEnter, 0, 0 );
    end;
  end;
end;


procedure TRzControlButton.MouseEnter;
begin
  FMouseOverButton := True;
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
  if FFlat or ThemeServices.ThemesEnabled then
    Refresh;
end;


procedure TRzControlButton.CMMouseEnter( var Msg: TMessage );
begin
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  MouseEnter;
end;


procedure TRzControlButton.MouseLeave;
begin
  FMouseOverButton := False;
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
  if FFlat or ThemeServices.ThemesEnabled then
    Refresh;
end;


procedure TRzControlButton.CMMouseLeave( var Msg: TMessage );
begin
  inherited;
  MouseLeave;
end;


procedure TRzControlButton.DrawBtnFace( var R: TRect );
var
  ElementDetails: TThemedElementDetails;
  ThemeRect, DestRect: TRect;
  MemImage: TBitmap;

  procedure DrawThemeButton( R: TRect; Style: TThemedScrollBar );
  begin
    ThemeRect := R;
    InflateRect( ThemeRect, 2, 2 );
    Inc( ThemeRect.Left );

    ElementDetails := ThemeServices.GetElementDetails( Style );

    MemImage := TBitmap.Create;
    try
      MemImage.Width := ThemeRect.Right - ThemeRect.Left;
      MemImage.Height := ThemeRect.Bottom - ThemeRect.Top;

      ThemeServices.DrawElement( MemImage.Canvas.Handle, ElementDetails, ThemeRect );

      DestRect := Rect( 2, 2, Width, Height );
      Canvas.CopyRect( DestRect, MemImage.Canvas, Rect( 0, 0, Width, Height ) );
      Canvas.Draw( 0, 0, MemImage );
    finally
      MemImage.Free;
    end;
  end;

begin
  if ThemeServices.ThemesEnabled then
  begin
    if FFlat then
    begin
      if FDown or ( FMouseOverButton and Enabled ) or ( csDesigning in ComponentState ) then
      begin
        if FDown then
          DrawThemeButton( R, tsThumbBtnHorzPressed )
        else
          DrawThemeButton( R, tsThumbBtnHorzHot );
      end
      else
      begin
        Canvas.Brush.Color := Color;
        Canvas.FillRect( R );
      end;
    end
    else
    begin
      if FDown or ( FMouseOverButton and Enabled ) or ( csDesigning in ComponentState ) then
      begin
        if FDown then
          DrawThemeButton( R, tsThumbBtnHorzPressed )
        else
          DrawThemeButton( R, tsThumbBtnHorzHot );
      end
      else if not Enabled then
        DrawThemeButton( R, tsThumbBtnHorzDisabled )
      else
        DrawThemeButton( R, tsThumbBtnHorzNormal );
    end;

    InflateRect( R, -2, -2 );
  end
  else // No XP Themes
  begin
    if FFlat then
    begin
      if FDown or ( FMouseOverButton and Enabled ) or ( csDesigning in ComponentState ) then
      begin
        if FDown then
          R := DrawBorder( Canvas, R, fsStatus )
        else
          R := DrawBorder( Canvas, R, fsPopup );
      end;
      Canvas.Brush.Color := Color;
    end
    else
    begin
       if FDown then
        R := DrawBevel( Canvas, R, clBtnShadow, clBtnShadow, 1, sdAllSides )
      else
        R := DrawBorder( Canvas, R, fsButtonUp );
      Canvas.Brush.Color := clBtnFace;
    end;

    Canvas.FillRect( R );
  end;
end; {= TRzControlButton.DrawBtnFace =}


procedure TRzControlButton.DrawSpinButton( var R: TRect );
type
  TRzSpinBtnState = ( sbsNormal, sbsDisabled, sbsHot, sbsPressed );
var
  ElementDetails: TThemedElementDetails;

  procedure DrawThemeSpinButton( R: TRect; State: TRzSpinBtnState );
  begin
    case FStyle of
      cbsLeft:
      begin
        case State of
          sbsNormal:   ElementDetails := ThemeServices.GetElementDetails( tsDownHorzNormal );
          sbsDisabled: ElementDetails := ThemeServices.GetElementDetails( tsDownHorzDisabled );
          sbsHot:      ElementDetails := ThemeServices.GetElementDetails( tsDownHorzHot );
          sbsPressed:  ElementDetails := ThemeServices.GetElementDetails( tsDownHorzPressed );
        end;
      end;

      cbsUp:
      begin
        case State of
          sbsNormal:   ElementDetails := ThemeServices.GetElementDetails( tsUpNormal );
          sbsDisabled: ElementDetails := ThemeServices.GetElementDetails( tsUpDisabled );
          sbsHot:      ElementDetails := ThemeServices.GetElementDetails( tsUpHot );
          sbsPressed:  ElementDetails := ThemeServices.GetElementDetails( tsUpPressed );
        end;
      end;

      cbsRight:
      begin
        case State of
          sbsNormal:   ElementDetails := ThemeServices.GetElementDetails( tsUpHorzNormal );
          sbsDisabled: ElementDetails := ThemeServices.GetElementDetails( tsUpHorzDisabled );
          sbsHot:      ElementDetails := ThemeServices.GetElementDetails( tsUpHorzHot );
          sbsPressed:  ElementDetails := ThemeServices.GetElementDetails( tsUpHorzPressed );
        end;
      end;

      cbsDown:
      begin
        case State of
          sbsNormal:   ElementDetails := ThemeServices.GetElementDetails( tsDownNormal );
          sbsDisabled: ElementDetails := ThemeServices.GetElementDetails( tsDownDisabled );
          sbsHot:      ElementDetails := ThemeServices.GetElementDetails( tsDownHot );
          sbsPressed:  ElementDetails := ThemeServices.GetElementDetails( tsDownPressed );
        end;
      end;
    end;
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );
  end;

  function StyleToDirection( S: TRzControlButtonStyle ): TDirection;
  begin
    Result := dirUp;
    case S of
      cbsLeft:  Result := dirLeft;
      cbsUp:    Result := dirUp;
      cbsRight: Result := dirRight;
      cbsDown:  Result := dirDown;
    end;
  end;

begin {= TRzControlButton.DrawSpinButton =}
  if ThemeServices.ThemesEnabled then
  begin
    if FFlat then
    begin
      if FDown or ( FMouseOverButton and Enabled ) or ( csDesigning in ComponentState ) then
      begin
        if FDown then
          DrawThemeSpinButton( R, sbsPressed )
        else
          DrawThemeSpinButton( R, sbsHot );
      end
      else
      begin
        Canvas.Brush.Color := Color;
        Canvas.FillRect( R );

        DrawSpinArrow( Canvas, R, uiWindowsXP, StyleToDirection( FStyle ), FDown, Enabled );
      end;
    end
    else // Not Flat
    begin
      if FDown or ( FMouseOverButton and Enabled ) or ( csDesigning in ComponentState ) then
      begin
        if FDown then
          DrawThemeSpinButton( R, sbsPressed )
        else
          DrawThemeSpinButton( R, sbsHot );
      end
      else if not Enabled then
        DrawThemeSpinButton( R, sbsDisabled )
      else
        DrawThemeSpinButton( R, sbsNormal );
    end;

    InflateRect( R, -2, -2 );
  end
  else // No XP Themes
  begin
    if FFlat then
    begin
      if FDown or ( FMouseOverButton and Enabled ) or ( csDesigning in ComponentState ) then
      begin
        if FDown then
          R := DrawBorder( Canvas, R, fsStatus )
        else
          R := DrawBorder( Canvas, R, fsPopup );
      end;
      Canvas.Brush.Color := Color;
    end
    else
    begin
       if FDown then
        R := DrawBevel( Canvas, R, clBtnShadow, clBtnShadow, 1, sdAllSides )
      else
        R := DrawBorder( Canvas, R, fsButtonUp );
      Canvas.Brush.Color := clBtnFace;
    end;

    Canvas.FillRect( R );
    DrawSpinArrow( Canvas, R, uiWindows95, StyleToDirection( FStyle ), FDown, Enabled );
  end;
end; {= TRzControlButton.DrawSpinButton =}


procedure TRzControlButton.DrawDropDownButton( var R: TRect );
type
  TRzDropDownBtnState = ( ddbsNormal, ddbsDisabled, ddbsHot, ddbsPressed );
var
  ElementDetails: TThemedElementDetails;

  procedure DrawThemeDropDownButton( R: TRect; State: TRzDropDownBtnState );
  begin
    case State of
      ddbsNormal:   ElementDetails := ThemeServices.GetElementDetails( tcDropDownButtonNormal );
      ddbsDisabled: ElementDetails := ThemeServices.GetElementDetails( tcDropDownButtonDisabled );
      ddbsHot:      ElementDetails := ThemeServices.GetElementDetails( tcDropDownButtonHot );
      ddbsPressed:  ElementDetails := ThemeServices.GetElementDetails( tcDropDownButtonPressed );
    end;
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );
  end;

begin {= TRzControlButton.DrawDropDownButton =}
  if ThemeServices.ThemesEnabled then
  begin
    InflateRect( R, 1, 1 );
    if FFlat then
    begin
      if FDown or ( FMouseOverButton and Enabled ) or ( csDesigning in ComponentState ) then
      begin
        if FDown then
          DrawThemeDropDownButton( R, ddbsPressed )
        else
          DrawThemeDropDownButton( R, ddbsHot );
      end
      else
      begin
        Canvas.Brush.Color := Color;
        Canvas.FillRect( R );

        DrawDropDownArrow( Canvas, R, uiWindowsXP, FDown, Enabled );
      end;
    end
    else // Not Flat
    begin
      if FDown or ( FMouseOverButton and Enabled ) or ( csDesigning in ComponentState ) then
      begin
        if FDown then
          DrawThemeDropDownButton( R, ddbsPressed )
        else
          DrawThemeDropDownButton( R, ddbsHot );
      end
      else if not Enabled then
        DrawThemeDropDownButton( R, ddbsDisabled )
      else
        DrawThemeDropDownButton( R, ddbsNormal );
    end;

    InflateRect( R, -2, -2 );
  end
  else // No XP Themes
  begin
    if FFlat then
    begin
      if FDown or ( FMouseOverButton and Enabled ) or ( csDesigning in ComponentState ) then
      begin
        if FDown then
          R := DrawBorder( Canvas, R, fsStatus )
        else
          R := DrawBorder( Canvas, R, fsPopup );
      end;
      Canvas.Brush.Color := Color;
    end
    else
    begin
       if FDown then
        R := DrawBevel( Canvas, R, clBtnShadow, clBtnShadow, 1, sdAllSides )
      else
        R := DrawBorder( Canvas, R, fsButtonUp );
      Canvas.Brush.Color := clBtnFace;
    end;

    Canvas.FillRect( R );
    DrawDropDownArrow( Canvas, R, uiWindows95, FDown, Enabled );
  end;
end; {= TRzControlButton.DrawDropDownButton =}


procedure TRzControlButton.DrawGlyph( R: TRect );
var
  DestRct, SrcRct: TRect;
  DestBmp: TBitmap;
  W, H: Integer;
  TransparentColor: TColor;
begin
  W := R.Right - R.Left;
  H := R.Bottom - R.Top;

  DestRct := Rect( 0, 0, W, H );
  if ( FNumGlyphs > 1 ) and not Enabled then
    SrcRct := Rect( W, 0, W + W, H )
  else
    SrcRct := Rect( 0, 0, W, H );

  // The DestBmp holds the desired region of the FGlyph bitmap

  DestBmp := TBitmap.Create;
  try
    DestBmp.Width := W;
    DestBmp.Height := H;
    DestBmp.Canvas.Brush.Color := Color;
    TransparentColor := FGlyph.Canvas.Pixels[ 0, H - 1 ];

    DestBmp.Canvas.CopyRect( DestRct, Canvas, R );
    DrawFullTransparentBitmap( DestBmp.Canvas, FGlyph, DestRct, SrcRct, TransparentColor );
    Canvas.Draw( R.Left, R.Top, DestBmp );
  finally
    DestBmp.Free;
  end;
end; {= TRzControlButton.DrawGlyph =}


procedure TRzControlButton.Paint;
var
  R: TRect;
  GlyphSize: TPoint;
begin
  R := ClientRect;

  case FStyle of
    cbsNone:
    begin
      DrawBtnFace( R );
      if not FGlyph.Empty then
      begin
        InflateRect( R, -1, -1 );
        GlyphSize := GetImageSize;
        R := CenterRect( R, GlyphSize.X, GlyphSize.Y );
        if FDown then
        begin
          if ThemeServices.ThemesEnabled then
            OffsetRect( R, 1, 0 )
          else
            OffsetRect( R, 1, 1 );
        end;

        DrawGlyph( R );
      end;
    end;

    cbsLeft, cbsUp, cbsRight, cbsDown:
    begin
      DrawSpinButton( R );
    end;

    cbsDropDown:
    begin
      DrawDropDownButton( R );
    end;
  end;
end; {= TRzControlButton.Paint =}


procedure TRzControlButton.SetStyle( Value: TRzControlButtonStyle );
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;


procedure TRzControlButton.SetFlat( Value: Boolean );
begin
  if FFlat <> Value then
  begin
    FFlat := Value;
    Repaint;
  end;
end;



{=======================================}
{== TRzShapeButton Support Procedures ==}
{=======================================}

type
  TRzPointArray = array[0..1] of Integer;


// Make a copy of a logical palette, returning the handle of the new palette.

function CopyPalette( SrcPalette: HPalette ): HPalette;
var
  Count: Cardinal;
  LogPal: PLogPalette;
begin
  Result := 0;
  Count := 0; // must init. because GetObject only passes back a 16-bit value

  // Is there a source palette? If not, then return zero.
  if SrcPalette = 0 then
    Exit;

  // Get the number of entries in the source palette.
  if GetObject( SrcPalette, SizeOf( Count ), @Count ) = 0 then
    raise Exception.Create( 'Invalid palette in CopyPalette' );

  if Count = 0 then
  begin
    // No entries is the equivalent of no palette.
    Result := 0;
    Exit;
  end;

  // TLogPalette already has room for one TPaletteEntry, so allocate
  // memory for an additional Count-1 entries.
  GetMem( LogPal, SizeOf( TLogPalette ) + ( Count-1 ) * SizeOf( TPaletteEntry ) );
  try
    // Get the palette entries from the source palette.
    if GetPaletteEntries( SrcPalette, 0, Count, LogPal^.palPalEntry ) <> Count then
      raise Exception.Create( 'Cannot get palette entries in CopyPalette' );
      
    LogPal^.palVersion := $300;
    LogPal^.palNumEntries := Count;
    // Create a new palette.
    Result := CreatePalette( LogPal^ );
    if Result = 0 then
      raise EOutOFResources.Create( 'Cannot create palette in CopyPalette' );
  finally
    FreeMem( LogPal, SizeOf( TLogPalette ) + ( Count-1 ) * SizeOf( TPaletteEntry ) );
  end;
end;


// Create a monochrome bitmap mask for use when overlaying images or
// when performing hit-testing.

function CreateMonoMask( ColorBmp: TBitmap; TransparentColor: TColor ): TBitmap;
var
  R: TRect;
  OldBkColor: TColorRef;
begin
  Result := TBitmap.Create;
  try
    Result.Monochrome := True;
    Result.Width := ColorBmp.Width;
    Result.Height := ColorBmp.Height;

    // Set background color for source bitmap -- this will be used
    // when copying to convert from a color bitmap to a mono bitmap

    OldBkColor := SetBkColor( ColorBmp.Canvas.Handle, TransparentColor );
    R := Rect( 0, 0, ColorBmp.Width, ColorBmp.Height );

    // Now copy to monochrome bitmap; all pixels in source bitmap that
    // were the transparent color will be white in the destination bitmap,
    // all other pixels will be black

    Result.Canvas.CopyMode := cmSrcCopy;
    Result.Canvas.CopyRect( R, ColorBmp.Canvas, R );
    SetBkColor( ColorBmp.Canvas.Handle, OldBkColor );
  except
    Result.Free;
    Raise;
  end;
end;


function CreateMonoOutlineMask( Source, NewSource: TBitmap; const OffsetPts: array of TRzPointArray;
                                TransparentColor: TColor ): TBitmap;
var
  I, W, H: Integer;
  R, NewR: TRect;
  SmallMask, BigMask, NewSourceMask: TBitmap;
begin
  Result := TBitmap.Create;
  try
    W := Source.Width;
    H := Source.Height;
    R := Rect( 0, 0, W, H );

    Result.Monochrome := True;
    Result.Width := W;
    Result.Height := H;

    SmallMask := CreateMonoMask( Source, TransparentColor );
    NewSourceMask := CreateMonoMask( NewSource, TransparentColor );
    BigMask := CreateMonoMask( NewSourceMask, TransparentColor );

    try
      BigMask.Canvas.CopyMode := cmSrcCopy;
      BigMask.Canvas.CopyRect( R, NewSourceMask.Canvas, R );

      for I := Low( OffsetPts ) to High( OffsetPts ) do
      begin
        if ( OffsetPts[I, 0] = 0 ) and ( OffsetPts[I, 1] = 0 ) then
          Break;
        NewR := R;
        OffsetRect( NewR, OffsetPts[I, 0], OffsetPts[I, 1] );
        BigMask.Canvas.CopyMode := cmSrcAnd; // DSa
        BigMask.Canvas.CopyRect( NewR, SmallMask.Canvas, R );
      end;
      BigMask.Canvas.CopyMode := cmSrcCopy;

      with Result do
      begin
        Canvas.CopyMode := cmSrcCopy;
        Canvas.CopyRect( R, NewSourceMask.Canvas, R );
        Canvas.CopyMode := $00DD0228; // SDno
        Canvas.CopyRect( R, BigMask.Canvas, R );
        Canvas.CopyMode := cmSrcCopy;
      end;

    finally
      SmallMask.Free;
      NewSourceMask.Free;
      BigMask.Free;
    end;

  except
    Result.Free;
    Raise;
  end;
end;


{============================}
{== TRzShapeButton Methods ==}
{============================}

constructor TRzShapeButton.Create( AOwner: TComponent );
begin
  inherited;

  SetBounds( 0, 0, 80, 80 );
  ControlStyle := [ csCaptureMouse, csOpaque ];
  FAutoSize := True;
  FBitmap := TBitmap.Create;
  FBitmap.OnChange := BitmapChanged;
  FBitmapUp := TBitmap.Create;
  FBitmapDown := TBitmap.Create;
  FHitTestMask := nil;
  ParentFont := True;
  FBevelWidth := 2;
  FBorderStyle := bsSingle;
  FState := bsUp;
  FPreciseClick := True;
  FPreciseShowHint := True;
  FBorderColor := cl3DDkShadow;
  FBevelHighlightColor := clBtnHighlight;
  FBevelShadowColor := clBtnShadow;
  FCaptionPosition := cpCentered;
end;


destructor TRzShapeButton.Destroy;
begin
  FBitmap.Free;
  FBitmapUp.Free;
  FBitmapDown.Free;
  FHitTestMask.Free;
  inherited;
end;


procedure TRzShapeButton.Paint;
var
  W, H: Integer;
  Composite, Mask, Overlay, CurrentBmp: TBitmap;
  R, NewR: TRect;
  BrushHandle: hBrush;
begin
  if csDesigning in ComponentState then
  begin
    with Canvas do
    begin
      Pen.Style := psDash;
      Brush.Style := bsClear;
      Rectangle( 0, 0, Width, Height );
    end;
  end;

  if ( csDesigning in ComponentState ) or ( FState in [ bsDisabled, bsExclusive ] ) then
    FState := bsUp;

  if FState = bsUp then
    CurrentBmp := FBitmapUp
  else
    CurrentBmp := FBitmapDown;

  if not CurrentBmp.Empty then
  begin
    W := Width;
    H := Height;
    R := ClientRect;
    NewR := R;

    Composite := TBitmap.Create;
    Overlay := TBitmap.Create;

    // When not using a palette ( 4, 16 or 24 bit color ) CopyPalette returns
    // without doing anything, and thus doesn't impact performance on these systems.

    Composite.Palette := CopyPalette( FBitmap.Palette );
    Overlay.Palette := CopyPalette( FBitmap.Palette );
    InitPalette( Composite.Canvas.Handle );
    InitPalette( Overlay.Canvas.Handle );
    InitPalette( Canvas.Handle );

    try
      with Composite do
      begin
        Width := W;
        Height := H;
        Canvas.CopyMode := cmSrcCopy;
        Canvas.CopyRect( R, Self.Canvas, R ); // Start with existing background
      end;

      with Overlay do
      begin
        Width := W;
        Height := H;
        Canvas.CopyMode := cmSrcCopy;
        BrushHandle := CreateSolidBrush( FBitmap.TransparentColor );
        try
          FillRect( Canvas.Handle, R, BrushHandle );
        finally
          DeleteObject( BrushHandle );
        end;
        if FState = bsDown then
          OffsetRect( NewR, 1, 1 );
        Canvas.CopyRect( NewR, CurrentBmp.Canvas, R );
      end;

      Mask := CreateMonoMask( Overlay, FBitmap.TransparentColor );
      try
        // Combine the mask with the existing background; this will give
        // the background with black ( 'holes' ) where the overlay will
        // eventually be shown

        Composite.Canvas.CopyMode := cmSrcAnd; // DSa
        Composite.Canvas.CopyRect( R, Mask.Canvas, R );

        // Generate the overlay image by combining the mask and the
        // original image; this will give ( courtesy of the appropriate
        // ROP code ) the image on a black background

        Overlay.Canvas.CopyMode := $00220326; { DSna }
        Overlay.Canvas.CopyRect( R, Mask.Canvas, R );

        // Now put the overlay image onto the background; this will
        // fill in the black ( 'holes' ) with the overlay image, leaving
        // the rest of the background as is

        Composite.Canvas.CopyMode := cmSrcPaint; { DSo }
        Composite.Canvas.CopyRect( R, Overlay.Canvas, R );

        // Now copy the composite image back
        Canvas.CopyMode := cmSrcCopy;
        Canvas.CopyRect( R, Composite.Canvas, R );
      finally
        Mask.Free;
      end;

    finally
      Composite.Free;
      Overlay.Free;
    end;
  end;

  if Length( Caption ) > 0 then
  begin
    // Draw the button caption
    Canvas.Font := Self.Font;
    R := GetCaptionRect( Canvas, Caption );
    DrawButtonText( Canvas, Caption, R, FState );
  end;
end; {= TRzShapeButton.Paint =}


procedure TRzShapeButton.CMHitTest( var Msg: TCMHitTest );
begin
  inherited;
  if PtInMask( Msg.XPos, Msg.YPos ) then
    Msg.Result := HTCLIENT
  else
    Msg.Result := HTNOWHERE;
end;


function TRzShapeButton.PtInMask( const X, Y: Integer ): Boolean;
begin
  Result := True;
  if FHitTestMask <> nil then
    Result := FHitTestMask.Canvas.Pixels[ X, Y ] = clBlack;
end;


procedure TRzShapeButton.MouseDown( Button: TMouseButton; Shift: TShiftState;
                                     X, Y: Integer );
var
  Clicked: Boolean;
begin
  inherited;

  if ( Button = mbLeft ) and Enabled then
  begin
    if FPreciseClick then
      Clicked := PtInMask( X, Y )
    else
      Clicked := True;

    if Clicked then
    begin
      FState := bsDown;
      Repaint;
    end;
    FDragging := True;
  end;
end;


procedure TRzShapeButton.MouseMove( Shift: TShiftState; X, Y: Integer );
var
  NewState: TButtonState;
  InMask: Boolean;
begin
  inherited;
  InMask := PtInMask( X, Y );

  if FPreciseShowHint and not InMask then
  begin
    // The outcome of PreciseShowHint being True may not be quite
    // what the user/developer expects because the Application
    // may still display the hint for the parent ( if the parent
    // has ShowHint = True ).  Consider the situation where the
    // button has been placed over a TImage and the button, image and
    // form all have ShowHint = True.  In this case PreciseShowHint
    // will result in the hint for the form being shown ( because it is
    // the parent of the button ) rather than the hint for the image
    // when the cursor is not positioned inside the masked area.

    if not FPrevShowHintSaved then
    begin
      // Must save ParentShowHint before changing ShowHint
      FPrevParentShowHint := ParentShowHint;
      ParentShowHint := False;
      FPrevShowHint := ShowHint;
      ShowHint := False;
      FPrevShowHintSaved := True;
    end;
  end
  else if FPreciseClick and not InMask then
  begin
    if not FPrevCursorSaved then
    begin
      FPrevCursor := Cursor;
      Cursor := crDefault;
      FPrevCursorSaved := True;
    end;
  end
  else
  begin
    if FPrevShowHintSaved then
    begin
      // Must set ShowHint before changing ParentShowHint
      ShowHint := FPrevShowHint;
      ParentShowHint := FPrevParentShowHint;
      FPrevShowHintSaved := False;
    end;
    if FPrevCursorSaved then
    begin
      Cursor := FPrevCursor;
      FPrevCursorSaved := False;
    end;
  end;

  if FDragging then
  begin
    if FPreciseClick then
      if InMask then
        NewState := bsDown
      else
        NewState := bsUp
    else
      if ( X >= 0 ) and ( X < ClientWidth ) and ( Y >= 0 ) and ( Y <= ClientHeight ) then
        NewState := bsDown
      else
        NewState := bsUp;

    if NewState <> FState then
    begin
      FState := NewState;
      Repaint;
    end;
  end;
end; {= TRzShapeButton.MouseMove =}


procedure TRzShapeButton.MouseUp( Button: TMouseButton; Shift: TShiftState;
                                   X, Y: Integer );
var
  DoClick: Boolean;
begin
  inherited;

  if FDragging then
  begin
    FDragging := False;
    if FPreciseClick then
      DoClick := PtInMask( X, Y ) // Determine if mouse released while on masked area
    else
      DoClick := ( X >= 0 ) and ( X < ClientWidth ) and
                 ( Y >= 0 ) and ( Y <= ClientHeight );

    if FState = bsDown then
    begin
      FState := bsUp;
      Repaint;
    end;

    if DoClick then
      Click;
  end;
end;


procedure TRzShapeButton.Click;
begin
  inherited;
end;


function TRzShapeButton.GetPalette: HPALETTE;
begin
  Result := FBitmap.Palette;
end;


procedure TRzShapeButton.SetBitmap( Value: TBitmap );
begin
  FBitmap.Assign( Value );
end;


procedure TRzShapeButton.SetBitmapUp( Value: TBitmap );
begin
  FBitmapUp.Assign( Value );
end;


procedure TRzShapeButton.SetBitmapDown( Value: TBitmap );
begin
  FBitmapDown.Assign( Value );
end;


procedure TRzShapeButton.BitmapChanged( Sender: TObject );
var
  OldCursor: TCursor;
  W, H: Integer;
begin
  AdjustBounds;

  if not ( ( csReading in ComponentState ) or ( csLoading in ComponentState ) ) then
  begin
    if FBitmap.Empty then
    begin
      // Bitmap has been cleared, also clear up & down images
      SetBitmapUp( nil );
      SetBitmapDown( nil );
    end
    else
    begin
      W := FBitmap.Width;
      H := FBitmap.Height;
      OldCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      try
        if ( FBitmapUp.Width <> W ) or ( FBitmapUp.Height <> H ) or
           ( FBitmapDown.Width <> W ) or ( FBitmapDown.Height <> H ) then
        begin
          FBitmapUp.Width := W;
          FBitmapUp.Height := H;
          FBitmapDown.Width := W;
          FBitmapDown.Height := H;
        end;
        Create3DBitmap( FBitmap, bsUp, FBitmapUp );
        Create3DBitmap( FBitmap, bsDown, FBitmapDown );

        FHitTestMask.Free;
        FHitTestMask := CreateMonoMask( FBitmapUp, FBitmap.TransparentColor );
      finally
        Screen.Cursor := OldCursor;
      end;
    end;
  end;
  Invalidate;
end; {= TRzShapeButton.BitmapChanged =}


procedure TRzShapeButton.CMDialogChar( var Msg: TCMDialogChar );
begin
  if IsAccel( Msg.CharCode, Caption ) and Enabled then
  begin
    Click;
    Msg.Result := 1;
  end
  else
    inherited;
end;


procedure TRzShapeButton.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  Invalidate;
end;


procedure TRzShapeButton.CMTextChanged( var Msg: TMessage );
begin
  inherited;
  Invalidate;
end;


procedure TRzShapeButton.CMSysColorChange( var Msg: TMessage );
begin
  inherited;
  BitmapChanged( Self );
end;


function TRzShapeButton.BevelColor( const AState: TButtonState; const TopLeft: Boolean ): TColor;
begin
  if AState = bsUp then
  begin
    if TopLeft then
    begin
      if ( ColorToRGB( FBitmap.TransparentColor ) and $FFFFFF ) = ColorToRGB( FBevelHighlightColor ) then
        Result := DarkerColor( FBevelHighlightColor, 1 )
      else
        Result := FBevelHighlightColor;
    end
    else
      Result := FBevelShadowColor;
  end
  else
  begin
    if TopLeft then
      Result := FBevelShadowColor
    else
    begin
      if ColorToRGB( FBitmap.TransparentColor ) = ColorToRGB( FBevelHighlightColor ) then
        Result := DarkerColor( FBevelHighlightColor, 1 )
      else
        Result := FBevelHighlightColor;
    end;
  end;
end;


{===============================================================================
  Create3DBitmap:

  The source bitmap is converted to a 3D bitmap by adding successive
  borders ( outlines ) around each successive image using the appropriate
  color to get the 3D shading effect.  Masks are used to just add each
  successive outline without affecting the existing image.  The new outline
  for each layer is generated by offsetting the original image to
  successive different positions so as to enlarge its 'footprint'.
  Up to 3 layers of outlines are possible depending on BevelWidth ( 0..2 )
  and BorderStyle ( bsNone, bsSingle ).  Each bevel outline can consist
  of two parts each of which can be a different color ( the border is all
  one color ).  When the image is in the 'up' state the first
  part, consisting of the top-right corner to the bottom-right corner
  to the bottom-left corner, will ( by default ) be dark grey in color
  and the second part, consisting of the bottom-left corner to the
  top-left corner to the top-right corner will be ( by default ) be white.
  Each outline ( getting further away from the origin ) requires more
  points to define its path than the previous outline.  The reverse
  colors will apply when the button is in the 'down' state.
  The OutlineOffsetPts type is used to define the points for each
  successive outline.  The first subscript is the outline level ( 1..3 ),
  the next subscript is for the part, dark-grey or white ( 0..1 ),
  and the final subscript is for each of the points.  Unused points
  are specified as ( 0,0 ).  The correct sequence for processing the points
  is necessary to get the correct 3D shading effect; this is why the
  the points don't just start from the top-left corner but always start
  from the top-right and proceed clockwise from there.  The 3D image is
  also built up from the inside out so as to be able to extract each
  succesive outline so it can be combined with the original image.

  The points are derived from the following grids, where B = Black ( border )
  W = White and G = Dk Grey.  X is the origin of the original image.
  Each character represents one pixel.

  Up: BBBBBBB   Down: BBBBBBB
      BWWWWGB         BGGGGWB
      BWWWGGB         BGGGWWB
      BWWXGGB         BGGXWWB
      BWGGGGB         BGWWWWB
      BGGGGGB         BWWWWWB
      BBBBBBB         BBBBBBB

===============================================================================}

procedure TRzShapeButton.Create3DBitmap( Source: TBitmap; const AState: TButtonState;
                                          Target: TBitmap );
type
  OutlineOffsetPts = array[ 1..3, 0..1, 0..12 ] of TRzPointArray;
const
  OutlinePts: OutlineOffsetPts =
    (
      ( ( (  1, -1 ), (  1,  0 ), (  1,  1 ), (  0,  1 ), ( -1,  1 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ) ),
        ( ( -1,  0 ), ( -1, -1 ), (  0, -1 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ) ) ),

      ( ( (  2, -2 ), (  2, -1 ), (  2,  0 ), (  2,  1 ), (  2,  2 ), (  1,  2 ), (  0,  2 ), ( -1,  2 ), ( -2,  2 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ) ),
        ( ( -2,  1 ), ( -2,  0 ), ( -2, -1 ), ( -2, -2 ), ( -1, -2 ), (  0, -2 ), (  1, -2 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ), (  0,  0 ) ) ),

      ( ( (  3, -3 ), (  3, -2 ), (  3, -1 ), (  3,  0 ), (  3,  1 ), (  3,  2 ), (  3,  3 ), (  2,  3 ), (  1,  3 ), (  0,  3 ), ( -1,  3 ), ( -2,  3 ), ( -3,  3 ) ),
        ( ( -3,  2 ), ( -3,  1 ), ( -3,  0 ), ( -3, -1 ), ( -3, -2 ), ( -3, -3 ), ( -2, -3 ), ( -1, -3 ), (  0, -3 ), (  1, -3 ), (  2, -3 ), (  0,  0 ), (  0,  0 ) ) )
    );
var
  I, J, W, H, Outlines: Integer;
  R: TRect;
  OutlineMask, Overlay, NewSource: TBitmap;
  BrushHandle: hBrush;
  OldBrushHandle: hBrush;
begin
  if ( Source = nil ) or ( Target = nil ) then
    Exit;

  W := Source.Width;
  H := Source.Height;
  R := Rect( 0, 0, W, H );

  Overlay := TBitmap.Create;
  NewSource := TBitmap.Create;

  // The following lines may look strange -- they are just used to force the
  // bitmap and canvas handles for Source to be created before doing anything
  // with Source. ( The handles are only assigned back to themselves so it will
  // compile under Delphi 1 -- under Delphi 2 we could just reference each
  // Handle property without assigning to itself. )
  // I don't know why but if the handles aren't initialised like this for
  // 256 color systems then changing the bitmap at design-time won't always
  // 'take' and changing the bitmap at design or run-time causes memory losses
  // ( palettes not freed by Graphics unit ).

  Source.Handle := Source.Handle;
  Source.Canvas.Handle := Source.Canvas.Handle;

  Overlay.Palette := CopyPalette( Source.Palette );
  NewSource.Palette := CopyPalette( Source.Palette );
  Target.Palette := CopyPalette( Source.Palette );
  InitPalette( Overlay.Canvas.Handle );
  InitPalette( NewSource.Canvas.Handle );
  InitPalette( Target.Canvas.Handle );

  try
    NewSource.Width := W;
    NewSource.Height := H;

    // Copy source to target
    Target.Canvas.CopyMode := cmSrcCopy;
    Target.Canvas.CopyRect( R, Source.Canvas, R );

    Overlay.Width := W;
    Overlay.Height := H;

    Outlines := FBevelWidth;
    if FBorderStyle = bsSingle then
      Inc( Outlines );

    for I := 1 to Outlines do
    begin
      // Use the target bitmap as the basis for the new outline
      with NewSource.Canvas do
      begin
        CopyMode := cmSrcCopy;
        CopyRect( R, Target.Canvas, R );
      end;

      for J := 0 to 1 do
      begin
        if ( AState = bsDown ) and ( I = Outlines ) and ( J = 0 ) then
          Continue; // No shadow outline for final border is used

        // Use TransparentColor of FBitmap rather than that of
        // the 3D bitmap because the bevel/outline may have been drawn into
        // the pixel previously used to indicate the transparent color.

        OutlineMask := CreateMonoOutlineMask( Source, NewSource, OutlinePts[ I, J ],
                                              FBitmap.TransparentColor );
        try
          with Overlay.Canvas do
          begin
            // Create our own brush rather than using the canvas's -- not sure
            // if this is absolutely necessary but you never know when dealing
            // with palette colors!

            if ( I = Outlines ) and ( FBorderStyle = bsSingle ) then
              BrushHandle := CreateSolidBrush( ColorToRGB( FBorderColor ) )
            else
              BrushHandle := CreateSolidBrush( ColorToRGB( BevelColor( AState, ( J = 1 ) ) ) );
            OldBrushHandle := SelectObject( Handle, BrushHandle );
            try
              CopyMode := $0030032A; // PSna
              CopyRect( R, OutlineMask.Canvas, R );
            finally
              SelectObject( Handle, OldBrushHandle );
              DeleteObject( BrushHandle );
            end;
          end;

          with Target.Canvas do
          begin
            // Create black outline in target where colored outline is to go
            CopyMode := cmSrcAnd; // DSa
            CopyRect( R, OutlineMask.Canvas, R );
            // Copy colored outline into black outline area
            CopyMode := cmSrcPaint; // DSo
            CopyRect( R, Overlay.Canvas, R );
            CopyMode := cmSrcCopy;
          end;

        finally
          OutlineMask.Free;
        end;
      end;
    end;

  finally
    Overlay.Free;
    NewSource.Free;
  end;
end; {= TRzShapeButton.Create3DBitmap =}


procedure TRzShapeButton.SetBorderStyle( Value: TBorderStyle );
begin
  if Value <> FBorderStyle then
  begin
    FBorderStyle := Value;
    BitmapChanged( Self );
  end;
end;


procedure TRzShapeButton.SetBorderColor( Value: TColor );
begin
  if Value <> FBorderColor then
  begin
    FBorderColor := Value;
    BitmapChanged( Self );
  end;
end;


procedure TRzShapeButton.SetBevelWidth( Value: TRzBevelWidth );
begin
  if Value > 2 then
    Value := 2;
  if Value <> FBevelWidth then
  begin
    FBevelWidth := Value;
    BitmapChanged( Self );
  end;
end;


procedure TRzShapeButton.SetBevelHighlightColor( Value: TColor );
begin
  if Value <> FBevelHighlightColor then
  begin
    FBevelHighlightColor := Value;
    BitmapChanged( Self );
  end;
end;


procedure TRzShapeButton.SetBevelShadowColor( Value: TColor );
begin
  if Value <> FBevelShadowColor then
  begin
    FBevelShadowColor := Value;
    BitmapChanged( Self );
  end;
end;


procedure TRzShapeButton.SetCaptionPosition( Value: TRzCaptionPosition );
begin
  if Value <> FCaptionPosition then
  begin
    FCaptionPosition := Value;
    Invalidate;
  end;
end;


procedure TRzShapeButton.SetCaptionX( Value: Integer );
begin
  SetCaptionXY( Value, FCaptionY );
end;


procedure TRzShapeButton.SetCaptionY( Value: Integer );
begin
  SetCaptionXY( FCaptionX, Value );
end;


procedure TRzShapeButton.SetCaptionXY( const X, Y: Integer );
var
  Moved: Boolean;
begin
  Moved := False;
  if X <> FCaptionX then
  begin
    FCaptionX := X;
    Moved := True;
  end;
  if Y <> FCaptionY then
  begin
    FCaptionY := Y;
    Moved := True;
  end;
  if Moved then
  begin
    FCaptionPosition := cpXY;
    Invalidate;
  end;
end;


function TRzShapeButton.GetCaptionRect( Canvas: TCanvas; const Caption: string ): TRect;
begin
  if FCaptionPosition = cpCentered then
    Result := ClientRect
  else
  begin
    Result := Rect( 0, 0, ClientRect.Right - ClientRect.Left, 0 );
    DrawText( Canvas.Handle, PChar( Caption ), -1, Result, dt_CalcRect );
    OffsetRect( Result, FCaptionX, FCaptionY );
  end;
end;


procedure TRzShapeButton.DrawButtonText( Canvas: TCanvas; const Caption: string; TextBounds: TRect; State: TButtonState );
begin
  Canvas.Brush.Style := bsClear;
  if State = bsDown then
    OffsetRect( TextBounds, 1, 1 );

  DrawText( Canvas.Handle, PChar( Caption ), -1, TextBounds, dt_Center or dt_VCenter or dt_SingleLine );
end;



procedure TRzShapeButton.Loaded;
var
  BigMask: TBitmap;
  R: TRect;
begin
  inherited;
  if ( FBitmap <> nil ) and ( FBitmap.Width > 0 ) and ( FBitmap.Height > 0 ) then
  begin
    // Combine the mask for the original image with one the mask of one
    // of the 'enlarged' images; this will remove any speckling inside
    // the image so that hit-testing will work correctly.
    // Use TransparentColor of FBitmap rather than that of
    // the 3D bitmap because the bevel/outline may have been drawn into
    // the pixel previously used to indicate the transparent color.

    FHitTestMask.Free;
    FHitTestMask := CreateMonoMask( FBitmap, FBitmap.TransparentColor );
    BigMask := CreateMonoMask( FBitmapUp, FBitmap.TransparentColor );
    try
      R := Rect( 0, 0, FBitmap.Width, FBitmap.Height );
      FHitTestMask.Canvas.CopyMode := cmSrcAnd;
      FHitTestMask.Canvas.CopyRect( R, BigMask.Canvas, R );
    finally
      BigMask.Free;
    end;
  end;
end;


// Fake BitmapUp and BitmapDown properties are defined so that
// the bitmaps for the button's up and down states are stored.

procedure TRzShapeButton.DefineProperties( Filer: TFiler );
begin
  inherited;
  Filer.DefineBinaryProperty( 'BitmapUp', ReadBitmapUpData, WriteBitmapUpData, not FBitmapUp.Empty );
  Filer.DefineBinaryProperty( 'BitmapDown', ReadBitmapDownData, WriteBitmapDownData, not FBitmapDown.Empty )
end;


procedure TRzShapeButton.ReadBitmapUpData( Stream: TStream );
begin
  FBitmapUp.LoadFromStream( Stream );
end;

procedure TRzShapeButton.WriteBitmapUpData( Stream: TStream );
begin
  FBitmapUp.SaveToStream( Stream );
end;

procedure TRzShapeButton.ReadBitmapDownData( Stream: TStream );
begin
  FBitmapDown.LoadFromStream( Stream );
end;

procedure TRzShapeButton.WriteBitmapDownData( Stream: TStream );
begin
  FBitmapDown.SaveToStream( Stream );
end;


procedure TRzShapeButton.AdjustBounds;
begin
  SetBounds( Left, Top, Width, Height );
end;


procedure TRzShapeButton.AdjustButtonSize( var W, H: Integer );
begin
  if not ( csReading in ComponentState ) and FAutoSize and not FBitmap.Empty then
  begin
    W := FBitmap.Width + 4;
    H := FBitmap.Height + 4;
  end;
end;


procedure TRzShapeButton.SetAutoSize( Value: Boolean );
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    AdjustBounds;
  end;
end;


procedure TRzShapeButton.SetBounds( ALeft, ATop, AWidth, AHeight: Integer );
var
  W, H: Integer;
begin
  W := AWidth;
  H := AHeight;
  AdjustButtonSize( W, H );
  inherited SetBounds( ALeft, ATop, W, H );
end;


procedure TRzShapeButton.Invalidate;
var
  R: TRect;
begin
  if ( Visible or ( csDesigning in ComponentState ) ) and ( Parent <> nil ) and Parent.HandleAllocated then
  begin
    R := BoundsRect;
    InvalidateRect( Parent.Handle, @R, True );
  end;
end;


// Select and realize the control's palette

procedure TRzShapeButton.InitPalette( DC: HDC );
var
  Palette: HPALETTE;
begin
  Palette := GetPalette;
  if Palette <> 0 then
  begin
    SelectPalette( DC, Palette, False );
    RealizePalette( DC );
  end;
end;





procedure FreeBitmaps; far;
var
  I: TBitBtnKind;
begin
  for I := Low( TBitBtnKind ) to High( TBitBtnKind ) do
    BitBtnGlyphs[ I ].Free;
end;

initialization
  FillChar( BitBtnGlyphs, SizeOf( BitBtnGlyphs ), 0 );
  {&RUI}

finalization
  FreeBitmaps;
end.

