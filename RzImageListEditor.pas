{===============================================================================
  RzImageListEditor Unit

  Raize Components - Design Editor Source Unit


  Design Editors        Description
  ------------------------------------------------------------------------------
  TRzImageListEditor    Improved design-time editor for managing images in an
                          ImageList.


  Modification History
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Fixed problem where Add/Replace dialog boxes allowed user to select JPG,
      WMF, and EMF files, which are not valid for the ImageList Editor.
    * Fixed problem where transparent color of Icons loaded into the editor were
      not calculated correctly.
  ------------------------------------------------------------------------------
  3.0.5  (24 Mar 2003)
    * Fixed problem where TransparentColor and FillColor changes made to images
      were not being stored correctly when applied to the image list.
    * Fixed problem where Left and Top position of editor was not being restored
      correctly the next time the dialog box was invoked.
    * Added missing icon for editor window.
  ------------------------------------------------------------------------------
  3.0.3  (21 Jan 2003)
    * Fixed problem where reordering images and then deleting an image messed up
      the list order.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Initial release.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzImageListEditor;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Classes,
  Controls,
  Forms,
  Windows,
  {$IFDEF VCL60_OR_HIGHER}
  DesignIntf,
  DesignMenus,
  DesignEditors,
  VCLEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  Dialogs,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  ImgList,
  Graphics,
  RzDesignEditors,
  RzListVw,
  RzCmboBx,
  RzPanel,
  RzRadGrp,
  RzLabel,
  RzButton,
  RzStatus,
  Menus,
  ExtDlgs;

const
  ImageListEditorSection = 'ImageListEditor';

type
  {==========================================}
  {== TRzImageListEditor Class Declaration ==}
  {==========================================}

  TRzImageListEditor = class( TRzComponentEditor )
  protected
    function ImageList: TCustomImageList;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  TRzImageListEditDlg = class;

  TRzImageOperation = ( ioCrop, ioStretch, ioCenter );

  TRzImageInfo = class( TObject )
  private
    FAutoOp: Boolean;
    FOperation: TRzImageOperation;
    FOwner: TList;
    FOwnerForm: TRzImageListEditDlg;
    FCanChangeTransparent: Boolean;
    FCanChangeFill: Boolean;
    FBitmap: TBitmap;
    FMask: TBitmap;
    FNew: Boolean;
    FTransparentColor: TColor;
    FFillColor: TColor;

    procedure Center;
    procedure Crop;

    function GetIndex: Integer;

    procedure SetOperation( Value: TRzImageOperation );
    procedure SetFillColor( Value: TColor );
    procedure SetTransparentColor( Value: TColor );
    procedure Stretch;
  public
    constructor Create( AOwner: TList; AOwnerForm: TRzImageListEditDlg );
    destructor Destroy; override;

    procedure Change;
    procedure SelectImage;

    property Bitmap: TBitmap
      read FBitmap;

    property Mask: TBitmap
      read FMask;

    property New: Boolean
      read FNew;

    property CanChangeFill: Boolean
      read FCanChangeFill;

    property CanChangeTransparent: Boolean
      read FCanChangeTransparent;

    property FillColor: TColor
      read FFillColor
      write SetFillColor;

    property Index: Integer
      read GetIndex;

    property Operation: TRzImageOperation
      read FOperation
      write SetOperation;

    property Owner: TList
      read FOwner;

    property OwnerForm: TRzImageListEditDlg
      read FOwnerForm;

    property TransparentColor: TColor
      read FTransparentColor
      write SetTransparentColor;
  end;


  TRzImageListEditDlg = class( TForm )
    BtnOK: TRzButton;
    BtnCancel: TRzButton;
    GrpSelected: TRzGroupBox;
    PnlSelected: TRzPanel;
    ImgPreview: TImage;
    GrpOptions: TRzRadioGroup;
    BtnApply: TRzButton;
    CbxTransparentColor: TRzComboBox;
    LblTransparentColor: TRzLabel;
    LblFillColor: TRzLabel;
    CbxFillColor: TRzComboBox;
    GrpImages: TRzGroupBox;
    LvwImages: TRzListView;
    BtnAdd: TRzButton;
    BtnDelete: TRzButton;
    BtnClear: TRzButton;
    BtnExport: TRzButton;
    BtnReplace: TRzButton;
    DlgSavePicture: TSavePictureDialog;
    DlgColor: TColorDialog;
    DlgOpenPicture: TOpenPictureDialog;
    MnuListView: TPopupMenu;
    MnuBackgroundColor: TMenuItem;
    MnuSep1: TMenuItem;
    MnuRestoreBackgroundColor: TMenuItem;
    PnlDialogButtons: TRzPanel;
    PnlImages: TRzPanel;
    PnlSelectImage: TRzPanel;
    StatusBar: TRzStatusBar;
    StsHints: TRzStatusPane;
    PnlImageListButtons: TRzPanel;
    BtnSave: TRzButton;
    procedure BtnAddClick( Sender: TObject );
    procedure BtnDeleteClick( Sender: TObject );
    procedure BtnClearClick( Sender: TObject );
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure GrpOptionsClick( Sender: TObject );
    procedure BtnApplyClick( Sender: TObject );
    procedure CbxTransparentColorChange( Sender: TObject );
    procedure CbxTransparentColorExit( Sender: TObject );
    procedure LvwImagesKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
    procedure ImgPreviewMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
    procedure BtnExportClick( Sender: TObject );
    procedure LvwImagesSelectItem( Sender: TObject; Item: TListItem; Selected: Boolean );
    procedure ImgPreviewMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer );
    procedure LvwImagesEdited( Sender: TObject; Item: TListItem; var S: String );
    procedure LvwImagesDragOver( Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean );
    procedure LvwImagesDragDrop( Sender, Source: TObject; X, Y: Integer );
    procedure LvwImagesCompare( Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer );
    procedure BtnReplaceClick( Sender: TObject );
    procedure HintControlMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
    procedure MnuBackgroundColorClick( Sender: TObject );
    procedure MnuRestoreBackgroundColorClick( Sender: TObject );
    procedure BtnSaveClick(Sender: TObject);
  private
    FChanging: Boolean;
    FDeleting: Boolean;
    FSelecting: Boolean;
    FComponentList: TImageList;
    FInfoList: TList;
    FImageList, FListViewImageList: TImageList;
    FImageBitmap: TBitmap;
    FDragImageList: TImageList;
    FImageXDivOffset: Integer;
    FImageYDivOffset: Integer;
    procedure AddColor( const S: string );
    procedure ClearBitmap( Value: TBitmap; Color: TColor );
    procedure ClearAllImages;
    procedure ClearWithFill( Bitmap: TBitmap; Index: Integer );
    procedure DeleteSelectedImages;
    procedure FocusImage( Index, Count: Integer );
    function GetImageInfo( Index: Integer ): TRzImageInfo;
    function GetIndex: Integer;
    procedure MoveImage( FromIndex, ToIndex: Integer );
    procedure Replace( Index: Integer; Image, Mask: TBitmap );
    procedure ReplaceMasked( Index: Integer; NewImage: TBitmap; MaskColor: TColor );
    procedure SeTRzImageOperation( Operation: TRzImageOperation );
    procedure SetImageColor( Color: TColor; Fill: Boolean );
    function UpdateStatus: Boolean;
    procedure StretchImageList( SrcList, DstList: TImageList; Width, Height: Integer );
    procedure CenterImageList( SrcList, DstList: TImageList; Width, Height: Integer );
    procedure UpdateListView;
    procedure StretchReplace( List: TImageList; Index: Integer; Image, Mask: TBitmap );
    procedure StretchReplaceMasked( List: TImageList; Index: Integer; Image: TBitmap; MaskColor: TColor );
    procedure CenterReplace( List: TImageList; Index: Integer; Image, Mask: TBitmap );
    procedure CenterReplaceMasked( List: TImageList; Index: Integer; Image: TBitmap; MaskColor: TColor );
    procedure DoListViewImageListChange( Sender: TObject );
    procedure UpdatePickColor( X, Y: Integer );
    procedure LoadSettings;
    procedure SaveSettings;
  public
    constructor CreateImgListEditor( AOwner: TComponent; AImgList: TImageList );

    procedure AddBitmap;
    procedure Center( Index: Integer );
    procedure Crop( Index: Integer );
    procedure SelectImage( Index: Integer );
    procedure Stretch( Index: Integer );

    property DragImageList: TImageList
      read FDragImageList
      write FDragImageList;

    property ImageBitmap: TBitmap
      read FImageBitmap;

    property Index: Integer
      read GetIndex;

    property InfoList: TList
      read FInfoList;

    property ImageList: TImageList
      read FImageList;

    property ListViewImageList: TImageList
      read FListViewImageList;

    property Items[ Index: Integer ]: TRzImageInfo
      read GetImageInfo;

    property ComponentList: TImageList
      read FComponentList;
  end;


