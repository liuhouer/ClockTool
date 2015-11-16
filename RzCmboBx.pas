{===============================================================================
  RzCmboBx Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzComboBox           Raize Combo Box.  Provides incremental keyboard
                          searching, AutoComplete, and Custom Framing.
  TRzColorComboBox      Drop-down list populated with color values
                          (incl. System Colors)
  TRzFontComboBox       Select fonts from drop-down list.
  TRzMRUComboBox        Component automatically manages Most Recently Used
                          items.
  TRzImageComboBox      Images can be displayed next to each item.  Items can
                          also be indented.

  NOTE:
  wm_NCPaint processing used in other controls to draw the frame does not work
  on combo boxes. The actual border is drawn in the default wm_Paint handler.


  Modification History
  ------------------------------------------------------------------------------
  3.0.10 (26 Dec 2003)
    * Fixed problem where inserting MBCS characters in the middle of the text in
      the combo box would result in incorrect characters being displayed.
    * Fixed problem where changing ParentColor to True in a control using Custom
      Framing did not reset internal color fields used to manage the color of
      the control at various states.
    * The TRzImageComboBox now allows keyboard access under all versions of
      Windows except Windows NT 4.0.
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Fixed problem where OnSelEndOK was not fired when user selects an item
      from a TRzComboBox by pressing Enter.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Fixed problem where AutoDropDown functionality was not working.
  ------------------------------------------------------------------------------
  3.0.5  (24 Mar 2003)
    * Fixed problem where Alt+F4 would not exit app if focus was in a
      TRzComboBox with its ReadOnly property set to True.
    * Fixed problem where it was possible to type in characters into a ReadOnly
      combo box.
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * Made IndexOf virtual. Overrode IndexOf in TRzCustomImageComboBox to
      correctly search for matching caption.
    * Fixed problem where items in the list could not be moved or exchanged
      without raising an exception.
    * Added Delete method to TRzCustomImageComboBox, which should be used to
      manually delete an item from the list.  This will cause the associated
      object to be freed.
    * Added MruRegIniFile property to TRzMRUComboBox. This property should be
      used instead of MRUPath.  MRUPath is still provided for
      backward-compatibility.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Added IsColorStored and IsFocusColorStored methods so that if control is
      disabled at design-time the Color and FocusColor properties are not
      streamed with the disabled color value.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    << TRzCustomComboBox and TRzComboBox >>
    * Renamed FrameFlat property to FrameHotTrack.
    * Renamed FrameFocusStyle property to FrameHotStyle.
    * Removed FrameFlatStyle property.
    * Add FocusColor and DisabledColor properties.
    * AutoComplete now works correctly under Multi-Byte Character Systems.
    * Fixed problem where an item that was the same as another item except in a
      different case could not be selected.
    * Added AutoComplete property.  This will allow a user to disable the
      auto-complete feature of the combo box.  Also added the ForceText method,
      which turns off AutoComplete, sets the text and then turns on
      AutoComplete.
    * Fixed problem where mouse wheel may not always scroll up to the top of the
      list.
    * When the combo box is csDropDownList and the user presses the Escape key
      while the List is down, the list only closes and does not put the first
      item in the list into the text area.
    * ComboBox button style has been updated.
    * Added the KeepSearchCase property.  This property controls whether or not
      the case of the search string the user types in is maintained as matches
      are found.
    * Fixed problem where moving the mouse over the edit portion of the combo
      box caused the selected item in the list to be displayed in the edit
      portion.  This problem occurred when the FrameFlat (now called
      FrameHotTrack) property was set to True.
    * Added XP visual style support in drawing of buttons during Custom Framing.

    << TRzFontCombobox >>
    * Added a ShowSymbolFonts property.
    * Added a new ShowStyle called ssFontPreview. When this style is selected,
      when the user drops the list of fonts down, a preview window is displayed
      that shows a sample string formatted in the selected font.  This effect is
      similar to the one used in CorelDRAW when selecting fonts. The size of the
      preview window can be changed with the PreviewWidth and PreviewHeight
      properties. The sample text displayed can be changed using the PreviewText
      property, or by specifying the PreviewEdit property. When the PreviewEdit
      property is set to a valid TCustomEdit and there the user has selected
      some text in the edit control, the selected text is used as the preview
      text.
    * The TRzFontComboBox now maintains the most recently used fonts selected by
      the user.  As the user selects a font, the font is added to the top of the
      list.  If the font is already in the MRU section, then it is moved to the
      top of the list when selected.

    << TRzColorComboBox >>
    * The LoadCustomColors and SaveCustomColors methods have been changed.
      Instead of passing the path to the registry key of where to store the
      custom colors, the TRzColorComboBox needs to be linked to a TRzRegIniFile
      component to handle saving the information off to either an INI file
      or the Registry.

    * TRzImageComboBox component added.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzCmboBx;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Messages,
  Windows,
  Classes,
  Forms,
  Graphics,
  Controls,
  StdCtrls,
  Menus,
  ExtCtrls,
  RzCommon,
  Dialogs,
  ImgList;

const
  MaxStdColors = 16;
  MaxSysColors = 25;

type
  {=========================================}
  {== TRzCustomComboBox Class Declaration ==}
  {=========================================}

  TRzDeleteComboItemEvent = procedure( Sender: TObject; Item: Pointer ) of object;

  TRzCustomComboBox = class( TCustomComboBox )
  private
    FAutoComplete: Boolean;
    FAllowEdit: Boolean;
    FBeepOnInvalidKey: Boolean;
    FFlatButtons: Boolean;
    FFlatButtonColor: TColor;
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
    FKeepSearchCase: Boolean;
    FSearchString: string;
    FSaveDropWidth: Integer;
    FDropDownWidth: Integer;
    FKeyCount: Integer;
    FTimer: TTimer;
    FTabOnEnter: Boolean;
    FTyping: Boolean;
    FClosingByEscape: Boolean;
    FEnterPressed: Boolean;
    FReadOnly: Boolean;
    FSysKeyDown: Boolean;

    FOnDeleteItem: TRzDeleteComboItemEvent;
    {$IFNDEF VCL60_OR_HIGHER}
    FOnCloseUp: TNotifyEvent;
    {$ENDIF}
    FOnMatch: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnNotInList: TNotifyEvent;
    FOnSelEndCancel: TNotifyEvent;
    FOnSelEndOk: TNotifyEvent;

    procedure ReadOldFrameFlatProp( Reader: TReader );
    procedure ReadOldFrameFocusStyleProp( Reader: TReader );

    procedure SetItemHeight2( Value: Integer );

    { Message Handling Methods }
    procedure WMKeyDown( var Msg: TWMKeyDown ); message wm_KeyDown;
    procedure WMCut( var Msg: TMessage ); message wm_Cut;
    procedure WMPaste( var Msg: TMessage ); message wm_Paste;
    procedure WMKillFocus( var Msg: TWMKillFocus ); message wm_KillFocus;
    procedure CNCommand( var Msg: TWMCommand ); message cn_Command;
    procedure CNDrawItem( var Msg: TWMDrawItem ); message cn_DrawItem;
    procedure CMTextChanged( var Msg: TMessage ); message cm_TextChanged;
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure WMPaint( var Msg: TWMPaint ); message wm_Paint;
    procedure CMEnter( var Msg: TCMEnter ); message cm_Enter;
    procedure CMExit( var Msg: TCMExit ); message cm_Exit;
    procedure CMMouseEnter( var Msg: TMessage ); message cm_MouseEnter;
    procedure CMMouseLeave( var Msg: TMessage ); message cm_MouseLeave;
    procedure WMSize( var Msg: TWMSize ); message wm_Size;
    procedure WMDeleteItem( var Msg: TWMDeleteItem ); message wm_DeleteItem;
    procedure WMLButtonDown( var Msg: TWMLButtonDown ); message wm_LButtonDown;
    procedure WMLButtonDblClick( var Msg: TWMLButtonDblClk ); message wm_LButtonDblClk;
    procedure CMParentColorChanged( var Msg: TMessage ); message cm_ParentColorChanged;
  protected
    FAboutInfo: TRzAboutInfo;
    FCanvas: TCanvas;
    FInControl: Boolean;
    FOverControl: Boolean;
    FShowFocus: Boolean;
    FIsFocused: Boolean;

    procedure CreateWnd; override;
    procedure DestroyWnd; override;

    procedure DefineProperties( Filer: TFiler ); override;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    procedure UpdateColors; virtual;
    procedure UpdateFrame( ViaMouse, InFocus: Boolean ); virtual;

    procedure InvalidKeyPressed; virtual;
    procedure SearchTimerExpired( Sender: TObject );

    procedure UpdateIndex( const FindStr: string; Msg: TWMChar ); virtual;
    function FindListItem( const FindStr: string; Msg: TMessage ): Boolean; virtual;
    function FindClosest( const S: string ): Integer; virtual;
    procedure ComboWndProc( var Msg: TMessage; ComboWnd: HWnd; ComboProc: Pointer ); override;

    procedure WndProc( var Msg: TMessage ); override;
    procedure UpdateSearchStr;

    { Event Dispatch Methods }
    {$IFDEF VCL60_OR_HIGHER}
    procedure CloseUp; override;
    {$ELSE}
    procedure CloseUp; dynamic;
    {$ENDIF}
    procedure KeyPress( var Key: Char ); override;
    procedure Match; dynamic;
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;
    procedure NotInList; dynamic;

    function DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean; override;
    function DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean; override;

    procedure DeleteItem( Item: Pointer ); virtual;
    procedure SelEndCancel; dynamic;
    procedure SelEndOk; dynamic;

    { Property Access Methods }
    function GetColor: TColor; virtual;
    procedure SetColor( Value: TColor ); virtual;
    procedure SetFlatButtons( Value: Boolean ); virtual;
    procedure SetFlatButtonColor( Value: TColor ); virtual;
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

    procedure SetDropDownWidth( Value: Integer ); virtual;
    procedure SetReadOnly( Value: Boolean ); virtual;

    { Property Declarations }
    property AllowEdit: Boolean
      read FAllowEdit
      write FAllowEdit
      default True;

    property AutoComplete: Boolean
      read FAutoComplete
      write FAutoComplete
      default True;

    property Color: TColor
      read GetColor
      write SetColor
      stored IsColorStored
      default clWindow;

    property FlatButtonColor: TColor
      read FFlatButtonColor
      write SetFlatButtonColor
      stored NotUsingController
      default clBtnFace;

    property FlatButtons: Boolean
      read FFlatButtons
      write SetFlatButtons
      stored NotUsingController
      default False;

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

    property KeepSearchCase: Boolean
      read FKeepSearchCase
      write FKeepSearchCase
      default False;

    property TabOnEnter: Boolean
      read FTabOnEnter
      write FTabOnEnter
      default False;

    (*
    // Do not surface control canvas property b/c interfers with w/ existing
    // canvas, which is used for owner-draw drawing in descendant components

    property Canvas: TCanvas
      read FCanvas;
    *)

    property DropDownWidth: Integer
      read FDropDownWidth
      write SetDropDownWidth
      default 0;

    property ReadOnly: Boolean
      read FReadOnly
      write SetReadOnly
      default False;

    {$IFNDEF VCL60_OR_HIGHER}
    property OnCloseUp: TNotifyEvent
      read FOnCloseUp
      write FOnCloseUp;
    {$ENDIF}

    property OnDeleteItem: TRzDeleteComboItemEvent
      read FOnDeleteItem
      write FOnDeleteItem;

    property OnMatch: TNotifyEvent
      read FOnMatch
      write FOnMatch;

    property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter
      write FOnMouseEnter;

    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave
      write FOnMouseLeave;

    property OnNotInList: TNotifyEvent
      read FOnNotInList
      write FOnNotInList;

    property OnSelEndCancel: TNotifyEvent
      read FOnSelEndCancel
      write FOnSelEndCancel;

    property OnSelEndOk: TNotifyEvent
      read FOnSelEndOk
      write FOnSelEndOk;

    property ItemHeight
      write SetItemHeight2;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function UseThemes: Boolean; virtual;
    function Focused: Boolean; override;

    procedure ForceText( const Value: string ); virtual;

    { Wrapper methods arounds Items object }
    function Add( const S: string ): Integer;
    function AddObject( const S: string; AObject: TObject ): Integer;
    procedure ClearSearchString;
    procedure Delete( Index: Integer );
    procedure ClearItems;
    function IndexOf( const S: string ): Integer; virtual;
    procedure Insert( Index: Integer; const S: string );
    procedure InsertObject( Index: Integer; const S: string; AObject: TObject );
    function Count: Integer;
    function FindItem( const S: string ): Boolean;
    function FindClosestItem( const S: string ): Boolean;

    property BeepOnInvalidKey: Boolean
      read FBeepOnInvalidKey
      write FBeepOnInvalidKey
      default True;

    property SearchString: string
      read FSearchString;
  end;


  {===================================}
  {== TRzComboBox Class Declaration ==}
  {===================================}

  TRzComboBox = class( TRzCustomComboBox )
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Align;
    property AllowEdit;
    property Anchors;
    property AutoComplete;
    {$IFDEF VCL70_OR_HIGHER}
    property AutoCloseUp;
    {$ENDIF}
    {$IFDEF VCL60_OR_HIGHER}
    property AutoDropDown;
    {$ENDIF}
    property BeepOnInvalidKey;
    property BiDiMode;
    property Style;                           { Must be published before Items }
    {$IFDEF VCL60_OR_HIGHER}
    property CharCase;
    {$ENDIF}
    property Color;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownWidth;
    property Enabled;
    property Font;
    property FlatButtonColor;
    property FlatButtons;
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
    property KeepSearchCase;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Sorted;
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;

    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnContextPopup;
    property OnDblClick;
    property OnDeleteItem;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMatch;
    property OnMeasureItem;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
    property OnNotInList;
    {$IFDEF VCL60_OR_HIGHER}
    property OnSelect;
    {$ENDIF}
    property OnSelEndCancel;
    property OnSelEndOk;
    property OnStartDock;
    property OnStartDrag;

    property Items; { Must be published after OnMeasureItem }
    property ItemIndex default -1;
  end;


  TRzColorComboBox = class;

  {=====================================}
  {== TRzColorNames Class Declaration ==}
  {=====================================}

  TRzColorNames = class( TPersistent )
  private
    FComboBox: TRzColorComboBox;
    FDefaultColor: string;
    FCustomColor: string;
    FStdColors: array[ 0..MaxStdColors - 1 ] of string;
    FSysColors: array[ 0..MaxSysColors - 1 ] of string;
  protected
    procedure SetDefaultColor( const Value: string );
    function GetStdColor( Index: Integer ): string;
    procedure SetStdColor( Index: Integer; const Value: string );
    function GetSysColor( Index: Integer ): string;
    procedure SetSysColor( Index: Integer; const Value: string );
    procedure SetCustomColor( const Value: string );
  public
    ShowSysColors: Boolean;
    ShowDefaultColor: Boolean;
    ShowCustomColor: Boolean;
    constructor Create;
    procedure Assign( Source: TPersistent ); override;

    property StdColors[ Index: Integer ]: string
      read GetStdColor
      write SetStdColor;

    property SysColors[ Index: Integer ]: string
      read GetSysColor
      write SetSysColor;
  published
    property Default: string
      read FDefaultColor
      write SetDefaultColor;

    property Black: string index 0 read GetStdColor write SetStdColor;
    property Maroon: string index 1 read GetStdColor write SetStdColor;
    property Green: string index 2 read GetStdColor write SetStdColor;
    property Olive: string index 3 read GetStdColor write SetStdColor;
    property Navy: string index 4 read GetStdColor write SetStdColor;
    property Purple: string index 5 read GetStdColor write SetStdColor;
    property Teal: string index 6 read GetStdColor write SetStdColor;
    property Gray: string index 7 read GetStdColor write SetStdColor;
    property Silver: string index 8 read GetStdColor write SetStdColor;
    property Red: string index 9 read GetStdColor write SetStdColor;
    property Lime: string index 10 read GetStdColor write SetStdColor;
    property Yellow: string index 11 read GetStdColor write SetStdColor;
    property Blue: string index 12 read GetStdColor write SetStdColor;
    property Fuchsia: string index 13 read GetStdColor write SetStdColor;
    property Aqua: string index 14 read GetStdColor write SetStdColor;
    property White: string index 15 read GetStdColor write SetStdColor;

    property ScrollBar: string index 0 read GetSysColor write SetSysColor;
    property Background: string index 1 read GetSysColor write SetSysColor;
    property ActiveCaption: string index 2 read GetSysColor write SetSysColor;
    property InactiveCaption: string index 3 read GetSysColor write SetSysColor;
    property Menu: string index 4 read GetSysColor write SetSysColor;
    property Window: string index 5 read GetSysColor write SetSysColor;
    property WindowFrame: string index 6 read GetSysColor write SetSysColor;
    property MenuText: string index 7 read GetSysColor write SetSysColor;
    property WindowText: string index 8 read GetSysColor write SetSysColor;
    property CaptionText: string index 9 read GetSysColor write SetSysColor;
    property ActiveBorder: string index 10 read GetSysColor write SetSysColor;
    property InactiveBorder: string index 11 read GetSysColor write SetSysColor;
    property AppWorkSpace: string index 12 read GetSysColor write SetSysColor;
    property Highlight: string index 13 read GetSysColor write SetSysColor;
    property HighlightText: string index 14 read GetSysColor write SetSysColor;
    property BtnFace: string index 15 read GetSysColor write SetSysColor;
    property BtnShadow: string index 16 read GetSysColor write SetSysColor;
    property GrayText: string index 17 read GetSysColor write SetSysColor;
    property BtnText: string index 18 read GetSysColor write SetSysColor;
    property InactiveCaptionText: string index 19 read GetSysColor write SetSysColor;
    property BtnHighlight: string index 20 read GetSysColor write SetSysColor;
    property DkShadow3D: string index 21 read GetSysColor write SetSysColor;
    property Light3D: string index 22 read GetSysColor write SetSysColor;
    property InfoText: string index 23 read GetSysColor write SetSysColor;
    property InfoBk: string index 24 read GetSysColor write SetSysColor;

    property Custom: string
      read FCustomColor
      write SetCustomColor;
  end;


  {========================================}
  {== TRzColorComboBox Class Declaration ==}
  {========================================}

  TRzColorComboBox = class( TRzCustomComboBox )
  private
    FCancelPick: Boolean;
    FDefaultColor: TColor;
    FCustomColor: TColor;
    FColorNames: TRzColorNames;
    FSaveColorNames: TRzColorNames;
    FShowSysColors: Boolean;
    FShowColorNames: Boolean;
    FShowDefaultColor: Boolean;
    FShowCustomColor: Boolean;
    FColorDlgOptions: TColorDialogOptions;
    FCustomColors: TStrings;
    FStoreColorNames: Boolean;
    FSaveItemIndex: Integer;
    FRegIniFile: TRzRegIniFile;


    { Message Handling Methods }
    procedure CNDrawItem( var Msg: TWMDrawItem ); message cn_DrawItem;
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
    procedure CNCommand( var Msg: TWMCommand ); message cn_Command;
  protected
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    function GetCustomColorName( Index: Integer ): string;
    procedure FixupCustomColors; virtual;
    procedure InitColorNames; virtual;
    function GetColorFromItem( Index: Integer ): TColor; virtual;

    { Event Dispatch Methods }
    procedure DrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState ); override;

    procedure CloseUp; override;

    { Property Access Methods }
    procedure SetDefaultColor( Value: TColor ); virtual;
    procedure SetColorNames( Value: TRzColorNames ); virtual;
    procedure SetCustomColor( Value: TColor ); virtual;
    procedure SetCustomColors( Value: TStrings ); virtual;
    procedure SetShowCustomColor( Value: Boolean ); virtual;
    procedure SetShowDefaultColor( Value: Boolean ); virtual;
    procedure SetShowSysColors( Value: Boolean ); virtual;
    procedure SetShowColorNames( Value: Boolean ); virtual;
    function GetSelectedColor: TColor; virtual;
    procedure SetSelectedColor( Value: TColor ); virtual;

    procedure SetFrameVisible( Value: Boolean ); override;
    procedure SetRegIniFile( Value: TRzRegIniFile ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure LoadCustomColors( const Section: string );
    procedure SaveCustomColors( const Section: string );
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property ColorNames: TRzColorNames
      read FColorNames
      write SetColorNames
      stored FStoreColorNames;

    property CustomColor: TColor
      read FCustomColor
      write SetCustomColor
      default clBlack;

    property CustomColors: TStrings
      read FCustomColors
      write SetCustomColors;

    property ColorDlgOptions: TColorDialogOptions
      read FColorDlgOptions
      write FColorDlgOptions
      default [ cdFullOpen ];

    property DefaultColor: TColor
      read FDefaultColor
      write SetDefaultColor
      default clBlack;

    property RegIniFile: TRzRegIniFile
      read FRegIniFile
      write SetRegIniFile;

    property ShowColorNames: Boolean
      read FShowColorNames
      write SetShowColorNames
      default True;

    property ShowCustomColor: Boolean
      read FShowCustomColor
      write SetShowCustomColor
      default True;

    property ShowDefaultColor: Boolean
      read FShowDefaultColor
      write SetShowDefaultColor
      default True;

    property ShowSysColors: Boolean
      read FShowSysColors
      write SetShowSysColors
      default True;

    { Must occur after ShowCustomColor, ShowDefaultColor, and ShowSysColors }
    property SelectedColor: TColor
      read GetSelectedColor
      write SetSelectedColor
      default clBlack;

    { Inherited Properties & Events }
    property Align;
    property Anchors;
    {$IFDEF VCL70_OR_HIGHER}
    property AutoCloseUp;
    {$ENDIF}
    {$IFDEF VCL60_OR_HIGHER}
    property AutoDropDown;
    {$ENDIF}
    property BeepOnInvalidKey;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownWidth;
    property Enabled;
    property FlatButtonColor;
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
    property ItemHeight;
    {property Items;    User does not have access to the Items list }
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    {property Sorted;   Color list should not be sorted }
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
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
    {$IFDEF VCL60_OR_HIGHER}
    property OnSelect;
    {$ENDIF}
    property OnStartDock;
    property OnStartDrag;
  end;

  {===========================================}
  {== TRzPreviewFontPanel Class Declaration ==}
  {===========================================}

  TRzFontComboBox = class;

  TRzPreviewFontPanel = class( TCustomPanel )
  private
    FControl: TWinControl;

    { Message Handling Methods }
    procedure CMCancelMode( var Msg: TCMCancelMode ); message cm_CancelMode;
    procedure CMShowingChanged( var Msg: TMessage ); message cm_ShowingChanged;
    procedure WMKillFocus( var Msg: TMessage ); message wm_KillFocus;
  protected
    procedure CreateParams( var Params: TCreateParams ); override;
    procedure Paint; override;
  public
    constructor Create( AOwner: TComponent ); override;

    property Control: TWinControl
      write FControl;

    property Alignment;
    property Canvas;
    property Caption;
    property Font;
  end;

  {=======================================}
  {== TRzFontComboBox Class Declaration ==}
  {=======================================}

  TRzFontDevice = ( fdScreen, fdPrinter );
  TRzFontType = ( ftAll, ftTrueType, ftFixedPitch, ftPrinter );
  TRzShowStyle = ( ssFontName, ssFontSample, ssFontNameAndSample, ssFontPreview );

  TRzFontComboBox = class( TRzCustomComboBox )
  private
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
    procedure DropDown; override;
    procedure CloseUp; override;
    procedure DrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState ); override;

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
      default True;

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
    {$IFDEF VCL70_OR_HIGHER}
    property AutoCloseUp;
    {$ENDIF}
    {$IFDEF VCL60_OR_HIGHER}
    property AutoDropDown;
    {$ENDIF}
    property BeepOnInvalidKey;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount default 14;
    property DropDownWidth;
    property Enabled;
    property FlatButtonColor;
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
    property ItemHeight;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Sorted default True;
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
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
    {$IFDEF VCL60_OR_HIGHER}
    property OnSelect;
    {$ENDIF}
    property OnStartDock;
    property OnStartDrag;
  end;


  {======================================}
  {== TRzMRUComboBox Class Declaration ==}
  {======================================}

  TRzMRUComboBox = class( TRzCustomComboBox )
  private
    FRemoveItemCaption: string;
    FEmbeddedMenu: TPopupMenu;
    FSelectFirstItemOnLoad: Boolean;
    FMnuUndo: TMenuItem;
    FMnuSeparator1: TMenuItem;
    FMnuCut: TMenuItem;
    FMnuCopy: TMenuItem;
    FMnuPaste: TMenuItem;
    FMnuDelete: TMenuItem;
    FMnuSeparator2: TMenuItem;
    FMnuSelectAll: TMenuItem;
    FMnuSeparator3: TMenuItem;
    FMnuRemove: TMenuItem;

    FMruRegIniFile: TRzRegIniFile;
    FMruPath: string;
    FMruSection: string;
    FMruID: string;
    FMaxHistory: Integer;

    FOnEscapeKeyPressed: TNotifyEvent;
    FOnEnterKeyPressed: TNotifyEvent;

    { Internal Event Handlers }
    procedure EmbeddedMenuPopupHandler( Sender: TObject );
    procedure MnuUndoClickHandler( Sender: TObject );
    procedure MnuCutClickHandler( Sender: TObject );
    procedure MnuCopyClickHandler( Sender: TObject );
    procedure MnuPasteClickHandler( Sender: TObject );
    procedure MnuDeleteClickHandler( Sender: TObject );
    procedure MnuSelectAllClickHandler( Sender: TObject );
    procedure MnuRemoveItemClickHandler( Sender: TObject );
  protected
    FPopupMenuTag: Integer;
    FDataIsLoaded: Boolean;

    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;
    procedure Loaded; override;
    procedure CreateWnd; override;

    procedure SetupMenuItem( AMenuItem: TMenuItem; ACaption: string;
                             AChecked, ARadioItem: Boolean;
                             AGroupIndex, AShortCut: Integer;
                             AHandler: TNotifyEvent ); dynamic;

    procedure CreatePopupMenuItems; virtual;
    procedure InitializePopupMenuItems; virtual;
    procedure AddMenuItemsToPopupMenu; virtual;

    { Event Dispatch Methods }
    procedure EnterKeyPressed; dynamic;
    procedure EscapeKeyPressed; dynamic;
    procedure KeyPress( var Key: Char ); override;

    procedure DoExit; override;

    { Property Access Methods }
    procedure SetMruRegIniFile( Value: TRzRegIniFile ); virtual;
    procedure SetRemoveItemCaption( const Value: string );
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure LoadMRUData( FromStream: Boolean ); dynamic;
    procedure SaveMRUData; dynamic;
    procedure UpdateMRUList; dynamic;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property MaxHistory: Integer
      read FMaxHistory
      write FMaxHistory
      default 25;

    property MruPath: string
      read FMruPath
      write FMruPath;

    property MruRegIniFile: TRzRegIniFile
      read FMruRegIniFile
      write SetMruRegIniFile;

    property MruSection: string
      read FMruSection
      write FMruSection;

    property MruID: string
      read FMruID
      write FMruID;

    property RemoveItemCaption: string
      read FRemoveItemCaption
      write SetRemoveItemCaption;

    property SelectFirstItemOnLoad: Boolean
      read FSelectFirstItemOnLoad
      write FSelectFirstItemOnLoad
      default False;

    property OnEnterKeyPressed: TNotifyEvent
      read FOnEnterKeyPressed
      write FOnEnterKeyPressed;

    property OnEscapeKeyPressed: TNotifyEvent
      read FOnEscapeKeyPressed
      write FOnEscapeKeyPressed;

    { Inherited Properties & Events }
    property Style;                           { Must be published before Items }
    property Align;
    property AllowEdit;
    property Anchors;
    property AutoComplete;
    {$IFDEF VCL70_OR_HIGHER}
    property AutoCloseUp;
    {$ENDIF}
    {$IFDEF VCL60_OR_HIGHER}
    property AutoDropDown;
    {$ENDIF}
    property BeepOnInvalidKey;
    property BiDiMode;
    {$IFDEF VCL60_OR_HIGHER}
    property CharCase;
    {$ENDIF}
    property Color;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownWidth;
    property Enabled;
    property FlatButtonColor;
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
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property Items;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    {property PopupMenu;}              { Prevent user from modifying PopupMenu }
    property ReadOnly;
    property ShowHint;
    {property Sorted;}                      { An MRU list should not be sorted }
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;

    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMatch;
    property OnMeasureItem;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseWheelDown;
    property OnMouseWheelUp;
    property OnNotInList;
    {$IFDEF VCL60_OR_HIGHER}
    property OnSelect;
    {$ENDIF}
    property OnStartDock;
    property OnStartDrag;
  end;

  {=========================================}
  {== TRzImageComboBox Class Declarations ==}
  {=========================================}

  TRzCustomImageComboBox = class;

  TRzImageComboBoxItem = class
  protected
    FOwner: TRzCustomImageComboBox;
    FItemIndex: Integer;

    FIndex: Integer;
    FIndentLevel: Integer;
    FImageIndex: Integer;
    FOverlayIndex: Integer;
    FCaption: string;
    FTag: Integer;
    FData: Pointer;

    procedure SetIndentLevel( Value: Integer );
    procedure SetImageIndex( Value: Integer );
    procedure SetCaption( const Value: string );
    procedure SetOverlayIndex( Value: Integer );
  public
    constructor Create( AOwner: TRzCustomImageComboBox );
    destructor Destroy; override;

    property Index: Integer
      read FIndex;    // Index in the list of the owning combobox

    property IndentLevel: Integer
      read FIndentLevel
      write SetIndentLevel;

    property ImageIndex: Integer
      read FImageIndex
      write SetImageIndex;

    property OverlayIndex: Integer
      read FOverlayIndex
      write SetOverlayIndex;

    property Caption: string
      read FCaption
      write SetCaption;

    property Data: Pointer
      read FData
      write FData;

    property Tag: Integer
      read FTag
      write FTag;
  end;


  TRzDeleteImageComboBoxItemEvent = procedure( Sender: TObject; Item: TRzImageComboBoxItem ) of object;

  TRzImageComboBoxGetItemDataEvent = procedure( Sender: TObject; Item: TRzImageComboBoxItem ) of object;

  TRzCustomImageComboBox = class( TRzCustomComboBox )
  private
    FAutoSizeHeight: Boolean;
    FImages: TCustomImageList;
    FItemIndent: Integer;
    FOnDeleteImageComboBoxItem: TRzDeleteImageComboBoxItemEvent;
    FOnGetItemData: TRzImageComboBoxGetItemDataEvent;
    FInWMSetFont: Boolean;
    FFreeObjOnDelete: Boolean;

    function GetImageComboBoxItem( index: Integer ): TRzImageComboBoxItem;

    procedure WMEraseBkgnd( var Msg: TWMEraseBkgnd ); message WM_ERASEBKGND;
    procedure WMSetFont( var Msg: TWMSetFont ); message WM_SETFONT;
  protected
    procedure DoAutoSize( hf: HFont );
    procedure AutoSize( hf: HFont ); dynamic;

    procedure SetItemIndent( Value: Integer );
    procedure SetImages( const Value: TCustomImageList );

    procedure CreateParams( var Params: TCreateParams ); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;

    procedure DrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState ); override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;
    procedure DeleteItem( Item: Pointer ); override;

    procedure GetItemData( Item: TRzImageComboBoxItem ); virtual;

    property Text
      stored False;

    property AutoSizeHeight: Boolean
      read FAutoSizeHeight
      write FAutoSizeHeight
      default True;

    property ItemIndent: Integer
      read FItemIndent
      write SetItemIndent
      default 12;

    property Images: TCustomImageList
      read FImages
      write SetImages;

    property OnDeleteItem: TRzDeleteImageComboBoxItemEvent
      read FOnDeleteImageComboBoxItem
      write FOnDeleteImageComboBoxItem;

    property OnGetItemData: TRzImageComboBoxGetItemDataEvent
      read FOnGetItemData
      write FOnGetItemData;

  public
    constructor Create( AOwner: TComponent ); override;

    function AddItem( Caption: string; ImageIndex: Integer;
                      IndentLevel: Integer ): TRzImageComboBoxItem; {$IFDEF VCL60_OR_HIGHER} reintroduce; {$ENDIF} virtual;

    procedure ItemsBeginUpdate;
    procedure ItemsEndUpdate;

    procedure Delete( Index: Integer );
    function IndexOf( const S: string ): Integer; override;

    property ImageComboItem[ Index: Integer ]: TRzImageComboBoxItem
      read GetImageComboBoxItem;
  end;


  TRzImageComboBox = class( TRzCustomImageComboBox )
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    { Inherited Properties & Events }
    property Align;
    property Anchors;
    {$IFDEF VCL70_OR_HIGHER}
    property AutoCloseUp;
    {$ENDIF}
    {$IFDEF VCL60_OR_HIGHER}
    property AutoDropDown;
    {$ENDIF}
    property AutoSizeHeight;
    property BiDiMode;
    {$IFDEF VCL60_OR_HIGHER}
    property CharCase;
    {$ENDIF}
    property Color;
    property Constraints;
    property Ctl3D;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property DropDownWidth;
    property Enabled;
    property Font;
    property FlatButtonColor;
    property FlatButtons;
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
    property Images;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property ItemIndent;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property Sorted;
    property TabOnEnter;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnContextPopup;
    property OnDblClick;
    property OnDeleteItem;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGetItemData;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseWheelUp;
    property OnMouseWheelDown;
    {$IFDEF VCL60_OR_HIGHER}
    property OnSelect;
    {$ENDIF}
    property OnSelEndCancel;
    property OnSelEndOk;
    property OnStartDock;
    property OnStartDrag;
  end;


