{===============================================================================
  RzChkLst Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzCheckList          Enhanced list box where each item is associated with a
                          check box.


  Modification History
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Fixed problem where ItemIndex was not being maintained in TRzCheckList
      when an Item's caption was changed.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Group code was moved from the TRzCheckList class to the TRzCustomListBox.
    * Fixed CheckGroup, UncheckGroup, EnableGroup, DisableGroup methods.
    * Added the AddItemToGroup and InsertItemIntoGroup methods. Also added the
      following support methods: ItemsInGroup and ItemIndexOfGroup.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Test FullColorSupport before all calls to PaintGradient.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Fixed problem where check and enabled states did not get updated correctly
      when the Items.Exchange method was used.
    * The TRzCheckList now supports grouping items in the list. By specifying a
      prefix "//" at the beginning of an item, the check list will display that
      item as a group header rather than a regular check item.  There are
      several new methods that allow users to manipulate the items within the
      group.  For example, SetGroupState, CheckGroup, UncheckGroup, EnableGroup,
      DisableGroup. It is also possible to convert an item to a group and back
      using the ItemToGroup and GroupToItem methods.
    * Added LoadFromFile, LoadFromStream, SaveToFile, and SaveToStream methods,
      which not only save the text of each item, but also the State of each item
      (i.e. cbChecked, cbUnchecked, cbGrayed) and the Enabled state of each
      item.
    * Added XP visual style support.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzChkLst;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Classes,
  Controls,
  Forms,
  SysUtils,
  Messages,
  Windows,
  StdCtrls,
  Graphics,
  Menus,
  RzCommon,
  RzLstBox;

type
  TRzCheckList = class( TRzCustomTabbedListBox )
  private
    FAboutInfo: TRzAboutInfo;
    FChangingItems: Boolean;
    FCheckItems: TStrings;
    FAllowGrayed: Boolean;
    FGlyphWidth: Integer;
    FGlyphHeight: Integer;

    FNumStates: Integer;
    FCustomGlyphs: TBitmap;
    FUseCustomGlyphs: Boolean;
    FTransparentColor: TColor;
    FHighlightColor: TColor;

    FSelectedItem: Integer;
    FSaveCheckItems: TStringList;
    FSaveTopIndex: Integer;
    FSaveItemIndex: Integer;
    FToggleOnItemClick: Boolean;
    FChangingState: Boolean;

    FOnChanging: TStateChangingEvent;
    FOnChange: TStateChangeEvent;

    { Internal Event Handlers }
    procedure CustomGlyphsChanged( Sender: TObject );

    { Message Handling Methods }
    procedure WMChar( var Msg: TWMChar ); message wm_Char;
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Loaded; override;
    procedure UpdateItemHeight; override;

    function InitialTabStopOffset: Integer; override;

    procedure ToggleCheckState; virtual;
    procedure ExtractGlyph( Index: Integer; Bitmap, Source: TBitmap; W, H: Integer );
    function CheckColor( Value: TColor ): TColor; virtual;
    procedure SelectGlyph( Index: Integer; Glyph: TBitmap ); virtual;

    function OwnerDrawItemIndent: Integer; override;
    procedure DrawListItem( Index: Integer; Rect: TRect; State: TOwnerDrawState ); override;

    { Event Dispatch Methods }
    function CanChange( Index: Integer; NewState: TCheckBoxState ): Boolean; dynamic;
    procedure Change( Index: Integer; NewState: TCheckBoxState ); dynamic;

    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure KeyUp( var Key: Word; Shift: TShiftState ); override;

    { Property Access Methods }
    function GetItems: TStrings; override;
    function GetItemChecked( Index: Integer ): Boolean; virtual;
    procedure SetItemChecked( Index: Integer; Value: Boolean ); virtual;
    function GetItemEnabled( Index: Integer ): Boolean; virtual;
    procedure SetItemEnabled( Index: Integer; Value: Boolean ); virtual;
    function GetItemState( Index: Integer ): TCheckBoxState; virtual;
    procedure SetItemState( Index: Integer; Value: TCheckBoxState ); virtual;
    procedure SetItems( Value: TStrings ); virtual;
    procedure SetAllowGrayed( Value: Boolean ); virtual;
    procedure SetCustomGlyphs( Value: TBitmap ); virtual;
    procedure SetUseCustomGlyphs( Value: Boolean ); virtual;
    procedure SetHighlightColor( Value: TColor ); virtual;
    procedure SetTransparentColor( Value: TColor ); virtual;

    property GlyphWidth: Integer
      read FGlyphWidth;

    property GlyphHeight: Integer
      read FGlyphHeight;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function AddEx( const S: string; Checked: Boolean; Enabled: Boolean = True ): Integer;
    procedure CheckAll;
    procedure UncheckAll;
    function ItemsChecked: Integer;

    procedure LoadFromFile( const FileName: string );
    procedure LoadFromStream( Stream: TStream );
    procedure SaveToFile( const FileName: string );
    procedure SaveToStream( Stream: TStream );

    procedure DefaultDrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState ); override;

    procedure SetGroupState( GroupIndex: Integer; State: TCheckBoxState );
    procedure CheckGroup( GroupIndex: Integer );
    procedure UncheckGroup( GroupIndex: Integer );
    procedure EnableGroup( GroupIndex: Integer );
    procedure DisableGroup( GroupIndex: Integer );

    property ItemChecked[ Index: Integer ]: Boolean
      read GetItemChecked
      write SetItemChecked;

    property ItemEnabled[ Index: Integer ]: Boolean
      read GetItemEnabled
      write SetItemEnabled;

    property ItemState[ Index: Integer ]: TCheckBoxState
      read GetItemState
      write SetItemState;

  published
    { Items property is redeclared, so TRzCheckListStrings type can be used }
    property Items: TStrings
      read FCheckItems
      write SetItems;

    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property AllowGrayed: Boolean
      read FAllowGrayed
      write SetAllowGrayed
      default False;

    property CustomGlyphs: TBitmap
      read FCustomGlyphs
      write SetCustomGlyphs;

    property HighlightColor: TColor
      read FHighlightColor
      write SetHighlightColor
      default clHighlight;

    property UseCustomGlyphs: Boolean
      read FUseCustomGlyphs
      write SetUseCustomGlyphs
      default False;

    property TransparentColor: TColor
      read FTransparentColor
      write SetTransparentColor
      default clOlive;

    property OnChange: TStateChangeEvent
      read FOnChange
      write FOnChange;

    property OnChanging: TStateChangingEvent
      read FOnChanging
      write FOnChanging;

    property ToggleOnItemClick: Boolean
      read FToggleOnItemClick
      write FToggleOnItemClick
      default False;

    { Inherited Properties & Events }
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
    property HorzExtent;
    property HorzScrollBar;
    property ImeMode;
    property ImeName;
    property IncrementalSearch;
    property IntegralHeight;
    property ItemHeight;
    property MultiSelect;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
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