function EditImageList( AImageList: TImageList ): Boolean;

implementation

{$R *.dfm}

uses
  CommCtrl,
  DsnConst,
  Registry,
  RzSelectImageEditor,
  SysUtils;


{=====================}
{== Support Methods ==}
{=====================}

procedure GetImages( ImageList: TImageList; Index: Integer; Image, Mask: TBitmap );
var
  R: TRect;
begin
  with ImageList do
  begin
    R := Rect( 0, 0, Width, Height );
    Image.Width := Width;
    Image.Height := Height;
    Mask.Width := Width;
    Mask.Height := Height;
  end;
  with Image.Canvas do
  begin
    Brush.Color := clWhite;
    FillRect( R );
    ImageList.Draw( Image.Canvas, 0, 0, Index );
  end;
  with Mask.Canvas do
  begin
    Brush.Color := clWhite;
    FillRect( R );
    {$IFDEF VCL60_OR_HIGHER}
    ImageList.Draw( Mask.Canvas, 0, 0, Index, dsNormal, itMask );
    {$ELSE}
    ImageList.ImageType := itMask;
    ImageList.Draw( Mask.Canvas, 0, 0, Index );
    ImageList.ImageType := itImage;
    {$ENDIF}
  end;
end;


function EditImageList( AImageList: TImageList ): Boolean;
var
  I: Integer;
  Dlg: TRzImageListEditDlg;
  OwnerName: string;
begin
  Dlg := TRzImageListEditDlg.CreateImgListEditor( Application, AImageList );
  try
    Screen.Cursor := crHourglass;
    try
      if AImageList.Width = 0 then
        Dlg.FImageXDivOffset := 1
      else
        Dlg.FImageXDivOffset := Dlg.ImgPreview.Width div AImageList.Width;

      if AImageList.Height = 0 then
        Dlg.FImageYDivOffset := 1
      else
        Dlg.FImageYDivOffset := Dlg.ImgPreview.Height div AImageList.Height;

      if Dlg.FImageXDivOffset = 0 then
        Dlg.FImageXDivOffset := 1;

      if Dlg.FImageYDivOffset = 0 then
        Dlg.FImageYDivOffset := 1;

      Dlg.FComponentList := AImageList;
      Dlg.FImageList.Assign( Dlg.ComponentList );

      Dlg.FListViewImageList.Assign( Dlg.FImageList );
      if ( Dlg.FListViewImageList.Width > 32 ) or ( Dlg.FListViewImageList.Height > 32 ) then
        Dlg.StretchImageList( Dlg.FImageList, Dlg.FListViewImageList, 32, 32 )
      else if ( Dlg.FListViewImageList.Width < 32 ) and ( Dlg.FListViewImageList.Height < 32 ) then
        Dlg.CenterImageList( Dlg.FImageList, Dlg.FListViewImageList, 32, 32 );

      Dlg.ImageList.Clear;
      Dlg.ImageBitmap.Height := Dlg.ImageList.Height;
      Dlg.ImageBitmap.Width := Dlg.ImageList.Width;

      for I := 0 to Dlg.ComponentList.Count - 1 do
      begin
        with TRzImageInfo.Create( Dlg.InfoList, Dlg ) do
        begin
          FNew := False;
          FAutoOp := False;
          GetImages( Dlg.ComponentList, I, FBitmap, FMask );
          TransparentColor := clDefault;
          Change;
        end;
      end;

      if Dlg.UpdateStatus then
        Dlg.ActiveControl := Dlg.LvwImages
      else
        Dlg.ActiveControl := Dlg.BtnAdd;

      Dlg.UpdateListView;
      Dlg.SelectImage( 0 );
      Dlg.FocusImage( 0, 0 );
      Dlg.BtnApply.Enabled := False;
    finally
      Screen.Cursor := crDefault;
    end;

    if AImageList.Owner <> nil then
      OwnerName := AImageList.Owner.Name + '.'
    else
      OwnerName := '';
    Dlg.Caption := OwnerName + AImageList.Name + Dlg.Caption;

    Result := Dlg.ShowModal = mrOk;

    if Result and Dlg.BtnApply.Enabled then
      Dlg.BtnApplyClick( nil );
  finally
    Dlg.Free;
  end;
end; {= EditImageList =}



{================================}
{== TRzImageListEditor Methods ==}
{================================}

function TRzImageListEditor.ImageList: TCustomImageList;
begin
  Result := Component as TCustomImageList;
end;


function TRzImageListEditor.GetVerbCount: Integer;
begin
  Result := 5;
end;


function TRzImageListEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Edit ImageList...';
    1: Result := 'Select Images...';
    2: Result := '-';
    3: Result := '16 x 16 Images';
    4: Result := '32 x 32 Images';
  end;
end;


function TRzImageListEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_IMAGELIST';
    1: Result := 'RZDESIGNEDITORS_SELECT_IMAGE';
  end;
end;


procedure TRzImageListEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    3: Item.Checked := ( ImageList.Width = 16 ) and ( ImageList.Height = 16 );
    4: Item.Checked := ( ImageList.Width = 32 ) and ( ImageList.Height = 32 );
  end;
end;


procedure TRzImageListEditor.ExecuteVerb( Index: Integer );
var
  SelDlg: TRzSelectImageEditDlg;
  OwnerName: string;
begin
  case Index of
    0:
    begin
      if EditImageList( Component as TImageList ) and Assigned( Designer ) then
        Designer.Modified;
    end;

    1:
    begin
      // Display Select Images Editor...
      SelDlg := TRzSelectImageEditDlg.Create( Application );
      try
        if Component.Owner <> nil then
          OwnerName := Component.Owner.Name + '.'
        else
          OwnerName := '';
        SelDlg.Caption := OwnerName + Component.Name + SelDlg.Caption;
        SelDlg.CompOwner := Designer.GetRoot;
        SelDlg.SetObject( TControl( Component ), False );
        SelDlg.UpdateControls;
        SelDlg.Reposition;
        SelDlg.ShowModal;
        Designer.Modified;
      finally
        SelDlg.Free;
      end;
    end;

    3:
    begin
      ImageList.Width := 16;
      ImageList.Height := 16;
      Designer.Modified;
    end;

    4:
    begin
      ImageList.Width := 32;
      ImageList.Height := 32;
      Designer.Modified;
    end;
  end;
