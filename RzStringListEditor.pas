{===============================================================================
  RzRadioGroupEditor Unit

  Raize Components - Design Editor Source Unit


  Design Editors          Description
  ------------------------------------------------------------------------------
  TRzStringListProperty   This unit file contains a replacement string list
                            property editor and its associated dialog box.
                            After installing this unit into the Delphi IDE, this
                            editor will be used to edit all string list
                            properties.


  Modification History
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Updated form to use custom framing editing controls and HotTrack style
      buttons, radio buttons, and check boxes.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzStringListEditor;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ExtCtrls,
  RzPanel,
  StdCtrls,
  Buttons,
  IniFiles,
  {$IFDEF VCL60_OR_HIGHER}
  DesignIntf,
  DesignEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  Registry,
  Menus,
  RzPrgres,
  RzSpnEdt,
  RzBorder,
  RzStatus,
  Mask,
  RzEdit,
  RzButton;

type
  TRzStringListProperty = class( TPropertyEditor )
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure Edit; override;
  end;


  TRzStringListEditDlg = class( TForm )
    MnuEdit: TPopupMenu;
    MnuUndo: TMenuItem;
    MnuCut: TMenuItem;
    MnuCopy: TMenuItem;
    MnuPaste: TMenuItem;
    MnuSep1: TMenuItem;
    MnuOpen: TMenuItem;
    MnuSave: TMenuItem;
    MnuSep2: TMenuItem;
    MnuIndent: TMenuItem;
    DlgOpen: TOpenDialog;
    DlgSave: TSaveDialog;
    DlgFont: TFontDialog;
    MnuUnindent: TMenuItem;
    MnuPrint: TMenuItem;
    MnuSep3: TMenuItem;
    DlgPrint: TPrintDialog;
    PnlToolbar: TRzPanel;
    BtnOpen: TRzToolbarButton;
    BtnSave: TRzToolbarButton;
    BtnCut: TRzToolbarButton;
    BtnCopy: TRzToolbarButton;
    BtnPaste: TRzToolbarButton;
    BtnUndo: TRzToolbarButton;
    BtnFont: TRzToolbarButton;
    BtnIndent: TRzToolbarButton;
    BtnUnindent: TRzToolbarButton;
    BtnTabSize: TRzToolbarButton;
    BtnSetTabSize: TRzToolbarButton;
    BtnCancelTabSize: TRzToolbarButton;
    BtnPrint: TRzToolbarButton;
    SpnTabSize: TRzSpinEdit;
    PnlButtons: TRzPanel;
    RzPanel2: TRzPanel;
    BtnOk: TRzButton;
    BtnCancel: TRzButton;
    PnlStatusBar: TRzPanel;
    RzStatusPane1: TRzStatusPane;
    RzStatusPane2: TRzStatusPane;
    LblCount: TRzStatusPane;
    LblLine: TLabel;
    LblCol: TLabel;
    PnlWorkSpace: TRzPanel;
    EdtStrings: TRzMemo;
    PbrPrint: TRzProgressBar;
    BtnCodeEditor: TRzButton;
    procedure FormCreate( Sender: TObject );
    procedure FormDestroy( Sender: TObject );
    procedure BtnFontClick( Sender: TObject );
    procedure BtnUndoClick( Sender: TObject );
    procedure BtnCutClick( Sender: TObject );
    procedure BtnCopyClick( Sender: TObject );
    procedure BtnPasteClick( Sender: TObject );
    procedure BtnOpenClick( Sender: TObject );
    procedure BtnSaveClick( Sender: TObject );
    procedure BtnIndentClick( Sender: TObject );
    procedure EdtStringsChange( Sender: TObject );
    procedure EdtStringsKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState );
    procedure EdtStringsKeyUp( Sender: TObject; var Key: Word; Shift: TShiftState );
    procedure EdtStringsClick( Sender: TObject);
    procedure EdtStringsMouseUp( Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnTabSizeClick(Sender: TObject);
    procedure BtnUnindentClick(Sender: TObject);
    procedure BtnSetTabSizeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnCodeEditorClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    SingleLine: string[ 15 ];
    MultipleLines: string[ 15 ];
    DelphiIni: TRegIniFile;
    FTabSize: Integer;
    FCurLine: Integer;
    FCurCol: Integer;
    FPropName: string;
    FModified: Boolean;
    function EndOfLine( LineNum: Integer ): Integer;
    procedure IndentLine( LineNum: Integer );
    function UnindentLine( LineNum: Integer ): Boolean;
    procedure IndentLines( Indent: Boolean );
    procedure SetTabSize;
    procedure EnableButtons( Enable: Boolean );
    procedure WMGetMinMaxInfo( var Msg: TWMGetMinMaxInfo ); message wm_GetMinMaxInfo;
  public
    property PropName: string
      read FPropName
      write FPropName;

    procedure UpdateLineColStatus;
    procedure UpdateClipboardStatus;
    procedure UpdateButtonStatus;
  end;


implementation

{$R *.DFM}


uses
  SysUtils,
  LibHelp,
  ClipBrd,
  Printers,
  ToolsAPI,
  StFilSys,
  TypInfo,
  RzStringModule,
  RzCommon;

const
  Section = 'String List Editor';

  fsBoldMask      = 8;              { Constants used to determine font style }
  fsItalicMask    = 4;
  fsUnderlineMask = 2;
  fsStrikeOutMask = 1;
  fsNormal        = 0;


{===================================}
{== TRzStringListProperty Methods ==}
{===================================}

function TRzStringListProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paDialog ];                  { Edit method will display a dialog }
end;


