{===============================================================================
  RzDBRGrp Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzDBRadioGroup       Data-Aware TRzRadioGroup


  Modification History
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Surfaced the OnPaint event in TRzDBRadioGroup. This is useful when
      GroupStyle is set to gsCustom.
    * When a TRzDBRadioGroup is connected to a dataset that is not active, the
      radio-group disables itself.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Inherits changes from TRzRadioGroup.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzDBRGrp;

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
  RzRadGrp,
  Menus,
  DB,
  RzPanel,
  DBCtrls,
  ExtCtrls,
  RzCommon;

type
  TRzDBRadioGroup = class( TRzCustomRadioGroup )
  private
    FAboutInfo: TRzAboutInfo;
    FDataLink: TFieldDataLink;
    FValue: string;
    FValues: TStrings;
    FInSetValue: Boolean;
    FOnChange: TNotifyEvent;

    { Internal Event Handlers }
    procedure ActiveChange( Sender: TObject );
    procedure DataChange( Sender: TObject );
    procedure UpdateData( Sender: TObject );

    { Message Handling Methods }
    procedure CMExit( var Msg: TCMExit ); message cm_Exit;
  protected
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    { Event Dispatch Methods }
    procedure Change; dynamic;
    procedure Click; override;
    procedure KeyPress( var Key: Char ); override;
    function CanModify: Boolean; override;

    { Property Access Methods }
    function GetField: TField; virtual;
    function GetDataField: string; virtual;
    procedure SetDataField( const Value: string ); virtual;
    function GetDataSource: TDataSource; virtual;
    procedure SetDataSource( Value: TDataSource ); virtual;
    function GetReadOnly: Boolean; virtual;
    procedure SetReadOnly( Value: Boolean ); virtual;
    function GetButtonValue( Index: Integer ): string; virtual;
    procedure SetValue( const Value: string ); virtual;
    procedure SetItems( Value: TStrings ); override;
    procedure SetValues( Value: TStrings ); virtual;

    { Property Declarations }
    property DataLink: TFieldDataLink
      read FDataLink;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function ExecuteAction( Action: TBasicAction ): Boolean; override;
    function UpdateAction( Action: TBasicAction ): Boolean; override;

    property Field: TField
      read GetField;

    property Value: string
      read FValue
      write SetValue;

    property Buttons;
    property ItemEnabled;
    property ItemIndex;
  published
    property About: TRzAboutInfo
      read FAboutInfo
      write FAboutInfo
      stored False;

    property DataField: string
      read GetDataField
      write SetDataField;

    property DataSource: TDataSource
      read GetDataSource
      write SetDataSource;

    property Items
      write SetItems;

    property ReadOnly: Boolean
      read GetReadOnly
      write SetReadOnly
      default False;

    property Values: TStrings
      read FValues
      write SetValues;

    property OnChange: TNotifyEvent
      read FOnChange
      write FOnChange;

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
    property ItemFrameColor;
    property ItemHighlightColor;
    property ItemHotTrack;
    property ItemHotTrackColor;
    property ItemHotTrackColorType;
    property ItemFont;
    property ItemHeight;
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


implementation


{&RT}
{=============================}
{== TRzDBRadioGroup Methods ==}
{=============================}

constructor TRzDBRadioGroup.Create( AOwner: TComponent );
begin
  inherited;
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
  FDataLink.OnUpdateData := UpdateData;
  FDataLink.OnActiveChange := ActiveChange;
  FValues := TStringList.Create;
  {&RCI}
end;


destructor TRzDBRadioGroup.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  FValues.Free;
  inherited;
end;


procedure TRzDBRadioGroup.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;
  if ( Operation = opRemove ) and ( FDataLink <> nil ) and ( AComponent = DataSource ) then
    DataSource := nil;
end;


procedure TRzDBRadioGroup.DataChange( Sender: TObject );
begin
  if not ( csDestroying in ComponentState ) then
  begin
    if FDataLink.Field <> nil then
      Value := FDataLink.Field.Text
    else
      Value := '';
  end;
end;


procedure TRzDBRadioGroup.UpdateData( Sender: TObject );
begin
  if FDataLink.Field <> nil then
    FDataLink.Field.Text := Value;
end;


procedure TRzDBRadioGroup.ActiveChange( Sender: TObject );
begin
  Enabled := ( FDataLink <> nil ) and FDataLink.Active;
end;


function TRzDBRadioGroup.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;


procedure TRzDBRadioGroup.SetDataSource( Value: TDataSource );
begin
  if not ( FDataLink.DataSourceFixed and ( csLoading in ComponentState ) ) then
  begin
    FDataLink.DataSource := Value;
    if Value <> nil then
      Value.FreeNotification( Self );
  end;
end;


function TRzDBRadioGroup.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;


procedure TRzDBRadioGroup.SetDataField( const Value: string );
begin
  FDataLink.FieldName := Value;
end;


function TRzDBRadioGroup.GetReadOnly: Boolean;
begin
  Result := FDataLink.ReadOnly;
end;


procedure TRzDBRadioGroup.SetReadOnly( Value: Boolean );
begin
  FDataLink.ReadOnly := Value;
end;


function TRzDBRadioGroup.GetField: TField;
begin
  Result := FDataLink.Field;
end;


function TRzDBRadioGroup.GetButtonValue( Index: Integer ): string;
begin
  if ( Index < FValues.Count ) and ( FValues[ Index ] <> '' ) then
    Result := FValues[ Index ]
  else if Index < Items.Count then
    Result := Items[ Index ]
  else
    Result := '';
end;


procedure TRzDBRadioGroup.SetValue( const Value: string );
var
  I, Index: Integer;
begin
  if FValue <> Value then
  begin
    FInSetValue := True;
    try
      Index := -1;
      for I := 0 to Items.Count - 1 do
        if Value = GetButtonValue(I) then
        begin
          Index := I;
          Break;
        end;
      ItemIndex := Index;
    finally
      FInSetValue := False;
    end;
    FValue := Value;
    Change;
  end;
end;


procedure TRzDBRadioGroup.CMExit( var Msg: TCMExit );
begin
  try
    FDataLink.UpdateRecord;
  except
    if ItemIndex >= 0 then
      TRadioButton( Controls[ ItemIndex ] ).SetFocus
    else
      TRadioButton( Controls[ 0 ] ).SetFocus;
    raise;
  end;
  inherited;
end;


procedure TRzDBRadioGroup.Click;
begin
  if not FInSetValue then
  begin
    inherited;
    if ItemIndex >= 0 then
      Value := GetButtonValue( ItemIndex );
    if FDataLink.Editing then
      FDataLink.Modified;
  end;
  {&RV}
end;


procedure TRzDBRadioGroup.SetItems( Value: TStrings );
begin
  Items.Assign( Value );
  DataChange( Self );
end;


procedure TRzDBRadioGroup.SetValues( Value: TStrings );
begin
  FValues.Assign( Value );
  DataChange( Self );
end;


procedure TRzDBRadioGroup.Change;
begin
  if Assigned( FOnChange ) then
    FOnChange( Self );
end;


procedure TRzDBRadioGroup.KeyPress( var Key: Char );
begin
  inherited;
  case Key of
    #8, ' ':
      FDataLink.Edit;
    #27:
      FDataLink.Reset;
  end;
end;


function TRzDBRadioGroup.CanModify: Boolean;
begin
  Result := FDataLink.Edit;
end;


function TRzDBRadioGroup.ExecuteAction( Action: TBasicAction ): Boolean;
begin
  Result := inherited ExecuteAction( Action ) or ( DataLink <> nil ) and DataLink.ExecuteAction( Action );
end;


function TRzDBRadioGroup.UpdateAction( Action: TBasicAction ): Boolean;
begin
  Result := inherited UpdateAction( Action ) or ( DataLink <> nil ) and DataLink.UpdateAction( Action );
end;


{&RUIF}
end.
