{===============================================================================
  RzLstBox Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzListBox            Enhanced list box--adds custom framing, incremental
                          keyboard searching, horizontal scroll bar.
  TRzTabbedListBox      TRzListBox descendant--uses Tab character to display
                          items in columns.
  TRzEditListBox        Items in the list can be modified at runtime by the
                          user.
  TRzRankListBox        Items can be rearranged in the list by dragging.


  Modification History
  ------------------------------------------------------------------------------
  3.0.10 (26 Dec 2003)
    * Fixed problem where calling InsertItemIntoGroup (or AddItemToGroup) did
      not call the GetItems method to access the correct Items property when
      called from the TRzCheckList class.
    * Fixed propblem where pressing Escape when editing an item in
      TRzEditListBox on a modal form would close the form and not close the edit
      box.
    * Fixed problem where changing ParentColor to True in a control using Custom
      Framing did not reset internal color fields used to manage the color of
      the control at various states.
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Fixed problem where tab stops were not being calculated correctly for a
      TRzTabbedListBox when an item did not have any embedded tab (#9)
      characters and other items did.
    * Modified TRzCustomListBox and descendants such that when the Items list is
      being updated (i.e. within a BeginUpdate..EndUpdate block),
      AdjustHorzExtent and AdjustTabStops are not called. The result of this is
      dramatically improved performance when loading files, etc into the Items
      list.  After loading the file, call AdjustHorzExtent and/or AdjustTabStops
      to instruct the control to make the necessary adjustments.
    * Added IncrementalSearch property.
    * Modified AjustHorzExtent method to take into account the OwnerDrawIndent
      value. This is necessary for descendant controls such as the TRzCheckList
      that specify a non-zero return value in OwnerDrawIndent to handle the
      display of glyphs (e.g. check boxes).
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Moved group support from the TRzCheckList control into the base
      TRzCustomListBox control. This includes the group-related properties
      (GroupColor, GroupFont, GroupPrefix, UseGradients, ShowGroups), as well as
      all the group-related support methods.
    * Fixed range error when using the Mouse Wheel and list box has more than
      65,535 items.
  ------------------------------------------------------------------------------
  3.0.5  (24 Mar 2003)
    * Fixed problem of item hints for TRzTabbedListBox show black boxes for
      tabs.
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * When MultiSelect is True and ExtendedSelect is False, the space bar
      toggles the selection state of the item instead of invoking the
      incremental searching function.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Index of item changed in TRzEditListBox updated correctly if list is
      sorted.
    * Add method override added to TRzTabStopList to handle updating tabstops
      after a tab stop is added. Insert method is not called when Add it called.
    * Added IsColorStored and IsFocusColorStored methods so that if control is
      disabled at design-time the Color and FocusColor properties are not
      streamed with the disabled color value.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    << TRzCustomListBox and TRzListBox >>
    * Added ShowItemHints property.  When set, a hint is displayed if the entire
      item cannot be shown within the width of the list box.
    * Add FocusColor and DisabledColor properties.
    * Renamed FrameFlat property to FrameHotTrack.
    * Renamed FrameFocusStyle property to FrameHotStyle.
    * Removed FrameFlatStyle property.
    * Added the AdjustHorzExtent method, which is called automatically if the
      HorzScrollBar is set to True.  This method automatically determines the
      appropriate horizontal extent needed to completely display the longest
      string in the list.
    * Added the OwnerDrawIndent property.  This property controls the rectangle
      used for each item when the Style is in Owner-Draw Mode.  This property
      allows a user to have only a portion of the item appear selected while the
      DrawItem event can draw anywhere in the original rectangle.
    * Fixed problem with Delphi 7 version of List Box that prevents the user
      from changing the Color of the list box.
    * The Delete method has been enhanced so that if the index passed to the
      method is the same as the item currently selected (i.e. ItemIndex), then
      the ItemIndex property will be updated to select the adjacent item after
      the deletion.

    << TRzEditListBox >>
    * Fixed problem where pressing F2 when the list box was empty generated an
      Index out of Range exception.
    * Added OnItemChanged event.

    << TRzFontListBox >>
    * Initial release.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzLstBox;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Windows,
  Classes,
  Graphics,
  Forms,
  StdCtrls,
  Controls,
  Messages,
  SysUtils,
  Menus,
  ExtCtrls,
  RzIntLst,
  ComCtrls,
  RzCommon,
  RzCmboBx;

const
  MaxTabs = 1000;
  strDefaultGroupPrefix = '//';

type
  TRzCustomListBox = class( TCustomListBox )
  private
    FUpdatingColor: Boolean;
    FDisabledColor: TColor;
    FFocusColor: TColor;
    FNormalColor: TColor;
    FFrameColor: TColor;
    FFrameController: TRzFrameController;
    FFrameHotColor: TColor;
    FFrameHotTrack: Boolean;
    FFrameHotStyle: TFrameStyle;
    FFrameSides: TSides;
    FFrameStyle: TFrameStyle;
    FFrameVisible: Boolean;
    FFramingPreference: TFramingPreference;

    FIncrementalSearch: Boolean;
    FBeepOnInvalidKey: Boolean;
    FHorzExtent: Word;
    FHorzScrollBar: Boolean;
    FSearchString: string;
    FTimer: TTimer;
    FKeyCount: Integer;
    FTabOnEnter: Boolean;
    FOwnerDrawIndent: Integer;
    FShowItemHints: boolean;
    FHintWnd: THintWindow;

    FUseGradients: Boolean;
    FGroupColor: TColor;
    FGroupFont: TFont;
    FGroupFontChanged: Boolean;
    FGroupPrefix: string;
    FShowGroups: Boolean;

    FOnDrawItem: TDrawItemEvent;
    FOnMatch: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnDeleteItems: TNotifyEvent;

    procedure ReadOldFrameFlatProp( Reader: TReader );
    procedure ReadOldFrameFocusStyleProp( Reader: TReader );

    { Internal Event Handlers }
    procedure SearchTimerExpired( Sender: TObject );
    procedure GroupFontChangeHandler( Sender: TObject );

    { Message Handling Methods }
    procedure WMLButtonDown( var Msg: TWMLButtonDown ); message wm_LButtonDown;
    procedure WMKeyDown( var Msg: TWMKeyDown ); message wm_KeyDown;
    procedure WMChar( var Msg: TWMChar ); message wm_Char;

    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure WMNCPaint( var Msg: TWMNCPaint ); message wm_NCPaint;
    procedure CMParentColorChanged( var Msg: TMessage ); message cm_ParentColorChanged;
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;

    procedure CMEnter( var Msg: TCMEnter ); message cm_Enter;
    procedure CMExit( var Msg: TCMExit ); message cm_Exit;
    procedure CMMouseEnter( var Msg: TMessage ); message cm_MouseEnter;
    procedure CMMouseLeave( var Msg: TMessage ); message cm_MouseLeave;
    procedure WMMouseMove(var Msg: TWMMouseMove); message wm_MouseMove;
    procedure WMSize( var Msg: TWMSize ); message wm_Size;

    procedure CNDrawItem( var Msg: TWMDrawItem ); message cn_DrawItem;
  protected
    FCanvas: TCanvas;
    FOverControl: Boolean;

    procedure CreateParams( var Params: TCreateParams ); override;
    procedure CreateWnd; override;

    procedure DefineProperties( Filer: TFiler ); override;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;
    procedure Resize; override;

    function CalcHintRect( MaxWidth: Integer; const HintStr: string; HintWnd: THintWindow ): TRect;
    procedure DoHint( X, Y: Integer );
    procedure ReleaseHintWindow;

    procedure UpdateColors; virtual;
    procedure UpdateFrame( ViaMouse, InFocus: Boolean ); virtual;
    procedure RepaintFrame; virtual;

    function OwnerDrawItemIndent: Integer; virtual;
    procedure UpdateItemHeight; virtual;

    procedure WndProc( var Msg: TMessage ); override;
    procedure GroupFontChanged; virtual;

    { Event Dispatch Methods }
    function FindClosest( const S: string ): Integer; virtual;
    procedure DrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState ); override;
    procedure DrawListItem( Index: Integer; Rect: TRect; State: TOwnerDrawState ); virtual;
    procedure DrawGroup( Index: Integer; Rect: TRect; State: TOwnerDrawState ); virtual;
    procedure Match; dynamic;
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;
    procedure DoDeleteItems; dynamic;

    function DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean; override;
    function DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean; override;

    { Property Access Methods }
    function GetColor: TColor; virtual;
    procedure SetColor( Value: TColor ); virtual;
    function IsColorStored: Boolean;
    function IsFocusColorStored: Boolean;
    function NotUsingController: Boolean;
    procedure SetDisabledColor( Value: TColor ); virtual;
    procedure SetFocusColor( Value: TColor ); virtual;
    procedure SetFrameColor( Value: TColor ); virtual;
    procedure SetFrameController( Value: TRzFrameController ); virtual;
    procedure SetFrameHotColor( Value: TColor ); virtual;
    procedure SetFrameHotTrack( Value: Boolean ); virtual;
    procedure SetFrameHotStyle( Value: TFrameStyle ); virtual;
    procedure SetFrameSides( Value: TSides ); virtual;
    procedure SetFrameStyle( Value: TFrameStyle ); virtual;
    procedure SetFrameVisible( Value: Boolean ); virtual;
    procedure SetFramingPreference( Value: TFramingPreference ); virtual;

    procedure SetHorzExtent( Value: Word ); virtual;
    procedure SetHorzScrollBar( Value: Boolean ); virtual;
    procedure SetOwnerDrawIndent( Value: Integer ); virtual;
    function GetItems: TStrings; virtual;

    function StoreGroupPrefix: Boolean;
    procedure SetGroupPrefix( const Value: string ); virtual;
    procedure SetGroupColor( Value: TColor ); virtual;
    procedure SetGroupFont( Value: TFont ); virtual;
    procedure SetUseGradients( Value: Boolean ); virtual;
    function GetItemIsGroup( Index: Integer ): Boolean; virtual;
    procedure SetShowGroups( Value: Boolean ); virtual;

    { Property Declarations }
    property Color: TColor
      read GetColor
      write SetColor
      stored IsColorStored
      default clWindow;

    property ShowItemHints: Boolean
      read FShowItemHints
      write FShowItemHints
      default True;

    property DisabledColor: TColor
      read FDisabledColor
      write SetDisabledColor
      stored NotUsingController
      default clBtnFace;

    property FocusColor: TColor
      read FFocusColor
      write SetFocusColor
      stored IsFocusColorStored
      default clWindow;

    property FrameColor: TColor
      read FFrameColor
      write SetFrameColor
      stored NotUsingController
      default clBtnShadow;

    property FrameController: TRzFrameController
      read FFrameController
      write SetFrameController;

    property FrameHotColor: TColor
      read FFrameHotColor
      write SetFrameHotColor
      stored NotUsingController
      default clBtnShadow;

    property FrameHotStyle: TFrameStyle
      read FFrameHotStyle
      write SetFrameHotStyle
      stored NotUsingController
      default fsFlatBold;

    property FrameHotTrack: Boolean
      read FFrameHotTrack
      write SetFrameHotTrack
      stored NotUsingController
      default False;

    property FrameSides: TSides
      read FFrameSides
      write SetFrameSides
      stored NotUsingController
      default sdAllSides;

    property FrameStyle: TFrameStyle
      read FFrameStyle
      write SetFrameStyle
      stored NotUsingController
      default fsFlat;

    property FrameVisible: Boolean
      read FFrameVisible
      write SetFrameVisible
      stored NotUsingController
      default False;

    property FramingPreference: TFramingPreference
      read FFramingPreference
      write SetFramingPreference
      default fpXPThemes;

    property GroupColor: TColor
      read FGroupColor
      write SetGroupColor
      default clInactiveCaptionText;

    property GroupFont: TFont
      read FGroupFont
      write SetGroupFont
      stored FGroupFontChanged;

    property GroupPrefix: string
      read FGroupPrefix
      write SetGroupPrefix
      stored StoreGroupPrefix;

    property HorzExtent: Word
      read FHorzExtent
      write SetHorzExtent
      default 0;

    property HorzScrollBar: Boolean
      read FHorzScrollBar
      write SetHorzScrollBar
      default False;

    property IncrementalSearch: Boolean
      read FIncrementalSearch
      write FIncrementalSearch
      default True;

    property OwnerDrawIndent: Integer
      read FOwnerDrawIndent
      write SetOwnerDrawIndent
      default 0;

    property ShowGroups: Boolean
      read FShowGroups
      write SetShowGroups
      default False;

    property TabOnEnter: Boolean
      read FTabOnEnter
      write FTabOnEnter
      default False;

    property UseGradients: Boolean
      read FUseGradients
      write SetUseGradients
      default True;

    property OnDrawItem: TDrawItemEvent
      read FOnDrawItem
      write FOnDrawItem;

    property OnMatch: TNotifyEvent
      read FOnMatch
      write FOnMatch;

    property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter
      write FOnMouseEnter;

    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave
      write FOnMouseLeave;

    property OnDeleteItems: TNotifyEvent
      read FOnDeleteItems
      write FOnDeleteItems;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function UseThemes: Boolean; virtual;
    procedure AdjustHorzExtent; virtual;

    procedure DefaultDrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState ); virtual;

    { Wrapper methods arounds Items object }
    function Add( const S: string ): Integer;
    function AddObject( const S: string; AObject: TObject ): Integer;
    procedure ClearSearchString;
    procedure Delete( Index: Integer );
    function IndexOf( const S: string ): Integer;
    procedure Insert( Index: Integer; const S: string );
    procedure InsertObject( Index: Integer; const S: string; AObject: TObject );
    {$IFNDEF VCL60_OR_HIGHER}
    function Count: Integer;
    {$ENDIF}
    function SelectedItem: string;
    function FindItem( const S: string ): Boolean;

    {$IFDEF VCL60_OR_HIGHER}
    procedure SelectAll; override;
    {$ELSE}
    procedure SelectAll;
    {$ENDIF}
    procedure UnselectAll;
    procedure DeleteSelectedItems;

    function AddGroup( const S: string ): Integer;

    function ItemCaption( Index: Integer ): string;
    function ItemInsideGroup( Index: Integer ): Boolean; virtual;
    function ItemGroupIndex( Index: Integer ): Integer; virtual;

    function ItemsInGroup( GroupIndex: Integer ): Integer;
    function ItemIndexOfGroup( GroupIndex: Integer ): Integer;
    function AddItemToGroup( GroupIndex: Integer; const S: string ): Integer;
    function InsertItemIntoGroup( GroupIndex, Index: Integer; const S: string ): Integer;

    procedure ItemToGroup( Index: Integer );
    procedure GroupToItem( Index: Integer );

    property ItemIsGroup[ Index: Integer ]: Boolean
      read GetItemIsGroup;


    property BeepOnInvalidKey: Boolean
      read FBeepOnInvalidKey
      write FBeepOnInvalidKey
      default True;

    property SearchString: string
      read FSearchString;
  end;


  TRzListBox = class( TRzCustomListBox )
  private
    FAboutInfo: TRzAboutInfo;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    { Inherited Properties and Events }
    property Align;
    property Anchors;
    property BeepOnInvalidKey;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
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
    property GroupColor;
    property GroupFont;
    property GroupPrefix;
    property HorzExtent;
    property HorzScrollBar;
    property ImeMode;
    property ImeName;
    property IncrementalSearch;
    property IntegralHeight;
    property ItemHeight;
    property Items;
    property MultiSelect;
    property OwnerDrawIndent;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowGroups;
    property ShowHint;
    property ShowItemHints;
    property Sorted;
    property Style;
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property TabWidth;
    property UseGradients;
    property Visible;

    property OnClick;
    property OnContextPopup;
    {$IFDEF VCL60_OR_HIGHER}
    property OnData;
    property OnDataFind;
    property OnDataObject;
    {$ENDIF}
    property OnDblClick;
    property OnDeleteItems;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMatch;
    property OnMeasureItem;
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


  EHeaderError = class( Exception );

  TRzTabArray = array[ 0..MaxTabs - 1 ] of Integer;

  TRzCustomTabbedListBox = class;

  TRzTabStopList = class( TRzIntegerList )
  private
    FListBox: TRzCustomTabbedListBox;
  protected
    procedure SetItem( Index: Integer; Value: Longint ); override;
  public
    constructor Create;
    procedure Delete( Index: Integer ); override;
    procedure Insert( Index: Integer; Value: Longint ); override;
    function Add( Value: Longint ): Integer; override;
  end;

  TRzTabStopsMode = ( tsmManual, tsmAutomatic );

  TRzCustomTabbedListBox = class( TRzCustomListBox )
  private
    FAboutInfo: TRzAboutInfo;
    FTabStops: TRzTabStopList;
    FTabStopsMode: TRzTabStopsMode;

    { Message Handling Methods }
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
  protected
    FDialogUnits: Integer;
    procedure CreateParams( var Params: TCreateParams ); override;
    procedure CreateWnd; override;
    procedure Loaded; override;

    procedure DrawGroup( Index: Integer; Rect: TRect; State: TOwnerDrawState ); override;

    function InitialTabStopOffset: Integer; virtual;
    procedure WndProc( var Msg: TMessage ); override;
    procedure GroupFontChanged; override;

    { Property Access Methods }
    function StoreTabStops: Boolean;
    procedure SetTabStops( Value: TRzTabStopList ); virtual;
    procedure SetTabStopsMode( Value: TRzTabStopsMode ); virtual;

    procedure GetTabArray( var TabCount: Integer; var TabArray: TRzTabArray ); virtual;
    function GetCellText( ACol, ARow: Integer ): string; virtual;
    procedure SetCellText( ACol, ARow: Integer; const Value: string ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure UpdateTabStops;
    procedure AdjustTabStops; virtual;
    procedure AdjustHorzExtent; override;

    procedure DefaultDrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState ); override;

    procedure UpdateFromHeader( Header: TControl ); virtual;

    { Property Declarations }
    property Cells[ ACol, ARow: Integer ]: string
      read GetCellText
      write SetCellText;

    property DialogUnits: Integer
      read FDialogUnits;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property TabStops: TRzTabStopList
      read FTabStops
      write SetTabStops
      stored StoreTabStops;

    property TabStopsMode: TRzTabStopsMode
      read FTabStopsMode
      write SetTabStopsMode
      default tsmManual;
  end;

  {========================================}
  {== TRzTabbedListBox Class Declaration ==}
  {========================================}

  TRzTabbedListBox = class( TRzCustomTabbedListBox )
  published
    { Inherited Properties and Events }
    property Align;
    property Anchors;
    property BeepOnInvalidKey;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property ShowItemHints default False;
    property ExtendedSelect;
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
    property GroupColor;
    property GroupFont;
    property GroupPrefix;
    property HorzExtent;
    property HorzScrollBar;
    property ImeMode;
    property ImeName;
    property IncrementalSearch;
    property IntegralHeight;
    property ItemHeight;
    property Items;
    property MultiSelect;
    property OwnerDrawIndent;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowGroups;
    property ShowHint;
    property Sorted;
    property Style;
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property UseGradients;
    property Visible;

    property OnClick;
    property OnContextPopup;
    {$IFDEF VCL60_OR_HIGHER}
    property OnData;
    property OnDataFind;
    property OnDataObject;
    {$ENDIF}
    property OnDblClick;
    property OnDeleteItems;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMatch;
    property OnMeasureItem;
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


  {====================================}
  {== TRzPopupEdit Class Declaration ==}
  {====================================}

  TRzEditListBox = class;

  TRzPopupEdit = class( TCustomEdit )
  private
    FList: TRzEditListBox;

    { Message Handling Methods }
    procedure CMCancelMode( var Msg: TCMCancelMode ); message cm_CancelMode;
    procedure CMShowingChanged( var Msg: TMessage ); message cm_ShowingChanged;
    procedure WMKillFocus( var Msg: TMessage ); message wm_KillFocus;
    procedure CNKeyDown( var Msg: TWMKeyDown ); message cn_KeyDown;
  protected
    procedure CreateParams( var Params: TCreateParams ); override;

    { Event Dispatch Methods }
    procedure KeyPress( var Key: Char ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    property Font;
  end;

  TRzShowingEditorEvent = procedure( Sender: TObject; Index: Integer; var AllowShow: Boolean ) of object;
  TRzSizeEditRectEvent = procedure( Sender: TObject; Index: Integer; var EditRect: TRect ) of object;
  TRzItemChangedEvent = procedure( Sender: TObject; Index: Integer ) of object;


  {======================================}
  {== TRzEditListBox Class Declaration ==}
  {======================================}

  TRzEditListBox = class( TRzListBox )
  private
    FJustGotFocus: Boolean;
    FAllowEdit: Boolean;
    FPopupEdit: TRzPopupEdit;
    FPopupVisible: Boolean;
    FCurrIdx: Integer;
    FEditorIdx: Integer;
    FDoubleClicked: Boolean;
    FTimer: TTimer;
    FShowEditorOnNextClick: Boolean;
    FAllowDeleteByKbd: Boolean;
    FOnSizeEditRect: TRzSizeEditRectEvent;
    FOnShowingEditor: TRzShowingEditorEvent;
    FOnHidingEditor: TNotifyEvent;
    FOnItemChanged: TRzItemChangedEvent;

    { Internal Event Handlers }
    procedure TimerExpired( Sender: TObject ); virtual;

    { Message Handling Methods }
    procedure WMSetFocus( var Msg: TMessage ); message wm_SetFocus;
    procedure WMLButtonDown( var Msg: TWMLButtonDown ); message wm_LButtonDown;
    procedure WMLButtonDblClick( var Msg: TWMLButtonDblClk ); message wm_LButtonDblClk;
  protected
    { Event Dispatch Methods }
    procedure SizeEditRect( Index: Integer; var EditRect: TRect ); dynamic;
    function DoShowingEditor( Index: Integer ): Boolean; dynamic;
    procedure DoHidingEditor; dynamic;

    procedure ItemChanged( Index: Integer ); dynamic;

    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
  public
    constructor Create( AOwner: TComponent ); override;

    procedure HideEditor( SaveChanges: Boolean ); virtual;
    procedure ShowEditor; virtual;

    property PopupEdit: TRzPopupEdit
      read FPopupEdit;
  published
    property AllowEdit: Boolean
      read FAllowEdit
      write FAllowEdit
      default True;

    property AllowDeleteByKbd: Boolean
      read FAllowDeleteByKbd
      write FAllowDeleteByKbd
      default False;

    property PopupVisible: Boolean
      read FPopupVisible;

    property OnSizeEditRect: TRzSizeEditRectEvent
      read FOnSizeEditRect
      write FOnSizeEditRect;

    property OnShowingEditor: TRzShowingEditorEvent
      read FOnShowingEditor
      write FOnShowingEditor;

    property OnHidingEditor: TNotifyEvent
      read FOnHidingEditor
      write FOnHidingEditor;

    property OnItemChanged: TRzItemChangedEvent
      read FOnItemChanged
      write FOnItemChanged;
  end;


  {======================================}
  {== TRzRankListBox Class Declaration ==}
  {======================================}

  TRzModifierKey = ( mkShift, mkNone );
  TRzMoveItemEvent = procedure( Sender: TObject; OldIndex, NewIndex: Integer ) of object;

  // By Definition:  Sorted = False
  //
  // Currently requires (these are ensured through read-only properties):
  //   Columns = 0
  //   DragMode = dmManual
  //   ExtendedSelect = False
  //   MultiSelect = False

  TRzRankListBox = class( TRzListBox )
  private
    FModifierKey: TRzModifierKey;           // Only applies to dragging with mouse
    FMoveOnDrag: Boolean;
    FMoving: Boolean;
    FOldIndex: Integer;
    FOldCursor: HCursor;
    FColumns: Integer;                      // Used instead of inherited Columns
    FDragCursor: TCursor;                   // Used instead of inherited DragCursor
    FDragMode: TDragMode;                   // Used instead of inherited DragMode
    FExtendedSelect: Boolean;               // Used instead of inherited ExtendedSelect
    FMultiSelect: Boolean;                  // Used instead of inherited MultiSelect
    FSorted: Boolean;                       // Used instead of inherited Sorted
    FOnMoveItem: TRzMoveItemEvent;
    procedure SetMoveOnDrag( Value: Boolean );
  protected
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseMove( Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MoveItem( OldIndex, NewIndex: Integer ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    // Define read-only properties to hide inherited properties
    property Columns: Integer               // Must be 0
      read FColumns
      default 0;

    property DragCursor: TCursor
      read FDragCursor
      default crDrag;

    property DragMode: TDragMode            // Must be dmManual
      read FDragMode
      default dmManual;

    property ExtendedSelect: Boolean        // Must be False
      read FExtendedSelect
      default False;

    property MultiSelect: Boolean           // Must be False
      read FMultiSelect
      default False;

    property Sorted: Boolean                // Must be False
      read FSorted
      default False;

    { Property Declarations }
    property ModifierKey: TRzModifierKey
      read FModifierKey
      write FModifierKey
      default mkShift;

    property MoveOnDrag: Boolean
      read FMoveOnDrag
      write SetMoveOnDrag
      default True;

    property OnMoveItem: TRzMoveItemEvent
      read FOnMoveItem
      write FOnMoveItem;
  end;


  TRzFontListBox = class( TRzCustomListBox )
  private
    FAboutInfo: TRzAboutInfo;
    FSaveFontName: string;
    FFont: TFont;

    FFontDevice: TRzFontDevice;
    FFontType: TRzFontType;
    FFontSize: Integer;
    FFontStyle: TFontStyles;
    FShowSymbolFonts: Boolean;

    FShowStyle: TRzShowStyle;

    FTrueTypeBmp: TBitmap;
    FFixedPitchBmp: TBitmap;
    FTrueTypeFixedBmp: TBitmap;
    FPrinterBmp: TBitmap;
    FDeviceBmp: TBitmap;

    FPreviewVisible: Boolean;
    FPreviewPanel: TRzPreviewFontPanel;
    FPreviewEdit: TCustomEdit;
    FPreviewText: string;

    FMRUCount: Integer;
    FMaintainMRUFonts: Boolean;

    { Message Handling Methods }
    procedure CNDrawItem( var Msg: TWMDrawItem ); message cn_DrawItem;
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
    procedure CMCancelMode( var Msg: TCMCancelMode ); message cm_CancelMode;
    procedure CMHidePreviewPanel( var Msg: TMessage ); message cm_HidePreviewPanel;
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure LoadFonts; virtual;
    procedure LoadBitmaps; virtual;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    procedure UpdatePreviewText;

    procedure HidePreviewPanel; virtual;
    procedure ShowPreviewPanel; virtual;

    { Event Dispatch Methods }
    procedure DrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState ); override;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;

    { Property Access Methods }
    procedure SetFontDevice( Value: TRzFontDevice ); virtual;
    procedure SetFontType( Value: TRzFontType ); virtual;
    function GetSelectedFont: TFont; virtual;
    procedure SetSelectedFont( Value: TFont ); virtual;
    function GetFontName: string; virtual;
    procedure SetFontName( const Value: string ); virtual;
    procedure SetPreviewEdit( Value: TCustomEdit ); virtual;
    function GetPreviewFontSize: Integer; virtual;
    procedure SetPreviewFontSize( Value: Integer ); virtual;
    function GetPreviewHeight: Integer; virtual;
    procedure SetPreviewHeight( Value: Integer ); virtual;
    function GetPreviewWidth: Integer; virtual;
    procedure SetPreviewWidth( Value: Integer ); virtual;
    procedure SetShowSymbolFonts( Value: Boolean ); virtual;
    procedure SetShowStyle( Value: TRzShowStyle ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure AddFontToMRUList;

    property SelectedFont: TFont
      read GetSelectedFont
      write SetSelectedFont;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property FontDevice: TRzFontDevice
      read FFontDevice
      write SetFontDevice
      default fdScreen;

    property FontName: string
      read GetFontName
      write SetFontName;

    property FontSize: Integer
      read FFontSize
      write FFontSize
      default 8;

    property FontStyle: TFontStyles
      read FFontStyle
      write FFontStyle
      default [];

    property FontType: TRzFontType
      read FFontType
      write SetFontType
      default ftAll;

    property MaintainMRUFonts: Boolean
      read FMaintainMRUFonts
      write FMaintainMRUFonts
      default False;

    property PreviewEdit: TCustomEdit
      read FPreviewEdit
      write FPreviewEdit;

    property PreviewFontSize: Integer
      read GetPreviewFontSize
      write SetPreviewFontSize
      default 36;

    property PreviewHeight: Integer
      read GetPreviewHeight
      write SetPreviewHeight
      default 65;

    property PreviewText: string
      read FPreviewText
      write FPreviewText;

    property PreviewWidth: Integer
      read GetPreviewWidth
      write SetPreviewWidth
      default 260;

    property ShowSymbolFonts: Boolean
      read FShowSymbolFonts
      write SetShowSymbolFonts
      default True;

    property ShowStyle: TRzShowStyle
      read FShowStyle
      write SetShowStyle
      default ssFontName;

    { Inherited Properties & Events }
    property Align;
    property Anchors;
    property BeepOnInvalidKey;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
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
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted default True;
    property TabOnEnter;
    property TabOrder;
    property TabStop;
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
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
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
  TypInfo,
  RzGrafx,
  Printers;

resourcestring
  sRzHeaderError   = 'Only THeader and THeaderControl components can be passed to TRzCustomTabbedListBox.UpdateFromHeader';
  sRzRowParamError = 'Row parameter out of range';
  sRzColParamError = 'Column parameter out of range';


{&RT}
{==============================}
{== TRzCustomListBox Methods ==}
{==============================}

constructor TRzCustomListBox.Create( AOwner: TComponent );
begin
  inherited;
  {&RCI}

  {$IFDEF VCL70_OR_HIGHER}
  ControlStyle := ControlStyle - [ csOpaque ];
  {$ENDIF}

  {$IFDEF VCL60_OR_HIGHER}
  inherited AutoComplete := False;
  {$ENDIF}
  FIncrementalSearch := True;
  FBeepOnInvalidKey := True;
  FSearchString := '';

  FTimer := TTimer.Create( nil );
  FTimer.Enabled := False;
  FTimer.OnTimer := SearchTimerExpired;
  FTimer.Interval := 1500; { 1.5 second delay }

  FCanvas := TControlCanvas.Create;
  TControlCanvas( FCanvas ).Control := Self;

  FDisabledColor := clBtnFace;
  FFocusColor := clWindow;
  FNormalColor := clWindow;
  FFrameColor := clBtnShadow;
  FFrameController := nil;
  FFrameHotColor := clBtnShadow;
  FFrameHotTrack := False;
  FFrameHotStyle := fsFlatBold;
  FFrameSides := sdAllSides;
  FFrameStyle := fsFlat;
  FFrameVisible := False;
  FFramingPreference := fpXPThemes;

  FGroupPrefix := strDefaultGroupPrefix;
  FGroupColor := clInactiveCaptionText;

  FGroupFont := TFont.Create;
  FGroupFont.Assign( Self.Font );
  FGroupFont.Style := [ fsBold ];
  FGroupFont.Color := clHighlight;
  FGroupFontChanged := False;
  FGroupFont.OnChange := GroupFontChangeHandler;

  FUseGradients := True;

  FTabOnEnter := False;
  FShowItemHints := True;
  FOwnerDrawIndent := 0;
end; {= TRzCustomListBox.Create =}


destructor TRzCustomListBox.Destroy;
begin
  FTimer.Free;
  FGroupFont.Free;
  if FFrameController <> nil then
    FFrameController.RemoveControl( Self );
  FCanvas.Free;
  inherited;
end;


procedure TRzCustomListBox.CreateParams( var Params: TCreateParams );
begin
  inherited;
  if FHorzScrollBar then
    Params.Style := Params.Style or ws_HScroll
  else
    Params.Style := Params.Style and not ws_HScroll;
end;


procedure TRzCustomListBox.CreateWnd;
begin
  inherited;

 { Initializing the scroll bar must occur after the Window Handle for the list }
 { box has been created }
  SendMessage( Handle, lb_SetHorizontalExtent, FHorzExtent, 0 );
  ShowScrollBar( Handle, sb_Horz, FHorzScrollBar );
end;


procedure TRzCustomListBox.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the FrameFlat and FrameFocusStyle properties were renamed to
  // FrameHotStyle and FrameHotStyle respectively in version 3.
  Filer.DefineProperty( 'FrameFlat', ReadOldFrameFlatProp, nil, False );
  Filer.DefineProperty( 'FrameFocusStyle', ReadOldFrameFocusStyleProp, nil, False );

  // Handle the fact that the FrameFlatStyle was published in version 2.x
  Filer.DefineProperty( 'FrameFlatStyle', TRzOldPropReader.ReadOldEnumProp, nil, False );
end;


procedure TRzCustomListBox.ReadOldFrameFlatProp( Reader: TReader );
begin
  FFrameHotTrack := Reader.ReadBoolean;
  if FFrameHotTrack then
  begin
    // If the FrameFlat property is stored, then init the FrameHotStyle property and the FrameStyle property.
    // These may be overridden when the rest of the stream is read in. However, we need to re-init them here
    // because the default values of fsStatus and fsLowered have changed in RC3.
    FFrameStyle := fsStatus;
    FFrameHotStyle := fsLowered;
  end;
end;


procedure TRzCustomListBox.ReadOldFrameFocusStyleProp( Reader: TReader );
begin
  FFrameHotStyle := TFrameStyle( GetEnumValue( TypeInfo( TFrameStyle ), Reader.ReadIdent ) );
end;


type
  TRzStringsAccess = class( TStrings )
  end;


procedure TRzCustomListBox.Loaded;
begin
  inherited;
  {$IFDEF VCL60_OR_HIGHER}
  if HorzScrollBar and ( TRzStringsAccess( Items ).UpdateCount = 0 ) then
    AdjustHorzExtent;
  {$ELSE}
  if HorzScrollBar then
    AdjustHorzExtent;
  {$ENDIF}
  UpdateColors;
  UpdateFrame( False, False );
end;


procedure TRzCustomListBox.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( AComponent = FFrameController ) then
    FFrameController := nil;
end;


procedure TRzCustomListBox.Resize;
begin
  inherited;
  if FUseGradients then
    Invalidate;
end;


procedure TRzCustomListBox.SearchTimerExpired( Sender: TObject );
begin
  if FKeyCount = 0 then
  begin
    FTimer.Enabled := False;
    FSearchString := '';
  end;
end;


procedure TRzCustomListBox.WMLButtonDown( var Msg: TWMLButtonDown );
begin
  {&RV}
  FSearchString := '';
  inherited;
end;



procedure TRzCustomListBox.WMKeyDown( var Msg: TWMKeyDown );
begin
  if Msg.CharCode in [ vk_Escape, vk_Prior..vk_Down ] then
    FSearchString := '';
  inherited;
end;


function TRzCustomListBox.FindClosest( const S: string ): Integer;
begin
  Result := SendMessage( Handle, lb_FindString, -1, Longint( PChar( S ) ) );
end;


procedure TRzCustomListBox.WMChar( var Msg: TWMChar );
var
  TempStr: string;
  Index, OldIdx: Integer;

  procedure UpdateIndex;
  begin
    OldIdx := ItemIndex;
    Index := FindClosest( TempStr );
    if Index <> -1 then
    begin
      if MultiSelect then
      begin
        Selected[ OldIdx ] := False;
        Selected[ Index ] := True;
        SendMessage( Handle, lb_SetCaretIndex, Index, 0 );
      end
      else
        ItemIndex := Index;
      FSearchString := TempStr;
      DoKeyPress( Msg );
      Match;
    end
    else if FBeepOnInvalidKey then
      MessageBeep( 0 );
  end;

begin {= TRzCustomListBox.WMChar =}
  if not FIncrementalSearch then
  begin
    inherited;
    Exit;
  end;

  TempStr := FSearchString;

  case Msg.CharCode of
    vk_Back:
    begin
      if Length( TempStr ) > 0 then
      begin
        System.Delete( TempStr, Length( TempStr ), 1 );
        if Length( TempStr ) = 0 then
        begin
          ItemIndex := 0;
          FSearchString := '';
          DoKeyPress( Msg );
          Exit;
        end;
      end
      else if FBeepOnInvalidKey then
        MessageBeep( 0 );

      UpdateIndex;
    end;

    vk_Return:
    begin
      if FTabOnEnter then
        PostMessage( Handle, wm_KeyDown, vk_Tab, 0 )
      else
        DoKeyPress( Msg );
    end;

    vk_Escape:
    begin
      ItemIndex := -1;
    end;


    32..255:
    begin
      // Allow space bar to toggle selection state of item
      if ( Msg.CharCode = 32 ) and MultiSelect and not ExtendedSelect then
        Exit;

      FKeyCount := 1;
      TempStr := TempStr + Char( Msg.CharCode );
      UpdateIndex;

      FTimer.Enabled := False;
      FTimer.Enabled := True;
      FKeyCount := 0;
    end;
  end;
end; {= TRzCustomListBox.WMChar =}


procedure TRzCustomListBox.Match;
begin
  if Assigned( FOnMatch ) then
    FOnMatch( Self );
end;


procedure TRzCustomListBox.DefaultDrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState );
var
  Flags: Longint;
  S: string;
begin
  Canvas.FillRect( Rect );
  if Index < Items.Count then
  begin
    Flags := DrawTextBiDiModeFlags( dt_SingleLine or dt_VCenter or dt_NoPrefix );
    if not UseRightToLeftAlignment then
      Inc( Rect.Left, 2 )
    else
      Dec( Rect.Right, 2 );

    S := '';
    {$IFDEF VCL60_OR_HIGHER}
    if ( Style in [ lbVirtual, lbVirtualOwnerDraw ] ) then
      S := DoGetData( Index )
    else
      S := Items[ Index ];
    {$ELSE}
      S := Items[ Index ];
    {$ENDIF}

    DrawText( Canvas.Handle, PChar( S ), Length( S ), Rect, Flags );
  end;
end; {= TRzCustomListBox.DefaultDrawItem =}


procedure TRzCustomListBox.DrawListItem( Index: Integer; Rect: TRect; State: TOwnerDrawState );
begin
  if not Assigned( OnDrawItem ) then
    DefaultDrawItem( Index, Rect, State )
  else
    OnDrawItem( Self, Index, Rect, State );
end;


procedure TRzCustomListBox.DrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState );
begin
  DrawListItem( Index, Rect, State );
end;



procedure TRzCustomListBox.ClearSearchString;
begin
  FSearchString := '';
end;


function TRzCustomListBox.GetItems: TStrings;
begin
  Result := Items;
end;

function TRzCustomListBox.Add( const S: string ): Integer;
begin
  Result := GetItems.Add( S );
end;

function TRzCustomListBox.AddObject( const S: string; AObject: TObject ): Integer;
begin
  Result := GetItems.AddObject( S, AObject );
end;

procedure TRzCustomListBox.Delete( Index: Integer );
var
  Idx: Integer;
begin
  Idx := ItemIndex;

  GetItems.Delete( Index );

  if ( Count > 0 ) and ( Idx <> -1 ) then
  begin
    if Idx = Count then
      Dec( Idx );
    ItemIndex := Idx;
    Click;
  end;
end;

function TRzCustomListBox.IndexOf( const S: string ): Integer;
begin
  Result := GetItems.IndexOf( S );
end;

procedure TRzCustomListBox.Insert( Index: Integer; const S: string );
begin
  GetItems.Insert( Index, S );
end;

procedure TRzCustomListBox.InsertObject( Index: Integer; const S: string; AObject: TObject );
begin
  GetItems.InsertObject( Index, S, AObject );
end;

{$IFNDEF VCL60_OR_HIGHER}
function TRzCustomListBox.Count: Integer;
begin
  Result := GetItems.Count;
end;
{$ENDIF}

function TRzCustomListBox.SelectedItem: string;
begin
  if ( MultiSelect and ( SelCount > 0 ) ) or
     ( not MultiSelect and ( ItemIndex <> -1 ) ) then
    Result := GetItems[ ItemIndex ]
  else
    Result := '';
end;


function TRzCustomListBox.FindItem( const S: string ): Boolean;
var
  Idx: Integer;
begin
  Idx := GetItems.IndexOf( S );
  if Idx <> -1 then
    ItemIndex := Idx;
  Result := Idx <> -1;
end;


procedure TRzCustomListBox.SelectAll;
begin
  if MultiSelect then
    SendMessage( Handle, lb_SetSel, 1, -1 );
end;


procedure TRzCustomListBox.UnselectAll;
begin
  if MultiSelect then
    SendMessage( Handle, lb_SetSel, 0, -1 );
end;


procedure TRzCustomListBox.DoDeleteItems;
begin
  if Assigned( FOnDeleteItems ) then
    FOnDeleteItems( Self );
end;


procedure TRzCustomListBox.DeleteSelectedItems;
var
  I: Integer;
begin
  Screen.Cursor := crHourGlass;
  Items.BeginUpdate;
  try
    for I := Items.Count - 1 downto 0 do
    begin
      if Selected[ I ] then
        Items.Delete( I );
    end;
  finally
    Items.EndUpdate;
    Screen.Cursor := crDefault;
  end;
  DoDeleteItems;
end;


function TRzCustomListBox.GetColor: TColor;
begin
  Result := inherited Color;
end;


procedure TRzCustomListBox.SetColor( Value: TColor );
begin
  if Color <> Value then
  begin
    inherited Color := Value;
    if not FUpdatingColor then
    begin
      if FFocusColor = FNormalColor then
        FFocusColor := Value;
      FNormalColor := Value;
    end;
    if FFrameVisible and not UseThemes then
      RepaintFrame;
  end;
end;


function TRzCustomListBox.IsColorStored: Boolean;
begin
  Result := NotUsingController and Enabled;
end;


function TRzCustomListBox.IsFocusColorStored: Boolean;
begin
  Result := NotUsingController and ( ColorToRGB( FFocusColor ) <> ColorToRGB( Color ) );
end;


function TRzCustomListBox.NotUsingController: Boolean;
begin
  Result := FFrameController = nil;
end;


procedure TRzCustomListBox.SetDisabledColor( Value: TColor );
begin
  FDisabledColor := Value;
  if not Enabled then
    UpdateColors;
end;


procedure TRzCustomListBox.SetFocusColor( Value: TColor );
begin
  FFocusColor := Value;
  if Focused then
    UpdateColors;
end;


procedure TRzCustomListBox.SetFrameColor( Value: TColor );
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    RepaintFrame;
  end;
end;


procedure TRzCustomListBox.SetFrameController( Value: TRzFrameController );
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


procedure TRzCustomListBox.SetFrameHotColor( Value: TColor );
begin
  if FFrameHotColor <> Value then
  begin
    FFrameHotColor := Value;
    RepaintFrame;
  end;
end;


procedure TRzCustomListBox.SetFrameHotTrack( Value: Boolean );
begin
  if FFrameHotTrack <> Value then
  begin
    FFrameHotTrack := Value;
    if FFrameHotTrack then
    begin
      FrameVisible := True;
      if not ( csLoading in ComponentState ) then
        FFrameSides := sdAllSides;
    end;
    RepaintFrame;
    Invalidate;
  end;
end;


procedure TRzCustomListBox.SetFrameHotStyle( Value: TFrameStyle );
begin
  if FFrameHotStyle <> Value then
  begin
    FFrameHotStyle := Value;
    RepaintFrame;
  end;
end;


procedure TRzCustomListBox.SetFrameSides( Value: TSides );
begin
  if FFrameSides <> Value then
  begin
    FFrameSides := Value;
    RepaintFrame;
  end;
end;


procedure TRzCustomListBox.SetFrameStyle( Value: TFrameStyle );
begin
  if FFrameStyle <> Value then
  begin
    FFrameStyle := Value;
    RepaintFrame;
  end;
end;


procedure TRzCustomListBox.SetFrameVisible( Value: Boolean );
begin
  if FFrameVisible <> Value then
  begin
    FFrameVisible := Value;
    if FFrameVisible then
      Ctl3D := True;
    RecreateWnd;              { Must recreate window so Ctl3D border reappears }
  end;
end;


procedure TRzCustomListBox.SetFramingPreference( Value: TFramingPreference );
begin
  if FFramingPreference <> Value then
  begin
    FFramingPreference := Value;
    if FFramingPreference = fpCustomFraming then
      RepaintFrame;
  end;
end;


procedure TRzCustomListBox.SetHorzExtent( Value: Word );
begin
  if Value <> FHorzExtent then
  begin
    FHorzExtent := Value;
    Perform( lb_SetHorizontalExtent, FHorzExtent, 0 );
  end;
end;


procedure TRzCustomListBox.SetHorzScrollBar( Value: Boolean );
begin
  if Value <> FHorzScrollBar then
  begin
    FHorzScrollBar := Value;
    RecreateWnd;
  end;
end;


procedure TRzCustomListBox.AdjustHorzExtent;
var
  ItemStr: string;
  I, MaxExtent: integer;
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
  SizeRec: TSize;
begin
  MaxExtent := 0;
  DC := GetDC( 0 );
  try
    SaveFont := SelectObject( DC, Font.Handle );
    GetTextMetrics( DC, Metrics );

    for I := 0 to Items.Count - 1 do
    begin
      ItemStr := Items[ I ] + 'x';
      GetTextExtentPoint32( DC, PChar( ItemStr ), Length( ItemStr ), SizeRec );
      if SizeRec.CX > MaxExtent then
        MaxExtent := SizeRec.CX;
    end;

    SelectObject( DC, SaveFont );
  finally
    ReleaseDC( 0, DC );
  end;
  HorzExtent := MaxExtent;
end; {= TRzCustomListbox.AdjustHorzExtent =}


procedure TRzCustomListBox.SetOwnerDrawIndent( Value: Integer );
begin
  if FOwnerDrawIndent <> Value then
  begin
    FOwnerDrawIndent := Value;
    Invalidate;
  end;
end;


procedure TRzCustomListBox.UpdateItemHeight;
begin
  ItemHeight := GetMinFontHeight( Font );
end;


procedure TRzCustomListBox.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  {$IFDEF VCL60_OR_HIGHER}
  if HorzScrollBar and ( TRzStringsAccess( Items ).UpdateCount = 0 ) then
    AdjustHorzExtent;
  {$ELSE}
  if HorzScrollBar then
    AdjustHorzExtent;
  {$ENDIF}
  if FShowGroups then
    UpdateItemHeight;
end;


procedure TRzCustomListBox.WndProc( var Msg: TMessage );
begin
  inherited;

  case Msg.Msg of
    lb_AddString, lb_InsertString, lb_DeleteString, lb_ResetContent:
    begin
      {$IFDEF VCL60_OR_HIGHER}
      if HorzScrollBar and ( TRzStringsAccess( Items ).UpdateCount = 0 ) then
        AdjustHorzExtent;
      {$ELSE}
      if HorzScrollBar then
        AdjustHorzExtent;
      {$ENDIF}
    end;
  end;
end;


procedure TRzCustomListBox.RepaintFrame;
var
  R: TRect;
begin
  R := Rect( 0, 0, Width, Height );
  RedrawWindow( Handle, @R, 0, rdw_Invalidate or rdw_UpdateNow or rdw_Frame );
end;


function TRzCustomListBox.UseThemes: Boolean;
begin
  Result := ( FFramingPreference = fpXPThemes ) and ThemeServices.ThemesEnabled;
end;


procedure TRzCustomListBox.CMEnabledChanged( var Msg: TMessage );
begin
  inherited;
  UpdateColors;
end;


procedure TRzCustomListBox.WMNCPaint( var Msg: TWMNCPaint );
var
  DC: HDC;
begin
  inherited;                       { Must call inherited so scroll bar show up }

  if FFrameVisible and not UseThemes then
  begin
    DC := GetWindowDC( Handle );
    FCanvas.Handle := DC;
    try
      if FFrameHotTrack and ( Focused or FOverControl ) then
        DrawFrame( FCanvas, Width, Height, FFrameHotStyle, Color, FFrameHotColor, FFrameSides )
      else
        DrawFrame( FCanvas, Width, Height, FFrameStyle, Color, FFrameColor, FFrameSides );
    finally
      FCanvas.Handle := 0;
      ReleaseDC( Handle, DC );
    end;
    Msg.Result := 0;
  end;
end; {= TRzCustomListBox.WMNCPaint =}


procedure TRzCustomListBox.CMParentColorChanged( var Msg: TMessage );
begin
  inherited;

  if ParentColor then
  begin
    // If ParentColor set to True, must reset FNormalColor and FFocusColor
    if FFocusColor = FNormalColor then
      FFocusColor := Color;
    FNormalColor := Color;
  end;

  if FrameVisible then
    RepaintFrame;
end;


procedure TRzCustomListBox.UpdateColors;
begin
  if csLoading in ComponentState then
    Exit;

  FUpdatingColor := True;
  try
    if not Enabled then
      Color := FDisabledColor
    else if Focused then
      Color := FFocusColor
    else
      Color := FNormalColor;
  finally
    FUpdatingColor := False;
  end;
end;


procedure TRzCustomListBox.UpdateFrame( ViaMouse, InFocus: Boolean );
begin
  if ViaMouse then
    FOverControl := InFocus;

  if FFrameHotTrack then
    RepaintFrame;

  UpdateColors;
end;


procedure TRzCustomListBox.CMEnter( var Msg: TCMEnter );
begin
  UpdateFrame( False, True );
  inherited;
end;


procedure TRzCustomListBox.CMExit( var Msg: TCMExit );
begin
  inherited;
  UpdateFrame( False, False );
end;


procedure TRzCustomListBox.MouseEnter;
begin
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
end;


procedure TRzCustomListBox.CMMouseEnter( var Msg: TMessage );
var
  P: TPoint;
begin
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  UpdateFrame( True, True );
  MouseEnter;

  GetCursorPos( P );
  P := ScreenToClient( P );
  if FShowItemHints then
    DoHint( P.X, P.Y );
end;


procedure TRzCustomListBox.MouseLeave;
begin
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
end;


procedure TRzCustomListBox.CMMouseLeave( var Msg: TMessage );
begin
  inherited;
  UpdateFrame( True, False );
  MouseLeave;
  ReleaseHintWindow;
end;


function TRzCustomListBox.CalcHintRect( MaxWidth: Integer; const HintStr: string; HintWnd: THintWindow ): TRect;
begin
  Result := HintWnd.CalcHintRect( Screen.Width, HintStr, nil );
end;


procedure TRzCustomListBox.DoHint( X, Y: Integer );
var
  Idx, Offset: Integer;
  R, IR, WinRect: TRect;
  P: TPoint;
  HintStr: string;

  function CleanUpString( const S: string ): string;
  var
    I: Integer;
  begin
    Result := '';
    for I := 1 to Length( S ) do
    begin
      if S[ I ] = #9 then
        Result := Result + '        '
      else
        Result := Result + S[ I ];
    end;
  end;

begin
  Idx := ItemAtPos( Point( X, Y ), True );
  Canvas.Font := Font;
  if not ( csDesigning in ComponentState ) and ( Idx >= 0 ) and
     ( Canvas.TextWidth( Items[ Idx ] ) + 2 > ClientWidth ) and ForegroundTask then
  begin
    if not Assigned( FHintWnd ) then
    begin
      FHintWnd := THintWindow.Create( Self );
      FHintWnd.Color := Application.HintColor;
    end;

    HintStr := CleanUpString( Items[ Idx ] );
    FHintWnd.Canvas.Font := Self.Font;
    R := CalcHintRect( Screen.Width, HintStr, FHintWnd );
    IR := ItemRect( Idx );

    Offset := ( ( IR.Bottom - IR.Top ) - ( R.Bottom - R.Top ) ) div 2 - 2;
    P := ClientToScreen( ItemRect( Idx ).TopLeft );
    OffsetRect( R, P.X - 1, P.Y + Offset );


    GetWindowRect( FHintWnd.Handle, WinRect );

    if not IsWindowVisible( FHintWnd.Handle ) or not ( ( R.Left = WinRect.Left ) and ( R.Top = WinRect.Top ) ) then
      FHintWnd.ActivateHint( R, HintStr )
  end
  else
    ReleaseHintWindow;
end;


procedure TRzCustomListBox.WMMouseMove(var Msg: TWMMouseMove);
begin
  inherited;
  if ShowItemHints then
    DoHint(Msg.XPos, Msg.YPos);
end;


procedure TRzCustomListBox.ReleaseHintWindow;
begin
  if Assigned( FHintWnd ) then
    FHintWnd.ReleaseHandle;
end;


procedure TRzCustomListBox.WMSize( var Msg: TWMSize );
begin
  inherited;
  if FFrameVisible and not UseThemes then
    RepaintFrame;
end;


function TRzCustomListBox.DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean;
var
  Info: TScrollInfo;
  I: Integer;
begin
  Info.cbSize := SizeOf( Info );
  Info.fMask := sif_Pos;

  GetScrollInfo( Handle, sb_Vert, Info );

  Info.nPos := Info.nPos + Mouse.WheelScrollLines;

  for I := 1 to Mouse.WheelScrollLines do
    SendMessage( Handle, wm_VScroll, MakeLong( sb_LineDown, 0 ), 0 );

  SetScrollInfo( Handle, sb_Vert, Info, True );
  Result := True;
end;


function TRzCustomListBox.DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean;
var
  Info: TScrollInfo;
  I, Delta: Integer;
begin
  Info.cbSize := SizeOf( Info );
  Info.fMask := sif_Pos;

  GetScrollInfo( Handle, sb_Vert, Info );

  Info.nPos := Info.nPos - Mouse.WheelScrollLines;

  if Info.nPos >= 0 then
    Delta := Mouse.WheelScrollLines
  else
  begin
    Delta := Info.nPos + Mouse.WheelScrollLines;
    Info.nPos := 0;
  end;

  for I := 1 to Delta do
    SendMessage( Handle, wm_VScroll, MakeLong( sb_LineUp, 0 ), 0 );

  SetScrollInfo( Handle, sb_Vert, Info, True );
  Result := True;
end;


function TRzCustomListBox.OwnerDrawItemIndent: Integer;
begin
  Result := FOwnerDrawIndent;
end;


procedure TRzCustomListBox.CNDrawItem( var Msg: TWMDrawItem );
var
  IsGroup: Boolean;
  State: TOwnerDrawState;
  ItemDetails: TDrawItemStruct;
begin
  ItemDetails := Msg.DrawItemStruct^;

  if FShowGroups and ( Integer( ItemDetails.itemID ) >= 0 ) and ItemIsGroup[ Integer( ItemDetails.itemID ) ] then
    IsGroup := True
  else
  begin
    IsGroup := False;
    // Indent owner-draw rectangle so focus rect doesn't cover glyph
    if not UseRightToLeftAlignment then
      ItemDetails.rcItem.Left := ItemDetails.rcItem.Left + OwnerDrawItemIndent
    else
      ItemDetails.rcItem.Right := ItemDetails.rcItem.Right - OwnerDrawItemIndent;
  end;

  State := TOwnerDrawState( LongRec( ItemDetails.itemState ).Lo );
  Canvas.Handle := ItemDetails.hDC;
  Canvas.Font := Font;
  Canvas.Brush := Brush;
  if ( Integer( ItemDetails.itemID ) >= 0 ) and ( odSelected in State ) then
  begin
    Canvas.Brush.Color := clHighlight;
    Canvas.Font.Color := clHighlightText
  end;

  if Integer( ItemDetails.itemID ) >= 0 then
  begin
    if IsGroup then
      DrawGroup( ItemDetails.itemID, ItemDetails.rcItem, State )
    else
    begin
      DrawItem( ItemDetails.itemID, ItemDetails.rcItem, State );
    end;
  end
  else
    Canvas.FillRect( ItemDetails.rcItem );

  if odFocused in State then
    DrawFocusRect( ItemDetails.hDC, ItemDetails.rcItem );

  Canvas.Handle := 0;
end; {= TRzCustomListBox.CNDrawItem =}


function TRzCustomListBox.StoreGroupPrefix: Boolean;
begin
  Result := FGroupPrefix <> strDefaultGroupPrefix;
end;


procedure TRzCustomListBox.SetGroupPrefix( const Value: string );
begin
  if FGroupPrefix <> Value then
  begin
    FGroupPrefix := Value;
    Invalidate;
  end;
end;


procedure TRzCustomListBox.SetGroupColor( Value: TColor );
begin
  if FGroupColor <> Value then
  begin
    FGroupColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomListBox.SetGroupFont( Value: TFont );
begin
  FGroupFont.Assign( Value );
end;


procedure TRzCustomListBox.GroupFontChanged;
begin
  // Notification - handled in descendant classes
end;

procedure TRzCustomListBox.GroupFontChangeHandler( Sender: TObject );
begin
  FGroupFontChanged := True;
  GroupFontChanged;
  Invalidate;
end;


procedure TRzCustomListBox.SetShowGroups( Value: Boolean );
begin
  if FShowGroups <> Value then
  begin
    FShowGroups := Value;
    if FShowGroups then
    begin
      Style := lbOwnerDrawFixed;
      UpdateItemHeight;
    end;
    Invalidate;
  end;
end;


procedure TRzCustomListBox.SetUseGradients( Value: Boolean );
begin
  if FUseGradients <> Value then
  begin
    FUseGradients := Value;
    Invalidate;
  end;
end;


function TRzCustomListBox.GetItemIsGroup( Index: Integer ): Boolean;
begin
  Result := False;
  if ( Index < 0 ) or ( Index >= Items.Count ) then
    Exit;
  Result := Copy( Items[ Index ], 1, Length( FGroupPrefix ) ) = FGroupPrefix;
end;


procedure TRzCustomListBox.ItemToGroup( Index: Integer );
var
  ResetItemIndex: Boolean;
begin
  if ( Index < 0 ) or ( Index >= Items.Count ) then
    Exit;
  if not ItemIsGroup[ Index ] then
  begin
    ResetItemIndex := Index = ItemIndex;
    Items[ Index ] := FGroupPrefix + Items[ Index ];
    if ResetItemIndex then
      ItemIndex := Index;
  end;
end;


procedure TRzCustomListBox.GroupToItem( Index: Integer );
var
  ResetItemIndex: Boolean;
  S: string;
begin
  if ( Index < 0 ) or ( Index >= Items.Count ) then
    Exit;
  if ItemIsGroup[ Index ] then
  begin
    ResetItemIndex := Index = ItemIndex;
    S := Items[ Index ];
    System.Delete( S, 1, Length( FGroupPrefix ) );
    Items[ Index ] := S;
    if ResetItemIndex then
      ItemIndex := Index;
  end;
end;


procedure TRzCustomListBox.DrawGroup( Index: Integer; Rect: TRect; State: TOwnerDrawState );
var
  S: string;
  TextOffset: Integer;
begin
  Canvas.Font := FGroupFont;

  if ( odSelected in State ) then
  begin
    Canvas.Font.Color := clHighlightText;
    Canvas.FillRect( Rect )
  end
  else if FUseGradients and FullColorSupport then
  begin
    if not UseRightToLeftAlignment then
      PaintGradient( Canvas, Rect, gdVerticalEnd, FGroupColor, Color )
    else
      PaintGradient( Canvas, Rect, gdVerticalEnd, Color, FGroupColor );
  end
  else
  begin
    Canvas.Brush.Color := FGroupColor;
    Canvas.FillRect( Rect );
  end;

  TextOffset := ( ItemHeight - Canvas.TextHeight( 'Pp' ) ) div 2;   // Center text vertically

  Canvas.Brush.Style := bsClear;

  IntersectClipRect( Canvas.Handle, Rect.Left, Rect.Top, Rect.Right, Rect.Bottom );
  try
    S := Items[ Index ];
    System.Delete( S, 1, Length( FGroupPrefix ) );         // Remove group prefix 

    if not UseRightToLeftAlignment then
    begin
      TextOut( Canvas.Handle, Rect.Left + 2, Rect.Top + TextOffset, PChar( S ), Length( S ) );
    end
    else
    begin
      SetTextAlign( Canvas.Handle, ta_Right or ta_Top );
      TextOut( Canvas.Handle, Rect.Right - 2, Rect.Top + TextOffset, PChar( S ), Length( S ) );
    end;

  finally
    SelectClipRgn( Canvas.Handle, 0 );                     // Removing clipping region
    Canvas.Brush.Style := bsSolid;
  end;
end; {= TRzCustomListBox.DrawGroup =}


function TRzCustomListBox.AddGroup( const S: string ): Integer;
begin
  Result := GetItems.Add( FGroupPrefix + S );
end;


function TRzCustomListBox.ItemsInGroup( GroupIndex: Integer ): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := ItemIndexOfGroup( GroupIndex ) + 1 to Items.Count - 1 do
  begin
    if ItemIsGroup[ I ] then                               // Found the next category - we're outta here.
      Exit;

    Inc( Result );
  end;
end;


function TRzCustomListBox.ItemIndexOfGroup( GroupIndex: Integer ): Integer;
var
  I, GroupCount: Integer;
begin
  Result := -1;
  if ( Items.Count > 0 ) and ( GroupIndex > -1 ) and ( GroupIndex < Items.Count ) then
  begin
    GroupCount := -1;
    for I := 0 to Items.Count - 1 do
    begin
      if ItemIsGroup[ I ] then
      begin
        Inc( GroupCount );
        if GroupCount = GroupIndex then
        begin
          Result := I;
          Exit;
        end;
      end;
    end;
  end;
end;


function TRzCustomListBox.InsertItemIntoGroup( GroupIndex, Index: Integer; const S: string ): Integer;
var
  Idx: Integer;
begin
  Idx := ItemIndexOfGroup( GroupIndex );
  if ( Idx <> -1 ) and ( Index >= 0 ) and ( Index <= ItemsInGroup( GroupIndex ) ) then
  begin
    Insert( Idx + Index + 1, S );
    Result := Idx + Index + 1;
  end
  else
    Result := -1;
end;


function TRzCustomListBox.AddItemToGroup( GroupIndex: Integer; const S: string ): Integer;
begin
  Result := InsertItemIntoGroup( GroupIndex, ItemsInGroup( GroupIndex ), S );
end;


function TRzCustomListBox.ItemCaption( Index: Integer ): string;
begin
  Result := '';
  if ( Index < 0 ) or ( Index >= Items.Count ) then
    Exit;

  if ItemIsGroup[ Index ] then
  begin
    Result := Items[ Index ];
    System.Delete( Result, 1, Length( FGroupPrefix ) );
  end
  else
    Result := Items[ Index ];
end;


function TRzCustomListBox.ItemGroupIndex( Index: Integer ): Integer;
var
  I: Integer;
begin
  // Returns the index to the heading for the group containing ItemIndex.
  Result := -1;
  if Index = -1 then
    Exit;

  for I := Index downto 0 do
  begin
    if ItemIsGroup[ I ] then                               // Found the next category - we're outta here.
    begin
      Result := I;
      Exit;
    end;
  end;
end;


function TRzCustomListBox.ItemInsideGroup( Index: Integer ): Boolean;
begin
  Result := ItemGroupIndex( Index ) <> -1;
end;


{============================}
{== TRzTabStopList Methods ==}
{============================}

constructor TRzTabStopList.Create;
begin
  inherited Create;
  Min := -MaxLongint;
  Max := MaxLongint;
end;


procedure TRzTabStopList.SetItem( Index: Integer; Value: Longint );
begin
  inherited;
  if FListBox <> nil then
    FListBox.UpdateTabStops;
end;


procedure TRzTabStopList.Delete( Index: Integer );
begin
  inherited;
  if FListBox <> nil then
    FListBox.UpdateTabStops;
end;


procedure TRzTabStopList.Insert( Index: Integer; Value: Longint );
begin
  inherited;
  if FListBox <> nil then
    FListBox.UpdateTabStops;
end;


function TRzTabStopList.Add( Value: Longint ): Integer;
begin
  Result := inherited Add( Value );
  if FListBox <> nil then
    FListBox.UpdateTabStops;
end;


{==============================}
{== TRzCustomTabbedListBox Methods ==}
{==============================}

constructor TRzCustomTabbedListBox.Create( AOwner: TComponent );
begin
  inherited;
  FDialogUnits := 6;
  FTabStops := TRzTabStopList.Create;
  FTabStops.FListBox := Self;

  FTabStopsMode := tsmManual;

  FShowItemHints := False;
  {&RCI}
end;


destructor TRzCustomTabbedListBox.Destroy;
begin
  FTabStops.Free;
  inherited;
end;


procedure TRzCustomTabbedListBox.CreateParams( var Params: TCreateParams );
begin
  inherited;
  Params.Style := Params.Style or lbs_UseTabStops;
end;


procedure TRzCustomTabbedListBox.CreateWnd;
begin
  inherited;
  UpdateTabStops;
  {&RV}
end;


procedure TRzCustomTabbedListBox.Loaded;
begin
  inherited;
  if FTabStopsMode = tsmAutomatic then
    AdjustTabStops;
  UpdateTabStops;
end;


procedure TRzCustomTabbedListBox.GroupFontChanged;
begin
  inherited;
  {$IFDEF VCL60_OR_HIGHER}
  if ( FTabStopsMode = tsmAutomatic ) and ( TRzStringsAccess( Items ).UpdateCount = 0 ) then
    AdjustTabStops;
  {$ELSE}
  if ( FTabStopsMode = tsmAutomatic ) then
    AdjustTabStops;
  {$ENDIF}
end;


procedure TRzCustomTabbedListBox.DrawGroup( Index: Integer; Rect: TRect; State: TOwnerDrawState );
var
  S: string;
  TextOffset: Integer;
  TabCount, I: Integer;
  TabArray: TRzTabArray;
begin
  Canvas.Font := FGroupFont;

  if ( odSelected in State ) then
  begin
    Canvas.Font.Color := clHighlightText;
    Canvas.FillRect( Rect )
  end
  else if FUseGradients and FullColorSupport then
  begin
    if not UseRightToLeftAlignment then
      PaintGradient( Canvas, Rect, gdVerticalEnd, FGroupColor, Color )
    else
      PaintGradient( Canvas, Rect, gdVerticalEnd, Color, FGroupColor );
  end
  else
  begin
    Canvas.Brush.Color := FGroupColor;
    Canvas.FillRect( Rect );
  end;

  TextOffset := ( ItemHeight - Canvas.TextHeight( 'Pp' ) ) div 2;   // Center text vertically.

  Canvas.Brush.Style := bsClear;

  IntersectClipRect( Canvas.Handle, Rect.Left, Rect.Top, Rect.Right, Rect.Bottom );
  try
    GetTabArray( TabCount, TabArray );
    for I := 0 to TabCount - 1 do
      TabArray[ I ] := Round( TabArray[ I ] * FDialogUnits / 4 );

    S := Items[ Index ];
    System.Delete( S, 1, Length( FGroupPrefix ) );     // Remove group prefix

    if not UseRightToLeftAlignment then
    begin
      TabbedTextOut( Canvas.Handle, Rect.Left + 2, Rect.Top + TextOffset, PChar( S ), Length( S ), TabCount, TabArray, 0 );
    end
    else
    begin
      SetTextAlign( Canvas.Handle, ta_Right or ta_Top );
      TextOut( Canvas.Handle, Rect.Right - 2, Rect.Top + TextOffset, PChar( S ), Length( S ) );
    end;

  finally
    SelectClipRgn( Canvas.Handle, 0 );                     // Removing clipping region
    Canvas.Brush.Style := bsSolid;
  end;
end; {= TRzCustomTabbedListBox.DrawGroup =}


procedure TRzCustomTabbedListBox.DefaultDrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState );
var
  TextOffset: Integer;
  TabCount, I: Integer;
  TabArray: TRzTabArray;