function TRzStringListProperty.GetValue: string;
begin
  { The GetPropType method is used to retrieve information pertaining to the   }
  { property type being edited.  In this case, the Name of the property class  }
  { is displayed in the value column of the Object Inspector.                  }

  Result := Format( '(%s)', [ GetPropType^.Name ] );
end;


procedure TRzStringListProperty.Edit;
var
  Component: TComponent;
  Dialog: TRzStringListEditDlg;
  Ident: string;
  Module: IOTAModule;
  Editor: IOTAEditor;
  ModuleServices: IOTAModuleServices;
  Stream: TStringStream;
  Age: TDateTime;
begin
  Component := TComponent( GetComponent( 0 ) );

  ModuleServices := BorlandIDEServices as IOTAModuleServices;
  if ( TObject( Component ) is TComponent ) and
     ( Component.Owner = Self.Designer.GetRoot ) then
  begin
    Ident := Self.Designer.GetRoot.Name + DotSep + Component.Name + DotSep + GetName;
    Module := ModuleServices.FindModule( Ident );
  end
  else
    Module := nil;

  if ( Module <> nil ) and ( Module.GetModuleFileCount > 0 ) then
    Module.GetModuleFileEditor( 0 ).Show
  else
  begin
    Dialog := TRzStringListEditDlg.Create( Application );
    try
      if Ident <> '' then
        Dialog.FPropName := Ident
      else if TObject( Component ) is TComponent then
        Dialog.FPropName := Component.Name + GetName
      else
        Dialog.FPropName := GetName;
      Dialog.Caption :=  Dialog.FPropName + ' - ' + Dialog.Caption;

      { Copy string list of property into the memo field of the dialog }
      Dialog.EdtStrings.Lines := TStrings( GetOrdValue );
      Dialog.UpdateLineColStatus;      { Update initial cursor position status }
      Dialog.FModified := False;

      Dialog.BtnCodeEditor.Enabled := Ident <> '';

      case Dialog.ShowModal of
        mrOK:
          SetOrdValue( Longint( Dialog.EdtStrings.Lines ) );

        mrYes:
        begin
          {$IFDEF VCL60_OR_HIGHER}
          StFilSys.Register;
          {$ENDIF}

          Stream := TStringStream.Create( '' );
          Dialog.EdtStrings.Lines.SaveToStream( Stream );
          Stream.Position := 0;
          Age := Now;
          Module := ModuleServices.CreateModule( TRzStringsModuleCreator.Create( Ident, Stream, Age ) );
          if Module <> nil then
          begin
            with StringsFileSystem.GetTStringsProperty( Ident, Component, GetName ) do
              DiskAge := DateTimeToFileDate( Age );
            Editor := Module.GetModuleFileEditor( 0 );
            if Dialog.FModified then
              Editor.MarkModified;
            Editor.Show;
          end;
        end;
      end; { case }
    finally
      Dialog.Free;
    end;
  end;
