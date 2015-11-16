{===============================================================================
  RzPanel Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzPanel              Enhanced panel component with many more display options.
  TRzGroupBox           Custom group box component with more display options and
                          functionality.
  TRzSpacer             Separator control designed to be used on a TRzToolbar.
  TRzToolbar            Custom TRzPanel control designed to function as a
                          toolbar.
  TRzStatusBar          Custom TRzPanel control designed to functiona as a
                          status bar.


  Modification History
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Surface the OnPaint event and Canvas property in TRzToolbar.
    * Added FrameController property to TRzGroupBox. This associate
      FrameController can be used to change the appearance of the group box when
      the GroupStyle property is set to gsCustom.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Surfaced the OnPaint event in TRzGroupBox. This is useful when GroupStyle
      is set to gsCustom.
    * Surfaced Align, Anchors, and Constraints properties in TRzSpacer.
    * Added fsFlatRounded to inner and outer border styles.
    * Refactored inner and outer border painting to common DrawInnerOuterBorders
      function.
  ------------------------------------------------------------------------------
  3.0.6  (11 Apr 2003)
    * Changing TRzGroupBox.GroupStyle to gsTopLine or gsCustom causes ThemeAware
      to be changed to False.
  ------------------------------------------------------------------------------
  3.0.5  (24 Mar 2003)
    * Fixed problem where background of TRzGroupBox was not getting drawn when
      using XP Themes.
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * Modified alignment code of TRzStatusBar so that panes appear positioned
      more appropriately when running under Windows XP.
    * Added ShowTextOptions parameter to TRzToolbar.Customize method.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    << TRzCustomPanel and TRzPanel >>
    * All panel controls now keep track of Enabled/Disabled children and then
      restore these values when the panel is re-enabled.
    * Added FlatColorAdjustment property.
    * The TRzPanel now supports displaying a grid on its canvas. The ShowGrid,
      GridStyle, GridXSize, GridYSize, and GridColor properties control how the
      grid is displayed.
    * The custom docking manager has been updated to show focus changes.
    * The FrameSides property has been removed from the TRzCustomPanel
      component.

    << TRzGroupBox >>
    * Added the gsFlat GroupStyle for all Raize group boxes.
    * When BorderWidth is larger than the height of the Caption, then the client
      area of the group box is no longer adjusted by the height of the caption.
    * Added XP visual styles support.

    << TRzToolbar >>
    * The TRzToolbar has received a number of enhancements including support for
      an ImageList, runtime customizations, etc.
    * Added XP visual styles support.

    << TRzStatusBar >>
    * Updated display of size grip to match Windows XP style.  The size grip now
      automatically detects the state of the parent form to determine if the
      size grip is valid.  For example, the size grip is not valid for a form
      with a BorderStyle of bsDialog.  The size grip is also not valid for a
      maximized form.
    * Added SimpleFrameStyle property.
    * Added XP visual styles support.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzPanel;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  SysUtils,
  Messages,
  Windows,
  Classes,
  Graphics,
  Controls,
  Buttons,
  StdCtrls,
  ExtCtrls,
  ImgList,
  Menus,
  Forms,
  Dialogs,
  RzGrafx,
  RzCommon,
  RzButton;

type
  {======================================}
  {== TRzCustomPanel Class Declaration ==}
  {======================================}

  TRzCustomPanel = class;

  { Need to create a new dock manager class the knows how to paint a
    TRzSizePanel as a Dock Site. The problem is that the default Dock Manager
    (i.e. TDockTree) does not handle painting the area occupied by the SizeBar }

  TRzPanelDockManager = class( TDockTree )
  private
    FPanel: TRzCustomPanel;
    FOldWndProc: TWndMethod;
    procedure WindowProcHook( var Msg: TMessage );
  protected
    FFont: TFont;
    FCloseFont: TFont;
    FGrabberSize: Integer;
    procedure AdjustDockRect( Control: TControl; var ARect: TRect ); override;
    procedure DrawVertTitle( Canvas: TCanvas; const Caption: string; Bounds: TRect );
    procedure PaintDockFrame( Canvas: TCanvas; Control: TControl; const ARect: TRect ); override;
  public
    constructor Create( DockSite: TWinControl ); override;
    destructor Destroy; override;
    procedure PaintSite( DC: HDC ); override;
  end;

  TRzGridStyle = ( gsDots, gsDottedLines, gsSolidLines );

  TRzCustomPanel = class( TCustomPanel, IRzCustomFramingNotification )
  private
    FInAlignControls: Boolean;
    FAlignmentVertical: TAlignmentVertical;
    FBorderInner: TFrameStyleEx;
    FBorderOuter: TFrameStyleEx;
    FBorderSides: TSides;
    FBorderColor: TColor;
    FBorderHighlight: TColor;
    FBorderShadow: TColor;
    FFlatColor: TColor;
    FFlatColorAdjustment: Integer;

    FGridColor: TColor;
    FGridStyle: TRzGridStyle;
    FGridXSize: Word;
    FGridYSize: Word;
    FShowGrid: Boolean;
    FTransparent: Boolean;

    FShowDockClientCaptions: Boolean;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FEnabledList: TStringList;
    FOnPaint: TNotifyEvent;

    { Message Handling Methods }
    procedure CMMouseEnter( var Msg: TMessage ); message cm_MouseEnter;
    procedure CMMouseLeave( var Msg: TMessage ); message cm_MouseLeave;
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure WMWindowPosChanged( var Msg: TWMWindowPosChanged ); message wm_WindowPosChanged;
    procedure WMEraseBkgnd( var Msg: TWMEraseBkgnd ); message wm_EraseBkgnd;
  protected
    FAboutInfo: TRzAboutInfo;
    FThemeAware: Boolean;
    FFrameController: TRzFrameController;

    procedure DefineProperties( Filer: TFiler ); override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    function CursorPosition: TPoint; virtual;
    procedure AlignControls( AControl: TControl; var Rect: TRect ); override;
    procedure FixClientRect( var Rect: TRect; ShrinkByBorder: Boolean ); virtual;
    procedure AdjustClientRect( var Rect: TRect ); override;
    function GetClientRect: TRect; override;
    function GetControlRect: TRect; virtual;

    procedure DrawCaption( Rect: TRect ); virtual;
    procedure DrawGrid( Rect: TRect ); virtual;
    procedure Paint; override;
    procedure CustomFramingChanged; virtual;

    function CreateDockManager: IDockManager; override;

    { Event Dispatch Methods }
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;

    { Property Access Methods }
    procedure SetAlignmentVertical( Value: TAlignmentVertical ); virtual;
    procedure SetBorderColor( Value: TColor ); virtual;
    procedure SetBorderInner( Value: TFrameStyleEx ); virtual;
    procedure SetBorderOuter( Value: TFrameStyleEx ); virtual;
    procedure SetBorderSides( Value: TSides ); virtual;
    procedure SetBorderHighlight( Value: TColor ); virtual;
    procedure SetBorderShadow( Value: TColor ); virtual;
    procedure SetFlatColor( Value: TColor ); virtual;
    procedure SetFlatColorAdjustment( Value: Integer ); virtual;
    procedure SetFrameController( Value: TRzFrameController ); virtual;
    procedure SetGridColor( Value: TColor ); virtual;
    procedure SetGridStyle( Value: TRzGridStyle ); virtual;
    procedure SetGridXSize( Value: Word ); virtual;
    procedure SetGridYSize( Value: Word ); virtual;
    procedure SetShowGrid( Value: Boolean ); virtual;
    procedure SetTransparent( Value: Boolean ); virtual;
    procedure SetThemeAware( Value: Boolean ); virtual;

    { Property Declarations }
    property AlignmentVertical: TAlignmentVertical
      read FAlignmentVertical
      write SetAlignmentVertical
      default avCenter;

    property BorderInner: TFrameStyleEx
      read FBorderInner
      write SetBorderInner
      default fsNone;

    property BorderOuter: TFrameStyleEx
      read FBorderOuter
      write SetBorderOuter
      default fsRaised;

    property BorderSides: TSides
      read FBorderSides
      write SetBorderSides
      default [ sdLeft, sdTop, sdRight, sdBottom ];

    property BorderColor: TColor
      read FBorderColor
      write SetBorderColor
      default clBtnFace;

    property BorderHighlight: TColor
      read FBorderHighlight
      write SetBorderHighlight
      default clBtnHighlight;

    property BorderShadow: TColor
      read FBorderShadow
      write SetBorderShadow
      default clBtnShadow;

    property FlatColor: TColor
      read FFlatColor
      write SetFlatColor
      default clBtnShadow;

    property FlatColorAdjustment: Integer
      read FFlatColorAdjustment
      write SetFlatColorAdjustment
      default 30;

    property FrameController: TRzFrameController
      read FFrameController
      write SetFrameController;

    property GridColor: TColor
      read FGridColor
      write SetGridColor
      default clBtnShadow;

    property GridStyle: TRzGridStyle
      read FGridStyle
      write SetGridStyle
      default gsDots;

    property GridXSize: Word
      read FGridXSize
      write SetGridXSize
      default 8;

    property GridYSize: Word
      read FGridYSize
      write SetGridYSize
      default 8;

    property ShowGrid: Boolean
      read FShowGrid
      write SetShowGrid
      default False;

    property ShowDockClientCaptions: Boolean
      read FShowDockClientCaptions
      write FShowDockClientCaptions
      default True;

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

    property OnPaint: TNotifyEvent
      read FOnPaint
      write FOnPaint;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure SetBounds( ALeft, ATop, AWidth, AHeight: Integer ); override;
    procedure SetGridSize( XSize, YSize: Integer );
  end;


  {================================}
  {== TRzPanel Class Declaration ==}
  {================================}

  TRzPanel = class( TRzCustomPanel )
  public
    property Canvas;
    property DockManager;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    { Inherited Properties & Events }
    property Align;
    property Alignment;
    property AlignmentVertical;
    property Anchors;
    property AutoSize;
    property BevelWidth;
    property BiDiMode;
    property BorderInner;
    property BorderOuter;
    property BorderSides;
    property BorderColor;
    property BorderHighlight;
    property BorderShadow;
    property BorderWidth;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor;
    property FlatColorAdjustment;
    property Font;
    property FrameController;
    property FullRepaint;
    property GridColor;
    property GridStyle;
    property GridXSize;
    property GridYSize;
    property Locked;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowDockClientCaptions;
    property ShowGrid;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Transparent;
    property UseDockManager default True;
    property Visible;

    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;


  {=========================================}
  {== TRzCustomGroupBox Class Declaration ==}
  {=========================================}

  TRzGroupBoxStyle = ( gsStandard, gsCustom, gsTopLine, gsFlat );

  TRzCustomGroupBox = class( TRzCustomPanel )
  private
    FGroupStyle: TRzGroupBoxStyle;

    { Message Handling Methods }
    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
    procedure WMEraseBkGnd( var Msg: TWMEraseBkGnd ); message wm_EraseBkgnd;
  protected
    procedure CustomFramingChanged; override;

    procedure Paint; override;
    procedure AdjustClientRect( var Rect: TRect ); override;

    { Property Access Methods }
    procedure SetGroupBoxStyle( Value: TRzGroupBoxStyle ); virtual;

    { Inherited Properties & Events }
    property Alignment default taLeftJustify;
    property AlignmentVertical default avTop;
    property BorderOuter default fsNone;
    property BorderInner default fsNone;
    property Height default 105;
  public
    constructor Create( AOwner: TComponent ); override;

    { Property Declarations }
    property GroupStyle: TRzGroupBoxStyle
      read FGroupStyle
      write SetGroupBoxStyle
      default gsFlat;
  end;


  {===================================}
  {== TRzGroupBox Class Declaration ==}
  {===================================}

  TRzGroupBox = class( TRzCustomGroupBox )
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    { Inherited Properties & Events }
    property Align;
    property Alignment;
    property Anchors;
    property BevelWidth;
    property BiDiMode;
    property BorderColor;
    property BorderInner;
    property BorderOuter;
    property BorderSides;
    property BorderWidth;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor;
    property FlatColorAdjustment;
    property Font;
    property FrameController;
    property GroupStyle;
    property Height;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowDockClientCaptions;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Transparent;
    property ThemeAware;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;


  {=================================}
  {== TRzSpacer Class Declaration ==}
  {=================================}

  TRzSpacer = class( TGraphicControl )
  private
    FAboutInfo: TRzAboutInfo;
    FGrooved: Boolean;
    FOrientation: TOrientation;
  protected
    procedure Paint; override;

    { Property Access Methods }
    procedure SetGrooved( Value: Boolean ); virtual;
    procedure SetOrientation( Value: TOrientation ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Grooved: Boolean
      read FGrooved
      write SetGrooved
      default False;

    property Orientation: TOrientation
      read FOrientation
      write SetOrientation
      default orHorizontal;

    { Inherited Properties & Events }
    property Align;
    property Anchors;
    property Constraints;
    property Height default 25;
    property Width default 8;
    property Visible;
  end;


  {=========================================}
  {== TRzToolbarControl Class Declaration ==}
  {=========================================}

  TRzToolbarControl = class( TObject )
  protected
    FControl: TControl;
    FControlName: string;
    procedure AssignElements( Control: TRzToolbarControl ); virtual;
  public
    property Control: TControl
      read FControl;

    property ControlName: string
      read FControlName;
  end;


  {=============================================}
  {== TRzToolbarControlList Class Declaration ==}
  {=============================================}

  TRzToolbar = class;
  TRzToolbarControlList = class;

  TRzToolbarControlList = class( TList )
  protected
    FToolbar: TRzToolbar;
    FIndexOfLastControlRead: Integer; { Valid only during call to ReadControl }
    FTempControlList: TRzToolbarControlList;
    function Get( Index: Integer ): TRzToolbarControl;
    procedure Put( Index: Integer; Value: TRzToolbarControl );

    procedure ControlsAreLoaded( OwnerComp: TComponent );

    procedure ReadControl( Reader: TReader ); virtual;
    procedure WriteControl( Index: Integer; Writer: TWriter ); virtual;
    function CreateToolBarControl: TRzToolBarControl;	virtual;
  public
    constructor Create( AToolbar: TRzToolbar );
    destructor Destroy; override;

    procedure ReadControls( Reader: TReader );
    procedure WriteControls( Writer: TWriter );
    function IndexOf( Control: TControl ): Integer;
    function IndexOfName( const ControlName: string ): Integer;
    function AddControl( Control: TControl ): Integer;
    function AddControlName( const ControlName: string ): Integer;
    function RemoveControl( Control: TControl): Integer;
    function RemoveControlName( const ControlName: string ): Integer;

    property Items[ Index: Integer ]: TRzToolbarControl
      read Get
      write Put; default;

    property Toolbar: TRzToolbar
      read FToolbar;
  end;


  {============================================}
  {== TRzCustomizeCaptions Class Declaration ==}
  {============================================}

  TRzCustomizeCaptions = class( TPersistent )
  private
    FStoreCaptions: Boolean;
    FTitle: string;
    FHint: string;
    FClose: string;
    FMoveUp: string;
    FMoveDown: string;
    FTextOptions: string;
    FNoTextLabels: string;
    FShowTextLabels: string;
    FSelectiveTextOnRight: string;
  protected
    function GetCaption( Index: Integer ): string;
    procedure SetCaption( Index: Integer; const Value: string );
  public
    constructor Create;
  published
    property Title: string
      index 1
      read GetCaption
      write SetCaption
      stored FStoreCaptions;

    property Hint: string
      index 2
      read GetCaption
      write SetCaption
      stored FStoreCaptions;

    property Close: string
      index 3
      read GetCaption
      write SetCaption
      stored FStoreCaptions;

    property MoveUp: string
      index 4
      read GetCaption
      write SetCaption
      stored FStoreCaptions;

    property MoveDown: string
      index 5
      read GetCaption
      write SetCaption
      stored FStoreCaptions;

    property TextOptions: string
      index 6
      read GetCaption
      write SetCaption
      stored FStoreCaptions;

    property NoTextLabels: string
      index 7
      read GetCaption
      write SetCaption
      stored FStoreCaptions;

    property ShowTextLabels: string
      index 8
      read GetCaption
      write SetCaption
      stored FStoreCaptions;

    property SelectiveTextOnRight: string
      index 9
      read GetCaption
      write SetCaption
      stored FStoreCaptions;
  end;


  {==================================}
  {== TRzToolbar Class Declaration ==}
  {==================================}

  TRzToolbarTextOptions = ( ttoNoTextLabels, ttoShowTextLabels, ttoSelectiveTextOnRight, ttoCustom );

  TRzToolbar = class( TRzCustomPanel )
  private
    FAutoResize: Boolean;
    FAutoStyle: Boolean;
    FBackground: TBitmap;
    FImages: TCustomImageList;
    FImageChangeLink: TChangeLink;
    FOrientation: TOrientation;
    FRowHeight: Integer;
    FShowDivider: Boolean;
    FShowButtonCaptions: Boolean;
    FButtonLayout: TButtonLayout;
    FButtonWidth: Integer;
    FButtonHeight: Integer;
    FTextOptions: TRzToolbarTextOptions;
    FUpdatingTextOptions: Boolean;
    FWrapControls: Boolean;

    FCustomizeCaptions: TRzCustomizeCaptions;
    FRegIniFile: TRzRegIniFile;

    FOnVisibleChanged: TNotifyEvent;

    { Internal Event Handlers }
    procedure BackgroundChangedHandler( Sender: TObject );
    procedure ImageListChange( Sender: TObject );

    { Message Handling Methods }
    procedure CMVisibleChanged( var Msg: TMessage ); message cm_VisibleChanged;
  protected
    FToolbarControls: TRzToolbarControlList;
    FMargin: Integer;
    FTopMargin: Integer;
    FCalculatedRowHeight: Integer;

    procedure Loaded; override;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure DrawCaption( Rect: TRect ); override;
    procedure Paint; override;

    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;
    procedure AlignControls( AControl: TControl; var Rect: TRect ); override;

    function CalculateRowHeight( Row: Integer ): Integer; virtual;
    procedure PositionControl( Index, Row: Integer; var Offset: Integer ); virtual;
    function CreateToolbarControlList: TRzToolbarControlList; virtual;
    procedure AdjustStyle( Value: TAlign ); virtual;

    { Event Dispatch Methods }
    procedure VisibleChanged; dynamic;

    { Property Access Methods }
    function GetAlign: TAlign; virtual;
    procedure SetAlign( Value: TAlign ); virtual;
    procedure SetAutoResize( Value: Boolean ); virtual;
    procedure SetBackground( Value: TBitmap ); virtual;
    procedure SetImages( Value: TCustomImageList ); virtual;
    procedure SetMargin( Value: Integer ); virtual;
    procedure SetTopMargin( Value: Integer ); virtual;
    procedure SetOrientation( Value: TOrientation ); virtual;
    procedure SetRowHeight( Value: Integer ); virtual;
    procedure SetShowButtonCaptions( Value: Boolean ); virtual;
    procedure SetButtonLayout( Value: TButtonLayout ); virtual;
    procedure SetButtonWidth( Value: Integer ); virtual;
    procedure SetButtonHeight( Value: Integer ); virtual;
    procedure SetShowDivider( Value: Boolean ); virtual;
    procedure SetTextOptions( Value: TRzToolbarTextOptions ); virtual;
    procedure SetWrapControls( Value: Boolean ); virtual;

    procedure SetCustomizeCaptions( Value: TRzCustomizeCaptions ); virtual;
    procedure SetRegIniFile( Value: TRzRegIniFile ); virtual;

    procedure SetBorderInner( Value: TFrameStyleEx ); override;
    procedure SetBorderOuter( Value: TFrameStyleEx ); override;
    procedure SetBorderSides( Value: TSides ); override;

    procedure CheckAutoResize( var Value: Boolean ); virtual;
    procedure SetParent( AParent: TWinControl ); override;
    procedure SetBiDiMode( Value: TBiDiMode ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure PositionControls; virtual; { Made virtual after 2.1 }
    procedure UpdateButtonSize( NewWidth, NewHeight: Integer; ShowCaptions: Boolean ); virtual;

    procedure Customize( ShowTextOptions: Boolean = True );
    procedure RestoreLayout;
    procedure SaveLayout;

    { Property Declarations }
    property ToolbarControls: TRzToolbarControlList
      read FToolbarControls;

    property Canvas;
    property DockManager;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Align: TAlign
      read GetAlign
      write SetAlign
      default alTop;

    property AutoResize: Boolean
      read FAutoResize
      write SetAutoResize
      default True;

    property AutoStyle: Boolean
      read FAutoStyle
      write FAutoStyle
      default True;

    property Background: TBitmap
      read FBackground
      write SetBackground;

    property CustomizeCaptions: TRzCustomizeCaptions
      read FCustomizeCaptions
      write SetCustomizeCaptions;

    property Images: TCustomImageList
      read FImages
      write SetImages;

    property Margin: Integer
      read FMargin
      write SetMargin
      default 4;

    property TopMargin: Integer
      read FTopMargin
      write SetTopMargin
      default 2;

    property Orientation: TOrientation
      read FOrientation
      write SetOrientation
      default orHorizontal;

    property RowHeight: Integer
      read FRowHeight
      write SetRowHeight
      default 25;

    property ButtonLayout: TButtonLayout
      read FButtonLayout
      write SetButtonLayout
      default blGlyphLeft;

    property ButtonWidth: Integer
      read FButtonWidth
      write SetButtonWidth
      default 25;

    property ButtonHeight: Integer
      read FButtonHeight
      write SetButtonHeight
      default 25;

    property RegIniFile: TRzRegIniFile
      read FRegIniFile
      write SetRegIniFile;

    property ShowButtonCaptions: Boolean
      read FShowButtonCaptions
      write SetShowButtonCaptions
      default False;

    property ShowDivider: Boolean
      read FShowDivider
      write SetShowDivider
      default True;

    property TextOptions: TRzToolbarTextOptions
      read FTextOptions
      write SetTextOptions
      default ttoNoTextLabels;

    property WrapControls: Boolean
      read FWrapControls
      write SetWrapControls
      default True;

    property OnVisibleChanged: TNotifyEvent
      read FOnVisibleChanged
      write FOnVisibleChanged;

    { Inherited Properties & Events }
    property Anchors;
    property AutoSize;
    property BevelWidth;
    property BiDiMode;
    property BorderColor;
    property BorderInner nodefault;
    property BorderOuter nodefault;
    property BorderSides nodefault;
    property BorderWidth nodefault;
    property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor;
    property FlatColorAdjustment;
    property Font;
    property FullRepaint default False;
    property Height default 32;
    property Locked;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowDockClientCaptions default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property ThemeAware;
    property Transparent;
    property UseDockManager default True;
    property Visible;
    property Width default 32;

    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDblClick;
    property OnDockDrop;
    property OnDockOver;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetSiteInfo;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;


  {====================================}
  {== TRzStatusBar Class Declaration ==}
  {====================================}

  TRzStatusBar = class( TRzCustomPanel )
  private
    FAutoStyle: Boolean;
    FSizeGripCanvas: TCanvas;
    FSimpleStatus: Boolean;
    FSimpleCaption: TCaption;
    FSimpleFrameStyle: TFrameStyle;
    FSizeGripValid: Boolean;
    FShowSizeGrip: Boolean;
    FAutoScalePanes: Boolean;
    FFirst: Boolean;
    FDelta: Integer;
    FLastWidth: Integer;

    { Message Handling Methods }
    procedure WMSetCursor( var Msg: TWMSetCursor ); message wm_SetCursor;
    procedure WMPaint( var Msg: TWMPaint ); message wm_Paint;
  protected
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure WndProc( var Msg: TMessage ); override;
    procedure Resize; override;
    function GetClientRect: TRect; override;
    procedure PaintSizeGrip( R: TRect );
    procedure DrawSimpleStatusBorder( R: TRect ); virtual;
    procedure Paint; override;

    procedure ValidateSizeGrip;
    function SizeGripRect: TRect;
    procedure AdjustStyle; virtual;

    { Property Access Methods }
    procedure SetShowSizeGrip( Value: Boolean ); virtual;
    procedure SetSimpleCaption( Value: TCaption ); virtual;
    procedure SetSimpleStatus( Value: Boolean ); virtual;
    procedure SetSimpleFrameStyle( Value: TFrameStyle ); virtual;

    procedure SetBorderInner( Value: TFrameStyleEx ); override;
    procedure SetBorderOuter( Value: TFrameStyleEx ); override;
    procedure SetBorderSides( Value: TSides ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    { Property Declarations }
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property AutoScalePanes: Boolean
      read FAutoScalePanes
      write FAutoScalePanes
      default False;

    property AutoStyle: Boolean
      read FAutoStyle
      write FAutoStyle
      default True;

    property ShowSizeGrip: Boolean
      read FShowSizeGrip
      write SetShowSizeGrip
      default True;

    property SimpleCaption: TCaption
      read FSimpleCaption
      write SetSimpleCaption;

    property SimpleFrameStyle: TFrameStyle
      read FSimpleFrameStyle
      write SetSimpleFrameStyle
      default fsFlat;

    property SimpleStatus: Boolean
      read FSimpleStatus
      write SetSimpleStatus
      default False;

    { Inherited Properties & Events }
    property Align default alBottom;
    property Anchors;
    property BevelWidth;
    property BiDiMode;
    property BorderColor;
    property BorderInner nodefault;
    property BorderOuter nodefault;
    property BorderSides nodefault;
    property BorderWidth nodefault;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor;
    property FlatColorAdjustment;
    property Font;
    property FullRepaint;
    property Height;
    property Locked;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property ThemeAware;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
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
  RzToolbarForm;

resourcestring
  sRzCustomizeTitle = 'Customize Toolbar';
  sRzHint = 'Uncheck to hide control';
  sRzMoveUp = 'Move Up';
  sRzMoveDown = 'Move Down';
  sRzClose = 'Close';
  sRzTextOptions = 'Text Options';
  sRzNoTextLabels = 'No text labels';
  sRzShowTextLabels = 'Show text labels';
  sRzSelectiveTextOnRight = 'Selective text on right';


{=================================}
{== TRzPanelDockManager Methods ==}
{=================================}

type
  TTextControl = class( TControl )
  end;

constructor TRzPanelDockManager.Create( DockSite: TWinControl );
begin
  inherited;
  FPanel := DockSite as TRzCustomPanel;
  FGrabberSize := 14;

  FFont := TFont.Create;
  FFont.Name := 'Verdana';
  FFont.Size := 8;

  FCloseFont := TFont.Create;
  FCloseFont.Name := 'Marlett';
  FCloseFont.Size := 8;

  if not (csDesigning in DockSite.ComponentState) then
  begin
    FOldWndProc := DockSite.WindowProc;
    DockSite.WindowProc := WindowProcHook;
  end;

end;


destructor TRzPanelDockManager.Destroy;
begin
  if @FOldWndProc <> nil then
  begin
    DockSite.WindowProc := FOldWndProc;
    FOldWndProc := nil;
  end;

  FFont.Free;
  FCloseFont.Free;
  inherited;
end;


procedure TRzPanelDockManager.WindowProcHook( var Msg: TMessage );
begin
  // This allows us to change the color of the caption bar on focus changes.
  if ( Msg.Msg = wm_Command ) or ( Msg.Msg = wm_MouseActivate ) then
    DockSite.Invalidate;

  if Assigned( FOldWndProc ) then
    FOldWndProc( Msg );
end;



procedure TRzPanelDockManager.AdjustDockRect( Control: TControl; var ARect: TRect );
begin
  // Allocate room for the caption on the left if docksite is horizontally
  // oriented, otherwise allocate room for the caption on the top.
  if FPanel.Align in [ alTop, alBottom ] then
    Inc( ARect.Left, FGrabberSize )
  else
    Inc( ARect.Top, FGrabberSize );
end;


procedure TRzPanelDockManager.DrawVertTitle( Canvas: TCanvas; const Caption: string; Bounds: TRect );
var
  R, TempRct: TRect;
  Center: TPoint;
  Flags: Word;
  OldTextAlign: Integer;

  function TextAligned( A: Integer ): Boolean;
  begin
    Result := ( Flags and A ) = A;
  end;

begin
  with Canvas do
  begin
    OldTextAlign := GetTextAlign( Canvas.Handle );
    R := Bounds;

    Flags := dt_ExpandTabs or DrawTextAlignments[ taLeftJustify ];

    Center.X := R.Right - 2;
    Center.Y := R.Bottom - 3;
    SetTextAlign( Canvas.Handle, ta_Left or ta_Baseline );

    Font.Handle := RotateFont( FFont, 90 );
    Canvas.Font.Color := clCaptionText;

    TempRct := R;
    TextRect( TempRct, Center.X, Center.Y, Caption );

    SetTextAlign( Canvas.Handle, OldTextAlign );
  end;
end; {= TRzPanelDockManager.DrawTitle =}


procedure TRzPanelDockManager.PaintDockFrame( Canvas: TCanvas; Control: TControl; const ARect: TRect );
var
  R: TRect;
  S: string;
begin
  if not FPanel.ShowDockClientCaptions then
    inherited
  else
  begin
    S := TTextControl( Control ).Text;
    Canvas.Font := FFont;

    if Control is TWinControl then
    begin
      if TWinControl( Control ).Focused then
      begin
        Canvas.Brush.Color := clActiveCaption;
        Canvas.Font.Color := clCaptionText;
      end
      else
      begin
        Canvas.Brush.Color := clInactiveCaption;
        Canvas.Font.Color := clInactiveCaptionText;
      end;
    end
    else
    begin
      Canvas.Brush.Color := clActiveCaption;
      Canvas.Font.Color := clCaptionText;
    end;

    if FPanel.Align in [ alTop, alBottom ] then
    begin
      R := Rect( ARect.Left, ARect.Top, ARect.Left + FGrabberSize, ARect.Bottom );
      DrawVertTitle( Canvas, S, R );

      // Draw the Close X
      Canvas.Font.Name := FCloseFont.Name;
      R := Rect( ARect.Left + 1, ARect.Top + 1, ARect.Left + FGrabberSize - 2, ARect.Top + 12 );
      Canvas.TextRect( R, R.Left, R.Top, 'r' );
    end
    else
    begin
      R := Rect( ARect.Left, ARect.Top, ARect.Right, ARect.Top + FGrabberSize );
      Canvas.TextRect( R, R.Left + 2, R.Top, S );

      // Draw the Close X
      Canvas.Font.Name := FCloseFont.Name;
      R := Rect( ARect.Right - FGrabberSize - 1, ARect.Top + 1, ARect.Right - 2, ARect.Top + 12 );
      Canvas.TextRect( R, R.Left, R.Top, 'r' );
    end;
  end;
end; {= TRzPanelDockManager.PaintDockFrame =}


procedure TRzPanelDockManager.PaintSite( DC: HDC );
begin
  inherited;
end;



{&RT}
{============================}
{== TRzCustomPanel Methods ==}
{============================}

constructor TRzCustomPanel.Create( AOwner: TComponent );
begin
  inherited;
  {&RCI}
                              { Prevent Caption from being set to default name }
  ControlStyle := ControlStyle - [ csSetCaption ];

  {$IFDEF VCL70_OR_HIGHER}
  // Delphi 7 sets the csParentBackground style and removes the csOpaque style when Themes are available, which causes
  // all kinds of other problems, so we restore these.
  ControlStyle := ControlStyle - [ csParentBackground ] + [ csOpaque ];
  {$ENDIF}

  FBorderSides := [ sdLeft, sdTop, sdRight, sdBottom ];
  FBorderColor := clBtnFace;
  FBorderHighlight := clBtnHighlight;
  FBorderShadow := clBtnShadow;
  FBorderOuter := fsRaised;
  FFlatColor := clBtnShadow;
  FFlatColorAdjustment := 30;
  BevelOuter := bvNone;
  FAlignmentVertical := avCenter;
  FInAlignControls := False;

  FShowGrid := False;
  FGridColor := clBtnShadow;
  FGridStyle := gsDots;
  FGridXSize := 8;
  FGridYSize := 8;

  FThemeAware := True;

  FShowDockClientCaptions := True;

  FEnabledList := TStringList.Create;
  {&RV}
end;


destructor TRzCustomPanel.Destroy;
begin
  if FFrameController <> nil then
    FFrameController.RemoveControl( Self );

  FEnabledList.Free;
  inherited;
end;


procedure TRzCustomPanel.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( AComponent = FFrameController ) then
    FFrameController := nil;
end;


function TRzCustomPanel.CursorPosition: TPoint;
begin
  GetCursorPos( Result );
  Result := ScreenToClient( Result );
end;


procedure TRzCustomPanel.AlignControls( AControl: TControl; var Rect: TRect );
begin
  // This was added to ensure that the border is drawn correctly when
  // DoubleBuffered is set to True
  FixClientRect( Rect, False );

  inherited;
end;


procedure TRzCustomPanel.SetBounds( ALeft, ATop, AWidth, AHeight: Integer );
begin
  { Adjust Top and Left if alignment is bottom or right because TControl
    repositions other controls that are also aligned in same direction }
  if Align = alBottom then
  begin
    if AHeight <> Height then
      ATop := Top - ( AHeight - Height );
  end
  else if Align = alRight then
  begin
    if AWidth <> Width then
      ALeft := Left - ( AWidth - Width );
  end;

  inherited;
end;


procedure TRzCustomPanel.FixClientRect( var Rect: TRect; ShrinkByBorder: Boolean );

  procedure AdjustRect( var R: TRect; Sides: TSides; N: Integer );
  begin
    if sdLeft in Sides then
      Inc( R.Left, N );
    if sdTop in Sides then
      Inc( R.Top, N );
    if sdRight in Sides then
      Dec( R.Right, N );
    if sdBottom in Sides then
      Dec( R.Bottom, N );
  end;

begin
  if ShrinkByBorder then
    InflateRect( Rect, -BorderWidth, -BorderWidth );

  if FBorderOuter = fsFlat then
    AdjustRect( Rect, FBorderSides, 1 )
  else if FBorderOuter in [ fsStatus, fsPopup ] then
    AdjustRect( Rect, FBorderSides, BevelWidth )
  else if FBorderOuter in [ fsGroove..fsButtonUp, fsFlatBold, fsFlatRounded ] then
    AdjustRect( Rect, FBorderSides, 2 );

  if FBorderInner = fsFlat then
    AdjustRect( Rect, FBorderSides, 1 )
  else if FBorderInner in [ fsStatus, fsPopup ] then
    AdjustRect( Rect, FBorderSides, BevelWidth )
  else if FBorderInner in [ fsGroove..fsButtonUp, fsFlatBold, fsFlatRounded ] then
    AdjustRect( Rect, FBorderSides, 2 );
end;



procedure TRzCustomPanel.AdjustClientRect( var Rect: TRect );
begin
  inherited;
  if DockSite then
    FixClientRect( Rect, False );
end;


function TRzCustomPanel.GetClientRect: TRect;
begin
  Result := inherited GetClientRect;
//  if not DockSite then
//    FixClientRect( Result, False {True for the splitter } );
end;


procedure TRzCustomPanel.WMWindowPosChanged( var Msg: TWMWindowPosChanged );
var
  R, CR: TRect;
begin
  if FullRepaint or ( Caption <> '' ) then
    Invalidate
  else
  begin

    R := Rect( 0, 0, Width, Height );
    CR := R;
    FixClientRect( CR, True );

    if Msg.WindowPos^.cx <> R.Right then
    begin
      R.Left := CR.Right - 1;
      R.Top := 0;
      InvalidateRect( Handle, @R, True );
    end;

    if Msg.WindowPos^.cy <> R.Bottom then
    begin
      R.Left := 0;
      R.Top := CR.Bottom - 1;
      InvalidateRect( Handle, @R, True );
    end;
  end;
  inherited;
end;


procedure TRzCustomPanel.DrawCaption( Rect: TRect );
var
  TextRct: TRect;
  H: Integer;
begin
  with Canvas, Rect do
  begin
    if Caption <> '' then
    begin
      Font := Self.Font;

      Inc( Rect.Left );
      TextRct := Rect;
      H := DrawText( Handle, PChar( Caption ), -1, TextRct,
                     dt_CalcRect or dt_WordBreak or dt_ExpandTabs or dt_VCenter or DrawTextAlignments[ Alignment ] );

      if FAlignmentVertical = avCenter then
      begin
        Top := ( ( Bottom + Top ) - H ) shr 1;
        Bottom := Top + H;
      end
      else if FAlignmentVertical = avBottom then
        Top := Bottom - H - 1;


      Brush.Style := bsClear;
      if not Enabled then
      begin
        Font.Color := clBtnHighlight;
        OffsetRect( Rect, 1, 1 );
        DrawText( Handle, PChar( Caption ), -1, Rect,
                  dt_WordBreak or dt_ExpandTabs or dt_VCenter or DrawTextAlignments[ Alignment ] );

        Font.Color := clBtnShadow;
        OffsetRect( Rect, -1, -1 );
      end;

      DrawText( Handle, PChar( Caption ), -1, Rect,
                dt_WordBreak or dt_ExpandTabs or dt_VCenter or DrawTextAlignments[ Alignment ] );
    end;
  end;
end;


function TRzCustomPanel.GetControlRect: TRect;
begin
  Result := Rect( 0, 0, Width, Height );
end;


procedure TRzCustomPanel.DrawGrid( Rect: TRect );
var
  X, Y, XCount, YCount: Integer;

  procedure DrawHorzLine( X1, X2, Y: Integer );
  var
    X: Integer;
  begin
    if FGridStyle = gsSolidLines then
    begin
      Canvas.MoveTo( X1, Y );
      Canvas.LineTo( X2, Y );
    end
    else
    begin
      X := X1 + 1;
      Canvas.MoveTo( X, Y );
      while X < X2 do
      begin
        Canvas.Pixels[ X, Y ] := FGridColor;
        Inc( X, 2 );
      end;
    end;
  end;

  procedure DrawVertLine( X, Y1, Y2: Integer );
  var
    Y: Integer;
  begin
    if FGridStyle = gsSolidLines then
    begin
      Canvas.MoveTo( X, Y1 );
      Canvas.LineTo( X, Y2 );
    end
    else
    begin
      Y := Y1 + 1;
      Canvas.MoveTo( X, Y );
      while Y < Y2 do
      begin
        Canvas.Pixels[ X, Y ] := FGridColor;
        Inc( Y, 2 );
      end;

    end;
  end;

begin {= TRzCustomPanel.DrawGrid =}
  if FGridXSize > 0 then
    XCount := ( Rect.Right - Rect.Left ) div FGridXSize
  else
    XCount := 0;
  if FGridYSize > 0 then
    YCount := ( Rect.Bottom - Rect.Top ) div FGridYSize
  else
    YCount := 0;

  Canvas.Pen.Color := FGridColor;
  case FGridStyle of
    gsDots:
    begin
      for X := 1 to XCount do
      begin
        for Y := 1 to YCount do
          Canvas.Pixels[ Rect.Left - 1 + X * FGridXSize, Rect.Top - 1 + Y * FGridYSize ] := FGridColor;
      end;
    end;

    gsDottedLines, gsSolidLines:
    begin
      for X := 1 to XCount do
        DrawVertLine( Rect.Left - 1 + X * FGridXSize, Rect.Top, Rect.Bottom );

      for Y := 1 to YCount do
        DrawHorzLine( Rect.Left, Rect.Right, Rect.Top - 1 + Y * FGridYSize );
    end;
  end;
end; {= TRzCustomPanel.DrawGrid =}


procedure TRzCustomPanel.WMEraseBkgnd( var Msg: TWMEraseBkgnd );
begin
  if FTransparent then
  begin
    DrawParentImage( Self, Msg.DC, True );
    Msg.Result := 1;
  end
  else
    inherited;
end;


type
  TWinControlAccess = class( TWinControl );


procedure TRzCustomPanel.Paint;
var
  R: TRect;
begin
  R := GetControlRect;

  R := DrawInnerOuterBorders( Canvas, R, FBorderOuter, FBorderInner, BorderWidth, FBorderSides, BevelWidth,
                              FBorderColor, FBorderHighlight, FBorderShadow,
                              FlatColor, FlatColorAdjustment, Color, TWinControlAccess( Parent ).Color, FTransparent );

  if not FTransparent then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect( R );
  end;

  if FShowGrid then
    DrawGrid( R );

  Canvas.Brush.Style := bsClear;
  DrawCaption( R );
  Canvas.Brush.Style := bsSolid;

  if Assigned( FOnPaint ) then
    FOnPaint( Self );

end; {= TRzCustomPanel.Paint =}


procedure TRzCustomPanel.CustomFramingChanged;
begin
  if FFrameController.FrameVisible then
  begin
    FBorderOuter := FFrameController.FrameStyle;
    FBorderSides := FFrameController.FrameSides;
    FFlatColor := FFrameController.FrameColor;
    FFlatColorAdjustment := 0;
    Color := FFrameController.Color;
    ParentColor := FFrameController.ParentColor;

    FBorderHighlight := LighterColor( Color, 100 );
    FBorderShadow := DarkerColor( Color, 50 );

    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetAlignmentVertical( Value: TAlignmentVertical );
begin
  if FAlignmentVertical <> Value then
  begin
    FAlignmentVertical := Value;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetBorderSides( Value: TSides );
begin
  if FBorderSides <> Value then
  begin
    FBorderSides := Value;
    Realign;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetBorderColor( Value: TColor );
begin
  if FBorderColor <> Value then
  begin
    FBorderColor := Value;
    Invalidate;
  end;
end;

procedure TRzCustomPanel.SetBorderHighlight( Value: TColor );
begin
  if FBorderHighlight <> Value then
  begin
    FBorderHighlight := Value;
    Invalidate;
  end;
end;

procedure TRzCustomPanel.SetBorderShadow( Value: TColor );
begin
  if FBorderShadow <> Value then
  begin
    FBorderShadow := Value;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetBorderInner( Value: TFrameStyleEx );
begin
  if FBorderInner <> Value then
  begin
    FBorderInner := Value;
    Realign;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetBorderOuter( Value: TFrameStyleEx );
begin
  if FBorderOuter <> Value then
  begin
    FBorderOuter := Value;
    Realign;
    Invalidate;
  end;
end;

procedure TRzCustomPanel.SetFlatColor( Value: TColor );
begin
  if FFlatColor <> Value then
  begin
    FFlatColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetFlatColorAdjustment( Value: Integer );
begin
  if FFlatColorAdjustment <> Value then
  begin
    FFlatColorAdjustment := Value;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetFrameController( Value: TRzFrameController );
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


procedure TRzCustomPanel.SetGridColor( Value: TColor );
begin
  if FGridColor <> Value then
  begin
    FGridColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetGridStyle( Value: TRzGridStyle );
begin
  if FGridStyle <> Value then
  begin
    FGridStyle := Value;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetGridXSize( Value: Word );
begin
  if FGridXSize <> Value then
  begin
    FGridXSize := Value;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetGridYSize( Value: Word );
begin
  if FGridYSize <> Value then
  begin
    FGridYSize := Value;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetGridSize( XSize, YSize: Integer );
begin
  SetGridXSize( XSize );
  SetGridYSize( YSize );
end;


procedure TRzCustomPanel.SetShowGrid( Value: Boolean );
begin
  if FShowGrid <> Value then
  begin
    FShowGrid := Value;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetThemeAware( Value: Boolean );
begin
  if FThemeAware <> Value then
  begin
    FThemeAware := Value;
    Invalidate;
  end;
end;


procedure TRzCustomPanel.SetTransparent( Value: Boolean );
var
  I: Integer;
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    if FTransparent then
      ControlStyle := ControlStyle - [ csOpaque ]
    else
      ControlStyle := ControlStyle + [ csOpaque ];
    Invalidate;
    for I := 0 to ControlCount - 1 do
      Controls[ I ].Invalidate;
  end;
end;


procedure TRzCustomPanel.MouseEnter;
begin
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
end;


procedure TRzCustomPanel.CMMouseEnter( var Msg: TMessage );
begin
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  MouseEnter;
end;


procedure TRzCustomPanel.MouseLeave;
begin
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
end;


procedure TRzCustomPanel.CMMouseLeave( var Msg: TMessage );
begin
  inherited;
  MouseLeave;
end;


procedure TRzCustomPanel.CMEnabledChanged( var Msg: TMessage );
var
  I, Idx: Integer;
begin
  inherited;
  Repaint;

  if not Enabled then
  begin
    FEnabledList.Clear;

    for I := 0 to ControlCount - 1 do
    begin
      if Controls[ I ].Enabled then
        FEnabledList.AddObject( '1', Controls[ I ] )
      else
        FEnabledList.AddObject( '0', Controls[ I ] );
    end;

    for I := 0 to ControlCount - 1 do
      Controls[ I ].Enabled := False;
  end
  else
  begin
    for I := 0 to ControlCount - 1 do
    begin
      Idx := FEnabledList.IndexOfObject( Controls[ I ] );
      if Idx <> -1 then
      begin
        if FEnabledList[ Idx ] = '1' then
          Controls[ I ].Enabled := True;
      end
      else
        Controls[ I ].Enabled := True;
    end;
  end;
end;


function TRzCustomPanel.CreateDockManager: IDockManager;
begin
  if ( DockManager = nil ) and DockSite and UseDockManager then
    Result := TRzPanelDockManager.Create( Self )
  else
    Result := DockManager;
  DoubleBuffered := DoubleBuffered or (Result <> nil);
end;


procedure TRzCustomPanel.DefineProperties( Filer: TFiler );
begin
  inherited;

  // Handle the fact that the FrameSides property was published in version 2.x
  Filer.DefineProperty( 'FrameSides', TRzOldPropReader.ReadOldSetProp, nil, False );
end;



{===============================}
{== TRzCustomGroupBox Methods ==}
{===============================}

constructor TRzCustomGroupBox.Create( AOwner: TComponent );
begin
  inherited;
  ControlStyle := ControlStyle + [ csSetCaption, csDoubleClicks ];
  BorderOuter := fsNone;
  BorderInner := fsNone;
  Alignment := taLeftJustify;
  AlignmentVertical := avTop;
  Height := 105;

  { Initializing GroupStyle must occur after BorderOuter/BorderInner settings
    b/c SetBorderOuter/SetBorderInner change GroupStyle to gsCustom }
  FGroupStyle := gsFlat;
  {&RCI}
end;


procedure TRzCustomGroupBox.AdjustClientRect( var Rect: TRect );
var
  H: Integer;
begin
  inherited;

  Canvas.Font := Font;
  H := Canvas.TextHeight( 'Yy' );

  if FGroupStyle in [ gsStandard, gsFlat, gsTopLine ] then
  begin
    if BorderWidth > H div 2 - 1 then
      Inc( Rect.Top, H div 2 - 1 )
    else
      Inc( Rect.Top, H - BorderWidth );
    if FGroupStyle = gsStandard then
      InflateRect( Rect, -2, -2 )
    else
      InflateRect( Rect, -1, -1 );
  end
  else // FGroupStyle = gsCustom
  begin
    Inc( Rect.Top, H );
    InflateRect( Rect, -2, -2 );
  end;

end;


procedure TRzCustomGroupBox.CMDialogChar( var Msg: TCMDialogChar );
begin
  with Msg do
  begin
    if IsAccel( CharCode, Caption ) and CanFocus then
    begin
      SelectFirst;
      Result := 1;
    end
    else
      inherited;
  end;
end;


procedure TRzCustomGroupBox.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  Invalidate;
end;


procedure TRzCustomGroupBox.WMEraseBkgnd( var Msg: TWMEraseBkgnd );
begin
  if FTransparent then
  begin
    DrawParentImage( Self, Msg.DC, True );
    Msg.Result := 1;
  end
  else
    inherited;
end;


procedure TRzCustomGroupBox.CustomFramingChanged;
begin
  if FFrameController.FrameVisible and ( FGroupStyle = gsCustom ) then
    inherited;
end;


procedure TRzCustomGroupBox.Paint;
var
  H, Offset: Integer;
  R, CaptionRect: TRect;
  C: TColor;
  CaptionSize: TSize;
  ElementDetails: TThemedElementDetails;
begin
  Canvas.Font := Self.Font;
  H := Canvas.TextHeight( 'Pp' );

  if ( Caption <> '' ) and ( FGroupStyle <> gsCustom ) then
  begin
    GetTextExtentPoint32( Canvas.Handle, PChar( Caption ), Length( Caption ), CaptionSize );
    CaptionRect := Rect( 0, 0, CaptionSize.CX, CaptionSize.CY );

    if FGroupStyle in [ gsStandard, gsFlat ] then
      Offset := 8
    else
      Offset := 0;
    OffsetRect( CaptionRect, Offset, 0 );

    if UseRightToLeftAlignment then
      OffsetRect( CaptionRect, Width - Offset - CaptionRect.Right, 0 );
  end
  else
    CaptionRect := Rect( 0, 0, 0, 0 );

  if FThemeAware and ThemeServices.ThemesEnabled then
  begin
    if not FTransparent then
    begin
      // When group box is not transparent, the control has it's csOpaque style set. This prevents the wm_EraseBkgnd
      // message from being sent to the control. Therefore, the background needs to be painted here.
      DrawParentImage( Self, Canvas.Handle, True );
    end;

    ExcludeClipRect( Canvas.Handle, CaptionRect.Left, CaptionRect.Top, CaptionRect.Right, CaptionRect.Bottom );
    R := Rect( 0, H div 2 - 1, Width, Height );

    if Enabled then
      ElementDetails := ThemeServices.GetElementDetails( tbGroupBoxNormal )
    else
      ElementDetails := ThemeServices.GetElementDetails( tbGroupBoxDisabled );

    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );

    SelectClipRgn( Canvas.Handle, 0 );
    if Caption <> '' then
      ThemeServices.DrawText( Canvas.Handle, ElementDetails, Caption, CaptionRect, DT_LEFT, 0 );
  end
  else // No Themes
  begin
    if FGroupStyle in [ gsStandard, gsTopLine, gsFlat ] then
    begin
      R := Rect( 0, 0, Width, Height );

      if FTransparent then
      begin
        ExcludeClipRect( Canvas.Handle, CaptionRect.Left, CaptionRect.Top, CaptionRect.Right, CaptionRect.Bottom );
      end
      else
      begin
        Canvas.Brush.Color := Color;
        Canvas.FillRect( R );
      end;

      R := Rect( 0, H div 2 - 1, Width, Height );

      case FGroupStyle of
        gsStandard:
        begin
          if BorderOuter = fsNone then
            DrawBorderSides( Canvas, R, fsGroove, sdAllSides )
          else if BorderOuter in [ fsFlat, fsFlatBold ] then
          begin
            C := AdjustColor( FFlatColor, FFlatColorAdjustment );
            if BorderOuter = fsFlat then
              DrawBevel( Canvas, R, C, C, 1, sdAllSides )
            else
              DrawBevel( Canvas, R, C, C, 2, sdAllSides );
          end
          else
            DrawBorderSides( Canvas, R, BorderOuter, sdAllSides );
        end;

        gsTopLine:
        begin
          if BorderOuter = fsNone then
            DrawBorderSides( Canvas, R, fsGroove, [ sdTop ] )
          else if BorderOuter in [ fsFlat, fsFlatBold ] then
          begin
            C := AdjustColor( FFlatColor, FFlatColorAdjustment );
            Canvas.Pen.Color := C;
            Canvas.MoveTo( R.Left + 2, R.Top );
            Canvas.LineTo( R.Right - 2, R.Top );
            if BorderOuter = fsFlatBold then
            begin
              Canvas.MoveTo( R.Left + 2, R.Top + 1 );
              Canvas.LineTo( R.Right - 2, R.Top + 1 );
            end;
          end
          else
            DrawBorderSides( Canvas, R, BorderOuter, [ sdTop ] );
        end;

        gsFlat:
        begin
          C := AdjustColor( FFlatColor, FFlatColorAdjustment );
          Canvas.Pen.Color := C;
          // Left side
          Canvas.MoveTo( R.Left, R.Top + 2 );
          Canvas.LineTo( R.Left, R.Bottom - 2 );
          // Top side
          Canvas.MoveTo( R.Left + 2, R.Top );
          Canvas.LineTo( R.Right - 2, R.Top );
          // Right side
          Canvas.MoveTo( R.Right - 1, R.Top + 2 );
          Canvas.LineTo( R.Right - 1, R.Bottom - 2 );
          // Bottom side
          Canvas.MoveTo( R.Left + 2, R.Bottom - 1 );
          Canvas.LineTo( R.Right - 2, R.Bottom - 1 );

          Canvas.Pixels[ R.Left + 1, R.Top + 1 ] := C;
          Canvas.Pixels[ R.Right - 2, R.Top + 1 ] := C;
          Canvas.Pixels[ R.Right - 2, R.Bottom - 2 ] := C;
          Canvas.Pixels[ R.Left + 1, R.Bottom - 2 ] := C;
        end;
      end;
    end
    else
      inherited;                                           // Draw panel borders 

    if ( Caption <> '' ) and ( FGroupStyle <> gsCustom ) then
    begin
      if not FTransparent then
        Canvas.FillRect( CaptionRect );

      Canvas.Brush.Style := bsClear;
      if not Enabled then
      begin
        Canvas.Font.Color := clBtnHighlight;
        OffsetRect( CaptionRect, 1, 1 );
        DrawText( Canvas.Handle, PChar( Caption ), -1, CaptionRect, dt_Left or dt_SingleLine );
        Canvas.Font.Color := clBtnShadow;
        OffsetRect( CaptionRect, -1, -1 );
      end;

      SelectClipRgn( Canvas.Handle, 0 );
      DrawText( Canvas.Handle, PChar( Caption ), -1, CaptionRect, dt_Left or dt_SingleLine );
    end;
  end;
end;


procedure TRzCustomGroupBox.SetGroupBoxStyle( Value: TRzGroupBoxStyle );
begin
  {&RV}
  if FGroupStyle <> Value then
  begin
    FGroupStyle := Value;
    if not ( FGroupStyle in [ gsStandard, gsFlat ] ) then
      FThemeAware := False;
    Invalidate;
  end;
end;



{=======================}
{== TRzSpacer Methods ==}
{=======================}

constructor TRzSpacer.Create( AOwner: TComponent );
begin
  inherited;
  FGrooved := False;
  Width := 8;
  Height := 25;
  FOrientation := orHorizontal;
  {&RCI}
end;


procedure TRzSpacer.Paint;
var
  X1, Y1, X2, Y2: Integer;
  ElementDetails: TThemedElementDetails;
  R: TRect;
begin
  inherited;

  if ( csDesigning in ComponentState ) and not FGrooved then
  begin
    Canvas.Pen.Style := psDot;
    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Style := bsClear;
    Canvas.Rectangle( ClientRect );
  end
  else if FGrooved then
  begin
    if ThemeServices.ThemesEnabled then
    begin
      if Width > Height then
        ElementDetails := ThemeServices.GetElementDetails( ttbSeparatorVertNormal )
      else
        ElementDetails := ThemeServices.GetElementDetails( ttbSeparatorNormal );
      R := ClientRect;
      ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );
    end
    else
    begin
      if Width > Height then
      begin
        X1 := ClientRect.Left + 1;
        Y1 := ClientRect.Top + ( ClientRect.Bottom - ClientRect.Top ) div 2 - 1;
        X2 := ClientRect.Right;
        Y2 := Y1;
      end
      else
      begin
        X1 := ClientRect.Left + ( ClientRect.Right - ClientRect.Left ) div 2 - 1;
        Y1 := ClientRect.Top + 1;
        X2 := X1;
        Y2 := ClientRect.Bottom;
      end;

      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Color := clBtnShadow;
      Canvas.MoveTo( X1, Y1 );
      Canvas.LineTo( X2, Y2 );

      if Width > Height then
      begin
        Inc( Y1 );
        Inc( Y2 );
      end
      else
      begin
        Inc( X1 );
        Inc( X2 );
      end;
      Canvas.Pen.Color := clBtnHighlight;
      Canvas.MoveTo( X1, Y1 );
      Canvas.LineTo( X2, Y2 );
    end;
  end;
end;


procedure TRzSpacer.SetGrooved( Value: Boolean );
begin
  {&RV}
  if FGrooved <> Value then
  begin
    FGrooved := Value;
    Invalidate;
  end;
end;


procedure TRzSpacer.SetOrientation( Value: TOrientation );
var
  W: Integer;
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    if not ( csLoading in ComponentState ) then
    begin
      { Swap Width and Height }
      W := Width;
      Width := Height;
      Height := W;
      Invalidate;
    end;
  end;
end;


{===============================}
{== TRzToolbarControl Methods ==}
{===============================}

{===============================================================================
  TRzToolbarControl.AssignElements

  Descendant classes of TRzToolbarControl that implement additional properties
  must override this method, calling inherited and then transfering any
  additional properties from referenceToolbarControl to Self.
===============================================================================}

procedure TRzToolbarControl.AssignElements( Control: TRzToolbarControl );
begin
  { Do nothing. Let descendants of TRzToolbarControl implement functionality. }
end;



{===================================}
{== TRzToolbarControlList Methods ==}
{===================================}

constructor TRzToolbarControlList.Create( AToolbar: TRzToolbar );
begin
  inherited Create;
  FToolbar := AToolbar;
end;


destructor TRzToolbarControlList.Destroy;
var
  I: Integer;
begin
  if Assigned( FTempControlList ) then
  begin
    FTempControlList.Free;
    FTempControlList := nil;
  end;

  { Free all TRzToolbarControls managed by the list }
  for I := 0 to Count - 1 do
    Items[ I ].Free;

  inherited;
end;


function TRzToolbarControlList.Get( Index: Integer ): TRzToolbarControl;
begin
  Result := TRzToolbarControl( inherited Get( Index ) );
end;

procedure TRzToolbarControlList.Put( Index: Integer; Value: TRzToolbarControl );
begin
  inherited Put( Index, Value );
end;


{===============================================================================
  TRzToolbarControlList.ReadControl

  Descendant classes can override and use FIndexOfLastControlRead to access the
  Control list, adding the necessary elements as they are streamed in.
===============================================================================}

procedure TRzToolbarControlList.ReadControl( Reader: TReader );
begin
  FIndexOfLastControlRead := FTempControlList.AddControlName( Reader.ReadIdent );
end;

procedure TRzToolbarControlList.ReadControls( Reader: TReader );
var
  I: Integer;
begin
  if not Assigned( FTempControlList ) then
    FTempControlList := TRzToolbarControlList.Create( FToolbar );

  for I := 0 to FTempControlList.Count - 1 do
    FTempControlList.Items[ I ].Free;
  FTempControlList.Clear;

  Reader.ReadListBegin;
  while not Reader.EndOfList do
    ReadControl( Reader );
  Reader.ReadListEnd;
end;


procedure TRzToolbarControlList.WriteControl( Index: Integer; Writer: TWriter );
begin
  Writer.WriteIdent( Items[ Index ].Control.Name );
end;

procedure TRzToolbarControlList.WriteControls( Writer: TWriter );
var
  I: Integer;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do
    WriteControl( I, Writer );
  Writer.WriteListEnd;
end;



procedure TRzToolbarControlList.ControlsAreLoaded( OwnerComp: TComponent );
var
  I: Integer;
  C: TComponent;
  Idx: Integer;
  FInACopy: Boolean;
begin
  if FTempControlList <> nil then
  begin
    FInACopy := False;
    for I := 0 to FTempControlList.Count - 1 do
    begin
      C := OwnerComp.FindComponent( FTempControlList.Items[ I ].ControlName );
      if ( C <> nil ) and ( C is TControl ) then
      begin
        if TControl( C ).Parent = FToolbar then
        begin
          Idx := AddControl( TControl( C ) );
          if Idx <> -1 then
            Items[ Idx ].AssignElements( FTempControlList.Items[ I ] );
        end
        else
        begin
          { Control is not parented by the Toolbar. This will occur
            if the toolbar was copied to the clipboard and pasted into
            the same form.  Therefore, remove the control from the list.}
          RemoveControlName( FTempControlList.Items[ I ].ControlName );
          FInACopy := True;
        end;
      end;
    end;

    if FInACopy then
    begin
      if FToolbar <> nil then
      begin
        for I := 0 to FToolbar.ControlCount - 1 do
          AddControl( FToolbar.Controls[ I ] );
      end;
    end;


    FTempControlList.Free;
    FTempControlList := nil;
  end
  else
  begin
    {===========================================================================
      If FTempControlList is empty, then the form file being loaded does not
      have a ToolbarControls property specfied. This will occur if the
      toolbar has no controls on it, or if the form was built using version
      1.01 or earlier of TRzToolbar.  In either case, iterate through all
      controls on the toolbar and add them to the list.
    ===========================================================================}
    if FToolbar <> nil then
    begin
      for I := 0 to FToolbar.ControlCount - 1 do
        AddControl( FToolbar.Controls[ I ] );
    end;
  end;
end;


function TRzToolbarControlList.IndexOfName( const ControlName: string ): Integer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if CompareText( Items[ I ].ControlName, ControlName ) = 0 then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;


function TRzToolbarControlList.IndexOf( Control: TControl ): Integer;
var
  I: Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Items[ I ].Control = Control then
    begin
      Result := I;
      Exit;
    end;
  end;
  Result := -1;
end;


function TRzToolBarControlList.CreateToolBarControl: TRzToolBarControl;
begin
  Result := TRzToolBarControl.Create;
end;


{===============================================================================
  TRzToolbarControlList.AddControl

  Adds someControl to the list, if it's not already in the list.
  Returns the index to the new item.
===============================================================================}

function TRzToolbarControlList.AddControl( Control: TControl ): Integer;
var
  Idx: Integer;
  Item: TRzToolbarControl;
begin
  Idx := IndexOf( Control );
  if Idx = -1 then
  begin
    Item := CreateToolbarControl;
    Item.FControl := Control;
    Item.FControlName := Control.Name;
    Result := inherited Add( Item );
  end
  else
    Result := Idx;
end;


function TRzToolbarControlList.AddControlName( const ControlName: string ): Integer;
var
  Idx: Integer;
  Item: TRzToolbarControl;
begin
  Idx := IndexOfName( ControlName );
  if Idx = -1 then
  begin
    Item := CreateToolbarControl;
    Item.FControlName := ControlName;
    Result := inherited Add( Item );
  end
  else
    Result := Idx;
end;


{===============================================================================
  TRzToolbarControlList.RemoveControl

  Returns old index of component that was removed.
  Returns -1 if component is not in list.
===============================================================================}

function TRzToolbarControlList.RemoveControl( Control: TControl ): Integer;
var
  Idx: Integer;
  Item: TRzToolbarControl;
begin
  Idx := IndexOf( Control );
  Result := Idx;
  if Idx = -1 then
  begin
    Exit;
  end
  else
  begin
    Item := Items[ Idx ];
    Result := inherited Remove( Item );
    Item.Free;
  end;
end;


function TRzToolbarControlList.RemoveControlName( const ControlName: string ): Integer;
var
  Idx: Integer;
  Item: TRzToolbarControl;
begin
  Idx := IndexOfName( ControlName );
  Result := Idx;
  if Idx = -1 then
  begin
    Exit;
  end
  else
  begin
    Item := Items[ Idx ];
    Result := inherited Remove( Item );
    Item.Free;
  end;
end;



{==================================}
{== TRzCustomizeCaptions Methods ==}
{==================================}

constructor TRzCustomizeCaptions.Create;
begin
  inherited Create;
  FStoreCaptions := False;

  FTitle := sRzCustomizeTitle;
  FHint:= sRzHint;
  FClose := sRzClose;
  FMoveUp := sRzMoveUp;
  FMoveDown := sRzMoveDown;
  FTextOptions := sRzTextOptions;
  FNoTextLabels := sRzNoTextLabels;
  FShowTextLabels := sRzShowTextLabels;
  FSelectiveTextOnRight := sRzSelectiveTextOnRight;
end;


function TRzCustomizeCaptions.GetCaption( Index: Integer ): string;
begin
  case Index of
    1: Result := FTitle;
    2: Result := FHint;
    3: Result := FClose;
    4: Result := FMoveUp;
    5: Result := FMoveDown;
    6: Result := FTextOptions;
    7: Result := FNoTextLabels;
    8: Result := FShowTextLabels;
    9: Result := FSelectiveTextOnRight;
  end;
end;


procedure TRzCustomizeCaptions.SetCaption( Index: Integer; const Value: string );
begin
  case Index of
    1: FTitle := Value;
    2: FHint := Value;
    3: FClose := Value;
    4: FMoveUp := Value;
    5: FMoveDown := Value;
    6: FTextOptions := Value;
    7: FNoTextLabels := Value;
    8: FShowTextLabels := Value;
    9: FSelectiveTextOnRight := Value;
  end;
  FStoreCaptions := True;
end;



{========================}
{== TRzToolbar Methods ==}
{========================}

constructor TRzToolbar.Create( AOwner: TComponent );
begin
  inherited;

  FShowDivider := True;
  FBorderInner := fsNone;
  FBorderOuter := fsGroove;
  FBorderSides := [ sdTop ];

  BorderWidth := 0;
  Align := alTop;
  Height := 32;
  Width := 32;
  ShowDockClientCaptions := False;

  FullRepaint := False;
  {&RCI}
  FToolbarControls := CreateToolbarControlList;
  FRowHeight := 25;
  FMargin := 4;
  FTopMargin := 2;
  FAutoResize := True;
  FAutoStyle := True;
  FWrapControls := True;
  FOrientation := orHorizontal;
  FBackground := TBitmap.Create;
  FBackground.OnChange := BackgroundChangedHandler;

  FShowButtonCaptions := False;
  FButtonLayout := blGlyphLeft;
  FButtonWidth := 25;
  FButtonHeight := 25;

  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;

  FTextOptions := ttoNoTextLabels;
  FCustomizeCaptions := TRzCustomizeCaptions.Create;
end; {= TRzToolbar.Create =}


destructor TRzToolbar.Destroy;
begin
  FBackground.Free;
  FToolbarControls.Free;
  FImageChangeLink.Free;
  FCustomizeCaptions.Free;
  inherited;
end;


procedure TRzToolbar.SetParent( AParent: TWinControl );
begin
  inherited;

  { The TPageScroller automatically resizes whatever is dropped onto it.
    This will cause an infinit loop if the AutoResize property is True. }

  CheckAutoResize( FAutoResize );
end;



{===============================================================================
  TRzToolbar.CreateToolbarControlList

  Descendant classes that need to also use a descendant of
  TRzToolbarControlList can override this and return custom class.
  (IMPORTANT: don't call inherited when overriding this proc)
===============================================================================}

function TRzToolbar.CreateToolbarControlList: TRzToolbarControlList;
begin
  Result := TRzToolbarControlList.Create( Self );
end;


procedure TRzToolbar.Loaded;
begin
  inherited;

  if Owner <> nil then
    FToolbarControls.ControlsAreLoaded( Owner );

  PositionControls;
  if FAutoStyle then
    AdjustStyle( Align );
  {&RV}
end;


procedure TRzToolbar.DefineProperties( Filer: TFiler );
begin
  inherited;
  Filer.DefineProperty( 'ToolbarControls', FToolbarControls.ReadControls, FToolbarControls.WriteControls,
                        FToolbarControls.Count > 0 );
end;


procedure TRzToolbar.AdjustStyle( Value: TAlign );
begin
  if Value in [ alLeft, alRight ] then
  begin
    FBorderInner := fsNone;
    if FShowDivider then
      FBorderOuter := fsGroove
    else
      FBorderOuter := fsNone;
    if Value = alLeft then
      FBorderSides := [ sdLeft ]
    else
      FBorderSides := [ sdRight ];
  end
  else
  begin
    FBorderInner := fsNone;
    FBorderOuter := fsGroove;

    if FShowDivider then
      FBorderOuter := fsGroove
    else
      FBorderOuter := fsNone;
    if Value = alBottom then
      FBorderSides := [ sdBottom ]
    else
      FBorderSides := [ sdTop ];
  end;
  Invalidate;
end;



procedure TRzToolbar.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if not ( csDestroying in ComponentState ) then
  begin
    if ( Operation = opRemove ) and ( AComponent is TControl ) and
       ( FToolbarControls <> nil ) and ( AComponent <> Self ) and
       ( FToolbarControls.RemoveControl( TControl( AComponent ) ) <> -1 ) then
    begin
      PositionControls;
    end;
  end;

  if ( Operation = opRemove ) and ( AComponent = FImages ) then
    SetImages( nil )  // Call access method so connections to link object can be cleared
  else if ( Operation = opRemove ) and ( AComponent = FRegIniFile ) then
    FRegIniFile := nil;
end;


procedure TRzToolbar.AlignControls( AControl: TControl; var Rect: TRect );
begin
  if not ( csLoading in ComponentState ) then
  begin
    if ( AControl <> nil ) and ( AControl.Parent = Self ) then
      FToolbarControls.AddControl( AControl );
    PositionControls;
  end;
end;


procedure TRzToolbar.PositionControl( Index, Row: Integer; var Offset: Integer );
var
  Control: TControl;
  YOffset, XOffset: Integer;
begin
  Control := FToolbarControls.Items[ Index ].Control;
  if not Assigned( Control ) or ( csDestroying in Control.ComponentState ) then
    Exit;

  with Control do
  begin
    if FOrientation = orHorizontal then
    begin
      YOffset := FTopMargin + FCalculatedRowHeight * ( Row - 1 ) + ( FRowHeight div 2 ) - ( Height div 2 );
      if not UseRightToLeftAlignment then
        SetBounds( Offset, YOffset, Width, Height )
      else
        SetBounds( Self.Width - Width - Offset, YOffset, Width, Height );
      Offset := Offset + Width;
    end
    else
    begin
      XOffset := FMargin + FCalculatedRowHeight * ( Row - 1 ) +
                 ( FRowHeight div 2 ) - ( Width div 2 );
      SetBounds( XOffset, Offset, Width, Height );
      Offset := Offset + Height;
    end;
  end;
end; {= TRzToolbar.PositionControl =}


function TRzToolbar.CalculateRowHeight( Row: Integer): Integer;
begin
  Result := FRowHeight;
end;


procedure TRzToolbar.PositionControls;
var
  I, Row, Col, MaxWidth, MaxHeight, XOffset, YOffset: Integer;
  Control: TControl;

  procedure ResizeParent;
  var
    State: Integer;
  begin
    if ( Parent <> nil ) and not ( Parent is TControlBar ) then
    begin
      if IsZoomed( Parent.Handle ) then
        State := SIZE_MAXIMIZED
      else if IsIconic( Parent.Handle ) then
        State := SIZE_MINIMIZED
      else
        State := SIZE_RESTORED;

      PostMessage( Parent.Handle, wm_Size, State,
                   MakeLong( Parent.Width, Parent.Height ) );
    end;
  end;

begin
  if FOrientation = orHorizontal then
  begin
    XOffset := FMargin;
    MaxWidth := 0;
    Row := 1;
    FCalculatedRowHeight := CalculateRowHeight( Row );
    for I := 0 to FToolbarControls.Count - 1 do
    begin
      Control := FToolbarControls.Items[ I ].Control;
      if Control.Visible or ( csDesigning in ComponentState ) then
      begin
        if FWrapControls and ( I > 0 ) and
           ( XOffset + Control.Width > Width - FMargin ) then
        begin                                                  { Wrap to next line }
          if XOffset > MaxWidth then
            MaxWidth := XOffset;

          XOffset := FMargin;
          Inc( Row );
          FCalculatedRowHeight := CalculateRowHeight( Row );
        end;

        PositionControl( I, Row, XOffset );
      end;
    end; { for }

    if FAutoResize then
    begin
      if ( Align in [ alLeft, alRight ] ) and ( MaxWidth <> 0 ) then
      begin
        if Width <> MaxWidth + FMargin then
          Invalidate;
        Width := MaxWidth + FMargin;
        ResizeParent;
      end
      else if Align in [ alTop, alBottom ] then
      begin
        if Height <> Row * FRowHeight + 2 * FTopMargin then
          Invalidate;
        Height := Row * FRowHeight + 2 * FTopMargin;
        ResizeParent;
      end;
    end;
  end
  else { FOrientation = orVertical }
  begin
    YOffset := FMargin;
    MaxHeight := 0;
    Col := 1;
    FCalculatedRowHeight := CalculateRowHeight( Col );
    for I := 0 to FToolbarControls.Count - 1 do
    begin
      Control := FToolbarControls.Items[ I ].Control;
      if Control.Visible or ( csDesigning in ComponentState ) then
      begin
        if FWrapControls and ( I > 0 ) and
           ( YOffset + Control.Height > Height - FMargin ) then
        begin                                                  { Wrap to next line }
          if YOffset > MaxHeight then
            MaxHeight := YOffset;

          YOffset := FMargin;
          Inc( Col );
          FCalculatedRowHeight := CalculateRowHeight( Col );
        end;

        PositionControl( I, Col, YOffset );
      end;
    end; { for }

    if FAutoResize then
    begin
      if Align in [ alLeft, alRight ] then
      begin
        if Width <> Col * FRowHeight + 2 + FTopMargin then
          Invalidate;
        Width := Col * FRowHeight + 2 + FTopMargin;
        ResizeParent;
      end
      else if ( Align in [ alTop, alBottom ] ) and ( MaxHeight <> 0 ) then
      begin
        if Height <> MaxHeight + FMargin then
          Invalidate;
        Height := MaxHeight + FMargin;
        ResizeParent;
      end;
    end;

  end;
end; {= TRzToolbar.PositionControls =}



procedure TRzToolbar.BackgroundChangedHandler( Sender: TObject );
begin
  Invalidate;
end;


function TRzToolbar.GetAlign: TAlign;
begin
  Result := inherited Align;
end;


procedure TRzToolbar.SetAlign( Value: TAlign );
begin
  if FAutoStyle then
    AdjustStyle( Value );
  inherited Align := Value;

  if FAutoResize then
  begin
    if Value in [ alLeft, alRight ] then
      Width := 32
    else
      Height := 32;
  end;
end; {= TRzToolbar.SetAlign =}


procedure TRzToolbar.SetImages( Value: TCustomImageList );
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


procedure TRzToolbar.ImageListChange( Sender: TObject );
begin
  if Sender = Images then
    Update;         // Call Update instead of Invalidate to prevent flicker
end;


procedure TRzToolbar.SetButtonLayout( Value: TButtonLayout );
begin
  if FButtonLayout <> Value then
  begin
    FButtonLayout := Value;
    NotifyControls( cm_ToolbarButtonLayoutChanged );
    if not FUpdatingTextOptions then
      FTextOptions := ttoCustom;
  end;
end;


procedure TRzToolbar.SetButtonWidth( Value: Integer );
begin
  if FButtonWidth <> Value then
  begin
    FButtonWidth := Value;
    NotifyControls( cm_ToolbarButtonSizeChanged );
    if not FUpdatingTextOptions then
      FTextOptions := ttoCustom;
  end;
end;


procedure TRzToolbar.SetButtonHeight( Value: Integer );
begin
  if FButtonHeight <> Value then
  begin
    FButtonHeight := Value;
    NotifyControls( cm_ToolbarButtonSizeChanged );
    if not FUpdatingTextOptions then
      FTextOptions := ttoCustom;
  end;
end;


procedure TRzToolbar.SetShowButtonCaptions( Value: Boolean );
begin
  if FShowButtonCaptions <> Value then
  begin
    FShowButtonCaptions := Value;
    NotifyControls( cm_ToolbarShowCaptionChanged );
    if not FUpdatingTextOptions then
      FTextOptions := ttoCustom;
  end;
end;


procedure TRzToolbar.SetTextOptions( Value: TRzToolbarTextOptions );
var
  W, H: Integer;
  ShowCaptions: Boolean;
  Layout: TButtonLayout;
begin
  if FTextOptions <> Value then
  begin
    FUpdatingTextOptions := True;
    try
      FTextOptions := Value;

      case FTextOptions of
        ttoShowTextLabels:
        begin
          W := 60;
          H := 40;
          ShowCaptions := True;
          Layout := blGlyphTop;
        end;

        ttoSelectiveTextOnRight:
        begin
          W := 60;
          H := 25;
          ShowCaptions := True;
          Layout := blGlyphLeft;
        end;

        else // ttNoTextLabels
        begin
          W := 25;
          H := 25;
          ShowCaptions := False;
          Layout := blGlyphLeft;
        end;
      end;

      if FTextOptions <> ttoCustom then
      begin
        SetButtonLayout( Layout );
        UpdateButtonSize( W, H, ShowCaptions );

        if Orientation = orHorizontal then
          SetRowHeight( H )
        else
          SetRowHeight( W );
      end;
    finally
      FUpdatingTextOptions := False;
    end;
  end;
end; {= TRzToolbar.SetTextOptions =}


procedure TRzToolbar.SetCustomizeCaptions( Value: TRzCustomizeCaptions );
begin
  FCustomizeCaptions.Assign( Value );
end;


procedure TRzToolbar.SetRegIniFile( Value: TRzRegIniFile );
begin
  if FRegIniFile <> Value then
  begin
    FRegIniFile := Value;
    if Value <> nil then
      Value.FreeNotification( Self );
  end;
end;


procedure TRzToolbar.SetShowDivider( Value: Boolean );
begin
  if FShowDivider <> Value then
  begin
    FShowDivider := Value;
    if FShowDivider then
      FBorderOuter := fsGroove
    else
      FBorderOuter := fsNone;
    Invalidate;
  end;
end;


procedure TRzToolbar.CheckAutoResize( var Value: Boolean );
begin
  { We use ClassNameIs to avoid linking in the ComCtrls unit. }
  if Value and ( Parent <> nil ) then
  begin
    if Parent.ClassNameIs( 'TPageScroller' ) or
       Parent.ClassNameIs( 'TToolbar' ) then
    begin
      Value := False;
    end;
  end;
end;



procedure TRzToolbar.SetAutoResize( Value: Boolean );
begin
  CheckAutoResize( Value );
  if FAutoResize <> Value then
  begin
    FAutoResize := Value;
    PositionControls;
  end;
end;


procedure TRzToolbar.SetBackground( Value: TBitmap );
begin
  FBackground.Assign( Value );
end;


procedure TRzToolbar.UpdateButtonSize( NewWidth, NewHeight: Integer; ShowCaptions: Boolean );
var
  I: Integer;
  Btn: TRzToolbarButton;
begin
  ShowButtonCaptions := ShowCaptions;
  ButtonWidth := NewWidth; 
  ButtonHeight := NewHeight;

  for I := 0 to ControlCount - 1 do
  begin
    if Controls[ I ] is TRzToolbarButton then
    begin
      Btn := TRzToolbarButton( Controls[ I ] );
      Btn.Width := NewWidth;
      Btn.Height := NewHeight;
      Btn.ShowCaption := ShowCaptions;
      if ShowCaptions then
      begin
        if NewHeight <= 30 then
          Btn.Layout := blGlyphLeft
        else
          Btn.Layout := blGlyphTop;
      end
      else
        Btn.Layout := blGlyphLeft;
    end;
  end;
  if FOrientation = orHorizontal then
    RowHeight := NewHeight
  else
    RowHeight := NewWidth;
end;


procedure TRzToolbar.SetMargin( Value: Integer );
begin
  if FMargin <> Value then
  begin
    FMargin := Value;
    PositionControls;
  end;
end;

procedure TRzToolbar.SetTopMargin( Value: Integer );
begin
  if FTopMargin <> Value then
  begin
    FTopMargin := Value;
    PositionControls;
  end;
end;


procedure TRzToolbar.SetOrientation( Value: TOrientation );
var
  I: Integer;
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    for I := 0 to ControlCount - 1 do
    begin
      if Controls[ I ] is TRzSpacer then
        TRzSpacer( Controls[ I ] ).Orientation := FOrientation;
    end;
    PositionControls;
  end;
end;


procedure TRzToolbar.SetRowHeight( Value: Integer );
begin
  if FRowHeight <> Value then
  begin
    FRowHeight := Value;
    PositionControls;
  end;
end;


procedure TRzToolbar.SetWrapControls( Value: Boolean );
begin
  if FWrapControls <> Value then
  begin
    FWrapControls := Value;
    PositionControls;
  end;
end;

procedure TRzToolbar.SetBorderInner( Value: TFrameStyleEx );
begin
  if BorderInner <> Value then
  begin
    inherited;
    FAutoStyle := False;
  end;
end;

procedure TRzToolbar.SetBorderOuter( Value: TFrameStyleEx );
begin
  if BorderOuter <> Value then
  begin
    inherited;
    FAutoStyle := False;
  end;
end;

procedure TRzToolbar.SetBorderSides( Value: TSides );
begin
  if BorderSides <> Value then
  begin
    inherited;
    FAutoStyle := False;
  end;
end;


procedure TRzToolbar.SetBiDiMode( Value: TBiDiMode );
begin
  if BiDiMode <> Value then
  begin
    inherited;
    PositionControls;
  end;
end;


procedure TRzToolbar.DrawCaption( Rect: TRect );
begin
  { Do not draw caption for a toolbar }
end;

procedure TRzToolbar.Paint;
var
  Col, Row, X, Y, XTiles, YTiles: Integer;
  R: TRect;
  ElementDetails: TThemedElementDetails;
begin
  if FThemeAware and ThemeServices.ThemesEnabled then
  begin
    ElementDetails := ThemeServices.GetElementDetails( trRebarRoot );
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, ClientRect );
  end
  else
  begin
    inherited;

    { Tile the background, if there is one }
    if ( FBackground.Width > 0 ) and ( FBackground.Height > 0 ) then
    begin
      R := ClientRect;
      FixClientRect( R, True );

      XTiles := ClientWidth div FBackground.Width;
      if ClientWidth mod FBackground.Width > 0 then
        Inc( XTiles );
      YTiles := ClientHeight div FBackground.Height;
      if ClientHeight mod FBackground.Height > 0 then
        Inc( YTiles );

      IntersectClipRect( Canvas.Handle, R.Left, R.Top, R.Right, R.Bottom );

      for Row := 0 to Pred( YTiles ) do
      begin
        Y := R.Top + Row * FBackground.Height;
        for Col := 0 to Pred( XTiles ) do
        begin
          X := R.Left + Col * FBackground.Width;
          Canvas.Draw( X, Y, FBackground );
        end;
      end;
    end;
  end;
end; {= TRzToolbar.Paint =}


procedure TRzToolbar.VisibleChanged;
begin
  if Assigned( FOnVisibleChanged ) then
    FOnVisibleChanged( Self );
end;

procedure TRzToolbar.CMVisibleChanged( var Msg: TMessage );
begin
  inherited;
  VisibleChanged;
end;


procedure TRzToolbar.Customize( ShowTextOptions: Boolean = True );
var
  F: TRzFrmCustomizeToolbar;
begin
  F := TRzFrmCustomizeToolbar.Create( Application );
  try
    F.CompOwner := Owner;
    F.Toolbar := Self;
    F.Reposition;
    F.UpdateControls( FCustomizeCaptions, ShowTextOptions );
    F.ShowModal;
  finally
    F.Free;
  end;
end;


procedure TRzToolbar.RestoreLayout;
var
  I, Count, OldIdx, Options: Integer;
  CN: string;
  MakeVisible: Boolean;
begin
  if FRegIniFile = nil then
    raise ENoRegIniFile.Create( sRzNoRegIniFile );

  Count := FRegIniFile.ReadInteger( Name, 'Count', 0 );
  if ( Count > 0 ) and ( Count = ToolbarControls.Count ) then
  begin
    for I := 0 to Count - 1 do
    begin
      MakeVisible := True;
      CN := FRegIniFile.ReadString( Name, 'Control' + IntToStr( I ), '' );
      if CN <> '' then
      begin
        if Pos( '##', CN ) = 1 then
        begin
          MakeVisible := False;
          Delete( CN, 1, 2 );
        end;
        OldIdx := ToolbarControls.IndexOfName( CN );
        ToolbarControls.Move( OldIdx, I );
        ToolbarControls[ I ].Control.Visible := MakeVisible;
      end;
    end;
    PositionControls;
  end;

  Options := FRegIniFile.ReadInteger( Name, 'TextOptions', -1 );
  if Options <> -1 then
    SetTextOptions( TRzToolbarTextOptions( Options ) );
end;


procedure TRzToolbar.SaveLayout;
var
  I: Integer;
  C: TControl;
begin
  if FRegIniFile = nil then
    raise ENoRegIniFile.Create( sRzNoRegIniFile );

  // Assume that all Controls have a valid Name

  FRegIniFile.WriteInteger( Name, 'TextOptions', Ord( FTextOptions ) );
  FRegIniFile.WriteInteger( Name, 'Count', FToolbarControls.Count );

  for I := 0 to FToolbarControls.Count - 1 do
  begin
    C := FToolbarControls.Items[ I ].Control;
    if C.Visible then
      FRegIniFile.WriteString( Name, 'Control' + IntToStr( I ), C.Name )
    else
      FRegIniFile.WriteString( Name, 'Control' + IntToStr( I ), '##' + C.Name );
  end;
end;


{==========================}
{== TRzStatusBar Methods ==}
{==========================}

constructor TRzStatusBar.Create( AOwner: TComponent );
begin
  inherited;

  FSizeGripCanvas := TControlCanvas.Create;
  TControlCanvas( FSizeGripCanvas ).Control := Self;

  Align := alBottom;
  FAutoStyle := True;
  AdjustStyle;

  FShowSizeGrip := True;
  FSimpleStatus := False;
  FSimpleFrameStyle := fsFlat;
  FSimpleCaption := '';
  FFirst := True;
  {&RCI}
end;


destructor TRzStatusBar.Destroy;
begin
  FSizeGripCanvas.Free;
  inherited;
end;


procedure TRzStatusBar.CreateWnd;
begin
  ValidateSizeGrip;
  inherited;
end;


procedure TRzStatusBar.Loaded;
begin
  inherited;
  if FAutoStyle then
    AdjustStyle;
  {&RV}
end;


procedure TRzStatusBar.WndProc( var Msg: TMessage );
const
  sc_DragSize = 61448;
var
  X, Y: Integer;
begin
  if FSizeGripValid and ( Msg.Msg = wm_LButtonDown ) then
  begin
    X := Msg.LParamLo;
    Y := Msg.LParamHi;
    if FShowSizeGrip and PtInRect( SizeGripRect, Point( X, Y ) ) then
    begin
      ReleaseCapture;
      GetParentForm( Self ).Perform( wm_SysCommand, sc_DragSize, 0 );
      Exit;
    end;
  end;

  inherited;
end;


procedure TRzStatusBar.SetShowSizeGrip( Value: Boolean );
begin
  if FShowSizeGrip <> Value then
  begin
    FShowSizeGrip := Value;
    ValidateSizeGrip;
    Invalidate;
  end;
end;

function TRzStatusBar.SizeGripRect: TRect;
begin
  Result := Rect( Width - 13, 0, Width, Height );
end;


procedure TRzStatusBar.ValidateSizeGrip;
var
  F: TCustomForm;
begin
  F := GetParentForm( Self );
  FSizeGripValid := ( F <> nil ) and ( F.BorderStyle in [ bsSizeable, bsSizeToolWin ] ) and
                    ( F.WindowState <> wsMaximized );
end;


procedure TRzStatusBar.WMSetCursor( var Msg: TWMSetCursor );
begin
  if FShowSizeGrip and FSizeGripValid and PtInRect( SizeGripRect, CursorPosition ) then
    SetCursor( Screen.Cursors[ crSizeNWSE ] )
  else
    inherited;
end;


procedure TRzStatusBar.Resize;
var
  I, Offset: Integer;
  Percent: Single;
begin
  inherited;

  if FFirst then
  begin
    FDelta := 0;
    FLastWidth := Width;
    FFirst := False;
  end
  else
  begin
    FDelta := Width - FLastWidth;
  end;

  { Adjust Size of all Status Panes }
  if FAutoScalePanes and ( ControlCount > 0 ) and ( Abs( FDelta ) > 0 ) then
  begin
    DisableAlign;
    try
      for I := 0 to ControlCount - 1 do
      begin
        Percent := Controls[ I ].Width / FLastWidth;
        Offset := Round( FDelta * Percent );
        Controls[ I ].Width := Controls[ I ].Width + Offset;
      end;
    finally
      EnableAlign;
    end;
  end;
  FLastWidth := Width;
end;


function TRzStatusBar.GetClientRect: TRect;
begin
  Result := inherited GetClientRect;

  if ThemeServices.ThemesAvailable then
  begin
    if FSimpleStatus then
    begin
      Inc( Result.Left );
      Inc( Result.Top );
      Dec( Result.Right );
    end;
  end
  else
  begin
    Inc( Result.Bottom, 1 );  // Removes bottom border of status panes in Win95
    if not FSimpleStatus then
    begin
      Result.Top := 1;
      Dec( Result.Left );
      Inc( Result.Right );
    end
    else
      Result.Top := 2;
  end;

  (*
  Inc( Result.Bottom, 1 );  // Removes bottom border of status panes in Win95
  if not FSimpleStatus then
  begin
    Result.Top := 1;
    Dec( Result.Left );
    Inc( Result.Right );
  end
  else
    Result.Top := 2;
  *)
end;


procedure TRzStatusBar.SetSimpleCaption( Value: TCaption );
begin
  if FSimpleCaption <> Value then
  begin
    FSimpleCaption := Value;
    Invalidate;
  end;
end;


procedure TRzStatusBar.SetSimpleFrameStyle( Value: TFrameStyle );
begin
  if FSimpleFrameStyle <> Value then
  begin
    FSimpleFrameStyle := Value;
    Invalidate;
  end;
end;


procedure TRzStatusBar.SetSimpleStatus( Value: Boolean );
var
  I: Integer;
begin
  if FSimpleStatus <> Value then
  begin
    FSimpleStatus := Value;

    DisableAlign;
    try
      for I := 0 to ControlCount - 1 do
      begin
        { Add csNoDesignVisible so TWinControls do not appear at design time }
        if csDesigning in ComponentState then
          Controls[ I ].ControlStyle := Controls[ I ].ControlStyle + [ csNoDesignVisible ];
        Controls[ I ].Visible := not FSimpleStatus;
      end;
    finally
      EnableAlign;
    end;
    Invalidate;
  end;
end;


procedure TRzStatusBar.AdjustStyle;
var
  OldAutoStyle: Boolean;
begin
  OldAutoStyle := FAutoStyle;
  try
    BorderInner := fsNone;
    BorderOuter := fsNone;
    BorderSides := sdAllSides;
    Height := 19;
    BorderWidth := 0;
  finally
    FAutoStyle := OldAutoStyle;
  end;
end;


procedure TRzStatusBar.PaintSizeGrip( R: TRect );
var
  X, Y: Integer;
  ElementDetails: TThemedElementDetails;
begin
  if FThemeAware and ThemeServices.ThemesEnabled then
  begin
    ElementDetails := ThemeServices.GetElementDetails( tsGripper );
    R.Left := R.Right - 20;
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );
  end
  else
  begin
    FSizeGripCanvas.Brush.Color := clBtnHighlight;
    FSizeGripCanvas.Pen.Color := clBtnHighlight;
    X := R.Right - 1;
    Y := R.Bottom - 0;
    FSizeGripCanvas.Rectangle( X - 4,  Y - 12, X - 2,  Y - 10 );
    FSizeGripCanvas.Rectangle( X - 4,  Y - 8,  X - 2,  Y - 6 );
    FSizeGripCanvas.Rectangle( X - 4,  Y - 4,  X - 2,  Y - 2 );
    FSizeGripCanvas.Rectangle( X - 8,  Y - 8,  X - 6,  Y - 6 );
    FSizeGripCanvas.Rectangle( X - 8,  Y - 4,  X - 6,  Y - 2 );
    FSizeGripCanvas.Rectangle( X - 12, Y - 4,  X - 10, Y - 2 );

    FSizeGripCanvas.Brush.Color := clBtnShadow;
    FSizeGripCanvas.Pen.Color := clBtnShadow;
    X := R.Right - 2;
    Y := R.Bottom - 1;
    FSizeGripCanvas.Rectangle( X - 4,  Y - 12, X - 2,  Y - 10 );
    FSizeGripCanvas.Rectangle( X - 4,  Y - 8,  X - 2,  Y - 6 );
    FSizeGripCanvas.Rectangle( X - 4,  Y - 4,  X - 2,  Y - 2 );
    FSizeGripCanvas.Rectangle( X - 8,  Y - 8,  X - 6,  Y - 6 );
    FSizeGripCanvas.Rectangle( X - 8,  Y - 4,  X - 6,  Y - 2 );
    FSizeGripCanvas.Rectangle( X - 12, Y - 4,  X - 10, Y - 2 );
  end;
end;


procedure TRzStatusBar.DrawSimpleStatusBorder( R: TRect );
var
  C: TColor;
  ElementDetails: TThemedElementDetails;
begin
  if FThemeAware and ThemeServices.ThemesEnabled then
  begin
    ElementDetails := ThemeServices.GetElementDetails( tsPane );
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );
  end
  else
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect( R );

    Canvas.Pen.Width := 1;
