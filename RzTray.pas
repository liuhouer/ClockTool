{===============================================================================
  RzTray Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzTrayIcon           Nonvisual component that allows application to have an
                          icon in the system tray.


  Modification History
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Fixed problem where setting Enabled to True, when the control was already
      Enabled caused an exception.
    * Animation of icons now only occurs at runtime.
    * Fixed problem where application would hang if RestoreOn was set to
      ticLeftClick and the icon was left-clicked while a popup menu was
      currently being displayed.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Fixed problem where setting Enabled to False still resulted in the tray
      icon data structure to be created when the component was created, and then
      turned off during loading.  Now, the tray icon data structure is not
      created until the first time the Enabled property is set to True.
    * Added the HideOnMinimize option that controls whether the button in the
      Task Bar remains visible when the main form is minimized.
    * If Windows Explorer is restarted, enabled TRzTrayIcon tray icons will be
      recreated.
    * Added new methods ShowBalloonHint and HideBalloonHint, which allows a user
      to display the BalloonHints that are available with version 5 or higher of
      the Shell32.dll.  The TRzTrayIcon also adds the following events:
      OnBalloonHintHide, OnBalloonHintClosed, and OnBalloonHintClicked;


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

// Typed Address checking must be turned off for this unit because two different record structures are passed to
// the Shell_NotifyIcon function:  FIconData and FIconDataPreV5.  This is to support the new features added in
// version 5 of Shell32.dll
{$TYPEDADDRESS OFF}


unit RzTray;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Messages,
  Windows,
  Controls,
  Forms,
  Menus,
  StdCtrls,
  ExtCtrls,
  Classes,
  ShellAPI,
  Graphics,
  SysUtils,
  RzCommon;

const
  wm_TrayIconMessage = wm_User + $2022;


type
  TRzBalloonHintIcon = ( bhiNone, bhiInfo, bhiWarning, bhiError);
  TRzBalloonHintTimeout = 10..30;                          // MSDN states that min = 10 seconds, max = 30 seconds

  TRzTimeoutOrVersion = record
    case Integer of              // 0: Before Win2000; 1: Win2000 and up
      0: ( uTimeout: UINT );
      1: ( uVersion: UINT );     // Only used when sending a NIM_SETVERSION message
  end;

  PRzNotifyIconDataA = ^TRzNotifyIconDataA;
  PRzNotifyIconDataW = ^TRzNotifyIconDataW;
  PNotifyIconData = PRzNotifyIconDataA;
  _RZNOTIFYICONDATAA = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[ 0..127 ] of AnsiChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[ 0..255 ] of AnsiChar;
    TimeoutOrVersion: TRzTimeoutOrVersion;
    szInfoTitle: array[ 0..63 ] of AnsiChar;
    dwInfoFlags: DWORD;
  end;
  _RZNOTIFYICONDATAW = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[ 0..63 ] of WideChar;
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[ 0..255 ] of WideChar;
    TimeoutOrVersion: TRzTimeoutOrVersion;
    szInfoTitle: array[ 0..63 ] of WideChar;
    dwInfoFlags: DWORD;
  end;
  _RZNOTIFYICONDATA = _RZNOTIFYICONDATAA;
  TRzNotifyIconDataA = _RZNOTIFYICONDATAA;
  TRzNotifyIconDataW = _RZNOTIFYICONDATAW;
  TRzNotifyIconData = TRzNotifyIconDataA;
  RZNOTIFYICONDATAA = _RZNOTIFYICONDATAA;
  RZNOTIFYICONDATAW = _RZNOTIFYICONDATAW;
  RZNOTIFYICONDATA = RZNOTIFYICONDATAA;

  ERzTrayIconError = class( Exception );

  TRzTrayIconClicks = ( ticNone,
                        ticLeftClick, ticLeftDblClick, ticLeftClickUp,
                        ticRightClick, ticRightDblClick, ticRightClickUp );

  TRzTrayIcon = class( TComponent )
  private
    FAboutInfo: TRzAboutInfo;
    FIconData: TRzNotifyIconData;
    FIconDataPreV5: TNotifyIconData;
    FIcon: TIcon;
    FIconList: TImageList;
    FPopupMenu: TPopupMenu;
    FTimer: TTimer;
    FHint: string;
    FIconIndex: Integer;
    FEnabled: Boolean;
    FMsgWindow: HWnd;
    FHideOnMinimize: Boolean;
    FTaskBarRecreated: Boolean;
    FMenuVisible: Boolean;

    FRestoreOn: TRzTrayIconClicks;
    FPopupMenuOn: TRzTrayIconClicks;

    FOnMinimizeApp: TNotifyEvent;
    FOnRestoreApp: TNotifyEvent;

    FOnLButtonDown: TNotifyEvent;
    FOnLButtonUp: TNotifyEvent;
    FOnLButtonDblClick: TNotifyEvent;
    FOnRButtonDown: TNotifyEvent;
    FOnRButtonUp: TNotifyEvent;
    FOnRButtonDblClick: TNotifyEvent;

    FShell32Ver5: Boolean;
    FOnBalloonHintHide: TNotifyEvent;
    FOnBalloonHintClose: TNotifyEvent; // Generated when the user clicks the Close button or the timeout value is reached
    FOnBalloonHintClick: TNotifyEvent;

    { Internal Event Handlers }
    procedure MinimizeAppHandler( Sender: TObject );
    procedure RestoreAppHandler( Sender: TObject );
    procedure TimerExpiredHandler( Sender: TObject );
  protected
    procedure Loaded; override;
    procedure Notification( Component: TComponent;
                            Operation: TOperation ); override;
    procedure MsgWndProc( var Msg: TMessage );
    procedure Update;
    procedure EnabledChanged;

    { Event Dispatch Methods }
    procedure EndSession; dynamic;
    procedure LButtonDown; dynamic;
    procedure LButtonUp; dynamic;
    procedure LButtonDblClick; dynamic;
    procedure RButtonDown; dynamic;
    procedure RButtonUp; dynamic;
    procedure RButtonDblClick; dynamic;
    procedure DoMinimizeApp; dynamic;
    procedure DoRestoreApp; dynamic;

    { Property Access Methods }
    function GetAnimate: Boolean; virtual;
    procedure SetAnimate( Value: Boolean ); virtual;
    procedure SetEnabled( Value: Boolean ); virtual;
    procedure SetHint( const Value: string ); virtual;
    function GetInterval: Integer; virtual;
    procedure SetInterval( Value: Integer ); virtual;
    procedure SetIconIndex( Value: Integer ); virtual;

    { Property Declarations }
    property IconData: TRzNotifyIconData
      read FIconData;
      
    property IconDataPreV5: TNotifyIconData
      read FIconDataPreV5;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure MinimizeApp;
    procedure RestoreApp;

    procedure ShowMenu;
    procedure SetDefaultIcon;

    procedure ShowBalloonHint( const Title: string; const Msg: string; IconType: TRzBalloonHintIcon = bhiInfo;
                               TimeoutSecs: TRzBalloonHintTimeOut = 10 );
    procedure HideBalloonHint;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Animate: Boolean
      read GetAnimate
      write SetAnimate
      default False;

    property Enabled: Boolean
      read FEnabled
      write SetEnabled
      default True;

    property HideOnMinimize: Boolean
      read FHideOnMinimize
      write FHideOnMinimize
      default True;

    property Hint: string
      read FHint
      write SetHint;

    property PopupMenu: TPopupMenu
      read FPopupMenu
      write FPopupMenu;

    property Icons: TImageList
      read FIconList
      write FIconList;

    property IconIndex: Integer
      read FIconIndex
      write SetIconIndex
      default 0;

    property Interval: Integer
      read GetInterval
      write SetInterval
      default 1000;

    property RestoreOn: TRzTrayIconClicks
      read FRestoreOn
      write FRestoreOn
      default ticLeftDblClick;

    property PopupMenuOn: TRzTrayIconClicks
      read FPopupMenuOn
      write FPopupMenuOn
      default ticRightClickUp;

    property OnBalloonHintHide: TNotifyEvent
      read FOnBalloonHintHide
      write FOnBalloonHintHide;

    property OnBalloonHintClose: TNotifyEvent
      read FOnBalloonHintClose
      write FOnBalloonHintClose;

    property OnBalloonHintClick: TNotifyEvent
      read FOnBalloonHintClick
      write FOnBalloonHintClick;

    property OnMinimizeApp: TNotifyEvent
      read FOnMinimizeApp
      write FOnMinimizeApp;

    property OnRestoreApp: TNotifyEvent
      read FOnRestoreApp
      write FOnRestoreApp;

    property OnLButtonDown: TNotifyEvent
      read FOnLButtonDown
      write FOnLButtonDown;

    property OnLButtonUp: TNotifyEvent
      read FOnLButtonUp
      write FOnLButtonUp;

    property OnLButtonDblClick: TNotifyEvent
      read FOnLButtonDblClick
      write FOnLButtonDblClick;

    property OnRButtonDown: TNotifyEvent
      read FOnRButtonDown
      write FOnRButtonDown;

    property OnRButtonUp: TNotifyEvent
      read FOnRButtonUp
      write FOnRButtonUp;

    property OnRButtonDblClick: TNotifyEvent
      read FOnRButtonDblClick
      write FOnRButtonDblClick;
  end;

implementation


const
  // Key select events (Space and Enter)
  NIN_SELECT           = WM_USER + 0;
  NINF_KEY             = 1;
  NIN_KEYSELECT        = NINF_KEY or NIN_SELECT;
  // Events returned by balloon hint
  NIN_BALLOONSHOW      = WM_USER + 2;
  NIN_BALLOONHIDE      = WM_USER + 3;
  NIN_BALLOONTIMEOUT   = WM_USER + 4;
  NIN_BALLOONUSERCLICK = WM_USER + 5;
  // Constants used for balloon hint feature
  NIIF_NONE            = $00000000;
  NIIF_INFO            = $00000001;
  NIIF_WARNING         = $00000002;
  NIIF_ERROR           = $00000003;
  NIIF_ICON_MASK       = $0000000F;    // Reserved for WinXP
  NIIF_NOSOUND         = $00000010;    // Reserved for WinXP
  // Additional uFlags constants for TNotifyIconDataEx
  NIF_STATE            = $00000008;
  NIF_INFO             = $00000010;
  NIF_GUID             = $00000020;
  // Additional dwMessage constants for Shell_NotifyIcon
  NIM_SETFOCUS         = $00000003;
  NIM_SETVERSION       = $00000004;
  NOTIFYICON_VERSION   = 3;            // Used with the NIM_SETVERSION message
  // Tooltip constants
  TOOLTIPS_CLASS       = 'tooltips_class32';
  TTS_NOPREFIX         = 2;


var
  wm_TaskbarCreated: DWord;

type
  _DllVersionInfo = record
    cbSize: DWORD;
    dwMajorVersion: DWORD;
    dwMinorVersion: DWORD;
    dwBuildNumber: DWORD;
    dwPlatformID: DWORD;
  end;
  DLLVERSIONINFO = _DllVersionInfo;
  TDLLVersionInfo = DLLVERSIONINFO;

var
  DLLGetVersion: function( var VI: TDLLVersionInfo ): HResult; stdcall;


function Shell32Version: Integer;
var
  VI: TDLLVersionInfo;
  ShModule: THandle;
begin
  Result := 0;
  ShModule := GetModuleHandle( ShellAPI.Shell32 );
  if ShModule <> 0 then
  begin
    @DLLGetVersion := GetProcAddress( ShModule, 'DllGetVersion' );
    if Assigned( DLLGetVersion ) then
    begin
      VI.cbSize := SizeOf( VI );
      DLLGetVersion( VI );
      Result := VI.dwMajorVersion;
    end;
  end;
end;


{&RT}
{=========================}
{== TRzTrayIcon Methods ==}
{=========================}

constructor TRzTrayIcon.Create( AOwner: TComponent );
begin
  inherited;

  FIcon := TIcon.Create;
  FTimer := TTimer.Create( nil );

  FIconIndex := 0;
  FIcon.Assign( Application.Icon );

  FRestoreOn := ticLeftDblClick;
  FPopupMenuOn := ticRightClickUp;

  FHideOnMinimize := True;

  {$IFDEF VCL60_OR_HIGHER}
  // Classes prefix needed to eliminate Warning message under Delphi 6 and higher
  FMsgWindow := Classes.AllocateHWnd( MsgWndProc );
  {$ELSE}
  FMsgWindow := AllocateHWnd( MsgWndProc );
  {$ENDIF}

  FTimer.Enabled := False;
  FTimer.OnTimer := TimerExpiredHandler;
  FTimer.Interval := 1000;
  {&RCI}

  FShell32Ver5 := Shell32Version >= 5;

  if not ( csDesigning in ComponentState ) then
  begin
    if FShell32Ver5 then
    begin
      FillChar( FIConData, 0, SizeOf( TRzNotifyIconData ) );

      FIConData.cbSize := SizeOf( TRzNotifyIconData );
      FIConData.Wnd := FMsgWindow;
      FIConData.uID := Integer( Self );
      FIConData.uFlags := nif_Message or nif_Icon;
      FIConData.uCallBackMessage := wm_TrayIconMessage;
      FIConData.hIcon := FIcon.Handle;
    end
    else
    begin
      FillChar( FIConDataPreV5, 0, SizeOf( TNotifyIconData ) );

      FIConDataPreV5.cbSize := SizeOf( TNotifyIconData );
      FIConDataPreV5.Wnd := FMsgWindow;
      FIConDataPreV5.uID := Integer( Self );
      FIConDataPreV5.uFlags := nif_Message or nif_Icon;
      FIConDataPreV5.uCallBackMessage := wm_TrayIconMessage;
      FIConDataPreV5.hIcon := FIcon.Handle;
    end;

    // Replace the application's OnMinimize and OnRestore handlers with
    // special ones for the tray icon. The TRzTrayIcon component has its own
    // OnMinimizeApp and OnRestoreApp events that the user can set.
    Application.OnMinimize := MinimizeAppHandler;
    Application.OnRestore := RestoreAppHandler;
    Update;
  end;
  FEnabled := True;
end;


destructor TRzTrayIcon.Destroy;
begin
  if not ( csDesigning in ComponentState ) then
  begin
    if FShell32Ver5 then
      Shell_NotifyIcon( nim_Delete, @FIconData )
    else
      Shell_NotifyIcon( nim_Delete, @FIconDataPreV5 );
  end;

  {$IFDEF VCL60_OR_HIGHER}
  // Classes prefix needed to eliminate Warning message under Delphi 6 and higher
  Classes.DeallocateHWnd( FMsgWindow );
  {$ELSE}
  DeallocateHWnd( FMsgWindow );
  {$ENDIF}

  FIcon.Free;
  FTimer.Free;
  inherited;
end;


procedure TRzTrayIcon.Loaded;
begin
  inherited;

  if not Assigned( FIconList ) then
    FIcon.Assign( Application.Icon )
  else
    FIconList.GetIcon( FIconIndex, FIcon );

  if not ( csDesigning in ComponentState ) and FEnabled then
    EnabledChanged;

  Update;
end;


procedure TRzTrayIcon.Notification( Component: TComponent; Operation: TOperation );
begin
  inherited;
  if Operation = opRemove then
  begin
    if Component = FPopupMenu then
      FPopupMenu := nil
    else if Component = FIconList then
      FIconList := nil;
  end;
end;


procedure TRzTrayIcon.Update;
begin
  if not ( csDesigning in ComponentState ) then
  begin
    if FShell32Ver5 then
    begin
      FIconData.hIcon := FIcon.Handle;
      Shell_NotifyIcon( nim_Modify, @FIconData );
    end
    else
    begin
      FIconDataPreV5.hIcon := FIcon.Handle;
      Shell_NotifyIcon( nim_Modify, @FIconDataPreV5 );
    end;
  end;
end;


procedure TRzTrayIcon.ShowMenu;
var
  P: TPoint;
begin
  {&RV}
  if Assigned( FPopupMenu ) then
  begin
    GetCursorPos( P );

    // Must call SetForegroundWindow for proper menu behavior
    if Owner is TForm then
      SetForegroundWindow( TForm( Owner ).Handle );
    FMenuVisible := True;
    try
      FPopupMenu.Popup( P.X, P.Y );
      PostMessage( 0, 0, 0, 0 );
    finally
      FMenuVisible := False;
    end;
  end;
end;


procedure TRzTrayIcon.ShowBalloonHint( const Title: string; const Msg: string; IconType: TRzBalloonHintIcon = bhiInfo;
                                       TimeoutSecs: TRzBalloonHintTimeOut = 10 );
const
  BalloonIconTypes: array[ TRzBalloonHintIcon ] of Byte = ( NIIF_NONE, NIIF_INFO, NIIF_WARNING, NIIF_ERROR );
begin
  if FShell32Ver5 then
  begin
    // Remove old balloon hint
    HideBalloonHint;

    // Display new balloon hint
    FIconData.uFlags := nif_Info;
    StrPLCopy( FIconData.szInfo, Msg, SizeOf( FIconData.szTip ) - 1 );
    StrPLCopy( FIconData.szInfoTitle, Title, SizeOf( FIconData.szTip ) - 1 );
    FIconData.TimeoutOrVersion.uTimeout := TimeoutSecs * 1000;
    FIconData.dwInfoFlags := BalloonIconTypes[ IconType ];

    Update;

    // Remove nif_Info before next call to ModifyIcon (or the balloon hint will redisplay itself)
    FIconData.uFlags := nif_Icon or nif_Message or nif_Tip;
  end;
end;


procedure TRzTrayIcon.HideBalloonHint;
begin
  if FShell32Ver5 then
  begin
    FIconData.uFlags := FIconData.uFlags or NIF_INFO;
    StrPCopy( FIconData.szInfo, '' );
    Update;
  end;
end;


procedure TRzTrayIcon.MsgWndProc( var Msg: TMessage );
begin
  case Msg.Msg of
    wm_QueryEndSession:
      Msg.Result := 1;                                     // Allow Windows to shut down

    wm_EndSession:
      EndSession;                                          // Be sure to clean up tray icon

    wm_TrayIconMessage:
    begin
      case Msg.LParam of
        wm_LButtonDown:
          LButtonDown;

        wm_LButtonUp:
          LButtonUp;

        wm_LButtonDblClk:
          LButtonDblClick;

        wm_RButtonDown:
          RButtonDown;

        wm_RButtonUp:
          RButtonUp;

        wm_RButtonDblClk:
          RButtonDblClick;

        nin_BalloonShow:
        begin
          // Do nothing
        end;

        nin_BalloonHide:
        begin
          if Assigned( FOnBalloonHintHide ) then
            FOnBalloonHintHide( Self );
        end;

        nin_BalloonTimeout:
        begin
          if Assigned( FOnBalloonHintClose ) then
            FOnBalloonHintClose( Self );
        end;

        nin_BalloonUserClick:
        begin
          if Assigned( FOnBalloonHintClick ) then
            FOnBalloonHintClick( Self );
        end;

      end;
    end;
  end;

  if Msg.Msg = wm_TaskbarCreated then
  begin
    try
      // Restore only icons that were already enabled. Do not restore disabled ones.
      if Enabled then
      begin
        FTaskBarRecreated := True;
        try
          SetEnabled( True );
        finally
          FTaskBarRecreated := False;
        end;
      end;
    except
    end;
  end;

  Dispatch( Msg );
end;


procedure TRzTrayIcon.TimerExpiredHandler( Sender: TObject );
begin
  if ( FIconList <> nil ) and not ( csDesigning in ComponentState ) then
  begin
    if IconIndex < FIconList.Count - 1 then
      Inc( FIconIndex )
    else
      FIconIndex := 0;

    SetIconIndex( FIconIndex );
    Update;
  end;
end;



procedure TRzTrayIcon.MinimizeAppHandler( Sender: TObject );
begin
  MinimizeApp;
end;

procedure TRzTrayIcon.RestoreAppHandler( Sender: TObject );
begin
  RestoreApp;
end;


procedure TRzTrayIcon.EndSession;
begin
  if FShell32Ver5 then
    Shell_NotifyIcon( nim_Delete, @FIconData )
  else
    Shell_NotifyIcon( nim_Delete, @FIconDataPreV5 );
end;


procedure TRzTrayIcon.DoMinimizeApp;
begin
  if Assigned( FOnMinimizeApp ) then
    FOnMinimizeApp( Self );
end;

procedure TRzTrayIcon.MinimizeApp;
begin
  Application.Minimize;
  if FEnabled and FHideOnMinimize then
    ShowWindow( Application.Handle, sw_Hide );
  DoMinimizeApp;
end;


procedure TRzTrayIcon.DoRestoreApp;
begin
  if Assigned( FOnRestoreApp ) then
    FOnRestoreApp( Self );
end;

procedure TRzTrayIcon.RestoreApp;
begin
  if FMenuVisible then
    Exit;
  Application.Restore;
  if FEnabled then
  begin
    ShowWindow( Application.Handle, sw_Restore );
    SetForegroundWindow( Application.Handle );
  end;
  DoRestoreApp;
end;


function TRzTrayIcon.GetAnimate: Boolean;
begin
  Result := FTimer.Enabled;
end;

procedure TRzTrayIcon.SetAnimate( Value: Boolean );
begin
  FTimer.Enabled := Value;
end;


procedure TRzTrayIcon.SetHint( const Value: string );
begin
  if ( FHint <> Value ) and ( Length( Value ) < 64 ) then
  begin
    FHint := Value;
    if FShell32Ver5 then
    begin
      StrPLCopy( FIconData.szTip, Value, SizeOf( FIconData.szTip ) - 1 );

      if Value <> '' then
        FIconData.uFlags := FIconData.uFlags or nif_Tip
      else
        FIconData.uFlags := FIconData.uFlags and not nif_Tip;
    end
    else
    begin
      StrPLCopy( FIconDataPreV5.szTip, Value, SizeOf( FIconDataPreV5.szTip ) - 1 );

      if Value <> '' then
        FIconDataPreV5.uFlags := FIconDataPreV5.uFlags or nif_Tip
      else
        FIconDataPreV5.uFlags := FIconDataPreV5.uFlags and not nif_Tip;
    end;

    Update;
  end;
end;


function TRzTrayIcon.GetInterval: Integer;
begin
  Result := FTimer.Interval;
end;

procedure TRzTrayIcon.SetInterval( Value: Integer );
begin
  FTimer.Interval := Value;
end;


procedure TRzTrayIcon.SetEnabled( Value: Boolean );
begin
  if ( FEnabled <> Value ) or FTaskBarRecreated then
  begin
    FEnabled := Value;

    if not ( csDesigning in ComponentState ) and not ( csLoading in ComponentState ) then
      EnabledChanged;
  end;
end;


procedure TRzTrayIcon.EnabledChanged;
begin
  if FEnabled then
  begin
    if FShell32Ver5 then
    begin
      if not Shell_NotifyIcon( nim_Add, @FIconData ) then
        raise ERzTrayIconError.Create( 'Cannot create Shell Notification Icon' );
    end
    else
    begin
      if not Shell_NotifyIcon( nim_Add, @FIconDataPreV5 ) then
        raise ERzTrayIconError.Create( 'Cannot create Shell Notification Icon' );
    end;
    Application.OnMinimize := MinimizeAppHandler;
    Application.OnRestore := RestoreAppHandler;
  end
  else
  begin
    if FShell32Ver5 then
    begin
      if not Shell_NotifyIcon( nim_Delete, @FIconData ) then
        raise ERzTrayIconError.Create( 'Cannot remove Shell Notification Icon' );
    end
    else
    begin
      if not Shell_NotifyIcon( nim_Delete, @FIconDataPreV5 ) then
        raise ERzTrayIconError.Create( 'Cannot remove Shell Notification Icon' );
    end;
  end;
end;


procedure TRzTrayIcon.SetIconIndex( Value: Integer );
begin
  FIconIndex := Value;

  if Assigned( FIconList ) then
    FIconList.GetIcon( FIconIndex, FIcon );
  Update;
end;

procedure TRzTrayIcon.SetDefaultIcon;
begin
  FIcon.Assign( Application.Icon );
  Update;
end;


procedure TRzTrayIcon.LButtonDown;
begin
  if FRestoreOn = ticLeftClick then
    RestoreApp;
  if FPopupMenuOn = ticLeftClick then
    ShowMenu;

  if Assigned( FOnLButtonDown ) then
    FOnLButtonDown( Self );
end;

procedure TRzTrayIcon.LButtonUp;
begin
  if FRestoreOn = ticLeftClickUp then
    RestoreApp;
  if FPopupMenuOn = ticLeftClickUp then
    ShowMenu;

  if Assigned( FOnLButtonUp ) then
    FOnLButtonUp( Self );
end;

procedure TRzTrayIcon.LButtonDblClick;
begin
  if FRestoreOn = ticLeftDblClick then
    RestoreApp;
  if FPopupMenuOn = ticLeftDblClick then
    ShowMenu;

  if Assigned( FOnLButtonDblClick ) then
    FOnLButtonDblClick( Self );
end;

procedure TRzTrayIcon.RButtonDown;
begin
  if FRestoreOn = ticRightClick then
    RestoreApp;
  if FPopupMenuOn = ticRightClick then
    ShowMenu;

  if Assigned( FOnRButtonDown ) then
    FOnRButtonDown( Self );
end;

procedure TRzTrayIcon.RButtonUp;
begin
  if FRestoreOn = ticRightClickUp then
    RestoreApp;
  if FPopupMenuOn = ticRightClickUp then
    ShowMenu;

  if Assigned( FOnRButtonUp ) then
    FOnRButtonUp( Self );
end;

procedure TRzTrayIcon.RButtonDblClick;
begin
  if FRestoreOn = ticRightDblClick then
    RestoreApp;
  if FPopupMenuOn = ticRightDblClick then
    ShowMenu;

  if Assigned( FOnRButtonDblClick ) then
    FOnRButtonDblClick( Self );
end;


initialization
  wm_TaskbarCreated := RegisterWindowMessage( 'TaskbarCreated' );
  {&RUI}

end.