implementation

uses
  {$IFDEF VCL60_OR_HIGHER}
  RTLConsts,
  {$ENDIF}
  {$IFDEF VCL70_OR_HIGHER}
  Themes,
  {$ELSE}
  RzThemeSrv,
  {$ENDIF}
  Consts,
  RzCommonBitmaps,
  RzGrafx;


const
  DefaultGlyphWidth  = 13;
  DefaultGlyphHeight = 13;

type
  TPacket = class
    State: TCheckBoxState;
    Enabled: Boolean;
  end;


  TRzCheckListStrings = class( TStrings )
  private
    FPackets: TList;
    FCheckList: TRzCheckList;
    procedure ReadItemEnabled( Reader: TReader );
    procedure WriteItemEnabled( Writer: TWriter );
    procedure ReadItemState( Reader: TReader );
    procedure WriteItemState( Writer: TWriter );
  protected
    procedure DefineProperties( Filer: TFiler ); override;
    function Get( Index: Integer ): string; override;
    procedure Put( Index: Integer; const S: string ); override;
    function GetCount: Integer; override;
    function GetObject( Index: Integer ): TObject; override;
    function GetItemEnabled( Index: Integer ): Boolean;
    function GetItemState( Index: Integer ): TCheckBoxState;

    procedure PutObject( Index: Integer; AObject: TObject ); override;
    procedure SetItemEnabled( Index: Integer; Value: Boolean );
    procedure SetItemState( Index: Integer; Value: TCheckBoxState );
    procedure SetUpdateState( Updating: Boolean ); override;
    procedure AddStrings( Strings: TStrings ); override;
    function AddObjectPacket( const S: string; AObject: TObject; APacket: TPacket ): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function Add( const S: string ): Integer; override;
    procedure Clear; override;
    procedure Delete( Index: Integer ); override;
    procedure Insert( Index: Integer; const S: string ); override;
    procedure Move( CurIndex, NewIndex: Integer ); override;
    procedure Exchange( Index1, Index2: Integer ); override;

    procedure LoadFromStream( Stream: TStream ); override;
    procedure SaveToStream( Stream: TStream ); override;

    property ItemEnabled[ Index: Integer ]: Boolean
      read GetItemEnabled
      write SetItemEnabled;

    property ItemState[ Index: Integer ]: TCheckBoxState
      read GetItemState
      write SetItemState;
  end;

  { TPacketStringList used to hold check state info during
    DestroyWnd/CreateWnd transition }

  TPacketStringList = class( TStringList )
  private
    FPackets: TList;
  protected
    procedure AddStrings( Strings: TStrings ); override;
    function AddObjectPacket( const S: string; AObject: TObject; APacket: TPacket ): Integer;
  public
    constructor Create;
    destructor Destroy; override;
    {$IFDEF VCL60_OR_HIGHER}
    function AddObject( const S: string; AObject: TObject ): Integer; override;
    {$ELSE}
    function Add( const S: string ): Integer; override;
    {$ENDIF}
    procedure Clear; override;
  end;


function Max( A, B: Integer ): Integer;
begin
  if A >= B then
    Result := A
  else
    Result := B;
end;


{&RT}
{==========================}
{== TRzCheckList Methods ==}
{==========================}