{=========================}
{== ColorItems constant ==}
{=========================}

type
  TRzColorRec = record
    Name: string;
    Color: TColor;
  end;

const
  DefaultColorItem: TRzColorRec =
    ( Name: 'Default';             Color: clBlack );

  CustomColorItem: TRzColorRec =
    ( Name: 'Custom';              Color: clBlack );

  StdColorItems: array[ 0..15 ] of TRzColorRec =
  ( ( Name: 'Black';               Color: clBlack ),
    ( Name: 'Maroon';              Color: clMaroon ),
    ( Name: 'Green';               Color: clGreen ),
    ( Name: 'Olive';               Color: clOlive ),
    ( Name: 'Navy';                Color: clNavy ),
    ( Name: 'Purple';              Color: clPurple ),
    ( Name: 'Teal';                Color: clTeal ),
    ( Name: 'Gray';                Color: clGray ),
    ( Name: 'Silver';              Color: clSilver ),
    ( Name: 'Red';                 Color: clRed ),
    ( Name: 'Lime';                Color: clLime ),
    ( Name: 'Yellow';              Color: clYellow ),
    ( Name: 'Blue';                Color: clBlue ),
    ( Name: 'Fuchsia';             Color: clFuchsia ),
    ( Name: 'Aqua';                Color: clAqua ),
    ( Name: 'White';               Color: clWhite )
  );

  SysColorItems: array[ 0..MaxSysColors - 1 ] of TRzColorRec =
  ( ( Name: 'ScrollBar';           Color: clScrollBar ),
    ( Name: 'Background';          Color: clBackground ),
    ( Name: 'ActiveCaption';       Color: clActiveCaption ),
    ( Name: 'InactiveCaption';     Color: clInactiveCaption ),
    ( Name: 'Menu';                Color: clMenu ),
    ( Name: 'Window';              Color: clWindow ),
    ( Name: 'WindowFrame';         Color: clWindowFrame ),
    ( Name: 'MenuText';            Color: clMenuText ),
    ( Name: 'WindowText';          Color: clWindowText ),
    ( Name: 'CaptionText';         Color: clCaptionText ),
    ( Name: 'ActiveBorder';        Color: clActiveBorder ),
    ( Name: 'InactiveBorder';      Color: clInactiveBorder ),
    ( Name: 'AppWorkSpace';        Color: clAppWorkSpace ),
    ( Name: 'Highlight';           Color: clHighlight ),
    ( Name: 'HighlightText';       Color: clHighlightText ),
    ( Name: 'BtnFace';             Color: clBtnFace ),
    ( Name: 'BtnShadow';           Color: clBtnShadow ),
    ( Name: 'GrayText';            Color: clGrayText ),
    ( Name: 'BtnText';             Color: clBtnText ),
    ( Name: 'InactiveCaptionText'; Color: clInactiveCaptionText ),
    ( Name: 'BtnHighlight';        Color: clBtnHighlight ),

    ( Name: '3DDkShadow';          Color: cl3DDkShadow ),
    ( Name: '3DLight';             Color: cl3DLight ),
    ( Name: 'InfoText';            Color: clInfoText ),
    ( Name: 'InfoBk';              Color: clInfoBk )
  );


