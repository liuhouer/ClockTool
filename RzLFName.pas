{===============================================================================
  RzLFName Unit

  Raize Components - Component Source Unit

  This unit implements several procedures and functions related to long file
  names.


  Modification History
  ------------------------------------------------------------------------------
  3.0    (20 Dec 2002)
    * No changes.


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
===============================================================================}

{$I RzComps.inc}
{$RANGECHECKS OFF}

unit RzLFName;

{$IFDEF VCL60_OR_HIGHER}
{$WARN UNIT_PLATFORM OFF}
{$ENDIF}

interface

uses
  {$IFDEF USE_CS}
  CSIntf,
  {$ENDIF}
  SysUtils;

function LongFNameFromShort( const ShortName: string ): string;
function LongPathFromShort( const ShortPath: string ): string;
function ShortFNameFromLong( const LongName: string ): string;
function ShortPathFromLong( const LongPath: string ): string;
function LongPathExists( const Name: string ): Boolean;
procedure ForceLongPath( Dir: string );

implementation


uses
  Windows,
  FileCtrl;

{=====================================}
{== Exported Functions & Procedures ==}
{=====================================}

function LongFNameFromShort( const ShortName: string ): string;
var
  FindData: TWin32FindData;
  ShortNameStz: array[ 0..255 ] of Char;
  H: THandle;
begin
  if ( Length( ShortName ) <= 3 ) and
     ( ShortName[ 2 ] = ':' ) then
  begin
    Result := ShortName;
    Exit;
  end;

  FillChar( FindData, SizeOf( FindData ), #0 );
  StrPCopy( ShortNameStz, ShortName );
  H := FindFirstFile( ShortNameStz, FindData );

  if H = Invalid_Handle_Value then
    Result := ShortName
  else
  begin
    Result := StrPas( FindData.cFileName );
    FindClose( H );
  end;
end;


function LongPathFromShort( const ShortPath: string ): string;
var
  P: string;
  Done: Boolean;
begin
  P := ExpandFileName( ShortPath );
  if Length( P ) <= 3 then
  begin
    Result := P;
    Exit;
  end;

  if P[ Length( P ) ] = '\' then
    Delete( P, Length( P ), 1 );
  Result := '';
  Done := False;
  while ( P <> '' ) and not Done do
  begin
    Result := '\' + LongFNameFromShort( P ) + Result;
    P := ExtractFilePath( P );
    Delete( P, Length( P ), 1 );
    if Length( P ) <= 3 then
    begin
      Result := P + Result;
      Done := True;
    end;
  end;
end;


function ShortFNameFromLong( const LongName: string ): string;
var
  FindData: TWin32FindData;
  LongNameStz: array[ 0..255 ] of Char;
  H: THandle;
begin
  if ( Length( LongName ) <= 3 ) and
     ( LongName[ 2 ] = ':' ) then
  begin
    Result := LongName;
    Exit;
  end;

  FillChar( FindData, SizeOf( FindData ), #0 );
  StrPCopy( LongNameStz, LongName );
  H := FindFirstFile( LongNameStz, FindData );

  if H = Invalid_Handle_Value then
    Result := LongName
  else
  begin
    Result := StrPas( FindData.cAlternateFileName );
    FindClose( H );
  end;
end;


function ShortPathFromLong( const LongPath: string ): string;
var
  LongPathStz: array[ 0..255 ] of Char;
  ShortPathStz: array[ 0..255 ] of Char;
  R: Integer;
begin
  StrPCopy( LongPathStz, LongPath );
  R := GetShortPathName( LongPathStz, ShortPathStz, 255 );

  if R = 0 then
    Result := LongPath
  else
    Result := StrPas( ShortPathStz );
end;


function LongPathExists( const Name: string ): Boolean;
begin
  Result := DirectoryExists( Name );
end;


procedure ForceLongPath( Dir: string );
begin
  ForceDirectories( Dir );
end;

end.