constructor TRzCheckList.Create( AOwner: TComponent );
begin
  inherited;

  Items.Free;  { Release memory allocated by ancestor }
  FCheckItems := TRzCheckListStrings.Create;
  TRzCheckListStrings( FCheckItems ).FCheckList := Self;
  FChangingItems := False;

  FToggleOnItemClick := False;
  Style := lbOwnerDrawFixed;

  FAllowGrayed := False;
  FNumStates := 6;
  FGlyphWidth := DefaultGlyphWidth;
  FGlyphHeight := DefaultGlyphHeight;

  FCustomGlyphs := TBitmap.Create;
  FCustomGlyphs.OnChange := CustomGlyphsChanged;
  FUseCustomGlyphs := False;
  FTransparentColor := clOlive;
  FHighlightColor := clHighlight;

  UpdateItemHeight;
  ShowGroups := True;
  {&RCI}
end;


destructor TRzCheckList.Destroy;
begin
  FCustomGlyphs.Free;
  FCheckItems.Free;
  FSaveCheckItems.Free;
  inherited;
end;


procedure TRzCheckList.CreateWnd;
begin
  inherited;
  if FSaveCheckItems <> nil then
  begin
    FCheckItems.Assign( FSaveCheckItems );
    TopIndex := FSaveTopIndex;
    ItemIndex := FSaveItemIndex;
    FSaveCheckItems.Free;
    FSaveCheckItems := nil;
  end;
  {&RV}
end;


procedure TRzCheckList.DestroyWnd;
begin
  if not ( csLoading in ComponentState ) then
  begin
    if FCheckItems.Count > 0 then
    begin
      FSaveCheckItems := TPacketStringList.Create;
      FSaveCheckItems.Assign( FCheckItems );
      FSaveTopIndex := TopIndex;
      FSaveItemIndex := ItemIndex;
    end;
  end;
  inherited;
end;


procedure TRzCheckList.Loaded;
begin
  inherited;
  if ( csDesigning in ComponentState ) and ( FCheckItems.Count > 0 ) then
    Repaint;

  {&RV}
end;


procedure TRzCheckList.UpdateItemHeight;
begin
  ItemHeight := Max( FGlyphHeight + 4, GetMinFontHeight( Font ) );
end;


procedure TRzCheckList.CustomGlyphsChanged( Sender: TObject );
begin
  if not ( csLoading in ComponentState ) then
  begin
    UseCustomGlyphs := not FCustomGlyphs.Empty;
    Invalidate;
  end;
end;


procedure TRzCheckList.ExtractGlyph( Index: Integer; Bitmap, Source: TBitmap; W, H: Integer );
var
  DestRct: TRect;
begin
  DestRct := Rect( 0, 0, W, H );

  Bitmap.Width := W;
  Bitmap.Height := H;
  Bitmap.Canvas.CopyRect( DestRct, Source.Canvas, Rect( Index * W, 0, (Index + 1 ) * W, H ) );
end;


procedure TRzCheckList.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  UpdateItemHeight;
end;



function TRzCheckList.CanChange( Index: Integer; NewState: TCheckBoxState ): Boolean;
begin
  Result := True;
  if Assigned( FOnChanging ) then
    FOnChanging( Self, Index, NewState, Result );
end;


procedure TRzCheckList.Change( Index: Integer; NewState: TCheckBoxState );
begin
  if Assigned( FOnChange ) then
    FOnChange( Self, Index, NewState );
end;


function TRzCheckList.GetItems: TStrings;
begin
  Result := Items;
end;

function TRzCheckList.AddEx( const S: string; Checked: Boolean; Enabled: Boolean = True ): Integer;
begin
  Result := Items.Add( S );
  ItemChecked[ Result ] := Checked;
  ItemEnabled[ Result ] := Enabled;
end;


procedure TRzCheckList.CheckAll;
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    ItemChecked[ I ] := True;
end;


procedure TRzCheckList.UncheckAll;
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
    ItemChecked[ I ] := False;
end;


function TRzCheckList.ItemsChecked: Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Items.Count - 1 do
  begin
    if ItemChecked[ I ] and not ItemIsGroup[ I ] then
      Inc( Result );
  end;
end;


function TRzCheckList.GetItemChecked( Index: Integer ): Boolean;
begin
  Result := TRzCheckListStrings( Items ).ItemState[ Index ] = cbChecked;
end;


procedure TRzCheckList.SetItemChecked( Index: Integer; Value: Boolean );
begin
  if Value then
    ItemState[ Index ] := cbChecked
  else
    ItemState[ Index ] := cbUnchecked;
end;


function TRzCheckList.GetItemEnabled( Index: Integer ): Boolean;
begin
  Result := TRzCheckListStrings( Items ).ItemEnabled[ Index ];
end;


procedure TRzCheckList.SetItemEnabled( Index: Integer; Value: Boolean );
begin
  if ItemEnabled[ Index ] <> Value then
  begin
    TRzCheckListStrings( Items ).ItemEnabled[ Index ] := Value;
    Invalidate;
  end;
end;


function TRzCheckList.GetItemState( Index: Integer ): TCheckBoxState;
begin
  Result := TRzCheckListStrings( Items ).ItemState[ Index ];
end;


procedure TRzCheckList.SetItemState( Index: Integer; Value: TCheckBoxState );
var
  R, ItemRct: TRect;
  Offset: Integer;