const
  ptDefault = 'AaBbYyZz';
  ptDefault1 = 'AaBbYyZ';
  ptDefault2 = 'AaBbYy';
  
implementation

// Link in glyphs for color and font combo boxes
{$R RzCmboBx.res}

uses
  {$IFDEF VCL70_OR_HIGHER}
  Themes,
  {$ELSE}
  RzThemeSrv,
  {$ENDIF}
  ClipBrd,
  TypInfo,
  Registry,
  IniFiles,
  SysUtils,
  Printers,
  CommCtrl;

{&RT}
{===============================}
{== TRzCustomComboBox Methods ==}
{===============================}

constructor TRzCustomComboBox.Create( AOwner: TComponent );
begin
  inherited;

  ControlStyle := ControlStyle - [ csSetCaption ];

  {$IFDEF VCL60_OR_HIGHER}
  inherited AutoComplete := False;
  {$ENDIF}
  FAutoComplete := True;
  FTyping := False;
  FShowFocus := True;
  
  FAllowEdit := True;
  FBeepOnInvalidKey := True;
  FKeepSearchCase := False;
  FSearchString := '';
  FDropDownWidth := 0;
  FSaveDropWidth := 0;

  FTimer := TTimer.Create( nil );
  FTimer.Enabled := False;
  FTimer.OnTimer := SearchTimerExpired;
  FTimer.Interval := 1500;  { 1.5 second delay }

  FCanvas := TControlCanvas.Create;
  TControlCanvas( FCanvas ).Control := Self;

  FFlatButtons := False;
  FFlatButtonColor := clBtnFace;
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
  {&RCI}
end;


procedure TRzCustomComboBox.CreateWnd;
begin
  inherited;
  {&RV}
  if FSaveDropWidth <> 0 then
  begin
    FDropDownWidth := 0;
    DropDownWidth := FSaveDropWidth;
  end;
end;


destructor TRzCustomComboBox.Destroy;
begin
  FTimer.Free;
  if FFrameController <> nil then
    FFrameController.RemoveControl( Self );
  FCanvas.Free;
  inherited;
end;


procedure TRzCustomComboBox.DestroyWnd;
begin
  FSaveDropWidth := FDropDownWidth;
  inherited;
end;


function TRzCustomComboBox.Focused: Boolean;
begin
  // The inherited Focused method does not accurately determine if the control has the focus.
  // Therefore, we update the FIsFocused field in the CMEnter and CMExit methods.
  Result := FIsFocused;
end;


procedure TRzCustomComboBox.ForceText( const Value: string );
begin
  if Text <> Value then
  begin
    FAutoComplete := False;
    try
      Text := Value;
    finally
      FAutoComplete := True;
    end;
  end;
end;


procedure TRzCustomComboBox.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the FrameFlat and FrameFocusStyle properties were renamed to
  // FrameHotStyle and FrameHotStyle respectively in version 3.
  Filer.DefineProperty( 'FrameFlat', ReadOldFrameFlatProp, nil, False );
  Filer.DefineProperty( 'FrameFocusStyle', ReadOldFrameFocusStyleProp, nil, False );

  // Handle the fact that the FrameFlatStyle was published in version 2.x
  Filer.DefineProperty( 'FrameFlatStyle', TRzOldPropReader.ReadOldEnumProp, nil, False );
end;


procedure TRzCustomComboBox.ReadOldFrameFlatProp( Reader: TReader );
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


procedure TRzCustomComboBox.ReadOldFrameFocusStyleProp( Reader: TReader );
begin
  FFrameHotStyle := TFrameStyle( GetEnumValue( TypeInfo( TFrameStyle ), Reader.ReadIdent ) );
end;


procedure TRzCustomComboBox.Loaded;
begin
  inherited;
  UpdateColors;
  UpdateFrame( False, False );
end;


procedure TRzCustomComboBox.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( AComponent = FFrameController ) then
    FFrameController := nil;
end;


procedure TRzCustomComboBox.InvalidKeyPressed;
begin
  if FBeepOnInvalidKey then
    MessageBeep( 0 );
end;

{= wm_KeyDown is generated only when ComboBox has csDropDownList style =}

procedure TRzCustomComboBox.WMKeyDown( var Msg: TWMKeyDown );
begin
  if Msg.CharCode in [ vk_Escape, vk_Prior..vk_Down ] then
    FSearchString := '';
  inherited;
end;


function TRzCustomComboBox.FindClosest( const S: string ): Integer;
begin
  Result := SendMessage( Handle, cb_FindString, -1, Longint( PChar( S ) ) );
end;


procedure TRzCustomComboBox.UpdateIndex( const FindStr: string; Msg: TWMChar );
var
  Index: Integer;
begin
  Index := FindClosest( FindStr );
  if Index <> -1 then
  begin
    ItemIndex := Index;
    FSearchString := FindStr;
    Click;
    Change;
    DoKeyPress( Msg );
  end
  else
    InvalidKeyPressed;
end;



procedure TRzCustomComboBox.SearchTimerExpired( Sender: TObject );
begin
  if FKeyCount = 0 then
  begin
    FTimer.Enabled := False;
    FSearchString := '';
  end;
end;




{= The WndProc method is called only when ComboBox has csDropDownList style =}

procedure TRzCustomComboBox.WndProc( var Msg: TMessage );
var
  TempStr: string;
begin
  if Msg.Msg = wm_KeyDown then
  begin
    if ( TWMKey( Msg ).CharCode = vk_Escape ) and DroppedDown then
      FClosingByEscape := True;
  end;

  if Msg.Msg = wm_Char then
  begin
    TempStr := FSearchString;

    case TWMKey( Msg ).CharCode of
      vk_Back:
      begin
        if Length( TempStr ) > 0 then
        begin
          while ByteType( TempStr, Length( TempStr ) ) = mbTrailByte do
            System.Delete( TempStr, Length( TempStr ), 1 );
          System.Delete( TempStr, Length( TempStr ), 1 );

          if Length( TempStr ) = 0 then
          begin
            ItemIndex := 0;
            Click;
            Change;
            FSearchString := '';
            DoKeyPress( TWMKey( Msg ) );
            Exit;
          end;
        end
        else
          InvalidKeyPressed;

        UpdateIndex( TempStr, TWMKey( Msg ) );
      end;

      vk_Escape:
      begin
        if not FClosingByEscape then
        begin
          ItemIndex := 0;
          Click;
          Change;
        end
        else
          FClosingByEscape := False;
      end;

      32..255:
      begin
        FKeyCount := 1;
        TempStr := TempStr + Char( TWMKey( Msg ).CharCode );
        UpdateIndex( TempStr, TWMKey( Msg ) );

        FTimer.Enabled := False;
        FTimer.Enabled := True;
        FKeyCount := 0;
      end;

      else
        inherited;
    end;
  end
  else
    inherited;
end; {= TRzCustomComboBox.WndProc =}



procedure TRzCustomComboBox.Match;
begin
  if Assigned( FOnMatch ) then
    FOnMatch( Self );
end;


function TRzCustomComboBox.FindListItem( const FindStr: string; Msg: TMessage ): Boolean;
var
  Index: Integer;
begin
  Index := FindClosest( FindStr );
  if Index <> -1 then
  begin
    if FKeepSearchCase then
    begin
      FTyping := True;
      try
        Text := FindStr + Copy( Items[ Index ], Length( FindStr ) + 1, MaxInt );
      finally
        FTyping := False;
      end;
    end
    else
      ItemIndex := Index;

    Click;
    Change;
    DoKeyPress( TWMKey( Msg ) );

    SelStart := Length( FindStr );
    SelLength := Length( Items[ Index ] ) - SelStart;

    Match;
    Result := True;
  end
  else
    Result := False;
end;


{= ComboWndProc has keyboard actions when Style is csSimple or csDropDown =}

procedure TRzCustomComboBox.ComboWndProc( var Msg: TMessage; ComboWnd: HWnd; ComboProc: Pointer );
var
  TempStr, OldSearchString: string;
  Mask: LongWord;
  PasteViaShiftInsert: Boolean;
  CW, OldSelStart: Integer;
  PeekMsg: TMsg;

  procedure DeleteSelectedText( var S: string );
  var
    StartPos, EndPos: DWord;
    OldText: string;
  begin
    OldText := S;
    SendMessage( Handle, CB_GETEDITSEL, Integer( @StartPos ), Integer( @EndPos ) );
    System.Delete( OldText, StartPos + 1, EndPos - StartPos );
    SendMessage( Handle, CB_SETCURSEL, -1, 0 );
    S := OldText;
    SendMessage( Handle, CB_SETEDITSEL, 0, MakeLParam( StartPos, StartPos ) );
  end;

