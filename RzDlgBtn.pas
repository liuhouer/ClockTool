{===============================================================================
  RzDlgBtn Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzDialogButtons      Panel component that embeds 3 buttons - OK, Cancel, and
                          Help.


  Modification History
  ------------------------------------------------------------------------------
  3.0.4  (04 Mar 2003)
    * Fixed problem where changing Width* properties did not update display of
      buttons.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Fixed problem where an Action's OnExecute event was not getting fired if
      the Action was connected to one of the buttons.  The custom click events
      for each button are still fired. This allows the user to handle the
      OnClickOK event and set ModalResult to mrNone to prevent the dialog from
      closing.
    * When the Align property is anything other than alLeft or alRight, the
      buttons will be repositioned on the left side of the client area when
      under a Right-to-Left locale.

  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzDlgBtn;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Windows,
  Classes,
  Controls,
  Graphics,
  Menus,
  Forms,
  StdCtrls,
  ExtCtrls,
  RzButton,
  SysUtils,
  RzCommon;

type
  TRzDialogButtons = class( TCustomPanel )
  private
    FAboutInfo: TRzAboutInfo;
    FShowDivider: Boolean;
    FShowGlyphs: Boolean;
    FWidths: array[ 1..3 ] of Integer;
    FOnClickOk: TNotifyEvent;
    FOnClickCancel: TNotifyEvent;
    FOnClickHelp: TNotifyEvent;

    procedure ReadOldFrameFlatProp( Reader: TReader );

    { Internal Event Handlers }
    procedure BtnOkClickHandler( Sender: TObject );
    procedure BtnCancelClickHandler( Sender: TObject );
    procedure BtnHelpClickHandler( Sender: TObject );
  protected
    FBtnOk: TRzBitBtn;
    FBtnCancel: TRzBitBtn;
    FBtnHelp: TRzBitBtn;

    procedure CreateButtons; virtual;

    procedure DefineProperties( Filer: TFiler ); override;
    procedure Loaded; override;

    procedure Paint; override;
    procedure AdjustPanelSize; virtual;
    procedure PositionButtons; virtual;
    procedure Resize; override;

    { Event Dispatch Methods }
    procedure BtnOkClick; dynamic;
    procedure BtnCancelClick; dynamic;
    procedure BtnHelpClick; dynamic;

    { Property Access Methods }
    function GetBtnAction( Index: Integer ): TBasicAction; virtual;
    procedure SetBtnAction( Index: Integer; Value: TBasicAction ); virtual;
    function GetAlign: TAlign; virtual;
    procedure SetAlign( Value: TAlign ); virtual;
    function GetButtonColor: TColor; virtual;
    procedure SetButtonColor( Value: TColor ); virtual;
    function GetBtnCaption( Index: Integer ): TCaption; virtual;
    procedure SetBtnCaption( Index: Integer; const Value: TCaption ); virtual;
    function GetBtnEnable( Index: Integer ): Boolean; virtual;
    procedure SetBtnEnable( Index: Integer; Value: Boolean ); virtual;
    function GetBtnWidth( Index: Integer ): Integer; virtual;
    procedure SetBtnWidth( Index: Integer; const Value: Integer ); virtual;
    procedure SetShowDivider( Value: Boolean ); virtual;
    procedure SetShowGlyphs( Value: Boolean ); virtual;
    function GetShowButton( Index: Integer ): Boolean; virtual;
    procedure SetShowButton( Index: Integer; Value: Boolean ); virtual;
    function GetCancelCancel: Boolean; virtual;
    procedure SetCancelCancel( Value: Boolean ); virtual;
    function GetOKDefault: Boolean; virtual;
    procedure SetOKDefault( Value: Boolean ); virtual;
    function GetHotTrack: Boolean; virtual;
    procedure SetHotTrack( Value: Boolean ); virtual;
    function GetHotTrackColor: TColor; virtual;
    procedure SetHotTrackColor( Value: TColor ); virtual;
    function GetHotTrackColorType: TRzHotTrackColorType; virtual;
    procedure SetHotTrackColorType( Value: TRzHotTrackColorType ); virtual;
    function GetHighlightColor: TColor; virtual;
    procedure SetHighlightColor( Value: TColor ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property ActionOk: TBasicAction
      index 1
      read GetBtnAction
      write SetBtnAction;

    property ActionCancel: TBasicAction
      index 2
      read GetBtnAction
      write SetBtnAction;

    property ActionHelp: TBasicAction
      index 3
      read GetBtnAction
      write SetBtnAction;

    property Align: TAlign
      read GetAlign
      write SetAlign
      default alBottom;

    property ButtonColor: TColor
      read GetButtonColor
      write SetButtonColor
      default clBtnFace;

    property CaptionOk: TCaption
      index 1
      read GetBtnCaption
      write SetBtnCaption;

    property CaptionCancel: TCaption
      index 2
      read GetBtnCaption
      write SetBtnCaption;

    property CaptionHelp: TCaption
      index 3
      read GetBtnCaption
      write SetBtnCaption;

    property EnableOk: Boolean
      index 1
      read GetBtnEnable
      write SetBtnEnable
      default True;

    property EnableCancel: Boolean
      index 2
      read GetBtnEnable
      write SetBtnEnable
      default True;

    property EnableHelp: Boolean
      index 3
      read GetBtnEnable
      write SetBtnEnable
      default True;

    property HotTrack: Boolean
      read GetHotTrack
      write SetHotTrack
      default False;

    property HighlightColor: TColor
      read GetHighlightColor
      write SetHighlightColor
      default clHighlight;

    property HotTrackColor: TColor
      read GetHotTrackColor
      write SetHotTrackColor
      default clHighlight;

    property HotTrackColorType: TRzHotTrackColorType
      read GetHotTrackColorType
      write SetHotTrackColorType
      default htctComplement;

    property CancelCancel: Boolean
      read GetCancelCancel
      write SetCancelCancel
      default True;

    property OKDefault: Boolean
      read GetOKDefault
      write SetOKDefault
      default True;

    property ShowDivider: Boolean
      read FShowDivider
      write SetShowDivider
      default False;

    property ShowGlyphs: Boolean
      read FShowGlyphs
      write SetShowGlyphs
      default False;

    property ShowOKButton: Boolean
      index 1
      read GetShowButton
      write SetShowButton
      default True;

    property ShowCancelButton: Boolean
      index 2
      read GetShowButton
      write SetShowButton
      default True;

    property ShowHelpButton: Boolean
      index 3
      read GetShowButton
      write SetShowButton
      default False;

    property WidthOk: Integer
      index 1
      read GetBtnWidth
      write SetBtnWidth
      default 75;

    property WidthCancel: Integer
      index 2
      read GetBtnWidth
      write SetBtnWidth
      default 75;

    property WidthHelp: Integer
      index 3
      read GetBtnWidth
      write SetBtnWidth
      default 75;

    property OnClickOk: TNotifyEvent
      read FOnClickOk
      write FOnClickOk;

    property OnClickCancel: TNotifyEvent
      read FOnClickCancel
      write FOnClickCancel;

    property OnClickHelp: TNotifyEvent
      read FOnClickHelp
      write FOnClickHelp;

    { Inherited Properties and Events }
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Font;
    property FullRepaint;
    property Height default 36;
    property Locked;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDrag;
  end;

implementation

uses
  RzCommonBitmaps,
  Buttons;

const
  ButtonWidth = 75;
  ButtonHeight = 25;

{&RT}
{==============================}
{== TRzDialogButtons Methods ==}
{==============================}

constructor TRzDialogButtons.Create( AOwner: TComponent );
begin
  inherited;
  {&RCI}
  ControlStyle := ControlStyle - [ csSetCaption ];
  Height := 36;
  inherited Align := alBottom;
  inherited BevelOuter := bvNone;

  FShowGlyphs := False;
  CreateButtons;
  FShowDivider := False;
end;

procedure TRzDialogButtons.CreateButtons;
begin
  FWidths[ 1 ] := ButtonWidth;
  FWidths[ 2 ] := ButtonWidth;
  FWidths[ 3 ] := ButtonWidth;

  FBtnOk := TRzBitBtn.Create( Self );
  FBtnOk.Parent := Self;
  FBtnOk.Width := FWidths[ 1 ];
  FBtnOk.Height := ButtonHeight;
  FBtnOk.ModalResult := mrOk;
  FBtnOk.Caption := BitBtnCaptions[ bkOk ];
  FBtnOk.Default := True;
  FBtnOk.OnClick := BtnOkClickHandler;

  FBtnCancel := TRzBitBtn.Create( Self );
  FBtnCancel.Parent := Self;
  FBtnCancel.Width := FWidths[ 2 ];
  FBtnCancel.Height := ButtonHeight;
  FBtnCancel.ModalResult := mrCancel;
  FBtnCancel.Caption := BitBtnCaptions[ bkCancel ];
  FBtnCancel.Cancel := True;
  FBtnCancel.OnClick := BtnCancelClickHandler;

  FBtnHelp := TRzBitBtn.Create( Self );
  FBtnHelp.Parent := Self;
  FBtnHelp.Width := FWidths[ 3 ];
  FBtnHelp.Height := ButtonHeight;
  FBtnHelp.Caption := BitBtnCaptions[ bkHelp ];
  FBtnHelp.Visible := False;
  FBtnHelp.OnClick := BtnHelpClickHandler;
end;


procedure TRzDialogButtons.DefineProperties( Filer: TFiler );
begin
  inherited;
  // Handle the fact that the FrameFlat property was renamed to HotTrack
  Filer.DefineProperty( 'FrameFlat', ReadOldFrameFlatProp, nil, False );
end;


procedure TRzDialogButtons.ReadOldFrameFlatProp( Reader: TReader );
begin
  HotTrack := Reader.ReadBoolean;
end;


procedure TRzDialogButtons.Loaded;
begin
  inherited;
  PositionButtons;
end;


function TRzDialogButtons.GetBtnAction( Index: Integer ): TBasicAction;
begin
  case Index of
    1: Result := FBtnOk.Action;
    2: Result := FBtnCancel.Action;
    3: Result := FBtnHelp.Action;
    else
      Result := nil;
  end;
end;

procedure TRzDialogButtons.SetBtnAction( Index: Integer; Value: TBasicAction );
begin
  case Index of
    1: FBtnOk.Action := Value;
    2: FBtnCancel.Action := Value;
    3: FBtnHelp.Action := Value;
  end;
end;


procedure TRzDialogButtons.AdjustPanelSize;
var
  I, MaxWidth: Integer;
begin
  if Align in [ alLeft, alRight ] then
  begin
    MaxWidth := 0;
    for I := 1 to 3 do
    begin
      if GetShowButton( I ) then
        if FWidths[ I ] > MaxWidth then
          MaxWidth := FWidths[ I ];
    end;
    Width := MaxWidth + 12;
  end
  else if Align in [ alTop, alBottom ] then
    Height := ButtonHeight + 11;
end;


function TRzDialogButtons.GetAlign: TAlign;
begin
  Result := inherited Align;
end;

procedure TRzDialogButtons.SetAlign( Value: TAlign );
begin
  if Align <> Value then
  begin
    inherited Align := Value;

    AdjustPanelSize;
    PositionButtons;
    Invalidate;
  end;
end;


function TRzDialogButtons.GetButtonColor: TColor;
begin
  Result := FBtnOK.Color;
end;

procedure TRzDialogButtons.SetButtonColor( Value: TColor );
begin
  FBtnOk.Color := Value;
  FBtnCancel.Color := Value;
  FBtnHelp.Color := Value;
end;


function TRzDialogButtons.GetBtnCaption( Index: Integer ): TCaption;
begin
  case Index of
    1: Result := FBtnOk.Caption;
    2: Result := FBtnCancel.Caption;
    3: Result := FBtnHelp.Caption;
    else
      Result := '';
  end;
end;

procedure TRzDialogButtons.SetBtnCaption( Index: Integer; const Value: TCaption );
begin
  case Index of
    1: FBtnOk.Caption := Value;
    2: FBtnCancel.Caption := Value;
    3: FBtnHelp.Caption := Value;
  end;
end;


function TRzDialogButtons.GetBtnEnable( Index: Integer ): Boolean;
begin
  case Index of
    1: Result := FBtnOk.Enabled;
    2: Result := FBtnCancel.Enabled;
    3: Result := FBtnHelp.Enabled;
    else
      Result := False;
  end;
end;

procedure TRzDialogButtons.SetBtnEnable( Index: Integer; Value: Boolean );
begin
  case Index of
    1: FBtnOk.Enabled := Value;
    2: FBtnCancel.Enabled := Value;
    3: FBtnHelp.Enabled := Value;
  end;
end;


function TRzDialogButtons.GetHotTrack: Boolean;
begin
  Result := FBtnOk.HotTrack;
end;

procedure TRzDialogButtons.SetHotTrack( Value: Boolean );
begin
  FBtnOk.HotTrack := Value;
  FBtnCancel.HotTrack := Value;
  FBtnHelp.HotTrack := Value;
end;


function TRzDialogButtons.GetHighlightColor: TColor;
begin
  Result := FBtnOk.HighlightColor;
end;

procedure TRzDialogButtons.SetHighlightColor( Value: TColor );
begin
  FBtnOk.HighlightColor := Value;
  FBtnCancel.HighlightColor := Value;
  FBtnHelp.HighlightColor := Value;
end;


function TRzDialogButtons.GetHotTrackColor: TColor;
begin
  Result := FBtnOk.HotTrackColor;
end;

procedure TRzDialogButtons.SetHotTrackColor( Value: TColor );
begin
  FBtnOk.HotTrackColor := Value;
  FBtnCancel.HotTrackColor := Value;
  FBtnHelp.HotTrackColor := Value;
end;


function TRzDialogButtons.GetHotTrackColorType: TRzHotTrackColorType;
begin
  Result := FBtnOK.HotTrackColorType;
end;


procedure TRzDialogButtons.SetHotTrackColorType( Value: TRzHotTrackColorType );
begin
  FBtnOK.HotTrackColorType := Value;
  FBtnCancel.HotTrackColorType := Value;
  FBtnHelp.HotTrackColorType := Value;
end;


procedure TRzDialogButtons.SetShowDivider( Value: Boolean );
begin
  if FShowDivider <> Value then
  begin
    FShowDivider := Value;
    Invalidate;
  end;
end;


procedure TRzDialogButtons.SetShowGlyphs( Value: Boolean );
begin
  if FShowGlyphs <> Value then
  begin
    FShowGlyphs := Value;

    if FShowGlyphs then
    begin
      FBtnOK.Glyph.Handle := LoadBitmap( HInstance, 'RZCOMMON_OK' );
      FBtnCancel.Glyph.Handle := LoadBitmap( HInstance, 'RZCOMMON_CANCEL' );
      FBtnHelp.Glyph.Handle := LoadBitmap( HInstance, 'RZCOMMON_HELP' );
    end
    else
    begin
      FBtnOK.Glyph := nil;
      FBtnCancel.Glyph := nil;
      FBtnHelp.Glyph := nil;
    end;

    Invalidate;
  end;
end;


function TRzDialogButtons.GetShowButton( Index: Integer ): Boolean;
begin
  case Index of
    1:
      Result := FBtnOK.Visible;
    2:
      Result := FBtnCancel.Visible;
    else
      Result := FBtnHelp.Visible;
  end;
end;

procedure TRzDialogButtons.SetShowButton( Index: Integer; Value: Boolean );
begin
  case Index of
    1: FBtnOK.Visible := Value;
    2: FBtnCancel.Visible := Value;
    3: FBtnHelp.Visible := Value;
  end;
  AdjustPanelSize;
  PositionButtons;
end;


function TRzDialogButtons.GetBtnWidth( Index: Integer ): Integer;
begin
  Result := FWidths[ Index ];
end;

procedure TRzDialogButtons.SetBtnWidth( Index: Integer; const Value: Integer );
begin
  FWidths[ Index ] := Value;
  AdjustPanelSize;
  PositionButtons;
  Invalidate;
end;


function TRzDialogButtons.GetCancelCancel: Boolean;
begin
  Result := FBtnCancel.Cancel;
end;

procedure TRzDialogButtons.SetCancelCancel( Value: Boolean );
begin
  FBtnCancel.Cancel := Value;
end;


function TRzDialogButtons.GetOKDefault: Boolean;
begin
  Result := FBtnOK.Default;
end;

procedure TRzDialogButtons.SetOKDefault( Value: Boolean );
begin
  FBtnOK.Default := Value;
end;


{== Internal Event Handlers and Event Dispatch Methods ==}

procedure TRzDialogButtons.BtnOkClickHandler( Sender: TObject );
begin
  {&RV}
  if FBtnOK.Action <> nil then
    FBtnOK.Action.Execute;
  BtnOkClick;
end;

procedure TRzDialogButtons.BtnOkClick;
begin
  if Assigned( FOnClickOk ) then
    FOnClickOk( Self );
end;


procedure TRzDialogButtons.BtnCancelClickHandler( Sender: TObject );
begin
  {&RV}
  if FBtnCancel.Action <> nil then
    FBtnCancel.Action.Execute;
  BtnCancelClick;
end;

procedure TRzDialogButtons.BtnCancelClick;
begin
  if Assigned( FOnClickCancel ) then
    FOnClickCancel( Self );
end;


procedure TRzDialogButtons.BtnHelpClickHandler( Sender: TObject );
begin
  if FBtnHelp.Action <> nil then
    FBtnHelp.Action.Execute;
  BtnHelpClick;
end;

procedure TRzDialogButtons.BtnHelpClick;
begin
  if Assigned( FOnClickHelp ) then
    FOnClickHelp( Self );
end;


procedure TRzDialogButtons.Paint;
begin
  inherited;

  if FShowDivider then
  begin
    case Align of
      alNone, alBottom, alClient:
        DrawBorderSides( Canvas, ClientRect, fsGroove, [ sdTop ] );

      alTop:
        DrawBorderSides( Canvas, ClientRect, fsGroove, [ sdBottom ] );

      alLeft:
        DrawBorderSides( Canvas, ClientRect, fsGroove, [ sdRight ] );

      alRight:
        DrawBorderSides( Canvas, ClientRect, fsGroove, [ sdLeft ] );
    end;
  end;
end;


procedure TRzDialogButtons.PositionButtons;
var
  H, Offset, SumWidth: Integer;

  function CalcLeft( Button: Integer ): Integer;
  begin
    if Button = 1 then
    begin
      { OkButton }
      SumWidth := 0;
      if ShowOkButton then
        SumWidth := SumWidth + FWidths[ 1 ] + 8;
      if ShowCancelButton then
        SumWidth := SumWidth + FWidths[ 2 ] + 8;
      if ShowHelpButton then
        SumWidth := SumWidth + FWidths[ 3 ] + 8;
      Result := Width - SumWidth;
    end
    else
    begin
      { Cancel button }
      SumWidth := 0;
      if ShowCancelButton then
        SumWidth := SumWidth + FWidths[ 2 ] + 8;
      if ShowHelpButton then
        SumWidth := SumWidth + FWidths[ 3 ] + 8;
      Result := Width - SumWidth;
    end;
  end;

begin {= TRzDialogButtons.PositionButtons =}

//  W := ButtonWidth;
  H := ButtonHeight;

  Offset := 0;
  if ShowOkButton then
    Inc( Offset );
  if ShowCancelButton then
    Inc( Offset );
  if ShowHelpButton then
    Inc( Offset );

  if Align in [ alNone, alTop, alBottom, alClient ] then
  begin
    if ShowOkButton then
    begin
      if not UseRightToLeftAlignment then
        FBtnOk.SetBounds( CalcLeft( 1 ), 6, FWidths[ 1 ], H )
      else
        FBtnOK.SetBounds( Width - CalcLeft( 1 ) - FWidths[ 1 ], 6, FWidths[ 1 ], H );
    end
    else
      FBtnOk.SetBounds( 0, 0, 0, 0 );

    if ShowCancelButton then
    begin
      if not UseRightToLeftAlignment then
        FBtnCancel.SetBounds( CalcLeft( 2 ), 6, FWidths[ 2 ], H )
      else
        FBtnCancel.SetBounds( Width - CalcLeft( 2 ) - FWidths[ 2 ], 6, FWidths[ 2 ], H );
    end
    else
      FBtnCancel.SetBounds( 0, 0, 0, 0 );

    if ShowHelpButton then
    begin
      if not UseRightToLeftAlignment then
        FBtnHelp.SetBounds( Width - ( FWidths[ 3 ] + 8 ), 6, FWidths[ 3 ], H )
      else
        FBtnHelp.SetBounds( 8, 6, FWidths[ 3 ], H );
    end
    else
      FBtnHelp.SetBounds( 0, 0, 0, 0 );
  end
  else { Align in alLeft or alRight }
  begin
    if ShowOkButton then
      FBtnOk.SetBounds( 6, 8, FWidths[ 1 ], H )
    else
      FBtnOk.SetBounds( 0, 0, 0, 0 );

    if ShowCancelButton and ShowOkButton then
      FBtnCancel.SetBounds( 6, ( H + 8 ) + 8, FWidths[ 2 ], H )
    else if ShowCancelButton then
      FBtnCancel.SetBounds( 6, 8, FWidths[ 2 ], H )
    else
      FBtnCancel.SetBounds( 0, 0, 0, 0 );

    if ShowHelpButton then
      FBtnHelp.SetBounds( 6, ( Offset - 1 ) * ( H + 8 ) + 8, FWidths[ 3 ], H )
    else
      FBtnHelp.SetBounds( 0, 0, 0, 0 );
  end;
end; {= TRzDialogButtons.PositionButtons =}


procedure TRzDialogButtons.Resize;
begin
  inherited;
  PositionButtons;
end;

{&RUIF}
end.