end;


resourcestring
  sRzEditorLine = 'Line';
  sRzEditorLines = 'Lines';

{=================================}
{== TRzStrListEditorDlg Methods ==}
{=================================}

procedure TRzStringListEditDlg.FormCreate(Sender: TObject);
var
  StyleBits: Byte;
begin
  Icon.Handle := LoadIcon( HInstance, 'RZDESIGNEDITORS_EDIT_ITEMS_ICON' );

  { The Contents and String Resource IDs were obtained from the StrEdit Unit }
  { in the \DELPHI\SOURCE\LIB directory }

  HelpContext := hcDStringListEditor;                      { Set Help Contexts }
  DlgOpen.HelpContext := hcDStringListLoad;
  DlgSave.HelpContext := hcDStringListSave;

  { Load String Resources for Line/Lines Label }
  SingleLine := sRzEditorLine;
  MultipleLines := sRzEditorLines;

  DelphiIni := TRegIniFile.Create( 'Software\Raize' );

  with EdtStrings.Font do
  begin
    Name := DelphiIni.ReadString( Section, 'FontName', 'MS Sans Serif' );
    Size := DelphiIni.ReadInteger( Section, 'FontSize', 8 );
    Color := DelphiIni.ReadInteger( Section, 'FontColor', clWindowText );
    StyleBits := DelphiIni.ReadInteger( Section, 'FontStyle', fsNormal );
    Style := [];
    if StyleBits and fsBoldMask = fsBoldMask then
      Style := Style + [ fsBold ];
    if StyleBits and fsItalicMask = fsItalicMask then
      Style := Style + [ fsItalic ];
    if StyleBits and fsUnderlineMask = fsUnderlineMask then
      Style := Style + [ fsUnderline ];
    if StyleBits and fsStrikeOutMask = fsStrikeOutMask then
      Style := Style + [ fsStrikeOut ];
  end;
  FTabSize := DelphiIni.ReadInteger( Section, 'TabSize', 8 );
  Width := DelphiIni.ReadInteger( Section, 'Width', 420 );
  Height := DelphiIni.ReadInteger( Section, 'Height', 320 );
  Left := DelphiIni.ReadInteger( Section, 'Left', ( Screen.Width - Width ) div 2 );
  Top := DelphiIni.ReadInteger( Section, 'Top', ( Screen.Height - Height ) div 2 );

  UpdateClipboardStatus;

  PnlToolbar.FullRepaint := False;
  PnlStatusBar.FullRepaint := False;

  if NewStyleControls then
  begin
    PnlToolbar.BorderOuter := fsNone;
    PnlButtons.BorderOuter := fsNone;
    PnlButtons.BorderSides := [ sdTop ];
    PnlStatusBar.BorderOuter := fsNone;
    PnlStatusBar.BorderSides := [ sdTop ];
    PnlStatusBar.BorderWidth := 1;
    PnlWorkSpace.BorderOuter := fsNone;
    PnlWorkSpace.BorderWidth := 2;
  end;

  SpnTabSize.FlatButtons := True;

  BtnCodeEditor.Visible := True;
end; {= TRzStrListEditorDlg.FormCreate =}


procedure TRzStringListEditDlg.FormDestroy(Sender: TObject);
begin
  DelphiIni.Free;
end;


procedure TRzStringListEditDlg.FormClose(Sender: TObject; var Action: TCloseAction);
var
  StyleBits: Byte;
begin
  with EdtStrings.Font do
  begin
    DelphiIni.WriteString( Section, 'FontName', Name );
    DelphiIni.WriteInteger( Section, 'FontSize', Size );
    DelphiIni.WriteInteger( Section, 'FontColor', Color );

    StyleBits := 0;
    if fsBold in Style then
      StyleBits := fsBoldMask;
    if fsItalic in Style then
      StyleBits := StyleBits + fsItalicMask;
    if fsUnderline in Style then
      StyleBits := StyleBits + fsUnderlineMask;
    if fsStrikeOut in Style then
      StyleBits := StyleBits + fsStrikeOutMask;
    DelphiIni.WriteInteger( Section, 'FontStyle', StyleBits );
  end;
  DelphiIni.WriteInteger( Section, 'TabSize', FTabSize );
  DelphiIni.WriteInteger( Section, 'Left', Left );
  DelphiIni.WriteInteger( Section, 'Top', Top );
  DelphiIni.WriteInteger( Section, 'Width', Width );
  DelphiIni.WriteInteger( Section, 'Height', Height );