begin
  Canvas.FillRect( Rect );   { Clear area for icon and text }
  TextOffset := ( ItemHeight - Canvas.TextHeight( 'Pp' ) ) div 2;

  { Clip text to Rect }
  IntersectClipRect( Canvas.Handle, Rect.Left, Rect.Top, Rect.Right, Rect.Bottom );
  try
    if not UseRightToLeftAlignment then
    begin
      GetTabArray( TabCount, TabArray );
      for I := 0 to TabCount - 1 do
        TabArray[ I ] := Round( TabArray[ I ] * FDialogUnits / 4 );

      TabbedTextOut( Canvas.Handle, Rect.Left + 2, Rect.Top + TextOffset,
                     PChar( Items[ Index ] ), Length( Items[ Index ] ), TabCount, TabArray, 0 );
    end
    else
    begin
      SetTextAlign( Canvas.Handle, ta_Right );
      TextOut( Canvas.Handle, Rect.Right - 2, Rect.Top + TextOffset, PChar( Items[ Index ] ), Length( Items[ Index ] ) );
    end
  finally
    SelectClipRgn( Canvas.Handle, 0 );            { Removing clipping region }
  end;

end; {= TRzCustomTabbedListBox.DefaultDrawItem =}


procedure TRzCustomTabbedListBox.WndProc( var Msg: TMessage );
begin
  inherited;

  case Msg.Msg of
    lb_AddString, lb_InsertString, lb_DeleteString:
    begin
      {$IFDEF VCL60_OR_HIGHER}
      if ( FTabStopsMode = tsmAutomatic ) and ( TRzStringsAccess( Items ).UpdateCount = 0 ) then
        AdjustTabStops;
      {$ELSE}
      if ( FTabStopsMode = tsmAutomatic ) then
        AdjustTabStops;
      {$ENDIF}
    end;
  end;
