
; Place the vs_community_2019.exe workloads_*.txt along in the same directory as this script
; Used for setup output filename and extract directory.

;Loading the workloads parameter from file with line breaks and removing
#define GETINSTALLLOCATION "'Visual Studio Community 2019'"
#define VS_INSTALLER_EXE "vs_community_2019.exe" 
#define SOURCEFILE SourcePath + "workloads_2019_min.txt"
#define TEMPFILE SourcePath + "workloads.txt.tmp"

#define VSDOWNLOADERFOLDERNAME=StringChange(VS_INSTALLER_EXE, "."+ExtractFileExt(VS_INSTALLER_EXE), "") 

    
;Creates an empty file, overrides existing
#expr SaveStringToFile(TEMPFILE, '',false)

#define FileHandle
#define FileLine

;Write a continues string to the file, whitespace seperated
#sub ProcessFileLine
  #define FileLine = FileRead(FileHandle)
  #expr SaveStringToFile(TEMPFILE , FileLine + ' ',true)
  #pragma message FileLine
#endsub

;Read the source file, appending each line at a string without linebreak via ProcessFileLine
#for {FileHandle = FileOpen(SOURCEFILE); \
  FileHandle && !FileEof(FileHandle); ""} \
  ProcessFileLine
#if FileHandle
  #expr FileClose(FileHandle)
#endif

;Reads the tempfile and deletes it one line
#define FileHandle FileOpen(TEMPFILE)
#define FileLine FileRead(FileHandle)
#if FileHandle
  #expr FileClose(FileHandle)
#endif
#expr DeleteFile(TEMPFILE)
 
;Remove UTF8 BOM created via SaveStringToFile
#define WORKLOADS Trim(StringChange(FileLine, '﻿', " "))

;Workloads for the offline installer depends on the orginal installer used.
;https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=vs-2019

;FileLineUTF8 now have the workloads as parameter
#pragma message "WORKLOAD: " + WORKLOADS
#pragma message "offline: " + VSDOWNLOADERFOLDERNAME

#define OUTPUTFILE VSDOWNLOADERFOLDERNAME + "_offline"
#define EXTRACT_DIR "C:\" + OUTPUTFILE

;Definition of the orginal visual studio installer filename and location.
#define VS_INSTALLER SourcePath + VS_INSTALLER_EXE

;Temporary directory to build download the required sources.
#define VS_INSTALLER_BUILD_DIR GetEnv("LOCALAPPDATA") + "\temp\" + "downloads_" +  VSDOWNLOADERFOLDERNAME

#define LAYOUTLANGUAGE "--lang en-US"

;Build the command line for the orginal installer
#define VS_INSTALLER_PARAM "--layout " + VS_INSTALLER_BUILD_DIR + " --passive " + WORKLOADS + " " + LAYOUTLANGUAGE

;Removes previous build dirs
#expr Exec(GetEnv("COMSPEC"),"/C rd /S /Q """+VS_INSTALLER_BUILD_DIR+"""")

#pragma message "Full commandline: " + VS_INSTALLER + " " + VS_INSTALLER_PARAM

;Invokes the orginal installer for offline download
#expr Exec(VS_INSTALLER, VS_INSTALLER_PARAM)



[Setup]
AppName=Visual Studio {#VSDOWNLOADERFOLDERNAME} offline installer
AppVerName=1.0
AppCopyright=Copyright (C) 2022 Carsten Riedel
VersionInfoCopyright=Copyright (C) 2022 Carsten Riedel
VersionInfoCompany=
VersionInfoDescription=Visual Studio {#VSDOWNLOADERFOLDERNAME} offline installer
VersionInfoOriginalFileName=Visual Studio {#VSDOWNLOADERFOLDERNAME} offline installer
VersionInfoProductName=Visual Studio {#VSDOWNLOADERFOLDERNAME} offline installer
VersionInfoVersion=1.0.0.0
DefaultDirName={pf}\
ArchitecturesInstallIn64BitMode=x64

OutputBaseFilename={#OUTPUTFILE}
OutputDir=.
Compression=zip/7
;DiskSpanning needed due to limit of exe size around 2GB
DiskSpanning=yes

SolidCompression=yes

DisableDirPage=yes
Uninstallable=no
CreateAppDir=No
 
[Files]
Source: "{#VS_INSTALLER_BUILD_DIR}\*"; DestDir: "{#EXTRACT_DIR}"; Flags: recursesubdirs createallsubdirs ignoreversion sortfilesbyextension

;https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2019
[Run]
Filename: "{cmd}"; Parameters: "/C start /wait ""INSTALL VS""  {#EXTRACT_DIR}\{#VS_INSTALLER_EXE} {code:GetOption} --quiet --norestart --wait --noWeb {#WORKLOADS}" ; Description: Run installer {#VS_INSTALLER_EXE} ; Flags: postinstall runascurrentuser runhidden
Filename: "{cmd}"; Parameters: "/C rd /s /q ""{#EXTRACT_DIR}""" ; Description: Delete extracted directory {#EXTRACT_DIR} ; Flags: postinstall runascurrentuser runhidden


[Code]
function GetRegistrySubkeyPathByDisplayName(RootKey: Integer; const Subkey: string; const DisplayName: string): string;
var
  Keys: TArrayOfString;
  I: Integer;
  SubkeyPath: string;
  value: string;
begin
  Result := '';
  if RegKeyExists(RootKey, Subkey) then
  begin
    if RegGetSubkeyNames(RootKey, Subkey, Keys) then
    begin
      for I := 0 to GetArrayLength(Keys) - 1 do
      begin
        SubkeyPath := Subkey + '\' + Keys[I];
        if RegQueryStringValue(RootKey, SubkeyPath, 'DisplayName', value)  then
        begin
            if value = Displayname then
            begin
              Result := SubkeyPath;
              Exit;
            end;
        end;
      end;
    end;
  end;
end;

function GetUninstallSubkeyPathByDisplayName(const DisplayName: string; ValueName: string): string;
var
  UninstallPath32: string;
  UninstallPath64: string;
  SubkeyPath: string;
  valuex: string;
begin
  UninstallPath32 := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall';
  UninstallPath64 := 'SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall';

  SubkeyPath := GetRegistrySubkeyPathByDisplayName(HKEY_LOCAL_MACHINE, UninstallPath32, DisplayName);
  if SubkeyPath = '' then
  begin
    SubkeyPath := GetRegistrySubkeyPathByDisplayName(HKEY_LOCAL_MACHINE, UninstallPath64, DisplayName);
  end;

  if SubkeyPath <> '' then
  begin
    if (RegQueryStringValue(HKEY_LOCAL_MACHINE, SubkeyPath, ValueName, valuex)) then
    begin
        Result :=  valuex;
    end
    else
    begin
        Result := '';
    end;
  end
  else
  begin
    Result := '';
  end;
end;

var
  SelectedOption: string; 


function InitializeSetup(): Boolean;
var
    location: string;
begin
  location := GetUninstallSubkeyPathByDisplayName({#GETINSTALLLOCATION},'InstallLocation')
  if location <> '' then
  begin
     SelectedOption := 'modify --installPath "'+location+'"';
  end
  else
  begin
     SelectedOption := '';
  end;

  Result := True;
end;


function GetOption(Param: String): String;
begin
    Result := SelectedOption;
end;