//    InflateRect( R, -BorderWidth, -BorderWidth );

    if FSimpleFrameStyle = fsFlat then
    begin
      C := AdjustColor( FFlatColor, FFlatColorAdjustment );
      Canvas.Pen.Color := C;
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
    end
    else
      DrawBorder( Canvas, R, FSimpleFrameStyle );
  end;
end; {= TRzStatusBar.DrawSimpleStatusBorder =}


procedure TRzStatusBar.Paint;
var
  X, Y: Integer;
  R: TRect;
  ElementDetails: TThemedElementDetails;
begin
  if FThemeAware and ThemeServices.ThemesEnabled then
  begin
    ElementDetails := ThemeServices.GetElementDetails( tsStatusRoot );
    R := Rect( 0, 0, Width, Height );
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );

    if FSimpleStatus then
    begin
      if FSimpleCaption <> '' then
        ThemeServices.DrawText( Canvas.Handle, ElementDetails, WideString( FSimpleCaption ), ClientRect,
                                dt_SingleLine or dt_VCenter, 0 );
    end;

  end
  else
  begin
    inherited;

    R := ClientRect;
    Dec( R.Bottom );

    if FSimpleStatus then
    begin
      DrawSimpleStatusBorder( R );

      InflateRect( R, -1, -1 );
      if FSimpleCaption <> '' then
      begin
        Canvas.Font := Font;
        with Canvas do
        begin
          { Set brush color so that old text in caption area gets erased }
          Brush.Color := Color;

          X := R.Left + 2;
          Y := R.Top + ( R.Bottom - R.Top - Canvas.TextHeight( 'Pp' ) ) div 2;

          TextRect( R, X, Y, FSimpleCaption );
        end; { with }
      end;
    end;
  end;
end;


procedure TRzStatusBar.WMPaint( var Msg: TWMPaint );
var
  R: TRect;
begin
  inherited;

  R := ClientRect;
  Dec( R.Bottom );

  ValidateSizeGrip;
  if FShowSizeGrip and FSizeGripValid then
    PaintSizeGrip( R );
end;


procedure TRzStatusBar.SetBorderInner( Value: TFrameStyleEx );
begin
  if BorderInner <> Value then
  begin
    inherited;
    FAutoStyle := False;
  end;
end;

procedure TRzStatusBar.SetBorderOuter( Value: TFrameStyleEx );
begin
  if BorderOuter <> Value then
  begin
    inherited;
    FAutoStyle := False;
  end;
end;

procedure TRzStatusBar.SetBorderSides( Value: TSides );
begin
  if BorderSides <> Value then
  begin
    inherited;
    FAutoStyle := False;
  end;
end;


{&RUIF}
end.