end;


procedure TRzStringListEditDlg.BtnFontClick(Sender: TObject);
begin
  DlgFont.Font := EdtStrings.Font;
  if DlgFont.Execute then
  begin
    EdtStrings.Font := DlgFont.Font;           { Assign new font to Memo field }
  end;
end;


procedure TRzStringListEditDlg.BtnUndoClick(Sender: TObject);
begin
  EdtStrings.Perform( wm_Undo, 0, 0 );
end;


procedure TRzStringListEditDlg.BtnCutClick(Sender: TObject);
begin
  EdtStrings.CutToClipboard;
  UpdateClipboardStatus;
end;


procedure TRzStringListEditDlg.BtnCopyClick(Sender: TObject);
begin
  EdtStrings.CopyToClipboard;
  UpdateClipboardStatus;
end;


procedure TRzStringListEditDlg.BtnPasteClick(Sender: TObject);
begin
  EdtStrings.PasteFromClipboard;
end;


procedure TRzStringListEditDlg.BtnOpenClick(Sender: TObject);
begin
  if DlgOpen.Execute then
    EdtStrings.Lines.LoadFromFile( DlgOpen.FileName );
end;


procedure TRzStringListEditDlg.BtnSaveClick(Sender: TObject);
begin
  if DlgSave.Execute then
    EdtStrings.Lines.SaveToFile( DlgSave.FileName );
end;


procedure TRzStringListEditDlg.BtnPrintClick(Sender: TObject);
const
  LM = '        ';
var
  I: Integer;
  PrintText: TextFile;
  Header: string;
begin
  if DlgPrint.Execute then
  begin
    PbrPrint.TotalParts := EdtStrings.Lines.Count;

    AssignPrn( PrintText );
    try
      Rewrite( PrintText );
      try
        Printer.Canvas.Font.Name := 'Arial';
        Printer.Canvas.Font.Style := [ fsBold ];
        Printer.Canvas.Font.Size := 12;

        Header := 'Contents of the ';
        if FPropName <> '' then
          Header := Header + FPropName + ' ';
        Header := Header + 'String List';

        Writeln( PrintText );
        Writeln( PrintText );
        Writeln( PrintText, LM, Header );
        Writeln( PrintText );
        Header := 'Printed on ' + FormatDateTime( 'ddddd "at" t', Now );
        Writeln( PrintText, LM, Header );

        Printer.Canvas.Font.Name := 'Courier New';
        Printer.Canvas.Font.Style := [];
        Printer.Canvas.Font.Size := 10;

        for I := 0 to EdtStrings.Lines.Count - 1 do
        begin
          Writeln( PrintText, LM, EdtStrings.Lines[ I ] );   { Print each line }
          PbrPrint.IncPartsByOne;          { Update percentage of Progress Bar }
        end;
      finally
        CloseFile( PrintText );        { Ensures that Printer File gets closed }
      end;
    finally
      PbrPrint.Percent := 0;
    end;
  end;
end;  {= TRzStrListEditorDlg.BtnPrintClick =}


function TRzStringListEditDlg.EndOfLine( LineNum: Integer ): Integer;
var
  L: Longint;
  P: Integer;
begin
  with EdtStrings do
  begin
    L := Perform( em_LineIndex, LineNum + 1, 0 ) - 2;
    if Integer( L ) < 0 then
    begin
      L := Perform( em_LineIndex, LineNum, 0 );
      P := Perform( em_LineLength, L, 0 );
      Result := L + P;
    end
    else
      Result := L;
  end;
end;


procedure TRzStringListEditDlg.IndentLine( LineNum: Integer );
begin
  with EdtStrings do
  begin
    { Move to Beginning of line and insert tab }
    SelStart := Perform( em_LineIndex, LineNum, 0 );
    Perform( wm_Char, vk_tab, 0 );
    { Move cursor to end of line }
    SelStart := EndOfLine( LineNum );
    UpdateLineColStatus;
  end;
end;


function TRzStringListEditDlg.UnindentLine( LineNum: Integer ): Boolean;
var
  L: string;
