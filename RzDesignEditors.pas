{===============================================================================
  RzDesignEditors Unit

  Raize Components - Design Editor Source Unit


  Design Editors                Description
  ---------------------------------------------------------------------------
  TRzComponentEditor            TComponentEditor descendant--implements
                                  EditPropertyByName and MenuBitmapResourceName
                                  methods.
  TRzDefaultEditor              TDefaultEditor descendant--implements
                                  EditPropertyByName and MenuBitmapResourceName
                                  methods.

  TRzFrameControllerEditor      Adds context menu to quickly change all
                                  connected controls to underline style.
  TRzStatusBarEditor            Adds context menu to quickly add status panes.
  TRzGroupBoxEditor             Adds context menu to TRzGroupBox to quickly
                                  change styles
  TRzPageControlEditor          Adds context menu to add new pages, and to cycle
                                  through existing pages.
  TRzTabControlEditor           Adds context menu to cycle through existing tabs.
  TRzSizePanelEditor            Adds context menu to TRzSizePanel component.
  TRzCheckBoxEditor             Adds context menu to set Checked property.
  TRzRadioButtonEditor          Adds context menu to set Checked property.
  TRzMemoEditor                 Adds context menu to TRzMemo component.
  TRzRichEditEditor             Adds context menu to TRzRichEdit component.
  TRzListBoxEditor              Adds context menu to TRzListBox component.
  TRzRankListBoxEditor          Adds context menu to TRzRankListBox component.
  TRzComboBoxEditor             Adds context menu to TRzComboBox component.
  TRzMRUComboBoxEditor          Adds context menu to TRzMRUComboBox component.
  TRzImageComboBoxEditor        Adds context menu to TRzImageComboBox component.
  TRzListViewEditor             Adds context menu to TRzListView component.
  TRzTreeViewEditor             Adds context menu to TRzTreeView component.
  TRzCheckTreeEditor            Adds context menu to TRzCheckTree component.
  TRzBackgroundEditor           Adds context menu to TRzBackground component.
  TRzTrackBarEditor             Adds context menu to TRzTrackBar component.
  TRzProgressBarEditor          Adds context menu to TRzProgressBar component.
  TRzFontListEditor             Adds context menu to TRzFontComboBox and
                                  TRzFontListBox components.
  TRzEditControlEditor          Adds context menu to TRzEdit component.
  TRzButtonEditEditor           Adds context menu to TRzButtonEdit component.
  TRzNumericEditEditor          Adds context menu to TRzNumericEdit component.
  TRzSpinEditEditor             Adds context menu to TRzSpinEdit component.
  TRzSpinnerEditor              Adds context menu to TRzSpinner component.
  TRzLookupDialogEditor         Adds context menu to TRzLookupDialog component.
  TRzDialogButtonsEditor        Adds context menu to TRzDialogButtons component.
  TRzFormEditor                 Adds context menu to TForm components to quickly
                                  add RzToolbars, RzStatusBars, etc.
  TRzFrameEditor                Adds context menu to TFrame components to
                                  quickly add RzToolbars, RzStatusBars, etc.
  TRzDateTimeEditEditor         Adds context menu to TRzDateTimeEdit component
                                  to switch EditType.
  TRzCalendarEditor             Adds context menu to TRzCalendar component.
  TRzTimePickerEditor           Adds context menu to TRzTimePicker component.
  TRzColorPickerEditor          Adds context menu to TRzColorPicker component.
  TRzColorEditEditor            Adds context menu to TRzColorEdit component.
  TRzLEDDisplayEditor           Adds context menu to TRzLEDDisplay component.
  TRzStatusPaneEditor           Adds context menu to TRzStatusPane component.
  TRzGlyphStatusEditor          Adds context menu to TRzGlyphStatus component.
  TRzMarqueeStatusEditor        Adds context menu to TRzMarqueeStatus component.
  TRzClockStatusEditor          Adds context menu to TRzClockStatus component.
  TRzKeyStatusEditor            Adds context menu to TRzKeyStatus component.
  TRzVersionInfoStatusEditor    Adds context menu to TRzVersionInfoStatus
                                  component.
  TRzResourceStatusEditor       Adds context menu to TRzResourceStatus component.
  TRzLineEditor                 Adds context menu to TRzLine component.
  TRzCustomColorsEditor         Adds context menu to TRzCustomColors component.
  TRzShapeButtonEditor          Adds context menu to TRzShapeButton component.
  TRzFormStateEditor            Adds context menu to TRzFormState component.
  TRzBorderEditor               Adds context menu to TRzBorder component.
  TRzTrayIconEditor             Adds context menu to TRzTrayIcon component.
  TRzAnimatorEditor             Adds context menu to TRzAnimator component.
  TRzSeparatorEditor            Adds context menu to TRzSeparator component.
  TRzSpacerEditor               Adds context menu to TRzSpacer component.
  TRzBalloonHintsEditor         Adds context menu to TRzBalloonHints component.
  TRzStringGridEditor           Adds context menu to TRzStringGrid component.

  ----

  TRzFrameStyleProperty         Displays list of frames styles along with a
                                  sample of each style.
  TRzComboBoxTextProperty       Displays list of strings in the Items property.
  TRzActivePageProperty         Provides list of available pages on the current
                                  TRzPageControl.
  TRzDateTimeFormatProperty     Provides list of format strings for changing
                                  date and time formats.
  TRzClockStatusFormatProperty  Provides list of format strings for changing
                                  date and time format in TRzClockStatus.
  TRzDTPFormatProperty          Provides list of format strings for controlling
                                  the display of date and time.
  TRzSpinValueProperty          Applies Decimals property to new value assigned
                                  to Value property.
  TRzSpinnerGlyphProperty       Prevents the user from editing the old GlyphPlus
                                  and GlyphMinus properties since we can't
                                  remove them from the component.
  TRzFileNameProperty           Uses common dialog to select a program or file
                                  to launch.
  TRzActionProperty             Displays a list of possible actions (e.g. Open,
                                  Explore, Print).
  TRzCustomColorsProperty       Uses a common Color dialog to specify new custom
                                  colors.

  TRzAlignProperty
  TRzBooleanProperty

  TRzPaletteSep                 Empty component used for adding a separator to
                                  component palette.


  Modification History
  ------------------------------------------------------------------------------
  3.0.10 (26 Dec 2003)
    * Added TRzPageControlSprig and TRzTabSheetSprig classes to handle
      displaying the tab sheets in a TRzPageControl appropriately in the Object
      Tree View.
  ------------------------------------------------------------------------------
  3.0.9  (22 Sep 2003)
    * Added TRzDateTimeFormatProperty editor which handles displaying date and
      time format strings in a dropdown list for TRzDateTimeEdit and
      TRzTimePicker controls.
  ------------------------------------------------------------------------------
  3.0.8  (29 Aug 2003)
    * Fixed problem where Traditional Style context menu item had no effect on a
      TRzGlyphStatus.
    * Fixed problem where TRzFormShape component editor would not update form
      designer of changes.
    * Added "Remove Border" item to TRzBorderEditor.
    * Fixed problem where Show Color Hints and Auto Size menu items for
      TRzColorPicker did not show correct state.
    * Added TRzStringGridEditor.
    * Added "Add a Size Panel" item to TRzFormEditor.
    * Added TRzFrameEditor, which is similar to the TRzFormEditor in that it
      provides a quick way to add various controls to the frame.
    * Added "Add a Group Bar" and "Add a Panel" items to TRzSizePanelEditor.
    * Fixed problem where TRzPageControl tab sheets (TRzTabSheet) were not
      selectable when the page control was created on a TFrame.
    * Added "Show Groups" item to TRzListBoxEditor and to TRzRankListBoxEditor.
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)  * Initial release.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzDesignEditors;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  Windows,
  Classes,
  Controls,
  Graphics,
  ImgList,
  Menus,
  Forms,
  {$IFDEF VCL60_OR_HIGHER}
  DesignIntf,
  DesignEditors,
  VCLEditors,
  DesignMenus,
  TreeIntf,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  RzCommon,
  RzEdit,
  RzStatus,
  RzLstBox,
  RzLine,
  RzTabs,
  RzRadChk,
  RzCmboBx,
  RzPanel,
  RzSplit,
  RzListVw,
  RzTreeVw,
  RzDlgBtn,
  RzBckgnd,
  RzBorder,
  RzTrkBar,
  RzPrgres,
  RzBtnEdt,
  RzSpnEdt,
  RzTray,
  RzForms,
  RzPopups,
  RzAnimtr,
  RzBHints,
  RzGrids;

const
  ppRaizePanels  = 'Raize Panels';
  ppRaizeEdits   = 'Raize Edits';
  ppRaizeLists   = 'Raize Lists';
  ppRaizeButtons = 'Raize Buttons';
  ppRaizeDisplay = 'Raize Display';
  ppRaizeShell   = 'Raize Shell';
  ppRaizeWidgets = 'Raize Widgets';

  RC_SettingsKey = 'Software\Raize\Raize Components\3.0';
  RegisterSection = 'Register';