end;


{==========================}
{== TRzImageInfo Methods ==}
{==========================}

constructor TRzImageInfo.Create( AOwner: TList; AOwnerForm: TRzImageListEditDlg );
begin
  inherited Create;
  FOwner := AOwner;
  FOwnerForm := AOwnerForm;
  Owner.Add( Self );
  FBitmap := TBitmap.Create;
  FMask := TBitmap.Create;
  FNew := True;
  FAutoOp := True;
  OwnerForm.AddBitmap;
  FTransparentColor := clNone;
  FFillColor := clBtnFace;
end;


destructor TRzImageInfo.Destroy;
begin
  Owner.Remove( Self );
  FOwner := nil;
  FMask.Free;
  FBitmap.Free;
  inherited;
end;


function TRzImageInfo.GetIndex: Integer;
begin
  Result := Owner.IndexOf( Self );
end;


procedure TRzImageInfo.Crop;
begin
  OwnerForm.Crop( Index );
end;


procedure TRzImageInfo.Stretch;
begin
  OwnerForm.Stretch( Index );
end;


procedure TRzImageInfo.Center;
begin
  OwnerForm.Center( Index );
end;


procedure TRzImageInfo.SelectImage;
begin
  OwnerForm.SelectImage( Index );
end;


procedure TRzImageInfo.SetOperation( Value: TRzImageOperation );
begin
  if Value <> Operation then
  begin
    FOperation := Value;
    Change;
  end;
end;


procedure TRzImageInfo.SetTransparentColor( Value: TColor );
begin
  if Value <> TransparentColor then
  begin
    FTransparentColor := Value;
    Change;
  end;
end;


procedure TRzImageInfo.SetFillColor( Value: TColor );
begin
  if Value <> FillColor then
  begin
    FFillColor := Value;
    Change;
  end;
end;


procedure TRzImageInfo.Change;
begin
  if not FOwnerForm.FChanging then
  begin
    FOwnerForm.FChanging := True;
    try
      if FAutoOp then
      begin
        if ( Bitmap.Width < FOwnerForm.ImageBitmap.Width ) and ( Bitmap.Height < FOwnerForm.ImageBitmap.Height ) then
          FOperation := ioCenter
        else if ( Bitmap.Width > FOwnerForm.ImageBitmap.Width ) or ( Bitmap.Height > FOwnerForm.ImageBitmap.Height ) then
          FOperation := ioStretch
        else
          FOperation := ioCrop;
        FFillColor := FTransparentColor;
        FAutoOp := False;
      end;
      case Operation of
        ioCrop: Crop;
        ioStretch: Stretch;
        ioCenter: Center;
      end;
    finally
      FOwnerForm.FChanging := False;
    end;
  end;
end;


{=================================}
{== TRzImageListEditDlg2 Methods ==}
{=================================}

constructor TRzImageListEditDlg.CreateImgListEditor( AOwner: TComponent; AImgList: TImageList );
begin
  FComponentList := AImgList; // This must be before the call to inherited
  inherited Create( AOwner );
end;


procedure TRzImageListEditDlg.FormCreate( Sender: TObject );
begin
  Icon.Handle := LoadIcon( HInstance, 'RZDESIGNEDITORS_IMAGELIST_ICON' );

  FImageBitmap := TBitmap.Create;
  FInfoList := TList.Create;
  FImageList := TImageList.CreateSize( FComponentList.Width, FComponentList.Height );
  FListViewImageList := TImageList.CreateSize( 32, 32 );

  GetColorValues( AddColor );
  CbxTransparentColor.ItemIndex := -1;
  CbxFillColor.ItemIndex := -1;

  ClearBitmap( ImageBitmap, clBtnHighlight );
  LvwImages.LargeImages := FListViewImageList;
  FListViewImageList.OnChange := DoListViewImageListChange;

  LoadSettings;
end;


procedure TRzImageListEditDlg.FormDestroy( Sender: TObject );
begin
  SaveSettings;

  while FInfoList.Count > 0 do
    TRzImageInfo( FInfoList.Last ).Free;
  FImageList.Free;
  FListViewImageList.Free;
  FImageBitmap.Free;
end;


procedure TRzImageListEditDlg.LoadSettings;
var
  R: TRegIniFile;
begin
  // Load size of form and state of word wrap
  R := TRegIniFile.Create( RC_SettingsKey );
  try
    Width := R.ReadInteger( ImageListEditorSection, 'Width', Constraints.MinWidth );
    Height := R.ReadInteger( ImageListEditorSection, 'Height', Constraints.MinHeight );
    Left := R.ReadInteger( ImageListEditorSection, 'Left', ( Screen.Width - Width ) div 2 );
    Top := R.ReadInteger( ImageListEditorSection, 'Top', ( Screen.Height - Height ) div 2 );

    LvwImages.Color := R.ReadInteger( ImageListEditorSection, 'ListViewColor', clWindow );
  finally
    R.Free;
  end;
end;


procedure TRzImageListEditDlg.SaveSettings;
var
  R: TRegIniFile;
begin
  // Store size of form and state of Word Wrap
  R := TRegIniFile.Create( RC_SettingsKey );
  try
    R.WriteInteger( ImageListEditorSection, 'Width', Width );
    R.WriteInteger( ImageListEditorSection, 'Height', Height );
    R.WriteInteger( ImageListEditorSection, 'Left', Left );
    R.WriteInteger( ImageListEditorSection, 'Top', Top );
    R.WriteInteger( ImageListEditorSection, 'ListViewColor', LvwImages.Color );
  finally
    R.Free;
  end;
end;


function TRzImageListEditDlg.UpdateStatus: Boolean;
begin
  Result := InfoList.Count > 0;
  BtnDelete.Enabled := Result;
  BtnClear.Enabled := Result;
  BtnExport.Enabled := Result;
  BtnSave.Enabled := Result;
  GrpOptions.Enabled := Result;
  CbxTransparentColor.Enabled := Result;
  LblTransparentColor.Enabled := Result;
  CbxFillColor.Enabled := Result;
  LblFillColor.Enabled := Result;
end;


procedure TRzImageListEditDlg.UpdateListView;
const
  NewState: array[ Boolean ] of Integer = ( -1, 0 );
var
  I: Integer;
  S: string;
  Items: TListItems;
begin
  if not FSelecting then
  begin
    FSelecting := True;
    try
      Items := LvwImages.Items;
      Items.BeginUpdate;
      try
        for I := 0 to FInfoList.Count - 1 do
        begin
          S := IntToStr( I );
          if Items.Count <= I then
          begin
            { Add }
            with Items.Add do
            begin
              Caption := S;
              ImageIndex := I;
            end;
          end
          else
          begin
            { Update }
            Items[ I ].Caption := S;
            Items[ I ].ImageIndex := I;
          end;
        end;
        while Items.Count > FInfoList.Count do
          Items[ Items.Count - 1 ].Free;
      finally
        Items.EndUpdate;
      end;
    finally
      FSelecting := False;
    end;
  end;
end;


procedure TRzImageListEditDlg.AddBitmap;
begin
  ImageList.Add( nil, nil );
  ListViewImageList.Add( nil, nil );
end;


