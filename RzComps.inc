{=======================================================================================================================
  RzComps Include File

  Raize Components - Include File

  Symbol                Meaning
  ----------------------------------------------------------------------------------------------------------------------
  VER12x                Compiler version is between 120 and 129. Includes Delphi 4 and C++Builder 4.
  VER13x                Compiler version is between 130 and 139. Includes Delphi 5 and C++Builder 5.
  VER14x                Compiler version is between 140 and 149. Includes Delphi 6 and Kylix 1.
  VER15x                Compiler version is between 150 and 159.

  DELPHI                Is a Delphi verison of the compiler.
  BCB                   Is a C++Builder version of the compiler.

  VCL40                 VCL version 4.0 (Delphi 4.0, C++Builder 4)
  VCL50                 VCL version 5.0 (Delphi 5.0, C++Builder 5)
  VCL60                 VCL version 6.0 (Delphi 6.0, C++Builder 6)
  VCL62                 VCL version 6.2 (Delphi 6.0 Update 2, C++Builder 6)
  VCL70                 VCL version 7.0 (Delphi 7.0)

  VCL40_OR_HIGHER       VCL version 4.0 or higher
  VCL50_OR_HIGHER       VCL version 5.0 or higher
  VCL60_OR_HIGHER       VCL version 6.0 or higher
  VCL62_OR_HIGHER       VCL version 6.2 or higher
  VCL70_OR_HIGHER       VCL version 7.0 or higher

  DELPHI4               Delphi 4
  DELPHI5               Delphi 5
  DELPHI6               Delphi 6
  DELPHI7               Delphi 7
  D4_OR_HIGHER          Delphi 4 or higher
  D5_OR_HIGHER          Delphi 5 or higher
  D6_OR_HIGHER          Delphi 6 or higher
  D7_OR_HIGHER          Delphi 7 or higher

  BCB4                  C++Builder 4
  BCB5                  C++Builder 5
  BCB6                  C++Builder 6
  BCB4_OR_HIGHER        C++Builder 4 or higher
  BCB5_OR_HIGHER        C++Builder 5 or higher
  BCB6_OR_HIGHER        C++Builder 6 or higher


  Modification History
  ----------------------------------------------------------------------------------------------------------------------
  <Ver>  (DD MMM YYYY)  <Modification detail>


  Copyright © 1995-2003 by Raize Software, Inc.  All Rights Reserved.
=======================================================================================================================}

{$DEFINE VER_UNKNOWN}

// VER120 (Delphi 4)

{$IFDEF VER120}
  {$UNDEF VER_UNKNOWN}
  {$DEFINE VER12x}
  {$DEFINE VCL40}

  {$DEFINE DELPHI}
  {$DEFINE DELPHI4}
  {$DEFINE D4_OR_HIGHER}

  {$DEFINE VCL40_OR_HIGHER}
{$ENDIF}


// VER125 (C++Builder 4)

{$IFDEF VER125}
  {$UNDEF VER_UNKNOWN}
  {$DEFINE VER12x}
  {$DEFINE VCL40}

  {$DEFINE BCB}
  {$DEFINE BCB4}
  {$DEFINE BCB4_OR_HIGHER}
  {$OBJEXPORTALL ON}

  {$DEFINE VCL40_OR_HIGHER}
{$ENDIF}


// VER130 (Delphi 5 & C++Builder 5)

{$IFDEF VER130}
  {$UNDEF VER_UNKNOWN}
  {$DEFINE VER13x}
  {$DEFINE VCL50}

  {$IFDEF BCB}
    {$DEFINE BCB5}
    {$DEFINE BCB4_OR_HIGHER}
    {$DEFINE BCB5_OR_HIGHER}
    {$OBJEXPORTALL ON}
  {$ELSE}
    {$DEFINE DELPHI}
    {$DEFINE DELPHI5}
    {$DEFINE D4_OR_HIGHER}
    {$DEFINE D5_OR_HIGHER}
  {$ENDIF}

  {$DEFINE VCL40_OR_HIGHER}
  {$DEFINE VCL50_OR_HIGHER}
{$ENDIF}


// VER140 (Delphi 6 & C++Builder 6 & Kylix 1)