begin
  if ItemState[ Index ] <> Value then
  begin
    TRzCheckListStrings( Items ).ItemState[ Index ] := Value;

    { Repaint the Checkbox }
    Offset := ( ItemHeight - FGlyphHeight ) div 2;
    R := ItemRect( Index );
    if not UseRightToLeftAlignment then
      ItemRct := Rect( R.Left, R.Top + Offset, R.Left + FGlyphWidth + 4, R.Top + ItemHeight - Offset )
    else
      ItemRct := Rect( R.Right - FGlyphWidth - 4, R.Top + Offset, R.Right, R.Top + ItemHeight - Offset );
    InvalidateRect( Handle, @ItemRct, False );
  end;
end;


procedure TRzCheckList.SetItems( Value: TStrings );
begin
  Items.Assign( Value );
end;


procedure TRzCheckList.SetAllowGrayed( Value: Boolean );
begin
  if FAllowGrayed <> Value then
    FAllowGrayed := Value;
end;


procedure TRzCheckList.SetCustomGlyphs( Value: TBitmap );
begin
  FCustomGlyphs.Assign( Value );
end;




procedure TRzCheckList.SetUseCustomGlyphs( Value: Boolean );
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
    UpdateItemHeight;
    Invalidate;
  end;
end;


procedure TRzCheckList.SetHighlightColor( Value: TColor );
begin
  if FHighlightColor <> Value then
  begin
    FHighlightColor := Value;
    Invalidate;
  end;
end;


procedure TRzCheckList.SetTransparentColor( Value: TColor );
begin
  if FTransparentColor <> Value then
  begin
    FTransparentColor := Value;
    Invalidate;
  end;
end;


function TRzCheckList.CheckColor( Value: TColor ): TColor;
begin
  // Need to check color against TransparentColor and WinMaskColor
  if ( ColorToRGB( Value ) = ColorToRGB( FTransparentColor ) ) or
     ( ColorToRGB( Value ) = ColorToRGB( clGray ) ) then
  begin
    Result := ColorToRGB( Value ) + 1;
  end
  else
    Result := Value;
end;


procedure TRzCheckList.SelectGlyph( Index: Integer; Glyph: TBitmap );
const
  BaseColors: array[ 0..4 ] of TColor = ( clWhite, clGray, clRed, clFuchsia, clBlue );
  ResNames: array[ TCheckBoxState ] of PChar = ( 'RZCOMMON_CHECKBOX_UNCHECKED',
                                                 'RZCOMMON_CHECKBOX_CHECKED',
                                                 'RZCOMMON_CHECKBOX_GRAYED' );
var
  R: TRect;
  DestBmp, SourceBmp: TBitmap;
  ReplaceColors: array[ 0..4 ] of TColor;
  ElementDetails: TThemedElementDetails;
begin
  R := Rect( 0, 0, FGlyphWidth, FGlyphHeight );

  if not FUseCustomGlyphs then
  begin
    if ThemeServices.ThemesEnabled then
    begin
      case ItemState[ Index ] of
        cbUnchecked:
        begin
          if ItemEnabled[ Index ] then
            ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxUncheckedNormal )
          else
            ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxUncheckedDisabled );
        end;

        cbChecked:
        begin
          if ItemEnabled[ Index ] then
            ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxCheckedNormal )
          else
            ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxCheckedDisabled );
        end;

        else // cbGrayed
        begin
          if ItemEnabled[ Index ] then
            ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxMixedNormal )
          else
            ElementDetails := ThemeServices.GetElementDetails( tbCheckBoxMixedDisabled );
        end;
      end;
      ThemeServices.DrawElement( Glyph.Canvas.Handle, ElementDetails, R );
    end
    else
    begin
      ReplaceColors[ 0 ] := clWindow;
      ReplaceColors[ 1 ] := FrameColor;
      ReplaceColors[ 2 ] := clWindow;
      ReplaceColors[ 3 ] := clWindow;
      ReplaceColors[ 4 ] := CheckColor( FHighlightColor );

      if not ItemEnabled[ Index ] then
      begin
        ReplaceColors[ 0 ] := DisabledColor;
        ReplaceColors[ 2 ] := DisabledColor;
        ReplaceColors[ 3 ] := DisabledColor;
        ReplaceColors[ 4 ] := clBtnShadow;
      end;

      Glyph.Handle := CreateMappedRes( HInstance, ResNames[ ItemState[ Index ] ], BaseColors, ReplaceColors  );
    end;
  end
  else
  begin
    SourceBmp := FCustomGlyphs;

    DestBmp := TBitmap.Create;
    try
      if ItemEnabled[ Index ] then
      begin
        case ItemState[ Index ] of
          cbUnchecked:
            ExtractGlyph( 0, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );

          cbChecked:
            ExtractGlyph( 1, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );

          cbGrayed:
            ExtractGlyph( 2, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );
        end;
      end
      else
      begin
        case ItemState[ Index ] of
          cbUnchecked:
            ExtractGlyph( 3, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );

          cbChecked:
            ExtractGlyph( 4, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );

          cbGrayed:
            ExtractGlyph( 5, DestBmp, SourceBmp, FGlyphWidth, FGlyphHeight );
        end;
      end;

      Glyph.Assign( DestBmp );

    finally
      DestBmp.Free;
    end;
  end;
end; {= TRzCheckList.SelectGlyph =}


