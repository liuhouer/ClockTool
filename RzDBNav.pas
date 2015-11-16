{===============================================================================
  RzDBNav Unit

  Raize Components - Component Source Unit


  Components            Description
  ------------------------------------------------------------------------------
  TRzDBNavigator        Enhanced DBNavigator that provides new button images and
                          also allows the images to be replaced from images in
                          an Image List.


  Modification History
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Initial release.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzDBNav;

interface

uses
  {&RF}
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  SysUtils, 
  Classes,
  Windows,
  Controls, 
  DBCtrls, 
  ImgList;

type
  {==================================================}
  {== TRzDBNavigatorImageIndexes Class Declaration ==}
  {==================================================}

  TRzDBNavigator = class;

  TRzDBNavigatorImageIndexes = class( TPersistent )
  private
    FNavigator: TRzDBNavigator;

    FFirst: TImageIndex;
    FPrevious: TImageIndex;
    FNext: TImageIndex;
    FLast: TImageIndex;
    FInsert: TImageIndex;
    FDelete: TImageIndex;
    FEdit: TImageIndex;
    FPost: TImageIndex;
    FCancel: TImageIndex;
    FRefresh: TImageIndex;
  protected
    function GetImageIndex( Index: Integer ): TImageIndex; virtual;
    procedure SetImageIndex( Index: Integer; Value: TImageIndex ); virtual;
  public
    constructor Create( Navigator: TRzDBNavigator );

    property Navigator: TRzDBNavigator
      read FNavigator; 
  published
    property First: TImageIndex
      index 0
      read GetImageIndex
      write SetImageIndex
      default -1;

    property Previous: TImageIndex
      index 1
      read GetImageIndex
      write SetImageIndex
      default -1;

    property Next: TImageIndex
      index 2
      read GetImageIndex
      write SetImageIndex
      default -1;

    property Last: TImageIndex
      index 3
      read GetImageIndex
      write SetImageIndex
      default -1;

    property Insert: TImageIndex
      index 4
      read GetImageIndex
      write SetImageIndex
      default -1;

    property Delete: TImageIndex
      index 5
      read GetImageIndex
      write SetImageIndex
      default -1;

    property Edit: TImageIndex
      index 6
      read GetImageIndex
      write SetImageIndex
      default -1;

    property Post: TImageIndex
      index 7
      read GetImageIndex
      write SetImageIndex
      default -1;

    property Cancel: TImageIndex
      index 8
      read GetImageIndex
      write SetImageIndex
      default -1;

    property Refresh: TImageIndex
      index 9
      read GetImageIndex
      write SetImageIndex
      default -1;
  end;


  {======================================}
  {== TRzDBNavigator Class Declaration ==}
  {======================================}

  TRzDBNavigator = class( TDBNavigator )
  private
    FImageIndexes: TRzDBNavigatorImageIndexes;
    FImages: TCustomImageList;
    FImagesChangeLink: TChangeLink;

    { Internal Event Handlers }
    procedure ImageListChange( Sender: TObject );
  protected
    procedure Loaded; override;
    procedure Notification( AComponent: TComponent; Operation: TOperation ); override;

    procedure UpdateImage( Button: TNavigateBtn; ImageIndex: TImageIndex );

    { Property Access Methods }
    procedure SetImageIndexes( Value: TRzDBNavigatorImageIndexes ); virtual;
    procedure SetImages( Value: TCustomImageList ); virtual;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property ImageIndexes: TRzDBNavigatorImageIndexes
      read FImageIndexes
      write SetImageIndexes;

    property Images: TCustomImageList
      read FImages
      write SetImages;

    { Inherited Properties & Events }
    property Color;
    property Flat default True;
  end;


implementation

{$R RzDBNav.res}  // Link in new glyphs for navigator buttons

uses
  RzCommon,
  Graphics;

const
  NavBmpNames: array[ TNavigateBtn ] of PChar =
    ( 'RZDBNAV_FIRST', 'RZDBNAV_PREVIOUS', 'RZDBNAV_NEXT', 'RZDBNAV_LAST', 'RZDBNAV_INSERT', 'RZDBNAV_DELETE',
      'RZDBNAV_EDIT', 'RZDBNAV_POST', 'RZDBNAV_CANCEL', 'RZDBNAV_REFRESH' );


{&RT}
{========================================}
{== TRzDBNavigatorImageIndexes Methods ==}
{========================================}

constructor TRzDBNavigatorImageIndexes.Create( Navigator: TRzDBNavigator );
begin
  inherited Create;

  FNavigator := Navigator;

  FFirst := -1;
  FPrevious := -1;
  FNext := -1;
  FLast := -1;
  FInsert := -1;
  FDelete := -1;
  FEdit := -1;
  FPost := -1;
  FCancel := -1;
  FRefresh := -1;
end;


function TRzDBNavigatorImageIndexes.GetImageIndex( Index: Integer ): TImageIndex;
begin
  Result := -1;
  case Index of
    0: Result := FFirst;
    1: Result := FPrevious;
    2: Result := FNext;
    3: Result := FLast;
    4: Result := FInsert;
    5: Result := FDelete;
    6: Result := FEdit;
    7: Result := FPost;
    8: Result := FCancel;
    9: Result := FRefresh;
  end;
end;


procedure TRzDBNavigatorImageIndexes.SetImageIndex( Index: Integer; Value: TImageIndex );
begin
  case Index of
    0: FFirst := Value;
    1: FPrevious := Value;
    2: FNext := Value;
    3: FLast := Value;
    4: FInsert := Value;
    5: FDelete := Value;
    6: FEdit := Value;
    7: FPost := Value;
    8: FCancel := Value;
    9: FRefresh := Value;
  end;
  FNavigator.UpdateImage( TNavigateBtn( Index ), Value );
end;

{============================}
{== TRzDBNavigator Methods ==}
{============================}

constructor TRzDBNavigator.Create( AOwner: TComponent );
var
  B: TNavigateBtn;
begin
  inherited;

  FImageIndexes := TRzDBNavigatorImageIndexes.Create( Self );
  {&RCI}
  FImagesChangeLink := TChangeLink.Create;
  FImagesChangeLink.OnChange := ImageListChange;

  Flat := True;

  for B := Low( TNavigateBtn ) to High( TNavigateBtn ) do
    Buttons[ B ].Glyph.LoadFromResourceName( HInstance, NavBmpNames[ B ] );
end;


procedure TRzDBNavigator.Loaded;
begin
  inherited;
  ImageListChange( nil );
end;


destructor TRzDBNavigator.Destroy;
begin
  FImagesChangeLink.Free;
  inherited;
end;


procedure TRzDBNavigator.Notification( AComponent: TComponent; Operation: TOperation );
begin
  inherited;

  if ( Operation = opRemove ) and ( AComponent = FImages ) then
    SetImages( nil );
end;


procedure TRzDBNavigator.SetImageIndexes( Value: TRzDBNavigatorImageIndexes );
begin
  {&RV}
  FImageIndexes.Assign( Value );
end;


procedure TRzDBNavigator.UpdateImage( Button: TNavigateBtn; ImageIndex: TImageIndex );
begin
  if ( ImageIndex = -1 ) or ( FImages = nil ) then
  begin
    // Reset glyph to image stored in resource
    Buttons[ Button ].Glyph.LoadFromResourceName( HInstance, NavBmpNames[ Button ] );
  end
  else
  begin
    Buttons[ Button ].NumGlyphs := 2;
    Buttons[ Button ].Glyph.Width := FImages.Width * 2;
    Buttons[ Button ].Glyph.Height := FImages.Height;
    Buttons[ Button ].Glyph.Canvas.Brush.Color := clFuchsia;
    Buttons[ Button ].Glyph.Canvas.FillRect( Rect( 0, 0, Buttons[ Button ].Glyph.Width, Buttons[ Button ].Glyph.Height ) );

    FImages.Draw( Buttons[ Button ].Glyph.Canvas, 0, 0, ImageIndex, True );
    FImages.Draw( Buttons[ Button ].Glyph.Canvas, FImages.Width, 0, ImageIndex, False );
  end;
end;


procedure TRzDBNavigator.SetImages( Value: TCustomImageList );
begin
  if FImages <> nil then
    FImages.UnRegisterChanges( FImagesChangeLink );

  FImages := Value;

  if FImages <> nil then
  begin
    FImages.RegisterChanges( FImagesChangeLink );
    FImages.FreeNotification( Self );
  end;
  Invalidate;
end;


procedure TRzDBNavigator.ImageListChange( Sender: TObject );
var
  B: TNavigateBtn;
begin
  for B := Low( TNavigateBtn ) to High( TNavigateBtn ) do
    UpdateImage( B, FImageIndexes.GetImageIndex( Ord( B ) ) );
end;


{&RUIF}
end.