procedure TRzImageListEditDlg.BtnAddClick( Sender: TObject );
var
  Modified: Boolean;
  Picture: TPicture;
  I, X, Y: Integer;
  IWidth, IHeight: Integer;
  NewBitmaps: TList;
  NewBitmap, NewBitmap1: TBitmap;
  SubDivideX, SubDivideY: Boolean;
  DivideX, DivideY: Integer;
  DialogResult: TModalResult;
  AddCount: Integer;
begin
  if DlgOpenPicture.Execute then
  begin
    Modified := False;
    Picture := TPicture.Create;
    NewBitmaps := TList.Create;
    NewBitmap := TBitmap.Create;
    { Add at least one bitmap and mask }
    NewBitmaps.Add( NewBitmap );
    AddCount := 0;
    Screen.Cursor := crHourglass;
    try
      DialogResult := mrYes;
      LvwImages.Selected := nil;
      for I := 0 to DlgOpenPicture.Files.Count - 1 do
      begin
        Picture.LoadFromFile( DlgOpenPicture.Files[ I ] );
        if Picture.Graphic is TIcon then
        begin
          NewBitmap1 := TBitmap.Create;
          try
            NewBitmap1.Width := Picture.Width;
            NewBitmap1.Height := Picture.Height;
            // Use clLime as a background for Icon image.
            // clLime will be picked as transparent color when image is selected in editor.
            NewBitmap1.Canvas.Brush.Color := clLime;
            NewBitmap1.Canvas.FillRect( Rect( 0, 0, Picture.Width, Picture.Height ) );
            NewBitmap1.Canvas.Draw( 0, 0, Picture.Graphic );
            Picture.Bitmap.Assign( NewBitmap1 );
          finally
            FreeAndNil( NewBitmap1 );
          end;
        end;

        IWidth := ImageBitmap.Width;
        IHeight := ImageBitmap.Height;

        if Picture.Graphic is TBitmap then
        begin
          { Find out if the new image is a list of bitmaps to be extracted }
          SubDivideX := ( Picture.Graphic.Width > IWidth ) and
            ( Picture.Graphic.Width mod IWidth = 0 );
          SubDivideY := ( Picture.Graphic.Height > IHeight ) and
            ( Picture.Graphic.Height mod IHeight = 0 );
          if SubDivideX then
            DivideX := Picture.Graphic.Width div IWidth
          else
            DivideX := 1;
          if SubDivideY then
            DivideY := Picture.Graphic.Height div IHeight
          else
            DivideY := 1;

          if SubDivideX or SubDivideY then
          begin
            if not ( DialogResult in [ mrNoToAll, mrYesToAll ] ) then
            begin
              DialogResult := MessageDlg( Format( SImageListDivide,
                                                  [ ExtractFileName( DlgOpenPicture.Files[ I ] ), DivideX * DivideY ] ),
                                          mtInformation, [ mbYes, mbNo ], 0 );
            end;
          end
          else if DialogResult = mrYes then
            DialogResult := mrNo;

          if DialogResult in [ mrNo, mrNoToAll ] then
          begin
            DivideX := 1;
            DivideY := 1;
            IWidth := Picture.Bitmap.Width;
            IHeight := Picture.Bitmap.Height;
          end;

          if DivideX * DivideY > NewBitmaps.Capacity then
            NewBitmaps.Capacity := DivideX * DivideY;
          for Y := 0 to DivideY - 1 do
            for X := 0 to DivideX - 1 do
            begin
              { Add new bitmap if necessary }
              if NewBitmaps.Count <= ( Y * DivideX + X ) then
              begin
                NewBitmap := TBitmap.Create;
                NewBitmaps.Add( NewBitmap );
              end
              else
                NewBitmap := TBitmap( NewBitmaps[ Y * DivideX + X ] );
              NewBitmap.Assign( Nil );
              NewBitmap.Height := IHeight;
              NewBitmap.Width := IWidth;
              NewBitmap.Canvas.CopyRect( Rect( 0, 0, NewBitmap.Width,
                NewBitmap.Height ), Picture.Bitmap.Canvas,
                Rect( X * IWidth, Y * IHeight, ( X + 1 ) * IWidth,
                ( Y + 1 ) * IHeight ) );
            end;
          for X := 0 to DivideX * DivideY - 1 do
            with TRzImageInfo.Create( InfoList, Self ) do
            try
              NewBitmap := TBitmap( NewBitmaps[ X ] );
              FChanging := True;
              try
                FCanChangeTransparent := True;
                FCanChangeFill := ( NewBitmap.Height < ImageList.Height ) or
                  ( NewBitmap.Width < ImageList.Width );
                TransparentColor := NewBitmap.TransparentColor;
                Bitmap.Assign( NewBitmap );
                Mask.Assign( nil );
              finally
                FChanging := False;
                Change;
              end;
              Inc( AddCount );
            except
              Free;
              raise;
            end;
        end
        else
          raise EInvalidGraphic.Create( SImageListGraphicUnsupported );
        Modified := True;
      end; { for }
    finally
      Screen.Cursor := crDefault;
      for I := 0 to NewBitmaps.Count - 1 do TBitmap( NewBitmaps[ I ] ).Free;
      NewBitmaps.Free;
      Picture.Free;
      if Modified then
      begin
        UpdateStatus;
        UpdateListView;
        SelectImage( InfoList.Count - 1 );
        FocusImage( InfoList.Count - 1, AddCount );
        LvwImages.Arrange( arSnapToGrid );
        BtnApply.Enabled := True;
      end;
    end;
  end;
end;


procedure TRzImageListEditDlg.BtnReplaceClick( Sender: TObject );
var
  Modified: Boolean;
  Picture: TPicture;
  I, X, Y: Integer;
  IWidth, IHeight: Integer;
  NewBitmaps: TList;
  NewBitmap, NewBitmap1: TBitmap;
  SubDivideX, SubDivideY: Boolean;
  DivideX, DivideY: Integer;
  DialogResult: TModalResult;
  Start, Stop, Idx, AddCount: Integer;
begin
  if LvwImages.SelCount = 0 then
  begin
    // Nothing selected, treat it just like an Add
    BtnAddClick( Sender );
  end
  else
  begin
    if DlgOpenPicture.Execute then
    begin
      // Record first selected index
      Idx := LvwImages.Selected.Index;

      // Delete currently selected images
      BtnDeleteClick( Sender );

      // Add new Images

      Modified := False;
      Picture := TPicture.Create;
      NewBitmaps := TList.Create;
      NewBitmap := TBitmap.Create;
      { Add at least one bitmap and mask }
      NewBitmaps.Add( NewBitmap );
      AddCount := 0;

      Start := 0;
      Stop := 0;

      Screen.Cursor := crHourglass;
      try
        DialogResult := mrYes;
        LvwImages.Selected := nil;
        for I := 0 to DlgOpenPicture.Files.Count - 1 do
        begin
          Picture.LoadFromFile( DlgOpenPicture.Files[ I ] );
          if Picture.Graphic is TIcon then
          begin
            NewBitmap1 := TBitmap.Create;
            try
//              NewBitmap1.Assign( Picture.Graphic );

              NewBitmap1.Width := Picture.Width;
              NewBitmap1.Height := Picture.Height;
              NewBitmap1.Canvas.Draw( 0, 0, Picture.Graphic );
