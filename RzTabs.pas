{===============================================================================
  RzTabs Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzPageControl        Custom version of a page control (including tab sheets).
  TRzTabControl         Custom version of a tab control


  Modification History
  ------------------------------------------------------------------------------
  3.0.10 (26 Dec 2003)
    * Fixed problem where divider line for tabs was not appearing if
      ShowCardFrame was True, but ShowFullFrame was False, and the tabs were
      positioned on a side other than top.
    * Added MakeControlVisible method to TRzPageControl. This method will switch
      to the tab sheet that contains the specified control.
    * Re-fixed problem where a TRzPageControl would automatically move to a new
      position on the (Delphi 5) form designer when clicking on the Object
      Inspector or Component Palette.
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Fixed problem where making TabHeight or TabWidth > 0 would cause the tabs
      to disappear if the page control less than a certain size.
    * Fixed problem where if ActivePage and ActivePageDefault were different
      pages, then upon loading, both pages would be considered visible by the
      page control.
    * Fixed problem where all tabs would be re-colored to active page color when
      MultiLine = True.
    * Fixed problem where clicking on secondary rows of tabs (MultiLine = True)
      would not bring the clicked tab to the front at design-time.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Initialized FShowFocusRect in constructor.
    * Modified GetScrollerSize and GetCloseButtonSize to take into account
      FixedDimension when calculating the size of the buttons.
    * Added AllowTabDragging property.  When set to True, the tabs can be
      reordered by dragging them with the mouse.
    * Fixed problem where OnChange event was being fired when the control was
      first loaded.
    * Clearing a TRzTabControl's Tabs collection now immediately sets the
      TabIndex to -1.
    * TRzPageControl can now be a dock site and as new clients are docked to the
      page control, new tab sheets are created to hold the dock clients.
    * Made Change event dispatch method public.
    * Fixed problem where deleting a tab in a TRzTabControl that is not active
      would raise an index out of range exception.
    * Fixed problem where setting Form.ActiveControl to some control contained
      on a TRzTabSheet in a TRzPageControl would not focus that control when the
      form was loaded.
    * Fixed problem where focus rectangle would clip vertically oriented text.
  ------------------------------------------------------------------------------
  3.0.6  (11 Apr 2003)
    * Fixed problem where Index Out Of Range error would occur if all pages were
      removed from a TRzPageControl while inside a LockWindowUpdate call.
    * Fixed problem where Close button would be visible if TabHeight was
      something other than zero.
    * Fixed problem where ActivePageIndex property would cause an access
      violation if no page was currently active.
    * Fixed problem where TRzPageControl would move at design-time if user
      clicked on a new tab and then clicked on another designer form such as the
      Object Inspector.
    * Added Tag and Data properties to TRzTabCollectionItem.
    * Added Data property to TRzTabSheet.
    * Adjusted position of tab scroller buttons and close button (if visible)
      such that they take into account the Margin property value.
    * Fixed problem where scroller button enabled states were incorrect when
      orientation was toRight.
    * Added ShowFullFrame property to TRzPageControl. When this property is set
      to False, only the portion of the frame that is adjacent to the tabs is
      drawn.
    * Added OnResize event to TRzTabSheet.
    * Fixed problem where Anchors were not being honored for controls that
      appeared on non-active tabs in a TRzPageControl -and- the page control was
      resized before switching to the other tabs.
    * Fixed problem where programmatically changing ActivePage or TabIndex did
      not update enabled states of scroller buttons.
  ------------------------------------------------------------------------------
  3.0.5  (24 Mar 2003)
    * Further enhanced performance of controls when HotTracking was set to True.
    * Added ShowCloseButton property to TRzPageControl and TRzTabControl.
    * Added OnClose event to TRzPageControl and TRzTabControl.
    * Added CloseActiveTab method. This method is called when the Close button
      is clicked and generates the OnClose event and takes care of
      destroying/deleting the active tab.
    * Added GetDisplayName override to TRzTabCollectionItem.
    * Fixed display states of the scrolling buttons.
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * Fixed problem where tabs extended past edge of card if ShowShadow was
      True.
    * Fixed problem where Ctrl+Tab caused blank page to appear (i.e. page
      control itself) if no tabs are visible.
    * Fixed performance problem that occurred when hot tracking and ShowShadow
      set to True.
    * Fixed problem where FixedDimension was not getting initialized correctly.
      This caused a problem when using Anchors for windowed controls inside the
      TRzPageControl--3.0.3 addressed graphic controls. For 3.0.4, the
      FixedDimension value needed to be stored to the stream in a
      DefineProperties override.
    * Added ShowFocusRect property.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Test FullColorSupport before all calls to PaintGradient.
    * Added gradient support to Color tabs.
    * Updated Scroller buttons to be displayed when first and/or last tab is
      visible.
    * Fixed problem where FixedDimension was not getting initialized correctly.
      This caused a problem when using Anchors for graphic controls inside the
      TRzPageControl.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)  * Initial release.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzTabs;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  SysUtils,
  Windows,
  Messages,
  Classes,
  Controls,
  Graphics,
  StdCtrls,
  Forms,
  ImgList,
  RzCommon,
  RzGrafx;

const
  MaxTabRegionPts = 20;                     // Maximum no. of points for defining tab shape

  // Define 'optimum' no. of tab regions kept in cache; cannot be 0.
  OptimumTabRegionCacheSize = 1;


