{===============================================================================
  RzListVw Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzListView           Enhanced list view components that supports Custom
                          Framing, custom drawing, sorting, etc.


  Modification History
  ------------------------------------------------------------------------------
  3.0.10 (26 Dec 2003)
    * Fixed problem where headers of list view would not display hot tracking
      when running under Windows XP Themes *and* the control was reparented.
    * Fixed problem where changing ParentColor to True in a control using Custom
      Framing did not reset internal color fields used to manage the color of
      the control at various states.
    * Fixed problem where context menu associated with the PopupMenu property
      would not be invoked when user right-clicked on empty area of list view.
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Fixed problem where context menu would get redisplayed after selecting an
      nested menu item under certain circumstances (i.e. the list view structure
      was modified in some way within the event handler).
    * Fixed problem where placing an item into edit mode caused a stack
      overflow.
    * Fixed problem where display of header captions appear bolded when moving
      the mouse over the list view and ClearType was enabled on the system.
    * Reworked several aspects of the custom drawing of headers and the handling
      of sort indicators.
    * Fixed problem introduced in 3.0.8 where popup menus on items were not
      consistently being displayed when the user right-clicked on a list view
      item.
    * Fixed problem where last column was not getting sized correctly when a
      form containing the list view was loaded and FillLastCol was set to True.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Fixed problem where background of items in list view were not being
      displayed correctly when the component was disabled. That is, the
      background was not being drawn using DisabledColor.
    * Fixed problem where header captions would not get updated correctly after
      a drag operation.
    * Fixed problem where header would not display images assigned to the
      Columns[i] items.
    * Fixed problem where header was not drawn correctly under certain
      conditions when using Windows XP Themes.
    * When running under Windows XP, header no longer use HDF_SORTUP and
      HDF_SORTDOWN styles for displaying the sort indicator. Instead, the
      indicator is drawn using the implemented owner-draw code.  The reason for
      this change is that the standard list view control does not support
      displaying a sort indicator *and* an image.
    * Fixed problem where context menu was being displayed in the wrong
      position.
    * Modified the SortByColumn method such that it specifies a default
      parameter to control the direction of the sorting operation.
  ------------------------------------------------------------------------------
  3.0.6  (11 Apr 2003)
    * Fixed problem where resizing columns would cause items covered by scroll
      bar not to be updated when the scroll bar is removed.
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * When FillLastColumn = True, the last column is only resized when
      ViewStyle = vsReport.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Added IsColorStored and IsFocusColorStored methods so that if control is
      disabled at design-time the Color and FocusColor properties are not
      streamed with the disabled color value.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Renamed FrameFlat property to FrameHotTrack.
    * Renamed FrameFocusStyle property to FrameHotStyle.
    * Removed FrameFlatStyle property.
    * Add FocusColor and DisabledColor properties.
    * Added EditSelectedCaption and EditItemCaption methods.  These two methods
      allow a developer to programmatically place a list item into edit mode
      when the EditOnRowClick property is set to False.
    * SortColumn method was renamed to SortByColumn.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzListVw;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Windows,
  Messages,
  Forms,
  Classes,
  Controls,
  StdCtrls,
  ComCtrls,
  CommCtrl,
  Graphics,
  Menus,
  SysUtils,
  RzCommon;


type
  {=========================================}
  {== TRzCustomListView Class Declaration ==}
  {=========================================}

  TRzLVCheckStateChanging = procedure ( Sender: TObject; Item: TListItem; ToBeChecked: Boolean;
                                        var AllowChange: Boolean ) of object;

  TRzLVOnItemContextMenuEvent = procedure( Sender: TObject; Item: TListItem; var Pos: TPoint;
                                           var Menu: TPopupMenu ) of object;

  TRzLVSortDirection = ( sdAscending, sdDescending );
  TRzLVHeaderSortDisplayMode = ( hsdmNone, hsdmLeftAlign, hsdmRightOfText, hsdmRightAlign );

  TRzCustomListView = class( TCustomListView )
  private
    FAlphaSortAll: Boolean;
    FLastIndex: Integer;
    FFillLastColumn: Boolean;
    FEditOnRowClick: Boolean;
    FEditingCaption: Boolean;
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

    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnCheckStateChanging: TRzLVCheckStateChanging;
    FOnCheckStateChange: TLVNotifyEvent;

    FOnItemContextMenu: TRzLVOnItemContextMenuEvent;
    FMenuAlreadyHandled: Boolean;
    FDragStarted: Boolean;

    FHeaderCanvas: TCanvas;
    FHeaderSortColumn: Integer;
    FHeaderSortDirection: TRzLVSortDirection;
    FHeaderSortDisplayMode: TRzLVHeaderSortDisplayMode;
    FHeaderDefaultDrawing: Boolean;

    FSetHeaderODStyleSem: Integer;

    FInternalHeaderHandle: HWND;
    FHeaderInstance: Pointer;
    FDefHeaderProc: Pointer;
    FRightClicked: Boolean;

    procedure ReadOldFrameFlatProp( Reader: TReader );
    procedure ReadOldFrameFocusStyleProp( Reader: TReader );

    { Message Handling Methods }
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure WMNCPaint( var Msg: TWMNCPaint ); message wm_NCPaint;
    procedure CMParentColorChanged( var Msg: TMessage ); message cm_ParentColorChanged;
    procedure CMEnter( var Msg: TCMEnter ); message cm_Enter;
    procedure CMExit( var Msg: TCMExit ); message cm_Exit;
    procedure CMMouseEnter( var Msg: TMessage ); message cm_MouseEnter;
    procedure CMMouseLeave( var Msg: TMessage ); message cm_MouseLeave;
    procedure CNNotify( var Msg: TWMNotify ); message cn_Notify;
    procedure WMSize( var Msg: TWMSize ); message wm_Size;
    procedure WMNotify( var Msg: TWMNotify ); message wm_Notify;

    procedure HeaderWndProc( var Msg: TMessage );

    function GetHeaderHandle: HWND;

    procedure CMColorChanged( var Msg: TMessage ); message cm_ColorChanged;
    procedure CMSysColorChange( var Msg: TMessage ); message cm_SysColorChange;

    procedure AMInitStage2( var Msg: TMessage ); message wm_User + 100;

    {$IFNDEF VCL60_OR_HIGHER}
    procedure LVMSetColumn( var Msg: TMessage ); message lvm_SetColumn;
    {$ENDIF}

    procedure WMContextMenu( var Msg: TMessage ); message wm_ContextMenu;
    procedure WMDrawItem( var Msg: TWMDrawItem ); message wm_DrawItem;
    procedure WMParentNotify( var Msg: TWMParentNotify ); message wm_ParentNotify;
    procedure WMRButtonUp( var Msg: TWMRButtonUp ); message wm_RButtonUp;
  protected
    FAboutInfo: TRzAboutInfo;
    FLoading: Boolean;
    FCanvas: TControlCanvas;
    FOverControl: Boolean;
    FOverHeaderSection: Integer;
    FHeaderSectionDown: Boolean;
    FSettingFrameController: Boolean;

    procedure DefineProperties( Filer: TFiler ); override;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    {$IFDEF VCL60_OR_HIGHER}
    function IsCustomDrawn( Target: TCustomDrawTarget; Stage: TCustomDrawStage ): Boolean; override;
    {$ENDIF}
    function CustomDrawItem( Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage ): Boolean; override;

    procedure UpdateColors; virtual;
    procedure UpdateFrame( ViaMouse, InFocus: Boolean ); virtual;
    procedure RepaintFrame; virtual;

    procedure ResizeLastColumn; virtual;

    procedure CreateWnd; override;

    procedure DrawHeader( AIndex: Integer; const ARect: TRect );
    procedure DrawHeaderSortGlyphs( Index: Integer; const Rect: TRect );
    procedure DefaultDrawHeader( Index: Integer; const Rect: TRect );
    procedure SetHeaderODStyle;

    procedure SetParent( Value: TWinControl ); override;
    procedure ResetHeaderHandle; 

    { Event Dispatch Methods }
    procedure ColClick( Column: TListColumn ); override;
    procedure MouseMove( Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;

    procedure CheckStateChange( Item: TListItem ); dynamic;
    function CanCheckStateChange( Item: TListItem; ToBeChecked: Boolean ): Boolean; dynamic;

    function DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean; override;
    function DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean; override;

    procedure DoPreItemContextMenu( pt: TPoint ); dynamic;
    procedure DoItemContextMenu( p: TPoint ); dynamic;
    procedure ItemContextMenu( Item: TListItem; var Pos: TPoint; var Menu: TPopupMenu ); dynamic;
    procedure KeyDown( var Key: Word; ShiftState: TShiftState ); override;

    { Property Access Methods }
    function GetColor: TColor; virtual;
    procedure SetColor( Value: TColor ); virtual;
    procedure SetFillLastColumn( Value: Boolean ); virtual;
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

    {$IFNDEF VCL60_OR_HIGHER}
    function GetViewStyle: TViewStyle;
    {$ENDIF}
    procedure SetViewStyle( AValue: TViewStyle ); {$IFDEF VCL60_OR_HIGHER} override; {$ENDIF}
    procedure SetHeaderSortColumn( Value: Integer );
    procedure SetHeaderSortDirection( Value: TRzLVSortDirection );
    procedure SetHeaderSortDisplayMode( Value: TRzLVHeaderSortDisplayMode );

    { Property Declarations }
    property AlphaSortAll: Boolean
      read FAlphaSortAll
      write FAlphaSortAll
      default False;

    property Color: TColor
      read GetColor
      write SetColor
      stored IsColorStored
      default clWindow;

    property Enabled: Boolean
      read GetEnabled
      write SetEnabled
      default True;

    property EditOnRowClick: Boolean
      read FEditOnRowClick
      write FEditOnRowClick
      default False;

    property FillLastColumn: Boolean
      read FFillLastColumn
      write SetFillLastColumn
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

    property HeaderCanvas: TCanvas
      read FHeaderCanvas;

    property HeaderHandle: HWND
      read GetHeaderHandle;

    property HeaderDefaultDrawing: Boolean
      read FHeaderDefaultDrawing
      write FHeaderDefaultDrawing
      default True;

    property HeaderSortDisplayMode: TRzLVHeaderSortDisplayMode
      read FHeaderSortDisplayMode
      write SetHeaderSortDisplayMode
      default hsdmRightOfText;

    property HeaderSortColumn: Integer
      read FHeaderSortColumn
      write SetHeaderSortColumn
      default -1;

    property HeaderSortDirection: TRzLVSortDirection
      read FHeaderSortDirection
      write SetHeaderSortDirection
      default sdAscending;

    {$IFNDEF VCL60_OR_HIGHER}
    property ViewStyle: TViewStyle
      read GetViewStyle
      write SetViewStyle
      default vsIcon;
    {$ENDIF}

    property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter
      write FOnMouseEnter;

    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave
      write FOnMouseLeave;

    property OnCheckStateChanging: TRzLVCheckStateChanging
      read FOnCheckStateChanging
      write FOnCheckStateChanging;

    property OnCheckStateChange: TLVNotifyEvent
      read FOnCheckStateChange
      write FOnCheckStateChange;

    property OnItemContextMenu: TRzLVOnItemContextMenuEvent
      read FOnItemContextMenu
      write FOnItemContextMenu;

    { Inherited Properties & Events }
    property OnMouseWheelUp;
    property OnMouseWheelDown;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function UseThemes: Boolean; virtual;

    function EditSelectedCaption: Boolean;
    function EditItemCaption( Item: TListItem ): Boolean;

    procedure SetBounds( ALeft, ATop, AWidth, AHeight: Integer); override;

    procedure SortByColumn( Index: Integer; Direction: TRzLVSortDirection = sdAscending );
    procedure SetTopIndex( Index: Integer );
  end;


  TRzListView = class( TRzCustomListView )
  public
    property HeaderCanvas;
    property HeaderHandle;
    property HeaderSortColumn;
    property HeaderSortDirection;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    { Inherited Properties & Events }
    {$IFDEF VCL60_OR_HIGHER}
    property Action;
    {$ENDIF}
    property Align;
    property AllocBy;
    property AlphaSortAll;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Checkboxes;
    property Color;
    property Columns;
    property ColumnClick;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property EditOnRowClick;
    property Enabled;
    property FillLastColumn;
    property FlatScrollBars;
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
    property FullDrag;
    property GridLines;
    property HeaderDefaultDrawing;
    property HeaderSortDisplayMode;
    property HideSelection;
    property HotTrack;
    property HotTrackStyles;
    property HoverTime;
    property IconOptions;
    property Items;
    property LargeImages;
    property MultiSelect;
    property OwnerData;
    property OwnerDraw;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly default False;
    property RowSelect;
    property ShowHint;
    property ShowColumnHeaders;
    property ShowWorkAreas;
    property SmallImages;
    property SortType;
    property StateImages;
    property TabOrder;
    property TabStop default True;
    property ViewStyle;
    property Visible;

    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnAdvancedCustomDrawSubItem;
    property OnChange;
    property OnChanging;
    property OnCheckStateChanging;
    property OnCheckStateChange;
    property OnClick;
    property OnColumnClick;
    property OnColumnDragged;
    property OnColumnRightClick;
    property OnContextPopup;
    property OnGetSubItemImage;
    property OnInfoTip;
    property OnCompare;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnCustomDrawSubItem;
    property OnData;
    property OnDataFind;
    property OnDataHint;
    property OnDataStateChange;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetImageIndex;
    property OnInsert;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
    property OnMouseWheel;
    property OnItemContextMenu;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnSelectItem;
  end;


function RzCustomSortDescendingProc( Item1, Item2, ColIndex: Integer ): Integer; stdcall;
function RzCustomSortProc( Item1, Item2, ColIndex: Integer ): Integer; stdcall;

procedure DrawDownArrow( Canvas: TCanvas; const Rect: TRect; BackgroundColor, ArrowColor: TColor );
procedure DrawUpArrow( Canvas: TCanvas; const Rect: TRect; BackgroundColor, ArrowColor: TColor );


implementation

uses
  {$IFDEF VCL70_OR_HIGHER}
  Themes,
  {$ELSE}
  RzThemeSrv,
  {$ENDIF}
  TypInfo,
  RzShellUtils;


const
  HDF_SORTUP = $0400;
  HDF_SORTDOWN = $0200;


{=====================}
{== Support Methods ==}
{=====================}

procedure DrawDownArrow( Canvas: TCanvas; const Rect: TRect; BackgroundColor, ArrowColor: TColor );
var
  X, Y, W, H: Integer;
begin
  H := 3 * ( Rect.Bottom - Rect.Top ) div 4;

  W := 2 * H - 1;

  X := Rect.Left;
  Y := Rect.Bottom - H;

  if BackgroundColor <> clNone then
  begin
    Canvas.Brush.Color := BackgroundColor;
    Canvas.FillRect( Bounds( X, Y, W, H ) );
  end;

  Canvas.Brush.Color := ArrowColor;
  Canvas.Pen.Color := ArrowColor;
  Canvas.Polygon( [ Point( X + W div 2, Y + H - 1 ),
                    Point( X, Y ),
                    Point( X + W - 1, Y ) ] );
  Canvas.Brush.Color := BackgroundColor;
end;



procedure DrawUpArrow( Canvas: TCanvas; const Rect: TRect; BackgroundColor, ArrowColor: TColor );
var
  X, Y, W, H: Integer;
begin
  H := 3 * ( Rect.Bottom - Rect.Top ) div 4;

  W := 2 * H - 1;

  X := Rect.Left;
  Y := Rect.Bottom - H;

  if BackgroundColor <> clNone then
  begin
    Canvas.Brush.Color := BackgroundColor;
    Canvas.FillRect( Bounds( X, Y, W, H ) );
  end;

  Canvas.Brush.Color := ArrowColor;
  Canvas.Pen.Color := ArrowColor;
  Canvas.Polygon( [ Point( X + W div 2, Y ),
                    Point( X, Y + H - 1 ),
                    Point( X + W - 1, Y + H - 1 ) ] );
  Canvas.Brush.Color := BackgroundColor;
end;



{&RT}
{===============================}
{== TRzCustomListView Methods ==}
{===============================}

constructor TRzCustomListView.Create( AOwner: TComponent );
begin
  inherited;

  FCanvas := TControlCanvas.Create;
  FCanvas.Control := Self;

  FAlphaSortAll := False;
  FEditOnRowClick := False;
  FFillLastColumn := True;

  FLastIndex := -1;
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

  FHeaderCanvas := TCanvas.Create;
  FHeaderSortDisplayMode := hsdmRightOfText;
  FHeaderDefaultDrawing := True;
  FHeaderSortColumn := -1;
  FHeaderSortDirection := sdAscending;
  FOverHeaderSection := -1;

  if not ( csDesigning in ComponentState ) then
    FHeaderSortColumn := -1;

  FHeaderInstance := MakeObjectInstance( HeaderWndProc );

  {&RCI}
end;


destructor TRzCustomListView.Destroy;
begin
  if FFrameController <> nil then
    FFrameController.RemoveControl( Self );
  FCanvas.Free;
  FHeaderCanvas.Free;

  if HeaderHandle <> 0 then
    SetWindowLong( HeaderHandle, GWL_WNDPROC, LongInt( FDefHeaderProc ) );
  FreeObjectInstance( FHeaderInstance );

  inherited;
end;


procedure TRzCustomListView.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the FrameFlat and FrameFocusStyle properties were renamed to
  // FrameHotStyle and FrameHotStyle respectively in version 3.
  Filer.DefineProperty( 'FrameFlat', ReadOldFrameFlatProp, nil, False );
  Filer.DefineProperty( 'FrameFocusStyle', ReadOldFrameFocusStyleProp, nil, False );

  // Handle the fact that the FrameFlatStyle was published in version 2.x
  Filer.DefineProperty( 'FrameFlatStyle', TRzOldPropReader.ReadOldEnumProp, nil, False );
end;


procedure TRzCustomListView.ReadOldFrameFlatProp( Reader: TReader );
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


procedure TRzCustomListView.ReadOldFrameFocusStyleProp( Reader: TReader );
begin
  FFrameHotStyle := TFrameStyle( GetEnumValue( TypeInfo( TFrameStyle ), Reader.ReadIdent ) );
end;


procedure TRzCustomListView.Loaded;
begin
  inherited;
  UpdateColors;
  UpdateFrame( False, False );

  if FFillLastColumn then
  begin
    FLoading := True;
    ResizeLastColumn;
    FLoading := False;
  end;

  ResetHeaderHandle;
end;


procedure TRzCustomListView.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( AComponent = FFrameController ) then
    FFrameController := nil;
end;


procedure TRzCustomListView.CNNotify( var Msg: TWMNotify );
var
  Item: TListItem;
  R: TRect;
  P: TPoint;
begin
  with Msg.NMHdr^ do
  begin
    Msg.Result := 0;

    case code of
      LVn_ItemChanging:
      begin
        inherited;  // Allow default OnChanging event to fire

        with PNMListView( Msg.NMHdr )^ do
        begin
          if CheckBoxes and
             ( ( uNewState = $2000 ) or ( uNewState = $1000 ) ) then
          begin
            if not CanCheckStateChange( Items[ iItem ], uNewState = $2000 ) then
              Msg.Result := 1;
          end;
        end;
      end;

      LVn_ItemChanged:
      begin
        inherited;  // Allow default OnChange event to fire

        with PNMListView( Msg.NMHdr )^ do
        begin
          if CheckBoxes and
             ( ( uNewState = $2000 ) or ( uNewState = $1000 ) ) then
          begin
            CheckStateChange( Items[ iItem ] );
          end;
        end;
      end;

      LVn_BeginLabelEdit:
      begin
        if not FEditingCaption and RowSelect and ( ViewStyle = vsReport ) and not FEditOnRowClick then
        begin
          // This notification message is received when the list view is about
          // to put the main item into edit mode.  Only go into edit mode if
          // the mouse was clicked on the main item.
          Item := TListItem( PLVDispInfo( Pointer( Msg.NMHdr ) )^.item.LParam );
          R := Item.DisplayRect( drLabel );

          GetCursorPos( P );
          P := ScreenToClient( P );

          if not PtInRect( R, P ) or not CanEdit( Item ) then
            Msg.Result := 1;
        end
        else
          inherited;
      end;

      LVn_BeginDrag, LVn_BeginRDrag:
      begin
        FDragStarted := True;
        inherited;
      end;

      nm_RClick:
      begin
        Windows.GetCursorPos( P );
        P := ScreenToClient( P );
        if htOnItem in GetHitTestInfoAt( P.X, P.Y ) then
          FRightClicked := True;
        DoPreItemContextMenu( P );
        FRightClicked := False;
        inherited;
      end

      else
        inherited;
    end; { case }
  end;
end; {= TRzCustomListView.CNNotify =}


procedure TRzCustomListView.CheckStateChange( Item: TListItem );
begin
  if Assigned( FOnCheckStateChange ) then
    FOnCheckStateChange( Self, Item );
end;


function TRzCustomListView.CanCheckStateChange( Item: TListItem; ToBeChecked: Boolean ): Boolean;
begin
  Result := True;
  if Assigned( FOnCheckStateChanging ) then
    FOnCheckStateChanging( Self, Item, ToBeChecked, Result );
end;


procedure TRzCustomListView.ResizeLastColumn;
var
  ColWidths, W, BaseWidth, I: Integer;
begin
  if not FFillLastColumn or ( ViewStyle <> vsReport ) or ( csDestroying in ComponentState ) then
    Exit;

  if Columns.Count >= 1 then
  begin
    ColWidths := 0;
    Items.BeginUpdate;
    for I := 0 to Columns.Count - 2 do
      ColWidths := ColWidths + Columns[ I ].Width;

    if ( Items.Count = 0 ) or FLoading then
      BaseWidth := ClientWidth - GetSystemMetrics( sm_CxVScroll )
    else
      BaseWidth := ClientWidth;

    if ColWidths < BaseWidth then
    begin
      W := BaseWidth - ColWidths;
      if W < 5 then
        W := 5;
      Columns[ Columns.Count - 1 ].Width := W;
    end;
    Items.EndUpdate;
  end;
end;


procedure TRzCustomListView.SetBounds( ALeft, ATop, AWidth, AHeight: Integer);
var
  NeedToResize: Boolean;
begin
  // Need to check to see if we need to call ResizeLastColumn.
  // But check must be made before calling inherited *and* the
  // call to ResizeLastColumn must be made after the inherited call
  // so that ResizeLastColumn can use the updated size of the control.

  NeedToResize := ( ALeft <> Left ) or ( ATop <> Top ) or
                  ( AWidth <> Width ) or ( AHeight <> Height );

  inherited;

  if NeedToResize then
    ResizeLastColumn;
end;


procedure TRzCustomListView.WMSize( var Msg: TWMSize );
begin
  inherited;

  if FFrameVisible and not UseThemes then
    RepaintFrame;
end;


procedure TRzCustomListView.WMNotify( var Msg: TWMNotify );
begin
  if Msg.NMHdr.hwndFrom = HeaderHandle then
  begin
    if Msg.NMHdr.code = HDN_ITEMCLICKW then
      InvalidateRect( HeaderHandle, nil, True );

    inherited;

    case Msg.NMHdr.code of
      hdn_EndTrack, hdn_BeginTrack, hdn_ItemChanged:
      begin
        // After dragging a column, the ownerdraw state seems to be reset, so set it back.
        SetHeaderODStyle;
        if FFrameVisible then
          Invalidate;
      end;
    end;

    case Msg.NMHdr.code of
      hdn_EndTrack, hdn_DividerDblClick:
        ResizeLastColumn;
    end;
  end
  else
    inherited;
end; {= TRzCustomListView.WMNotify =}



procedure TRzCustomListView.SetFillLastColumn( Value: Boolean );
begin
  if FFillLastColumn <> Value then
  begin
    FFillLastColumn := Value;
    ResizeLastColumn;
  end;
end;


procedure TRzCustomListView.SetTopIndex( Index: Integer );
var
  L, T, H: Integer;
  R: TRect;
begin
  T := TopItem.Index;
  if T = Index then
    Exit;  // Nothing to do

  L := Index - T;
  R := Items[ T ].DisplayRect( drBounds );
  H := R.Bottom - R.Top;
  Scroll( 0, L * H );
end;

procedure TRzCustomListView.SortByColumn( Index: Integer; Direction: TRzLVSortDirection = sdAscending );
begin
  if Direction = sdAscending then
    FLastIndex := -1
  else
    FLastIndex := Index;
  ColClick( Columns[ Index ] );
end;


procedure TRzCustomListView.ColClick( Column: TListColumn );
begin
  if FAlphaSortAll then
  begin
    if FLastIndex = Column.Index then
    begin
      HeaderSortColumn := Column.Index;
      HeaderSortDirection := sdDescending;
      CustomSort( RzCustomSortDescendingProc, Column.Index );
      FLastIndex := -1;
    end
    else
    begin
      HeaderSortColumn := Column.Index;
      HeaderSortDirection := sdAscending;
      CustomSort( RzCustomSortProc, Column.Index );
      FLastIndex := Column.Index;
    end;
  end;
  inherited;
end;


function RzCustomSortDescendingProc( Item1, Item2, ColIndex: Integer ): Integer; stdcall;
begin
  Result := RzCustomSortProc( Item1, Item2, ColIndex );
  Result := Result * -1;
end;


function RzCustomSortProc( Item1, Item2, ColIndex: Integer ): Integer; stdcall;
var
  Item1Str: string;
  Item2Str: string;
  ListItem1, ListItem2: TListItem;
begin
  Result := 0;

  ListItem1 := TListItem( Item1 );
  ListItem2 := TListItem( Item2 );
  if ( ListItem1 = nil ) or ( ListItem2 = nil ) then
    Exit;

  Item1Str := '';
  Item2Str := '';

  if ColIndex < 0 then
    Exit;

  if ColIndex = 0 then
  begin
    Item1Str := ListItem1.Caption;
    Item2Str := ListItem2.Caption;
  end
  else
  begin
    if ColIndex <= ListItem1.SubItems.Count then
      Item1Str := ListItem1.SubItems[ ColIndex - 1 ];

    if ColIndex <= ListItem2.SubItems.Count then
      Item2Str := ListItem2.SubItems[ ColIndex - 1 ];
  end;

  Result := CompareText( Item1Str, Item2Str );

  // If one of the strings is empty, make the other string sort before it

  if ( Result > 0 ) and ( Item2Str = '' ) then
    Result := -1
  else if ( Result < 0 ) and ( Item1Str = '' ) then
    Result := 1;
end; {= RzCustomSortProc =}


function TRzCustomListView.EditSelectedCaption: Boolean;
begin
  Result := EditItemCaption( Selected );
end;


function TRzCustomListView.EditItemCaption( Item: TListItem ): Boolean;
begin
  Result := False;
  if Item <> nil then
  begin
    FEditingCaption := True;
    try
      Result := Item.EditCaption;
    finally
      FEditingCaption := True;
    end;
  end;
end;


function TRzCustomListView.DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean;
begin
  case ViewStyle of
    vsIcon:
      Scroll( 0, Mouse.WheelScrollLines * 32 );

    vsSmallIcon, vsList, vsReport:
      Scroll( 0, Mouse.WheelScrollLines * 16 );
  end;
  Result := True;
end;


function TRzCustomListView.DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean;
begin
  case ViewStyle of
    vsIcon:
      Scroll( 0, -Mouse.WheelScrollLines * 32 );

    vsSmallIcon, vsList, vsReport:
      Scroll( 0, -Mouse.WheelScrollLines * 16 );
  end;
  Result := True;
end;


function TRzCustomListView.GetColor: TColor;
begin
  Result := inherited Color;
end;


procedure TRzCustomListView.SetColor( Value: TColor );
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


function TRzCustomListView.IsColorStored: Boolean;
begin
  Result := NotUsingController and Enabled;
end;


function TRzCustomListView.IsFocusColorStored: Boolean;
begin
  Result := NotUsingController and ( ColorToRGB( FFocusColor ) <> ColorToRGB( Color ) );
end;


function TRzCustomListView.NotUsingController: Boolean;
begin
  Result := FFrameController = nil;
end;


procedure TRzCustomListView.SetDisabledColor( Value: TColor );
begin
  FDisabledColor := Value;
  if not Enabled then
    UpdateColors;
end;


procedure TRzCustomListView.SetFocusColor( Value: TColor );
begin
  FFocusColor := Value;
  if Focused then
    UpdateColors;
end;


procedure TRzCustomListView.SetFrameColor( Value: TColor );
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    RepaintFrame;
  end;
end;


procedure TRzCustomListView.SetFrameController( Value: TRzFrameController );
begin
  FSettingFrameController := True;
  try
    if FFrameController <> nil then
      FFrameController.RemoveControl( Self );
    FFrameController := Value;
    if Value <> nil then
    begin
      Value.AddControl( Self );
      Value.FreeNotification( Self );
    end;
  finally
    FSettingFrameController := False;
  end;
end;


procedure TRzCustomListView.SetFrameHotColor( Value: TColor );
begin
  if FFrameHotColor <> Value then
  begin
    FFrameHotColor := Value;
    RepaintFrame;
  end;
end;


procedure TRzCustomListView.SetFrameHotTrack( Value: Boolean );
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


procedure TRzCustomListView.SetFrameHotStyle( Value: TFrameStyle );
begin
  if FFrameHotStyle <> Value then
  begin
    FFrameHotStyle := Value;
    RepaintFrame;
  end;
end;


procedure TRzCustomListView.SetFrameSides( Value: TSides );
begin
  if FFrameSides <> Value then
  begin
    FFrameSides := Value;
    RepaintFrame;
  end;
end;


procedure TRzCustomListView.SetFrameStyle( Value: TFrameStyle );
begin
  if FFrameStyle <> Value then
  begin
    FFrameStyle := Value;
    RepaintFrame;
  end;
end;


procedure TRzCustomListView.SetFrameVisible( Value: Boolean );
begin
  if FFrameVisible <> Value then
  begin
    FFrameVisible := Value;
    // Do not call RecreateWnd if setting the FrameController property--if FrameController is on another form, calling
    // RecreateWnd causes and list index exception somewhere in the VCL
    if not FSettingFrameController then
      RecreateWnd;
  end;
end;


procedure TRzCustomListView.SetFramingPreference( Value: TFramingPreference );
begin
  if FFramingPreference <> Value then
  begin
    FFramingPreference := Value;
    if FFramingPreference = fpCustomFraming then
      RepaintFrame;
  end;
end;


procedure TRzCustomListView.RepaintFrame;
var
  R: TRect;
begin
  if not ( csLoading in ComponentState ) then
  begin
    R := Rect( 0, 0, Width, Height );
    RedrawWindow( Handle, @R, 0, rdw_Invalidate or rdw_UpdateNow or rdw_Frame );
  end;
end;


function TRzCustomListView.UseThemes: Boolean;
begin
  Result := ( FFramingPreference = fpXPThemes ) and ThemeServices.ThemesEnabled;
end;


procedure TRzCustomListView.CMEnabledChanged( var Msg: TMessage );
begin
  inherited;
  UpdateColors;
end;


procedure TRzCustomListView.WMNCPaint( var Msg: TWMNCPaint );
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
end; {= TRzCustomListView.WMNCPaint =}


procedure TRzCustomListView.CMParentColorChanged( var Msg: TMessage );
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


{$IFDEF VCL60_OR_HIGHER}

function TRzCustomListView.IsCustomDrawn( Target: TCustomDrawTarget; Stage: TCustomDrawStage ): Boolean;
begin
  if not ( csDesigning in ComponentState ) and not Enabled then
    Result := True
  else
    Result := inherited IsCustomDrawn( Target, Stage );
end;

{$ENDIF}


function TRzCustomListView.CustomDrawItem( Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage ): Boolean;
begin
  Result := inherited CustomDrawItem( Item, State, Stage );

  // The following fixes the problem where the background of items were not drawn using the DisabledColor value.
  if not ( csDesigning in ComponentState) and not Enabled then
  begin
    Canvas.Brush.Color := clNone;
    Canvas.Brush.Color := FDisabledColor;
  end;
end;


procedure TRzCustomListView.UpdateColors;
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


procedure TRzCustomListView.UpdateFrame( ViaMouse, InFocus: Boolean );
begin
  if ViaMouse then
    FOverControl := InFocus;

  if FFrameHotTrack then
    RepaintFrame;

  UpdateColors;
end;


procedure TRzCustomListView.CMEnter( var Msg: TCMEnter );
begin
  UpdateFrame( False, True );
  inherited;
end;


procedure TRzCustomListView.CMExit( var Msg: TCMExit );
begin
  inherited;
  UpdateFrame( False, False );
end;


procedure TRzCustomListView.MouseMove( Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  if ThemeServices.ThemesEnabled and ( ViewStyle = vsReport ) and (FOverHeaderSection <> -1 ) then
  begin
    FOverHeaderSection := -1;
    InvalidateRect( HeaderHandle, nil, False );
  end;
end;


procedure TRzCustomListView.MouseEnter;
begin
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
end;


procedure TRzCustomListView.CMMouseEnter( var Msg: TMessage );
begin
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  UpdateFrame( True, True );
  MouseEnter;
  {&RV}
end;


procedure TRzCustomListView.MouseLeave;
begin
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
end;


procedure TRzCustomListView.CMMouseLeave( var Msg: TMessage );
begin
  inherited;
  if ThemeServices.ThemesEnabled and ( ViewStyle = vsReport ) then
  begin
    FOverHeaderSection := -1;
    InvalidateRect( HeaderHandle, nil, False );
  end;
  UpdateFrame( True, False );
  MouseLeave;
end;


function TRzCustomListView.GetHeaderHandle: HWND;
begin
  if HandleAllocated then
    Result := GetDlgItem( Handle, 0 )
  else
    Result := 0;
end;


{$IFNDEF VCL60_OR_HIGHER}
function TRzCustomListView.GetViewStyle: TViewStyle;
begin
  Result := inherited ViewStyle;
end;
{$ENDIF}


procedure TRzCustomListView.SetViewStyle( AValue: TViewStyle );
begin
  if ( AValue <> ViewStyle ) then
  begin
    {$IFDEF VCL60_OR_HIGHER}
    inherited;
    {$ELSE}
    inherited ViewStyle := AValue;
    {$ENDIF}
    if AValue = vsReport then
      SetHeaderODStyle;
  end;
end;


procedure TRzCustomListView.SetHeaderSortColumn( Value: Integer );
var
  Header: HWND;
  TmpRect: TRect;
begin
  if FHeaderSortColumn <> Value then
  begin
    Header := HeaderHandle;
    if Header <> 0 then
    begin
      if FHeaderSortColumn >= 0 then
      begin
        if Bool( Header_GetItemRect( Header, FHeaderSortColumn, @TmpRect ) ) then
          InvalidateRect( Header, @TmpRect, True );
      end;

      if Value >= 0 then
      begin
        if Bool( Header_GetItemRect( Header, Value, @TmpRect ) ) then
          InvalidateRect( Header, @TmpRect, True );
      end;
    end;
    FHeaderSortColumn := Value;

    if ( RzShellUtils.COMCTL32_VER.version >= COMCTL32_VER600 ) and ( HeaderHandle <> 0 ) then
      SetHeaderODStyle;
  end;
end;


procedure TRzCustomListView.SetHeaderSortDirection( Value: TRzLVSortDirection );
var
  TmpRect: TRect;
begin
  if FHeaderSortDirection <> Value then
  begin
    if ( HeaderHandle <> 0 ) and ( FHeaderSortColumn >= 0 ) then
    begin
      if Bool( Header_GetItemRect( HeaderHandle, FHeaderSortColumn, @TmpRect ) ) then
        InvalidateRect( HeaderHandle, @TmpRect, True );
    end;
    FHeaderSortDirection := Value;

    if ( RzShellUtils.COMCTL32_VER.version >= COMCTL32_VER600 ) and
       ( HeaderHandle <> 0 ) and
       ( FHeaderSortColumn >= 0 ) then
    begin
      SetHeaderODStyle;
    end;
    Update;
  end;
end;


procedure TRzCustomListView.SetHeaderSortDisplayMode( Value: TRzLVHeaderSortDisplayMode );
begin
  if ( FHeaderSortDisplayMode <> Value ) then
  begin
    if ( COMCTL32_VER.version < COMCTL32_VER470 ) then
      FHeaderSortDisplayMode := hsdmNone
    else
      FHeaderSortDisplayMode := Value;
    SetHeaderODStyle;
    if HandleAllocated then
      InvalidateRect( HeaderHandle, nil, True );
  end;
end;


procedure TRzCustomListView.CMColorChanged( var Msg: TMessage );
begin
  inherited;
  Perform( LVM_SETBKCOLOR, 0, ColorToRGB( Color ) );
  Perform( LVM_SETTEXTBKCOLOR, 0, ColorToRGB( Color ) );
end;


procedure TRzCustomListView.CMSysColorChange( var Msg: TMessage );
begin
  inherited;
  if Color < 0 then   // If color<0 then using sys colors, so need to reflect change to sys colors
    Perform( CM_COLORCHANGED, Msg.wParam, Msg.lParam );
end;


procedure TRzCustomListView.AMInitStage2( var Msg: TMessage );
begin
  SetHeaderODStyle;
end;


{$IFNDEF VCL60_OR_HIGHER}

procedure TRzCustomListView.LVMSetColumn( var Msg: TMessage );
begin
  if COMCTL32_VER.AsInt64 >= COMCTL32_VER470 then
  begin
    with PLVColumn( Msg.LParam )^ do
    if iImage = -1 then
      Mask := Mask and not LVCF_IMAGE;
  end;
  inherited;
end;

{$ENDIF}


procedure TRzCustomListView.WMContextMenu( var Msg: TMessage );
begin
  if not ( csDesigning in ComponentState ) and not FMenuAlreadyHandled then
  begin
    if ( SelCount = 0 ) or not Assigned( ItemFocused ) then
      Exit;

    if ( Msg.lParam = -1 ) then
      DoPreItemContextMenu( Point( 0, 0 ) )
    else
      DoItemContextMenu( ScreenToClient( Point( Msg.lParamLo, Msg.lParamHi ) ) );
  end
end;


procedure TRzCustomListView.WMDrawItem( var Msg: TWMDrawItem );
begin
  if Msg.DrawItemStruct.hwndItem = HeaderHandle then
  begin
    Windows.SaveDC( Msg.DrawItemStruct.hDC );
    try
      HeaderCanvas.Handle := Msg.DrawItemStruct.hDC;
      DrawHeader( Msg.DrawItemStruct.itemID, Msg.DrawItemStruct.rcItem );
    finally
      HeaderCanvas.Handle := 0;
      RestoreDC( Msg.DrawItemStruct.hDC, -1 );
      Msg.Result := 1;
    end;
  end
  else
    inherited;
end;


procedure TRzCustomListView.SetParent( Value: TWinControl );
begin
  if Parent <> Value then
  begin
    if HeaderHandle <> 0 then
      SetWindowLong( HeaderHandle, GWL_WNDPROC, LongInt( FDefHeaderProc ) );
    FInternalHeaderHandle := 0;
  end;

  inherited;
end;


procedure TRzCustomListView.WMParentNotify( var Msg: TWMParentNotify );
begin
  inherited;

  if ( Msg.Event = wm_Create ) and ( FInternalHeaderHandle = 0 ) then
  begin
    FInternalHeaderHandle := HeaderHandle;
    FDefHeaderProc := Pointer( GetWindowLong( HeaderHandle, GWL_WNDPROC ) );
    SetWindowLong( HeaderHandle, GWL_WNDPROC, LongInt( FHeaderInstance ) );
  end;

  SetHeaderODStyle;
end;


procedure TRzCustomListView.ResetHeaderHandle;
begin
  // Reset the internal HeaderHandle, which may have changed since the original
  // allocation if the list view is on a control that is part of a TFrame.

  if HeaderHandle <> 0 then
    SetWindowLong( HeaderHandle, GWL_WNDPROC, LongInt( FDefHeaderProc ) );
  FInternalHeaderHandle := HeaderHandle;
  FDefHeaderProc := Pointer( GetWindowLong( HeaderHandle, GWL_WNDPROC ) );
  SetWindowLong( HeaderHandle, GWL_WNDPROC, LongInt( FHeaderInstance ) );
end;


// Since we do all the popup menu handling ourselves, we need to defeat Delphi's default handling. We do this by
// setting the popup menu's AutoPopup property false before allowing Delphi a shot at it.

procedure TRzCustomListView.WMRButtonUp( var Msg: TWMRButtonUp );
var
  OldPopup: TPopupMenu;
begin
  try
    if FMenuAlreadyHandled and Assigned( PopupMenu ) then
    begin
      OldPopup := PopupMenu;
      PopupMenu := nil;
      try
        inherited;
      finally
        PopupMenu := OldPopup;
      end;
    end
    else
      inherited;
  finally
    FMenuAlreadyHandled := FALSE;
  end;
end;


// Call this method when a menu is required, but you don't know if it should be the control or item one. If it should
//  be the control one, then it is displayed. If it should be the item one, then the point at which it should popup is
//  determined and passed to DoItemContextMenu.  'pt' is where the control menu should be placed if it is decided
//  that it is the required menu.

procedure TRzCustomListView.DoPreItemContextMenu( pt: TPoint );
var
  p: TPoint;
  r: TRect;

  procedure DoDefault;
  begin
    if Assigned( PopupMenu ) then
    begin
      PopupMenu.PopupComponent := self;
      with ClientToScreen( pt ) do
        PopupMenu.Popup( x, y );
    end;
  end;

begin {= TRzCustomListView.DoPreItemContextMenu =}
  if Assigned( ItemFocused ) and not FRightClicked then
  begin
    // The following code to determine the popup coordinate is derived from observation of Explorer (95/NT)
    // if the user presses the Shift+F10 key combination.
    if ItemFocused.Selected then
    begin
      r := ItemFocused.DisplayRect( drIcon );
      p := Point( ( r.Left + r.Right ) div 2, ( r.Bottom + r.Top ) div 2 );
      DoItemContextMenu( p );
    end
    else if ( SelCount > 0 ) and Assigned( Selected ) then // Some selections, but the current focus isn't one of them, second clause just paranoid safety level
    begin
      r := Selected.DisplayRect( drIcon );
      p := Point( ( r.Left + r.Right ) div 2, ( r.Bottom + r.Top ) div 2 );
      DoItemContextMenu( p );
    end
    else
    begin
      DoDefault;
    end;
  end
  else if not FRightClicked then
  begin
    DoDefault;
    FMenuAlreadyHandled := True;
  end
  else
  begin
    DoItemContextMenu( pt );
  end;
end; {= TRzCustomListView.DoPreItemContextMenu =}


// This method is called after it is known that the popup menu should be for an item.

procedure TRzCustomListView.DoItemContextMenu( p: TPoint );
var
  mnu: TPopupMenu;
begin
  mnu := PopupMenu;                         // Default to normal popup
  ItemContextMenu( ItemFocused, p, mnu );
  FMenuAlreadyHandled := True;
  if Assigned( mnu ) then
  begin
    mnu.PopupComponent := self;
    with ClientToScreen( p ) do
      mnu.Popup( x, y );
  end;
end;


procedure TRzCustomListView.ItemContextMenu( Item: TListItem; var Pos: TPoint; var Menu: TPopupMenu );
begin
  if Assigned( OnItemContextMenu ) then
    OnItemContextMenu( Self, Item, Pos, Menu );
end;


procedure TRzCustomListView.KeyDown( var Key: Word; ShiftState: TShiftState );
begin
  if ( ( Key = VK_APPS ) and ( ShiftState = [ ] ) ) or
     ( ( Key = VK_F10 ) and ( ShiftState = [ ssShift ] ) ) then
  begin
    Key := 0;
    DoPreItemContextMenu( Point( 0, 0 ) )
  end;
  inherited;
end;


procedure TRzCustomListView.CreateWnd;
begin
  inherited;
  Perform( LVM_SETTEXTBKCOLOR, 0, ColorToRGB( Color ) );
  Perform( LVM_SETBKCOLOR, 0, ColorToRGB( Color ) );
  SetHeaderODStyle;
  PostMessage( Handle, WM_USER + 100, 0, 0 );
end;


procedure TRzCustomListView.DrawHeader( AIndex: Integer; const ARect: TRect );
var
  R: TRect;
begin
  HeaderCanvas.Font := Self.Font;
  HeaderCanvas.Brush.Color := clBtnFace;

  R := ARect;
  if not ThemeServices.ThemesEnabled then
  begin
    HeaderCanvas.FillRect( R );
    InflateRect( R, -2, -2 );
  end;

  if HeaderDefaultDrawing then
    DefaultDrawHeader( AIndex, R );
end;


procedure TRzCustomListView.DrawHeaderSortGlyphs( Index: Integer; const Rect: TRect );
begin
  if ( Index = FHeaderSortColumn ) and ( Columns[ Index ].Width > ( Rect.Right - Rect.Left ) * 2 ) then
  begin
    if FHeaderSortDirection = sdDescending then
      DrawDownArrow( HeaderCanvas, Rect, clNone, clBtnShadow )
    else
      DrawUpArrow( HeaderCanvas, Rect, clNone, clBtnShadow );
  end;
end;


procedure TRzCustomListView.DefaultDrawHeader( Index: Integer; const Rect: TRect );
const
  GLYPH_WIDTH = 9;
  TEXT_GLYPH_SPACING = 5;
var
  R: TRect;
  SortGlyphRect: TRect;
  ElementDetails: TThemedElementDetails;


  function GetColumnAlignment: TAlignment;
  var
    Col: TLVColumn;
  begin
    Col.Mask := LVCF_FMT;
    if ListView_GetColumn( Handle, Index, Col ) then
    begin
      if ( Col.fmt and LVCFMT_RIGHT ) = LVCFMT_RIGHT then
        Result := taRightJustify
      else if ( Col.fmt and LVCFMT_CENTER ) = LVCFMT_CENTER then
        Result := taCenter
      else
        Result := taLeftJustify;
    end
    else
      Result := taLeftJustify;
  end;


  function GetColumnCaption: string;
  var
    Col: TLVColumn;
  begin
    Col.Mask := LVCF_TEXT;
    GetMem( Col.pszText, 255 );
    Col.cchTextMax := 255;
    try
      if ListView_GetColumn( Handle, Index, Col ) then
        Result := Col.pszText
      else
        Result := '';
    finally
      FreeMem( Col.pszText );
    end;
  end;


  procedure DoDrawText( var ARect: TRect; ACalcRect: Boolean );
  const
    ALIGNMENT_CONVERSION: array[ TAlignment ] of DWORD = ( DT_LEFT, DT_RIGHT, DT_CENTER );
  var
    A: TAlignment;
    S: string;
  begin
    // Do not use Columns[] property to access attributes of the column. When dragging columns that are displayed using
    // Owner-Drawn code, as the headers in the TRzListView do, the Columns property is not correctly sync'd up when this
    // method is called.
    // As a result, do not use Columns[ Index ].Caption or Columns[ Index ].Alignment
    // Use the ListView_GetColumn function instead.

    S := GetColumnCaption;
    A := GetColumnAlignment;

    if ( Columns[ Index ].ImageIndex <> -1 ) and ( SmallImages <> nil ) then
    begin
      SmallImages.Draw( HeaderCanvas, ARect.Left, ARect.Top, Index );
      Inc( ARect.Left, SmallImages.Width + 4 );
    end;

    if ThemeServices.ThemesEnabled then
       HeaderCanvas.Brush.Style := bsClear
    else
      HeaderCanvas.Brush.Color := clBtnFace;

    DrawText( HeaderCanvas.Handle, PChar( S ), Length( S ), ARect,
              DT_END_ELLIPSIS or DT_SINGLELINE or ALIGNMENT_CONVERSION[ A ] );

    if ACalcRect then
      DrawText( HeaderCanvas.Handle, PChar( S ), Length( S ), ARect,
                DT_END_ELLIPSIS or DT_SINGLELINE or DT_CALCRECT or DT_RIGHT );
  end;


  function GetTextHeight( ARect: TRect ): Integer;
  var
    S: string;
  begin
    S := GetColumnCaption;

    DrawText( HeaderCanvas.Handle, PChar( S ), Length( S ), ARect,
              DT_END_ELLIPSIS or DT_SINGLELINE or DT_CALCRECT or DT_RIGHT );

    Result := ARect.Bottom - ARect.Top;
  end;


  function CalcSortGlyphRect( ARect: TRect ): TRect;
  var
    DesiredHeight: Integer;
  begin
    DesiredHeight := ( ARect.Bottom + ARect.Top ) div 2 - 1;
    Result.Left := ARect.Left;
    Result.Right := ARect.Left + DesiredHeight + 1;
    Result.Top := ( ARect.Top + ARect.Bottom - DesiredHeight ) div 2 - 1;
    Result.Bottom := Result.Top + DesiredHeight;
  end;

begin {= TRzCustomListView.DefaultDrawHeader =}
  if ThemeServices.ThemesEnabled then
  begin
    if FOverHeaderSection = Index then
    begin
      if FHeaderSectionDown then
        ElementDetails := ThemeServices.GetElementDetails( thHeaderItemPressed )
      else
        ElementDetails := ThemeServices.GetElementDetails( thHeaderItemHot );
    end
    else
      ElementDetails := ThemeServices.GetElementDetails( thHeaderItemNormal );

    ThemeServices.DrawElement( HeaderCanvas.Handle, ElementDetails, Rect );
  end;

  R := Rect;
  if ThemeServices.ThemesEnabled then
  begin
    InflateRect( R, -2, -2 );
    R.Left := R.Left + 4;
    R.Right := R.Right - 4;
  end
  else
  begin
    R.Left := R.Left + 4;
    R.Right := R.Right - 4;
  end;

  IntersectClipRect( HeaderCanvas.Handle, Rect.Left, Rect.Top, Rect.Right, Rect.Bottom );

  case HeaderSortDisplayMode of
    hsdmNone:
      DoDrawText( R, false );

    hsdmLeftAlign:
    begin
      if ( Index = FHeaderSortColumn ) and ( Columns[ Index ].Width > 15 ) then
      begin
        SortGlyphRect := CalcSortGlyphRect( R );
        DrawHeaderSortGlyphs( Index, SortGlyphRect );
        R.Left := SortGlyphRect.Right + TEXT_GLYPH_SPACING;
      end;
      DoDrawText( R, false );
    end;

    hsdmRightOfText:
    begin
      if GetColumnAlignment = taLeftJustify then
      begin
        DoDrawText( R, True );
        OffsetRect( R, R.Right - R.Left + TEXT_GLYPH_SPACING, 0 );
        DrawHeaderSortGlyphs( Index, CalcSortGlyphRect( R ) );
      end
      else
      begin
        // If text is right-justified then offset R by the glyph size
        if Index = FHeaderSortColumn then
        begin
          R.Bottom := R.Top + GetTextHeight( R );
          SortGlyphRect := CalcSortGlyphRect( R );
          OffsetRect( SortGlyphRect,
                      R.Right - R.Left - ( SortGlyphRect.Right - SortGlyphRect.Left ) - TEXT_GLYPH_SPACING, 0 );
          DrawHeaderSortGlyphs( Index, SortGlyphRect );

          if GetColumnAlignment = taRightJustify then
            R.Right := SortGlyphRect.Left - TEXT_GLYPH_SPACING
          else
            InflateRect( R, -( SortGlyphRect.Right - SortGlyphRect.Left + TEXT_GLYPH_SPACING ), 0 );
        end;
        DoDrawText( R, false );
      end;
    end;

    hsdmRightAlign:
    begin
      SortGlyphRect := CalcSortGlyphRect( R );
      OffsetRect( SortGlyphRect,
                  R.Right - R.Left - ( SortGlyphRect.Right - SortGlyphRect.Left ) - TEXT_GLYPH_SPACING, 0 );
      DrawHeaderSortGlyphs( Index, SortGlyphRect );

      if ( Index = FHeaderSortColumn ) then
        R.Right := SortGlyphRect.Left - TEXT_GLYPH_SPACING;

      DoDrawText( R, false );
    end;
  end;
end; {= TRzCustomListView.DefaultDrawHeader =}


procedure TRzCustomListView.SetHeaderODStyle;
var
  ColumnIndex: Integer;
  Header: THandle;
  HdrItemData: THDItem;
  OwnerDrawMode: Boolean;
begin
  if not HandleAllocated or ( ViewStyle <> vsReport ) then
    Exit;

  if FSetHeaderODStyleSem > 0 then          // Prevent reentrancy
    Exit;

  Inc( FSetHeaderODStyleSem );
  try
    OwnerDrawMode := ( HeaderSortDisplayMode <> hsdmNone );

    Header := HeaderHandle;
    if Header <> 0 then
    begin
      for ColumnIndex := Columns.Count - 1 downto 0 do
      begin
        {Set the HDF_OWNERDRAW flag while retaining the justify flag.}
        FillChar( HdrItemData, SizeOf( HdrItemData ), 0 );
        HdrItemData.Mask := HDI_FORMAT;
        Header_GetItem( Header, ColumnIndex, HdrItemData );

        if OwnerDrawMode then
          HdrItemData.fmt := ( HdrItemData.fmt and HDF_JUSTIFYMASK ) or HDF_OWNERDRAW
        else
        begin
          if ( Columns[ ColumnIndex ].ImageIndex <> -1 ) and ( SmallImages <> nil ) then
            HdrItemData.fmt := ( ( HdrItemData.fmt and HDF_JUSTIFYMASK ) and not HDF_OWNERDRAW ) or HDF_STRING or HDF_IMAGE
          else
            HdrItemData.fmt := ( ( HdrItemData.fmt and HDF_JUSTIFYMASK ) and not HDF_OWNERDRAW ) or HDF_STRING;
          if ( FHeaderSortColumn = ColumnIndex ) and ( HeaderSortDisplayMode <> hsdmNone ) then
          begin
            if FHeaderSortDirection = sdAscending then
              HdrItemData.fmt := HdrItemData.fmt or HDF_SORTUP
            else
              HdrItemData.fmt := HdrItemData.fmt or HDF_SORTDOWN;
          end;
        end;

        Header_SetItem( Header, ColumnIndex, HdrItemData );
      end;

      InvalidateRect( Header, nil, True );
    end;
  finally
    Dec( FSetHeaderODStyleSem );
  end;
end; {= TRzCustomListView.SetHeaderODStyle =}


procedure TRzCustomListView.HeaderWndProc( var Msg: TMessage );
var
  HTInfo: THDHitTestInfo;
begin
  try
    case Msg.Msg of
      wm_NCHitTest:
      begin
        if csDesigning in ComponentState then
        begin
          Msg.Result := Windows.HTTRANSPARENT;
          Exit;
        end;
      end;

      wm_NCDestroy:
      begin
        Msg.Result := CallWindowProc( FDefHeaderProc, HeaderHandle, Msg.Msg, Msg.WParam, Msg.LParam );
        FDefHeaderProc := nil;
        Exit;
      end;

      wm_MouseMove:
      begin
        // Handle moving over the header--needed for XP Theme support
        if ThemeServices.ThemesEnabled and not FHeaderSectionDown then
        begin
          HTInfo.Point.X := SmallInt( Msg.LParam and $FFFF );
          HTInfo.Point.Y := SmallInt( ( Msg.LParam and $FFFF0000 ) shr 16 );
          FOverHeaderSection := SendMessage( HeaderHandle, hdm_HitTest, 0, Longint( @HTInfo ) );
          InvalidateRect( HeaderHandle, nil, False );
        end
        else
        begin

        end;
      end;

      wm_LButtonDown:
      begin
        FHeaderSectionDown := True;
      end;

      wm_LButtonUp:
      begin
        FHeaderSectionDown := False;
      end;
    end;
    Msg.Result := CallWindowProc( FDefHeaderProc, HeaderHandle, Msg.Msg, Msg.WParam, Msg.LParam );
  except
    Application.HandleException( Self );
  end;
end;


{&RUIF}

end.