//              Picture.Bitmap.Canvas.StretchDraw( Rect( 0, 0, Picture.Width, Picture.Height ), NewBitmap1 );


              Picture.Bitmap.Assign( NewBitmap1 );
            finally
              FreeAndNil( NewBitmap1 );
            end;
          end;

          IWidth := ImageBitmap.Width;
          IHeight := ImageBitmap.Height;

          if Picture.Graphic is TBitmap then
          begin
            { Find out if the new image is a list of bitmaps to be extracted }
            SubDivideX := ( Picture.Graphic.Width > IWidth ) and ( Picture.Graphic.Width mod IWidth = 0 );
            SubDivideY := ( Picture.Graphic.Height > IHeight ) and ( Picture.Graphic.Height mod IHeight = 0 );
            if SubDivideX then
              DivideX := Picture.Graphic.Width div IWidth
            else
              DivideX := 1;
            if SubDivideY then
              DivideY := Picture.Graphic.Height div IHeight
            else
              DivideY := 1;

            if SubDivideX or SubDivideY then
            begin
              if not ( DialogResult in [ mrNoToAll, mrYesToAll ] ) then
                DialogResult := MessageDlg( Format( SImageListDivide,
                                                    [ ExtractFileName( DlgOpenPicture.Files[ I ] ), DivideX * DivideY ] ), mtInformation,
                                            [ mbYes, mbNo ], 0 );
            end
            else if DialogResult = mrYes then
              DialogResult := mrNo;

            if DialogResult in [ mrNo, mrNoToAll ] then
            begin
              DivideX := 1;
              DivideY := 1;
              IWidth := Picture.Bitmap.Width;
              IHeight := Picture.Bitmap.Height;
            end;

            if DivideX * DivideY > NewBitmaps.Capacity then
              NewBitmaps.Capacity := DivideX * DivideY;

            for Y := 0 to DivideY - 1 do
            begin
              for X := 0 to DivideX - 1 do
              begin
                { Add new bitmap if necessary }
                if NewBitmaps.Count <= ( Y * DivideX + X ) then
                begin
                  NewBitmap := TBitmap.Create;
                  NewBitmaps.Add( NewBitmap );
                end
                else
                  NewBitmap := TBitmap( NewBitmaps[ Y * DivideX + X ] );
                NewBitmap.Assign( Nil );
                NewBitmap.Height := IHeight;
                NewBitmap.Width := IWidth;
                NewBitmap.Canvas.CopyRect( Rect( 0, 0, NewBitmap.Width, NewBitmap.Height ), Picture.Bitmap.Canvas,
                                           Rect( X * IWidth, Y * IHeight, ( X + 1 ) * IWidth, ( Y + 1 ) * IHeight ) );
              end;
            end;

            for X := 0 to DivideX * DivideY - 1 do
            begin
              with TRzImageInfo.Create( InfoList, Self ) do
              try
                NewBitmap := TBitmap( NewBitmaps[ X ] );
                FChanging := True;
                try
                  FCanChangeTransparent := True;
                  FCanChangeFill := ( NewBitmap.Height < ImageList.Height ) or ( NewBitmap.Width < ImageList.Width );
                  TransparentColor := NewBitmap.TransparentColor;
                  Bitmap.Assign( NewBitmap );
                  Mask.Assign( nil );
                finally
                  FChanging := False;
                  Change;
                end;
                Inc( AddCount );
              except
                Free;
                raise;
              end;
            end;
          end
          else
            raise EInvalidGraphic.Create( SImageListGraphicUnsupported );
          Modified := True;
        end; { for }

        Start := FInfoList.Count - NewBitmaps.Count;
        Stop := FInfoList.Count - 1;

      finally
        Screen.Cursor := crDefault;
        for I := 0 to NewBitmaps.Count - 1 do
          TBitmap( NewBitmaps[ I ] ).Free;
        NewBitmaps.Free;
        Picture.Free;
        if Modified then
        begin
          UpdateStatus;
          UpdateListView;
          SelectImage( InfoList.Count - 1 );
          FocusImage( InfoList.Count - 1, AddCount );
          LvwImages.Arrange( arSnapToGrid );
          BtnApply.Enabled := True;
        end;
      end;

      // Move newly added images to their correct location

      for I := Start to Stop do
        MoveImage( I, Idx + ( I - Start ) );
    end;
  end;
end;



procedure TRzImageListEditDlg.BtnDeleteClick( Sender: TObject );
begin
  DeleteSelectedImages;
  SelectImage( Index );
  if not UpdateStatus then
    BtnAdd.SetFocus;
  BtnApply.Enabled := True;
end;


procedure TRzImageListEditDlg.BtnClearClick( Sender: TObject );
begin
  ClearAllImages;
  SelectImage( -1 );
  if not UpdateStatus then
    BtnAdd.SetFocus;
  BtnApply.Enabled := True;
end;


procedure TRzImageListEditDlg.AddColor( const S: string );
begin
  CbxTransparentColor.Items.Add( S );
  CbxFillColor.Items.Add( S );
end;


procedure TRzImageListEditDlg.SelectImage( Index: Integer );
var
  S: string;
begin
  if not FSelecting then
  begin
    FSelecting := True;
    try
      if ( Index >= 0 ) and ( InfoList.Count > 0 ) and ( Index < InfoList.Count ) then
      begin
        GrpOptions.ItemIndex := Ord( Items[ Index ].Operation );
        if not Items[ Index ].New then
        begin
          S := ColorToString( clNone );
          CbxTransparentColor.Text := S;
          CbxFillColor.Text := S;
          CbxFillColor.Enabled := False;
          LblFillColor.Enabled := False;
          GrpOptions.Enabled := False;
          CbxTransparentColor.Enabled := False;
          LblTransparentColor.Enabled := False;
          ImgPreview.Cursor := crDefault;
        end
        else
        begin
          CbxTransparentColor.Text := ColorToString( Items[ Index ].TransparentColor );
          CbxFillColor.Text := ColorToString( Items[ Index ].FillColor );
          CbxFillColor.Enabled := Items[ Index ].CanChangeFill;
          LblFillColor.Enabled := CbxFillColor.Enabled;
          GrpOptions.Enabled := Items[ Index ].CanChangeTransparent;
          CbxTransparentColor.Enabled := GrpOptions.Enabled;
          LblTransparentColor.Enabled := GrpOptions.Enabled;
        end;

        FImageBitmap.Assign( nil );
        ImageList.GetBitmap( Index, FImageBitmap );
        ImgPreview.Picture.Assign( nil );
        ImageList.GetBitmap( Index, ImgPreview.Picture.Bitmap );
      end
      else
      begin
        GrpOptions.ItemIndex := 0;
        ClearWithFill( ImageBitmap, -1 );
        ImgPreview.Picture.Assign( nil );
        ImgPreview.Cursor := crDefault;
      end;
    finally
      FSelecting := False;
    end;
  end;
end; {= TRzImageListEditDlg2.SelectImage =}


procedure TRzImageListEditDlg.ClearWithFill( Bitmap: TBitmap; Index: Integer );
begin
  if ( Index >= 0 ) and ( InfoList.Count > 0 ) and ( Index < InfoList.Count ) then
    ClearBitmap( Bitmap, Items[ Index ].FillColor )
  else
    ClearBitmap( Bitmap, clBtnHighlight );
end;


function TRzImageListEditDlg.GetIndex: Integer;
var
  ListItem: TListItem;
begin
  ListItem := LvwImages.Selected;
  if ListItem <> nil then
    Result := ListItem.Index
  else
    Result := -1;
end;


function TRzImageListEditDlg.GetImageInfo( Index: Integer ): TRzImageInfo;
begin
  Result := FInfoList[ Index ];
end;


