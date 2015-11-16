{===============================================================================
  RzDBNavEditor Unit

  Raize Components - Design Editor Source Unit


  Design Editors                      Description
  ------------------------------------------------------------------------------
  TRzDBNavigatorImageIndexProperty    Property editor for
                                        TRzDBNavigatorImageIndexes properties.


  Modification History
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * Initial release.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}

unit RzDBNavEditor;

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  {$IFDEF VCL60_OR_HIGHER}
  DesignIntf,
  DesignMenus,
  DesignEditors,
  VCLEditors,
  {$ELSE}
  DsgnIntf,
  {$ENDIF}
  RzSelectImageEditor,
  ImgList;

type

  {========================================================}
  {== TRzDBNavigatorImageIndexProperty Class Declaration ==}
  {========================================================}

  TRzDBNavigatorImageIndexProperty = class( TRzCustomImageIndexProperty )
  protected
    function GetImageList: TCustomImageList; override;
  end;


implementation

uses
  RzDBNav;

{==============================================}
{== TRzDBNavigatorImageIndexProperty Methods ==}
{==============================================}

function TRzDBNavigatorImageIndexProperty.GetImageList: TCustomImageList;
begin
  Result := ( GetComponent( 0 ) as TRzDBNavigatorImageIndexes ).Navigator.Images;
end;

end.

