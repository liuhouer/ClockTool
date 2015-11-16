{===============================================================================
  RzShellOpenForm Unit

  Raize Components - Component Source Unit
  Raize Shell Controls are licensed from Plasmatech Software Design.


  Components            Description
  ------------------------------------------------------------------------------
  TRzShellOpenSaveForm  Custom dialog box form for Open and Save Dialog boxes.


  Modification History
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Fixed problem where ShellList would not be initialized correctly if user
      specified a Filter and FilterIndex value for the TRzOpenDialog or
      TRzSaveDialog.
    * Replaced call to Application.HelpContext with a call to
      Application.HelpCommand to work-around the problem of HelpContext not
      generating a wm_Help message.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Initial inclusion in Raize Components.
  ------------------------------------------------------------------------------
  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
  Copyright © 1996-2003 by Plasmatech Software Design. All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

{$RANGECHECKS OFF}
{$WRITEABLECONST OFF}
{$TYPEDADDRESS ON}

unit RzShellOpenForm;

interface

uses
  Classes,
  Windows,
  Messages,
  Controls,
  Forms,
  Graphics,
  Menus,
  ComCtrls,
  StdCtrls,
  ExtCtrls,
  Buttons,
  RzCommon,
  RzShellDialogs,
  RzListVw,
  RzShellCtrls,
  RzTreeVw,
  RzCmboBx,
  RzPanel,
  RzSplit,
  ImgList,
  RzButton,
  RzRadChk, Mask, RzEdit;

type
  TRzShellOpenSaveForm_LIS = ( lisEdit, lisList ); // C++ Builder demands formal type decl for enumerations.

  TRzShellOpenSaveForm = class( TForm )
    ShellCombo: TRzShellCombo;
    UpOneLevelBtn: TSpeedButton;
    ListBtn: TSpeedButton;
    DetailsBtn: TSpeedButton;
    CreateNewFolderBtn: TSpeedButton;
    PnlEdits: TPanel;
    FileNameTxt: TLabel;
    FilesOfTypeTxt: TLabel;
    FileTypesCbx: TRzComboBox;
    FileNameEdt: TRzEdit;
    OpenBtn: TRzButton;
    CancelBtn: TRzButton;
    FileNameCbx: TRzComboBox;
    ReadOnlyChk: TRzCheckBox;
    ShowTreeBtn: TSpeedButton;
    HelpBtn: TRzButton;
    LvPopup: TPopupMenu;
    View1Mitm: TMenuItem;
    N1: TMenuItem;
    New1Mitm: TMenuItem;
    N2: TMenuItem;
    Properties1Mitm: TMenuItem;
    Folder1Mitm: TMenuItem;
    LargeIcons1Mitm: TMenuItem;
    Smallicons1MItm: TMenuItem;
    List1Mitm: TMenuItem;
    Details1Mitm: TMenuItem;
    Paste1Mitm: TMenuItem;
    N3: TMenuItem;
    ShowDesktopBtn: TSpeedButton;
    RzSplitter1: TRzSplitter;
    ShellTree: TRzShellTree;
    ShellList: TRzShellList;
    ImageList1: TImageList;
    PnlJumps: TPanel;
    BtnJumpRecent: TRzToolButton;
    BtnJumpDesktop: TRzToolButton;
    BtnJumpDocuments: TRzToolButton;
    BtnJumpComputer: TRzToolButton;
    BtnJumpNetwork: TRzToolButton;
    LookInTxt: TLabel;
    PnlWork: TPanel;
    procedure ViewBtnClick( Sender: TObject );
    procedure ShellListChange( Sender: TObject; Item: TListItem; Change: TItemChange );
    procedure UpOneLevelBtnClick( Sender: TObject );
    procedure ShowTreeBtnClick( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure FormKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
    procedure FormCloseQuery( Sender: TObject; var CanClose: Boolean );
    procedure ShellTreeChange( Sender: TObject; Node: TTreeNode );
    procedure FileTypesCbxSelEndOk( Sender: TObject );
    procedure CreateNewFolderBtnClick( Sender: TObject );
    procedure FileNameEdtChange( Sender: TObject );
    procedure Paste1MitmClick( Sender: TObject );
    procedure Properties1MitmClick( Sender: TObject );
    procedure HelpBtnClick( Sender: TObject );
    procedure ReadOnlyChkClick( Sender: TObject );
    procedure ShellListFolderChanged( Sender: TObject );
    procedure FormResize( Sender: TObject );
    procedure ShowDesktopBtnClick( Sender: TObject );
    procedure FormCreate(Sender: TObject);
    procedure BtnJumpClick(Sender: TObject);
  private
    function FormHelp( Command: Word; Data: Integer; var CallHelp: Boolean ): Boolean;
    procedure ListDblClickOpen( Sender: TObject;  var Handled: Boolean );
    procedure WMGetMinMaxInfo( var Msg: TWMGetMinMaxInfo ); message WM_GETMINMAXINFO;
  protected
    FDefaultExt: string;
    FOptions: TRzOpenSaveOptions;
    FFiles: TStrings;  // Last request for 'files'
    FFilter: string;
    FInitialDir: string;

    FOnTypeChanged: TNotifyEvent;
    FOnFolderChanged: TNotifyEvent;
    FOnSelectionChanged: TNotifyEvent;
    FOnFormShow: TNotifyEvent;
    FOnFormClose: TNotifyEvent;
    FOnFormHelp: THelpEvent;

    procedure DoOnFormClose; dynamic;
    procedure DoOnFolderChanged; dynamic;
    procedure DoOnSelectionChanged; dynamic;
    procedure DoOnFormShow; dynamic;
    procedure DoOnTypeChanged; dynamic;

    function  GetFilename: string;
    function  GetFiles: TStrings;
    function  GetFilterIndex: Integer;
    function  GetFormSplitterPos: Integer;
    function  GetOnAddListItem: TRzShAddItemEvent;
    function  GetOnAddTreeItem: TRzShAddItemEvent;
    function  GetOnAddComboItem: TRzShAddItemEvent;

    procedure SetFilename( const Value: string );
    procedure SetFilter( const Value: string );
    procedure SetFilterIndex( Value: Integer );
    procedure SetFormSplitterPos( Value: Integer );
    procedure SetInitialDir( const Value: string );
    procedure SetOptions( Value: TRzOpenSaveOptions );
    procedure SetOnAddListItem( Value: TRzShAddItemEvent );
    procedure SetOnAddTreeItem( Value: TRzShAddItemEvent );
    procedure SetOnAddComboItem( Value: TRzShAddItemEvent );

  protected
    FUserFilter: string; // Used for filters typed into the filename box
    FExecuting: Boolean;

    FSelections: TStrings;
    FLastInputState: TRzShellOpenSaveForm_LIS;

    FHGripWindow: HWND;

    procedure CreateWnd; override;
    procedure DoTranslation; dynamic;
    procedure ApplyUserFilter( Filter: string );
    procedure GetSelectedFiles( s: TStrings );
    procedure ShowTree( Show: Boolean );

    procedure DoHide; override;
    procedure DoShow; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function  ParseInputstring( const ins: string ): Boolean;

    procedure InitFraming( FrameColor: TColor; FrameStyle: TFrameStyle;
                           FrameVisible: Boolean;
                           FramingPreference: TFramingPreference );
    procedure InitHotTracking( HotTrack: Boolean; HighlightColor: TColor;
                               HotTrackColor: TColor;
                               HotTrackColorType: TRzHotTrackColorType );

    property DefaultExt: string
      read FDefaultExt
      write FDefaultExt;

    property Executing: Boolean
      read FExecuting;

    property Options: TRzOpenSaveOptions
      read FOptions
      write SetOptions;

    property FileName: string
      read GetFilename
      write SetFilename;

    property Files: TStrings
      read GetFiles;

    property Filter: string
      read FFilter
      write SetFilter;

    property FilterIndex: Integer
      read GetFilterIndex
      write SetFilterIndex
      default 1; // Does default count in this situation?

    property FormSplitterPos: Integer
      read GetFormSplitterPos
      write SetFormSplitterPos
      default -1; // Does default count in this situation?

    property HelpContext;

    property InitialDir: string
      read FInitialDir
      write SetInitialDir;

    property OnAddListItem: TRzShAddItemEvent
      read GetOnAddListItem
      write SetOnAddListItem;

    property OnAddTreeItem: TRzShAddItemEvent
      read GetOnAddTreeItem
      write SetOnAddTreeItem;

    property OnAddComboItem: TRzShAddItemEvent
      read GetOnAddComboItem
      write SetOnAddComboItem;

    property OnHelp;

    property OnFormHelp: THelpEvent
      read FOnFormHelp
      write FOnFormHelp;

    property OnFormClose: TNotifyEvent
      read FOnFormClose
      write FOnFormClose;

    property OnFormShow: TNotifyEvent
      read FOnFormShow
      write FOnFormShow;

    property OnFolderChanged: TNotifyEvent
      read FOnFolderChanged
      write FOnFolderChanged;

    property OnSelectionChanged: TNotifyEvent
      read FOnSelectionChanged
      write FOnSelectionChanged;

    property OnTypeChanged: TNotifyEvent
      read FOnTypeChanged
      write FOnTypeChanged;
  end;


implementation

{$R *.dfm}

uses
  SysUtils,
  Dialogs,
  TypInfo,
  Registry,
  ShlObj,
  RzShellConsts,
  RzShellIntf,
  RzShellUtils;

const
  SIZEGRIP_SIZE = 13;


{The list of filter strings is thus:
  [Visible][TStringList of extensions:[]]
  ---------------------------------------
  [Item1 ( *.* )][ [*.*] ]
  [Item2 ( *.doc )][ [*.doc] ]
  [Item3 ( *.gif, *.jpg, *.bmp )][ [*.gif][*.jpg][*.bmp] ]
}

type
  TFilterItemRec = record
    FExtension: string;
  end;
  PFilterItemRec = ^TFilterItemRec;


function NewFilterItemRec: PFilterItemRec;
begin
  New( Result );
end;


procedure DisposeFilterItemRec( pfir: PFilterItemRec );
begin
  Dispose( pfir );
end;


procedure GetCharsUpToNextCharDB( var Pos: Integer; Source: string; var Dest: string; CharToFind: Char );
begin
  Dest := '';
  while ( Source[ Pos ] <> CharToFind ) and ( Pos <= Length( Source ) ) do
    CopyCharDB( Pos, Source, Dest );
end;


// Takes a filter in the form "FileType1|*.ext11;*.ext12;*.ext1n|FileType2|*.ext21|" etc.
// and fills astrings.strings[] with the FileType part and the .Objects[] part with a TFilterItemRec.
// The TFilterItemRec comprises a TStringList itSelf which is a list of all the extensions
// eg. [*.ext11][*.ext12][*.ext1n]. The ExtensionsToTStrings method takes a semi-colon delimited list of
// extensions and adds them to a TStrings.

procedure FilterToTStrings( Filter: string; Strings: TStrings );
var
  pos: Integer;
  tmp: string;
  displayName: string;
  extensions: string;  // All extensions ( *.gif;*.jpg;*.bmp;etc... )
  p: PFilterItemRec;
begin
  pos := 1;
  SetLength( tmp, 255 ); tmp:='';  // Allocate some space now to prevent reallocations
  while ( pos <= Length( Filter ) ) do
  begin
   // Get all chars up to '|' character
    GetCharsUpToNextCharDB( pos, Filter, displayName, '|' ); Inc( pos ); // skip bar
    GetCharsUpToNextCharDB( pos, Filter, extensions, '|' );  Inc( pos ); // skip bar
    p := NewFilterItemRec;
    p.FExtension := extensions;
    Strings.AddObject( displayName, TObject( p ) );
  end;
end;


procedure FilterstringsFree( Strings: TStrings );
var
  I: Integer;
begin
  for I := 0 to Strings.Count-1 do
    DisposeFilterItemRec( Pointer( Strings.Objects[ I ] ) );
end;



{==================================}
{== TRzShellOpenSaveForm Methods ==}
{==================================}

constructor TRzShellOpenSaveForm.Create( AOwner: TComponent );
begin
  inherited Create( AOwner );
  FFiles := TStringList.Create;
  FSelections := TStringList.Create;
  ShellList.OnDblClickOpen := ListDblClickOpen;
  OnHelp := FormHelp;
end;



procedure TRzShellOpenSaveForm.FormCreate(Sender: TObject);
var
  IdList: PItemIdList;
begin
  ImageList1.Handle := ShellGetSystemImageList( iszLarge );
  ImageList1.ShareImages := True;
  // If ShareImages is done before assigning the handle, then the existing image list is also shared and not
  // correctly freed when overwritten by the assigning of the system image list handle.

  ShellGetSpecialFolderIdList( 0, csidlRecent, IdList );
  BtnJumpRecent.Caption := ShellGetFriendlyNameFromIdList( nil, IdList, fnNormal );
  BtnJumpRecent.ImageIndex := ShellGetSpecialFolderIconIndex( csidlRecent, 0 );

  ShellGetSpecialFolderIdList( 0, csidlDesktop, IdList );
  BtnJumpDesktop.Caption := ShellGetFriendlyNameFromIdList( nil, IdList, fnNormal );
  BtnJumpDesktop.ImageIndex := ShellGetSpecialFolderIconIndex( csidlDesktop, 0 );

  ShellGetSpecialFolderIdList( 0, csidlPersonal, IdList );
  BtnJumpDocuments.Caption := ShellGetFriendlyNameFromIdList( nil, IdList, fnNormal );
  BtnJumpDocuments.ImageIndex := ShellGetSpecialFolderIconIndex( csidlPersonal, 0 );

  ShellGetSpecialFolderIdList( 0, csidlDrives, IdList );
  BtnJumpComputer.Caption := ShellGetFriendlyNameFromIdList( nil, IdList, fnNormal );
  BtnJumpComputer.ImageIndex := ShellGetSpecialFolderIconIndex( csidlDrives, 0 );

  ShellGetSpecialFolderIdList( 0, csidlNetwork, IdList );
  BtnJumpNetwork.Caption := ShellGetFriendlyNameFromIdList( nil, IdList, fnNormal );
  BtnJumpNetwork.ImageIndex := ShellGetSpecialFolderIconIndex( csidlNetwork, 0 );
end;


procedure TRzShellOpenSaveForm.DoTranslation;

  function IMax( a, b: Integer ): Integer;
  begin
    if ( a>b ) then
      Result := a
    else
      Result := b;
  end;

var
  x: Integer;
begin
  CancelBtn.Caption := SCancelButton;
  HelpBtn.Caption := SHelpButton;
  UpOneLevelBtn.Hint := SUpOneLevelHint;
  CreateNewFolderBtn.Hint := SCreateNewFolderHint;

  ListBtn.Hint := SViewListHint + '|' + SViewListContext;
  DetailsBtn.Hint := SViewDetailsHint + '|' + SViewDetailsContext;

  ReadOnlyChk.Caption := SOpenAsReadOnly;
  FileNameTxt.Caption := SFileName;
  ShowTreeBtn.Hint := SShowTreeHint;

  {It is the responsibility of the caller to translate LookInTxt, FilesOfTypesTxt, OpenBtn and the
   form's title itSelf.}
  View1Mitm.Caption := SViewMenu;
  View1Mitm.Hint := SViewContext;

  LargeIcons1Mitm.Caption := SViewLargeIconsMenu;
  LargeIcons1Mitm.Hint := SViewLargeIconsContext;

  SmallIcons1Mitm.Caption := SViewSmallIconsMenu;
  SmallIcons1Mitm.Hint := SViewSmallIconsContext;

  List1Mitm.Caption := SViewListMenu;
  List1Mitm.Hint := SViewListContext;

  Details1Mitm.Caption := SViewDetailsMenu;
  Details1Mitm.Hint := SViewDetailsContext;

  Paste1Mitm.Caption := SEditPasteMenu;
  Paste1Mitm.Hint := SPasteContext;

  New1Mitm.Caption := SNewMenu;
  New1Mitm.Hint := SNewPopupContext;

  Folder1Mitm.Caption := SNewFolderMenu;
  Folder1Mitm.Hint := SCreateFolderContext;

  Properties1Mitm.Caption := SPropertiesMenu;
  Properties1Mitm.Hint := SPropertiesContext;

   // Adjust controls for different language text lengths
  x := IMax( FilesOfTypeTxt.BoundsRect.Right, FileNameTxt.BoundsRect.Right ) + 8;

  with FileTypesCbx.BoundsRect do
    FileTypesCbx.BoundsRect := Rect( x, Top, Right, Bottom );
  with FileNameEdt.BoundsRect do
    FileNameEdt.BoundsRect := Rect( x, Top, Right, Bottom );
  with ReadOnlyChk.BoundsRect do
    ReadOnlyChk.BoundsRect := Rect( x, Top, Right, Bottom );

end; {= TRzShellOpenSaveForm.DoTranslation =}


destructor TRzShellOpenSaveForm.Destroy;
begin
  FSelections.Free;
  FFiles.Free;
  inherited;
end;


procedure TRzShellOpenSaveForm.CreateWnd;
begin
  inherited;
  // Create the size-grip in the bottom right corner of the window.
  FHGripWindow := CreateWindowEx( WS_EX_LEFT or WS_EX_LTRREADING or WS_EX_RIGHTSCROLLBAR, 'SCROLLBAR', '',
                                  WS_CHILDWINDOW or WS_VISIBLE or WS_CLIPSIBLINGS or WS_CLIPCHILDREN or SBS_SIZEGRIP,
                                  ClientRect.Right-SIZEGRIP_SIZE, ClientRect.Bottom-SIZEGRIP_SIZE,
                                  SIZEGRIP_SIZE, SIZEGRIP_SIZE, Handle, 0,HInstance, nil );

  SetWindowPos( FHGripWindow, HWND_TOP, 0,0,0,0, SWP_NOSIZE or SWP_NOMOVE );
end;


procedure TRzShellOpenSaveForm.InitFraming( FrameColor: TColor; FrameStyle: TFrameStyle;
                                            FrameVisible: Boolean;
                                            FramingPreference: TFramingPreference );
begin
  ShellCombo.FrameColor := FrameColor;
  ShellCombo.FrameStyle := FrameStyle;
  ShellCombo.FrameVisible := FrameVisible;
  ShellCombo.FlatButtons := FrameVisible;
  ShellCombo.FramingPreference := FramingPreference;

  ShellTree.FrameColor := FrameColor;
  ShellTree.FrameStyle := FrameStyle;
  ShellTree.FrameVisible := FrameVisible;
  ShellTree.FramingPreference := FramingPreference;

  ShellList.FrameColor := FrameColor;
  ShellList.FrameStyle := FrameStyle;
  ShellList.FrameVisible := FrameVisible;
  ShellList.FramingPreference := FramingPreference;

  FileNameCbx.FrameColor := FrameColor;
  FileNameCbx.FrameStyle := FrameStyle;
  FileNameCbx.FrameVisible := FrameVisible;
  FileNameCbx.FlatButtons := FrameVisible;
  FileNameCbx.FramingPreference := FramingPreference;

  FileNameEdt.FrameColor := FrameColor;
  FileNameEdt.FrameStyle := FrameStyle;
  FileNameEdt.FrameVisible := FrameVisible;
  FileNameEdt.FramingPreference := FramingPreference;

  FileTypesCbx.FrameColor := FrameColor;
  FileTypesCbx.FrameStyle := FrameStyle;
  FileTypesCbx.FrameVisible := FrameVisible;
  FileTypesCbx.FlatButtons := FrameVisible;
  FileTypesCbx.FramingPreference := FramingPreference;
end;


procedure TRzShellOpenSaveForm.InitHotTracking( HotTrack: Boolean; HighlightColor: TColor;
                                                HotTrackColor: TColor;
                                                HotTrackColorType: TRzHotTrackColorType );
begin
  ReadOnlyChk.HotTrack := HotTrack;
  ReadOnlyChk.HighlightColor := HighlightColor;
  ReadOnlyChk.HotTrackColor := HotTrackColor;
  ReadOnlyChk.HotTrackColorType := HotTrackColorType;

  OpenBtn.HotTrack := HotTrack;
  OpenBtn.HighlightColor := HighlightColor;
  OpenBtn.HotTrackColor := HotTrackColor;
  OpenBtn.HotTrackColorType := HotTrackColorType;

  CancelBtn.HotTrack := HotTrack;
  CancelBtn.HighlightColor := HighlightColor;
  CancelBtn.HotTrackColor := HotTrackColor;
  CancelBtn.HotTrackColorType := HotTrackColorType;

  HelpBtn.HotTrack := HotTrack;
  HelpBtn.HighlightColor := HighlightColor;
  HelpBtn.HotTrackColor := HotTrackColor;
  HelpBtn.HotTrackColorType := HotTrackColorType;
end;


//  Respond to view menu or view button click. Update state of menu and buttons so they remain synchronised.

procedure TRzShellOpenSaveForm.ViewBtnClick( Sender: TObject );
var
  Tag: Integer;

  procedure CheckItems( a: array of TComponent;  prop: Shortstring );
  var i: Integer;
  begin
    for i := Low( a ) to High( a ) do
      SetOrdProp( a[i], GetPropInfo( a[i].ClassInfo, prop ), Integer( a[i].Tag=tag ) );
  end;

begin
  tag := ( sender as TComponent ).Tag;
  ShellList.ViewStyle := TViewStyle( tag );
  CheckItems( [ListBtn, DetailsBtn], 'Down' );
  CheckItems( [LargeIcons1Mitm, SmallIcons1Mitm, List1Mitm, Details1Mitm], 'Checked' );
end;


procedure TRzShellOpenSaveForm.ListDblClickOpen( Sender: TObject; var Handled: Boolean );
begin
  ModalResult := mrOk;
  Handled := True;
end;


procedure TRzShellOpenSaveForm.WMGetMinMaxInfo( var Msg: TWMGetMinMaxInfo );
begin
  Msg.minMaxInfo.ptMinTrackSize := Point( 463, 274 );
end;


procedure TRzShellOpenSaveForm.DoOnFormClose;
begin
  if Assigned( FOnFormClose ) then
    FOnFormClose( Self );
end;


procedure TRzShellOpenSaveForm.DoOnFolderChanged;
begin
  if Assigned( FOnFolderChanged ) then
    FOnFolderChanged( Self );
end;


procedure TRzShellOpenSaveForm.DoOnSelectionChanged;
begin
  if Assigned( FOnSelectionChanged ) then
    FOnSelectionChanged( Self );
end;


procedure TRzShellOpenSaveForm.DoOnFormShow;
begin
  if Assigned( FOnFormShow ) then
    FOnFormShow( Self );
end;


procedure TRzShellOpenSaveForm.DoOnTypeChanged;
begin
  if Assigned( FOnTypeChanged ) then
    FOnTypeChanged( Self );
end;


function TRzShellOpenSaveForm.GetFilename: string;
begin
  if Executing then
  begin
    GetSelectedFiles( FFiles );
    if FFiles.Count>0 then
      Result := FFiles[0]
    else
      Result := '';
  end
  else
    Result := FileNameEdt.Text;
end;


function TRzShellOpenSaveForm.GetFiles: TStrings;
begin
  GetSelectedFiles( FFiles );
  Result := FFiles;
end;


function TRzShellOpenSaveForm.GetFilterIndex: Integer;
begin
  if FileTypesCbx.Items.Count>0 then
    Result := FileTypesCbx.ItemIndex + 1
  else
    Result := 0;
end;


function TRzShellOpenSaveForm.GetFormSplitterPos: Integer;
begin
  Result := RzSplitter1.Position;
end;


function TRzShellOpenSaveForm.GetOnAddListItem: TRzShAddItemEvent;
begin
  Result := ShellList.OnAddItem;
end;


function TRzShellOpenSaveForm.GetOnAddTreeItem: TRzShAddItemEvent;
begin
  Result := ShellTree.OnAddItem;
end;


function TRzShellOpenSaveForm.GetOnAddComboItem: TRzShAddItemEvent;
begin
  {Result := ShellCombo.OnAddItem;}
end;


procedure TRzShellOpenSaveForm.SetFilename( const Value: string );
begin
  FileNameEdt.Text := Value;
end;


procedure TRzShellOpenSaveForm.SetFilter( const Value: string );
begin
  FFilter := Value;
  ShellList.FileFilter := Filter;
  FilterToTStrings( FFilter, FileTypesCbx.Items );
end;


procedure TRzShellOpenSaveForm.SetFilterIndex( Value: Integer );
begin
  if ( Value>=1 ) and ( Value <= FileTypesCbx.Items.Count ) then
  begin
    FileTypesCbx.ItemIndex := Value-1;
    FileTypesCbxSelEndOk( Self );
  end
  else if FileTypesCbx.Items.Count>0 then
    FileTypesCbx.ItemIndex := 0;
end;


procedure TRzShellOpenSaveForm.SetFormSplitterPos( Value: Integer );
begin
  RzSplitter1.Position := Value;
end;


procedure TRzShellOpenSaveForm.SetInitialDir( const Value: string );
begin
  FInitialDir := Value;
  ShellList.Folder.Pathname := Value;
end;


procedure TRzShellOpenSaveForm.SetOptions( Value: TRzOpenSaveOptions );
var
  TreeOptions: TRzShellTreeOptions;
  ListOptions: TRzShellListOptions;

  procedure ApplyListOption( Apply: Boolean; ListOpt: TRzShellListOption );
  begin
    if Apply then
      Include( ListOptions, ListOpt )
    else
      Exclude( ListOptions, ListOpt );
  end;

  procedure ApplyTreeOption( Apply: Boolean; TreeOpt: TRzShellTreeOption );
  begin
    if Apply then
      Include( TreeOptions, TreeOpt )
    else
      Exclude( TreeOptions, TreeOpt );
  end;

  procedure ApplyOptions( Apply: Boolean; TreeOpt: TRzShellTreeOption; ListOpt: TRzShellListOption );
  begin
    ApplyListOption( Apply, ListOpt );
    ApplyTreeOption( Apply, TreeOpt );
  end;

begin {= TRzShellOpenSaveForm.SetOptions =}
  FOptions := Value;

  TreeOptions := ShellTree.Options;
  ListOptions := ShellList.Options;
  ApplyOptions( osoOleDrag in Value,  stoOleDrag, sloOleDrag );
  ApplyOptions( osoOleDrop in Value,  stoOleDrop, sloOleDrop );
  ApplyOptions( osoShowHidden in Value, stoShowHidden, sloShowHidden );
  ApplyListOption( osoHideFoldersInListWhenTreeVisible in Value, sloHideFoldersWhenLinkedToTree );
  ShellList.MultiSelect := ( osoAllowMultiselect in Value );
  ShellTree.Options := treeOptions;
  ShellList.Options := listOptions;

  ReadOnlyChk.Visible := not ( osoHideReadOnly in Value );
  HelpBtn.Visible := ( osoShowHelp in Value );

  ShowHint := ( osoShowHints in Value );

end; {= TRzShellOpenSaveForm.SetOptions =}


procedure TRzShellOpenSaveForm.SetOnAddListItem( Value: TRzShAddItemEvent );
begin
  ShellList.OnAddItem := Value;
end;


procedure TRzShellOpenSaveForm.SetOnAddTreeItem( Value: TRzShAddItemEvent );
begin
  ShellTree.OnAddItem := Value;
end;


procedure TRzShellOpenSaveForm.SetOnAddComboItem( Value: TRzShAddItemEvent );
begin
  {ShellCombo.OnAddItem := Value;}
end;


procedure TRzShellOpenSaveForm.ShowTree( Show: Boolean );
var
  c: TCursor;
begin
  if Show then
  begin
    if Assigned( ShellCombo.ShellTree ) and RzSplitter1.UpperLeft.Visible  then
      Exit; // Already showing

    try
      ShowTreeBtn.Down := True;
      if not Assigned( ShellCombo.ShellTree ) then
      begin
        c := Screen.Cursor;
        Screen.Cursor := crHourglass;
        try
          ShellTree.SelectedFolder := ShellCombo.SelectedFolder;
            // Assign selected folder before linking the list and combo to prevent redundant update

          ShellCombo.ShellList := nil;
          ShellCombo.ShellTree := ShellTree;
          ShellTree.ShellList := ShellList;

          RzSplitter1.UpperLeft.Visible := True;
          if FormSplitterPos < 0 then
            RzSplitter1.Position := 200
          else
            RzSplitter1.Position := FormSplitterPos;
        finally
          Screen.Cursor := c;
        end;
      end
      else
      begin
        //  Support for ptsloHideFoldersWhenLinkedToTree option
        ShellTree.ShellList := ShellList;
        ShellCombo.ShellTree := ShellTree;
        if FormSplitterPos<0 then
          RzSplitter1.Position := 200
        else
          RzSplitter1.Position := FormSplitterPos;
      end;
    except
      ShowTreeBtn.Down := False;
      raise;
    end;
    Options := Options + [osoShowTree];
    ShellTree.TabStop := True;
  end
  else // not aShow
  begin
    ShowTreeBtn.Down := False;
    if ShellTree.Focused then
      ShellList.SetFocus;
    ShellTree.TabStop := False;
    {-- Support for ptsloHideFoldersWhenLinkedToTree option}
    ShellTree.ShellList := nil;
    ShellCombo.ShellTree := nil;
    ShellCombo.ShellList := ShellList;
    FormSplitterPos := RzSplitter1.Position;
    RzSplitter1.UpperLeft.Visible := False;
    Options := Options - [osoShowTree];
  end;
  if ( ShellList.Visible ) and ( sloHideFoldersWhenLinkedToTree in ShellList.Options ) then
    ShellList.FillItems;
end; {= TRzShellOpenSaveForm.ShowTree =}


procedure TRzShellOpenSaveForm.ApplyUserFilter( Filter: string );
begin
  FUserFilter := Filter;
  ShellList.FileFilter := Filter;
  ShellList.FillItems;
end;


procedure TRzShellOpenSaveForm.GetSelectedFiles( s: TStrings );
begin
  s.Assign( FSelections );
end;


procedure TRzShellOpenSaveForm.ShellListChange( Sender: TObject; Item: TListItem; Change: TItemChange );

  procedure AddFilename( var sofar: string;  const toadd: string );
  begin
    if Length( sofar )>0 then sofar := sofar + ' ';
    sofar := sofar + '"' + toadd + '"';
  end;

var
  ld: TRzShellListData;
  vsi: TList; // Valid selected items
  i: Integer;
  tmpitem: TListItem;
  tmps: string;
begin
  if ( Change <> ctState ) or ( not Executing ) then
    Exit; // Only interested in selection changes

  vsi := TList.Create;
  try
    if ShellList.SelCount > 1 then
    begin
      for i := ShellList.Selected.Index to ShellList.Items.Count-1 do
      begin
        tmpitem := ShellList.Items[i];
        if tmpitem.Selected and Assigned( tmpitem.Data ) then
        begin
          ld := ShellList.ShellListData[i];
          if not ld.IsFolder then
            vsi.Add( ld );
        end;
      end;
    end
    else if ( ShellList.SelCount = 1 ) then
    begin
      tmpitem := ShellList.Selected;
      if Assigned( tmpitem ) and Assigned( tmpitem.Data ) then
      begin
        begin
          ld := ShellList.GetDataFromItem( ShellList.Selected );
          if not ld.IsFolder then
            vsi.Add( ld );
        end;
      end;
    end;

    if vsi.Count>1 then
    begin
      tmps := '';
      for i := 0 to vsi.Count-1 do
        AddFilename( tmps, TRzShellListData( vsi[i] ).FileName );
      FileNameEdt.Text := tmps;
    end
    else if vsi.Count=1 then
      FileNameEdt.Text := TRzShellListData( vsi[0] ).DisplayName;

    FLastInputState := lisList;
  finally
    vsi.Free;
  end;

  DoOnSelectionChanged;
end; {= TRzShellOpenSaveForm.ShellListChange =}


procedure TRzShellOpenSaveForm.UpOneLevelBtnClick( Sender: TObject );
begin
  ShellCombo.GoUp( 1 );
end;


procedure TRzShellOpenSaveForm.ShowTreeBtnClick( Sender: TObject );
begin
  ShowTree( ShowTreeBtn.Down )
end;


procedure TRzShellOpenSaveForm.FormDestroy( Sender: TObject );
begin
  FilterstringsFree( FileTypesCbx.Items );
end;


procedure TRzShellOpenSaveForm.FormKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
begin
  case key of
    VK_F4:
      if Shift=[] then
      begin
        if ShellCombo.DroppedDown then
        begin
          ShellCombo.DroppedDown := False;
          ShellList.SetFocus;
          ShellCombo.Perform( CN_COMMAND, MakeLong( 0,CBN_SELENDOK ), ShellCombo.Handle );
        end
        else
        begin
          ShellCombo.SetFocus;
          ShellCombo.DroppedDown := True;
        end;
      end;

    VK_F5:
      if Shift=[] then
      begin
        if not ShellCombo.Focused then ShellCombo.FillItems;
        if not ShellList.Focused then ShellList.FillItems;
        if Assigned( ShellTree.ShellList ) and not ( ShellTree.Focused ) then
          ShellTree.RefreshNodes;
      end;

    VK_F12:
      if Shift=[] then
      begin
        if ( osoAllowTree in Options ) then
          ShowTree( not ShowTreeBtn.Down );
      end;
  end;
end;


{Do processing in WideChars for easy DBCS support. To do this sort of processing in native DBCS is a real pain - and
 possibly slower than doing the DBCS->UNICODE, UNICODE<-DBCS conversion anyway.

 Given a starting fully qualified path 'aCurrent' and a relative modifier path 'aEntered' returns the
 new fully qualified path. Supports drive-letters and UNC names.}

function ApplyPathname( aCurrent, aEntered: string ): string;
var
  wcCurrent, wcEntered, wcResult: array[0..MAX_PATH] of WideChar;

  function StrLenW( pwc: PWideChar ): Integer;
  begin
    Result := 0;
    while pwc^ <> WideChar( #0 ) do
    begin
      Inc( pwc );
      Inc( Result );
    end;
  end;


  function AllDots( wc: PWideChar ): Bool;
  begin
    while wc^ <> WideChar( #0 ) do
    begin
      if wc^ <> WideChar( '.' ) then
      begin
        Result := False;
        Exit;
      end;
      Inc( wc );  // Add 2
    end;
    Result := True;
  end;


  {Might add a wide char to the string. The caller is responsible for ensuring there is sufficient space.}
  procedure EnsureTrailingSlash( pwc: PWideChar;  len: Integer );
  begin
    if ( len<0 ) then len := StrLenW( pwc );
    Inc( pwc, len-1 );
    if ( pwc^ <> WideChar( '\' ) ) then
    begin
      ( pwc+1 )^ := WideChar( '\' );
      ( pwc+2 )^ := WideChar( #0 );
    end;
  end;


  procedure EnsureNoTrailingSlash( pwc: PWideChar;  len: Integer );
  begin
    if ( len<0 ) then len := StrLenW( pwc );
    Inc( pwc, len-1 );
    if ( pwc^ = WideChar( '\' ) ) then
      pwc^ := WideChar( #0 );
  end;


  {Returns a ptr to the position of the minimum position - the first part of the path that you cannot go back below}
  function GetMinimumSizePtr( pwc: PWideChar;  len: Integer ): PWideChar;
  begin
    if ( len<0 ) then len := StrLenW( pwc );
    if ( len>=3 ) and ( ( pwc+1 )^ = WideChar( ':' ) ) then
      Result := ( pwc+3 )
    else if ( len>2 ) and ( ( pwc+0 )^ = WideChar( '\' ) ) and ( ( pwc+1 )^ = WideChar( '\' ) ) then
    begin
      Inc( pwc, 2 );  // Skip the first two slashes
      while ( pwc^ <> WideChar( #0 ) ) and ( pwc^ <> WideChar( '\' ) ) do // Find next slash
        Inc( pwc );
      if ( pwc^ = WideChar( #0 ) ) then
      begin
        Result:=nil;
        Exit;
      end;  // If end reached here then failed

      Inc( pwc );
      while ( pwc^ <> WideChar( #0 ) ) and ( pwc^ <> WideChar( '\' ) ) do // Find next slash or end
        Inc( pwc );

      Result := ( pwc );
    end
    else
      Result := nil;
  end; {GetMinimumSizePtr - local}


  procedure RemoveRightmostElement( pwc: PWideChar );
  var len: DWORD;
      endc: PWideChar;
      minpos: PWideChar;
  begin
    len := StrLenW( pwc );
    endc := PWideChar( UINT( pwc ) + len*2 -2 );
    minpos := GetMinimumSizePtr( pwc, len );
    if UINT( minpos ) - UINT( pwc ) = len*2 then
    begin
      Exit;
    end;
    while ( UINT( endc ) > UINT( minpos ) ) and ( endc <> pwc ) and ( endc^ <> WideChar( '\' ) ) do
      Dec( endc );
    endc^ := WideChar( #0 );
  end;


  procedure StrAppendW( pdest, ptoappend: PWideChar );
  var len: Integer;
  begin
    len := StrLenW( pdest );
    pdest := PWideChar( Integer( pdest )+len*2 );
    while ptoappend^ <> WideChar( #0 ) do
    begin
      pdest^ := ptoappend^;
      Inc( pdest );
      Inc( ptoappend );
    end;
    pdest^ := WideChar( #0 );
  end;


  procedure GetTokenAndAdvance( var pwc: PWideChar;  ptoken: PWideChar );
  var ptok: PWideChar;
  begin
    ptok := ptoken;
    while ( pwc^ <> WideChar( #0 ) ) and ( pwc^ <> WideChar( '\' ) ) do
    begin
      ptok^ := pwc^;
      Inc( pwc );
      Inc( ptok );
    end;
    if ( pwc^ = WideChar( '\' ) ) then Inc( pwc );
    ptok^ := WideChar( #0 );
  end; {GetTokenAndAdvance - local}


  procedure Merge;
  var token: array[0..MAX_PATH] of WideChar;
      pinentered: PWideChar;
      i, max: Integer;
  begin
    Move( wcCurrent, wcResult, ( Length( aCurrent )+1 )*2 );
    pinentered := @wcEntered[0];

    token[0] := WideChar( #0 );
    GetTokenAndAdvance( pinentered, @token[0] );
    while token[0] <> WideChar( #0 ) do
    begin
      if AllDots( @token[0] ) then
      begin
        max := StrLenW( token )-1;
        for i := 1 to max do
          RemoveRightmostElement( @wcResult[0] );
      end
      else
      begin
        if ( wcResult[0] <> WideChar( #0 ) ) then
          EnsureTrailingSlash( @wcResult[0], -1 );
        StrAppendW( @wcResult[0], @token[0] );
      end;
      token[0] := WideChar( #0 );
      GetTokenAndAdvance( pinentered, @token[0] );
    end;
  end; {Merge - local}


type
  TPathType = ( ptAbsDisk, ptAbsNet, ptRel, ptErr );

  function GetPathTypeW( pwc: PWideChar ): TPathType;
  var
    len: Integer;
  begin
    len := StrLenW( pwc );
    if ( len>=2 ) and ( ( pwc+1 )^ = WideChar( ':' ) ) then
      Result := ptAbsDisk
    else if ( len>=3 ) and ( ( pwc+0 )^ = WideChar( '\' ) ) and ( ( pwc+1 )^ = WideChar( '\' ) ) then
      Result := ptAbsNet
    else if ( pwc^ = WideChar( '\' ) ) then
      Result := ptAbsDisk // Just one slash means 'current drive root directory'
    else if ( len>0 ) then
      Result := ptRel
    else
      Result := ptErr;
  end; {GetPathTypeW - local}


var
  pwc: PWideChar;

begin {= ApplyPathname =}
  if ( Length( aCurrent )>2 ) and ( aCurrent[ Length( aCurrent ) ]='\' ) then
    Delete( aCurrent,Length( aCurrent ),1 );

  stringToWideChar( aCurrent, @wcCurrent[0], Sizeof( wcCurrent ) );
  stringToWideChar( aEntered, @wcEntered[0], Sizeof( wcEntered ) );

  wcResult[0] := WideChar( #0 );

 // Determine if the entered string is an absolute path, if so we can ignore aCurrent
  case GetPathTypeW( wcEntered ) of
    ptAbsDisk:
      begin
        if wcEntered[0] = WideChar( '\' ) then
        begin
          case GetPathTypeW( wcCurrent ) of
            ptAbsDisk:
              begin
                wcResult[0] := wcCurrent[0];
                wcResult[1] := wcCurrent[1];
                wcResult[2] := WideChar( #0 );
              end;
            ptAbsNet:
              begin
                Move( wcCurrent, wcResult, ( Length( aCurrent )+1 )*2 );
                pwc := GetMinimumSizePtr( wcResult, -1 );
                pwc^ := WideChar( #0 );
              end;
            else // can't be ptRel, by definition the current path must be an absolute path
          end;
          StrAppendW( @wcResult[0], @wcEntered[0] );
        end
        else if Length( aEntered )=2 then
        begin
          wcResult[0] := wcEntered[0];
          wcResult[1] := wcEntered[1];
          wcResult[2] := WideChar( '\' );
          wcResult[3] := WideChar( #0 );
        end
        else
          Move( wcEntered, wcResult, ( Length( aEntered )+1 )*2 );
      end;

    ptAbsNet:
      begin
        Move( wcEntered, wcResult, ( Length( aEntered )+1 )*2 );
      end;

    ptRel:
      begin
        Merge;
      end;
    else
  end; {case}

  Result := WideCharTostring( @wcResult[0] );
end; {= ApplyPathname =}


function IsFileReadOnly( aFile: string ): Boolean;
var dw: DWORD;
begin
  dw := Windows.GetFileAttributes( PChar( aFile ) );
  Result := ( ( dw <> $FFFFFFFF ) and ( ( dw and FILE_ATTRIBUTE_READONLY )<>0 ) );
end;


function IsExtensionRegistered( const ext: string ): Boolean;
var r: TRegistry;
begin
  r := TRegistry.Create;
  try
    r.RootKey := HKEY_CLASSES_ROOT;
    Result := r.KeyExists( ext );
  finally
    r.Free;
  end;
end;


function MessageDlgCaption( const Caption, Msg: string; dlgType: TMsgDlgType; buttons: TMsgDlgButtons;
                            helpCtx: Integer ): Integer;
begin
  with Dialogs.CreateMessageDialog( Msg, dlgType, buttons ) do
    try
      Caption := Caption;
      HelpContext := helpctx;
      Result := ShowModal;
    finally
      Free;
    end;
end; {MessageDlgCaption}


procedure NotFound( const caption, filename: string );
begin
  MessageDlgCaption( caption, Format( SFileNotFound, [filename] ), mtWarning, [mbOk], 0 );
end;

function DoYouWishToCreateIt( const caption, filename: string ): Boolean;
begin
  Result := ( MessageDlgCaption( caption, Format( SDoesNotExistCreate, [filename] ), mtConfirmation, [mbYes, mbNo], 0 ) = mrYes );
end;

procedure NoReadOnlyReturn( const caption, filename: string );
begin
  MessageDlgCaption( Caption, Format( SExistsAndIsReadOnly, [filename] ), mtWarning, [mbOk], 0 );
end;

function FileExistsOverwrite( const caption, filename: string ): Boolean;
begin
  Result := ( MessageDlgCaption( caption, Format( SFileExistsReplace, [filename] ), mtWarning, [mbYes, mbNo], 0 ) = mrYes );
end;

procedure ThereCanBeOnlyOne( const caption, filename: string );
begin
  MessageDlgCaption( caption, Format( SThereCanBeOnlyOne, [filename] ), mtWarning, [mbOk], 0 );
end;

procedure ThisFilenameIsNotValid( const caption, filename: string );
begin
  MessageDlgCaption( caption, Format( SFilenameIsInvalid, [filename] ), mtWarning, [mbOk], 0 );
end;


{Returns True if a '*' or '?' char is found - DBCS enabled}
function AnyWildcardsDB( s: string ): Boolean;
var pos: Integer;
begin
  pos := 1;
  while ( pos <= Length( s ) ) do
  begin
    if IsDBCSLeadByte( Byte( s[pos] ) ) then
      Inc( pos,2 )
    else
    begin
      if ( s[pos] = '*' ) or ( s[pos] = '?' ) then
      begin
        Result := True;
        Exit;
      end;
      Inc( pos );
    end;
  end;
  Result := False;
end; {AnyWildcardsDB}


function AnyOfThisCharDB( const ins: string;  thisChar: Char ): Boolean;
var inpos: Integer;
begin
  inpos := 1;
  while ( inpos <= Length( ins ) ) do
  begin
    if IsDBCSLeadByte( Byte( ins[inpos] ) ) then
      Inc( inpos, 2 )
    else if ( ins[inpos] = thisChar ) then
    begin
      Result := True;
      Exit;
    end
    else
      Inc( inpos );
  end;
  Result := False;
end; {AnyOfThisCharDB}


procedure ParametizeDB_special( const ins: string;  outs: TStrings );
{$IFNDEF VCL30PLUS}
  function AnsiPos( const Substr, S: string ): Integer;
  begin
    Result := Pos( Substr, S );
  end;
{$ENDIF}
const WHITESPACE = [' ',#9];
var curs: string;
    state: ( sNormal, sInQuotes, sInWhitespace );
    inpos: Integer;
    curchar: Char;
    fIsDBCS: Boolean;
begin
  curs := '';
  state := sInWhitespace;
  inpos := 1;
  while ( inpos <= Length( ins ) ) do
  begin
    curchar := ins[inpos];
    fIsDBCS := IsDBCSLeadByte( Byte( curchar ) );
    case state of
      sNormal:
        begin
          if not fIsDBCS and ( curchar = '"' ) then
          begin
            curs := TrimRightDB( curs );
            if Length( curs )>0 then
            begin
              outs.Add( curs );
              curs := '';
            end;
            state := sInQuotes;
            Inc( inpos, 1 );
          end
          else
            CopyCharDB( inpos, ins, curs );
        end;

      sInQuotes:
        begin
          if not fIsDBCS and ( curchar = '"' ) then
          begin
            curs := TrimRightDB( curs );
            if Length( curs )>0 then
            begin
              outs.Add( curs );
              curs := '';
            end;
            state := sInWhitespace;
            Inc( inpos );
          end
          else
            CopyCharDB( inpos, ins, curs );
        end;

      sInWhitespace:
        begin
          if not fIsDBCS then
          begin
            if ( curchar = '"' ) then
            begin
              curs := '';
              state := sInQuotes;
            end
            else if not ( curchar in WHITESPACE ) then
            begin
              curs := curchar;
              state := sNormal;
            end;
            Inc( inpos, 1 );
          end
          else // fIsDBCS
          begin
            CopyCharDB( inpos, ins, curs );
            state := sNormal;
          end;
        end;
    end; {case}
  end; {while}

  curs := TrimRightDB( curs );
  if Length( curs )>0 then
    outs.Add( curs );
end; {ParametizeDB}



// Also input: all the selected items in ShellList
function TRzShellOpenSaveForm.ParseInputstring( const ins: string ): Boolean;
  function ApplyOptions( pathname: string;  options: TRzOpenSaveOptions ): Boolean;
  var fFileExists: Boolean;
  begin
    fFileExists := FileExists( pathname );
    if fFileExists then
    begin
      if IsFileReadOnly( pathname ) and ( osoNoReadOnlyReturn in options ) then
      begin
        NoReadOnlyReturn( Caption, pathname );
        Result := False;
        Exit;
      end;

      if ( osoOverwritePrompt in options ) then
      begin
        if not FileExistsOverwrite( Caption, pathname ) then
          begin Result := False; Exit; end;
      end;

      Result := True;
      Exit;
    end;
   // not FileExists

    if ( osoFileMustExist in options ) then
      begin NotFound( Caption, pathname ); Result := False; Exit; end;

    if ( osoCreatePrompt in options ) then
      if not DoYouWishToCreateIt( Caption, ExtractFileName( pathname ) ) then
        begin Result := False; Exit; end;

    Result := True;
  end; {ApplyOptions - local}

  function GetCurrentFolderPath: string;
  begin
    Result := ShellList.Folder.Pathname;
  end; {GetCurrentFolderPath - local}

  function IfFolderOpenIt( pathname: string ): Boolean;
  var dskishf, ishf: IShellFolder_NRC;
      fFileExists: Boolean;
      pidl: PItemIdList;
      wca: array[0..MAX_PATH] of WideChar;
      dw, dw2, dwAttrib, chEaten: DWORD;
  begin
    Result := False;

    dskishf:=nil; pidl:=nil; ishf:=nil;
    try
      stringToWideChar( pathname, @wca[0], SizeOf( wca ) );
      ShellGetDesktopFolder( dskishf );
      dw := dskishf.ParseDisplayName( Handle, nil, @wca[0], chEaten, pidl, dwAttrib );

      fFileExists := FileExists( pathname );
      if Succeeded( dw ) then
      begin
        dwAttrib := SFGAO_FOLDER;
        dw2 := dskishf.GetAttributesOf( 1, pidl, dwAttrib );
        if Succeeded( dw2 ) and ( not fFileExists ) and ( ( dwAttrib and SFGAO_FOLDER )<>0 ) then
        begin
          dw2 := dskishf.BindToObject( pidl, nil, IID_IShellFolder, Pointer( ishf ) );
          if Failed( dw2 ) then raise Exception.Create( {$IFDEF PTDEBUG}'TRzShellOpenSaveForm.ParseInputstring BindToObject: '#13+{$ENDIF}
                                                           SysErrorMessage( dw2 ) );
          ShellCombo.SelectedFolder.IdList := pidl;
          FileNameEdt.SelectAll;
          Result := True;
        end;
      end;
    finally
      if Assigned( ishf ) then ishf.Release;
      if Assigned( pidl ) then ShellMemFree( pidl );
      if Assigned( dskishf ) then dskishf.Release;
    end;
  end; {IfFolderOpenIt - local}

  function DereferenceShortcut( pathname: string ): string;
  var ld: TLinkData;
  begin
    if ( AnsiCompareText( ExtractFileExt( pathname ), '.lnk' )=0 ) and
       Succeeded( ResolveShortcut( pathname, ld, False ) ) and
       ( ld.pathname <> '' )
    then
      Result := ld.pathname
    else
      Result := pathname;
  end; {DereferenceShortcut - local}

  procedure HandleDefaultExt( var pathname: string );
    procedure HandleUnregisteredExt;
    var
      ext: string;
    begin
      ext := ExtractFileExt( PFilterItemRec( FileTypesCbx.Items.Objects[FileTypesCbx.ItemIndex] ).FExtension );
      if ( ext <> '' ) then
      begin
        if AnsiCompareText( ExtractFileExt( pathname ), ext )<>0 then
        begin
          pathname := EnsureTrailingCharDB( pathname, '.' ) + Copy( ext,2,MAXINT );
          if AnsiCompareText( ext, '.'+DefaultExt )<>0 then
            Options := Options + [osoExtensionDifferent]
          else
            Options := Options - [osoExtensionDifferent];
        end;
      end
      else
      begin
        pathname := EnsureTrailingCharDB( pathname, '.' ) + DefaultExt;
        Options := Options - [osoExtensionDifferent];
      end;
    end;
  var
    ext: string;
  begin
    if DefaultExt <> '' then
    begin
      ext := ExtractFileExt( pathname );
      if Length( ext ) > 0 then
      begin
        if IsExtensionRegistered( ext ) then
          Options := Options + [osoExtensionDifferent]
        else
        begin
          HandleUnregisteredExt;
        end;
      end
      else
      begin
        HandleUnregisteredExt;
      end;
    end;
  end; {HandleDefaultExt}

  { Look for invalid chars and simple invalid sequences. }
  function InitialValidityCheck( s: string ): Boolean;
    function AllCharsValid( s: string ): Boolean;
    var i: Integer;
    begin
      i := 1;
      while ( i <= Length( s ) ) do
      begin
        if IsDBCSLeadByte( Byte( s[i] ) ) then
          Inc( i,2 )
        else if s[i] in ['/', '|','<','>'] then
        begin
          Result := False;
          Exit;
        end
        else
          Inc( i );
      end;
      Result := True;
    end;

    function DoubleBackslashOk( s: string ): Boolean;
    var i: Integer;
    begin
      Result := True;
      i := 3;
      while ( i <= Length( s ) ) do
      begin
        if IsDBCSLeadByte( Byte( s[i] ) ) then
          Inc( i,2 )
        else if ( s[i] = '\' ) and ( s[i-1] = '\' ) then
        begin
          Result := False;
          Break;
        end
        else
          Inc( i );
      end;
    end;
  begin
    Result := AllCharsValid( s ) and DoubleBackslashOk( s );
  end;

var sl: TStrings;
    i, li: Integer;
    curpathname, curname, curpath, curfldpath: string;
    firstFound: TListItem;

begin {ParseInputstring}
  Result := False;
  sl := TStringList.Create;
  FSelections.Clear;
  try
    if AnyOfThisCharDB( ins, '"' ) then
      ParametizeDB_special( ins, sl )
    else
      sl.Add( ins );

    curfldpath := GetCurrentFolderPath;
    EnsureTrailingCharDB( curfldpath, '\' );

    if sl.Count > 0 then
    begin
      for i := 0 to sl.Count-1 do
      begin
        if not ( osoNoValidate in Options ) and not InitialValidityCheck( ins ) then
        begin
          ThisFilenameIsNotValid( Caption, ins );
          Exit;
        end;

        curpathname := ApplyPathname( curfldpath, sl[i] );
        if ( curpathname='' ) then Continue;

        if IfFolderOpenIt( curpathname ) then
          Exit;

        if not ( osoNoDereferenceLinks in Options ) then
          curpathname := DereferenceShortcut( curpathname );

        if ( sl.Count=1 ) then
        begin
          if ( FLastInputState = lisList ) and Assigned( ShellList.SelectedItem ) then
            curpathname := ShellList.SelectedItem.Pathname
          else // FLastInputState = lisEdit
          begin
            HandleDefaultExt( curpathname );

            curname := ExtractFileName( curpathname );
            curpath := ExtractFilePath( curpathname );
            EnsureTrailingCharDB( curpath, '\' );

            if AnsiCompareText( curpath, curfldpath )<>0 then
              ShellCombo.SelectedFolder.Pathname := ExtractFilePath( curpathname );

            firstFound := nil;
            for li := 0 to ShellList.Items.Count-1 do
            begin
              if AnsiCompareText( ShellList.Items[li].Caption, curname )=0 then
              begin
                if Assigned( firstFound ) then
                begin
                  ThereCanBeOnlyOne( Caption, curname );
                  firstFound.Selected := True;
                  firstFound.Focused := True;
                  ShellList.SetFocus;
                  Exit;
                end
                else
                  firstFound := ShellList.Items[li];
              end;
              if Assigned( firstFound ) then
                curpathname := TRzShellListData( firstFound.Data ).Pathname;
            end;
          end;
          Result := ApplyOptions( curpathname, Options );
        end {if sl.Count=1}
        else
          Result := ApplyOptions( curpathname, Options );  // v1.3h
//          Result := ApplyOptions( curpathname, Options + [osoFileMustExist] );  pre v1.3h

        if Result then
          FSelections.Add( curpathname )
        else
          Exit;
      end;
    end;
  finally
    sl.Free;
    if not Result then FSelections.Clear;
  end;
end; {TRzShellOpenSaveForm.ParseInputstring}


procedure TRzShellOpenSaveForm.FormCloseQuery( Sender: TObject; var CanClose: Boolean );
var fname: string;
begin
  if ModalResult = mrOk then
  begin
    fname := ExtractFileName( FileNameEdt.Text );
    if AnyWildcardsDB( fname ) then
    begin
      CanClose := False;
      ParseInputstring( ExtractFilePath( FileNameEdt.Text ) );
      ApplyUserFilter( fname );
      FileNameEdt.Text := fname;
      FileNameEdt.SelectAll;
    end
    else
    begin
      CanClose := ParseInputstring( FileNameEdt.Text );
    end;
  end;

  if CanClose and not ( osoNoChangeDir in Options ) and ( ShellList.Folder.PathName <> '' ) then
    try
      SetCurrentDirectory( PChar( ShellList.Folder.PathName ) );
    except
    end;
end;


procedure TRzShellOpenSaveForm.ShellTreeChange( Sender: TObject; Node: TTreeNode );
begin
  (*
  // The following prevents the FileName edit from being initialized because this
  // event is fired when the form is first displayed.
  if Executing then
    if ( node <> nil ) then
      FileNameEdt.Text := '';
  *)
end;


procedure TRzShellOpenSaveForm.FileTypesCbxSelEndOk( Sender: TObject );
begin
  if ( FUserFilter <> '' ) then
    FileNameEdt.Clear;
  FUserFilter := '';
  ShellList.FileFilter := PFilterItemRec( FileTypesCbx.Items.Objects[FileTypesCbx.ItemIndex] ).FExtension;

  if Executing then
    DoOnTypeChanged;
end;


procedure TRzShellOpenSaveForm.CreateNewFolderBtnClick( Sender: TObject );
begin
  if ShellTree.Focused or ( ShowTreeBtn.Down and ( osoHideFoldersInListWhenTreeVisible in Options ) ) then
    ShellTree.CreateNewFolder( True )
  else
    ShellList.CreateNewFolder( True );
end;


procedure TRzShellOpenSaveForm.FileNameEdtChange( Sender: TObject );
begin
  if Executing then
    FLastInputState := lisEdit;
end;


procedure TRzShellOpenSaveForm.Paste1MitmClick( Sender: TObject );
begin
  ShellList.DoCommandForFolder( RZSH_CMDS_PASTE );
end;


procedure TRzShellOpenSaveForm.Properties1MitmClick( Sender: TObject );
begin
  ShellList.DoCommandForFolder( RZSH_CMDS_PROPERTIES );
end;


function TRzShellOpenSaveForm.FormHelp( Command: Word; Data: Integer; var CallHelp: Boolean ): Boolean;
begin
  if Assigned( OnFormHelp ) then
    Result := OnFormHelp( command, data, callhelp )
  else
    Result := False;
end;


procedure TRzShellOpenSaveForm.HelpBtnClick( Sender: TObject );
begin
  //Application.HelpContext( HelpContext ); // FormHelp is still called in this case
  // There is a bug in Delphi 6 and 7 that causes Application.HelpContext fail to generate a wm_Help message.
  // This causes problems with help systems, especially CHM help.  The following is a work-around.
  Application.HelpCommand( HELP_CONTEXT, HelpContext );
end;


procedure TRzShellOpenSaveForm.DoHide;
begin
  FExecuting := False;
  inherited;
  DoOnFormClose;
end;


procedure TRzShellOpenSaveForm.DoShow;

  procedure SetPnlEditsHeight;
  var
    I, Max: Integer;
  begin
    Max := 0;
    for I := 0 to PnlEdits.ControlCount - 1 do
      with PnlEdits.Controls[ i ] do
        if Visible then
          with BoundsRect do
            if bottom > max then
              max := bottom;
    PnlEdits.Height := max + 8;
  end;

var
  ofsx: Integer;
  tmps1: string;
begin {= TRzShellOpenSaveForm.DoShow =}
  Screen.Cursor := crHourglass;
  Cursor := crHourglass;
  inherited;
  Font.Name := SDialogFontName;
  FileTypesCbx.Perform( CB_SETEXTENDEDUI, 1,0 );

 // If no tree button, then hide it and move the other buttons across a bit
  if not ( osoAllowTree in Options ) then
  begin
    ShowTreeBtn.Visible := False;
    ofsx := ListBtn.Left - ShowTreeBtn.Left;
    ListBtn.Left := ListBtn.Left - ofsx;
    DetailsBtn.Left := DetailsBtn.Left - ofsx;
  end;

  SetPnlEditsHeight;

  DoTranslation;

  ShowTree( osoShowTree in Options );  // Causes events that cause edit field to be reset.

  tmps1 := ExtractFilePath( Filename );
  if ( InitialDir = '' ) then
    if Length( tmps1 ) <> 0 then
    begin
      ShellCombo.SelectedFolder.Pathname := tmps1;
      tmps1 := ExtractFileName( Filename );
      if ( tmps1 <> '' ) then
        Filename := tmps1;
    end
    else
      ShellCombo.SelectedFolder.Pathname := GetCurrentDir
  else
    ShellCombo.SelectedFolder.Pathname := InitialDir;

  FLastInputState := lisList;

  FExecuting := True;

  DoOnFormShow;

  Cursor := crDefault;
  Screen.Cursor := crDefault;
end; {= TRzShellOpenSaveForm.DoShow =}


procedure TRzShellOpenSaveForm.ReadOnlyChkClick( Sender: TObject );
begin
  if ReadOnlyChk.Checked then
    Include( FOptions, osoReadOnly )
  else
    Exclude( FOptions, osoReadOnly );
end;


procedure TRzShellOpenSaveForm.ShellListFolderChanged( Sender: TObject );
begin
  if Executing then
    DoOnFolderChanged;
end;


procedure TRzShellOpenSaveForm.FormResize( Sender: TObject );
const
  BUTTON_RIGHT_MARGIN = 16; // was 4 pre v1.h, increased to accomodate size-grip
var
  W, X, Y: Integer;
begin
  inherited;

  Y := ShellCombo.BoundsRect.Bottom + 8;
  RzSplitter1.BoundsRect := Rect( 0, Y, PnlWork.Width - 8, PnlEdits.Top );
  
  W := OpenBtn.Width;

  X := PnlWork.Width - w - BUTTON_RIGHT_MARGIN;

  OpenBtn.Left := X;
  CancelBtn.Left := X;
  HelpBtn.Left := X;

  FileNameCbx.Width := X - FileNameCbx.Left - 8;
  FileNameEdt.Width := X - FileNameEdt.Left - 8;
  FileTypesCbx.Width := X - FileTypesCbx.Left - 8;

  SetWindowPos( FHGripWindow, HWND_TOP, ClientRect.Right-SIZEGRIP_SIZE, ClientRect.Bottom - SIZEGRIP_SIZE, 0, 0,
                SWP_NOSIZE );
end; {= TRzShellOpenSaveForm.FormResize =}


procedure TRzShellOpenSaveForm.ShowDesktopBtnClick( Sender: TObject );
begin
  ShellList.Folder.CSIDL := csidlDesktop;
end;

procedure TRzShellOpenSaveForm.BtnJumpClick(Sender: TObject);
begin
  case TRzToolButton( Sender ).Tag of
    0: ShellList.Folder.CSIDL := csidlRecent;
    1: ShellList.Folder.CSIDL := csidlDesktop;
    2: ShellList.Folder.CSIDL := csidlPersonal;
    3: ShellList.Folder.CSIDL := csidlDrives;
    4: ShellList.Folder.CSIDL := csidlNetwork;
  end;
end;

end.