procedure TRzImageListEditDlg.Crop( Index: Integer );
var
  MaxX, MaxY: Integer;
  R: TRect;
begin
  MaxX := ImageBitmap.Width;
  MaxY := ImageBitmap.Height;

  if Items[ Index ].Bitmap.Width < MaxX then
    MaxX := Items[ Index ].Bitmap.Width;

  if Items[ Index ].Bitmap.Height < MaxY then
    MaxY := Items[ Index ].Bitmap.Height;

  R := Rect( 0, 0, MaxX, MaxY );
  ClearWithFill( ImageBitmap, Index );
  ImgPreview.Picture.Assign( nil );
  ImageBitmap.Canvas.CopyRect( R, Items[ Index ].Bitmap.Canvas, R );
  if Items[ Index ].New and Items[ Index ].Mask.Empty then
  begin
    if Items[ Index ].TransparentColor = clNone then
      Replace( Index, ImageBitmap, nil )
    else
      ReplaceMasked( Index, ImageBitmap, ColorToRGB( Items[ Index ].TransparentColor ) );
  end
  else
    Replace( Index, ImageBitmap, Items[ Index ].Mask );

  BtnApply.Enabled := True;
end;


procedure TRzImageListEditDlg.Stretch( Index: Integer );
var
  ImageMask: TBitmap;
begin
  ImgPreview.Picture.Assign( nil );

//  with ImageBitmap, Items[ Index ] do
  begin
    ClearBitmap( ImageBitmap, Items[ Index ].FillColor );
    ImageBitmap.Canvas.StretchDraw( Rect( 0, 0, ImageBitmap.Width, ImageBitmap.Height ), Items[ Index ].Bitmap );
    if Items[ Index ].New and Items[ Index ].Mask.Empty then
    begin
      if Items[ Index ].TransparentColor = clNone then
        Replace( Index, ImageBitmap, nil )
      else
        ReplaceMasked( Index, ImageBitmap, ColorToRGB( Items[ Index ].TransparentColor ) );
    end
    else
    begin
      ImageMask := TBitmap.Create;
      ImageMask.Width := Width;
      ImageMask.Height := Height;
      ImageMask.Canvas.StretchDraw( Rect( 0, 0, Width, Height ), Items[ Index ].Mask );
      Replace( Index, ImageBitmap, ImageMask );
      ImageMask.Free;
    end;
  end;
  BtnApply.Enabled := True;
end;


procedure TRzImageListEditDlg.Center( Index: Integer );
var
  R: TRect;
  ImageMask: TBitmap;
begin
  ImgPreview.Picture.Assign( nil );

  with Items[ Index ] do
  begin
    R := Bounds( ( ImageBitmap.Width - Bitmap.Width ) div 2,
      ( ImageBitmap.Height - Bitmap.Height ) div 2, Bitmap.Width, Bitmap.Height );
    ClearBitmap( ImageBitmap, Items[ Index ].FillColor );
    ImageBitmap.Canvas.StretchDraw( R, Bitmap );
    if New and Mask.Empty then
      if Items[ Index ].TransparentColor = clNone then
        Replace( Index, ImageBitmap, nil )
      else
        ReplaceMasked( Index, ImageBitmap, ColorToRGB( TransparentColor ) )
    else
    begin
      ImageMask := TBitmap.Create;
      ImageMask.Width := Width;
      ImageMask.Height := Height;
      ImageMask.Canvas.StretchDraw( Rect( 0, 0, Width, Height ), Mask );
      Replace( Index, ImageBitmap, ImageMask );
      ImageMask.Free;
    end;
  end;
  BtnApply.Enabled := True;
end;


procedure TRzImageListEditDlg.GrpOptionsClick( Sender: TObject );
begin
  if not ( FChanging or FSelecting ) then
    SeTRzImageOperation( TRzImageOperation( GrpOptions.ItemIndex ) );
end;


procedure TRzImageListEditDlg.BtnApplyClick( Sender: TObject );
var
  TempImageList: TImageList;
begin
  Screen.Cursor := crHourglass;
  try
    TempImageList := TImageList.Create( Application );
    TempImageList.Assign( ImageList );
    ComponentList.Assign( TempImageList );
    TempImageList.Free;
    BtnApply.Enabled := False;
  finally
    Screen.Cursor := crDefault;
  end;
end;


procedure TRzImageListEditDlg.CbxTransparentColorChange( Sender: TObject );
begin
  if not ( FChanging or FSelecting ) and ( Sender is TRzComboBox ) then
  begin
    if TRzComboBox( Sender ).Items.IndexOf( TRzComboBox( Sender ).Text ) <> -1 then
      SetImageColor( StringToColor( TRzComboBox( Sender ).Text ), Sender = CbxFillColor );
  end;
end;


procedure TRzImageListEditDlg.ClearBitmap( Value: TBitmap; Color: TColor );
begin
  if ( Value.Width > 0 ) and ( Value.Height > 0 ) then
  begin
    Value.Canvas.Brush.Color := Color;
    Value.Canvas.Brush.Style := bsSolid;
    Value.Canvas.FillRect( Rect( 0, 0, Value.Width, Value.Height ) );
  end;
end;


procedure TRzImageListEditDlg.CbxTransparentColorExit( Sender: TObject );
var
  Color: TColor;
begin
  if Sender is TRzComboBox then
  begin
    Color := StringToColor( TRzComboBox( Sender ).Text );
    SetImageColor( Color, Sender = CbxFillColor );
  end;
end;


procedure TRzImageListEditDlg.Replace( Index: Integer; Image, Mask: TBitmap );
begin
  ImageList.Replace( Index, Image, Mask );
  // adjust if necessary
  with FListViewImageList do
    if ( Image.Width > Width ) or ( Image.Height > Height ) then
      StretchReplace( FListViewImageList, Index, Image, Mask )
    else if ( Image.Width < Width ) and ( Image.Height < Height ) then
      CenterReplace( FListViewImageList, Index, Image, Mask )
    else FListViewImageList.Replace( Index, Image, Mask );
end;


procedure TRzImageListEditDlg.ReplaceMasked( Index: Integer; NewImage: TBitmap; MaskColor: TColor );
begin
  ImageList.ReplaceMasked( Index, NewImage, MaskColor );
  // adjust if necessary
  with FListViewImageList do
    if ( NewImage.Width > Width ) or ( NewImage.Height > Height ) then
      StretchReplaceMasked( FListViewImageList, Index, NewImage, MaskColor )
    else if ( NewImage.Width < Width ) and ( NewImage.Height < Height ) then
      CenterReplaceMasked( FListViewImageList, Index, NewImage, MaskColor )
    else
      FListViewImageList.ReplaceMasked( Index, NewImage, MaskColor );
end;


procedure TRzImageListEditDlg.DeleteSelectedImages;
var
  Item: TListItem;
  I: Integer;
begin
  Screen.Cursor := crHourglass;
  FDeleting := True;
  try
    Item := LvwImages.Selected;
    if Item <> nil then
    begin
      ImageList.Delete( Item.Index );
      ListViewImageList.Delete( Item.Index );
      TRzImageInfo( InfoList[ Item.Index ] ).Free;
      Item.Free;
    end;
    I := 0;
    while I < LvwImages.Items.Count do
    begin
      Item := LvwImages.Items[ I ];
      if Item.Selected then
      begin
        ImageList.Delete( Item.Index );
        ListViewImageList.Delete( Item.Index );
        TRzImageInfo( InfoList[ Item.Index ] ).Free;
        Item.Free;
      end
      else
        Inc( I );
    end;
    UpdateListView;
  finally
    FDeleting := False;
    Screen.Cursor := crDefault;
  end;
