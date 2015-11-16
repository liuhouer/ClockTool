{===============================================================================
  RzRadGrp Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzRadioGroup         Mimics TRadioGroup but descends from TRzPanel and
                          provides more display options.
  TRzCheckGroup         Similar to TRzRadioGroup, but creates embedded check
                          boxes instead of radio buttons.


  Modification History
  ------------------------------------------------------------------------------
  3.0.10 (26 Dec 2003)
    * Fixed problem where OnClick and OnDblClick events were not getting fired
      by the TRzRadioGroup and TRzCheckGroup controls.
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Added MouseDown event dispatch method override to TRzGroupButton in order
      to trap mouse clicks if the control cannot be modified.  This is necessary
      when the radio group is a TRzDBRadioGroup and the corresponding dataset is
      not in edit mode (or cannot be placed into edit mode).
    * Added the FrameController property to both the TRzRadioGroup and the
      TRzCheckGroup. If the group has its GroupStyle property set to gsCustom,
      then the appearance of the group is controlled by the settings of the
      TRzFrameController. In addition, if the radio buttons/check boxes
      displayed within the group are set to HotTrack mode (i.e. flat), then the
      associated FrameController determines the coloring of the radio
      button/check box frames.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Surfaced the OnPaint event in TRzRadioGroup and TRzCheckGroup. This is
      useful when GroupStyle is set to gsCustom.
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * Fixed display problem when under Right-To-Left locales.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    << TRzCustomRadioGroup and TRzRadioGroup >>
    * ItemFont only streamed when changed from the default component font.
    * Added OnChanging event.  Developer can now prevent the user from changing
      the selected radio button.
    * Added a SpaceEvenly property. When set to True, the radio buttons
      contained in the group are spaced evenly across the width of the group
      box.  This behavior is similar to the way in which the standard
      TRadioGroup positions its buttons.
    * Other controls can now be dropped onto a TRzRadioGroup.
    * Added a FlatButtons property that controls the Flat properties of the
      embedded TRzRadioButtons.
    * Radio button alignment automatically switched when run under Right-To-Left
      locales.

    << TRzCustomCheckGroup and TRzCheckGroup >>
    * TRzCheckGroup component added.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzRadGrp;

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
  RzPanel,
  Menus,
  RzCommon,
  RzIntLst,
  ExtCtrls,
  RzRadChk;

type
  TRzIndexChangingEvent = procedure( Sender: TObject; NewIndex: Integer; var AllowChange: Boolean ) of object;

  TRzCustomRadioGroup = class( TRzCustomGroupBox )
  private
    FButtons: TList;
    FItemFont: TFont;
    FItemFontChanged: Boolean;
    FItems: TStrings;
    FItemIndex: Integer;
    FColumns: Integer;
    FReading: Boolean;
    FUpdating: Boolean;
    FSpaceEvenly: Boolean;
    FStartXPos: Integer;
    FStartYPos: Integer;
    FVerticalSpacing: Integer;
    FItemHeight: Integer;

    FGlyphWidth: Integer;
    FGlyphHeight: Integer;
    FNumStates: Integer;
    FCustomGlyphs: TBitmap;
    FUseCustomGlyphs: Boolean;
    FTransparentColor: TColor;
    FWinMaskColor: TColor;
    FLightTextStyle: Boolean;
    FTextStyle: TTextStyle;
    FTextHighlightColor: TColor;
    FTextShadowColor: TColor;
    FTextShadowDepth: Integer;
    FTabOnEnter: Boolean;

    FItemFrameColor: TColor;
    FItemHotTrack: Boolean;
    FItemHotTrackColor: TColor;
    FItemHotTrackColorType: TRzHotTrackColorType;
    FItemHighlightColor: TColor;

    FOnChanging: TRzIndexChangingEvent;

    procedure ReadOldFlatProp( Reader: TReader );

    { Internal Event Handlers }
    procedure ButtonClick( Sender: TObject );
    procedure ItemsChange( Sender: TObject );
    procedure ItemFontChanged( Sender: TObject );
    procedure CustomGlyphsChanged( Sender: TObject );

    { Message Handling Methods }
    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
    procedure WMSize( var Msg: TWMSize ); message wm_Size;
  protected
    procedure DefineProperties( Filer: TFiler ); override;

    procedure ChangeScale( M, D: Integer ); override;
    procedure SetButtonCount( Value: Integer ); virtual;
    procedure ArrangeButtons; virtual;
    procedure UpdateButtons; virtual;

    procedure ReadState( Reader: TReader ); override;
    function CanModify: Boolean; virtual;

    procedure CustomFramingChanged; override;

    { Event Dispatch Methods }
    procedure KeyPress( var Key: Char ); override;
    function CanChange( NewIndex: Integer ): Boolean; dynamic;

    { Property Access Methods }
    function GetButtons( Index: Integer ): TRzRadioButton; virtual;
    function GetCaption: TCaption; virtual;
    procedure SetCaption( const Value: TCaption ); virtual;
    procedure SetColumns( Value: Integer ); virtual;
    procedure SetCustomGlyphs( Value: TBitmap ); virtual;

    procedure SetItemFrameColor( Value: TColor ); virtual;
    procedure SetItemHotTrack( Value: Boolean ); virtual;
    procedure SetItemHotTrackColor( Value: TColor ); virtual;
    procedure SetItemHotTrackColorType( Value: TRzHotTrackColorType ); virtual;
    procedure SetItemHighlightColor( Value: TColor ); virtual;

    procedure SetGroupBoxStyle( Value: TRzGroupBoxStyle ); override;
    function GetItemEnabled( Index: Integer ): Boolean;
    procedure SetItemEnabled( Index: Integer; Value: Boolean );
    procedure SetItemFont( Value: TFont ); virtual;
    procedure SetItemHeight( Value: Integer ); virtual;
    procedure SetItemIndex( Value: Integer ); virtual;
    procedure SetItems( Value: TStrings ); virtual;
    procedure SetLightTextStyle( Value: Boolean ); virtual;

    procedure SetTextHighlightColor( Value: TColor ); virtual;
    procedure SetTextShadowColor( Value: TColor ); virtual;
    procedure SetTextShadowDepth( Value: Integer ); virtual;
    procedure SetSpaceEvenly( Value: Boolean ); virtual;
    procedure SetStartPos( Index: Integer; Value: Integer ); virtual;
    procedure SetTextStyle( Value: TTextStyle ); virtual;
    procedure SetVerticalSpacing( Value: Integer ); virtual;
    procedure SetTransparent( Value: Boolean ); override;
    procedure SetTransparentColor( Value: TColor ); virtual;
    procedure SetUseCustomGlyphs( Value: Boolean ); virtual;
    procedure SetWinMaskColor( Value: TColor ); virtual;

    { Property Declarations }
    property Buttons[ Index: Integer ]: TRzRadioButton
      read GetButtons;

    property Caption: TCaption
      read GetCaption
      write SetCaption;

    property Columns: Integer
      read FColumns
      write SetColumns
      default 1;

    property CustomGlyphs: TBitmap
      read FCustomGlyphs
      write SetCustomGlyphs;

    property ItemFrameColor: TColor
      read FItemFrameColor
      write SetItemFrameColor
      default clBtnShadow;
      
    property ItemHotTrack: Boolean
      read FItemHotTrack
      write SetItemHotTrack
      default False;

    property ItemHighlightColor: TColor
      read FItemHighlightColor
      write SetItemHighlightColor
      default clHighlight;

    property ItemHotTrackColor: TColor
      read FItemHotTrackColor
      write SetItemHotTrackColor
      default clHighlight;

    property ItemHotTrackColorType: TRzHotTrackColorType
      read FItemHotTrackColorType
      write SetItemHotTrackColorType
      default htctComplement;

    property ItemFont: TFont
      read FItemFont
      write SetItemFont
      stored FItemFontChanged;

    property ItemHeight: Integer
      read FItemHeight
      write SetItemHeight
      default 17;

    property ItemIndex: Integer
      read FItemIndex
      write SetItemIndex
      default -1;

    property ItemEnabled[ Index: Integer ]: Boolean
      read GetItemEnabled
      write SetItemEnabled;

    property Items: TStrings
      read FItems
      write SetItems;

    property LightTextStyle: Boolean
      read FLightTextStyle
      write SetLightTextStyle
      default False;

    property TextHighlightColor: TColor
      read FTextHighlightColor
      write SetTextHighlightColor
      default clBtnHighlight;

    property TextShadowColor: TColor
      read FTextShadowColor
      write SetTextShadowColor
      default clBtnShadow;

    property TextShadowDepth: Integer
      read FTextShadowDepth
      write SetTextShadowDepth
      default 2;

    property SpaceEvenly: Boolean
      read FSpaceEvenly
      write SetSpaceEvenly
      default False;

    property StartXPos: Integer
      index 1
      read FStartXPos
      write SetStartPos
      default 8;

    property StartYPos: Integer
      index 2
      read FStartYPos
      write SetStartPos
      default 2;

    property TabOnEnter: Boolean
      read FTabOnEnter
      write FTabOnEnter
      default False;

    property TextStyle: TTextStyle
      read FTextStyle
      write SetTextStyle
      default tsNormal;

    property TransparentColor: TColor
      read FTransparentColor
      write SetTransparentColor
      default clOlive;

    property UseCustomGlyphs: Boolean
      read FUseCustomGlyphs
      write SetUseCustomGlyphs
      default False;

    property VerticalSpacing: Integer
      read FVerticalSpacing
      write SetVerticalSpacing
      default 3;

    property WinMaskColor: TColor
      read FWinMaskColor
      write SetWinMaskColor
      default clTeal;

    property OnChanging: TRzIndexChangingEvent
      read FOnChanging
      write FOnChanging;

    { Inherited Properties & Events }
    property Alignment default taLeftJustify;
    property AlignmentVertical default avTop;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure FlipChildren( AllLevels: Boolean ); override;
  end;


  TRzRadioGroup = class( TRzCustomRadioGroup )
  private
    FAboutInfo: TRzAboutInfo;
  public
    property Buttons;
    property ItemEnabled;
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
    property Columns;
    property Constraints;
    property Ctl3D;
    property CustomGlyphs;
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
    property Hint;
    property ItemFrameColor;
    property ItemHotTrack;
    property ItemHighlightColor;
    property ItemHotTrackColor;
    property ItemHotTrackColorType;
    property ItemFont;
    property ItemHeight;
    property ItemIndex;
    property Items;
    property LightTextStyle;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property TextHighlightColor;
    property TextShadowColor;
    property TextShadowDepth;
    property ShowHint;
    property SpaceEvenly;
    property StartXPos;
    property StartYPos;
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property TextStyle;
    property ThemeAware;
    property Transparent;
    property TransparentColor;
    property UseCustomGlyphs;
    property VerticalSpacing;
    property Visible;
    property WinMaskColor;

    property OnChanging;
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
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;

  TRzStateChangingEvent = procedure( Sender: TObject; Index: Integer; NewState: TCheckBoxState;
                                     var AllowChange: Boolean ) of object;

  TRzCustomCheckGroup = class( TRzCustomGroupBox )
  private
    FChecks: TList;
    FItemFont: TFont;
    FItemFontChanged: Boolean;
    FItems: TStrings;
    FColumns: Integer;
    FReading: Boolean;
    FSpaceEvenly: Boolean;
    FStartXPos: Integer;
    FStartYPos: Integer;
    FVerticalSpacing: Integer;
    FItemHeight: Integer;

    FGlyphWidth: Integer;
    FGlyphHeight: Integer;
    FNumStates: Integer;
    FCustomGlyphs: TBitmap;
    FUseCustomGlyphs: Boolean;
    FTransparentColor: TColor;
    FWinMaskColor: TColor;
    FLightTextStyle: Boolean;
    FTextStyle: TTextStyle;
    FTextHighlightColor: TColor;
    FTextShadowColor: TColor;
    FTextShadowDepth: Integer;
    FTabOnEnter: Boolean;
    FAllowGrayed: Boolean;

    FItemFrameColor: TColor;
    FItemHotTrack: Boolean;
    FItemHotTrackColor: TColor;
    FItemHotTrackColorType: TRzHotTrackColorType;
    FItemHighlightColor: TColor;

    FItemStates: TRzIntegerList;

    FOnChange: TStateChangeEvent;

    procedure ReadCheckStates( Reader: TReader );
    procedure WriteCheckStates( Writer: TWriter );

    { Internal Event Handlers }
    procedure CheckClick( Sender: TObject );
    procedure ItemsChange( Sender: TObject );
    procedure ItemFontChanged( Sender: TObject );
    procedure CustomGlyphsChanged( Sender: TObject );

    { Message Handling Methods }
    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
    procedure WMSize( var Msg: TWMSize ); message wm_Size;
  protected
    procedure ChangeScale( M, D: Integer ); override;
    procedure SetCheckCount( Value: Integer ); virtual;
    procedure ArrangeChecks; virtual;
    procedure UpdateChecks; virtual;
    function GetIndex( CheckBox: TRzCheckBox ): Integer;

    procedure Loaded; override;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure ReadState( Reader: TReader ); override;
    function CanModify: Boolean; virtual;

    procedure CustomFramingChanged; override;

    { Event Dispatch Methods }
    procedure KeyPress( var Key: Char ); override;
    procedure Change( Index: Integer; NewState: TCheckBoxState ); dynamic;

    { Property Access Methods }
    function GetChecks( Index: Integer ): TRzCheckBox; virtual;

    procedure SetAllowGrayed( Value: Boolean ); virtual;
    function GetCaption: TCaption; virtual;
    procedure SetCaption( const Value: TCaption ); virtual;
    procedure SetColumns( Value: Integer ); virtual;
    procedure SetCustomGlyphs( Value: TBitmap ); virtual;
    procedure SetGroupBoxStyle( Value: TRzGroupBoxStyle ); override;
    procedure SetItemFrameColor( Value: TColor ); virtual;
    procedure SetItemHotTrack( Value: Boolean ); virtual;
    procedure SetItemHighlightColor( Value: TColor ); virtual;
    procedure SetItemHotTrackColor( Value: TColor ); virtual;
    procedure SetItemHotTrackColorType( Value: TRzHotTrackColorType ); virtual;
    function GetItemChecked( Index: Integer ): Boolean; virtual;
    procedure SetItemChecked( Index: Integer; Value: Boolean ); virtual;
    function GetItemEnabled( Index: Integer ): Boolean; virtual;
    procedure SetItemEnabled( Index: Integer; Value: Boolean ); virtual;
    procedure SetItemFont( Value: TFont ); virtual;
    procedure SetItemHeight( Value: Integer ); virtual;
    procedure SetItems( Value: TStrings ); virtual;
    function GetItemState( Index: Integer ): TCheckBoxState; virtual;
    procedure SetItemState( Index: Integer; Value: TCheckBoxState ); virtual;

    procedure SetLightTextStyle( Value: Boolean ); virtual;
    procedure SetTextHighlightColor( Value: TColor ); virtual;
    procedure SetTextShadowColor( Value: TColor ); virtual;
    procedure SetTextShadowDepth( Value: Integer ); virtual;
    procedure SetSpaceEvenly( Value: Boolean ); virtual;
    procedure SetStartPos( Index: Integer; Value: Integer ); virtual;
    procedure SetTextStyle( Value: TTextStyle ); virtual;
    procedure SetVerticalSpacing( Value: Integer ); virtual;
    procedure SetTransparent( Value: Boolean ); override;
    procedure SetTransparentColor( Value: TColor ); virtual;
    procedure SetUseCustomGlyphs( Value: Boolean ); virtual;
    procedure SetWinMaskColor( Value: TColor ); virtual;

    { Property Declarations }
    property AllowGrayed: Boolean
      read FAllowGrayed
      write SetAllowGrayed
      default False;

    property Checks[ Index: Integer ]: TRzCheckBox
      read GetChecks;

    property Caption: TCaption
      read GetCaption
      write SetCaption;

    property Columns: Integer
      read FColumns
      write SetColumns
      default 1;

    property CustomGlyphs: TBitmap
      read FCustomGlyphs
      write SetCustomGlyphs;

    property ItemFrameColor: TColor
      read FItemFrameColor
      write SetItemFrameColor
      default clBtnShadow;

    property ItemHotTrack: Boolean
      read FItemHotTrack
      write SetItemHotTrack
      default False;

    property ItemHighlightColor: TColor
      read FItemHighlightColor
      write SetItemHighlightColor
      default clHighlight;

    property ItemHotTrackColor: TColor
      read FItemHotTrackColor
      write SetItemHotTrackColor
      default clHighlight;

    property ItemHotTrackColorType: TRzHotTrackColorType
      read FItemHotTrackColorType
      write SetItemHotTrackColorType
      default htctComplement;

    property ItemFont: TFont
      read FItemFont
      write SetItemFont
      stored FItemFontChanged;

    property ItemHeight: Integer
      read FItemHeight
      write SetItemHeight
      default 17;

    property ItemChecked[ Index: Integer ]: Boolean
      read GetItemChecked
      write SetItemChecked;

    property ItemEnabled[ Index: Integer ]: Boolean
      read GetItemEnabled
      write SetItemEnabled;

    property ItemState[ Index: Integer ]: TCheckBoxState
      read GetItemState
      write SetItemState;

    property Items: TStrings
      read FItems
      write SetItems;

    property LightTextStyle: Boolean
      read FLightTextStyle
      write SetLightTextStyle
      default False;

    property TextHighlightColor: TColor
      read FTextHighlightColor
      write SetTextHighlightColor
      default clBtnHighlight;

    property TextShadowColor: TColor
      read FTextShadowColor
      write SetTextShadowColor
      default clBtnShadow;

    property TextShadowDepth: Integer
      read FTextShadowDepth
      write SetTextShadowDepth
      default 2;

    property SpaceEvenly: Boolean
      read FSpaceEvenly
      write SetSpaceEvenly
      default False;

    property StartXPos: Integer
      index 1
      read FStartXPos
      write SetStartPos
      default 8;

    property StartYPos: Integer
      index 2
      read FStartYPos
      write SetStartPos
      default 2;

    property TabOnEnter: Boolean
      read FTabOnEnter
      write FTabOnEnter
      default False;

    property TextStyle: TTextStyle
      read FTextStyle
      write SetTextStyle
      default tsNormal;

    property TransparentColor: TColor
      read FTransparentColor
      write SetTransparentColor
      default clOlive;

    property UseCustomGlyphs: Boolean
      read FUseCustomGlyphs
      write SetUseCustomGlyphs
      default False;

    property VerticalSpacing: Integer
      read FVerticalSpacing
      write SetVerticalSpacing
      default 3;

    property WinMaskColor: TColor
      read FWinMaskColor
      write SetWinMaskColor
      default clTeal;

    property OnChange: TStateChangeEvent
      read FOnChange
      write FOnChange;

    { Inherited Properties & Events }
    property Alignment default taLeftJustify;
    property AlignmentVertical default avTop;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure FlipChildren(AllLevels: Boolean); override;
  end;


  TRzCheckGroup = class( TRzCustomCheckGroup )
  private
    FAboutInfo: TRzAboutInfo;
  public
    property Checks;
    property ItemChecked;
    property ItemEnabled;
    property ItemState;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    { Inherited Properties & Events }
    property Align;
    property Alignment;
    property AllowGrayed;
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
    property Columns;
    property Constraints;
    property Ctl3D;
    property CustomGlyphs;
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
    property ItemFrameColor;
    property ItemHighlightColor;
    property ItemHotTrack;
    property ItemHotTrackColor;
    property ItemHotTrackColorType;
    property ItemFont;
    property ItemHeight;
    property Items;
    property LightTextStyle;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property TextHighlightColor;
    property TextShadowColor;
    property TextShadowDepth;
    property ShowHint;
    property SpaceEvenly;
    property StartXPos;
    property StartYPos;
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property TextStyle;
    property ThemeAware;
    property Transparent;
    property TransparentColor;
    property UseCustomGlyphs;
    property VerticalSpacing;
    property Visible;
    property WinMaskColor;

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
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnPaint;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
  end;


implementation

uses RzButton;


{===================================}
{== TRzGroupButton Internal Class ==}
{===================================}

type
  TRzGroupButton = class( TRzRadioButton )
  private
    FInClick: Boolean;
  protected
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure KeyPress( var Key: Char ); override;
  public
    constructor CreateInGroup( RadioGroup: TRzCustomRadioGroup );
    destructor Destroy; override;
  end;


constructor TRzGroupButton.CreateInGroup( RadioGroup: TRzCustomRadioGroup );
begin
  inherited Create( RadioGroup );

  RadioGroup.FButtons.Add( Self );
  Visible := False;
  Enabled := RadioGroup.Enabled;
  ParentShowHint := False;
  OnClick := RadioGroup.ButtonClick;
  Parent := RadioGroup;
  ParentFont := False;
end;


destructor TRzGroupButton.Destroy;
begin
  TRzCustomRadioGroup( Owner ).FButtons.Remove( Self );
  inherited;
end;


procedure TRzGroupButton.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  try
    if TRzCustomRadioGroup( Parent ).CanModify then
      inherited;
  except
    Application.HandleException( Self );
  end;
end;


procedure TRzGroupButton.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  if not FInClick then
  begin
    FInClick := True;
    try
      if TRzCustomRadioGroup( Parent ).CanModify then
        inherited;
    except
      Application.HandleException( Self );
    end;
    FInClick := False;
  end;
end;


procedure TRzGroupButton.KeyPress( var Key: Char );
begin
  inherited;
  TRzCustomRadioGroup( Parent ).KeyPress( Key );
  if ( Key = #8 ) or ( Key = ' ' ) then
  begin
    if not TRzCustomRadioGroup( Parent ).CanModify then
      Key := #0;
  end;
end;


procedure TRzGroupButton.KeyDown( var Key: Word; Shift: TShiftState );
begin
  inherited;
  TRzCustomRadioGroup( Parent ).KeyDown( Key, Shift );
end;

{&RT}
{=================================}
{== TRzCustomRadioGroup Methods ==}
{=================================}

constructor TRzCustomRadioGroup.Create( AOwner: TComponent );
begin
  inherited;
  ControlStyle := ControlStyle - [ csReplicatable ];
  FButtons := TList.Create;
  FItemFont := TFont.Create;
  FItemFont.Name := 'MS Sans Serif';
  FItemFont.Size := 8;
  FItemFont.OnChange := ItemFontChanged;
  FItems := TStringList.Create;
  TStringList( FItems ).OnChange := ItemsChange;
  FItemIndex := -1;
  FColumns := 1;
  FSpaceEvenly := False;
  FStartXPos := 8;
  FStartYPos := 2;
  FVerticalSpacing := 3;
  FItemHeight := 17;
  {&RCI}

  FGlyphWidth := 13;
  FGlyphHeight := 13;
  FItemFrameColor := clBtnShadow;
  FItemHotTrack := False;
  FItemHighlightColor := clHighlight;
  FItemHotTrackColor := clHighlight;
  FItemHotTrackColorType := htctComplement;

  FNumStates := 6;
  FCustomGlyphs := TBitmap.Create;
  FCustomGlyphs.OnChange := CustomGlyphsChanged;
  FUseCustomGlyphs := False;

  FLightTextStyle := False;
  FTextStyle := tsNormal;
  FTextShadowDepth := 2;
  FTextShadowColor := clBtnShadow;
  FTextHighlightColor := clBtnHighlight;

  FTransparentColor := clOlive;
  FWinMaskColor := clTeal;
  FTabOnEnter := False;
end;


destructor TRzCustomRadioGroup.Destroy;
begin
  FItemFont.Free;
  SetButtonCount( 0 );
  TStringList( FItems ).OnChange := nil;
  FItems.Free;
  FButtons.Free;
  FCustomGlyphs.Free;
  inherited;
end;


procedure TRzCustomRadioGroup.FlipChildren( AllLevels: Boolean );
begin
  // The radio buttons are flipped using BiDiMode
end;


procedure TRzCustomRadioGroup.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the Flat property was renamed to ItemHotTrack
  Filer.DefineProperty( 'Flat', ReadOldFlatProp, nil, False );
end;


procedure TRzCustomRadioGroup.ReadOldFlatProp( Reader: TReader );
begin
  ItemHotTrack := Reader.ReadBoolean;
end;


procedure TRzCustomRadioGroup.ButtonClick( Sender: TObject );
begin
  if not FUpdating then
  begin
    if CanChange( FButtons.IndexOf( Sender ) ) then
    begin
      FItemIndex := FButtons.IndexOf( Sender );
      Changed;
      Click;
    end
    else
    begin
      // Restore the previous ItemIndex selection
      FUpdating := True;
      try
        Buttons[ FItemIndex ].SetFocus;
      finally
        FUpdating := False;
      end;
    end;
  end;
end;


procedure TRzCustomRadioGroup.ItemsChange( Sender: TObject );
begin
  if not FReading then
  begin
    if FItemIndex >= FItems.Count then
      FItemIndex := FItems.Count - 1;
    UpdateButtons;
  end;
end;


procedure TRzCustomRadioGroup.ItemFontChanged( Sender: TObject );
begin
  FItemFontChanged := True;
  ArrangeButtons;
  Invalidate;
end;


procedure TRzCustomRadioGroup.CustomGlyphsChanged(Sender: TObject);
begin
  UseCustomGlyphs := True;                 { Invokes SetUseCustomGlyphs method }
  Invalidate;
end;


procedure TRzCustomRadioGroup.ReadState( Reader: TReader );
begin
  FReading := True;
  inherited;
  FReading := False;
  UpdateButtons;
end;


procedure TRzCustomRadioGroup.SetButtonCount( Value: Integer );
begin
  while FButtons.Count < Value do
    TRzGroupButton.CreateInGroup( Self );
  while FButtons.Count > Value do
    TRzGroupButton( FButtons.Last ).Free;
end;


function TRzCustomRadioGroup.GetButtons( Index: Integer ): TRzRadioButton;
begin
  Result := TRzRadioButton( FButtons[ Index ] );
end;

function TRzCustomRadioGroup.GetCaption: TCaption;
begin
  Result := inherited Caption;
end;


procedure TRzCustomRadioGroup.SetCaption( const Value: TCaption );
begin
  inherited Caption := Value;
  ArrangeButtons;
end;


procedure TRzCustomRadioGroup.SetColumns( Value: Integer );
begin
  if Value < 1 then
    Value := 1;
  if Value > 16 then
    Value := 16;
  if FColumns <> Value then
  begin
    FColumns := Value;
    ArrangeButtons;
    Invalidate;
  end;
end;


procedure TRzCustomRadioGroup.SetItemIndex( Value: Integer );
begin
  if FReading then
    FItemIndex := Value
  else
  begin
    if Value < -1 then
      Value := -1;
    if Value >= FButtons.Count then
      Value := FButtons.Count - 1;
    if FItemIndex <> Value then
    begin
      if FItemIndex >= 0 then
        TRzGroupButton( FButtons[ FItemIndex ] ).Checked := False;
      FItemIndex := Value;
      if FItemIndex >= 0 then
        TRzGroupButton( FButtons[ FItemIndex ] ).Checked := True;
    end;
  end;
end;


procedure TRzCustomRadioGroup.SetItems( Value: TStrings );
begin
  {&RV}
  FItems.Assign( Value );
end;


function TRzCustomRadioGroup.CanModify: Boolean;
begin
  Result := True;
end;


procedure TRzCustomRadioGroup.CustomFramingChanged;
var
  I: Integer;
begin
  if FFrameController.FrameVisible then
  begin
    if ( GroupStyle = gsCustom ) then
      inherited;
    ItemFrameColor := FFrameController.FrameColor;
    for I := 0 to FButtons.Count - 1 do
      Buttons[ I ].DisabledColor := FFrameController.DisabledColor;
  end;
end;


procedure TRzCustomRadioGroup.ArrangeButtons;
var
  ButtonsPerCol, ButtonWidth, TopMargin, I, K, X, W, L: Integer;
  Offset, TitleHeight: Integer;
  ColWidths: array[ 0..15 ] of Integer;
begin
  if ( FButtons.Count <> 0 ) and not FReading then
  begin
    ButtonsPerCol := ( FButtons.Count + FColumns - 1 ) div FColumns;

    if FSpaceEvenly then
      ButtonWidth := ( ( Width - FStartXPos ) - ( 2 * BorderWidth ) - 10 ) div FColumns
    else
      ButtonWidth := 0;

    TitleHeight := GetMinFontHeight( Font );

    if GroupStyle = gsStandard then
    begin
      if Caption <> '' then
        TopMargin := TitleHeight + FStartYPos
      else
        TopMargin := TitleHeight div 2 + 2 + FStartYPos;
    end
    else
    begin
      Offset := BorderWidth + 1;
      if BorderOuter in [ fsGroove..fsButtonUp ] then
        Inc( Offset, 2 );
      if BorderInner in [ fsGroove..fsButtonUp ] then
        Inc( Offset, 2 );
      if Caption <> '' then
        TopMargin := TitleHeight + Offset + FStartYPos
      else
        TopMargin := Offset + FStartYPos;
    end;


    if not FSpaceEvenly then
    begin
      for I := 0 to FColumns - 1 do
        ColWidths[ I ] := 0;

      Self.Canvas.Font := FItemFont;
      for I := 0 to FButtons.Count - 1 do
      begin
        with TRzGroupButton( FButtons[ I ] ) do
        begin
          W := Self.Canvas.TextWidth( Caption ) + FGlyphWidth + 4 + 8;
          if W > ColWidths[ I div ButtonsPerCol ] then
            ColWidths[ I div ButtonsPerCol ] := W;
        end;
      end;
    end;

    for I := 0 to FButtons.Count - 1 do
    begin
      with TRzGroupButton( FButtons[ I ] ) do
      begin
        if FSpaceEvenly then
        begin
          L := ( I div ButtonsPerCol ) * ButtonWidth + BorderWidth;
          if not UseRightToLeftAlignment then
            L := L + FStartXPos
          else
            L := Self.ClientWidth - L - ButtonWidth - FStartXPos;

          SetBounds( L, ( I mod ButtonsPerCol ) * ( FItemHeight + FVerticalSpacing ) + TopMargin,
                     ButtonWidth, FItemHeight );
        end
        else
        begin
          X := 0;
          for K := ( I div ButtonsPerCol ) - 1 downto 0 do
            X := X + ColWidths[ K ];

          L := X + BorderWidth;
          if not UseRightToLeftAlignment then
            L := L + FStartXPos
          else
            L := Self.ClientWidth - L - ColWidths[ I div ButtonsPerCol ] - 4 + 8 - FStartXPos;

          SetBounds( L, ( I mod ButtonsPerCol ) * ( FItemHeight + FVerticalSpacing ) + TopMargin,
                     ColWidths[ I div ButtonsPerCol ] - 4, FItemHeight );
        end;
        Visible := True;
        Font.Assign( FItemFont );
        BiDiMode := Self.BiDiMode;
        Alignment := GetControlsAlignment;
        TextHighlightColor := FTextHighlightColor;
        TextShadowColor := FTextShadowColor;
        TextShadowDepth := FTextShadowDepth;
        LightTextStyle := FLightTextStyle;
        TextStyle := FTextStyle;
        Transparent := Self.Transparent;
        WinMaskColor := FWinMaskColor;
        TransparentColor := FTransparentColor;
        CustomGlyphs.Assign( FCustomGlyphs );
        UseCustomGlyphs := FUseCustomGlyphs;
        FrameColor := FItemFrameColor;
        HotTrack := FItemHotTrack;
        HighlightColor := FItemHighlightColor;
        HotTrackColor := FItemHotTrackColor;
        HotTrackColorType := FItemHotTrackColorType;
      end;
    end;
  end;
end; {= TRzCustomRadioGroup.ArrangeButtons =}


procedure TRzCustomRadioGroup.UpdateButtons;
var
  I: Integer;
begin
  SetButtonCount( FItems.Count );
  for I := 0 to FButtons.Count - 1 do
    TRzGroupButton( FButtons[ I ] ).Caption := FItems[ I ];
  if FItemIndex >= 0 then
  begin
    FUpdating := True;
    TRzGroupButton( FButtons[ FItemIndex ] ).Checked := True;
    FUpdating := False;
  end;
  ArrangeButtons;
  Invalidate;
end;


procedure TRzCustomRadioGroup.SetCustomGlyphs( Value: TBitmap );
begin
  FCustomGlyphs.Assign( Value );
  ArrangeButtons;
end;



function TRzCustomRadioGroup.GetItemEnabled( Index: Integer ): Boolean;
begin
  Result := TRzRadioButton( FButtons[ Index ] ).Enabled;
end;

procedure TRzCustomRadioGroup.SetItemEnabled( Index: Integer; Value: Boolean );
begin
  TRzRadioButton( FButtons[ Index ] ).Enabled := Value;
end;


procedure TRzCustomRadioGroup.ChangeScale( M, D: Integer );
begin
  inherited;
  if FItemFontChanged then
    FItemFont.Size := MulDiv( FItemFont.Size, M, D );
  FVerticalSpacing := MulDiv( FVerticalSpacing, M, D );
  FItemHeight := MulDiv( FItemHeight, M, D );
  FStartYPos := MulDiv( FStartYPos, M, D );
  ArrangeButtons;
end;


procedure TRzCustomRadioGroup.SetItemFont( Value: TFont );
begin
  if FItemFont <> Value then
  begin
    FItemFont.Assign( Value );
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetItemHeight( Value: Integer );
begin
  if FItemHeight <> Value then
  begin
    FItemHeight := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetGroupBoxStyle( Value: TRzGroupBoxStyle );
begin
  inherited;
  ArrangeButtons;
  Invalidate;
end;


procedure TRzCustomRadioGroup.SetItemFrameColor( Value: TColor );
begin
  if FItemFrameColor <> Value then
  begin
    FItemFrameColor := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetItemHotTrack( Value: Boolean );
begin
  if FItemHotTrack <> Value then
  begin
    FItemHotTrack := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetItemHighlightColor( Value: TColor );
begin
  if FItemHighlightColor <> Value then
  begin
    FItemHighlightColor := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetItemHotTrackColor( Value: TColor );
begin
  if FItemHotTrackColor <> Value then
  begin
    FItemHotTrackColor := Value;
    ArrangeButtons;
  end;
end;

procedure TRzCustomRadioGroup.SetItemHotTrackColorType( Value: TRzHotTrackColorType );
begin
  if FItemHotTrackColorType <> Value then
  begin
    FItemHotTrackColorType := Value;
    ArrangeButtons;
  end;
end;



procedure TRzCustomRadioGroup.SetLightTextStyle( Value: Boolean );
begin
  if FLightTextStyle <> Value then
  begin
    FLightTextStyle := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetTextHighlightColor( Value: TColor );
begin
  if FTextHighlightColor <> Value then
  begin
    FTextHighlightColor := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetTextShadowColor( Value: TColor );
begin
  if FTextShadowColor <> Value then
  begin
    FTextShadowColor := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetTextShadowDepth( Value: Integer );
begin
  if FTextShadowDepth <> Value then
  begin
    FTextShadowDepth := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetSpaceEvenly( Value: Boolean );
begin
  if FSpaceEvenly <> Value then
  begin
    FSpaceEvenly := Value;
    ArrangeButtons;
  end;
end;

procedure TRzCustomRadioGroup.SetStartPos( Index: Integer; Value: Integer );
begin
  if Index = 1 then
  begin
    if FStartXPos <> Value then
    begin
      FStartXPos := Value;
      ArrangeButtons;
    end;
  end
  else
  begin
    if FStartYPos <> Value then
    begin
      FStartYPos := Value;
      ArrangeButtons;
    end;
  end;
end;


procedure TRzCustomRadioGroup.SetTextStyle( Value: TTextStyle );
begin
  if FTextStyle <> Value then
  begin
    FTextStyle := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetTransparent( Value: Boolean );
begin
  inherited;
  ArrangeButtons;
end;


procedure TRzCustomRadioGroup.SetTransparentColor( Value: TColor );
begin
  if FTransparentColor <> Value then
  begin
    FTransparentColor := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetUseCustomGlyphs( Value: Boolean );
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
      FGlyphWidth := 13;
      FGlyphHeight := 13;
    end;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetVerticalSpacing( Value: Integer );
begin
  if FVerticalSpacing <> Value then
  begin
    FVerticalSpacing := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.SetWinMaskColor( Value: TColor );
begin
  if FWinMaskColor <> Value then
  begin
    FWinMaskColor := Value;
    ArrangeButtons;
  end;
end;


procedure TRzCustomRadioGroup.CMDialogChar( var Msg: TCMDialogChar );
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


procedure TRzCustomRadioGroup.CMEnabledChanged( var Msg: TMessage );
var
  I: Integer;
begin
  inherited;
  Repaint;
  for I := 0 to FButtons.Count - 1 do
    TRzGroupButton( FButtons[ I ] ).Enabled := Enabled;
end;


procedure TRzCustomRadioGroup.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  if not FItemFontChanged then
  begin
    FItemFont.Assign( Self.Font );
    // Reset FItemFontChanged b/c internal handler has gotten called from above statements
    FItemFontChanged := False;
  end;
  Invalidate;
end;


procedure TRzCustomRadioGroup.WMSize( var Msg: TWMSize );
begin
  inherited;
  ArrangeButtons;
end;


procedure TRzCustomRadioGroup.KeyPress( var Key: Char );
begin
  if FTabOnEnter and ( Ord( Key ) = vk_Return ) then
  begin
    Key := #0;
    PostMessage( Handle, wm_KeyDown, vk_Tab, 0 );
  end
  else
    inherited;
end;


function TRzCustomRadioGroup.CanChange( NewIndex: Integer ): Boolean;
begin
  Result := True;
  if Assigned( FOnChanging ) then
    FOnChanging( Self, NewIndex, Result );
end;



{==================================}
{== TRzGroupCheck Internal Class ==}
{==================================}

type
  TRzGroupCheck = class( TRzCheckBox )
  private
    FInClick: Boolean;
  protected
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure KeyPress( var Key: Char ); override;
  public
    constructor CreateInGroup( CheckGroup: TRzCustomCheckGroup );
    destructor Destroy; override;
  end;


constructor TRzGroupCheck.CreateInGroup( CheckGroup: TRzCustomCheckGroup );
begin
  inherited Create( CheckGroup );

  CheckGroup.FChecks.Add( Self );
  Visible := False;
  Enabled := CheckGroup.Enabled;
  ParentShowHint := False;
  OnClick := CheckGroup.CheckClick;
  Parent := CheckGroup;
  ParentFont := False;
end;


destructor TRzGroupCheck.Destroy;
begin
  TRzCustomCheckGroup( Owner ).FChecks.Remove( Self );
  inherited;
end;


procedure TRzGroupCheck.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  if not FInClick then
  begin
    FInClick := True;
    try
      if TRzCustomCheckGroup( Parent ).CanModify then
        inherited;
    except
      Application.HandleException( Self );
    end;
    FInClick := False;
  end;
end;


procedure TRzGroupCheck.KeyPress( var Key: Char );
begin
  inherited;
  TRzCustomCheckGroup( Parent ).KeyPress( Key );
  if ( Key = #8 ) or ( Key = ' ' ) then
  begin
    if not TRzCustomCheckGroup( Parent ).CanModify then
      Key := #0;
  end;
end;


procedure TRzGroupCheck.KeyDown( var Key: Word; Shift: TShiftState );
begin
  inherited;
  TRzCustomCheckGroup( Parent ).KeyDown( Key, Shift );
end;


{=================================}
{== TRzCustomCheckGroup Methods ==}
{=================================}

constructor TRzCustomCheckGroup.Create( AOwner: TComponent );
begin
  inherited;
  ControlStyle := ControlStyle - [ csReplicatable ];
  FChecks := TList.Create;
  FItemFont := TFont.Create;
  FItemFont.Name := 'MS Sans Serif';
  FItemFont.Size := 8;
  FItemFont.OnChange := ItemFontChanged;
  FItems := TStringList.Create;
  TStringList( FItems ).OnChange := ItemsChange;
  FColumns := 1;
  FSpaceEvenly := False;
  FStartXPos := 8;
  FStartYPos := 2;
  FVerticalSpacing := 3;
  FItemHeight := 17;
  {&RCI}

  FItemStates := TRzIntegerList.Create;

  FGlyphWidth := 13;
  FGlyphHeight := 13;
  FItemFrameColor := clBtnShadow;
  FItemHotTrack := False;
  FItemHighlightColor := clHighlight;
  FItemHotTrackColor := clHighlight;
  FItemHotTrackColorType := htctComplement;

  FAllowGrayed := False;

  FNumStates := 6;
  FCustomGlyphs := TBitmap.Create;
  FCustomGlyphs.OnChange := CustomGlyphsChanged;
  FUseCustomGlyphs := False;

  FLightTextStyle := False;
  FTextStyle := tsNormal;
  FTextShadowDepth := 2;
  FTextShadowColor := clBtnShadow;
  FTextHighlightColor := clBtnHighlight;

  FTransparentColor := clOlive;
  FWinMaskColor := clTeal;
  FTabOnEnter := False;
end;


destructor TRzCustomCheckGroup.Destroy;
begin
  FItemFont.Free;
  SetCheckCount( 0 );
  TStringList( FItems ).OnChange := nil;
  FItems.Free;
  FChecks.Free;
  FCustomGlyphs.Free;
  FItemStates.Free;
  inherited;
end;


procedure TRzCustomCheckGroup.FlipChildren( AllLevels: Boolean );
begin
  // The check boxes are flipped using BiDiMode
end;


function TRzCustomCheckGroup.GetIndex( CheckBox: TRzCheckBox ): Integer;
begin
  Result := FChecks.IndexOf( CheckBox );
end;


procedure TRzCustomCheckGroup.CheckClick( Sender: TObject );
var
  CheckBox: TRzCheckBox;
begin
  CheckBox := TRzCheckBox( Sender );
  Change( GetIndex( CheckBox ), CheckBox.State );
end;


procedure TRzCustomCheckGroup.ItemsChange( Sender: TObject );
begin
  if not FReading then
    UpdateChecks;
end;


procedure TRzCustomCheckGroup.ItemFontChanged( Sender: TObject );
begin
  FItemFontChanged := True;
  ArrangeChecks;
  Invalidate;
end;


procedure TRzCustomCheckGroup.CustomGlyphsChanged(Sender: TObject);
begin
  UseCustomGlyphs := True;                 { Invokes SetUseCustomGlyphs method }
  Invalidate;
end;


procedure TRzCustomCheckGroup.ReadState( Reader: TReader );
begin
  FReading := True;
  inherited;
  FReading := False;
  UpdateChecks;
end;


procedure TRzCustomCheckGroup.Loaded;
var
  I: Integer;
begin
  inherited;
  for I := 0 to FItemStates.Count - 1 do
    ItemState[ I ] := TCheckBoxState( FItemStates[ I ] );
end;


procedure TRzCustomCheckGroup.DefineProperties( Filer: TFiler );
begin
  inherited;
  Filer.DefineProperty( 'CheckStates', ReadCheckStates, WriteCheckStates, FChecks.Count > 0 );
end;


procedure TRzCustomCheckGroup.ReadCheckStates( Reader: TReader );
begin
  Reader.ReadListBegin;
  FItemStates.Clear;
  while not Reader.EndOfList do
    FItemStates.Add( Reader.ReadInteger );
  Reader.ReadListEnd;
end;


procedure TRzCustomCheckGroup.WriteCheckStates( Writer: TWriter );
var
  I: Integer;
begin
  Writer.WriteListBegin;
  for I := 0 to FChecks.Count - 1 do
    Writer.WriteInteger( Ord( ItemState[ I ] ) );
  Writer.WriteListEnd;
end;


procedure TRzCustomCheckGroup.SetCheckCount( Value: Integer );
begin
  while FChecks.Count < Value do
    TRzGroupCheck.CreateInGroup( Self );
  while FChecks.Count > Value do
    TRzGroupCheck( FChecks.Last ).Free;
end;


function TRzCustomCheckGroup.GetChecks( Index: Integer ): TRzCheckBox;
begin
  Result := TRzCheckBox( FChecks[ Index ] );
end;

function TRzCustomCheckGroup.GetCaption: TCaption;
begin
  Result := inherited Caption;
end;


procedure TRzCustomCheckGroup.SetCaption( const Value: TCaption );
begin
  inherited Caption := Value;
  ArrangeChecks;
end;


procedure TRzCustomCheckGroup.SetColumns( Value: Integer );
begin
  if Value < 1 then
    Value := 1;
  if Value > 16 then
    Value := 16;
  if FColumns <> Value then
  begin
    FColumns := Value;
    ArrangeChecks;
    Invalidate;
  end;
end;


procedure TRzCustomCheckGroup.SetItems( Value: TStrings );
begin
  {&RV}
  FItems.Assign( Value );
end;


function TRzCustomCheckGroup.CanModify: Boolean;
begin
  Result := True;
end;


procedure TRzCustomCheckGroup.CustomFramingChanged;
var
  I: Integer;
begin
  if FFrameController.FrameVisible then
  begin
    if ( GroupStyle = gsCustom ) then
      inherited;
    ItemFrameColor := FFrameController.FrameColor;
    for I := 0 to FChecks.Count - 1 do
      Checks[ I ].DisabledColor := FFrameController.DisabledColor;
  end;
end;


procedure TRzCustomCheckGroup.ArrangeChecks;
var
  ChecksPerCol, CheckWidth, TopMargin, I, K, X, W, L: Integer;
  Offset, TitleHeight: Integer;
  ColWidths: array[ 0..15 ] of Integer;
begin
  if ( FChecks.Count <> 0 ) and not FReading then
  begin
    ChecksPerCol := ( FChecks.Count + FColumns - 1 ) div FColumns;

    if FSpaceEvenly then
      CheckWidth := ( ( Width - FStartXPos ) - ( 2 * BorderWidth ) - 10 ) div FColumns
    else
      CheckWidth := 0;

    TitleHeight := GetMinFontHeight( Font );

    if GroupStyle = gsStandard then
    begin
      if Caption <> '' then
        TopMargin := TitleHeight + FStartYPos
      else
        TopMargin := TitleHeight div 2 + 2 + FStartYPos;
    end
    else
    begin
      Offset := BorderWidth + 1;
      if BorderOuter in [ fsGroove..fsButtonUp ] then
        Inc( Offset, 2 );
      if BorderInner in [ fsGroove..fsButtonUp ] then
        Inc( Offset, 2 );
      if Caption <> '' then
        TopMargin := TitleHeight + Offset + FStartYPos
      else
        TopMargin := Offset + FStartYPos;
    end;


    if not FSpaceEvenly then
    begin
      for I := 0 to FColumns - 1 do
        ColWidths[ I ] := 0;

      Self.Canvas.Font := FItemFont;
      for I := 0 to FChecks.Count - 1 do
      begin
        with TRzGroupCheck( FChecks[ I ] ) do
        begin
          W := Self.Canvas.TextWidth( Caption ) + FGlyphWidth + 4 + 8;
          if W > ColWidths[ I div ChecksPerCol ] then
            ColWidths[ I div ChecksPerCol ] := W;
        end;
      end;
    end;

    for I := 0 to FChecks.Count - 1 do
    begin
      with TRzGroupCheck( FChecks[ I ] ) do
      begin
        if FSpaceEvenly then
        begin
          L := ( I div ChecksPerCol ) * CheckWidth + BorderWidth;
          if not UseRightToLeftAlignment then
            L := L + FStartXPos
          else
            L := Self.ClientWidth - L - CheckWidth - FStartXPos;

          SetBounds( L, ( I mod ChecksPerCol ) * ( FItemHeight + FVerticalSpacing ) + TopMargin,
                     CheckWidth, FItemHeight );
        end
        else
        begin
          X := 0;
          for K := ( I div ChecksPerCol ) - 1 downto 0 do
            X := X + ColWidths[ K ];

          L := X + BorderWidth;
          if not UseRightToLeftAlignment then
            L := L + FStartXPos
          else
            L := Self.ClientWidth - L - ColWidths[ I div ChecksPerCol ] - 4 + 8 - FStartXPos;

          SetBounds( L, ( I mod ChecksPerCol ) * ( FItemHeight + FVerticalSpacing ) + TopMargin,
                     ColWidths[ I div ChecksPerCol ] - 4, FItemHeight );
        end;

        Visible := True;
        Font.Assign( FItemFont );
        BiDiMode := Self.BiDiMode;
        Alignment := GetControlsAlignment;
        TextHighlightColor := FTextHighlightColor;
        TextShadowColor := FTextShadowColor;
        TextShadowDepth := FTextShadowDepth;
        LightTextStyle := FLightTextStyle;
        TextStyle := FTextStyle;
        Transparent := Self.Transparent;
        WinMaskColor := FWinMaskColor;
        TransparentColor := FTransparentColor;
        CustomGlyphs.Assign( FCustomGlyphs );
        UseCustomGlyphs := FUseCustomGlyphs;
        FrameColor := FItemFrameColor;
        HotTrack := FItemHotTrack;
        HighlightColor := FItemHighlightColor;
        HotTrackColor := FItemHotTrackColor;
        HotTrackColorType := FItemHotTrackColorType;
        AllowGrayed := FAllowGrayed;
      end;
    end;
  end;
end; {= TRzCustomCheckGroup.ArrangeChecks =}


procedure TRzCustomCheckGroup.UpdateChecks;
var
  I: Integer;
begin
  SetCheckCount( FItems.Count );
  for I := 0 to FChecks.Count - 1 do
    TRzGroupCheck( FChecks[ I ] ).Caption := FItems[ I ];

  ArrangeChecks;
  Invalidate;
end;



procedure TRzCustomCheckGroup.SetAllowGrayed( Value: Boolean );
begin
  if FAllowGrayed <> Value then
  begin
    FAllowGrayed := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetCustomGlyphs( Value: TBitmap );
begin
  FCustomGlyphs.Assign( Value );
  ArrangeChecks;
end;


procedure TRzCustomCheckGroup.SetItemFrameColor( Value: TColor );
begin
  if FItemFrameColor <> Value then
  begin
    FItemFrameColor := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetItemHotTrack( Value: Boolean );
begin
  if FItemHotTrack <> Value then
  begin
    FItemHotTrack := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetItemHighlightColor( Value: TColor );
begin
  if FItemHighlightColor <> Value then
  begin
    FItemHighlightColor := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetItemHotTrackColor( Value: TColor );
begin
  if FItemHotTrackColor <> Value then
  begin
    FItemHotTrackColor := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetItemHotTrackColorType( Value: TRzHotTrackColorType );
begin
  if FItemHotTrackColorType <> Value then
  begin
    FItemHotTrackColorType := Value;
    ArrangeChecks;
  end;
end;


function TRzCustomCheckGroup.GetItemChecked( Index: Integer ): Boolean;
begin
  Result := TRzCheckBox( FChecks[ Index ] ).Checked;
end;


procedure TRzCustomCheckGroup.SetItemChecked( Index: Integer; Value: Boolean );
begin
  TRzCheckBox( FChecks[ Index ] ).Checked := Value;
end;


function TRzCustomCheckGroup.GetItemEnabled( Index: Integer ): Boolean;
begin
  Result := TRzCheckBox( FChecks[ Index ] ).Enabled;
end;


procedure TRzCustomCheckGroup.SetItemEnabled( Index: Integer; Value: Boolean );
begin
  TRzCheckBox( FChecks[ Index ] ).Enabled := Value;
end;


function TRzCustomCheckGroup.GetItemState( Index: Integer ): TCheckBoxState;
begin
  Result := TRzCheckBox( FChecks[ Index ] ).State;
end;


procedure TRzCustomCheckGroup.SetItemState( Index: Integer; Value: TCheckBoxState );
begin
  TRzCheckBox( FChecks[ Index ] ).State := Value;
end;


procedure TRzCustomCheckGroup.ChangeScale( M, D: Integer );
begin
  inherited;
  if FItemFontChanged then
    FItemFont.Size := MulDiv( FItemFont.Size, M, D );
  FVerticalSpacing := MulDiv( FVerticalSpacing, M, D );
  FItemHeight := MulDiv( FItemHeight, M, D );
  FStartYPos := MulDiv( FStartYPos, M, D );
  ArrangeChecks;
end;


procedure TRzCustomCheckGroup.SetItemFont( Value: TFont );
begin
  if FItemFont <> Value then
  begin
    FItemFont.Assign( Value );
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetItemHeight( Value: Integer );
begin
  if FItemHeight <> Value then
  begin
    FItemHeight := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetGroupBoxStyle( Value: TRzGroupBoxStyle );
begin
  inherited;
  ArrangeChecks;
  Invalidate;
end;


procedure TRzCustomCheckGroup.SetLightTextStyle( Value: Boolean );
begin
  if FLightTextStyle <> Value then
  begin
    FLightTextStyle := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetTextHighlightColor( Value: TColor );
begin
  if FTextHighlightColor <> Value then
  begin
    FTextHighlightColor := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetTextShadowColor( Value: TColor );
begin
  if FTextShadowColor <> Value then
  begin
    FTextShadowColor := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetTextShadowDepth( Value: Integer );
begin
  if FTextShadowDepth <> Value then
  begin
    FTextShadowDepth := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetSpaceEvenly( Value: Boolean );
begin
  if FSpaceEvenly <> Value then
  begin
    FSpaceEvenly := Value;
    ArrangeChecks;
  end;
end;

procedure TRzCustomCheckGroup.SetStartPos( Index: Integer; Value: Integer );
begin
  if Index = 1 then
  begin
    if FStartXPos <> Value then
    begin
      FStartXPos := Value;
      ArrangeChecks;
    end;
  end
  else
  begin
    if FStartYPos <> Value then
    begin
      FStartYPos := Value;
      ArrangeChecks;
    end;
  end;
end;


procedure TRzCustomCheckGroup.SetTextStyle( Value: TTextStyle );
begin
  if FTextStyle <> Value then
  begin
    FTextStyle := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetTransparent( Value: Boolean );
begin
  inherited;
  ArrangeChecks;
end;


procedure TRzCustomCheckGroup.SetTransparentColor( Value: TColor );
begin
  if FTransparentColor <> Value then
  begin
    FTransparentColor := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetUseCustomGlyphs( Value: Boolean );
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
      FGlyphWidth := 13;
      FGlyphHeight := 13;
    end;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetVerticalSpacing( Value: Integer );
begin
  if FVerticalSpacing <> Value then
  begin
    FVerticalSpacing := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.SetWinMaskColor( Value: TColor );
begin
  if FWinMaskColor <> Value then
  begin
    FWinMaskColor := Value;
    ArrangeChecks;
  end;
end;


procedure TRzCustomCheckGroup.CMDialogChar( var Msg: TCMDialogChar );
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


procedure TRzCustomCheckGroup.CMEnabledChanged( var Msg: TMessage );
var
  I: Integer;
begin
  inherited;
  Repaint;
  for I := 0 to FChecks.Count - 1 do
    TRzGroupCheck( FChecks[ I ] ).Enabled := Enabled;
end;


procedure TRzCustomCheckGroup.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  if not FItemFontChanged then
  begin
    FItemFont.Assign( Self.Font );
    // Reset FItemFontChanged b/c internal handler has gotten called from above statements
    FItemFontChanged := False;
  end;
  Invalidate;
end;


procedure TRzCustomCheckGroup.WMSize( var Msg: TWMSize );
begin
  inherited;
  ArrangeChecks;
end;


procedure TRzCustomCheckGroup.KeyPress( var Key: Char );
begin
  if FTabOnEnter and ( Ord( Key ) = vk_Return ) then
  begin
    Key := #0;
    PostMessage( Handle, wm_KeyDown, vk_Tab, 0 );
  end
  else
    inherited;
end;


procedure TRzCustomCheckGroup.Change( Index: Integer; NewState: TCheckBoxState );
begin
  if Assigned( FOnChange ) then
    FOnChange( Self, Index, NewState );
end;


{&RUIF}
end.
