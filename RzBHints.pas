{===============================================================================
  TRzBHints Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzBalloonHints       Application hints are displayed in a customizable
                          balloon hint window


  Modification History
  ------------------------------------------------------------------------------
  3.0.10 (26 Dec 2003)
    * Set TRzBalloonHints.Font.Color to clInfoText as default.

  3.0    (20 Dec 2002)
    * Removed the BalloonStyle property.
    * The hint window displayed by the component is much cleaner and is similar
      to the BalloonHint window implemented in version 5 of the Shell32.dll
      for Windows.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzBHints;

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
  ExtCtrls,
  RzCommon,
  RzGrafx;

const
  MinWindowWidth = 55;
  MouseAdj = 2;

type
  TRzHintCorner = ( hcLowerRight, hcLowerLeft, hcUpperLeft, hcUpperRight );

  TSetHintWinSizeEvent = procedure( Sender: TObject; Canvas: TCanvas; var Width, Height: Integer;
                                    Hint: string; Corner: TRzHintCorner ) of object;
  TSetHintRectEvent = procedure( Sender: TObject; Canvas: TCanvas; var Rect: TRect;
                                 Hint: string; Corner: TRzHintCorner ) of object;

  {=========================================}
  {== TRzBalloonBitmaps Class Declaration ==}
  {=========================================}

  PRzBalloonBitmaps = ^TRzBalloonBitmaps;

  TRzBalloonBitmaps = class( TPersistent )
  private
    FLowerRight: TBitmap;
    FLowerLeft: TBitmap;
    FUpperLeft: TBitmap;
    FUpperRight: TBitmap;
    FTransparentColor: TColor;
    FOnChange: TNotifyEvent;
  protected
    { Property Access Methods }
    procedure SetLowerRight( Value: TBitmap ); virtual;
    procedure SetLowerLeft( Value: TBitmap ); virtual;
    procedure SetUpperLeft( Value: TBitmap ); virtual;
    procedure SetUpperRight( Value: TBitmap ); virtual;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property LowerRight: TBitmap
      read FLowerRight
      write SetLowerRight;

    property LowerLeft: TBitmap
      read FLowerLeft
      write SetLowerLeft;

    property UpperLeft: TBitmap
      read FUpperLeft
      write SetUpperLeft;

    property UpperRight: TBitmap
      read FUpperRight
      write SetUpperRight;

    property TransparentColor: TColor
      read FTransParentColor
      write FTransParentColor;

    property OnChange: TNotifyEvent
      read FOnChange
      write FOnChange;
  end;

  TRzBalloonHints = class;

  {===========================================}
  {== TRzCustomHintWindow Class Declaration ==}
  {===========================================}

  TRzCustomHintWindow = class( THintWindow )
  private
    FHintActive: Bool;
    FApplication: TApplication;
    FBalloonHints: TRzBalloonHints;
    FBitmaps: PRzBalloonBitmaps;
    FCaption: string;
    FCaptionWidth: Integer;
    FColor: TColor;
    FHintInfo: THintInfo;
    FFont: TFont;
    FAlignment: TAlignment;
    FCorner: TRzHintCorner;
    FDrawCorner: TRzHintCorner;

    FOnSetHintWinSize: TSetHintWinSizeEvent;
    FOnSetHintRect: TSetHintRectEvent;

    { Message Handling Methods }
    procedure CMTextChanged( var Msg: TMessage ); message cm_TextChanged;
    procedure WMNCPaint( var Msg: TMessage ); message wm_NCPaint;
    procedure WMNCHitTest( var Msg: TWMNCHitTest ); message wm_NCHitTest;
  protected
    procedure CreateParams( var Params: TCreateParams ); override;

    procedure Paint; override;
    procedure DrawBalloon( Canvas: TCanvas; BalloonRect: TRect );
    procedure DrawBitmapBalloon( Canvas: TCanvas );

    procedure WndProc( var msg: TMessage ); override;

    { Property Access Methods }
    procedure SetFont( Value: TFont );
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure ActivateHint( Rect: TRect; const AHint: string ); override;
    function IsHintMsg( var Msg: TMsg ): Boolean; override;
    procedure ReleaseHandle;
    procedure DoShowHint( var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo );
    procedure BitmapChanged( Sender: TObject );

    property Bitmaps: PRzBalloonBitmaps
      read FBitmaps
      write FBitmaps;
  published
    property Color: TColor
      read FColor
      write FColor;

    property CaptionWidth: Integer
      read FCaptionWidth
      write FCaptionWidth;

    property Caption: string
      read FCaption
      write FCaption;

    property Font: TFont
      read FFont
      write SetFont;

    property Alignment: TAlignment
      read FAlignment
      write FAlignment;

    property Corner: TRzHintCorner
      read FCorner
      write FCorner;

    property OnSetHintWinSize: TSetHintWinSizeEvent
      read FOnSetHintWinSize
      write FOnSetHintWinSize;

    property OnSetHintRect: TSetHintRectEvent
      read FOnSetHintRect
      write FOnSetHintRect;

    property Canvas;
  end;

  {=======================================}
  {== TRzBalloonHints Class Declaration ==}
  {=======================================}

  TRzBalloonHints = class( TComponent )
  private
    FAboutInfo: TRzAboutInfo;
    FHintWindow: TRzCustomHintWindow;
    FOrigHintWindowClass: THintWindowClass;

    FBitmaps: TRzBalloonBitmaps;
    FCaptionWidth: Integer;
    FColor: TColor;
    FFont: TFont;
    FAlignment: TAlignment;
    FCorner: TRzHintCorner;
    FShadow: Boolean;
    FShowBalloon: Boolean;

    FOnSetHintWinSize: TSetHintWinSizeEvent;
    FOnSetHintRect: TSetHintRectEvent;
    FOnShowHint: TShowHintEvent;

    { Internal Event Handlers }
    procedure FontChanged( Sender: TObject );
  protected
    procedure DefineProperties( Filer: TFiler ); override;

    { Property Access Methods }
    procedure SetFont( Value: TFont ); virtual;
    procedure SetColor( Value: TColor ); virtual;
    procedure SetCaptionWidth( Value: Integer ); virtual;
    procedure SetAlignment( Value: TAlignment ); virtual;
    procedure SetCorner( Value: TRzHintCorner ); virtual;
    procedure SetOnSetHintWinSize( Value: TSetHintWinSizeEvent ); virtual;
    procedure SetOnSetHintRect( Value: TSetHintRectEvent ); virtual;

    function GetHintPause: Integer; virtual;
    procedure SetHintPause( Value: Integer ); virtual;
    function GetHintShortPause: Integer; virtual;
    procedure SetHintShortPause( Value: Integer ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure MakeConnection( HintWindow: TRzCustomHintWindow );
    procedure BreakConnection( HintWindow: TRzCustomHintWindow );

    property HintWindow: TRzCustomHintWindow
      read FHintWindow;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property Alignment: TAlignment
      read FAlignment
      write SetAlignment;

    property Bitmaps: TRzBalloonBitmaps
      read FBitmaps
      write FBitmaps;

    property CaptionWidth: Integer
      read FCaptionWidth
      write SetCaptionWidth;

    property Color: TColor
      read FColor
      write SetColor;

    property Corner: TRzHintCorner
      read FCorner
      write SetCorner
      default hcUpperRight;

    property Font: TFont
      read FFont
      write SetFont;

    property HintPause: Integer
      read GetHintPause
      write SetHintPause;

    property HintShortPause: Integer
      read GetHintShortPause
      write SetHintShortPause
      default 50;

    property Shadow: Boolean
      read FShadow
      write FShadow
      default False;

    property ShowBalloon: Boolean
      read FShowBalloon
      write FShowBalloon
      default True;

    property OnSetHintWinSize: TSetHintWinSizeEvent
      read FOnSetHintWinSize
      write SetOnSetHintWinSize;

    property OnSetHintRect: TSetHintRectEvent
      read FOnSetHintRect
      write SetOnSetHintRect;

    property OnShowHint: TShowHintEvent
      read FOnShowHint
      write FOnShowHint;
  end;


implementation


{&RT}
{=================================}
{== TRzCustomHintWindow Methods ==}
{=================================}

constructor TRzCustomHintWindow.Create( AOwner: TComponent );
var
  I, J: Integer;
  F: TForm;
  S: string[ 255 ];
begin
  inherited;

  if AOwner is TApplication then
  begin
    FApplication := TApplication( AOwner );
    FApplication.OnShowHint := DoShowHint;
  end;

  FHintActive := False;
  FCaptionWidth := 100;
  FCorner := hcUpperRight;

  FFont := TFont.Create;
  FFont.Name := 'MS Sans Serif';
  FFont.Size := 8;

  Canvas.Font := FFont;
  Canvas.Brush.Style := bsClear;

  FBalloonHints := nil;
  FBitmaps := nil;

  // Find The TRzBalloonHints Window and make a connection with it so we can use it's properties

  if AOwner is TApplication then
  begin
    if not ( csDesigning in ComponentState ) then
    begin
      for I := 0 to FApplication.ComponentCount - 1 do
      begin
        S := FApplication.Components[ I ].ClassName;
        if FApplication.Components[ I ] is TForm then
        begin
          F := TForm( FApplication.Components[ I ] );
          for J := 0 to F.ComponentCount - 1 do
          begin
            S := F.Components[ J ].ClassName;
            if F.Components[ J ] is TRzBalloonHints then
            begin
              FBalloonHints := TRzBalloonHints( F.Components[ J ] );
              FBalloonHints.MakeConnection( Self );
            end;
          end;
        end;
      end;
    end;
  end;
end; {= TRzCustomHintWindow.Create =}


destructor TRzCustomHintWindow.Destroy;
begin
  FFont.Free;

  if FBalloonHints <> nil then
    FBalloonHints.BreakConnection( self );
  FBalloonHints := nil;

  inherited;
end;


procedure TRzCustomHintWindow.CreateParams( var Params: TCreateParams );
begin
  inherited;

  Params.Style := ws_Popup or ws_Ex_Transparent;
  Params.WindowClass.Style := Params.WindowClass.Style or cs_SaveBits;

  {$IFDEF VCL70_OR_HIGHER}
  if CheckWin32Version( 5, 1 ) then
    Params.WindowClass.Style := Params.WindowClass.style and not cs_DropShadow;
  {$ENDIF}
end;


procedure TRzCustomHintWindow.WndProc( var Msg: TMessage );
var
  R: TRect;
  P: TPoint;
begin
  case Msg.Msg of
    wm_EraseBkgnd:
    begin
      Msg.Result := 1;
    end;

    wm_SetFocus:
      Windows.SetFocus( Msg.WParam );

    wm_MouseMove:
    begin
      if FHintActive then
      begin
        SetRect( R, FHintInfo.CursorPos.X - MouseAdj, FHintInfo.CursorPos.Y - MouseAdj,
                    FHintInfo.CursorPos.X + MouseAdj, FHintInfo.CursorPos.Y + MouseAdj );

        R.TopLeft := FHintInfo.HintControl.ClientToScreen( R.TopLeft );
        R.BottomRight := FHintInfo.HintControl.ClientToScreen( R.BottomRight );

        R.TopLeft := ScreenToClient( R.TopLeft );
        R.BottomRight := ScreenToClient( R.BottomRight );
        P.X := TWMMouseMove( Msg ).XPos;
        P.Y := TWMMouseMove( Msg ).YPos;
        if not PtInRect( R, P ) then
        begin
          FHintActive := False;
          Application.CancelHint;
        end;
      end;

      FHintInfo.HintControl.Dispatch( Msg );
    end;

    wm_LButtonDblClk, wm_LButtonDown, wm_LButtonUp,
    wm_MButtonDblClk, wm_MButtonDown, wm_MButtonUp,
    wm_RButtonDblClk, wm_RButtonDown, wm_RButtonUp:
      FHintInfo.HintControl.Dispatch( Msg );

    else
      Dispatch( Msg );
  end;
end;{= TRzCustomHintWindow.WndProc =}


function TRzCustomHintWindow.IsHintMsg( var Msg: TMsg ): Boolean;
begin
  Result := ( ( Msg.Message >= WM_KEYFIRST ) and ( Msg.Message <= WM_KEYLAST ) ) or
            ( ( Msg.Message = CM_ACTIVATE ) or ( Msg.Message = CM_DEACTIVATE ) ) or
            ( Msg.Message = CM_APPKEYDOWN ) or
            ( Msg.Message = CM_APPSYSCOMMAND ) or
            ( Msg.Message = WM_COMMAND ) or
            ( ( Msg.Message > WM_MOUSEMOVE ) and ( Msg.Message <= WM_MOUSELAST ) );
end;


procedure TRzCustomHintWindow.ReleaseHandle;
begin
  DestroyHandle;
end;


procedure TRzCustomHintWindow.CMTextChanged( var Msg: TMessage );
var
  R: TRect;
  H: Integer;
  W: Integer;
begin
  inherited;

  R := Bounds( 0, 0, FCaptionWidth, 0 );

  DrawText( Canvas.Handle, PChar( Caption ), -1, R, dt_CalcRect or dt_Left or dt_WordBreak or dt_NoPrefix );

  if Assigned( FOnSetHintRect ) then
    FOnSetHintRect( Self, Canvas, R, Caption, FDrawCorner );

  if ( R.Right - R.Left ) >= MinWindowWidth then
    W := R.Right - R.Left
  else
    W := MinWindowWidth;

//  InflateRect( R, 15, 15 );
  H := R.Bottom - R.Top;

  if Assigned( FOnSetHintWinSize ) then
    FOnSetHintWinSize( Self, Canvas, W, H, Caption, FDrawCorner );

  if W < MinWindowWidth then
    W := MinWindowWidth;

  Height := H;
  Width := W;
end;{= TRzCustomHintWindow.CMTextChanged =}


procedure TRzCustomHintWindow.DoShowHint( var HintStr: string; var CanShow: Boolean;
                                          var HintInfo: THintInfo );
var
  OriginalColor: TColor;
begin
  OriginalColor := FColor;
  if FBalloonHints <> nil then
  begin
    OriginalColor := FBalloonHints.Color;
    HintInfo.HintColor := OriginalColor;
  end;

  CanShow := True;
  HintInfo.HintMaxWidth := FCaptionWidth;

  if FBalloonHints <> nil then
  begin
    if Assigned( FBalloonHints.FOnShowHint ) then
      FBalloonHints.FOnShowHint( HintStr, CanShow, HintInfo );
  end;

  FHintInfo := HintInfo;
  if HintInfo.HintColor <> OriginalColor then
    Color := HintInfo.HintColor
  else
    Color := OriginalColor;
end;


procedure TRzCustomHintWindow.WMNCPaint( var Msg: TMessage );
begin
  { Prevent NonClient Painting }
end;

procedure TRzCustomHintWindow.WMNCHitTest( var Msg: TWMNCHitTest );
begin
  Msg.Result := HTTRANSPARENT;
end;


procedure TRzCustomHintWindow.ActivateHint( Rect: TRect; const AHint: string );
var
  P: TPoint;
  TopLeft: TPoint;
  W: Integer;
  H: Integer;
begin
  Caption := AHint;

  if Assigned( FOnSetHintRect ) then
    FOnSetHintRect( Self, Canvas, Rect, Caption, FDrawCorner );

  BoundsRect := Rect;
  if ( FBalloonHints <> nil ) and FBalloonHints.ShowBalloon then
  begin
    case FDrawCorner of
      hcUpperRight:
      begin
        Inc( Rect.Bottom, 28 );
        if FBalloonHints.Shadow then
          Inc( Rect.Right, 2 );
      end;

      hcUpperLeft:
      begin
        Inc( Rect.Bottom, 28 );
        if FBalloonHints.Shadow then
          Inc( Rect.Right, 2 );
      end;

      hcLowerRight:
      begin
        Dec( Rect.Top, 28 );
        if FBalloonHints.Shadow then
        begin
          Inc( Rect.Right, 2 );
          Inc( Rect.Bottom, 2 );
        end;
      end;

      hcLowerLeft:
      begin
        Dec( Rect.Top, 28 );
        if FBalloonHints.Shadow then
        begin
          Inc( Rect.Right, 2 );
          Inc( Rect.Bottom, 2 );
        end;
      end;
    end;
  end;
  InflateRect( Rect, 2, 2 );

  if FHintInfo.HintControl <> nil then
    P := FHintInfo.HintControl.ClientToScreen( FHintInfo.CursorPos )
  else
    P := BoundsRect.TopLeft;

  if ( FBalloonHints <> nil ) and FBalloonHints.ShowBalloon then
  begin
    OffsetRect( Rect, -Rect.Left, -Rect.Top );
    OffsetRect( Rect, P.X, P.Y );
  end;

  if ( Rect.Right - Rect.Left ) >= MinWindowWidth then
    W := Rect.Right - Rect.Left
  else
    W := MinWindowWidth;

  H := Rect.Bottom - Rect.Top;

  if Assigned( FOnSetHintWinSize ) then
    FOnSetHintWinSize( Self, Canvas, W, H, Caption, FDrawCorner );

  if W < MinWindowWidth then
    W := MinWindowWidth;

  if ( FBalloonHints <> nil ) and not FBalloonHints.ShowBalloon then
    FCorner := hcLowerRight;

  FDrawCorner := FCorner;
  case FCorner of
    hcLowerRight:
    begin
      TopLeft.X := Rect.Left + 1;
      TopLeft.Y := Rect.Top;
    end;

    hcUpperRight:
    begin
      TopLeft.X := Rect.Left + 1;
      TopLeft.Y := Rect.Top - H;
    end;

    hcLowerLeft:
    begin
      TopLeft.X := Rect.Left - W - 1;
      TopLeft.Y := Rect.Top;
    end;

    hcUpperLeft:
    begin
      TopLeft.X := Rect.Left - W - 1;
      TopLeft.Y := Rect.Top - H;
    end;
  end; { case }

  if TopLeft.Y < 0 then
  begin
    if FDrawCorner = hcUpperRight then
      FDrawCorner := hcLowerRight
    else
      FDrawCorner := hcLowerLeft;
    TopLeft.Y := Rect.Top;
  end;

  if TopLeft.Y + H > Screen.Height then
  begin
    if FDrawCorner = hcLowerRight then
      FDrawCorner := hcUpperRight
    else
      FDrawCorner := hcUpperLeft;
    TopLeft.Y := Rect.Top - H;
  end;

  if ( TopLeft.X + W ) > Screen.Width then
  begin
    if FDrawCorner = hcLowerRight then
      FDrawCorner := hcLowerLeft
    else
      FDrawCorner := hcUpperLeft;
    TopLeft.X := Rect.Left - W - 1;
  end;

  if TopLeft.X < 0 then
  begin
    if FDrawCorner = hcLowerLeft then
      FDrawCorner := hcLowerRight
    else
      FDrawCorner := hcUpperRight;
    TopLeft.X := Rect.Left + 1;
  end;

  SetWindowPos( Handle, hwnd_TopMost, TopLeft.X, TopLeft.Y, W, H, swp_ShowWindow or swp_NoActivate );

  FHintActive := True;
end;{= TRzCustomHintWindow.ActivateHint =}


procedure TRzCustomHintWindow.Paint;
var
  R: TRect;
begin
  R := ClientRect;

  // Needs to be set to the bounding rectangle of the text

  if ( FBalloonHints <> nil ) and FBalloonHints.ShowBalloon then
  begin
    case FDrawCorner of
      hcUpperRight:
      begin
        Dec( R.Bottom, 20 );
        if FBalloonHints.Shadow then
          Dec( R.Right, 2 );
      end;

      hcUpperLeft:
      begin
        Dec( R.Bottom, 20 );
        if FBalloonHints.Shadow then
          Dec( R.Right, 2 );
      end;

      hcLowerRight:
      begin
        Inc( R.Top, 20 );
        if FBalloonHints.Shadow then
        begin
          Dec( R.Right, 2 );
          Dec( R.Bottom, 2 );
        end;
      end;

      hcLowerLeft:
      begin
        Inc( R.Top, 20 );
        if FBalloonHints.Shadow then
        begin
          Dec( R.Right, 2 );
          Dec( R.Bottom, 2 );
        end;
      end;
    end;
  end;

  Canvas.Brush.Color := FColor;
  Canvas.Pen.Color := clBlack;
  Canvas.Font := FFont;
  Canvas.Pen.Width := 1;

  DrawBalloon( Canvas, R );
end;


procedure TRzCustomHintWindow.DrawBalloon( Canvas: TCanvas; BalloonRect: TRect );
var
  R, BorderRect, BubbleRect1, BubbleRect2: TRect;
  OldBkMode: Integer;
  Pt1, Pt2, Pt3: TPoint;
begin
  R := ClientRect;

  // Allow user to change text location
  if Assigned( FOnSetHintRect ) then
    FOnSetHintRect( Self, Canvas, BalloonRect, Caption, FDrawCorner );


  if ( FBitmaps <> nil ) and
     ( ( FBitmaps^.FLowerRight.Handle <> 0 ) or ( FBitmaps^.FLowerLeft.Handle <> 0 ) or
       ( FBitmaps^.FUpperLeft.Handle <> 0 ) or ( FBitmaps^.FUpperRight.Handle <> 0 ) ) then
  begin
    DrawBitmapBalloon( Canvas );
  end
  else
  begin
    if ( FBalloonHints <> nil ) and FBalloonHints.ShowBalloon then
    begin
      if ( FBalloonHints <> nil ) and FBalloonHints.Shadow then
      begin
        Canvas.Pen.Color := clBtnShadow;
        Canvas.Brush.Color := clBtnShadow;
        Canvas.RoundRect( BalloonRect.Left + 2, BalloonRect.Top + 2, BalloonRect.Right + 2, BalloonRect.Bottom + 2, 10, 10 );
        Canvas.Pen.Color := cl3DDkShadow;
        Canvas.Brush.Color := cl3DDkShadow;
        Canvas.RoundRect( BalloonRect.Left + 1, BalloonRect.Top + 1, BalloonRect.Right + 1, BalloonRect.Bottom + 1, 10, 10 );
      end;
      Canvas.Pen.Color := clInfoText;
      Canvas.Brush.Color := FColor;
      Canvas.RoundRect( BalloonRect.Left, BalloonRect.Top, BalloonRect.Right, BalloonRect.Bottom, 10, 10 );

      // Draw the Triangle

      case FDrawCorner of
        hcUpperRight:
        begin
          Pt1 := Point( BalloonRect.Left + 10, BalloonRect.Bottom - 2 );
          Pt2 := Point( BalloonRect.Left + 10, R.Bottom - 2 );
          Pt3 := Point( BalloonRect.Left + 30, BalloonRect.Bottom - 2 );

          SetRect( R, BalloonRect.Left + 10, BalloonRect.Bottom - 3,
                      BalloonRect.Left + 31, BalloonRect.Bottom - 1 );

          if FBalloonHints.Shadow then
          begin
            Canvas.Brush.Color := clBtnShadow;
            Canvas.Pen.Color := clBtnShadow;
            Canvas.Polygon( [ Point( Pt1.X + 2, Pt1.Y + 4 ), Point( Pt2.X + 2, Pt2.Y + 2 ), Point( Pt3.X, Pt3.Y + 4 ) ] );

            Canvas.Brush.Color := cl3DDkShadow;
            Canvas.Pen.Color := cl3DDkShadow;
            Canvas.Polygon( [ Point( Pt1.X + 1, Pt1.Y + 3 ), Point( Pt2.X + 1, Pt2.Y + 1 ), Point( Pt3.X - 1, Pt3.Y + 3 ) ] );
          end;
        end;

        hcUpperLeft:
        begin
          Pt1 := Point( BalloonRect.Right - 10, BalloonRect.Bottom - 2 );
          Pt2 := Point( BalloonRect.Right - 10, R.Bottom - 2 );
          Pt3 := Point( BalloonRect.Right - 30, BalloonRect.Bottom - 2 );

          SetRect( R, BalloonRect.Right - 9, BalloonRect.Bottom - 3,
                      BalloonRect.Right - 30, BalloonRect.Bottom - 1 );

          if FBalloonHints.Shadow then
          begin
            Canvas.Brush.Color := clBtnShadow;
            Canvas.Pen.Color := clBtnShadow;
            Canvas.Polygon( [ Point( Pt1.X + 2, Pt1.Y + 4 ), Point( Pt2.X + 2, Pt2.Y + 2 ), Point( Pt3.X + 2, Pt3.Y + 2 ) ] );

            Canvas.Brush.Color := cl3DDkShadow;
            Canvas.Pen.Color := cl3DDkShadow;
            Canvas.Polygon( [ Point( Pt1.X + 1, Pt1.Y + 3 ), Point( Pt2.X + 1, Pt2.Y + 1 ), Point( Pt3.X + 1, Pt3.Y + 1 ) ] );
          end;
        end;

        hcLowerRight:
        begin
          Pt1 := Point( BalloonRect.Left + 10, BalloonRect.Top + 1 );
          Pt2 := Point( BalloonRect.Left + 10, R.Top + 1 );
          Pt3 := Point( BalloonRect.Left + 30, BalloonRect.Top + 1 );

          SetRect( R, BalloonRect.Left + 10, BalloonRect.Top + 2,
                      BalloonRect.Left + 31, BalloonRect.Top + 1 );
          // No need to draw a shadow on the triangle when in this corner
        end;

        hcLowerLeft:
        begin
          Pt1 := Point( BalloonRect.Right - 10, BalloonRect.Top + 1 );
          Pt2 := Point( BalloonRect.Right - 10, R.Top + 1 );
          Pt3 := Point( BalloonRect.Right - 30, BalloonRect.Top + 1 );

          SetRect( R, BalloonRect.Right - 9, BalloonRect.Top + 2,
                      BalloonRect.Right - 30, BalloonRect.Top + 1 );

          if FBalloonHints.Shadow then
          begin
            Canvas.Brush.Color := clBtnShadow;
            Canvas.Pen.Color := clBtnShadow;
            Canvas.Polygon( [ Point( Pt1.X + 2, Pt1.Y - 2 ), Point( Pt2.X + 2, Pt2.Y + 2 ), Point( Pt3.X + 2, Pt3.Y ) ] );

            Canvas.Brush.Color := cl3DDkShadow;
            Canvas.Pen.Color := cl3DDkShadow;
            Canvas.Polygon( [ Point( Pt1.X + 1, Pt1.Y - 2 ), Point( Pt2.X + 1, Pt2.Y + 1 ), Point( Pt3.X + 1, Pt3.Y ) ] );
          end;
        end;
      end; { case FDrawCorner =}

      Canvas.Brush.Color := clInfoBk;
      Canvas.Pen.Color := clInfoText;
      Canvas.Polygon( [ Pt1, Pt2, Pt3 ] );
      Canvas.FillRect( R );
    end
    else
    begin
      Canvas.Rectangle( BalloonRect.Left, BalloonRect.Top, BalloonRect.Right, BalloonRect.Bottom );
      if ( FBalloonHints <> nil ) and FBalloonHints.Shadow then
      begin
        BorderRect := RzCommon.DrawSides( Canvas, BalloonRect, clBtnHighlight, clBlack, sdAllSides );
        RzCommon.DrawSides( Canvas, BorderRect, FColor, clBtnShadow, sdAllSides );
      end
      else
        RzCommon.DrawSides( Canvas, BalloonRect, clInfoText, clInfoText, sdAllSides );
    end;
  end;

  if ( FBalloonHints <> nil ) and FBalloonHints.ShowBalloon then
    InflateRect( BalloonRect, -4, -4 )
  else
  begin
    case Alignment of
      taLeftJustify: OffsetRect( BalloonRect, 2, 2 );
      taRightJustify: OffsetRect( BalloonRect, -2, 2 );
      taCenter: OffsetRect( BalloonRect, 0, 2 )
    end;
  end;

  OldBkMode := SetBkMode( Canvas.Handle, Transparent );
  DrawText( Canvas.Handle, PChar( Caption ), -1, BalloonRect,
            DrawTextAlignments[ Alignment ] or dt_NoPrefix or dt_WordBreak );
  SetBkMode( Canvas.Handle, OldBkMode );
end;{= TRzCustomHintWindow.DrawBalloon =}


procedure TRzCustomHintWindow.DrawBitmapBalloon( Canvas: TCanvas );
var
  TmpBitmap: TBitmap;
  Src: TRect;

  function GetTmpBitmap( var Src: TRect ): TBitmap;
  begin
    Result := nil;
    if FBitmaps^.UpperRight.Handle <> 0 then
    begin
      Result := FBitmaps^.UpperRight;
      case FDrawCorner of
        hcUpperLeft: Src := Rect( Result.Width - 1, 0, 0, Result.Height );
        hcLowerRight: Src := Rect( 0, Result.Height - 1, Result.Width, 0 );
        hcLowerLeft: Src := Rect( Result.Width - 1, Result.Height - 1, 0, 0 );
      end;
    end
    else if FBitmaps^.UpperLeft.Handle <> 0 then
    begin
      Result := FBitmaps^.UpperLeft;
      case FDrawCorner of
        hcUpperRight: Src := Rect( Result.Width - 1, 0, 0, Result.Height );
        hcLowerRight: Src := Rect( Result.Width - 1, Result.Height - 1, 0, 0 );
        hcLowerLeft: Src := Rect( 0, Result.Height - 1, Result.Width, 0 );
      end;
    end
    else if FBitmaps^.LowerRight.Handle <> 0 then
    begin
      Result := FBitmaps^.LowerRight;
      case FDrawCorner of
        hcUpperRight: Src := Rect( 0, Result.Height - 1, Result.Width, 0 );
        hcUpperLeft: Src := Rect( Result.Width - 1, Result.Height - 1, 0, 0 );
        hcLowerLeft: Src := Rect( Result.Width - 1, 0, 0, Result.Height );
      end;
    end
    else if FBitmaps^.LowerLeft.Handle <> 0 then
    begin
      Result := FBitmaps^.LowerLeft;
      case FDrawCorner of
        hcUpperRight: Src := Rect( Result.Width - 1, Result.Height - 1, 0, 0 );
        hcUpperLeft: Src := Rect( 0, Result.Height - 1, Result.Width, 0 );
        hcLowerRight: Src := Rect( Result.Width - 1, 0, 0, Result.Height );
      end;
    end;
  end; {= GetTmpBitmap =}


begin
  TmpBitmap := nil;

  case FDrawCorner of
    hcUpperRight:
    begin
      if FBitmaps^.UpperRight.Handle <> 0 then
      begin
        TmpBitmap := FBitmaps^.UpperRight;
        Src := Bounds( 0, 0, TmpBitmap.width, TmpBitmap.Height );
      end
      else
        TmpBitmap := GetTmpBitmap( Src );
    end;

    hcUpperLeft:
    begin
      if FBitmaps^.UpperLeft.Handle <> 0 then
      begin
        TmpBitmap := FBitmaps^.UpperLeft;
        Src := Bounds( 0, 0, TmpBitmap.width, TmpBitmap.Height );
      end
      else
        TmpBitmap := GetTmpBitmap( Src );
    end;

    hcLowerRight:
    begin
      if FBitmaps^.LowerRight.Handle <> 0 then
      begin
        TmpBitmap := FBitmaps^.LowerRight;
        Src := Bounds( 0, 0, TmpBitmap.width, TmpBitmap.Height );
      end
      else
        TmpBitmap := GetTmpBitmap( Src );
    end;

    hcLowerLeft:
    begin
      if FBitmaps^.LowerLeft.Handle <> 0 then
      begin
        TmpBitmap := FBitmaps^.LowerLeft;
        Src := Bounds( 0, 0, TmpBitmap.width, TmpBitmap.Height );
      end
      else
        TmpBitmap := GetTmpBitmap( Src );
    end;
  end; { case FDrawCorner }

  Canvas.CopyMode := SrcCopy;
  SetBkMode( Canvas.Handle, OPAQUE );
  SetBkColor( Canvas.Handle, clWhite );

  DrawTransparentBitmap( Canvas, TmpBitmap, ClientRect, Src, FBitmaps^.TransparentColor );

end;{= TRzCustomHintWindow.DrawBitmapBalloon =}



procedure TRzCustomHintWindow.SetFont( Value: TFont );
begin
  FFont.Assign( Value );
  Canvas.Font := Value;
end;

procedure TRzCustomHintWindow.BitmapChanged( Sender: TObject );
begin
  if Visible then
    Invalidate;
end;


{===============================}
{== TRzBalloonBitmaps Methods ==}
{===============================}

constructor TRzBalloonBitmaps.Create;
begin
  FLowerRight := TBitmap.Create;
  FLowerLeft := TBitmap.Create;
  FUpperLeft := TBitmap.Create;
  FUpperRight := TBitmap.Create;
  FTransparentColor := clOlive;
end;

destructor TRzBalloonBitmaps.Destroy;
begin
  FLowerRight.Free;
  FLowerLeft.Free;
  FUpperLeft.Free;
  FUpperRight.Free;
  inherited;
end;

procedure TRzBalloonBitmaps.SetLowerRight( Value: TBitmap );
begin
  if FLowerRight <> Value then
  begin
    FLowerRight.Assign( Value );
    if Assigned( FOnChange ) then
      FOnChange( Self );
  end;
end;

procedure TRzBalloonBitmaps.SetLowerLeft( Value: TBitmap );
begin
  if FLowerLeft <> Value then
  begin
    FLowerLeft.Assign( Value );
    if Assigned( FOnChange ) then
      FOnChange( Self );
  end;
end;

procedure TRzBalloonBitmaps.SetUpperLeft( Value: TBitmap );
begin
  if FUpperLeft <> Value then
  begin
    FUpperLeft.Assign( Value );
    if Assigned( FOnChange ) then
      FOnChange( Self );
  end;
end;

procedure TRzBalloonBitmaps.SetUpperRight( Value: TBitmap );
begin
  if FUpperRight <> Value then
  begin
    FUpperRight.Assign( Value );
    if Assigned( FOnChange ) then
      FOnChange( Self );
  end;
end;


{=============================}
{== TRzBalloonHints Methods ==}
{=============================}

constructor TRzBalloonHints.Create( AOwner: TComponent );
var
  OrigVal: Boolean;
begin
  inherited;

  OrigVal := Application.ShowHint;
  FOrigHintWindowClass := HintWindowClass;
  FCaptionWidth := 100;

  FColor := clInfoBk;

  FAlignment := taLeftJustify;
  FCorner := hcUpperRight;
  FShadow := False;
  FShowBalloon := True;
  FBitmaps := TRzBalloonBitmaps.Create;
  FFont := TFont.Create;
  FFont.Name := 'MS Sans Serif';
  FFont.Size := 8;
  FFont.Color := clInfoText;
  FFont.OnChange := FontChanged;

  if not ( csDesigning in ComponentState ) then
  begin
    Application.ShowHint := False;
    HintWindowClass := THintWindowClass( TRzCustomHintWindow );
    Application.ShowHint := OrigVal;
  end;
  HintShortPause := 50;
  {&RCI}
end;{= TRzBalloonHints.Create =}


destructor TRzBalloonHints.Destroy;
var
  OrigVal: Boolean;
begin
  if not ( csDestroying in Application.ComponentState ) then
  begin
    OrigVal := Application.ShowHint;
    Application.ShowHint := False;
    HintWindowClass := FOrigHintWindowClass;
    Application.ShowHint := OrigVal;
  end;
  FBitmaps.Free;
  FFont.Free;
  inherited;
end;


procedure TRzBalloonHints.MakeConnection( HintWindow: TRzCustomHintWindow );
begin
  FHintWindow := HintWindow;
  FHintWindow.CaptionWidth := FCaptionWidth;
  FHintWindow.Color := FColor;
  FHintWindow.Corner := FCorner;
  FHintWindow.Alignment := Alignment;
  FHintWindow.Bitmaps := @FBitmaps;

  FHintWindow.FOnSetHintWinSize := FOnSetHintWinSize;
  FHintWindow.FOnSetHintRect := FOnSetHintRect;

  if FFont <> nil then
    FHintWindow.Font := FFont;
  {&RV}
end;


procedure TRzBalloonHints.BreakConnection( HintWindow: TRzCustomHintWindow );
begin
  FHintWindow := nil;
end;


procedure TRzBalloonHints.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the BalloonStyle was published in version 2.x
  Filer.DefineProperty( 'BalloonStyle', TRzOldPropReader.ReadOldEnumProp, nil, False );
end;


procedure TRzBalloonHints.FontChanged( Sender: TObject );
begin
  if FHintWindow <> nil then
    FHintWindow.Font := FFont;
end;

procedure TRzBalloonHints.SetFont( Value: TFont );
begin
  FFont.Assign( Value );
  if FHintWindow <> nil then
    FHintWindow.Font := Value;
end;

procedure TRzBalloonHints.SetColor( Value: TColor );
begin
  FColor := Value;
  if FHintWindow <> nil then
    FHintWindow.Color := Value;
end;

procedure TRzBalloonHints.SetCaptionWidth( Value: Integer );
begin
  FCaptionWidth := Value;
  if FHintWindow <> nil then
    FHintWindow.CaptionWidth := Value;
end;

procedure TRzBalloonHints.SetAlignment( Value: TAlignment );
begin
  FAlignment := Value;
  if FHintWindow <> nil then
    FHintWindow.Alignment := Value;
end;


procedure TRzBalloonHints.SetCorner( Value: TRzHintCorner );
begin
  FCorner := Value;
  if FHintWindow <> nil then
    FHintWindow.Corner := Value;
end;

procedure TRzBalloonHints.SetOnSetHintWinSize( Value: TSetHintWinSizeEvent );
begin
  FOnSetHintWinSize := Value;
  if FHintWindow <> nil then
    FHintWindow.OnSetHintWinSize := Value;
end;

procedure TRzBalloonHints.SetOnSetHintRect( Value: TSetHintRectEvent );
begin
  FOnSetHintRect := Value;
  if FHintWindow <> nil then
    FHintWindow.OnSetHintRect := Value;
end;


function TRzBalloonHints.GetHintPause: Integer;
begin
  Result := Application.HintPause;
end;

procedure TRzBalloonHints.SetHintPause( Value: Integer );
begin
  Application.HintPause := Value;
end;


function TRzBalloonHints.GetHintShortPause: Integer;
begin
  Result := Application.HintShortPause;
end;

procedure TRzBalloonHints.SetHintShortPause( Value: Integer );
begin
  Application.HintShortPause := Value;
end;


{&RUIF}
end.