end;


procedure TRzImageListEditDlg.ClearAllImages;
begin
  Screen.Cursor := crHourglass;
  try
    LvwImages.Items.Clear;
    ImageList.Clear;
    ListViewImageList.Clear;
    while InfoList.Count > 0 do
      TRzImageInfo( InfoList[ 0 ] ).Free;
  finally
    Screen.Cursor := crDefault;
  end;
end;


procedure TRzImageListEditDlg.FocusImage( Index, Count: Integer );
var
  Item: TListItem;
  I: Integer;
begin
  with LvwImages do
  begin
    Selected := nil;
    Item := nil;
    for I := Items.Count - 1 downto Items.Count - Count do
      Items[ I ].Selected := True;
    if Items.Count > 0 then
      Item := Items[ Index ];
    Selected := Item;
    if Assigned( Item ) then
      Item.MakeVisible( False );
  end;
end;


procedure TRzImageListEditDlg.LvwImagesKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
begin
  if ( Key = vk_Delete ) and BtnDelete.Enabled and ( not LvwImages.IsEditing ) then
    BtnDelete.Click;
end;


procedure TRzImageListEditDlg.MoveImage( FromIndex, ToIndex: Integer );
begin
  InfoList.Move( FromIndex, ToIndex );
  ImageList.Move( FromIndex, ToIndex );
  ListViewImageList.Move( FromIndex, ToIndex );
  LvwImages.Items[ FromIndex ].ImageIndex := -1;
  LvwImages.Items[ ToIndex ].ImageIndex := -1;
  UpdateListView;
  BtnApply.Enabled := True;
end;


procedure TRzImageListEditDlg.SeTRzImageOperation( Operation: TRzImageOperation );
var
  Item: TListItem;
begin
  Screen.Cursor := crHourglass;
  try
    Item := LvwImages.Selected;
    if Item <> nil then
    begin
      Items[ Item.Index ].Operation := Operation;
    end;
    Item := LvwImages.Selected;
    while Item <> nil do
    begin
      Items[ Item.Index ].Operation := Operation;
      Item := LvwImages.GetNextItem( Item, sdAll, [ isSelected ] );
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;


procedure TRzImageListEditDlg.SetImageColor( Color: TColor; Fill: Boolean );
var
  Item: TListItem;
  OldCur: TCursor;
begin
  OldCur := Screen.Cursor;
  try
    Screen.Cursor := crHourglass;
    Item := LvwImages.Selected;
    if Assigned( Item ) then
      if Fill then
        Items[ Item.Index ].FillColor := Color
      else
        Items[ Item.Index ].TransparentColor := Color;
    Item := LvwImages.GetNextItem( Item, sdAll, [ isSelected ] );
    while Item <> nil do
    begin
      Items[ Item.Index ].TransparentColor := Color;
      Item := LvwImages.GetNextItem( Item, sdAll, [ isSelected ] );
    end;
  finally
    Screen.Cursor := OldCur;
  end;
end;


procedure TRzImageListEditDlg.StretchImageList( SrcList, DstList: TImageList; Width, Height: Integer );
var
  I: Integer;
  Image, Mask: TBitmap;
begin
  DstList.Width := Width;
  DstList.Height := Height;
  Image := TBitmap.Create;
  Mask := TBitmap.Create;
  try
    for I := 0 to SrcList.Count - 1 do
    begin
      GetImages( SrcList, I, Image, Mask );
      DstList.Add( nil, nil );
      StretchReplace( DstList, I, Image, Mask );
    end;
  finally
    Mask.Free;
    Image.Free;
  end;
end;


procedure TRzImageListEditDlg.CenterImageList( SrcList, DstList: TImageList; Width, Height: Integer );
var
  I: Integer;
  Image, Mask: TBitmap;
begin
  DstList.Width := Width;
  DstList.Height := Height;
  Image := TBitmap.Create;
  Mask := TBitmap.Create;
  try
    for I := 0 to SrcList.Count - 1 do
    begin
      GetImages( SrcList, I, Image, Mask );
      DstList.Add( nil, nil );
      CenterReplace( DstList, I, Image, Mask );
    end;
  finally
    Mask.Free;
    Image.Free;
  end;
end;


const
  MaskBackground: array[ Boolean ] of TColor = ( clWhite, clBlack );


procedure TRzImageListEditDlg.StretchReplace( List: TImageList; Index: Integer; Image, Mask: TBitmap );
var
  NewImage, NewMask: TBitmap;
begin
  NewImage := TBitmap.Create;
  NewMask := TBitmap.Create;
  try
    NewImage.Width := List.Width;
    NewImage.Height := List.Height;
    NewImage.Canvas.StretchDraw( Rect( 0, 0, List.Width, List.Height ), Image );
    NewMask.Width := List.Width;
    NewMask.Height := List.Height;
    NewMask.Canvas.Brush.Color := MaskBackground[ Mask = nil ];
    NewMask.Canvas.FillRect( Rect( 0,0,List.Width,List.Height ) );
    if Mask <> nil then
      NewMask.Canvas.StretchDraw( Rect( 0, 0, List.Width, List.Height ), Mask );
    List.Replace( Index, NewImage, NewMask );
  finally
    NewImage.Free;
    NewMask.Free;
  end;
end;

procedure TRzImageListEditDlg.StretchReplaceMasked( List: TImageList; Index: Integer; Image: TBitmap;
                                                     MaskColor: TColor );
var
  NewImage: TBitmap;
begin
  NewImage := TBitmap.Create;
  try
    NewImage.Width := List.Width;
    NewImage.Height := List.Height;
    NewImage.Canvas.StretchDraw( Rect( 0, 0, List.Width, List.Height ), Image );
    List.ReplaceMasked( Index, NewImage, MaskColor );
  finally
    NewImage.Free;
  end;
end;

procedure TRzImageListEditDlg.CenterReplace( List: TImageList; Index: Integer; Image, Mask: TBitmap );
var
  R: TRect;
  NewImage, NewMask: TBitmap;
begin
  R := Bounds( ( List.Width - Image.Width ) div 2,
    ( List.Height - Image.Height ) div 2, Image.Width, Image.Height );
  NewImage := TBitmap.Create;
  NewMask := TBitmap.Create;
  try
    NewImage.Width := List.Width;
    NewImage.Height := List.Height;
    NewImage.Canvas.Brush.Color := List.BkColor;
    NewImage.Canvas.FillRect( Rect( 0,0,List.Width,List.Height ) );
    NewImage.Canvas.StretchDraw( R, Image );
    NewMask.Width := List.Width;
    NewMask.Height := List.Height;
    NewMask.Canvas.Brush.Color := MaskBackground[ Mask = nil ];
    NewMask.Canvas.FillRect( Rect( 0,0,List.Width,List.Height ) );
    if Mask <> nil then
      NewMask.Canvas.StretchDraw( R, Mask );
    List.Replace( Index, NewImage, NewMask );
  finally
    NewImage.Free;
    NewMask.Free;
  end;
end;


procedure TRzImageListEditDlg.CenterReplaceMasked( List: TImageList; Index: Integer; Image: TBitmap;
                                                    MaskColor: TColor );
var
  R: TRect;
  NewImage: TBitmap;