end;


procedure TRzCustomTabbedListBox.SetTabStopsMode( Value: TRzTabStopsMode );
begin
  if FTabStopsMode <> Value then
  begin
    FTabStopsMode := Value;

    {$IFDEF VCL60_OR_HIGHER}
    if ( FTabStopsMode = tsmAutomatic ) and ( TRzStringsAccess( Items ).UpdateCount = 0 ) then
      AdjustTabStops;
    {$ELSE}
    if ( FTabStopsMode = tsmAutomatic ) then
      AdjustTabStops;
    {$ENDIF}
  end;
end;


function TRzCustomTabbedListBox.InitialTabStopOffset: Integer;
begin
  Result := 0;
end;


procedure TRzCustomTabbedListBox.AdjustTabStops;
var
  I, K, N, P, W, T, MaxW, MaxTabs: Integer;
  StrList: TStringList;
  S, ColStr: string;
begin
  if ( csLoading in ComponentState ) or ( csDestroying in ComponentState ) then
    Exit;

  FTabStops.Clear;

  MaxTabs := 0;
  for I := 0 to Items.Count - 1 do
  begin
    N := CountChar( #9, Items[ I ] );
    if N > MaxTabs then
      MaxTabs := N;
  end;

  StrList := TStringList.Create;
  try
    StrList.AddStrings( Items );

    for K := 0 to MaxTabs - 1 do
    begin
      MaxW := 0;
      for I := 0 to StrList.Count - 1 do
      begin
        S := StrList[ I ];
        P := Pos( #9, S );
        if P = 0 then                                      // If not tab found, then consider entire remaining string
          P := Length( S ) + 1;
        ColStr := Copy( S, 1, P - 1 );
        StrList[ I ] := Copy( S, P + 1, Length( S ) - P );

        if ItemIsGroup[ I ] then
        begin
          Canvas.Font := GroupFont;
          if K = 0 then                               // If first column in a group, then need to strip off group prefix
            System.Delete( ColStr, 1, Length( GroupPrefix ) );
          W := Canvas.TextWidth( ColStr );
        end
        else
        begin
          Canvas.Font := Font;
          W := Canvas.TextWidth( ColStr );
          if K = 0 then
            W := W + InitialTabStopOffset;                 // First column--must account for check box width
        end;

        if W > MaxW then
          MaxW := W;
      end;

      if FTabStops.Count > 0 then
        T := FTabStops[ FTabStops.Count - 1 ]
      else
        T := 0;
      FTabStops.Add( T + ( MaxW div FDialogUnits ) + 4 );
    end;
  finally
    StrList.Free;
  end;
end; {= TRzCustomTabbedListBox.AdjustTabStops =}


function TRzCustomTabbedListBox.StoreTabStops: Boolean;
begin
  Result := FTabStops.Count > 0;
end;

procedure TRzCustomTabbedListBox.SetTabStops( Value: TRzTabStopList );
begin
  FTabStops.Assign( Value );
  UpdateTabStops;
end;


procedure TRzCustomTabbedListBox.GetTabArray( var TabCount: Integer; var TabArray: TRzTabArray );
var
  I: Integer;
begin
  TabCount := FTabStops.Count;
  if TabCount > MaxTabs then
    TabCount := MaxTabs;

  for I := 0 to TabCount - 1 do     { Copy Contents of FTabStops to Temp Array }
    TabArray[ I ] := FTabStops.Items[ I ] * 4; { Convert Chars to Dialog Units }
end;


{-----------------------------------------------------------------------------------------------------------------------
  TRzCustomTabbedListBox.UpdateTabStops

  The lb_SetTabStops message is used to set the tab stops.  The LParam parameter for this message is a pointer to an
  array of Word values representing the tab stops.  Therefore, the contents of the FTabStops list is transferred to a
  temporary array.
-----------------------------------------------------------------------------------------------------------------------}

procedure TRzCustomTabbedListBox.UpdateTabStops;
var
  TabCount: Integer;
  TabArray: TRzTabArray;
begin
  GetTabArray( TabCount, TabArray );
                                   { Send message to list box to set tab stops }
  if TabCount = 0 then
    SendMessage( Handle, lb_SetTabStops, 0, 0 )      { Reset default tab width }
  else
    SendMessage( Handle, lb_SetTabStops, TabCount, Longint( @TabArray ) );
  Invalidate;
end;


function Min( A, B: Integer ): Integer;
begin
  if A < B then
    Result := A
  else
    Result := B;
end;


procedure TRzCustomTabbedListBox.UpdateFromHeader( Header: TControl );
var
  I, W, Limit: Integer;
  RightAligned: Boolean;
begin
  W := 0;
  if Header is THeader then
  begin
    Limit := Min( THeader( Header ).Sections.Count - 2, TabStops.Count - 1 );
    for I := 0 to Limit do
    begin
      W := W + THeader( Header ).SectionWidth[ I ];
      RightAligned := TabStops[ I ] < 0;
      if RightAligned then
        TabStops[ I ] := -( (W + THeader(Header).SectionWidth[ I + 1 ]) div FDialogUnits ) + 1
      else
        TabStops[ I ] := ( W div FDialogUnits ) + 1;
    end;
  end
  else if Header is THeaderControl then
  begin
    Limit := Min( THeaderControl( Header ).Sections.Count - 1, TabStops.Count - 1 );
    for I := 0 to Limit do
    begin
      W := W + THeaderControl( Header ).Sections[ I ].Width;
      RightAligned := TabStops[ I ] < 0;
      if RightAligned then
      begin
        if I < THeaderControl( Header ).Sections.Count - 1 then
          TabStops[ I ] := -( ( W + THeaderControl( Header ).Sections[ I + 1 ].Width ) div FDialogUnits ) + 1
        else
          TabStops[ I ] := -( ( Width ) div FDialogUnits ) + 1
      end
      else
        TabStops[ I ] := ( W div FDialogUnits ) + 1;
    end;
  end
  else
  begin
    raise EHeaderError.Create( sRzHeaderError );
  end;

end; {= TRzCustomTabbedListBox.UpdateFromHeader =}


procedure TRzCustomTabbedListBox.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  FDialogUnits := GetAvgCharWidth( Font );

  {$IFDEF VCL60_OR_HIGHER}
  if ( FTabStopsMode = tsmAutomatic ) and ( TRzStringsAccess( Items ).UpdateCount = 0 ) then
    AdjustTabStops;
  {$ELSE}
  if ( FTabStopsMode = tsmAutomatic ) then
    AdjustTabStops;
  {$ENDIF}
end;


function TRzCustomTabbedListBox.GetCellText( ACol, ARow: Integer ): string;
var
  S: string;
  P, Count: Integer;
begin
  if ( ARow < 0 ) or ( ARow >= Items.Count ) then
    raise EListError.Create( sRzRowParamError );
  if ( ACol < 0 ) then
    raise EListError.Create( sRzColParamError );

  S := Items[ ARow ];
  P := Pos( #9, S );
  Count := 0;
  while ( P <> 0 ) and ( Count < ACol ) do
  begin
    System.Delete( S, 1, P );
    P := Pos( #9, S );
    Inc( Count );
  end;
  if Count < ACol then
    raise EListError.Create( sRzColParamError )
  else if P <> 0 then
    Result := Copy( S, 1, P - 1 )
  else
    Result := S;
end;


procedure TRzCustomTabbedListBox.SetCellText( ACol, ARow: Integer; const Value: string );
var
  S: string;
  TotalP, P, Count, Len: Integer;
begin
  if ( ARow < 0 ) or ( ARow >= Items.Count ) then
    raise EListError.Create( sRzRowParamError );
  if ( ACol < 0 ) then
    raise EListError.Create( sRzColParamError );

  S := Items[ ARow ];

  P := Pos( #9, S );
  TotalP := 0;
  Count := 0;
  while ( P <> 0 ) and ( Count < ACol ) do
  begin
    System.Delete( S, 1, P );
    Inc( TotalP, P );
    P := Pos( #9, S );
    Inc( Count );
  end;
  if Count < ACol then
    raise EListError.Create( sRzColParamError )
  else if P <> 0 then
    Len := P - 1
  else
    Len := Length( S );

  S := Items[ ARow ];
  System.Delete( S, TotalP + 1, Len );
  System.Insert( Value, S, TotalP + 1 );
  Items[ ARow ] := S;
end;


procedure TRzCustomTabbedListBox.AdjustHorzExtent;
var
  TabCount, I: Integer;
  TabArray: TRzTabArray;
  ItemStr: string;
  Extent, MaxExtent: integer;
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  TabCount := FTabStops.Count;
  if TabCount > MaxTabs then
    TabCount := MaxTabs;
  for I := 0 to TabCount - 1 do                            // Copy Contents of FTabStops to Temp Array
    TabArray[ I ] := FTabStops.Items[ I ] * FDialogUnits;

  MaxExtent := 0;
  DC := GetDC( 0 );
  try
    SaveFont := SelectObject( DC, Font.Handle );
    GetTextMetrics( DC, Metrics );

    for I := 0 to Items.Count - 1 do
    begin
      ItemStr := Items[ I ] + 'x';
      Extent := LoWord( GetTabbedTextExtent( DC, PChar( ItemStr ), Length( ItemStr ), TabCount, TabArray ) );
      if Extent > MaxExtent then
        MaxExtent := Extent;
    end;

    SelectObject( DC, SaveFont );
  finally
    ReleaseDC( 0, DC );
  end;
  HorzExtent := MaxExtent + OwnerDrawItemIndent;
end; {= TRzCustomTabbedListBox.AdjustHorzExtent =}


{==========================}
{== TRzPopupEdit Methods ==}
{==========================}

constructor TRzPopupEdit.Create( AOwner: TComponent );
begin
  inherited;
  ParentCtl3D := False;
  Ctl3D := False;
  TabStop := False;
  BorderStyle := bsSingle;
  Visible := False;
end;

procedure TRzPopupEdit.CreateParams( var Params: TCreateParams );
begin
  inherited;
  Params.WindowClass.Style := CS_SAVEBITS;
end;


procedure TRzPopupEdit.KeyPress( var Key: Char );
begin
  case Key of
    #9: Key := #0;

    #27:
    begin
      FList.HideEditor( False );
      Key := #0;
    end;

    #13:
    begin
      FList.HideEditor( True );
      Key := #0;
    end;
  end;

  if Key <> #0 then
    inherited;
end;


procedure TRzPopupEdit.CNKeyDown( var Msg: TWMKeyDown );
begin
  case Msg.CharCode of
    67:
    begin
      // Check to see if user presses Ctrl+C and stop it from triggering main menu Copy
      Msg.CharCode := 0;
    end;

    vk_Escape:
    begin
      FList.HideEditor( False );
      Msg.CharCode := 0;
    end;

    else
      inherited;
  end;
end;


procedure TRzPopupEdit.CMCancelMode( var Msg: TCMCancelMode );
begin
  { cm_CancelMode is sent when user clicks somewhere in same application }
  if Msg.Sender <> Self then
    FList.HideEditor( True );
end;

procedure TRzPopupEdit.WMKillFocus( var Msg: TMessage );
begin
  { wm_KillFocus is sent went user switches to another application or window }
  inherited;
  FList.HideEditor( True );
end;

procedure TRzPopupEdit.CMShowingChanged( var Msg: TMessage );
begin
  { Ignore showing using the Visible property }
end;



{============================}
{== TRzEditListBox Methods ==}
{============================}

constructor TRzEditListBox.Create( AOwner: TComponent );
begin
  inherited;
  FPopupVisible := False;

  FAllowEdit := True;
  FPopupEdit := TRzPopupEdit.Create( Self );
  FPopupEdit.Parent := Self;
  FPopupEdit.FList := Self;
  FJustGotFocus := False;
  FShowEditorOnNextClick := False;
  FTimer := TTimer.Create( Self );
  FTimer.Enabled := False;
  FTimer.Interval := 400;
  FTimer.OnTimer := TimerExpired;
  {&RCI}
end;


procedure TRzEditListBox.SizeEditRect( Index: Integer; var EditRect: TRect );
begin
  if Assigned( FOnSizeEditRect ) then
    FOnSizeEditRect( Self, Index, EditRect );
end;


function TRzEditListBox.DoShowingEditor( Index: Integer ): Boolean;
begin
  Result := True;
  if Assigned( FOnShowingEditor ) then
    FOnShowingEditor( Self, Index, Result );
end;


procedure TRzEditListBox.DoHidingEditor;
begin
  if Assigned( FOnHidingEditor ) then
    FOnHidingEditor( Self );
end;


procedure TRzEditListBox.ItemChanged( Index: Integer );
begin
  if Assigned( FOnItemChanged ) then
    FOnItemChanged( Self, Index );
end;


procedure TRzEditListBox.HideEditor( SaveChanges: Boolean );
var
  Idx: Integer;
begin
  if FPopupVisible then
  begin
    if SaveChanges then
    begin
      if Sorted then
      begin
        Items.Delete( FCurrIdx );
        Idx := Items.Add( FPopupEdit.Text );
        SendMessage( Handle, lb_SetCaretIndex, Idx, 0 );
        FCurrIdx := Idx;
      end
      else
      begin
        Items[ FCurrIdx ] := FPopupEdit.Text;
        SendMessage( Handle, lb_SetCaretIndex, FCurrIdx, 0 );
      end;
    end;

    DoHidingEditor;

    FPopupVisible := False;
    SetWindowPos( FPopupEdit.Handle, 0, 0, 0, 0, 0,
                  swp_NoActivate or swp_NoZOrder or swp_NoMove or swp_NoSize or
                  swp_HideWindow );
    SetFocus;
    if MultiSelect then
      Selected[ FCurrIdx ] := True
    else
      ItemIndex := FCurrIdx;

    ItemChanged( FCurrIdx );
  end;
end;


procedure TRzEditListBox.ShowEditor;
var
  EditRect: TRect;
begin
  // Make sure there are items in the list
  if Items.Count = 0 then
    Exit;

  // Make sure item to be edited is in view

  FCurrIdx := SendMessage( Handle, lb_GetCaretIndex, 0, 0 );
  SendMessage( Handle, lb_SetCaretIndex, FCurrIdx, 0 );
  if not MultiSelect then
    ItemIndex := -1;

  UnselectAll;
  FPopupEdit.Text := Items[ FCurrIdx ];

  // Generate OnShowingEditor event
  if DoShowingEditor( FCurrIdx ) then
  begin
    EditRect := ItemRect( FCurrIdx );
    Inc( EditRect.Left, 2 );
    Dec( EditRect.Right, 2 );
    SizeEditRect( FCurrIdx, EditRect );  { Generate OnSizeRect event }

    with EditRect do
      SetWindowPos( FPopupEdit.Handle, 0, Left, Top, Right - Left, Bottom - Top,
                    swp_NoActivate or swp_ShowWindow );
    Windows.SetFocus( FPopupEdit.Handle );
    FPopupVisible := True;
  end;
end;


procedure TRzEditListBox.WMSetFocus( var Msg: TMessage );
begin
  inherited;
  FJustGotFocus := True;
end;


procedure TRzEditListBox.WMLButtonDown( var Msg: TWMLButtonDown );
begin
  {&RV}
  if not FJustGotFocus then
  begin
    if FEditorIdx <> ItemIndex then
      FShowEditorOnNextClick := True
    else
      FShowEditorOnNextClick := not FShowEditorOnNextClick;
  end;
  FJustGotFocus := False;
  FEditorIdx := ItemIndex;
  inherited;
end;

procedure TRzEditListBox.WMLButtonDblClick( var Msg: TWMLButtonDblClk );
begin
  inherited;
  FShowEditorOnNextClick := False;
  FDoubleClicked := True;
end;


procedure TRzEditListBox.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  if not FDoubleClicked then
  begin
    if ItemAtPos( Point( X, Y ), True ) <> -1 then
      FTimer.Enabled := True;
  end
  else
    FDoubleClicked := False;
end;


procedure TRzEditListBox.TimerExpired( Sender: TObject );
begin
  FTimer.Enabled := False;

  if FAllowEdit and ( ItemIndex = FEditorIdx ) and FShowEditorOnNextClick and ( ItemIndex <> -1 ) then
    ShowEditor;
end;

procedure TRzEditListBox.KeyDown( var Key: Word; Shift: TShiftState );
begin
  case Key of
    vk_Escape:
    begin
      if FPopupVisible then
        HideEditor( False );
    end;

    vk_Delete:
    begin
      if FAllowDeleteByKbd then
        DeleteSelectedItems
      else
        inherited;
    end;

    vk_F2:
    begin
      if FAllowEdit then
      begin
        FShowEditorOnNextClick := True;
        ShowEditor;
      end
      else
        inherited;
    end;

    else
      inherited;
  end;
end;


{============================}
{== TRzRankListBox Methods ==}
{============================}

constructor TRzRankListBox.Create( AOwner: TComponent );
begin
  inherited;
  FColumns := 0;
  FDragCursor := crDrag;
  FDragMode := dmManual;
  inherited ExtendedSelect := False;        // Normally True for TListBox
  FExtendedSelect := False;
  FMultiSelect := False;
  FSorted := False;
  FModifierKey := mkShift;
  FMoveOnDrag := True;
  FOldIndex := -1;
  FMoving := False;
end;


procedure TRzRankListBox.SetMoveOnDrag( Value: Boolean );
begin
  if FMoving then
    raise Exception.Create( 'MoveOnDrag property cannot be changed while moving an item' )
  else
    if FMoveOnDrag <> Value then
      FMoveOnDrag := Value;
end;


procedure TRzRankListBox.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  if ( Button = mbLeft ) and
     ( ( FModifierKey = mkNone ) or ( ( FModifierKey = mkShift ) and ( ssShift in Shift ) ) ) then
  begin
    FOldIndex := ItemAtPos( Point( X, Y ), True );
    if FOldIndex <> -1 then
    begin
      FOldCursor := Windows.GetCursor;
      Windows.SetCursor( Screen.Cursors[ DragCursor ] );
      FMoving := True;
    end;
  end;
end;


procedure TRzRankListBox.MouseMove( Shift: TShiftState; X, Y: Integer );
var
  NewIndex: Integer;
  ScreenPos: TPoint;
  Box: TRect;
  HitTop: Boolean;
begin
  inherited;
  if FMoving then
  begin
    HitTop := False;
    Box := ClientRect;

    if not PtInRect( Box, Point( X, Y ) ) then
    begin
      // Don't allow drag outside box; adjust position if outside box.
      // Different adjustments necessary for right and bottom edges due
      // to a point on either edge not being considered _inside_ the box
      // when ItemAtPos() used.

      if X < Box.Left then
        X := Box.Left
      else if X >= Box.Right then
        X := Box.Right - 1;
      if Y < Box.Top then
      begin
        Y := Box.Top;
        HitTop := True;
      end
      else if Y >= Box.Bottom then
        Y := Box.Bottom - 1;
      ScreenPos := ClientToScreen( Point( X, Y ) );
      SetCursorPos( ScreenPos.X, ScreenPos.Y );
    end;

    if FMoveOnDrag then
    begin
      NewIndex := ItemAtPos( Point( X, Y ), True );
      if NewIndex = -1 then
      begin
        // Dragged above first item or below last item
        if HitTop then
          NewIndex := 0
        else
          NewIndex := Items.Count - 1;
      end;

      if NewIndex <> FOldIndex then
      begin
        MoveItem( FOldIndex, NewIndex );
        FOldIndex := ItemIndex;
      end;
    end;
  end;
end;


procedure TRzRankListBox.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  NewIndex: Integer;
begin
  inherited;
  if FMoving then
  begin
    if not FMoveOnDrag then
    begin
      NewIndex := ItemAtPos( Point( X, Y ), True );
      if NewIndex = -1 then
      begin
        // Dragged above first item or below last item
        if Y < ClientRect.Top then
          NewIndex := 0
        else
        begin
          // IntegralHeight = False and dragged below last item into space }
          NewIndex := Items.Count - 1;
        end;
      end;

      if NewIndex <> FOldIndex then
        MoveItem( FOldIndex, NewIndex );
    end;

    Windows.SetCursor( FOldCursor );
    FMoving := False;
  end;
end;


procedure TRzRankListBox.KeyDown( var Key: Word; Shift: TShiftState );
var
  NewIndex: Integer;
begin
  if ( ssShift in Shift ) and not FMoving then
  begin
    FOldIndex := ItemIndex;
    case Key of
      VK_DOWN:
      begin
        if ItemIndex < Items.Count - 1 then
        begin
          NewIndex := ItemIndex + 1;
          MoveItem( FOldIndex, NewIndex );
          Key := 0;
        end;
      end;

      VK_UP:
      begin
        if ItemIndex > 0 then
        begin
          NewIndex := ItemIndex - 1;
          MoveItem( FOldIndex, NewIndex );
          Key := 0;
        end;
      end;

      VK_HOME:
      begin
        if ItemIndex > 0 then
        begin
          NewIndex := 0;
          MoveItem( FOldIndex, NewIndex );
          Key := 0;
        end;
      end;

      VK_END:
      begin
        if ItemIndex < Items.Count - 1 then
        begin
          NewIndex := Items.Count - 1;
          MoveItem( FOldIndex, NewIndex );
          Key := 0;
        end;
      end;
    end;
  end;
  inherited;
end;


procedure TRzRankListBox.MoveItem( OldIndex, NewIndex: Integer );
begin
  // Move the string item (and its associated object) from position OldIndex
  // to position NewIndex.

  Items.Move( OldIndex, NewIndex );
  ItemIndex := NewIndex;
  if Assigned( FOnMoveItem ) then
    FOnMoveItem( Self, OldIndex, NewIndex );
end;


{=============================}
{== TRzFontListBox Methods ==}
{=============================}

constructor TRzFontListBox.Create( AOwner: TComponent );
begin
  inherited;
  Style := lbOwnerDrawFixed;                  // Style is not published

  FSaveFontName := '';

  Sorted := True;
  FShowStyle := ssFontName;
  FShowSymbolFonts := True;

  FFont := TFont.Create;
  FFontSize := 8;
  FFont.Size := FFontSize;
  FFontStyle := [];
  FFontType := ftAll;

  FTrueTypeBmp := TBitmap.Create;
  FFixedPitchBmp := TBitmap.Create;
  FTrueTypeFixedBmp := TBitmap.Create;
  FPrinterBmp := TBitmap.Create;
  FDeviceBmp := TBitmap.Create;
  LoadBitmaps;

  FMaintainMRUFonts := False;
  FMRUCount := -1;
  FPreviewVisible := False;

  FPreviewPanel := TRzPreviewFontPanel.Create( Self );
  FPreviewPanel.Parent := TWinControl( AOwner );
  FPreviewPanel.Control := Self;

  {&RCI}
end;


destructor TRzFontListBox.Destroy;
begin
  FFont.Free;
  FTrueTypeBmp.Free;
  FFixedPitchBmp.Free;
  FTrueTypeFixedBmp.Free;
  FPrinterBmp.Free;
  FDeviceBmp.Free;
  inherited;
end;


procedure TRzFontListBox.CreateWnd;
begin
  {&RV}
  inherited;
  Clear;
  LoadFonts;
  if FSaveFontName <> '' then
    SetFontName( FSaveFontName );
end;

procedure TRzFontListBox.DestroyWnd;
begin
  FSaveFontName := GetFontName;
  inherited;
end;


function EnumFontsProc( var LogFont: TLogFont; var TextMetric: TTextMetric;
                        FontType: Integer; Data: Pointer ): Integer; stdcall;
begin
  with TRzFontListBox( Data ), TextMetric do
  begin
    case FontType of
      ftAll:
      begin
        if ShowSymbolFonts or ( LogFont.lfCharSet <> SYMBOL_CHARSET ) then
          Items.AddObject( LogFont.lfFaceName, TObject( tmPitchAndFamily ) );
      end;

      ftTrueType:
      begin
        if ( tmPitchAndFamily and tmpf_TrueType) = tmpf_TrueType then
          if ShowSymbolFonts or ( LogFont.lfCharSet <> SYMBOL_CHARSET ) then
            Items.AddObject( LogFont.lfFaceName, TObject( tmPitchAndFamily ) );
      end;

      ftFixedPitch:
      begin
        if ( tmPitchAndFamily and tmpf_Fixed_Pitch ) = 0 then
          if ShowSymbolFonts or ( LogFont.lfCharSet <> SYMBOL_CHARSET ) then
            Items.AddObject( LogFont.lfFaceName, TObject( tmPitchAndFamily ) );
      end;
    end; { case }
    Result := 1;
  end;
end;


procedure TRzFontListBox.LoadFonts;
var
  DC: HDC;
begin
  if FFontDevice = fdScreen then
  begin
    DC := GetDC( 0 );
    EnumFontFamilies( DC, nil, @EnumFontsProc, Longint( Self ) );
    ReleaseDC( 0, DC );
  end
  else
  begin
    EnumFontFamilies( Printer.Handle, nil, @EnumFontsProc, Longint( Self ) );
  end;
end;


procedure TRzFontListBox.LoadBitmaps;
begin
  FTrueTypeBmp.Handle := LoadBitmap( HInstance, 'RZCMBOBX_TRUETYPE' );
  FFixedPitchBmp.Handle := LoadBitmap( HInstance, 'RZCMBOBX_FIXEDPITCH' );
  FTrueTypeFixedBmp.Handle := LoadBitmap( HInstance, 'RZCMBOBX_TRUETYPEFIXED' );
  FPrinterBmp.Handle := LoadBitmap( HInstance, 'RZCMBOBX_PRINTER' );
  FDeviceBmp.Handle := LoadBitmap( HInstance, 'RZCMBOBX_DEVICE' );
end;


procedure TRzFontListBox.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if ( AComponent = FPreviewEdit ) and ( Operation = opRemove ) then
    FPreviewEdit := nil;
end;


procedure TRzFontListBox.HidePreviewPanel;
begin
  if FPreviewVisible then
  begin
    FPreviewVisible := False;
    SetWindowPos( FPreviewPanel.Handle, 0, 0, 0, 0, 0,
                  swp_NoActivate or swp_NoZOrder or swp_NoMove or swp_NoSize or
                  swp_HideWindow );
  end;
end;


procedure TRzFontListBox.ShowPreviewPanel;
var
  P: TPoint;
begin
  // Make sure there are items in the list
  if Items.Count = 0 then
    Exit;

  P := ClientToScreen( Point( 0, 0 ) );
  P.X := P.X + Width;

  // Because FPreviewPanel has style WS_POPUP, Left and Top values to SetWindowPos are screen coordinates

  SetWindowPos( FPreviewPanel.Handle, 0, P.X - 1, P.Y,
                FPreviewPanel.Width, FPreviewPanel.Height,
                swp_NoActivate or swp_ShowWindow );
  FPreviewVisible := True;
end;


procedure TRzFontListBox.CMCancelMode( var Msg: TCMCancelMode );
begin
  // cm_CancelMode is sent when user clicks somewhere in same application
  if ( FShowStyle = ssFontPreview ) and ( Msg.Sender <> Self ) then
    HidePreviewPanel;
end;


procedure TRzFontListBox.CMHidePreviewPanel( var Msg: TMessage );
begin
  inherited;
  HidePreviewPanel;
end;



procedure TRzFontListBox.UpdatePreviewText;
var
  Preview: string;
begin
  if FPreviewText = '' then
    Preview := ptDefault
  else
    Preview := FPreviewText;

  FPreviewPanel.Alignment := taCenter;

  if Assigned( FPreviewEdit ) then
  begin
    FPreviewPanel.Alignment := taLeftJustify;
    if FPreviewEdit.SelLength > 0 then
      Preview := FPreviewEdit.SelText
    else
      Preview := Copy( FPreviewEdit.Text, 1, 10 );
  end
  else
  begin
    if FPreviewPanel.Canvas.TextWidth( FPreviewText ) >= PreviewWidth then
      Preview := ptDefault1;
    if FPreviewPanel.Canvas.TextWidth( FPreviewText ) >= PreviewWidth then
      Preview := ptDefault2;
  end;
  FPreviewPanel.Caption := Preview;
end;


procedure TRzFontListBox.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  UpdatePreviewText;
  inherited;
  if FShowStyle = ssFontPreview then
    ShowPreviewPanel;
end;


procedure TRzFontListBox.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  if FShowStyle = ssFontPreview then
    HidePreviewPanel;
end;


procedure TRzFontListBox.AddFontToMRUList;
var
  Idx, I: Integer;
  FoundMRUFont: Boolean;
begin
  if FMaintainMRUFonts and ( ItemIndex <> 0 ) then
  begin
    Idx := ItemIndex;
    if Idx = -1 then
      Exit;
    // Add selected item to top of list if not already at the top
    FoundMRUFont := False;
    I := 0;
    while ( I <= FMRUCount ) and not FoundMRUFont do
    begin
      if Items[ I ] = Items[ Idx ] then
        FoundMRUFont := True
      else
        Inc( I );
    end;
    if FoundMRUFont then
    begin
      Items.Move( I, 0 );                   // Move MRU font to top of list
    end
    else
    begin
      // Make a copy of the selected font to appear in MRU portion at top of list
      Items.InsertObject( 0, Items[ Idx ], Items.Objects[ Idx ] );
      if Idx > FMRUCount then
        Inc( FMRUCount );
    end;
    ItemIndex := 0;
  end;
end;


procedure TRzFontListBox.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  RecreateWnd;
end;


procedure TRzFontListBox.CNDrawItem( var Msg: TWMDrawItem );
begin
  // Indent owner-draw rectangle so focus rect doesn't cover glyph
  with Msg.DrawItemStruct^ do
    rcItem.Left := rcItem.Left + 24;
  inherited;
end;


procedure TRzFontListBox.DrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState );
var
  Bmp: TBitmap;
  DestRct, SrcRct, R: TRect;
  BmpOffset, TextOffset: Integer;
  FT: Byte;
  TransparentColor: TColor;
  InEditField: Boolean;
  TempStyle: TRzShowStyle;
begin
  InEditField := odComboBoxEdit in State;

  with Canvas do
  begin
    Bmp := TBitmap.Create;
    try
      FillRect( Rect );   { Clear area for icon and text }

      DestRct := Classes.Rect( 0, 0, 12, 12 );
      SrcRct := DestRct;
      BmpOffset := ( ( Rect.Bottom - Rect.Top ) - 12 ) div 2;

      { Don't Forget to Set the Width and Height of Destination Bitmap }
      Bmp.Width := 12;
      Bmp.Height := 12;

      Bmp.Canvas.Brush.Color := Color;

      TransparentColor := clOlive;

      FT := Longint( Items.Objects[ Index ] ) and $0000000F;
      if ( ( FT and tmpf_TrueType ) = tmpf_TrueType ) and
         ( ( FT and tmpf_Fixed_Pitch ) <> tmpf_Fixed_Pitch ) then
      begin
        Bmp.Canvas.BrushCopy( DestRct, FTrueTypeFixedBmp, SrcRct, TransparentColor );
        Draw( Rect.Left - 20, Rect.Top + BmpOffset, Bmp );
      end
      else if ( FT and tmpf_TrueType ) = tmpf_TrueType then
      begin
        Bmp.Canvas.BrushCopy( DestRct, FTrueTypeBmp, SrcRct, TransparentColor );
        Draw( Rect.Left - 20, Rect.Top + BmpOffset, Bmp );
      end
      else if ( FT and tmpf_Fixed_Pitch ) <> tmpf_Fixed_Pitch then
      begin
        Bmp.Canvas.BrushCopy( DestRct, FFixedPitchBmp, SrcRct, TransparentColor );
        Draw( Rect.Left - 20, Rect.Top + BmpOffset, Bmp );
      end
      else if FFontDevice = fdPrinter then
      begin
        Bmp.Canvas.BrushCopy( DestRct, FPrinterBmp, SrcRct, TransparentColor );
        Draw( Rect.Left - 20, Rect.Top + BmpOffset, Bmp );
      end
      else
      begin
        Bmp.Canvas.BrushCopy( DestRct, FDeviceBmp, SrcRct, TransparentColor );
        Draw( Rect.Left - 20, Rect.Top + BmpOffset, Bmp );
      end;

      if not Enabled then
        Font.Color := clBtnShadow;

      TempStyle := FShowStyle;
      if InEditField and ( TempStyle = ssFontNameAndSample ) then
        TempStyle := ssFontName;

      TextOffset := ( ( Rect.Bottom - Rect.Top ) - TextHeight( 'Yy' ) ) div 2;
      case TempStyle of
        ssFontName, ssFontPreview:
        begin
          TextOut( Rect.Left + 2, Rect.Top + TextOffset, Items[ Index ] );
        end;

        ssFontSample:
        begin
          Font.Name := Items[ Index ];
          TextOut( Rect.Left + 2, Rect.Top + TextOffset, Items[ Index ] );
        end;

        ssFontNameAndSample:
        begin
          R := Rect;
          R.Right := R.Left + ( R.Right - R.Left ) div 2 - 4;
          Font.Name := Self.Font.Name;
          TextRect( R, R.Left + 2, R.Top + TextOffset, Items[ Index ] );

          if Enabled then
            Pen.Color := clWindowText
          else
            Pen.Color := clBtnShadow;

          MoveTo( R.Right + 2, R.Top );
          LineTo( R.Right + 2, R.Bottom );

          Font.Name := Items[ Index ];
          R.Left := R.Right + 4;
          R.Right := Rect.Right;
          TextRect( R, R.Left + 2, R.Top + TextOffset, Items[ Index ] );
        end;
      end;
    finally
      Bmp.Free;
    end;
  end;

  if ( FShowStyle = ssFontPreview ) and ( odFocused in State ) then
  begin
    FPreviewPanel.Font.Name := Items[ Index ];
    FPreviewPanel.Canvas.Font := FPreviewPanel.Font;
    UpdatePreviewText;
  end;

  if FMaintainMRUFonts and not InEditField and ( Index = FMRUCount ) then
  begin
    Canvas.MoveTo( 0, Rect.Bottom - 1 );
    Canvas.LineTo( Rect.Right, Rect.Bottom - 1 );
  end;

end; {= TRzFontListBox.DrawItem =}


procedure TRzFontListBox.SetFontDevice( Value: TRzFontDevice );
begin
  if FFontDevice <> Value then
  begin
    FFontDevice := Value;
    RecreateWnd;
  end;
end;


procedure TRzFontListBox.SetFontType( Value: TRzFontType );
begin
  if FFontType <> Value then
  begin
    FFontType := Value;
    RecreateWnd;
  end;
end;


function TRzFontListBox.GetSelectedFont: TFont;
begin
  if ItemIndex = -1 then
    Result := nil
  else
  begin
    FFont.Name := Items[ ItemIndex ];
    FFont.Size := FFontSize;
    FFont.Style := FFontStyle;
    Result := FFont;
  end;
end;


procedure TRzFontListBox.SetSelectedFont( Value: TFont );
begin
  ItemIndex := Items.IndexOf( Value.Name );
end;


function TRzFontListBox.GetFontName: string;
begin
  if ItemIndex >= 0 then
    Result := Items[ ItemIndex ]
  else
    Result := '';
end;


procedure TRzFontListBox.SetFontName( const Value: string );
begin
  ItemIndex := Items.IndexOf( Value );
end;


procedure TRzFontListBox.SetShowSymbolFonts( Value: Boolean );
begin
  if FShowSymbolFonts <> Value then
  begin
    FShowSymbolFonts := Value;
    RecreateWnd;
  end;
end;


procedure TRzFontListBox.SetShowStyle( Value: TRzShowStyle );
begin
  if FShowStyle <> Value then
  begin
    FShowStyle := Value;
    Invalidate;
  end;
end;


procedure TRzFontListBox.SetPreviewEdit( Value: TCustomEdit );
begin
  FPreviewEdit := Value;
  if FPreviewEdit <> nil then
    FPreviewEdit.FreeNotification( Self );
end;


function TRzFontListBox.GetPreviewFontSize: Integer;
begin
  Result := FPreviewPanel.Font.Size;
end;

procedure TRzFontListBox.SetPreviewFontSize( Value: Integer );
begin
  FPreviewPanel.Font.Size := Value;
end;


function TRzFontListBox.GetPreviewHeight: Integer;
begin
  Result := FPreviewPanel.Height;
end;

procedure TRzFontListBox.SetPreviewHeight( Value: Integer );
begin
  FPreviewPanel.Height := Value;
end;


function TRzFontListBox.GetPreviewWidth: Integer;
begin
  Result := FPreviewPanel.Width;
end;

procedure TRzFontListBox.SetPreviewWidth( Value: Integer );
begin
  FPreviewPanel.Width := Value;
end;



{&RUIF}
end.