type
  {== Base Component Editors ==========================================================================================}

  {==========================================}
  {== TRzComponentEditor Class Declaration ==}
  {==========================================}

  TRzComponentEditor = class( TComponentEditor )
  private
    FPropName: string;
    FContinue: Boolean;
    {$IFDEF VCL60_OR_HIGHER}
    FPropEditor: IProperty;
    procedure EnumPropertyEditors( const PropertyEditor: IProperty );
    procedure TestPropertyEditor( const PropertyEditor: IProperty; var Continue: Boolean );
    {$ELSE}
    FPropEditor: TPropertyEditor;
    procedure EnumPropertyEditors( PropertyEditor: TPropertyEditor );
    procedure TestPropertyEditor( PropertyEditor: TPropertyEditor; var Continue, FreeEditor: Boolean );
    {$ENDIF}
    procedure AlignMenuHandler( Sender: TObject );
    procedure ImageListMenuHandler( Sender: TObject );
    procedure RegIniFileMenuHandler( Sender: TObject );
  protected
    procedure EditPropertyByName( const APropName: string );
    function AlignMenuIndex: Integer; virtual;
    function MenuBitmapResourceName( Index: Integer ): string; virtual;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; virtual;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); virtual;
  public
    {$IFDEF VER13x}
    procedure PrepareItem( Index: Integer; const AItem: TMenuItem ); override;
    {$ENDIF}
    {$IFDEF VCL60_OR_HIGHER}
    procedure PrepareItem( Index: Integer; const AItem: IMenuItem ); override;
    {$ENDIF}
  end;


  {========================================}
  {== TRzDefaultEditor Class Declaration ==}
  {========================================}

  TRzDefaultEditor = class( TDefaultEditor )
  private
    FPropName: string;
    FContinue: Boolean;
    {$IFDEF VCL60_OR_HIGHER}
    FPropEditor: IProperty;
    procedure EnumPropertyEditors( const PropertyEditor: IProperty );
    procedure TestPropertyEditor( const PropertyEditor: IProperty; var Continue: Boolean );
    {$ELSE}
    FPropEditor: TPropertyEditor;
    procedure EnumPropertyEditors( PropertyEditor: TPropertyEditor );
    procedure TestPropertyEditor( PropertyEditor: TPropertyEditor; var Continue, FreeEditor: Boolean );
    {$ENDIF}
    procedure AlignMenuHandler( Sender: TObject );
    procedure ImageListMenuHandler( Sender: TObject );
    procedure RegIniFileMenuHandler( Sender: TObject );
  protected
    procedure EditPropertyByName( const APropName: string );
    function AlignMenuIndex: Integer; virtual;
    function MenuBitmapResourceName( Index: Integer ): string; virtual;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; virtual;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); virtual;
  public
    {$IFDEF VER13x}
    procedure PrepareItem( Index: Integer; const AItem: TMenuItem ); override;
    {$ENDIF}
    {$IFDEF VCL60_OR_HIGHER}
    procedure PrepareItem( Index: Integer; const AItem: IMenuItem ); override;
    {$ENDIF}
  end;


  {== Component Editors ===============================================================================================}

  {================================================}
  {== TRzFrameControllerEditor Class Declaration ==}
  {================================================}

  TRzFrameControllerEditor = class( TRzComponentEditor )
  protected
    function FrameController: TRzFrameController;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {==========================================}
  {== TRzStatusBarEditor Class Declaration ==}
  {==========================================}

  TRzStatusBarEditor = class( TRzComponentEditor )
  protected
    function StatusBar: TRzStatusBar;
    function MenuBitmapResourceName( Index: Integer ): string; override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
    procedure Edit; override;
  end;


  {=========================================}
  {== TRzGroupBoxEditor Class Declaration ==}
  {=========================================}

  TRzGroupBoxEditor = class( TRzDefaultEditor )
  protected
    function GroupBox: TRzGroupBox;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzPageControlEditor Class Declaration ==}
  {============================================}

  TRzPageControlEditor = class( TRzDefaultEditor )
  protected
    function PageControl: TRzPageControl;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure StyleMenuHandler( Sender: TObject );
    procedure OrientationMenuHandler( Sender: TObject );
    procedure ImageListMenuHandler( Sender: TObject );
    procedure AlignMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;

  {$IFDEF VCL60_OR_HIGHER}

  TRzPageControlSprig = class( TComponentSprig )
  public
    constructor Create( AItem: TPersistent ); override;
    function SortByIndex: Boolean; override;
  end;


  TRzTabSheetSprig = class( TComponentSprig )
  public
    constructor Create( AItem: TPersistent ); override;
    function Caption: string; override;
    function ItemIndex: Integer; override;
    function Hidden: Boolean; override;
  end;

  {$ENDIF}

  {===========================================}
  {== TRzTabControlEditor Class Declaration ==}
  {===========================================}

  TRzTabControlEditor = class( TRzDefaultEditor )
  private
    procedure Skip( Next: Boolean );
  protected
    function TabControl: TRzTabControl;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure StyleMenuHandler( Sender: TObject );
    procedure OrientationMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {==========================================}
  {== TRzSizePanelEditor Class Declaration ==}
  {==========================================}

  TRzSizePanelEditor = class( TRzComponentEditor )
  protected
    function SizePanel: TRzSizePanel;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=========================================}
  {== TRzCheckBoxEditor Class Declaration ==}
  {=========================================}

  TRzCheckBoxEditor = class( TRzDefaultEditor )
  protected
    function CheckBox: TRzCheckBox;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzRadioButtonEditor Class Declaration ==}
  {============================================}

  TRzRadioButtonEditor = class( TRzDefaultEditor )
  protected
    function RadioButton: TRzRadioButton;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=====================================}
  {== TRzMemoEditor Class Declaration ==}
  {=====================================}

  TRzMemoEditor = class( TRzDefaultEditor )
  protected
    function GetWordWrap: Boolean; virtual;
    procedure SetWordWrap( Value: Boolean ); virtual;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;

    property WordWrap: Boolean
      read GetWordWrap
      write SetWordWrap;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=========================================}
  {== TRzRichEditEditor Class Declaration ==}
  {=========================================}

  TRzRichEditEditor = class( TRzMemoEditor )
  protected
    function GetWordWrap: Boolean; override;
    procedure SetWordWrap( Value: Boolean ); override;
  end;


  {========================================}
  {== TRzListBoxEditor Class Declaration ==}
  {========================================}

  TRzListBoxEditor = class( TRzDefaultEditor )
  protected
    function ListBox: TRzListBox;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzRankListBoxEditor Class Declaration ==}
  {============================================}

  TRzRankListBoxEditor = class( TRzDefaultEditor )
  protected
    function ListBox: TRzRankListBox;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=========================================}
  {== TRzComboBoxEditor Class Declaration ==}
  {=========================================}

  TRzComboBoxEditor = class( TRzDefaultEditor )
  protected
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzMRUComboBoxEditor Class Declaration ==}
  {============================================}

  TRzMRUComboBoxEditor = class( TRzComboBoxEditor )
  public
    function GetVerbCount: Integer; override;
  end;


  {==============================================}
  {== TRzImageComboBoxEditor Class Declaration ==}
  {==============================================}

  TRzImageComboBoxEditor = class( TRzDefaultEditor )
  protected
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
  end;


  {=========================================}
  {== TRzListViewEditor Class Declaration ==}
  {=========================================}

  TRzListViewEditor = class( TRzDefaultEditor )
  protected
    function ListView: TRzListView;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure ViewStyleMenuHandler( Sender: TObject );
    procedure SmallImagesMenuHandler( Sender: TObject );
    procedure LargeImagesMenuHandler( Sender: TObject );
    procedure StateImagesMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=========================================}
  {== TRzTreeViewEditor Class Declaration ==}
  {=========================================}

  TRzTreeViewEditor = class( TRzComponentEditor )
  protected
    function TreeView: TRzTreeView;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
    procedure ImagesMenuHandler( Sender: TObject );
    procedure StateImagesMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {==========================================}
  {== TRzCheckTreeEditor Class Declaration ==}
  {==========================================}

  TRzCheckTreeEditor = class( TRzTreeViewEditor )
  protected
    function CheckTree: TRzCheckTree;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;

  {===========================================}
  {== TRzBackgroundEditor Class Declaration ==}
  {===========================================}

  TRzBackgroundEditor = class( TRzDefaultEditor )
  protected
    function Background: TRzBackground;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure GradientDirectionMenuHandler( Sender: TObject );
    procedure ImageStyleMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=========================================}
  {== TRzTrackBarEditor Class Declaration ==}
  {=========================================}

  TRzTrackBarEditor = class( TRzDefaultEditor )
  protected
    function TrackBar: TRzTrackBar;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure ThumbStyleMenuHandler( Sender: TObject );
    procedure TickStepMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzProgressBarEditor Class Declaration ==}
  {============================================}

  TRzProgressBarEditor = class( TRzDefaultEditor )
  protected
    function ProgressBar: TRzProgressBar;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=========================================}
  {== TRzFontListEditor Class Declaration ==}
  {=========================================}

  TRzFontListEditor = class( TRzDefaultEditor )
  protected
    function AlignMenuIndex: Integer; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure ShowStyleMenuHandler( Sender: TObject );
    procedure FontTypeMenuHandler( Sender: TObject );
    procedure FontDeviceMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzEditControlEditor Class Declaration ==}
  {============================================}

  TRzEditControlEditor = class( TRzDefaultEditor )
  protected
    function EditControl: TRzCustomEdit;
    function AlignMenuIndex: Integer; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {===========================================}
  {== TRzButtonEditEditor Class Declaration ==}
  {===========================================}

  TRzButtonEditEditor = class( TRzDefaultEditor )
  protected
    function ButtonEdit: TRzButtonEdit;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure ButtonKindMenuHandler( Sender: TObject );
    procedure AltBtnKindMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzNumericEditEditor Class Declaration ==}
  {============================================}

  TRzNumericEditEditor = class( TRzDefaultEditor )
  protected
    function NumericEdit: TRzNumericEdit;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=========================================}
  {== TRzSpinEditEditor Class Declaration ==}
  {=========================================}

  TRzSpinEditEditor = class( TRzDefaultEditor )
  protected
    function SpinEdit: TRzSpinEdit;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure DirectionMenuHandler( Sender: TObject );
    procedure OrientationMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzSpinButtonsEditor Class Declaration ==}
  {============================================}

  TRzSpinButtonsEditor = class( TRzDefaultEditor )
  protected
    function SpinButtons: TRzSpinButtons;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure DirectionMenuHandler( Sender: TObject );
    procedure OrientationMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {========================================}
  {== TRzSpinnerEditor Class Declaration ==}
  {========================================}

  TRzSpinnerEditor = class( TRzDefaultEditor )
  protected
    function Spinner: TRzSpinner;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=============================================}
  {== TRzLookupDialogEditor Class Declaration ==}
  {=============================================}

  TRzLookupDialogEditor = class( TRzComponentEditor )
  protected
    function MenuBitmapResourceName( Index: Integer ): string; override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {==============================================}
  {== TRzDialogButtonsEditor Class Declaration ==}
  {==============================================}

  TRzDialogButtonsEditor = class( TRzDefaultEditor )
  protected
    function DialogButtons: TRzDialogButtons;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=====================================}
  {== TRzFormEditor Class Declaration ==}
  {=====================================}

  TRzFormEditor = class( TRzDefaultEditor )
  protected
    function Form: TForm;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure StyleMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {======================================}
  {== TRzFrameEditor Class Declaration ==}
  {======================================}

  TRzFrameEditor = class( TRzDefaultEditor )
  protected
    function Frame: TFrame;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure StyleMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=============================================}
  {== TRzDateTimeEditEditor Class Declaration ==}
  {=============================================}

  TRzDateTimeEditEditor = class( TRzDefaultEditor )
  protected
    function DateTimeEdit: TRzDateTimeEdit;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure ElementsMenuHandler( Sender: TObject );
    procedure FirstDayOfWeekMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=========================================}
  {== TRzCalendarEditor Class Declaration ==}
  {=========================================}

  TRzCalendarEditor = class( TRzDefaultEditor )
  protected
    function Calendar: TRzCalendar;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure ElementsMenuHandler( Sender: TObject );
    procedure FirstDayOfWeekMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {===========================================}
  {== TRzTimePickerEditor Class Declaration ==}
  {===========================================}

  TRzTimePickerEditor = class( TRzDefaultEditor )
  protected
    function TimePicker: TRzTimePicker;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;



  {============================================}
  {== TRzColorPickerEditor Class Declaration ==}
  {============================================}

  TRzColorPickerEditor = class( TRzDefaultEditor )
  protected
    function ColorPicker: TRzColorPicker;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure CustomColorsMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {==========================================}
  {== TRzColorEditEditor Class Declaration ==}
  {==========================================}

  TRzColorEditEditor = class( TRzDefaultEditor )
  protected
    function ColorEdit: TRzColorEdit;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure CustomColorsMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {===========================================}
  {== TRzLEDDisplayEditor Class Declaration ==}
  {===========================================}

  TRzLEDDisplayEditor = class( TRzDefaultEditor )
  protected
    function LEDDisplay: TRzLEDDisplay;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {===========================================}
  {== TRzStatusPaneEditor Class Declaration ==}
  {===========================================}

  TRzStatusPaneEditor = class( TRzComponentEditor )
  protected
    function FlatStyleMenuIndex: Integer; virtual;
    function TraditionalStyleMenuIndex: Integer; virtual;
    function AutoSizeMenuIndex: Integer; virtual;
    function AlignmentMenuIndex: Integer; virtual;
    function BlinkingMenuIndex: Integer; virtual;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure AlignmentMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzGlyphStatusEditor Class Declaration ==}
  {============================================}

  TRzGlyphStatusEditor = class( TRzStatusPaneEditor )
  protected
    function GlyphStatus: TRzGlyphStatus;
    function FlatStyleMenuIndex: Integer; override;
    function TraditionalStyleMenuIndex: Integer; override;
    function AutoSizeMenuIndex: Integer; override;
    function AlignmentMenuIndex: Integer; override;
    function BlinkingMenuIndex: Integer; override;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure GlyphAlignmentMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {==============================================}
  {== TRzMarqueeStatusEditor Class Declaration ==}
  {==============================================}

  TRzMarqueeStatusEditor = class( TRzStatusPaneEditor )
  protected
    function MarqueeStatus: TRzMarqueeStatus;
    function FlatStyleMenuIndex: Integer; override;
    function TraditionalStyleMenuIndex: Integer; override;
    function AutoSizeMenuIndex: Integer; override;
    function AlignmentMenuIndex: Integer; override;
    function BlinkingMenuIndex: Integer; override;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzClockStatusEditor Class Declaration ==}
  {============================================}

  TRzClockStatusEditor = class( TRzStatusPaneEditor )
  protected
    function ClockStatus: TRzClockStatus;
    function FlatStyleMenuIndex: Integer; override;
    function TraditionalStyleMenuIndex: Integer; override;
    function AutoSizeMenuIndex: Integer; override;
    function AlignmentMenuIndex: Integer; override;
    function BlinkingMenuIndex: Integer; override;
    function AlignMenuIndex: Integer; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure ClockMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
  end;


  {==========================================}
  {== TRzKeyStatusEditor Class Declaration ==}
  {==========================================}

  TRzKeyStatusEditor = class( TRzStatusPaneEditor )
  protected
    function KeyStatus: TRzKeyStatus;
    function FlatStyleMenuIndex: Integer; override;
    function TraditionalStyleMenuIndex: Integer; override;
    function AutoSizeMenuIndex: Integer; override;
    function AlignmentMenuIndex: Integer; override;
    function BlinkingMenuIndex: Integer; override;
    function AlignMenuIndex: Integer; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {==================================================}
  {== TRzVersionInfoStatusEditor Class Declaration ==}
  {==================================================}

  TRzVersionInfoStatusEditor = class( TRzStatusPaneEditor )
  protected
    function VersionInfoStatus: TRzVersionInfoStatus;
    function FlatStyleMenuIndex: Integer; override;
    function TraditionalStyleMenuIndex: Integer; override;
    function AutoSizeMenuIndex: Integer; override;
    function AlignmentMenuIndex: Integer; override;
    function BlinkingMenuIndex: Integer; override;
    function AlignMenuIndex: Integer; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure VersionInfoMenuHandler( Sender: TObject );
    procedure FieldMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
  end;


  {===============================================}
  {== TRzResourceStatusEditor Class Declaration ==}
  {===============================================}

  TRzResourceStatusEditor = class( TRzStatusPaneEditor )
  protected
    function ResourceStatus: TRzResourceStatus;
    function FlatStyleMenuIndex: Integer; override;
    function TraditionalStyleMenuIndex: Integer; override;
    function AutoSizeMenuIndex: Integer; override;
    function AlignmentMenuIndex: Integer; override;
    function BlinkingMenuIndex: Integer; override;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=====================================}
  {== TRzLineEditor Class Declaration ==}
  {=====================================}

  TRzLineEditor = class( TRzComponentEditor )
  protected
    function Line: TRzLine;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure ShowArrowsMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=============================================}
  {== TRzCustomColorsEditor Class Declaration ==}
  {=============================================}

  TRzCustomColorsEditor = class( TRzComponentEditor )
  protected
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {============================================}
  {== TRzShapeButtonEditor Class Declaration ==}
  {============================================}

  TRzShapeButtonEditor = class( TRzDefaultEditor )
  protected
    function MenuBitmapResourceName( Index: Integer ): string; override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {==========================================}
  {== TRzFormStateEditor Class Declaration ==}
  {==========================================}

  TRzFormStateEditor = class( TRzComponentEditor )
  protected
    function FormState: TRzFormState;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
  end;


  {==========================================}
  {== TRzFormShapeEditor Class Declaration ==}
  {==========================================}

  TRzFormShapeEditor = class( TRzComponentEditor )
  protected
    function FormShape: TRzFormShape;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=======================================}
  {== TRzBorderEditor Class Declaration ==}
  {=======================================}

  TRzBorderEditor = class( TRzDefaultEditor )
  protected
    function Border: TRzBorder;
    function AlignMenuIndex: Integer; override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=========================================}
  {== TRzTrayIconEditor Class Declaration ==}
  {=========================================}

  TRzTrayIconEditor = class( TRzComponentEditor )
  protected
    function TrayIcon: TRzTrayIcon;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
    procedure IconsMenuHandler( Sender: TObject );
    procedure PopupMenuMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=========================================}
  {== TRzAnimatorEditor Class Declaration ==}
  {=========================================}

  TRzAnimatorEditor = class( TRzComponentEditor )
  protected
    function Animator: TRzAnimator;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    function GetCompRefData( Index: Integer; var CompRefClass: TComponentClass; var CompRefPropName: string;
                             var CompRefMenuHandler: TNotifyEvent ): Boolean; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure ImageListMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {==========================================}
  {== TRzSeparatorEditor Class Declaration ==}
  {==========================================}

  TRzSeparatorEditor = class( TRzComponentEditor )
  protected
    function Separator: TRzSeparator;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure HighlightLocationMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=======================================}
  {== TRzSpacerEditor Class Declaration ==}
  {=======================================}

  TRzSpacerEditor = class( TRzComponentEditor )
  protected
    function Spacer: TRzSpacer;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {=============================================}
  {== TRzBalloonHintsEditor Class Declaration ==}
  {=============================================}

  TRzBalloonHintsEditor = class( TRzComponentEditor )
  protected
    function BalloonHints: TRzBalloonHints;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
    procedure CornerMenuHandler( Sender: TObject );
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  {===========================================}
  {== TRzStringGridEditor Class Declaration ==}
  {===========================================}

  TRzStringGridEditor = class( TRzDefaultEditor )
  protected
    function Grid: TRzStringGrid;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ) : string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;



  {== Property Editors ================================================================================================}

  {=============================================}
  {== TRzFrameStyleProperty Class Declaration ==}
  {=============================================}

  {$IFDEF VCL60_OR_HIGHER}

  TRzFrameStyleProperty = class( TEnumProperty, ICustomPropertyDrawing, ICustomPropertyListDrawing )
  private
    FDrawingPropertyValue: Boolean;
  public
    // ICustomPropertyListDrawing
    procedure ListMeasureHeight( const Value: string; ACanvas: TCanvas; var AHeight: Integer );
    procedure ListMeasureWidth( const Value: string; ACanvas: TCanvas; var AWidth: Integer );
    procedure ListDrawValue( const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );

    // ICustomPropertyDrawing
    procedure PropDrawName( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
    procedure PropDrawValue( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
  end;


  TRzAlignProperty = class( TEnumProperty, ICustomPropertyDrawing, ICustomPropertyListDrawing )
  private
    FDrawingPropertyValue: Boolean;
  public
    // ICustomPropertyListDrawing
    procedure ListMeasureHeight( const Value: string; ACanvas: TCanvas; var AHeight: Integer );
    procedure ListMeasureWidth( const Value: string; ACanvas: TCanvas; var AWidth: Integer );
    procedure ListDrawValue( const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );

    // ICustomPropertyDrawing
    procedure PropDrawName( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
    procedure PropDrawValue( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
  end;

  TRzBooleanProperty = class( TEnumProperty, ICustomPropertyDrawing, ICustomPropertyListDrawing )
  public
    // ICustomPropertyListDrawing
    procedure ListMeasureHeight( const Value: string; ACanvas: TCanvas; var AHeight: Integer );
    procedure ListMeasureWidth( const Value: string; ACanvas: TCanvas; var AWidth: Integer );
    procedure ListDrawValue( const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );

    // ICustomPropertyDrawing
    procedure PropDrawName( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
    procedure PropDrawValue( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
  end;

  {$ENDIF}

  {$IFDEF VER13x}

  TRzFrameStyleProperty = class( TEnumProperty )
  private
    FDrawingPropertyValue: Boolean;
  public
    procedure ListMeasureHeight( const Value: string; ACanvas: TCanvas; var AHeight: Integer ); override;
    procedure ListMeasureWidth( const Value: string; ACanvas: TCanvas; var AWidth: Integer ); override;
    procedure ListDrawValue( const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean ); override;
    procedure PropDrawValue( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean ); override;
  end;

  TRzAlignProperty = class( TEnumProperty )
  private
    FDrawingPropertyValue: Boolean;
  public
    procedure ListMeasureHeight( const Value: string; ACanvas: TCanvas; var AHeight: Integer ); override;
    procedure ListMeasureWidth( const Value: string; ACanvas: TCanvas; var AWidth: Integer ); override;
    procedure ListDrawValue( const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean ); override;
    procedure PropDrawValue( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean ); override;
  end;

  TRzBooleanProperty = class( TEnumProperty )
  public
    procedure ListMeasureHeight( const Value: string; ACanvas: TCanvas; var AHeight: Integer ); override;
    procedure ListMeasureWidth( const Value: string; ACanvas: TCanvas; var AWidth: Integer ); override;
    procedure ListDrawValue( const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean ); override;
    procedure PropDrawValue( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean ); override;
  end;

  {$ENDIF}


  {===============================================}
  {== TRzComboBoxTextProperty Class Declaration ==}
  {===============================================}

  TRzComboBoxTextProperty = class( TCaptionProperty )
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues( Proc: TGetStrProc ); override;
    procedure SetValue( const Value: string ); override;
  end;


  {=============================================}
  {== TRzActivePageProperty Class Declaration ==}
  {=============================================}

  TRzActivePageProperty = class( TComponentProperty )
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues( Proc: TGetStrProc ); override;
  end;


  {=================================================}
  {== TRzDateTimeFormatProperty Class Declaration ==}
  {=================================================}

  TRzDateTimeFormatFilter = ( ffAll, ffDates, ffTimes );

  TRzDateTimeFormatProperty = class( TStringProperty )
  protected
    function FormatFilter: TRzDateTimeFormatFilter; virtual;
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues( Proc: TGetStrProc ); override;
  end;


  {====================================================}
  {== TRzClockStatusFormatProperty Class Declaration ==}
  {====================================================}

  TRzClockStatusFormatProperty = class( TRzDateTimeFormatProperty )
  protected
    function FormatFilter: TRzDateTimeFormatFilter; override;
  end;


  {============================================}
  {== TRzDTPFormatProperty Class Declaration ==}
  {============================================}

  TRzDTPFormatProperty = class( TStringProperty )
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues( Proc: TGetStrProc ); override;
  end;


  {============================================}
  {== TRzSpinValueProperty Class Declaration ==}
  {============================================}

  TRzSpinValueProperty = class( TFloatProperty )
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure SetValue( const Value: string ); override;
  end;


  {===============================================}
  {== TRzSpinnerGlyphProperty Class Declaration ==}
  {===============================================}

  TRzSpinnerGlyphProperty = class( TFloatProperty )
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;


  {===========================================}
  {== TRzFileNameProperty Class Declaration ==}
  {===========================================}

  TRzFileNameProperty = class( TStringProperty )
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;


  {=========================================}
  {== TRzActionProperty Class Declaration ==}
  {=========================================}

  TRzActionProperty = class( TStringProperty )
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues( Proc: TGetStrProc ); override;
  end;


  {===============================================}
  {== TRzCustomColorsProperty Class Declaration ==}
  {===============================================}

  TRzCustomColorsProperty = class( TClassProperty )
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;


  {== Category Classes ================================================================================================}

  {$IFDEF VER13x}

  TRzCustomFramingCategory = class( TPropertyCategory )
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TRzHotSpotCategory = class( TPropertyCategory )
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TRzBorderStyleCategory = class( TPropertyCategory )
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TRzCustomGlyphsCategory = class( TPropertyCategory )
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TRzTextStyleCategory = class( TPropertyCategory )
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TRzTrackStyleCategory = class( TPropertyCategory )
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TRzPrimaryButtonCategory = class( TPropertyCategory )
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TRzAlternateButtonCategory = class( TPropertyCategory )
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  TRzSplitterCategory = class( TPropertyCategory )
  public
    class function Name: string; override;
    class function Description: string; override;
  end;

  {$ENDIF}


{$IFDEF VCL60_OR_HIGHER}
resourcestring
  sRzCustomFramingCategoryName = 'Custom Framing';
  sRzHotSpotCategoryName = 'HotSpot';
  sRzBorderStyleCategoryName = 'Border Style';
  sRzCustomGlyphsCategoryName = 'Custom Glyphs';
  sRzTextStyleCategoryName = 'Text Style';
  sRzTrackStyleCategoryName = 'Track Style';
  sRzPrimaryButtonCategoryName = 'Button - Primary';
  sRzAlternateButtonCategoryName = 'Button - Alternate';
  sRzSplitterCategoryName = 'Splitter Style';
{$ENDIF}


type
  TRzPaletteSep = class( TComponent )
  public
    constructor Create( AOwner: TComponent ); override;
  end;

  TRzPaletteSep_Panels = class( TRzPaletteSep );
  TRzPaletteSep_Edits = class( TRzPaletteSep );
  TRzPaletteSep_Lists = class( TRzPaletteSep );
  TRzPaletteSep_Buttons = class( TRzPaletteSep );
  TRzPaletteSep_Display = class( TRzPaletteSep );
  TRzPaletteSep_Shell = class( TRzPaletteSep );
  TRzPaletteSep_Widgets = class( TRzPaletteSep );


function UniqueName( AComponent: TComponent ): string;

implementation

uses
  SysUtils,
  TypInfo,
  StdCtrls,
  ComCtrls,
  Dialogs,
  RzGrafx,
  RzButton,
  RzLookup,
  RzRadGrp,
  RzGroupBar;

{$R RzDesignEditors.res}    // Link in  bitmaps for component editors


{=====================}
{== Support Methods ==}
{=====================}

// There is no UniqueName method for TFormDesigner in Delphi 1, so we need our
// own equivalent.  The local UniqueName function is also used for Delphi 2/3
// because it makes the names nicer by removing the 'cs' prefix normally
// included (by TFormDesigner.UniqueName) for objects of type TRzTabSheet.

// Test a component name for uniqueness and return True if it is unique or False
// if there is another component with the same name.

function TryName( const AName: string; AComponent: TComponent ): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to AComponent.ComponentCount - 1 do
  begin
    if CompareText( AComponent.Components[ I ].Name, AName ) = 0 then
      Exit;
  end;
  Result := True;
end;


// Generate a unique name for a component.  Use the standard Delphi rules,
// e.g., <type><number>, where <type> is the component's class name without
// a leading 'T', and <number> is an integer to make the name unique.

function UniqueName( AComponent: TComponent ): string;
var
  I: Integer;
  Fmt: string;
begin
  // Create a Format string to use as a name template.
  if CompareText( Copy( AComponent.ClassName, 1, 3 ), 'TRz' ) = 0 then
    Fmt := Copy( AComponent.ClassName, 4, 255 ) + '%d'
  else
    Fmt := AComponent.ClassName + '%d';

  if AComponent.Owner = nil then
  begin
    // No owner; any name is unique. Use 1.
    Result := Format( Fmt, [ 1 ] );
    Exit;
  end
  else
  begin
    // Try all possible numbers until we find a unique name.
    for I := 1 to High( Integer ) do
    begin
      Result := Format( Fmt, [ I ] );
      if TryName( Result, AComponent.Owner ) then
        Exit;
    end;
  end;

  // This should never happen, but just in case...
  raise Exception.CreateFmt('Cannot create unique name for %s.', [ AComponent.ClassName ] );
end;



{== Base Component Editors ============================================================================================}

{================================}
{== TRzComponentEditor Methods ==}
{================================}

{$IFDEF VCL60_OR_HIGHER}

procedure TRzComponentEditor.EnumPropertyEditors( const PropertyEditor: IProperty );
begin
  if FContinue then
    TestPropertyEditor( PropertyEditor, FContinue );
end;


procedure TRzComponentEditor.TestPropertyEditor( const PropertyEditor: IProperty; var Continue: Boolean );
begin
  if not Assigned( FPropEditor ) and ( CompareText( PropertyEditor.GetName, FPropName ) = 0 ) then
  begin
    Continue := False;
    FPropEditor := PropertyEditor;
  end;
end;


procedure TRzComponentEditor.EditPropertyByName( const APropName: string );
var
  Components: IDesignerSelections;
begin
  Components := TDesignerSelections.Create;
  FContinue := True;
  FPropName := APropName;
  Components.Add( Component );
  FPropEditor := nil;
  try
    GetComponentProperties( Components, tkAny, Designer, EnumPropertyEditors );
    if Assigned( FPropEditor ) then
      FPropEditor.Edit;
  finally
    FPropEditor := nil;
  end;
end;

{$ELSE}

procedure TRzComponentEditor.EnumPropertyEditors( PropertyEditor: TPropertyEditor );
var
  FreeEditor: Boolean;
begin
  FreeEditor := True;
  try
    if FContinue then
      TestPropertyEditor( PropertyEditor, FContinue, FreeEditor );
  finally
    if FreeEditor then
      PropertyEditor.Free;
  end;
end;


procedure TRzComponentEditor.TestPropertyEditor( PropertyEditor: TPropertyEditor;
                                                 var Continue, FreeEditor: Boolean );
begin
  if not Assigned( FPropEditor ) and
     ( CompareText( PropertyEditor.GetName, FPropName ) = 0 ) then
  begin
    FreeEditor := False;
    Continue := False;
    FPropEditor := PropertyEditor;
  end;
end;


procedure TRzComponentEditor.EditPropertyByName( const APropName: string );
var
  Components: TDesignerSelectionList;
begin
  Components := TDesignerSelectionList.Create;
  try
    FContinue := True;
    FPropName := APropName;
    Components.Add( Component );
    FPropEditor := nil;
    try
      GetComponentProperties( Components, tkAny, Designer, EnumPropertyEditors );
      if Assigned( FPropEditor ) then
        FPropEditor.Edit;
    finally
      if Assigned( FPropEditor ) then
        FPropEditor.Free;
    end;
  finally
    Components.Free;
  end;
end;

{$ENDIF}


function TRzComponentEditor.AlignMenuIndex: Integer;
begin
  Result := -1;
end;


function TRzComponentEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  Result := '';
end;


function TRzComponentEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                            var CompRefPropName: string;
                                            var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
end;


procedure TRzComponentEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
var
  ResName: string;
  I, CompRefCount: Integer;
  CompOwner: TComponent;
  CompRefClass: TComponentClass;
  CompRefPropName: string;
  CompRefMenuHandler: TNotifyEvent;

  procedure CreateAlignItem( AlignValue: TAlign; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( AlignValue );
    NewItem.Checked := TControl( Component ).Align = AlignValue;
    case AlignValue of
      alNone:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_NONE' );
      alTop:    NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_TOP' );
      alBottom: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_BOTTOM' );
      alLeft:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_LEFT' );
      alRight:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_RIGHT' );
      alClient: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_CLIENT' );
    end;
    NewItem.OnClick := AlignMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateCompRefMenu( CompRef: TComponent; const CompRefPropName: string; CompRefMenuHandler: TNotifyEvent );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.AutoHotkeys := maManual;
    NewItem.Caption := CompRef.Name;
    NewItem.Checked := GetObjectProp( Component, CompRefPropName ) = CompRef;
    NewItem.OnClick := CompRefMenuHandler;
    Item.Add( NewItem );
  end;

begin {= TRzComponentEditor.PrepareMenuItem =}
  // Descendant classes override this method to consistently handle preparing menu items in
  // Delphi 5, Delphi 6 and higher.

  ResName := MenuBitmapResourceName( Index );
  if ResName <> '' then
    Item.Bitmap.LoadFromResourceName( HInstance, ResName );

  if Index = AlignMenuIndex then
  begin
    case TControl( Component ).Align of
      alNone:   Item.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_NONE' );
      alTop:    Item.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_TOP' );
      alBottom: Item.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_BOTTOM' );
      alLeft:   Item.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_LEFT' );
      alRight:  Item.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_RIGHT' );
      alClient: Item.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_CLIENT' );
    end;

    CreateAlignItem( alClient, 'Client' );
    CreateAlignItem( alLeft, 'Left' );
    CreateAlignItem( alTop, 'Top' );
    CreateAlignItem( alRight, 'Right' );
    CreateAlignItem( alBottom, 'Bottom' );
    CreateAlignItem( alNone, 'None' );
  end;

  if GetCompRefData( Index, CompRefClass, CompRefPropName, CompRefMenuHandler ) then
  begin
    Item.AutoHotkeys := maManual;
    CompRefCount := 0;
    CompOwner := Designer.GetRoot;

    if not Assigned( CompRefMenuHandler ) then
    begin
      if CompRefClass = TCustomImageList then
        CompRefMenuHandler := ImageListMenuHandler
      else if CompRefClass = TRzRegIniFile then
        CompRefMenuHandler := RegIniFileMenuHandler;
    end;

    if CompOwner <> nil then
    begin
      for I := 0 to CompOwner.ComponentCount - 1 do
      begin
        if CompOwner.Components[ I ] is CompRefClass then
        begin
          Inc( CompRefCount );
          CreateCompRefMenu( CompOwner.Components[ I ], CompRefPropName, CompRefMenuHandler );
        end;
      end;
    end;
    Item.Enabled := CompRefCount > 0;
  end;

end; {= TRzComponentEditor.PrepareMenuItem =}


{$IFDEF VER13x}

procedure TRzComponentEditor.PrepareItem( Index: Integer; const AItem: TMenuItem );
begin
  PrepareMenuItem( Index, AItem );
end; {= TRzComponentEditor.PrepareItem =}

{$ENDIF}

{$IFDEF VCL60_OR_HIGHER}

procedure TRzComponentEditor.PrepareItem( Index: Integer; const AItem: IMenuItem );
var
  CompRef: IInterfaceComponentReference;
  MenuItem: TMenuItem;
begin
  CompRef := AItem as IInterfaceComponentReference;
  MenuItem := CompRef.GetComponent as TMenuItem;
  PrepareMenuItem( Index, MenuItem );
end;

{$ENDIF}


procedure TRzComponentEditor.AlignMenuHandler( Sender: TObject );
begin
  TControl( Component ).Align := TAlign( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzComponentEditor.ImageListMenuHandler( Sender: TObject );
var
  S: string;
  ImageList: TCustomImageList;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ImageList := Designer.GetRoot.FindComponent( S ) as TCustomImageList;
    SetObjectProp( Component, 'Images', ImageList );
    Designer.Modified;
  end;
end;


procedure TRzComponentEditor.RegIniFileMenuHandler( Sender: TObject );
var
  S: string;
  RegIniFile: TRzRegIniFile;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    RegIniFile := Designer.GetRoot.FindComponent( S ) as TRzRegIniFile;
    SetObjectProp( Component, 'RegIniFile', RegIniFile );
    Designer.Modified;
  end;
end;


{==============================}
{== TRzDefaultEditor Methods ==}
{==============================}

{$IFDEF VCL60_OR_HIGHER}

procedure TRzDefaultEditor.EnumPropertyEditors( const PropertyEditor: IProperty );
begin
  if FContinue then
    TestPropertyEditor( PropertyEditor, FContinue );
end;


procedure TRzDefaultEditor.TestPropertyEditor( const PropertyEditor: IProperty; var Continue: Boolean );
begin
  if not Assigned( FPropEditor ) and
     ( CompareText( PropertyEditor.GetName, FPropName ) = 0 ) then
  begin
    Continue := False;
    FPropEditor := PropertyEditor;
  end;
end;


procedure TRzDefaultEditor.EditPropertyByName( const APropName: string );
var
  Components: IDesignerSelections;
begin
  Components := TDesignerSelections.Create;
  FContinue := True;
  FPropName := APropName;
  Components.Add( Component );
  FPropEditor := nil;
  try
    GetComponentProperties( Components, tkAny, Designer, EnumPropertyEditors );
    if Assigned( FPropEditor ) then
      FPropEditor.Edit;
  finally
    FPropEditor := nil;
  end;
end;

{$ELSE}

procedure TRzDefaultEditor.EnumPropertyEditors( PropertyEditor: TPropertyEditor );
var
  FreeEditor: Boolean;
begin
  FreeEditor := True;
  try
    if FContinue then
      TestPropertyEditor( PropertyEditor, FContinue, FreeEditor );
  finally
    if FreeEditor then
      PropertyEditor.Free;
  end;
end;


procedure TRzDefaultEditor.TestPropertyEditor( PropertyEditor: TPropertyEditor; var Continue, FreeEditor: Boolean );
begin
  if not Assigned( FPropEditor ) and
     ( CompareText( PropertyEditor.GetName, FPropName ) = 0 ) then
  begin
    FreeEditor := False;
    Continue := False;
    FPropEditor := PropertyEditor;
  end;
end;


procedure TRzDefaultEditor.EditPropertyByName( const APropName: string );
var
  Components: TDesignerSelectionList;
begin
  Components := TDesignerSelectionList.Create;
  try
    FContinue := True;
    FPropName := APropName;
    Components.Add( Component );
    FPropEditor := nil;
    try
      GetComponentProperties( Components, tkAny, Designer, EnumPropertyEditors );
      if Assigned( FPropEditor ) then
        FPropEditor.Edit;
    finally
      if Assigned( FPropEditor ) then
        FPropEditor.Free;
    end;
  finally
    Components.Free;
  end;
end;

{$ENDIF}


function TRzDefaultEditor.AlignMenuIndex: Integer;
begin
  Result := -1;
end;


function TRzDefaultEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  Result := '';
end;


function TRzDefaultEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                          var CompRefPropName: string;
                                          var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
end;


procedure TRzDefaultEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
var
  ResName: string;
  I, CompRefCount: Integer;
  CompOwner: TComponent;
  CompRefClass: TComponentClass;
  CompRefPropName: string;
  CompRefMenuHandler: TNotifyEvent;

  procedure CreateAlignItem( AlignValue: TAlign; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( AlignValue );
    NewItem.Checked := TControl( Component ).Align = AlignValue;
    case AlignValue of
      alNone:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_NONE' );
      alTop:    NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_TOP' );
      alBottom: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_BOTTOM' );
      alLeft:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_LEFT' );
      alRight:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_RIGHT' );
      alClient: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_CLIENT' );
    end;
    NewItem.OnClick := AlignMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateCompRefMenu( CompRef: TComponent; const CompRefPropName: string; CompRefMenuHandler: TNotifyEvent );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.AutoHotkeys := maManual;
    NewItem.Caption := CompRef.Name;
    NewItem.Checked := GetObjectProp( Component, CompRefPropName ) = CompRef;
    NewItem.OnClick := CompRefMenuHandler;
    Item.Add( NewItem );
  end;

begin {= TRzDefaultEditor.PrepareMenuItem =}
  // Descendant classes override this method to consistently handle preparing menu items in
  // Delphi 5, Delphi 6 and higher.

  ResName := MenuBitmapResourceName( Index );
  if ResName <> '' then
    Item.Bitmap.LoadFromResourceName( HInstance, ResName );

  if Index = AlignMenuIndex then
  begin
    Item.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN' );

    CreateAlignItem( alClient, 'Client' );
    CreateAlignItem( alLeft, 'Left' );
    CreateAlignItem( alTop, 'Top' );
    CreateAlignItem( alRight, 'Right' );
    CreateAlignItem( alBottom, 'Bottom' );
    CreateAlignItem( alNone, 'None' );
  end;

  if GetCompRefData( Index, CompRefClass, CompRefPropName, CompRefMenuHandler ) then
  begin
    Item.AutoHotkeys := maManual;
    CompRefCount := 0;
    CompOwner := Designer.GetRoot;

    if not Assigned( CompRefMenuHandler ) then
    begin
      if CompRefClass = TCustomImageList then
        CompRefMenuHandler := ImageListMenuHandler
      else if CompRefClass = TRzRegIniFile then
        CompRefMenuHandler := RegIniFileMenuHandler;
    end;

    if CompOwner <> nil then
    begin
      for I := 0 to CompOwner.ComponentCount - 1 do
      begin
        if CompOwner.Components[ I ] is CompRefClass then
        begin
          Inc( CompRefCount );
          CreateCompRefMenu( CompOwner.Components[ I ], CompRefPropName, CompRefMenuHandler );
        end;
      end;
    end;
    Item.Enabled := CompRefCount > 0;
  end;

end;


{$IFDEF VER13x}

procedure TRzDefaultEditor.PrepareItem( Index: Integer; const AItem: TMenuItem );
begin
  PrepareMenuItem( Index, AItem );
end;

{$ENDIF}

{$IFDEF VCL60_OR_HIGHER}

procedure TRzDefaultEditor.PrepareItem( Index: Integer; const AItem: IMenuItem );
var
  CompRef: IInterfaceComponentReference;
  MenuItem: TMenuItem;
begin
  CompRef := AItem as IInterfaceComponentReference;
  MenuItem := CompRef.GetComponent as TMenuItem;
  PrepareMenuItem( Index, MenuItem );
end;

{$ENDIF}


procedure TRzDefaultEditor.AlignMenuHandler( Sender: TObject );
begin
  TControl( Component ).Align := TAlign( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzDefaultEditor.ImageListMenuHandler( Sender: TObject );
var
  S: string;
  ImageList: TCustomImageList;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ImageList := Designer.GetRoot.FindComponent( S ) as TCustomImageList;
    SetObjectProp( Component, 'Images', ImageList );
    Designer.Modified;
  end;
end;


procedure TRzDefaultEditor.RegIniFileMenuHandler( Sender: TObject );
var
  S: string;
  RegIniFile: TRzRegIniFile;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    RegIniFile := Designer.GetRoot.FindComponent( S ) as TRzRegIniFile;
    SetObjectProp( Component, 'RegIniFile', RegIniFile );
    Designer.Modified;
  end;
end;


{== Component Editors =================================================================================================}


{======================================}
{== TRzFrameControllerEditor Methods ==}
{======================================}

function TRzFrameControllerEditor.FrameController: TRzFrameController;
begin
  Result := Component as TRzFrameController;
end;


function TRzFrameControllerEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;


function TRzFrameControllerEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Frame Visible';
    1: Result := 'Underline Controls';
    2: Result := '-';
    3: Result := 'Set RegIniFile';
  end;
end;


function TRzFrameControllerEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_FRAME_VISIBLE';
    1: Result := 'RZDESIGNEDITORS_FRAME_UNDERLINE';
    3: Result := 'RZDESIGNEDITORS_REGINIFILE';
  end;
end;


function TRzFrameControllerEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                                  var CompRefPropName: string;
                                                  var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  if Index = 3 then
  begin
    CompRefClass := TRzRegIniFile;
    CompRefPropName := 'RegIniFile';
    CompRefMenuHandler := nil;
    Result := True;
  end
end;


procedure TRzFrameControllerEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0:
    begin
      FrameController.FrameVisible := True;
      Designer.Modified;
    end;

    1:
    begin
      FrameController.FrameVisible := True;
      FrameController.FrameSides := [ sdBottom ];
      Designer.Modified;
    end;

  end;
end;


{================================}
{== TRzStatusBarEditor Methods ==}
{================================}

function TRzStatusBarEditor.StatusBar: TRzStatusBar;
begin
  Result := Component as TRzStatusBar;
end;


function TRzStatusBarEditor.GetVerbCount: Integer;
begin
  Result := 12;
end;


function TRzStatusBarEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'New Status Pane';
    1: Result := 'New Field Status';
    2: Result := 'New Glyph Status';
    3: Result := 'New Marquee Status';
    4: Result := 'New Clock Status';
    5: Result := 'New Key Status';
    6: Result := 'New Resource Status';
    7: Result := 'New VersionInfo Status';
    8: Result := 'New Progress Bar';
    9: Result := '-';
    10: Result := 'New DB Status Pane';
    11: Result := 'New DB State Status';
  end;
end;


function TRzStatusBarEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_STATUS';
    1: Result := 'RZDESIGNEDITORS_STATUS_FIELD';
    2: Result := 'RZDESIGNEDITORS_STATUS_GLYPH';
    3: Result := 'RZDESIGNEDITORS_STATUS_MARQUEE';
    4: Result := 'RZDESIGNEDITORS_STATUS_CLOCK';
    5: Result := 'RZDESIGNEDITORS_STATUS_KEY';
    6: Result := 'RZDESIGNEDITORS_STATUS_RESOURCE';
    7: Result := 'RZDESIGNEDITORS_STATUS_VERSIONINFO';
    8: Result := 'RZDESIGNEDITORS_STATUS_PROGRESS';
    10: Result := 'RZDESIGNEDITORS_STATUS_DB';
    11: Result := 'RZDESIGNEDITORS_STATUS_DBSTATE';
  end;
end;


procedure TRzStatusBarEditor.ExecuteVerb( Index: Integer );
var
  CompOwner: TComponent;
  BaseName: string;
  Ref: TPersistentClass;
  C: TControl;
  {$IFDEF VCL60_OR_HIGHER}
  OldGroup: TPersistentClass;
  {$ENDIF}
begin
  BaseName := 'RzStatusPane';

  {$IFDEF VCL60_OR_HIGHER}
  OldGroup := ActivateClassGroup( TControl );
  try
  {$ENDIF}


  case Index of
    0: BaseName := 'RzStatusPane';
    1: BaseName := 'RzFieldStatus';
    2: BaseName := 'RzGlyphStatus';
    3: BaseName := 'RzMarqueeStatus';
    4: BaseName := 'RzClockStatus';
    5: BaseName := 'RzKeyStatus';
    6: BaseName := 'RzResourceStatus';
    7: BaseName := 'RzVersionInfoStatus';
    8: BaseName := 'RzProgressBar';
    10: BaseName := 'RzDBStatusPane';
    11: BaseName := 'RzDBStateStatus';
  end;
  Ref := GetClass( 'T' + BaseName );

  {$IFDEF VCL60_OR_HIGHER}
  finally
    ActivateClassGroup( OldGroup );
  end;
  {$ENDIF}

  CompOwner := Designer.GetRoot;
  if CompOwner <> nil then
  begin
    C := TControlClass( Ref ).Create( CompOwner );
    C.Parent := TWinControl( Component );

    StatusBar.SimpleStatus := False;

    C.Left := C.Parent.Width;
    C.Align := alLeft;
    if C is TRzProgressBar then
    begin
      with TRzProgressBar( C ) do
      begin
        BorderInner := fsFlat;
        BorderOuter := fsNone;
        BorderWidth := 1;
        BackColor := TRzStatusBar( Parent ).Color;
      end;
    end;

    C.Name := GetNewComponentName( CompOwner, BaseName, False );
    Designer.Modified;
  end;
end; {= TRzStatusBarEditor.ExecuteVerb =}


procedure TRzStatusBarEditor.Edit;
begin
  // Do not add a new status pane (item 1) on double-click
end;


{===============================}
{== TRzGroupBoxEditor Methods ==}
{===============================}

function TRzGroupBoxEditor.GroupBox: TRzGroupBox;
begin
  Result := Component as TRzGroupBox;
end;


function TRzGroupBoxEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;


function TRzGroupBoxEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Flat';
    1: Result := 'Traditional';
    2: Result := 'Top Line';
    3: Result := 'Custom';
  end;
end;


function TRzGroupBoxEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_GROUPBOX_FLAT';
    1: Result := 'RZDESIGNEDITORS_GROUPBOX_STANDARD';
    2: Result := 'RZDESIGNEDITORS_GROUPBOX_TOPLINE';
    3: Result := 'RZDESIGNEDITORS_GROUPBOX_CUSTOM';
  end;
end;


procedure TRzGroupBoxEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := GroupBox.GroupStyle = gsFlat;
    1: Item.Checked := GroupBox.GroupStyle = gsStandard;
    2: Item.Checked := GroupBox.GroupStyle = gsTopLine;
    3: Item.Checked := GroupBox.GroupStyle = gsCustom;
  end;
end;


procedure TRzGroupBoxEditor.ExecuteVerb( Index: Integer );
begin
  if Component is TRzGroupBox then
  begin
    case Index of
      0: GroupBox.GroupStyle := gsFlat;
      1: GroupBox.GroupStyle := gsStandard;
      2: GroupBox.GroupStyle := gsTopLine;
      3: GroupBox.GroupStyle := gsCustom;
    end;
    if Index in [ 0..3 ] then
      Designer.Modified;
  end;
end;


{==================================}
{== TRzPageControlEditor Methods ==}
{==================================}

function TRzPageControlEditor.PageControl: TRzPageControl;
begin
  if Component is TRzPageControl then
    Result := TRzPageControl( Component )
  else if Component is TRzTabSheet then
    Result := TRzTabSheet( Component ).PageControl
  else
    raise Exception.Create( 'Invalid Component type for editor' );
end;


function TRzPageControlEditor.GetVerbCount: Integer;
begin
  if Component is TRzTabSheet then
    Result := 17
  else
    Result := 15;
end;


function TRzPageControlEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'New Page';
    1: Result := '-';
    2: Result := 'Next Page';
    3: Result := 'Previous Page';
    4: Result := '-';
    5: Result := 'Style';
    6: Result := 'Orientation';
    7: Result := '-';
    8: Result := 'Hide All Tabs';
    9: Result := 'Show All Tabs';
    10: Result := '-';
    11: Result := 'Align';
    12: Result := 'XP Colors';
    13: Result := '-';
    14: Result := 'Set ImageList';
    15: Result := 'Select Image...';
    16: Result := 'Select Disabled Image...';
  end;
end;


function TRzPageControlEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_PAGE_NEW';
    2: Result := 'RZDESIGNEDITORS_PAGE_NEXT';
    3: Result := 'RZDESIGNEDITORS_PAGE_PREVIOUS';

    5: // Style
    begin
      case PageControl.TabStyle of
        tsSingleSlant:  Result := 'RZDESIGNEDITORS_TABSTYLE_SINGLESLANT';
        tsDoubleSlant:  Result := 'RZDESIGNEDITORS_TABSTYLE_DOUBLESLANT';
        tsCutCorner:    Result := 'RZDESIGNEDITORS_TABSTYLE_CUTCORNER';
        tsRoundCorners: Result := 'RZDESIGNEDITORS_TABSTYLE_ROUNDCORNERS';
      end;
    end;

    6: // Orientation
    begin
      case PageControl.TabOrientation of
        toTop:    Result := 'RZDESIGNEDITORS_TABORIENTATION_TOP';
        toBottom: Result := 'RZDESIGNEDITORS_TABORIENTATION_BOTTOM';
        toLeft:   Result := 'RZDESIGNEDITORS_TABORIENTATION_LEFT';
        toRight:  Result := 'RZDESIGNEDITORS_TABORIENTATION_RIGHT';
      end;
    end;

    11: // Align
    begin
      case PageControl.Align of
        alNone:   Result := 'RZDESIGNEDITORS_ALIGN_NONE';
        alTop:    Result := 'RZDESIGNEDITORS_ALIGN_TOP';
        alBottom: Result := 'RZDESIGNEDITORS_ALIGN_BOTTOM';
        alLeft:   Result := 'RZDESIGNEDITORS_ALIGN_LEFT';
        alRight:  Result := 'RZDESIGNEDITORS_ALIGN_RIGHT';
        alClient: Result := 'RZDESIGNEDITORS_ALIGN_CLIENT';
      end;
    end;

    12: Result := 'RZDESIGNEDITORS_XPCOLORS';
    14: Result := 'RZDESIGNEDITORS_IMAGELIST';
    15: Result := 'RZDESIGNEDITORS_SELECT_IMAGE';
    16: Result := 'RZDESIGNEDITORS_SELECT_DISABLED_IMAGE';
  end;
end;


procedure TRzPageControlEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
var
  I, ImageListCount: Integer;
  CompOwner: TComponent;

  procedure CreateStyleMenu( Style: TRzTabStyle; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Style );
    NewItem.Checked := PageControl.TabStyle = Style;
    case Style of
      tsSingleSlant:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABSTYLE_SINGLESLANT' );
      tsDoubleSlant:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABSTYLE_DOUBLESLANT' );
      tsCutCorner:    NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABSTYLE_CUTCORNER' );
      tsRoundCorners: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABSTYLE_ROUNDCORNERS' );
    end;
    NewItem.OnClick := StyleMenuHandler;
    Item.Add( NewItem );
  end;


  procedure CreateOrientationMenu( Orientation: TRzTabOrientation; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Orientation );
    NewItem.Checked := PageControl.TabOrientation = Orientation;
    case Orientation of
      toTop:    NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABORIENTATION_TOP' );
      toBottom: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABORIENTATION_BOTTOM' );
      toLeft:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABORIENTATION_LEFT' );
      toRight:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABORIENTATION_RIGHT' );
    end;
    NewItem.OnClick := OrientationMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateImageListMenu( ImageList: TCustomImageList );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.AutoHotkeys := maManual;
    NewItem.Caption := ImageList.Name;
    NewItem.Checked := GetObjectProp( PageControl, 'Images' ) = ImageList;
    NewItem.OnClick := ImageListMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateAlignItem( AlignValue: TAlign; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( AlignValue );
    NewItem.Checked := PageControl.Align = AlignValue;
    case AlignValue of
      alNone:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_NONE' );
      alTop:    NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_TOP' );
      alBottom: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_BOTTOM' );
      alLeft:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_LEFT' );
      alRight:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_RIGHT' );
      alClient: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_ALIGN_CLIENT' );
    end;
    NewItem.OnClick := AlignMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0:
    begin
      // Only allow user to add new pages if the page control is NOT being edited in an inline frame
      // (i.e. a frame instance).
      Item.Enabled := not IsInInlined;
    end;

    5:
    begin
      CreateStyleMenu( tsSingleSlant, 'Single Slant' );
      CreateStyleMenu( tsDoubleSlant, 'Double Slant' );
      CreateStyleMenu( tsCutCorner, 'Cut Corner' );
      CreateStyleMenu( tsRoundCorners, 'Round Corners' );
    end;

    6:
    begin
      CreateOrientationMenu( toTop, 'Top' );
      CreateOrientationMenu( toBottom, 'Bottom' );
      CreateOrientationMenu( toLeft, 'Left' );
      CreateOrientationMenu( toRight, 'Right' );
    end;

    11:
    begin
      CreateAlignItem( alClient, 'Client' );
      CreateAlignItem( alLeft, 'Left' );
      CreateAlignItem( alTop, 'Top' );
      CreateAlignItem( alRight, 'Right' );
      CreateAlignItem( alBottom, 'Bottom' );
      CreateAlignItem( alNone, 'None' );
    end;

    14:
    begin
      Item.AutoHotkeys := maManual;
      ImageListCount := 0;
      CompOwner := Designer.GetRoot;
      if CompOwner <> nil then
      begin
        for I := 0 to CompOwner.ComponentCount - 1 do
        begin
          if CompOwner.Components[ I ] is TCustomImageList then
          begin
            Inc( ImageListCount );
            CreateImageListMenu( TCustomImageList( CompOwner.Components[ I ] ) );
          end;
        end;
      end;
      Item.Enabled := ImageListCount > 0;
    end;
  end;
end;


procedure TRzPageControlEditor.ExecuteVerb( Index: Integer );
var
  APageControl: TRzPageControl;
  Page: TRzTabSheet;
  {$IFDEF VCL60_OR_HIGHER}
  Designer: IDesigner;
  {$ELSE}
  Designer: IFormDesigner;
  {$ENDIF}
begin
  if Component is TRzTabSheet then
    APageControl := TRzTabSheet( Component ).PageControl
  else
    APageControl := TRzPageControl( Component );

  if APageControl <> nil then
  begin
    Designer := Self.Designer;

    case Index of
      0:                                    // New Page
      begin
        {$IFDEF VCL60_OR_HIGHER}
        Page := TRzTabSheet.Create( Designer.Root );
        {$ELSE}
        Page := TRzTabSheet.Create( Designer.GetRoot );
        {$ENDIF}
        try
          // Generate unique name
          Page.Name := UniqueName( Page );
          Page.PageControl := APageControl;
        except
          Page.Free;
          raise;
        end;

        APageControl.ActivePage := Page;
        Designer.SelectComponent( Page );
        Designer.Modified;

      end;

      2, 3:                                                // Next/Previous Page
      begin
        Page := APageControl.FindNextPage( APageControl.ActivePage, Index = 2 {Next}, False );
        if ( Page <> nil ) and ( Page <> APageControl.ActivePage ) then
        begin
          APageControl.ActivePage := Page;
          if Component is TRzTabSheet then
            Designer.SelectComponent( Page );
          Designer.Modified;
        end;
      end;

      8: // Hide All Tabs
      begin
        APageControl.HideAllTabs;
        APageControl.ShowShadow := False;
        Designer.Modified;
      end;

      9: // Show All Tabs
      begin
        APageControl.ShowAllTabs;
        Designer.Modified;
      end;

      12: // XP Colors
      begin
        APageControl.HotTrackColorType := htctActual;
        APageControl.HotTrackColor := $003CC7FF;
        APageControl.TabColors.HighlightBar := $003CC7FF;
        APageControl.FlatColor := $009C9B91;
        APageControl.Color := $00F5F6F7;
        APageControl.ShowShadow := True;
        Designer.Modified;
      end;

      15:
      begin
        // This will only get used if we are on a TRzTabSheet
        EditPropertyByName( 'ImageIndex' );
      end;

      16:
      begin
        // This will only get used if we are on a TRzTabSheet
        EditPropertyByName( 'DisabledIndex' );
      end;
    end;
  end;
end; {= TRzPageControlEditor.ExecuteVerb =}


procedure TRzPageControlEditor.StyleMenuHandler( Sender: TObject );
begin
  PageControl.TabStyle := TRzTabStyle( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzPageControlEditor.OrientationMenuHandler( Sender: TObject );
begin
  PageControl.TabOrientation := TRzTabOrientation( TMenuItem( Sender ).Tag );
  case PageControl.TabOrientation of
    toTop, toBottom:
    begin
      PageControl.TextOrientation := orHorizontal;
      PageControl.ImagePosition := ipLeft;
    end;

    toLeft, toRight:
    begin
      PageControl.TextOrientation := orVertical;
      if PageControl.TabOrientation = toRight then
        PageControl.ImagePosition := ipTop
      else
        PageControl.ImagePosition := ipBottom;
    end;
  end;
  Designer.Modified;
end;



procedure TRzPageControlEditor.ImageListMenuHandler( Sender: TObject );
var
  S: string;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    PageControl.Images := Designer.GetRoot.FindComponent( S ) as TCustomImageList;
    Designer.Modified;
  end;
end;


procedure TRzPageControlEditor.AlignMenuHandler( Sender: TObject );
begin
  PageControl.Align := TAlign( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


{$IFDEF VCL60_OR_HIGHER}

{=================================}
{== TRzPageControlSprig Methods ==}
{=================================}

constructor TRzPageControlSprig.Create( AItem: TPersistent );
begin
  inherited;
  ImageIndex := CUIControlSprigImage;
end;


function TRzPageControlSprig.SortByIndex: Boolean;
begin
  Result := True;
end;


{==============================}
{== TRzTabSheetSprig Methods ==}
{==============================}

constructor TRzTabSheetSprig.Create( AItem: TPersistent );
begin
  inherited;
  ImageIndex := CUIContainerSprigImage;
end;


function TRzTabSheetSprig.Caption: string;
begin
  Result := CaptionFor( TRzTabSheet( Item ).Caption, TRzTabSheet( Item ).Name );
end;


function TRzTabSheetSprig.ItemIndex: Integer;
begin
  Result := TRzTabSheet( Item ).PageIndex;
end;


function TRzTabSheetSprig.Hidden: Boolean;
begin
  Result := True;
end;

{$ENDIF}

{=================================}
{== TRzTabControlEditor Methods ==}
{=================================}

function TRzTabControlEditor.TabControl: TRzTabControl;
begin
  Result := Component as TRzTabControl;
end;


function TRzTabControlEditor.GetVerbCount: Integer;
begin
  Result := 15;
end;


function TRzTabControlEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Tabs...';
    1: Result := '-';
    2: Result := 'Next Tab';
    3: Result := 'Previous Tab';
    4: Result := '-';
    5: Result := 'Style';
    6: Result := 'Orientation';
    7: Result := '-';
    8: Result := 'Hide All Tabs';
    9: Result := 'Show All Tabs';
    10: Result := '-';
    11: Result := 'Align';
    12: Result := 'XP Colors';
    13: Result := '-';
    14: Result := 'Set ImageList';
  end;
end;


function TRzTabControlEditor.AlignMenuIndex: Integer;
begin
  Result := 11;
end;


function TRzTabControlEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT';
    2: Result := 'RZDESIGNEDITORS_PAGE_NEXT';
    3: Result := 'RZDESIGNEDITORS_PAGE_PREVIOUS';

    5: // Style
    begin
      case TabControl.TabStyle of
        tsSingleSlant:  Result := 'RZDESIGNEDITORS_TABSTYLE_SINGLESLANT';
        tsDoubleSlant:  Result := 'RZDESIGNEDITORS_TABSTYLE_DOUBLESLANT';
        tsCutCorner:    Result := 'RZDESIGNEDITORS_TABSTYLE_CUTCORNER';
        tsRoundCorners: Result := 'RZDESIGNEDITORS_TABSTYLE_ROUNDCORNERS';
      end;
    end;

    6: // Orientation
    begin
      case TabControl.TabOrientation of
        toTop:    Result := 'RZDESIGNEDITORS_TABORIENTATION_TOP';
        toBottom: Result := 'RZDESIGNEDITORS_TABORIENTATION_BOTTOM';
        toLeft:   Result := 'RZDESIGNEDITORS_TABORIENTATION_LEFT';
        toRight:  Result := 'RZDESIGNEDITORS_TABORIENTATION_RIGHT';
      end;
    end;

    12: Result := 'RZDESIGNEDITORS_XPCOLORS';
    14: Result := 'RZDESIGNEDITORS_IMAGELIST';
  end;
end;


function TRzTabControlEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                             var CompRefPropName: string;
                                             var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  if Index = 14 then
  begin
    CompRefClass := TCustomImageList;
    CompRefPropName := 'Images';
    CompRefMenuHandler := nil;
    Result := True;
  end
end;


procedure TRzTabControlEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateStyleMenu( Style: TRzTabStyle; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Style );
    NewItem.Checked := TabControl.TabStyle = Style;
    case Style of
      tsSingleSlant:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABSTYLE_SINGLESLANT' );
      tsDoubleSlant:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABSTYLE_DOUBLESLANT' );
      tsCutCorner:    NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABSTYLE_CUTCORNER' );
      tsRoundCorners: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABSTYLE_ROUNDCORNERS' );
    end;
    NewItem.OnClick := StyleMenuHandler;
    Item.Add( NewItem );
  end;


  procedure CreateOrientationMenu( Orientation: TRzTabOrientation; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Orientation );
    NewItem.Checked := TabControl.TabOrientation = Orientation;
    case Orientation of
      toTop:    NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABORIENTATION_TOP' );
      toBottom: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABORIENTATION_BOTTOM' );
      toLeft:   NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABORIENTATION_LEFT' );
      toRight:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_TABORIENTATION_RIGHT' );
    end;
    NewItem.OnClick := OrientationMenuHandler;
    Item.Add( NewItem );
  end;


begin
  inherited;

  if Index = 0 then
  begin
    // Only allow user to edit tabs if the tab control is NOT being edited in an inline frame (i.e. a frame instance).
    Item.Enabled := not IsInInlined;
  end;

  if Index = 5 then
  begin
    CreateStyleMenu( tsSingleSlant, 'Single Slant' );
    CreateStyleMenu( tsDoubleSlant, 'Double Slant' );
    CreateStyleMenu( tsCutCorner, 'Cut Corner' );
    CreateStyleMenu( tsRoundCorners, 'Round Corners' );
  end;

  if Index = 6 then
  begin
    CreateOrientationMenu( toTop, 'Top' );
    CreateOrientationMenu( toBottom, 'Bottom' );
    CreateOrientationMenu( toLeft, 'Left' );
    CreateOrientationMenu( toRight, 'Right' );
  end;
end;


procedure TRzTabControlEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'Tabs' );
    2: Skip( True );  // Next
    3: Skip( False ); // Previous

    8: // Hide All Tabs;
    begin
      TabControl.HideAllTabs;
      TabControl.ShowShadow := False;
      Designer.Modified;
    end;

    9: // Show All Tabs;
    begin
      TabControl.ShowAllTabs;
      Designer.Modified;
    end;

    12: // XP Colors
    begin
      TabControl.HotTrackColorType := htctActual;
      TabControl.HotTrackColor := $003CC7FF;
      TabControl.TabColors.HighlightBar := $003CC7FF;
      TabControl.FlatColor := $009C9B91;
      TabControl.Color := $00F5F6F7;
      TabControl.ShowShadow := True;
      Designer.Modified;
    end;
  end;
end;


procedure TRzTabControlEditor.Skip( Next: Boolean );
var
  NewTabIndex, InitialTabIndex: Integer;
begin
  with TRzCollectionTabControl( Component ) do
  begin
    if Tabs.Count = 0 then
      Exit;

    if TabIndex >= 0 then
      NewTabIndex := TabIndex
    else
      if Next then
        NewTabIndex := Tabs.Count - 1       // next tab will be first tab
      else
        NewTabIndex := 0;                   // previous tab will be last tab
    InitialTabIndex := NewTabIndex;

    // Skip to the next visible tab in the specified direction
    repeat
      if Next then
      begin
        if NewTabIndex = Tabs.Count - 1 then
          NewTabIndex := 0
        else
          Inc( NewTabIndex );
      end
      else if NewTabIndex = 0 then
        NewTabIndex := Tabs.Count - 1
      else
        Dec( NewTabIndex );
    until Tabs[ NewTabIndex ].Visible or ( NewTabIndex = InitialTabIndex );

    if NewTabIndex <> TabIndex then
    begin
      TabIndex := NewTabIndex;
      Designer.Modified;
    end;
  end;
end;


procedure TRzTabControlEditor.StyleMenuHandler( Sender: TObject );
begin
  TabControl.TabStyle := TRzTabStyle( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzTabControlEditor.OrientationMenuHandler( Sender: TObject );
begin
  TabControl.TabOrientation := TRzTabOrientation( TMenuItem( Sender ).Tag );
  case TabControl.TabOrientation of
    toTop, toBottom:
      TabControl.TextOrientation := orHorizontal;

    toLeft, toRight:
      TabControl.TextOrientation := orVertical;
  end;
  Designer.Modified;
end;



{================================}
{== TRzSizePanelEditor Methods ==}
{================================}

function TRzSizePanelEditor.SizePanel: TRzSizePanel;
begin
  Result := Component as TRzSizePanel;
end;


function TRzSizePanelEditor.GetVerbCount: Integer;
begin
  Result := 7;
end;


function TRzSizePanelEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Align';
    1: Result := '-';
    2: Result := 'Show HotSpot';
    3: Result := 'Real-Time Dragging';
    4: Result := '-';
    5: Result := 'Add a Group Bar';
    6: Result := 'Add a Panel';
  end;
end;


function TRzSizePanelEditor.AlignMenuIndex: Integer;
begin
  Result := 0;
end;


function TRzSizePanelEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    2:
    begin
      if SizePanel.Align in [ alLeft, alRight ] then
        Result := 'RZDESIGNEDITORS_SPLIT_HOTSPOT_HORIZONTAL'
      else
        Result := 'RZDESIGNEDITORS_SPLIT_HOTSPOT_VERTICAL';
    end;

    5: Result := 'RZDESIGNEDITORS_GROUPBAR_CATEGORYVIEW';
    6: Result := 'RZDESIGNEDITORS_PANEL';
  end;
end; {= TRzSizePanelEditor.MenuBitmapResourceName =}


procedure TRzSizePanelEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    2: Item.Checked := SizePanel.HotSpotVisible;
    3: Item.Checked := SizePanel.RealTimeDrag;
  end;
end;


procedure TRzSizePanelEditor.ExecuteVerb( Index: Integer );
var
  GroupBar: TRzGroupBar;
  Panel: TRzPanel;
begin
  case Index of
    2: SizePanel.HotSpotVisible := not SizePanel.HotSpotVisible;
    3: SizePanel.RealTimeDrag := not SizePanel.RealTimeDrag;

    5:
    begin
      GroupBar := Designer.CreateComponent( TRzGroupBar, SizePanel, 10, 10, 100, 100 ) as TRzGroupBar;
      GroupBar.Align := alClient;
      SizePanel.Color := clBtnShadow;
      SizePanel.SizeBarStyle := ssGroupBar;
    end;

    6:
    begin
      Panel := Designer.CreateComponent( TRzPanel, SizePanel, 10, 10, 100, 100 ) as TRzPanel;
      Panel.Align := alClient;
      Panel.BorderOuter := fsLowered;
    end;
  end;
  if Index in [ 2, 3, 5, 6 ] then
    Designer.Modified;
end;


{===============================}
{== TRzCheckBoxEditor Methods ==}
{===============================}

function TRzCheckBoxEditor.CheckBox: TRzCheckBox;
begin
  Result := Component as TRzCheckBox;
end;


function TRzCheckBoxEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;


function TRzCheckBoxEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0:
    begin
      if CheckBox.Checked then
        Result := 'Uncheck'
      else
        Result := 'Check';
    end;

    1: Result := 'HotTrack';
    2: Result := 'XP Colors';
  end;
end;


function TRzCheckBoxEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0:
    begin
      if CheckBox.Checked then
        Result := 'RZDESIGNEDITORS_CHECKBOX_UNCHECK'
      else
        Result := 'RZDESIGNEDITORS_CHECKBOX_CHECK';
    end;

    1: Result := 'RZDESIGNEDITORS_HOTTRACK';
    2: Result := 'RZDESIGNEDITORS_XPCOLORS';
  end;
end;


procedure TRzCheckBoxEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    1: Item.Checked := CheckBox.HotTrack;
  end;
end;


procedure TRzCheckBoxEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: CheckBox.Checked := not CheckBox.Checked;
    1: CheckBox.HotTrack := not CheckBox.HotTrack;

    2: // XP Colors
    begin
      CheckBox.HotTrackColorType := htctActual;
      CheckBox.HotTrack := True;
      CheckBox.HighlightColor := $0021A121;
      CheckBox.HotTrackColor := $003CC7FF;
      CheckBox.FrameColor := $0080511C;
    end;
  end;
  if Index in [ 0, 1, 2 ] then
    Designer.Modified;
end;


{==================================}
{== TRzRadioButtonEditor Methods ==}
{==================================}

function TRzRadioButtonEditor.RadioButton: TRzRadioButton;
begin
  Result := Component as TRzRadioButton;
end;


function TRzRadioButtonEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;


function TRzRadioButtonEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Check';
    1: Result := 'HotTrack';
    2: Result := 'XP Colors';
  end;
end;


function TRzRadioButtonEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_RADIOBUTTON_CHECK';
    1: Result := 'RZDESIGNEDITORS_HOTTRACK';
    2: Result := 'RZDESIGNEDITORS_XPCOLORS';
  end;
end;


procedure TRzRadioButtonEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    1: Item.Checked := RadioButton.HotTrack;
  end;
end;


procedure TRzRadioButtonEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: RadioButton.Checked := True;
    1: RadioButton.HotTrack := not RadioButton.HotTrack;

    2: // XP Colors
    begin
      RadioButton.HotTrackColorType := htctActual;
      RadioButton.HotTrack := True;
      RadioButton.HighlightColor := $0021A121;
      RadioButton.HotTrackColor := $003CC7FF;
      RadioButton.FrameColor := $0080511C;
    end;

  end;
  if Index in [ 0, 1, 2 ] then
    Designer.Modified;
end;


{===========================}
{== TRzMemoEditor Methods ==}
{===========================}

function TRzMemoEditor.GetWordWrap: Boolean;
begin
  Result := ( Component as TRzMemo ).WordWrap;
end;


procedure TRzMemoEditor.SetWordWrap( Value: Boolean );
begin
  ( Component as TRzMemo ).WordWrap := Value;
end;


function TRzMemoEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;


function TRzMemoEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Lines...';
    1: Result := 'Align';
    2: Result := '-';
    3: Result := 'Word Wrap';
  end;
end;


function TRzMemoEditor.AlignMenuIndex: Integer;
begin
  Result := 1;
end;


function TRzMemoEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT_ITEMS';
    3: Result := 'RZDESIGNEDITORS_WORDWRAP';
  end;
end;


procedure TRzMemoEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    3: Item.Checked := WordWrap;
  end;
end;


procedure TRzMemoEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'Lines' );

    3:
    begin
      WordWrap := not WordWrap;
      Designer.Modified;
    end;
  end;
end;


{=================================}
{== TRzRichEditEditor Methods ==}
{=================================}

function TRzRichEditEditor.GetWordWrap: Boolean;
begin
  Result := ( Component as TRzRichEdit ).WordWrap;
end;


procedure TRzRichEditEditor.SetWordWrap( Value: Boolean );
begin
  ( Component as TRzRichEdit ).WordWrap := Value;
end;



{==============================}
{== TRzListBoxEditor Methods ==}
{==============================}

function TRzListBoxEditor.ListBox: TRzListBox;
begin
  Result := Component as TRzListBox;
end;


function TRzListBoxEditor.GetVerbCount: Integer;
begin
  Result := 6;
end;


function TRzListBoxEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Edit Items...';
    1: Result := 'Align';
    2: Result := '-';
    3: Result := 'Show Groups';
    4: Result := 'Sorted';
    5: Result := 'MultiSelect';
  end;
end;


function TRzListBoxEditor.AlignMenuIndex: Integer;
begin
  Result := 1;
end;


function TRzListBoxEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT_ITEMS';
  end;
end;


procedure TRzListBoxEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    3: Item.Checked := ListBox.ShowGroups;
    4: Item.Checked := ListBox.Sorted;
    5: Item.Checked := ListBox.MultiSelect;
  end;
end;


procedure TRzListBoxEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0:
      EditPropertyByName( 'Items' );

    3:
    begin
      ListBox.ShowGroups := not ListBox.ShowGroups;
      Designer.Modified;
    end;

    4:
    begin
      ListBox.Sorted := not ListBox.Sorted;
      Designer.Modified;
    end;

    5:
    begin
      ListBox.MultiSelect := not ListBox.MultiSelect;
      Designer.Modified;
    end;
  end;
end;


{==================================}
{== TRzRankListBoxEditor Methods ==}
{==================================}

function TRzRankListBoxEditor.ListBox: TRzRankListBox;
begin
  Result := Component as TRzRankListBox;
end;


function TRzRankListBoxEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;


function TRzRankListBoxEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Edit Items...';
    1: Result := 'Align';
    2: Result := '-';
    3: Result := 'Show Groups';
  end;
end;


function TRzRankListBoxEditor.AlignMenuIndex: Integer;
begin
  Result := 1;
end;


function TRzRankListBoxEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT_ITEMS';
  end;
end;


procedure TRzRankListBoxEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    3: Item.Checked := ListBox.ShowGroups;
  end;
end;


procedure TRzRankListBoxEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'Items' );

    3:
    begin
      ListBox.ShowGroups := not ListBox.ShowGroups;
      Designer.Modified;
    end;

  end;
end;


{===============================}
{== TRzComboBoxEditor Methods ==}
{===============================}

function TRzComboBoxEditor.GetVerbCount: Integer;
begin
  Result := 7;
end;


function TRzComboBoxEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Items...';
    1: Result := '-';
    2: Result := 'csDropDown Style';
    3: Result := 'csDropDownList Style';
    4: Result := '-';
    5: Result := 'AllowEdit';
    6: Result := 'Sorted';
  end;
end;


function TRzComboBoxEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT_ITEMS';
  end;
end;


procedure TRzComboBoxEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    2: Item.Checked := GetOrdProp( Component, 'Style' ) = Ord( csDropDown );
    3: Item.Checked := GetOrdProp( Component, 'Style' ) = Ord( csDropDownList );
    5: Item.Checked := GetOrdProp( Component, 'AllowEdit' ) = 1;
    6: Item.Checked := GetOrdProp( Component, 'Sorted' ) = 1;
  end;
end;


procedure TRzComboBoxEditor.ExecuteVerb( Index: Integer );
var
  B: Boolean;
begin
  case Index of
    0: EditPropertyByName( 'Items' );

    2: SetOrdProp( Component, 'Style', Ord( csDropDown ) );
    3: SetOrdProp( Component, 'Style', Ord( csDropDownList ) );

    5:
    begin
      B := GetOrdProp( Component, 'AllowEdit' ) = 1;
      SetOrdProp( Component, 'AllowEdit', Ord( not B ) );
    end;

    6:
    begin
      B := GetOrdProp( Component, 'Sorted' ) = 1;
      SetOrdProp( Component, 'Sorted', Ord( not B ) );
    end;
  end;
  if Index in [ 2, 3, 5, 6 ] then
    Designer.Modified;
end;


{==================================}
{== TRzMRUComboBoxEditor Methods ==}
{==================================}

function TRzMRUComboBoxEditor.GetVerbCount: Integer;
begin
  Result := 6;   // Don't Show the Sorted option
end;


{====================================}
{== TRzImageComboBoxEditor Methods ==}
{====================================}

function TRzImageComboBoxEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


function TRzImageComboBoxEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Set ImageList';
  end;
end;


function TRzImageComboBoxEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_IMAGELIST';
  end;
end;


function TRzImageComboBoxEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                                var CompRefPropName: string;
                                                var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  case Index of
    0:
    begin
      CompRefClass := TCustomImageList;
      CompRefPropName := 'Images';
      CompRefMenuHandler := nil;
      Result := True;
    end;
  end;
end;


{===============================}
{== TRzListViewEditor Methods ==}
{===============================}

function TRzListViewEditor.ListView: TRzListView;
begin
  Result := Component as TRzListView;
end;


function TRzListViewEditor.GetVerbCount: Integer;
begin
  Result := 10;
end;


function TRzListViewEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Columns...';
    1: Result := 'Edit Items...';
    2: Result := '-';
    3: Result := 'Align';
    4: Result := '-';
    5: Result := 'Set SmallImages';
    6: Result := 'Set LargeImages';
    7: Result := 'Set StateImages';
    8: Result := '-';
    9: Result := 'View Style';
  end;
end;


function TRzListViewEditor.AlignMenuIndex: Integer;
begin
  Result := 3;
end;


function TRzListViewEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT_COLUMNS';
    1: Result := 'RZDESIGNEDITORS_EDIT_ITEMS';
    5: Result := 'RZDESIGNEDITORS_IMAGELIST';
    6: Result := 'RZDESIGNEDITORS_IMAGELIST';
    7: Result := 'RZDESIGNEDITORS_IMAGELIST';
  end;
end;


function TRzListViewEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                           var CompRefPropName: string;
                                           var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  case Index of
    5:
    begin
      CompRefClass := TCustomImageList;
      CompRefPropName := 'SmallImages';
      CompRefMenuHandler := SmallImagesMenuHandler;
      Result := True;
    end;

    6:
    begin
      CompRefClass := TCustomImageList;
      CompRefPropName := 'LargeImages';
      CompRefMenuHandler := LargeImagesMenuHandler;
      Result := True;
    end;

    7:
    begin
      CompRefClass := TCustomImageList;
      CompRefPropName := 'StateImages';
      CompRefMenuHandler := StateImagesMenuHandler;
      Result := True;
    end;
  end;
end;


procedure TRzListViewEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateViewStyleMenu( Style: TViewStyle; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Style );
    NewItem.Checked := ListView.ViewStyle = Style;
    NewItem.OnClick := ViewStyleMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  if Index = 9 then
  begin
    CreateViewStyleMenu( vsIcon, 'Icons' );
    CreateViewStyleMenu( vsSmallIcon, 'Small Icons' );
    CreateViewStyleMenu( vsList, 'List' );
    CreateViewStyleMenu( vsReport, 'Report' );
  end;
end;


procedure TRzListViewEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'Columns' );
    1: EditPropertyByName( 'Items' );
  end;
end;


procedure TRzListViewEditor.ViewStyleMenuHandler( Sender: TObject );
begin
  ListView.ViewStyle := TViewStyle( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzListViewEditor.SmallImagesMenuHandler( Sender: TObject );
var
  S: string;
  ImageList: TCustomImageList;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ImageList := Designer.GetRoot.FindComponent( S ) as TCustomImageList;
    SetObjectProp( Component, 'SmallImages', ImageList );
    Designer.Modified;
  end;
end;


procedure TRzListViewEditor.LargeImagesMenuHandler( Sender: TObject );
var
  S: string;
  ImageList: TCustomImageList;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ImageList := Designer.GetRoot.FindComponent( S ) as TCustomImageList;
    SetObjectProp( Component, 'LargeImages', ImageList );
    Designer.Modified;
  end;
end;


procedure TRzListViewEditor.StateImagesMenuHandler( Sender: TObject );
var
  S: string;
  ImageList: TCustomImageList;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ImageList := Designer.GetRoot.FindComponent( S ) as TCustomImageList;
    SetObjectProp( Component, 'StateImages', ImageList );
    Designer.Modified;
  end;
end;


{===============================}
{== TRzTreeViewEditor Methods ==}
{===============================}

function TRzTreeViewEditor.TreeView: TRzTreeView;
begin
  Result := Component as TRzTreeView;
end;


function TRzTreeViewEditor.GetVerbCount: Integer;
begin
  Result := 5;
end;


function TRzTreeViewEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Items...';
    1: Result := 'Align';
    2: Result := '-';
    3: Result := 'Set Images';
    4: Result := 'Set StateImages';
  end;
end;


function TRzTreeViewEditor.AlignMenuIndex: Integer;
begin
  Result := 1;
end;


function TRzTreeViewEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT_ITEMS';
    3: Result := 'RZDESIGNEDITORS_IMAGELIST';
    4: Result := 'RZDESIGNEDITORS_IMAGELIST';
  end;
end;


function TRzTreeViewEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                           var CompRefPropName: string;
                                           var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  case Index of
    3:
    begin
      CompRefClass := TCustomImageList;
      CompRefPropName := 'Images';
      CompRefMenuHandler := ImagesMenuHandler;
      Result := True;
    end;

    4:
    begin
      CompRefClass := TCustomImageList;
      CompRefPropName := 'StateImages';
      CompRefMenuHandler := StateImagesMenuHandler;
      Result := True;
    end;
  end;
end;


procedure TRzTreeViewEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0:
      EditPropertyByName( 'Items' );
  end;
end;


procedure TRzTreeViewEditor.ImagesMenuHandler( Sender: TObject );
var
  S: string;
  ImageList: TCustomImageList;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ImageList := Designer.GetRoot.FindComponent( S ) as TCustomImageList;
    SetObjectProp( Component, 'Images', ImageList );
    Designer.Modified;
  end;
end;


procedure TRzTreeViewEditor.StateImagesMenuHandler( Sender: TObject );
var
  S: string;
  ImageList: TCustomImageList;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ImageList := Designer.GetRoot.FindComponent( S ) as TCustomImageList;
    SetObjectProp( Component, 'StateImages', ImageList );
    Designer.Modified;
  end;
end;



{================================}
{== TRzCheckTreeEditor Methods ==}
{================================}

function TRzCheckTreeEditor.CheckTree: TRzCheckTree;
begin
  Result := Component as TRzCheckTree;
end;


function TRzCheckTreeEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount + 2;
end;


function TRzCheckTreeEditor.GetVerb(Index: Integer): string;
begin
  Result := inherited GetVerb( Index );
  case Index of
    5: Result := '-';
    6: Result := 'Cascade Checks';
  end;
end;


procedure TRzCheckTreeEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  if Index = 6 then
    Item.Checked := CheckTree.CascadeChecks;
end;


procedure TRzCheckTreeEditor.ExecuteVerb( Index: Integer );
begin
  inherited;

  case Index of
    6:
    begin
      CheckTree.CascadeChecks := not CheckTree.CascadeChecks;
      Designer.Modified;
    end;
  end;
end;



{=================================}
{== TRzBackgroundEditor Methods ==}
{=================================}

function TRzBackgroundEditor.Background: TRzBackground;
begin
  Result := Component as TRzBackground;
end;


function TRzBackgroundEditor.GetVerbCount: Integer;
begin
  Result := 11;
end;


function TRzBackgroundEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Align';
    1: Result := '-';
    2: Result := 'Show Gradient';
    3: Result := 'Gradient Direction';
    4: Result := '-';
    5: Result := 'Show Texture';
    6: Result := 'Select Texture...';
    7: Result := '-';
    8: Result := 'Show Image';
    9: Result := 'Select Image...';
    10: Result := 'Image Style';

  end;
end;


function TRzBackgroundEditor.AlignMenuIndex: Integer;
begin
  Result := 0;
end;


function TRzBackgroundEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    6: Result := 'RZDESIGNEDITORS_SELECT_TEXTURE';
    9: Result := 'RZDESIGNEDITORS_SELECT_IMAGE';
  end;
end;


procedure TRzBackgroundEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateGradientDirectionMenu( Direction: TGradientDirection; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Direction );
    NewItem.Checked := Background.GradientDirection = Direction;
    NewItem.OnClick := GradientDirectionMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateImageStyleMenu( Style: TImageStyle; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Style );
    NewItem.Checked := Background.ImageStyle = Style;
    NewItem.OnClick := ImageStyleMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    2: Item.Checked := Background.ShowGradient;

    3:
    begin
      CreateGradientDirectionMenu( gdDiagonalUp, 'Diagonal Up' );
      CreateGradientDirectionMenu( gdDiagonalDown, 'Diagonal Down' );
      CreateGradientDirectionMenu( gdHorizontalEnd, 'Horizontal End' );
      CreateGradientDirectionMenu( gdHorizontalCenter, 'Horizontal Center' );
      CreateGradientDirectionMenu( gdHorizontalBox, 'Horizontal Box' );
      CreateGradientDirectionMenu( gdVerticalEnd, 'Vertical End' );
      CreateGradientDirectionMenu( gdVerticalCenter, 'Vertical Center' );
      CreateGradientDirectionMenu( gdVerticalBox, 'Vertical Box' );
      CreateGradientDirectionMenu( gdSquareBox, 'Square Box' );
      CreateGradientDirectionMenu( gdBigSquareBox, 'Big Square Box' );
    end;

    5: Item.Checked := Background.ShowTexture;

    8: Item.Checked := Background.ShowImage;

    10:
    begin
      CreateImageStyleMenu( isCenter, 'Center' );
      CreateImageStyleMenu( isClip, 'Clip' );
      CreateImageStyleMenu( isFill, 'Fill' );
      CreateImageStyleMenu( isStretch, 'Stretch' );
      CreateImageStyleMenu( isTiled, 'Tiled' );
    end;
  end;
end;


procedure TRzBackgroundEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'Columns' );
    1: EditPropertyByName( 'Items' );
    2: Background.ShowGradient := not Background.ShowGradient;
    5: Background.ShowTexture := not Background.ShowTexture;
    6: EditPropertyByName( 'Texture' );
    8: Background.ShowImage := not Background.ShowImage;
    9: EditPropertyByName( 'Image' );
  end;
  if Index in [ 2, 5, 8 ] then
    Designer.Modified;
end;


procedure TRzBackgroundEditor.GradientDirectionMenuHandler( Sender: TObject );
begin
  Background.GradientDirection := TGradientDirection( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzBackgroundEditor.ImageStyleMenuHandler( Sender: TObject );
begin
  Background.ImageStyle := TImageStyle( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


{===============================}
{== TRzTrackBarEditor Methods ==}
{===============================}

function TRzTrackBarEditor.TrackBar: TRzTrackBar;
begin
  Result := Component as TRzTrackBar;
end;


function TRzTrackBarEditor.GetVerbCount: Integer;
begin
  Result := 5;
end;


function TRzTrackBarEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Thumb Style';
    1: Result := 'Tick Step';
    2: Result := '-';
    3: Result := 'Show Tick Marks';
    4: Result := 'Show Focus Rect';
  end;
end;


procedure TRzTrackBarEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateThumbStyleMenu( Style: TThumbStyle; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Style );
    NewItem.Checked := TrackBar.ThumbStyle = Style;
    NewItem.OnClick := ThumbStyleMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateTickStepMenu( Step: Integer; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Step;
    NewItem.Checked := TrackBar.TickStep = Step;
    NewItem.OnClick := TickStepMenuHandler;
    Item.Add( NewItem );
  end;


begin
  inherited;

  case Index of
    0:
    begin
      CreateThumbStyleMenu( tsBox, 'Box' );
      CreateThumbStyleMenu( tsCustom, 'Custom' );
      CreateThumbStyleMenu( tsMixer , 'Mixer ' );
      CreateThumbStyleMenu( tsPointer, 'Pointer' );
      CreateThumbStyleMenu( tsFlat, 'Flat' );
      CreateThumbStyleMenu( tsXPPointer, 'XP Pointer' );
      CreateThumbStyleMenu( tsXPBox, 'XP Box' );
    end;

    1:
    begin
      CreateTickStepMenu( 1, '1' );
      CreateTickStepMenu( 2, '2' );
      CreateTickStepMenu( 5, '5' );
      CreateTickStepMenu( 10, '10' );
      CreateTickStepMenu( 15, '15' );
      CreateTickStepMenu( 20, '20' );
      CreateTickStepMenu( 25, '25' );
      CreateTickStepMenu( 30, '30' );
      CreateTickStepMenu( 50, '50' );
      CreateTickStepMenu( 90, '90' );
      CreateTickStepMenu( 100, '100' );
    end;

    3: Item.Checked := TrackBar.ShowTicks;

    4: Item.Checked := TrackBar.ShowFocusRect;
  end;
end;


procedure TRzTrackBarEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    3: TrackBar.ShowTicks := not TrackBar.ShowTicks;
    4: TrackBar.ShowFocusRect := not TrackBar.ShowFocusRect;
  end;
  if Index in [ 3, 4 ] then
    Designer.Modified;
end;


procedure TRzTrackBarEditor.ThumbStyleMenuHandler( Sender: TObject );
begin
  TrackBar.ThumbStyle := TThumbStyle( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzTrackBarEditor.TickStepMenuHandler( Sender: TObject );
begin
  TrackBar.TickStep := TMenuItem( Sender ).Tag;
  Designer.Modified;
end;


{==================================}
{== TRzProgressBarEditor Methods ==}
{==================================}

function TRzProgressBarEditor.ProgressBar: TRzProgressBar;
begin
  Result := Component as TRzProgressBar;
end;


function TRzProgressBarEditor.GetVerbCount: Integer;
begin
  Result := 7;
end;


function TRzProgressBarEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Traditional Bar Style';
    1: Result := 'LED Bar Style';
    2: Result := '-';
    3: Result := 'Show Percent';
    4: Result := '-';
    5: Result := 'Status Pane - Flat Style';
    6: Result := 'Status Pane - Traditional Style';
  end;
end;


function TRzProgressBarEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_PROGRESS_TRADITIONAL';
    1: Result := 'RZDESIGNEDITORS_PROGRESS_LED';
    5: Result := 'RZDESIGNEDITORS_STATUS_FLAT';
  end;
end;


procedure TRzProgressBarEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := ProgressBar.BarStyle = bsTraditional;
    1: Item.Checked := ProgressBar.BarStyle = bsLED;
    3: Item.Checked := ProgressBar.ShowPercent;
  end;
end;


type
  TWinControlAccess = class( TWinControl );


procedure TRzProgressBarEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: ProgressBar.BarStyle := bsTraditional;
    1: ProgressBar.BarStyle := bsLED;
    3: ProgressBar.ShowPercent := not ProgressBar.ShowPercent;

    5:
    begin
      ProgressBar.BorderInner := fsFlat;
      ProgressBar.BorderOuter := fsNone;
      ProgressBar.BorderWidth := 1;
      if ProgressBar.Parent <> nil then
        ProgressBar.BackColor := TWinControlAccess( ProgressBar.Parent ).Color;
    end;

    6:
    begin
      ProgressBar.BorderInner := fsStatus;
      ProgressBar.BorderOuter := fsNone;
      ProgressBar.BorderWidth := 1;
      if ProgressBar.Parent <> nil then
        ProgressBar.BackColor := TWinControlAccess( ProgressBar.Parent ).Color;
    end;
  end;
  if Index in [ 0, 1, 3, 5, 6 ] then
    Designer.Modified;
end;



{===============================}
{== TRzFontListEditor Methods ==}
{===============================}

function TRzFontListEditor.GetVerbCount: Integer;
begin
  Result := 9;
end;


function TRzFontListEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Show Style';
    1: Result := '-';
    2: Result := 'Font Type';
    3: Result := 'Font Device';
    4: Result := 'Show Symbol Fonts';
    5: Result := '-';
    6: Result := 'Maintain MRU Fonts';
    7: Result := '-';
    8: Result := 'Align';
  end;
end;


function TRzFontListEditor.AlignMenuIndex: Integer;
begin
  Result := 8;
end;


procedure TRzFontListEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateShowStyleMenu( Style: TRzShowStyle; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Style );
    NewItem.Checked := GetOrdProp( Component, 'ShowStyle' ) = Ord( Style );
    NewItem.OnClick := ShowStyleMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateFontTypeMenu( FontType: TRzFontType; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( FontType );
    NewItem.Checked := GetOrdProp( Component, 'FontType' ) = Ord( FontType );
    NewItem.OnClick := FontTypeMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateFontDeviceMenu( Device: TRzFontDevice; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Device );
    NewItem.Checked := GetOrdProp( Component, 'FontDevice' ) = Ord( Device );
    NewItem.OnClick := FontDeviceMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0: // Show Style
    begin
      CreateShowStyleMenu( ssFontName, 'Font Name' );
      CreateShowStyleMenu( ssFontSample, 'Font Sample' );
      CreateShowStyleMenu( ssFontNameAndSample, 'Font Name and Sample' );
      CreateShowStyleMenu( ssFontPreview, 'Font Preview' );
    end;

    2: // Font Type
    begin
      CreateFontTypeMenu( ftAll, 'All Fonts' );
      CreateFontTypeMenu( ftTrueType, 'True Type Fonts' );
      CreateFontTypeMenu( ftFixedPitch, 'Fixed Pitch Fonts' );
      CreateFontTypeMenu( ftPrinter, 'Printer Fonts' );
    end;

    3: // Font Device
    begin
      CreateFontDeviceMenu( RzCmboBx.fdScreen, 'Screen' );
      CreateFontDeviceMenu( RzCmboBx.fdPrinter, 'Printer' );
    end;

    4: Item.Checked := GetOrdProp( Component, 'ShowSymbolFonts' ) = 1;
    6: Item.Checked := GetOrdProp( Component, 'MaintainMRUFonts' ) = 1;
  end;
end;


procedure TRzFontListEditor.ExecuteVerb( Index: Integer );
var
  B: Boolean;
begin
  case Index of
    4:
    begin
      B := GetOrdProp( Component, 'ShowSymbolFonts' ) = 1;
      SetOrdProp( Component, 'ShowSymbolFonts', Ord( not B ) );
    end;

    6:
    begin
      B := GetOrdProp( Component, 'MaintainMRUFonts' ) = 1;
      SetOrdProp( Component, 'MaintainMRUFonts', Ord( not B ) );
    end;
  end;
  if Index in [ 4, 6 ] then
    Designer.Modified;
end;


procedure TRzFontListEditor.ShowStyleMenuHandler( Sender: TObject );
begin
  SetOrdProp( Component, 'ShowStyle', TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzFontListEditor.FontTypeMenuHandler( Sender: TObject );
begin
  SetOrdProp( Component, 'FontType', TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzFontListEditor.FontDeviceMenuHandler( Sender: TObject );
begin
  SetOrdProp( Component, 'FontDevice', TMenuItem( Sender ).Tag );
  Designer.Modified;
end;

{==================================}
{== TRzEditControlEditor Methods ==}
{==================================}

function TRzEditControlEditor.EditControl: TRzCustomEdit;
begin
  Result := Component as TRzCustomEdit;
end;


function TRzEditControlEditor.GetVerbCount: Integer;
begin
  Result := 8;
end;


function TRzEditControlEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Left Justify';
    1: Result := 'Right Justify';
    2: Result := '-';
    3: Result := 'Normal Case';
    4: Result := 'Upper Case';
    5: Result := 'Lower Case';
    6: Result := '-';
    7: Result := 'Align';
  end;
end;


function TRzEditControlEditor.AlignMenuIndex: Integer;
begin
  Result := 7;
end;


type
  TRzCustomEditAccess = class( TRzCustomEdit );

procedure TRzEditControlEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := TRzCustomEditAccess( EditControl ).Alignment = taLeftJustify;
    1: Item.Checked := TRzCustomEditAccess( EditControl ).Alignment = taRightJustify;
    3: Item.Checked := TRzCustomEditAccess( EditControl ).CharCase = ecNormal;
    4: Item.Checked := TRzCustomEditAccess( EditControl ).CharCase = ecUpperCase;
    5: Item.Checked := TRzCustomEditAccess( EditControl ).CharCase = ecLowerCase;
  end;
end;


procedure TRzEditControlEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: TRzCustomEditAccess( EditControl ).Alignment := taLeftJustify;
    1: TRzCustomEditAccess( EditControl ).Alignment := taRightJustify;
    3: TRzCustomEditAccess( EditControl ).CharCase := ecNormal;
    4: TRzCustomEditAccess( EditControl ).CharCase := ecUpperCase;
    5: TRzCustomEditAccess( EditControl ).CharCase := ecLowerCase;
  end;
  if Index in [ 0, 1, 3..5 ] then
    Designer.Modified;
end;



{=================================}
{== TRzButtonEditEditor Methods ==}
{=================================}

function TRzButtonEditEditor.ButtonEdit: TRzButtonEdit;
begin
  Result := Component as TRzButtonEdit;
end;


function TRzButtonEditEditor.GetVerbCount: Integer;
begin
  Result := 8;
end;


function TRzButtonEditEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Show Button';
    1: Result := 'Button Kind';
    2: Result := '-';
    3: Result := 'Show Alternate Button';
    4: Result := 'Alternate Button Kind';
    5: Result := '-';
    6: Result := 'Flat Buttons';
    7: Result := 'Allow Key Edit';
  end;
end;


procedure TRzButtonEditEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateButtonKindMenu( Kind: TButtonKind; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Kind );
    NewItem.Checked := ButtonEdit.ButtonKind = Kind;
    NewItem.OnClick := ButtonKindMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateAltBtnKindMenu( Kind: TButtonKind; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Kind );
    NewItem.Checked := ButtonEdit.AltBtnKind = Kind;
    NewItem.OnClick := AltBtnKindMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0: Item.Checked := ButtonEdit.ButtonVisible;

    1: // ButtonKind
    begin
      CreateButtonKindMenu( bkCustom, 'Custom' );
      CreateButtonKindMenu( bkLookup, 'Lookup' );
      CreateButtonKindMenu( bkDropDown, 'DropDown' );
      CreateButtonKindMenu( bkCalendar, 'Calendar' );
      CreateButtonKindMenu( bkAccept, 'Accept' );
      CreateButtonKindMenu( bkReject, 'Reject' );
      CreateButtonKindMenu( bkFolder, 'Folder' );
      CreateButtonKindMenu( bkFind, 'Find' );
      CreateButtonKindMenu( bkSearch, 'Search' );
    end;

    3: Item.Checked := ButtonEdit.AltBtnVisible;

    4: // AltBtnKind
    begin
      CreateAltBtnKindMenu( bkCustom, 'Custom' );
      CreateAltBtnKindMenu( bkLookup, 'Lookup' );
      CreateAltBtnKindMenu( bkDropDown, 'DropDown' );
      CreateAltBtnKindMenu( bkCalendar, 'Calendar' );
      CreateAltBtnKindMenu( bkAccept, 'Accept' );
      CreateAltBtnKindMenu( bkReject, 'Reject' );
      CreateAltBtnKindMenu( bkFolder, 'Folder' );
      CreateAltBtnKindMenu( bkFind, 'Find' );
      CreateAltBtnKindMenu( bkSearch, 'Search' );
    end;

    6: Item.Checked := ButtonEdit.FlatButtons;
    7: Item.Checked := ButtonEdit.AllowKeyEdit;
  end;
end;


procedure TRzButtonEditEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: ButtonEdit.ButtonVisible := not ButtonEdit.ButtonVisible;
    3: ButtonEdit.AltBtnVisible := not ButtonEdit.AltBtnVisible;
    6: ButtonEdit.FlatButtons := not ButtonEdit.FlatButtons;
    7: ButtonEdit.AllowKeyEdit := not ButtonEdit.AllowKeyEdit;
  end;
  if Index in [ 0, 3, 6, 7 ] then
    Designer.Modified;
end;


procedure TRzButtonEditEditor.ButtonKindMenuHandler( Sender: TObject );
begin
  ButtonEdit.ButtonKind := TButtonKind( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzButtonEditEditor.AltBtnKindMenuHandler( Sender: TObject );
begin
  ButtonEdit.AltBtnKind := TButtonKind( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


{==================================}
{== TRzNumericEditEditor Methods ==}
{==================================}

function TRzNumericEditEditor.NumericEdit: TRzNumericEdit;
begin
  Result := Component as TRzNumericEdit;
end;


function TRzNumericEditEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;


function TRzNumericEditEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Integers Only';
    1: Result := 'Check Range';
    2: Result := 'Allow Blank';
  end;
end;


procedure TRzNumericEditEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := NumericEdit.IntegersOnly;
    1: Item.Checked := NumericEdit.CheckRange;
    2: Item.Checked := NumericEdit.AllowBlank;
  end;
end;


procedure TRzNumericEditEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: NumericEdit.IntegersOnly := not NumericEdit.IntegersOnly;
    1: NumericEdit.CheckRange := not NumericEdit.CheckRange;
    2: NumericEdit.AllowBlank := not NumericEdit.AllowBlank;
  end;
  if Index in [ 0, 1, 2 ] then
    Designer.Modified;
end;



{===============================}
{== TRzSpinEditEditor Methods ==}
{===============================}

function TRzSpinEditEditor.SpinEdit: TRzSpinEdit;
begin
  Result := Component as TRzSpinEdit;
end;


function TRzSpinEditEditor.GetVerbCount: Integer;
begin
  Result := 8;
end;


function TRzSpinEditEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Integers Only';
    1: Result := 'Allow Key Edit';
    2: Result := 'Check Range';
    3: Result := 'Allow Blank';
    4: Result := '-';
    5: Result := 'Flat Buttons';
    6: Result := 'Direction';
    7: Result := 'Orientation';
  end;
end;


procedure TRzSpinEditEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateDirectionMenu( Direction: TSpinDirection; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Direction );
    NewItem.Checked := SpinEdit.Direction = Direction;
    NewItem.OnClick := DirectionMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateOrientationMenu( Orientation: TOrientation; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Orientation );
    NewItem.Checked := SpinEdit.Orientation = Orientation;
    NewItem.OnClick := OrientationMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0: Item.Checked := SpinEdit.IntegersOnly;
    1: Item.Checked := SpinEdit.AllowKeyEdit;
    2: Item.Checked := SpinEdit.CheckRange;
    3: Item.Checked := SpinEdit.AllowBlank;
    5: Item.Checked := SpinEdit.FlatButtons;

    6: // Direction
    begin
      CreateDirectionMenu( sdUpDown, 'Up/Down' );
      CreateDirectionMenu( sdLeftRight, 'Left/Right' );
    end;

    7: // Orientation
    begin
      CreateOrientationMenu( orHorizontal, 'Horizontal' );
      CreateOrientationMenu( orVertical, 'Vertical' );
    end;
  end;
end;


procedure TRzSpinEditEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: SpinEdit.IntegersOnly := not SpinEdit.IntegersOnly;
    1: SpinEdit.AllowKeyEdit := not SpinEdit.AllowKeyEdit;
    2: SpinEdit.CheckRange := not SpinEdit.CheckRange;
    3: SpinEdit.AllowBlank := not SpinEdit.AllowBlank;
    5: SpinEdit.FlatButtons := not SpinEdit.FlatButtons;
  end;
  if Index in [ 0, 1, 2, 3, 5 ] then
    Designer.Modified;
end;


procedure TRzSpinEditEditor.DirectionMenuHandler( Sender: TObject );
begin
  SpinEdit.Direction := TSpinDirection( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzSpinEditEditor.OrientationMenuHandler( Sender: TObject );
begin
  SpinEdit.Orientation := TOrientation( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


{==================================}
{== TRzSpinButtonsEditor Methods ==}
{==================================}

function TRzSpinButtonsEditor.SpinButtons: TRzSpinButtons;
begin
  Result := Component as TRzSpinButtons;
end;


function TRzSpinButtonsEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;


function TRzSpinButtonsEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Flat Buttons';
    1: Result := 'Direction';
    2: Result := 'Orientation';
  end;
end;


procedure TRzSpinButtonsEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateDirectionMenu( Direction: TSpinDirection; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Direction );
    NewItem.Checked := SpinButtons.Direction = Direction;
    NewItem.OnClick := DirectionMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateOrientationMenu( Orientation: TOrientation; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Orientation );
    NewItem.Checked := SpinButtons.Orientation = Orientation;
    NewItem.OnClick := OrientationMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0: Item.Checked := SpinButtons.Flat;

    1: // Direction
    begin
      CreateDirectionMenu( sdUpDown, 'Up/Down' );
      CreateDirectionMenu( sdLeftRight, 'Left/Right' );
    end;

    2: // Orientation
    begin
      CreateOrientationMenu( orHorizontal, 'Horizontal' );
      CreateOrientationMenu( orVertical, 'Vertical' );
    end;
  end;
end;


procedure TRzSpinButtonsEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0:
    begin
      SpinButtons.Flat := not SpinButtons.Flat;
      Designer.Modified;
    end;
  end;
end;


procedure TRzSpinButtonsEditor.DirectionMenuHandler( Sender: TObject );
begin
  SpinButtons.Direction := TSpinDirection( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


procedure TRzSpinButtonsEditor.OrientationMenuHandler( Sender: TObject );
begin
  SpinButtons.Orientation := TOrientation( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


{==============================}
{== TRzSpinnerEditor Methods ==}
{==============================}

function TRzSpinnerEditor.Spinner: TRzSpinner;
begin
  Result := Component as TRzSpinner;
end;


function TRzSpinnerEditor.GetVerbCount: Integer;
begin
  Result := 5;
end;


function TRzSpinnerEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Check Range';
    1: Result := '-';
    2: Result := 'Set ImageList';
    3: Result := 'Select Plus Image...';
    4: Result := 'Select Minus Image...';
  end;
end;


function TRzSpinnerEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    2: Result := 'RZDESIGNEDITORS_IMAGELIST';
  end;
end;


function TRzSpinnerEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                          var CompRefPropName: string;
                                          var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  if Index = 2 then
  begin
    CompRefClass := TCustomImageList;
    CompRefPropName := 'Images';
    CompRefMenuHandler := nil;
    Result := True;
  end
end;


procedure TRzSpinnerEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := Spinner.CheckRange;
  end;
end;


procedure TRzSpinnerEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0:
    begin
      Spinner.CheckRange := not Spinner.CheckRange;
      Designer.Modified;
    end;

    3: EditPropertyByName( 'ImageIndexPlus' );
    4: EditPropertyByName( 'ImageIndexMinus' );
  end;
end;



{===================================}
{== TRzLookupDialogEditor Methods ==}
{===================================}

function TRzLookupDialogEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


function TRzLookupDialogEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Preview Dialog';
  end;
end;


function TRzLookupDialogEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_PREVIEW_DIALOG';
  end;
end;


procedure TRzLookupDialogEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0:
    begin
      if Component is TRzLookupDialog then
        TRzLookupDialog( Component ).Execute;
      Designer.Modified;
    end;
  end;
end;



{====================================}
{== TRzDialogButtonsEditor Methods ==}
{====================================}

function TRzDialogButtonsEditor.DialogButtons: TRzDialogButtons;
begin
  Result := Component as TRzDialogButtons;
end;


function TRzDialogButtonsEditor.GetVerbCount: Integer;
begin
  Result := 8;
end;


function TRzDialogButtonsEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Align';
    1: Result := '-';
    2: Result := 'Show OK Button';
    3: Result := 'Show Cancel Button';
    4: Result := 'Show Help Button';
    5: Result := '-';
    6: Result := 'HotTrack';
    7: Result := 'XP Colors';
  end;
end;


function TRzDialogButtonsEditor.AlignMenuIndex: Integer;
begin
  Result := 0;
end;


function TRzDialogButtonsEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    6: Result := 'RZDESIGNEDITORS_HOTTRACK';
    7: Result := 'RZDESIGNEDITORS_XPCOLORS';
  end;
end;


procedure TRzDialogButtonsEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    2: Item.Checked := DialogButtons.ShowOkButton;
    3: Item.Checked := DialogButtons.ShowCancelButton;
    4: Item.Checked := DialogButtons.ShowHelpButton;
    6: Item.Checked := DialogButtons.HotTrack;
  end;
end;


procedure TRzDialogButtonsEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    2: DialogButtons.ShowOkButton := not DialogButtons.ShowOkButton;
    3: DialogButtons.ShowCancelButton := not DialogButtons.ShowCancelButton;
    4: DialogButtons.ShowHelpButton := not DialogButtons.ShowHelpButton;
    6: DialogButtons.HotTrack := not DialogButtons.HotTrack;

    7: // XP Colors
    begin
      DialogButtons.HotTrackColorType := htctActual;
      DialogButtons.HotTrack := True;
      DialogButtons.HotTrackColor := $003CC7FF;
      DialogButtons.HighlightColor := $00F48D6A;
      DialogButtons.ButtonColor := $00F0F4F4;
    end;

  end;
  if Index in [ 2, 3, 4, 6, 7 ] then
    Designer.Modified;
end;


{================================}
{== ChangeUI Support Procedure ==}
{================================}

procedure ChangeUI( Root: TComponent; Style: Integer );
var
  I: Integer;
  C: TComponent;


  procedure SetIntProp( C: TComponent; const PropName: string; Value: Integer );
  begin
    if C <> nil then
    begin
      if IsPublishedProp( C, PropName ) then
        SetOrdProp( C, PropName, Value );
    end;
  end;

  procedure SetBooleanProp( C: TComponent; const PropName: string; Value: Boolean );
  begin
    if C <> nil then
    begin
      if IsPublishedProp( C, PropName ) then
        SetOrdProp( C, PropName, Ord( Value ) );
    end;
  end;

  procedure SetStyleProp( C: TComponent; const PropName: string; Value: TFrameStyle );
  begin
    if C <> nil then
    begin
      if IsPublishedProp( C, PropName ) then
        SetOrdProp( C, PropName, Ord( Value ) );
    end;
  end;

  procedure SetPreferenceProp( C: TComponent; const PropName: string; Value: TFramingPreference );
  begin
    if C <> nil then
    begin
      if IsPublishedProp( C, PropName ) then
        SetOrdProp( C, PropName, Ord( Value ) );
    end;
  end;

  procedure SetHotTrackColorTypeProp( C: TComponent; const PropName: string; Value: TRzHotTrackColorType );
  begin
    if C <> nil then
    begin
      if IsPublishedProp( C, PropName ) then
        SetOrdProp( C, PropName, Ord( Value ) );
    end;
  end;

  procedure SetColorProp( C: TComponent; const PropName: string; Value: TColor );
  begin
    if C <> nil then
    begin
      if IsPublishedProp( C, PropName ) then
        SetOrdProp( C, PropName, Value );
    end;
  end;

  procedure SetFrameSidesProp( C: TComponent );
  var
    Side: TSide;
    SidesSet: Cardinal;
    PropInfo: PPropInfo;
  begin
    if C <> nil then
    begin
      PropInfo := GetPropInfo( PTypeInfo( C.ClassInfo), 'FrameSides' );
      if PropInfo <> nil then
      begin
        if GetTypeData( PropInfo^.PropType^ )^.CompType^.Kind <> tkEnumeration then
          Exit;

        SidesSet := 0;
        for Side := RzCommon.sdLeft to RzCommon.sdBottom do
          SidesSet := SidesSet or ( 1 shl Ord( Side ) );

        SetOrdProp( C, PropInfo, SidesSet );
      end;
    end;
  end;


begin {= ChangeUI =}
  for I := 0 to Root.ComponentCount - 1 do
  begin
    C := Root.Components[ I ];

    // First Check from Custom Framing

    if IsPublishedProp( C, 'FrameController' ) and not ( C is TRzCustomButton ) then
    begin
      if GetObjectProp( C, 'FrameController' ) = nil then
      begin
        SetBooleanProp( C, 'FlatButtons', True );
        if Style = 1 then
          SetColorProp( C, 'FrameColor', $00B99D7F )
        else
          SetColorProp( C, 'FrameColor', clBtnShadow );
        SetFrameSidesProp( C );
        SetStyleProp( C, 'FrameStyle', fsFlat );
        SetBooleanProp( C, 'FrameVisible', Style <> 2 );
        SetPreferenceProp( C, 'FramingPreference', fpXPThemes );
      end;
    end
    else if ( C is TRzCustomButton ) or ( C is TRzDialogButtons ) then
    begin
      SetBooleanProp( C, 'HotTrack', Style <> 2 );

      if Style = 1 then
      begin
        SetColorProp( C, 'HotTrackColor', $003CC7FF );
        SetHotTrackColorTypeProp( C, 'HotTrackColorType', htctActual );

        if C is TRzCustomGlyphButton then
        begin
          SetColorProp( C, 'HighlightColor', $0021A121 );
          SetColorProp( C, 'FrameColor', $0080511C );
        end
        else if C is TRzDialogButtons then
        begin
          SetColorProp( C, 'HighlightColor', $00F48D6A );
          SetColorProp( C, 'ButtonColor', $00F0F4F4 );
        end
        else
        begin
          SetColorProp( C, 'HighlightColor', $00F48D6A );
          SetColorProp( C, 'Color', $00F0F4F4 );
        end;
      end
      else
      begin
        SetColorProp( C, 'HotTrackColor', clHighlight );
        SetHotTrackColorTypeProp( C, 'HotTrackColorType', htctComplement );

        if C is TRzCustomGlyphButton then
        begin
          SetColorProp( C, 'HighlightColor', clHighlight );
          SetColorProp( C, 'FrameColor', clBtnShadow );
        end
        else if C is TRzDialogButtons then
        begin
          SetColorProp( C, 'HighlightColor', clHighlight );
          SetColorProp( C, 'ButtonColor', clBtnFace );
        end
        else
        begin
          SetColorProp( C, 'HighlightColor', clHighlight );
          SetColorProp( C, 'Color', clBtnFace );
        end;
      end;
    end
    else if ( C is TRzCustomRadioGroup ) or ( C is TRzCustomCheckGroup ) then
    begin
      SetBooleanProp( C, 'ItemHotTrack', Style <> 2 );
    end
    else if ( C is TRzCalendar ) or ( C is TRzTimePicker ) or ( C is TRzColorPicker ) then
    begin
      if Style = 2 then
        SetStyleProp( C, 'BorderOuter', fsLowered )
      else
        SetStyleProp( C, 'BorderOuter', fsFlat );
      if Style = 1 then
      begin
        SetColorProp( C, 'FlatColor', $0080511C );
        SetIntProp( C, 'FlatColorAdjustment', 0 );
      end
      else
      begin
        SetColorProp( C, 'FlatColor', clBtnShadow );
        SetIntProp( C, 'FlatColorAdjustment', 30 );
      end;
    end
    else if ( C is TRzPageControl ) or ( C is TRzTabControl ) then
    begin
      if Style = 1 then
      begin
        SetHotTrackColorTypeProp( C, 'HotTrackColorType', htctActual );
        SetColorProp( C, 'HotTrackColor', $003CC7FF );
        if C is TRzPageControl then
          TRzPageControl( C ).TabColors.HighlightBar := $003CC7FF
        else
          TRzTabControl( C ).TabColors.HighlightBar := $003CC7FF;
        SetColorProp( C, 'FlatColor', $009C9B91 );
        SetColorProp( C, 'Color', $00F5F6F7 );
        SetBooleanProp( C, 'ShowShadow', True );
      end
      else
      begin
        SetHotTrackColorTypeProp( C, 'HotTrackColorType', htctComplement );
        SetColorProp( C, 'HotTrackColor', clHighlight );
        if C is TRzPageControl then
          TRzPageControl( C ).TabColors.HighlightBar := clHighlight
        else
          TRzTabControl( C ).TabColors.HighlightBar := clHighlight;
        SetColorProp( C, 'FlatColor', clBtnShadow );
        SetColorProp( C, 'Color', clBtnFace );
        SetBooleanProp( C, 'ShowShadow', True );
      end;
    end;
  end;
end; {= ChangeUI =}





{===========================}
{== TRzFormEditor Methods ==}
{===========================}

function TRzFormEditor.Form: TForm;
begin
  Result := Component as TForm;
end;


function TRzFormEditor.GetVerbCount: Integer;
begin
  Result := 16;
end;


function TRzFormEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Change UI Style';
    1: Result := '-';
    2: Result := 'Add a Group Bar';
    3: Result := 'Add a Toolbar';
    4: Result := 'Add a Status Bar';
    5: Result := 'Add a Splitter';
    6: Result := 'Add a Size Panel';
    7: Result := 'Add a Panel';
    8: Result := '-';
    9: Result := 'Add an Image List';
    10: Result := 'Add a Frame Controller';
    11: Result := 'Add a Form State component';
    12: Result := 'Add a RegIniFile component';
    13: Result := '-';
    14: Result := 'Create Dialog';
    15: Result := 'Create Options Dialog';
  end;
end;


function TRzFormEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    2: Result := 'RZDESIGNEDITORS_GROUPBAR_CATEGORYVIEW';
    3: Result := 'RZDESIGNEDITORS_TOOLBAR_STYLE_NOCAPTIONS';
    4: Result := 'RZDESIGNEDITORS_STATUSBAR';
    5: Result := 'RZDESIGNEDITORS_SPLIT_HORIZONTAL';
    6: Result := 'RZDESIGNEDITORS_SIZEPANEL';
    7: Result := 'RZDESIGNEDITORS_PANEL';
    9: Result := 'RZDESIGNEDITORS_IMAGELIST';
    10: Result := 'RZDESIGNEDITORS_FRAME_CONTROLLER';
    11: Result := 'RZDESIGNEDITORS_FORM_STATE';
    12: Result := 'RZDESIGNEDITORS_REGINIFILE';
  end;
end;


procedure TRzFormEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateStyleMenu( Style: Integer; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Style;
    case Style of
      0: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_UISTYLE_FLAT' );
      1: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_UISTYLE_XP' );
      2: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_UISTYLE_DEFAULT' );
    end;
    NewItem.OnClick := StyleMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0:
    begin
      CreateStyleMenu( 0, 'Flat' );
      CreateStyleMenu( 1, 'Flat (XP Coloring)' );
      CreateStyleMenu( 2, 'Default' );
    end;
  end;
end;



var
  ImgListOffset: Integer = 0;

procedure TRzFormEditor.ExecuteVerb( Index: Integer );
var
  CompOwner: TComponent;
  PageControl: TRzPageControl;
  DlgButtons: TRzDialogButtons;
  TabSheet: TRzTabSheet;
  Splitter: TRzSplitter;
begin
  case Index of
    2: Designer.CreateComponent( TRzGroupBar, Form, 10, 10, 0, 0 );
    3: Designer.CreateComponent( TRzToolbar, Form, 10, 10, 0, 0 );
    4: Designer.CreateComponent( TRzStatusBar, Form, 10, 10, 0, 0 );

    5:
    begin
      Splitter := Designer.CreateComponent( TRzSplitter, Form, 10, 10, 0, 0 ) as TRzSplitter;
      Splitter.Align := alClient;
    end;

    6: Designer.CreateComponent( TRzSizePanel, Form, 10, 10, 168, 100 );
    7: Designer.CreateComponent( TRzPanel, Form, 200, 128, 100, 100 );

    9: // ImageList
    begin
      Designer.CreateComponent( TImageList, Form, 200 + ( ImgListOffset * 28 ), 48, 24, 24 );
      Inc( ImgListOffset );
      if ImgListOffset > 10 then
        ImgListOffset := 0;
    end;

    10: Designer.CreateComponent( TRzFrameController, Form, 200, 84, 24, 24 );
    11: Designer.CreateComponent( TRzFormState, Form, 228, 84, 24, 24 );
    12: Designer.CreateComponent( TRzRegIniFile, Form, 256, 84, 24, 24 );

    14: // Create Dialog
    begin
      Designer.CreateComponent( TRzDialogButtons, Form, 10, 10, 0, 0 );
      Form.BorderStyle := bsDialog;
    end;

    15: // Create Options Dialog
    begin
      CompOwner := Designer.GetRoot;
      if CompOwner <> nil then
      begin
        DlgButtons := Designer.CreateComponent( TRzDialogButtons, Form, 10, 10, 0, 0 ) as TRzDialogButtons;
        Form.BorderStyle := bsDialog;

        PageControl := Designer.CreateComponent( TRzPageControl, Form, 8, 8,
                                                 Form.ClientWidth - 16,
                                                 Form.ClientHeight - 8 - DlgButtons.Height ) as TRzPageControl;
        PageControl.Anchors := [ akLeft, akTop, akRight, akBottom ];

        TabSheet := Designer.CreateComponent( TRzTabSheet, PageControl, 10, 10, 0, 0 ) as TRzTabSheet;
        TabSheet.PageControl := PageControl;
        TabSheet.Caption := 'Page One';

        TabSheet := Designer.CreateComponent( TRzTabSheet, PageControl, 10, 10, 0, 0 ) as TRzTabSheet;
        TabSheet.PageControl := PageControl;
        TabSheet.Caption := 'Page Two';

        PageControl.TabIndex := 0;
        Designer.SelectComponent( PageControl );
      end;
    end;
  end;
  if Index in [ 2..7, 9..12, 14, 15 ] then
    Designer.Modified;
end; {= TRzFormEditor.ExecuteVerb =}


procedure TRzFormEditor.StyleMenuHandler( Sender: TObject );
begin
  ChangeUI( Form, TMenuItem( Sender ).Tag );
  Designer.Modified;
end;



{============================}
{== TRzFrameEditor Methods ==}
{============================}

function TRzFrameEditor.Frame: TFrame;
begin
  Result := Component as TFrame;
end;


function TRzFrameEditor.GetVerbCount: Integer;
begin
  Result := 11;
end;


function TRzFrameEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Change UI Style';
    1: Result := '-';
    2: Result := 'Add a Group Bar';
    3: Result := 'Add a Toolbar';
    4: Result := 'Add a Status Bar';
    5: Result := 'Add a Splitter';
    6: Result := 'Add a Size Panel';
    7: Result := 'Add a Panel';
    8: Result := '-';
    9: Result := 'Add an Image List';
    10: Result := 'Add a Frame Controller';
  end;
end;


function TRzFrameEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    2: Result := 'RZDESIGNEDITORS_GROUPBAR_CATEGORYVIEW';
    3: Result := 'RZDESIGNEDITORS_TOOLBAR_STYLE_NOCAPTIONS';
    4: Result := 'RZDESIGNEDITORS_STATUSBAR';
    5: Result := 'RZDESIGNEDITORS_SPLIT_HORIZONTAL';
    6: Result := 'RZDESIGNEDITORS_SIZEPANEL';
    7: Result := 'RZDESIGNEDITORS_PANEL';
    9: Result := 'RZDESIGNEDITORS_IMAGELIST';
    10: Result := 'RZDESIGNEDITORS_FRAME_CONTROLLER';
  end;
end;


procedure TRzFrameEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateStyleMenu( Style: Integer; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Style;
    case Style of
      0: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_UISTYLE_FLAT' );
      1: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_UISTYLE_XP' );
      2: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_UISTYLE_DEFAULT' );
    end;
    NewItem.OnClick := StyleMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0:
    begin
      CreateStyleMenu( 0, 'Flat' );
      CreateStyleMenu( 1, 'Flat (XP Coloring)' );
      CreateStyleMenu( 2, 'Default' );
    end;
  end;
end;


procedure TRzFrameEditor.ExecuteVerb( Index: Integer );
var
  Splitter: TRzSplitter;
begin
  case Index of
    2: Designer.CreateComponent( TRzGroupBar, Frame, 10, 10, 0, 0 );
    3: Designer.CreateComponent( TRzToolbar, Frame, 10, 10, 0, 0 );
    4: Designer.CreateComponent( TRzStatusBar, Frame, 10, 10, 0, 0 );

    5:
    begin
      Splitter := Designer.CreateComponent( TRzSplitter, Frame, 10, 10, 0, 0 ) as TRzSplitter;
      Splitter.Align := alClient;
    end;

    6: Designer.CreateComponent( TRzSizePanel, Frame, 10, 10, 168, 100 );
    7: Designer.CreateComponent( TRzPanel, Frame, 200, 128, 100, 100 );

    9: // ImageList
    begin
      Designer.CreateComponent( TImageList, Frame, 200 + ( ImgListOffset * 28 ), 48, 24, 24 );
      Inc( ImgListOffset );
      if ImgListOffset > 10 then
        ImgListOffset := 0;
    end;

    10: Designer.CreateComponent( TRzFrameController, Frame, 200, 84, 24, 24 );
  end;
  if Index in [ 2..7, 9, 10 ] then
    Designer.Modified;
end; {= TRzFrameEditor.ExecuteVerb =}


procedure TRzFrameEditor.StyleMenuHandler( Sender: TObject );
begin
  ChangeUI( Frame, TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


{===================================}
{== TRzDateTimeEditEditor Methods ==}
{===================================}

function TRzDateTimeEditEditor.DateTimeEdit: TRzDateTimeEdit;
begin
  Result := Component as TRzDateTimeEdit;
end;


function TRzDateTimeEditEditor.GetVerbCount: Integer;
begin
  Result := 5;
end;


function TRzDateTimeEditEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Date';
    1: Result := 'Time';
    2: Result := '-';
    3:
    begin
      if DateTimeEdit.EditType = etDate then
        Result := 'Visible Elements'
      else
        Result := 'Restrict Minutes (by 5)';
    end;

    4:
    begin
      if DateTimeEdit.EditType = etDate then
        Result := 'First Day of Week'
      else
        Result := 'Show How to Select Time Hint';
    end;
  end;
end;


function TRzDateTimeEditEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_DATE';
    1: Result := 'RZDESIGNEDITORS_TIME';
  end;
end;


procedure TRzDateTimeEditEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateElementsMenu( Element: TRzCalendarElement; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Element );
    NewItem.Checked := Element in DateTimeEdit.CalendarElements;
    NewItem.OnClick := ElementsMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateFirstDayOfWeekMenu( DOW: TRzFirstDayOfWeek; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( DOW );
    NewItem.Checked := DateTimeEdit.FirstDayOfWeek = DOW;
    NewItem.OnClick := FirstDayOfWeekMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0: Item.Checked := DateTimeEdit.EditType = etDate;
    1: Item.Checked := DateTimeEdit.EditType = etTime;

    3:
    begin
      if DateTimeEdit.EditType = etDate then
      begin
        CreateElementsMenu( ceYear, 'Year' );
        CreateElementsMenu( ceMonth, 'Month' );
        CreateElementsMenu( ceArrows, 'Arrows' );
        CreateElementsMenu( ceWeekNumbers, 'Week Numbers' );
        CreateElementsMenu( ceDaysOfWeek, 'Days of the Week' );
        CreateElementsMenu( ceFillDays, 'Fill Days' );
        CreateElementsMenu( ceTodayButton, 'Today Button' );
        CreateElementsMenu( ceClearButton, 'Clear Button' );
      end
      else
      begin
        Item.Checked := DateTimeEdit.RestrictMinutes;
      end;
    end;

    4:
    begin
      if DateTimeEdit.EditType = etDate then
      begin
        CreateFirstDayOfWeekMenu( fdowMonday, 'Monday' );
        CreateFirstDayOfWeekMenu( fdowTuesday, 'Tuesday' );
        CreateFirstDayOfWeekMenu( fdowWednesday, 'Wednesday' );
        CreateFirstDayOfWeekMenu( fdowThursday, 'Thursday' );
        CreateFirstDayOfWeekMenu( fdowFriday, 'Friday' );
        CreateFirstDayOfWeekMenu( fdowSaturday, 'Saturday' );
        CreateFirstDayOfWeekMenu( fdowSunday, 'Sunday' );
        CreateFirstDayOfWeekMenu( fdowLocale, 'Locale' );
      end
      else
      begin
        Item.Checked := DateTimeEdit.ShowHowToUseHint;
      end;
    end;
  end;
end;


procedure TRzDateTimeEditEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: DateTimeEdit.EditType := etDate;
    1: DateTimeEdit.EditType := etTime;

    3:
    begin
      if DateTimeEdit.EditType = etTime then
        DateTimeEdit.RestrictMinutes := not DateTimeEdit.RestrictMinutes;
    end;

    4:
    begin
      if DateTimeEdit.EditType = etTime then
        DateTimeEdit.ShowHowToUseHint := not DateTimeEdit.ShowHowToUseHint;
    end;
  end;
  if Index in [ 0, 1, 3, 4 ] then
    Designer.Modified;
end;


procedure TRzDateTimeEditEditor.ElementsMenuHandler( Sender: TObject );
var
  MI: TMenuItem;
  Element: TRzCalendarElement;
begin
  MI := TMenuItem( Sender );
  Element := TRzCalendarElement( MI.Tag );
  // Remove the element if checked, b/c menu has not yet been updated to remove the check
  if MI.Checked then
    DateTimeEdit.CalendarElements := DateTimeEdit.CalendarElements - [ Element ]
  else
    DateTimeEdit.CalendarElements := DateTimeEdit.CalendarElements + [ Element ];
  Designer.Modified;
end;


procedure TRzDateTimeEditEditor.FirstDayOfWeekMenuHandler( Sender: TObject );
begin
  DateTimeEdit.FirstDayOfWeek := TRzFirstDayOfWeek( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


{===============================}
{== TRzCalendarEditor Methods ==}
{===============================}

function TRzCalendarEditor.Calendar: TRzCalendar;
begin
  Result := Component as TRzCalendar;
end;


function TRzCalendarEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;


function TRzCalendarEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Visible Elements';
    1: Result := 'First Day of Week';
    2: Result := 'AutoSize';
  end;
end;


procedure TRzCalendarEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateElementsMenu( Element: TRzCalendarElement; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Element );
    NewItem.Checked := Element in Calendar.Elements;
    NewItem.OnClick := ElementsMenuHandler;
    Item.Add( NewItem );
  end;

  procedure CreateFirstDayOfWeekMenu( DOW: TRzFirstDayOfWeek; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( DOW );
    NewItem.Checked := Calendar.FirstDayOfWeek = DOW;
    NewItem.OnClick := FirstDayOfWeekMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0:
    begin
      CreateElementsMenu( ceYear, 'Year' );
      CreateElementsMenu( ceMonth, 'Month' );
      CreateElementsMenu( ceArrows, 'Arrows' );
      CreateElementsMenu( ceWeekNumbers, 'Week Numbers' );
      CreateElementsMenu( ceDaysOfWeek, 'Days of the Week' );
      CreateElementsMenu( ceFillDays, 'Fill Days' );
      CreateElementsMenu( ceTodayButton, 'Today Button' );
      CreateElementsMenu( ceClearButton, 'Clear Button' );
    end;

    1:
    begin
      CreateFirstDayOfWeekMenu( fdowMonday, 'Monday' );
      CreateFirstDayOfWeekMenu( fdowTuesday, 'Tuesday' );
      CreateFirstDayOfWeekMenu( fdowWednesday, 'Wednesday' );
      CreateFirstDayOfWeekMenu( fdowThursday, 'Thursday' );
      CreateFirstDayOfWeekMenu( fdowFriday, 'Friday' );
      CreateFirstDayOfWeekMenu( fdowSaturday, 'Saturday' );
      CreateFirstDayOfWeekMenu( fdowSunday, 'Sunday' );
      CreateFirstDayOfWeekMenu( fdowLocale, 'Locale' );
    end;

    2: Item.Checked := Calendar.AutoSize;
  end;
end;


procedure TRzCalendarEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    2:
    begin
      Calendar.AutoSize := not Calendar.AutoSize;
      Designer.Modified;
    end;
  end;
end;


procedure TRzCalendarEditor.ElementsMenuHandler( Sender: TObject );
var
  MI: TMenuItem;
  Element: TRzCalendarElement;
begin
  MI := TMenuItem( Sender );
  Element := TRzCalendarElement( MI.Tag );
  // Remove the element if checked, b/c menu has not yet been updated to remove the check
  if MI.Checked then
    Calendar.Elements := Calendar.Elements - [ Element ]
  else
    Calendar.Elements := Calendar.Elements + [ Element ];
  Designer.Modified;
end;


procedure TRzCalendarEditor.FirstDayOfWeekMenuHandler( Sender: TObject );
begin
  Calendar.FirstDayOfWeek := TRzFirstDayOfWeek( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;



{=================================}
{== TRzTimePickerEditor Methods ==}
{=================================}

function TRzTimePickerEditor.TimePicker: TRzTimePicker;
begin
  Result := Component as TRzTimePicker;
end;


function TRzTimePickerEditor.GetVerbCount: Integer;
begin
  Result := 3;
end;


function TRzTimePickerEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Restrict Minutes (by 5)';
    1: Result := 'Show How to Use Hint';
    2: Result := 'AutoSize';
  end;
end;


procedure TRzTimePickerEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := TimePicker.RestrictMinutes;
    1: Item.Checked := TimePicker.ShowHowToUseHint;
    2: Item.Checked := TimePicker.AutoSize;
  end;
end;


procedure TRzTimePickerEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: TimePicker.RestrictMinutes := not TimePicker.RestrictMinutes;
    1: TimePicker.ShowHowToUseHint := not TimePicker.ShowHowToUseHint;
    2: TimePicker.AutoSize := not TimePicker.AutoSize;
  end;
  if Index in [ 0..2 ] then
    Designer.Modified;
end;


{==================================}
{== TRzColorPickerEditor Methods ==}
{==================================}

function TRzColorPickerEditor.ColorPicker: TRzColorPicker;
begin
  Result := Component as TRzColorPicker;
end;


function TRzColorPickerEditor.GetVerbCount: Integer;
begin
  Result := 11;
end;


function TRzColorPickerEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Show All Areas';
    1: Result := '-';
    2: Result := 'Show No Color Area';
    3: Result := 'Show Default Color';
    4: Result := 'Show Custom Color Area';
    5: Result := 'Show System Colors';
    6: Result := '-';
    7: Result := 'Show Color Hints';
    8: Result := 'AutoSize';
    9: Result := '-';
    10: Result := 'Set CustomColors';
  end;
end;


function TRzColorPickerEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    10: Result := 'RZDESIGNEDITORS_EDIT_COLORS';
  end;
end;


function TRzColorPickerEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                              var CompRefPropName: string;
                                              var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  if Index = 10 then
  begin
    CompRefClass := TRzCustomColors;
    CompRefPropName := 'CustomColors';
    CompRefMenuHandler := CustomColorsMenuHandler;
    Result := True;
  end
end;


procedure TRzColorPickerEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    2: Item.Checked := ColorPicker.ShowNoColor;
    3: Item.Checked := ColorPicker.ShowDefaultColor;
    4: Item.Checked := ColorPicker.ShowCustomColor;
    5: Item.Checked := ColorPicker.ShowSystemColors;
    7: Item.Checked := ColorPicker.ShowColorHints;
    8: Item.Checked := ColorPicker.AutoSize;
  end;
end;


procedure TRzColorPickerEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0:
    begin
      ColorPicker.ShowNoColor := True;
      ColorPicker.ShowDefaultColor := True;
      ColorPicker.ShowCustomColor := True;
      ColorPicker.ShowSystemColors := True;
    end;

    2: ColorPicker.ShowNoColor := not ColorPicker.ShowNoColor;
    3: ColorPicker.ShowDefaultColor := not ColorPicker.ShowDefaultColor;
    4: ColorPicker.ShowCustomColor := not ColorPicker.ShowCustomColor;
    5: ColorPicker.ShowSystemColors := not ColorPicker.ShowSystemColors;
    7: ColorPicker.ShowColorHints := not ColorPicker.ShowColorHints;
    8: ColorPicker.AutoSize := not ColorPicker.AutoSize;
  end;
  if Index in [ 0, 2..5, 7, 8 ] then
    Designer.Modified
end;


procedure TRzColorPickerEditor.CustomColorsMenuHandler( Sender: TObject );
var
  S: string;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ColorPicker.CustomColors := Designer.GetRoot.FindComponent( S ) as TRzCustomColors;
    Designer.Modified;
  end;
end;


{================================}
{== TRzColorEditEditor Methods ==}
{================================}

function TRzColorEditEditor.ColorEdit: TRzColorEdit;
begin
  Result := Component as TRzColorEdit;
end;


function TRzColorEditEditor.GetVerbCount: Integer;
begin
  Result := 7;
end;


function TRzColorEditEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Show No Color Area';
    1: Result := 'Show Default Color';
    2: Result := 'Show Custom Color Area';
    3: Result := 'Show System Colors';
    4: Result := 'Show Color Hints';
    5: Result := '-';
    6: Result := 'Set CustomColors';
  end;
end;


function TRzColorEditEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    6: Result := 'RZDESIGNEDITORS_EDIT_COLORS';
  end;
end;


function TRzColorEditEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                            var CompRefPropName: string;
                                            var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  if Index = 6 then
  begin
    CompRefClass := TRzCustomColors;
    CompRefPropName := 'CustomColors';
    CompRefMenuHandler := CustomColorsMenuHandler;
    Result := True;
  end
end;


procedure TRzColorEditEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := ColorEdit.ShowNoColor;
    1: Item.Checked := ColorEdit.ShowDefaultColor;
    2: Item.Checked := ColorEdit.ShowCustomColor;
    3: Item.Checked := ColorEdit.ShowSystemColors;
    4: Item.Checked := ColorEdit.ShowColorHints;
  end;
end;


procedure TRzColorEditEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: ColorEdit.ShowNoColor := not ColorEdit.ShowNoColor;
    1: ColorEdit.ShowDefaultColor := not ColorEdit.ShowDefaultColor;
    2: ColorEdit.ShowCustomColor := not ColorEdit.ShowCustomColor;
    3: ColorEdit.ShowSystemColors := not ColorEdit.ShowSystemColors;
    4: ColorEdit.ShowColorHints := not ColorEdit.ShowColorHints;
  end;
  if Index in [ 0..4 ] then
    Designer.Modified;
end;


procedure TRzColorEditEditor.CustomColorsMenuHandler( Sender: TObject );
var
  S: string;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ColorEdit.CustomColors := Designer.GetRoot.FindComponent( S ) as TRzCustomColors;
    Designer.Modified;
  end;
end;


{=================================}
{== TRzLEDDisplayEditor Methods ==}
{=================================}

function TRzLEDDisplayEditor.LEDDisplay: TRzLEDDisplay;
begin
  Result := Component as TRzLEDDisplay;
end;


function TRzLEDDisplayEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;


function TRzLEDDisplayEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Scroll Display';
    1: Result := '-';
    2: Result := 'Scroll Left';
    3: Result := 'Scroll Right';
  end;
end;


function TRzLEDDisplayEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    2: Result := 'RZDESIGNEDITORS_SCROLL_LEFT';
    3: Result := 'RZDESIGNEDITORS_SCROLL_RIGHT';
  end;
end;


procedure TRzLEDDisplayEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := LEDDisplay.Scrolling;
    2: Item.Checked := LEDDisplay.ScrollType = stRightToLeft;
    3: Item.Checked := LEDDisplay.ScrollType = stLeftToRight;
  end;
end;


procedure TRzLEDDisplayEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: LEDDisplay.Scrolling := not LEDDisplay.Scrolling;
    2: LEDDisplay.ScrollType := stRightToLeft;
    3: LEDDisplay.ScrollType := stLeftToRight;
  end;
  if Index in [ 0, 2, 3 ] then
    Designer.Modified;
end;



{=================================}
{== TRzStatusPaneEditor Methods ==}
{=================================}

function TRzStatusPaneEditor.GetVerbCount: Integer;
begin
  Result := 8;
end;


function TRzStatusPaneEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Flat Style';
    1: Result := 'Traditional Style';
    2: Result := '-';
    3: Result := 'AutoSize';
    4: Result := 'Alignment';
    5: Result := 'Blinking';
    6: Result := '-';
    7: Result := 'Align';
  end;
end;


function TRzStatusPaneEditor.FlatStyleMenuIndex: Integer;
begin
  Result := 0;
end;


function TRzStatusPaneEditor.TraditionalStyleMenuIndex: Integer;
begin
  Result := 1;
end;


function TRzStatusPaneEditor.AutoSizeMenuIndex: Integer;
begin
  Result := 3;
end;


function TRzStatusPaneEditor.AlignmentMenuIndex: Integer;
begin
  Result := 4;
end;


function TRzStatusPaneEditor.BlinkingMenuIndex: Integer;
begin
  Result := 5;
end;


function TRzStatusPaneEditor.AlignMenuIndex: Integer;
begin
  Result := 7;
end;


function TRzStatusPaneEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  if Index = FlatStyleMenuIndex then
    Result := 'RZDESIGNEDITORS_STATUS_FLAT'
  else if Index = TraditionalStyleMenuIndex then
    Result := 'RZDESIGNEDITORS_STATUS_TRADITIONAL';
end;


procedure TRzStatusPaneEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateAlignmentMenu( Alignment: TAlignment; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Alignment );
    NewItem.Checked := GetOrdProp( Component, 'Alignment' ) = Ord( Alignment );
    NewItem.OnClick := AlignmentMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  if Index = FlatStyleMenuIndex then
    Item.Checked := GetOrdProp( Component, 'FrameStyle' ) = Ord( fsFlat )
  else if Index = TraditionalStyleMenuIndex then
    Item.Checked := GetOrdProp( Component, 'FrameStyle' ) = Ord( fsStatus )
  else if Index = AutoSizeMenuIndex then
    Item.Checked := GetOrdProp( Component, 'AutoSize' ) = 1
  else if Index = AlignmentMenuIndex then
  begin
    CreateAlignmentMenu( taLeftJustify, 'Left Justify' );
    CreateAlignmentMenu( taRightJustify, 'Right Justify' );
    CreateAlignmentMenu( taCenter, 'Center' );
  end
  else if Index = BlinkingMenuIndex then
    Item.Checked := GetOrdProp( Component, 'Blinking' ) = 1;
end;


procedure TRzStatusPaneEditor.ExecuteVerb( Index: Integer );
var
  B: Boolean;
begin
  inherited;

  if Index = FlatStyleMenuIndex then
  begin
    SetOrdProp( Component, 'FrameStyle', Ord( fsFlat ) );
    Designer.Modified;
  end
  else if Index = TraditionalStyleMenuIndex then
  begin
    SetOrdProp( Component, 'FrameStyle', Ord( fsStatus ) );
    Designer.Modified;
  end
  else if Index = AutoSizeMenuIndex then
  begin
    B := GetOrdProp( Component, 'AutoSize' ) = 1;
    SetOrdProp( Component, 'AutoSize', Ord( not B ) );
    Designer.Modified;
  end
  else if Index = BlinkingMenuIndex then
  begin
    B := GetOrdProp( Component, 'Blinking' ) = 1;
    SetOrdProp( Component, 'Blinking', Ord( not B ) );
    Designer.Modified;
  end;
end;


procedure TRzStatusPaneEditor.AlignmentMenuHandler( Sender: TObject );
begin
  SetOrdProp( Component, 'Alignment', TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


{==================================}
{== TRzGlyphStatusEditor Methods ==}
{==================================}

function TRzGlyphStatusEditor.GlyphStatus: TRzGlyphStatus;
begin
  Result := Component as TRzGlyphStatus;
end;


function TRzGlyphStatusEditor.GetVerbCount: Integer;
begin
  Result := 15;
end;


function TRzGlyphStatusEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Select Image...';
    1: Result := 'Select Disabled Image...';
    2: Result := 'Set ImageList';
    3: Result := '-';
    4: Result := 'Show Glyph';
    5: Result := 'Glyph Alignment';
    6: Result := '-';
    7: Result := 'Flat Style';
    8: Result := 'Traditional Style';
    9: Result := '-';
    10: Result := 'AutoSize';
    11: Result := 'Alignment';
    12: Result := 'Blinking';
    13: Result := '-';
    14: Result := 'Align';
  end;
end;


function TRzGlyphStatusEditor.FlatStyleMenuIndex: Integer;
begin
  Result := 7;
end;


function TRzGlyphStatusEditor.TraditionalStyleMenuIndex: Integer;
begin
  Result := 8;
end;


function TRzGlyphStatusEditor.AutoSizeMenuIndex: Integer;
begin
  Result := 10;
end;


function TRzGlyphStatusEditor.AlignmentMenuIndex: Integer;
begin
  Result := 11;
end;


function TRzGlyphStatusEditor.BlinkingMenuIndex: Integer;
begin
  Result := 12;
end;


function TRzGlyphStatusEditor.AlignMenuIndex: Integer;
begin
  Result := 14;
end;


function TRzGlyphStatusEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  Result := inherited MenuBitmapResourceName( Index );

  case Index of
    0: Result := 'RZDESIGNEDITORS_SELECT_IMAGE';
    1: Result := 'RZDESIGNEDITORS_SELECT_DISABLED_IMAGE';
    2: Result := 'RZDESIGNEDITORS_IMAGELIST';
  end;
end;


function TRzGlyphStatusEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                              var CompRefPropName: string;
                                              var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  if Index = 2 then
  begin
    CompRefClass := TCustomImageList;
    CompRefPropName := 'Images';
    CompRefMenuHandler := nil;
    Result := True;
  end
end;


procedure TRzGlyphStatusEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateGlyphAlignmentMenu( GlyphAlignment: TGlyphAlignment; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( GlyphAlignment );
    NewItem.Checked := GlyphStatus.GlyphAlignment = GlyphAlignment;
    NewItem.OnClick := GlyphAlignmentMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    4: Item.Checked := GlyphStatus.ShowGlyph;
    5:
    begin
      CreateGlyphAlignmentMenu( gaLeft, 'Left' );
      CreateGlyphAlignmentMenu( gaRight, 'Right' );
    end;
  end;
end;


procedure TRzGlyphStatusEditor.ExecuteVerb( Index: Integer );
begin
  inherited;

  case Index of
    0: EditPropertyByName( 'ImageIndex' );
    1: EditPropertyByName( 'DisabledIndex' );
    4: GlyphStatus.ShowGlyph := not GlyphStatus.ShowGlyph;
  end;
  if Index in [ 0, 1, 4 ] then
    Designer.Modified;
end;


procedure TRzGlyphStatusEditor.GlyphAlignmentMenuHandler( Sender: TObject );
begin
  GlyphStatus.GlyphAlignment := TGlyphAlignment( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;



{====================================}
{== TRzMarqueeStatusEditor Methods ==}
{====================================}

function TRzMarqueeStatusEditor.MarqueeStatus: TRzMarqueeStatus;
begin
  Result := Component as TRzMarqueeStatus;
end;


function TRzMarqueeStatusEditor.GetVerbCount: Integer;
begin
  Result := 13;
end;


function TRzMarqueeStatusEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Scroll Caption';
    1: Result := '-';
    2: Result := 'Scroll Left';
    3: Result := 'Scroll Right';
    4: Result := '-';
    5: Result := 'Flat Style';
    6: Result := 'Traditional Style';
    7: Result := '-';
    8: Result := 'AutoSize';
    9: Result := 'Alignment';
    10: Result := 'Blinking';
    11: Result := '-';
    12: Result := 'Align';
  end;
end;


function TRzMarqueeStatusEditor.FlatStyleMenuIndex: Integer;
begin
  Result := 5;
end;


function TRzMarqueeStatusEditor.TraditionalStyleMenuIndex: Integer;
begin
  Result := 6;
end;


function TRzMarqueeStatusEditor.AutoSizeMenuIndex: Integer;
begin
  Result := 8;
end;


function TRzMarqueeStatusEditor.AlignmentMenuIndex: Integer;
begin
  Result := 9;
end;


function TRzMarqueeStatusEditor.BlinkingMenuIndex: Integer;
begin
  Result := 10;
end;


function TRzMarqueeStatusEditor.AlignMenuIndex: Integer;
begin
  Result := 12;
end;


function TRzMarqueeStatusEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  Result := inherited MenuBitmapResourceName( Index );

  case Index of
    2: Result := 'RZDESIGNEDITORS_SCROLL_LEFT';
    3: Result := 'RZDESIGNEDITORS_SCROLL_RIGHT';
  end;
end;


procedure TRzMarqueeStatusEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := MarqueeStatus.ScrollType = RzCommon.stNone;
    2: Item.Checked := MarqueeStatus.ScrollType = RzCommon.stRightToLeft;
    3: Item.Checked := MarqueeStatus.ScrollType = RzCommon.stLeftToRight;
  end;
end;


procedure TRzMarqueeStatusEditor.ExecuteVerb( Index: Integer );
begin
  inherited;

  case Index of
    0: MarqueeStatus.ScrollType := RzCommon.stNone;
    2: MarqueeStatus.ScrollType := RzCommon.stRightToLeft;
    3: MarqueeStatus.ScrollType := RzCommon.stLeftToRight;
  end;
  if Index in [ 0, 2, 3 ] then
    Designer.Modified;
end;


{==================================}
{== TRzClockStatusEditor Methods ==}
{==================================}

function TRzClockStatusEditor.ClockStatus: TRzClockStatus;
begin
  Result := Component as TRzClockStatus;
end;


function TRzClockStatusEditor.GetVerbCount: Integer;
begin
  Result := 10;
end;


function TRzClockStatusEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Format';
    1: Result := '-';
    2: Result := 'Flat Style';
    3: Result := 'Traditional Style';
    4: Result := '-';
    5: Result := 'AutoSize';
    6: Result := 'Alignment';
    7: Result := 'Blinking';
    8: Result := '-';
    9: Result := 'Align';
  end;
end;


function TRzClockStatusEditor.FlatStyleMenuIndex: Integer;
begin
  Result := 2;
end;


function TRzClockStatusEditor.TraditionalStyleMenuIndex: Integer;
begin
  Result := 3;
end;


function TRzClockStatusEditor.AutoSizeMenuIndex: Integer;
begin
  Result := 5;
end;


function TRzClockStatusEditor.AlignmentMenuIndex: Integer;
begin
  Result := 6;
end;


function TRzClockStatusEditor.BlinkingMenuIndex: Integer;
begin
  Result := 7;
end;


function TRzClockStatusEditor.AlignMenuIndex: Integer;
begin
  Result := 9;
end;


procedure TRzClockStatusEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateFormatMenu( const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.AutoHotkeys := maManual;
    NewItem.Caption := Caption;
    NewItem.Checked := ClockStatus.Format = Caption;
    NewItem.OnClick := ClockMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0: // Format
    begin
      Item.AutoHotKeys := maManual;
      CreateFormatMenu( 'c' );
      CreateFormatMenu( 't' );
      CreateFormatMenu( 'tt' );
      CreateFormatMenu( 'ddddd' );
      CreateFormatMenu( 'dddddd' );
      CreateFormatMenu( 'ddddd t' );
      CreateFormatMenu( 'ddddd tt' );
      CreateFormatMenu( 'dddddd tt' );
      CreateFormatMenu( 'm/d/yy' );
      CreateFormatMenu( 'mm/dd/yy' );
      CreateFormatMenu( 'd/m/yy');
      CreateFormatMenu( 'dd/mm/yy');
      CreateFormatMenu( 'dd/mm/yyyy');
      CreateFormatMenu( 'h:n:s' );
      CreateFormatMenu( 'h:n:s a/p' );
      CreateFormatMenu( 'h:nn:ss' );
      CreateFormatMenu( 'h:nn:ss am/pm');
      CreateFormatMenu( 'hh:nn:ss' );
      CreateFormatMenu( 'hh:nn:ss am/pm' );
    end;
  end;
end;


procedure TRzClockStatusEditor.ClockMenuHandler( Sender: TObject );
begin
  ClockStatus.Format := TMenuItem( Sender ).Caption;
  Designer.Modified;
end;



{================================}
{== TRzKeyStatusEditor Methods ==}
{================================}

function TRzKeyStatusEditor.KeyStatus: TRzKeyStatus;
begin
  Result := Component as TRzKeyStatus;
end;


function TRzKeyStatusEditor.GetVerbCount: Integer;
begin
  Result := 13;
end;


function TRzKeyStatusEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Caps Lock';
    1: Result := 'Num Lock';
    2: Result := 'Scroll Lock';
    3: Result := 'Insert';
    4: Result := '-';
    5: Result := 'Flat Style';
    6: Result := 'Traditional Style';
    7: Result := '-';
    8: Result := 'AutoSize';
    9: Result := 'Alignment';
    10: Result := 'Blinking';
    11: Result := '-';
    12: Result := 'Align';
  end;
end;


function TRzKeyStatusEditor.FlatStyleMenuIndex: Integer;
begin
  Result := 5;
end;


function TRzKeyStatusEditor.TraditionalStyleMenuIndex: Integer;
begin
  Result := 6;
end;


function TRzKeyStatusEditor.AutoSizeMenuIndex: Integer;
begin
  Result := 8;
end;


function TRzKeyStatusEditor.AlignmentMenuIndex: Integer;
begin
  Result := 9;
end;


function TRzKeyStatusEditor.BlinkingMenuIndex: Integer;
begin
  Result := 10;
end;


function TRzKeyStatusEditor.AlignMenuIndex: Integer;
begin
  Result := 12;
end;


procedure TRzKeyStatusEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := KeyStatus.Key = tkCapsLock;
    1: Item.Checked := KeyStatus.Key = tkNumLock;
    2: Item.Checked := KeyStatus.Key = tkScrollLock;
    3: Item.Checked := KeyStatus.Key = tkInsert;
  end;
end;


procedure TRzKeyStatusEditor.ExecuteVerb( Index: Integer );
begin
  inherited;

  case Index of
    0: KeyStatus.Key := tkCapsLock;
    1: KeyStatus.Key := tkNumLock;
    2: KeyStatus.Key := tkScrollLock;
    3: KeyStatus.Key := tkInsert;
  end;
  if Index in [ 0, 1, 2, 3 ] then
    Designer.Modified;
end;


{========================================}
{== TRzVersionInfoStatusEditor Methods ==}
{========================================}

function TRzVersionInfoStatusEditor.VersionInfoStatus: TRzVersionInfoStatus;
begin
  Result := Component as TRzVersionInfoStatus;
end;


function TRzVersionInfoStatusEditor.GetVerbCount: Integer;
begin
  Result := 11;
end;


function TRzVersionInfoStatusEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Set VersionInfo';
    1: Result := 'Select Field';
    2: Result := '-';
    3: Result := 'Flat Style';
    4: Result := 'Traditional Style';
    5: Result := '-';
    6: Result := 'AutoSize';
    7: Result := 'Alignment';
    8: Result := 'Blinking';
    9: Result := '-';
    10: Result := 'Align';
  end;
end;


function TRzVersionInfoStatusEditor.FlatStyleMenuIndex: Integer;
begin
  Result := 3;
end;


function TRzVersionInfoStatusEditor.TraditionalStyleMenuIndex: Integer;
begin
  Result := 4;
end;


function TRzVersionInfoStatusEditor.AutoSizeMenuIndex: Integer;
begin
  Result := 6;
end;


function TRzVersionInfoStatusEditor.AlignmentMenuIndex: Integer;
begin
  Result := 7;
end;


function TRzVersionInfoStatusEditor.BlinkingMenuIndex: Integer;
begin
  Result := 8;
end;


function TRzVersionInfoStatusEditor.AlignMenuIndex: Integer;
begin
  Result := 10;
end;


function TRzVersionInfoStatusEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                                    var CompRefPropName: string;
                                                    var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  if Index = 0 then
  begin
    CompRefClass := TRzVersionInfo;
    CompRefPropName := 'VersionInfo';
    CompRefMenuHandler := VersionInfoMenuHandler;
    Result := True;
  end
end;


procedure TRzVersionInfoStatusEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateFieldMenu( Field: TRzVersionInfoField; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Field );
    NewItem.Checked := VersionInfoStatus.Field = Field;
    NewItem.OnClick := FieldMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  if Index = 1 then
  begin
    CreateFieldMenu( vifCompanyName, 'CompanyName' );
    CreateFieldMenu( vifFileDescription, 'FileDescription' );
    CreateFieldMenu( vifFileVersion, 'FileVersion' );
    CreateFieldMenu( vifInternalName, 'InternalName' );
    CreateFieldMenu( vifCopyright, 'Copyright' );
    CreateFieldMenu( vifTrademarks, 'Trademarks' );
    CreateFieldMenu( vifOriginalFilename, 'OriginalFilename' );
    CreateFieldMenu( vifProductName, 'ProductName' );
    CreateFieldMenu( vifProductVersion, 'ProductVersion' );
    CreateFieldMenu( vifComments, 'Comments' );
  end;
end;


procedure TRzVersionInfoStatusEditor.VersionInfoMenuHandler( Sender: TObject );
var
  S: string;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    VersionInfoStatus.VersionInfo := Designer.GetRoot.FindComponent( S ) as TRzVersionInfo;
    Designer.Modified;
  end;
end;


procedure TRzVersionInfoStatusEditor.FieldMenuHandler( Sender: TObject );
begin
  VersionInfoStatus.Field := TRzVersionInfoField( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


{=====================================}
{== TRzResourceStatusEditor Methods ==}
{=====================================}

function TRzResourceStatusEditor.ResourceStatus: TRzResourceStatus;
begin
  Result := Component as TRzResourceStatus;
end;


function TRzResourceStatusEditor.GetVerbCount: Integer;
begin
  Result := 12;
end;


function TRzResourceStatusEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Traditional Bar Style';
    1: Result := 'LED Bar Style';
    2: Result := '-';
    3: Result := 'Show Percent';
    4: Result := '-';
    5: Result := 'Flat Style';
    6: Result := 'Traditional Style';
    7: Result := '-';
    8: Result := 'Alignment';
    9: Result := 'Blinking';
    10: Result := '-';
    11: Result := 'Align';
  end;
end;


function TRzResourceStatusEditor.FlatStyleMenuIndex: Integer;
begin
  Result := 5;
end;


function TRzResourceStatusEditor.TraditionalStyleMenuIndex: Integer;
begin
  Result := 6;
end;


function TRzResourceStatusEditor.AutoSizeMenuIndex: Integer;
begin
  Result := -1;
end;


function TRzResourceStatusEditor.AlignmentMenuIndex: Integer;
begin
  Result := 8;
end;


function TRzResourceStatusEditor.BlinkingMenuIndex: Integer;
begin
  Result := 9;
end;


function TRzResourceStatusEditor.AlignMenuIndex: Integer;
begin
  Result := 11;
end;


function TRzResourceStatusEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  Result := inherited MenuBitmapResourceName( Index );

  case Index of
    0: Result := 'RZDESIGNEDITORS_PROGRESS_TRADITIONAL';
    1: Result := 'RZDESIGNEDITORS_PROGRESS_LED';
  end;
end;


procedure TRzResourceStatusEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := ResourceStatus.BarStyle = bsTraditional;
    1: Item.Checked := ResourceStatus.BarStyle = bsLED;
    3: Item.Checked := ResourceStatus.ShowPercent;
  end;
end;


procedure TRzResourceStatusEditor.ExecuteVerb( Index: Integer );
begin
  inherited;

  case Index of
    0: ResourceStatus.BarStyle := bsTraditional;
    1: ResourceStatus.BarStyle := bsLED;
    3: ResourceStatus.ShowPercent := not ResourceStatus.ShowPercent;
  end;
  if Index in [ 0, 1, 3 ] then
    Designer.Modified;
end;


{===========================}
{== TRzLineEditor Methods ==}
{===========================}

function TRzLineEditor.Line: TRzLine;
begin
  Result := Component as TRzLine;
end;


function TRzLineEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;


function TRzLineEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Slope Down';
    1: Result := 'Slope Up';
    2: Result := '-';
    3: Result := 'Show Arrows';
  end;
end;


procedure TRzLineEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateShowArrowsMenu( ShowArrows: TRzShowArrows; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( ShowArrows );
    NewItem.Checked := Line.ShowArrows = ShowArrows;
    NewItem.OnClick := ShowArrowsMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0: Item.Checked := Line.LineSlope = lsDown;
    1: Item.Checked := Line.LineSlope = lsUp;

    3:
    begin
      CreateShowArrowsMenu( saNone, 'No Arrows' );
      CreateShowArrowsMenu( saStart, 'Arrow at Start' );
      CreateShowArrowsMenu( saEnd, 'Arrow at End' );
      CreateShowArrowsMenu( saBoth, 'Arrows at Both Ends' );
    end;
  end;
end;


procedure TRzLineEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: Line.LineSlope := lsDown;
    1: Line.LineSlope := lsUp;
  end;
  Designer.Modified;
end;


procedure TRzLineEditor.ShowArrowsMenuHandler( Sender: TObject );
begin
  Line.ShowArrows := TRzShowArrows( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;



{===================================}
{== TRzCustomColorsEditor Methods ==}
{===================================}

function TRzCustomColorsEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;


function TRzCustomColorsEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Edit Custom Colors';
    1: Result := 'Set RegIniFile';
  end;
end;


function TRzCustomColorsEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT_COLORS';
    1: Result := 'RZDESIGNEDITORS_REGINIFILE';
  end;
end;


function TRzCustomColorsEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                               var CompRefPropName: string;
                                               var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  if Index = 1 then
  begin
    CompRefClass := TRzRegIniFile;
    CompRefPropName := 'RegIniFile';
    CompRefMenuHandler := nil;
    Result := True;
  end
end;


procedure TRzCustomColorsEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'Colors' );
  end;
end;


{==================================}
{== TRzShapeButtonEditor Methods ==}
{==================================}

function TRzShapeButtonEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


function TRzShapeButtonEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Select Bitmap...';
  end;
end;


function TRzShapeButtonEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_SELECT_IMAGE';
  end;
end;


procedure TRzShapeButtonEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'Bitmap' );
  end;
end;


{================================}
{== TRzFormStateEditor Methods ==}
{================================}

function TRzFormStateEditor.FormState: TRzFormState;
begin
  Result := Component as TRzFormState;
end;


function TRzFormStateEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;


function TRzFormStateEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Set RegIniFile';
  end;
end;


function TRzFormStateEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_REGINIFILE';
  end;
end;


function TRzFormStateEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                                  var CompRefPropName: string;
                                                  var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  if Index = 0 then
  begin
    CompRefClass := TRzRegIniFile;
    CompRefPropName := 'RegIniFile';
    CompRefMenuHandler := nil;
    Result := True;
  end
end;


{================================}
{== TRzFormShapeEditor Methods ==}
{================================}

function TRzFormShapeEditor.FormShape: TRzFormShape;
begin
  Result := Component as TRzFormShape;
end;


function TRzFormShapeEditor.GetVerbCount: Integer;
begin
  Result := 9;
end;


function TRzFormShapeEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Edit Picture...';
    1: Result := '-';
    2: Result := 'AllowFormDraw';
    3: Result := 'Transparent';
    4: Result := 'Proportional';
    5: Result := 'Stretch';
    6: Result := 'Center';
    7: Result := '-';
    8: Result := 'Align';
  end;
end;


function TRzFormShapeEditor.AlignMenuIndex: Integer;
begin
  Result := 8;
end;


function TRzFormShapeEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_SELECT_IMAGE';
  end;
end;


procedure TRzFormShapeEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    2: Item.Checked := FormShape.AllowFormDrag;
    3: Item.Checked := FormShape.Transparent;
    4:
    begin
      {$IFDEF VCL60_OR_HIGHER}
      Item.Checked := FormShape.Proportional;
      {$ELSE}
      Item.Enabled := False;
      {$ENDIF}
    end;
    5: Item.Checked := FormShape.Stretch;
    6: Item.Checked := FormShape.Center;
  end;
end;


procedure TRzFormShapeEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'Picture' );
    2: FormShape.AllowFormDrag := not FormShape.AllowFormDrag;
    3: FormShape.Transparent := not FormShape.Transparent;
    {$IFDEF VCL60_OR_HIGHER}
    4: FormShape.Proportional := not FormShape.Proportional;
    {$ENDIF}
    5: FormShape.Stretch := not FormShape.Stretch;
    6: FormShape.Center := not FormShape.Center;
  end;
  if Index in [ 2..6 ] then
    Designer.Modified;
end;


{=============================}
{== TRzBorderEditor Methods ==}
{=============================}

function TRzBorderEditor.Border: TRzBorder;
begin
  Result := Component as TRzBorder;
end;


function TRzBorderEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;


function TRzBorderEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Align';
    1: Result := 'Remove Border';
  end;
end;


function TRzBorderEditor.AlignMenuIndex: Integer;
begin
  Result := 0;
end;


procedure TRzBorderEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    1:
    begin
      Border.BorderOuter := fsNone;
      Border.BorderInner := fsNone;
      Border.BorderWidth := 0;
      Designer.Modified;
    end;
  end;
end;


{===============================}
{== TRzTrayIconEditor Methods ==}
{===============================}

function TRzTrayIconEditor.TrayIcon: TRzTrayIcon;
begin
  Result := Component as TRzTrayIcon;
end;


function TRzTrayIconEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;


function TRzTrayIconEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Select Icon...';
    1: Result := 'Set Icons (ImageList)';
    2: Result := '-';
    3: Result := 'Set PopupMenu';
  end;
end;


function TRzTrayIconEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_SELECT_IMAGE';
    1: Result := 'RZDESIGNEDITORS_IMAGELIST';
  end;
end;


function TRzTrayIconEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                           var CompRefPropName: string;
                                           var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  if Index = 1 then
  begin
    CompRefClass := TCustomImageList;
    CompRefPropName := 'Icons';
    CompRefMenuHandler := IconsMenuHandler;
    Result := True;
  end
  else if Index = 3 then
  begin
    CompRefClass := TPopupMenu;
    CompRefPropName := 'PopupMenu';
    CompRefMenuHandler := PopupMenuMenuHandler;
    Result := True;
  end;
end;


procedure TRzTrayIconEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'IconIndex' );
  end;
end;


procedure TRzTrayIconEditor.IconsMenuHandler( Sender: TObject );
var
  S: string;
  ImageList: TCustomImageList;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ImageList := Designer.GetRoot.FindComponent( S ) as TCustomImageList;
    SetObjectProp( Component, 'Icons', ImageList );
    Designer.Modified;
  end;
end;


procedure TRzTrayIconEditor.PopupMenuMenuHandler( Sender: TObject );
var
  S: string;
  PM: TPopupMenu;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    PM := Designer.GetRoot.FindComponent( S ) as TPopupMenu;
    SetObjectProp( Component, 'PopupMenu', PM );
    Designer.Modified;
  end;
end;


{===============================}
{== TRzAnimatorEditor Methods ==}
{===============================}

function TRzAnimatorEditor.Animator: TRzAnimator;
begin
  Result := Component as TRzAnimator;
end;


function TRzAnimatorEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;


function TRzAnimatorEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Select Image...';
    1: Result := 'Set ImageList';
    2: Result := '-';
    3: Result := 'Animate';
  end;
end;


function TRzAnimatorEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_SELECT_IMAGE';
    1: Result := 'RZDESIGNEDITORS_IMAGELIST';
  end;
end;


function TRzAnimatorEditor.GetCompRefData( Index: Integer; var CompRefClass: TComponentClass;
                                           var CompRefPropName: string;
                                           var CompRefMenuHandler: TNotifyEvent ): Boolean;
begin
  Result := False;
  case Index of
    1:
    begin
      CompRefClass := TCustomImageList;
      CompRefPropName := 'ImageList';
      CompRefMenuHandler := ImageListMenuHandler;
      Result := True;
    end;
  end;
end;


procedure TRzAnimatorEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    3: Item.Checked := Animator.Animate;
  end;
end;


procedure TRzAnimatorEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: EditPropertyByName( 'ImageIndex' );

    3:
    begin
      Animator.Animate := not Animator.Animate;
      Designer.Modified;
    end;
  end;
end;


procedure TRzAnimatorEditor.ImageListMenuHandler( Sender: TObject );
var
  S: string;
  ImageList: TCustomImageList;
begin
  if Designer.GetRoot <> nil then
  begin
    S := TMenuItem( Sender ).Caption;
    ImageList := Designer.GetRoot.FindComponent( S ) as TCustomImageList;
    SetObjectProp( Component, 'ImageList', ImageList );
    Designer.Modified;
  end;
end;



{================================}
{== TRzSeparatorEditor Methods ==}
{================================}

function TRzSeparatorEditor.Separator: TRzSeparator;
begin
  Result := Component as TRzSeparator;
end;


function TRzSeparatorEditor.GetVerbCount: Integer;
begin
  Result := 6;
end;


function TRzSeparatorEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Horizontal';
    1: Result := 'Vertical';
    2: Result := '-';
    3: Result := 'Highlight Location';
    4: Result := '-';
    5: Result := 'Align';
  end;
end;


function TRzSeparatorEditor.AlignMenuIndex: Integer;
begin
  Result := 5;
end;


function TRzSeparatorEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_SEPARATOR_HORIZONTAL';
    1: Result := 'RZDESIGNEDITORS_SEPARATOR_VERTICAL';
  end;
end;


procedure TRzSeparatorEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateHighlightLocationMenu( Location: TRzHighlightLocation; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Location );
    NewItem.Checked := Separator.HighlightLocation = Location;
    NewItem.OnClick := HighlightLocationMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0: Item.Checked := Separator.Orientation = orHorizontal;
    1: Item.Checked := Separator.Orientation = orVertical;

    3:
    begin
      CreateHighlightLocationMenu( hlCenter, 'Center' );
      CreateHighlightLocationMenu( hlUpperLeft, 'Upper-Left' );
      CreateHighlightLocationMenu( hlLowerRight, 'Lower-Right' );
    end;
  end;
end;


procedure TRzSeparatorEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: Separator.Orientation := orHorizontal;
    1: Separator.Orientation := orVertical;
  end;
  if Index in [ 0, 1 ] then
    Designer.Modified;
end;


procedure TRzSeparatorEditor.HighlightLocationMenuHandler( Sender: TObject );
begin
  Separator.HighlightLocation := TRzHighlightLocation( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;


{=============================}
{== TRzSpacerEditor Methods ==}
{=============================}

function TRzSpacerEditor.Spacer: TRzSpacer;
begin
  Result := Component as TRzSpacer;
end;


function TRzSpacerEditor.GetVerbCount: Integer;
begin
  Result := 4;
end;


function TRzSpacerEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Grooved';
    1: Result := '-';
    2: Result := 'Horizontal';
    3: Result := 'Vertical';
  end;
end;


procedure TRzSpacerEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    0: Item.Checked := Spacer.Grooved;
    2: Item.Checked := Spacer.Orientation = orHorizontal;
    3: Item.Checked := Spacer.Orientation = orVertical;
  end;
end;


procedure TRzSpacerEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: Spacer.Grooved := not Spacer.Grooved;
    2: Spacer.Orientation := orHorizontal;
    3: Spacer.Orientation := orVertical;
  end;
  if Index in [ 0, 2, 3 ] then
    Designer.Modified;
end;




{===================================}
{== TRzBalloonHintsEditor Methods ==}
{===================================}

function TRzBalloonHintsEditor.BalloonHints: TRzBalloonHints;
begin
  Result := Component as TRzBalloonHints;
end;


function TRzBalloonHintsEditor.GetVerbCount: Integer;
begin
  Result := 5;
end;


function TRzBalloonHintsEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Balloon Style';
    1: Result := 'Traditional Style';
    2: Result := '-';
    3: Result := 'Shadow';
    4: Result := 'Corner';
  end;
end;


function TRzBalloonHintsEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_BALLOONHINTS';
    1: Result := 'RZDESIGNEDITORS_BALLOONHINTS_NOPOINT';
    3: Result := 'RZDESIGNEDITORS_BALLOONHINTS_SHADOW';
    4: // Corner
    begin
      case BalloonHints.Corner of
        hcLowerRight: Result := 'RZDESIGNEDITORS_BALLOONHINTS_LOWERRIGHT';
        hcLowerLeft:  Result := 'RZDESIGNEDITORS_BALLOONHINTS_LOWERLEFT';
        hcUpperLeft:  Result := 'RZDESIGNEDITORS_BALLOONHINTS_UPPERLEFT';
        hcUpperRight: Result := 'RZDESIGNEDITORS_BALLOONHINTS_UPPERRIGHT';
      end;
    end;
  end;
end;


procedure TRzBalloonHintsEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );

  procedure CreateCornerMenu( Corner: TRzHintCorner; const Caption: string );
  var
    NewItem: TMenuItem;
  begin
    NewItem := TMenuItem.Create( Item );
    NewItem.Caption := Caption;
    NewItem.Tag := Ord( Corner );
    NewItem.Checked := BalloonHints.Corner = Corner;
    case Corner of
      hcLowerRight: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_BALLOONHINTS_LOWERRIGHT' );
      hcLowerLeft:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_BALLOONHINTS_LOWERLEFT' );
      hcUpperLeft:  NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_BALLOONHINTS_UPPERLEFT' );
      hcUpperRight: NewItem.Bitmap.LoadFromResourceName( HInstance, 'RZDESIGNEDITORS_BALLOONHINTS_UPPERRIGHT' );
    end;
    NewItem.OnClick := CornerMenuHandler;
    Item.Add( NewItem );
  end;

begin
  inherited;

  case Index of
    0: Item.Checked := BalloonHints.ShowBalloon;
    1: Item.Checked := not BalloonHints.ShowBalloon;
    3: Item.Checked := BalloonHints.Shadow;

    4:
    begin
      CreateCornerMenu( hcLowerRight, 'Lower-Right' );
      CreateCornerMenu( hcLowerLeft, 'Lower-Left' );
      CreateCornerMenu( hcUpperLeft, 'Upper-Left' );
      CreateCornerMenu( hcUpperRight, 'Upper-Right' );
    end;
  end;
end;


procedure TRzBalloonHintsEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    0: BalloonHints.ShowBalloon := True;
    1: BalloonHints.ShowBalloon := False;
    3: BalloonHints.Shadow := not BalloonHints.Shadow;
  end;
  if Index in [ 0, 1, 3 ] then
    Designer.Modified;
end;


procedure TRzBalloonHintsEditor.CornerMenuHandler( Sender: TObject );
begin
  BalloonHints.Corner := TRzHintCorner( TMenuItem( Sender ).Tag );
  Designer.Modified;
end;



{=================================}
{== TRzStringGridEditor Methods ==}
{=================================}

function TRzStringGridEditor.Grid: TRzStringGrid;
begin
  Result := Component as TRzStringGrid;
end;


function TRzStringGridEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;


function TRzStringGridEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Align';
    1: Result := 'XP Colors';
  end;
end;


function TRzStringGridEditor.AlignMenuIndex: Integer;
begin
  Result := 0;
end;


function TRzStringGridEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    1: Result := 'RZDESIGNEDITORS_XPCOLORS';
  end;
end;


procedure TRzStringGridEditor.ExecuteVerb( Index: Integer );
begin
  case Index of
    1: // XP Colors
    begin
      Grid.FixedColor := clInactiveCaptionText;
      Grid.LineColor := clInactiveCaption;
      Grid.FixedLineColor := $00B99D7F;
      Grid.FrameColor := $00B99D7F;
      Grid.FrameVisible := True;
      Designer.Modified;
    end;
  end;
end;



{== Property Editors ==================================================================================================}

{===================================}
{== TRzFrameStyleProperty Methods ==}
{===================================}

procedure TRzFrameStyleProperty.ListMeasureHeight( const Value: string; ACanvas: TCanvas; var AHeight: Integer );
begin
  AHeight := Max( ACanvas.TextHeight( 'Yy' ), 28 );
end;

procedure TRzFrameStyleProperty.ListMeasureWidth( const Value: string; ACanvas: TCanvas; var AWidth: Integer );
begin
  AWidth := AWidth + 28;
end;


{$IFDEF VCL60_OR_HIGHER}
procedure TRzFrameStyleProperty.PropDrawName( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
begin
  DefaultPropertyDrawName( Self, ACanvas, ARect );
end;
{$ENDIF}


procedure TRzFrameStyleProperty.PropDrawValue( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
begin
  if GetVisualValue <> '' then
  begin
    FDrawingPropertyValue := True;
    try
      ListDrawValue( GetVisualValue, ACanvas, ARect, ASelected );
    finally
      FDrawingPropertyValue := False;
    end;
  end
  else
    {$IFDEF VCL60_OR_HIGHER}
    DefaultPropertyDrawValue( Self, ACanvas, ARect );
    {$ELSE}
    inherited PropDrawValue( ACanvas, ARect, ASelected );
    {$ENDIF}
end;


procedure TRzFrameStyleProperty.ListDrawValue( const Value: string; ACanvas: TCanvas; const ARect: TRect;
                                               ASelected: Boolean );
var
  R: TRect;
  TextStart: Integer;
  OldBrushColor: TColor;
  FrameStyleEx: TFrameStyleEx;
begin
  R := ARect;
  R.Right := R.Left + ( R.Bottom - R.Top );
  TextStart := R.Right;
  with ACanvas do
  begin
    try
      OldBrushColor := Brush.Color;
      Brush.Color := clBtnFace;
      FillRect( R );

      if FDrawingPropertyValue then
        InflateRect( R, -1, -1 )
      else
        InflateRect( R, -2, -2 );

      FrameStyleEx := TFrameStyleEx( GetEnumValue( GetPropInfo^.PropType^, Value ) );
      if FrameStyleEx <> fsFlatRounded then
        DrawBorder( ACanvas, R, TFrameStyle( FrameStyleEx ) )
      else
        DrawRoundedFlatBorder( ACanvas, R, clBtnShadow, sdAllSides );


      // Restore Canvas Settings
      Brush.Color := OldBrushColor;
    finally
      {$IFDEF VCL60_OR_HIGHER}
      DefaultPropertyListDrawValue( Value, ACanvas, Rect( TextStart, ARect.Top, ARect.Right, ARect.Bottom ), ASelected );
      {$ELSE}
      inherited ListDrawValue( Value, ACanvas, Rect( TextStart, ARect.Top, ARect.Right, ARect.Bottom ), ASelected );
      {$ENDIF}
    end;
  end;
end;


{==============================}
{== TRzAlignProperty Methods ==}
{==============================}

procedure TRzAlignProperty.ListMeasureHeight( const Value: string; ACanvas: TCanvas; var AHeight: Integer );
begin
  AHeight := Max( ACanvas.TextHeight( 'Yy' ), 24 );
end;


procedure TRzAlignProperty.ListMeasureWidth( const Value: string; ACanvas: TCanvas; var AWidth: Integer );
begin
  AWidth := AWidth + 24;
end;


{$IFDEF VCL60_OR_HIGHER}
procedure TRzAlignProperty.PropDrawName( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
begin
  DefaultPropertyDrawName( Self, ACanvas, ARect );
end;
{$ENDIF}


procedure TRzAlignProperty.PropDrawValue( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
begin
  if GetVisualValue <> '' then
  begin
    FDrawingPropertyValue := True;
    try
      ListDrawValue( GetVisualValue, ACanvas, ARect, ASelected );
    finally
      FDrawingPropertyValue := False;
    end;
  end
  else
  begin
    {$IFDEF VCL60_OR_HIGHER}
    DefaultPropertyDrawValue( Self, ACanvas, ARect );
    {$ELSE}
    inherited PropDrawValue( ACanvas, ARect, ASelected );
    {$ENDIF}
  end;
end;


procedure TRzAlignProperty.ListDrawValue( const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
var
  R: TRect;
  TextStart: Integer;
  Align: TAlign;
  Bmp, AlignBmp: TBitmap;
  TransparentColor: TColor;
  DestRct, SrcRct: TRect;
  BmpOffset: Integer;
begin
  R := ARect;
  R.Right := R.Left + ( R.Bottom - R.Top );
  TextStart := R.Right;
  with ACanvas do
  begin
    Bmp := TBitmap.Create;
    AlignBmp := TBitmap.Create;
    try
      FillRect( R );

      Bmp.Canvas.Brush.Color := ACanvas.Brush.Color;
      TransparentColor := clAqua;

      Align := TAlign( GetEnumValue( GetPropInfo^.PropType^, Value ) );

      if FDrawingPropertyValue then
      begin
        DestRct := Classes.Rect( 0, 0, 11, 11 );
        SrcRct := DestRct;
        BmpOffset := ( ( R.Bottom - R.Top ) - 11 ) div 2;

        { Don't Forget to Set the Width and Height of Destination Bitmap }
        Bmp.Width := 11;
        Bmp.Height := 11;

        case Align of
          alNone:    AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGNPROP_NONE' );
          alTop:     AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGNPROP_TOP' );
          alBottom:  AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGNPROP_BOTTOM' );
          alLeft:    AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGNPROP_LEFT' );
          alRight:   AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGNPROP_RIGHT' );
          alClient:  AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGNPROP_CLIENT' );
          {$IFDEF VCL60_OR_HIGHER}
          alCustom:  AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGNPROP_CUSTOM' );
          {$ENDIF}
        end;
      end
      else
      begin
        DestRct := Classes.Rect( 0, 0, 16, 16 );
        SrcRct := DestRct;
        BmpOffset := ( ( R.Bottom - R.Top ) - 16 ) div 2;

        { Don't Forget to Set the Width and Height of Destination Bitmap }
        Bmp.Width := 16;
        Bmp.Height := 16;

        case Align of
          alNone:    AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGN_NONE' );
          alTop:     AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGN_TOP' );
          alBottom:  AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGN_BOTTOM' );
          alLeft:    AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGN_LEFT' );
          alRight:   AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGN_RIGHT' );
          alClient:  AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGN_CLIENT' );
          {$IFDEF VCL60_OR_HIGHER}
          alCustom:  AlignBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_ALIGN' );
          {$ENDIF}
        end;
      end;

      Bmp.Canvas.BrushCopy( DestRct, AlignBmp, SrcRct, TransparentColor );
      Draw( R.Left + 2, R.Top + BmpOffset, Bmp );
    finally
      Bmp.Free;
      AlignBmp.Free;

      {$IFDEF VCL60_OR_HIGHER}
      DefaultPropertyListDrawValue( Value, ACanvas, Rect( TextStart, ARect.Top, ARect.Right, ARect.Bottom ), ASelected );
      {$ELSE}
      inherited ListDrawValue( Value, ACanvas, Rect( TextStart, ARect.Top, ARect.Right, ARect.Bottom ), ASelected );
      {$ENDIF}
    end;
  end;
end;


{================================}
{== TRzBooleanProperty Methods ==}
{================================}

procedure TRzBooleanProperty.ListMeasureHeight( const Value: string; ACanvas: TCanvas; var AHeight: Integer );
begin
  AHeight := Max( AHeight, 15 );
end;

procedure TRzBooleanProperty.ListMeasureWidth( const Value: string; ACanvas: TCanvas; var AWidth: Integer );
begin
  AWidth := AWidth + 15;
end;


{$IFDEF VCL60_OR_HIGHER}
procedure TRzBooleanProperty.PropDrawName( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
begin
  DefaultPropertyDrawName( Self, ACanvas, ARect );
end;
{$ENDIF}


procedure TRzBooleanProperty.PropDrawValue( ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
begin
  if GetVisualValue <> '' then
    ListDrawValue( GetVisualValue, ACanvas, ARect, ASelected )
  else
  begin
    {$IFDEF VCL60_OR_HIGHER}
    DefaultPropertyDrawValue( Self, ACanvas, ARect );
    {$ELSE}
    inherited PropDrawValue( ACanvas, ARect, ASelected );
    {$ENDIF}
  end;
end;


procedure TRzBooleanProperty.ListDrawValue( const Value: string; ACanvas: TCanvas; const ARect: TRect; ASelected: Boolean );
var
  R: TRect;
  TextStart: Integer;
  BoolValue: Boolean;
  Bmp, CheckBoxBmp: TBitmap;
  TransparentColor: TColor;
  DestRct, SrcRct: TRect;
  BmpOffset: Integer;
begin
  R := ARect;
  R.Right := R.Left + ( R.Bottom - R.Top );
  TextStart := R.Right;
  with ACanvas do
  begin
    Bmp := TBitmap.Create;
    CheckBoxBmp := TBitmap.Create;
    try
      FillRect( R );

      DestRct := Classes.Rect( 0, 0, 11, 11 );
      SrcRct := DestRct;
      BmpOffset := ( ( R.Bottom - R.Top ) - 11 ) div 2;

      { Don't Forget to Set the Width and Height of Destination Bitmap }
      Bmp.Width := 11;
      Bmp.Height := 11;

      Bmp.Canvas.Brush.Color := ACanvas.Brush.Color;

      TransparentColor := clOlive;

      BoolValue := Boolean( GetEnumValue( GetPropInfo^.PropType^, Value ) );
      case BoolValue of
        False:
          CheckBoxBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_BOOLEAN_FALSE' );

        True:
          CheckBoxBmp.Handle := LoadBitmap( HInstance, 'RZDESIGNEDITORS_BOOLEAN_TRUE' );
      end;
      Bmp.Canvas.BrushCopy( DestRct, CheckBoxBmp, SrcRct, TransparentColor );
      Draw( R.Left + 2, R.Top + BmpOffset, Bmp );
    finally
      Bmp.Free;
      CheckBoxBmp.Free;

      {$IFDEF VCL60_OR_HIGHER}
      DefaultPropertyListDrawValue( Value, ACanvas, Rect( TextStart, ARect.Top, ARect.Right, ARect.Bottom ), ASelected );
      {$ELSE}
      inherited ListDrawValue( Value, ACanvas, Rect( TextStart, ARect.Top, ARect.Right, ARect.Bottom ), ASelected );
      {$ENDIF}
    end;
  end;
end;



{=====================================}
{== TRzComboBoxTextProperty Methods ==}
{=====================================}

function TRzComboBoxTextProperty.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [ paValueList ];
end;


procedure TRzComboBoxTextProperty.GetValues( Proc: TGetStrProc );
var
  I: Integer;
  C: TRzComboBox;
begin
  C := GetComponent( 0 ) as TRzComboBox;
  for I := 0 to C.Items.Count - 1 do
    Proc( C.Items[ I ] );
end;


procedure TRzComboBoxTextProperty.SetValue( const Value: string );
var
  C: TRzComboBox;
  Idx: Integer;
begin
  C := GetComponent( 0 ) as TRzComboBox;
  if C.Style <> csDropDown then
  begin
    Idx := C.Items.IndexOf( Value );
    if Idx <> -1 then
      C.ItemIndex := Idx;
  end;
  inherited;
end;



{===================================}
{== TRzActivePageProperty Methods ==}
{===================================}

function TRzActivePageProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paValueList ];
end;


procedure TRzActivePageProperty.GetValues( Proc: TGetStrProc );
var
  I: Integer;
  APageControl: TRzPageControl;
begin
  APageControl := TRzPageControl( GetComponent( 0 ) );
  for I := 0 to APageControl.PageCount - 1 do
  begin
    if APageControl.Pages[ I ].Name <> '' then
      Proc( APageControl.Pages[ I ].Name );
  end;
end;



{=======================================}
{== TRzDateTimeFormatProperty Methods ==}
{=======================================}

function TRzDateTimeFormatProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paValueList, paMultiSelect, paAutoUpdate ];
end;


function TRzDateTimeFormatProperty.FormatFilter: TRzDateTimeFormatFilter;
var
  C: TPersistent;
begin
  Result := ffAll;
  C := GetComponent( 0 );
  if C is TRzTimePicker then
    Result := ffTimes
  else if C is TRzDateTimeEdit then
  begin
    if TRzDateTimeEdit( C ).EditType = etTime then
      Result := ffTimes
    else
      Result := ffDates;
  end;
end;


procedure TRzDateTimeFormatProperty.GetValues( Proc: TGetStrProc );
var
  F: TRzDateTimeFormatFilter;
begin
  F := FormatFilter;

  if F = ffAll then
  begin
    Proc( 'c' );
    Proc( 'ddddd t' );
    Proc( 'ddddd tt' );
    Proc( 'dddddd tt' );
  end;

  if ( F = ffDates ) or ( F = ffAll ) then
  begin
    Proc( 'ddddd' );
    Proc( 'dddddd' );
    Proc( 'm/d/yyyy' );
    Proc( 'mm/dd/yyyy' );
    Proc( 'd/m/yyyy');
    Proc( 'dd/mm/yyyy');
  end;

  if ( F = ffTimes ) or ( F = ffAll ) then
  begin
    Proc( 't' );
    Proc( 'tt' );
    Proc( 'h:nn am/pm' );
    Proc( 'hh:nn am/pm' );
    Proc( 'h:nn:ss am/pm');
    Proc( 'hh:nn:ss am/pm' );
    Proc( 'h:nn' );
    Proc( 'hh:nn' );
    Proc( 'h:nn:ss' );
    Proc( 'hh:nn:ss' );
  end;
end;



{==========================================}
{== TRzClockStatusFormatProperty Methods ==}
{==========================================}

function TRzClockStatusFormatProperty.FormatFilter: TRzDateTimeFormatFilter;
begin
  Result := ffAll;
end;




{==================================}
{== TRzDTPFormatProperty Methods ==}
{==================================}

function TRzDTPFormatProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paValueList, paMultiSelect, paAutoUpdate ];
end;


procedure TRzDTPFormatProperty.GetValues( Proc: TGetStrProc );
begin
  Proc( 'M/dd/yyyy' );
  Proc( 'MM/dd/yyyy' );
  Proc( 'MMM dd, yyyy' );
  Proc( 'd/MM/yyyy');
  Proc( 'dd/MM/yyyy' );
  Proc( 'd MMM yyyy');
  Proc( 'h:mm tt' );
  Proc( 'h:mm:ss tt' );
  Proc( 'H:mm' );
  Proc( 'HH:mm:ss' );
end;



{==================================}
{== TRzSpinValueProperty Methods ==}
{==================================}

function TRzSpinValueProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ ];
end;


procedure TRzSpinValueProperty.SetValue( const Value: string );
var
  P: Integer;
  D, SaveDecimals: Byte;
  N: Single;
begin
  SaveDecimals := TRzSpinEdit( GetComponent( 0 ) ).Decimals;
  P := Pos( '.', Value );
  if P = 0 then
    D := 0
  else
    D := Length( Value ) - P;
  TRzSpinEdit( GetComponent( 0 ) ).Decimals := D;

  try
    N := StrToFloat( Value );
  except
    on EConvertError do
    begin
      TRzSpinEdit( GetComponent( 0 ) ).Decimals := SaveDecimals;
      raise;
    end;
  end;

  SetFloatValue( N );
end;



{=====================================}
{== TRzSpinnerGlyphProperty Methods ==}
{=====================================}

function TRzSpinnerGlyphProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paReadOnly ];
end;


function TRzSpinnerGlyphProperty.GetValue: string;
begin
  Result := 'Deprecated--Do Not Use.';
end;

{=================================}
{== TRzFileNameProperty Methods ==}
{=================================}

procedure TRzFileNameProperty.Edit;
var
  DlgOpen: TOpenDialog;
begin
  DlgOpen := TOpenDialog.Create( Application );
  DlgOpen.FileName := GetValue;
  DlgOpen.Filter := 'Executables|*.EXE;*.BAT;*.COM;*.PIF|All Files|*.*';
  DlgOpen.Options := DlgOpen.Options + [ofPathMustExist, ofFileMustExist];
  try
    if DlgOpen.Execute then
      SetValue( DlgOpen.FileName );
  finally
    DlgOpen.Free;
  end;
end;


function TRzFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paDialog, paRevertable ];
end;


{===============================}
{== TRzActionProperty Methods ==}
{===============================}

function TRzActionProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paValueList, paMultiSelect ];
end;


procedure TRzActionProperty.GetValues( Proc: TGetStrProc );
begin
  Proc( 'Open' );
  Proc( 'Print' );
  Proc( 'Explore' );
end;



{=====================================}
{== TRzCustomColorsProperty Methods ==}
{=====================================}

procedure TRzCustomColorsProperty.Edit;
var
  DlgColor: TColorDialog;
begin
  DlgColor := TColorDialog.Create( Application );
  try
    DlgColor.CustomColors := TStrings( GetOrdValue );
    DlgColor.Options := [ cdFullOpen ];
    if DlgColor.Execute then
      SetOrdValue( Longint( DlgColor.CustomColors ) );
  finally
    DlgColor.Free;
  end;
end;


function TRzCustomColorsProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [ paDialog ];
end;



{== Category Classes ==================================================================================================}


{$IFDEF VER13x}

{======================================}
{== TRzCustomFramingCategory Methods ==}
{======================================}

class function TRzCustomFramingCategory.Name: string;
begin
  Result := 'Custom Framing';
end;

class function TRzCustomFramingCategory.Description: string;
begin
  Result := 'Custom Framing Category';
end;


{================================}
{== TRzHotSpotCategory Methods ==}
{================================}

class function TRzHotSpotCategory.Name: string;
begin
  Result := 'HotSpot';
end;

class function TRzHotSpotCategory.Description: string;
begin
  Result := 'HotSpot Category';
end;


{====================================}
{== TRzBorderStyleCategory Methods ==}
{====================================}

class function TRzBorderStyleCategory.Name: string;
begin
  Result := 'Border Style';
end;

class function TRzBorderStyleCategory.Description: string;
begin
  Result := 'Border Style Category';
end;


{=====================================}
{== TRzCustomGlyphsCategory Methods ==}
{=====================================}

class function TRzCustomGlyphsCategory.Name: string;
begin
  Result := 'Custom Glyphs';
end;

class function TRzCustomGlyphsCategory.Description: string;
begin
  Result := 'Custom Glyphs Category';
end;


{==================================}
{== TRzTextStyleCategory Methods ==}
{==================================}

class function TRzTextStyleCategory.Name: string;
begin
  Result := 'Text Style';
end;

class function TRzTextStyleCategory.Description: string;
begin
  Result := 'Text Style Category';
end;


{===================================}
{== TRzTrackStyleCategory Methods ==}
{===================================}

class function TRzTrackStyleCategory.Name: string;
begin
  Result := 'Track Style';
end;

class function TRzTrackStyleCategory.Description: string;
begin
  Result := 'Track Style Category';
end;


{======================================}
{== TRzPrimaryButtonCategory Methods ==}
{======================================}

class function TRzPrimaryButtonCategory.Name: string;
begin
  Result := 'Button - Primary';
end;

class function TRzPrimaryButtonCategory.Description: string;
begin
  Result := 'Primary Button Category';
end;


{========================================}
{== TRzAlternateButtonCategory Methods ==}
{========================================}

class function TRzAlternateButtonCategory.Name: string;
begin
  Result := 'Button - Alternate';
end;

class function TRzAlternateButtonCategory.Description: string;
begin
  Result := 'Alternate Button Category';
end;


{=================================}
{== TRzSplitterCategory Methods ==}
{=================================}

class function TRzSplitterCategory.Name: string;
begin
  Result := 'Splitter Style';
end;

class function TRzSplitterCategory.Description: string;
begin
  Result := 'Splitter Style Category';
end;

{$ENDIF}


{===========================}
{== TRzPaletteSep Methods ==}
{===========================}

constructor TRzPaletteSep.Create( AOwner: TComponent );
begin
  raise Exception.Create( 'Palette Separator - Only for use on Component Palette' );
end;




end.