begin
  R := Bounds( ( List.Width - Image.Width ) div 2,
    ( List.Height - Image.Height ) div 2, Image.Width, Image.Height );
  NewImage := TBitmap.Create;
  try
    NewImage.Width := List.Width;
    NewImage.Height := List.Height;
    NewImage.Canvas.Brush.Color := MaskColor;
    NewImage.Canvas.FillRect( Rect( 0,0,List.Width,List.Height ) );
    NewImage.Canvas.StretchDraw( R, Image );
    List.ReplaceMasked( Index, NewImage, MaskColor );
  finally
    NewImage.Free;
  end;
end;


procedure TRzImageListEditDlg.DoListViewImageListChange( Sender: TObject );
var
  Item: TListItem;
begin
  if not ( csDestroying in ComponentState ) and not FDeleting then
  begin
    Item := LvwImages.Selected;
    if Assigned( Item ) then
      SelectImage( Item.Index );
  end;
end;


procedure TRzImageListEditDlg.UpdatePickColor( X, Y: Integer );
var
  Item: TListItem;
  TransColor: TColor;
  ImageX, ImageY: Integer;
  B: TBitmap;
begin
  if not ImgPreview.Picture.Bitmap.Empty then
  begin
    ImageX := X div FImageXDivOffset;
    ImageY := Y div FImageYDivOffset;
    if ( ImageX > ImgPreview.Picture.Bitmap.Width ) or ( ImageX < 0 ) or
       ( ImageY > ImgPreview.Picture.Bitmap.Height ) or ( ImageY < 0 ) then
      Exit;

    Item := LvwImages.Selected;
    if Assigned( Item ) and Items[ Item.Index ].CanChangeTransparent then
    begin
      B := TBitmap.Create;
      try
        B.Width := ImgPreview.Width;
        B.Height := ImgPreview.Height;
        B.Canvas.StretchDraw( Rect( 0, 0, B.Width, B.Height ), ImgPreview.Picture.Bitmap );

        TransColor := B.Canvas.Pixels[ X, Y ];
        Items[ Item.Index ].TransparentColor := TransColor;
      finally
        B.Free;
      end;
    end;
  end;
end;


procedure TRzImageListEditDlg.ImgPreviewMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
begin
  if ssLeft in Shift then
    UpdatePickColor( X, Y );
end;


procedure TRzImageListEditDlg.BtnExportClick( Sender: TObject );
var
  ImageStrip: TBitmap;
  ImageCount: Integer;
  {$IFNDEF VCL60_OR_HIGHER}
  I: Integer;
  {$ENDIF}

  procedure CreateImageStrip( var Strip: TBitmap; ImageList: TImageList;
    BkColor: TColor );
  var
    I, DestIndex: Integer;
  begin
    with Strip do
    begin
      Canvas.Brush.Color := BkColor;
      Canvas.FillRect( Rect( 0, 0, Strip.Width, Strip.Height ) );
      DestIndex := 0;
      for I := 0 to ImageList.Count - 1 do
        if LvwImages.Items[ I ].Selected then
        begin
          ImageList.Draw( Canvas, DestIndex * ImageList.Width, 0, I );
          Inc( DestIndex );
        end;
    end;
  end;

begin
  if LvwImages.Items.Count = 0 then
    ImageCount := ImageList.Count
  else
    ImageCount := LvwImages.SelCount;

  if ImageCount = 0 then  // If nothing is selected...
  begin
    {$IFDEF VCL60_OR_HIGHER}
    LvwImages.SelectAll;
    {$ELSE}
    for I := 0 to LvwImages.Items.Count - 1 do
      LvwImages.Items[ I ].Selected := True;

    {$ENDIF}
    ImageCount := LvwImages.SelCount;
  end;

  // Build image strip
  ImageStrip := TBitmap.Create;
  try
    ImageStrip.Width := ImageList.Width * ImageCount;
    ImageStrip.Height := ImageList.Height;
    CreateImageStrip( ImageStrip, ImageList, clFuchsia );

    // Save image strip
    if DlgSavePicture.Execute then
      ImageStrip.SaveToFile( DlgSavePicture.FileName );
  finally
    ImageStrip.Free;
  end;
end;


procedure TRzImageListEditDlg.BtnSaveClick(Sender: TObject);
begin
  if LvwImages.Selected <> nil then
  begin
    if DlgSavePicture.Execute then
      Items[ LvwImages.Selected.Index ].Bitmap.SaveToFile( DlgSavePicture.FileName );
  end;

end;


procedure TRzImageListEditDlg.LvwImagesSelectItem( Sender: TObject; Item: TListItem; Selected: Boolean );
begin
  if Selected then
    SelectImage( Item.Index );
end;


procedure TRzImageListEditDlg.ImgPreviewMouseDown( Sender: TObject; Button: TMouseButton; Shift: TShiftState;
                                                    X, Y: Integer );
begin
  UpdatePickColor( X, Y );
end;


procedure TRzImageListEditDlg.LvwImagesEdited( Sender: TObject; Item: TListItem; var S: string );
var
  I : Integer;
  Old: string;
begin
  Old := Item.Caption;
  I := StrToInt( S );
  if I < 0 then
    I := 0
  else
    if I > InfoList.Count - 1 then
      I := InfoList.Count - 1;
  if Item.Index <> I then
  begin
    MoveImage( Item.Index, I );
    S := Item.Caption;
  end
  else
    Item.Caption := Old;
  SelectImage( Item.Index );
end;


procedure TRzImageListEditDlg.LvwImagesDragOver( Sender, Source: TObject; X, Y: Integer; State: TDragState;
                                                  var Accept: Boolean );
begin
  Accept := True;
end;


procedure TRzImageListEditDlg.LvwImagesDragDrop( Sender, Source: TObject; X, Y: Integer );
var
  OrgPos, NewPos: Integer;
  Item: TListItem;
  {$IFNDEF VCL60_OR_HIGHER}
  I: Integer;
  {$ENDIF}
begin
  try
    OrgPos := StrToInt( LvwImages.Selected.Caption );
    Item := LvwImages.GetNearestItem( Point( X, Y ), sdAll );
    if Item = nil then
      Exit;

    NewPos := StrToInt( Item.Caption );
    if NewPos > FInfoList.Count - 1 then
      NewPos := FInfoList.Count - 1;


    if OrgPos <> NewPos then
    begin
      MoveImage( OrgPos, NewPos );
    end;
    SelectImage( NewPos );
    {$IFDEF VCL60_OR_HIGHER}
    LvwImages.ClearSelection;
    {$ELSE}
    for I := 0 to LvwImages.Items.Count - 1 do
      LvwImages.Items[ I ].Selected := False;
    {$ENDIF}
    Item.Selected := True;
    Item.Focused := True;
  except
  end;
end;


procedure TRzImageListEditDlg.LvwImagesCompare( Sender: TObject; Item1, Item2: TListItem; Data: Integer;
                                                 var Compare: Integer );
begin
  Compare := StrToInt( Item1.Caption ) - StrToInt( Item2.Caption )
end;


procedure TRzImageListEditDlg.HintControlMouseMove( Sender: TObject; Shift: TShiftState; X, Y: Integer );
begin
  StsHints.Caption := ' ' + ( Sender as TControl ).Hint;
end;


procedure TRzImageListEditDlg.MnuBackgroundColorClick( Sender: TObject );
begin
  DlgColor.Color := LvwImages.Color;
  if DlgColor.Execute then
    LvwImages.Color := DlgColor.Color;
end;


procedure TRzImageListEditDlg.MnuRestoreBackgroundColorClick( Sender: TObject );
begin
  LvwImages.Color := clWindow;
end;


end.

