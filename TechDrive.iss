; TechDrive.iss - Inno Setup 6 installer for the Nuitka single-file build.
;
; Produces ONE file: installer\Output\TechDriveSetup.exe
;   - LZMA2 ultra64, solid compression (the strongest Inno Setup offers)
;   - built-in EULA page, Start Menu + optional desktop shortcut, uninstaller
;   - per-user install (no admin needed), x64 only
;
; BUILD:
;   1. Run build_nuitka.bat   ->  dist\TechDrive.exe
;      (for the SMALLEST installer run "build_nuitka.bat nocompress" - see
;       the note in build_installer.bat)
;   2. Run build_installer.bat   (or open this file in Inno Setup and press F9)
;
; WHY {localappdata} AND NOT {autopf} (Program Files)
;   TechDrive writes tool groups / logs next to itself at runtime, and
;   Program Files is read-only for standard users. A per-user install keeps
;   the app folder writable without elevation.

#define MyAppName      "TechDrive"
#define MyAppVersion   "1.1.0"
#define MyAppPublisher "TechDrive"
#define MyAppExeName   "TechDrive.exe"
#define MyAppURL       "https://techdrive.tanujgunasekara693.workers.dev/"

#if !FileExists(AddBackslash(SourcePath) + "D:\micro sas\techdrive\dist\TechDrive.exe")
  #error "D:\micro sas\techdrive\dist\TechDrive.exe not found - run build_nuitka.bat first."
#endif

[Setup]
; Keep this GUID unchanged in every future version so installers upgrade
; the existing install in place instead of creating a second copy.
AppId={{D9181FC4-FD65-44AC-8CB7-34999AD78800}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
VersionInfoVersion={#MyAppVersion}.0
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName} Setup
VersionInfoProductName={#MyAppName}

DefaultDirName={localappdata}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0

LicenseFile=..\EULA_FULL.txt
SetupIconFile=..\techdrive_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
WizardStyle=modern
ShowLanguageDialog=no

; Close a running TechDrive during upgrade instead of failing on a locked exe.
CloseApplications=yes
RestartApplications=no

OutputDir=Output
OutputBaseFilename=TechDriveSetup

; ---- Maximum compression ------------------------------------------------
Compression=lzma2/ultra64
SolidCompression=yes
InternalCompressLevel=ultra64
LZMAAlgorithm=1
LZMAMatchFinder=BT
LZMANumFastBytes=273
; 64 MB dictionary: more than enough for this payload. A larger one gains
; nothing but would make Setup need that much RAM on the user's PC.
LZMADictionarySize=65536
LZMAUseSeparateProcess=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional shortcuts:"

[Files]
Source: "..\dist\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName} now"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Files TechDrive creates at runtime inside its own folder; Inno only
; removes files it installed itself.
Type: filesandordirs; Name: "{app}\hosted_plugins"
Type: filesandordirs; Name: "{app}\techdrive_modules"
Type: files; Name: "{app}\pluginhost.log"
