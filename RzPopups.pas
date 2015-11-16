{===============================================================================
  RzPopups Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzCalendar           Calendar panel that displays dates in month view
                          (Office-style)
  TRzTimePicker         Custom panel that displays a clock and allows a user to
                          select a time using left and right mouse buttons.


  Modification History
  ------------------------------------------------------------------------------
  3.0.10 (26 Dec 2003)
    * Enhanced StrToDateEx procedure to accept 8-digit strings (e.g. MMDDYYYY)
      without separators and correctly convert it into an actual date.
  3.0.9  (22 Sep 2003)
    * Fixed problem where TRzCalendar.OnDblClick would never get fired.
    * Added OnGetWeekNumber event to TRzCalendar. Handle this event to implement
      a customized week numbering scheme.
    * Added Format property to TRzTimePicker. This property controls the format
      of the time that is displayed at the top of the control.
    * Set default values for TRzCalendar.CalendarColors and
      TRzTimePicker.ClockFaceColors.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Made change to TRzPopup.Popup method so that when a popup window is
      displayed by a control, the CPU utilization no longer hits 100%.
  ------------------------------------------------------------------------------
  3.0.6  (11 Apr 2003)
    * Fixed problem where StrToDateEx would try to interpret the year in a date
      specifying a month name (e.g. April 11, 2003) as a month/year combintation
      without a date-separator. This lead to the entire date being considered
      invalid, when in fact it was a valid date.
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * Fixed problem where popups were not being displayed on the appropriate
      monitor when running under a system supporting multiple monitors.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Added keyboard support for TRzCalendar and TRzTimePicker.
    * HowToUseHint is positioned at bottom of TRzTimePicker. Also, a timer is
      used to remove the hint if the mouse is moved outside the clock face and
      the hint is still visible, which can happen if the user moves the mouse
      quickly.
    * Fixed display of Time header in TRzTimePicker so that it completely fills
      client region when other border styles are used.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Initial release.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzPopups;

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
  StdCtrls,
  ExtCtrls,
  RzCommon,
  RzPanel;

type
  {=========================================}
  {== TRzCalendarColors Class Declaration ==}
  {=========================================}

  TRzCalendar = class;

  TRzCalendarColors = class( TPersistent )
  private
    FDays: TColor;
    FFillDays: TColor;
    FDaysOfWeek: TColor;
    FLines: TColor;
    FSelectedDateBack: TColor;
    FSelectedDateFore: TColor;
    FTodaysDateFrame: TColor;

    FCalendar: TRzCalendar;
  protected
    { Property Access Methods }
    function GetColor( Index: Integer ): TColor; virtual;
    procedure SetColor( Index: Integer; Value: TColor ); virtual;
  public
    constructor Create( ACalendar: TRzCalendar );
    destructor Destroy; override;

    procedure Assign( Source: TPersistent ); override;

    { Property Declarations }
    property Calendar: TRzCalendar
      read FCalendar;

    property Colors[ Index: Integer ]: TColor
      read GetColor
      write SetColor;
  published
    property Days: TColor
      index 0
      read GetColor
      write SetColor
      default clWindowText;

    property FillDays: TColor
      index 1
      read GetColor
      write SetColor
      default clBtnShadow;

    property DaysOfWeek: TColor
      index 2
      read GetColor
      write SetColor
      default clWindowText;

    property Lines: TColor
      index 3
      read GetColor
      write SetColor
      default clBtnShadow;

    property SelectedDateBack: TColor
      index 4
      read GetColor
      write SetColor
      default clHighlight;

    property SelectedDateFore: TColor
      index 5
      read GetColor
      write SetColor
      default clHighlightText;

    property TodaysDateFrame: TColor
      index 6
      read GetColor
      write SetColor
      default clMaroon;
  end;


  TRzCalendarElement = ( ceYear, ceMonth, ceArrows, ceWeekNumbers, ceDaysOfWeek, ceFillDays, ceTodayButton, ceClearButton );
  TRzCalendarElements = set of TRzCalendarElement;

  TRzCalendarArea = ( caYear, caMonth, caArrows, caWeekNumbers, caDays, caDaysOfWeek, caFillDays, caTodayButton, caClearButton );
  TRzCalendarAreas = array[ TRzCalendarArea ] of TRect;

  TRzFirstDayOfWeek = ( fdowMonday, fdowTuesday, fdowWednesday, fdowThursday, fdowFriday,
                        fdowSaturday, fdowSunday, fdowLocale );

  TRzGetBoldDaysEvent = procedure( Sender: TObject; Year, Month: Word; var Bitmask: Cardinal ) of object;

  TRzGetWeekNumberEvent = procedure( Sender: TObject; WeekDate: TDateTime; var WeekNumber: Integer ) of object;

  TRzCalendar = class( TRzCustomPanel )
  private
    FFirstDay: Byte;
    FFirstDayOfWeek: TRzFirstDayOfWeek;
    FElements: TRzCalendarElements;
    FPressedArea: TRzCalendarArea;
    FOverArea: TRzCalendarArea;

    FIsPopup: Boolean;
    FMouseOverRect: TRect;
    FCharSize: TPoint;
    FCellSize: TPoint;

    FDate: TDateTime;
    FViewDate: TDateTime;
    FDrawDate: TDateTime;
    FForceUpdate: Boolean;

    FCaptionClearBtn: TCaption;
    FClearBtnWidth: Integer;
    FCaptionTodayBtn: TCaption;
    FTodayBtnWidth: Integer;

    FCalendarColors: TRzCalendarColors;
    FCounter: Integer;
    FMonthList: TWinControl;

    FOnChange: TNotifyEvent;
    FOnGetBoldDays: TRzGetBoldDaysEvent;
    FOnGetWeekNumber: TRzGetWeekNumberEvent;

    { Message Handling Methods }
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;
    procedure WMEraseBkgnd( var Msg: TMessage ); message wm_EraseBkgnd;
    procedure WMNCHitTest( var Msg: TWMNCHitTest ); message wm_NCHitTest;
    procedure WMTimer( var Msg: TMessage ); message wm_Timer;
    procedure WMGetDlgCode( var Msg: TWMGetDlgCode ); message wm_GetDlgCode;
  protected
    procedure CreateHandle; override;
    procedure CreateWnd; override;

    procedure Paint; override;

    procedure CalcAreas( var Areas: TRzCalendarAreas );
    procedure AdjustClientRect( var Rect: TRect ); override;
    procedure AdjustForFont;
    procedure CalcFontSize;
    procedure ConstrainedResize( var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer ); override;

    procedure UpdateHighlight( X, Y: Integer );
    function InternalHitTest( R: TRect; P: TPoint ): TDateTime;

    procedure StartTimer;
    procedure TimerExpired;
    procedure StopTimer;
    procedure CloseMonthList;

    { Event Dispatch Methods }
    procedure Changed; dynamic;
    procedure Click; override;
    procedure DblClick; override;
    procedure GetBoldDays( Year, Month: Word; var Bitmask: Cardinal ); dynamic;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseMove( Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;

    { Property Access Methods }
    procedure SetCalendarColors( Value: TRzCalendarColors ); virtual;
    procedure SetCaptionClearBtn( const Value: TCaption ); virtual;
    procedure SetCaptionTodayBtn( const Value: TCaption ); virtual;
    procedure SetDate( Value: TDateTime ); virtual;
    procedure SetFirstDayOfWeek( Value: TRzFirstDayOfWeek ); virtual;
    procedure SetElements( Value: TRzCalendarElements ); virtual;
    procedure SetOverArea( Value: TRzCalendarArea ); virtual;
    procedure SetPressedArea( Value: TRzCalendarArea ); virtual;
    procedure SetViewDate( Value: TDateTime ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function CanAutoSize( var NewWidth, NewHeight: Integer ): Boolean; override;

    function DaysToBitmask( Days: array of Byte ): Cardinal;
    function HitTest( X, Y: Integer ): TDateTime;

    function IsClear: Boolean;
    procedure Clear;
    procedure Today;

    property ViewDate: TDateTime
      read FViewDate
      write SetViewDate;

    property IsPopup: Boolean
      write FIsPopup;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property CalendarColors: TRzCalendarColors
      read FCalendarColors
      write SetCalendarColors;

    property CaptionClearBtn: TCaption
      read FCaptionClearBtn
      write SetCaptionClearBtn;

    property CaptionTodayBtn: TCaption
      read FCaptionTodayBtn
      write SetCaptionTodayBtn;

    property Date: TDateTime
      read FDate
      write SetDate;

    property FirstDayOfWeek: TRzFirstDayOfWeek
      read FFirstDayOfWeek
      write SetFirstDayOfWeek
      default fdowLocale;

    property Elements: TRzCalendarElements
      read FElements
      write SetElements
      default [ ceYear, ceMonth, ceArrows, ceFillDays, ceDaysOfWeek, ceTodayButton, ceClearButton ];

    property OnChange: TNotifyEvent
      read FOnChange
      write FOnChange;

    property OnGetBoldDays: TRzGetBoldDaysEvent
      read FOnGetBoldDays
      write FOnGetBoldDays;

    property OnGetWeekNumber: TRzGetWeekNumberEvent
      read FOnGetWeekNumber
      write FOnGetWeekNumber;

    { Inherited Properties & Events }
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize default True;
    property BevelWidth;
    property BiDiMode;
    property BorderInner;
    property BorderOuter default fsStatus;
    property BorderSides;
    property BorderColor;
    property BorderHighlight;
    property BorderShadow;
    property BorderWidth;
    property Color default clWindow;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor;
    property FlatColorAdjustment default 0;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEndDock;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;


  {==========================================}
  {== TRzClockFaceColors Class Declaration ==}
  {==========================================}

  TRzTimePicker = class;

  TRzClockFaceColors = class( TPersistent )
  private
    FFace: TColor;
    FHands: TColor;
    FNumbers: TColor;
    FHourTicks: TColor;
    FMinuteTicks: TColor;

    FTimePicker: TRzTimePicker;
  protected
    { Property Access Methods }
    function GetColor( Index: Integer ): TColor; virtual;
    procedure SetColor( Index: Integer; Value: TColor ); virtual;
  public
    constructor Create( ATimePicker: TRzTimePicker );
    destructor Destroy; override;

    procedure Assign( Source: TPersistent ); override;

    { Property Declarations }
    property TimePicker: TRzTimePicker
      read FTimePicker;

    property Colors[ Index: Integer ]: TColor
      read GetColor
      write SetColor;
  published
    { Property Declarations }
    property Face: TColor
      index 0
      read GetColor
      write SetColor
      default clBtnFace;

    property Hands: TColor
      index 1
      read GetColor
      write SetColor
      default clWindowText;

    property Numbers: TColor
      index 2
      read GetColor
      write SetColor
      default clWindowText;

    property HourTicks: TColor
      index 3
      read GetColor
      write SetColor
      default clBtnShadow;

    property MinuteTicks: TColor
      index 4
      read GetColor
      write SetColor
      default clWindowText;
  end;


  {=====================================}
  {== TRzTimePicker Class Declaration ==}
  {=====================================}

  TRzTimePicker = class( TRzCustomPanel )
  private
    FTime: TTime;
    FTimeIsPM: Boolean;
    FRestrictMinutes: Boolean;
    FForceUpdate: Boolean;
    FIsPopup: Boolean;

    FTimeRect: TRect;
    FClockRect: TRect;
    FRadius: Integer;
    FClockCenter: TPoint;
    FAMRect: TRect;
    FPMRect: TRect;
    FSetRect: TRect;
    FCharSize: TPoint;

    FMouseOverAM: Boolean;
    FMouseOverPM: Boolean;
    FMouseOverSet: Boolean;
    FMouseOverClock: Boolean;
    FPressingLeft: Boolean;
    FPressingRight: Boolean;

    FFormat: string;
    FCaptionAM: TCaption;
    FCaptionPM: TCaption;
    FCaptionSet: TCaption;

    FClockFaceColors: TRzClockFaceColors;
    FShowSetButton: Boolean;
    FShowHowToUseHint: Boolean;
    FHowToUseMsg: string;
    FHintWnd: THintWindow;
    FTimer: TTimer;

    FOnChange: TNotifyEvent;
    FOnSetBtnClick: TNotifyEvent;
    FOnSetTime: TNotifyEvent;

    { Internal Event Handlers }
    procedure CheckHintWindowHandler( Sender: TObject );

    { Message Handling Methods }
    procedure CMFontChanged( var Msg: TMessage ); message cm_FontChanged;
    procedure CMDialogChar( var Msg: TCMDialogChar ); message cm_DialogChar;
    procedure WMGetDlgCode( var Msg: TWMGetDlgCode ); message wm_GetDlgCode;
  protected
    procedure Paint; override;
    procedure DrawClock( Bounds: TRect; CenterPoint: TPoint; Radius: Integer ); virtual;

    procedure CalcRects;
    procedure AdjustClientRect( var Rect: TRect ); override;
    procedure AdjustForFont;
    procedure CalcFontSize;
    procedure ConstrainedResize( var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer ); override;

    function NormalizedArcTan( const Y, X: Extended ): Extended;
    function GetHourFromXY( X, Y: Integer ): Integer;
    function GetMinuteFromXY( X, Y: Integer; Restrict: Boolean ): Integer;

    function CalcHintRect( MaxWidth: Integer; const HintStr: string; HintWnd: THintWindow ): TRect;
    procedure DoHint( X, Y: Integer );
    procedure ReleaseHintWindow;

    procedure ChangeToAM;
    procedure ChangeToPM;

    { Event Dispatch Methods }
    procedure Changed; dynamic;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown( var Key: Word; Shift: TShiftState ); override;
    procedure MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseMove( Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer ); override;
    procedure MouseEnter; override;
    procedure MouseLeave; override;
    procedure SetBtnClick; dynamic;

    { Property Access Methods }
    procedure SetCaptionAM( const Value: TCaption ); virtual;
    procedure SetCaptionPM( const Value: TCaption ); virtual;
    procedure SetCaptionSet( const Value: TCaption ); virtual;
    procedure SetClockFaceColors( Value: TRzClockFaceColors ); virtual;
    procedure SetFormat( const Value: string ); virtual;
    procedure SetHour( Value: Integer );
    procedure SetMinutes( Value: Integer );
    procedure SetTime( Value: TTime ); virtual;
    procedure SetShowSetButton( Value: Boolean ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function CanAutoSize( var NewWidth, NewHeight: Integer ): Boolean; override;

    procedure AdjustHour( DeltaHours: Int64 );
    procedure AdjustMinute( DeltaMinutes: Int64 );

    function IsClear: Boolean;
    procedure Clear;

    property IsPopup: Boolean
      write FIsPopup;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property CaptionAM: TCaption
      read FCaptionAM
      write SetCaptionAM;

    property CaptionPM: TCaption
      read FCaptionPM
      write SetCaptionPM;

    property CaptionSet: TCaption
      read FCaptionSet
      write SetCaptionSet;

    property ClockFaceColors: TRzClockFaceColors
      read FClockFaceColors
      write SetClockFaceColors;

    property Format: string
      read FFormat
      write SetFormat;

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

    property ShowSetButton: Boolean
      read FShowSetButton
      write SetShowSetButton
      default False;

    property Time: TTime
      read FTime
      write SetTime;

    property OnChange: TNotifyEvent
      read FOnChange
      write FOnChange;

    property OnSetBtnClick: TNotifyEvent
      read FOnSetBtnClick
      write FOnSetBtnClick;

    property OnSetTime: TNotifyEvent
      read FOnSetTime
      write FOnSetTime;

    { Inherited Properties & Events }
    property Align;
    property Alignment;
    property Anchors;
    property AutoSize default True;
    property BevelWidth;
    property BiDiMode;
    property BorderInner;
    property BorderOuter default fsLowered;
    property BorderSides;
    property BorderColor;
    property BorderHighlight;
    property BorderShadow;
    property BorderWidth;
    property Color default clWindow;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FlatColor;
    property FlatColorAdjustment default 0;
    property Font;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEndDock;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
  end;


  {======================================}
  {== TRzCustomPopup Class Declaration ==}
  {======================================}

  TRzCustomPopup = class( TRzCustomPanel )
  private
    FPopupControl: TControl;
  protected
    procedure AdjustClientRect( var Rect: TRect ); override;
    procedure AlignControls( AControl: TControl; var Rect: TRect ); override;

    procedure Paint; override;
  public
    constructor Create( AOwner: TComponent ); override;

    property PopupControl: TControl
      read FPopupControl;
  published
    property BevelWidth;
    property BorderInner;
    property BorderOuter;
    property BorderColor;
    property BorderHighlight;
    property BorderShadow;
    property BorderWidth;
    property FlatColor;
    property FlatColorAdjustment default 0;
  end;


  {=====================================}
  {== TRzPopupPanel Class Declaration ==}
  {=====================================}

  TRzPopupPanel = class( TRzCustomPopup )
  private
    FPopup: TWinControl;

    FOnClose: TNotifyEvent;
    FOnPopup: TNotifyEvent;
  protected
    procedure DestroyWnd; override;

    { Event Dispatch Methods }
    procedure DoClose; dynamic;
    procedure DoPopup; dynamic;

    { Property Access Methods }
    function GetActive: Boolean;
  public
    constructor Create( AOwner: TComponent ); override;

    procedure Close( Sender: TObject = nil );
    function Popup( PopupControl: TControl ): Boolean;

    property Active: Boolean
      read GetActive;
  published
    property OnClose: TNotifyEvent
      read FOnClose
      write FOnClose;

    property OnPopup: TNotifyEvent
      read FOnPopup
      write FOnPopup;

    { Inherited Properties & Events }
    property Alignment default taRightJustify;
    property AutoSize default True; 
    property BiDiMode;
    property ParentBiDiMode;
    property Color default clBtnFace;
    property Ctl3D;
    property Enabled;
    property Font;
    property ParentColor default False;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;

    property OnContextPopup;
  end;


function StrToDateEx( const S: string ): TDateTime;
function StrToTimeEx( const S: string ): TDateTime;


resourcestring
  sRzHowToSelectTime = 'Left-click to set Hour'#13'Right-click to set Minute'#13'    Ctrl key restricts to 5 minutes';
  sRzCaptionAM       = 'AM';
  sRzCaptionPM       = 'PM';
  sRzCaptionSet      = 'Set';
  sRzCaptionClearBtn = 'Clear';
  sRzCaptionTodayBtn = 'Today';

implementation

uses
  {$IFDEF VCL70_OR_HIGHER}
  Themes,
  {$ELSE}
  RzThemeSrv,
  {$ENDIF}
  {$IFDEF VCL60_OR_HIGHER}
  DateUtils,
  {$ENDIF}
  MultiMon,
  RzCommonBitmaps;


{=====================}
{== Support Methods ==}
{=====================}

function SimplifyFormat( const Format, ValidChars: string ): string;
var
  I: Integer;
  C: Char;
  S: string;
begin
  Result := '';
  S := UpperCase( Format );
  for I := 1 to Length( S ) do
  begin
    C := S[ I ];
    if ( Pos( C, ValidChars ) > 0 ) and ( Pos( C, Result ) = 0 ) then
    begin
      Result := Result + C;
    end;
  end;
end;


function ParseToken( var S: string; var Token: string ): Integer;
var
  I, Len: Integer;

  function CharType( C: Char ): Integer;
  begin
    if not IsCharAlphaNumeric( C ) then
      Result := 0
    else if IsCharAlpha( C ) then
      Result := -1
    else
      Result := 1;
  end;

begin
  Token := '';
  Result := 0;
  Len := Length( S );
  if Len > 0 then
  begin
    I := 1;
    while ( I <= Len ) and ( CharType( S[ I ] ) = 0 ) do
      Inc( I );
    Dec( Len, I - 1 );
    S := Copy( S, I, Len );
    if Len > 0 then
    begin
      Token := S;
      I := 2;
      Result := CharType( S[ 1 ] );
      while ( I <= Len ) and ( Result = CharType( S[ I ] ) ) do
        Inc( I );
      SetLength( Token, I - 1 );
      S := Copy( S, I, Len - I + 1 );
    end;
  end;
end; {= ParseToken =}



function StrToDateEx( const S: string ): TDateTime;
var
  C: Char;
  Token: Integer;
  TokenStr, T1, T2, T3, WorkStr, Format, SFormat: String;
  I, K, L, P1, P2: Integer;
  D, M, Y: Word;

  function MonthPassiveName( LCID: Cardinal; Month: Integer ): string;
  var
    M: TSystemTime;
    Buffer: array[ 0..255 ] of Char;
  begin
    M.wDay := 1;
    M.wMonth := Month;
    M.wYear := 2000;
    Result := 'dd MMMM';
    GetDateFormatA( LCID, 0, @M, PChar( Result ), Buffer, 256 );
    Result := Copy( StrPas( Buffer ), 4, 255 );
  end;

  function IsMonthName( const Name: string ): Integer;
  begin
    for Result := 1 to 12 do
    begin
      if AnsiUpperCase( ShortMonthNames[ Result ] ) = Name then
        Exit;
      if AnsiUpperCase( LongMonthNames[ Result ] ) = Name then
        Exit;
      if AnsiUpperCase( MonthPassiveName( LOCALE_USER_DEFAULT, Result ) ) = Name then
        Exit;
      if AnsiUpperCase( MonthPassiveName( $409, Result ) ) = Name then
        Exit;
    end;
    Result := -1;
  end;

begin {= StrToDateEx =}
  if Trim( S ) = '' then
    Result := 0
  else
  begin
    Format := SimplifyFormat( ShortDateFormat, 'DMY' );
    SFormat := Format;
    DecodeDate( SysUtils.Date, Y, M, D );
    WorkStr := AnsiUpperCase( S );
    for I := 1 to 3 do
    begin
      Token := ParseToken( WorkStr, TokenStr );
      while Token < 0 do
      begin
        K := IsMonthName( TokenStr );
        if K > 0 then
        begin
          M := K;
          RemoveChar( Format, 'M' );
        end;
        Token := ParseToken( WorkStr, TokenStr );
      end;
      if ( TokenStr > '' ) and ( Format > '' ) then
      begin
        L := Length( TokenStr );

        if ( L in [ 3, 4, 5, 6, 8 ] ) and ( Pos( DateSeparator, S ) = 0 ) and ( Format <> 'Y' ) then
        begin
          // This code handles the user entering dates without using the "/" symbol
          case L of
            3:
            begin
              P1 := 2;
              P2 := 0;
            end;

            4:
            begin
              P1 := 3;
              P2 := 0;
            end;

            5:
            begin
              P1 := 2;
              P2 := 4;
            end;

            else // L = 6 or 8
            begin
              P1 := 3;
              P2 := 5;
            end;
          end;

          T1 := Copy( TokenStr, 1, P1 - 1 );
          T2 := Copy( TokenStr, P1, 2 );
          if P2 > 0 then
          begin
            if L = 6 then
              T3 := Copy( TokenStr, P2, 2 )
            else
              T3 := Copy( TokenStr, P2, 4 );
          end
          else
            T3 := '';

          K := StrToInt( T1 );
          C := Format[ 1 ];
          if K > 999 then
            C := 'Y'
          else if ( K > 12 ) and ( C <> 'Y' ) then
            C := 'D';
          case C of
           'D':
             D := K;

           'M':
             M := K;

           else
             Y := K;
          end;
          RemoveChar( Format, C );

          K := StrToInt( T2 );
          C := Format[ 1 ];
          if K > 999 then
            C := 'Y'
          else if ( K > 12 ) and ( C <> 'Y' ) then
            C := 'D';
          case C of
           'D':
             D := K;

           'M':
             M := K;

           else
             Y := K;
          end;
          RemoveChar( Format, C );

          if T3 <> '' then
          begin
            K := StrToInt( T3 );
            C := Format[ 1 ];
            if K > 999 then
              C := 'Y'
            else if ( K > 12 ) and ( C <> 'Y' ) then
              C := 'D';
            case C of
             'D':
               D := K;

             'M':
               M := K;

             else
               Y := K;
            end;
            RemoveChar( Format, C );
          end;
        end
        else
        begin
          K := StrToInt( TokenStr );
          C := Format[ 1 ];
          if K > 999 then
            C := 'Y'
          else if ( K > 12 ) and ( C <> 'Y' ) then
            C := 'D';
          case C of
           'D':
             D := K;

           'M':
             M := K;

           else
             Y := K;
          end;
          RemoveChar( Format, C );
        end;
      end;
    end; { for }

    if M > 12 then
    begin
      if D <= 12 then
        Swap( M, D )
      else
        M := 1;
    end;

    if Y < 100 then
    begin
      // Short year format workaround
      Format := '';
      for I := 1 to Length( SFormat ) do
      begin
        case SFormat[ I ] of
         'D':
           Format := Format + DateSeparator + IntToStr( D );

         'M':
           Format := Format + DateSeparator + IntToStr( M );

         'Y':
           Format := Format + DateSeparator + IntToStr( Y );
        end;
      end;
      Delete( Format, 1, 1 );
      try
        Result := StrToDate( Format );
      except
        Result := 0;
      end;
    end
    else
    begin
      try
        Result := EncodeDate( Y, M, D );
      except
        Result := 0;
      end;
    end;
  end;
end; {= StrToDateEx =}


function StrToTimeEx( const S: string ): TDateTime;
var
  Token: Integer;
  TokenStr, T1, T2, WorkStr, Format, SFormat: String;
  I, K, AMPM, L, P: Integer;
  H, M, Sec, Z: Word;

  function IsAMPMName( const Token: string ): Integer;
  begin
    Result := 0;
    if ( Token = TimeAMString ) or ( Token = 'AM' ) or ( Token = 'A' ) then
      Result := -1
    else if ( Token = TimePMString ) or ( Token = 'PM' ) or ( Token = 'P' ) then
      Result :=  1;
  end;

begin {= StrToTimeEx =}
  Format := SimplifyFormat( LongTimeFormat, 'HMNSZ' );
  SFormat := Format;
  H := 0;
  M := 0;
  Sec := 0;
  Z := 0;
  AMPM := 0;
  WorkStr := AnsiUpperCase( S );
  for I := 1 to 4 do
  begin
    Token := ParseToken( WorkStr, TokenStr );
    while Token < 0 do
    begin
      if AMPM = 0 then
      begin
        K := IsAMPMName( TokenStr );
        if K <> 0 then
          AMPM := K;
      end;
      Token := ParseToken( WorkStr, TokenStr );
    end;
    if ( TokenStr > '' ) and ( Format > '' ) then
    begin
      L := Length( TokenStr );
      if ( L > 2 ) and ( L <= 4 ) then
      begin
        // This code handles the user entering times without using the ":" symbol
        if L = 3 then
          P := 2
        else
          P := 3;

        T1 := Copy( TokenStr, 1, P - 1 );
        T2 := Copy( TokenStr, P, 2 );

        K := StrToInt( T1 );
        case Format[ 1 ] of
         'H':
           H := K;

         'M','N':
           M := K;

         'S':
           Sec := K;

         else
           Z := K;
        end;
        Delete( Format, 1, 1 );

        K := StrToInt( T2 );
        case Format[ 1 ] of
         'H':
           H := K;

         'M','N':
           M := K;

         'S':
           Sec := K;

         else
           Z := K;
        end;
        Delete( Format, 1, 1 );

      end
      else
      begin
        K := StrToInt( TokenStr );
        case Format[ 1 ] of
         'H':
           H := K;

         'M','N':
           M := K;

         'S':
           Sec := K;

         else
           Z := K;
        end;
        Delete( Format, 1, 1 );
      end;
    end;
  end;

  if ( H < 12 ) and ( AMPM > 0 ) then
    Inc( H, 12 )
  else if ( H = 12 ) and ( AMPM < 0 ) then
    H := 0;

  while H >= 24 do
    Dec( H, 24 );
  if M >= 60 then
    M := 0;
  if Sec >= 60 then
    Sec := 0;
  while Z > 999 do
    Z := Z div 10;
  try
    Result := EncodeTime( H, M, Sec, Z );
  except
    Result := 0;
  end;
end; {= StrToTimeEx =}



{====================================}
{== TRzMonthList Class Declaration ==}
{====================================}

type
  TRzMonthList = class( TCustomControl )
  private
    FCalendar: TRzCalendar;
    FItemHeight: Integer;
    FHighlightMonth: TDateTime;
    FCenterMonth: TDateTime;
  protected
    procedure CreateParams( var Params: TCreateParams ); override;
    procedure Paint; override;

    procedure SelectMonth( const APoint: TPoint );
    function ScrollList: Integer;

    { Property Access Methods }
    procedure SetHighlightMonth( Value: TDateTime ); virtual;
    procedure SetCenterMonth( Value: TDateTime ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;

    property HighlightMonth: TDateTime
      read FHighlightMonth
      write SetHighlightMonth;

    property CenterMonth: TDateTime
      read FCenterMonth
      write SetCenterMonth;
  end;



{==========================}
{== TRzMonthList Methods ==}
{==========================}

constructor TRzMonthList.Create( AOwner: TComponent );
var
  W: Integer;
  P: TPoint;
begin
  inherited;

  FCalendar := TRzCalendar( AOwner );

  Visible := False;
  Parent := FCalendar;
  Color := FCalendar.Color;

  FItemHeight := FCalendar.FCharSize.Y + 2;
  W := FCalendar.FCharSize.X + 2;
  P := FCalendar.ClientToScreen( Point( W * 2, FCalendar.FMouseOverRect.Top + 2 - FItemHeight * 3 ) );
  SetBounds( P.X, P.Y, FCalendar.Width - W * 4, FItemHeight * 7 + 2 );

  CenterMonth := FCalendar.ViewDate;
  HighlightMonth := FCalendar.ViewDate;

  DoubleBuffered := True;
  Visible := True;
end;


procedure TRzMonthList.CreateParams( var Params: TCreateParams );
begin
  inherited;
  Params.Style := ( Params.Style and not ws_Child ) or ws_Popup or ws_Border;
end;


procedure TRzMonthList.Paint;
var
  I: Integer;
  P: TPoint;
  R: TRect;
  D: TDateTime;
  S: string;
begin
  inherited;
  GetCursorPos( P );
  P := ScreenToClient( P );

  Canvas.Font.Assign( Font );

  D := IncMonth( FCenterMonth, -3 );
  R := ClientRect;
  R.Bottom := R.Top + FItemHeight;

  for I := 0 to 6 do
  begin
    S := FormatDateTime( 'mmmm yyyy', D );
    if D = FHighlightMonth then
    begin
      Canvas.Brush.Color := clHighlight;
      Canvas.Font.Color := clHighlightText;
      Canvas.FillRect( R );
    end
    else
    begin
      Canvas.Brush.Color := Color;
      Canvas.Font.Color := Font.Color;
    end;
    DrawText( Canvas.Handle, PChar( S ), -1, R, dt_Center );
    Canvas.MoveTo( 0, 0 );
    OffsetRect( R, 0, FItemHeight );
    D := IncMonth( D, 1 );
  end;
end; {= TRzMonthList.Paint =}


procedure TRzMonthList.SelectMonth( const APoint: TPoint );
begin
  if PtInRect( ClientRect, APoint ) then
    HighlightMonth := IncMonth( CenterMonth, ( APoint.Y div FItemHeight ) - 3 )
  else
    HighlightMonth := 0;
end;


procedure TRzMonthList.SetHighlightMonth( Value: TDateTime );
begin
  if FHighlightMonth <> Value then
  begin
    FHighlightMonth := Value;
    Invalidate;
  end;
end;


procedure TRzMonthList.SetCenterMonth( Value: TDateTime );
begin
  if FCenterMonth <> Value then
  begin
    FCenterMonth := Value;
    Invalidate;
  end;
end;


function TRzMonthList.ScrollList: Integer;
var
  P: TPoint;
  Offset: Integer;
begin
  Offset := 0;
  GetCursorPos( P );
  P := ScreenToClient( P );

  if P.Y < 0 then
    Offset := -1
  else if P.Y > Height then
  begin
    Offset := 1;
    Dec( P.Y, Height );
  end;
  Result := 5 - ( Abs( P.Y ) div 10 );
  if Result < 0 then
    Result := 0;

  CenterMonth := IncMonth( FCenterMonth, Offset );
end;



{===============================}
{== TRzCalendarColors Methods ==}
{===============================}

constructor TRzCalendarColors.Create( ACalendar: TRzCalendar );
begin
  inherited Create;
  FCalendar := ACalendar;

  FDays := clWindowText;
  FFillDays := clBtnShadow;
  FDaysOfWeek := clWindowText;
  FLines := clBtnShadow;
  FSelectedDateBack := clHighlight;
  FSelectedDateFore := clHighlightText;
  FTodaysDateFrame := clMaroon;
end;


destructor TRzCalendarColors.Destroy;
begin
  FCalendar := nil;
  inherited;
end;


procedure TRzCalendarColors.Assign( Source: TPersistent );
begin
  if Source is TRzCalendarColors then
  begin
    Days := TRzCalendarColors( Source ).Days;
    FillDays := TRzCalendarColors( Source ).FillDays;
    DaysOfWeek := TRzCalendarColors( Source ).DaysOfWeek;
    Lines := TRzCalendarColors( Source ).Lines;
    SelectedDateBack := TRzCalendarColors( Source ).SelectedDateBack;
    SelectedDateFore := TRzCalendarColors( Source ).SelectedDateFore;
    TodaysDateFrame := TRzCalendarColors( Source ).TodaysDateFrame;
  end
  else
    inherited;
end;


function TRzCalendarColors.GetColor( Index: Integer ): TColor;
begin
  case Index of
    0: Result := FDays;
    1: Result := FFillDays;
    2: Result := FDaysOfWeek;
    3: Result := FLines;
    4: Result := FSelectedDateBack;
    5: Result := FSelectedDateFore;
    6: Result := FTodaysDateFrame;
    else
      Result := clNone;
  end;
end;


procedure TRzCalendarColors.SetColor( Index: Integer; Value: TColor );
begin
  case Index of
    0: FDays := Value;
    1: FFillDays := Value;
    2: FDaysOfWeek := Value;
    3: FLines := Value;
    4: FSelectedDateBack := Value;
    5: FSelectedDateFore := Value;
    6: FTodaysDateFrame := Value;
  end;

  if FCalendar <> nil then
    FCalendar.Invalidate;
end;



{&RT}
{=========================}
{== TRzCalendar Methods ==}
{=========================}

constructor TRzCalendar.Create( AOwner: TComponent );
begin
  inherited;
  ControlStyle := ( ControlStyle - [ csAcceptsControls, csNoStdEvents, csSetCaption ] ) + [ csReflector ];

  FElements := [ ceYear, ceMonth, ceArrows, ceFillDays, ceDaysOfWeek, ceTodayButton, ceClearButton ];
  FDate := 1;
  Clear;

  FForceUpdate := False;
  FFirstDayOfWeek := fdowLocale;

  FCalendarColors := TRzCalendarColors.Create( Self );
  {&RCI}

  Width := 147;
  Height := 159;

  Color := clWindow;
  FlatColorAdjustment := 0;
  BorderOuter := fsLowered;
  TabStop := True;
  AutoSize := True;
  DoubleBuffered := True;
  AdjustForFont;
end;


procedure TRzCalendar.CreateHandle;
begin
  inherited;
  FPressedArea := caFillDays;
end;


procedure TRzCalendar.CreateWnd;
begin
  inherited;
  SetFirstDayOfWeek( FFirstDayOfWeek );
end;


destructor TRzCalendar.Destroy;
begin
  CloseMonthList;
  FCalendarColors.Free;
  inherited;
end;


procedure TRzCalendar.Paint;
var
  S, F: string;
  R, WR, SelRect, DaysRect: TRect;
  I, J, WN, Offset: Integer;
  DrawDate: TDateTime;
  Y, M, D, ViewDateMonth: Word;
  PMBoldDays, NMBoldDays, CMBoldDays: Cardinal;
  ArrowFont: TFont;
  ButtonsVisible: Boolean;
  Areas: TRzCalendarAreas;
  ElementDetails: TThemedElementDetails;


  procedure DrawHorizontalLine( ALeft, ARight, AHeight: Integer );
  var
    ElementDetails: TThemedElementDetails;
  begin
    if ThemeServices.ThemesEnabled then
    begin
      ElementDetails := ThemeServices.GetElementDetails( ttbSeparatorVertNormal );
      ThemeServices.DrawElement( Canvas.Handle, ElementDetails, Rect( ALeft, AHeight, ARight, AHeight + 3 ) );
    end
    else
    begin
      Canvas.Pen.Color := FCalendarColors.Lines;
      Canvas.MoveTo( ALeft, AHeight );
      Canvas.LineTo( ARight, AHeight );
    end;
  end;


  procedure DrawVerticalLine( ATop, ABottom, ALeft: Integer );
  var
    ElementDetails: TThemedElementDetails;
  begin
    if ThemeServices.ThemesEnabled then
    begin
      ElementDetails := ThemeServices.GetElementDetails( ttbSeparatorNormal );
      ThemeServices.DrawElement( Canvas.Handle, ElementDetails, Rect( ALeft, ATop, ALeft + 3, ABottom ) );
    end
    else
    begin
      Canvas.Pen.Color := FCalendarColors.Lines;
      Canvas.MoveTo( ALeft, ATop );
      Canvas.LineTo( ALeft, ABottom );
    end;
  end;

  procedure DrawString( const S: string; var Bounds: TRect; Flags: Cardinal );
  begin
    DrawText( Canvas.Handle, PChar( S ), -1, Bounds, dt_VCenter or dt_SingleLine or Flags );
  end;


  procedure DrawButton( Bounds: TRect; const Caption: string; Down: Boolean );
  var
    EdgeType: Integer;
    ElementDetails: TThemedElementDetails;
  begin
    if ThemeServices.ThemesEnabled then
    begin
      if Down then
        ElementDetails := ThemeServices.GetElementDetails( tbPushButtonPressed )
      else
        ElementDetails := ThemeServices.GetElementDetails( tbPushButtonNormal );
      ThemeServices.DrawElement( Canvas.Handle, ElementDetails, Bounds );

      Canvas.Brush.Style := bsClear;
    end
    else
    begin
      Canvas.Brush.Color := clBtnFace;
      if Down then
        EdgeType := edge_Sunken
      else
      begin
        if ( BorderOuter = fsFlat ) or ( BorderOuter = fsFlatBold ) then
          EdgeType := edge_Etched
        else
          EdgeType := edge_Raised;
      end;
      DrawEdge( Canvas.Handle, Bounds, EdgeType, bf_Rect or bf_Middle or bf_Adjust );

      if Down then
      begin
        Inc( Bounds.Left, 2 );
        Inc( Bounds.Top, 2 );
      end;
    end;
    DrawString( Caption, Bounds, dt_Center );
    Canvas.Brush.Style := bsSolid;
  end;

begin {= TRzCalendar.Paint =}
  if ThemeServices.ThemesEnabled then
  begin
    ElementDetails := ThemeServices.GetElementDetails( teEditRoot );
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, ClientRect );
  end
  else
    inherited;

  CalcAreas( Areas );

  // Draw Month and Year Bar

  if ( [ ceMonth, ceYear ] * FElements ) <> [ ] then
  begin

    if ThemeServices.ThemesEnabled then
    begin
      ElementDetails := ThemeServices.GetElementDetails( thHeaderRoot );
      ThemeServices.DrawElement( Canvas.Handle, ElementDetails, Areas[ caYear ] );
    end
    else
    begin
      if ( BorderOuter = fsFlat ) or ( BorderOuter = fsFlatBold ) then
        DrawEdge( Canvas.Handle, Areas[ caYear ], bdr_RaisedInner, bf_Rect or bf_Middle or bf_Flat )
      else
        DrawEdge( Canvas.Handle, Areas[ caYear ], bdr_RaisedInner, bf_Rect or bf_Middle );
    end;

    SetBkMode( Canvas.Handle, Windows.Transparent );
    if ceArrows in FElements then
    begin
      ArrowFont := TFont.Create;
      try
        ArrowFont.Name := 'Marlett';
        ArrowFont.Size := Font.Size + 4;
        Canvas.Font.Assign( ArrowFont );
      finally
        ArrowFont.Free;
      end;
      DrawString( '3', Areas[ caMonth ], dt_Center );   // Draw Left Arrow
      DrawString( '4', Areas[ caArrows ], dt_Center );  // Draw Right Arrow
    end;
    // Draw month and year
    Canvas.Font.Assign( Font );
    F := 'mmmm';
    if ceYear in FElements then
      F := F + ' yyyy';
    DrawString( FormatDateTime( F, ViewDate ), Areas[ caYear ], dt_Center );
  end;

  ButtonsVisible := False;

  // Draw Today button

  if ceTodayButton in FElements then
  begin
    if FCaptionTodayBtn <> '' then
      S := FCaptionTodayBtn
    else
      S := sRzCaptionTodayBtn;
    DrawButton( Areas[ caTodayButton ], S, ( FPressedArea = caTodayButton ) and ( FOverArea = caTodayButton ) );
    ButtonsVisible := True;
  end;

  // Draw Clear Button

  if ceClearButton in FElements then
  begin
    if FCaptionClearBtn <> '' then
      S := FCaptionClearBtn
    else
      S := sRzCaptionClearBtn;
    DrawButton( Areas[ caClearButton ], S, ( FPressedArea = caClearButton ) and ( FOverArea = caClearButton ) );
    ButtonsVisible := True;
  end;

  // Draw Day of Week Headings

  if ceDaysOfWeek in FElements then
  begin
    Canvas.Brush.Color := Color;
    Canvas.Font.Color := FCalendarColors.DaysOfWeek;
    R := Bounds( Areas[ caDaysOfWeek ].Left, Areas[ caDaysOfWeek ].Top - 1, FCellSize.X - 2, FCellSize.Y );
    for I := 0 to 6 do
    begin
      J := FFirstDay + I + 2;
      if J > 7 then
        Dec( J, 7 );
      S := ShortDayNames[ J ];
      DrawString( S[ 1 ], R, dt_Right or dt_NoClip );
      OffsetRect( R, FCellSize.X, 0 );
    end;

    if ButtonsVisible or ( ceWeekNumbers in FElements ) then
    begin
      if ceWeekNumbers in FElements then
      begin
        if ThemeServices.ThemesEnabled then
          Offset := 6
        else
          Offset := 5;
        DrawHorizontalLine( Areas[ caWeekNumbers ].Right - Offset, Areas[ caDaysOfWeek ].Right, R.Bottom );
      end
      else
        DrawHorizontalLine( Areas[ caDaysOfWeek ].Left, Areas[ caDaysOfWeek ].Right, R.Bottom );
    end;
  end;

  // Draw Days

  DaysRect := Areas[ caDays ];

  CMBoldDays := 0;  // Current Month
  PMBoldDays := 0;  // Previous Month
  NMBoldDays := 0;  // Next Month

  DecodeDate( FViewDate, Y, ViewDateMonth, D );
  GetBoldDays( Y, ViewDateMonth, CMBoldDays );
  if ceFillDays in FElements then
  begin
    DecodeDate( FDrawDate, Y, M, D );
    GetBoldDays( Y, M, PMBoldDays );
    DecodeDate( IncMonth( FViewDate, 1 ), Y, M, D );
    GetBoldDays( Y, M, NMBoldDays );
  end;

  if ceWeekNumbers in FElements then
  begin
    Canvas.Pen.Color := FCalendarColors.DaysOfWeek;
    if ThemeServices.ThemesEnabled then
      Offset := 1
    else
      Offset := 0;
    DrawVerticalLine( Areas[ caWeekNumbers ].Top - Offset, Areas[ caWeekNumbers ].Bottom + Offset, Areas[ caWeekNumbers ].Right - 5 );
  end;

  R := Bounds( DaysRect.Left, DaysRect.Top - 1, FCellSize.X - 2, FCellSize.Y );

  WR := Areas[ caWeekNumbers ];
  Inc( WR.Top, 1 );
  WR.Bottom := WR.Top + FCellSize.Y;
  Dec( WR.Right, 5 );

  DrawDate := FDrawDate;
  for I := 0 to 5 do
  begin
    for J := 0 to 6 do
    begin
      DecodeDate( DrawDate, Y, M, D );
      Canvas.Brush.Color := Color;
      if M = ViewDateMonth then
      begin
        Canvas.Font.Color := FCalendarColors.Days;
        PMBoldDays := CMBoldDays;
      end
      else
      begin
        if M > ViewDateMonth then
          PMBoldDays := NMBoldDays;
        Canvas.Font.Color := FCalendarColors.FillDays;
      end;

      if ( PMBoldDays and ( $1 shl ( D - 1 ) ) ) = 0 then
        Canvas.Font.Style := Canvas.Font.Style - [ fsBold ]
      else
        Canvas.Font.Style := Canvas.Font.Style + [ fsBold ];

      if ( ( ceFillDays in FElements ) or ( M = ViewDateMonth ) ) then
      begin
        if DrawDate = Trunc( Self.Date ) then
        begin
          // Highlight selected Date
          SelRect := R;
          Inc( SelRect.Right, 2 );
          Canvas.Font.Color := FCalendarColors.SelectedDateFore;
          Canvas.Brush.Color := FCalendarColors.SelectedDateBack;
          FillRect( Canvas.Handle, SelRect, Canvas.Brush.Handle );

          if Focused then
            Canvas.DrawFocusRect( SelRect );
        end;

        DrawString( IntToStr( D ), R, dt_Right or dt_NoClip );

        if DrawDate = Trunc( SysUtils.Date ) then
        begin
          // Highlight Today's date
          Canvas.Pen.Color := FCalendarColors.TodaysDateFrame;
          Canvas.Brush.Style := bsClear;
          Canvas.Rectangle( R.Left, R.Top, R.Right + 2, R.Bottom );
          Canvas.Brush.Style := bsSolid;
        end;
      end;
      OffsetRect( R, FCellSize.X, 0 );
      DrawDate := DrawDate + 1;
    end;

    if ceWeekNumbers in FElements then
    begin
      Canvas.Brush.Color := Color;
      Canvas.Font.Color := FCalendarColors.DaysOfWeek;
      if Assigned( FOnGetWeekNumber ) then
      begin
        WN := WeekOf( DrawDate - 6 );
        FOnGetWeekNumber( Self, DrawDate, WN );
        DrawString( IntToStr( WN ), WR, dt_Center );
      end
      else
        DrawString( IntToStr( WeekOf( DrawDate - 6 ) ), WR, dt_Center );
      OffsetRect( WR, 0, FCellSize.Y );
    end;

    OffsetRect( R, DaysRect.Left - R.Left, FCellSize.Y );
  end;

  if ButtonsVisible then
  begin
    if ceWeekNumbers in FElements then
    begin
      if ThemeServices.ThemesEnabled then
        Offset := 6
      else
        Offset := 5;
      DrawHorizontalLine( Areas[ caWeekNumbers ].Right - Offset, DaysRect.Right, DaysRect.Bottom - 1 );
    end
    else
      DrawHorizontalLine( DaysRect.Left, DaysRect.Right, DaysRect.Bottom - 1 );
  end;

end; {= TRzCalendar.Paint =}



procedure TRzCalendar.CalcAreas( var Areas: TRzCalendarAreas );
var
  CR, R: TRect;
  I, J: Integer;
begin
  CR := ClientRect;
  AdjustClientRect( CR );

  FillChar( Areas, SizeOf( Areas ), 0 );
  if ( [ ceYear, ceMonth ] * FElements ) <> [ ] then
  begin
    // If ceYear or ceMonth in FElements...
    Areas[ caYear ] := CR;
    Areas[ caYear ].Bottom := CR.Top + FCharSize.Y + 5;
    if ceArrows in FElements then
    begin
      Areas[ caMonth ] := Areas[ caYear ];
      Areas[ caMonth ].Right := Areas[ caMonth ].Left + FCharSize.Y + 5;
      Areas[ caArrows ] := Areas[ caYear ];
      Areas[ caArrows ].Left := Areas[ caArrows ].Right - FCharSize.Y - 5;
    end;
    CR.Top := Areas[ caYear ].Bottom;
  end;

  Inc( CR.Left, FCharSize.X * 2 - 1 );
  Dec( CR.Right, FCharSize.X * 2 + 1 );
  if ( [ ceTodayButton, ceClearButton ] * FElements ) <> [ ] then
  begin
    // If ceTodayButton or ceClearButton in FOption...
    R := CR;
    R.Top := R.Bottom - ( FCharSize.Y + 15 + 3 );
    if ceTodayButton in FElements then
    begin
      Areas[ caTodayButton ] := R;
      if ceClearButton in FElements then
      begin
        Areas[ caTodayButton ].Right := ( R.Right + R.Left - FTodayBtnWidth - FClearBtnWidth - 5 ) div 2 + FTodayBtnWidth;
        R.Left := Areas[ caTodayButton ].Right + 5;
      end;
      Areas[ caTodayButton ] := CenterRect( Areas[ caTodayButton ], FTodayBtnWidth + 17, FCharSize.Y + 7 );
    end;
    if ceClearButton in FElements then
      Areas[ caClearButton ] := CenterRect( R, FClearBtnWidth + 17, FCharSize.Y + 7 );
    CR.Bottom := R.Top + 1;
  end;

  if ceWeekNumbers in FElements then
  begin
    Areas[ caWeekNumbers ] := CR;
    Areas[ caWeekNumbers ].Right := Cr.Left + FCharSize.X * 2 + 10;
    Inc( CR.Left, FCharSize.X * 2 + 10 );
  end;

  I := 6;
  J := 1;
  if ceDaysOfWeek in FElements then
  begin
    Inc( I );
    Inc( J );
  end;
  FCellSize.X := ( CR.Right - CR.Left ) div 7;
  FCellSize.Y := ( CR.Bottom - CR.Top - J ) div I;
  if ceDaysOfWeek in FElements then
  begin
    Areas[ caDaysOfWeek ] := CR;
    Areas[ caDaysOfWeek ].Bottom := Areas[ caDaysOfWeek ].Top + FCellSize.Y;
    Areas[ caWeekNumbers ].Top := Areas[ caDaysOfWeek ].Top + FCellSize.Y;
    CR.Top := Areas[ caDaysOfWeek ].Bottom + 2;
  end;

  Areas[ caDays ] := CR;
end; {= TRzCalendar.CalcAreas =}


procedure TRzCalendar.AdjustClientRect( var Rect: TRect );
begin
  inherited;
  FixClientRect( Rect, False );
end;


procedure TRzCalendar.AdjustForFont;
begin
  CalcFontSize;
  AdjustSize;
  Invalidate;
end;


procedure TRzCalendar.CalcFontSize;
var
  Canvas: TCanvas;
  DC: HDC;
begin
  Canvas := TCanvas.Create;
  DC := GetDC( 0 );
  try
    Canvas.Handle := DC;
    Canvas.Font.Assign( Font );
    FCharSize.X := Canvas.TextWidth( '0' );
    FCharSize.Y := Canvas.TextHeight( '0' );

    if FCaptionTodayBtn <> '' then
      FTodayBtnWidth := Canvas.TextWidth( FCaptionTodayBtn )
    else
      FTodayBtnWidth := Canvas.TextWidth( sRzCaptionTodayBtn );

    if FCaptionClearBtn <> '' then
      FClearBtnWidth := Canvas.TextWidth( FCaptionClearBtn )
    else
      FClearBtnWidth := Canvas.TextWidth( sRzCaptionClearBtn );
  finally
    Canvas.Handle := 0;
    Canvas.Free;
    ReleaseDC( 0, DC );
  end;
end; {= TRzCalendar.CalcFontSize =}


procedure TRzCalendar.ConstrainedResize( var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer );
begin
  CanAutoSize( MinWidth, MinHeight );
  inherited;
end;


function TRzCalendar.CanAutoSize( var NewWidth, NewHeight: Integer ): Boolean;
var
  W: Integer;
begin
  NewHeight := 4;
  if ( [ ceYear, ceMonth ] * FElements ) <> [ ] then
    Inc( NewHeight, FCharSize.Y + 5 );

  Inc( NewHeight, ( FCharSize.Y + 2 ) * 6 + 1 );

  if ceDaysOfWeek in FElements then
    Inc( NewHeight, ( FCharSize.Y + 2 ) + 1 );

  NewWidth := ( FCharSize.X * 2 + 5 ) * 7;

  if ceWeekNumbers in FElements then
    NewWidth := NewWidth + FCharSize.X * 2 + 5;

  if ( [ ceTodayButton, ceClearButton ] * FElements ) <> [ ] then
  begin
    Inc( NewHeight, FCharSize.Y + 15 + 2 );

    W := 34;
    if ceTodayButton in FElements then
    begin
      if ceClearButton in FElements then
        W := W + FTodayBtnWidth + 5 + FClearBtnWidth
      else
        W := W + FTodayBtnWidth;
    end
    else if ceClearButton in FElements then
      W := W + FClearBtnWidth;

    if W > NewWidth then
      NewWidth := W;
  end;
  Inc( NewWidth, FCharSize.X * 4 );
  Result := True;
end; {= TRzCalendar.CanAutoSize =}


procedure TRzCalendar.StartTimer;
begin
  if FOverArea = caYear then
    FMonthList := TRzMonthList.Create( Self );
  FCounter := -1;
  TimerExpired;
  SetTimer( Handle, 0, 50, nil );
end;


procedure TRzCalendar.TimerExpired;

  function ScrollMonth( var Counter: Integer ): Boolean;
  begin
    Result := False;
    Inc( Counter );
    if Counter < 20 then
    begin
      // For the first second ( 20 * 50 ms ), scroll month every 250 ms
      if ( Counter mod 5 ) <> 0 then
        Exit;
    end
    else if Counter < 200 then
    begin
      // For the next 9 seconds ( (200 - 20) * 50 ms ), scroll month every 100 ms
      if ( Counter mod 2 ) <> 0 then
        Exit;
    end;
    Result := True;
  end;

begin
  case FPressedArea of
    caMonth:
    begin
      if ScrollMonth( FCounter ) and ( FOverArea = FPressedArea ) then
        SetViewDate( IncMonth( FViewDate, -1 ) );
    end;

    caArrows:
    begin
      if ScrollMonth( FCounter ) and ( FOverArea = FPressedArea ) then
        SetViewDate( IncMonth( FViewDate, 1 ) );
    end;

    caYear:
    begin
      Dec( FCounter );
      if FCounter <= 0 then
        FCounter := TRzMonthList( FMonthList ).ScrollList;
    end;
  end;
end;


procedure TRzCalendar.StopTimer;
begin
  KillTimer( Handle, 0 );
  CloseMonthList;
end;


procedure TRzCalendar.CloseMonthList;
begin
  if FMonthList <> nil then
  begin
    FMonthList.Free;
    FMonthList := nil;
  end;
end;


procedure TRzCalendar.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
var
  Areas: TRzCalendarAreas;
begin
  inherited;

  if not ( csDesigning in ComponentState ) and not FIsPopup then
    SetFocus;

  if Button = mbLeft then
  begin
    if not PtInRect( ClientRect, Point( X, Y ) ) then
      SetOverArea( caFillDays );

    if FOverArea in [ caTodayButton, caClearButton, caDays ] then
    begin
      CalcAreas( Areas );
      FMouseOverRect := Areas[ FOverArea ];
    end
    else
      FMouseOverRect := Rect( 0, 0, 0, 0 );
    SetPressedArea( FOverArea );
    if FPressedArea in [ caMonth, caArrows, caYear ] then
      StartTimer
    else
      UpdateHighlight( X, Y );
  end;
end; {= TRzCalendar.MouseDown =}


procedure TRzCalendar.UpdateHighlight( X, Y: Integer );
var
  HighlightDate: TDateTime;
begin
  if FMonthList <> nil then
  begin
    TRzMonthList( FMonthList ).SelectMonth( FMonthList.ScreenToClient( ClientToScreen( Point( X, Y ) ) ) );
  end
  else if ( FPressedArea = caDays ) and ( FOverArea = caDays ) then
  begin
    HighlightDate := InternalHitTest( FMouseOverRect, Point( X, Y ) );
    if ( HighlightDate <> 0 ) and ( Trunc( FDate ) <> HighlightDate ) then
    begin
      FDate := HighlightDate + Frac( FDate );
      try
        Changed;
      finally
        Invalidate;
      end;
    end;
  end;
end;


function TRzCalendar.InternalHitTest( R: TRect; P: TPoint ): TDateTime;
var
  Row, Col: Integer;
  CellRect: TRect;
  Y, M, D, ViewMonth: Word;
  DrawDate: TDateTime;
begin
  Result := 0;
  if PtInRect( R, P ) then
  begin
    DecodeDate( FViewDate, Y, ViewMonth, D );
    CellRect := Bounds( R.Left, R.Top - 1, FCellSize.X, FCellSize.Y );
    DrawDate := FDrawDate;
    for Row := 0 to 5 do
    begin
      for Col := 0 to 6 do
      begin
        DecodeDate( DrawDate, Y, M, D );
        if ( ceFillDays in FElements ) or ( M = ViewMonth ) then
        begin
          if PtInRect( CellRect, P ) then
          begin
            Result := DrawDate;
            Exit;
          end;
        end;
        OffsetRect( CellRect, FCellSize.X, 0 );
        DrawDate := DrawDate + 1;
      end;
      OffsetRect( CellRect, R.Left - CellRect.Left, FCellSize.Y );
    end;
  end;
end; {= TRzCalendar.InternalHitTest =}


function TRzCalendar.HitTest( X, Y: Integer ): TDateTime;
var
  Areas: TRzCalendarAreas;
begin
  CalcAreas( Areas );
  Result := InternalHitTest( Areas[ caDays ], Point( X, Y ) );
end;


procedure TRzCalendar.MouseMove( Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  UpdateHighlight( X, Y );
end;


procedure TRzCalendar.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  if Button = mbLeft then
  begin
    if FMonthList <> nil then
    begin
      if TRzMonthList( FMonthList ).HighlightMonth <> 0 then
        SetViewDate( TRzMonthList( FMonthList ).HighlightMonth );
    end;
    SetPressedArea( caFillDays );
    StopTimer;
  end;
  inherited;
end;


procedure TRzCalendar.Changed;
begin
  if Assigned( FOnChange ) then
    FOnChange( Self );
end;


procedure TRzCalendar.Click;
begin
  {&RV}
  if ( FPressedArea = FOverArea ) and ( FPressedArea in [ caDays, caTodayButton, caClearButton ] ) then
  begin
    case FPressedArea of
      caClearButton:
        Clear;

      caTodayButton:
        Today;

      caDays:
        SetViewDate( FDate );  // Upate view to show selected date in the active month
    end;
    inherited;
  end;
end;


procedure TRzCalendar.DblClick;
begin
  SetPressedArea( FOverArea );
  if FPressedArea in [ caDays, caTodayButton, caClearButton ] then
    inherited;
end;


function TRzCalendar.DaysToBitmask( Days: array of Byte ): Cardinal;
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


procedure TRzCalendar.GetBoldDays( Year, Month: Word; var Bitmask: Cardinal );
begin
  if Assigned( FOnGetBoldDays ) then
    FOnGetBoldDays( Self, Year, Month, Bitmask );
end;


procedure TRzCalendar.DoEnter;
begin
  inherited;
  Invalidate;
end;


procedure TRzCalendar.DoExit;
begin
  inherited;
  Invalidate;
end;


procedure TRzCalendar.KeyDown( var Key: Word; Shift: TShiftState );
var
  D, M, Y: Word;
  BaseDate: TDateTime;
begin
  inherited;

  if Shift = [ ] then
  begin
    if IsClear then
      BaseDate := SysUtils.Date
    else
      BaseDate := FDate;

    case Key of
      vk_Up:
        SetDate( BaseDate - 7 );

      vk_Down:
        SetDate( BaseDate + 7 );

      vk_Left:
        SetDate( BaseDate - 1 );

      vk_Right:
        SetDate( BaseDate + 1 );

      vk_Home:
      begin
        DecodeDate( BaseDate, Y, M, D );
        SetDate( EncodeDate( Y, M, 1 ) );
      end;

      vk_End:
      begin
        DecodeDate( IncMonth( BaseDate, 1 ), Y, M, D );
        SetDate( EncodeDate( Y, M, 1 ) - 1 );
      end;
    end;

    if ceMonth in FElements then
    begin
      case Key of
        vk_Prior:
          SetDate( IncMonth( BaseDate, -1 ) );

        vk_Next:
          SetDate( IncMonth( BaseDate, 1 ) );
      end;
    end;

    if Key = vk_Return then
      inherited Click;
  end;
end; {= TRzCalendar.KeyDown =}


procedure TRzCalendar.SetCalendarColors( Value: TRzCalendarColors );
begin
  FCalendarColors.Assign( Value );
end;


procedure TRzCalendar.SetCaptionClearBtn( const Value: TCaption );
begin
  if FCaptionClearBtn <> Value then
  begin
    FCaptionClearBtn := Value;
    AdjustForFont;
  end;
end;


procedure TRzCalendar.SetCaptionTodayBtn( const Value: TCaption );
begin
  if FCaptionTodayBtn <> Value then
  begin
    FCaptionTodayBtn := Value;
    AdjustForFont;
  end;
end;


function TRzCalendar.IsClear: Boolean;
begin
  Result := Trunc( FDate ) = 0;
end;


procedure TRzCalendar.Clear;
begin
  FForceUpdate := True;
  try
    SetDate( 0 );
  finally
    FForceUpdate := False;
  end;
end;


procedure TRzCalendar.Today;
begin
  FForceUpdate := True;
  try
    SetDate( SysUtils.Date + Frac( FDate ) );
  finally
    FForceUpdate := False;
  end;
end;


procedure TRzCalendar.SetDate( Value: TDateTime );
begin
  if ( FDate <> Trunc( Value ) ) or FForceUpdate then
  begin
    FDate := Value;

    if FDate = 0 then
      SetViewDate( SysUtils.Date )
    else
      SetViewDate( FDate );

    try
      Changed;
    finally
      Invalidate;
    end;
  end;
end; {= TRzCalendar.SetDate =}


procedure TRzCalendar.SetFirstDayOfWeek( Value: TRzFirstDayOfWeek );
var
  A: array[ 0..1 ] of Char;
begin
  if HandleAllocated then
  begin
    if Value = fdowLocale then
    begin
      GetLocaleInfo( locale_User_Default, locale_IFirstDayOfWeek, A, SizeOf( A ) );
      FFirstDay := Ord( A[ 0 ] ) - Ord( '0' );
    end
    else
      FFirstDay := Ord( Value );
  end;
  FFirstDayOfWeek := Value;
  FForceUpdate := True;
  try
    SetDate( FDate );  // This will rebuild the calendar days
  finally
    FForceUpdate := False;
  end;
end;


procedure TRzCalendar.SetElements( Value: TRzCalendarElements );
begin
  if FElements <> Value then
  begin
    FElements := Value;
    AdjustForFont;
  end;
end;


procedure TRzCalendar.SetOverArea( Value: TRzCalendarArea );
var
  NeedToInvalidate: Boolean;
begin
  if FOverArea <> Value then
  begin
    NeedToInvalidate := FOverArea = FPressedArea;
    FOverArea := Value;
    NeedToInvalidate := NeedToInvalidate or ( FOverArea = FPressedArea );
    if NeedToInvalidate and not IsRectEmpty( FMouseOverRect ) then
      InvalidateRect( Handle, @FMouseOverRect, False );
  end;
end;


procedure TRzCalendar.SetPressedArea( Value: TRzCalendarArea );
begin
  if FPressedArea <> Value then
  begin
    FPressedArea := Value;
    if not IsRectEmpty( FMouseOverRect ) then
      InvalidateRect( Handle, @FMouseOverRect, False );
  end;
end;


procedure TRzCalendar.SetViewDate( Value: TDateTime );
var
  Y, M, D: Word;
  PrevDay: TDateTime;
begin
  if ( FViewDate <> Trunc( Value ) ) or FForceUpdate then
  begin
    FViewDate := Trunc( Value );
    DecodeDate( Value, Y, M, D );
    PrevDay := EncodeDate( Y, M, 1 ) - 1;
    DecodeDate( PrevDay, Y, M, D );
    D := D - ( ( DayOfWeek( PrevDay ) + 5 - FFirstDay ) mod 7 );
    FDrawDate := EncodeDate( Y, M, D );
    Invalidate;
  end;
end;


procedure TRzCalendar.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  AdjustForFont;
end;


procedure TRzCalendar.CMDialogChar( var Msg: TCMDialogChar );
begin
  if Enabled then
  begin
    if IsAccel( Msg.CharCode, FCaptionClearBtn ) then
    begin
      Clear;
      Msg.Result := 1;
    end
    else if IsAccel( Msg.CharCode, FCaptionTodayBtn ) then
    begin
      Today;
      Msg.Result := 1;
    end;
  end;
end;


procedure TRzCalendar.WMEraseBkgnd( var Msg: TMessage );
begin
  Msg.Result := 0;
end;


procedure TRzCalendar.WMNCHitTest( var Msg: TWMNCHitTest );
var
  P: TPoint;
  Area: TRzCalendarArea;
  Areas: TRzCalendarAreas;
begin
  inherited;
  CalcAreas( Areas );
  P := ScreenToClient( Point( Msg.XPos, Msg.YPos ) );
  for Area := High( Area ) downto Low( Area ) do
  begin
    if PtInRect( Areas[ Area ], P ) then
    begin
      SetOverArea( Area );
      Exit;
    end;
  end;
  SetOverArea( caFillDays );
end;


procedure TRzCalendar.WMTimer( var Msg: TMessage );
begin
  TimerExpired;
end;


procedure TRzCalendar.WMGetDlgCode( var Msg: TWMGetDlgCode );
begin
  Msg.Result := dlgc_WantArrows;
end;


{================================}
{== TRzClockFaceColors Methods ==}
{================================}

constructor TRzClockFaceColors.Create( ATimePicker: TRzTimePicker );
begin
  inherited Create;
  FTimePicker := ATimePicker;

  FFace := clBtnFace;
  FHands := clWindowText;
  FNumbers := clWindowText;
  FHourTicks := clBtnShadow;
  FMinuteTicks := clWindowText;
end;


destructor TRzClockFaceColors.Destroy;
begin
  FTimePicker := nil;
  inherited;
end;


procedure TRzClockFaceColors.Assign( Source: TPersistent );
begin
  if Source is TRzClockFaceColors then
  begin
    Face := TRzClockFaceColors( Source ).Face;
    Hands := TRzClockFaceColors( Source ).Hands;
    Numbers := TRzClockFaceColors( Source ).Numbers;
    HourTicks := TRzClockFaceColors( Source ).HourTicks;
    MinuteTicks := TRzClockFaceColors( Source ).MinuteTicks;
  end
  else
    inherited;
end;


function TRzClockFaceColors.GetColor( Index: Integer ): TColor;
begin
  case Index of
    0: Result := FFace;
    1: Result := FHands;
    2: Result := FNumbers;
    3: Result := FHourTicks;
    4: Result := FMinuteTicks;
    else
      Result := clNone;
  end;
end;


procedure TRzClockFaceColors.SetColor( Index: Integer; Value: TColor );
begin
  case Index of
    0: FFace := Value;
    1: FHands := Value;
    2: FNumbers := Value;
    3: FHourTicks := Value;
    4: FMinuteTicks := Value;
  end;

  if FTimePicker <> nil then
    FTimePicker.Invalidate;
end;



{===========================}
{== TRzTimePicker Methods ==}
{===========================}

constructor TRzTimePicker.Create( AOwner: TComponent );
begin
  inherited;
  ControlStyle := ( ControlStyle - [ csAcceptsControls, csNoStdEvents, csSetCaption ] ) + [ csReflector ];

  FIsPopup := False;
  FTime := SysUtils.Time;
  Clear;

  FForceUpdate := False;

  FClockFaceColors := TRzClockFaceColors.Create( Self );

  Color := clWindow;
  FlatColorAdjustment := 0;
  BorderOuter := fsLowered;
  TabStop := True;
  AutoSize := True;
  DoubleBuffered := True;
  AdjustForFont;
  {&RCI}

  FShowSetButton := False;

  Width := 160;
  Height := 190;

  FRestrictMinutes := False;
  FShowHowToUseHint := True;

  FTimer := TTimer.Create( Self );
  FTimer.OnTimer := CheckHintWindowHandler;
  FTimer.Interval := 1000;
  FTimer.Enabled := False;

  {$IFDEF VCL70_OR_HIGHER}
  ParentBackground := False;  // If this is True, then control flickers like crazy during mouse move
  {$ENDIF}
end;


destructor TRzTimePicker.Destroy;
begin
  FClockFaceColors.Free;
  inherited;
end;


procedure TRzTimePicker.Paint;
var
  S, FormatStr: string;
  ElementDetails: TThemedElementDetails;

  procedure DrawLine( ALeft, ARight, AHeight: Integer );
  var
    ElementDetails: TThemedElementDetails;
  begin
    if ThemeServices.ThemesEnabled then
    begin
      ElementDetails := ThemeServices.GetElementDetails( ttbSeparatorVertNormal );
      ThemeServices.DrawElement( Canvas.Handle, ElementDetails, Rect( ALeft, AHeight, ARight, AHeight + 3 ) );
    end
    else
    begin
      Canvas.Pen.Color := clBtnShadow;
      Canvas.MoveTo( ALeft, AHeight );
      Canvas.LineTo( ARight, AHeight );
    end;
  end;


  procedure DrawString( const S: string; var Bounds: TRect; Flags: Cardinal );
  begin
    DrawText( Canvas.Handle, PChar( S ), -1, Bounds, dt_VCenter or dt_SingleLine or Flags );
  end;


  procedure DrawButton( Bounds: TRect; const Caption: string; Down: Boolean );
  var
    EdgeType: Integer;
    ElementDetails: TThemedElementDetails;
  begin
    if ThemeServices.ThemesEnabled then
    begin
      if Down then
        ElementDetails := ThemeServices.GetElementDetails( tbPushButtonPressed )
      else
        ElementDetails := ThemeServices.GetElementDetails( tbPushButtonNormal );
      ThemeServices.DrawElement( Canvas.Handle, ElementDetails, Bounds );

      Canvas.Brush.Style := bsClear;
    end
    else
    begin
      Canvas.Brush.Color := clBtnFace;
      if Down then
        EdgeType := edge_Sunken
      else
      begin
        if ( BorderOuter = fsFlat ) or ( BorderOuter = fsFlatBold ) then
          EdgeType := edge_Etched
        else
          EdgeType := edge_Raised;
      end;
      DrawEdge( Canvas.Handle, Bounds, EdgeType, bf_Rect or bf_Middle or bf_Adjust );

      if Down then
      begin
        Inc( Bounds.Left, 2 );
        Inc( Bounds.Top, 2 );
      end;
    end;
    DrawString( Caption, Bounds, dt_Center );
    Canvas.Brush.Style := bsSolid;
  end;


  function CheckColor( Value: TColor ): TColor;
  begin
    // Need to check color against TransparentColor and WinMaskColor
    if ColorToRGB( Value ) = ColorToRGB( clGray ) then
    begin
      Result := ColorToRGB( Value ) + 1;
    end
    else
      Result := Value;
  end;


  procedure DrawRadioButton( Bounds: TRect; const Caption: string; Down: Boolean );
  const
    BaseColors: array[ 0..13 ] of TColor = ( clWhite,   // Interior (i.e. clWindow)
                                             clBlack,   // Main Border
                                             clGreen,   // Border Lighter
                                             clGray,    // Border Alpha 1 with DarkHotTrack
                                             clPurple,  // Border Alpha 1 with LightHotTrack
                                             clMaroon,  // Border Alpha 2 with DarkHotTrack
                                             clLime,    // Border Alpha 2 with LightHotTrack
                                             clRed,     // DarkHotTrack
                                             clFuchsia, // LightHotTrack
                                             clYellow,  // LightHotTrack Alpha with Interior
                                             clNavy,    // HighlightColor
                                             clBlue,    // HighlightColor Alpha with Interior
                                             clAqua,    // Border Alpha with background
                                             clOlive ); // Background

    ResNames: array[ Boolean ] of PChar = ( 'RZCOMMON_RADIOBUTTON_UNCHECKED',
                                            'RZCOMMON_RADIOBUTTON_CHECKED' );
  var
    Offset: Integer;
    R: TRect;
    Bmp: TBitmap;
    ReplaceColors: array[ 0..13 ] of TColor;
    ElementDetails: TThemedElementDetails;
  begin
    R := Rect( 0, 0, 13, 13 );

    Bmp := TBitmap.Create;
    try
      Bmp.Width := 13;
      Bmp.Height := 13;

      Bmp.Canvas.Brush.Color := Color;
      Bmp.Canvas.FillRect( R );

      // Test for XP themes first...
      if ThemeServices.ThemesEnabled then
      begin
        if Down then
          ElementDetails := ThemeServices.GetElementDetails( tbRadioButtonCheckedNormal )
        else
          ElementDetails := ThemeServices.GetElementDetails( tbRadioButtonUncheckedNormal );
        ThemeServices.DrawElement( Bmp.Canvas.Handle, ElementDetails, R );
      end
      else // No Themes, but draw as HotTrack style
      begin
        ReplaceColors[ 0 ] := clWindow;                                                // Interior (i.e. clWindow)
        ReplaceColors[ 1 ] := CheckColor( clBtnShadow );                               // Main Border
        ReplaceColors[ 2 ] := LighterColor( clBtnShadow, 10 );                         // Border Lighter
        ReplaceColors[ 3 ] := BlendColors( clBtnShadow, clWindow, 128 );               // Border Alpha 1 with DarkHotTrack
        ReplaceColors[ 4 ] := ReplaceColors[ 3 ];                                      // Border Alpha 1 with LightHotTrack
        ReplaceColors[ 5 ] := BlendColors( clBtnShadow, clWindow, 80 );                // Border Alpha 2 with DarkHotTrack
        ReplaceColors[ 6 ] := ReplaceColors[ 5 ];                                      // Border Alpha 2 with LightHotTrack
        ReplaceColors[ 7 ] := clWindow;                                                // DarkHotTrack
        ReplaceColors[ 8 ] := clWindow;                                                // LightHotTrack
        ReplaceColors[ 9 ] := clWindow;                                                // LightHotTrack Alpha with Interior
        ReplaceColors[ 10 ] := CheckColor( clHighlight );                              // HighlightColor
        ReplaceColors[ 11 ] := BlendColors( clHighlight, clWindow, 153 );              // HighlightColor Alpha with Interior
        ReplaceColors[ 12 ] := BlendColors( clBtnShadow, Color, 100 );                 // Border Alpha with background
        ReplaceColors[ 13 ] := Color;

        Bmp.Handle := CreateMappedRes( HInstance, ResNames[ Down ], BaseColors, ReplaceColors  );
      end;

      Offset := ( Bounds.Bottom - Bounds.Top - 13 ) div 2;
      R := Classes.Bounds( Bounds.Left, Bounds.Top + Offset, 13, 13 );
      Canvas.Draw( R.Left, R.Top, Bmp );
    finally
      Bmp.Free;
    end;

    Canvas.Brush.Color := Color;
    Inc( Bounds.Left, 14 );
    DrawString( Caption, Bounds, dt_Center );
  end; {= DrawRadioButton =}


begin {= TRzTimePicker.Paint =}
  if ThemeServices.ThemesEnabled then
  begin
    ElementDetails := ThemeServices.GetElementDetails( teEditRoot );
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, ClientRect );
  end
  else
    inherited;

  CalcRects;

  Canvas.Font := Self.Font;

  // Draw the Time
  if ThemeServices.ThemesEnabled then
  begin
    ElementDetails := ThemeServices.GetElementDetails( thHeaderRoot );
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, FTimeRect );
  end
  else
  begin
    if ( BorderOuter = fsFlat ) or ( BorderOuter = fsFlatBold ) then
      DrawEdge( Canvas.Handle, FTimeRect, bdr_RaisedInner, bf_Rect or bf_Middle or bf_Flat )
    else
      DrawEdge( Canvas.Handle, FTimeRect, bdr_RaisedInner, bf_Rect or bf_Middle );
  end;
  Canvas.Brush.Style := bsClear;
  if FFormat = '' then
    FormatStr := 'h:mm ampm'
  else
    FormatStr := FFormat;
  DrawString( FormatDateTime( FormatStr, FTime ), FTimeRect, dt_Center );
  Canvas.Brush.Style := bsSolid;

  // Draw the Clock
  DrawClock( FClockRect, FClockCenter, FRadius );
  Canvas.Font := Self.Font;                                // Reset font in case DrawClock changed it

  // Draw Separator Line
  DrawLine( 5, Width - 5, FAMRect.Top - 5 );

  // Draw AM Button
  if FCaptionAM <> '' then
    S := FCaptionAM
  else
    S := sRzCaptionAM;
  DrawRadioButton( FAMRect, S, not FTimeIsPM );

  // Draw PM Button
  if FCaptionPM <> '' then
    S := FCaptionPM
  else
    S := sRzCaptionPM;
  DrawRadioButton( FPMRect, S, FTimeIsPM );

  // Draw Set Radio Button
  if FShowSetButton then
  begin
    if FCaptionSet <> '' then
      S := FCaptionSet
    else
      S := sRzCaptionSet;
    DrawButton( FSetRect, S, FPressingLeft and FMouseOverSet );
  end;
end; {= TRzTimePicker.Paint =}



procedure TRzTimePicker.DrawClock( Bounds: TRect; CenterPoint: TPoint; Radius: Integer );
var
  I, X, Y, R, K, HX, HY, HL, Offset: Integer;
  Hour, Min, Sec, MSec: Word;
  OldTextAlign: Cardinal;
  S: string;
  P1, P2, P3, P4: TPoint;

  procedure GetHoursXY( Hours: Integer; Radius: Integer; var X, Y: Integer );
  var
    Angle: Extended;
  begin
    Angle := ( Hours * Pi / 6 ) - ( Pi / 2 );

    X := Round( Radius * Cos( Angle ) );
    Y := Round( Radius * Sin( Angle ) );
  end;


  procedure GetMinutesXY( Minutes: Integer; Radius: Integer; var X, Y: Integer );
  var
    Angle: Extended;
  begin
    Angle := ( Minutes * Pi / 30 ) - ( Pi / 2 );

    X := Round( Radius * Cos( Angle ) );
    Y := Round( Radius * Sin( Angle ) );
  end;


  procedure GetAngleXY( const Angle: Extended; Radius: Integer; var X, Y: Integer );
  begin
    X := Round( Radius * Cos( Angle ) );
    Y := Round( Radius * Sin( Angle ) );
  end;

begin {= TRzTimePicker.DrawClock =}
  if Focused then
    Canvas.Pen.Color := DarkerColor( FClockFaceColors.Face, 40 )
  else
    Canvas.Pen.Color := FClockFaceColors.Face;

  Canvas.Brush.Color := FClockFaceColors.Face;
  Canvas.Font.Style := [ fsBold ];
  Canvas.Font.Height := -Round( 0.20 * Radius );
  Canvas.Ellipse( Bounds.Left, Bounds.Top, Bounds.Right, Bounds.Bottom );

  R := Round( 0.75 * Radius );


  // Draw Numbers

  OldTextAlign := GetTextAlign( Canvas.Handle );
  SetTextAlign( Canvas.Handle, ta_Center );
  Offset := Canvas.TextHeight( '0' ) div 2;


  for I := 1 to 12 do
  begin
    S := IntToStr( I );
    GetHoursXY( I, R, X, Y );
    Canvas.Font.Color := FClockFaceColors.Numbers;
    Canvas.TextOut( CenterPoint.X + X, CenterPoint.Y + Y - Offset, S );
  end;

  // Draw Ticks
  Canvas.Brush.Color := FClockFaceColors.HourTicks;
  Canvas.Pen.Color := FClockFaceColors.HourTicks;
  R := Round( 0.92 * Radius );
  K := Round( 0.02 * Radius );
  for I := 1 to 60 do
  begin
    GetMinutesXY( I, R, X, Y );

    if I mod 5 = 0 then
      Canvas.Rectangle( CenterPoint.X + X - K, CenterPoint.Y + Y - K, CenterPoint.X + X + K + 1, CenterPoint.Y + Y + K + 1 )
    else
      Canvas.Pixels[ CenterPoint.X + X, CenterPoint.Y + Y ] := FClockFaceColors.MinuteTicks;
  end;


  DecodeTime( FTime, Hour, Min, Sec, MSec );
  if Hour > 12 then
    Dec( Hour, 12 );

  // Draw the Big Hand
  P1 := CenterPoint;

  R := Round( 0.80 * Radius );
  GetMinutesXY( Min, R, X, Y );
  P3 := Point( CenterPoint.X + X, CenterPoint.Y + Y );

  R := Round( 0.25 * Radius );
  GetMinutesXY( Min, R, HX, HY );

  HL := Round( 0.04 * Radius );
  GetAngleXY( Min * Pi / 30, HL, X, Y );
  P4 := Point( CenterPoint.X + HX + X, CenterPoint.Y + HY + Y );
  P2 := Point( CenterPoint.X + HX - X, CenterPoint.Y + HY - Y );

  Canvas.Brush.Color := FClockFaceColors.Hands;
  Canvas.Pen.Color := FClockFaceColors.Hands;
  Canvas.Polygon( [ P1, P2, P3, P4 ] );

  // Draw the Little Hand
  P1 := CenterPoint;

  R := Round( 0.50 * Radius );
  GetHoursXY( Hour, R, X, Y );
  P3 := Point( CenterPoint.X + X, CenterPoint.Y + Y );

  R := Round( 0.15 * Radius );
  GetHoursXY( Hour, R, HX, HY );

  HL := Round( 0.04 * Radius );
  GetAngleXY( Hour * Pi / 6, HL, X, Y );
  P4 := Point( CenterPoint.X + HX + X, CenterPoint.Y + HY + Y );
  P2 := Point( CenterPoint.X + HX - X, CenterPoint.Y + HY - Y );

  Canvas.Brush.Color := FClockFaceColors.Hands;
  Canvas.Pen.Color := FClockFaceColors.Hands;
  Canvas.Polygon( [ P1, P2, P3, P4 ] );


  SetTextAlign( Canvas.Handle, OldTextAlign );
end; {= TRzTimePicker.DrawClock =}


procedure TRzTimePicker.CalcRects;
var
  Margin, W, H, FontHeight: Integer;
  S: string;
  CR: TRect;
begin
  CR := ClientRect;
  AdjustClientRect( CR );

  Canvas.Font := Font;

  FontHeight := GetMinFontHeight( Font ) + 4;
  Margin := 5;
  FTimeRect := CR;
  FTimeRect.Bottom := FontHeight;

  if FCaptionAM <> '' then
    S := FCaptionAM
  else
    S := sRzCaptionAM;
  FAMRect := Bounds( Margin, Height - Margin - FontHeight, Canvas.TextWidth( S ) + 14, FontHeight );

  if FCaptionPM <> '' then
    S := FCaptionPM
  else
    S := sRzCaptionPM;
  FPMRect := Bounds( FAMRect.Right + Margin, Height - Margin - FontHeight, Canvas.TextWidth( S ) + 14, FontHeight );

  if FCaptionSet <> '' then
    S := FCaptionSet
  else
    S := sRzCaptionSet;
  FSetRect := Rect( FPMRect.Right + ( Width - Margin - FPMRect.Right ) div 3, Height - Margin - FontHeight, Width - Margin, FPMRect.Bottom );

  W := Width - 10;
  H := FAMRect.Top - 5 - FTimeRect.Bottom - 5;
  FClockCenter.X := 5 + ( W div 2 );
  FClockCenter.Y := FTimeRect.Bottom + 3 + ( H div 2 );

  FRadius := Min( W div 2, H div 2 );
  FClockRect := Rect( FClockCenter.X - FRadius, FClockCenter.Y - FRadius, FClockCenter.X + FRadius, FClockCenter.Y + FRadius );
end;


procedure TRzTimePicker.AdjustClientRect( var Rect: TRect );
begin
  inherited;
  FixClientRect( Rect, False );
end;


procedure TRzTimePicker.AdjustForFont;
begin
  CalcFontSize;
  AdjustSize;
  Invalidate;
end;


procedure TRzTimePicker.CalcFontSize;
var
  Canvas: TCanvas;
  DC: HDC;
begin
  Canvas := TCanvas.Create;
  DC := GetDC( 0 );
  try
    Canvas.Handle := DC;
    Canvas.Font.Assign( Font );
    FCharSize.X := Canvas.TextWidth( '0' );
    FCharSize.Y := Canvas.TextHeight( '0' );
  finally
    Canvas.Handle := 0;
    Canvas.Free;
    ReleaseDC( 0, DC );
  end;
end; {= TRzTimePicker.CalcFontSize =}


procedure TRzTimePicker.ConstrainedResize( var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer );
begin
  CanAutoSize( MinWidth, MinHeight );
  inherited;
end;


function TRzTimePicker.CanAutoSize( var NewWidth, NewHeight: Integer ): Boolean;
var
  W1, W2: Integer;
begin
  NewHeight := FCharSize.Y * 10 + ( FCharSize.Y + 2 ) * 4;

  W1 := ( FCharSize.X + 6 ) * 13;
  if FCaptionSet = '' then
    W2 := FCharSize.X * 12 + 2 * FCharSize.X * 6
  else
    W2 := FCharSize.X * 12 + 2 * FCharSize.X * ( Length( FCaptionSet ) + 2 );

  NewWidth := Max( W1, W2 );

  Result := True;
end;


function TRzTimePicker.NormalizedArcTan( const Y, X: Extended ): Extended;
begin
  Result := ArcTan( Y / X );
  if ( X > 0 ) and ( Y < 0 ) then
    Result := Result + 2 * Pi
  else if ( X < 0 ) then
    Result := Result + Pi;
end;


function TRzTimePicker.GetHourFromXY( X, Y: Integer ): Integer;
var
  I, DX, DY: Integer;
  Angle: Extended;
begin
  Result := 12;
  DX := X - FClockCenter.X;
  DY := Y - FClockCenter.Y;
  if DX <> 0 then
  begin
    Angle := NormalizedArcTan( DY, DX );

    Angle := Angle + ( Pi / 3 );
    if Angle > 2 * Pi then
      Angle := Angle - 2 * Pi;

    for I := 1 to 12 do
    begin
      if Angle < ( I * ( Pi / 6 ) - ( Pi / 12 ) ) then
      begin
        Result := I;
        Break;
      end;
    end;

  end
  else if DY > 0 then
    Result := 6
  else
    Result := 12;
end;


function TRzTimePicker.GetMinuteFromXY( X, Y: Integer; Restrict: Boolean ): Integer;
var
  I, DX, DY: Integer;
  Angle: Extended;
begin
  Result := 0;
  DX := X - FClockCenter.X;
  DY := Y - FClockCenter.Y;
  if DX <> 0 then
  begin
    Angle := NormalizedArcTan( DY, DX );

    Angle := Angle + ( Pi / 2 );
    if Angle > 2 * Pi then
      Angle := Angle - 2 * Pi;

    for I := 1 to 60 do
    begin
      if Angle < ( I * ( Pi / 30 ) - ( Pi / 60 ) ) then
      begin
        Result := I - 1;
        Break;
      end;
    end;

    if FRestrictMinutes or Restrict then
    begin
      Result := Round( Result / 60 * 12 ) * 5;
      if Result = 60 then
        Result := 0;
    end;
  end
  else if DY > 0 then
    Result := 30
  else
    Result := 0;
end;


procedure TRzTimePicker.MouseDown( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;
  {&RV}

  if not ( csDesigning in ComponentState ) and not FIsPopup then
    SetFocus;

  if Button = mbLeft then
  begin
    FPressingLeft := True;
    if PtInRect( FAMRect, Point( X, Y ) ) then
    begin
      FMouseOverAM := True;
    end
    else if PtInRect( FPMRect, Point( X, Y ) ) then
    begin
      FMouseOverPM := True;

    end
    else if PtInRect( FSetRect, Point( X, Y ) ) then
    begin
      FMouseOverSet := True;

    end
    else if PtInRect( FClockRect, Point( X, Y ) ) then
    begin
      // Select Hours
      FMouseOverClock := True;
      SetHour( GetHourFromXY( X, Y ) );
    end;
    Invalidate;
  end
  else if Button = mbRight then
  begin
    FPressingRight := True;
    if PtInRect( FClockRect, Point( X, Y ) ) then
    begin
      FMouseOverClock := True;
      SetMinutes( GetMinuteFromXY( X, Y, ssCtrl in Shift ) );
    end;

  end;
end; {= TRzTimePicker.MouseDown =}


procedure TRzTimePicker.MouseMove( Shift: TShiftState; X, Y: Integer );
begin
  if ShowHowToUseHint then
    DoHint( X, Y );

  inherited;

  if FPressingLeft then
  begin
    if FMouseOverClock and PtInRect( FClockRect, Point( X, Y ) ) then
      SetHour( GetHourFromXY( X, Y ) );
  end
  else if FPressingRight then
  begin
    if FMouseOverClock and PtInRect( FClockRect, Point( X, Y ) ) then
      SetMinutes( GetMinuteFromXY( X, Y, ssCtrl in Shift ) );
  end;

end;


procedure TRzTimePicker.MouseUp( Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
begin
  inherited;

  if ( Button = mbLeft ) and FPressingLeft then
  begin
    if FMouseOverAM and PtInRect( FAMRect, Point( X, Y ) ) then
    begin
      ChangeToAM;
    end
    else if FMouseOverPM and PtInRect( FPMRect, Point( X, Y ) ) then
    begin
      ChangeToPM;
    end
    else if FMouseOverSet and PtInRect( FSetRect, Point( X, Y ) ) then
    begin
      // Probably generate an event here so that popup can close
      SetBtnClick;
    end
    else if FMouseOverClock and PtInRect( FClockRect, Point( X, Y ) ) then
    begin
      SetHour( GetHourFromXY( X, Y ) );
      if Assigned( FOnSetTime ) then
        FOnSetTime( Self );
    end;
  end
  else if ( Button = mbRight ) and FPressingRight then
  begin
    if FMouseOverClock and PtInRect( FClockRect, Point( X, Y ) ) then
    begin
      SetMinutes( GetMinuteFromXY( X, Y, ssCtrl in Shift ) );
      if Assigned( FOnSetTime ) then
        FOnSetTime( Self );
    end;
  end;

  FPressingLeft := False;
  FMouseOverAM := False;
  FMouseOverPM := False;
  FMouseOverSet := False;
  FMouseOverClock := False;

  Invalidate;
end; {= TRzTimePicker.MouseUp =}


procedure TRzTimePicker.MouseEnter;
var
  P: TPoint;
begin
  inherited;

  GetCursorPos( P );
  P := ScreenToClient( P );
  if FShowHowToUseHint then
    DoHint( P.X, P.Y );
end;


procedure TRzTimePicker.MouseLeave;
begin
  inherited;
  ReleaseHintWindow;
end;


procedure TRzTimePicker.AdjustHour( DeltaHours: Int64 );
var
  T: TTime;
begin
  T := Date + FTime;
  T := IncHour( T, DeltaHours );
  SetTime( T );
end;


procedure TRzTimePicker.AdjustMinute( DeltaMinutes: Int64 );
var
  T: TTime;
begin
  T := Date + FTime;
  T := IncMinute( T, DeltaMinutes );
  SetTime( T );
end;


procedure TRzTimePicker.KeyDown( var Key: Word; Shift: TShiftState );
begin
  inherited;

  case Key of
    vk_Prior:
      AdjustHour( 1 );
    vk_Next:
      AdjustHour( -1 );
    vk_Up:
      AdjustMinute( 1 );
    vk_Down:
      AdjustMinute( -1 );

    vk_Return:
    begin
      if FShowSetButton then
        SetBtnClick;
    end;
  end;
end;


procedure TRzTimePicker.DoEnter;
begin
  inherited;
  Invalidate;
end;


procedure TRzTimePicker.DoExit;
begin
  inherited;
  Invalidate;
end;


procedure TRzTimePicker.SetBtnClick;
begin
  if Assigned( FOnSetBtnClick ) then
    FOnSetBtnClick( Self );
end;


function TRzTimePicker.CalcHintRect( MaxWidth: Integer; const HintStr: string; HintWnd: THintWindow ): TRect;
begin
  Result := HintWnd.CalcHintRect( Screen.Width, HintStr, nil );
end;


procedure TRzTimePicker.DoHint( X, Y: Integer );
var
  R, WinRect: TRect;
  P: TPoint;
  HintStr: string;
begin
  if not ( csDesigning in ComponentState ) and PtInRect( FClockRect, Point( X, Y ) ) and ForegroundTask then
  begin
    Canvas.Font := Font;
    if not Assigned( FHintWnd ) then
    begin
      FHintWnd := THintWindow.Create( Self );
      FHintWnd.Color := Application.HintColor;
    end;

    if FHowToUseMsg = '' then
      HintStr := sRzHowToSelectTime
    else
      HintStr := FHowToUseMsg;
    R := CalcHintRect( Screen.Width, HintStr, FHintWnd );

    P := ClientToScreen( Point( 0, Height ) );
    OffsetRect( R, P.X, P.Y );

    GetWindowRect( FHintWnd.Handle, WinRect );

    if not IsWindowVisible( FHintWnd.Handle ) or not ( ( R.Left = WinRect.Left ) and ( R.Top = WinRect.Top ) ) then
    begin
      FHintWnd.ActivateHint( R, HintStr );
      FTimer.Enabled := True;
    end;
  end
  else
  begin
    FTimer.Enabled := False;
    ReleaseHintWindow;
    Repaint;
  end;
end;


procedure TRzTimePicker.CheckHintWindowHandler( Sender: TObject );
var
  P: TPoint;
begin
  GetCursorPos( P );
  P := ScreenToClient( P );
  if not PtInRect( FClockRect, P ) then
  begin
    FTimer.Enabled := False;
    ReleaseHintWindow;
    Repaint;
  end;
end;


procedure TRzTimePicker.ReleaseHintWindow;
begin
  if Assigned( FHintWnd ) then
    FHintWnd.ReleaseHandle;
end;


procedure TRzTimePicker.Changed;
begin
  if Assigned( FOnChange ) then
    FOnChange( Self );
end;


procedure TRzTimePicker.ChangeToAM;
var
  Hour, Min, Sec, MSec: Word;
begin
  if FTimeIsPM then
  begin
    FTimeIsPM := False;
    DecodeTime( FTime, Hour, Min, Sec, MSec );
    SetHour( Hour - 12 );
  end;
end;


procedure TRzTimePicker.ChangeToPM;
var
  Hour, Min, Sec, MSec: Word;
begin
  if not FTimeIsPM then
  begin
    FTimeIsPM := True;
    DecodeTime( FTime, Hour, Min, Sec, MSec );
    SetHour( Hour + 12 );
  end;
end;


procedure TRzTimePicker.SetCaptionAM( const Value: TCaption );
begin
  if FCaptionAM <> Value then
  begin
    FCaptionAM := Value;
    AdjustForFont;
  end;
end;


procedure TRzTimePicker.SetCaptionPM( const Value: TCaption );
begin
  if FCaptionPM <> Value then
  begin
    FCaptionPM := Value;
    AdjustForFont;
  end;
end;


procedure TRzTimePicker.SetCaptionSet( const Value: TCaption );
begin
  if FCaptionSet <> Value then
  begin
    FCaptionSet := Value;
    AdjustForFont;
  end;
end;


procedure TRzTimePicker.SetClockFaceColors( Value: TRzClockFaceColors );
begin
  FClockFaceColors.Assign( Value );
end;


function TRzTimePicker.IsClear: Boolean;
begin
  Result := Trunc( FTime ) = 0;
end;


procedure TRzTimePicker.Clear;
begin
  SetTime( 0 );
end;


procedure TRzTimePicker.SetFormat( const Value: string );
begin
  if FFormat <> Value then
  begin
    FFormat := Value;
    Invalidate;
  end;
end;


procedure TRzTimePicker.SetHour( Value: Integer );
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime( FTime, Hour, Min, Sec, MSec );
  if FTimeIsPM and ( Value < 12 ) then
    Value := Value + 12
  else if not FTimeIsPM and ( Value = 12 ) then
    Value := 0;
  SetTime( EncodeTime( Value, Min, 0, 0 ) );
end;


procedure TRzTimePicker.SetMinutes( Value: Integer );
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime( FTime, Hour, Min, Sec, MSec );
  SetTime( EncodeTime( Hour, Value, 0, 0 ) );
end;


procedure TRzTimePicker.SetTime( Value: TTime );
var
  Hour, Min, Sec, MSec: Word;
begin
  if ( FTime <> Frac( Value ) ) or FForceUpdate then
  begin
    DecodeTime( Value, Hour, Min, Sec, MSec );
    FTime := EncodeTime( Hour, Min, 0, 0 );

    FTimeIsPM := Hour >= 12;

    try
      Changed;
    finally
      Invalidate;
    end;
  end;
end; {= TRzTimePicker.SetTime =}


procedure TRzTimePicker.SetShowSetButton( Value: Boolean );
begin
  if FShowSetButton <> Value then
  begin
    FShowSetButton := Value;
    Invalidate;
  end;
end;


procedure TRzTimePicker.CMFontChanged( var Msg: TMessage );
begin
  inherited;
  AdjustForFont;
end;


procedure TRzTimePicker.CMDialogChar( var Msg: TCMDialogChar );
begin
  if Enabled then
  begin
    if IsAccel( Msg.CharCode, FCaptionAM ) then
    begin
      ChangeToAM;
      Msg.Result := 1;
    end
    else if IsAccel( Msg.CharCode, FCaptionPM ) then
    begin
      ChangeToPM;
      Msg.Result := 1;
    end
    else if IsAccel( Msg.CharCode, FCaptionSet ) then
    begin
      SetBtnClick;
      Msg.Result := 1;
    end;
  end;
end;


procedure TRzTimePicker.WMGetDlgCode( var Msg: TWMGetDlgCode );
begin
  Msg.Result := dlgc_WantArrows;
end;


{============================}
{== TRzCustomPopup Methods ==}
{============================}

constructor TRzCustomPopup.Create( AOwner: TComponent );
begin
  inherited;

  BorderWidth := 2;
  BorderOuter := fsPopup;
  FlatColorAdjustment := 0;
  Visible := False;
end;


procedure TRzCustomPopup.AdjustClientRect( var Rect: TRect );
begin
  inherited;
  FixClientRect( Rect, False );
end;


procedure TRzCustomPopup.AlignControls( AControl: TControl; var Rect: TRect );
begin
  AdjustClientRect( Rect );
  inherited;
end;


procedure TRzCustomPopup.Paint;
var
  ElementDetails: TThemedElementDetails;
begin
  if ThemeServices.ThemesEnabled then
  begin
    ElementDetails := ThemeServices.GetElementDetails( tsThumbBtnHorzPressed );
    ThemeServices.DrawElement( Canvas.Handle, ElementDetails, ClientRect );
  end
  else
    inherited;
end;


{======================}
{== TRzPopup Methods ==}
{======================}

const
  cm_KillPopup = wm_User + $2023;

type
  TRzPopup = class( TRzCustomPopup )
  private
    FPopupPanel: TRzPopupPanel;
    FTarget: TWinControl;
    FCancel: Boolean;

    function ContainsWindow( Wnd: HWnd ): Boolean;
    procedure ReparentControls( OldParent, NewParent: TWinControl );
  protected
    procedure DoClose( Sender: TObject );
    procedure Cancel;

    procedure CreateParams( var Params: TCreateParams ); override;
    procedure WndProc( var Msg: TMessage ); override;

    {$IFNDEF VCL60_OR_HIGHER}
    function GetMonitorFromPoint( const Point: TPoint ): TMonitor;
    function GetMonitorWorkareaRect( M: TMonitor ): TRect;
    {$ENDIF}
  public
    constructor Create( AOwner: TComponent ); override;

    function Popup( PopupControl: TControl; Alignment: TAlignment ): Boolean;
  end;


constructor TRzPopup.Create( AOwner: TComponent );
begin
  inherited;
  Visible := False;

  FPopupPanel := TRzPopupPanel( AOwner );

  Parent := GetParentForm( FPopupPanel );
  Color := FPopupPanel.Color;
  Font := FPopupPanel.Font;
  Width := FPopupPanel.BorderWidth;
  Ctl3D := False;
  Hint := FPopupPanel.Hint;
  ShowHint := FPopupPanel.ShowHint;
end;


procedure TRzPopup.CreateParams( var Params: TCreateParams );
begin
  inherited;
  Params.Style := ws_Popup;
end;


type
  TApplicationAccess = class( TApplication );


function TRzPopup.Popup( PopupControl: TControl; Alignment: TAlignment ): Boolean;
var
  PopupControlBounds: TRect;
  X, Y, W, H: Integer;
  Msg: TMsg;
  M: TMonitor;
  {$IFNDEF VCL60_OR_HIGHER}
  WR: TRect;
  {$ENDIF}

  procedure SetTarget;
  var
    I: Integer;
    C: TControl;
  begin
    ReparentControls( FPopupPanel, Self );
    FTarget := nil;
    for I := 0 to ControlCount - 1 do
    begin
      C := Controls[ I ];
      if ( C is TWinControl ) and C.Enabled and C.Visible then
      begin
        FTarget := TWinControl( C );
        Break;
      end;
    end;
    Windows.SetFocus( FPopupPanel.Handle );
  end;


  procedure Hide;
  begin
    SetWindowPos( Handle, 0, 0, 0, 0, 0, swp_HideWindow or swp_NoZOrder or swp_NoMove or swp_NoSize or swp_NoActivate );
    ReparentControls( Self, FPopupPanel );
    Parent := nil;
  end;


  procedure MessageLoop;
  begin
    try
      repeat
        if PeekMessage( Msg, 0, 0, 0, pm_NoRemove ) then
        begin
          case Msg.message of
            wm_NCLButtonDown, wm_NCRButtonDown, wm_NCMButtonDown,
            wm_LButtonDown, wm_LButtonDblClk,
            wm_RButtonDown, wm_RButtonDblClk,
            wm_MButtonDown, wm_MButtonDblClk:
            begin
              if not ContainsWindow( Msg.hwnd ) then
              begin
                PeekMessage( Msg, 0, 0, 0, pm_Remove );
                Break;
              end;
            end;

            wm_KeyFirst..wm_KeyLast:
            begin
              PeekMessage( Msg, 0, 0, 0, pm_Remove );
              SendMessage( Handle, Msg.Message, Msg.WParam, Msg.LParam );
              Continue;
            end;

            wm_KillFocus, cm_KillPopup:
              Exit;

            cm_Deactivate, wm_ActivateApp:
              Break;
          end;
          Application.HandleMessage;
        {$IFDEF VCL60_OR_HIGHER}
        end
        else
          TApplicationAccess( Application ).Idle( Msg );
        {$ELSE}
        end;
        {$ENDIF}

      until Application.Terminated;
    finally
      Hide;
    end;
    Cancel;
  end; {= MessageLoop =}


begin {= TRzPopup.Popup =}
  FPopupControl := PopupControl;

  if FPopupControl is TWinControl then
  begin
    GetWindowRect( TWinControl( FPopupControl ).Handle, PopupControlBounds );
  end
  else with FPopupControl.Parent do
  begin
    PopupControlBounds := FPopupControl.BoundsRect;
    PopupControlBounds.TopLeft := ClientToScreen( PopupControlBounds.TopLeft );
    PopupControlBounds.BottomRight := ClientToScreen( PopupControlBounds.BottomRight );
  end;

  SetTarget;

  W := FPopupPanel.BoundsRect.Right - FPopupPanel.BoundsRect.Left;
  H := FPopupPanel.BoundsRect.Bottom - FPopupPanel.BoundsRect.Top;
  Y := PopupControlBounds.Bottom;

  case Alignment of
   taLeftJustify:
     X := PopupControlBounds.Left;

   taRightJustify:
     X := PopupControlBounds.Right - W;

   else
     X := ( PopupControlBounds.Left + PopupControlBounds.Right - W ) div 2;
  end;

  {$IFDEF VCL60_OR_HIGHER}

  M := Screen.MonitorFromPoint( Point( X, Y ) );

  if ( X + W ) > M.WorkareaRect.Right then
    X := M.WorkareaRect.Right - W;
  if ( Y + H ) > M.WorkareaRect.Bottom then
    Y := PopupControlBounds.Top - H;

  if X < M.WorkareaRect.Left then
    X := M.WorkareaRect.Left;
  if Y < M.WorkareaRect.Top then
    Y := M.WorkareaRect.Top;

  {$ELSE}

  M := GetMonitorFromPoint( Point( X, Y ) );
  WR := GetMonitorWorkareaRect( M );

  if ( X + W ) > WR.Right then
    X := WR.Right - W;
  if ( Y + H ) > WR.Bottom then
    Y := PopupControlBounds.Top - H;

  if X < WR.Left then
    X := WR.Left;
  if Y < WR.Top then
    Y := WR.Top;

  {$ENDIF}

  SetBounds( X, Y, W, H );
  SetWindowPos( Handle, hwnd_Top, X, Y, W, H, swp_NoActivate or swp_ShowWindow );

  Visible := True;
  FCancel := True;
  MessageLoop;
  Result := not FCancel;
end; {= TRzPopup.Popup =}


{$IFDEF VER13x}

function TRzPopup.GetMonitorFromPoint( const Point: TPoint ): TMonitor;

  function FindMonitor( Handle: HMONITOR ): TMonitor;
  var
    I: Integer;
  begin
    Result := nil;
    for I := 0 to Screen.MonitorCount - 1 do
    begin
      if Screen.Monitors[ I ].Handle = Handle then
      begin
        Result := Screen.Monitors[ I ];
        Break;
      end;
    end;
  end;

begin
  Result := FindMonitor( MultiMon.MonitorFromPoint( Point, MONITOR_DEFAULTTONEAREST ) );
end;


function TRzPopup.GetMonitorWorkareaRect( M: TMonitor ): TRect;
var
  MonInfo: TMonitorInfo;
begin
  MonInfo.cbSize := SizeOf( MonInfo );
  GetMonitorInfo( M.Handle, @MonInfo );
  Result := MonInfo.rcWork;
end;

{$ENDIF}

procedure TRzPopup.DoClose( Sender: TObject );
begin
  FCancel := False;
  Cancel;
end;


procedure TRzPopup.Cancel;
begin
  PostMessage( Handle, cm_KillPopup, 0, 0 );
end;


procedure TRzPopup.ReparentControls( OldParent, NewParent: TWinControl );
var
  I: Integer;
begin
  for I := OldParent.ControlCount - 1 downto 0 do
    OldParent.Controls[ I ].Parent := NewParent;
end;


function TRzPopup.ContainsWindow( Wnd: HWnd ): Boolean;
begin
  while ( Wnd <> 0 ) and ( Wnd <> Handle ) do
    Wnd := GetParent( Wnd );

  Result := Wnd = Handle;
end;


procedure TRzPopup.WndProc( var Msg: TMessage );
begin
  case Msg.Msg of
    wm_NCActivate:
      Msg.Result := 0;

    wm_MouseActivate:
      Msg.Result := ma_NoActivate;

    wm_SysCommand:
      Cancel;

    wm_KeyFirst..wm_KeyLast:
    begin
      if Msg.WParam = vk_Escape then
        Cancel;

      if FTarget <> nil then
        TRzPopup( FTarget ).WndProc( Msg )
      else
        inherited;
    end;

    cm_KillPopup:
      Free;

    else
      inherited;
  end;
end; {= TRzPopup.WndProc =}


{===========================}
{== TRzPopupPanel Methods ==}
{===========================}

constructor TRzPopupPanel.Create( AOwner: TComponent );
begin
  inherited;
  Alignment := taRightJustify;
  Width := 100;
  Height := 100;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
  Color := clBtnFace;
  ParentColor := False;
  AutoSize := True;
end;


procedure TRzPopupPanel.DestroyWnd;
begin
  Close( Self );
  inherited;
end;


procedure TRzPopupPanel.Close;
begin
  if FPopup <> nil then
    TRzPopup( FPopup ).DoClose( Self );
end;


function TRzPopupPanel.Popup( PopupControl: TControl ): Boolean;
var
  F: TCustomForm;
  SaveFocus: HWnd;
begin
  Result := False;
  if not Active then
  begin
    FPopupControl := PopupControl;
    F := GetParentForm( Self );
    SaveFocus := GetFocus;
    if F <> nil then
      F.DisableAutoRange;

    try
      DoPopup;
      Handle;
      RecreateWnd;
      Handle;

      FPopup := TRzPopup.Create( Self );
      Result := TRzPopup( FPopup ).Popup( FPopupControl, Alignment );

      DoClose;
    finally
      if F <> nil then
        F.EnableAutoRange;
      if Application.Active then
        Windows.SetFocus( SaveFocus );
      FPopupControl := nil;
      FPopup := nil;
    end;
  end;
end;


procedure TRzPopupPanel.DoClose;
begin
  if Assigned( FOnClose ) then
    FOnClose( Self );
end;


procedure TRzPopupPanel.DoPopup;
begin
  if Assigned( FOnPopup ) then
    FOnPopup( Self );
end;


function TRzPopupPanel.GetActive: Boolean;
begin
  Result := FPopup <> nil;
end;


{&RUIF}
end.