function TRzCheckList.OwnerDrawItemIndent: Integer;
begin
  Result := FGlyphWidth + 8;
end;


procedure TRzCheckList.DefaultDrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState );
var
  TextOffset: Integer;
  TabCount, I: Integer;
  TabArray: TRzTabArray;
begin
  TextOffset := ( ItemHeight - Canvas.TextHeight( 'Pp' ) ) div 2;

  GetTabArray( TabCount, TabArray );
  for I := 0 to TabCount - 1 do
    TabArray[ I ] := Round( TabArray[ I ] * FDialogUnits / 4 );

  if not UseRightToLeftAlignment then
  begin
    TabbedTextOut( Canvas.Handle, Rect.Left + 2, Rect.Top + TextOffset, PChar( Items[ Index ] ),
                   Length( Items[ Index ] ), TabCount, TabArray, 0 );
  end
  else
  begin
    SetTextAlign( Canvas.Handle, ta_Right or ta_Top );
    TextOut( Canvas.Handle, Rect.Right - 2, Rect.Top + TextOffset, PChar( Items[ Index ] ), Length( Items[ Index ] ) );
  end;

end;


procedure TRzCheckList.DrawListItem( Index: Integer; Rect: TRect; State: TOwnerDrawState );
var
  Bmp, FGlyph: TBitmap;
  R: TRect;
  BmpOffset: Integer;