begin
  PasteViaShiftInsert := False;
  if FAutoComplete then
  begin
    case Msg.Msg of
      wm_LButtonDown:
      begin
        if Style = csDropDown then
          FSearchString := Text;
      end;

      wm_Char:
      begin
        if FSysKeyDown then
        begin
          // When Alt+Arrow keys are used to open and close the drop down list, a wm_Char message is sent to the control
          // with a CharCode (i.e. Msg.WParam) of 63, which causes a ? to show up in the edit field.  In this case, we
          // want to ignore this situation.
          FSysKeyDown := False
        end
        else
        begin
          if not FReadOnly then
          begin
            TempStr := FSearchString;

            case Msg.WParam of
              vk_Return:
              begin
                if DroppedDown then
                  SelEndOk;
                FEnterPressed := True;
              end;

              vk_Back:
              begin
                if Length( TempStr ) > 0 then
                begin
                  if SelStart >= Length( FSearchString ) then
                  begin
                    while ByteType( TempStr, Length( TempStr ) ) = mbTrailByte do
                      System.Delete( TempStr, Length( TempStr ), 1 );
                    System.Delete( TempStr, Length( TempStr ), 1 );
                  end
                  else if ( SelLength > 0 ) and FAllowEdit then
                  begin
                    DeleteSelectedText( TempStr );
                  end
                  else if FAllowEdit then
                  begin
                    CW := 1;
                    if ByteType( TempStr, SelStart ) = mbTrailByte then
                      Inc( CW );
                    System.Delete( TempStr, SelStart, CW );
                  end;

                  Change;
                  if Length( TempStr ) = 0 then
                  begin
                    ItemIndex := -1;
                    if FKeepSearchCase then
                      Text := '';
                    FSearchString := '';
                    Click;
                    Change;
                    DoKeyPress( TWMKey( Msg ) );
                  end;
                end
                else
                  InvalidKeyPressed;

                FSearchString := TempStr;
                if FindListItem( FSearchString, Msg ) then
                  Exit;

              end; { vk_Back }

              vk_Escape:
              begin
                if not DroppedDown then
                  ItemIndex := -1;

                FSearchString := '';
                Click;
                Change;
                DoKeyPress( TWMKey( Msg ) );
                if not DroppedDown then
                  Exit;
              end;

              22, 24: { Ctrl+V, Ctrl+X }
              begin
                if not FAllowEdit then
                begin
                  Msg.WParam := 0;
                end;
              end;

              32..255:
              begin
                // Invoke any user defined OnKeyPress handlers
                DoKeyPress( TWMKey( Msg ) );
                // Then use NEW character in case user changed it
                if Msg.WParam in [ 32..255 ] then
                begin
                  // If text is selected, it will be erased when new char is inserted.
                  // Therefore, delete the selected text from the search string

                  if SelLength > 0 then
                    System.Delete( FSearchString, SelStart + 1, SelLength );


                  OldSearchString := FSearchString;
                  System.Insert( Char( Msg.WParam ), FSearchString, SelStart + 1 );
                  //FSearchString := FSearchString + Char( Msg.WParam );

                  if Char( Msg.WParam ) in LeadBytes then
                  begin
                    if PeekMessage( PeekMsg, Handle, 0, 0, pm_NoRemove ) and ( PeekMsg.Message = wm_Char ) then
                      System.Insert( Char( PeekMsg.WParam ), FSearchString, SelStart + 2 );
                      //FSearchString := FSearchString + Char( PeekMsg.WParam );
                  end;

                  if FindListItem( FSearchString, Msg ) then
                  begin
                    PeekMessage( PeekMsg, Handle, 0, 0, pm_Remove );
                    Exit;
                  end
                  else
                  begin
                    if FAllowEdit then
                    begin
                      OldSelStart := SelStart;
                      FTyping := True;
                      try
                        Text := OldSearchString;
                      finally
                        FTyping := False;
                      end;
                      SelStart := OldSelStart;
                      SelLength := 0;
                    end
                    else
                    begin
                      InvalidKeyPressed;
                      FSearchString := OldSearchString;
                      Msg.WParam := 0;
                    end;
                  end;

                end;
              end;
            end;
          end
          else // FReadOnly
          begin
            if Msg.WParam <> 3 then  // <> Ctrl+C
              Exit;
          end;
        end;
      end; { wm_Char }

      wm_KeyDown:
      begin
        FSysKeyDown := False;
        case Msg.WParam of
          vk_Insert:
          begin
            Mask := $80000000;
            if ( GetKeyState( vk_Shift ) and Mask ) = Mask then
              PasteViaShiftInsert := True;
            if not FAllowEdit then
            begin
              Msg.WParam := 0;
            end;
          end;

          vk_Delete:
          begin
            FSearchString := Text;

            // Check current character to see if it is a lead byte
            CW := 1;
            if ByteType( FSearchString, SelStart + 1 ) = mbLeadByte then
              Inc( CW );
            System.Delete( FSearchString, SelStart + 1, Max( SelLength, CW ) );

            if not FAllowEdit and ( SelLength < Length( Text ) ) then
              Msg.WParam := 0;
          end;

          vk_End, vk_Home, vk_Left, vk_Right:
          begin
            FSearchString := Text;
          end;

          vk_Prior, vk_Next, vk_Up, vk_Down:
          begin
            FTyping := True;
            FSearchString := '';
            if FReadOnly then
              Exit;
          end;

          vk_F4:
          begin
            if FReadOnly then
              Exit;
          end;
        end; { case }
      end; { wm_KeyDown }

      wm_SysKeyDown:
      begin
        FSysKeyDown := True;
        if FReadOnly and ( Msg.WParam <> vk_F4 ) then
          Exit;
      end;
    end;
  end; { if FAutoComplete }

  inherited;

  if FAutoComplete then
  begin
    { Handle Ctrl+V and Ctrl+X and Shift+Insert combinations }
    if PasteViaShiftInsert or
       ( ( Msg.Msg = wm_Char ) and
         ( ( Msg.WParam = 22 ) or ( Msg.WParam = 24 ) ) ) then
    begin
      if FAllowEdit then
      begin
        FSearchString := Text;
        FindListItem( FSearchString, Msg );
      end;
    end;
  end;

end; {= TRzCustomComboBox.ComboWndProc =}


procedure TRzCustomComboBox.UpdateSearchStr;
var
  Index: Integer;
begin
  if Style = csDropDown then
  begin
    if not FEnterPressed then
      FSearchString := Text
    else
      FEnterPressed := False;

    Index := FindClosest( FSearchString );

    if Index <> -1 then
    begin
      ItemIndex := Index;
      SelStart := Length( FSearchString );
      SelLength := Length( Items[ ItemIndex ] ) - SelStart;
    end;
  end;
end;


procedure TRzCustomComboBox.ClearSearchString;
begin
  FSearchString := '';
end;


