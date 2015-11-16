{===============================================================================
  RzDBEdit Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzDBEdit             Data-Aware TRzEdit
  TRzDBNumericEdit      Data-Aware TRzNumericEdit
  TRzDBExpandEdit       Data-Aware TRzExpandEdit
  TRzDBDateTimeEdit     Data-Aware TRzDateTimeEdit
  TRzDBMemo             Data-Aware TRzMemo
  TRzDBRichEdit         Data-Aware TRzRichEdit


  Modification History
  ------------------------------------------------------------------------------
  3.0.10 (26 Dec 2003)
    * Fixed problem in TRzDBDateTimeEdit where using Minus key or Down Arrow key
      to change time value would result in an incorrect time value if the change
      would cause the time to be earlier than midnight (i.e. 12:00 am).
    * Enhanced TRzDateTimeEdit to allow entry of unformatted 8-digit date
      strings and correctly convert it to an actual date.
    * Fixed problem where changing ParentColor to True in a control using Custom
      Framing did not reset internal color fields used to manage the color of
      the control at various states.
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Added OnGetWeekNumber event to TRzDBDateTimeEdit. Handle this event to
      implement a customized week numbering scheme.
    * Added OnRangeError event to TRzNumericEdit. This event is generated when
      the user leaves the field and the value entered by the user exceeds the
      bounds defined by the Min and Max properties.
    * Fixed problem where Line property in TRzDBMemo and TRzDBRichEdit would not
      return the correct value when text was selected.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Fixed problem where user could not enter a positive number into a
      TRzDBNumericEdit if the first character in the selection was a '-' sign.
    * Fixed problem where taking a screen capture of a TRzDBEdit when
      PasswordChar was <> #0 caused the real text to appear in the capture.
    * Fixed display problems when edit controls were placed on a TDBCtrlGrid.
    * Added OnDateTimeChange to TRzDBDateTimeEdit. This event fires whenever the
      date/time value in the edit field changes.
    * Fixed problem where selected text at beginning of a TRzDBNumericEdit that
      contained a '+' or '-' sign could not be replaced by pressing the '+' or
      '-' keys.
  ------------------------------------------------------------------------------
  3.0.6  (11 Apr 2003)
    * Fixed problem where using the TimePicker to set the time in a
      TRzDBDateTimeEdit's Time to 12:00 AM did not enter 12:00 AM into the edit
      field.
    * Fixed problem where a digit could be entered to the left of a sign symbol
      in TRzDBNumericEdit.
    * Fixed problem where drop-down TimePicker was closing in response to the
      wrong event.
  ------------------------------------------------------------------------------
  3.0.5  (24 Mar 2003)
    * Fixed problem with enter 12:00 am into TRzDBDateTimeEdit and leaving the
      field changed the time to 12:00 PM.
    * Clear method now correctly clears the TRzDBDateTimeEdit and it internal
      datetime value and sets the corresponding database field to NULL.
    * Modified TRzDBNumericEdit.EvaluteText so that string conversion is avoided
      if text just contains a leading minus sign or open paren indicating a
      negative number. This change prevents the beep from sounded if the text
      value cannot be converted.
    * Fixed problem in TRzDBEdit.WMPaint where Msg.DC was being passed to
      SendMessage as a WParam and was not casted to a WParam (i.e. Longint).
    * Fixed problem where leaving a TRzDBDateTimeEdit (with EditType=etTime)
      after deleting selected time value caused 12:00 AM (or appropriately
      formatted time) to appear in control.
    * Fixed problem where clearing the date/time value from a TRzDBDateTimeEdit
      did not write NULL to the database field.
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * Fixed problem where empty TRzDBNumericEdit would not write NULL to
      database field even if AllowBlank was set to True.
    * Fixed problem where format of TRzDBDateTimeEdit would change when control
      received the focus.
    * Fixed problem where OnExit event for TRzDBEdit was getting fired twice.
    * Fixed problem where focus would leave TRzDBDateTimeEdit if accelerator
      pressed and the key was a valid date or time value key (e.g. 1, 2, 3...).
    * Surfaced DropButtonVisible in TRzDBDateTimeEdit.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Added IsColorStored and IsFocusColorStored methods so that if control is
      disabled at design-time the Color and FocusColor properties are not
      streamed with the disabled color value.
    * Added additional hot keys to TRzDBDateTimeEdit for changing Day, Month,
      Year, and Hour, Minute.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * TRzDBEdit now descends from TRzCustomEdit instead of from TDBEdit. This
      change was needed so that we can have more control over the painting of
      the data-aware version. The TDBEdit component handles the wm_Paint message
      and does its own painting of the control.
    * Renamed FrameFlat property to FrameHotTrack.
    * Renamed FrameFocusStyle property to FrameHotStyle.
    * Removed FrameFlatStyle property.
    * Published inherited FocusColor and DisabledColor properties.
    * Published inherited FramingPreference property.

    << TRzDBNumericEdit >>
    * Added AllowBlank and BlankValue to TRzDBNumericEdit.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

{$R-}     // Range checking must be turned off so that TRzDBEdit can operate
          // correctly in DBCtrlGrid

unit RzDBEdit;

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
  RzCommon,
  StdCtrls,
  Mask,
  RzEdit,
  DBCtrls,
  RzPopups,
  DB,
  DBCGrids,
  ExtCtrls;

type
  TRzDBEdit = class;

  {---------------------------------------------------------------------------------------------------------------------
    TRzPaintEdit is a simple panel descendant that knows how to look like a TRzDBEdit component. This is necessary for
    the TRzDBEdit component to appear correctly when used in a TDBCtrlGrid. The problem is that the TDBCtrlGrid uses a
    technique that relies on the control being replicated painting itself using a shared device context. Since the
    standard edit control does not do this, the TRzPaintEdit component is used for replicated instances of a TRzDBEdit.
  ---------------------------------------------------------------------------------------------------------------------}

  TRzPaintEdit = class( TCustomPanel )
  private
    FEditControl: TRzDBEdit;
  protected
    procedure Paint; override;
  public
    constructor Create( AOwner: TComponent ); override;
  end;


  {=================================}
  {== TRzDBEdit Class Declaration ==}
  {=================================}

  TRzDBEdit = class( TRzCustomEdit )
  private
    FFocused: Boolean;
    FPaintControl: TRzPaintEdit;
    FDataLink: TFieldDataLink;
    FAlignment: TAlignment;

    { Internal Event Handlers }
    procedure ActiveChangeHandler( Sender: TObject );
    procedure DataChangeHandler( Sender: TObject );
    procedure EditingChangeHandler( Sender: TObject );
    procedure UpdateDataHandler( Sender: TObject );

    { Message Handling Methods }
    procedure WMPaint( var Msg: TWMPaint ); message wm_Paint;
    procedure CMEnter( var Msg: TCMEnter ); message cm_Enter;
    procedure CMExit( var Msg: TCMExit ); message cm_Exit;
    procedure WMCut( var Msg: TMessage ); message wm_Cut;
    procedure WMPaste( var Msg: TMessage ); message wm_Paste;
    procedure WMUndo( var Msg: TMessage ); message wm_undo;
    procedure CMGetDataLink( var Msg: TMessage ); message cm_GetDataLink;
  protected
    FOverControl: Boolean;

    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    procedure RepaintFrame; override;

    function GetRightJustifiedText: string; override;
    procedure AdjustEditRect; virtual;
    function GetEditRect: TRect; override;

    procedure ResetMaxLength;
    function EditCanModify: Boolean; override;
    procedure Reset; override;

    procedure ActiveChanged; virtual;
    procedure DataChanged; virtual;
    procedure EditingChanged; virtual;
    procedure UpdateData; virtual;

    function GetDisplayString: string; virtual;

    { Event Dispatch Methods }
    procedure Change; override;

    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure KeyPress( var Key: Char ); override;

    { Property Access Methods }
    function GetDataField: string; virtual;
    procedure SetDataField( const Value: string ); virtual;
    function GetDataSource: TDataSource; virtual;
    procedure SetDataSource( Value: TDataSource ); virtual;
    function GetField: TField; virtual;
    procedure SetFocused( Value: Boolean ); virtual;
    function GetReadOnly: Boolean; virtual;
    procedure SetReadOnly( Value: Boolean ); virtual;

    procedure SetFrameVisible( Value: Boolean ); override;

    // Give Descendants Access to the DataLink
    property DataLink: TFieldDataLink
      read FDataLink;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function ExecuteAction( Action: TBasicAction ): Boolean; override;
    function UpdateAction( Action: TBasicAction ): Boolean; override;
    function UseRightToLeftAlignment: Boolean; override;

    property Field: TField
      read GetField;

    property Text;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property DataSource: TDataSource
      read GetDataSource
      write SetDataSource;

    property DataField: string
      read GetDataField
      write SetDataField;

    property ReadOnly: Boolean
      read GetReadOnly
      write SetReadOnly
      default False;

    { Inherited Properties & Events }
    property Align;
    property Alignment;
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
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
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
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnStartDock;
    property OnStartDrag;
  end;



  {========================================}
  {== TRzDBNumericEdit Class Declaration ==}
  {========================================}

  TRzDBNumericEdit = class( TRzDBEdit )
  private
    FAllowBlank: Boolean;
    FBlankValue: Extended;
    FCheckRange: Boolean;
    FIntegersOnly: Boolean;
    FMin: Extended;
    FMax: Extended;
    FDisplayFormat: string;
    FFieldValue: Extended;
    FModified: Boolean;

    FOnRangeError: TRzRangeErrorEvent;

    { Message Handling Methods }
    procedure CMEnter( var Msg: TCMEnter ); message cm_Enter;
    procedure CMExit( var Msg: TCMExit ); message cm_Exit;
  protected
    procedure CreateWnd; override;
    procedure CreateParams( var Params: TCreateParams ); override;

    function CleanUpText: string;
    function IsValidChar( Key: Char ): Boolean; virtual;
    function FormatText( const Value: Extended ): string; virtual;
    function EvaluateText: Extended; virtual;

    function GetDisplayString: string; override;

    procedure DataChanged; override;
    procedure UpdateData; override;

    { Event Dispatch Methods }
    procedure KeyPress( var Key: Char ); override;
    procedure RangeError( EnteredValue, AdjustedValue: Extended; var AutoCorrect: Boolean ); dynamic;

    { Property Access Methods }
    procedure SetIntegersOnly( Value: Boolean ); virtual;

    procedure SetMin( const Value: Extended ); virtual;
    procedure SetMax( const Value: Extended ); virtual;

    function GetIntValue: Integer; virtual;
    procedure SetIntValue( Value: Integer ); virtual;
    function GetValue: Extended; virtual;
    function CheckValue( const Value: Extended; var KeepFocusOnEdit: Boolean ): Extended; virtual;
    procedure SetValue( const Value: Extended ); virtual;
    procedure SetDisplayFormat( FormatString: string ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;

    property IntValue: Integer
      read GetIntValue
      write SetIntValue;

    property Modified: Boolean
      read FModified;

   published
    property AllowBlank: Boolean
      read FAllowBlank
      write FAllowBlank
      default True;

    property BlankValue: Extended
      read FBlankValue
      write FBlankValue;

    property CheckRange: Boolean
      read FCheckRange
      write FCheckRange
      default False;

    property IntegersOnly: Boolean
      read FIntegersOnly
      write SetIntegersOnly
      default True;

    property Max: Extended
      read FMax
      write SetMax;

    property Min: Extended
      read FMin
      write SetMin;

    property Value: Extended
      read GetValue
      write SetValue;

    property DisplayFormat: string
      read FDisplayFormat
      write SetDisplayFormat;

    property OnRangeError: TRzRangeErrorEvent
      read FOnRangeError
      write FOnRangeError;

    { Inherited Properties & Events }
    property Alignment default taRightJustify;
  end;


  {=======================================}
  {== TRzDBExpandEdit Class Declaration ==}
  {=======================================}

  TRzDBExpandEdit = class( TRzDBEdit )
  private
    FExpandedWidth: Integer;
    FExpanded: Boolean;
    FOrigWidth: Integer;
    FExpandOn: TExpandOnType;

    { Message Handling Methods }
    procedure WMSetFocus( var Msg: TWMSetFocus  ); message wm_SetFocus;
    procedure WMKillFocus( var Msg: TWMKillFocus ); message wm_KillFocus;
    procedure WMRButtonUp( var Msg: TWMRButtonUp ); message wm_RButtonUp;
  protected
    { Property Access Methods }
    procedure SetExpandedWidth( Value: Integer ); virtual;
    procedure SetExpandOn( Value: TExpandOnType ); virtual;
  public
   constructor Create( AOwner: TComponent ); override;
  published
   property ExpandedWidth: Integer
     read FExpandedWidth
     write SetExpandedWidth;

   property ExpandOn: TExpandOnType
     read FExpandOn
     write SetExpandOn
     default etNone;
  end;


  {=========================================}
  {== TRzDBDateTimeEdit Class Declaration ==}
  {=========================================}

  TRzDBDateTimeEdit = class( TRzDBEdit )
  private
    FEditType: TRzDTEditType;
    FLastDateTime: TDateTime;
    FDateTime: TDateTime;
    FFormat: string;
    FUpdating: Boolean;
    FTimeHasBeenSet: Boolean;
    FSettingTime: Boolean;
    FTimePicked: Boolean;

    FCalendarElements: TRzCalendarElements;
    FCalendarColors: TRzCalendarColors;
    FCaptionClearBtn: string;
    FCaptionTodayBtn: string;
    FFirstDayOfWeek: TRzFirstDayOfWeek;

    FClockFaceColors: TRzClockFaceColors;
    FCaptionAM: string;
    FCaptionPM: string;
    FCaptionSet: string;
    FRestrictMinutes: Boolean;
    FShowHowToUseHint: Boolean;
    FHowToUseMsg: string;

    FOnGetBoldDays: TRzGetBoldDaysEvent;
    FOnDateTimeChange: TRzDateTimeChangeEvent;
    FOnGetWeekNumber: TRzGetWeekNumberEvent;

    procedure CheckDateTimeChange;

    { Message Handling Methods }
    procedure WMSetFocus( var Msg: TMessage ); message wm_SetFocus;
    procedure WMKillFocus( var Msg: TMessage ); message wm_KillFocus;
    procedure WMGetDlgCode( var Msg: TWMGetDlgCode ); message wm_GetDlgCode;
  protected
    function CanEditData: Boolean;
    procedure SetDateTime;
    procedure UpdateText;

    procedure DisplayCalendar; virtual;
    procedure DisplayTimePicker; virtual;

    procedure DataChanged; override;
    procedure UpdateData; override;

    { Event Dispatch Methods }
    procedure Change; override;
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure KeyPress( var Key: Char ); override;
    procedure CloseUp; override;
    procedure DropDown; override;
    procedure DateTimeChange; dynamic;

    { Property Access Methods }
    function GetDate: TDate; virtual;
    procedure SetDate( Value: TDate ); virtual;
    function IsDate: Boolean; virtual;
    procedure SetEditType( Value: TRzDTEditType ); virtual;
    procedure SetFormat( const Value: string ); virtual;
    function GetTime: TTime; virtual;
    procedure SetTime( Value: TTime ); virtual;
    function IsTime: Boolean; virtual;
    procedure SetClockFaceColors( Value: TRzClockFaceColors ); virtual;
    procedure SetCalendarColors( Value: TRzCalendarColors ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure Clear; override;

    function DaysToBitmask( Days: array of Byte ): Cardinal;

    procedure AdjustYear( DeltaYears: Integer );
    procedure AdjustMonth( DeltaMonths: Integer );
    procedure AdjustDay( DeltaDays: Integer );
    procedure AdjustHour( DeltaHours: Int64 );
    procedure AdjustMinute( DeltaMinutes: Int64 );

    procedure ReformatDateTime;
  published
    property CalendarColors: TRzCalendarColors
      read FCalendarColors
      write SetCalendarColors;

    property CalendarElements: TRzCalendarElements
      read FCalendarElements
      write FCalendarElements
      default [ ceYear, ceMonth, ceArrows, ceFillDays, ceDaysOfWeek, ceTodayButton, ceClearButton ];

    property CaptionTodayBtn: string
      read FCaptionTodayBtn
      write FCaptionTodayBtn;

    property CaptionClearBtn: string
      read FCaptionClearBtn
      write FCaptionClearBtn;

    property CaptionAM: string
      read FCaptionAM
      write FCaptionAM;

    property CaptionPM: string
      read FCaptionPM
      write FCaptionPM;

    property CaptionSet: string
      read FCaptionSet
      write FCaptionSet;

    property ClockFaceColors: TRzClockFaceColors
      read FClockFaceColors
      write SetClockFaceColors;

    property Date: TDate
      read GetDate
      write SetDate
      stored IsDate
      nodefault;

    property FirstDayOfWeek: TRzFirstDayOfWeek
      read FFirstDayOfWeek
      write FFirstDayOfWeek
      default fdowLocale;

    property HowToUseMsg: string
      read FHowToUseMsg
      write FHowToUseMsg;

    property RestrictMinutes: Boolean
      read FRestrictMinutes
      write FRestrictMinutes
      default False;

    property ShowHowToUseHint: Boolean
      read FShowHowToUseHint
      write FShowHowToUseHint
      default True;

    property Time: TTime
      read GetTime
      write SetTime
      stored IsTime
      nodefault;

    property EditType: TRzDTEditType
      read FEditType
      write SetEditType
      nodefault;

    property Format: string
      read FFormat
      write SetFormat;

    property OnGetBoldDays: TRzGetBoldDaysEvent
      read FOnGetBoldDays
      write FOnGetBoldDays;

    property OnDateTimeChange: TRzDateTimeChangeEvent
      read FOnDateTimeChange
      write FOnDateTimeChange;

    property OnGetWeekNumber: TRzGetWeekNumberEvent
      read FOnGetWeekNumber
      write FOnGetWeekNumber;
      
    { Inherited Properties & Events }
    property Align;
    property Alignment;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BorderStyle;
    property BiDiMode;
    property CharCase;
    property Color;
    property Constraints;
    property DisabledColor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropButtonVisible default True;
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
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnStartDock;
    property OnStartDrag;
  end;



  TRzDBMemo = class;

  {---------------------------------------------------------------------------------------------------------------------
    TRzPaintMemo is a simple panel descendant that knows how to look like a TRzDBMemo component. This is necessary for
    the TRzDBMemo component to appear correctly when used in a TDBCtrlGrid. The problem is that the TDBCtrlGrid uses a
    technique that relies on the control being replicated painting itself using a shared device context. Since the
    standard Memo control does not do this, the TRzPaintMemo component is used for replicated instances of a TRzDBMemo.
  ---------------------------------------------------------------------------------------------------------------------}
  TRzPaintMemo = class( TRzPaintEdit )
  private
    FEditControl: TRzDBMemo;
  protected
    procedure Paint; override;
  public
    constructor Create( AOwner: TComponent ); override;
  end;


  {=================================}
  {== TRzDBMemo Class Declaration ==}
  {=================================}

  TRzDBMemo = class( TDBMemo )
  private
    FAboutInfo: TRzAboutInfo;
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
    FTabOnEnter: Boolean;
    FPaintControl: TRzPaintMemo;

    FOnLineColChange: TLineColChangeEvent;
    FOnClipboardChange: TClipboardChangeEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;

    procedure ReadOldFrameFlatProp( Reader: TReader );
    procedure ReadOldFrameFocusStyleProp( Reader: TReader );

    { Message Handling Methods }
    procedure CMEnabledChanged( var Msg: TMessage ); message cm_EnabledChanged;
    procedure WMNCPaint( var Msg: TWMNCPaint ); message wm_NCPaint;
    procedure CMParentColorChanged( var Msg: TMessage ); message cm_ParentColorChanged;
    procedure WMPaint( var Msg: TWMPaint ); message wm_Paint;
    procedure CMEnter( var Msg: TCMEnter ); message cm_Enter;
    procedure CMExit( var Msg: TCMExit ); message cm_Exit;
    procedure CMMouseEnter( var Msg: TMessage ); message cm_MouseEnter;
    procedure CMMouseLeave( var Msg: TMessage ); message cm_MouseLeave;
    procedure WMSize( var Msg: TWMSize ); message wm_Size;
  protected
    FCanvas: TCanvas;
    FOverControl: Boolean;

    procedure CreateWnd; override;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    procedure UpdateColors; virtual;
    procedure UpdateFrame( ViaMouse, InFocus: Boolean ); virtual;
    procedure RepaintFrame; virtual;

    { Event Dispatch Methods }
    procedure Change; override;
    procedure Click; override;
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure KeyUp( var Key: Word; Shift: TShiftState ); override;
    procedure KeyPress( var Key: Char ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure LineColChange; dynamic;
    procedure ClipboardChange; dynamic;
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;

    function DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean; override;
    function DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean; override;

    { Property Access Methods }
    function GetColumn: Integer; virtual;
    procedure SetColumn( Value: Integer ); virtual;
    function GetLine: Integer; virtual;
    procedure SetLine( Value: Integer ); virtual;
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

    { Property Declarations }
    property Canvas: TCanvas
      read FCanvas;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function UseThemes: Boolean; virtual;
    procedure JumpTo( ALine, ACol: Integer );

    { Property Declarations }
    property Column: Integer
      read GetColumn
      write SetColumn;

    property Line: Integer
      read GetLine
      write SetLine;
  published
    { Property Declarations }
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Color: TColor
      read GetColor
      write SetColor
      stored IsColorStored
      default clWindow;

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

    property TabOnEnter: Boolean
      read FTabOnEnter
      write FTabOnEnter
      default False;

    property OnLineColChange: TLineColChangeEvent
      read FOnLineColChange
      write FOnLineColChange;

    property OnClipboardChange: TClipboardChangeEvent
      read FOnClipboardChange
      write FOnClipboardChange;

     property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter
      write FOnMouseEnter;

    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave
      write FOnMouseLeave;

    { Inherited Properties & Events }
    property OnMouseWheelUp;
    property OnMouseWheelDown;
  end;


  {=====================================}
  {== TRzDBRichEdit Class Declaration ==}
  {=====================================}

  TRzDBRichEdit = class( TDBRichEdit )
  private
    FAboutInfo: TRzAboutInfo;
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
    FTabOnEnter: Boolean;

    FOnLineColChange: TLineColChangeEvent;
    FOnClipboardChange: TClipboardChangeEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;

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
    procedure WMSize( var Msg: TWMSize ); message wm_Size;
  protected
    FCanvas: TCanvas;
    FOverControl: Boolean;

    procedure CreateWnd; override;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    procedure UpdateColors; virtual;
    procedure UpdateFrame( ViaMouse, InFocus: Boolean ); virtual;
    procedure RepaintFrame; virtual;

    { Event Dispatch Methods }
    procedure Change; override;
    procedure Click; override;
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure KeyUp( var Key: Word; Shift: TShiftState ); override;
    procedure KeyPress( var Key: Char ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure SelectionChange; override;
    procedure LineColChange; dynamic;
    procedure ClipboardChange; dynamic;
    procedure MouseEnter; dynamic;
    procedure MouseLeave; dynamic;

    function DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean; override;
    function DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean; override;

    { Property Access Methods }
    function GetColumn: Integer; virtual;
    procedure SetColumn( Value: Integer ); virtual;
    function GetLine: Integer; virtual;
    procedure SetLine( Value: Integer ); virtual;
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

    { Property Declarations }
    property Canvas: TCanvas
      read FCanvas;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function UseThemes: Boolean; virtual;
    procedure JumpTo( ALine, ACol: Integer );

    { Property Declarations }
    property Column: Integer
      read GetColumn
      write SetColumn;

    property Line: Integer
      read GetLine
      write SetLine;
  published
    { Property Declarations }
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Color: TColor
      read GetColor
      write SetColor
      stored IsColorStored
      default clWindow;

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

    property TabOnEnter: Boolean
      read FTabOnEnter
      write FTabOnEnter
      default False;

    property OnLineColChange: TLineColChangeEvent
      read FOnLineColChange
      write FOnLineColChange;

    property OnClipboardChange: TClipboardChangeEvent
      read FOnClipboardChange
      write FOnClipboardChange;

     property OnMouseEnter: TNotifyEvent
      read FOnMouseEnter
      write FOnMouseEnter;

    property OnMouseLeave: TNotifyEvent
      read FOnMouseLeave
      write FOnMouseLeave;

    { Inherited Properties & Events }
    property OnMouseWheelUp;
    property OnMouseWheelDown;
  end;


implementation

uses
  {$IFDEF VCL60_OR_HIGHER}
  DateUtils,
  {$ENDIF}
  {$IFDEF VCL70_OR_HIGHER}
  Themes,
  {$ELSE}
  RzThemeSrv,
  {$ENDIF}
  Clipbrd,
  TypInfo,
  RzGrafx,
  RzPanel;

{&RT}
{==========================}
{== TRzPaintEdit Methods ==}
{==========================}

constructor TRzPaintEdit.Create( AOwner: TComponent );
begin
  inherited;
  FEditControl := TRzDBEdit( AOwner );
  Alignment := taLeftJustify;
  BevelOuter := bvNone;
end;


procedure TRzPaintEdit.Paint;
var
  X, Y: Integer;
  R: TRect;
  FrameColor: TColor;
  FrameSides: TSides;
  FrameStyle: TFrameStyle;
  FrameVisible: Boolean;
begin
  Canvas.Font := FEditControl.Font;
  Canvas.Brush.Color := FEditControl.Color;
  Canvas.FillRect( ClientRect );

  FrameColor := FEditControl.FrameColor;
  FrameSides := FEditControl.FrameSides;
  FrameStyle := FEditControl.FrameStyle;
  FrameVisible := FEditControl.FrameVisible;

  { Draw Border }
  if FrameVisible then
  begin
    R := ClientRect;
    if FEditControl.Color = clWindow then
    begin
      if FrameStyle = fsFlat then
        DrawSides( Canvas, R, FrameColor, FrameColor, FrameSides )
      else
        DrawBorderSides( Canvas, R, FrameStyle, FrameSides );
    end
    else
    begin
      if FrameStyle = fsFlat then
        DrawSides( Canvas, R, FrameColor, FrameColor, FrameSides )
      else
        DrawColorBorderSides( Canvas, R, FEditControl.Color, FrameStyle, FrameSides );
    end;
  end;

  { Draw Text }
  R := FEditControl.GetEditRect;
  if FrameVisible then
    InflateRect( R, -1, -2 );

  X := 0;
  SetTextAlign( Canvas.Handle, SetTextAlignments[ Alignment ] );
  case Alignment of
    taLeftJustify:
    begin
      if FrameVisible then
        X := R.Left
      else
        X := R.Left + 1;
    end;

    taRightJustify:
    begin
      if FrameVisible then
        X := R.Right - 1
      else
        X := R.Right - 2;
    end;

    taCenter:
      X := R.Left + ( R.Right - R.Left ) div 2;
  end;
  Y := R.Top + ( R.Bottom - R.Top - Canvas.TextHeight( 'Pp' ) ) div 2 - 1;

  Canvas.TextRect( R, X, Y, Caption );
end; {= TRzPaintEdit.Paint; =}


{=======================}
{== TRzDBEdit Methods ==}
{=======================}

constructor TRzDBEdit.Create( AOwner: TComponent );
begin
  inherited;
  inherited ReadOnly := True;

  {&RCI}
  FPaintControl := TRzPaintEdit.Create( Self );
  FPaintControl.Parent := Self;
  FPaintControl.Visible := False;

  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChangeHandler;
  FDataLink.OnEditingChange := EditingChangeHandler;
  FDataLink.OnUpdateData := UpdateDataHandler;
  FDataLink.OnActiveChange := ActiveChangeHandler;
end;


destructor TRzDBEdit.Destroy;
begin
  FPaintControl.Free;
  FDataLink.Free;
  FDataLink := nil;
  inherited;
end;


procedure TRzDBEdit.Loaded;
begin
  inherited;
  ResetMaxLength;
  if csDesigning in ComponentState then
    DataChanged;
end;


procedure TRzDBEdit.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( FDataLink <> nil ) and ( AComponent = DataSource ) then
    SetDataSource( nil );
end;


function TRzDBEdit.UseRightToLeftAlignment: Boolean;
begin
  Result := DBUseRightToLeftAlignment( Self, Field );
end;


procedure TRzDBEdit.Change;
begin
  FDataLink.Modified;
  inherited;
end;


procedure TRzDBEdit.KeyDown( var Key: Word; Shift: TShiftState );
begin
  inherited;
  if ( Key = vk_Delete ) or ( ( Key = vk_Insert ) and ( ssShift in Shift ) ) then
    FDataLink.Edit;
end;


procedure TRzDBEdit.KeyPress( var Key: Char );
begin
  inherited;

  if ( Key in [ #32..#255 ] ) and ( FDataLink.Field <> nil ) and not FDataLink.Field.IsValidChar( Key ) then
  begin
    MessageBeep( 0 );
    Key := #0;
  end;

  case Key of
    ^H, ^V, ^X, #32..#255:
      FDataLink.Edit;

    #27: // Escape Key
    begin
      FDataLink.Reset;
      SelectAll;
      Key := #0;
    end;
  end;
end;


function TRzDBEdit.EditCanModify: Boolean;
begin
  Result := FDataLink.Edit;
end;


procedure TRzDBEdit.Reset;
begin
  inherited;
  FDataLink.Reset;
  SelectAll;
end;


function TRzDBEdit.GetRightJustifiedText: string;
begin
  Result := Text;
end;


function TRzDBEdit.GetEditRect: TRect;
begin
  Result := ClientRect;
end;


procedure TRzDBEdit.AdjustEditRect;
begin
end;


procedure TRzDBEdit.RepaintFrame;
var
  R: TRect;
begin
  R := ClientRect;
  if Parent is TDBCtrlPanel then
    Invalidate
  else
    RedrawWindow( Handle, @R, 0, rdw_Invalidate or rdw_UpdateNow or rdw_Frame );
end;


function TRzDBEdit.GetDisplayString: string;
begin
  if Field <> nil then
  begin
    Result := Field.DisplayText;
    if PasswordChar <> #0 then
      FillChar( Result[ 1 ], Length( Result ), PasswordChar );
  end
  else
    Result := '';
end;


procedure TRzDBEdit.WMPaint( var Msg: TWMPaint );
var
  S: string;
begin
  if ( Field <> nil ) and ( Field.Alignment <> taCenter ) then
    Alignment := Field.Alignment;

  if csPaintCopy in ControlState then
  begin
    S := GetDisplayString;

    FPaintControl.SetBounds( BoundsRect.Left, BoundsRect.Top,
                             BoundsRect.Right - BoundsRect.Left,
                             BoundsRect.Bottom - BoundsRect.Top );

    if Field <> nil then
      FPaintControl.Alignment := Field.Alignment;

    SendMessage( FPaintControl.Handle, wm_SetText, 0, Longint( PChar( S ) ) );
    SendMessage( FPaintControl.Handle, wm_Paint, WParam( Msg.DC ), 0 );
  end
  else
  begin
    FPaintControl.SetBounds( 0, 0, 0, 0 );
    AdjustEditRect;
    inherited;

    if FrameVisible and not UseThemes and ( Parent is TDBCtrlPanel ) then
       DrawFrame( FCanvas, Width, Height, FrameStyle, Color, FrameColor, FrameSides );
  end;
end; {= TRzDBEdit.WMPaint =}


function TRzDBEdit.GetField: TField;
begin
  Result := FDataLink.Field;
end;


function TRzDBEdit.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;


procedure TRzDBEdit.SetDataField( const Value: string );
begin
  if not ( csDesigning in ComponentState ) then
    ResetMaxLength;
  FDataLink.FieldName := Value;
end;


function TRzDBEdit.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;


procedure TRzDBEdit.SetDataSource( Value: TDataSource );
begin
  if not ( FDataLink.DataSourceFixed and ( csLoading in ComponentState ) ) then
    FDataLink.DataSource := Value;
  if Value <> nil then
    Value.FreeNotification( Self );
end;


procedure TRzDBEdit.ResetMaxLength;
var
  F: TField;
begin
  if ( MaxLength > 0 ) and Assigned( DataSource ) and Assigned( DataSource.DataSet ) then
  begin
    F := DataSource.DataSet.FindField( DataField );
    if Assigned( F ) and ( F.DataType in [ ftString, ftWideString ] ) and ( F.Size = MaxLength ) then
      MaxLength := 0;
  end;
end;


function TRzDBEdit.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;


procedure TRzDBEdit.SetReadOnly( Value: Boolean );
begin
  FDataLink.ReadOnly := Value;
end;


procedure TRzDBEdit.SetFocused( Value: Boolean );
begin
  if FFocused <> Value then
  begin
    FFocused := Value;
    if ( Alignment <> taLeftJustify) and not IsMasked then
      Invalidate;
    FDataLink.Reset;
  end;
end;


procedure TRzDBEdit.ActiveChanged;
begin
  ResetMaxLength;
end;


procedure TRzDBEdit.ActiveChangeHandler( Sender: TObject );
begin
  ActiveChanged;
end;


procedure TRzDBEdit.DataChanged;
begin
  if FDataLink.Field <> nil then
  begin
    if FAlignment <> FDataLink.Field.Alignment then
    begin
      EditText := '';  {forces update}
      FAlignment := FDataLink.Field.Alignment;
    end;
    EditMask := FDataLink.Field.EditMask;
    if not ( csDesigning in ComponentState ) then
    begin
      if ( FDataLink.Field.DataType in [ ftString, ftWideString ] ) and ( MaxLength = 0 ) then
        MaxLength := FDataLink.Field.Size;
    end;
    if FFocused and FDataLink.CanModify then
      Text := FDataLink.Field.Text
    else
    begin
      EditText := FDataLink.Field.DisplayText;
      if FDataLink.Editing {and FDataLink.FModified} then   // FModified is private
        Modified := True;
    end;
  end
  else
  begin
    FAlignment := taLeftJustify;
    EditMask := '';
    if csDesigning in ComponentState then
      EditText := Name
    else
      EditText := '';
  end;
end; {= TRzDBEdit.DataChanged =}


procedure TRzDBEdit.DataChangeHandler( Sender: TObject );
begin
  DataChanged;
end;


procedure TRzDBEdit.EditingChanged;
begin
  inherited ReadOnly := not FDataLink.Editing;
end;


procedure TRzDBEdit.EditingChangeHandler( Sender: TObject );
begin
  EditingChanged;
end;


procedure TRzDBEdit.UpdateData;
begin
  ValidateEdit;
  FDataLink.Field.Text := Text;
end;


procedure TRzDBEdit.UpdateDataHandler( Sender: TObject );
begin
  UpdateData;
end;


procedure TRzDBEdit.WMUndo( var Msg: TMessage );
begin
  FDataLink.Edit;
  inherited;
end;


procedure TRzDBEdit.WMCut( var Msg: TMessage );
begin
  FDataLink.Edit;
  inherited;
end;


procedure TRzDBEdit.WMPaste( var Msg: TMessage );
begin
  FDataLink.Edit;
  inherited;
end;


procedure TRzDBEdit.CMEnter( var Msg: TCMEnter );
begin
  SetFocused( True );
  inherited;
  if SysLocale.FarEast and FDataLink.CanModify then
    inherited ReadOnly := False;
end;


procedure TRzDBEdit.CMExit( var Msg: TCMExit );
begin
  // Replace call to inherited with just a call to UpdateFrame. This change eliminates the extra OnExit event that
  // was being generated and still allows the FocusColor property to work correctly.
  UpdateFrame( False, False );

  try
    if FDataLink.Editing then
      FDataLink.UpdateRecord;
  except
    SelectAll;
    SetFocus;
    raise;
  end;
  SetFocused( False );
  CheckCursor;
  DoExit;
end;


procedure TRzDBEdit.CMGetDataLink( var Msg: TMessage );
begin
  Msg.Result := Integer( FDataLink );
end;


function TRzDBEdit.ExecuteAction( Action: TBasicAction ): Boolean;
begin
  Result := inherited ExecuteAction( Action ) or ( FDataLink <> nil ) and FDataLink.ExecuteAction( Action );
end;


function TRzDBEdit.UpdateAction( Action: TBasicAction ): Boolean;
begin
  Result := inherited UpdateAction( Action ) or ( FDataLink <> nil ) and FDataLink.UpdateAction( Action );
end;


procedure TRzDBEdit.SetFrameVisible( Value: Boolean );
begin
  if FFrameVisible <> Value then
  begin
    FFrameVisible := Value;
    if Parent is TDBCtrlPanel then
    begin
      ParentCtl3D := not FFrameVisible;
      Ctl3D := not FFrameVisible;
      Invalidate;
    end
    else
    begin
      if FFrameVisible then
        Ctl3D := True;
      RecreateWnd;
    end;
  end;
end;


{==============================}
{== TRzDBNumericEdit Methods ==}
{==============================}

constructor TRzDBNumericEdit.Create( AOwner: TComponent );
begin
  inherited;

  Height := 21;
  Width := 65;
  FAllowBlank := True;
  FBlankValue := 0;
  FIntegersOnly := True;
  FCheckRange := False;
  FMin := 0;
  FMax := 0;
  Alignment := taRightJustify;
  FDisplayFormat := ',0;(,0)';
  FFieldValue := 0.0;
  SetValue( FFieldValue );
  Text := FormatText( FFieldValue );
end;


procedure TRzDBNumericEdit.CreateParams( var Params: TCreateParams );
begin
  inherited;
end;


procedure TRzDBNumericEdit.CreateWnd;
begin
  inherited;

  SetValue( Value );
  Text := FormatText( Value );
end;


procedure TRzDBNumericEdit.KeyPress( var Key: Char );
begin
  inherited;

  if Key = #0 then
    Exit;         { If Key is cleared by inherited KeyPress, then exit }

  if not IsValidChar( Key ) then
  begin
    Key := #0;
    MessageBeep( 0 );
  end;
end;


function TRzDBNumericEdit.CleanUpText: string;
var
  I: Integer;
  ValidCharSet: set of Char;
begin
  ValidCharSet := [ DecimalSeparator, '+', '-', '0'..'9' ];

  Result := '';
  for I := 1 to Length( Text ) do
  begin
    if Text[ I ] in ValidCharSet then
      Result := Result + Text[ I ];
  end;
end;


function TRzDBNumericEdit.IsValidChar( Key: Char ): Boolean;
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
    begin
      if ( SelStart = 0 ) and ( Pos( '+', Text ) = 0 ) and ( Pos( '-', Text ) = 0 ) then
      begin
        // Cursor is at beginning and there is no + or - currently in the text
        Result := True;
      end
      else if SelLength = Length( Text ) then
      begin
        // All text in the edit field is selected. Enter a + or - is acceptable.
        Result := True;
      end
      else if ( SelStart = 0 ) and ( SelLength > 0 ) and
              ( ( Pos( '+', SelText ) > 0 ) or ( Pos( '-', SelText ) > 0 ) ) then
      begin
        // Cursor is at beginning and there is a selection at the beginning.  If the selection contains a + or - then
        // allow the new + or - to replace the old one.
        Result := True;
      end
      else
        Result := False;
    end
    else
    begin
      // Check if a digit is being entered at the beginning, but the text already has a sign symbol at the beginning.
      if ( SelStart = 0 ) and ( SelLength = 0 ) and ( ( Pos( '+', Text ) = 1 ) or ( Pos( '-', Text ) = 1 ) ) then
        Result := False;
    end;
  end;
end;


procedure TRzDBNumericEdit.SetIntegersOnly( Value: Boolean );
begin
  if FIntegersOnly <> Value then
  begin
    FIntegersOnly := Value;
    if FIntegersOnly then
    begin
      SetValue( Round( GetValue ) );
    end;
  end;
end;


procedure TRzDBNumericEdit.SetMin( const Value: Extended );
begin
  if FMin <> Value then
  begin
    FMin := Value;
    if FMax < FMin then
      FMax := FMin;
    Invalidate;
  end;
end;


procedure TRzDBNumericEdit.SetMax( const Value: Extended );
begin
  if FMax <> Value then
  begin
    FMax := Value;
    if FMin > FMax then
      FMin := FMax;
    Invalidate;
  end;
end;


function TRzDBNumericEdit.GetIntValue: Integer;
begin
  Result := Round( GetValue );
end;


procedure TRzDBNumericEdit.SetIntValue( Value: Integer );
begin
  SetValue( Value );
end;


function TRzDBNumericEdit.GetValue: Extended;
begin
  if Field = nil then
  begin
    Result := FMin;
    Exit;
  end;

  try
    if Text = '' then
    begin
      if FAllowBlank then
        Result := FBlankValue
      else
      begin
        Text := FormatText( FMin );
        Result := EvaluateText;
      end;
    end
    else
    begin
      Result := EvaluateText;
    end;
  except
    Result := FMin;
  end;
end;


procedure TRzDBNumericEdit.RangeError( EnteredValue, AdjustedValue: Extended; var AutoCorrect: Boolean );
begin
  if Assigned( FOnRangeError ) then
    FOnRangeError( Self, EnteredValue, AdjustedValue, AutoCorrect );
end;


function TRzDBNumericEdit.CheckValue( const Value: Extended; var KeepFocusOnEdit: Boolean ): Extended;
var
  AutoCorrect: Boolean;
begin
  Result := Value;
  if ( FMax <> FMin ) or FCheckRange then
  begin
    AutoCorrect := True;
    if Value < FMin then
    begin
      RangeError( Value, FMin, AutoCorrect );
      if AutoCorrect then
        Result := FMin
      else
        KeepFocusOnEdit := True;
    end
    else if Value > FMax then
    begin
      RangeError( Value, FMax, AutoCorrect );
      if AutoCorrect then
        Result := FMax
      else
        KeepFocusOnEdit := True;
    end;
  end;

  FModified := ( Result <> FFieldValue );
  FFieldValue := Result;
end;


procedure TRzDBNumericEdit.SetValue( const Value: Extended );
begin
  if ( Field <> nil ) and ( Value <> EvaluateText ) then
    Text := FormatText( Value );
end;


procedure TRzDBNumericEdit.DataChanged;
begin
  if Field <> nil then
  begin
    if FAllowBlank and Field.IsNull then
      Text := ''
    else
    begin
      Value := DataLink.Field.AsFloat;
      Text := FormatText( Value );
    end;
  end
  else
  begin
    if csDesigning in ComponentState then
      EditText := Name
    else
      EditText := '';
  end;
end;


procedure TRzDBNumericEdit.UpdateData;
begin
  if DataLink.Editing then
  begin
    if FAllowBlank and ( Text = '' ) then
      DataLink.Field.Clear
    else
      DataLink.Field.AsFloat := Value;
  end;
end;


procedure TRzDBNumericEdit.CMEnter( var Msg: TCMEnter );
begin
  if Field <> nil then
  begin
    FModified := False;
    FFieldValue := EvaluateText;
    if not FAllowBlank then
      Text := FormatText( FFieldValue );
  end;
  inherited;
end;


procedure TRzDBNumericEdit.CMExit( var Msg: TCMExit );
var
  N: Extended;
  MustSet, KeepFocusOnEdit: Boolean;
begin
  if Field <> nil then
  begin
    if FAllowBlank and ( Text = '' ) then
    begin
      inherited;
      Exit;
    end;

    MustSet := False;
    try
      KeepFocusOnEdit := False;
      N := CheckValue( EvaluateText, KeepFocusOnEdit );
      if KeepFocusOnEdit then
      begin
        SetFocus;
        Exit;
      end;
    except
      N := FMin;
      MustSet := True;
    end;
    if MustSet then
      SetValue( N );
    Text := FormatText( N );
  end;
  inherited;
end;


procedure TRzDBNumericEdit.SetDisplayFormat( FormatString: string );
begin
  if FDisplayFormat <> FormatString then
  begin
    FDisplayFormat := FormatString;
    SetValue( Value );
    Text := FormatText( Value );
  end;
end;

function TRzDBNumericEdit.FormatText( const Value: Extended ): string;
begin
  if Field <> nil then
    Result := FormatFloat( FDisplayFormat, Value )
  else
    Result := '';
end;


function TRzDBNumericEdit.GetDisplayString: string;
begin
  if Field <> nil then
    Result := FormatFloat( FDisplayFormat, Field.AsFloat )
  else
    Result := '';
end;


function TRzDBNumericEdit.EvaluateText: Extended;
var
  TmpText: string;
  Tmp: Byte;
  IsNeg: Boolean;
begin
  if ( Length( Text ) > 0 ) then
  begin
    IsNeg := ( Pos( '-', Text ) > 0 ) or ( Pos( '(', Text ) > 0 );
    TmpText := '';

    for Tmp := 1 to Length( Text ) do
    begin
      if Text[ Tmp ] in [ '0'..'9', DecimalSeparator ] then
        TmpText := TmpText + Text[ Tmp ];
    end;

    if TmpText <> '' then
    begin
      try
        if IsNeg then
          TmpText := '-' + TmpText;
        Result := StrToFloat( TmpText );
      except
        MessageBeep( 0 );
        Result := 0.0;
      end;
    end
    else
      Result := 0;
  end
  else
    Result := 0;
end;


{=============================}
{== TRzDBExpandEdit Methods ==}
{=============================}

constructor TRzDBExpandEdit.Create( AOwner: TComponent );
begin
  inherited;

  FExpandOn := etNone;
  FExpanded := False;
  FExpandedWidth := 0;
  FOrigWidth := Width;
  {&RCI}
end;


procedure TRzDBExpandEdit.WMSetFocus( var Msg: TWMSetFocus );
begin
  if ( FExpandOn = etFocus ) and not FExpanded and ( FExpandedWidth > 0 ) then
  begin
    BringToFront;
    FExpanded := True;
    FOrigWidth := Width;
    Width := FExpandedWidth;
    if AutoSelect then
    begin
      SelLength := 0;
      SelectAll;
    end;
  end;
  inherited;
end;


procedure TRzDBExpandEdit.WMRButtonUp( var Msg: TWMRButtonUp );
begin
  if ( FExpandOn = etMouseButton2Click ) and ( FExpandedWidth > 0 ) then
  begin
    if not FExpanded then
    begin
      BringToFront;
      FExpanded := True;
      FOrigWidth := Width;
      Width := FExpandedWidth;
      SetFocus;
      if AutoSelect then
      begin
        SelLength := 0;
        SelectAll;
      end;
    end
    else
    begin
      Width := FOrigWidth;
      FExpanded := False;
    end;
  end
  else
    inherited;
end;


procedure TRzDBExpandEdit.WMKillFocus( var Msg: TWMKillFocus );
begin
  if ( FExpandOn <> etNone ) and ( FExpandedWidth > 0 ) and FExpanded then
    Width := FOrigWidth;
  FExpanded := False;
  inherited;
end;


procedure TRzDBExpandEdit.SetExpandedWidth( Value: Integer );
begin
  {&RV}
  if FExpandedWidth <> Value then
  begin
    FExpandedWidth := Value;
    Repaint;
  end;
end;

procedure TRzDBExpandEdit.SetExpandOn( Value: TExpandOnType );
begin
  if FExpandOn <> Value then
  begin
    FExpandOn := Value;
    Repaint;
  end;
end;


{===============================}
{== TRzDBDateTimeEdit Methods ==}
{===============================}

constructor TRzDBDateTimeEdit.Create( AOwner: TComponent );
begin
  inherited;

  DropButtonVisible := True;
  SetEditType( etDate );
  FCalendarElements := [ ceYear, ceMonth, ceArrows, ceFillDays, ceDaysOfWeek, ceTodayButton, ceClearButton ];
  FFirstDayOfWeek := fdowLocale;

  FRestrictMinutes := False;
  FShowHowToUseHint := True;

  // Pass nil since this component is not a TRzTimePicker
  FClockFaceColors := TRzClockFaceColors.Create( nil );
  // Pass nil since this component is not a TRzCalendar
  FCalendarColors := TRzCalendarColors.Create( nil );
end;


destructor TRzDBDateTimeEdit.Destroy;
begin
  FClockFaceColors.Free;
  FCalendarColors.Free;
  inherited;
end;


function TRzDBDateTimeEdit.CanEditData: Boolean;
begin
  if not ReadOnly and ( Field <> nil ) and Field.CanModify and ( DataSource <> nil ) then
  begin
    DataSource.Edit;
    Result := DataSource.State in dsEditModes;
  end
  else
    Result := False;
end;


procedure TRzDBDateTimeEdit.SetDateTime;
begin
  if Modified then
  begin
    try
      Modified := False;
      if FEditType = etTime then
      begin
        FDateTime := StrToTimeEx( Text );
        FTimeHasBeenSet := True;
      end
      else
      begin
        FDateTime := StrToDateEx( Text );
      end;
      CheckDateTimeChange;
    except
      // Catch all exceptions during this conversion
    end;
  end;
end;


procedure TRzDBDateTimeEdit.CheckDateTimeChange;
begin
  if FEditType = etTime then
  begin
    if Frac( FDateTime ) <> Frac( FLastDateTime ) then
    begin
      DateTimeChange;
      FLastDateTime := FDateTime;
    end;
  end
  else
  begin
    if Trunc( FDateTime ) <> Trunc( FLastDateTime ) then
    begin
      DateTimeChange;
      FLastDateTime := FDateTime;
    end;
  end;
end;


procedure TRzDBDateTimeEdit.DateTimeChange;
begin
  if Assigned( FOnDateTimeChange ) then
    FOnDateTimeChange( Self, FDateTime );
end;


procedure TRzDBDateTimeEdit.UpdateText;
var
  TempFormat: string;
begin
  TempFormat := FFormat;
  if TempFormat = '' then
  begin
    if FEditType = etTime then
      TempFormat := 't'
    else
      TempFormat := 'ddddd';
  end;

  FUpdating := True;
  try
    if FEditType = etTime then
    begin
      if not FSettingTime and
         ( ( ( FDateTime = 0 ) and not FTimeHasBeenSet and ( Field <> nil ) and Field.IsNull ) or
           ( ( FDateTime = 0 ) and FTimeHasBeenSet and ( Text = '' ) and not FTimePicked ) ) then
      begin
        Text := '';
      end
      else
        Text := FormatDateTime( TempFormat, FDateTime );
    end
    else
    begin
      if FDateTime = 0 then
        Text := ''
      else
        Text := FormatDateTime( TempFormat, FDateTime );
    end;
  finally
    FUpdating := False;
  end;
  Modified := False;
end; {= TRzDBDateTimeEdit.UpdateText =}


procedure TRzDBDateTimeEdit.CloseUp;
begin
  if not ReadOnly and ( Field <> nil ) and Field.CanModify and ( DataSource <> nil ) then
  begin
    try
      inherited;
    except
    end;
  end;
end;


procedure TRzDBDateTimeEdit.DropDown;
begin
  if not ReadOnly and ( Field <> nil ) and Field.CanModify and ( DataSource <> nil ) then
  begin
    try
      inherited;
      if FEditType = etDate then
        DisplayCalendar
      else
        DisplayTimePicker;
    except
    end;
  end;
end;



function TRzDBDateTimeEdit.DaysToBitmask( Days: array of Byte ): Cardinal;
var
  I: Integer;
begin
  Result := 0;
  for I := Low( Days ) to High( Days ) do
  begin
    if Days[ I ] in [ 1..31 ] then
      Result := Result or ( $00000001 shl ( Days[ I ] - 1 ) );
  end;
end;


procedure TRzDBDateTimeEdit.DisplayCalendar;
var
  PopupPanel: TRzPopupPanel;
  Calendar: TRzCalendar;
  F: TCustomForm;
  SaveAutoSelect: Boolean;
begin
  SaveAutoSelect := AutoSelect;
  AutoSelect := False;
  try
    F := GetParentForm( Self );
    if F <> nil then
    begin
      PopupPanel := TRzPopupPanel.Create( Self );
      try
        Calendar := TRzCalendar.Create( PopupPanel );
        Calendar.Parent := PopupPanel;
        PopupPanel.Parent := F;
        PopupPanel.Font.Name := Font.Name;
        PopupPanel.Font.Color := Font.Color;

        Calendar.IsPopup := True;
        Calendar.Color := Color;
        Calendar.Elements := FCalendarElements;
        Calendar.FirstDayOfWeek := FFirstDayOfWeek;
        Calendar.CaptionClearBtn := FCaptionClearBtn;
        Calendar.CaptionTodayBtn := FCaptionTodayBtn;
        Calendar.OnGetBoldDays := FOnGetBoldDays;
        Calendar.OnGetWeekNumber := FOnGetWeekNumber;
        Calendar.Handle;
        Calendar.Date := GetDate;
        if FrameVisible and not UseThemes and ( FrameStyle = fsFlat ) or ( FrameStyle = fsFlatBold ) then
        begin
          Calendar.BorderOuter := fsFlat;
          Calendar.FlatColor := FrameColor;
        end;
        Calendar.Visible := True;
        Calendar.CalendarColors := FCalendarColors;
        Calendar.OnClick := PopupPanel.Close;

        if PopupPanel.Popup( Self ) then
          SetDate( Calendar.Date );
      finally
        PopupPanel.Free;
      end;
    end;
  finally
    AutoSelect := SaveAutoSelect;
  end;
end;


procedure TRzDBDateTimeEdit.DisplayTimePicker;
var
  PopupPanel: TRzPopupPanel;
  TimePicker: TRzTimePicker;
  F: TCustomForm;
  SaveAutoSelect: Boolean;
begin
  SaveAutoSelect := AutoSelect;
  AutoSelect := False;
  try
    F := GetParentForm( Self );
    if F <> nil then
    begin
      PopupPanel := TRzPopupPanel.Create( Self );
      try
        TimePicker := TRzTimePicker.Create( PopupPanel );
        TimePicker.Parent := PopupPanel;
        PopupPanel.Parent := F;
        PopupPanel.Font.Name := Font.Name;
        PopupPanel.Font.Color := Font.Color;

        TimePicker.IsPopup := True;
        TimePicker.Color := Color;
        TimePicker.CaptionAM := FCaptionAM;
        TimePicker.CaptionPM := FCaptionPM;
        TimePicker.CaptionSet := FCaptionSet;
        TimePicker.Handle;
        TimePicker.Time := GetTime;
        if FrameVisible and not UseThemes and ( FrameStyle = fsFlat ) or ( FrameStyle = fsFlatBold ) then
        begin
          TimePicker.BorderOuter := fsFlat;
          TimePicker.FlatColor := FrameColor;
        end;
        TimePicker.Visible := True;
        TimePicker.ClockFaceColors := FClockFaceColors;
        TimePicker.Format := FFormat;
        TimePicker.ShowSetButton := True;
        TimePicker.ShowHowToUseHint := FShowHowToUseHint;
        TimePicker.HowToUseMsg := FHowToUseMsg;
        TimePicker.RestrictMinutes := FRestrictMinutes;
        TimePicker.OnSetBtnClick := PopupPanel.Close;

        if PopupPanel.Popup( Self ) then
        begin
          FTimePicked := True;
          SetTime( TimePicker.Time );
          FTimePicked := False;
        end;
      finally
        PopupPanel.Free;
      end;
    end;
  finally
    AutoSelect := SaveAutoSelect;
  end;
end;


procedure TRzDBDateTimeEdit.Change;
begin
  if not FUpdating then
  begin
    SetDateTime;
    DateTimeChange;
  end;
  inherited;
end;


procedure TRzDBDateTimeEdit.AdjustYear( DeltaYears: Integer );
begin
  if not CanEditData then
    Exit;
  if FDateTime = 0 then
    FDateTime := SysUtils.Date;
  FDateTime := IncYear( FDateTime, DeltaYears );
  CheckDateTimeChange;
  UpdateText;
end;


procedure TRzDBDateTimeEdit.AdjustMonth( DeltaMonths: Integer );
begin
  if not CanEditData then
    Exit;
  if FDateTime = 0 then
    FDateTime := SysUtils.Date;
  FDateTime := IncMonth( FDateTime, DeltaMonths );
  CheckDateTimeChange;
  UpdateText;
end;


procedure TRzDBDateTimeEdit.AdjustDay( DeltaDays: Integer );
begin
  if not CanEditData then
    Exit;
  if FDateTime = 0 then
    FDateTime := SysUtils.Date;
  FDateTime := IncDay( FDateTime, DeltaDays );
  CheckDateTimeChange;
  UpdateText;
end;


procedure TRzDBDateTimeEdit.AdjustHour( DeltaHours: Int64 );
begin
  if not CanEditData then
    Exit;
  if FDateTime = 0 then
    FDateTime := SysUtils.Now;
  FDateTime := IncHour( FDateTime, DeltaHours );
  if FDateTime < 0 then
  begin
    // Time has been changed to be earlier than 12:00 am.
    FDateTime := IncHour( FDateTime, 24 );
  end;
  CheckDateTimeChange;
  UpdateText;
end;


procedure TRzDBDateTimeEdit.AdjustMinute( DeltaMinutes: Int64 );
begin
  if not CanEditData then
    Exit;
  if FDateTime = 0 then
    FDateTime := SysUtils.Now;
  FDateTime := IncMinute( FDateTime, DeltaMinutes );
  if FDateTime < 0 then
  begin
    // Time has been changed to be earlier than 12:00 am.
    FDateTime := IncHour( FDateTime, 24 );
  end;
  CheckDateTimeChange;
  UpdateText;
end;


procedure TRzDBDateTimeEdit.KeyDown( var Key: Word; Shift: TShiftState );
begin
  inherited;

  if FEditType = etDate then
  begin
    case Key of
      vk_Prior:
      begin
        if ssShift in Shift then
          AdjustYear( 1 )
        else
          AdjustMonth( 1 );
      end;

      vk_Next:
      begin
        if ssShift in Shift then
          AdjustYear( -1 )
        else
          AdjustMonth( -1 );
      end;

      vk_Up:
        AdjustDay( 1 );
      vk_Down:
        AdjustDay( -1 );
    end;
  end
  else // FEditType = etTime
  begin
    case Key of
      vk_Prior:
        AdjustHour( 1 );
      vk_Next:
        AdjustHour( -1 );
      vk_Up:
        AdjustMinute( 1 );
      vk_Down:
        AdjustMinute( -1 );
    end;
  end;
end;


procedure TRzDBDateTimeEdit.KeyPress( var Key: Char );
begin
  if ( FEditType = etTime ) and not ( Key in [ #8, #13, #27 ] ) and IsCharAlpha( Key ) and
     not ( Upcase( Key ) in [ 'A', 'P', 'M' ] ) then
  begin
    Key := #0;
    MessageBeep( 0 );
  end
  else if FEditType = etDate then
  begin
    if Key <> DateSeparator then
    begin
      case Key of
        '+', '=':
        begin
          AdjustDay( 1 );
          Key := #0;
        end;

        '-', '_':
        begin
          AdjustDay( -1 );
          Key := #0;
        end;

        else
          inherited;
      end;
    end
    else
      inherited;
  end
  else // FEdit = etTime
  begin
    if Key <> TimeSeparator then
    begin
      case Key of
        '+', '=':
        begin
          AdjustHour( 1 );
          Key := #0;
        end;

        '-', '_':
        begin
          AdjustHour( -1 );
          Key := #0;
        end;

        else
          inherited;
      end;
    end
    else
      inherited;
  end;
end;


procedure TRzDBDateTimeEdit.ReformatDateTime;
begin
  SetDateTime;
  UpdateText;
end;


function TRzDBDateTimeEdit.GetDate: TDate;
begin
  Result := Trunc( FDateTime );
end;


procedure TRzDBDateTimeEdit.SetDate( Value: TDate );
begin
  if CanEditData then
  begin
    FDateTime := Value;
    SetEditType( etDate );
    CheckDateTimeChange;
    UpdateText;
  end;
end;


function TRzDBDateTimeEdit.IsDate: Boolean;
begin
  Result := FEditType = etDate;
end;


procedure TRzDBDateTimeEdit.SetEditType( Value: TRzDTEditType );
begin
  if FEditType <> Value then
  begin
    FEditType := Value;
    ReformatDateTime;
  end;
end;


procedure TRzDBDateTimeEdit.SetFormat( const Value: string );
begin
  if FFormat <> Value then
  begin
    SetDateTime;
    FFormat := Value;
    UpdateText;
  end;
end;


procedure TRzDBDateTimeEdit.SetClockFaceColors( Value: TRzClockFaceColors );
begin
  FClockFaceColors.Assign( Value );
end;


procedure TRzDBDateTimeEdit.SetCalendarColors( Value: TRzCalendarColors );
begin
  FCalendarColors.Assign( Value );
end;


function TRzDBDateTimeEdit.GetTime: TTime;
begin
  Result := Frac( FDateTime );
end;


procedure TRzDBDateTimeEdit.SetTime( Value: TTime );
begin
  if CanEditData then
  begin
    FSettingTime := True;
    try
      FDateTime := Value;
      FTimeHasBeenSet := True;
      SetEditType( etTime );
      CheckDateTimeChange;
      UpdateText;
    finally
      FSettingTime := False;
    end;
  end;
end;


function TRzDBDateTimeEdit.IsTime: Boolean;
begin
  Result := FEditType = etTime;
end;


procedure TRzDBDateTimeEdit.Clear;
begin
  if CanEditData then
  begin
    inherited;
    FDateTime := 0;
    CheckDateTimeChange;
    FTimeHasBeenSet := False;
    UpdateText;
    if Field <> nil then
      Field.Clear;
  end;
end;


procedure TRzDBDateTimeEdit.WMSetFocus( var Msg: TMessage );
begin
  inherited;
  UpdateText;
end;


procedure TRzDBDateTimeEdit.WMKillFocus( var Msg: TMessage );
begin
  inherited;
  ReformatDateTime;
end;


procedure TRzDBDateTimeEdit.DataChanged;
begin
  if Field <> nil then
  begin
    FDateTime := DataLink.Field.AsDateTime;
    FTimeHasBeenSet := False;
    UpdateText;
  end
  else
  begin
    if csDesigning in ComponentState then
      EditText := Name
    else
      EditText := '';
  end;
end;


procedure TRzDBDateTimeEdit.UpdateData;
var
  DT: TDateTime;
begin
  if DataLink.Editing then
  begin
    DT := DataLink.Field.AsDateTime;
    if FEditType = etDate then
      ReplaceDate( DT, FDateTime )
    else
      ReplaceTime( DT, FDateTime );
    if ( DT = 0 ) and ( Text = '' ) then
      DataLink.Field.Clear
    else
      DataLink.Field.AsDateTime := DT;
  end;
end;


procedure TRzDBDateTimeEdit.WMGetDlgCode( var Msg: TWMGetDlgCode );
begin
  Msg.Result := dlgc_WantChars + dlgc_WantArrows;
end;



{==========================}
{== TRzPaintMemo Methods ==}
{==========================}

constructor TRzPaintMemo.Create( AOwner: TComponent );
begin
  inherited;
  FEditControl := TRzDBMemo( AOwner );
end;


procedure TRzPaintMemo.Paint;
var
  R: TRect;
  FrameColor: TColor;
  FrameSides: TSides;
  FrameStyle: TFrameStyle;
  FrameVisible: Boolean;
begin
  Canvas.Font := FEditControl.Font;
  Canvas.Brush.Color := FEditControl.Color;
  Canvas.FillRect( ClientRect );

  FrameColor := FEditControl.FrameColor;
  FrameSides := FEditControl.FrameSides;
  FrameStyle := FEditControl.FrameStyle;
  FrameVisible := FEditControl.FrameVisible;

  { Draw Border }
  if FrameVisible then
  begin
    R := ClientRect;
    if FEditControl.Color = clWindow then
    begin
      if FrameStyle = fsFlat then
        DrawSides( Canvas, R, FrameColor, FrameColor, FrameSides )
      else
        DrawBorderSides( Canvas, R, FrameStyle, FrameSides );
    end
    else
    begin
      if FrameStyle = fsFlat then
        DrawSides( Canvas, R, FrameColor, FrameColor, FrameSides )
      else
        DrawColorBorderSides( Canvas, R, FEditControl.Color, FrameStyle, FrameSides );
    end;
  end;

  { Draw Text }
  R := FEditControl.ClientRect;
  if FrameVisible then
    InflateRect( R, -1, -2 )
  else
    InflateRect( R, -1, -1 );
  Inc( R.Left );
  Dec( R.Right, 4 );

  DrawText( Canvas.Handle, PChar( Caption ), -1, R,
            dt_EditControl or dt_WordBreak or dt_ExpandTabs or DrawTextAlignments[ Alignment ] );
end; {= TRzPaintMemo.Paint; =}


{=======================}
{== TRzDBMemo Methods ==}
{=======================}

constructor TRzDBMemo.Create( AOwner: TComponent );
begin
  inherited;

  ControlStyle := ControlStyle - [ csSetCaption ];

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
  FTabOnEnter := False;

  FPaintControl := TRzPaintMemo.Create( Self );
  FPaintControl.Parent := Self;
  FPaintControl.Visible := False;
end;


procedure TRzDBMemo.CreateWnd;
begin
  inherited;
  LineColChange;
  ClipboardChange;
  {&RCI}
end;


destructor TRzDBMemo.Destroy;
begin
  FPaintControl.Free;
  if FFrameController <> nil then
    FFrameController.RemoveControl( Self );
  FCanvas.Free;
  inherited;
end;


procedure TRzDBMemo.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the FrameFlat and FrameFocusStyle properties were renamed to
  // FrameHotStyle and FrameHotStyle respectively in version 3.
  Filer.DefineProperty( 'FrameFlat', ReadOldFrameFlatProp, nil, False );
  Filer.DefineProperty( 'FrameFocusStyle', ReadOldFrameFocusStyleProp, nil, False );

  // Handle the fact that the FrameFlatStyle was published in version 2.x
  Filer.DefineProperty( 'FrameFlatStyle', TRzOldPropReader.ReadOldEnumProp, nil, False );
end;


procedure TRzDBMemo.ReadOldFrameFlatProp( Reader: TReader );
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


procedure TRzDBMemo.ReadOldFrameFocusStyleProp( Reader: TReader );
begin
  FFrameHotStyle := TFrameStyle( GetEnumValue( TypeInfo( TFrameStyle ), Reader.ReadIdent ) );
end;


procedure TRzDBMemo.Loaded;
begin
  inherited;
  UpdateColors;
  UpdateFrame( False, False );
end;


procedure TRzDBMemo.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( AComponent = FFrameController ) then
    FFrameController := nil;
end;


function TRzDBMemo.GetColor: TColor;
begin
  Result := inherited Color;
end;

procedure TRzDBMemo.SetColor( Value: TColor );
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


function TRzDBMemo.IsColorStored: Boolean;
begin
  Result := NotUsingController and Enabled;
end;


function TRzDBMemo.IsFocusColorStored: Boolean;
begin
  Result := NotUsingController and ( ColorToRGB( FFocusColor ) <> ColorToRGB( Color ) );
end;


function TRzDBMemo.NotUsingController: Boolean;
begin
  Result := FFrameController = nil;
end;


procedure TRzDBMemo.SetDisabledColor( Value: TColor );
begin
  FDisabledColor := Value;
  if not Enabled then
    UpdateColors;
end;


procedure TRzDBMemo.SetFocusColor( Value: TColor );
begin
  FFocusColor := Value;
  if Focused then
    UpdateColors;
end;


procedure TRzDBMemo.SetFrameColor( Value: TColor );
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    RepaintFrame;
  end;
end;


procedure TRzDBMemo.SetFrameController( Value: TRzFrameController );
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


procedure TRzDBMemo.SetFrameHotColor( Value: TColor );
begin
  if FFrameHotColor <> Value then
  begin
    FFrameHotColor := Value;
    RepaintFrame;
  end;
end;


procedure TRzDBMemo.SetFrameHotTrack( Value: Boolean );
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


procedure TRzDBMemo.SetFrameHotStyle( Value: TFrameStyle );
begin
  if FFrameHotStyle <> Value then
  begin
    FFrameHotStyle := Value;
    RepaintFrame;
  end;
end;


procedure TRzDBMemo.SetFrameSides( Value: TSides );
begin
  if FFrameSides <> Value then
  begin
    FFrameSides := Value;
    RepaintFrame;
  end;
end;


procedure TRzDBMemo.SetFrameStyle( Value: TFrameStyle );
begin
  if FFrameStyle <> Value then
  begin
    FFrameStyle := Value;
    RepaintFrame;
  end;
end;


procedure TRzDBMemo.SetFrameVisible( Value: Boolean );
begin
  if FFrameVisible <> Value then
  begin
    FFrameVisible := Value;
    if Parent is TDBCtrlPanel then
    begin
      ParentCtl3D := not FFrameVisible;
      Ctl3D := not FFrameVisible;
      Invalidate;
    end
    else
    begin
      if FFrameVisible then
        Ctl3D := True;
      RecreateWnd;
    end;
  end;
end;


procedure TRzDBMemo.SetFramingPreference( Value: TFramingPreference );
begin
  if FFramingPreference <> Value then
  begin
    FFramingPreference := Value;
    if FFramingPreference = fpCustomFraming then
      RepaintFrame;
  end;
end;


procedure TRzDBMemo.JumpTo( ALine, ACol: Integer );
begin
  Line := ALine;
  if Line = ALine then
    Column := ACol;
end;


function TRzDBMemo.GetColumn: Integer;
var
  CaretPos: TPoint;
  P, LinePos, CharPos: Integer;
begin
  Windows.GetCaretPos( CaretPos );

  P := SendMessage( Handle, em_CharFromPos, 0, MakeLong( Word( CaretPos.X ), Word( CaretPos.Y ) ) );
  if P <> -1 then
  begin
    CharPos := LoWord( P );
    LinePos := HiWord( P );
    Result := CharPos - SendMessage( Handle, em_LineIndex, LinePos, 0 ) + 1;
  end
  else
    Result := 1;
end;


procedure TRzDBMemo.SetColumn( Value: Integer );
var
  P, Len: Integer;
begin
  P := SendMessage( Handle, em_LineIndex, Line - 1, 0 );
  Len := SendMessage( Handle, em_LineLength, P, 0 );
  if Value <= Len + 1 then
  begin
    P := P + Value - 1;
    SendMessage( Handle, em_SetSel, P, P );
    LineColChange;
  end;
end;


function TRzDBMemo.GetLine: Integer;
var
  CaretPos: TPoint;
  P: Integer;
begin
  Windows.GetCaretPos( CaretPos );

  P := SendMessage( Handle, em_CharFromPos, 0, MakeLong( Word( CaretPos.X ), Word( CaretPos.Y ) ) );
  if P <> -1 then
    Result := HiWord( P ) + 1
  else
    Result := 1;
end;


procedure TRzDBMemo.SetLine( Value: Integer );
var
  P, L: Integer;
begin
  P := SendMessage( Handle, em_LineIndex, Value - 1, 0 );

                       { Position Cursor to correct line number }
  SendMessage( Handle, em_SetSel, P, P );

  if Line = Value then
  begin
                            { Move selected line to top of window }
    L := SendMessage( Handle, em_GetFirstVisibleLine, 0, 0 );
    SendMessage( Handle, em_LineScroll, 0, Value - L - 1 );
    LineColChange;
  end;
end;


procedure TRzDBMemo.Change;
begin
  inherited;
  LineColChange;
end;


procedure TRzDBMemo.Click;
begin
  {&RV}
  inherited;
  LineColChange;
end;


procedure TRzDBMemo.KeyDown( var Key: Word; Shift: TShiftState );
begin
  inherited;
  LineColChange;
end;


procedure TRzDBMemo.KeyUp( var Key: Word; Shift: TShiftState );
begin
  inherited;
  LineColChange;
end;


procedure TRzDBMemo.KeyPress( var Key: Char );
begin
  if FTabOnEnter and ( Ord( Key ) = vk_Return ) then
  begin
    Key := #0;
    PostMessage( Handle, wm_KeyDown, vk_Tab, 0 );
  end
  else
    inherited;
end;


procedure TRzDBMemo.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  ClipboardChange;
end;


procedure TRzDBMemo.LineColChange;
begin
  if Assigned( FOnLineColChange ) then
    FOnLineColChange( Self, Line, Column );
  ClipboardChange;
end;


procedure TRzDBMemo.ClipboardChange;
begin
  if Assigned( FOnClipboardChange ) then
    FOnClipboardChange( Self, SelLength <> 0, Clipboard.HasFormat( cf_Text ) );
end;



function TRzDBMemo.DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean;
begin
  inherited DoMouseWheelDown( Shift, MousePos );
  if ( GetKeyState( vk_Control ) and $8000 ) = $8000 then
    SendMessage( Handle, em_LineScroll, 0, Mouse.WheelScrollLines )
  else
    SendMessage( Handle, em_LineScroll, 0, 1 );
  Result := True;
end;


function TRzDBMemo.DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean;
begin
  inherited DoMouseWheelUp( Shift, MousePos );
  if ( GetKeyState( vk_Control ) and $8000 ) = $8000 then
    SendMessage( Handle, em_LineScroll, 0, -Mouse.WheelScrollLines )
  else
    SendMessage( Handle, em_LineScroll, 0, -1 );
  Result := True;
end;


procedure TRzDBMemo.RepaintFrame;
var
  R: TRect;
begin
  R := ClientRect;
  if Parent is TDBCtrlPanel then
    Invalidate
  else
    RedrawWindow( Handle, @R, 0, rdw_Invalidate or rdw_UpdateNow or rdw_Frame );
end;


function TRzDBMemo.UseThemes: Boolean;
begin
  Result := ( FFramingPreference = fpXPThemes ) and ThemeServices.ThemesEnabled;
end;


procedure TRzDBMemo.WMNCPaint( var Msg: TWMNCPaint );
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
end; {= TRzDBMemo.WMNCPaint =}


procedure TRzDBMemo.CMParentColorChanged( var Msg: TMessage );
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


procedure TRzDBMemo.CMEnabledChanged( var Msg: TMessage );
begin
  inherited;
  UpdateColors;
end;


procedure TRzDBMemo.WMPaint( var Msg: TWMPaint );
var
  S: string;
begin
  if csPaintCopy in ControlState then
  begin
    if Field <> nil then
    begin
      if Field.IsBlob then
      begin
        if AutoDisplay then
          S := AdjustLineBreaks( Field.AsString )
        else
          S := Format('(%s)', [ Field.DisplayLabel ] );
      end
      else
        S := Field.DisplayText;
    end;

    FPaintControl.SetBounds( BoundsRect.Left, BoundsRect.Top,
                             BoundsRect.Right - BoundsRect.Left,
                             BoundsRect.Bottom - BoundsRect.Top );
    if Field <> nil then
      FPaintControl.Alignment := Field.Alignment;

    SendMessage( FPaintControl.Handle, wm_SetText, 0, Longint( PChar( S ) ) );
    SendMessage( FPaintControl.Handle, wm_Paint, WParam( Msg.DC ), 0 );
  end
  else
  begin
    FPaintControl.SetBounds( 0, 0, 0, 0 );
    inherited;

    if FFrameVisible and not UseThemes and ( Parent is TDBCtrlPanel ) then
      DrawFrame( FCanvas, Width, Height, FFrameStyle, Color, FFrameColor, FFrameSides );
  end;
end; {= TRzDBMemo.WMPaint =}


procedure TRzDBMemo.UpdateColors;
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


procedure TRzDBMemo.UpdateFrame( ViaMouse, InFocus: Boolean );
begin
  if ViaMouse then
    FOverControl := InFocus;

  if FFrameHotTrack then
    RepaintFrame;

  UpdateColors;
end;


procedure TRzDBMemo.CMEnter( var Msg: TCMEnter );
begin
  UpdateFrame( False, True );
  inherited;
end;

procedure TRzDBMemo.CMExit( var Msg: TCMExit );
begin
  inherited;
  UpdateFrame( False, False );
end;


procedure TRzDBMemo.MouseEnter;
begin
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
end;

procedure TRzDBMemo.CMMouseEnter( var Msg: TMessage );
begin
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  UpdateFrame( True, True );
  MouseEnter;
end;

procedure TRzDBMemo.MouseLeave;
begin
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
end;

procedure TRzDBMemo.CMMouseLeave( var Msg: TMessage );
begin
  inherited;
  UpdateFrame( True, False );
  MouseLeave;
end;

procedure TRzDBMemo.WMSize( var Msg: TWMSize );
begin
  inherited;
  if FFrameVisible and not UseThemes then
    RepaintFrame;
end;


{===========================}
{== TRzDBRichEdit Methods ==}
{===========================}

constructor TRzDBRichEdit.Create( AOwner: TComponent );
begin
  inherited;

  ControlStyle := ControlStyle - [ csSetCaption ];

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
  FTabOnEnter := False;
end;

procedure TRzDBRichEdit.CreateWnd;
begin
  inherited;
  LineColChange;
  ClipboardChange;
  {&RCI}
end;


destructor TRzDBRichEdit.Destroy;
begin
  if FFrameController <> nil then
    FFrameController.RemoveControl( Self );
  FCanvas.Free;
  inherited;
end;


procedure TRzDBRichEdit.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the FrameFlat and FrameFocusStyle properties were renamed to
  // FrameHotStyle and FrameHotStyle respectively in version 3.
  Filer.DefineProperty( 'FrameFlat', ReadOldFrameFlatProp, nil, False );
  Filer.DefineProperty( 'FrameFocusStyle', ReadOldFrameFocusStyleProp, nil, False );

  // Handle the fact that the FrameFlatStyle was published in version 2.x
  Filer.DefineProperty( 'FrameFlatStyle', TRzOldPropReader.ReadOldEnumProp, nil, False );
end;


procedure TRzDBRichEdit.ReadOldFrameFlatProp( Reader: TReader );
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


procedure TRzDBRichEdit.ReadOldFrameFocusStyleProp( Reader: TReader );
begin
  FFrameHotStyle := TFrameStyle( GetEnumValue( TypeInfo( TFrameStyle ), Reader.ReadIdent ) );
end;


procedure TRzDBRichEdit.Loaded;
begin
  inherited;
  UpdateColors;
  UpdateFrame( False, False );
end;


procedure TRzDBRichEdit.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( AComponent = FFrameController ) then
    FFrameController := nil;
end;


function TRzDBRichEdit.GetColor: TColor;
begin
  Result := inherited Color;
end;

procedure TRzDBRichEdit.SetColor( Value: TColor );
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


function TRzDBRichEdit.IsColorStored: Boolean;
begin
  Result := NotUsingController and Enabled;
end;


function TRzDBRichEdit.IsFocusColorStored: Boolean;
begin
  Result := NotUsingController and ( ColorToRGB( FFocusColor ) <> ColorToRGB( Color ) );
end;


function TRzDBRichEdit.NotUsingController: Boolean;
begin
  Result := FFrameController = nil;
end;


procedure TRzDBRichEdit.SetDisabledColor( Value: TColor );
begin
  FDisabledColor := Value;
  if not Enabled then
    UpdateColors;
end;


procedure TRzDBRichEdit.SetFocusColor( Value: TColor );
begin
  FFocusColor := Value;
  if Focused then
    UpdateColors;
end;


procedure TRzDBRichEdit.SetFrameColor( Value: TColor );
begin
  if FFrameColor <> Value then
  begin
    FFrameColor := Value;
    RepaintFrame;
  end;
end;


procedure TRzDBRichEdit.SetFrameController( Value: TRzFrameController );
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


procedure TRzDBRichEdit.SetFrameHotColor( Value: TColor );
begin
  if FFrameHotColor <> Value then
  begin
    FFrameHotColor := Value;
    RepaintFrame;
  end;
end;


procedure TRzDBRichEdit.SetFrameHotTrack( Value: Boolean );
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


procedure TRzDBRichEdit.SetFrameHotStyle( Value: TFrameStyle );
begin
  if FFrameHotStyle <> Value then
  begin
    FFrameHotStyle := Value;
    RepaintFrame;
  end;
end;


procedure TRzDBRichEdit.SetFrameSides( Value: TSides );
begin
  if FFrameSides <> Value then
  begin
    FFrameSides := Value;
    RepaintFrame;
  end;
end;


procedure TRzDBRichEdit.SetFrameStyle( Value: TFrameStyle );
begin
  if FFrameStyle <> Value then
  begin
    FFrameStyle := Value;
    RepaintFrame;
  end;
end;


procedure TRzDBRichEdit.SetFrameVisible( Value: Boolean );
begin
  if FFrameVisible <> Value then
  begin
    FFrameVisible := Value;
    if FFrameVisible then
      Ctl3D := True;
    RecreateWnd;
  end;
end;


procedure TRzDBRichEdit.SetFramingPreference( Value: TFramingPreference );
begin
  if FFramingPreference <> Value then
  begin
    FFramingPreference := Value;
    if FFramingPreference = fpCustomFraming then
      RepaintFrame;
  end;
end;


procedure TRzDBRichEdit.JumpTo( ALine, ACol: Integer );
begin
  Line := ALine;
  if Line = ALine then
    Column := ACol;
end;


function TRzDBRichEdit.GetColumn: Integer;
var
  CaretPos: TPoint;
  P, LinePos, CharPos: Integer;
begin
  Windows.GetCaretPos( CaretPos );

  P := SendMessage( Handle, em_CharFromPos, 0, MakeLong( Word( CaretPos.X ), Word( CaretPos.Y ) ) );
  if P <> -1 then
  begin
    CharPos := LoWord( P );
    LinePos := HiWord( P );
    Result := CharPos - SendMessage( Handle, em_LineIndex, LinePos, 0 ) + 1;
  end
  else
    Result := 1;
end;


procedure TRzDBRichEdit.SetColumn( Value: Integer );
var
  P, Len: Integer;
begin
  P := SendMessage( Handle, em_LineIndex, Line - 1, 0 );
  Len := SendMessage( Handle, em_LineLength, P, 0 );
  if Value <= Len + 1 then
  begin
    P := P + Value - 1;
    SendMessage( Handle, em_SetSel, P, P );
    LineColChange;
  end;
end;


function TRzDBRichEdit.GetLine: Integer;
var
  CaretPos: TPoint;
  P: Integer;
begin
  Windows.GetCaretPos( CaretPos );

  P := SendMessage( Handle, em_CharFromPos, 0, MakeLong( Word( CaretPos.X ), Word( CaretPos.Y ) ) );
  if P <> -1 then
    Result := HiWord( P ) + 1
  else
    Result := 1;
end;


procedure TRzDBRichEdit.SetLine( Value: Integer );
var
  P, L: Integer;
begin
  P := SendMessage( Handle, em_LineIndex, Value - 1, 0 );

                       { Position Cursor to correct line number }
  SendMessage( Handle, em_SetSel, P, P );

  if Line = Value then
  begin
                            { Move selected line to top of window }
    L := SendMessage( Handle, em_GetFirstVisibleLine, 0, 0 );
    SendMessage( Handle, em_LineScroll, 0, Value - L - 1 );
    LineColChange;
  end;
end;


procedure TRzDBRichEdit.Change;
begin
  inherited;
  LineColChange;
end;


procedure TRzDBRichEdit.Click;
begin
  {&RV}
  inherited;
  LineColChange;
end;


procedure TRzDBRichEdit.KeyDown( var Key: Word; Shift: TShiftState );
begin
  inherited;
  LineColChange;
end;


procedure TRzDBRichEdit.KeyUp( var Key: Word; Shift: TShiftState );
begin
  inherited;
  LineColChange;
end;


procedure TRzDBRichEdit.KeyPress( var Key: Char );
begin
  if FTabOnEnter and ( Ord( Key ) = vk_Return ) then
  begin
    Key := #0;
    PostMessage( Handle, wm_KeyDown, vk_Tab, 0 );
  end
  else
    inherited;
end;


procedure TRzDBRichEdit.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  ClipboardChange;
end;


procedure TRzDBRichEdit.SelectionChange;
begin
  inherited;
  ClipboardChange;
end;


procedure TRzDBRichEdit.LineColChange;
begin
  if Assigned( FOnLineColChange ) then
    FOnLineColChange( Self, Line, Column );
  ClipboardChange;
end;


procedure TRzDBRichEdit.ClipboardChange;
begin
  if Assigned( FOnClipboardChange ) then
    FOnClipboardChange( Self, SelLength <> 0, Clipboard.HasFormat( cf_Text ) );
end;



function TRzDBRichEdit.DoMouseWheelDown( Shift: TShiftState; MousePos: TPoint ): Boolean;
begin
  inherited DoMouseWheelDown( Shift, MousePos );
  if ( GetKeyState( vk_Control ) and $8000 ) = $8000 then
    SendMessage( Handle, em_LineScroll, 0, Mouse.WheelScrollLines )
  else
    SendMessage( Handle, em_LineScroll, 0, 1 );
  Result := True;
end;


function TRzDBRichEdit.DoMouseWheelUp( Shift: TShiftState; MousePos: TPoint ): Boolean;
begin
  inherited DoMouseWheelUp( Shift, MousePos );
  if ( GetKeyState( vk_Control ) and $8000 ) = $8000 then
    SendMessage( Handle, em_LineScroll, 0, -Mouse.WheelScrollLines )
  else
    SendMessage( Handle, em_LineScroll, 0, -1 );
  Result := True;
end;


procedure TRzDBRichEdit.RepaintFrame;
var
  R: TRect;
begin
  R := ClientRect;
  RedrawWindow( Handle, @R, 0, rdw_Invalidate or rdw_UpdateNow or rdw_Frame );
end;


function TRzDBRichEdit.UseThemes: Boolean;
begin
  Result := ( FFramingPreference = fpXPThemes ) and ThemeServices.ThemesEnabled;
end;


procedure TRzDBRichEdit.CMEnabledChanged( var Msg: TMessage );
begin
  inherited;
  UpdateColors;
end;


procedure TRzDBRichEdit.WMNCPaint( var Msg: TWMNCPaint );
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
end; {= TRzDBRichEdit.WMNCPaint =}


procedure TRzDBRichEdit.CMParentColorChanged( var Msg: TMessage );
begin
  inherited;

  if ParentColor then
  begin
    // If ParentColor set to True, must reset FNormalColor and FFocusColor
    if FFocusColor = FNormalColor then
      FFocusColor := Color;
    FNormalColor := Color;
  end;

  if FFrameVisible and not UseThemes then
    RepaintFrame;
end;


procedure TRzDBRichEdit.UpdateColors;
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


procedure TRzDBRichEdit.UpdateFrame( ViaMouse, InFocus: Boolean );
begin
  if ViaMouse then
    FOverControl := InFocus;

  if FFrameHotTrack then
    RepaintFrame;

  UpdateColors;
end;


procedure TRzDBRichEdit.CMEnter( var Msg: TCMEnter );
begin
  UpdateFrame( False, True );
  inherited;
end;

procedure TRzDBRichEdit.CMExit( var Msg: TCMExit );
begin
  inherited;
  UpdateFrame( False, False );
end;


procedure TRzDBRichEdit.MouseEnter;
begin
  if Assigned( FOnMouseEnter ) then
    FOnMouseEnter( Self );
end;

procedure TRzDBRichEdit.CMMouseEnter( var Msg: TMessage );
begin
  inherited;
  {$IFDEF VCL70_OR_HIGHER}
  if csDesigning in ComponentState then
    Exit;
  {$ENDIF}
  UpdateFrame( True, True );
  MouseEnter;
end;

procedure TRzDBRichEdit.MouseLeave;
begin
  if Assigned( FOnMouseLeave ) then
    FOnMouseLeave( Self );
end;

procedure TRzDBRichEdit.CMMouseLeave( var Msg: TMessage );
begin
  inherited;
  UpdateFrame( True, False );
  MouseLeave;
end;

procedure TRzDBRichEdit.WMSize( var Msg: TWMSize );
begin
  inherited;
  if FFrameVisible and not UseThemes then
    RepaintFrame;
end;

{&RUIF}

end.