begin
  if not FChangingItems then
  begin
    Bmp := TBitmap.Create;
    FGlyph := TBitmap.Create;
    FGlyph.Width := FGlyphWidth;
    FGlyph.Height := FGlyphHeight;
    try
      SelectGlyph( Index, FGlyph );

      Canvas.FillRect( Rect );   { Clear area for icon and text }

      R := Classes.Rect( 0, 0, FGlyphWidth, FGlyphHeight );

      { Don't Forget to Set the Width and Height of Destination Bitmap }

      Bmp.Width := FGlyphWidth;
      Bmp.Height := FGlyphHeight;
      Bmp.Canvas.Brush.Color := Color;
      Bmp.Canvas.BrushCopy( R, FGlyph, R, FTransparentColor );

      BmpOffset := ( ItemHeight - FGlyphHeight ) div 2;
      if not UseRightToLeftAlignment then
        Canvas.Draw( Rect.Left - FGlyphWidth - 4, Rect.Top + BmpOffset, Bmp )
      else
        Canvas.Draw( Rect.Right + 4, Rect.Top + BmpOffset, Bmp );
    finally
      FGlyph.Free;
      Bmp.Free;
    end;

    Canvas.Font := Font;
    if not ItemEnabled[ Index ] or not Enabled then
    begin
      if ColorToRGB( Color ) = ColorToRGB( clBtnShadow ) then
        Canvas.Font.Color := clBtnFace
      else
        Canvas.Font.Color := clBtnShadow;
    end;


    // Clip text to Rect
    IntersectClipRect( Canvas.Handle, Rect.Left, Rect.Top, Rect.Right, Rect.Bottom );
    try
      if odSelected in State then
      begin
        Canvas.Brush.Color := clHighlight;
        Canvas.Font.Color := clHighlightText;
      end;

      if not Assigned( OnDrawItem ) then
        DefaultDrawItem( Index, Rect, State )
      else
        OnDrawItem( Self, Index, Rect, State );
    finally
      // Removing clipping region
      SelectClipRgn( Canvas.Handle, 0 );
    end;
  end;
end; {= TRzCheckList.DrawListItem =}


procedure TRzCheckList.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  R: TRect;
  Pt: TPoint;
  Idx: Integer;
begin
  if Button = mbLeft then
  begin
    Idx := ItemAtPos( Point( X, Y ), True );
    if Idx <> -1 then
    begin
      R := ItemRect( Idx );
      if not UseRightToLeftAlignment then
        R.Right := R.Left + FGlyphWidth + 4
      else
        R.Left := R.Right - FGlyphWidth - 4;
      Pt := Point( X, Y );
      if FToggleOnItemClick or PtInRect( R, Pt ) then
      begin
        FChangingState := True;
        FSelectedItem := ItemIndex;
      end;
    end;
  end
  else if Button = mbRight then
  begin
    Idx := ItemAtPos( Point( X, Y ), True );
    if Idx <> -1 then
    begin
      if Idx <> ItemIndex then
      begin
        ItemIndex := Idx;
        Click;
      end;
    end;
  end;

  inherited;
end;


procedure TRzCheckList.ToggleCheckState;
var
  NewState: TCheckBoxState;
begin
  if ( ItemIndex = -1 ) or not ItemEnabled[ ItemIndex ] or ItemIsGroup[ ItemIndex ] then
    Exit;

  NewState := cbChecked;
  case ItemState[ ItemIndex ] of
    cbUnchecked:
      if FAllowGrayed then
        NewState := cbGrayed
      else
        NewState := cbChecked;

    cbChecked:
      NewState := cbUnchecked;

    cbGrayed:
      NewState := cbChecked;
  end;

  if CanChange( ItemIndex, NewState ) then
  begin
    ItemState[ ItemIndex ] := NewState;
    FChangingState := False;
    Change( ItemIndex, NewState );
  end
  else
    FChangingState := False;
end; {= TRzCheckList.ToggleCheckState =}


function TRzCheckList.InitialTabStopOffset: Integer;
begin
  Result := GlyphWidth;
end;


procedure TRzCheckList.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  if ( Button = mbLeft ) and FChangingState and ( ItemIndex = FSelectedItem ) and
     PtInRect( ClientRect, Point( X, Y ) ) then
  begin
    ToggleCheckState;
  end;

  inherited;
end;


procedure TRzCheckList.KeyDown( var Key: Word; Shift: TShiftState );
begin
  if Key = vk_Space then
    FChangingState := True;
  FSelectedItem := ItemIndex;

  inherited;
end;


procedure TRzCheckList.KeyUp( var Key: Word; Shift: TShiftState );
begin
  if FChangingState and ( Key = vk_Space ) then
    ToggleCheckState;

  inherited;
end;


procedure TRzCheckList.WMChar( var Msg: TWMChar );
begin
  if Msg.CharCode <> vk_Space then
    inherited;
end;


procedure TRzCheckList.CMEnabledChanged( var Msg: TMessage );
var
  I: Integer;
begin
  inherited;
  for I := 0 to Items.Count - 1 do
    ItemEnabled[ I ] := Enabled;
end;


procedure TRzCheckList.LoadFromFile( const FileName: string );
begin
  Items.LoadFromFile( FileName );
end;


procedure TRzCheckList.LoadFromStream( Stream: TStream );
begin
  Items.LoadFromStream( Stream );
end;


procedure TRzCheckList.SaveToFile( const FileName: string );
begin
  Items.SaveToFile( FileName );
end;


procedure TRzCheckList.SaveToStream( Stream: TStream );
begin
  Items.SaveToStream( Stream );
end;


procedure TRzCheckList.SetGroupState( GroupIndex: Integer; State: TCheckBoxState );
var
  I: Integer;
begin
  for I := ItemIndexOfGroup( GroupIndex ) + 1 to Items.Count - 1 do
  begin
    if ItemIsGroup[ I ] then                               // Found the next category - we're outta here.
      Exit;

    ItemState[ I ] := State;
  end;
end;

procedure TRzCheckList.CheckGroup( GroupIndex: Integer );
var
  I: Integer;
begin
  for I := ItemIndexOfGroup( GroupIndex ) + 1 to Items.Count - 1 do
  begin
    if ItemIsGroup[ I ] then                               // Found the next category - we're outta here.
      Exit;

    ItemChecked[ I ] := True;
  end;
end;


procedure TRzCheckList.UncheckGroup( GroupIndex: Integer );
var
  I: Integer;
begin
  for I := ItemIndexOfGroup( GroupIndex ) + 1 to Items.Count - 1 do
  begin
    if ItemIsGroup[ I ] then                               // Found the next category - we're outta here.
      Exit;

    ItemChecked[ I ] := False;
  end;
end;


procedure TRzCheckList.EnableGroup( GroupIndex: Integer );
var
  I: Integer;
begin
  for I := ItemIndexOfGroup( GroupIndex ) + 1 to Items.Count - 1 do
  begin
    if ItemIsGroup[ I ] then                               // Found the next category - we're outta here.
      Exit;

    ItemEnabled[ I ] := True;
  end;
end;


procedure TRzCheckList.DisableGroup( GroupIndex: Integer );
var
  I: Integer;
begin
  for I := ItemIndexOfGroup( GroupIndex ) + 1 to Items.Count - 1 do
  begin
    if ItemIsGroup[ I ] then                               // Found the next category - we're outta here.
      Exit;

    ItemEnabled[ I ] := False;
  end;
end;


{=================================}
{== TRzCheckListStrings Methods ==}
{=================================}

constructor TRzCheckListStrings.Create;
begin
  inherited;
  FPackets := TList.Create;
end;


destructor TRzCheckListStrings.Destroy;
var
  I: Integer;
begin
  for I := 0 to FPackets.Count - 1 do
    TPacket( FPackets[ I ] ).Free;
  FPackets.Free;
  inherited;
end;


procedure TRzCheckListStrings.DefineProperties( Filer: TFiler );
begin
  inherited;
  Filer.DefineProperty( 'ItemEnabled', ReadItemEnabled, WriteItemEnabled, Count > 0 );
  Filer.DefineProperty( 'ItemState', ReadItemState, WriteItemState, Count > 0 );
end;


procedure TRzCheckListStrings.ReadItemEnabled( Reader: TReader );
var
  I: Integer;
begin
  Reader.ReadListBegin;
  I := 0;
  while not Reader.EndOfList do
  begin
    ItemEnabled[ I ] := Reader.ReadBoolean;
    Inc( I );
  end;
  Reader.ReadListEnd;
end;


procedure TRzCheckListStrings.WriteItemEnabled( Writer: TWriter );
var
  I: Integer;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do
    Writer.WriteBoolean( ItemEnabled[ I ] );
  Writer.WriteListEnd;
end;


procedure TRzCheckListStrings.ReadItemState( Reader: TReader );
var
  I: Integer;
begin
  Reader.ReadListBegin;
  I := 0;
  while not Reader.EndOfList do
  begin
    ItemState[ I ] := TCheckBoxState( Reader.ReadInteger );
    Inc( I );
  end;
  Reader.ReadListEnd;
end;


procedure TRzCheckListStrings.WriteItemState( Writer: TWriter );
var
  I: Integer;
begin
  Writer.WriteListBegin;
  for I := 0 to Count - 1 do
    Writer.WriteInteger( Ord( ItemState[ I ] ) );
  Writer.WriteListEnd;
end;


function TRzCheckListStrings.GetCount: Integer;
begin
  if FCheckList = nil then
  begin
    Result := lb_Err;
    Exit;
  end;
  Result := SendMessage( FCheckList.Handle, lb_GetCount, 0, 0 );
end;


function TRzCheckListStrings.Get( Index: Integer ): string;
var
  Len: Integer;
  Text: array[ 0..4095 ] of Char;
begin
  if FCheckList = nil then
    Exit;
  Len := SendMessage( FCheckList.Handle, lb_GetText, Index, Longint( @Text ) );

  if Len < 0 then
    raise EStringListError.Create( SListIndexError );

  SetString( Result, Text, Len );
end;


procedure TRzCheckListStrings.Put( Index: Integer; const S: string );
var
  TempState: TCheckBoxState;
  TempEnabled: Boolean;
  I: Integer;
begin
  if FCheckList = nil then
    Exit;
  I := FCheckList.ItemIndex;
  TempState := ItemState[ Index ];
  TempEnabled := ItemEnabled[ Index ];
  inherited;
  ItemState[ Index ] := TempState;
  ItemEnabled[ Index ] := TempEnabled;
  FCheckList.ItemIndex := I;
end;


function TRzCheckListStrings.GetItemEnabled( Index: Integer ): Boolean;
begin
  Result := TPacket( FPackets[ Index ] ).Enabled;
end;


procedure TRzCheckListStrings.SetItemEnabled( Index: Integer; Value: Boolean );
begin
  TPacket( FPackets[ Index ] ).Enabled := Value;
end;


function TRzCheckListStrings.GetItemState( Index: Integer ): TCheckBoxState;
begin
  Result := TPacket( FPackets[ Index ] ).State;
end;


procedure TRzCheckListStrings.SetItemState( Index: Integer; Value: TCheckBoxState );
begin
  TPacket( FPackets[ Index ] ).State := Value;
end;


function TRzCheckListStrings.GetObject( Index: Integer ): TObject;
begin
  if FCheckList = nil then
  begin
    Result := nil;
    Exit;
  end;
  Result := TObject( SendMessage( FCheckList.Handle, lb_GetItemData, Index, 0 ) );

  if Longint( Result ) = lb_Err then
    raise EStringListError.Create( SListIndexError );
end;


procedure TRzCheckListStrings.PutObject( Index: Integer; AObject: TObject );
begin
  if FCheckList = nil then
    Exit;
  SendMessage( FCheckList.Handle, lb_SetItemData, Index, Longint( AObject ) );
end;


procedure TRzCheckListStrings.Move( CurIndex, NewIndex: Integer );
var
  CurState: TCheckBoxState;
  CurEnabled: Boolean;
begin
  if CurIndex <> NewIndex then
  begin
    CurState := ItemState[ CurIndex ];
    CurEnabled := ItemEnabled[ CurIndex ];
    inherited;
    ItemState[ NewIndex ] := CurState;
    ItemEnabled[ NewIndex ] := CurEnabled;
  end;
end;


procedure TRzCheckListStrings.Exchange( Index1, Index2: Integer );
var
  CurState1, CurState2: TCheckBoxState;
  CurEnabled1, CurEnabled2: Boolean;
begin
  if Index1 <> Index2 then
  begin
    BeginUpdate;
    try
      CurState1 := ItemState[ Index1 ];
      CurEnabled1 := ItemEnabled[ Index1 ];
      CurState2 := ItemState[ Index2 ];
      CurEnabled2 := ItemEnabled[ Index2 ];
      inherited;
      // Exchange the states
      ItemState[ Index1 ] := CurState2;
      ItemEnabled[ Index1 ] := CurEnabled2;
      ItemState[ Index2 ] := CurState1;
      ItemEnabled[ Index2 ] := CurEnabled1;
    finally
      EndUpdate;
    end;
  end;
end;


procedure TRzCheckListStrings.AddStrings( Strings: TStrings );
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Strings.Count - 1 do
    begin
      if Strings is TPacketStringList then
        AddObjectPacket( Strings[ I ], Strings.Objects[ I ],
                         TPacketStringList( Strings ).FPackets[ I ] )
      else if Strings is TRzCheckListStrings then
        AddObjectPacket( Strings[ I ], Strings.Objects[ I ],
                         TRzCheckListStrings( Strings ).FPackets[ I ] )
      else
        AddObject( Strings[ I ], Strings.Objects[ I ] );
    end;
  finally
    EndUpdate;
  end;
end;


function TRzCheckListStrings.AddObjectPacket( const S: string; AObject: TObject; APacket: TPacket ): Integer;
begin
  Result := AddObject( S, AObject );
  SetItemState( Result, APacket.State );
  SetItemEnabled( Result, APacket.Enabled );
end;


function CreateNewPacket: TPacket;
begin
  Result := TPacket.Create;
  Result.State := cbUnchecked;
  Result.Enabled := True;
end;

function TRzCheckListStrings.Add( const S: string ): Integer;
begin
  FCheckList.FChangingItems := True;
  try
    if FCheckList = nil then
    begin
      Result := lb_Err;
      Exit;
    end;
    Result := SendMessage( FCheckList.Handle, lb_AddString, 0, Longint( PChar( S ) ) );

    if Result < 0 then
      raise EOutOfResources.Create( SInsertLineError );

    FPackets.Insert( Result, CreateNewPacket );
  finally
    FCheckList.FChangingItems := False;
  end;
end;


procedure TRzCheckListStrings.Insert( Index: Integer; const S: string );
var
  LineNum: Integer;
begin
  if FCheckList = nil then
    Exit;

  FCheckList.FChangingItems := True;
  try
    LineNum := SendMessage( FCheckList.Handle, lb_InsertString, Index, Longint( PChar( S ) ) );

    if LineNum < 0 then
      raise EOutOfResources.Create( SInsertLineError );

    FPackets.Insert( Index, CreateNewPacket );
  finally
    FCheckList.FChangingItems := False;
  end;
end;


procedure TRzCheckListStrings.Delete( Index: Integer );
begin
  if FCheckList = nil then
    Exit;
  SendMessage( FCheckList.Handle, lb_DeleteString, Index, 0 );
  TPacket( FPackets[ Index ] ).Free;
  FPackets.Delete( Index );
end;


procedure TRzCheckListStrings.Clear;
var
  I: Integer;
begin
  if FCheckList = nil then
    Exit;
  SendMessage( FCheckList.Handle, lb_ResetContent, 0, 0 );
  for I := 0 to FPackets.Count - 1 do
    TPacket( FPackets[ I ] ).Free;
  FPackets.Clear;
end;


procedure TRzCheckListStrings.SetUpdateState(Updating: Boolean);
begin
  if FCheckList = nil then
    Exit;
  SendMessage( FCheckList.Handle, wm_SetRedraw, Ord(not Updating), 0 );
  if not Updating then
    FCheckList.Refresh;
end;


procedure TRzCheckListStrings.LoadFromStream( Stream: TStream );
var
  List: TStringList;
  I: Integer;
  E: Boolean;
  St: TCheckBoxState;
  S: string;
begin
  List := TStringList.Create;
  BeginUpdate;
  try
    Clear;
    List.LoadFromStream( Stream );

    for I := 0 to List.Count - 1 do
    begin
      S := List[ I ];
      if S[ 1 ] = '&' then
      begin
        // State Information stored in file
        E := S[ 2 ] = '1';
        St := TCheckBoxState( StrToInt( S[ 4 ] ) );

        System.Delete( S, 1, 5 ); // Delete state number

        Add( S );
        ItemEnabled[ I ] := E;
        ItemState[ I ] := St;
      end
      else
      begin
        Add( S );
      end;
    end;
  finally
    EndUpdate;
    List.Free;
  end;
end;


procedure TRzCheckListStrings.SaveToStream( Stream: TStream );
const
  EndOfLine = #13#10;
var
  I, E, St: Integer;
  S: string;
begin
  for I := 0 to Count - 1 do
  begin
    E := Ord( ItemEnabled[ I ] );
    St := Ord( ItemState[ I ] );

    S := Format( '&%d %d %s %s', [ E, St, Get( I ), EndOfLine ] );
    Stream.Write( Pointer( S )^, Length( S ) );
  end;
end;


{===============================}
{== TPacketStringList Methods ==}
{===============================}

constructor TPacketStringList.Create;
begin
  inherited;
  FPackets := TList.Create;
end;

destructor TPacketStringList.Destroy;
var
  I: Integer;
begin
  for I := 0 to FPackets.Count - 1 do
    TPacket( FPackets[ I ] ).Free;
  FPackets.Free;
  inherited;
end;


{$IFDEF VCL60_OR_HIGHER}

function TPacketStringList.AddObject( const S: string; AObject: TObject ): Integer;
begin
  Result := inherited AddObject( S, AObject );
  FPackets.Add( CreateNewPacket );
end;

{$ELSE}

function TPacketStringList.Add( const S: string ): Integer;
begin
  Result := inherited Add( S );
  FPackets.Add( CreateNewPacket );
end;

{$ENDIF}

procedure TPacketStringList.Clear;
var
  I: Integer;
begin
  inherited;
  for I := 0 to FPackets.Count - 1 do
    TPacket( FPackets[ I ] ).Free;
  FPackets.Clear;
end;

procedure TPacketStringList.AddStrings( Strings: TStrings );
var
  I: Integer;
begin
  BeginUpdate;
  try
    for I := 0 to Strings.Count - 1 do
    begin
      AddObjectPacket( Strings[ I ], Strings.Objects[ I ], TRzCheckListStrings( Strings ).FPackets[ I ] )
    end;
  finally
    EndUpdate;
  end;
end;


function TPacketStringList.AddObjectPacket( const S: string; AObject: TObject; APacket: TPacket ): Integer;
begin
  Result := AddObject( S, AObject );
  TPacket( FPackets[ Result ] ).State := APacket.State;
  TPacket( FPackets[ Result ] ).Enabled := APacket.Enabled;
end;


{&RUIF}
end.