{$IFDEF VER140}
  {$UNDEF VER_UNKNOWN}
  {$DEFINE VER14x}
  {$DEFINE VCL60}

  {$IFDEF MSWINDOWS}
    {$IFDEF BCB}
      {$DEFINE BCB6}
      {$DEFINE BCB4_OR_HIGHER}
      {$DEFINE BCB5_OR_HIGHER}
      {$DEFINE BCB6_OR_HIGHER}
      {$OBJEXPORTALL ON}
    {$ELSE}
      {$DEFINE DELPHI}
      {$DEFINE DELPHI6}
      {$DEFINE D4_OR_HIGHER}
      {$DEFINE D5_OR_HIGHER}
      {$DEFINE D6_OR_HIGHER}
    {$ENDIF}
  {$ELSE}
    // Non-Windows compiler (i.e. Kylix)
  {$ENDIF}

  {$DEFINE VCL40_OR_HIGHER}
  {$DEFINE VCL50_OR_HIGHER}
  {$DEFINE VCL60_OR_HIGHER}
{$ENDIF}


// VER150 (Delphi 7)

// If compiler version is unknown, assume to be VER150

{$IFDEF VER150}
  {$DEFINE USE_VER150}
{$ENDIF}

{$IFDEF VER_UNKNOWN}
  {$UNDEF VER_UNKNOWN}
  {$DEFINE USE_VER150}
{$ENDIF}

{$IFDEF USE_VER150}
  {$UNDEF VER_UNKNOWN}
  {$DEFINE VER15x}
  {$DEFINE VCL70}

  {$IFDEF MSWINDOWS}
    {$IFDEF BCB}
      {$DEFINE BCB7}
      {$DEFINE BCB4_OR_HIGHER}
      {$DEFINE BCB5_OR_HIGHER}
      {$DEFINE BCB6_OR_HIGHER}
      {$DEFINE BCB7_OR_HIGHER}
      {$OBJEXPORTALL ON}
    {$ELSE}
      {$DEFINE DELPHI}
      {$DEFINE DELPHI7}
      {$DEFINE D4_OR_HIGHER}
      {$DEFINE D5_OR_HIGHER}
      {$DEFINE D6_OR_HIGHER}
      {$DEFINE D7_OR_HIGHER}
    {$ENDIF}
    {$DEFINE DOTNET_WARNINGS}
  {$ELSE}
    // Non-Windows compiler (i.e. Kylix)
  {$ENDIF}

  {$DEFINE VCL40_OR_HIGHER}
  {$DEFINE VCL50_OR_HIGHER}
  {$DEFINE VCL60_OR_HIGHER}
  {$DEFINE VCL70_OR_HIGHER}
{$ENDIF}


{$IFDEF VCL60_OR_HIGHER}
  {$WARN UNIT_PLATFORM OFF}
  {$WARN SYMBOL_PLATFORM OFF}
  {$WARN UNIT_DEPRECATED OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}


{$IFDEF DOTNET_WARNINGS}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}


{== Code Generation Directives ========================================================================================}

{$ALIGN ON}
{$OPTIMIZATION ON}
{$SAFEDIVIDE OFF}
{$STACKFRAMES OFF}

// Runtime Errors

{$IFOPT D+}
  // Compiled with Debug Information
  {$ASSERTIONS ON}
  {$LOCALSYMBOLS ON}
  {$RANGECHECKS ON}
  {$REFERENCEINFO ON}
{$ELSE}
  // Compiled without Debug Information
  {$ASSERTIONS OFF}
  {$LOCALSYMBOLS OFF}
  {$RANGECHECKS OFF}
  {$REFERENCEINFO OFF}
{$ENDIF}

{$IOCHECKS ON}
{$OVERFLOWCHECKS OFF}

// Syntax Options

{$BOOLEVAL OFF}
{$LONGSTRINGS ON}
{$WRITEABLECONST OFF}
{$OPENSTRINGS ON}
{$TYPEDADDRESS ON}
{$VARSTRINGCHECKS OFF}
{$EXTENDEDSYNTAX ON}

// Miscellaneous Directives

{$IMPORTEDDATA ON}
{$MINENUMSIZE 1}