begin
  L := EdtStrings.Lines[ LineNum ];
  if ( Length( L ) > 0 ) and ( L[ 1 ] = #9 ) then
  begin
    { Move to Beginning of line and remove first character }
    EdtStrings.SelStart := Perform( em_LineIndex, LineNum, 0 );
    Perform( wm_KeyDown, vk_Delete, 0 );
    Perform( wm_KeyUp, vk_Delete, 0 );

    { Move cursor to end of line }
    EdtStrings.SelStart := EndOfLine( LineNum );
    Result := True;
    UpdateLineColStatus;
  end
  else
    Result := False;
end; {= TRzStrListEditorDlg.UnindentLine =}


procedure TRzStringListEditDlg.IndentLines( Indent: Boolean );
var
  I, StartLine, StopLine: Integer;
  OldSelStart, OldSelLength: Integer;
  LineCount, P: Integer;
begin
  with EdtStrings do
  begin
    StartLine := Perform( em_LineFromChar, SelStart, 0 );
    StopLine := Perform( em_LineFromChar, SelStart + SelLength, 0 );

    SelStart := Perform( em_LineIndex, StartLine, 0 );
    P := EndOfLine( StopLine );
    SelLength := P - SelStart;

    OldSelStart := SelStart;
    OldSelLength := SelLength;

    LineCount := 0;
    for I := StartLine to StopLine do   { For each line in the selection block }
    begin
      if Indent then
        IndentLine( I )
      else
      begin
        if UnindentLine( I ) then
          Inc( LineCount );
      end;
    end;

    SelStart := OldSelStart;                     { Re-establish text selection }
    if Indent then
      SelLength := OldSelLength + StopLine - StartLine
    else
      SelLength := OldSelLength - LineCount;

  end;
end; {= TRzStrListEditorDlg.IndentLines =}


procedure TRzStringListEditDlg.BtnUnindentClick(Sender: TObject);
begin
  if EdtStrings.SelLength <> 0 then
    IndentLines( False )
  else
    UnindentLine( FCurLine );
  UpdateClipboardStatus;
end;


procedure TRzStringListEditDlg.BtnIndentClick(Sender: TObject);
begin
  with EdtStrings do
  begin
    if SelLength <> 0 then
      IndentLines( True )
    else
      IndentLine( FCurLine );
  end;
  UpdateClipboardStatus;
end;


procedure TRzStringListEditDlg.EdtStringsChange(Sender: TObject);
var
  Count: Integer;
  LineText: string[ 15 ];
begin
  FModified := True;
  Count := EdtStrings.Lines.Count;
  if Count = 1 then
    LineText := SingleLine
  else
    LineText := MultipleLines;
  LblCount.Caption := Format( '%d %s', [ Count, LineText ] );

  UpdateButtonStatus;
  UpdateLineColStatus;
end;


procedure TRzStringListEditDlg.EdtStringsKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  UpdateLineColStatus;
  { If user presses Esc key while in Memo, the Dialog is cancelled }
  if Key = vk_Escape then
    BtnCancel.Click;
end;


procedure TRzStringListEditDlg.EdtStringsKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  UpdateLineColStatus;
end;


procedure TRzStringListEditDlg.EdtStringsClick(Sender: TObject);
begin
  UpdateLineColStatus;
end;


procedure TRzStringListEditDlg.UpdateLineColStatus;
begin
  { Get current line from cursor position }
  FCurLine := EdtStrings.Perform( em_LineFromChar, EdtStrings.SelStart, 0 );
  { Get current column from cursor position }
  FCurCol := EdtStrings.SelStart - EdtStrings.Perform( em_LineIndex, FCurLine, 0 );

  LblLine.Caption := IntToStr( FCurLine + 1 );
  LblCol.Caption := IntToStr( FCurCol + 1 );
  UpdateClipboardStatus;
end;


procedure TRzStringListEditDlg.UpdateClipboardStatus;
var
  HasText: Boolean;
  HasSelection: Boolean;
begin
  HasSelection := EdtStrings.SelLength <> 0;
  BtnCut.Enabled := HasSelection;           { Cut and Copy are only enabled if }
  MnuCut.Enabled := HasSelection;            { the user has selected some text }
  BtnCopy.Enabled := HasSelection;
  MnuCopy.Enabled := HasSelection;

  HasText := Clipboard.HasFormat( cf_Text );
  BtnPaste.Enabled := HasText;                  { Paste is only enabled if the }
  MnuPaste.Enabled := HasText;                       { Clipboard contents Text }
end;


procedure TRzStringListEditDlg.UpdateButtonStatus;
var
  Enable: Boolean;
begin
  Enable := EdtStrings.Lines.Count <> 0;
  { No point in Unindenting, Saving, or Printing when there is no text in memo }
  BtnUnindent.Enabled := Enable;
  BtnSave.Enabled := Enable;
  BtnPrint.Enabled := Enable;
end;


procedure TRzStringListEditDlg.EdtStringsMouseUp( Sender: TObject;
                                                 Button: TMouseButton;
                                                 Shift: TShiftState;
                                                 X, Y: Integer);
begin
  UpdateClipboardStatus;
end;


procedure TRzStringListEditDlg.BtnTabSizeClick(Sender: TObject);
begin
  if BtnTabSize.Down then
  begin
    { When the TabSize button is pressed, all of the controls in the dialog    }
    { are disabled, in effect creating a modal state in which the tab size of  }
    { the memo field can be updated.                                           }

    SpnTabSize.Visible := True;
    BtnSetTabSize.Visible := True;
    BtnCancelTabSize.Visible := True;
    EnableButtons( False );                              { Disable All Buttons }

    SpnTabSize.Value := FTabSize;
    SpnTabSize.SetFocus;
  end
  else
    BtnSetTabSizeClick( BtnCancelTabSize );
end; {= TRzStrListEditorDlg.BtnTabSizeClick =}


procedure TRzStringListEditDlg.SetTabSize;
var
  TabStop: Integer;
begin
  if FTabSize < 0 then
    FTabSize := -FTabSize;
  TabStop := FTabSize * 4;              { Roughly 4 Dialog units per character }
  EdtStrings.Perform( em_SetTabStops, 1, Longint( @TabStop ) );
  EdtStrings.Invalidate;
end;


procedure TRzStringListEditDlg.BtnSetTabSizeClick(Sender: TObject);
begin
  if Sender = BtnSetTabSize then
  begin
    try
      FTabSize := SpnTabSize.IntValue;
    except
    end;
    SetTabSize;
  end;

  SpnTabSize.Visible := False;
  BtnSetTabSize.Visible := False;
  BtnCancelTabSize.Visible := False;
  BtnTabSize.Down := False;
  EnableButtons( True );
  EdtStrings.SetFocus;
end;


procedure TRzStringListEditDlg.EnableButtons( Enable: Boolean );
var
  SysMenu: HMenu;
begin
  BtnUnindent.Enabled := Enable;
  BtnIndent.Enabled := Enable;
  BtnOpen.Enabled := Enable;
  BtnSave.Enabled := Enable;
  BtnPrint.Enabled := Enable;
  BtnUndo.Enabled := Enable;
  BtnFont.Enabled := Enable;
  BtnOK.Enabled := Enable;
  BtnCancel.Enabled := Enable;
  BtnCodeEditor.Enabled := Enable;

  EdtStrings.Enabled := Enable;

  BtnCut.Enabled := Enable;
  BtnCopy.Enabled := Enable;
  BtnPaste.Enabled := Enable;
  if Enable then
    UpdateClipboardStatus;
  if Enable then
    UpdateButtonStatus;

  { Disable the Close menu item, so dialog cannot be closed }
  SysMenu := GetSystemMenu( Handle, False );
  if Enable then
    EnableMenuItem( SysMenu, sc_Close, mf_ByCommand or mf_Enabled )
  else
    EnableMenuItem( SysMenu, sc_Close, mf_ByCommand or mf_Disabled or mf_Grayed );
end; {= TRzStringListEditDlg.EnableButtons =}


procedure TRzStringListEditDlg.FormShow(Sender: TObject);
begin
  SetTabSize;
end;


procedure TRzStringListEditDlg.WMGetMinMaxInfo( var Msg: TWMGetMinMaxInfo );
begin
  Msg.MinMaxInfo^.ptMinTrackSize := Point( 410, 220 );
end;


procedure TRzStringListEditDlg.BtnCodeEditorClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

end.