procedure TRzCustomComboBox.KeyPress( var Key: Char );
begin
  if FTabOnEnter and ( Ord( Key ) = vk_Return ) and not DroppedDown then
  begin
    Key := #0;
    PostMessage( Handle, wm_KeyDown, vk_Tab, 0 );
  end
  else
  begin
    if ( Style = csDropDown ) and
       ( Key in [ #32..#255 ] ) and
       ( MaxLength > 0 ) and
       ( Length( Text ) >= MaxLength ) and
       ( SelLength = 0 ) then
    begin
      MessageBeep( 0 );
      Key := #0;
    end;

    inherited;

    {$IFDEF VCL60_OR_HIGHER}
    // Setting AutoDropDown does not cause the list to drop down when the user starts typing.  This is because the
    // inherited KeyPress event dispatch method, which implements the AutoDropDown functionality immediately exits if
    // AutoComplete is turned off.  The problem is that the RC combo boxes turn off the inherited AutoComplete
    // functionality so that it doesn't interfere with our own. The following case statement mimics the AutoDropDown
    // functionality.

    case Ord( Key ) of
      vk_Escape, vk_Back:
        ;
      vk_Tab:
        if AutoDropDown and DroppedDown then
          DroppedDown := False;
      else
        if AutoDropDown and not DroppedDown then
          DroppedDown := True;
    end;
    {$ENDIF}
  end;
end;


procedure TRzCustomComboBox.CMTextChanged( var Msg: TMessage );
begin
  inherited;
  if FAutoComplete then
  begin
    if not ( csDesigning in ComponentState ) and not FTyping and not DroppedDown then
      UpdateSearchStr;
  end;
  FTyping := False;
end;


procedure TRzCustomComboBox.CMEnabledChanged( var Msg: TMessage );
begin
  inherited;
  UpdateColors;
end;


procedure TRzCustomComboBox.WMCut( var Msg: TMessage );
begin
  if FAllowEdit then
  begin
    FSearchString := Text;
    FindListItem( FSearchString, Msg );
    inherited;
  end;
end;


procedure TRzCustomComboBox.WMPaste( var Msg: TMessage );
begin
  if FAllowEdit then
  begin
    inherited;
    FSearchString := Text;
    FindListItem( FSearchString, Msg );
  end;
end;


procedure TRzCustomComboBox.WMKillFocus( var Msg: TWMKillFocus );
begin
  inherited;
  FSearchString := '';
end;


procedure TRzCustomComboBox.CNCommand( var Msg: TWMCommand );
begin
  inherited;
  case Msg.NotifyCode of
    {$IFNDEF VCL60_OR_HIGHER}
    cbn_CloseUp:
    begin
      CloseUp;
    end;
    {$ENDIF}

    cbn_SelEndOk:
    begin
      // Setting FTyping to True here is necessary to allow a user to select
      // an item from the list that happens to be a substring of another item
      // in the list. If FTyping is not set to True, then the other item will
      // be placed in the edit area if it occurs earlier in the list.
      FTyping := True;
      SelEndOk;
    end;

    cbn_SelEndCancel:
    begin
      SelEndCancel;
    end;
  end;
end;


procedure TRzCustomComboBox.CNDrawItem( var Msg: TWMDrawItem );
var
  State: TOwnerDrawState;
begin
  with Msg.DrawItemStruct^ do
  begin
    State := TOwnerDrawState( LongRec( itemState ).Lo );

    if itemState and ODS_COMBOBOXEDIT <> 0 then
      Include( State, odComboBoxEdit );

    if itemState and ODS_DEFAULT <> 0 then
      Include( State, odDefault );

    Canvas.Handle := hDC;
    Canvas.Font := Font;
    Canvas.Brush := Brush;

    if ( Integer( itemID ) >= 0 ) and ( odSelected in State ) then
    begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText
    end;

    if Integer( itemID ) >= 0 then
    begin
      DrawItem( itemID, rcItem, State );
      if ( odSelected in State ) and FShowFocus then
        DrawFocusBorder( Canvas, rcItem );
    end
    else
    begin
      if odSelected in State then
        DrawFocusBorder( Canvas, rcItem )
      else
        Canvas.FillRect( rcItem );
    end;

    Canvas.Handle := 0;
  end;
end;


procedure TRzCustomCombobox.WMDeleteItem( var Msg: TWMDeleteItem );
begin
  if Msg.deleteItemStruct.itemData <> 0 then
  begin  // Windows NT4 can send some strange WM_DELETEITEM messages. We filter them here.
    DeleteItem( Pointer( Msg.deleteItemStruct.itemData ) );
    Pointer( Msg.deleteItemStruct.itemData ) := nil;
  end;

  inherited;
end;


procedure TRzCustomComboBox.WMLButtonDown( var Msg: TWMLButtonDown );
begin
  if FReadOnly then
    Exit;
  inherited;
end;


procedure TRzCustomComboBox.WMLButtonDblClick( var Msg: TWMLButtonDblClk );
begin
  if FReadOnly then
    Exit;
  inherited;
end;


procedure TRzCustomComboBox.CloseUp;
begin
  {$IFDEF VCL60_OR_HIGHER}
  inherited;

  {$ELSE}

  if Assigned( FOnCloseUp ) then
    FOnCloseUp( Self );
  {$ENDIF}

  Invalidate;
end;


procedure TRzCustomCombobox.DeleteItem( Item: Pointer );
begin
  if Assigned( FOnDeleteItem ) then
    FOnDeleteItem( Self, Item );
end;


procedure TRzCustomCombobox.SelEndCancel;
begin
  if Assigned( FOnSelEndCancel ) then
    FOnSelEndCancel( Self );
end;


procedure TRzCustomCombobox.SelEndOk;
begin
  if Assigned( OnSelEndOk ) then
    OnSelEndOk( Self );
end;



function TRzCustomComboBox.Add( const S: string ): Integer;
begin
  Result := Items.Add( S );
end;

function TRzCustomComboBox.AddObject( const S: string; AObject: TObject ): Integer;
begin
  Result := Items.AddObject( S, AObject );
end;

procedure TRzCustomComboBox.Delete( Index: Integer );
begin
  Items.Delete( Index );
end;


procedure TRzCustomComboBox.ClearItems;
begin
  Items.Clear;
end;


function TRzCustomComboBox.IndexOf( const S: string ): Integer;
begin
  Result := Items.IndexOf( S );
end;

procedure TRzCustomComboBox.Insert( Index: Integer; const S: string );
begin
  Items.Insert( Index, S );
end;

procedure TRzCustomComboBox.InsertObject( Index: Integer; const S: string; AObject: TObject );
begin
  Items.InsertObject( Index, S, AObject );
end;

function TRzCustomComboBox.Count: Integer;
begin
  Result := Items.Count;
end;


function TRzCustomComboBox.FindItem( const S: string ): Boolean;
var
  Idx: Integer;
begin
  Idx := Items.IndexOf( S );
  if Idx <> -1 then
    ItemIndex := Idx;
  Result := Idx <> -1;
end;


function TRzCustomComboBox.FindClosestItem( const S: string ): Boolean;
var
  Idx: Integer;
begin
  Idx := FindClosest( S );
  if Idx <> -1 then
    ItemIndex := Idx;
  Result := Idx <> -1;
end;


procedure TRzCustomComboBox.SetDropDownWidth( Value: Integer );
begin
  if FDropDownWidth <> Value then
  begin
    FDropDownWidth := Value;
    SendMessage( Handle, cb_SetDroppedWidth, FDropDownWidth, 0 );
  end;
end;


procedure TRzCustomComboBox.SetReadOnly( Value: Boolean );
var
  H: HWnd;
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;

    H := EditHandle;
    if ( Style in [ csDropDown, csSimple ] ) and HandleAllocated then
      SendMessage( H, em_SetReadOnly, Ord( FReadOnly ), 0 );

    Invalidate;
  end;
end;


procedure TRzCustomComboBox.SetFlatButtonColor( Value: TColor );
begin
  if FFlatButtonColor <> Value then
  begin
    FFlatButtonColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomComboBox.SetFlatButtons( Value: Boolean );
begin
  if FFlatButtons <> Value then
  begin
    FFlatButtons := Value;
    Invalidate;
  end;
end;


function TRzCustomComboBox.GetColor: TColor;
begin
  Result := inherited Color;
end;


procedure TRzCustomComboBox.SetColor( Value: TColor );
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
  end;
end;


function TRzCustomComboBox.IsColorStored: Boolean;
begin
  Result := NotUsingController and Enabled;
end;


function TRzCustomComboBox.IsFocusColorStored: Boolean;
begin
  Result := NotUsingController and ( ColorToRGB( FFocusColor ) <> ColorToRGB( Color ) );
end;


function TRzCustomComboBox.NotUsingController: Boolean;
begin
  Result := FFrameController = nil;
end;


procedure TRzCustomComboBox.SetDisabledColor( Value: TColor );
begin
  FDisabledColor := Value;
  if not Enabled then
    UpdateColors;
end;


procedure TRzCustomComboBox.SetFocusColor( Value: TColor );
begin
  FFocusColor := Value;
  if Focused then
    UpdateColors;
end;


procedure TRzCustomComboBox.SetFrameColor( Value: TColor );
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomComboBox.SetFrameController( Value: TRzFrameController );
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


procedure TRzCustomComboBox.SetFrameHotColor( Value: TColor );
begin
  if FFrameHotColor <> Value then
  begin
    FFrameHotColor := Value;
    Invalidate;
  end;
end;


procedure TRzCustomComboBox.SetFrameHotTrack( Value: Boolean );
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
    Invalidate;
  end;
end;


procedure TRzCustomComboBox.SetFrameHotStyle( Value: TFrameStyle );
begin
  if FFrameHotStyle <> Value then
  begin
    FFrameHotStyle := Value;
    Invalidate;
  end;
end;


procedure TRzCustomComboBox.SetFrameSides( Value: TSides );
begin
  if FFrameSides <> Value then
  begin
    FFrameSides := Value;
    Invalidate;
  end;
end;


procedure TRzCustomComboBox.SetFrameStyle( Value: TFrameStyle );
begin
  if FFrameStyle <> Value then
  begin
    FFrameStyle := Value;
    Invalidate;
  end;
end;


procedure TRzCustomComboBox.SetFrameVisible( Value: Boolean );
begin
  if FFrameVisible <> Value then
  begin
    FFrameVisible := Value;
    ParentCtl3D := not FFrameVisible;
    Ctl3D := not FFrameVisible;
    Invalidate;
  end;
end;


procedure TRzCustomComboBox.SetFramingPreference( Value: TFramingPreference );
begin
  if FFramingPreference <> Value then
  begin
    FFramingPreference := Value;
    if FFramingPreference = fpCustomFraming then
      Invalidate;
  end;
end;


function TRzCustomComboBox.UseThemes: Boolean;
begin
  Result := ( FFramingPreference = fpXPThemes ) and ThemeServices.ThemesEnabled;
end;


procedure TRzCustomComboBox.WMPaint( var Msg: TWMPaint );
var
  BtnRect, TempRect, R: TRect;
  Offset: Integer;
  ElementDetails: TThemedElementDetails;
begin
  inherited;

  if ThemeServices.ThemesEnabled then
    Offset := 1
  else
    Offset := 2;
  if not UseRightToLeftAlignment then
    BtnRect := Rect( Width - GetSystemMetrics( sm_CxVScroll ) - Offset, Offset, Width - Offset, Height - Offset )
  else
    BtnRect := Rect( Offset, Offset, GetSystemMetrics( sm_CxVScroll ) + Offset, Height - Offset );

  if FFrameVisible and not UseThemes then
  begin
    // Erase Ctl3D Border
    if ThemeServices.ThemesEnabled then
    begin
      if ColorToRGB( Color ) <> clWhite then
        DrawBevel( FCanvas, ClientRect, Color, Color, 1, sdAllSides );

      R := ClientRect;
      if not UseRightToLeftAlignment then
        R.Right := BtnRect.Left
      else
        R.Left := BtnRect.Right;

      InflateRect( R, -1, -1 );

      if ColorToRGB( Color ) <> clWhite then
        DrawBevel( FCanvas, R, Color, Color, 2, sdAllSides );
    end
    else
      DrawBevel( FCanvas, ClientRect, Color, Color, 2, sdAllSides );
  end
  else if ThemeServices.ThemesEnabled then
  begin
    // Remove white border inside blue flat border when XP Themes in use
    R := ClientRect;
    if not UseRightToLeftAlignment then
      R.Right := BtnRect.Left
    else
      R.Left := BtnRect.Right;

    InflateRect( R, -1, -1 );
    if ColorToRGB( Color ) <> clWhite then
      DrawBevel( FCanvas, R, Color, Color, 2, sdAllSides );
  end;

  if ThemeServices.ThemesEnabled then
  begin
    // Fill extra space by drop down button in XP themes
    R := BtnRect;
    if not UseRightToLeftAlignment then
    begin
      R.Right := R.Left;
      Dec( R.Left, 3 );
    end
    else
    begin
      R.Left := R.Right;
      Inc( R.Right, 2 );
    end;

    FCanvas.Brush.Color := Color;
    FCanvas.FillRect( R );
  end;

  if FFlatButtons and not FReadOnly then
  begin
    if not ( FInControl or FOverControl ) then
    begin
      // Erase Button Border
      FCanvas.Brush.Color := Color;
      FCanvas.FillRect( BtnRect );

      if ThemeServices.ThemesEnabled then
        DrawDropDownArrow( FCanvas, BtnRect, uiWindowsXP, False, Enabled )
      else
        DrawDropDownArrow( FCanvas, BtnRect, uiWindows95, False, Enabled );
    end
    else
    begin
      // Erase Button Border
      if ThemeServices.ThemesEnabled then
      begin
        if DroppedDown then
          ElementDetails := ThemeServices.GetElementDetails( tcDropDownButtonPressed )
        else
          ElementDetails := ThemeServices.GetElementDetails( tcDropDownButtonHot );

        ThemeServices.DrawElement( FCanvas.Handle, ElementDetails, BtnRect );
      end
      else // No Themes
      begin
        FCanvas.Brush.Color := FFlatButtonColor;

        if FFlatButtonColor = clBtnFace then
        begin
          if DroppedDown then
            TempRect := DrawBevel( FCanvas, BtnRect, clBtnShadow, clBtnHighlight, 1, sdAllSides )
          else
            TempRect := DrawBevel( FCanvas, BtnRect, clBtnHighlight, clBtnShadow, 1, sdAllSides );
        end
        else
        begin
          if DroppedDown then
            TempRect := DrawColorBorder( FCanvas, BtnRect, FFlatButtonColor, fsStatus )
          else
            TempRect := DrawColorBorder( FCanvas, BtnRect, FFlatButtonColor, fsPopup );
        end;

        FCanvas.FillRect( TempRect );
        DrawDropDownArrow( FCanvas, TempRect, uiWindows95, DroppedDown, Enabled );
      end;
    end;
  end
  else if FReadOnly then
  begin
    // Erase drop down button
    FCanvas.Brush.Color := Color;
    FCanvas.FillRect( BtnRect );
  end;

  if FFrameVisible and not UseThemes then
  begin
    if FFrameHotTrack and ( FInControl or FOverControl ) then
    begin
      if FFrameHotStyle = fsFlat then
        DrawSides( FCanvas, ClientRect, FFrameHotColor, FFrameHotColor, FFrameSides )
      else if FFrameHotStyle = fsFlatBold then
        DrawBevel( FCanvas, ClientRect, FFrameHotColor, FFrameHotColor, 2, FFrameSides )
      else if Color = clWindow then
        DrawBorderSides( FCanvas, ClientRect, FFrameHotStyle, FFrameSides )
      else
        DrawColorBorderSides( FCanvas, ClientRect, Color, FFrameHotStyle, FFrameSides );
    end
    else
    begin
      if FFrameStyle = fsFlat then
        DrawSides( FCanvas, ClientRect, FFrameColor, FFrameColor, FFrameSides )
      else if FFrameStyle = fsFlatBold then
        DrawBevel( FCanvas, ClientRect, FFrameColor, FFrameColor, 2, FFrameSides )
      else if Color = clWindow then
        DrawBorderSides( FCanvas, ClientRect, FFrameStyle, FFrameSides )
      else
        DrawColorBorderSides( FCanvas, ClientRect, Color, FFrameStyle, FFrameSides );
    end;
  end;
end; {= TRzCustomComboBox.WMPaint =}


procedure TRzCustomComboBox.UpdateColors;
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


procedure TRzCustomComboBox.UpdateFrame( ViaMouse, InFocus: Boolean );
var
  PaintIt: Boolean;
  R: TRect;
begin
  if ViaMouse then
    FOverControl := InFocus
  else
    FInControl := InFocus;

  PaintIt := FFlatButtons or FFrameHotTrack;

  if PaintIt and not DroppedDown then
  begin
    R := ClientRect;
    if not FFrameHotTrack then
      R.Left := R.Right - GetSystemMetrics( sm_CxVScroll ) - 2;
    RedrawWindow( Handle, @R, 0, rdw_Invalidate or rdw_UpdateNow or rdw_NoErase );
  end;

  UpdateColors;
end;


procedure TRzCustomComboBox.CMEnter( var Msg: TCMEnter );
begin
  inherited;
  FIsFocused := True;
  UpdateFrame( False, True );
end;


procedure TRzCustomComboBox.NotInList;
begin
  if Assigned( FOnNotInList ) then
    FOnNotInList( Self );
end;

procedure TRzCustomComboBox.CMExit( var Msg: TCMExit );
begin
  inherited;
  FIsFocused := False;
  UpdateFrame( False, False );

  if ( Style = csDropDown ) and ( Text <> '' ) and not ( Items.IndexOf( Text ) <> -1 ) then
    NotInList;
end;


procedure TRzCustomComboBox.MouseEnter;
begin
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
end;

procedure TRzCustomComboBox.CMMouseEnter( var Msg: TMessage );
begin
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  UpdateFrame( True, True );
  MouseEnter;
end;

procedure TRzCustomComboBox.MouseLeave;
begin
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
end;


procedure TRzCustomComboBox.CMMouseLeave( var Msg: TMessage );
begin
  inherited;
  UpdateFrame( True, False );
  MouseLeave;
end;


procedure TRzCustomComboBox.WMSize( var Msg: TWMSize );
begin
  inherited;
  if FFrameVisible and not UseThemes then
    Invalidate;
end;



function TRzCustomComboBox.DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean;
var
  I: Integer;
begin
  if not DroppedDown then
  begin
    ItemIndex := ItemIndex + 1;
    Click;
    Change;
  end
  else
  begin
    I := SendMessage( Handle, cb_GetTopIndex, 0, 0 );
    SendMessage( Handle, cb_SetTopIndex, I + Mouse.WheelScrollLines, 0 );
  end;
  Result := True;
end;


function TRzCustomComboBox.DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean;
var
  I, TopIndex: Integer;
begin
  if not DroppedDown then
  begin
    if ItemIndex > 0 then
    begin
      ItemIndex := ItemIndex - 1;
      Click;
      Change;
    end
    else
      ItemIndex := 0;
  end
  else
  begin
    I := SendMessage( Handle, cb_GetTopIndex, 0, 0 );
    TopIndex := I - Mouse.WheelScrollLines;
    if TopIndex < 0 then
      TopIndex := 0;
    SendMessage( Handle, cb_SetTopIndex, TopIndex, 0 );
  end;
  Result := True;
end;


procedure TRzCustomComboBox.SetItemHeight2( Value: Integer );
begin
  if ( ItemHeight <> Value ) and ( Style in [ csOwnerDrawFixed, csOwnerDrawVariable ] ) then
  begin
    inherited ItemHeight := Value;
    RecreateWnd;
  end;
end;


procedure TRzCustomComboBox.CMParentColorChanged( var Msg: TMessage );
begin
  inherited;

  if ParentColor then
  begin
    // If ParentColor set to True, must reset FNormalColor and FFocusColor
    if FFocusColor = FNormalColor then
      FFocusColor := Color;
    FNormalColor := Color;
  end;
end;


{===========================}
{== TRzColorNames Methods ==}
{===========================}

constructor TRzColorNames.Create;
begin
  inherited;
  ShowDefaultColor := True;
  ShowCustomColor := True;
  ShowSysColors := True;
end;

procedure TRzColorNames.Assign( Source: TPersistent );
var
  I: Integer;
begin
  if Source is TRzColorNames then
  begin
    if ShowDefaultColor then
      FDefaultColor := TRzColorNames( Source ).Default;

    for I := 0 to MaxStdColors - 1 do
      SetStdColor( I, TRzColorNames( Source ).GetStdColor( I ) );

    if ShowSysColors then
    begin
      for I := 0 to MaxSysColors - 1 do
        SetSysColor( I, TRzColorNames( Source ).GetSysColor( I ) );
    end;

    if ShowCustomColor then
      FCustomColor := TRzColorNames( Source ).Custom;

    Exit;
  end;
  inherited;
end;


procedure TRzColorNames.SetDefaultColor( const Value: string );
var
  Idx: Integer;
begin
  FDefaultColor := Value;
  if ( FComboBox <> nil ) and ShowDefaultColor then
  begin
    Idx := FComboBox.ItemIndex;
    FComboBox.Items[ 0 ] := Value;
    FComboBox.ItemIndex := Idx;
    FComboBox.FStoreColorNames := True;
  end;
end;


function TRzColorNames.GetStdColor( Index: Integer ): string;
begin
  Result := FStdColors[ Index ];
end;


procedure TRzColorNames.SetStdColor( Index: Integer; const Value: string );
var
  Idx, ColorIdx: Integer;
begin
  FStdColors[ Index ] := Value;
  if FComboBox <> nil then
  begin
    Idx := FComboBox.ItemIndex;
    ColorIdx := Index;
    if ShowDefaultColor then
      Inc( ColorIdx );
    FComboBox.Items[ ColorIdx ] := Value;
    FComboBox.ItemIndex := Idx;
    FComboBox.FStoreColorNames := True;
  end;
end;


function TRzColorNames.GetSysColor( Index: Integer ): string;
begin
  Result := FSysColors[ Index ];
end;

procedure TRzColorNames.SetSysColor( Index: Integer; const Value: string );
var
  Idx, ColorIdx: Integer;
begin
  FSysColors[ Index ] := Value;
  if ( FComboBox <> nil ) and ShowSysColors then
  begin
    Idx := FComboBox.ItemIndex;
    ColorIdx := MaxStdColors + Index;
    if ShowDefaultColor then
      Inc( ColorIdx );
    FComboBox.Items[ ColorIdx ] := Value;
    FComboBox.ItemIndex := Idx;
    FComboBox.FStoreColorNames := True;
  end;
end;


procedure TRzColorNames.SetCustomColor( const Value: string );
var
  Idx: Integer;
begin
  FCustomColor := Value;
  if ( FComboBox <> nil ) and ShowCustomColor then
  begin
    Idx := FComboBox.ItemIndex;
    FComboBox.Items[ FComboBox.Items.Count - 1 ] := Value;
    FComboBox.ItemIndex := Idx;
    FComboBox.FStoreColorNames := True;
  end;
end;


{==============================}
{== TRzColorComboBox Methods ==}
{==============================}

constructor TRzColorComboBox.Create( AOwner: TComponent );
begin
  inherited;

  FSaveItemIndex := 0;
  Style := csOwnerDrawFixed;                // Style is not published

  FColorNames := TRzColorNames.Create;
  InitColorNames;
  FColorNames.FComboBox := Self;
  FStoreColorNames := False;

  FShowColorNames := True;
  FShowSysColors := True;
  {&RCI}
  FShowDefaultColor := True;
  FDefaultColor := clBlack;
  FShowCustomColor := True;
  FCustomColor := clBlack;

  FColorDlgOptions := [ cdFullOpen ];
  FCustomColors := TStringList.Create;
  FCancelPick := False;
end;


procedure TRzColorComboBox.CreateWnd;
var
  I: Integer;
begin
  inherited;

  Clear;

  { Add Default Color Item }
  if FShowDefaultColor then
    Items.AddObject( DefaultColorItem.Name, TObject( DefaultColorItem.Color ) );
  SetDefaultColor( FDefaultColor );

  { Add Standard Colors Always }
  for I := 0 to MaxStdColors - 1 do
    Items.AddObject( StdColorItems[ I ].Name, TObject( StdColorItems[ I ].Color ) );

  { Add System Colors }
  if FShowSysColors then
  begin
    for I := 0 to MaxSysColors - 1 do
      Items.AddObject( SysColorItems[ I ].Name, TObject( SysColorItems[ I ].Color ) );
  end;

  { Add Custom Color Item }
  if FShowCustomColor then
    Items.AddObject( CustomColorItem.Name, TObject( CustomColorItem.Color ) );
  SetCustomColor( FCustomColor );

  if FSaveColorNames <> nil then
  begin
    FColorNames.Assign( FSaveColorNames );
    FSaveColorNames.Free;
    FSaveColorNames := nil;
  end;

  { Select Default color entry or clBlack -- needed for when control dynamically created }
  ItemIndex := FSaveItemIndex;
  {&RV}
end;


procedure TRzColorComboBox.Loaded;
begin
  inherited;

  if ItemIndex = -1 then
    ItemIndex := 0;               { Select Default color entry by default }
end;


destructor TRzColorComboBox.Destroy;
begin
  FCustomColors.Free;
  FColorNames.Free;
  inherited;
end;


procedure TRzColorComboBox.DestroyWnd;
begin
  FSaveItemIndex := ItemIndex;
  if ( Items.Count > 0 ) and FStoreColorNames then
  begin
    FSaveColorNames := TRzColorNames.Create;
    FSaveColorNames.ShowDefaultColor := FShowDefaultColor;
    FSaveColorNames.ShowCustomColor := FShowCustomColor;
    FSaveColorNames.ShowSysColors := FShowSysColors;
    FSaveColorNames.Assign( FColorNames );
  end;
  inherited;
end;


procedure TRzColorComboBox.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if ( Operation = opRemove ) and ( AComponent = FRegIniFile ) then
    FRegIniFile := nil;
end;


function TRzColorComboBox.GetCustomColorName( Index: Integer ): string;
begin
  Result := FCustomColors.Names[ Index ];
end; 


procedure TRzColorComboBox.FixupCustomColors;
var
  I: Integer;
  L: Longint;
  S, Ident: string;
begin
  for I := 0 to FCustomColors.Count - 1 do
  begin
    Ident := GetCustomColorName( I );

    { This code removes the high bit of the color value--
      only the lower 3 bytes are needed }
      
    L := StrToInt( '$' + FCustomColors.Values[ Ident ] ) and $00FFFFFF;
    S := Format( '%.6x', [ L ] );
    FCustomColors.Values[ Ident ] := S;
  end;
end;


procedure TRzColorComboBox.LoadCustomColors( const Section: string );
begin
  if FRegIniFile = nil then
    raise ENoRegIniFile.Create( sRzCannotLoadCustomColors );

  FRegIniFile.ReadSectionValues( Section, FCustomColors );
  FixupCustomColors;
end;


procedure TRzColorComboBox.SaveCustomColors( const Section: string );
var
  I: Integer;
  Ident: string;
begin
  if FRegIniFile = nil then
    raise ENoRegIniFile.Create( sRzCannotSaveCustomColors );

  for I := 0 to FCustomColors.Count - 1 do
  begin
    Ident := GetCustomColorName( I );
    FRegIniFile.WriteString( Section, Ident, FCustomColors.Values[ Ident ] );
  end;
end;


procedure TRzColorComboBox.InitColorNames;
var
  I: Integer;
begin
  FColorNames.Default := DefaultColorItem.Name;
  for I := 0 to MaxStdColors - 1 do
    FColorNames.SetStdColor( I, StdColorItems[ I ].Name );
  for I := 0 to MaxSysColors - 1 do
    FColorNames.SetSysColor( I, SysColorItems[ I ].Name );
  FColorNames.Custom := CustomColorItem.Name;
end;


procedure TRzColorComboBox.SetCustomColors( Value: TStrings );
begin
  FCustomColors.Assign( Value );
  FixupCustomColors;
end;


procedure TRzColorComboBox.SetColorNames( Value: TRzColorNames );
begin
  FColorNames.Assign( Value );
end;


procedure TRzColorComboBox.SetShowColorNames( Value: Boolean );
begin
  if FShowColorNames <> Value then
  begin
    FShowColorNames := Value;
    Invalidate;
  end;
end;


procedure TRzColorComboBox.SetShowCustomColor( Value: Boolean );
begin
  if FShowCustomColor <> Value then
  begin
    FShowCustomColor := Value;
    FColorNames.ShowCustomColor := FShowCustomColor;
    RecreateWnd;
  end;
end;


procedure TRzColorComboBox.SetShowDefaultColor( Value: Boolean );
begin
  if FShowDefaultColor <> Value then
  begin
    FShowDefaultColor := Value;
    FColorNames.ShowDefaultColor := FShowDefaultColor;
    RecreateWnd;
  end;
end;


procedure TRzColorComboBox.SetShowSysColors( Value: Boolean );
begin
  if FShowSysColors <> Value then
  begin
    FShowSysColors := Value;
    FColorNames.ShowSysColors := FShowSysColors;
    RecreateWnd;
  end;
end;


function TRzColorComboBox.GetColorFromItem( Index: Integer ): TColor;
begin
  Result := TColor( Items.Objects[ Index ] );
end;

procedure TRzColorComboBox.SetDefaultColor( Value: TColor );
begin
  FDefaultColor := Value;
  if FShowDefaultColor then
  begin
    Items.Objects[ 0 ] := TObject( Value );
    Invalidate;
  end;
end;

procedure TRzColorComboBox.SetCustomColor( Value: TColor );
begin
  FCustomColor := Value;
  if FShowCustomColor then
  begin
    Items.Objects[ Items.Count - 1 ] := TObject( Value );
    Invalidate;
  end;
end;


function TRzColorComboBox.GetSelectedColor: TColor;
begin
  if ItemIndex = -1 then
    Result := FDefaultColor
  else
    Result := GetColorFromItem( ItemIndex );
end;


procedure TRzColorComboBox.SetSelectedColor( Value: TColor );
var
  I: Integer;
  Found: Boolean;
begin
  Found := False;
  I := 0;

  while ( I < Items.Count ) and not Found do
  begin
    if TColor( Items.Objects[ I ] ) = Value then
      Found := True
    else
      Inc( I );
  end;

  if Found then
    ItemIndex := I
  else
  begin
    SetCustomColor( Value );
    ItemIndex := Items.Count - 1;
  end;

  Change;                                   // Generate the OnChange event
end; {= TRzColorComboBox.SetSelectedColor =}


procedure TRzColorComboBox.SetFrameVisible( Value: Boolean );
var
  C: TColor;
begin
  C := SelectedColor;
  inherited;
  SelectedColor := C;
end;


procedure TRzColorComboBox.SetRegIniFile( Value: TRzRegIniFile );
begin
  if FRegIniFile <> Value then
  begin
    FRegIniFile := Value;
    if Value <> nil then
      Value.FreeNotification( Self );
  end;
end;



procedure TRzColorComboBox.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  RecreateWnd;
end;


procedure TRzColorComboBox.CNDrawItem( var Msg: TWMDrawItem );
begin
  { Indent owner-draw rectangle so focus rect doesn't cover color sample }
  if FShowColorNames then
  begin
    with Msg.DrawItemStruct^ do
      rcItem.Left := rcItem.Left + 24;
  end;
  inherited;
end;


procedure TRzColorComboBox.DrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState );
var
  R: TRect;
  InEditField: Boolean;
  RGBColor: Longint;
  YOffset: Integer;
begin
  InEditField := odComboBoxEdit in State;

  with Canvas do
  begin
    FillRect( Rect );

    R := Rect;                         { R represents size of color block }
    InflateRect( R, -2, -2 );
    if not InEditField then
      OffsetRect( R, 2, 0 );

    if FShowColorNames then
    begin
      Dec( R.Left, 24 );
      R.Right := R.Left + 16;
    end
    else if FShowCustomColor and ( Index = Items.Count - 1 ) then
      Dec( R.Right, 20 );

    Brush.Color := GetColorFromItem( Index );
    Pen.Color := clBtnShadow;
    Rectangle( R.Left, R.Top, R.Right, R.Bottom );

    RGBColor := ColorToRGB( Brush.Color );
    if ( ( RGBColor and $00FF0000 ) <= $00800000 ) and
       ( ( RGBColor and $0000FF00 ) <= $00008000 ) and
       ( ( RGBColor and $000000FF ) <= $00000080 ) then
      DrawSides( Canvas, R, clBlack, clBlack, sdAllSides )
    else
      DrawSides( Canvas, R, clGray, clGray, sdAllSides );

    if odSelected in State then
    begin
      Brush.Color := clHighlight;
      Pen.Color := clHighlightText;
    end
    else
    begin
      Brush.Color := Color;
      if Enabled then
        Pen.Color := clWindowText
      else
        Pen.Color := clBtnShadow;
    end;

    if FShowCustomColor and ( Index = Items.Count - 1 ) then
    begin
      { Custom Color Entry -- draw an ellipsis }
      Rectangle( Rect.Right - 16, Rect.Bottom - 7, Rect.Right - 14, Rect.Bottom - 4 );
      Rectangle( Rect.Right - 12, Rect.Bottom - 7, Rect.Right - 10, Rect.Bottom - 4 );
      Rectangle( Rect.Right - 8, Rect.Bottom - 7, Rect.Right - 6, Rect.Bottom - 4 );
    end;

    if FShowColorNames then
    begin
      if not Enabled then
        Font.Color := clBtnShadow;
      YOffset := ( ( Rect.Bottom - Rect.Top ) - TextHeight( 'Yy' ) ) div 2;
      TextOut( Rect.Left + 2, Rect.Top + YOffset, Items[ Index ] );
    end;
  end;
end;

procedure TRzColorComboBox.CNCommand( var Msg: TWMCommand );
begin
  inherited;
  if Msg.NotifyCode = cbn_SelEndCancel then
    FCancelPick := True
  else
    FCancelPick := False;
end;


procedure TRzColorComboBox.CloseUp;
var
  FColorDlg: TColorDialog;
begin
  inherited;

  if not FCancelPick and FShowCustomColor and ( ItemIndex = Items.Count - 1 ) then
  begin

    { Display color dialog box }
    FColorDlg := TColorDialog.Create( Self );
    try
      with FColorDlg do
      begin
        Color := SelectedColor;
        CustomColors := FCustomColors;
        Options := FColorDlgOptions;
        if Execute then
        begin
          SetCustomColors( CustomColors );
          SetCustomColor( Color );
        end;
      end;
    finally
      FColorDlg.Free;
    end;
  end;
end;




{=================================}
{== TRzPreviewFontPanel Methods ==}
{=================================}

constructor TRzPreviewFontPanel.Create( AOwner: TComponent );
begin
  inherited;

  {$IFDEF VCL70_OR_HIGHER}
  // Delphi 7 sets the csParentBackground style and removes the csOpaque style when Themes are available, which causes
  // all kinds of other problems, so we restore these.
  ControlStyle := ControlStyle - [ csParentBackground ] + [ csOpaque ];
  {$ENDIF}

  Color := clWindow;
  Width := 260;
  Height := 65;
  Visible := False;
  Caption := ptDefault;
  BevelOuter := bvNone;
  Font.Size := 36;
end;


procedure TRzPreviewFontPanel.CreateParams( var Params: TCreateParams );
begin
  inherited;
  Params.Style := Params.Style or WS_POPUP;
  Params.WindowClass.Style := CS_SAVEBITS;
end;


procedure TRzPreviewFontPanel.Paint;
begin
  inherited;
  Canvas.Rectangle( 0, 0, Width, Height );
end;


procedure TRzPreviewFontPanel.CMCancelMode( var Msg: TCMCancelMode );
begin
  // cm_CancelMode is sent when user clicks somewhere in same application
  if Msg.Sender <> Self then
    SendMessage( FControl.Handle, cm_HidePreviewPanel, 0, 0 );
end;


procedure TRzPreviewFontPanel.WMKillFocus( var Msg: TMessage );
begin
  // wm_KillFocus is sent went user switches to another application or window
  inherited;
  SendMessage( FControl.Handle, cm_HidePreviewPanel, 0, 0 );
end;


procedure TRzPreviewFontPanel.CMShowingChanged( var Msg: TMessage );
begin
  // Ignore showing using the Visible property
end;


{=============================}
{== TRzFontComboBox Methods ==}
{=============================}

constructor TRzFontComboBox.Create( AOwner: TComponent );
begin
  inherited;
  Style := csOwnerDrawFixed;                  // Style is not published

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

  DropDownCount := 14;
  FMaintainMRUFonts := True;
  FMRUCount := -1;
  FPreviewVisible := False;

  FPreviewPanel := TRzPreviewFontPanel.Create( Self );
  FPreviewPanel.Parent := TWinControl( AOwner );
  FPreviewPanel.Control := Self;

  {&RCI}
end;


procedure TRzFontComboBox.CreateWnd;
begin
  {&RV}
  inherited;
  Clear;
  LoadFonts;
  if FSaveFontName <> '' then
    SetFontName( FSaveFontName );
end;


destructor TRzFontComboBox.Destroy;
begin
  FFont.Free;
  FTrueTypeBmp.Free;
  FFixedPitchBmp.Free;
  FTrueTypeFixedBmp.Free;
  FPrinterBmp.Free;
  FDeviceBmp.Free;
  inherited;
end;


procedure TRzFontComboBox.DestroyWnd;
begin
  FSaveFontName := GetFontName;
  inherited;
end;


function EnumFontsProc( var LogFont: TLogFont; var TextMetric: TTextMetric; FontType: Integer;
                        Data: Pointer ): Integer; stdcall;
begin
  with TRzFontComboBox( Data ), TextMetric do
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


procedure TRzFontComboBox.LoadFonts;
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


procedure TRzFontComboBox.LoadBitmaps;
begin
  FTrueTypeBmp.Handle := LoadBitmap( HInstance, 'RZCMBOBX_TRUETYPE' );
  FFixedPitchBmp.Handle := LoadBitmap( HInstance, 'RZCMBOBX_FIXEDPITCH' );
  FTrueTypeFixedBmp.Handle := LoadBitmap( HInstance, 'RZCMBOBX_TRUETYPEFIXED' );
  FPrinterBmp.Handle := LoadBitmap( HInstance, 'RZCMBOBX_PRINTER' );
  FDeviceBmp.Handle := LoadBitmap( HInstance, 'RZCMBOBX_DEVICE' );
end;


procedure TRzFontComboBox.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if ( AComponent = FPreviewEdit ) and ( Operation = opRemove ) then
    FPreviewEdit := nil;
end;


procedure TRzFontComboBox.HidePreviewPanel;
begin
  if FPreviewVisible then
  begin
    FPreviewVisible := False;
    SetWindowPos( FPreviewPanel.Handle, 0, 0, 0, 0, 0,
                  swp_NoActivate or swp_NoZOrder or swp_NoMove or swp_NoSize or
                  swp_HideWindow );
  end;
end;


procedure TRzFontComboBox.ShowPreviewPanel;
var
  P: TPoint;
begin
  // Make sure there are items in the list
  if Items.Count = 0 then
    Exit;

  P := ClientToScreen( Point( 0, 0 ) );
  if DropDownWidth = 0 then
    P.X := P.X + Width
  else
    P.X := P.X + DropDownWidth;

  // Because FPreviewPanel has style WS_POPUP, Left and Top values to SetWindowPos are screen coordinates

  SetWindowPos( FPreviewPanel.Handle, 0, P.X - 1, P.Y,
                FPreviewPanel.Width, FPreviewPanel.Height,
                swp_NoActivate or swp_ShowWindow );
  FPreviewVisible := True;
end;


procedure TRzFontComboBox.CMCancelMode( var Msg: TCMCancelMode );
begin
  // cm_CancelMode is sent when user clicks somewhere in same application
  if ( FShowStyle = ssFontPreview ) and ( Msg.Sender <> Self ) then
    HidePreviewPanel;
end;


procedure TRzFontComboBox.CMHidePreviewPanel( var Msg: TMessage );
begin
  inherited;
  HidePreviewPanel;
end;


procedure TRzFontComboBox.UpdatePreviewText;
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


procedure TRzFontComboBox.DropDown;
begin
  UpdatePreviewText;
  inherited;
  if FShowStyle = ssFontPreview then
    ShowPreviewPanel;
end;


procedure TRzFontComboBox.CloseUp;
var
  Idx, I: Integer;
  FoundMRUFont: Boolean;
begin
  inherited;
  if FShowStyle = ssFontPreview then
    HidePreviewPanel;

  if FMaintainMRUFonts and ( Itemindex <> 0 ) then
  begin
    Idx := ItemIndex;
    if Idx = -1 then
      Exit;
    // Add selected item to Top of list if not already at the Top
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
      Items.Move( I, 0 );                   // Move MRU font to Top of list
    end
    else
    begin
      // Make a copy of the selected font to appear in MRU portion at Top of list
      Items.InsertObject( 0, Items[ Idx ], Items.Objects[ Idx ] );
      if Idx > FMRUCount then
        Inc( FMRUCount );
    end;
    ItemIndex := 0;
  end;
end; {= TRzFontComboBox.CloseUp =}



procedure TRzFontComboBox.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  RecreateWnd;
end;


procedure TRzFontComboBox.CNDrawItem( var Msg: TWMDrawItem );
begin
  // Indent owner-draw rectangle so focus rect doesn't cover glyph
  with Msg.DrawItemStruct^ do
    rcItem.Left := rcItem.Left + 24;
  inherited;
end;


procedure TRzFontComboBox.DrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState );
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

  Bmp := TBitmap.Create;
  try
    Canvas.FillRect( Rect );   { Clear area for icon and text }

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
      Canvas.Draw( Rect.Left - 20, Rect.Top + BmpOffset, Bmp );
    end
    else if ( FT and tmpf_TrueType ) = tmpf_TrueType then
    begin
      Bmp.Canvas.BrushCopy( DestRct, FTrueTypeBmp, SrcRct, TransparentColor );
      Canvas.Draw( Rect.Left - 20, Rect.Top + BmpOffset, Bmp );
    end
    else if ( FT and tmpf_Fixed_Pitch ) <> tmpf_Fixed_Pitch then
    begin
      Bmp.Canvas.BrushCopy( DestRct, FFixedPitchBmp, SrcRct, TransparentColor );
      Canvas.Draw( Rect.Left - 20, Rect.Top + BmpOffset, Bmp );
    end
    else if FFontDevice = fdPrinter then
    begin
      Bmp.Canvas.BrushCopy( DestRct, FPrinterBmp, SrcRct, TransparentColor );
      Canvas.Draw( Rect.Left - 20, Rect.Top + BmpOffset, Bmp );
    end
    else
    begin
      Bmp.Canvas.BrushCopy( DestRct, FDeviceBmp, SrcRct, TransparentColor );
      Canvas.Draw( Rect.Left - 20, Rect.Top + BmpOffset, Bmp );
    end;

    if not Enabled then
      Canvas.Font.Color := clBtnShadow;

    TempStyle := FShowStyle;
    if InEditField and ( TempStyle = ssFontNameAndSample ) then
      TempStyle := ssFontName;

    TextOffset := ( ( Rect.Bottom - Rect.Top ) - Canvas.TextHeight( 'Yy' ) ) div 2;
    case TempStyle of
      ssFontName, ssFontPreview:
      begin
        Canvas.TextRect( Rect, Rect.Left + 2, Rect.Top + TextOffset, Items[ Index ] );
      end;

      ssFontSample:
      begin
        Canvas.Font.Name := Items[ Index ];
        Canvas.TextRect( Rect, Rect.Left + 2, Rect.Top + TextOffset, Items[ Index ] );
      end;

      ssFontNameAndSample:
      begin
        R := Rect;
        R.Right := R.Left + ( R.Right - R.Left ) div 2 - 4;
        Canvas.Font.Name := Self.Font.Name;
        Canvas.TextRect( R, R.Left + 2, R.Top + TextOffset, Items[ Index ] );

        if Enabled then
          Canvas.Pen.Color := clWindowText
        else
          Canvas.Pen.Color := clBtnShadow;

        Canvas.MoveTo( R.Right + 2, R.Top );
        Canvas.LineTo( R.Right + 2, R.Bottom );

        Canvas.Font.Name := Items[ Index ];
        R.Left := R.Right + 4;
        R.Right := Rect.Right;
        Canvas.TextRect( R, R.Left + 2, R.Top + TextOffset, Items[ Index ] );
      end;
    end;
  finally
    Bmp.Free;
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


end; {= TRzFontComboBox.DrawItem =}


procedure TRzFontComboBox.SetFontDevice( Value: TRzFontDevice );
begin
  if FFontDevice <> Value then
  begin
    FFontDevice := Value;
    RecreateWnd;
  end;
end;


procedure TRzFontComboBox.SetFontType( Value: TRzFontType );
begin
  if FFontType <> Value then
  begin
    FFontType := Value;
    RecreateWnd;
  end;
end;


function TRzFontComboBox.GetSelectedFont: TFont;
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


procedure TRzFontComboBox.SetSelectedFont( Value: TFont );
begin
  ItemIndex := Items.IndexOf( Value.Name );
end;


function TRzFontComboBox.GetFontName: string;
begin
  if ItemIndex >= 0 then
    Result := Items[ ItemIndex ]
  else
    Result := '';
end;


procedure TRzFontComboBox.SetFontName( const Value: string );
begin
  ItemIndex := Items.IndexOf( Value );
end;


procedure TRzFontComboBox.SetShowSymbolFonts( Value: Boolean );
begin
  if FShowSymbolFonts <> Value then
  begin
    FShowSymbolFonts := Value;
    RecreateWnd;
  end;
end;


procedure TRzFontComboBox.SetShowStyle( Value: TRzShowStyle );
begin
  if FShowStyle <> Value then
  begin
    FShowStyle := Value;
    Invalidate;
  end;
end;


procedure TRzFontComboBox.SetPreviewEdit( Value: TCustomEdit );
begin
  FPreviewEdit := Value;
  if FPreviewEdit <> nil then
    FPreviewEdit.FreeNotification( Self );
end;


function TRzFontComboBox.GetPreviewFontSize: Integer;
begin
  Result := FPreviewPanel.Font.Size;
end;

procedure TRzFontComboBox.SetPreviewFontSize( Value: Integer );
begin
  FPreviewPanel.Font.Size := Value;
end;


function TRzFontComboBox.GetPreviewHeight: Integer;
begin
  Result := FPreviewPanel.Height;
end;

procedure TRzFontComboBox.SetPreviewHeight( Value: Integer );
begin
  FPreviewPanel.Height := Value;
end;


function TRzFontComboBox.GetPreviewWidth: Integer;
begin
  Result := FPreviewPanel.Width;
end;

procedure TRzFontComboBox.SetPreviewWidth( Value: Integer );
begin
  FPreviewPanel.Width := Value;
end;


{============================}
{== TRzMRUComboBox Methods ==}
{============================}

constructor TRzMRUComboBox.Create( AOwner: TComponent );
begin
  inherited;
  {&RCI}
  FSelectFirstItemOnLoad := False;
  FRemoveItemCaption := '&Remove item from history list';

  FMruPath := '';

  FMruSection := '';
  FMruID := '';

  FDataIsLoaded := False;
  FMaxHistory := 25;
  inherited Sorted := False;

  { Build custom popup menu }
  CreatePopupMenuItems;
  InitializePopupMenuItems;
  AddMenuItemsToPopupMenu;
end;


procedure TRzMRUComboBox.CreateWnd;
begin
  inherited;

  if not ( csLoading in ComponentState ) and not FDataIsLoaded then
  begin
    if ( ( FMruPath <> '' ) or ( FMruRegIniFile <> nil ) ) and
       ( FMruSection <> '' ) and ( FMruID <> '' ) then
    begin
      LoadMRUData( False );
    end;
  end;
end;


destructor TRzMRUComboBox.Destroy;
begin
  inherited;
end;


procedure TRzMRUComboBox.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if ( Operation = opRemove ) and ( AComponent = FMruRegIniFile ) then
    FMruRegIniFile := nil;
end;


procedure TRzMRUComboBox.Loaded;
begin
  inherited;
  LoadMRUData( True );
  {&RV}
end;


procedure TRzMRUComboBox.LoadMRUData( FromStream: Boolean );
var
  I, Idx, AddIdx, NumMRUItems: Integer;
  ItemStr: string;
  R: TRzRegIniFile;
begin
  { Make sure we have the necessary data to read the MRU values }
  if ( csDesigning in ComponentState ) or
     ( ( FMruPath = '' ) and ( FMruRegIniFile = nil ) ) or
     ( FMruSection = '' ) or
     ( FMruID = '' ) then
  begin
    Exit;
  end;

  if FMruRegIniFile <> nil then
    R := FMruRegIniFile
  else
  begin
    R := TRzRegIniFile.Create( Self );
    R.PathType := ptRegistry;
    R.Path := FMruPath;
  end;

  try
    NumMRUItems := R.ReadInteger( FMruSection, FMruID + '_Count', 0 );
    for I := 0 to NumMRUItems - 1 do
    begin
      ItemStr := R.ReadString( FMruSection, FMruID + '_Item' + IntToStr( I ), '' );

      if ItemStr <> '' then
      begin
        if FromStream then
        begin
          Idx := Items.IndexOf( ItemStr );
          if Idx = -1 then
          begin
            AddIdx := Items.Add( ItemStr );
            Items.Move( AddIdx, I );
          end
          else
          begin
            Items.Move( Idx, I );
          end;
        end
        else
        begin
          Idx := Items.IndexOf( ItemStr );
          if Idx = -1 then
            Items.Add( ItemStr );
        end;
      end;
    end;

    if FSelectFirstItemOnLoad and ( Items.Count > 0 ) then
      ItemIndex := 0;                      { Select the first item in the list }

    FDataIsLoaded := True;
  finally
    if FMruRegIniFile = nil then
      R.Free;
  end;
end; {= TRzMRUComboBox.LoadMRUData =}


procedure TRzMRUComboBox.SaveMRUData;
var
  NumItemsToSave, I: Integer;
  R: TRzRegIniFile;
begin
  { Make sure we have the necessary data to save the MRU values }
  if ( ( FMruPath = '' ) and ( FMruRegIniFile = nil ) ) or ( FMruSection = '' ) or ( FMruID = '' ) then
    Exit;

  if FMruRegIniFile <> nil then
    R := FMruRegIniFile
  else
  begin
    R := TRzRegIniFile.Create( Self );
    R.PathType := ptRegistry;
    R.Path := FMruPath;
  end;

  try
    NumItemsToSave := Items.Count;
    if NumItemsToSave > FMaxHistory then
      NumItemsToSave := FMaxHistory;

    R.WriteInteger( FMruSection, FMruID + '_Count', NumItemsToSave );

    for I := 0 to NumItemsToSave - 1 do
      R.WriteString( FMruSection, FMruID + '_Item' + IntToStr( I ), Items[ I ] );

    { Clean up entries no longer being used }
    for I := NumItemsToSave to FMaxHistory - 1 do
      R.DeleteKey( FMruSection, FMruID + '_Item' + IntToStr( I ) );
  finally
    if FMruRegIniFile = nil then
      R.Free;
  end;
end; {= TRzMRUComboBox.SaveMRUData =}



procedure TRzMRUComboBox.UpdateMRUList;
var
  S: string;
  Idx: Integer;
begin
  if Text = '' then
    Exit;

  Idx := Items.IndexOf( Text );
  if Idx = -1 then
    Items.Insert( 0, Text )	                     { Insert entry at Top of list }
  else
  begin
    { Entry is already in list. Let's move it to the Top }
    { Must save and restore since call to Move clears text }
    S := Text;
    Items.Move( Idx, 0 );
    if Style = csDropDownList then
      ItemIndex := 0
    else
      Text := S;

  end;
  SaveMRUData;	                       { Save data since we just made a change }
end;


procedure TRzMRUComboBox.DoExit;
begin
  inherited;
  UpdateMRUList;
end;


procedure TRzMRUComboBox.CreatePopupMenuItems;
begin
  FEmbeddedMenu := TPopupMenu.Create( Self );
  inherited PopupMenu := FEmbeddedMenu;

  FMnuUndo := TMenuItem.Create( FEmbeddedMenu );
  FMnuSeparator1 := TMenuItem.Create( FEmbeddedMenu );
  FMnuCut := TMenuItem.Create( FEmbeddedMenu );
  FMnuCopy := TMenuItem.Create( FEmbeddedMenu );
  FMnuPaste := TMenuItem.Create( FEmbeddedMenu );
  FMnuDelete := TMenuItem.Create( FEmbeddedMenu );
  FMnuSeparator2 := TMenuItem.Create( FEmbeddedMenu );
  FMnuSelectAll := TMenuItem.Create( FEmbeddedMenu );
  FMnuSeparator3 := TMenuItem.Create( FEmbeddedMenu );
  FMnuRemove := TMenuItem.Create( FEmbeddedMenu );
end;


procedure TRzMRUComboBox.SetupMenuItem( AMenuItem: TMenuItem; ACaption: string; AChecked, ARadioItem: Boolean;
                                        AGroupIndex, AShortCut: Integer; AHandler: TNotifyEvent );
begin
  with AMenuItem do
  begin
    Caption := ACaption;
    Checked := AChecked;
    RadioItem := ARadioItem;
    GroupIndex := AGroupIndex;
    ShortCut := AShortCut;
    OnClick := AHandler;
    Tag := FPopupMenuTag;
    Inc( FPopupMenuTag );
  end;
end;



procedure TRzMRUComboBox.InitializePopupMenuItems;
var
  ShellLib: THandle;

  { Get popup menu captions from Shell32.dll }
  function GetMenuText( ID: DWORD ): string;
  var
    Stz: array[ 0..255 ] of Char;
  begin
    if LoadString( ShellLib, ID, Stz, 255 ) <> 0 then
      Result := StrPas( Stz )
    else
      Result := '';
  end;

begin
  ShellLib := LoadLibrary( 'Shell32' );
  try
    FPopupMenuTag := 0;
    SetupMenuItem( FMnuUndo, GetMenuText( 33563 ), False, False, 0, 0, MnuUndoClickHandler );
    SetupMenuItem( FMnuSeparator1, '-', False, False, 0, 0, nil );
    SetupMenuItem( FMnuCut, GetMenuText( 33560 ), False, False, 0, 0, MnuCutClickHandler );
    SetupMenuItem( FMnuCopy, GetMenuText( 33561 ), False, False, 0, 0, MnuCopyClickHandler );
    SetupMenuItem( FMnuPaste, GetMenuText( 33562 ), False, False, 0, 0, MnuPasteClickHandler );
    SetupMenuItem( FMnuDelete, GetMenuText( 33553 ), False, False, 0, 0, MnuDeleteClickHandler );
    SetupMenuItem( FMnuSeparator2, '-', False, False, 0, 0, nil );
    SetupMenuItem( FMnuSelectAll, GetMenuText( 4171 ), False, False, 0, 0, MnuSelectAllClickHandler );
    SetupMenuItem( FMnuSeparator3, '-', False, False, 0, 0, nil );
    SetupMenuItem( FMnuRemove, FRemoveItemCaption, False, False, 0, 0, MnuRemoveItemClickHandler );
  finally
    FreeLibrary( ShellLib );
  end;
end;


procedure TRzMRUComboBox.AddMenuItemsToPopupMenu;
begin
  with FEmbeddedMenu do
  begin
    OnPopup := EmbeddedMenuPopupHandler;

    { Add menu items in the order they should appear in the popup menu }
    Items.Add( FMnuUndo );
    Items.Add( FMnuSeparator1 );
    Items.Add( FMnuCut );
    Items.Add( FMnuCopy );
    Items.Add( FMnuPaste );
    Items.Add( FMnuDelete );
    Items.Add( FMnuSeparator2 );
    Items.Add( FMnuSelectAll );
    Items.Add( FMnuSeparator3 );
    Items.Add( FMnuRemove );
  end;
end;


procedure TRzMRUComboBox.EmbeddedMenuPopupHandler( Sender: TObject );
var
  CanUndo, TextIsOnClipboard, HasSelection: Boolean;
begin
  Windows.SetFocus( Handle );
  if Focused then
  begin
    HasSelection := ( SelLength <> 0 );
    CanUndo := SendMessage( EditHandle, em_CanUndo, 0, 0 ) <> 0;

    TextIsOnClipboard := Clipboard.AsText <> '';

    FMnuCut.Enabled := HasSelection;
    FMnuCopy.Enabled := HasSelection;
    FMnuDelete.Enabled := HasSelection;
    FMnuUndo.Enabled := CanUndo;
    FMnuPaste.Enabled := TextIsOnClipboard;
    FMnuSelectAll.Enabled := Text <> '';
    FMnuRemove.Enabled := Text <> '';
  end;
end;


procedure TRzMRUComboBox.MnuUndoClickHandler( Sender: TObject );
begin
  SendMessage( EditHandle, em_Undo, 0, 0 );
end;

procedure TRzMRUComboBox.MnuCutClickHandler( Sender: TObject );
begin
  Perform( wm_Cut, 0, 0 );
end;

procedure TRzMRUComboBox.MnuCopyClickHandler( Sender: TObject );
begin
  Perform( wm_Copy, 0, 0 );
end;

procedure TRzMRUComboBox.MnuPasteClickHandler( Sender: TObject );
begin
  Perform( wm_Paste, 0, 0 );
end;

procedure TRzMRUComboBox.MnuDeleteClickHandler( Sender: TObject );
begin
  Perform( wm_Clear, 0, 0 );
end;

procedure TRzMRUComboBox.MnuSelectAllClickHandler( Sender: TObject );
begin
  Perform( cb_SetEditSel, 0, MakeLong( 0, Word( -1 ) ) );
end;


procedure TRzMRUComboBox.MnuRemoveItemClickHandler( Sender: TObject );
var
  I: Integer;
begin
  I := Items.IndexOf( Text );
  if I >= 0 then
  begin
    Items.Delete( I );
    SaveMRUData;
  end;
  Text := '';
  Change;
end;


procedure TRzMRUComboBox.SetRemoveItemCaption( const Value: string );
begin
  if FRemoveItemCaption <> Value then
  begin
    FRemoveItemCaption := Value;
    if Assigned( FMnuRemove ) then
      FMnuRemove.Caption := FRemoveItemCaption;
  end;
end;


procedure TRzMRUComboBox.SetMruRegIniFile( Value: TRzRegIniFile );
begin
  if FMruRegIniFile <> Value then
  begin
    FMruRegIniFile := Value;
    if Value <> nil then
      Value.FreeNotification( Self );
  end;
end;


procedure TRzMRUComboBox.EscapeKeyPressed;
begin
  if Assigned( FOnEscapeKeyPressed ) then
    FOnEscapeKeyPressed( Self );
end;

procedure TRzMRUComboBox.EnterKeyPressed;
begin
  if Assigned( FOnEnterKeyPressed ) then
    FOnEnterKeyPressed( Self );
  {&RV}
end;


procedure TRzMRUComboBox.KeyPress( var Key: Char );
begin
  if Ord( Key ) = vk_Return then                           { Enter key pressed }
  begin
    UpdateMRUList;
    EnterKeyPressed;
    if FTabOnEnter then
    begin
      Key := #0;
      PostMessage( Handle, wm_KeyDown, vk_Tab, 0 );
    end;
  end
  else if Ord( Key ) = vk_Escape then                     { Escape key pressed }
  begin
    EscapeKeyPressed;
  end
  else
    inherited;
end;


{==================================}
{== TRzImageComboBoxItem Methods ==}
{==================================}

constructor TRzImageComboBoxItem.Create( AOwner: TRzCustomImageComboBox );
begin
  inherited Create;
  FOwner := aOwner;
  FOverlayIndex := -1;
  {$IFDEF PTDEBUG}
  Inc( FOwner.mdbgItems );
  Inc( g_dbgItems );
  {$ENDIF}
end;

destructor TRzImageComboBoxItem.Destroy;
begin
  {$IFDEF PTDEBUG}
  Dec( FOwner.mdbgItems );
  Dec( g_dbgItems );
  {$ENDIF}
  inherited;
end;

procedure TRzImageComboBoxItem.SetIndentLevel( Value: Integer );
begin
  FIndentLevel := Value;
  FOwner.Invalidate;
end;

procedure TRzImageComboBoxItem.SetImageIndex( Value: Integer );
begin
  FImageIndex := Value;
  FOwner.Invalidate;
end;

procedure TRzImageComboBoxItem.SetCaption( const Value: string );
begin
  FCaption := Value;
  FOwner.Invalidate;
end;

procedure TRzImageComboBoxItem.SetOverlayIndex( Value: Integer );
begin
  FOverlayIndex := Value;
  FOwner.Invalidate;
end;


{============================}
{== TRzCustomImageComboBox ==}
{============================}

constructor TRzCustomImageComboBox.Create( AOwner: TComponent );
begin
  inherited;

  FShowFocus := False;
  Style := csOwnerDrawFixed;
  FItemIndent := 12;
  FAutoSizeHeight := True;
end;


procedure TRzCustomImageComboBox.CreateParams( var Params: TCreateParams );
begin
  inherited;

  if RunningUnder( WinNT ) then
  begin
    // PT Comments -
    // Under Windows NT (4.0) if the combo has the CBS_HASSTRINGS style set,
    // then when the WM_DELETEITEM message is sent, the itemData member of the
    // DELETEITEMSTRUCT record is 0 (so we GP fault and items leak).
    // The unfortunate side effect of this fix is that keyboard access doesn't
    // work anymore.

    Params.Style := Params.Style and not CBS_HASSTRINGS;
  end;
end;


procedure TRzCustomImageComboBox.CreateWnd;
begin
  inherited;
  SendMessage( Handle, CB_SETEXTENDEDUI, 1, 0 );
end;


procedure TRzCustomImageComboBox.DestroyWnd;
begin
  inherited Items.Clear; // Prevent TCustomCombobox.DestroyWnd from streaming out Items.
  inherited;
end;


procedure TRzCustomImageComboBox.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( AComponent = FImages ) then
    FImages := nil;
end;


function TRzCustomImageComboBox.GetImageComboBoxItem( Index: Integer ): TRzImageComboBoxItem;
begin
  Result := inherited Items.Objects[ Index ] as TRzImageComboBoxItem;
end;


procedure TRzCustomImageComboBox.DrawItem( Index: Integer; Rect: TRect; State: TOwnerDrawState );
var
  Item: TRzImageComboBoxItem;
  X, Top, Indent: Integer;
  R: TRect;
  OldBkColor: TColorRef;
begin
  if Assigned( OnDrawItem ) then
    OnDrawItem( Self, Index, Rect, State )
  else
  begin
    Item := inherited Items.Objects[ Index ] as TRzImageComboBoxItem;
    if not Assigned( Item ) then
      Exit;

    GetItemData( Item );

    {$IFDEF VCL60_OR_HIGHER}
    if odComboBoxEdit in State then
      Indent := 0
    else
      Indent := Item.IndentLevel;
    {$ELSE}
    if WindowFromDC( Canvas.Handle ) = Handle then
      Indent := 0
    else
      Indent := Item.IndentLevel;
    // PT: Should check odComboBoxEdit (aka. ODS_COMBOBOXEDIT) in aState, but StdCtrls doesn't declare it
    // PT: This WindowFromDC trick works Ok though.
    {$ENDIF}

    Canvas.Brush.Color := Color;
    Canvas.FillRect( Rect );

    if Assigned( FImages ) then
    begin
      if odSelected in State then
      begin
        Canvas.Brush.Color := clHighlight;
        FImages.BlendColor := clHighlight;
        FImages.DrawingStyle := dsSelected;
      end
      else
        FImages.DrawingStyle := dsNormal;

      // Use the API to prevent a Change event occuring for the imagelist component
      OldBkColor := ImageList_GetBkColor( FImages.Handle );
      try
        ImageList_SetBkColor( FImages.Handle, ColorToRGB( Color ) );
        Top := ( Rect.Top + Rect.Bottom - FImages.Height ) div 2;
        if ( Item.OverlayIndex < 0 ) then
          FImages.Draw( Canvas, Rect.Left + Indent * FItemIndent + 2, Top, Item.ImageIndex )
        else
          FImages.DrawOverlay( Canvas, Rect.Left + Indent * FItemIndent + 2, Top, Item.ImageIndex, Item.OverlayIndex );
      finally
        ImageList_SetBkColor( FImages.Handle, OldBkColor );
      end;
    end;

    if odSelected in State then
      Canvas.Brush.Color := clHighlight;

    if Item.Caption <> '' then
    begin
      if Assigned( FImages ) then
        X := FImages.Width + 4
      else
        X := 4;
      R.Left := Rect.Left + Indent * FItemIndent + 2 + X - 1;
      R.Top := Rect.Top;
      R.Right := R.Left + Canvas.TextWidth( Item.Caption ) + 1 + 2;
      R.Bottom := Rect.Bottom - 1;

      if not Enabled then
        Canvas.Font.Color := clBtnShadow;

      Canvas.TextRect( R, R.Left + 1, R.Top + 1, Item.Caption );
    end;
  end;
end; {= TRzCustomImageComboBox.DrawItem =}


procedure TRzCustomImageComboBox.WMEraseBkgnd( var Msg: TWMEraseBkgnd );
var
  Brush: TBrush;
begin
  Brush := TBrush.Create;
  if Owner is TForm then
    Brush.Color := TForm( Owner ).Color
  else
    Brush.Color := clWindow;
  Windows.FillRect( Msg.DC, ClientRect, Brush.Handle );
  Brush.Free;
  Msg.Result := 1;
end;


procedure TRzCustomImageComboBox.WMSetFont( var Msg: TWMSetFont );
begin
  if not FInWMSetFont then
  begin
    try
      FInWMSetFont := True;
      AutoSize( Msg.Font );
      inherited;
    finally
      FInWMSetFont := False;
    end;
  end
  else
    inherited;
end;


function TRzCustomImageComboBox.AddItem( Caption: string; ImageIndex: Integer; IndentLevel: Integer ): TRzImageComboBoxItem;
const
  NOSTRING: string = '';
begin
  Result := TRzImageComboBoxItem.Create( Self );
  Result.FCaption := Caption;
  Result.FImageIndex := ImageIndex;
  Result.FIndentLevel := IndentLevel;
  if RunningUnder( WinNT ) then
    Result.FIndex := inherited Items.AddObject( NOSTRING, Result )
  else
    Result.FIndex := inherited Items.AddObject( Caption, Result );
end;


procedure TRzCustomImageComboBox.ItemsBeginUpdate;
begin
  inherited Items.BeginUpdate;
end;


procedure TRzCustomImageComboBox.ItemsEndUpdate;
begin
  inherited Items.EndUpdate;
end;


procedure TRzCustomImageComboBox.DoAutoSize( hf: HFONT );
var
  H: Integer;
  oldf: HFONT;
  dc: HDC;
  tm: TTextMetric;
begin
  dc := GetDC( 0 );
  oldf := 0;
  try
    oldf := SelectObject( dc, hf );
    GetTextMetrics( dc, tm );
    H := Abs( tm.tmHeight ) + 4;
  finally
    if ( oldf <> 0 ) then
      SelectObject( dc, oldf );
    ReleaseDC( 0, dc );
  end;
  if Assigned( FImages ) and ( FImages.Height > H ) then
    H := FImages.Height;
  ItemHeight := H;
end;


procedure TRzCustomImageComboBox.AutoSize( hf: HFONT );
begin
  if AutoSizeHeight then
    DoAutoSize( hf );
end;


procedure TRzCustomImageComboBox.SetItemIndent( Value: Integer );
begin
  if FItemIndent <> Value then
  begin
    FItemIndent := Value;
    Invalidate;
  end;
end;


procedure TRzCustomImageComboBox.SetImages( const Value: TCustomImageList );
begin
  FImages := Value;
  Invalidate;
  if Assigned( FImages ) then
    FImages.FreeNotification( Self );
  if not ( csLoading in ComponentState ) then
    AutoSize( Font.Handle );
end;


procedure TRzCustomImageComboBox.DeleteItem( Item: Pointer );
begin
  if Assigned( OnDeleteItem ) then
    OnDeleteItem( Self, TRzImageComboBoxItem( Item ) );

  // This method gets called as a result of calling Items.Move and Items.Exchange.
  // As such, we do not want to free the associated object in these cases.
  if ( FFreeObjOnDelete or ( csDestroying in ComponentState ) ) and Assigned( Item ) then
    TObject( Item ).Free;
end;


procedure TRzCustomImageComboBox.GetItemData( Item: TRzImageComboBoxItem );
begin
  if Assigned( FOnGetItemData ) then
    FOnGetItemData( Self, Item );
end;


procedure TRzCustomImageComboBox.Delete( Index: Integer );
begin
  FFreeObjOnDelete := True;
  try
    Items.Delete( Index );
  finally
    FFreeObjOnDelete := False;
  end;
end;


function TRzCustomImageComboBox.IndexOf( const S: string ): Integer;

  function GetCaption( Idx: Integer ): string;
  var
    Item: TRzImageComboBoxItem;
  begin
    Item := inherited Items.Objects[ Idx ] as TRzImageComboBoxItem;
    if Item <> nil then
      Result := Item.Caption
    else
      Result := '';
  end;

begin
  for Result := 0 to Items.Count - 1 do
  begin
    if AnsiCompareText( GetCaption( Result ), S ) = 0 then
      Exit;
  end;
  Result := -1;
end;



{&RUIF}
end.