type
  TRzCustomTabControl = class;

  TRzTabScrollerBtn = ( sbDownLeft, sbUpRight );

  TRzTabScroller = class( TCustomControl )
  private
    FFrameColor: TColor;
    FOrientation: TOrientation;
    FTabControl: TRzCustomTabControl;

    FPressed: Boolean;
    FDown: Boolean;
    FCurrent: TRzTabScrollerBtn;

    FOnUpRightClick: TNotifyEvent;
    FOnDownLeftClick: TNotifyEvent;
    procedure CMDesignHitTest( var Msg: TCMDesignHitTest ); message cm_DesignHitTest;
  protected
    procedure Paint; override;

    { Event Dispatch Methods }
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseMove( Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;

    procedure DownLeftClick; dynamic;
    procedure UpRightClick; dynamic;

    { Property Access Methods }
    procedure SetFrameColor( Value: TColor ); virtual;
    procedure SetOrientation( Value: TOrientation ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property FrameColor: TColor
      read FFrameColor
      write SetFrameColor
      default clBtnShadow;

    property Orientation: TOrientation
      read FOrientation
      write SetOrientation
      stored False;

    property OnUpRightClick: TNotifyEvent
      read FOnUpRightClick
      write FOnUpRightClick;

    property OnDownLeftClick: TNotifyEvent
      read FOnDownLeftClick
      write FOnDownLeftClick;
  end;


  TRzTabCloseButton = class( TCustomControl )
  private
    FFrameColor: TColor;
    FTabControl: TRzCustomTabControl;

    FPressed: Boolean;
    FDown: Boolean;

    FOnClose: TNotifyEvent;
  protected
    procedure Paint; override;

    { Event Dispatch Methods }
    procedure DoClose; dynamic;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseMove( Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;

    { Property Access Methods }
    procedure SetFrameColor( Value: TColor ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property FrameColor: TColor
      read FFrameColor
      write SetFrameColor
      default clBtnShadow;

    property OnClose: TNotifyEvent
      read FOnClose
      write FOnClose;
  end;


  TRzTabStyle = ( tsSingleSlant, tsDoubleSlant, tsCutCorner, tsRoundCorners );
  TRzTabSequence = ( tsStandard, tsReverse );
  TRzTabOrientation = ( toTop, toLeft, toBottom, toRight );

  // Image position is relative to the tab's caption,
  // i.e. ipLeft indicates the image is displayed to the left of the caption.
  // ipStretch will cause the image to be stretched to fit the entire
  // _usable area_ of the tab face.  ipBack places the image 'behind' the text.

  TRzImagePosition = ( ipLeft, ipTop, ipRight, ipBottom, ipBack, ipStretch );
  TRzHorizontalAlignment = ( haLeft, haCenter, haRight );
  TRzVerticalAlignment = ( vaTop, vaCenter, vaBottom );

  // Theoretically, the tsHotTrack style should not be mutually exclusive to
  // tsSelected or tsUnselected, but changing TRzTextStyle to a set to allow
  // multiple values (e.g. [tsHotTrack, tsSelected]) would break existing user's
  // code.  The user will have to add their own code to determine if the tab
  // being drawn is selected or not.

  TRzTextStyle = ( tsHotTrack, tsSelected, tsUnselected, tsDisabledHighlight, tsDisabledShadow );
  TRzHotTrackStyle = ( htsTab, htsText );

  TRzTabRegionPts = array[ 0..MaxTabRegionPts - 1 ] of TPoint;

  TRzTabData = class;
  TRzTabDataList = class;

  // TRzTabRegionCache implements a MRU (most recently used) cache of recently
  // created tab regions.  The first item in the cache is the MRU tab region.
  // Because a region (and not just a rect) must be used for hit-testing when
  // the mouse is moved over a tab it is too slow to dynamically create the
  // tab's region each time the mouse is moved.  Conversely, creating
  // and keeping the regions for all tabs would use too much of GDI resources
  // (about 5% for 10 tabs in Delphi 1).  The default cache capacity of 1 (one)
  // minimises GDI resource usage while at the same time having acceptable
  // speed -- while the mouse is moved over a tab the cached region is the only
  // one needed (and thus immediately available) until the mouse crosses over to
  // another tab.

  TRzTabRegionCache = class( TObject )
  private
    FCache: TList;
    FCapacity: Integer;
    function GetCount: Integer;
    procedure SetCapacity( Value: Integer );
  public
    constructor Create;
    destructor Destroy; override;
    // Add adds a Rect -> Region association to the cache, as the new
    // first entry, if there is no region for Rect already present.

    procedure Add( ARect: TRect; ARegion: hRgn ); // to front of cache
    procedure Clear;                        // entire cache
    function Find( ARect: TRect ): hRgn;

    // Capacity determines how many tab regions will be cached.
    // Capacity can be:
    //  -1 to cache all tab regions (maximum GDI resource usage, maximum speed),
    //  +n, where n > 0, to cache up to n tab regions (compromise).

    property Capacity: Integer
      read FCapacity
      write SetCapacity
      default OptimumTabRegionCacheSize;

    property Count: Integer
      read GetCount;
  end;


  // TRzTextExtentCache implements a cache of the text extents for strings.
  // If the font on which the stored text extents are based is changed then
  // it is up to the caller to clear the cache.
  // It is assumed that the cache only contains extents for the same font style,
  // e.g. all Normal or all Bold but not a mixture.

  TRzTextExtentCache = class
  private
    FCache: TStringList;
  public
    constructor Create;
    destructor Destroy; override;

    // Add adds a String->Extent association to the cache.
    procedure Add( const AString: string; Extent: TSize );
    procedure Clear;                        // entire cache
    function Find( const AString: string; var Extent: TSize ): Boolean;
  end;

  // A TabCloseEvent event is generated when the CloseButton is clicked.

  TRzTabCloseEvent = procedure( Sender: TObject; var AllowClose: Boolean ) of object;

  // A TabChangingEvent event is generated prior to selecting a different tab.

  TRzTabChangingEvent = procedure( Sender: TObject; NewIndex: Integer; var AllowChange: Boolean ) of object;


  // A PaintBackgroundEvent occurs when the background of the tab control is being textured/filled.

  TRzPaintBackgroundEvent = procedure( Sender: TObject; ACanvas: TCanvas; const ARect: TRect;
                                       var Handled: Boolean ) of object;

  // A PaintTabBackgroundEvent occurs when the background of each tab is being erased/painted.

  TRzPaintTabBackgroundEvent = procedure( Sender: TObject; ACanvas: TCanvas; ATabIndex: Integer; const ARect: TRect;
                                          var Handled: Boolean ) of object;

  // A PaintCardBackgroundEvent occurs when the background of each card is being
  // erased/painted.  The front (current) card is in Row 0.

  TRzPaintCardBackgroundEvent = procedure( Sender: TObject; ACanvas: TCanvas; ARow: Integer; const ARect: TRect;
                                           var Handled: Boolean ) of object;

  // A GetTextColorEvent occurs when the text of a tab is being drawn.

  TRzGetTextColorEvent = procedure( Sender: TObject; ATabIndex: Integer; AStyle: TRzTextStyle;
                                    var AColor: TColor; var Handled: Boolean ) of object;


  TRzTabColors = class( TPersistent )
  private
    FTabControl: TRzCustomTabControl;

    FHighlightBar: TColor;
    FShadow: TColor;
    FUnselected: TColor;
  protected
    procedure SetHighlightBar( Value: TColor ); virtual;
    procedure SetShadow( Value: TColor ); virtual;
    procedure SetUnselected( Value: TColor ); virtual;
  public
    constructor Create( TabControl: TRzCustomTabControl );
  published
    property HighlightBar: TColor
      read FHighlightBar
      write SetHighlightBar
      default clHighlight;

    property Shadow: TColor
      read FShadow
      write SetShadow
      default clBtnFace;

    property Unselected: TColor
      read FUnselected
      write SetUnselected
      default clWindow;
  end;


  TRzTextColors = class( TPersistent )
  private
    FTabControl: TRzCustomTabControl;

    FDisabledHighlight: TColor;
    FDisabledShadow: TColor;
    FSelected: TColor;
    FUnselected: TColor;
  protected
    procedure SetDisabledHighlight( Value: TColor ); virtual;
    procedure SetDisabledShadow( Value: TColor ); virtual;
    procedure SetSelected( Value: TColor ); virtual;
    procedure SetUnselected( Value: TColor ); virtual;
  public
    constructor Create( TabControl: TRzCustomTabControl );
  published
    property DisabledHighlight: TColor
      read FDisabledHighlight
      write SetDisabledHighlight
      default clBtnHighlight;

    property DisabledShadow: TColor
      read FDisabledShadow
      write SetDisabledShadow
      default clBtnShadow;

    property Selected: TColor
      read FSelected
      write SetSelected
      default clBtnText;

    property Unselected: TColor
      read FUnselected
      write SetUnselected
      default clBtnText;
  end;



  TRzCustomTabControl = class( TCustomControl )
  private
    FBuffer: TBitmap;
    FCalcNeeded: Boolean;
    FCalcTextExtentLines: TStringList;      // used by CalcTextExtent
    FChangingDone: Boolean;                 // flag to indicate OnChanging already generated
    FCommands: TList;
    FDoneTabIndexDefault: Boolean;          // indicates if default tab index has been set
    FDrawTabTextLines: TStringList;         // used by DrawTabText
    FFirstInView: Integer;
    FFixedDimension: Integer;
    FFocusRectBrushColor: TColor;
    FHFonts: TList;                         // Stack of font handles selected into buffer's canvas
    FHitTest: TPoint;
    FHotTrackIndex: Integer;
    FOriginalHint: string;                  // original Hint for the control
    FPrevDisplayRect: TRect;                // DisplayRect used for previous AlignControls
    FRowExtent: Integer;

    FScroller: TRzTabScroller;
    FScrollerNeeded: Boolean;
    FTabDataList: TRzTabDataList;           // internal tab data
    FTabRegionCache: TRzTabRegionCache;
    FTabRegionCacheSize: Integer;

    FCloseButton: TRzTabCloseButton;
    FShowCloseButton: Boolean;

    // FTextFont contains the same font as Self.Font and is used instead of
    // Self.Font so that changes to the font style (of FTextFont) don't cause
    // further (infinite) CMFontChanged events to self.

    FTextFont: TFont;
    FTimerHandle: THandle;

    { Property Storage Fields }
    FAlignTabs: Boolean;
    FBackgroundColor: TColor;
    FBoldCurrentTab: Boolean;
    FShowCard: Boolean;
    FShowCardFrame: Boolean;
    FShowFullFrame: Boolean;
    FUseColoredTabs: Boolean;
    FCutCornerSize: Integer;
    FFlatColor: TColor;
    FFlatColorAdjustment: Integer;
    FImagePosition: TRzImagePosition;
    FImageAlignment: TRzHorizontalAlignment;
    FImageMargin: Integer;
    FImageAlignmentVertical: TRzVerticalAlignment;

    FHotTrackColor: TColor;
    FHotTrackColorType: TRzHotTrackColorType;
    FHotTrack: Boolean;
    FHotTrackStyle: TRzHotTrackStyle;
    FHotTracking: Boolean;

    FImages: TCustomImageList;
    FImagesChangeLink: TChangeLink;
    FMargin: Integer;
    FMultiLine: Boolean;
    FParentBackgroundColor: Boolean;
    FRowIndent: Integer;
    FRowOverlap: Integer;                   // Amount each row of tabs overlaps the previous row
    FScrollBtnArrowColor: TColor;
    FScrollBtnFaceColor: TColor;
    FTextOrientation: TOrientation;
    FTabHeight: Integer;
    FTabHints: Boolean;
    FTabIndex: Integer;
    FTabIndexDefault: Integer;
    FTabOrientation: TRzTabOrientation;
    FTabSequence: TRzTabSequence;
    FTabStyle: TRzTabStyle;
    FTabWidth: Integer;

    FTabColors: TRzTabColors;
    FTextColors: TRzTextColors;

    FTextAlignment: TRzHorizontalAlignment;
    FTextAlignmentVertical: TRzVerticalAlignment;
    FShowShadow: Boolean;
    FUseGradients: Boolean;
    FTransparent: Boolean;
    FShowFocusRect: Boolean;

    FAllowTabDragging: Boolean;
    FLastDragOverRect: TRect;
    FLastMoveTabIndex: Integer;
    FMoveTabIndicatorVisible: Boolean;

    FOnChange: TNotifyEvent;
    FOnChanging: TRzTabChangingEvent;
    FOnClose: TRzTabCloseEvent;
    FOnGetTextColor: TRzGetTextColorEvent;
    FOnPaintBackground: TRzPaintBackgroundEvent;
    FOnPaintCardBackground: TRzPaintCardBackgroundEvent;
    FOnPaintTabBackground: TRzPaintTabBackgroundEvent;
    FOnTabClick: TNotifyEvent;

    {$IFNDEF VCL60_OR_HIGHER}
    FDesignTimeTabChange: Boolean;
    {$ENDIF}

    procedure AddCommand( const Command: Integer );
    procedure AddCommandPt( const Command: Integer; const APoint: TPoint );
    procedure AlignScroller;
    procedure AlignCloseButton;
    procedure BringTabToFrontRow( TabData: TRzTabData );

    procedure CalcCardDrawCommands( ARow: Integer );
    function CalcDefaultTabFaceExtent( AFont: TFont ): TSize;
    function CalcImageExtent( AImageIndex: TImageIndex ): TSize;
    function CalcMappedCardRect( ARow: Integer ): TRect;
    function CalcMappedTabRect( ATabIndex: Integer; TabData: TRzTabData ): TRect;
    procedure CalcMappedTabRegionPts( ATabIndex: Integer; var Pts: TRzTabRegionPts; var NumPts: Integer );
    function CalcMapPoint( const RawPt: TPoint ): TPoint;
    function CalcMapRect( const RawRect: TRect ): TRect;
    procedure CalcMetrics;
    procedure CalcScrollerNeeded;
    function CalcTabExtentFromTabFaceExtent( TabFaceExtent: TSize ): TSize;
    function CalcTabFaceRect( ARect: TRect ): TRect;
    function CalcTabRegion( ATabIndex: Integer; const ARect: TRect ): hRgn;
    procedure CalcTabRegionPts( ATabIndex: Integer; var Pts: TRzTabRegionPts; var NumPts: Integer );
    function CalcTextExtent( const S: string; Horizontal: Boolean ): TSize;
    procedure CalcTabDrawCommands( ATabIndex: Integer );
    function CalcTabRect( ATabIndex: Integer; TabData: TRzTabData ): TRect;
    function CalcWholeRect: TRect;

    procedure CancelHotTrackTimer;
    function CanSelectTab( ATabIndex: Integer ): Boolean;
    procedure CheckCalcNeeded;
    procedure CreateScroller;
    procedure CreateCloseButton;
    procedure DeselectFont;
    procedure DoRealign;

    procedure DoTextOut( X, Y: Integer; const AString: string; ACanvas: TCanvas;
                         Horizontal: Boolean; AColor: TColor );

    procedure ProcessCommands;
    procedure DrawTabBackground( ATabIndex: Integer; const ARect: TRect );
    procedure DrawTabFace( ATabIndex: Integer; const ARect: TRect );
    procedure DrawTabs;

    function GetDisplayRect: TRect;
    function GetExtraTopMargin: Integer;
    function GetFirstVisible: Integer;
    function GetIndexHeight: Integer;
    function GetIndexRect: TRect;
    function GetIndexWidth: Integer;
    function GetInitialTabOffset: Integer;
    function GetLastVisible: Integer;
    function GetScrollerSize: Integer;
    function GetCloseButtonSize: Integer;
    function GetTabOffset( ATabHeight: Integer ): Integer;

    function IsBackgroundColorStored: Boolean;
    procedure ParseTextLines( const S: string; Lines: TStrings );
    function PopHFont: HFont;
    procedure PushHFont( Value: HFont );

    procedure ScrollTabs( Next: Boolean );

    procedure SelectFont;
    procedure StopHotTracking;
    function TabInView( TabData: TRzTabData ): Boolean;

    procedure ReadFixedDimension( Reader: TReader );
    procedure WriteFixedDimension( Writer: TWriter );

    { Internal Event Handlers }
    procedure ImageListChange( Sender: TObject );
    procedure ScrollUpRightClickHandler( Sender: TObject );
    procedure ScrollDownLeftClickHandler( Sender: TObject );
    procedure CloseButtonClickHandler( Sender: TObject );

    { Message Handling Methods }
    procedure CMColorChanged( var Msg: TMessage ); message CM_COLORCHANGED;
    procedure CMDesignHitTest( var Msg: TCMDesignHitTest ); message CM_DESIGNHITTEST;
    procedure CMDialogChar( var Msg: TCMDialogChar ); message CM_DIALOGCHAR;
    procedure CMFontChanged( var Msg: TMessage ); message CM_FONTCHANGED;
    procedure CMParentColorChanged( var Msg: TMessage ); message CM_PARENTCOLORCHANGED;
    procedure WMEraseBkgnd( var Msg: TWMEraseBkgnd ); message WM_ERASEBKGND;
    procedure WMGetDlgCode( var Msg: TWMGetDlgCode ); message WM_GETDLGCODE;
    procedure WMKillFocus( var Msg: TWMKillFocus ); message WM_KILLFOCUS;
    procedure WMNCHitTest( var Msg: TWMNCHitTest ); message WM_NCHITTEST;
    procedure WMSetFocus( var Msg: TWMSetFocus ); message WM_SETFOCUS;
    procedure WMSize( var Msg: TWMSize ); message WM_SIZE;
    procedure WMTimer( var Msg: TWMTimer ); message WM_TIMER;
  protected
    FAboutInfo: TRzAboutInfo;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;
    procedure AlignControls( AControl: TControl; var Rect: TRect ); override;
    procedure Changing( NewIndex: Integer; var Allowed: Boolean ); virtual;
    procedure CreateParams( var Params: TCreateParams ); override;

    procedure DefineProperties( Filer: TFiler ); override;

    // GetTabDataList is used by descendant classes (in other units) and thus cannot be private.
    function GetTabDataList: TRzTabDataList;

    procedure GetTextColor( ATabIndex: Integer; AStyle: TRzTextStyle;
                            var AColor: TColor; var Handled: Boolean ); virtual;

    procedure Rebuild; virtual;
    procedure TabClick; virtual;

    procedure InvalidateControl; virtual;
    procedure Paint; override;
    procedure PaintBackground( ACanvas: TCanvas; const ARect: TRect; var Handled: Boolean ); virtual;
    procedure PaintCardBackground( ACanvas: TCanvas; ARow: Integer;
                                   const ARect: TRect; var Handled: Boolean ); virtual;
    procedure PaintTabBackground( ACanvas: TCanvas; ATabIndex: Integer;
                                  const ARect: TRect; var Handled: Boolean ); virtual;

    procedure DrawMoveTabIndicator( R: TRect ); virtual;

    procedure DestroyActiveTab; virtual;
    procedure ActiveTabMoved( Index: Integer ); virtual;

    { Event Dispatch Methods }
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure Loaded; override;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseMove( Shift: TShiftState; X, Y: Integer ); override;
    procedure DragOver( Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean ); override;

    function CanClose: Boolean; dynamic;

    { Property Access Methods }
    procedure SetAlignTabs( Value: Boolean ); virtual;
    procedure SetBackgroundColor( Value: TColor ); virtual;
    procedure SetBoldCurrentTab( Value: Boolean ); virtual;
    procedure SetCalcNeeded( Value: Boolean ); virtual;
    procedure SetShowCard( Value: Boolean ); virtual;
    procedure SetShowCardFrame( Value: Boolean ); virtual;
    procedure SetShowFullFrame( Value: Boolean ); virtual;
    procedure SetShowCloseButton( Value: Boolean ); virtual;
    procedure SetUseColoredTabs( Value: Boolean ); virtual;
    procedure SetCutCornerSize( Value: Integer ); virtual;
    procedure SetFlatColor( Value: TColor ); virtual;
    procedure SetFlatColorAdjustment( Value: Integer ); virtual;
    procedure SetImagePosition( Value: TRzImagePosition ); virtual;
    procedure SetImageAlignment( Value: TRzHorizontalAlignment ); virtual;
    procedure SetImageMargin( Value: Integer ); virtual;
    procedure SetImageAlignmentVertical( Value: TRzVerticalAlignment ); virtual;
    procedure SetHotTrack( Value: Boolean ); virtual;
    procedure SetHotTrackColor( Value: TColor ); virtual;
    procedure SetHotTrackColorType( Value: TRzHotTrackColorType ); virtual;
    procedure SetHotTrackStyle( Value: TRzHotTrackStyle ); virtual;
    procedure SetImages( Value: TCustomImageList ); virtual;
    procedure SetMargin( Value: Integer ); virtual;
    procedure SetMultiLine( Value: Boolean ); virtual;
    procedure SetParentBackgroundColor( Value: Boolean ); virtual;
    procedure SetRowExtent( Value: Integer ); virtual;
    procedure SetRowIndent( Value: Integer ); virtual;
    procedure SetRowOverlap( Value: Integer ); virtual;
    procedure SetShowFocusRect( Value: Boolean ); virtual;
    procedure SetShowShadow( Value: Boolean ); virtual;
    procedure SetTextOrientation( Value: TOrientation ); virtual;
    procedure SetTabColors( Value: TRzTabColors ); virtual;
    procedure SetTabHeight( Value: Integer ); virtual;
    procedure SetTabHints( Value: Boolean ); virtual;
    procedure SetTabIndex( Value: Integer ); virtual;
    procedure SetTabOrientation( Value: TRzTabOrientation ); virtual;
    procedure SetTabRegionCacheSize( Value: Integer ); virtual;
    procedure SetTabSequence( Value: TRzTabSequence ); virtual;
    procedure SetTabStyle( Value: TRzTabStyle ); virtual;
    procedure SetTabWidth( Value: Integer ); virtual;
    procedure SetTextColors( Value: TRzTextColors ); virtual;
    procedure SetTextAlignment( Value: TRzHorizontalAlignment ); virtual;
    procedure SetTextAlignmentVertical( Value: TRzVerticalAlignment ); virtual;
    procedure SetUseGradients( Value: Boolean ); virtual;
    procedure SetTransparent( Value: Boolean ); virtual;


    property AlignTabs: Boolean
      read FAlignTabs
      write SetAlignTabs
      default False;

    property AllowTabDragging: Boolean
      read FAllowTabDragging
      write FAllowTabDragging
      default False;

    property BackgroundColor: TColor
      read FBackgroundColor
      write SetBackgroundColor
      stored IsBackgroundColorStored;

    property BoldCurrentTab: Boolean
      read FBoldCurrentTab
      write SetBoldCurrentTab
      default False;

    property CutCornerSize: Integer
      read FCutCornerSize
      write SetCutCornerSize
      default 6;

    property DisplayRect: TRect
      read GetDisplayRect;

    property FlatColor: TColor
      read FFlatColor
      write SetFlatColor
      default clBtnShadow;

    property FlatColorAdjustment: Integer
      read FFlatColorAdjustment
      write SetFlatColorAdjustment
      default 0;

    property ImageAlignment: TRzHorizontalAlignment
      read FImageAlignment
      write SetImageAlignment
      default haCenter;

    property ImageMargin: Integer
      read FImageMargin
      write SetImageMargin
      default 2;

    property ImagePosition: TRzImagePosition
      read FImagePosition
      write SetImagePosition
      default ipLeft;

    property ImageAlignmentVertical: TRzVerticalAlignment
      read FImageAlignmentVertical
      write SetImageAlignmentVertical
      default vaCenter;

    property HotTrack: Boolean
      read FHotTrack
      write SetHotTrack
      default True;

    property HotTrackColor: TColor
      read FHotTrackColor
      write SetHotTrackColor
      default clHighlight;

    property HotTrackColorType: TRzHotTrackColorType
      read FHotTrackColorType
      write SetHotTrackColorType
      default htctComplement;

    property HotTrackStyle: TRzHotTrackStyle
      read FHotTrackStyle
      write SetHotTrackStyle
      default htsTab;

    property Images: TCustomImageList
      read FImages
      write SetImages;

    property Margin: Integer
      read FMargin
      write SetMargin
      default 0;

    property MultiLine: Boolean
      read FMultiLine
      write SetMultiLine
      default False;

    // ParentBackgroundColor determines whether the color of the parent will be
    // used for BackgroundColor.
    property ParentBackgroundColor: Boolean
      read FParentBackgroundColor
      write SetParentBackgroundColor
      default True;

    property RowIndent: Integer
      read FRowIndent
      write SetRowIndent
      default 5;

    property RowOverlap: Integer
      read FRowOverlap
      write SetRowOverlap
      default 5;

    // Scroller property is only provided for use by descendants so they can
    // ignore the scroll buttons within their GetChildren and WriteComponents
    // implementations.
    property Scroller: TRzTabScroller
      read FScroller
      stored False;

    property CloseButton: TRzTabCloseButton
      read FCloseButton
      stored False;

    // ShowCard determines whether an enclosed frame ('card') is drawn around
    // the client area or just the top line of the frame is drawn.
    property ShowCard: Boolean
      read FShowCard
      write SetShowCard
      default True;

    property ShowCardFrame: Boolean
      read FShowCardFrame
      write SetShowCardFrame
      default True;

    property ShowCloseButton: Boolean
      read FShowCloseButton
      write SetShowCloseButton
      default False;

    property ShowFocusRect: Boolean
      read FShowFocusRect
      write SetShowFocusRect
      default True;

    property ShowFullFrame: Boolean
      read FShowFullFrame
      write SetShowFullFrame
      default True;
      
    property ShowShadow: Boolean
      read FShowShadow
      write SetShowShadow
      default True;

    property TextOrientation: TOrientation
      read FTextOrientation
      write SetTextOrientation
      default orHorizontal;

    property TabColors: TRzTabColors
      read FTabColors
      write SetTabColors;

    property TabHeight: Integer
      read FTabHeight
      write SetTabHeight
      default 0;

    property TabHints: Boolean
      read FTabHints
      write SetTabHints
      default False;

    property TabIndex: Integer
      read FTabIndex
      write SetTabIndex
      default -1;

    property TabIndexDefault: Integer
      read FTabIndexDefault
      write FTabIndexDefault
      default 0;

    property TabOrientation: TRzTabOrientation
      read FTabOrientation
      write SetTabOrientation
      default toTop;

    property TabRegionCacheSize: Integer
      read FTabRegionCacheSize
      write SetTabRegionCacheSize
      default OptimumTabRegionCacheSize;

    property TabSequence: TRzTabSequence
      read FTabSequence
      write SetTabSequence
      default tsStandard;

    property TabStyle: TRzTabStyle
      read FTabStyle
      write SetTabStyle
      default tsSingleSlant;

    property TabWidth: Integer
      read FTabWidth
      write SetTabWidth
      default 0;

    property TextColors: TRzTextColors
      read FTextColors
      write SetTextColors;

    property TextAlignment: TRzHorizontalAlignment
      read FTextAlignment
      write SetTextAlignment
      default haCenter;

    property TextAlignmentVertical: TRzVerticalAlignment
      read FTextAlignmentVertical
      write SetTextAlignmentVertical
      default vaCenter;

    property UseColoredTabs: Boolean
      read FUseColoredTabs
      write SetUseColoredTabs
      default False;

    property Transparent: Boolean
      read FTransparent
      write SetTransparent
      default False;

    property UseGradients: Boolean
      read FUseGradients
      write SetUseGradients
      default True;

    property OnChange: TNotifyEvent
      read FOnChange
      write FOnChange;

    property OnChanging: TRzTabChangingEvent
      read FOnChanging
      write FOnChanging;

    property OnClose: TRzTabCloseEvent
      read FOnClose
      write FOnClose;

    property OnGetTextColor: TRzGetTextColorEvent
      read FOnGetTextColor
      write FOnGetTextColor;

    property OnPaintBackground: TRzPaintBackgroundEvent
      read FOnPaintBackground
      write FOnPaintBackground;

    property OnPaintCardBackground: TRzPaintCardBackgroundEvent
      read FOnPaintCardBackground
      write FOnPaintCardBackground;

    property OnPaintTabBackground: TRzPaintTabBackgroundEvent
      read FOnPaintTabBackground
      write FOnPaintTabBackground;

    property OnTabClick: TNotifyEvent
      read FOnTabClick
      write FOnTabClick;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure Change; virtual;
    procedure CloseActiveTab;

    procedure HideAllTabs; virtual;
    procedure ShowAllTabs; virtual;

    function TabAtPos( X, Y: Integer ): Integer;

    procedure DragDrop( Source: TObject; X, Y: Integer ); override;

    property TabStop default True;
  end;


  // A TRzTabData object is used to hold the attributes of a single tab.

  TRzTabData = class( TPersistent )
  private
    FCaption: string;
    FColor: TColor;
    FDisabledIndex: TImageIndex;
    FEnabled: Boolean;
    FHint: string;
    FImageIndex: TImageIndex;
    FRawRect: TRect;
    FVisible: Boolean;
    FRow: Integer;
  public
    constructor Create;

    procedure Assign( Source: TPersistent ); override;

    property Caption: string
      read FCaption
      write FCaption;

    property Color: TColor
      read FColor
      write FColor
      default clBtnFace;

    property DisabledIndex: TImageIndex
      read FDisabledIndex
      write FDisabledIndex
      default -1;

    property Enabled: Boolean
      read FEnabled
      write FEnabled
      default True;

    property Hint: string
      read FHint
      write FHint;

    property ImageIndex: TImageIndex
      read FImageIndex
      write FImageIndex
      default -1;

    property RawRect: TRect
      read FRawRect
      write FRawRect;

    property Row: Integer
      read FRow
      write FRow
      default 0;

    property Visible: Boolean
      read FVisible
      write FVisible
      default True;
  end;


  TRzTabDataList = class( TPersistent )
  private
    FTabList: TList;
  protected
    function GetCount: Integer; virtual;
    function GetItem( Index: Integer ): TRzTabData; virtual;
    procedure SetItem( Index: Integer; Value: TRzTabData ); virtual;
  public
    constructor Create;
    destructor Destroy; override;

    function Add( Item: TRzTabData ): Integer;
    procedure Assign( Source: TPersistent ); override;
    procedure Clear;
    procedure Delete( Index: Integer );
    function First: TRzTabData;
    function IndexOf( Item: TRzTabData ): Integer;
    procedure Insert( Index: Integer; Item: TRzTabData );
    function Last: TRzTabData;
    procedure Move( CurIndex, NewIndex: Integer );
    function Remove( Item: TRzTabData ): Integer;

    property Count: Integer
      read GetCount;

    property Items[ Index: Integer ]: TRzTabData
      read GetItem
      write SetItem; default;
  end;


  TRzPageControl = class;

  TRzTabSheet = class( TCustomControl )
  private
    FDisabledIndex: TImageIndex;
    FImageIndex: TImageIndex;
    FPageControl: TRzPageControl;

    FTabEnabled: Boolean;
    FTabVisible: Boolean;
    FOnPaintBackground: TRzPaintBackgroundEvent;

    FData: Pointer;

    procedure AssignToTabData( Dest: TPersistent );
    procedure Changed;

    procedure InternalSetVisible( Value: Boolean );

    { Message Handling Methods }
    procedure CMTextChanged( var Msg: TMessage ); message CM_TEXTCHANGED;
    procedure WMEraseBkgnd( var Msg: TWmEraseBkgnd ); message WM_ERASEBKGND;
  protected
    procedure AssignTo( Dest: TPersistent ); override;
    procedure CreateParams( var Params: TCreateParams ); override;
    procedure DestroyHandle;

    procedure Paint; override;
    procedure PaintBackground( ACanvas: TCanvas; const ARect: TRect; var Handled: Boolean );
    procedure ReadState( Reader: TReader ); override;

    { Property Access Methods }
    function GetColor: TColor; virtual;
    procedure SetColor( Value: TColor ); virtual;
    procedure SetDisabledIndex( Value: TImageIndex ); virtual;
    procedure SetImageIndex( Value: TImageIndex ); virtual;
    procedure SetPageControl( APageControl: TRzPageControl ); virtual;
    function GetPageIndex: Integer; virtual;
    procedure SetPageIndex( Value: Integer ); virtual;
    procedure SetTabEnabled( Value: Boolean ); virtual;
    function GetTabIndex: Integer; virtual;
    procedure SetTabVisible( Value: Boolean ); virtual;
    function GetVisible: Boolean; virtual;
    procedure SetVisible( Value: Boolean ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    property Data: Pointer
      read FData
      write FData;

    property PageControl: TRzPageControl
      read FPageControl
      write SetPageControl;

    property TabIndex: Integer
      read GetTabIndex;

    property Visible: Boolean
      read GetVisible
      write SetVisible;
  published
    property Color: TColor
      read GetColor
      write SetColor
      default clBtnFace;

    property DisabledIndex: TImageIndex
      read FDisabledIndex
      write SetDisabledIndex
      default -1;

    property ImageIndex: TImageIndex
      read FImageIndex
      write SetImageIndex
      default -1;

    property PageIndex: Integer
      read GetPageIndex
      write SetPageIndex
      stored False;

    property TabEnabled: Boolean
      read FTabEnabled
      write SetTabEnabled
      default True;

    property TabVisible: Boolean
      read FTabVisible
      write SetTabVisible
      default True;

    property OnPaintBackground: TRzPaintBackgroundEvent
      read FOnPaintBackground
      write FOnPaintBackground;

    { Inherited Properties & Events }
    property Caption;
    property Constraints;
    property Enabled;
    property Font;
    property Height stored False;
    property Left stored False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Top stored False;
    property Width stored False;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
  end;


  TRzPageControl = class( TRzCustomTabControl )
  private
    FActivePage: TRzTabSheet;
    FActivePageDefault: TRzTabSheet;
    FNewDockSheet: TRzTabSheet;
    FUndockingPage: TRzTabSheet;
    FPages: TList;
    FSaveResources: Boolean;
    FInitActivePage: Boolean;

    procedure ChangeActivePage( Page: TRzTabSheet );
    procedure InsertPage( Page: TRzTabSheet );
    procedure RemovePage( Page: TRzTabSheet );

    function GetDockClientFromMousePos( MousePos: TPoint ): TControl;

    { Message Handling Methods }
    procedure CMColorChanged( var Msg: TMessage ); message cm_ColorChanged;
    procedure CMDialogKey( var Msg: TCMDialogKey ); message cm_DialogKey;

    procedure CMDockClient( var Msg: TCMDockClient ); message cm_DockClient;
    procedure CMDockNotification( var Msg: TCMDockNotification ); message cm_DockNotification;
    procedure CMUnDockClient( var Msg: TCMUnDockClient ); message cm_UndockClient;
    procedure WMLButtonDown( var Msg: TWMLButtonDown); message wm_LButtonDown;
    procedure WMLButtonDblClk( var Msg: TWMLButtonDblClk); message wm_LButtonDblClk;
  protected
    procedure Changing( NewIndex: Integer; var Allowed: Boolean ); override;
    procedure CreateParams( var Params: TCreateParams ); override;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    procedure DestroyActiveTab; override;
    procedure ActiveTabMoved( Index: Integer ); override;

    procedure PaintCardBackground( ACanvas: TCanvas; ARow: Integer;
                                   const ARect: TRect; var Handled: Boolean ); override;
    procedure Rebuild; override;
    procedure GetChildren( Proc: TGetChildProc; Root: TComponent ); override;
    procedure SetChildOrder( Child: TComponent; Order: Integer ); override;
    procedure ShowControl( AControl: TControl ); override;

    procedure DoAddDockClient( Client: TControl; const ARect: TRect ); override;
    procedure DockOver( Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean ); override;
    procedure DoRemoveDockClient( Client: TControl ); override;
    function GetPageFromDockClient( Client: TControl ): TRzTabSheet;
    procedure GetSiteInfo( Client: TControl; var InfluenceRect: TRect; MousePos: TPoint;
                           var CanDock: Boolean ); override;

    { Property Access Methods }
    function GetPage( Index: Integer ): TRzTabSheet; virtual;
    function GetPageCount: Integer; virtual;
    procedure SetActivePage( Page: TRzTabSheet ); virtual;
    function GetActivePageIndex: Integer; virtual;
    procedure SetActivePageIndex( Value: Integer ); virtual;
    procedure SetUseColoredTabs( Value: Boolean ); override;
    procedure SetSaveResources( Value: Boolean ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure Change; override;

    function FindNextPage( CurPage: TRzTabSheet; GoForward, CheckTabVisible: Boolean ): TRzTabSheet;
    function PageForTab( ATabIndex: Integer ): TRzTabSheet;
    procedure SelectNextPage( GoForward: Boolean );

    procedure HideAllTabs; override;
    procedure ShowAllTabs; override;

    procedure MakeControlVisible( AControl: TControl );

    property PageCount: Integer
      read GetPageCount;

    property Pages[ Index: Integer ]: TRzTabSheet
      read GetPage;

    property ActivePageIndex: Integer
      read GetActivePageIndex
      write SetActivePageIndex;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property ActivePage: TRzTabSheet
      read FActivePage
      write SetActivePage;

    property ActivePageDefault: TRzTabSheet
      read FActivePageDefault
      write FActivePageDefault;

    property SaveResources: Boolean
      read FSaveResources
      write SetSaveResources
      default False;

    { Inherited Properties & Events }
    property Align;
    property AlignTabs;
    property AllowTabDragging;
    property Anchors;
    property BackgroundColor;
    property BoldCurrentTab;
    property Color default clBtnFace;
    property UseColoredTabs;
    property Constraints;
    property CutCornerSize;
    property DockSite;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property FlatColor;
    property FlatColorAdjustment;
    property ImageAlignment;
    property ImageMargin;
    property ImagePosition;
    property ImageAlignmentVertical;
    property HelpContext;
    property Hint;
    property HotTrack;
    property HotTrackColor;
    property HotTrackColorType;
    property HotTrackStyle;
    property Images;
    property Margin;
    property MultiLine;
    property ParentBackgroundColor;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RowIndent;
    property RowOverlap;
    property ShowCardFrame;
    property ShowCloseButton;
    property ShowFocusRect;
    property ShowFullFrame;
    property ShowHint;
    property ShowShadow;
    property TextOrientation;
    property TabColors;
    property TabHeight;
    property TabHints;
    property TabIndex;
    property TabOrder;
    property TabOrientation;
    property TabSequence;
    property TabStop;
    property TabStyle;
    property TabWidth;
    property TextColors;
    property TextAlignment;
    property TextAlignmentVertical;
    property Transparent;
    property UseGradients;
    property Visible;

    property OnChange;
    property OnChanging;
    property OnClick;
    property OnClose;
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
    property OnGetTextColor;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaintBackground;             // background behind tabs

    // Even though each page of a page control has an OnPaintBackground event,
    // the OnPaintCardBackground event is still needed to paint the 'gap' where
    // the card shows through between the current tab and its page.
    property OnPaintCardBackground;
    property OnPaintTabBackground;
    property OnStartDock;
    property OnStartDrag;
    property OnTabClick;
    property OnUnDock;
  end;


  TRzCollectionTabControl = class;

  // A TRzTabCollectionItem object is used to hold the attributes of a single tab

  TRzTabCollectionItem = class( TCollectionItem )
  private
    FCaption: string;
    FColor: TColor;
    FDisabledIndex: TImageIndex;
    FEnabled: Boolean;
    FHint: string;
    FImageIndex: TImageIndex;
    FVisible: Boolean;
    FTag: Longint;
    FData: Pointer;
    procedure AssignToTabData( Dest: TPersistent );
  protected
    function GetDisplayName: string; override;

    procedure AssignTo( Dest: TPersistent ); override;

    { Property Access Methods }
    procedure SetCaption( const Value: string ); virtual;
    procedure SetColor( Value: TColor ); virtual;
    procedure SetDisabledIndex( Value: TImageIndex ); virtual;
    procedure SetEnabled( Value: Boolean ); virtual;
    procedure SetHint( const Value: string ); virtual;
    procedure SetImageIndex( Value: TImageIndex ); virtual;
    procedure SetVisible( Value: Boolean ); virtual;
  public
    constructor Create( Collection: TCollection ); override;

    procedure Assign( Source: TPersistent ); override;

    property Data: Pointer
      read FData
      write FData;
  published
    property Caption: string
      read FCaption
      write SetCaption;

    property Color: TColor
      read FColor
      write SetColor
      default clBtnFace;

    property DisabledIndex: TImageIndex
      read FDisabledIndex
      write SetDisabledIndex
      default -1;

    property Enabled: Boolean
      read FEnabled
      write SetEnabled
      default True;

    property Hint: string
      read FHint
      write SetHint;

    property ImageIndex: TImageIndex
      read FImageIndex
      write SetImageIndex
      default -1;

    property Tag: Longint
      read FTag
      write FTag
      default 0;

    property Visible: Boolean
      read FVisible
      write SetVisible
      default True;
  end;


  TRzTabCollection = class( TCollection )
  private
    FTabControl: TRzCollectionTabControl;
  protected
    function GetOwner: TPersistent; override;
    procedure Update( Item: TCollectionItem ); override;

    { Property Access Methods }
    function GetItem( Index: Integer ): TRzTabCollectionItem; virtual;
    procedure SetItem( Index: Integer; Value: TRzTabCollectionItem ); virtual;
  public
    constructor Create( TabControl: TRzCollectionTabControl );

    function Add: TRzTabCollectionItem;
    procedure Delete( Index: Integer );
    procedure Move( CurIndex, NewIndex: Integer );
    procedure Clear;

    property Items[ Index: Integer ]: TRzTabCollectionItem
      read GetItem
      write SetItem; default;
  end;


  TRzCollectionTabControl = class( TRzCustomTabControl )
  private
    FTabCollection: TRzTabCollection;
    function GetTabCollection: TRzTabCollection;
    procedure SetTabCollection( Value: TRzTabCollection );
  protected
    procedure Rebuild; override;

    procedure DestroyActiveTab; override;
    procedure ActiveTabMoved( Index: Integer ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure HideAllTabs; override;
    procedure ShowAllTabs; override;

    property TabIndex;

    property Tabs: TRzTabCollection
      read GetTabCollection
      write SetTabCollection;
  end;


  TRzTabControl = class( TRzCollectionTabControl )
  public
    property DisplayRect;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Align;
    property AlignTabs;
    property AllowTabDragging;
    property Anchors;
    property BackgroundColor;
    property BoldCurrentTab;
    property Color default clBtnFace;
    property UseColoredTabs;
    property Constraints;
    property CutCornerSize;
    property Enabled;
    property Font;
    property FlatColor;
    property FlatColorAdjustment;
    property ImageAlignment;
    property ImageMargin;
    property ImagePosition;
    property ImageAlignmentVertical;
    property HelpContext;
    property Hint;
    property HotTrack;
    property HotTrackColor;
    property HotTrackColorType;
    property HotTrackStyle;
    property Images;
    property Margin;
    property MultiLine;
    property ParentBackgroundColor;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RowIndent;
    property RowOverlap;
    property ShowCard;
    property ShowCardFrame;
    property ShowCloseButton;
    property ShowFocusRect;
    property ShowHint;
    property ShowShadow;
    property TextOrientation;
    property TabColors;
    property TabHeight;
    property TabHints;
    property TabIndex;
    property TabIndexDefault;
    property TabOrder;
    property TabOrientation;
    property Tabs;
    property TabSequence;
    property TabStop;
    property TabStyle;
    property TabWidth;
    property TextColors;
    property TextAlignment;
    property TextAlignmentVertical;
    property Transparent;
    property UseGradients;
    property Visible;

    property OnChange;
    property OnChanging;
    property OnClick;
    property OnClose;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetTextColor;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaintBackground;
    property OnPaintCardBackground;
    property OnPaintTabBackground;
    property OnTabClick;
  end;


implementation

uses
  {$IFDEF VCL70_OR_HIGHER}
  Themes;
  {$ELSE}
  RzThemeSrv;
  {$ENDIF}

resourcestring
  sRzIncorrectNumberOfPoints = 'Incorrect number of points in tab shape';
  sRzTabRegionCapacityError  = 'Capacity must be -1 (to cache all regions) or > 0';
  sRzSavingDCError           = 'Error saving device context';
  sRzRestoringDCError        = 'Error restoring device context';
  sRzCreateRegionError       = 'Error creating region';
  sRzPageIndexOutOfRange     = '%d is an invalid PageIndex value. PageIndex must be between 0 and %d';
  sRzInvalidVisibilityChange = 'You cannot change the Visible property of a page';

{=======================}
{== Support Functions ==}
{=======================}

function IsRectZero( ARect: TRect ): Boolean;
begin
  Result := ( ARect.Left = 0 ) and
            ( ARect.Right = 0 ) and
            ( ARect.Top = 0 ) and
            ( ARect.Bottom = 0 );
end;


procedure OrderRectCorners( var ARect: TRect );
var
  R: TRect;
begin
  // Re-order the corner points so the origin is at top-left and
  // the corner is at the bottom-right
  R.Left := Min( ARect.Left, ARect.Right );
  R.Right := Max( ARect.Left, ARect.Right );
  R.Top := Min( ARect.Top, ARect.Bottom );
  R.Bottom := Max( ARect.Top, ARect.Bottom );
  ARect := R;
end;


function PointInRect( const ARect: TRect; const APoint: TPoint ): Boolean;
var
  R: TRect;
begin
  R := ARect;
  // Corners should already have been ordered but check anyway
  OrderRectCorners( R );                    // necessary for PtInRect to work
  Result := PtInRect( R, APoint );
end;



type
  TRectClass = class
  public
    Rect: TRect;
  end;

var
  Registered: Boolean = False;



{============================}
{== TRzTabScroller Methods ==}
{============================}

constructor TRzTabScroller.Create( AOwner: TComponent );
begin
  inherited;
  FTabControl := TRzCustomTabControl( AOwner );
  FOrientation := orHorizontal;
  FFrameColor := clBtnShadow;
end;


procedure TRzTabScroller.Paint;
var
  R: TRect;
  ElementDetails: TThemedElementDetails;
  Direction: TDirection;
  Disabled: Boolean;
begin
  if ThemeServices.ThemesEnabled then
  begin
    // Draw Down/Left Button
    R := ClientRect;
    if FOrientation = orHorizontal then
    begin
      R.Right := R.Left + ( Width div 2 );
      if FTabControl.TabSequence = tsStandard then
      begin
        if FTabControl.FFirstInView = 0 then
          ElementDetails := ThemeServices.GetElementDetails( tsDownHorzDisabled )
        else if FDown and ( FCurrent = sbDownLeft ) then
          ElementDetails := ThemeServices.GetElementDetails( tsDownHorzPressed )
        else
          ElementDetails := ThemeServices.GetElementDetails( tsDownHorzNormal );
      end
      else
      begin
        if ( FTabControl.GetLastVisible <> -1 ) and
           ( FTabControl.TabInView( FTabControl.FTabDataList[ FTabControl.GetLastVisible ] ) ) then
          ElementDetails := ThemeServices.GetElementDetails( tsDownHorzDisabled )
        else if FDown and ( FCurrent = sbDownLeft ) then
          ElementDetails := ThemeServices.GetElementDetails( tsDownHorzPressed )
        else
          ElementDetails := ThemeServices.GetElementDetails( tsDownHorzNormal );
      end;
    end
    else // FOrientation = orVertical
    begin
      R.Top := R.Bottom - ( Height div 2 );
      if FTabControl.TabSequence = tsStandard then
      begin
        if ( ( FTabControl.TabOrientation <> toRight ) and ( FTabControl.FFirstInView = 0 ) )
           or
           ( ( FTabControl.TabOrientation = toRight ) and ( FTabControl.GetLastVisible <> -1 ) and
             ( FTabControl.TabInView( FTabControl.FTabDataList[ FTabControl.GetLastVisible ] ) ) ) then
        begin
          ElementDetails := ThemeServices.GetElementDetails( tsDownDisabled )
        end
        else if FDown and ( FCurrent = sbDownLeft ) then
          ElementDetails := ThemeServices.GetElementDetails( tsDownPressed )
        else
          ElementDetails := ThemeServices.GetElementDetails( tsDownNormal );
      end
      else
      begin
        if ( ( FTabControl.TabOrientation <> toRight ) and ( FTabControl.GetLastVisible <> -1 ) and
             ( FTabControl.TabInView( FTabControl.FTabDataList[ FTabControl.GetLastVisible ] ) ) )
           or
           ( ( FTabControl.TabOrientation = toRight ) and ( FTabControl.FFirstInView = 0 ) ) then
        begin
          ElementDetails := ThemeServices.GetElementDetails( tsDownDisabled )
        end
        else if FDown and ( FCurrent = sbDownLeft ) then
          ElementDetails := ThemeServices.GetElementDetails( tsDownPressed )
        else
          ElementDetails := ThemeServices.GetElementDetails( tsDownNormal );
      end;
    end;

    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );


    // Draw Up/Right Button
    R := ClientRect;
    if FOrientation = orHorizontal then
    begin
      R.Left := R.Right - ( Width div 2 );
      if FTabControl.TabSequence = tsStandard then
      begin
        if ( FTabControl.GetLastVisible <> -1 ) and
           ( FTabControl.TabInView( FTabControl.FTabDataList[ FTabControl.GetLastVisible ] ) ) then
          ElementDetails := ThemeServices.GetElementDetails( tsUpHorzDisabled )
        else if FDown and ( FCurrent = sbUpRight ) then
          ElementDetails := ThemeServices.GetElementDetails( tsUpHorzPressed )
        else
          ElementDetails := ThemeServices.GetElementDetails( tsUpHorzNormal );
      end
      else
      begin
        if FTabControl.FFirstInView = 0 then
          ElementDetails := ThemeServices.GetElementDetails( tsUpHorzDisabled )
        else if FDown and ( FCurrent = sbUpRight ) then
          ElementDetails := ThemeServices.GetElementDetails( tsUpHorzPressed )
        else
          ElementDetails := ThemeServices.GetElementDetails( tsUpHorzNormal );
      end;
    end
    else // FOrientation = orVertical
    begin
      R.Bottom := R.Top + ( Height div 2 );
      if FTabControl.TabSequence = tsStandard then
      begin
        if ( ( FTabControl.TabOrientation <> toRight ) and ( FTabControl.GetLastVisible <> -1 ) and
             ( FTabControl.TabInView( FTabControl.FTabDataList[ FTabControl.GetLastVisible ] ) ) )
           or
           ( ( FTabControl.TabOrientation = toRight ) and ( FTabControl.FFirstInView = 0 ) ) then
        begin
          ElementDetails := ThemeServices.GetElementDetails( tsUpDisabled )
        end
        else if FDown and ( FCurrent = sbUpRight ) then
          ElementDetails := ThemeServices.GetElementDetails( tsUpPressed )
        else
          ElementDetails := ThemeServices.GetElementDetails( tsUpNormal );
      end
      else
      begin
        if ( ( FTabControl.TabOrientation <> toRight ) and ( FTabControl.FFirstInView = 0 ) )
           or
           ( ( FTabControl.TabOrientation = toRight ) and ( FTabControl.GetLastVisible <> -1 ) and
             ( FTabControl.TabInView( FTabControl.FTabDataList[ FTabControl.GetLastVisible ] ) ) ) then
        begin
          ElementDetails := ThemeServices.GetElementDetails( tsUpDisabled )
        end
        else if FDown and ( FCurrent = sbUpRight ) then
          ElementDetails := ThemeServices.GetElementDetails( tsUpPressed )
        else
          ElementDetails := ThemeServices.GetElementDetails( tsUpNormal );
      end;
    end;

    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );
  end
  else // No XP Themes
  begin
    // Draw Down/Left Button
    R := ClientRect;
    if FOrientation = orHorizontal then
    begin
      R.Right := R.Left + ( Width div 2 ) + 1;
      Direction := dirLeft;
    end
    else
    begin
      R.Top := R.Bottom - ( Height div 2 ) - 1;
      Direction := dirDown;
    end;

    if FTabControl.TabSequence = tsStandard then
    begin
      if FTabControl.TabOrientation <> toRight then
        Disabled := FTabControl.FFirstInView = 0
      else
      begin
        if FTabControl.GetLastVisible <> -1 then
          Disabled := FTabControl.TabInView( FTabControl.FTabDataList[ FTabControl.GetLastVisible ] )
        else
          Disabled := True;
      end;
    end
    else
    begin
      if FTabControl.TabOrientation <> toRight then
      begin
        if FTabControl.GetLastVisible <> -1 then
          Disabled := FTabControl.TabInView( FTabControl.FTabDataList[ FTabControl.GetLastVisible ] )
        else
          Disabled := True;
      end
      else
        Disabled := FTabControl.FFirstInView = 0;
    end;

    DrawSpinArrow( Canvas, R, uiWindows95, Direction, FDown and ( FCurrent = sbDownLeft ), not Disabled );

    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := FFrameColor;
    Canvas.Rectangle( R.Left, R.Top, R.Right, R.Bottom );
    Canvas.Brush.Style := bsSolid;


    // Draw Up/Right Button
    R := ClientRect;
    if FOrientation = orHorizontal then
    begin
      R.Left := R.Right - ( Width div 2 ) - 1;
      Direction := dirRight;
    end
    else
    begin
      R.Bottom := R.Top + ( Height div 2 ) + 1;
      Direction := dirUp;
    end;

    if FTabControl.TabSequence = tsStandard then
    begin
      if FTabControl.TabOrientation <> toRight then
      begin
        if FTabControl.GetLastVisible <> -1 then
          Disabled := FTabControl.TabInView( FTabControl.FTabDataList[ FTabControl.GetLastVisible ] )
        else
          Disabled := True;
      end
      else
        Disabled := FTabControl.FFirstInView = 0;
    end
    else
    begin
      if FTabControl.TabOrientation <> toRight then
        Disabled := FTabControl.FFirstInView = 0
      else
      begin
        if FTabControl.GetLastVisible <> -1 then
          Disabled := FTabControl.TabInView( FTabControl.FTabDataList[ FTabControl.GetLastVisible ] )
        else
          Disabled := True;
      end;
    end;

    DrawSpinArrow( Canvas, R, uiWindows95, Direction, FDown and ( FCurrent = sbUpRight ), not Disabled );

    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := FFrameColor;
    Canvas.Rectangle( R.Left, R.Top, R.Right, R.Bottom );
    Canvas.Brush.Style := bsSolid;
  end;
end; {= TRzTabScroller.Paint =}


procedure TRzTabScroller.DownLeftClick;
begin
  if Assigned( FOnDownLeftClick ) then
    FOnDownLeftClick( Self );
end;


procedure TRzTabScroller.UpRightClick;
begin
  if Assigned( FOnUpRightClick ) then
    FOnUpRightClick( Self );
end;


procedure TRzTabScroller.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;

  if FOrientation = orHorizontal then
  begin
    if X < Width div 2 then
      FCurrent := sbDownLeft
    else
      FCurrent := sbUpRight;
  end
  else
  begin
    if Y > Height div 2 then
      FCurrent := sbDownLeft
    else
      FCurrent := sbUpRight;
  end;

  FPressed := True;
  FDown := True;
  Invalidate;
  SetCapture( Handle );
end;


procedure TRzTabScroller.MouseMove( Shift: TShiftState; X, Y: Integer );
var
  P: TPoint;
  R: TRect;
begin
  inherited;

  if FPressed then
  begin
    P := Point( X, Y );
    R := Rect( 0, 0, Width div 2, Height );

    if FCurrent = sbUpRight then
      OffsetRect( R, Width div 2, 0 );

    if PtInRect( R, P ) <> FDown then
    begin
      FDown := not FDown;
      Invalidate;
    end;
  end;
end;


procedure TRzTabScroller.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;

  ReleaseCapture;
  FPressed := False;

  if FDown then
  begin
    FDown := False;
    case FCurrent of
      sbDownLeft:
        DownLeftClick;

      sbUpRight:
        UpRightClick;
    end;
    Invalidate;
  end;
end;


procedure TRzTabScroller.CMDesignHitTest( var Msg: TCMDesignHitTest );
begin
  Msg.Result := 1;
end;


procedure TRzTabScroller.SetFrameColor( Value: TColor );
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Invalidate;
  end;
end;


procedure TRzTabScroller.SetOrientation( Value: TOrientation );
begin
  if FOrientation <> Value then
  begin
    FOrientation := Value;
    Invalidate;
  end;
end;



{===============================}
{== TRzTabCloseButton Methods ==}
{===============================}

constructor TRzTabCloseButton.Create( AOwner: TComponent );
begin
  inherited;
  FTabControl := TRzCustomTabControl( AOwner );
  FFrameColor := clBtnShadow;
end;


procedure TRzTabCloseButton.Paint;
var
  R: TRect;
  ElementDetails: TThemedElementDetails;
  Flags: DWord;
begin
  R := ClientRect;
  if ThemeServices.ThemesEnabled then
  begin
    if FTabControl.TabIndex = -1 then
      ElementDetails := ThemeServices.GetElementDetails( twSmallCloseButtonDisabled )
    else if FDown then
      ElementDetails := ThemeServices.GetElementDetails( twSmallCloseButtonPushed )
    else
      ElementDetails := ThemeServices.GetElementDetails( twSmallCloseButtonNormal );

    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, R );
  end
  else // No XP Themes
  begin
    Flags := dfcs_CaptionClose or dfcs_Flat;
    if FDown then
      Flags := Flags or dfcs_Pushed;
    if FTabControl.TabIndex = -1 then
      Flags := Flags or dfcs_Inactive;

    DrawFrameControl( Canvas.Handle, R, dfc_Caption, Flags );

    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color := FFrameColor;
    Canvas.Rectangle( R.Left, R.Top, R.Right, R.Bottom );
    Canvas.Brush.Style := bsSolid;
  end;
end; {= TRzTabCloseButton.Paint =}


procedure TRzTabCloseButton.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;

  FPressed := True;
  FDown := True;
  Invalidate;
  SetCapture( Handle );
end;


procedure TRzTabCloseButton.MouseMove( Shift: TShiftState; X, Y: Integer );
var
  P: TPoint;
begin
  inherited;

  if FPressed then
  begin
    P := Point( X, Y );

    if PtInRect( ClientRect, P ) <> FDown then
    begin
      FDown := not FDown;
      Invalidate;
    end;
  end;
end;


procedure TRzTabCloseButton.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;

  ReleaseCapture;
  FPressed := False;

  if FDown then
  begin
    FDown := False;
    DoClose;
    Invalidate;
  end;
end;


procedure TRzTabCloseButton.SetFrameColor( Value: TColor );
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Invalidate;
  end;
end;


procedure TRzTabCloseButton.DoClose;
begin
  if Assigned( FOnClose ) then
    FOnClose( Self );
end;


{=============================================}
{== TRzTabRegionCacheItem Class Declaration ==}
{=============================================}

type
  TRzTabRegionCacheItem = class
  private
    FTabRect: TRect;
    FTabRegion: hRgn;
  protected
    procedure SetTabRegion( Value: hRgn ); virtual;
  public
    constructor Create;
    destructor Destroy; override;

    property TabRect: TRect
      read FTabRect
      write FTabRect;

    property TabRegion: hRgn
    read FTabRegion
    write SetTabRegion;
  end;


{===================================}
{== TRzTabRegionCacheItem Methods ==}
{===================================}

constructor TRzTabRegionCacheItem.Create;
begin
  inherited Create;
  FTabRect := Rect( -1, -1, -1, -1 );
end;


destructor TRzTabRegionCacheItem.Destroy;
begin
  SetTabRegion( 0 );
  inherited;
end;


procedure TRzTabRegionCacheItem.SetTabRegion( Value: hRgn );
begin
  if FTabRegion <> Value then
  begin
    { free memory used by previous region }
    if FTabRegion <> 0 then
      DeleteObject( FTabRegion );
    FTabRegion := Value;
  end;
end;



{===============================}
{== TRzTabRegionCache Methods ==}
{===============================}

constructor TRzTabRegionCache.Create;
begin
  inherited Create;
  FCache := TList.Create;
  FCapacity := OptimumTabRegionCacheSize;
end;


destructor TRzTabRegionCache.Destroy;
var
  I: Integer;
begin
  for I := 0 to FCache.Count - 1 do
    TRzTabRegionCacheItem( FCache[ I ] ).Free;
  FCache.Free;
  inherited;
end;


procedure TRzTabRegionCache.Add( ARect: TRect; ARegion: hRgn );
var
  Item: TRzTabRegionCacheItem;
  Region: hRgn;
  OldPos: Integer;
  I: Integer;
begin
  Region := Find( ARect );
  if Region = 0 then                        // No region for specified rect was found
  begin                                     // Create new item and insert as most recent
    Item := TRzTabRegionCacheItem.Create;
    Item.TabRect := ARect;
    Item.TabRegion := ARegion;
    FCache.Insert( 0, Item );
  end
  else
  begin                                     // A region for the specified rect was found; move to start
    OldPos := -1;
    for I := 0 to FCache.Count - 1 do
    begin
      if TRzTabRegionCacheItem( FCache[ I ] ).TabRegion = Region then
      begin
        OldPos := I;
        Break;
      end;
    end;
    if ( OldPos >= 0 ) and ( OldPos < FCache.Count ) then
      FCache.Move( OldPos, 0 );
  end;
  if ( FCapacity <> -1 ) and ( FCache.Count > FCapacity ) then
  begin                                     // Remove oldest item from cache
    I := FCache.Count - 1;
    TRzTabRegionCacheItem( FCache[ I ] ).Free;
    FCache.Delete( I );
  end;
end; {= TRzTabRegionCache.Add =}


procedure TRzTabRegionCache.Clear;
var
  I: Integer;
begin
  for I := 0 to FCache.Count - 1 do
    TRzTabRegionCacheItem( FCache[ I ] ).Free;
  FCache.Clear;
end;


function TRzTabRegionCache.Find( ARect: TRect ): hRgn;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to FCache.Count - 1 do
  begin
    if EqualRect( ARect, TRzTabRegionCacheItem( FCache[ I ] ).TabRect ) then
    begin
      Result := TRzTabRegionCacheItem( FCache[ I ] ).TabRegion;
      Break;
    end;
  end;
end;


function TRzTabRegionCache.GetCount: Integer;
begin
  Result := FCache.Count;
end;


procedure TRzTabRegionCache.SetCapacity( Value: Integer );
var
  I: Integer;
begin
  if ( Value < -1 ) or ( Value = 0 ) then
    raise Exception.Create( sRzTabRegionCapacityError );

  if FCapacity <> Value then
  begin
    FCapacity := Value;
    if FCapacity <> -1 then
      while FCache.Count > FCapacity do
      begin
        I := FCache.Count - 1;
        TRzTabRegionCacheItem( FCache[ I ] ).Free;
        FCache.Delete( I );
      end;
  end;
end;


{====================================}
{== TRzTextExtentCacheItem Methods ==}
{====================================}

type
  // The undelying size of TSize is different under different Delphi versions
  // (4 bytes in Delphi 1, 8 bytes in Delphi 2/3) so we can't just store the
  // extent in the object pointer of each FCache item.

  TRzTextExtentCacheItem = class
  private
    FExtent: TSize;
  public
    constructor Create( Extent: TSize );

    property Extent: TSize
      read FExtent
      write FExtent;
  end;

constructor TRzTextExtentCacheItem.Create( Extent: TSize );
begin
  inherited Create;
  FExtent := Extent;
end;


{================================}
{== TRzTextExtentCache Methods ==}
{================================}

constructor TRzTextExtentCache.Create;
begin
  inherited Create;
  FCache := TStringList.Create;
end;


destructor TRzTextExtentCache.Destroy;
begin
  Clear;
  FCache.Free;
  inherited;
end;


procedure TRzTextExtentCache.Add( const AString: string; Extent: TSize );
begin
  if FCache.IndexOf( AString ) = -1 then
    FCache.AddObject( AString, TRzTextExtentCacheItem.Create( Extent ) );
end;


procedure TRzTextExtentCache.Clear;
var
  I: Integer;
begin
  for I := 0 to FCache.Count - 1 do
    TRzTextExtentCacheItem( FCache.Objects[ I ] ).Free;
  FCache.Clear;
end;


function TRzTextExtentCache.Find( const AString: string; var Extent: TSize ): Boolean;
var
  Idx: Integer;
begin
  Result := FCache.Find( AString, Idx );
  if Result then
    Extent := TRzTextExtentCacheItem( FCache.Objects[ Idx ] ).Extent;
end;


{========================}
{== TRzTabData Methods ==}
{========================}

constructor TRzTabData.Create;
begin
  FColor := clBtnFace;
  FEnabled := True;
  FVisible := True;
  FImageIndex := -1;
  FDisabledIndex := -1;
end;


procedure TRzTabData.Assign( Source: TPersistent );
var
  TabData: TRzTabData;
begin
  if Source is TRzTabData then
  begin
    TabData := TRzTabData( Source );
    Caption := TabData.Caption;
    DisabledIndex := TabData.DisabledIndex;
    ImageIndex := TabData.ImageIndex;
    Color := TabData.Color;
    Enabled := TabData.Enabled;
    Visible := TabData.Visible;
    Hint := TabData.Hint;
    Exit;
  end;
  inherited;
end;



{============================}
{== TRzTabDataList Methods ==}
{============================}

constructor TRzTabDataList.Create;
begin
  inherited Create;
  FTabList := TList.Create;
end;


destructor TRzTabDataList.Destroy;
begin
  Clear;
  FTabList.Free;
  inherited;
end;


procedure TRzTabDataList.Assign( Source: TPersistent );
var
  AList: TRzTabDataList;
  TabData: TRzTabData;
  I: Integer;
begin
  if Source is TRzTabDataList then
  begin
    Clear;
    AList := TRzTabDataList( Source );
    for I := 0 to AList.Count - 1 do
    begin
      TabData := TRzTabData.Create;
      TabData.Assign( AList[ I ] );
      Add( TabData );
    end;
    Exit;
  end;
  inherited;
end;


function TRzTabDataList.Add( Item: TRzTabData ): Integer;
begin
  Result := FTabList.Add( Item );
end;


procedure TRzTabDataList.Clear;
var
  I: Integer;
begin
  for I := 0 to FTabList.Count - 1 do
    Items[ I ].Free;
  FTabList.Clear;
end;


procedure TRzTabDataList.Delete( Index: Integer );
begin
  Items[ Index ].Free;
  FTabList.Delete( Index );
end;


function TRzTabDataList.First: TRzTabData;
begin
  Result := TRzTabData( FTabList.First );
end;


function TRzTabDataList.GetCount: Integer;
begin
  Result := FTabList.Count;
end;


function TRzTabDataList.GetItem( Index: Integer ): TRzTabData;
begin
  Result := TRzTabData( FTabList[ Index ] );
end;


function TRzTabDataList.IndexOf( Item: TRzTabData ): Integer;
begin
  Result := FTabList.IndexOf( Item );
end;


procedure TRzTabDataList.Insert( Index: Integer; Item: TRzTabData );
begin
  FTabList.Insert( Index, Item );
end;


function TRzTabDataList.Last: TRzTabData;
begin
  Result := TRzTabData( FTabList.Last );
end;


procedure TRzTabDataList.Move( CurIndex, NewIndex: Integer );
var
  Item: TRzTabData;
begin
  if CurIndex <> NewIndex then
  begin
    Item := Items[ CurIndex ];
    FTabList.Delete( CurIndex );            // Don't use Self.Delete because it frees item
    Insert( NewIndex, Item );
  end;
end;


procedure TRzTabDataList.SetItem( Index: Integer; Value: TRzTabData );
begin
  Items[ Index ].Free;
  FTabList[ Index ] := Value;
end;


{ Note that Remove uses the non-virtual Delete method }

function TRzTabDataList.Remove( Item: TRzTabData ): Integer;
begin
  Result := IndexOf( Item );
  if Result <> -1 then
    Delete( Result );
end;


{==========================}
{== TRzTabColors Methods ==}
{==========================}

constructor TRzTabColors.Create( TabControl: TRzCustomTabControl );
begin
  inherited Create;
  FTabControl := TabControl;

  FHighlightBar := clHighlight;
  FShadow := clBtnFace;
  FUnselected := clWindow;
end;


procedure TRzTabColors.SetHighlightBar( Value: TColor );
begin
  if FHighlightBar <> Value then
  begin
    FHighlightBar := Value;
    FTabControl.InvalidateControl;
  end;
end;


procedure TRzTabColors.SetShadow( Value: TColor );
begin
  if FShadow <> Value then
  begin
    FShadow := Value;
    FTabControl.InvalidateControl;
  end;
end;


procedure TRzTabColors.SetUnselected( Value: TColor );
begin
  if FUnselected <> Value then
  begin
    FUnselected := Value;
    FTabControl.InvalidateControl;
  end;
end;


{===========================}
{== TRzTextColors Methods ==}
{===========================}

constructor TRzTextColors.Create( TabControl: TRzCustomTabControl );
begin
  inherited Create;
  FTabControl := TabControl;

  FDisabledHighlight := clBtnHighlight;
  FDisabledShadow := clBtnShadow;
  FSelected := clBtnText;
  FUnselected := clBtnText;
end;


procedure TRzTextColors.SetDisabledHighlight( Value: TColor );
begin
  if FDisabledHighlight <> Value then
  begin
    FDisabledHighlight := Value;
    FTabControl.InvalidateControl;
  end;
end;


procedure TRzTextColors.SetDisabledShadow( Value: TColor );
begin
  if FDisabledShadow <> Value then
  begin
    FDisabledShadow := Value;
    FTabControl.InvalidateControl;
  end;
end;


procedure TRzTextColors.SetSelected( Value: TColor );
begin
  if FSelected <> Value then
  begin
    FSelected := Value;
    FTabControl.InvalidateControl;
  end;
end;


procedure TRzTextColors.SetUnselected( Value: TColor );
begin
  if FUnselected <> Value then
  begin
    FUnselected := Value;
    FTabControl.InvalidateControl;
  end;
end;


{&RT}
{=================================}
{== TRzCustomTabControl Methods ==}
{=================================}

const
  PolyFillMode = Integer( Alternate );      // DO NOT use TFillMode values
  MidRangeScrollBtnPosition = 1;
  ExtentAdjustment = 10;
  ScrollBtnMargin = 2;
  CRLF = #13#10;

  // These commands don't expect any data after the command
  cmd_Border         = 0;

  // These commands all expect data (2 additional items) after the command
  cmd_HasData        = 2;
  cmd_BorderColor    = 2;                     // Set frame border color
  cmd_MoveTo         = 3;
  cmd_LineTo         = 4;
  cmd_Shadow1_LineTo = 5;
  cmd_Shadow2_LineTo = 6;



constructor TRzCustomTabControl.Create( AOwner: TComponent );
begin
  inherited;
  Width := 300;
  Height := 100;

  ControlStyle := [ csAcceptsControls, csCaptureMouse, csClickEvents, csDoubleClicks ];
  FBuffer := TBitmap.Create;
  FBuffer.Width := Width;
  FBuffer.Height := Height;
  FCommands := TList.Create;
  FHotTrackIndex := -1;
  FDoneTabIndexDefault := False;
  FFocusRectBrushColor := clBtnFace;
  FHFonts := TList.Create;
  FRowExtent := 1;
  FTabDataList := TRzTabDataList.Create;

  // For speed: Create FCalcTextExtentLines and FDrawTabTextLines in advance so
  //            we won't need to test if they are nil prior to use.
  FCalcTextExtentLines := TStringList.Create;
  FDrawTabTextLines := TStringList.Create;

  FTextFont := TFont.Create;

  // Ctl3D is already True -- setting again/explicitly would mess up ParentCtl3D

  TabStop := True;

  // Declare default property values -- some are unecessary (e.g. where False or
  // first enumerated value) but are included for clarity
  FAlignTabs := False;
  FBackgroundColor := clBtnFace;
  FBoldCurrentTab := False;
  FShowCard := True;
  FShowCardFrame := True;
  FShowFullFrame := True;
  FUseColoredTabs := False;
  FCutCornerSize := 6;
  FShowFocusRect := True;

  FFlatColor := clBtnShadow;
  FFlatColorAdjustment := 0;

  FImagePosition := ipLeft;
  FImageAlignment := haCenter;
  FImageMargin := 2;
  FImageAlignmentVertical := vaCenter;
  {&RCI}

  FHotTrack := True;
  FHotTrackColor := clHighlight;
  FHotTrackColorType := htctComplement;
  FHotTrackStyle := htsTab;

  FMargin := 0;
  FMultiLine := False;
  FParentBackgroundColor := True;
  FRowIndent := 5;
  FRowOverlap := 5;
  FScrollBtnArrowColor := clBtnText;
  FScrollBtnFaceColor := clBtnFace;
  FTextOrientation := orHorizontal;

  FTabColors := TRzTabColors.Create( Self );

  FTabHeight := 0;
  FTabHints := False;
  FTabIndex := -1;
  FTabIndexDefault := 0;
  FTabOrientation := toTop;
  FTabRegionCacheSize := OptimumTabRegionCacheSize;
  FTabSequence := tsStandard;
  FTabStyle := tsSingleSlant;
  FTabWidth := 0;

  FTextColors := TRzTextColors.Create( Self );
  FTextAlignment := haCenter;
  FTextAlignmentVertical := vaCenter;

  FTransparent := False;
  FUseGradients := True;
  FShowShadow := True;

  FImagesChangeLink := TChangeLink.Create;
  FImagesChangeLink.OnChange := ImageListChange;

  // Create tab region cache, now that FTabRegionCacheSize has been set
  FTabRegionCache := TRzTabRegionCache.Create;
  FTabRegionCache.Capacity := FTabRegionCacheSize;
  SetCalcNeeded( True );
end;


procedure TRzCustomTabControl.CreateParams( var Params: TCreateParams );
begin
  inherited;

  Params.WindowClass.Style := Params.WindowClass.Style and not ( CS_HREDRAW or CS_VREDRAW );
end;


destructor TRzCustomTabControl.Destroy;
begin
  CancelHotTrackTimer;
  FTabDataList.Free;
  FTabRegionCache.Free;
  FCommands.Free;
  FBuffer.Free;
  FHFonts.Free;

  FTextFont.Free;
  FCalcTextExtentLines.Free;
  FDrawTabTextLines.Free;

  FTabColors.Free;
  FTextColors.Free;

  FImagesChangeLink.Free;

  inherited;
end;


procedure TRzCustomTabControl.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if ( Operation = opRemove ) and ( AComponent = FImages ) then
    SetImages( nil );
end;


procedure TRzCustomTabControl.DefineProperties( Filer: TFiler );
begin
  inherited;
  Filer.DefineProperty( 'FixedDimension', ReadFixedDimension, WriteFixedDimension, True );
end;


procedure TRzCustomTabControl.ReadFixedDimension( Reader: TReader );
begin
  FFixedDimension := Reader.ReadInteger;
end;


procedure TRzCustomTabControl.WriteFixedDimension( Writer: TWriter );
begin
  Writer.WriteInteger( FFixedDimension );
end;


function TRzCustomTabControl.GetTabDataList: TRzTabDataList;
begin
  Result := FTabDataList;
end;


procedure TRzCustomTabControl.InvalidateControl;
begin
  FHotTracking := False;
  Invalidate;
end;


procedure TRzCustomTabControl.Paint;
var
  Handled: Boolean;
  ARect: TRect;
  BrushHandle: HBrush;

begin
  FDoneTabIndexDefault := True;
  CheckCalcNeeded;
  if ( Width <> FBuffer.Width ) or ( Height <> FBuffer.Height ) then
  begin
    FBuffer.Width := Width;
    FBuffer.Height := Height;
  end;

  // It is necessary to init the buffer's brush to prevent 'silent' errors
  // (which only show in a debug/log output window) from being caused *sometimes*
  // when we assign new brush colors later.  (Error is raised by
  // TResourceManager.FreeResource in Graphics, but don't know why?)

  FBuffer.Canvas.Brush.Handle := GetStockObject( BLACK_BRUSH );

  // Erase background
  ARect := CalcWholeRect;

  // expand right and bottom sides to include edge
  Inc( ARect.Right );
  Inc( ARect.Bottom );
  Handled := False;

  PaintBackground( FBuffer.Canvas, ARect, Handled );

  if not Handled then
  begin
    if FTransparent then
    begin
      DrawParentImage( Self, FBuffer.Canvas );
    end
    else
    begin
      BrushHandle := CreateSolidBrush( ColorToRGB( FBackgroundColor ) );
      FillRect( FBuffer.Canvas.Handle, ARect, BrushHandle );
      DeleteObject( BrushHandle );
    end;
  end;

  AlignCloseButton;
  AlignScroller;
  DrawTabs;

  // Copy buffer bitmap to control's canvas
  Canvas.CopyRect( ClientRect, FBuffer.Canvas, ClientRect );
end; {= TRzCustomTabControl.Paint =}



procedure TRzCustomTabControl.Rebuild;
begin
  SetCalcNeeded( True );
end;


procedure TRzCustomTabControl.SetCutCornerSize( Value: Integer );
begin
  if ( Value >= 0 ) and ( FCutCornerSize <> Value ) then
  begin
    FCutCornerSize := Value;
    if FTabStyle = tsCutCorner then
      Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetTabOrientation( Value: TRzTabOrientation );
begin
  if FTabOrientation <> Value then
  begin
    {&RV}
    FTabOrientation := Value;
    if not ( ( csLoading in ComponentState ) or ( csReading in ComponentState ) ) then
      Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetTabRegionCacheSize( Value: Integer );
begin
  if ( Value = -1 ) or ( Value >= 1 ) and ( FTabRegionCacheSize <> Value ) then
  begin
    FTabRegionCacheSize := Value;
    FTabRegionCache.Capacity := Value;
  end;
end;


procedure TRzCustomTabControl.SetTabStyle( Value: TRzTabStyle );
begin
  if FTabStyle <> Value then
  begin
    FTabStyle := Value;
    Rebuild;
  end;
  {&RV}
end;


procedure TRzCustomTabControl.SetTextOrientation( Value: TOrientation );
begin
  if FTextOrientation <> Value then
  begin
    FTextOrientation := Value;
    if not ( csLoading in ComponentState ) and not IsTrueTypeFont( Font ) then
      Font.Name := 'Verdana';  // Switch to Verdana if current font is not TrueType
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetTabSequence( Value: TRzTabSequence );
begin
  if FTabSequence <> Value then
  begin
    FTabSequence := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetTabHeight( Value: Integer );
begin
  if ( Value >= 0 ) and ( FTabHeight <> Value ) then
  begin
    FTabHeight := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetTabWidth( Value: Integer );
begin
  if ( Value >= 0 ) and ( FTabWidth <> Value ) then
  begin
    FTabWidth := Value;
    Rebuild;
  end;
end;


// The scroll buttons are only needed if the total width of all tabs
// is > the tab index width.

procedure TRzCustomTabControl.CalcScrollerNeeded;
var
  FirstTab, LastTab: TRzTabData;
  FirstVisibleIdx, IndexWidth: Integer;
begin
  FScrollerNeeded := False;
  if FMultiLine then
    Exit;
  FirstVisibleIdx := GetFirstVisible;
  if ( FirstVisibleIdx >= 0 ) then
  begin
    FirstTab := FTabDataList[ FirstVisibleIdx ];
    LastTab := FTabDataList[ GetLastVisible ];
    IndexWidth := GetIndexWidth - ( FMargin * 2 );
    if FShowCloseButton then
      Dec( IndexWidth, GetCloseButtonSize );
    FScrollerNeeded := ( FTabDataList.Count > 0 ) and ( ( FTabSequence = tsStandard ) and
                       ( LastTab.RawRect.Right > IndexWidth ) ) or ( ( FTabSequence = tsReverse ) and
                       ( FirstTab.RawRect.Right > IndexWidth ) );
  end;
end;


procedure TRzCustomTabControl.AlignScroller;
var
  R: TRect;
  L, T, W, H: Integer;
  BtnSize: Integer;
begin
  if not ( ( csLoading in ComponentState ) or ( csReading in ComponentState ) ) then
  begin
    if FScrollerNeeded then
    begin
      if FScroller = nil then
        CreateScroller;
      FScroller.Visible := True;
    end
    else
    begin
      if FScroller <> nil then
      begin
        // Using Hide doesn't work at design-time; use trickery!
        W := FScroller.Width;
        H := FScroller.Height;
        FScroller.SetBounds( -1 - W, -1 - H, W, H );
      end;
      Exit;
    end;

    // Scroller is needed; determine appropriate size and position

    R := GetIndexRect;
    BtnSize := GetScrollerSize;

    if FTabOrientation in [ toTop, toBottom ] then
    begin
      H := BtnSize;
      W := BtnSize * 2 - 1;                     // two buttons
    end
    else
    begin
      H := BtnSize * 2 - 1;                     // two buttons
      W := BtnSize;
    end;
    L := 0;
    T := 0;

    if FTabSequence = tsStandard then
    begin
      case FTabOrientation of
        toTop:
        begin
          if FShowShadow then
            L := R.Right - W - 1
          else
            L := R.Right - W + 1;
          if FShowCloseButton then
            Dec( L, GetCloseButtonSize + ScrollBtnMargin + Margin )
          else
            Dec( L, Margin );
          T := R.Bottom - H - ScrollBtnMargin;
        end;

        toBottom:
        begin
          L := R.Right - W + 1;
          if FShowCloseButton then
            Dec( L, GetCloseButtonSize + ScrollBtnMargin + Margin)
          else
            Dec( L, Margin );
          T := R.Top + ScrollBtnMargin;
        end;

        toLeft:
        begin
          L := R.Right - W - ScrollBtnMargin;
          T := R.Top;
          if FShowCloseButton then
            Inc( T, GetCloseButtonSize + ScrollBtnMargin + Margin )
          else
            Inc( T, Margin );
        end;

        toRight:
        begin
          L := R.Left + ScrollBtnMargin;
          T := R.Bottom - H + 1;
          if FShowCloseButton then
            Dec( T, GetCloseButtonSize + ScrollBtnMargin + Margin )
          else
            Dec( T, Margin );
        end;
      end;
    end
    else // FTabSequence = tsReverse
    begin
      case FTabOrientation of
        toTop:
        begin
          L := R.Left;
          if FShowCloseButton then
            Inc( L, GetCloseButtonSize + ScrollBtnMargin + Margin )
          else
            Inc( L, Margin );
          T := R.Bottom - H - ScrollBtnMargin;
        end;

        toBottom:
        begin
          L := R.Left;
          if FShowCloseButton then
            Inc( L, GetCloseButtonSize + ScrollBtnMargin + Margin )
          else
            Inc( L, Margin );
          T := R.Top + ScrollBtnMargin;
        end;

        toLeft:
        begin
          L := R.Right - W - ScrollBtnMargin;
          T := R.Bottom - H + 1;
          if FShowCloseButton then
            Dec( T, GetCloseButtonSize + ScrollBtnMargin + Margin )
          else
            Dec( T, Margin );
        end;

        toRight:
        begin
          L := R.Left + ScrollBtnMargin;
          T := R.Top;
          if FShowCloseButton then
            Inc( T, GetCloseButtonSize + ScrollBtnMargin + Margin )
          else
            Inc( T, Margin );
        end;
      end;
    end;

    if FTabOrientation in [ toTop, toBottom ] then
      FScroller.Orientation := orHorizontal
    else
      FScroller.Orientation := orVertical;

    FScroller.SetBounds( L, T, W, H );
    FScroller.Visible := True;
  end;
end; {= TRzCustomTabControl.AlignScroller =}


procedure TRzCustomTabControl.AlignCloseButton;
var
  R: TRect;
  L, T, W, H: Integer;
  BtnSize: Integer;
begin
  if not ( ( csLoading in ComponentState ) or ( csReading in ComponentState ) ) then
  begin
    if not FShowCloseButton then
      Exit;

    R := GetIndexRect;
    BtnSize := GetCloseButtonSize;

    L := 0;
    T := 0;
    H := BtnSize;
    W := BtnSize;

    if FTabSequence = tsStandard then
      case FTabOrientation of
        toTop:
        begin
          if FShowShadow then
            L := R.Right - W - 1 - Margin
          else
            L := R.Right - W + 1 - Margin;
          T := R.Bottom - H - ScrollBtnMargin;
        end;

        toBottom:
        begin
          L := R.Right - W + 1 - Margin;
          T := R.Top + ScrollBtnMargin;
        end;

        toLeft:
        begin
          L := R.Right - W - ScrollBtnMargin;
          T := R.Top + Margin;
        end;

        toRight:
        begin
          L := R.Left + ScrollBtnMargin;
          T := R.Bottom - H + 1 - Margin;
        end;
      end
    else                                    { tsReverse }
      case FTabOrientation of
        toTop:
        begin
          L := R.Left + Margin;
          T := R.Bottom - H - ScrollBtnMargin;
        end;

        toBottom:
        begin
          L := R.Left + Margin;
          T := R.Top + ScrollBtnMargin;
        end;

        toLeft:
        begin
          L := R.Right - W - ScrollBtnMargin;
          T := R.Bottom - H + 1 - Margin;
        end;

        toRight:
        begin
          L := R.Left + ScrollBtnMargin;
          T := R.Top + Margin;
        end;
      end;

    FCloseButton.SetBounds( L, T, W, H );
    FCloseButton.Visible := True;
  end;
end; {= TRzCustomTabControl.AlignCloseButton =}


procedure TRzCustomTabControl.AlignControls( AControl: TControl; var Rect: TRect );
begin
  AlignCloseButton;
  AlignScroller;
  Rect := DisplayRect;
  FPrevDisplayRect := Rect;
  inherited;
end;


procedure TRzCustomTabControl.Loaded;
begin
  inherited;
  FOriginalHint := Hint;                    // Remember control's original Hint value
  SetCalcNeeded( True );
  if FTabIndexDefault <> FTabIndex then
    FTabIndex := FTabIndexDefault;

  if ( FTextOrientation = orVertical ) and not IsTrueTypeFont( Font ) then
    Font.Name := 'Verdana';  // Switch to Verdana if current font is not TrueType

  // Now that tabs have been loaded, set TabIndex to check validity
  SetTabIndex( FTabIndex );
end;


function TRzCustomTabControl.GetLastVisible: Integer;
var
  TabData: TRzTabData;
begin
  Result := FTabDataList.Count - 1;
  while ( Result >= 0 ) do
  begin
    TabData := FTabDataList[ Result ];
    if TabData.Visible then
      Break
    else
      Dec( Result );
  end;
end;


function TRzCustomTabControl.GetFirstVisible: Integer;
var
  TabData: TRzTabData;
  Idx: Integer;
begin
  Result := -1;
  Idx := 0;
  while Idx < FTabDataList.Count do
  begin
    TabData := FTabDataList[ Idx ];
    if TabData.Visible then
    begin
      Result := Idx;
      Break;
    end;
    Inc( Idx );
  end;
end;


function TRzCustomTabControl.GetExtraTopMargin: Integer;
begin
  if ( FTabStyle = tsRoundCorners ) then
    Result := 3
  else
    Result := 0;
end;


function TRzCustomTabControl.GetIndexHeight;
var
  Adjustment: Integer;
begin
  if FShowCard then
    Result := FFixedDimension + ( ( FFixedDimension - FRowOverlap ) * ( FRowExtent - 1 ) ) + GetExtraTopMargin
  else
  begin
    if ( FTabOrientation in [ toTop, toBottom ] ) then
      Result := Height - 1
    else
      Result := Width - 1;

    Adjustment := 0;
    if FTabStyle = tsRoundCorners then
    begin
      if FTabOrientation in [ toBottom, toRight ] then
        Inc( Adjustment, 1 );
    end;
    Dec( Result, Adjustment );
  end;
end;


function TRzCustomTabControl.GetIndexWidth;
var
  IndexRect: TRect;
begin
  IndexRect := GetIndexRect;
  if FTabOrientation in [ toTop, toBottom ] then
    Result := IndexRect.Right - IndexRect.Left
  else
    Result := IndexRect.Bottom - IndexRect.Top;
end;


// Return the rect for the area where the tabs are displayed.

function TRzCustomTabControl.GetIndexRect: TRect;
var
  WholeRect, IndexRect: TRect;
  IndexHeight: Integer;
  L, T, R, B, W, H: Integer;
begin
  WholeRect := Rect( 0, 0, Width - 1, Height - 1 );
  IndexHeight := GetIndexHeight;
  W := WholeRect.Right - WholeRect.Left;
  H := WholeRect.Bottom - WholeRect.Top;

  if FTabOrientation = toRight then
    L := W - IndexHeight
  else
    L := 0;
  if FTabOrientation = toBottom then
    T := H - IndexHeight
  else
    T := 0;
  if FTabOrientation = toLeft then
    R := IndexHeight
  else
    R := W;
  if FTabOrientation = toTop then
    B := IndexHeight
  else
    B := H;

  if ( FTabOrientation = toTop ) and FShowShadow then
    Dec( R, 2 );

  IndexRect := Rect( L, T, R, B );
  Result := IndexRect;
end;


function TRzCustomTabControl.GetDisplayRect: TRect;
begin
  if FShowCard then
  begin
    Result := CalcMappedCardRect( 0 );
    if FShowCardFrame then
    begin
      if FShowFullFrame then
      begin
        Inc( Result.Left );
        Inc( Result.Top );
        if ( FTabOrientation = toTop ) and ( FTabSequence = tsStandard ) and FShowShadow then
        begin
          Dec( Result.Right, 2 );
          Dec( Result.Bottom, 2 );
        end;
      end
      else
      begin
        if FTabOrientation <> toRight then
          Inc( Result.Top );
        Inc( Result.Right );
        Inc( Result.Bottom );
      end;
    end
    else
    begin
      Inc( Result.Right );
      Inc( Result.Bottom );
    end;
  end
  else                                      { no client-area }
  begin
    // Must return a rect which is not empty (0,0,0,0), otherwise
    // AlignControls will just ignore the DisplayRect, so return
    // a rect which is outside the visible area instead

    Result := Rect( -2, -2, -1, -1 );
  end;
end; {= TRzCustomTabControl.GetDisplayRect =}


function TRzCustomTabControl.CalcWholeRect: TRect;
var
  ARect: TRect;
begin
  // ClientRect cannot be used if control is being created and has no window handle yet.

  if HandleAllocated then
    ARect := ClientRect
  else
    ARect := Rect( 0, 0, Width, Height );

  Result := Rect( 0, 0, ARect.Right - 1, ARect.Bottom - 1 );
end;


// Return the rect for the card corresponding to the specified row of tabs.

function TRzCustomTabControl.CalcMappedCardRect( ARow: Integer ): TRect;
var
  ARect: TRect;
  L, T, R, B: Integer;
  TopAdj, BottomAdj, LeftAdj, RightAdj: Integer;

  // AdjustCardRect changes the specified rect so that the 'sides' and 'bottom'
  // are beyond the control's boundaries and won't be seen.
  // By faking the card rect so that the 'sides' and 'bottom' are actually
  // outside the control's bounds we will only get the 'top' of the card drawn
  // and don't need to redraw to eliminate the unwanted frame portions and also
  // don't need to use additional drawing to fix up the joins on each end of the
  // 'top' line.

  procedure AdjustCardRect( var ARect: TRect );
  const
    Adjustment: Integer = 3;                // sufficient for max. bevel depth + border
  var
    WholeRect: TRect;
  begin
    WholeRect := CalcWholeRect;
    case FTabOrientation of
      toTop:
      begin
        ARect.Left := WholeRect.Left - Adjustment;
        ARect.Right := WholeRect.Right + Adjustment;
        ARect.Bottom := WholeRect.Bottom + Adjustment;
      end;

      toBottom:
      begin
        ARect.Left := WholeRect.Left - Adjustment;
        ARect.Right := WholeRect.Right + Adjustment;
        ARect.Top := WholeRect.Top - Adjustment;
      end;

      toLeft:
      begin
        ARect.Right := WholeRect.Right + Adjustment;
        ARect.Top := WholeRect.Top - Adjustment;
        ARect.Bottom := WholeRect.Bottom + Adjustment;
      end;

      toRight:
      begin
        ARect.Left := WholeRect.Left - Adjustment;
        ARect.Top := WholeRect.Top - Adjustment;
        ARect.Bottom := WholeRect.Bottom + Adjustment;
      end;
    end;
  end; {= AdjustCardRect =}

begin {= TRzCustomTabControl.CalcMappedCardRect =}
  ARect := CalcWholeRect;
  if ( FTabDataList.Count = 0 ) and FShowCard then
  begin
    Result := ARect;
    Exit;
  end;
  L := ARect.Left;
  T := ARect.Top;
  R := ARect.Right;
  B := ARect.Bottom;

  // CalcMapRect (or more correctly, CalcMapPoint) can't be used to map the card
  // rect, so we need to work out the rect for the appropriate orientation and
  // tab sequence.

  TopAdj := GetIndexHeight - ( ( FFixedDimension - FRowOverlap ) * ARow );
  BottomAdj := ( FFixedDimension - FRowOverlap ) * ARow;
  LeftAdj := ( FRowIndent * ARow );
  RightAdj := FRowIndent * ( FRowExtent - ARow - 1 );

  if FTabSequence = tsStandard then
  begin
    case FTabOrientation of
      toTop:
      begin
        Inc( T, TopAdj );
        Dec( B, BottomAdj );
        Inc( L, LeftAdj );
        Dec( R, RightAdj );
      end;

      toBottom:
      begin
        Inc( T, BottomAdj );
        Dec( B, TopAdj );
        Inc( L, LeftAdj );
        Dec( R, RightAdj );
      end;

      toLeft:
      begin
        Inc( T, RightAdj );
        Dec( B, LeftAdj );
        Inc( L, TopAdj );
        Dec( R, BottomAdj );
      end;

      toRight:
      begin
        Inc( T, LeftAdj );
        Dec( B, RightAdj );
        Inc( L, BottomAdj );
        Dec( R, TopAdj );
      end;
    end;
  end
  else
  begin
    case FTabOrientation of
      toTop:
      begin
        Inc( T, TopAdj );
        Dec( B, BottomAdj );
        Inc( L, RightAdj );
        Dec( R, LeftAdj );
      end;

      toBottom:
      begin
        Inc( T, BottomAdj );
        Dec( B, TopAdj );
        Inc( L, RightAdj );
        Dec( R, LeftAdj );
      end;

      toLeft:
      begin
        Inc( T, LeftAdj );
        Dec( B, RightAdj );
        Inc( L, TopAdj );
        Dec( R, BottomAdj );
      end;

      toRight:
      begin
        Inc( T, RightAdj );
        Dec( B, LeftAdj );
        Inc( L, BottomAdj );
        Dec( R, TopAdj );
      end;
    end;
  end;

  Result := Rect( L, T, R, B );

  if ( L > R ) or ( T > B ) then            // Tabs are oversized -- shrink card rect
    Result := Rect( 0, 0, 0, 0 )
  else if not FShowCard then
    AdjustCardRect( Result );
end; {= TRzCustomTabControl.CalcMappedCardRect =}


function TRzCustomTabControl.GetScrollerSize: Integer;
begin
  SelectFont;
  Result := CalcTextExtent( 'A', True ).cY;

  DeselectFont;
  if FTextOrientation = orVertical then
    Inc( Result, 2 )
  else
    Inc( Result, 4 );

  // Check if larger than fixed dimension

  if FTabOrientation in [ toTop, toBottom ] then
  begin
    if ( FTextOrientation = orHorizontal ) and ( FTabHeight > 0 ) then
      Result := Max( Result, FFixedDimension - 2 )
    else
      Result := Min( Result, FFixedDimension - 2 );
  end
  else // FTabOrientation in [ toLeft, toRight ]
  begin
    if ( FTextOrientation = orVertical ) and ( FTabWidth > 0 ) then
      Result := Max( Result, FFixedDimension - 2 )
    else
      Result := Min( Result, FFixedDimension - 2 );
  end;
end;


function TRzCustomTabControl.GetCloseButtonSize: Integer;
begin
  if FShowCloseButton and ( FTabDataList.Count > 0 ) then
    Result := GetScrollerSize
  else
    Result := 0;
end;


procedure TRzCustomTabControl.DrawTabs;
var
  I: Integer;
  TabData: TRzTabData;
  FirstTabIdx: Integer;
  LastTabIdx: Integer;
  PrevRow: Integer;

  function FindFirstTabIdx: Integer;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to FTabDataList.Count - 1 do
    begin
      TabData := FTabDataList[ I ];
      if TabData.Visible and ( TabData.Row = 0 ) then
      begin
        Result := I;
        Break;
      end;
    end;
  end;

  procedure DrawTab( ATabIndex: Integer );
  var
    R1, R2: TRect;
    Region: hRgn;
    TabData: TRzTabData;
    ARect: TRect;

    // Draw tab outline
    procedure DrawTabShape( ATabIndex: Integer );
    var
      APoint: TPoint;
    begin
      FCommands.Clear;
      // store information for frame item and aspect a point string
      APoint.X := 0{Ord( fiTab )};             // Item is tab
      APoint.Y := ATabIndex;                // Aspect is the tab being drawn
      AddCommandPt( cmd_BorderColor, APoint );
      CalcTabDrawCommands( ATabIndex {, Commands} );
      ProcessCommands;
    end;

  begin {= DrawTab =}
    TabData := FTabDataList[ ATabIndex ];
    ARect := CalcMappedTabRect( ATabIndex, TabData );

    R1 := FBuffer.Canvas.ClipRect;          // area of canvas being redrawn
    R2 := ARect;                            // assume ARect already ordered (required for IntersectRect)

    // check if this tab is inside the area being drawn, note that
    // IntersectRect return value for Delphi 1 must be converted to Boolean

    if not Bool( IntersectRect( R1, R1, R2 ) ) then
      Exit;                                 // no intersection; don't draw

    // restrict tab drawing to within the tab's region
    Region := CalcTabRegion( ATabIndex, ARect );
    if Region <> 0 then                     // region was created
    begin
      // save DC so that region can be de-activated later
      if SaveDC( FBuffer.Canvas.Handle ) = 0 then
        raise Exception.Create( sRzSavingDCError );

      // Note: When a region is selected using SelectObject, the result is not
      //       the old region, i.e. don't save/restore value returned by
      //       SelectObject.

      SelectObject( FBuffer.Canvas.Handle, Region );
      try
        // Fill the background of the tab (inside the region)
        DrawTabBackground( ATabIndex, ARect );
        // Draw the tab caption & image
        DrawTabFace( ATabIndex, ARect );
      finally
        // De-activate clipping region
        if RestoreDC( FBuffer.Canvas.Handle, -1 ) = WordBool( 0 ) then
          raise Exception.Create( sRzRestoringDCError );
      end;
    end;

    // Now draw tab shape -- this is not done until the region is deselected so
    // that the bottom and right edges, which are not included within regions,
    // will be drawn

    DrawTabShape( ATabIndex );
  end; {= DrawTab =}


  procedure DrawCard( ARow: Integer );
  var
    ARect: TRect;
    Handled: Boolean;
    BrushColor: TColor;

    // ARow is the row of tabs, where row 0 is the first, row 1 the second etc.
    procedure DrawCardShape( ARow: Integer );
    var
      APoint: TPoint;
    begin
      { draw card outline }
      FCommands.Clear;
      { store information for frame item and aspect as a point string }
      APoint.X := 1{Ord( fiCard )};
      APoint.Y := ARow;
      AddCommandPt( cmd_BorderColor, APoint );
      CalcCardDrawCommands( ARow );
      ProcessCommands;
    end;

  begin {= DrawCard =}
    ARect := CalcMappedCardRect( ARow );
    if not IsRectZero( ARect ) then
    begin
      if FShowCard then
      begin
        // Expand right and bottom edges (which aren't included by FillRect)
        Inc( ARect.Right );
        Inc( ARect.Bottom );
      end;
      Handled := False;
      PaintCardBackground( FBuffer.Canvas, ARow, ARect, Handled );
      if not Handled then
      begin
        // Fill the specified card with the appropriate color
        if FUseColoredTabs and ( FTabIndex >= 0 ) then
        begin
          BrushColor := FTabDataList[ FTabIndex ].Color;

          // 3.0.9 - The following code is only called when in multi-line mode, and multiple rows are visible. However,
          // setting the Color property causes all tabs in the control to take on the color of the active tab.
          (*
          // Change color of self to match the current tab -- this is OK to do
          // within Paint processing because we have a special CMColorChanged
          // handler which doesn't Invalidate (again)
          Color := BrushColor;
          *)
        end
        else
          BrushColor := Color;
        FBuffer.Canvas.Brush.Color := BrushColor;
        FBuffer.Canvas.FillRect( ARect );
      end;

      // Now draw card frame onto card's background
      if FShowCardFrame then
        DrawCardShape( ARow );
    end;
  end; {= DrawCard =}

begin {= TRzCustomTabControl.DrawTabs =}
  if FTabDataList.Count >= 1 then
  begin
    // Draw tabs other than the current one; start with the last and go
    // through to the first (painter's algorithm) -- this ensures they overlap
    //  each other correctly without having to worrying about explicitly drawing joins

    FirstTabIdx := FindFirstTabIdx;
    if FirstTabIdx = 0 then
      LastTabIdx := FTabDataList.Count - 1
    else
      LastTabIdx := FirstTabIdx - 1;
    I := LastTabIdx;
    PrevRow := FRowExtent - 1;

    repeat
      TabData := FTabDataList[ I ];
      if TabData.Visible then
      begin
        if TabInView( TabData ) and ( I >= FFirstInView ) and ( I <> FTabIndex ) then
        begin
          if ( TabData.Row < PrevRow ) and ( PrevRow > 0 ) then
          begin
            // Tab is in a new row, draw the card for previous row of tabs
            DrawCard( PrevRow );
            PrevRow := TabData.Row;
          end;
          DrawTab( I );
        end;
      end;
      if I > 0 then
        Dec( I )
      else
        I := FTabDataList.Count - 1;
    until ( I = LastTabIdx );               // Same tab that we started on
    if ( PrevRow = 1 ) then                 // Penultimate card hasn't been drawn yet
      DrawCard( 1 );
  end;

  // Draw current tab if in view -- the current tab is drawn last so that it is
  // always 'on top of' the other tabs

  if ( FTabIndex >= 0 ) and ( FTabIndex >= FFirstInView ) then
  begin
    TabData := FTabDataList[ FTabIndex ];
    if TabInView( TabData ) then
    begin
      DrawTab( FTabIndex );
    end;
  end;
  DrawCard( 0 );                            // Front card
end; {= TRzCustomTabControl.DrawTabs =}


// Return the offset to the 'initial' edge of the initial tab's raw tab rect.
// Only relevant when MultiLine = False (i.e. initial tab may not be the
// first tab due to having scrolled).
//
// tsStandard: The left side of the initial tab's raw tab rect is
//           aligned with the left side of the raw index rect.
//
// tsReverse: The right side of the initial tab's raw tab rect is
//           aligned with the right side of the raw index rect.

function TRzCustomTabControl.GetInitialTabOffset: Integer;
var
  TabData: TRzTabData;
  Adjust: Integer;
begin
  TabData := FTabDataList[ FFirstInView ];
  if FTabStyle = tsRoundCorners then
    Adjust := 2
  else
    Adjust := 0;
  Inc( Adjust, FMargin );
  if FTabSequence = tsStandard then
    Result := TabData.RawRect.Left - Adjust
  else
    Result := TabData.RawRect.Right + Adjust;
end;


// Assume: Tab's clipping region has already been selected.
procedure TRzCustomTabControl.DrawTabBackground( ATabIndex: Integer; const ARect: TRect );
var
  Handled: Boolean;
  BrushColor, UnselColor, ShadowColor: TColor;
begin
  Handled := False;
  PaintTabBackground( FBuffer.Canvas, ATabIndex, ARect, Handled );
  if not Handled then
  begin
    // Fill the specified tab with the appropriate color
    if FUseColoredTabs then
    begin
      BrushColor := FTabDataList[ ATabIndex ].Color;
      UnselColor := FTabDataList[ ATabIndex ].Color;
      ShadowColor := DarkerColor( UnselColor, 30 );
    end
    else
    begin
      BrushColor := Color;
      UnselColor := FTabColors.Unselected;
      ShadowColor := FTabColors.Shadow;
    end;


    if ATabIndex = FTabIndex then
    begin
      FBuffer.Canvas.Brush.Color := BrushColor;
      FBuffer.Canvas.FillRect( ARect );
    end
    else
    begin
      if FUseGradients and FullColorSupport then
      begin
        case FTabOrientation of
          toTop:
            PaintGradient( FBuffer.Canvas, ARect, gdHorizontalEnd, UnselColor, ShadowColor );
          toLeft:
            PaintGradient( FBuffer.Canvas, ARect, gdVerticalEnd, UnselColor, ShadowColor );
          toBottom:
            PaintGradient( FBuffer.Canvas, ARect, gdHorizontalEnd, ShadowColor, UnselColor );
          toRight:
            PaintGradient( FBuffer.Canvas, ARect, gdVerticalEnd, ShadowColor, UnselColor );
        end;
      end
      else
      begin
        FBuffer.Canvas.Brush.Color := UnselColor;
        FBuffer.Canvas.FillRect( ARect );
      end;
    end;
  end;
  // Save color of brush for use later when drawing focus rect of current tab
  FFocusRectBrushColor := FBuffer.Canvas.Brush.Color;
end;


// DoTextOut
//
// Wrapper for TextOut call.
// This method is used to overcome the limitation of TextOut()
// (and ExtTextOut()) not automatically underlining the character prefixed
// by an ampersand in the string.
// Draws the text using the specified device context. If the text contains
// an ampersand (&) the following character will be underlined.
// If the text contains two successive ampersands (&&) then a single
// ampersand will be output.

procedure TRzCustomTabControl.DoTextOut( X, Y: Integer; const AString: string;
                                         ACanvas: TCanvas; Horizontal: Boolean; AColor: TColor );
var
  P1, P2: Integer;
  Part: array[ 0..2 ] of string;
  I, MaxPartIdx: Integer;
  Extent: TSize;
  RemoveUnderline: Boolean;
begin
  // Break the string up into parts: the part before the '&', the character
  // immediately after the '&' (which will be underlined), and the remainder

  MaxPartIdx := 2;
  P1 := Pos( '&', AString );
  if P1 > 0 then
  begin
    P2 := Pos( '&', Copy( AString, P1 + 1, Length( AString ) ) );
    if P2 = 1 then
      Inc( P2, P1 )
    else
      P2 := 0;
  end
  else
    P2 := 0;
  if ( P1 > 0 ) and ( P2 <> P1 + 1 ) then
  begin
    Part[ 0 ] := Copy( AString, 1, P1 - 1 );
    Part[ 1 ] := Copy( AString, P1 + 1, 1 );
    Part[ 2 ] := Copy( AString, P1 + 2, Length( AString ) );
  end
  else if ( P1 > 0 ) and ( P2 = P1 + 1 ) then // '&&' in string
  begin
    Part[ 0 ] := Copy( AString, 1, P1 );
    Part[ 1 ] := '';
    Part[ 2 ] := Copy( AString, P2 + 1, Length( AString ) );
  end
  else
  begin
    Part[ 0 ] := AString;
    Part[ 1 ] := '';
    Part[ 2 ] := '';
    MaxPartIdx := 0;                        // Highest part index used
  end;

  RemoveUnderline := False;

  // Output each part in the appropriate font (plain or underlined)
  for I := 0 to MaxPartIdx do
  begin
    if I = 1 then
    begin
      // Underlined part of text
      if not ( fsUnderline in FTextFont.Style ) then
      begin
        FTextFont.Style := FTextFont.Style + [ fsUnderline ];
        RemoveUnderline := True;
      end
    end
    else
    begin
      if RemoveUnderline then
        FTextFont.Style := FTextFont.Style - [ fsUnderline ];
    end;

    SelectFont;

    // Because we have selected our own font into the canvas we must explicitly
    // set the text color and background mode for the selected font

    SetTextColor( ACanvas.Handle, ColorToRGB( AColor ) );
    SetBkMode( ACanvas.Handle, Windows.TRANSPARENT );
    ACanvas.TextOut( X, Y, Part[ I ] );

    if MaxPartIdx > 0 then
    begin
      // Determine extent of part just output so position can be updated
      if Length( Part[ I ] ) > 0 then
      begin
        Extent := CalcTextExtent( Part[ I ], Horizontal );

        if FTextOrientation = orHorizontal then
          Inc( X, Extent.cX )
        else if FTabOrientation = toRight then
          Inc( Y, Extent.cY )
        else
          Dec( Y, Extent.cY );
      end;
    end;

    DeselectFont;
  end;
end; {= TRzCustomTabControl.DoTextOut =}


// Assume: Tab's clipping region has already been selected.

procedure TRzCustomTabControl.DrawTabFace( ATabIndex: Integer; const ARect: TRect );
var
  FaceRect: TRect;
  TabData: TRzTabData;
  ImageSize: TSize;
  ImageRect: TRect;
  TextRect: TRect;
  TextColor: TColor;
  Handled: Boolean;

  function GetTextRect: TRect;
  var
    Margin: Integer;
  begin
    Result := FaceRect;
    if TabData.ImageIndex = -1 then
      Margin := 0
    else
      Margin := FImageMargin;

    // FImagePosition specifies where image will be relative to text

    case FImagePosition of
      ipTop:
        Result.Top := Result.Top + ImageSize.cY + Margin;

      ipBottom:
        Result.Bottom := Result.Bottom - ImageSize.cY - Margin;

      ipLeft:
        Result.Left := Result.Left + ImageSize.cX + Margin;

      ipRight:
        Result.Right := Result.Right - ImageSize.cX - Margin;
    else
      { use all of FaceRect }
    end;
  end; {= GetTextRect =}


  function GetImageRect: TRect;
  begin
    Result := FaceRect;
    // FImagePosition specifies where image will be relative to text
    case FImagePosition of
      ipTop:
        Result.Bottom := Result.Top + ImageSize.cY;

      ipBottom:
        Result.Top := Result.Bottom - ImageSize.cY;

      ipLeft:
        Result.Right := Result.Left + ImageSize.cX;

      ipRight:
        Result.Left := Result.Right - ImageSize.cX;
    else
      // use all of FaceRect
    end;
  end; {= GetImageRect =}


  // AdjustTextRect
  //
  // Shrink TextRect to match the extent of the text in the direction
  // perpendicular to the direction in which the text runs, i.e.
  // if text is horizontal shrink TextRect in the vertical direction.

  procedure AdjustTextRect;
  var
    Extent: TSize;
    Margin: Integer;
  begin
    // Work out entire size of text and adjust text rect according to alignment
    Extent.cX := 0;
    Extent.cY := 0;
    if Length( TabData.Caption ) > 0 then
    begin
      Extent := CalcTextExtent( TabData.Caption, FTextOrientation = orHorizontal );
    end;

    if FTextOrientation = orVertical then
    begin
      if FTabOrientation = toRight then
      begin
        case TextAlignment of
          haCenter:
          begin
            Margin := ( TextRect.Right - TextRect.Left - Extent.cX ) div 2;
            TextRect.Left := TextRect.Left + Margin;
            TextRect.Right := TextRect.Right - Margin;
          end;

          haLeft:
            TextRect.Right := TextRect.Left + Extent.cX;

          //else
            // haRight - do nothing
        end;
      end
      else
      begin
        case TextAlignment of
          haCenter:
          begin
            Margin := ( TextRect.Right - TextRect.Left - Extent.cX ) div 2;
            TextRect.Left := TextRect.Left + Margin;
            TextRect.Right := TextRect.Right - Margin;
          end;

          haRight:
            TextRect.Left := TextRect.Right - Extent.cX;

          //else
            // haLeft - do nothing
        end;
      end
    end
    else
    begin
      case TextAlignmentVertical of
        vaCenter:
        begin
          Margin := ( TextRect.Bottom - TextRect.Top - Extent.cY ) div 2;
          TextRect.Top := TextRect.Top + Margin;
          TextRect.Bottom := TextRect.Bottom - Margin;
        end;

        vaBottom:
          TextRect.Top := TextRect.Bottom - Extent.cY;

        // else
          // vaTop - do nothing
      end;
    end;
  end; {= AdjustTextRect =}


  procedure DrawTabText( AColor: TColor; TextOffset: Integer );
  var
    OldStyle: TFontStyles;
    Lines: TStringList;
    I: Integer;
    Extent: TSize;
    XPos, YPos: Integer;
    XOffset, YOffset: Integer;
  begin
    OldStyle := FTextFont.Style;

    if ( ATabIndex = FTabIndex ) and FBoldCurrentTab then
      FTextFont.Style := FTextFont.Style + [ fsBold ];

    SelectFont;
    AdjustTextRect;

    // Re-use same list object to speed things up by not recreating each time
    // (which starts to add up when there are lots of tabs)

    Lines := FDrawTabTextLines;
    Lines.Clear;
    ParseTextLines( TabData.Caption, Lines );
    if Lines.Count = 0 then
      Exit;
    XOffset := 0;
    YOffset := 0;
    I := 0;
    repeat
      // Work out extent of current line and position within TextRect according to alignment
      Extent.cX := 0;
      Extent.cY := 0;
      if Length( Lines[ I ] ) > 0 then
      begin
        Extent := CalcTextExtent( Lines[ I ], FTextOrientation = orHorizontal );
      end;

      if FTextOrientation = orVertical then
      begin
        if FTabOrientation = toRight then
        begin
          case TextAlignmentVertical of
            vaCenter:
              YOffset := ( TextRect.Bottom - TextRect.Top - Extent.cY ) div 2;

            vaBottom:
              YOffset := TextRect.Bottom - TextRect.Top - Extent.cY;

            else                              { vaTop }
              YOffset := 0;
          end;
          XPos := TextRect.Right - XOffset;
          YPos := TextRect.Top + YOffset;
        end
        else
        begin
          case TextAlignmentVertical of
            vaTop:
              YOffset := TextRect.Bottom - TextRect.Top - Extent.cY;

            vaCenter:
              YOffset := ( TextRect.Bottom - TextRect.Top - Extent.cY ) div 2;

            else                              { vaBottom }
              YOffset := 0;
          end;
          XPos := TextRect.Left + XOffset;
          YPos := TextRect.Bottom - YOffset;
        end;
      end
      else
      begin
        case TextAlignment of
          haCenter:
            XOffset := ( TextRect.Right - TextRect.Left - Extent.cX ) div 2;

          haRight:
            XOffset := TextRect.Right - TextRect.Left - Extent.cX;

          else                                { haLeft }
            XOffset := 0;
        end;
        XPos := TextRect.Left + XOffset;
        YPos := TextRect.Top + YOffset;
      end;
      Inc( XPos, TextOffset );
      Inc( YPos, TextOffset );

      DoTextOut( XPos, YPos, Lines[ I ], FBuffer.Canvas, FTextOrientation = orHorizontal, AColor );

      // Update offset to be used for position of next line
      if FTextOrientation = orVertical then
      begin
        Inc( XOffset, Extent.cX );
        YOffset := 0;
      end
      else
      begin
        XOffset := 0;
        Inc( YOffset, Extent.cY );
      end;
      Inc( I );
    until I = Lines.Count;
    DeselectFont;
    FTextFont.Style := OldStyle;
  end; {= DrawTabText =}


  procedure DrawTabImage;
  var
    XOffset, YOffset: Integer;
  begin
    if ImagePosition <> ipStretch then
    begin
      case ImageAlignment of
        haCenter:
          XOffset := ( ImageRect.Right - ImageRect.Left - ImageSize.cX ) div 2;

        haRight:
          XOffset := ( ImageRect.Right - ImageRect.Left - ImageSize.cX );

        else // haLeft
          XOffset := 0;
      end;

      case ImageAlignmentVertical of
        vaCenter:
          YOffset := ( ImageRect.Bottom - ImageRect.Top - ImageSize.cY ) div 2;

        vaBottom:
          YOffset := ( ImageRect.Bottom - ImageRect.Top - ImageSize.cY );

        else // vaTop
          YOffset := 0;
      end;
      ImageRect.Left := ImageRect.Left + XOffset;
      ImageRect.Top := ImageRect.Top + YOffset;
      ImageRect.Right := ImageRect.Left + ImageSize.cX;
      ImageRect.Bottom := ImageRect.Top + ImageSize.cY;
    end;


    if FImages <> nil then
    begin
      if TabData.DisabledIndex <> -1 then
      begin
        if TabData.Enabled then
        begin
          if TabData.ImageIndex <> -1 then
            FImages.Draw( FBuffer.Canvas, ImageRect.Left, ImageRect.Top, TabData.ImageIndex );
        end
        else
          FImages.Draw( FBuffer.Canvas, ImageRect.Left, ImageRect.Top, TabData.DisabledIndex );
      end
      else if TabData.ImageIndex <> -1 then
        FImages.Draw( FBuffer.Canvas, ImageRect.Left, ImageRect.Top, TabData.ImageIndex, TabData.Enabled );
    end;
  end; {= DrawTabImage =}


  procedure DrawTabFocusRect;
  var
    FocusRect: TRect;
  begin
    // Inflate the face rect to get the focus rect
    FocusRect := TextRect;
    if FTabOrientation in [ toTop, toBottom ] then
      InflateRect( FocusRect, 1, 0 )
    else
      InflateRect( FocusRect, 0, 1 );

    if FTabStyle = tsRoundCorners then
    begin
      case FTabOrientation of
        toTop:    Inc( FocusRect.Top );
        toLeft:   Inc( FocusRect.Left, 2 );
        toBottom: Dec( FocusRect.Bottom );
        toRight:  Dec( FocusRect.Right, 2 );
      end;
    end;

    FBuffer.Canvas.DrawFocusRect( FocusRect );
  end;


  procedure DrawHotTrackedTab( Hot: Boolean );
  var
    OldColor: TColor;
    HotRect: TRect;
    TabData: TRzTabData;
    H: Byte;
  begin
    TabData := FTabDataList[ ATabIndex ];
    HotRect := CalcMappedTabRect( ATabIndex, TabData );
    InflateRect( HotRect, 1, 1 );

    OldColor := FBuffer.Canvas.Brush.Color;
    if Hot then
    begin
      if HotTrackColorType = htctComplement then
      begin
        H := ColorHue( FHotTrackColor );
        if H >= 120 then
          H := H - 120
        else
          H := H + 120;
        FBuffer.Canvas.Brush.Color := HSLToColor( H, 240, 140 );
      end
      else // if htctActual
      begin
        FBuffer.Canvas.Brush.Color := FHotTrackColor;
      end;
    end
    else
      FBuffer.Canvas.Brush.Color := FTabColors.HighlightBar;
    FBuffer.Canvas.Pen.Style := psClear;

    case FTabOrientation of
      toTop:    HotRect.Bottom := HotRect.Top + 6;
      toLeft:   HotRect.Right := HotRect.Left + 6;
      toBottom: HotRect.Top := HotRect.Bottom - 4;
      toRight:  HotRect.Left := HotRect.Right - 4;
    end;

    FBuffer.Canvas.Rectangle( HotRect.Left, HotRect.Top, HotRect.Right, HotRect.Bottom );

    FBuffer.Canvas.Pen.Style := psSolid;
    FBuffer.Canvas.Brush.Color := OldColor;
  end; {= DrawHotTrackedTab =}

begin {= TRzCustomTabControl.DrawTabFace =}
  TabData := FTabDataList[ ATabIndex ];
  FaceRect := CalcTabFaceRect( ARect );
  ImageSize := CalcImageExtent( TabData.ImageIndex );
  TextRect := GetTextRect;
  ImageRect := GetImageRect;
  if ( FImages <> nil ) and ( TabData.ImageIndex <> -1 ) then
    DrawTabImage;
  Handled := False;

  // Note: OnGetTextColor events are performed even if caption is ''
  // so that TextColor is initialised prior to calling DrawTabFocusRect.

  if TabData.Enabled then
  begin
    if FHotTrack and ( ATabIndex = FHotTrackIndex ) then
    begin
      GetTextColor( ATabIndex, tsHotTrack, TextColor, Handled );
      if not Handled then
      begin
        if FHotTrackStyle = htsText then
          TextColor := FHotTrackColor
        else
          TextColor := FTextColors.Selected;
      end;

      if FHotTrackStyle = htsTab then
        DrawHotTrackedTab( True );
    end
    else if ATabIndex = FTabIndex then
    begin
      GetTextColor( ATabIndex, tsSelected, TextColor, Handled );
      if not Handled then
        TextColor := FTextColors.Selected;

      if FHotTrack and ( FHotTrackStyle = htsTab ) then
        DrawHotTrackedTab( False );
    end
    else
    begin
      GetTextColor( ATabIndex, tsUnselected, TextColor, Handled );
      if not Handled then
        TextColor := FTextColors.Unselected;
    end;
    if TabData.Caption <> '' then
      DrawTabText( TextColor, 0 );
  end
  else
  begin
    GetTextColor( ATabIndex, tsDisabledHighlight, TextColor, Handled );
    if not Handled then
      TextColor := FTextColors.DisabledHighlight;

    if TabData.Caption <> '' then
      DrawTabText( TextColor, 1 );

    Handled := False;
    GetTextColor( ATabIndex, tsDisabledShadow, TextColor, Handled );
    if not Handled then
      TextColor := FTextColors.DisabledShadow;

    if TabData.Caption <> '' then
      DrawTabText( TextColor, 0 );
  end;
  if FShowFocusRect and ( ATabIndex = FTabIndex ) and Focused then
    DrawTabFocusRect;
end; {= TRzCustomTabControl.DrawTabFace =}


procedure TRzCustomTabControl.ProcessCommands;
var
  I, X, Y: Integer;
  Cmd: Integer;
  Alpha: Byte;
  SP, EP, APoint: TPoint;
  FrameColor: TColor;                      // State variable for current shadow color
  ItemColor: TColor;
  BgBmp: TBitmap;

  function NeedShadowBgBmp: Boolean;
  var
    I, Cmd: Integer;
  begin
    Result := False;
    I := 0;
    while I < FCommands.Count do
    begin
      Cmd := Integer( FCommands[ I ] );
      Inc( I );
      if Cmd >= cmd_HasData then               // data follows command
        Inc( I, 2 );
      if ( Cmd = cmd_Shadow1_LineTo ) or ( Cmd = cmd_Shadow2_LineTo ) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

begin
  FrameColor := AdjustColor( FFlatColor, FFlatColorAdjustment );
  BgBmp := nil;
  if NeedShadowBgBmp then
  begin
    BgBmp := TBitmap.Create;
    BgBmp.Width := Width;
    BgBmp.Height := Height;
    DrawParentImage( Self, BgBmp.Canvas );
  end;

  I := 0;
  while I < FCommands.Count do
  begin
    Cmd := Integer( FCommands[ I ] );
    Inc( I );
    if Cmd >= cmd_HasData then               // data follows command
    begin
      APoint.X := Integer( FCommands[ I ] );
      Inc( I );
      APoint.Y := Integer( FCommands[ I ] );
      Inc( I );
    end;

    case Cmd of
      cmd_Border:
        FBuffer.Canvas.Pen.Color := FrameColor;

      cmd_BorderColor:
      begin
        ItemColor := AdjustColor( FFlatColor, FFlatColorAdjustment );
        FrameColor := ItemColor;
      end;

      cmd_MoveTo:
        FBuffer.Canvas.MoveTo( APoint.X, APoint.Y );

      cmd_LineTo:
        FBuffer.Canvas.LineTo( APoint.X, APoint.Y );

      cmd_Shadow1_LineTo, cmd_Shadow2_LineTo:
      begin
        if Cmd = cmd_Shadow1_LineTo then
          Alpha := 30
        else
          Alpha := 15;

        SP := FBuffer.Canvas.PenPos;
        EP := APoint;
        if SP.X = EP.X then
        begin
          // Vertical Line
          if SP.Y > EP.Y then
          begin
            SP := APoint;
            EP := FBuffer.Canvas.PenPos;
          end;

          for Y := SP.Y to EP.Y do
            FBuffer.Canvas.Pixels[ SP.X, Y ] := BlendColors( clBlack, BgBmp.Canvas.Pixels[ SP.X, Y ], Alpha );
        end
        else
        begin
          // Horizontal Line
          if SP.X > EP.X then
          begin
            SP := APoint;
            EP := FBuffer.Canvas.PenPos;
          end;

          for X := SP.X to EP.X do
            FBuffer.Canvas.Pixels[ X, SP.Y ] := BlendColors( clBlack, BgBmp.Canvas.Pixels[ X, SP.Y ], Alpha );
        end;
        FBuffer.Canvas.MoveTo( APoint.X, APoint.Y );
      end;
    end;
  end;

  if BgBmp <> nil then
    BgBmp.Free;
end; {= TRzCustomTabControl.ProcessCommands =}


procedure TRzCustomTabControl.SetTabIndex( Value: Integer );
var
  OldTabIndex: Integer;
  Scrolled, AllowChange: Boolean;
  TabData: TRzTabData;
begin
  Scrolled := False;
  if ( csLoading in ComponentState ) or ( csReading in ComponentState ) then
  begin                                     // Tabs not loaded yet
    FTabIndex := Value;
    Exit;
  end;

  if ( Value < 0 ) or ( Value >= FTabDataList.Count ) then
  begin
    FTabIndex := -1;
    InvalidateControl;
  end
  else
  begin
    OldTabIndex := FTabIndex;
    // Check that it is OK to change to the requested tab
    AllowChange := True;
    if ( FTabIndex <> Value ) and not FChangingDone then
      AllowChange := CanSelectTab( Value );

    if AllowChange then
    begin
      FTabIndex := Value;
      if FScrollerNeeded then
        if FTabIndex < FFirstInView then
        begin
          FFirstInView := FTabIndex;
          InvalidateControl;
        end
        else
        begin
          // check if necessary to 'scroll' so new tab is _fully_ in view
          while ( FFirstInView < FTabIndex ) do
          begin
            TabData := FTabDataList[ FTabIndex ];
            if not TabInView( TabData ) then
            begin
              Inc( FFirstInView );
              Scrolled := True;
            end
            else
              Break;
          end;
        end
      else
      begin
        TabData := FTabDataList[ FTabIndex ];
        BringTabToFrontRow( TabData );
      end;
    end; { if AllowChange }

    if Scrolled or ( FTabIndex <> OldTabIndex ) then
    begin
      InvalidateControl;
      if FScroller <> nil then
        FScroller.Invalidate;
      if FTabIndex <> OldTabIndex then
      begin
        Change;
        if ( csDesigning in ComponentState ) and FDoneTabIndexDefault then
          UpdateObjectInspector( Self );
      end;
    end;
  end;

  if FShowCloseButton then
    FCloseButton.Invalidate;
end; {= TRzCustomTabControl.SetTabIndex =}


function TRzCustomTabControl.CalcMapRect( const RawRect: TRect ): TRect;
var
  NewOrigin, NewCorner: TPoint;
begin
  NewOrigin := CalcMapPoint( Point( RawRect.Left, RawRect.Top ) );
  NewCorner := CalcMapPoint( Point( RawRect.Right, RawRect.Bottom ) );
  Result.Left := NewOrigin.X;
  Result.Top := NewOrigin.Y;
  Result.Right := NewCorner.X;
  Result.Bottom := NewCorner.Y;
  OrderRectCorners( Result );
end;

// CalcMapPoint
//
// Map the point from raw index rect coordinates to actual
// index rect coordinates.

function TRzCustomTabControl.CalcMapPoint( const RawPt: TPoint ): TPoint;
var
  IndexRect: TRect;
  Offset: Integer;
begin
  Offset := GetInitialTabOffset;
  IndexRect := GetIndexRect;
  if FTabSequence = tsStandard then
  begin
    case FTabOrientation of
      toTop:
      begin
        Result.X := IndexRect.Left + ( RawPt.X - Offset );
        Result.Y := IndexRect.Top + RawPt.Y;
      end;

      toBottom:
      begin
        Result.X := IndexRect.Left + ( RawPt.X - Offset );
        Result.Y := IndexRect.Bottom - RawPt.Y;
      end;

      toLeft:
      begin
        Result.X := IndexRect.Left + RawPt.Y;
        Result.Y := IndexRect.Bottom - ( RawPt.X - Offset );
      end;

      toRight:
      begin
        Result.X := IndexRect.Right - RawPt.Y;
        Result.Y := IndexRect.Top + ( RawPt.X - Offset );
      end;
    end
  end
  else                                      // tsReverse
  begin
    case FTabOrientation of
      toTop:
      begin
        Result.X := IndexRect.Right - ( Offset - RawPt.X );
        Result.Y := IndexRect.Top + RawPt.Y;
      end;

      toBottom:
      begin
        Result.X := IndexRect.Right - ( Offset - RawPt.X );
        Result.Y := IndexRect.Bottom - RawPt.Y;
      end;

      toLeft:
      begin
        Result.X := IndexRect.Left + RawPt.Y;
        Result.Y := IndexRect.Top + ( Offset - RawPt.X );
      end;

      toRight:
      begin
        Result.X := IndexRect.Right - RawPt.Y;
        Result.Y := IndexRect.Bottom - ( Offset - RawPt.X );
      end;
    end;
  end;
end; {= TRzCustomTabControl.CalcMapPoint =}


function TRzCustomTabControl.TabAtPos( X, Y: Integer ): Integer;
var
  Pt: TPoint;
  I: Integer;
  Found: Boolean;

  // PointInTab
  // Return true if the specified point is inside the boundaries of the specified tab.

  function PointInTab( APoint: TPoint; ATabIndex: Integer ): Boolean;
  var
    TabData: TRzTabData;
    R: TRect;
    Region: hRgn;
  begin
    Result := False;
    TabData := FTabDataList[ ATabIndex ];
    if TabInView( TabData ) then
    begin
      R := CalcMappedTabRect( ATabIndex, TabData );

      // First do a quick (but inexact) test using PointInRect, and if that
      // succeeds then use an exact (but slower) PtInRegion test.

      if PointInRect( R, APoint ) then      // now do exact test using region
      begin
        Region := CalcTabRegion( ATabIndex, R );
        if ( Region <> 0 ) and PtInRegion( Region, APoint.X, APoint.Y ) then
          Result := True;                   { point is over specified tab }
      end;
    end;
  end;

begin {= TRzCustomTabControl.TabAtPos =}
  Pt := Point( X, Y );
  Result := -1;
  if ( FTabDataList.Count = 0 ) or ( FFirstInView < 0 ) then
    Exit;

  Found := False;
  I := FTabIndex;

  // The current tab is 'in front of' all other tabs and so is checked first
  if I >= 0 then
    Found := PointInTab( Pt, I );

  if not Found then
  begin
    // Each tab (apart from current tab which has already been checked) --
    // starting from the first in view -- is 'in front of' the following tab and
    // so is checked in that order

    I := FFirstInView;
    repeat
      if ( I <> FTabIndex ) then            // This tab hasn't been checked yet
        Found := PointInTab( Pt, I );

      if not Found then
      begin
        if I < FTabDataList.Count - 1 then
          Inc( I )
        else
          I := 0;
      end;
    until Found or ( I = FFirstInView );
  end;

  if Found then
    Result := I;
end; {= TRzCustomTabControl.TabAtPos =}


procedure TRzCustomTabControl.HideAllTabs;
begin
  // Real work done in descendant classes
end;


procedure TRzCustomTabControl.ShowAllTabs;
begin
  // Real work done in descendant classes
end;


procedure TRzCustomTabControl.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  NewTabIndex: Integer;
begin
  // Select the tab on which the mouse pointer was clicked.

  inherited;

  if ( Button = mbLeft ) and ( Enabled or ( csDesigning in ComponentState ) ) then
  begin
    NewTabIndex := TabAtPos( X, Y );

    if ( NewTabIndex >= 0 ) and FTabDataList[ NewTabIndex ].Enabled then
    begin
      // Only set focus to self if it has TabStop and the tab clicked is already the current one

      if TabStop and ( NewTabIndex = FTabIndex ) and not ( csDesigning in ComponentState ) then
      begin
        SetFocus;                           // to self
        if not Focused then
          Exit;                             // OnExit event handlers have redirected focus
      end;
      SetTabIndex( NewTabIndex );
      if FTabIndex = NewTabIndex then
        // Tab change was allowed
        TabClick;
    end;
  end;
end; {= TRzCustomTabControl.MouseDown =}


procedure TRzCustomTabControl.MouseMove( Shift: TShiftState; X, Y: Integer );
var
  Idx: Integer;
  NewHint, SavedHint: string;
  IndexRect: TRect;
  InIndexRect: Boolean;
begin
  if ( not ( csDesigning in ComponentState ) ) and ( FHotTrack or FTabHints ) then
  begin
    Idx := TabAtPos( X, Y );
    if Idx >= 0 then                        // Mouse cursor is over a tab
    begin
      if Idx <> FHotTrackIndex then         // Mouse cursor has been moved to different tab
      begin
        FHotTrackIndex := Idx;
        if FHotTrack then                   // Redraw tabs to indicate hot-tracked tab
        begin
          IndexRect := GetIndexRect;
          FHotTracking := True;             // We are about to redraw tabs via hot tracking--no need to update shadow
          InvalidateRect( Handle, @IndexRect, False );
        end;

        if FTabHints then                   // Change control's Hint to hint for tab under mouse cursor }
        begin
          Application.CancelHint;           // So hint will change even though we are on same control }
          NewHint := FTabDataList[ Idx ].Hint;
          if ( NewHint <> '' ) then         // Replace control's Hint with tab's Hint }
            Hint := NewHint;
        end;

        // Create timer with minimum interval (max. freq is 18Hz ~= 60ms)
        // so we can detect if the mouse cursor is moved quickly off of the
        // tabs and ends up outside the control's bounds (and thus no longer
        // sending mouse move messages to the control).
        // This timer is used for both hot-tracking of tab captions and when
        // doing hints for each tab.

        if FTimerHandle = 0 then
          FTimerHandle := SetTimer( Handle, 0, 60, nil );
      end;
    end
    else                                    // Idx < 0
    begin
      // Mouse cursor may be either over the card area of the control, in which
      // case we want to use the original hint value -- StopHotTracking takes
      // care of this case -- or, over the index area but not over a tab, in
      // which case we want to set the Hint to blank to stop if showing

      IndexRect := GetIndexRect;            // Area in which tabs are displayed
      InIndexRect := PointInRect( IndexRect, Point( X, Y ) );
      if FTabHints then
      begin
        // Cancel hint if we were previously over a tab or are over the
        // index area (but not over a tab)

        if ( FHotTrackIndex >= 0 ) or InIndexRect then
          Application.CancelHint;

        if InIndexRect then
        begin
          // Mouse cursor is in index area but not over a tab; temporarily change
          // FOriginalHint to '' before calling StopHotTracking (which uses
          // the value of FOriginalHint) and then restore its value afterwards
          // so that if the user subsequently moves into the card area of the
          // control (but is still not over a tab) we will end up here again and
          // StopHotTracking will be called and will use the FOriginalHint value
          // we restored previously

          SavedHint := FOriginalHint;
          FOriginalHint := '';
        end;
      end;

      StopHotTracking;

      if FTabHints and InIndexRect then     // Restore FOriginalHint
        FOriginalHint := SavedHint;
    end;
  end;
  inherited;

  if FAllowTabDragging and ( ssLeft in Shift ) and ( TabAtPos( X, Y ) <> -1 ) then
    BeginDrag( False );

end; {= TRzCustomTabControl.MouseMove =}


procedure TRzCustomTabControl.DragOver( Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean );
var
  Idx: Integer;
  R: TRect;
begin
  inherited;

  if not FAllowTabDragging then
    Exit;

  Idx := TabAtPos( X, Y );

  Accept := ( Idx <> -1 ) and ( Idx <> FTabIndex );

  if Idx <> FLastMoveTabIndex then
  begin
    FLastMoveTabIndex := Idx;

    if Accept then
    begin
      if FMoveTabIndicatorVisible then
        DrawMoveTabIndicator( FLastDragOverRect );

      R := CalcMappedTabRect( Idx, FTabDataList[ Idx ] );

      case FTabOrientation of
        toTop:
        begin
          R.Top := R.Top - 2;
          R.Bottom := R.Top + 8;

          if ( ( Idx < FTabIndex ) and ( FTabSequence = tsStandard ) ) or
             ( ( Idx > FTabIndex ) and ( FTabSequence = tsReverse ) ) then
          begin
            R.Left := R.Left - 8;
            R.Right := R.Left + 15;

            if FTabStyle = tsDoubleSlant then
              OffsetRect( R, FFixedDimension div 2, 0 );
          end
          else
          begin
            R.Right := R.Right + 8;
            R.Left := R.Right - 15;

            case FTabStyle of
              tsSingleSlant, tsDoubleSlant:
                OffsetRect( R, -FFixedDimension div 2, 0 );
              tsCutCorner, tsRoundCorners:
                OffsetRect( R, 1, 0 );
            end;
          end;
        end;

        toLeft:
        begin
          R.Left := R.Left - 2;
          R.Right := R.Left + 8;

          if ( ( Idx < FTabIndex ) and ( FTabSequence = tsStandard ) ) or
             ( ( Idx > FTabIndex ) and ( FTabSequence = tsReverse ) ) then
          begin
            R.Bottom := R.Bottom + 8;
            R.Top := R.Bottom - 15;

            case FTabStyle of
              tsDoubleSlant:
                OffsetRect( R, 0, -FFixedDimension div 2 );

              tsCutCorner, tsRoundCorners:
                OffsetRect( R, 0, 1 );
            end;
          end
          else
          begin
            R.Top := R.Top - 8;
            R.Bottom := R.Top + 15;

            case FTabStyle of
              tsSingleSlant, tsDoubleSlant:
                OffsetRect( R, 0, FFixedDimension div 2 );
            end;
          end;
        end;

        toBottom:
        begin
          R.Bottom := R.Bottom + 2;
          R.Top := R.Bottom - 8;

          if ( ( Idx < FTabIndex ) and ( FTabSequence = tsStandard ) ) or
             ( ( Idx > FTabIndex ) and ( FTabSequence = tsReverse ) ) then
          begin
            R.Left := R.Left - 8;
            R.Right := R.Left + 15;

            if FTabStyle = tsDoubleSlant then
              OffsetRect( R, FFixedDimension div 2, 0 );
          end
          else
          begin
            R.Right := R.Right + 8;
            R.Left := R.Right - 15;

            case FTabStyle of
              tsSingleSlant, tsDoubleSlant:
                OffsetRect( R, -FFixedDimension div 2, 0 );
              tsCutCorner, tsRoundCorners:
                OffsetRect( R, 1, 0 );
            end;
          end;
        end;

        toRight:
        begin
          R.Right := R.Right + 3;
          R.Left := R.Right - 8;

          if ( ( Idx < FTabIndex ) and ( FTabSequence = tsStandard ) ) or
             ( ( Idx > FTabIndex ) and ( FTabSequence = tsReverse ) ) then
          begin
            R.Top := R.Top - 8;
            R.Bottom := R.Top + 15;

            if FTabStyle = tsDoubleSlant then
              OffsetRect( R, 0, FFixedDimension div 2 + 1);
          end
          else
          begin
            R.Bottom := R.Bottom+ 8;
            R.Top := R.Bottom - 15;

            case FTabStyle of
              tsSingleSlant, tsDoubleSlant:
                OffsetRect( R, 0, -FFixedDimension div 2 );
              tsCutCorner, tsRoundCorners:
                OffsetRect( R, 0, 1 );
            end;
          end;
        end;
      end;

      DrawMoveTabIndicator( R );
      FMoveTabIndicatorVisible := True;
      FLastDragOverRect := R;
    end
    else if FMoveTabIndicatorVisible then
    begin
      DrawMoveTabIndicator( FLastDragOverRect );
      FMoveTabIndicatorVisible := False;
    end;
  end;

  if ( State = dsDragLeave ) and FMoveTabIndicatorVisible then
  begin
    DrawMoveTabIndicator( FLastDragOverRect );
    FMoveTabIndicatorVisible := False;
    FLastMoveTabIndex := -1;
  end;
end; {= TRzCustomTabControl.DragOver =}


procedure TRzCustomTabControl.DrawMoveTabIndicator( R: TRect );
var
  Canvas: TCanvas;
  DrawDC: HDC ;
  SrcRect: TRect;
  FIndicator: TBitmap;
begin
  DrawDC := GetDC( 0 );
  try
    R.TopLeft := ClientToScreen( R.TopLeft );
    R.BottomRight := ClientToScreen( R.BottomRight );
    Canvas := TCanvas.Create;
    try
      Canvas.Handle := DrawDC;
      Canvas.CopyMode := cmSrcInvert;

      FIndicator:= TBitmap.Create;
      FIndicator.Width := R.Right - R.Left;
      FIndicator.Height := R.Bottom - R.Top;

      SrcRect := Rect( 0, 0, FIndicator.Width, FIndicator.Height );
      try
        FIndicator.Canvas.Brush.Color := clBtnShadow;
        FIndicator.Canvas.FillRect( SrcRect );
        FIndicator.Canvas.Pen.Style := psClear;
        FIndicator.Canvas.Brush.Color := clBlack;
        case FTabOrientation of
          toTop:
          begin
            FIndicator.Canvas.Polygon( [ Point( 0, 0 ), Point( 8, 8 ), Point( 0, 8 ) ] );
            FIndicator.Canvas.Polygon( [ Point( 7, 8 ), Point( 15, 0 ), Point( 15, 8 ) ] );
          end;

          toLeft:
          begin
            FIndicator.Canvas.Polygon( [ Point( 1, 0 ), Point( 8, 0 ), Point( 8, 8 ) ] );
            FIndicator.Canvas.Polygon( [ Point( -1, 15 ), Point( 8, 7 ), Point( 8, 15 ) ] );
          end;

          toBottom:
          begin
            FIndicator.Canvas.Polygon( [ Point( -1, 8 ), Point( -1, -1 ), Point( 8, -1 ) ] );
            FIndicator.Canvas.Polygon( [ Point( 7, -1 ), Point( 15, 0 ), Point( 15, 8 ) ] );
          end;

          toRight:
          begin
            FIndicator.Canvas.Polygon( [ Point( 0, 0 ), Point( 7, 0 ), Point( 0, 7 ) ] );
            FIndicator.Canvas.Polygon( [ Point( 0, 7 ), Point( 8, 15 ), Point( 0, 15 ) ] );
          end;
        end;

        Canvas.CopyRect( R, FIndicator.Canvas, SrcRect );
      finally
        FIndicator.Free;
      end;
    finally
      Canvas.Free;
    end;
  finally
    ReleaseDC( 0, DrawDC );
  end;
end; {= TRzCustomTabControl.DrawMoveTabIndicator =}


procedure TRzCustomTabControl.DragDrop( Source: TObject; X, Y: Integer );
var
  Idx: Integer;
begin
  inherited;

  if not FAllowTabDragging then
    Exit;

  if FMoveTabIndicatorVisible then
    DrawMoveTabIndicator( FLastDragOverRect );

  FMoveTabIndicatorVisible := False;

  Idx := TabAtPos( X, Y );
  if Idx <> -1 then
    ActiveTabMoved( Idx );
end;


procedure TRzCustomTabControl.StopHotTracking;
var
  IndexRect: TRect;
begin
  CancelHotTrackTimer;
  FHotTrackIndex := -1;
  IndexRect := GetIndexRect;
  InvalidateRect( Handle, @IndexRect, False );
  Hint := FOriginalHint;
end;


procedure TRzCustomTabControl.CancelHotTrackTimer;
begin
  if FTimerHandle <> 0 then
  begin
    KillTimer( 0, FTimerHandle );
    FTimerHandle := 0;
  end;
end;


procedure TRzCustomTabControl.WMTimer( var Msg: TWMTimer );
var
  Point: TPoint;
  Idx: Integer;
begin
  // Check for left-over messages generated prior to timer being killed
  if FTimerHandle = 0 then
    Exit;

  // Check if still over a tab
  GetCursorPos( Point );
  Point := ScreenToClient( Point );
  Idx := TabAtPos( Point.X, Point.Y );
  if ( Idx = -1 ) then                      // No longer over a tab
    StopHotTracking;
end;


// CalcTabRect
//
// Return the (unmapped) rect for the tab with allowance for row indentation
// and/or enlarged current tab.
// Use CalcMappedTabRect if the mapped tab rect is required.

function TRzCustomTabControl.CalcTabRect( ATabIndex: Integer; TabData: TRzTabData ): TRect;
var
  R: TRect;
begin
  R := TabData.RawRect;
  if TabData.Row > 0 then                   // Multiple rows of tabs
  begin
    // Add amount of row indent appropriate for row no.
    if FTabSequence = tsStandard then
      OffsetRect( R, TabData.Row * FRowIndent, 0 )
    else
      OffsetRect( R, -TabData.Row * FRowIndent, 0 );
  end;

  if ( FTabStyle = tsRoundCorners ) and ( ATabIndex = FTabIndex ) then
  begin
    // Tab Control (Win95) style tabs have enlarged current tab 
    Dec( R.Left, 2 );
    Inc( R.Right, 2 );
    Dec( R.Top, 2 );
  end;
  Result := R;
end;


function TRzCustomTabControl.CalcMappedTabRect( ATabIndex: Integer; TabData: TRzTabData ): TRect;
var
  R: TRect;
begin
  R := CalcTabRect( ATabIndex, TabData );
  Result := CalcMapRect( R );
end;


// CalcTabRegion
//
// Return the region for the specified tab by seeing if it already exists in
// the region cache or otherwise creating it.

function TRzCustomTabControl.CalcTabRegion( ATabIndex: Integer; const ARect: TRect ): hRgn;
var
  R: TRect;
  Region: hRgn;
  Pts: TRzTabRegionPts;
  NumPts: Integer;
begin
  Result := 0;
  R := ARect;
  Region := FTabRegionCache.Find( R );
  if Region = 0 then                        // not in cache
  begin
    CalcMappedTabRegionPts( ATabIndex, {R,} Pts, NumPts );
    if NumPts >= 3 then
    begin
      Region := CreatePolygonRgn( Pts, NumPts, PolyFillMode );
      if Region = 0 then
        raise Exception.Create( sRzCreateRegionError );

      // add new item to cache
      FTabRegionCache.Add( R, Region );
      Result := Region;
    end;
  end
  else
    Result := Region;
end;


procedure TRzCustomTabControl.CalcTabRegionPts( ATabIndex: Integer; var Pts: TRzTabRegionPts; var NumPts: Integer );
var
  L, T, R, B: Integer;
  RR: TRect;
  TabData: TRzTabData;
begin
  NumPts := 0;
  TabData := FTabDataList[ ATabIndex ];
  RR := CalcTabRect( ATabIndex, TabData );
  L := RR.Left;
  T := RR.Top;
  R := RR.Right;
  B := RR.Bottom;

  case FTabStyle of
    tsSingleSlant:                                       //       * * * * * * * * * * *
    begin                                                //     *                       *
      NumPts := 5;                                       //   *                           *
      Pts[ 0 ] := Point( L, B );                         //   *                             *
      Pts[ 1 ] := Point( L, T + 2 );                     //   *                               *
      Pts[ 2 ] := Point( L + 2, T );                     //   *                                 *
      Pts[ 3 ] := Point( R - ( B - T ), T );             //   *                                   *
      Pts[ 4 ] := Point( R, B );                         //   *                                     *
    end;

    tsDoubleSlant:                                       //               * * * * * * * * * * *
    begin                                                //             *                       *
      NumPts := 4;                                       //           *                           *
      Pts[ 0 ] := Point( L, B );                         //         *                               *
      Pts[ 1 ] := Point( L + ( B - T ), T );             //       *                                   *
      Pts[ 2 ] := Point( R - ( B - T ), T );             //     *                                       *
      Pts[ 3 ] := Point( R, B );                         //   *                                           *
    end;

    tsCutCorner:                                         //   * * * * * * * * * * * * * * * *
    begin                                                //   *                               *
      NumPts := 5;                                       //   *                                 *
      Pts[ 0 ] := Point( L, B );                         //   *                                   *
      Pts[ 1 ] := Point( L, T );                         //   *                                   *
      Pts[ 2 ] := Point( R - FCutCornerSize, T );        //   *                                   *
      Pts[ 3 ] := Point( R, T + FCutCornerSize );        //   *                                   *
      Pts[ 4 ] := Point( R, B );                         //   *                                   *
    end;

    tsRoundCorners:                                      //       * * * * * * * * * * * * * * *
    begin                                                //     *                               *
      NumPts := 6;                                       //   *                                   *
      Pts[ 0 ] := Point( L, B );                         //   *                                   *
      Pts[ 1 ] := Point( L, T + 2 );                     //   *                                   *
      Pts[ 2 ] := Point( L + 2, T );                     //   *                                   *
      Pts[ 3 ] := Point( R - 2, T );                     //   *                                   *
      Pts[ 4 ] := Point( R, T + 2 );                     //   *                                   *
      Pts[ 5 ] := Point( R, B );
    end;
  end;
end; {= TRzCustomTabControl.CalcTabRegionPts =}


procedure TRzCustomTabControl.CalcMappedTabRegionPts( ATabIndex: Integer; var Pts: TRzTabRegionPts; var NumPts: Integer );
var
  I: Integer;
begin
  CalcTabRegionPts( ATabIndex, Pts, NumPts );
  // Map points to actual orientation
  for I := 0 to NumPts - 1 do
    Pts[ I ] := CalcMapPoint( Pts[ I ] );
end;


// CalcTabDrawCommands
//
// Build a list of commands which can be used to draw the specified tab.
// Commands like cmd_Border, CMD_HIGHLIGHT, etc. will result in the
// appropriate color being selected.

procedure TRzCustomTabControl.CalcTabDrawCommands( ATabIndex: Integer );
var
  Pts: TRzTabRegionPts;
  MappedPts: array[ Low( TRzTabRegionPts )..High( TRzTabRegionPts ) ] of TPoint;
  I, NumPts: Integer;
  APoint: TPoint;
begin

  // Get tab points for unmapped tab outline
  CalcTabRegionPts( ATabIndex, Pts, NumPts );

  // Build list of commands needed to draw the tab shape

  case FTabStyle of
    tsSingleSlant:
    begin
      if NumPts <> 5 then
        raise Exception.Create( sRzIncorrectNumberOfPoints );

      AddCommand( cmd_Border );
      AddCommandPt( cmd_MoveTo, CalcMapPoint( Pts[ 0 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 1 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 2 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 3 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 4 ] ) );
    end;

    tsDoubleSlant:
    begin
      if NumPts <> 4 then
        raise Exception.Create( sRzIncorrectNumberOfPoints );

      AddCommand( cmd_Border );
      AddCommandPt( cmd_MoveTo, CalcMapPoint( Pts[ 0 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 1 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 2 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 3 ] ) );
    end;

    tsCutCorner:
    begin
      if NumPts <> 5 then
        raise Exception.Create( sRzIncorrectNumberOfPoints );

      AddCommand( cmd_Border );
      AddCommandPt( cmd_MoveTo, CalcMapPoint( Pts[ 0 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 1 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 2 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 3 ] ) );
      AddCommandPt( cmd_LineTo, CalcMapPoint( Pts[ 4 ] ) );
    end;

    tsRoundCorners:
    begin
      if NumPts <> 6 then
        raise Exception.Create( sRzIncorrectNumberOfPoints );

      for I := 0 to 5 do
        MappedPts[ I ] := CalcMapPoint( Pts[ I ] );

      // Non-intuitive order of drawing line segments is so that appropriate
      // segments are 'on top of' other segments and appropriate end points
      // are included so the control matches the look of the native Windows
      // tab control.
      // Also note that some of the 3D highlighting is not strictly
      // realistic (i.e. highlight used on some segments which would be
      // shadowed) but has been changed to give the tabs a better appearance
      // in bottom and right orientations.

      case FTabOrientation of
        toTop:
        begin
          AddCommand( cmd_Border );
          AddCommandPt( cmd_MoveTo, MappedPts[ 4 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 5 ] );
          AddCommandPt( cmd_MoveTo, MappedPts[ 4 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 3 ] );
          APoint := Point( Pts[ 4 ].X - 1, Pts[ 4 ].Y );
          AddCommandPt( cmd_MoveTo, CalcMapPoint( APoint ) );
          APoint := Point( Pts[ 5 ].X - 1, Pts[ 5 ].Y );
          AddCommandPt( cmd_MoveTo, MappedPts[ 3 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 2 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 1 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 0 ] );
        end;

        toBottom:
        begin
          AddCommand( cmd_Border );
          AddCommandPt( cmd_MoveTo, MappedPts[ 4 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 5 ] );
          AddCommandPt( cmd_MoveTo, MappedPts[ 4 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 3 ] );
          APoint := Point( Pts[ 4 ].X - 1, Pts[ 4 ].Y );
          AddCommandPt( cmd_MoveTo, CalcMapPoint( APoint ) );
          APoint := Point( Pts[ 5 ].X - 1, Pts[ 5 ].Y );
          AddCommandPt( cmd_MoveTo, MappedPts[ 3 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 2 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 1 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 0 ] );
        end;

        toLeft:
        begin
          AddCommand( cmd_Border );
          AddCommandPt( cmd_MoveTo, MappedPts[ 1 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 0 ] );
          AddCommandPt( cmd_MoveTo, MappedPts[ 1 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 2 ] );
          APoint := Point( Pts[ 1 ].X + 1, Pts[ 1 ].Y );
          AddCommandPt( cmd_MoveTo, CalcMapPoint( APoint ) );
          APoint := Point( Pts[ 0 ].X + 1, Pts[ 0 ].Y );
          AddCommandPt( cmd_MoveTo, MappedPts[ 2 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 3 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 4 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 5 ] );
        end;

        toRight:
        begin
          AddCommand( cmd_Border );
          AddCommandPt( cmd_MoveTo, MappedPts[ 4 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 5 ] );
          AddCommandPt( cmd_MoveTo, MappedPts[ 4 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 3 ] );
          APoint := Point( Pts[ 4 ].X - 1, Pts[ 4 ].Y );
          AddCommandPt( cmd_MoveTo, CalcMapPoint( APoint ) );
          APoint := Point( Pts[ 5 ].X - 1, Pts[ 5 ].Y );
          AddCommandPt( cmd_MoveTo, MappedPts[ 3 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 2 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 1 ] );
          AddCommandPt( cmd_LineTo, MappedPts[ 0 ] );
        end;
      end;
    end; { tsRoundCorners }
  end;
end; {= TRzCustomTabControl.CalcTabDrawCommands =}


// CalcCardDrawCommands
//
// Build a list of commands which can be used to draw the card for the
// specified row of tabs.
// Commands like cmd_Border, CMD_HIGHLIGHT, etc. will result in the
// appropriate color being selected.

procedure TRzCustomTabControl.CalcCardDrawCommands( ARow: Integer );
var
  TabData: TRzTabData;
  CurrentTabInView: Boolean;
  FirstRawPt, LastRawPt, FirstPt, LastPt: TPoint;
  CardRect: TRect;
  Pts: TRzTabRegionPts;
  NumPts: Integer;

  procedure GenerateShadowCommands;
  begin
    // The alpha blended shadow does not need to be displayed everytime the tabs are repainted. For example, when
    // hot tracking, the shadow is not changed.  Therefore, we only update the shadow when necessary.  This changes
    // eliminates the performance hit of calculating the shadow colors (for each pixel) during a full paint.
    if FHotTracking then
      Exit;

    AddCommandPt( cmd_MoveTo, Point( Pts[ 1 ].X - 1, Pts[ 1 ].Y + 1 ) );
    AddCommandPt( cmd_Shadow1_LineTo, Point( Pts[ 2 ].X - 1, Pts[ 2 ].Y - 1 ) );
    AddCommandPt( cmd_Shadow1_LineTo, Point( Pts[ 3 ].X, Pts[ 3 ].Y - 1 ) );

    AddCommandPt( cmd_MoveTo, Point( Pts[ 1 ].X - 1, Pts[ 1 ].Y ) );
    AddCommandPt( cmd_Shadow2_LineTo, Pts[ 1 ] );
    AddCommandPt( cmd_Shadow2_LineTo, Pts[ 2 ] );
    AddCommandPt( cmd_Shadow2_LineTo, Point( Pts[ 3 ].X, Pts[ 3 ].Y ) );
    AddCommandPt( cmd_Shadow2_LineTo, Point( Pts[ 3 ].X, Pts[ 3 ].Y - 1 ) );
  end;


  procedure GenerateContinuousBorderCommands;
  begin
    if ( FTabOrientation = toTop ) and ( FTabSequence = tsStandard ) and FShowShadow then
    begin
      AddCommand( cmd_Border );
      AddCommandPt( cmd_MoveTo, Pts[ 0 ] );
      AddCommandPt( cmd_LineTo, Point( Pts[ 1 ].X - 2, Pts[ 1 ].Y ) );
      AddCommandPt( cmd_LineTo, Point( Pts[ 2 ].X - 2, Pts[ 2 ].Y - 2 ) );
      AddCommandPt( cmd_LineTo, Point( Pts[ 3 ].X, Pts[ 3 ].Y - 2 ) );
      AddCommandPt( cmd_LineTo, Pts[ 0 ] );

      GenerateShadowCommands;
    end
    else
    begin
      AddCommand( cmd_Border );
      AddCommandPt( cmd_MoveTo, Pts[ 0 ] );
      AddCommandPt( cmd_LineTo, Pts[ 1 ] );
      if FShowFullFrame then
      begin
        AddCommandPt( cmd_LineTo, Pts[ 2 ] );
        AddCommandPt( cmd_LineTo, Pts[ 3 ] );
        AddCommandPt( cmd_LineTo, Pts[ 0 ] );
      end;
    end;
  end;


  procedure GenerateBrokenBorderCommands;
  begin
    case FTabOrientation of
      toTop:
      begin
        if ( FTabSequence = tsStandard ) and FShowShadow then
        begin
          AddCommand( cmd_Border );
          AddCommandPt( cmd_MoveTo, Pts[ 0 ] );
          AddCommandPt( cmd_LineTo, FirstPt );
          AddCommandPt( cmd_MoveTo, LastPt );
          AddCommandPt( cmd_LineTo, Point( Pts[ 1 ].X - 2, Pts[ 1 ].Y ) );
          if FShowFullFrame then
          begin
            AddCommandPt( cmd_LineTo, Point( Pts[ 2 ].X - 2, Pts[ 2 ].Y - 2 ) );
            AddCommandPt( cmd_LineTo, Point( Pts[ 3 ].X, Pts[ 3 ].Y - 2 ) );
            AddCommandPt( cmd_LineTo, Point( Pts[ 0 ].X, Pts[ 0 ].Y - 1 ) );
          end;
          GenerateShadowCommands;
        end
        else
        begin
          AddCommand( cmd_Border );
          if FShowFullFrame then
          begin
            AddCommandPt( cmd_MoveTo, Pts[ 0 ] );
            AddCommandPt( cmd_LineTo, FirstPt );
            AddCommandPt( cmd_MoveTo, LastPt );
            AddCommandPt( cmd_LineTo, Pts[ 1 ] );
            AddCommandPt( cmd_LineTo, Pts[ 2 ] );
            AddCommandPt( cmd_LineTo, Pts[ 3 ] );
            AddCommandPt( cmd_LineTo, Pts[ 0 ] );
          end
          else
          begin
            AddCommandPt( cmd_MoveTo, Pts[ 0 ] );
            AddCommandPt( cmd_LineTo, FirstPt );
            AddCommandPt( cmd_MoveTo, LastPt );
            AddCommandPt( cmd_LineTo, Point( Pts[ 1 ].X + 1, Pts[ 1 ].Y ) );
          end;
        end;
      end;

      toBottom:
      begin
        AddCommand( cmd_Border );
        if FShowFullFrame then
        begin
          AddCommandPt( cmd_MoveTo, Pts[ 0 ] );
          AddCommandPt( cmd_LineTo, Pts[ 1 ] );
          AddCommandPt( cmd_LineTo, Pts[ 2 ] );
          AddCommandPt( cmd_LineTo, Point( LastPt.X - 1, LastPt.Y ) );
          AddCommandPt( cmd_MoveTo, Point( FirstPt.X - 1, LastPt.Y ) );
          AddCommandPt( cmd_LineTo, Pts[ 3 ] );
          AddCommandPt( cmd_LineTo, Pts[ 0 ] );
        end
        else
        begin
          AddCommandPt( cmd_MoveTo, Point( Pts[ 2 ].X, Pts[ 2 ].Y + 1 ) );
          AddCommandPt( cmd_LineTo, Point( LastPt.X - 1, LastPt.Y + 1 ) );
          AddCommandPt( cmd_MoveTo, Point( FirstPt.X - 1, LastPt.Y + 1 ) );
          AddCommandPt( cmd_LineTo, Point( Pts[ 3 ].X, Pts[ 3 ].Y + 1 ) );
        end;
      end;

      toLeft:
      begin
        AddCommand( cmd_Border );
        if FShowFullFrame then
        begin
          AddCommandPt( cmd_MoveTo, Pts[ 0 ] );
          AddCommandPt( cmd_LineTo, Pts[ 1 ] );
          AddCommandPt( cmd_LineTo, Pts[ 2 ] );
          AddCommandPt( cmd_LineTo, Pts[ 3 ] );
          AddCommandPt( cmd_LineTo, FirstPt );
          AddCommandPt( cmd_MoveTo, LastPt );
          AddCommandPt( cmd_LineTo, Pts[ 0 ] );
        end
        else
        begin
          AddCommandPt( cmd_MoveTo, Point( Pts[ 3 ].X - 1, Pts[ 3 ].Y ) );
          AddCommandPt( cmd_LineTo, Point( FirstPt.X - 1, FirstPt.Y ) );
          AddCommandPt( cmd_MoveTo, Point( LastPt.X - 1, LastPt.Y ) );
          AddCommandPt( cmd_LineTo, Point( Pts[ 0 ].X - 1, Pts[ 0 ].Y ) );
        end;
      end;

      toRight:
      begin
        AddCommand( cmd_Border );
        if FShowFullFrame then
        begin
          AddCommandPt( cmd_MoveTo, Pts[ 0 ] );
          AddCommandPt( cmd_LineTo, Pts[ 1 ] );
          AddCommandPt( cmd_LineTo, FirstPt );
          AddCommandPt( cmd_MoveTo, LastPt );
          AddCommandPt( cmd_LineTo, Pts[ 2 ] );
          AddCommandPt( cmd_LineTo, Pts[ 3 ] );
          AddCommandPt( cmd_LineTo, Pts[ 0 ] );
        end
        else
        begin
          AddCommandPt( cmd_MoveTo, Point( Pts[ 1 ].X + 1, Pts[ 1 ].Y ) );
          AddCommandPt( cmd_LineTo, Point( FirstPt.X + 1, FirstPt.Y ) );
          AddCommandPt( cmd_MoveTo, Point( LastPt.X + 1, LastPt.Y ) );
          AddCommandPt( cmd_LineTo, Point( Pts[ 2 ].X + 1, Pts[ 2 ].Y + 1 ) );
        end;
      end;
    end;
  end; {= GenerateBrokenBorderCommands =}


  procedure GenerateBrokenRoundCornerCommands;
  begin
    // The reason why some of these drawing commands start from Pts[3] is to
    // ensure the final segment drawn overlaps the first segment drawn.

    case FTabOrientation of
      toTop:
      begin
        if ( FTabSequence = tsStandard ) and FShowShadow then
        begin
          AddCommand( cmd_Border );
          AddCommandPt( cmd_MoveTo, Point( Pts[ 3 ].X, Pts[ 3 ].Y - 2 ) );
          AddCommandPt( cmd_LineTo, Pts[ 0 ] );
          AddCommandPt( cmd_LineTo, FirstPt );
          AddCommandPt( cmd_MoveTo, LastPt );

          AddCommandPt( cmd_LineTo, Point( Pts[ 1 ].X - 2, Pts[ 1 ].Y ) );
          AddCommandPt( cmd_LineTo, Point( Pts[ 2 ].X - 2, Pts[ 2 ].Y - 2 ) );
          AddCommandPt( cmd_LineTo, Point( Pts[ 3 ].X - 1, Pts[ 3 ].Y - 2 ) );

          GenerateShadowCommands;

          AddCommand( cmd_Border );
          Pts[ 1 ] := Point( Pts[ 1 ].X - 1, Pts[ 1 ].Y + 1 );
          Pts[ 2 ] := Point( Pts[ 2 ].X - 1, Pts[ 2 ].Y - 1 );
          Pts[ 3 ] := Point( Pts[ 3 ].X, Pts[ 3 ].Y - 1 );
          // Fix up join between current tab and card
          AddCommandPt( cmd_MoveTo, LastPt );
          AddCommandPt( cmd_LineTo, Point( LastPt.X, LastPt.Y ) );
          AddCommandPt( cmd_LineTo, Point( LastPt.X + 1, LastPt.Y ) );
        end
        else
        begin
          if FShowFullFrame then
          begin
            AddCommandPt( cmd_MoveTo, Pts[ 3 ] );
            AddCommand( cmd_Border );
            AddCommandPt( cmd_LineTo, Pts[ 0 ] );

            AddCommandPt( cmd_LineTo, FirstPt );
            AddCommandPt( cmd_MoveTo, LastPt );
            AddCommandPt( cmd_LineTo, Pts[ 1 ] );

            AddCommandPt( cmd_LineTo, Pts[ 2 ] );
            AddCommandPt( cmd_LineTo, Point( Pts[ 3 ].X - 1, Pts[ 3 ].Y ) );
            Pts[ 1 ] := Point( Pts[ 1 ].X - 1, Pts[ 1 ].Y + 1 );
            Pts[ 2 ] := Point( Pts[ 2 ].X - 1, Pts[ 2 ].Y - 1 );
            Pts[ 3 ] := Point( Pts[ 3 ].X, Pts[ 3 ].Y - 1 );

            // Fix up join between current tab and card
            AddCommandPt( cmd_MoveTo, LastPt );
            AddCommandPt( cmd_LineTo, Point( LastPt.X, LastPt.Y ) );
            AddCommandPt( cmd_LineTo, Point( LastPt.X + 1, LastPt.Y ) );
          end
          else
          begin
            AddCommand( cmd_Border );
            AddCommandPt( cmd_MoveTo, Pts[ 0 ] );

            AddCommandPt( cmd_LineTo, FirstPt );
            AddCommandPt( cmd_MoveTo, LastPt );
            AddCommandPt( cmd_LineTo, Point( Pts[ 1 ].X + 1, Pts[ 1 ].Y ) );

            // Fix up join between current tab and card
            AddCommandPt( cmd_MoveTo, LastPt );
            AddCommandPt( cmd_LineTo, Point( LastPt.X, LastPt.Y ) );
            AddCommandPt( cmd_LineTo, Point( LastPt.X + 1, LastPt.Y ) );
          end;
        end;
      end;

      toBottom:
      begin
        FirstPt.X := FirstPt.X - 1;
        LastPt.X := LastPt.X - 1;

        if FShowFullFrame then
        begin
          AddCommandPt( cmd_MoveTo, Pts[ 3 ] );
          AddCommand( cmd_Border );
          AddCommandPt( cmd_LineTo, Pts[ 0 ] );
          AddCommandPt( cmd_LineTo, Pts[ 1 ] );
          AddCommandPt( cmd_LineTo, Pts[ 2 ] );

          AddCommandPt( cmd_LineTo, LastPt );
          AddCommandPt( cmd_MoveTo, FirstPt );
          AddCommandPt( cmd_LineTo, Pts[ 3 ] );

          Pts[ 1 ] := Point( Pts[ 1 ].X - 1, Pts[ 1 ].Y + 1 );
          Pts[ 2 ] := Point( Pts[ 2 ].X - 1, Pts[ 2 ].Y - 1 );
          Pts[ 3 ] := Point( Pts[ 3 ].X, Pts[ 3 ].Y - 1 );
        end
        else
        begin
          AddCommand( cmd_Border );
          AddCommandPt( cmd_MoveTo, Point( Pts[ 2 ].X, Pts[ 2 ].Y + 1 ) );
          AddCommandPt( cmd_LineTo, Point( LastPt.X, LastPt.Y + 1  ) );
          AddCommandPt( cmd_MoveTo, Point( FirstPt.X, LastPt.Y + 1 ) );
          AddCommandPt( cmd_LineTo, Point( Pts[ 3 ].X - 1, Pts[ 3 ].Y + 1 ) );
        end;

        FirstPt.Y := FirstPt.Y - 1;
        LastPt.Y := LastPt.Y - 1;
      end;

      toLeft:
      begin
        if FShowFullFrame then
        begin
          AddCommandPt( cmd_MoveTo, Pts[ 3 ] );
          AddCommand( cmd_Border );
          AddCommandPt( cmd_LineTo, FirstPt );
          AddCommandPt( cmd_MoveTo, LastPt );
          AddCommandPt( cmd_LineTo, Pts[ 0 ] );
          AddCommandPt( cmd_LineTo, Pts[ 1 ] );
          AddCommandPt( cmd_LineTo, Pts[ 2 ] );
          AddCommandPt( cmd_LineTo, Point( Pts[ 3 ].X - 1, Pts[ 3 ].Y ) );
          Pts[ 1 ] := Point( Pts[ 1 ].X - 1, Pts[ 1 ].Y + 1 );
          Pts[ 2 ] := Point( Pts[ 2 ].X - 1, Pts[ 2 ].Y - 1 );
          Pts[ 3 ] := Point( Pts[ 3 ].X, Pts[ 3 ].Y - 1 );
        end
        else
        begin
          AddCommandPt( cmd_MoveTo, Point( Pts[ 3 ].X - 1, Pts[ 3 ].Y ) );
          AddCommand( cmd_Border );
          AddCommandPt( cmd_LineTo, Point( FirstPt.X - 1, FirstPt.Y ) );
          AddCommandPt( cmd_MoveTo, Point( LastPt.X - 1, LastPt.Y ) );
          AddCommandPt( cmd_LineTo, Point( Pts[ 0 ].X - 1, Pts[ 0 ].Y ) );
        end;
      end;

      toRight:
      begin
        FirstPt.Y := FirstPt.Y - 1;

        if FShowFullFrame then
        begin
          AddCommandPt( cmd_MoveTo, Pts[ 3 ] );
          AddCommand( cmd_Border );
          AddCommandPt( cmd_LineTo, Pts[ 0 ] );
          AddCommandPt( cmd_LineTo, Point( Pts[ 1 ].X + 1, Pts[ 1 ].Y ) );
          AddCommandPt( cmd_MoveTo, Pts[ 1 ] );
          AddCommandPt( cmd_LineTo, Point( FirstPt.X, FirstPt.Y + 1 ) );
          AddCommandPt( cmd_MoveTo, LastPt );
          AddCommandPt( cmd_LineTo, Pts[ 2 ] );
          AddCommandPt( cmd_LineTo, Point( Pts[ 3 ].X - 1, Pts[ 3 ].Y ) );
          Pts[ 1 ] := Point( Pts[ 1 ].X - 1, Pts[ 1 ].Y + 1 );
          Pts[ 2 ] := Point( Pts[ 2 ].X - 1, Pts[ 2 ].Y - 1 );
          Pts[ 3 ] := Point( Pts[ 3 ].X, Pts[ 3 ].Y - 1 );
        end
        else
        begin
          AddCommand( cmd_Border );
          AddCommandPt( cmd_MoveTo, Point( Pts[ 1 ].X + 1, Pts[ 1 ].Y ) );
          AddCommandPt( cmd_LineTo, Point( FirstPt.X + 1, FirstPt.Y + 1 ) );
          AddCommandPt( cmd_MoveTo, Point( LastPt.X + 1, LastPt.Y ) );
          AddCommandPt( cmd_LineTo, Point( Pts[ 2 ].X + 1, Pts[ 2 ].Y + 1 ) );
        end;

        FirstPt.X := FirstPt.X - 1;
        FirstPt.Y := FirstPt.Y + 1;
        LastPt.X := LastPt.X - 1;
        LastPt.Y := LastPt.Y - 1;
      end;
    end;
  end; {= GenerateBrokenRoundCornerCommands =}


begin {= TRzCustomTabControl.CalcCardDrawCommands =}
  if FTabIndex < 0 then
  begin
    // No tabs are visible/enabled/selectable, draw appropriate continuous card

    // Put corners of mapped rect points into Pts[]
    CardRect := CalcMappedCardRect( ARow );
    NumPts := 4;
    Pts[ 0 ] := Point( CardRect.Left, CardRect.Top );
    Pts[ 1 ] := Point( CardRect.Right, CardRect.Top );
    Pts[ 2 ] := Point( CardRect.Right, CardRect.Bottom );
    Pts[ 3 ] := Point( CardRect.Left, CardRect.Bottom );

    // Build list of commands needed to draw the tab shape }
    GenerateContinuousBorderCommands;
  end
  else  { FTabIndex >= 0 }
  begin

    TabData := FTabDataList[ FTabIndex ];
    CurrentTabInView := TabInView( TabData );

    // Get first and last points of outline, for use in calculating the opening
    // where the current tab joins the front card

    CalcTabRegionPts( FTabIndex, Pts, NumPts );
    FirstRawPt := Point( Pts[ 0 ].X + 1, Pts[ 0 ].Y );
    LastRawPt := Pts[ NumPts - 1 ];
    FirstPt := CalcMapPoint( FirstRawPt );
    LastPt := CalcMapPoint( LastRawPt );

    // Put corners of mapped rect points into Pts[]

    CardRect := CalcMappedCardRect( ARow );
    NumPts := 4;
    Pts[ 0 ] := Point( CardRect.Left, CardRect.Top );
    Pts[ 1 ] := Point( CardRect.Right, CardRect.Top );
    Pts[ 2 ] := Point( CardRect.Right, CardRect.Bottom );
    Pts[ 3 ] := Point( CardRect.Left, CardRect.Bottom );

    // Build list of commands needed to draw the tab shape
    case FTabStyle of
      tsSingleSlant, tsDoubleSlant, tsCutCorner:
      begin
        if ( ARow > 0 ) or not CurrentTabInView then // Continuous card border
          GenerateContinuousBorderCommands
        else                              // Card border has gap where current tab meets card
          GenerateBrokenBorderCommands;
      end;

      tsRoundCorners:
      begin
        if ( ARow > 0 ) or not CurrentTabInView then // Continuous card border
          GenerateContinuousBorderCommands
        else
          GenerateBrokenRoundCornerCommands;
      end;
    end;
  end;
end; {= TRzCustomTabControl.CalcCardDrawCommands =}


procedure TRzCustomTabControl.PaintBackground( ACanvas: TCanvas; const ARect: TRect; var Handled: Boolean );
begin
  if Assigned( FOnPaintBackground ) then
    FOnPaintBackground( Self, ACanvas, ARect, Handled );
end;


procedure TRzCustomTabControl.PaintCardBackground( ACanvas: TCanvas; ARow: Integer; const ARect: TRect;
                                                   var Handled: Boolean );
begin
  if Assigned( FOnPaintCardBackground ) then
    FOnPaintCardBackground( Self, ACanvas, ARow, ARect, Handled );
end;


procedure TRzCustomTabControl.PaintTabBackground( ACanvas: TCanvas; ATabIndex: Integer; const ARect: TRect;
                                                  var Handled: Boolean );
begin
  if Assigned( FOnPaintTabBackground ) then
    FOnPaintTabBackground( Self, ACanvas, ATabIndex, ARect, Handled );
end;


function TRzCustomTabControl.CalcImageExtent( AImageIndex: TImageIndex ): TSize;
begin
  // Calculate size needed for image
  Result.cX := 0;
  Result.cY := 0;
  if ( AImageIndex <> -1 ) and ( FImages <> nil ) then
  begin
    Result.cX := FImages.Width;
    Result.cY := FImages.Height;
  end;
end;


// CalcTextExtent
//
// CalcTextExtent will determine the extent (X, Y) of the specified
// string. The string can be multi-line (CRLF at end of each line) and can
// contain a single ampersand character to indicate underlining or double
// ampersand characters to indicate the inclusion of a single ampersand in the
// text. The Horizontal parameter indicates if the text runs horizontally or
// vertically (i.e. sideways).

function TRzCustomTabControl.CalcTextExtent( const S: string; Horizontal: Boolean ): TSize;
var
  NextLine: string;
  Extent: TSize;
  DC: hDC;
  Lines: TStringList;
  I: Integer;

  // CalcExtent will determine the extent (width & height) of the NextLine
  // string; single and double ampersand character sequences in the string
  // are supported.

  procedure CalcExtent;
  var
    Pos1, Pos2: Integer;
    PlainText: string;
    PText: array[ 0..255 ] of Char;
    ActualY: Integer;
  begin
    Pos1 := Pos( '&', NextLine );
    if ( Pos1 = Length( NextLine ) ) then
    begin
      // If the string contains a '&' as the last character it will
      // usually be because DoTextOut is determining the length of the
      // first part of a caption which contains '&&' indicating a
      // literal '&' is to actually be displayed.  In this case
      // no underlining will occur so the length of the whole
      // string (including the '&') should be calculated.

      Pos1 := 0;
      Pos2 := 0;
    end
    else if Pos1 > 0 then
    begin
      Pos2 := Pos( '&', Copy( NextLine, Pos1 + 1, Length( NextLine ) ) );
      if Pos2 = 1 then
        Inc( Pos2, Pos1 )
      else
        Pos2 := 0;
    end
    else
      Pos2 := 0;

    // Check for special case of trailing single '&' which will occur
    // when getting the length of the first part of a string which
    // contained '&&', e.g. 'A&&A'

    if ( Pos1 > 0 ) and ( Pos2 <> Pos1 + 1 ) then
      PlainText := Copy( NextLine, 1, Pos1 - 1 ) + Copy( NextLine, Pos1 + 1, Length( NextLine ) )
    else if ( Pos1 > 0 ) and ( Pos2 = Pos1 + 1 ) then
      PlainText := Copy( NextLine, 1, Pos1 ) + Copy( NextLine, Pos2 + 1, Length( NextLine ) )
    else
      PlainText := NextLine;
    StrPCopy( PText, PlainText );

    if not GetTextExtentPoint32( DC, PText, StrLen( PText ), Extent ) then
    begin
      Extent.cX := 0;
      Extent.cY := 0;
    end;

    if not Horizontal then
    begin
      // The GetTextExtentPoint* functions don't seem to allow for when using
      // sideways text and thus still return the width and height AS IF THE
      // TEXT WERE HORIZONTAL, so we need to switch x and y extents.

      ActualY := Extent.cX;
      Extent.cX := Extent.cY;
      Extent.cY := ActualY;
    end;
  end; {= CalcExtent =}

begin {= TRzCustomTabControl.CalcTextExtent =}
  Result.cX := 0;
  Result.cY := 0;

  // Re-use same list object to speed things up by not recreating each time
  // (which starts to add up when there are lots of tabs)

  Lines := FCalcTextExtentLines;
  Lines.Clear;
  DC := FBuffer.Canvas.Handle;
  ParseTextLines( S, Lines );

  for I := 0 to Lines.Count - 1 do
  begin
    NextLine := Lines[ I ];
    CalcExtent;
    if Horizontal then
    begin
      // Total X extent is maximum of X extents of all lines,
      // Total Y extent is sum of Y extents of each line

      if Extent.cX > Result.cX then
        Result.cX := Extent.cX;
      Inc( Result.cY, Extent.cY );
    end
    else
    begin
      // Total X extent is sum of X extents of each line,
      // Total Y extent is maximum of Y extents of all lines

      Inc( Result.cX, Extent.cX );
      if Extent.cY > Result.cY then
        Result.cY := Extent.cY;
    end;
  end;
end; {= TRzCustomTabControl.CalcTextExtent =}


function TRzCustomTabControl.CalcTabExtentFromTabFaceExtent( TabFaceExtent: TSize ): TSize;
begin
  // TabFaceExtent will be the size of just the tab's caption -- allow for
  // 1 pixel border on all sides for focus rect

  Inc( TabFaceExtent.cX, 2 );
  Inc( TabFaceExtent.cY, 2 );

  // Now work out tab size needed to accomodate the tab face size

  case FTabStyle of
    tsSingleSlant:
    begin
      if FTabOrientation in [ toTop, toBottom ] then
      begin
        Result.cX := TabFaceExtent.cX + ( GetTabOffset( TabFaceExtent.cY + 4 ) * 2 ) + 4 + FTabHeight div 2;
        Result.cY := TabFaceExtent.cY + 4;
      end
      else
      begin
        Result.cX := TabFaceExtent.cX + 4;
        Result.cY := TabFaceExtent.cY + ( GetTabOffset( TabFaceExtent.cX + 4 ) * 2 ) + 4 + FTabHeight div 2;
      end;
    end;

    tsDoubleSlant:
    begin
      if FTabOrientation in [ toTop, toBottom ] then
      begin
        Result.cX := TabFaceExtent.cX + ( GetTabOffset( TabFaceExtent.cY ) * 2 ) + 4 + FTabHeight;
        Result.cY := TabFaceExtent.cY + 4;
      end
      else
      begin
        Result.cX := TabFaceExtent.cX + 4;
        Result.cY := TabFaceExtent.cY + ( GetTabOffset( TabFaceExtent.cX ) * 2 ) + 4 + FTabheight;
      end;
    end;

    tsCutCorner:
    begin
      if FTabOrientation in [ toTop, toBottom ] then
      begin
        if FTextOrientation = orVertical then
        begin
          Result.cX := TabFaceExtent.cX + 8;
          Result.cY := TabFaceExtent.cY + FCutCornerSize + 5;
        end
        else
        begin
          Result.cX := TabFaceExtent.cX + ( FCutCornerSize * 2 ) + 6;
          Result.cY := TabFaceExtent.cY + 5;
        end
      end
      else                                  // toLeft, toRight
      begin
        if FTextOrientation = orVertical then
        begin
          Result.cX := TabFaceExtent.cX + 5;
          Result.cY := TabFaceExtent.cY + ( FCutCornerSize * 2 ) + 6;
        end
        else
        begin
          Result.cX := TabFaceExtent.cX + FCutCornerSize + 5;
          Result.cY := TabFaceExtent.cY + 8;
        end;
      end;
    end;

    tsRoundCorners:
    begin
      Result := TabFaceExtent;
      if FTextOrientation = orVertical then
      begin
        Inc( Result.cX, 4 );
        Inc( Result.cY, 14 );
      end
      else
      begin
        Inc( Result.cX, 14 );
        Inc( Result.cY, 4 );
      end;
    end;

    else
    begin
      Result.cX := TabFaceExtent.cX;
      Result.cY := TabFaceExtent.cY;
    end;
  end;
end; {= TRzCustomTabControl.CalcTabExtentFromTabFaceExtent =}


// CalcTabFaceRect
//
// Return rect of tab face for specified raw rect.
// Note: Implicitly related to CalcTabExtentFromTabFaceExtent.

function TRzCustomTabControl.CalcTabFaceRect( ARect: TRect ): TRect;
begin
  Result := ARect;
  case FTabStyle of
    tsSingleSlant:
    begin
      if FTabOrientation in [ toTop, toBottom ] then
      begin
        InflateRect( Result, -1, -1 );
        Dec( Result.Right, 2 * GetTabOffset( ARect.Bottom - ARect.Top ) + 2 );
        OffsetRect( Result, 2, 0 );

        OffsetRect( Result, 1, 0 );

        if FTabOrientation = toTop then
          Inc( Result.Top, 2 )
        else
          Dec( Result.Bottom, 2 );

        if FTabOrientation = toBottom then
          OffsetRect( Result, 0, 1 );
      end
      else
      begin
        InflateRect( Result, -1, -1 );
        if FTabOrientation = toLeft then
        begin
          Inc( Result.Top, 2 * GetTabOffset( ARect.Right - ARect.Left ) + 2 );
          OffsetRect( Result, 0, -2 );
        end
        else
        begin
          Dec( Result.Bottom, 2 * GetTabOffset( ARect.Right - ARect.Left ) + 2 );
          OffsetRect( Result, 0, 2 );
        end;

        OffsetRect( Result, 0, 1 );
        if FTabOrientation = toLeft then
          Inc( Result.Left, 2 )
        else
          Dec( Result.Right, 2 );
        if FTabOrientation = toRight then
          OffsetRect( Result, 1, 0 );
      end;
    end; { case tsSingleSlant }

    tsDoubleSlant:
    begin
      if FTabOrientation in [ toTop, toBottom ] then
      begin
        InflateRect( Result, 1, -1 );
        InflateRect( Result, -GetTabOffset( ARect.Bottom - ARect.Top ), 0 );
        OffsetRect( Result, 1, 0 );

        if FTabOrientation = toTop then
          Inc( Result.Top, 2 )
        else
          Dec( Result.Bottom, 2 );

        if FTabOrientation = toBottom then
          OffsetRect( Result, 0, 1 );
      end
      else
      begin
        InflateRect( Result, -1, 1 );
        InflateRect( Result, 0, -GetTabOffset( ARect.Right - ARect.Left ) );
        Inc( Result.Bottom, 2 );
        OffsetRect( Result, 0, 1 );

        if FTabOrientation = toLeft then
          Inc( Result.Left, 2 )
        else
          Dec( Result.Right, 2 );
        if FTabOrientation = toRight then
          OffsetRect( Result, 1, 0 );
      end;
    end; { case tsDoubleSlant }

    tsCutCorner:
    begin
      if FTabOrientation in [ toTop, toBottom ] then
      begin
        if FTextOrientation = orVertical then
        begin
          InflateRect( Result, -4, -1 );
          if FTabOrientation = toTop then
            Inc( Result.Top, FCutCornerSize + 3 )
          else
            Dec( Result.Bottom, FCutCornerSize + 3 );
        end
        else
        begin
          InflateRect( Result, -( FCutCornerSize + 3 ), -1 );
          if FTabOrientation = toTop then
            Inc( Result.Top, 3 )
          else
            Dec( Result.Bottom, 3 );
        end;
        if FTabOrientation = toBottom then
          OffsetRect( Result, 0, 1 );
      end
      else                                  { toLeft, toRight }
      begin
        if FTextOrientation = orVertical then
        begin
          InflateRect( Result, -1, -( FCutCornerSize + 3 ) );
          if FTabOrientation = toLeft then
            Inc( Result.Left, 5 )
          else
            Dec( Result.Right, 5 );
        end
        else
        begin
          InflateRect( Result, -1, -4 );
          if FTabOrientation = toLeft then
            Inc( Result.Left, FCutCornerSize + 5 )
          else
            Dec( Result.Right, FCutCornerSize + 5 );
        end;
        if FTabOrientation = toRight then
          OffsetRect( Result, 1, 0 );
      end;
    end; { case tsCutCorner }

    tsRoundCorners:
    begin
      if FTextOrientation = orVertical then
        InflateRect( Result, -2, -4 )
      else
        InflateRect( Result, -4, -2 );
    end;
  end; { case }

  // Size of Result includes the 1 pixel border for the focus rect -- deflate
  // to return just the text rect

  InflateRect( Result, -1, -1 );
end; {= TRzCustomTabControl.CalcTabFaceRect =}



// CalcDefaultTabFaceExtent
//
// Calculate the default size tab face to be used.  The tab face would, for
// example, be this size when the tab caption is a single character and has no
// image.  This ensures that tabs with short captions aren't all scrunched up.

function TRzCustomTabControl.CalcDefaultTabFaceExtent( AFont: TFont ): TSize;
var
  MinExtent: TSize;
  Horizontal: Boolean;                      // Horizontal tab text
  OldStyle: TFontStyles;
begin
  Horizontal := FTextOrientation = orHorizontal;

  OldStyle := FTextFont.Style;
  if FBoldCurrentTab then   // calculate all extents using bold font
    FTextFont.Style := FTextFont.Style + [ fsBold ];

  SelectFont;
  if FTabStyle = tsRoundCorners then
    MinExtent := CalcTextExtent( 'AAA', Horizontal )
  else
    MinExtent := CalcTextExtent( 'A', Horizontal );

  DeselectFont;
  FTextFont.Style := OldStyle;

  if FTextOrientation = orVertical then
  begin
    Result.cX := Abs( AFont.Height );
    Result.cY := MinExtent.cY;
  end
  else
  begin
    Result.cX := MinExtent.cX;
    Result.cY := Abs( AFont.Height );
  end;
end; {= TRzCustomTabControl.CalcDefaultTabFaceExtent =}


procedure TRzCustomTabControl.CalcMetrics;
var
  MaxTabFaceExtent: TSize;
  MaxTabExtent: TSize;

  // Calculate the extent (X, Y) of the minimum sized rect
  // needed to bound the tab's caption and image.

  function CalcTabFaceExtent( ATabIndex: Integer; TabData: TRzTabData ): TSize;
  var
    ImageSize: TSize;
    TextSize: TSize;
    MinSize: TSize;
    OldStyle: TFontStyles;
  begin
    Result.cX := 0;
    Result.cY := 0;
    if not TabData.Visible then
      Exit;

    // Calculate size needed for image
    ImageSize := CalcImageExtent( TabData.ImageIndex );

    OldStyle := FTextFont.Style;
    if FBoldCurrentTab then   // select bold font to allow for extra size needed
      FTextFont.Style := FTextFont.Style + [ fsBold ];

    SelectFont;
    TextSize.cX := 0;
    TextSize.cY := 0;
    if Length( TabData.Caption ) > 0 then
      TextSize := CalcTextExtent( TabData.Caption, FTextOrientation = orHorizontal );
    DeselectFont;
    FTextFont.Style := OldStyle;

    // Now calculate total size required
    case FImagePosition of
      ipTop, ipBottom:
      begin
        Result.cX := Max( ImageSize.cX, TextSize.cX );
        Result.cY := ImageSize.cY + FImageMargin + TextSize.cY;
      end;

      ipLeft, ipRight:
      begin
        Result.cX := ImageSize.cX + FImageMargin + TextSize.cX;
        Result.cY := Max( ImageSize.cY, TextSize.cY );
      end;

      ipBack:                               // Use larger of image and text sizes in each dimension }
      begin
        Result.cX := Max( ImageSize.cX, TextSize.cX );
        Result.cY := Max( ImageSize.cY, TextSize.cY );
      end;

      ipStretch:                            // Stretch size of image to match text size }
      begin
        Result := TextSize;
      end;
    end;

    // Check that tab face is not less than default size when using
    // automatic sizing (TabWidth or TabHeight is zero)

    MinSize := CalcDefaultTabFaceExtent( FTextFont );
    if ( FTabWidth = 0 ) and ( Result.cX < MinSize.cX ) then
      Result.cX := MinSize.cX;
    if ( FTabHeight = 0 ) and ( Result.cY < MinSize.cY ) then
      Result.cY := MinSize.cY;
  end; {= CalcTabFaceExtent =}


  // Calculate the maximum tab face extent, i.e. the minimum size rect
  // within which each of the tab's captions + images would fit.

  function CalcMaxTabFaceExtent: TSize;
  var
    I: Integer;
    TabData: TRzTabData;
    Extent: TSize;
  begin
    Result.cX := 0;
    Result.cY := 0;
    for I := 0 to FTabDataList.Count - 1 do
    begin
      TabData := FTabDataList[ I ];
      if TabData.Visible then
      begin
        Extent := CalcTabFaceExtent( I, TabData );
        if Extent.cX > Result.cX then
          Result.cX := Extent.cX;
        if Extent.cY > Result.cY then
          Result.cY := Extent.cY;
      end;
    end;
  end; {= CalcMaxTabFaceExtent =}


  function CalcMaxTabExtent: TSize;
  var
    I: Integer;
    TabData: TRzTabData;
    Extent: TSize;
    FaceExtent: TSize;
    MinExtent: TSize;
    OldStyle: TFontStyles;
  begin
    Result.cX := 0;
    Result.cY := 0;

    OldStyle := FTextFont.Style;
    if FBoldCurrentTab then   // Select bold font to allow for extra size needed
      FTextFont.Style := FTextFont.Style + [ fsBold ];

    SelectFont;
    MinExtent := CalcDefaultTabFaceExtent( Font );

    for I := 0 to FTabDataList.Count - 1 do
    begin
      TabData := FTabDataList[ I ];
      if TabData.Visible then
      begin
        FaceExtent := CalcTabFaceExtent( I, TabData );
        if FaceExtent.cX < MinExtent.cX then
          FaceExtent.cX := MinExtent.cX;
        if FaceExtent.cY < MinExtent.cY then
          FaceExtent.cY := MinExtent.cY;
        Extent := CalcTabExtentFromTabFaceExtent( FaceExtent );
        if Extent.cX > Result.cX then
          Result.cX := Extent.cX;
        if Extent.cY > Result.cY then
          Result.cY := Extent.cY;
      end;
    end;
    DeselectFont;
    FTextFont.Style := OldStyle;

    //  Override if fixed width or fixed height specified
    if FTabWidth > 0 then
      Result.cX := FTabWidth;
    if FTabHeight > 0 then
      Result.cY := FTabHeight;
  end; {= CalcMaxTabExtent =}


  procedure CheckWidth( var TabWidth: Integer; IndexWidth: Integer );
  var
    Adjustment: Integer;
  begin
    if ( FTabStyle = tsRoundCorners ) then
      Adjustment := 4                       // Tab Control style inflates current tab
    else
      Adjustment := 0;
    if ( TabWidth > IndexWidth - Adjustment ) then // Truncate width
      TabWidth := IndexWidth - Adjustment;
  end; {= CheckWidth =}


  function CalcActualTabExtent( ATabIndex: Integer; TabData: TRzTabData ): TSize;
  var
    FaceExtent: TSize;
  begin
    FaceExtent := CalcTabFaceExtent( ATabIndex, TabData );
    if FTabOrientation in [ toTop, toBottom ] then
    begin
      if FaceExtent.cY < MaxTabFaceExtent.cY then
        FaceExtent.cY := MaxTabFaceExtent.cY;
    end
    else
    begin
      if FaceExtent.cX < MaxTabFaceExtent.cX then
        FaceExtent.cX := MaxTabFaceExtent.cX;
    end;
    Result := CalcTabExtentFromTabFaceExtent( FaceExtent );
    if FTabWidth > 0 then
      Result.cX := FTabWidth;
    if FTabHeight > 0 then
      Result.cY := FTabHeight;
  end; {= CalcActualTabExtent =}


  // CalcRowsNeeded
  //
  // Calculate no. of rows of tabs needed and return the result.
  // This is an iterative process because each time the row count increases
  // it means the available tab index width (for all rows) needs to be reduced
  // (by an amount of RowIndent) and the process started again.

  function CalcRowsNeeded: Integer;
  var
    I, L, H, W: Integer;
    TabData: TRzTabData;
    TabExtent: TSize;
    MaxIdx, MaxIndexWidth: Integer;
    RowCount, TabCount, MinRowCount: Integer;
  begin
    Result := 1;
    if FMultiLine then
    begin
      H := FFixedDimension;
      L := FMargin;
      MaxIndexWidth := GetIndexWidth - ( FMargin * 2 );
      RowCount := 1;
      MinRowCount := 1;
      TabCount := FTabDataList.Count;
      MaxIdx := GetLastVisible;
      I := 0;
      while I < TabCount do
      begin
        TabData := FTabDataList[ I ];
        if TabData.Visible then
        begin
          TabExtent := CalcActualTabExtent( I, TabData );
          if ( FTabOrientation in [ toTop, toBottom ] ) then
            W := TabExtent.cX
          else
            W := TabExtent.cY;

          CheckWidth( W, MaxIndexWidth );
          if ( L + W >= MaxIndexWidth ) then // Full width of tab won't fit
          begin
            if RowCount < MinRowCount then
            begin
              Inc( RowCount );
              if ( L = FMargin ) then       // Only tab in row and W = MaxIndexWidth
                Inc( I );
            end
            else if ( L > FMargin ) or ( ( L = FMargin ) and ( I < MaxIdx ) ) then
            begin
              Inc( MinRowCount );
              Dec( MaxIndexWidth, FRowIndent );
              I := 0;                       // Restart using reduced MaxIndexWidth
              RowCount := 1;
            end
            else
            begin
              { L = 0 and I = MaxIdx, i.e. last tab }
              Inc( I );
            end;
            L := FMargin;
          end
          else
          begin
            Inc( I );
            L := L + W - GetTabOffset( H ) + 1;
          end;
        end
        else
          Inc( I );
      end;
      Result := RowCount;
    end;
  end; {= CalcRowsNeeded =}


  // CalcRawTabRects
  //
  // Calculate the 'raw' tab rects for all tabs.  The 'raw' rect is the rect the
  // tab would have if the tabset was drawn in its actual orientation and the
  // entire tabset then rotated (if necessary) to top orientation.
  // tsStandard tabs are like this: [ A ][ B ][ C ]...
  // tsReverse tabs are like this: ...[ C ][ B ][ A ]
  // The raw tab rects only need to be recalculated when anything to do with an
  // individual tab is changed (caption, font, visible).
  // Other actions such as scrolling the tabs do not require the raw tab rects
  // to be recalculated.

  procedure CalcRawTabRects;
  var
    I, H, W, L, R, T, Offset, RowIdx, MaxIndexWidth: Integer;
    Box: TRect;
    TabData: TRzTabData;
    TabExtent: TSize;
  begin
    SetRowExtent( CalcRowsNeeded );
    H := FFixedDimension;
    T := GetIndexHeight - H;
    RowIdx := 0;
    MaxIndexWidth := GetIndexWidth - ( FMargin * 2 );
    if FMultiLine then
      MaxIndexWidth := MaxIndexWidth - ( ( FRowExtent - 1 ) * FRowIndent )
    else
    begin
      if FShowCloseButton then
        MaxIndexWidth := MaxIndexWidth - GetCloseButtonSize - ScrollBtnMargin;
      MaxIndexWidth := MaxIndexWidth - ( GetScrollerSize * 2 ) - ScrollBtnMargin;
    end;

    // Actual row indent (which is *not* the same thing as margin) for each row
    // is added later when displaying because it will depend on the actual order
    // in which the rows are displayed at that time

    L := FMargin;
    R := -FMargin;
    I := 0;
    while I < FTabDataList.Count do
    begin
      TabData := FTabDataList[ I ];
      if TabData.Visible then
      begin
        TabExtent := CalcActualTabExtent( I, TabData );
        if ( FTabOrientation in [ toTop, toBottom ] ) then
          W := TabExtent.cX
        else
          W := TabExtent.cY;
        CheckWidth( W, MaxIndexWidth );
        if ( FTabSequence = tsStandard ) then
        begin
          if FMultiLine then
          begin
            if ( L + W >= MaxIndexWidth ) then
            begin
              if L = FMargin then           // only tab in row
              begin
                TabData.Row := RowIdx;
                Box := Rect( L, T, L + W, T + H );
                Inc( I );
              end
              else                          // process this tab again in next row
                L := FMargin;
              Dec( T, H - FRowOverlap );
              Inc( RowIdx );
            end
            else
            begin
              TabData.Row := RowIdx;
              Box := Rect( L, T, L + W, T + H );
              L := L + W - GetTabOffset( H ) + 1;
              Inc( I );
            end
          end
          else
          begin
            TabData.Row := RowIdx;
            Box := Rect( L, T, L + W, T + H );
            L := L + W - GetTabOffset( H ) + 1;
            Inc( I );
          end;
          TabData.RawRect := Box;
        end
        else                                // tsReverse
        begin
          if FMultiLine then
          begin
            if ( R - W <= -MaxIndexWidth ) then
            begin
              if R = -FMargin then          // Only tab in row
              begin
                TabData.Row := RowIdx;
                Box := Rect( R - W, T, R, T + H );
                Inc( I );
              end
              else                          // Process this tab again in next row
                R := -FMargin;
              Dec( T, H - FRowOverlap );
              Inc( RowIdx );
            end
            else
            begin
              TabData.Row := RowIdx;
              Box := Rect( R - W, T, R, T + H );
              R := R - W + GetTabOffset( H ) - 1;
              Inc( I );
            end
          end
          else
          begin
            TabData.Row := RowIdx;
            Box := Rect( R - W, T, R, T + H );
            R := R - W + GetTabOffset( H ) - 1;
            Inc( I );
          end;
          TabData.RawRect := Box;
        end;
      end
      else
        Inc( I );
    end;

    if FTabSequence = tsReverse then
    begin
      // Offset all raw tab rects so leftmost is at 0,0
      if FMultiLine then                    // Current value of R not relevant
        Offset := Width
      else
        Offset := Abs( R );

      for I := 0 to FTabDataList.Count - 1 do
      begin
        TabData := FTabDataList[ I ];
        if TabData.Visible then
        begin
          Box := TabData.RawRect;
          Inc( Box.Left, Offset );
          Inc( Box.Right, Offset );
          TabData.RawRect := Box;
        end;
      end;
    end;

  end; {= CalcRawTabRects =}


  // SetFixedDimension
  //
  // SetFixedDimension determines the extent of the 'fixed dimension', which is
  // the height for top/bottom tab orientation and the width for left/right
  // tab orientation.
  // In top/bottom orientation all tabs will always have the same height.
  // In left/right orientation all tabs will always have the same width.

  procedure SetFixedDimension( Extent: TSize );
  begin
    if ( FTabOrientation = toTop ) or ( FTabOrientation = toBottom ) then
      FFixedDimension := Extent.cY
    else
      FFixedDimension := Extent.cX;
  end;


  // Divides any extra space at the end of each row amongst the tabs in that
  // row so they are aligned with both the left and right margins of the cards.
  // The no. of rows of tabs is unchanged.

  procedure AlignRawTabRects;
  var
    I, MaxIdx, FirstIdxInRow, TabsInRow: Integer;
    TabData, PrevTabData: TRzTabData;

    // Align the tabs with indexes FirstIdx..LastIdx so they fill the row (from margin to margin).

    procedure AlignRow( FirstIdx, LastIdx, TabCount: Integer );
    var
      I, MaxIndexWidth, RowWidth, Extra, Quotient, Remainder, Offset: Integer;
      TabToAlign: TRzTabData;
      Box: TRect;
    begin
      MaxIndexWidth := GetIndexWidth - ( FMargin * 2 );
      MaxIndexWidth := MaxIndexWidth - ( ( FRowExtent - 1 ) * FRowIndent );
      if FTabSequence = tsStandard then
        RowWidth := FTabDataList[ LastIdx ].RawRect.Right - FTabDataList[ FirstIdx ].RawRect.Left
      else
        RowWidth := FTabDataList[ FirstIdx ].RawRect.Right - FTabDataList[ LastIdx ].RawRect.Left;

      if FTabStyle = tsRoundCorners then
        Inc( RowWidth, 4 );                 // +2 on either side allowed for enlarged current tab
      Extra := MaxIndexWidth - RowWidth;
      if Extra <= 0 then
        Exit;                               // Should never happen (tabs already fit)

      Quotient := Extra div TabCount;
      Remainder := Extra mod TabCount;
      Offset := 0;

      for I := FirstIdx to LastIdx do
      begin
        TabToAlign := FTabDataList[ I ];
        if TabToAlign.Visible then
        begin
          Box := TabToAlign.RawRect;
          Extra := Quotient;                // Start with whole amount
          if Remainder > 0 then
          begin
            Inc( Extra );                   // Plus one from remainder
            Dec( Remainder );
          end;

          // Offset each raw rect (to allow for lengthening of previous tabs in row) and then extend

          if FTabSequence = tsStandard then
          begin
            Inc( Box.Left, Offset );
            Inc( Box.Right, Offset + Extra );
          end
          else
          begin
            Dec( Box.Right, Offset );
            Dec( Box.Left, Offset + Extra );
          end;
          TabToAlign.RawRect := Box;
          Inc( Offset, Extra );
        end;
      end;
    end; {= AlignRow =}

  begin {= AlignRawTabRects =}

    // Only perform alignment if necessary prerequisites met.
    if not ( FMultiLine and FAlignTabs and
      ( ( ( FTabOrientation in [ toTop, toBottom ] ) and ( FTabWidth = 0 ) ) or
        ( ( FTabOrientation in [ toLeft, toRight ] ) and ( FTabHeight = 0 ) ) ) ) then
    begin
      Exit;
    end;

    PrevTabData := nil;
    MaxIdx := FTabDataList.Count - 1;
    FirstIdxInRow := -1;
    TabsInRow := 0;

    for I := 0 to MaxIdx do
    begin
      TabData := FTabDataList[ I ];
      if TabData.Visible then
      begin
        if FirstIdxInRow = -1 then
          FirstIdxInRow := TabData.Row;

        if PrevTabData = nil then
          PrevTabData := TabData;

        if ( TabData.Row <> PrevTabData.Row ) or ( I = MaxIdx ) then // new/last row
        begin
          if ( TabData.Row <> PrevTabData.Row ) then // align previous tab
          begin
            AlignRow( FirstIdxInRow, I - 1, TabsInRow );
            FirstIdxInRow := I;
            TabsInRow := 0;
          end;
          if ( I = MaxIdx ) then            // align very last tab
          begin
            Inc( TabsInRow );
            AlignRow( FirstIdxInRow, I, TabsInRow );
          end;
          FirstIdxInRow := I;
        end;
        Inc( TabsInRow );
        PrevTabData := TabData;
      end;
    end;
  end; {= AlignRawTabRects =}

begin {= TRzCustomTabControl.CalcMetrics =}
  MaxTabFaceExtent := CalcMaxTabFaceExtent;
  MaxTabExtent := CalcMaxTabExtent;
  SetFixedDimension( MaxTabExtent );
  CalcRawTabRects;
  AlignRawTabRects;
end; {= TRzCustomTabControl.CalcMetrics =}


function TRzCustomTabControl.GetTabOffset( ATabHeight: Integer ): Integer;
begin
  // This controls the spacing between tabs
  case FTabStyle of
    tsSingleSlant:
      Result := ATabHeight div 2;

    tsDoubleSlant:
      Result := ATabHeight;

    tsCutCorner:
      Result := -1;

    else
      Result := -1;
  end;
end;


procedure TRzCustomTabControl.SetMultiLine( Value: Boolean );
begin
  if FMultiLine <> Value then
  begin
    FMultiLine := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetRowExtent( Value: Integer );
begin
  FRowExtent := Value;
end;


procedure TRzCustomTabControl.SetRowOverlap( Value: Integer );
begin
  if ( Value >= 0 ) and ( FRowOverlap <> Value ) then
  begin
    FRowOverlap := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetRowIndent( Value: Integer );
begin
  if ( Value >= 0 ) and ( FRowIndent <> Value ) then
  begin
    FRowIndent := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.CreateScroller;
begin
  FScroller := TRzTabScroller.Create( Self );
  FScroller.Parent := Self;
  FScroller.ControlStyle := FScroller.ControlStyle + [ csNoDesignVisible ];
  FScroller.FrameColor := AdjustColor( FFlatColor, FFlatColorAdjustment );

  FScroller.OnDownLeftClick := ScrollDownLeftClickHandler;
  FScroller.OnUpRightClick := ScrollUpRightClickHandler;
end;


procedure TRzCustomTabControl.CreateCloseButton;
begin
  FCloseButton := TRzTabCloseButton.Create( Self );
  FCloseButton.Parent := Self;
  FCloseButton.ControlStyle := FCloseButton.ControlStyle + [ csNoDesignVisible ];
  FCloseButton.FrameColor := AdjustColor( FFlatColor, FFlatColorAdjustment );

  FCloseButton.OnClose := CloseButtonClickHandler;
end;



// TabInView
//
// Whereas TRzTabData.Visible indicates that the tab can be shown,
// TabInView indicates that the tab is currently showing which depends on
// the scrolled position of all the tabs.

function TRzCustomTabControl.TabInView( TabData: TRzTabData ): Boolean;
var
  IndexWidth: Integer;
begin
  if TabData.Visible then
  begin
    if FScrollerNeeded then
    begin
      IndexWidth := GetIndexWidth - ( GetScrollerSize * 2 ) - ( FMargin * 2 );
      if FShowCloseButton then
        IndexWidth := IndexWidth - GetCloseButtonSize;


      Result := ( ( FTabSequence = tsStandard ) and
                  ( TabData.RawRect.Left >= GetInitialTabOffset ) and
                  ( TabData.RawRect.Right - GetInitialTabOffset <= IndexWidth ) )
                or
                ( ( FTabSequence = tsReverse ) and
                  ( TabData.RawRect.Right <= GetInitialTabOffset ) and
                  ( GetInitialTabOffset - TabData.RawRect.Left <= IndexWidth ) );
    end
    else
      Result := True;
  end
  else
    Result := False;
end;


procedure TRzCustomTabControl.ScrollUpRightClickHandler( Sender: TObject );
var
  Next: Boolean;
begin
  Next := False;
  case FTabOrientation of
    toTop, toBottom, toLeft:
      Next := FTabSequence = tsStandard;

    toRight:
      Next := not ( FTabSequence = tsStandard );
  end;
  ScrollTabs( Next );
end;


procedure TRzCustomTabControl.ScrollDownLeftClickHandler( Sender: TObject );
var
  Next: Boolean;
begin
  Next := False;
  case FTabOrientation of
    toTop, toBottom, toLeft:
      Next := not ( FTabSequence = tsStandard );

    toRight:
      Next := FTabSequence = tsStandard;
  end;
  ScrollTabs( Next );
end;


procedure TRzCustomTabControl.ScrollTabs( Next: Boolean );
var
  OldFirstInView: Integer;
begin
  OldFirstInView := FFirstInView;
  if Next and ( FFirstInView < FTabDataList.Count - 1 ) and not TabInView( FTabDataList[ GetLastVisible ] ) then
  begin
    repeat
      Inc( FFirstInView );
    until ( FFirstInView = FTabDataList.Count ) or TabInView( FTabDataList[ FFirstInView ] );

    if FFirstInView = FTabDataList.Count then
      FFirstInView := OldFirstInView
    else
      InvalidateControl;
  end
  else if ( not Next ) and ( FFirstInView > 0 ) and not TabInView( FTabDataList[ GetFirstVisible ] ) then
  begin
    repeat
      Dec( FFirstInView );
    until ( FFirstInView < 0 ) or TabInView( FTabDataList[ FFirstInView ] );

    if FFirstInView < 0 then
      FFirstInView := OldFirstInView
    else
      InvalidateControl;
  end;
end; {= TRzCustomTabControl.ScrollTabs =}


procedure TRzCustomTabControl.DestroyActiveTab;
begin
  // Real processing handled in descendant classes
end;


procedure TRzCustomTabControl.ActiveTabMoved( Index: Integer );
begin
  // Real processing handled in descendant classes
end;


function TRzCustomTabControl.CanClose: Boolean;
begin
  Result := False;
  if Assigned( FOnClose ) then
    FOnClose( Self, Result );
end;


procedure TRzCustomTabControl.CloseActiveTab;
begin
  if FTabIndex <> -1 then
  begin
    if CanClose then
      DestroyActiveTab;
  end;
end;


procedure TRzCustomTabControl.CloseButtonClickHandler( Sender: TObject );
begin
  CloseActiveTab;
end;


procedure TRzCustomTabControl.SetCalcNeeded( Value: Boolean );
begin
  if FCalcNeeded <> Value then
  begin
    FCalcNeeded := Value;
    if FCalcNeeded then
      InvalidateControl;
  end;
end;



procedure TRzCustomTabControl.WMEraseBkgnd( var Msg: TWMEraseBkgnd );
begin
  // WMEraseBkgdn does nothing -- all 'erasing' is handled by Paint so that
  // an off-screen bitmap can be used (i.e. double buffering).

  // Let Paint take care of everything
  Msg.Result := 1;
end;


procedure TRzCustomTabControl.CheckCalcNeeded;
var
  NewTabIndex: Integer;
  OldFirstInView: Integer;
  FirstVisibleIdx: Integer;
begin
  if FCalcNeeded then
  begin
    SetCalcNeeded( False );
    CalcMetrics;
    FTabRegionCache.Clear;
    OldFirstInView := FFirstInView;
    FirstVisibleIdx := GetFirstVisible;     // *not* the same as first in view
    CalcScrollerNeeded;

    if FScrollerNeeded then
    begin
      // Check in forwards direction for first tab in view
      while ( FFirstInView >= 0 ) and ( FFirstInView < FTabDataList.Count ) and
            not TabInView( FTabDataList[ FFirstInView ] ) do
      begin
        Inc( FFirstInView );
      end;

      if FFirstInView = FTabDataList.Count then
      begin
        // Check backwards from initial position
        FFirstInView := OldFirstInView - 1;
        while ( FFirstInView >= 0 ) and not TabInView( FTabDataList[ FFirstInView ] ) do
          Dec( FFirstInView );

        // FFirstInView will be -1 if no tabs are visible
      end;

      if FFirstInView < 0 then
        FFirstInView := FirstVisibleIdx;
    end
    else
      FFirstInView := FirstVisibleIdx;

    if FirstVisibleIdx >= 0 then
    begin
      if FTabIndex < 0 then
      begin
        // When FTabIndex is -1 don't automatically select another tab; this
        // is necessary for page controls to allow the current page to remain
        // active when its tab is deleted by setting the TabIndex to -1 prior to
        // doing Rebuild (to remove the deleted tab).
        NewTabIndex := -1;
      end
      else
        NewTabIndex := FTabIndex;
    end
    else
      NewTabIndex := -1;

    // Check in forwards direction for first tab that is visible and enabled
    // (but not necessarily in view)

    while ( NewTabIndex >= 0 ) and ( NewTabIndex < FTabDataList.Count ) and not CanSelectTab( NewTabIndex ) do
      Inc( NewTabIndex );

    if NewTabIndex = FTabDataList.Count then
    begin
      // Check backwards from initial position
      NewTabIndex := FTabIndex;
      if NewTabIndex = FTabDataList.Count then // Current tab was just deleted
        Dec( NewTabIndex );

      while ( NewTabIndex >= 0 ) and not CanSelectTab( NewTabIndex ) do
        Dec( NewTabIndex );

      // NewTabIndex will be -1 if no tabs are visible
    end;

    if NewTabIndex <> FTabIndex then
    begin
      // OnChanging event will have already been generated by CanSelectTab --
      // set flag to prevent duplicate event being generated by SetTabIndex
      FChangingDone := True;
    end;

    // SetTabIndex is called so that even if NewTabIndex = TabIndex the current
    // tab will be brought into view and/or the first row.

    SetTabIndex( NewTabIndex );
    FChangingDone := False;
    DoRealign;
  end;
end; {= TRzCustomTabControl.CheckCalcNeeded =}


procedure TRzCustomTabControl.BringTabToFrontRow( TabData: TRzTabData );
var
  I, NewFrontRow, MaxRow, NumRows, NumShifts: Integer;
  ATabData: TRzTabData;
  RectList: TList;
  Item: TRectClass;
  ARect: TRect;
begin
  if not FMultiLine then
    Exit;

  RectList := TList.Create;
  try
    NewFrontRow := TabData.Row;
    MaxRow := 0;
    for I := 0 to FTabDataList.Count - 1 do
    begin
      ATabData := FTabDataList[ I ];
      if ATabData.Row > MaxRow then
        MaxRow := ATabData.Row;
    end;
    NumRows := MaxRow + 1;

    // Add enough items to list to allow for all rows -- the index of each item
    // in the list then corresponds to the row no.

    for I := 0 to NumRows - 1 do
      RectList.Add( nil );

    // Save the rects of _a_ tab for each row -- since we are only
    // interested in the Top and Bottom values in the rects it doesn't matter
    // which tab from a row is used as they all have the same Top and Bottom

    for I := 0 to FTabDataList.Count - 1 do
    begin
      ATabData := FTabDataList[ I ];
      if ATabData.Visible then
      begin
        if RectList[ ATabData.Row ] = nil then
        begin
          Item := TRectClass.Create;
          Item.Rect := ATabData.RawRect;
          RectList[ ATabData.Row ] := Item;
        end;
      end;
    end;

    // Rows are shifted in a circular order, i.e. they stay in the same relative
    // order and we just change which row is the first row

    NumShifts := ( NumRows - NewFrontRow ) mod NumRows;
    for I := 0 to FTabDataList.Count - 1 do
    begin
      ATabData := FTabDataList[ I ];
      if ATabData.Visible then
      begin
        // Determine new row position for this tab
        ATabData.Row := ( ATabData.Row + NumShifts ) mod NumRows;
        // Get old rect for row from list and adjust Top and Bottom of RawRect
        ARect := ATabData.RawRect;
        Item := TRectClass( RectList[ ATabData.Row ] );
        ARect.Top := Item.Rect.Top;
        ARect.Bottom := Item.Rect.Bottom;
        ATabData.RawRect := ARect;
      end;
    end;
  finally
    for I := 0 to RectList.Count - 1 do
      TRectClass( RectList[ I ] ).Free;
    RectList.Free;
  end;
end; {= TRzCustomTabControl.BringTabToFrontRow =}


// SelectFont will create a new font handle for a font with the required
// metrics (taken from FTextFont) and select it into the buffer's canvas in
// preparation for use during text metric calculations or text output.

procedure TRzCustomTabControl.SelectFont;
var
  Escapement: Integer;
  LogFont: TLogFont;
  NewHFont: HFont;
begin
  case FTabOrientation of
    toLeft, toTop, toBottom:
    begin
      if FTextOrientation = orVertical then
        Escapement := 900
      else
        Escapement := 0;
    end;

    toRight:
    begin
      if FTextOrientation = orVertical then
        Escapement := 2700
      else
        Escapement := 0;
    end;

    else
      Escapement := 0;
  end;

  // Must initialise all fields of the record structure
  with LogFont do
  begin
    lfHeight := FTextFont.Height;
    lfWidth := 0;                           // have font mapper choose
    lfEscapement := Escapement;
    lfOrientation := 0;                     // no rotation
    if ( fsBold in FTextFont.Style ) then
      lfWeight := FW_BOLD
    else
      lfWeight := FW_NORMAL;
    lfItalic := Byte( fsItalic in FTextFont.Style );
    lfUnderline := Byte( fsUnderline in FTextFont.Style );
    lfStrikeOut := Byte( fsStrikeOut in FTextFont.Style );
    lfCharSet := DEFAULT_CHARSET;
    StrPCopy( lfFaceName, FTextFont.Name );
    lfQuality := DEFAULT_QUALITY;
    // Everything else as default
    lfOutPrecision := OUT_DEFAULT_PRECIS;
    lfClipPrecision := CLIP_DEFAULT_PRECIS;
    lfPitchAndFamily := DEFAULT_PITCH;
  end;

  NewHFont := CreateFontIndirect( LogFont );

  // Save the current DC state so the current font object can be restored

  if SaveDC( FBuffer.Canvas.Handle ) = 0 then
    raise Exception.Create( sRzSavingDCError );

  // Save the handle of the font object on our 'stack'
  PushHFont( NewHFont );

  // and select the new font into the buffer's canvas
  SelectObject( FBuffer.Canvas.Handle, NewHFont );
end; {= TRzCustomTabControl.SelectTextFont =}



procedure TRzCustomTabControl.DeselectFont;
begin
  // Restore a previously selected font in the buffer's canvas.

  if RestoreDC( FBuffer.Canvas.Handle, -1 ) = WordBool( 0 ) then
    raise Exception.Create( sRzRestoringDCError );

  // Delete the deselected font object
  DeleteObject( PopHFont );
end;


procedure TRzCustomTabControl.PushHFont( Value: HFont );
begin
  // Push the specified value onto our 'stack' of font handles.
  // The last value in the list corresponds to the top of the stock
  // and the value at the top of the stack corresponds to the currently
  // selected font object in the buffer's canvas.

  FHFonts.Add( TObject( Value ) );
end;



function TRzCustomTabControl.PopHFont: HFont;
begin
  // Pop the top most (i.e. last) value from the 'stack' of font handles.

  Result := 0;
  if FHFonts.Count > 0 then
  begin
    Result := HFont( FHFonts[ FHFonts.Count - 1 ] );
    FHFonts.Delete( FHFonts.Count - 1 );
  end;
end;


procedure TRzCustomTabControl.CMFontChanged( var Msg: TMessage );
begin
  // Copy the current font into the FTextFont field
  FTextFont.Assign( Self.Font );
  Rebuild;
  inherited;
end;


procedure TRzCustomTabControl.SetImageAlignment( Value: TRzHorizontalAlignment );
begin
  if FImageAlignment <> Value then
  begin
    FImageAlignment := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetImageAlignmentVertical( Value: TRzVerticalAlignment );
begin
  if FImageAlignmentVertical <> Value then
  begin
    FImageAlignmentVertical := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetTextAlignment( Value: TRzHorizontalAlignment );
begin
  if FTextAlignment <> Value then
  begin
    FTextAlignment := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetTextAlignmentVertical( Value: TRzVerticalAlignment );
begin
  if FTextAlignmentVertical <> Value then
  begin
    FTextAlignmentVertical := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetShowCloseButton( Value: Boolean );
begin
  if FShowCloseButton <> Value then
  begin
    FShowCloseButton := Value;
    if FCloseButton = nil then
      CreateCloseButton;
    FCloseButton.Visible := FShowCloseButton;
    Rebuild;
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.SetShowFocusRect( Value: Boolean );
begin
  if FShowFocusRect <> Value then
  begin
    FShowFocusRect := Value;
    Invalidate;
  end;
end;


procedure TRzCustomTabControl.SetShowShadow( Value: Boolean );
begin
  if FShowShadow <> Value then
  begin
    FShowShadow := Value;
    if FShowShadow then
      FShowFullFrame := True; // If setting shadow to true, then make sure full frame is shown
    Rebuild;
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.SetTransparent( Value: Boolean );
begin
  if FTransparent <> Value then
  begin
    FTransparent := Value;
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.SetUseGradients( Value: Boolean );
begin
  if FUseGradients <> Value then
  begin
    FUseGradients := Value;
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.ParseTextLines( const S: string; Lines: TStrings );
var
  WorkText: string;
  NextLine: string;

  // ParseNextLine will get the next line of text (minus the trailing CRLF) from
  // WorkText and will then set the work string to the remainder
  // (minus the leading CRLF).

  procedure ParseNextLine;
  var
    CRLFPos: Integer;
  begin
    CRLFPos := Pos( CRLF, WorkText );
    if CRLFPos = 0 then
    begin
      NextLine := Copy( WorkText, 1, Length( WorkText ) );
      WorkText := '';
    end
    else
    begin
      NextLine := Copy( WorkText, 1, CRLFPos - 1 );
      WorkText := Copy( WorkText, CRLFPos + 2, Length( WorkText ) );
    end;
  end; {= ParseNextLine =}

begin {= TRzCustomTabControl.ParseTextLines =}
  Lines.Clear;
  WorkText := Copy( S, 1, Length( S ) );
  while Length( WorkText ) > 0 do
  begin
    ParseNextLine;
    Lines.Add( NextLine );
  end;
end; {= TRzCustomTabControl.ParseTextLines =}


procedure TRzCustomTabControl.SetImagePosition( Value: TRzImagePosition );
begin
  if FImagePosition <> Value then
  begin
    FImagePosition := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetImageMargin( Value: Integer );
begin
  if ( Value >= 0 ) and ( FImageMargin <> Value ) then
  begin
    FImageMargin := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetShowCard( Value: Boolean );
begin
  if FShowCard <> Value then
  begin
    FShowCard := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetShowCardFrame( Value: Boolean );
begin
  if FShowCardFrame <> Value then
  begin
    FShowCardFrame := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetShowFullFrame( Value: Boolean );
begin
  if FShowFullFrame <> Value then
  begin
    FShowFullFrame := Value;
    if not FShowFullFrame then
      FShowShadow := False;   // Turn off shadow if not showing the full frame
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetFlatColor( Value: TColor );
begin
  if FFlatColor <> Value then
  begin
    FFlatColor := Value;
    if FScroller <> nil then
      FScroller.FrameColor := AdjustColor( FFlatColor, FFlatColorAdjustment );
    if FCloseButton <> nil then
      FCloseButton.FrameColor := AdjustColor( FFlatColor, FFlatColorAdjustment );
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.SetFlatColorAdjustment( Value: Integer );
begin
  if FFlatColorAdjustment <> Value then
  begin
    FFlatColorAdjustment := Value;
    if FScroller <> nil then
      FScroller.FrameColor := AdjustColor( FFlatColor, FFlatColorAdjustment );
    if FCloseButton <> nil then
      FCloseButton.FrameColor := AdjustColor( FFlatColor, FFlatColorAdjustment );
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.SetTabColors( Value: TRzTabColors );
begin
  FTabColors.Assign( Value );
end;


procedure TRzCustomTabControl.GetTextColor( ATabIndex: Integer; AStyle: TRzTextStyle; var AColor: TColor;
                                            var Handled: Boolean );
begin
  if Assigned( FOnGetTextColor ) then
    FOnGetTextColor( Self, ATabIndex, AStyle, AColor, Handled );
end;


procedure TRzCustomTabControl.SetTextColors( Value: TRzTextColors );
begin
  FTextColors.Assign( Value );
end;


procedure TRzCustomTabControl.Change;
begin
  if Assigned( FOnChange ) then
    FOnChange( Self );
end;


procedure TRzCustomTabControl.Changing( NewIndex: Integer; var Allowed: Boolean );
begin
  if Assigned( FOnChanging ) then
    FOnChanging( Self, NewIndex, Allowed );
end;


{ CanSelectTab returns true if OK to select the tab with the specified index }

function TRzCustomTabControl.CanSelectTab( ATabIndex: Integer ): Boolean;
begin
  Result := ( FTabDataList.Count > 0 ) and
            ( TRzTabData( FTabDataList[ ATabIndex ] ).Visible and
            ( TRzTabData( FTabDataList[ ATabIndex ] ).Enabled or ( csDesigning in ComponentState ) ) );

  if Result and ( ATabIndex <> FTabIndex ) then
    Changing( ATabIndex, Result );
end;


procedure TRzCustomTabControl.SetMargin( Value: Integer );
begin
  if ( Value >= 0 ) and ( FMargin <> Value ) then
  begin
    FMargin := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.WMSize( var Msg: TWMSize );
begin
  inherited;
  Rebuild;
end;


procedure TRzCustomTabControl.SetUseColoredTabs( Value: Boolean );
begin
  if FUseColoredTabs <> Value then
  begin
    FUseColoredTabs := Value;
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.CMDialogChar( var Msg: TCMDialogChar );
var
  I: Integer;
  TabData: TRzTabData;
begin
  if CanFocus then
  begin
    with Msg do
    begin
      for I := 0 to FTabDataList.Count - 1 do
      begin
        TabData := FTabDataList[ I ];
        if IsAccel( CharCode, TabData.Caption ) and TabData.Enabled and TabData.Visible then
        begin                               // select appropriate Tab and give it focus
          Result := 1;                      // accelerator key is valid (don't beep)
          SetFocus;                         // to self
          if not Focused then
            Exit;                           // OnExit event handlers redirected focus
          SetTabIndex( I );
          if FTabIndex = I then
          begin
            // Page change was allowed
            TabClick;
          end;
          Exit;
        end;
      end;
    end;
  end;
  inherited;
end;


// Draw the Tab's focus rect and perform user-assigned OnClick event method

procedure TRzCustomTabControl.TabClick;
begin
  if Assigned( FOnTabClick ) then
    FOnTabClick( Self );
end;


procedure TRzCustomTabControl.WMGetDlgCode( var Msg: TWMGetDlgCode );
begin
  Msg.Result := dlgc_WantArrows;
end;


procedure TRzCustomTabControl.KeyDown( var Key: Word; Shift: TShiftState );
var
  NewTabIndex: Integer;
begin
  inherited;
  if FTabDataList.Count = 0 then
    Exit;                                   // no tabs, ignore

  NewTabIndex := FTabIndex;
  case Key of
    VK_RIGHT, VK_DOWN, VK_LEFT, VK_UP:
    begin
      repeat
        if ( ( FTabSequence = tsStandard ) and ( ( Key = VK_RIGHT ) or ( Key = VK_DOWN ) ) ) or
           ( ( FTabSequence = tsReverse ) and ( ( Key = VK_LEFT ) or ( Key = VK_UP ) ) ) then
        begin
          // Determine 'next' tab
          if ( NewTabIndex = FTabDataList.Count - 1 ) then
            NewTabIndex := 0
          else
            Inc( NewTabIndex );
        end
        else if ( NewTabIndex <= 0 ) then   // first tab or -1
          NewTabIndex := FTabDataList.Count - 1
        else
          Dec( NewTabIndex );

        // Continue until we find a selectable tab or are back where we started
      until CanSelectTab( NewTabIndex ) or ( NewTabIndex = FTabIndex );
    end;

    VK_HOME, VK_END:
    begin
      if Key = VK_HOME then
        NewTabIndex := 0
      else                                  // VK_END
        NewTabIndex := FTabDataList.Count - 1;

      while not ( ( NewTabIndex = FTabIndex ) or CanSelectTab( NewTabIndex ) ) do
      begin
        if Key = VK_HOME then
          Inc( NewTabIndex )
        else                                // VK_END
          Dec( NewTabIndex );

        if ( NewTabIndex < 0 ) or ( NewTabIndex = FTabDataList.Count ) then
          NewTabIndex := FTabIndex;         // must have been -1
      end;
    end;
  end;

  if NewTabIndex <> FTabIndex then
  begin
    // OnChanging event will have already been generated by CanSelectTab --
    // set flag to prevent duplicate event being generated by SetTabIndex

    FChangingDone := True;

    // SetTabIndex is called so that even if NewTabIndex = TabIndex the current
    // tab will be brought into view and/or the first row.

    SetTabIndex( NewTabIndex );
    FChangingDone := False;
    TabClick;
  end;
end; {= TRzCustomTabControl.KeyDown =}


procedure TRzCustomTabControl.WMSetFocus( var Msg: TWMSetFocus );
begin
  InvalidateControl;
  inherited;
end;


procedure TRzCustomTabControl.WMKillFocus( var Msg: TWMKillFocus );
begin
  InvalidateControl;
  inherited;
end;


procedure TRzCustomTabControl.CMDesignHitTest( var Msg: TCMDesignHitTest );
var
  NewTabIndex: Integer;
  {$IFNDEF VCL60_OR_HIGHER}
  ShiftState: TShiftState;
  {$ENDIF}
begin
  {$IFDEF VCL60_OR_HIGHER}

  NewTabIndex := TabAtPos( Msg.Pos.X, Msg.Pos.Y );
  if ( NewTabIndex >= 0 ) and ( NewTabIndex <> TabIndex ) then
    Msg.Result := 1;

  {$ELSE}

  ShiftState := KeysToShiftState( Msg.Keys );
  if ssLeft in ShiftState then
  begin
    NewTabIndex := TabAtPos( Msg.Pos.X, Msg.Pos.Y );
    if ( NewTabIndex >= 0 ) and ( NewTabIndex <> TabIndex ) then
    begin
//      SetTabIndex( NewTabIndex );
      Msg.Result := 1;
      FDesignTimeTabChange := True;
    end;
  end
  else
  begin
    if FDesignTimeTabChange then
      Msg.Result := 1;
    FDesignTimeTabChange := False;
  end;

  {$ENDIF}
end;


procedure TRzCustomTabControl.WMNCHitTest( var Msg: TWMNCHitTest );
begin
  DefaultHandler( Msg );
  FHitTest := SmallPointToPoint( Msg.Pos );
end;


procedure TRzCustomTabControl.SetBackgroundColor( Value: TColor );
begin
  if FBackgroundColor <> Value then
  begin
    FBackgroundColor := Value;
    FParentBackgroundColor := False;
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.SetBoldCurrentTab( Value: Boolean );
begin
  if FBoldCurrentTab <> Value then
  begin
    FBoldCurrentTab := Value;
    Rebuild;
  end;
end;


procedure TRzCustomTabControl.SetParentBackgroundColor( Value: Boolean );
begin
  if FParentBackgroundColor <> Value then
  begin
    FParentBackgroundColor := Value;
    if Parent <> nil then
      Perform( CM_PARENTCOLORCHANGED, 0, 0 );
  end;
end;


procedure TRzCustomTabControl.CMParentColorChanged( var Msg: TMessage );
begin
  inherited;
  if FParentBackgroundColor and ( Parent <> nil ) then
  begin
    // Set BackgroundColor to the parent's Color -- this disables
    // ParentBackgroundColor so we must re-enable afterwards

    SetBackgroundColor( TGroupBox( Parent ).Color ); // typecast needed to access
    FParentBackgroundColor := True;
  end;
end;


procedure TRzCustomTabControl.CMColorChanged( var Msg: TMessage );
begin
  if FUseColoredTabs then
  begin
    // When tracking the current tab color, self's Color property is set
    // (by DrawCard) to the color of the current tab.  Normally, changes to the
    // Color property of a TWinControl would cause the control to be Invalidated
    // and all its children to be sent a CM_PARENTCOLORCHANGED control message.
    // Because self's Color is changed automatically during our Paint processing
    // we don't want to Invalidate the control (again) which would cause a
    // second paint iteration.
    NotifyControls( CM_PARENTCOLORCHANGED );
  end
  else
  begin
    inherited;
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.DoRealign;
begin
  if not EqualRect( DisplayRect, FPrevDisplayRect ) then
  begin
    // Alignment needed for child controls
    Realign;
  end;
end;


procedure TRzCustomTabControl.SetAlignTabs( Value: Boolean );
begin
  if FAlignTabs <> Value then
  begin
    FAlignTabs := Value;
    if FMultiLine then
      Rebuild;
  end;
end;


procedure TRzCustomTabControl.AddCommand( const Command: Integer );
begin
  FCommands.Add( Pointer( Command ) );
end;


procedure TRzCustomTabControl.AddCommandPt( const Command: Integer; const APoint: TPoint );
begin
  FCommands.Add( Pointer( Command ) );
  FCommands.Add( Pointer( APoint.X ) );
  FCommands.Add( Pointer( APoint.Y ) );
end;


function TRzCustomTabControl.IsBackgroundColorStored: Boolean;
begin
  Result := not ParentBackgroundColor;
end;


procedure TRzCustomTabControl.SetHotTrack( Value: Boolean );
begin
  if FHotTrack <> Value then
  begin
    if FHotTrack and not FTabHints then
      CancelHotTrackTimer;
    FHotTrack := Value;
  end;
end;


procedure TRzCustomTabControl.SetHotTrackColor( Value: TColor );
begin
  if FHotTrackColor <> Value then
  begin
    FHotTrackColor := Value;
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.SetHotTrackColorType( Value: TRzHotTrackColorType );
begin
  if FHotTrackColorType <> Value then
  begin
    FHotTrackColorType := Value;
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.SetHotTrackStyle( Value: TRzHotTrackStyle );
begin
  if FHotTrackStyle <> Value then
  begin
    FHotTrackStyle := Value;
    InvalidateControl;
  end;
end;


procedure TRzCustomTabControl.SetImages( Value: TCustomImageList );
begin
  if FImages <> nil then
    FImages.UnRegisterChanges( FImagesChangeLink );

  FImages := Value;

  if FImages <> nil then
  begin
    FImages.RegisterChanges( FImagesChangeLink );
    FImages.FreeNotification( Self );
  end;
  Rebuild;
end;


procedure TRzCustomTabControl.ImageListChange( Sender: TObject );
begin
  InvalidateControl;
end;


procedure TRzCustomTabControl.SetTabHints( Value: Boolean );
begin
  if FTabHints <> Value then
  begin
    if FTabHints and not FHotTrack then
      CancelHotTrackTimer;
    FTabHints := Value;
  end;
end;


{=========================}
{== TRzTabSheet Methods ==}
{=========================}

constructor TRzTabSheet.Create( AOwner: TComponent );
begin
  inherited;
  InternalSetVisible( False );
  ControlStyle := ControlStyle + [ csAcceptsControls, csOpaque, csNoDesignVisible ];
  Align := alClient;
  FImageIndex := -1;
  FDisabledIndex := -1;
  FTabEnabled := True;
  FTabVisible := True;
end;


procedure TRzTabSheet.CreateParams( var Params: TCreateParams );
begin
  inherited;
  Params.WindowClass.Style := Params.WindowClass.Style and not ( CS_HREDRAW or CS_VREDRAW );
end;


destructor TRzTabSheet.Destroy;
begin
  if FPageControl <> nil then
    FPageControl.RemovePage( Self );
  inherited;
end;


procedure TRzTabSheet.AssignTo( Dest: TPersistent );
begin
  if Dest is TRzTabData then
    AssignToTabData( TRzTabData( Dest ) )
  else
    inherited;
end;


procedure TRzTabSheet.AssignToTabData( Dest: TPersistent );
begin
  with TRzTabData( Dest ) do
  begin
    // Copy relevant properties of self into TRzTabData destination
    Caption := Self.Caption;
    Color := Self.Color;
    Enabled := Self.TabEnabled;             // Note use of TabEnabled, instead of Enabled
    Visible := Self.TabVisible;             // Note use of TabVisible, instead of Visible
    Hint := Self.Hint;
    ImageIndex := Self.ImageIndex;
    DisabledIndex := Self.DisabledIndex;
  end;
end;


function TRzTabSheet.GetPageIndex: Integer;
begin
  if FPageControl <> nil then
    Result := FPageControl.FPages.IndexOf( Self )
  else
    Result := -1;
end;


function TRzTabSheet.GetTabIndex: Integer;
var
  I: Integer;
begin
  Result := 0;
  if not FTabVisible then
    Dec( Result )
  else
  begin
    for I := 0 to PageIndex - 1 do
    begin
      if FPageControl.Pages[ I ].TabVisible then
        Inc( Result );
    end;
  end;
end;


procedure TRzTabSheet.ReadState( Reader: TReader );
begin
  inherited;
  if Reader.Parent is TRzPageControl then
    PageControl := TRzPageControl( Reader.Parent );
end;


procedure TRzTabSheet.SetDisabledIndex( Value: TImageIndex );
begin
  if FDisabledIndex <> Value then
  begin
    FDisabledIndex := Value;
    Changed;
  end;
end;


procedure TRzTabSheet.SetImageIndex( Value: TImageIndex );
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed;
  end;
end;


procedure TRzTabSheet.SetPageControl( APageControl: TRzPageControl );
begin
  if FPageControl <> APageControl then
  begin
    if FPageControl <> nil then
      FPageControl.RemovePage( Self );
    Parent := APageControl;
    if APageControl <> nil then
      APageControl.InsertPage( Self );
  end;
end;


procedure TRzTabSheet.SetPageIndex( Value: Integer );
var
  MaxPageIndex: Integer;
begin
  if FPageControl <> nil then
  begin
    MaxPageIndex := FPageControl.FPages.Count - 1;
    if Value > MaxPageIndex then
      raise Exception.CreateFmt( sRzPageIndexOutOfRange, [ Value, MaxPageIndex ] );
    FPageControl.FPages.Move( PageIndex, Value );
    Changed;
  end;
end;


procedure TRzTabSheet.SetTabEnabled( Value: Boolean );
begin
  if FTabEnabled <> Value then
  begin
    FTabEnabled := Value;
    Changed;
  end;
end;


procedure TRzTabSheet.SetTabVisible( Value: Boolean );
begin
  if FTabVisible <> Value then
  begin
    FTabVisible := Value;
    Changed;
  end;
end;


// Note: Caption is updated as each character is typed/changed in the O.I.

procedure TRzTabSheet.CMTextChanged( var Msg: TMessage );
begin
  Changed;
end;


procedure TRzTabSheet.Changed;
begin
  if FPageControl <> nil then
    FPageControl.Rebuild;
end;


procedure TRzTabSheet.DestroyHandle;
begin
  inherited;
end;


procedure TRzTabSheet.Paint;
var
  ARect: TRect;
  Handled: Boolean;
begin
  ARect := Rect( 0, 0, Width, Height );
  Handled := False;
  PaintBackground( Canvas, ARect, Handled );
  if not Handled then
  begin
    Canvas.Brush.Color := Color;
    Canvas.FillRect( ARect );
    Handled := True;
  end;
end;


procedure TRzTabSheet.PaintBackground( ACanvas: TCanvas; const ARect: TRect; var Handled: Boolean );
begin
  if Assigned( FOnPaintBackground ) then
    FOnPaintBackground( Self, ACanvas, ARect, Handled );
end;


procedure TRzTabSheet.WMEraseBkgnd( var Msg: TWmEraseBkgnd );
begin
  // Paint takes care of everything -- ignore erase to prevent flicker
  Msg.Result := 1;
end;


function TRzTabSheet.GetVisible: Boolean;
begin
  Result := inherited Visible;
end;


procedure TRzTabSheet.SetVisible( Value: Boolean );
begin
  // Visibility of pages can only be changed via the InternalSetVisible method;
  // this prevents attempts to change the Visible property programmatically.

  raise Exception.Create( sRzInvalidVisibilityChange );
end;


procedure TRzTabSheet.InternalSetVisible( Value: Boolean );
begin
  inherited Visible := Value;
end;


function TRzTabSheet.GetColor: TColor;
begin
  Result := inherited Color;
end;


procedure TRzTabSheet.SetColor( Value: TColor );
begin
  // Prevent change to color of page unless using UseColoredTabs or the page's color
  // is being changed (automatically) to match that of the page control.

  if GetColor <> Value then
  begin
    if FPageControl <> nil then
    begin
      if not FPageControl.UseColoredTabs and ( Value <> FPageControl.Color ) then
        FPageControl.UseColoredTabs := True;

      if ( FPageControl.UseColoredTabs or
         ( ( GetColor <> FPageControl.Color ) and ( Value = FPageControl.Color ) ) ) then
      begin
        inherited Color := Value;
        Changed;
      end;

    end
    else // FPageControl = nil
    begin
      inherited Color := Value;
      Changed;
    end;
  end;
end;


{============================}
{== TRzPageControl Methods ==}
{============================}

constructor TRzPageControl.Create( AOwner: TComponent );
begin
  if not Registered then
  begin
    Classes.RegisterClasses( [ TRzTabSheet ] );
    Registered := True;
  end;

  inherited;

  ControlStyle := ControlStyle - [ csAcceptsControls ] + [ csOpaque ];
  Height := 150;                            // make page controls larger than tab controls
  UseColoredTabs := False;
  FActivePage := nil;
  FActivePageDefault := nil;
  FPages := TList.Create;
end;


procedure TRzPageControl.CreateParams( var Params: TCreateParams );
begin
  inherited;
  Params.Style := Params.Style or WS_CLIPCHILDREN;
end;


destructor TRzPageControl.Destroy;
var
  I: Integer;
begin
  for I := 0 to FPages.Count - 1 do
    TRzTabSheet( FPages[ I ] ).FPageControl := nil;
  FPages.Free;
  inherited;
end;


procedure TRzPageControl.Loaded;
var
  Page: TRzTabSheet;
begin
  inherited;
  FInitActivePage := True;
  try
    CalcMetrics;

    TabIndex := -1;                       // to ensure a Changing event occurs (if the page has a tab)
    if ( FActivePageDefault <> nil ) and ( FActivePageDefault <> FActivePage ) then
    begin
      if FActivePage <> nil then
        FActivePage.InternalSetVisible( False );
      Page := FActivePageDefault
    end
    else
      Page := FActivePage;
    FActivePage := nil;
    Rebuild;

    // Call SetActivePage again (first call occurs when ActivePage property is
    // streamed in, i.e. before pages have been reordered).

    SetActivePage( Page );
  finally
    FInitActivePage := False;
  end;
end;


procedure TRzPageControl.Change;
begin
  if not FInitActivePage then
    inherited;
end;


procedure TRzPageControl.ChangeActivePage( Page: TRzTabSheet );
var
  Form: TCustomForm;
begin
  if FActivePage <> Page then
  begin
    Form := GetParentForm( Self );
    if ( Form <> nil ) and ( FActivePage <> nil ) and FActivePage.ContainsControl( Form.ActiveControl ) then
      Form.ActiveControl := FActivePage;

    if Page <> nil then
    begin
      Page.BringToFront;
      Page.InternalSetVisible( True );
      if ( Form <> nil ) and ( FActivePage <> nil ) and ( Form.ActiveControl = FActivePage ) then
      begin
        if Page.CanFocus then
          Form.ActiveControl := Page
        else
          Form.ActiveControl := Self;
      end;
    end;

    if FActivePage <> nil then
    begin
      FActivePage.InternalSetVisible( False );
      if FSaveResources and not ( csDesigning in ComponentState ) then
        FActivePage.DestroyHandle;
    end;

    FActivePage := Page;
    if ( Form <> nil ) and ( FActivePage <> nil ) and ( Form.ActiveControl = FActivePage ) then
      FActivePage.SelectFirst;
  end;
end; {= TRzPageControl.ChangeActivePage =}


function TRzPageControl.FindNextPage( CurPage: TRzTabSheet; GoForward, CheckTabVisible: Boolean ): TRzTabSheet;
var
  I, StartIndex: Integer;
begin
  if FPages.Count <> 0 then
  begin
    StartIndex := FPages.IndexOf( CurPage );
    if StartIndex = -1 then
    begin
      if GoForward then
        StartIndex := FPages.Count - 1
      else
        StartIndex := 0;
    end;

    I := StartIndex;
    repeat
      if GoForward then
      begin
        Inc( I );
        if I = FPages.Count then
          I := 0;
      end
      else
      begin
        if I = 0 then
          I := FPages.Count;
        Dec( I );
      end;
      Result := FPages[ I ];

      if not CheckTabVisible or Result.TabVisible then
        Exit;
    until I = StartIndex;
  end;
  Result := nil;
end; {= TRzPageControl.FindNextPage =}


procedure TRzPageControl.MakeControlVisible( AControl: TControl );
var
  I, ControlPageIndex: Integer;
  Page: TRzTabSheet;

  function FindControl( Container: TWinControl ): Boolean;
  var
    C: TControl;
    I: Integer;
  begin
    Result := False;
    for I := 0 to ( Container.ControlCount - 1 ) do
    begin
      C := Container.Controls[ I ];
      if C = AControl then
        Result := True
      else
      begin
        if C is TWinControl then
          Result := FindControl( C as TWinControl );
      end;

      if Result then
        Break;
    end;
  end;

begin {= TRzPageControl.MakeControlVisible =}
  ControlPageIndex := -1;

  for I := 0 to ( PageCount - 1 ) do
  begin
    Page := Pages[ I ];
    if Page = AControl then
    begin
      ControlPageIndex := I;
      Break;
    end
    else
    begin
      if FindControl( Page ) then
      begin
        ControlPageIndex := I;
        Break;
      end;
    end;
  end;

  if ControlPageIndex < 0 then
    ControlPageIndex := 0;

  if ControlPageIndex <> ActivePageIndex then
    ActivePageIndex := ControlPageIndex;
end; {= TRzPageControl.MakeControlVisible =}



procedure TRzPageControl.GetChildren( Proc: TGetChildProc; Root: TComponent );
var
  I: Integer;
begin
  for I := 0 to FPages.Count - 1 do
    Proc( TComponent( FPages[ I ] ) );
end;


function TRzPageControl.GetPage( Index: Integer ): TRzTabSheet;
begin
  Result := FPages[ Index ];
end;


function TRzPageControl.GetPageCount: Integer;
begin
  Result := FPages.Count;
end;


procedure TRzPageControl.InsertPage( Page: TRzTabSheet );
begin
  // Calling HandleNeeded is necessary so that the correct path in TControl.UpdateAnchorRules is taken when determining
  // the FOriginalParentSize value for the tab sheets.
  HandleNeeded;

  FPages.Add( Page );
  Page.FPageControl := Self;
  Rebuild;
end;


procedure TRzPageControl.RemovePage( Page: TRzTabSheet );
begin
  if FActivePage = Page then
    SetActivePage( nil );
  // Remove page before doing Rebuild to ensure correct state used
  FPages.Remove( Page );
  Rebuild;
  Page.FPageControl := nil;             // Disconnect page from control
end;


procedure TRzPageControl.DestroyActiveTab;
var
  Idx: Integer;
begin
  if FActivePage <> nil then
  begin
    Idx := TabIndex;
    FActivePage.Free;
    if Idx > 0 then
      Dec( Idx );
    TabIndex := Idx;
  end;
end;


procedure TRzPageControl.ActiveTabMoved( Index: Integer );
begin
  ActivePage.PageIndex := Index;
end;


procedure TRzPageControl.SelectNextPage( GoForward: Boolean );
var
  Page: TRzTabSheet;
begin
  Page := FindNextPage( ActivePage, GoForward, True );
  if Page <> nil then
    SetActivePage( Page );
end;


procedure TRzPageControl.SetActivePage( Page: TRzTabSheet );
var
  NewTabIndex: Integer;
begin
  if ( Page <> nil ) and ( Page.PageControl <> Self ) then
    Exit;

  // Page needs to be made visible in order for Form.ActiveControl to work property
  if Page <> nil then
    Page.InternalSetVisible( True );

  if ( csLoading in ComponentState ) or ( csReading in ComponentState ) then
  begin
    // Pages haven't been re-ordered by Loaded yet
    FActivePage := Page;
    Exit;
  end;


  // When the destination page has a TabIndex of -1 (no tab visible)
  // we cannot rely on the setting of (self's) TabIndex to cause the
  // required page change (via Changing call) and must instead explicitly
  // change pages.

  if Page <> nil then
    NewTabIndex := Page.TabIndex        // could be -1 if page has no tab
  else
    NewTabIndex := -1;

  if NewTabIndex < 0 then               // explicitly change pages
    ChangeActivePage( Page );

  // If NewTabIndex is -1, setting TabIndex will always succeed.
  // If NewTabIndex is >= 0, setting TabIndex will generate Changing call to
  // check if OK to change to a different tab.  If the change is allowed,
  // Changing will perform the necessary page change too.

  TabIndex := NewTabIndex;
end; {= TRzPageControl.SetActivePage =}


function TRzPageControl.GetActivePageIndex: Integer;
begin
  if ActivePage <> nil then
    Result := ActivePage.PageIndex
  else
    Result := -1;
end;


procedure TRzPageControl.SetActivePageIndex( Value: Integer );
begin
  SetActivePage( Pages[ Value ] );
end;


procedure TRzPageControl.HideAllTabs;
var
  I: Integer;
begin
  for I := 0 to FPages.Count - 1 do
    Pages[ I ].TabVisible := False;
end;


procedure TRzPageControl.ShowAllTabs;
var
  I: Integer;
begin
  for I := 0 to FPages.Count - 1 do
    Pages[ I ].TabVisible := True;
end;


procedure TRzPageControl.SetChildOrder( Child: TComponent; Order: Integer );
begin
  TRzTabSheet( Child ).PageIndex := Order;
end;


procedure TRzPageControl.ShowControl( AControl: TControl );
begin
  if ( AControl is TRzTabSheet ) and ( TRzTabSheet( AControl ).PageControl = Self ) then
    SetActivePage( TRzTabSheet( AControl ) );

  inherited;
end;


procedure TRzPageControl.CMDialogKey( var Msg: TCMDialogKey );
var
  Form: TCustomForm;
begin
  // Broadcast the message to any child controls (e.g. a nested page control)
  // before attempting to handle in self.

  inherited;

  if Msg.Result <> 0 then
    Exit;                               // Handled by a child control

  // Now see if self is in the parent hierarchy for the active control --
  // this ensures that the page control which is the most immediate parent of
  // the active control handles the message.

  Form := GetParentForm( Self );
  if ( Form <> nil ) and ContainsControl( Form.ActiveControl ) and
     ( Msg.CharCode = VK_TAB ) and ( GetKeyState( VK_CONTROL ) < 0 ) then
  begin
    SelectNextPage( GetKeyState( VK_SHIFT ) >= 0 );
    Msg.Result := 1;
  end;
end;


procedure TRzPageControl.Rebuild;
var
  I: Integer;
  Tab: TRzTabData;
  Page: TRzTabSheet;
begin
  // Mirror the persistent page definitions in the internal tab data structures

  GetTabDataList.Clear;
  for I := 0 to FPages.Count - 1 do
  begin
    Page := TRzTabSheet( FPages[ I ] );

    // Don't add a tab for pages with TabVisible = False; this also implies
    // that all internal TRzTabData objects for a page control will have
    // TRzTabData.Visible = True

    if Page.TabVisible then
    begin
      Tab := TRzTabData.Create;
      Tab.Assign( Page );               // Gets passed to AssignTo
      GetTabDataList.Add( Tab );
    end;
  end;

  // Handle special cases after rebuild of tabs/pages
  if FActivePage <> nil then
  begin
    if not FActivePage.TabVisible then
      TabIndex := -1
    else if TabIndex <> FActivePage.TabIndex then
      TabIndex := FActivePage.TabIndex;
  end;
  inherited;
end; {= TRzPageControl.Rebuild =}


procedure TRzPageControl.Changing( NewIndex: Integer; var Allowed: Boolean );
begin
  if not FInitActivePage then
    inherited;

  if Allowed then
  begin
    // NewIndex is the TabIndex of the destination page.  It will always be >= 0
    // because changing to a page (via ActivePage property) which has no tab
    // (TabIndex = -1) will not generate a Changing (tab) call.

    ChangeActivePage( PageForTab( NewIndex ) );
  end;
end;


function TRzPageControl.PageForTab( ATabIndex: Integer ): TRzTabSheet;
var
  I: Integer;
  Page: TRzTabSheet;
begin
  Result := nil;
  if ATabIndex < 0 then
    Exit;

  for I := 0 to FPages.Count - 1 do
  begin
    Page := TRzTabSheet( FPages[ I ] );
    if Page.TabIndex = ATabIndex then
    begin
      Result := Page;
      Exit;
    end;
  end;
end;


procedure TRzPageControl.SetSaveResources( Value: Boolean );
var
  I: Integer;
begin
  if Value <> FSaveResources then
  begin
    FSaveResources := Value;
    if FSaveResources and not ( csDesigning in ComponentState ) then
    begin
      // Release existing resources for all pages which are not visible
      for I := 0 to FPages.Count - 1 do
        if FPages[ I ] <> FActivePage then
          TRzTabSheet( FPages[ I ] ).DestroyHandle;
    end;
  end;
end;


// The 'card' still has to be painted to fill in the gap between the current tab
//  and the associated page; the page is actually smaller than the entire 'card' size.

procedure TRzPageControl.PaintCardBackground( ACanvas: TCanvas; ARow: Integer; const ARect: TRect;
                                              var Handled: Boolean );
begin
  // Call inherited method to allow user's OnPaintCardBackground to fill gap
  inherited;

  if ( not Handled ) and ( ARow = 0 ) and ( TabIndex >= 0 ) and ( ActivePage <> nil ) then
  begin
    with ACanvas do
    begin
      Brush.Color := ActivePage.Color;
      FillRect( ARect );
    end;
    Handled := True;
  end;
end;


// When not using UseColoredTabs we have to manually change the color of each page
// to match the color of the page control.  This is necessary because the
// ParentColor property of each page will be False due to changes to each
// page's Color property and thus each page's Color won't be updated via the
// normal process (CM_PARENTCOLORCHANGED message).

procedure TRzPageControl.CMColorChanged( var Msg: TMessage );
var
  I: Integer;
begin
  if not UseColoredTabs then
  begin
    for I := 0 to FPages.Count - 1 do
      TRzTabSheet( FPages[ I ] ).Color := Color;
  end;
  inherited;
end;


// Update the UseColoredTabs property.  If necessary, a CM_COLORCHANGED message is
// generated to ensure the page's colors are changed to match.

procedure TRzPageControl.SetUseColoredTabs( Value: Boolean );
begin
  inherited;
  if ( Parent <> nil ) and not UseColoredTabs then         // Change color of pages to match
    Perform( CM_COLORCHANGED, 0, 0 );
end;


procedure TRzPageControl.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if ( Operation = opRemove ) and ( AComponent = FActivePageDefault ) then
    FActivePageDefault := nil;
end;



procedure TRzPageControl.CMDockClient( var Msg: TCMDockClient );
var
  IsVisible: Boolean;
  DockCtl: TControl;
begin
  Msg.Result := 0;
  FNewDockSheet := TRzTabSheet.Create( Self );
  try
    try
      DockCtl := Msg.DockSource.Control;
      if DockCtl is TCustomForm then
        FNewDockSheet.Caption := TCustomForm( DockCtl ).Caption;
      FNewDockSheet.PageControl := Self;
      DockCtl.Dock( Self, Msg.DockSource.DockRect );
    except
      FNewDockSheet.Free;
      raise;
    end;
    IsVisible := DockCtl.Visible;
    FNewDockSheet.TabVisible := IsVisible;
    if IsVisible then
      ActivePage := FNewDockSheet;
    DockCtl.Align := alClient;
  finally
    FNewDockSheet := nil;
  end;
end;


procedure TRzPageControl.CMDockNotification( var Msg: TCMDockNotification );
var
  I: Integer;
  S: string;
  Page: TRzTabSheet;
begin
  Page := GetPageFromDockClient( Msg.Client );
  if Page <> nil then
  begin
    case Msg.NotifyRec.ClientMsg of
      wm_SetText:
      begin
        S := PChar( Msg.NotifyRec.MsgLParam );
        // Search for first CR/LF and end string there
        for I := 1 to Length( S ) do
        begin
          if S[ I ] in [ #13, #10 ] then
          begin
            SetLength( S, I - 1 );
            Break;
          end;
        end;
        Page.Caption := S;
      end;

      cm_VisibleChanged:
        Page.TabVisible := Boolean( Msg.NotifyRec.MsgWParam );
    end;
  end;
  inherited;
end;


procedure TRzPageControl.CMUnDockClient( var Msg: TCMUnDockClient );
var
  Page: TRzTabSheet;
begin
  Msg.Result := 0;
  Page := GetPageFromDockClient( Msg.Client );
  if Page <> nil then
  begin
    FUndockingPage := Page;
    Msg.Client.Align := alNone;
  end;
end;


function TRzPageControl.GetDockClientFromMousePos( MousePos: TPoint ): TControl;
var
  I, HitIndex: Integer;
  Page: TRzTabSheet;
begin
  Result := nil;
  if DockSite then
  begin
    HitIndex := TabAtPos( MousePos.X, MousePos.Y );
    if HitIndex >= 0 then
    begin
      Page := nil;
      for I := 0 to HitIndex do
        Page := FindNextPage( Page, True, True );
      if ( Page <> nil ) and ( Page.ControlCount > 0 ) then
      begin
        Result := Page.Controls[ 0 ];
        if Result.HostDockSite <> Self then
          Result := nil;
      end;
    end;
  end;
end;


procedure TRzPageControl.DoAddDockClient( Client: TControl; const ARect: TRect );
begin
  if FNewDockSheet <> nil then
    Client.Parent := FNewDockSheet;
end;


procedure TRzPageControl.DockOver( Source: TDragDockObject; X, Y: Integer; State: TDragState; var Accept: Boolean );
var
  R: TRect;
begin
  GetWindowRect( Handle, R );
  Source.DockRect := R;
  DoDockOver( Source, X, Y, State, Accept );
end;


procedure TRzPageControl.DoRemoveDockClient( Client: TControl );
begin
  if ( FUndockingPage <> nil ) and not ( csDestroying in ComponentState ) then
  begin
    SelectNextPage( True );
    FUndockingPage.Free;
    FUndockingPage := nil;
  end;
end;


function TRzPageControl.GetPageFromDockClient( Client: TControl ): TRzTabSheet;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to PageCount - 1 do
  begin
    if ( Client.Parent = Pages[ I ] ) and ( Client.HostDockSite = Self ) then
    begin
      Result := Pages[ I ];
      Exit;
    end;
  end;
end;


procedure TRzPageControl.GetSiteInfo( Client: TControl; var InfluenceRect: TRect; MousePos: TPoint;
                                      var CanDock: Boolean );
begin
  CanDock := GetPageFromDockClient( Client ) = nil;
  inherited;
end;


procedure TRzPageControl.WMLButtonDown( var Msg: TWMLButtonDown );
var
  DockCtl: TControl;
begin
  inherited;
  DockCtl := GetDockClientFromMousePos( SmallPointToPoint( Msg.Pos ) );
  if DockCtl <> nil then
    DockCtl.BeginDrag( False );
end;


procedure TRzPageControl.WMLButtonDblClk( var Msg: TWMLButtonDblClk );
var
  DockCtl: TControl;
begin
  inherited;
  DockCtl := GetDockClientFromMousePos( SmallPointToPoint( Msg.Pos ) );
  if DockCtl <> nil then
    DockCtl.ManualDock( nil, nil, alNone );
end;



{=====================================}
{== TRzCollectionTabControl Methods ==}
{=====================================}

constructor TRzCollectionTabControl.Create( AOwner: TComponent );
begin
  inherited;

  // Note: Argument to TRzTabCollection.Create is TabControl, *not* owner.
  FTabCollection := TRzTabCollection.Create( Self );
end;


destructor TRzCollectionTabControl.Destroy;
begin
  FTabCollection.Free;
  inherited;
end;


procedure TRzCollectionTabControl.DestroyActiveTab;
var
  Idx: Integer;
begin
  Idx := TabIndex;
  if Idx <> -1 then
    FTabCollection.Delete( Idx );
end;


procedure TRzCollectionTabControl.ActiveTabMoved( Index: Integer );
begin
  Tabs.Move( FTabIndex, Index );
  SetTabIndex( Index );
end;


function TRzCollectionTabControl.GetTabCollection: TRzTabCollection;
begin
  Result := FTabCollection;
end;


procedure TRzCollectionTabControl.SetTabCollection( Value: TRzTabCollection );
begin
  GetTabCollection.Assign( Value );
  Rebuild;
end;


procedure TRzCollectionTabControl.HideAllTabs;
var
  I: Integer;
begin
  for I := 0 to FTabCollection.Count - 1 do
    FTabCollection[ I ].Visible := False;
end;


procedure TRzCollectionTabControl.ShowAllTabs;
var
  I: Integer;
begin
  for I := 0 to FTabCollection.Count - 1 do
    FTabCollection[ I ].Visible := True;
end;


procedure TRzCollectionTabControl.Rebuild;
var
  I: Integer;
  Tab: TRzTabData;
begin
  // Mirror the persistent tab definitions in the internal tab data structures
  GetTabDataList.Clear;
  for I := 0 to FTabCollection.Count - 1 do
  begin
    Tab := TRzTabData.Create;
    Tab.Assign( FTabCollection[ I ] );  // Gets passed to AssignTo
    GetTabDataList.Add( Tab );
  end;
  inherited;
end;


{==================================}
{== TRzTabCollectionItem Methods ==}
{==================================}

constructor TRzTabCollectionItem.Create( Collection: TCollection );
begin
  FColor := clBtnFace;
  FEnabled := True;
  FVisible := True;
  FImageIndex := -1;
  FDisabledIndex := -1;
  inherited;
end;


procedure TRzTabCollectionItem.Assign( Source: TPersistent );
begin
  if Source is TRzTabCollectionItem then
  begin
    Caption := TRzTabCollectionItem( Source ).Caption;
    Color := TRzTabCollectionItem( Source ).Color;
    Enabled := TRzTabCollectionItem( Source ).Enabled;
    Visible := TRzTabCollectionItem( Source ).Visible;
    Hint := TRzTabCollectionItem( Source ).Hint;
    ImageIndex := TRzTabCollectionItem( Source ).ImageIndex;
    DisabledIndex := TRzTabCollectionItem( Source ).DisabledIndex;
    Changed( True );
    Exit;
  end;
  inherited;                                               // Eventually gets to AssignTo
end;


procedure TRzTabCollectionItem.AssignTo( Dest: TPersistent );
begin
  if Dest is TRzTabData then
    AssignToTabData( TRzTabData( Dest ) )
  else
    inherited;
end;


procedure TRzTabCollectionItem.AssignToTabData( Dest: TPersistent );
begin
  with TRzTabData( Dest ) do
  begin
    // Copy relevant properties of self into TRzTabData destination
    Caption := Self.Caption;
    Color := Self.Color;
    Enabled := Self.Enabled;
    Visible := Self.Visible;
    Hint := Self.Hint;
    ImageIndex := Self.ImageIndex;
    DisabledIndex := Self.DisabledIndex;
  end;
end;


function TRzTabCollectionItem.GetDisplayName: string;
begin
  Result := FCaption;
  if Result = '' then
    Result := inherited GetDisplayName;
end;


procedure TRzTabCollectionItem.SetCaption( const Value: string );
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Changed( True );
  end;
end;


procedure TRzTabCollectionItem.SetColor( Value: TColor );
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Changed( True );
  end;
end;


procedure TRzTabCollectionItem.SetEnabled( Value: Boolean );
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Changed( True );
  end;
end;


procedure TRzTabCollectionItem.SetHint( const Value: string );
begin
  if FHint <> Value then
  begin
    FHint := Value;
    Changed( True );
  end;
end;


procedure TRzTabCollectionItem.SetDisabledIndex( Value: TImageIndex );
begin
  if FDisabledIndex <> Value then
  begin
    FDisabledIndex := Value;
    Changed( True );
  end;
end;


procedure TRzTabCollectionItem.SetImageIndex( Value: TImageIndex );
begin
  if FImageIndex <> Value then
  begin
    FImageIndex := Value;
    Changed( True );
  end;
end;


procedure TRzTabCollectionItem.SetVisible( Value: Boolean );
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Changed( True );
  end;
end;


{==============================}
{== TRzTabCollection Methods ==}
{==============================}

constructor TRzTabCollection.Create( TabControl: TRzCollectionTabControl );
begin
  inherited Create( TRzTabCollectionItem );
  FTabControl := TabControl;
end;


function TRzTabCollection.Add: TRzTabCollectionItem;
begin
  Result := TRzTabCollectionItem( inherited Add );
end;


procedure TRzTabCollection.Delete( Index: Integer );
begin
  // Setting an item's Collection property to nil will delete it
  Items[ Index ].Collection := nil;

  // If Index <> FTabControl.TabIndex, then must reset FTabControl.TabIndex to reflect removal of Index tab
  if Index <= FTabControl.TabIndex then
    Dec( FTabControl.FTabIndex );
end;


procedure TRzTabCollection.Clear;
begin
  inherited;
  if FTabControl <> nil then
    FTabControl.FTabIndex := -1;
end;


function TRzTabCollection.GetItem( Index: Integer ): TRzTabCollectionItem;
begin
  Result := TRzTabCollectionItem( inherited GetItem( Index ) );
end;


function TRzTabCollection.GetOwner: TPersistent;
begin
  Result := FTabControl;
end;


procedure TRzTabCollection.Move( CurIndex, NewIndex: Integer );
begin
  Items[ CurIndex ].Index := NewIndex;
end;


procedure TRzTabCollection.SetItem( Index: Integer; Value: TRzTabCollectionItem );
begin
  inherited SetItem( Index, Value );
end;


procedure TRzTabCollection.Update( Item: TCollectionItem );
begin
  FTabControl.Rebuild;
end;

{&RUIF}
end.

