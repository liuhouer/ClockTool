{===============================================================================
  RzSplitterEditor Unit

  Raize Components - Design Editor Source Unit


  Design Editors        Description
  ------------------------------------------------------------------------------
  TRzSplitterEditor     Adds context menu and editing dialog.


  Modification History
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Updated form to use custom framing editing controls and HotTrack style
      buttons, radio buttons, and check boxes. Also uses the TRzTabControl
      component.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzSplitterEditor;

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
  Buttons,
  Menus,
  {$IFDEF VCL60_OR_HIGHER}
  DesignIntf,
  DesignEditors,
  DesignMenus,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  RzTrkBar,
  RzDesignEditors,
  RzButton,
  RzRadChk,
  RzPanel,
  RzSplit,
  RzCmboBx,
  RzLabel,
  RzRadGrp,
  RzTabs;

type
  TRzSplitterEditor = class( TRzComponentEditor )
  protected
    function Splitter: TRzSplitter;
    function AlignMenuIndex: Integer; override;
    function MenuBitmapResourceName( Index: Integer ): string; override;
    procedure PrepareMenuItem( Index: Integer; const Item: TMenuItem ); override;
  public
    function GetVerbCount: Integer; override;
    function GetVerb( Index: Integer ): string; override;
    procedure ExecuteVerb( Index: Integer ); override;
  end;


  TRzSplitterEditDlg = class(TForm)
    BtnOK: TRzButton;
    BtnCancel: TRzButton;
    GrpPreview: TRzGroupBox;
    SplPreview: TRzSplitter;
    GrpOrientation: TRzRadioGroup;
    ChkRealTime: TRzCheckBox;
    PbxUpperLeft: TPaintBox;
    ChkUsePercent: TRzCheckBox;
    GrpFixedPane: TRzRadioGroup;
    ChkShowHotSpot: TRzCheckBox;
    TbcRegions: TRzTabControl;
    ChkVisible: TRzCheckBox;
    GrpBorder: TRzGroupBox;
    LblOuter: TRzLabel;
    LblInner: TRzLabel;
    CbxOuter: TRzComboBox;
    CbxInner: TRzComboBox;
    CbxBarStyle: TRzComboBox;
    GrpWidth: TRzGroupBox;
    TrkWidth: TRzTrackBar;
    PbxLowerRight: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure FrameStyleChange(Sender: TObject);
    procedure GrpOrientationClick(Sender: TObject);
    procedure TrkWidthChange(Sender: TObject);
    procedure ChkRealTimeClick(Sender: TObject);
    procedure PbxUpperLeftPaint(Sender: TObject);
    procedure PbxLowerRightPaint(Sender: TObject);
    procedure PbxUpperLeftClick(Sender: TObject);
    procedure PbxLowerRightClick(Sender: TObject);
    procedure ChkVisibleClick(Sender: TObject);
    procedure TrkWidthDrawTick(TrackBar: TRzTrackBar; Canvas: TCanvas;
      Location: TPoint; Index: Integer);
    procedure CbxBarStyleChange(Sender: TObject);
    procedure ChkUsePercentClick(Sender: TObject);
    procedure GrpFixedPaneClick(Sender: TObject);
    procedure ChkShowHotSpotClick(Sender: TObject);
    procedure TbcRegionsChanging(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
  private
    FRegion: Integer;
    procedure SetRegionSettings;
  public
    procedure UpdateControls;
  end;


implementation

{$R *.DFM}

uses
  RzCommon;

const
  rgSplitter    = 0;
  rgSplitterBar = 1;
  rgULPane      = 2;
  rgLRPane      = 3;

{===============================}
{== TRzSplitterEditor Methods ==}
{===============================}

function TRzSplitterEditor.Splitter: TRzSplitter;
begin
  Result := Component as TRzSplitter;
end;


function TRzSplitterEditor.GetVerbCount: Integer;
begin
  Result := 10;
end;


function TRzSplitterEditor.GetVerb( Index: Integer ): string;
begin
  case Index of
    0: Result := 'Edit Splitter...';
    1: Result := 'Align';

    2:
    begin
      if Splitter.Orientation = orVertical then
        Result := 'Horizontal'
      else
        Result := 'Vertical';
    end;

    3: Result := '-';

    4: Result := 'Show HotSpot';
    5: Result := 'Use Percent Positioning';
    6: Result := 'Real-Time Dragging';

    7: Result := '-';

    8:
    begin
      if Splitter.Orientation = orVertical then
        Result := 'Select Upper Pane'
      else
        Result := 'Select Left Pane';
    end;

    9:
    begin
      if Splitter.Orientation = orVertical then
        Result := 'Select Lower Pane'
      else
        Result := 'Select Right Pane';
    end;

  end; { case }
end;


function TRzSplitterEditor.AlignMenuIndex: Integer;
begin
  Result := 1;
end;


function TRzSplitterEditor.MenuBitmapResourceName( Index: Integer ): string;
begin
  case Index of
    0: Result := 'RZDESIGNEDITORS_EDIT';

    2:
    begin
      if Splitter.Orientation = orVertical then
        Result := 'RZDESIGNEDITORS_SPLIT_HORIZONTAL'
      else
        Result := 'RZDESIGNEDITORS_SPLIT_VERTICAL';
    end;


    4:
    begin
      if Splitter.Orientation = orVertical then
        Result := 'RZDESIGNEDITORS_SPLIT_HOTSPOT_VERTICAL'
      else
        Result := 'RZDESIGNEDITORS_SPLIT_HOTSPOT_HORIZONTAL';
    end;

    8:
    begin
      if Splitter.Orientation = orVertical then
        Result := 'RZDESIGNEDITORS_SELECT_TOP'
      else
        Result := 'RZDESIGNEDITORS_SELECT_LEFT';
    end;

    9:
    begin
      if Splitter.Orientation = orVertical then
        Result := 'RZDESIGNEDITORS_SELECT_BOTTOM'
      else
        Result := 'RZDESIGNEDITORS_SELECT_RIGHT';
    end;
  end; { case }
end; {= TRzSplitterEditor.MenuBitmapResourceName =}


procedure TRzSplitterEditor.PrepareMenuItem( Index: Integer; const Item: TMenuItem );
begin
  inherited;

  case Index of
    4:
    begin
      if Splitter.HotSpotVisible then
        Item.Checked := True;
    end;

    5:
    begin
      if Splitter.UsePercent then
        Item.Checked := True;
    end;

    6:
    begin
      if Splitter.RealTimeDrag then
        Item.Checked := True;
    end;
  end;
end;


procedure TRzSplitterEditor.ExecuteVerb( Index: Integer );
var
  Dialog: TRzSplitterEditDlg;
  OldPos: Integer;
  OwnerName: string;

  procedure CopySplitter( Dest, Source: TRzSplitter );
  begin
    Dest.UpperLeft.Pane.BorderOuter := Source.UpperLeft.Pane.BorderOuter;
    Dest.UpperLeft.Pane.BorderInner := Source.UpperLeft.Pane.BorderInner;
    Dest.UpperLeft.Pane.BorderWidth := Source.UpperLeft.Pane.BorderWidth;
    Dest.UpperLeft.Pane.Visible:= Source.UpperLeft.Pane.Visible;

    Dest.LowerRight.Pane.BorderOuter := Source.LowerRight.Pane.BorderOuter;
    Dest.LowerRight.Pane.BorderInner := Source.LowerRight.Pane.BorderInner;
    Dest.LowerRight.Pane.BorderWidth := Source.LowerRight.Pane.BorderWidth;
    Dest.LowerRight.Pane.Visible := Source.LowerRight.Pane.Visible;

    Dest.BorderOuter := Source.BorderOuter;
    Dest.BorderInner := Source.BorderInner;
    Dest.BorderWidth := Source.BorderWidth;
    Dest.RealTimeDrag := Source.RealTimeDrag;
    Dest.UsePercent := Source.UsePercent;
    Dest.SplitterStyle := Source.SplitterStyle;
    Dest.SplitterWidth := Source.SplitterWidth;
    Dest.Orientation := Source.Orientation;
    Dest.FixedPane := Source.FixedPane;
    Dest.HotSpotVisible := Source.HotSpotVisible;
  end;

begin
  case Index of
    0:                                                      { Edit Splitter... }
    begin
      Dialog := TRzSplitterEditDlg.Create( Application );

      try
        { Copy Attributes to Dialog Box SplPreview Component }
        CopySplitter( Dialog.SplPreview, Splitter );

        if Component.Owner <> nil then
          OwnerName := Component.Owner.Name + '.'
        else
          OwnerName := '';

        Dialog.Caption := OwnerName + Component.Name + Dialog.Caption;
        Dialog.UpdateControls;             { Update all controls on dialog box }

        if Dialog.ShowModal = mrOK then                   { Display Dialog Box }
        begin
          OldPos := Splitter.Position;
          Splitter.Position := 0;
          CopySplitter( Splitter, Dialog.SplPreview );
          Splitter.Position := OldPos;
          Designer.Modified;
        end;
      finally
        Dialog.Free;                         { Don't forget to free dialog box }
      end;
    end;

    2:
    begin
      if Splitter.Orientation = orVertical then
        Splitter.Orientation := orHorizontal
      else
        Splitter.Orientation := orVertical;
      Designer.Modified;
    end;


    4:
    begin
      Splitter.HotSpotVisible := not Splitter.HotSpotVisible;
      Designer.Modified;
    end;

    5:
    begin
      Splitter.UsePercent := not Splitter.UsePercent;
      Designer.Modified;
    end;

    6:
    begin
      Splitter.RealTimeDrag := not Splitter.RealTimeDrag;
      Designer.Modified;
    end;


    8:
    begin
      Splitter.SelectedPane := spUpperLeft;
      Designer.Modified;
    end;

    9:
    begin
      Splitter.SelectedPane := spLowerRight;
      Designer.Modified;
    end;
  end; { case }
end; {= TRzSplitterEditor.ExecuteVerb =}




{================================}
{== TRzSplitterEditDlg Methods ==}
{================================}

{===============================================================================
  NOTE:  All changes made through the control on this dialog box affect only
         the preview splitter (SplPreview).  Only if the OK button is pressed
         are the changes reflected in the selected component.
===============================================================================}

procedure TRzSplitterEditDlg.FormCreate(Sender: TObject);
begin
  FRegion := rgSplitter;
end;


procedure TRzSplitterEditDlg.UpdateControls;
begin
  ChkRealTime.Checked := SplPreview.RealTimeDrag;
  ChkUsePercent.Checked := SplPreview.UsePercent;
  ChkShowHotSpot.Checked := SplPreview.HotSpotVisible;
  GrpOrientation.ItemIndex := Ord( SplPreview.Orientation );
  GrpFixedPane.ItemIndex := Ord( SplPreview.FixedPane );
  SetRegionSettings;
end;


procedure TRzSplitterEditDlg.SetRegionSettings;
begin
  case FRegion of
    rgSplitter:
    begin
      CbxInner.ItemIndex := Integer( SplPreview.BorderInner );
      CbxOuter.ItemIndex := Integer( SplPreview.BorderOuter );
      TrkWidth.Position := SplPreview.BorderWidth;
    end;

    rgSplitterBar:
    begin
      CbxInner.ItemIndex := -1;
      CbxOuter.ItemIndex := -1;
      CbxBarStyle.ItemIndex := Integer( SplPreview.SplitterStyle );
      TrkWidth.Position := SplPreview.SplitterWidth;
    end;

    rgULPane:
    begin
      CbxInner.ItemIndex := Integer( SplPreview.UpperLeft.Pane.BorderInner );
      CbxOuter.ItemIndex := Integer( SplPreview.UpperLeft.Pane.BorderOuter );
      TrkWidth.Position := SplPreview.UpperLeft.Pane.BorderWidth;
      ChkVisible.Checked := SplPreview.UpperLeft.Pane.Visible;
    end;

    rgLRPane:
    begin
      CbxInner.ItemIndex := Integer( SplPreview.LowerRight.Pane.BorderInner );
      CbxOuter.ItemIndex := Integer( SplPreview.LowerRight.Pane.BorderOuter );
      TrkWidth.Position := SplPreview.LowerRight.Pane.BorderWidth;
      ChkVisible.Checked := SplPreview.LowerRight.Pane.Visible;
    end;
  end;


  if FRegion = rgSplitterBar then
  begin
    LblOuter.Caption := 'Style';
    GrpWidth.Caption := 'Splitter Width';
    GrpBorder.Caption := 'Splitter Style';
  end
  else
  begin
    LblOuter.Caption := 'Outer';
    GrpWidth.Caption := 'Border Width';
    GrpBorder.Caption := 'Border Style';
  end;

  ChkVisible.Visible := ( FRegion = rgULPane ) or ( FRegion = rgLRPane );
  LblInner.Visible := FRegion <> rgSplitterBar;
  CbxInner.Visible := FRegion <> rgSplitterBar;
  CbxOuter.Visible := FRegion <> rgSplitterBar;
  CbxBarStyle.Visible := FRegion = rgSplitterBar;
end;


procedure TRzSplitterEditDlg.FrameStyleChange(Sender: TObject);
begin
  case FRegion of
    rgSplitter:
    begin
      if TComboBox( Sender ).Tag = 1 then
        SplPreview.BorderInner := TFrameStyleEx( CbxInner.ItemIndex )
      else
        SplPreview.BorderOuter := TFrameStyleEx( CbxOuter.ItemIndex );
    end;

    rgULPane:
    begin
      if TComboBox( Sender ).Tag = 1 then
        SplPreview.UpperLeft.Pane.BorderInner := TFrameStyleEx( CbxInner.ItemIndex )
      else
        SplPreview.UpperLeft.Pane.BorderOuter := TFrameStyleEx( CbxOuter.ItemIndex );
    end;

    rgLRPane:
    begin
      if TComboBox( Sender ).Tag = 1 then
        SplPreview.LowerRight.Pane.BorderInner := TFrameStyleEx( CbxInner.ItemIndex )
      else
        SplPreview.LowerRight.Pane.BorderOuter := TFrameStyleEx( CbxOuter.ItemIndex );
    end;
  end;
end;


procedure TRzSplitterEditDlg.GrpOrientationClick(Sender: TObject);
var
  OldIdx: Integer;
begin
  SplPreview.Orientation := TOrientation( GrpOrientation.ItemIndex );
  OldIdx := GrpFixedPane.ItemIndex;
  if GrpOrientation.ItemIndex = 0 then
  begin
    TbcRegions.Tabs[ 2 ].Caption := 'Left Pane';
    TbcRegions.Tabs[ 3 ].Caption := 'Right Pane';
    GrpFixedPane.Items.Clear;
    GrpFixedPane.Items.Add( 'Left' );
    GrpFixedPane.Items.Add( 'Right' );
  end
  else
  begin
    TbcRegions.Tabs[ 2 ].Caption := 'Upper Pane';
    TbcRegions.Tabs[ 3 ].Caption := 'Lower Pane';
    GrpFixedPane.Items.Clear;
    GrpFixedPane.Items.Add( 'Upper' );
    GrpFixedPane.Items.Add( 'Lower' );
  end;
  GrpFixedPane.ItemIndex := OldIdx;
end;

procedure TRzSplitterEditDlg.GrpFixedPaneClick(Sender: TObject);
begin
  SplPreview.FixedPane := TFixedPane( GrpFixedPane.ItemIndex );
end;


procedure TRzSplitterEditDlg.TrkWidthChange(Sender: TObject);
begin
  case FRegion of
    rgSplitter:
      SplPreview.BorderWidth := TrkWidth.Position;

    rgSplitterBar:
      SplPreview.SplitterWidth := TrkWidth.Position;

    rgULPane:
      SplPreview.UpperLeft.Pane.BorderWidth := TrkWidth.Position;

    rgLRPane:
      SplPreview.LowerRight.Pane.BorderWidth := TrkWidth.Position;
  end; { case }
end;

procedure TRzSplitterEditDlg.ChkShowHotSpotClick(Sender: TObject);
begin
  SplPreview.HotSpotVisible := ChkShowHotSpot.Checked;
end;


procedure TRzSplitterEditDlg.ChkRealTimeClick(Sender: TObject);
begin
  SplPreview.RealTimeDrag := ChkRealTime.Checked;
end;


procedure TRzSplitterEditDlg.ChkUsePercentClick(Sender: TObject);
begin
  SplPreview.UsePercent := ChkUsePercent.Checked;
end;


procedure TRzSplitterEditDlg.PbxUpperLeftClick(Sender: TObject);
begin
  SplPreview.UpperLeft.Pane.SetFocus;
  TbcRegions.TabIndex := 2;
end;


procedure TRzSplitterEditDlg.PbxUpperLeftPaint(Sender: TObject);
var
  OldPenStyle: TPenStyle;
  OldBrushStyle: TBrushStyle;
begin
  if ( SplPreview.UpperLeft.Pane.BorderOuter = fsNone ) and
     ( SplPreview.UpperLeft.Pane.BorderInner = fsNone ) then
  begin
    with PbxUpperLeft, PbxUpperLeft.Canvas do
    begin
      OldPenStyle := Pen.Style;
      OldBrushStyle := Brush.Style;
      Pen.Style := psClear;
      Brush.Color := clGray;
      Brush.Style := bsFDiagonal;
      Rectangle( 0, 0, Width, Height );

      if SplPreview.UpperLeft.Pane.Focused then
      begin
        Pen.Style := psDot;
        Brush.Style := bsClear;
        Rectangle( 0, 0, Width, Height );
      end;
      Brush.Style := OldBrushStyle;
      Pen.Style := OldPenStyle;
    end;
  end;
end;


procedure TRzSplitterEditDlg.PbxLowerRightClick(Sender: TObject);
begin
  SplPreview.LowerRight.Pane.SetFocus;
  TbcRegions.TabIndex := 3;
end;


procedure TRzSplitterEditDlg.PbxLowerRightPaint(Sender: TObject);
var
  OldPenStyle: TPenStyle;
  OldBrushStyle: TBrushStyle;
begin
  if ( SplPreview.LowerRight.Pane.BorderOuter = fsNone ) and
     ( SplPreview.LowerRight.Pane.BorderInner = fsNone ) then
  begin
    with PbxLowerRight, PbxLowerRight.Canvas do
    begin
      OldPenStyle := Pen.Style;
      OldBrushStyle := Brush.Style;
      Pen.Style := psClear;
      Brush.Color := clGray;
      Brush.Style := bsFDiagonal;
      Rectangle( 0, 0, Width, Height );

      if SplPreview.LowerRight.Pane.Focused then
      begin
        Pen.Style := psDot;
        Brush.Style := bsClear;
        Rectangle( 0, 0, Width, Height );
      end;
      Brush.Style := OldBrushStyle;
      Pen.Style := OldPenStyle;
    end;
  end;
end;


procedure TRzSplitterEditDlg.ChkVisibleClick(Sender: TObject);
begin
  if FRegion = rgULPane then
    SplPreview.UpperLeft.Pane.Visible := ChkVisible.Checked
  else
    SplPreview.LowerRight.Pane.Visible := ChkVisible.Checked
end;


procedure TRzSplitterEditDlg.TbcRegionsChanging( Sender: TObject; NewIndex: Integer; var AllowChange: Boolean );
begin
  FRegion := NewIndex;
  SplPreview.Invalidate;
  SetRegionSettings;

  if NewIndex = 1 then
    GrpBorder.Height := MulDiv( 57, Screen.PixelsPerInch, 96 )
  else
    GrpBorder.Height := MulDiv( 77, Screen.PixelsPerInch, 96 );
end;



procedure TRzSplitterEditDlg.TrkWidthDrawTick(TrackBar: TRzTrackBar;
  Canvas: TCanvas; Location: TPoint; Index: Integer);
var
  W: Integer;
  S: string;
begin
  if Index mod 5 = 0 then
  begin
    Canvas.Brush.Color := Color;
    Canvas.Font.Name := 'Small Fonts';
    Canvas.Font.Size := 7;
    Canvas.Font.Style := [];
    S := IntToStr( Index );
    W := Canvas.TextWidth( S );
    Canvas.TextOut( Location.X - (W div 2), 1, S );
  end;
end;


procedure TRzSplitterEditDlg.CbxBarStyleChange(Sender: TObject);
begin
  SplPreview.SplitterStyle := TSplitterStyle( CbxBarStyle.ItemIndex );
end;


end.
