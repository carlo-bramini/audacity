﻿;   Audacity: A Digital Audio Editor
;   Audacity(R) is copyright (c) 1999-2016 Audacity Team.
;   License: GPL v2.  See License.txt.
;
;   audacity.iss
;   Vaughan Johnson, Leland Lucius, Martyn Shaw, Richard Ash, & others
;

; This requires that the ISS Preprocessor be installed
#define AppExe "..\release\audacity.exe" 
#define AppMajor ""
#define AppMinor ""
#define AppRev ""
#define AppBuild ""
#define FullVersion ParseVersion(AppExe, AppMajor, AppMinor, AppRev, AppBuild)
#define AppVersion Str(AppMajor) + "." + Str(AppMinor) + "." + Str(AppRev)
#define AppName GetStringFileInfo(AppExe, PRODUCT_NAME)

[UninstallRun]
; Uninstall prior installations.
Filename: "{app}\unins*.*"; 

[Setup]
; compiler-related directives
OutputBaseFilename=audacity-win-{#AppVersion}

WizardImageFile=".\audacity_InnoWizardImage.bmp"
WizardSmallImageFile=".\audacity_InnoWizardSmallImage.bmp"

SolidCompression=yes

; installer-related directives
; From Inno 5.5.7, Inno defaults to disabling the Welcome page as recommended 
; by Microsoft's desktop applications guideline, but we don't want to do that.
DisableWelcomePage=no

AppName={#AppName}
AppVerName=Audacity {#AppVersion}
; Specify AppVersion as well, so it appears in the Add/Remove Programs entry. 
AppVersion={#AppVersion}
AppPublisher="Audacity Team"
AppPublisherURL=http://audacityteam.org
AppSupportURL=http://audacityteam.org
AppUpdatesURL=http://audacityteam.org
ChangesAssociations=yes

DefaultDirName={pf}\Audacity

VersionInfoProductName={#AppName}
VersionInfoProductTextVersion={#GetFileProductVersion(AppExe)}
VersionInfoDescription={#AppName + " " + AppVersion + " Setup"}
VersionInfoVersion={#GetFileVersion(AppExe)}
VersionInfoCopyright={#GetFileCopyright(AppExe)}

; Don't disable the "Select Destination Location" wizard, even if 
; Audacity is already installed.
DisableDirPage=no

; Always warn if dir exists, because we'll overwrite previous Audacity.
DirExistsWarning=yes
DisableProgramGroupPage=yes
UninstallDisplayIcon="{app}\audacity.exe"

; No longer force them to accept the license, just display it.   LicenseFile=..\LICENSE.txt
InfoBeforeFile=".\audacity_InnoWizard_InfoBefore.rtf"
InfoAfterFile=..\..\README.txt

; We no longer produce new ANSI builds. 
; As we use Inno Setup (u), the Unicode version, to build this script, 
; the MinVersion will automatically be set to what we need. 
; We no longer explicitly set it.
;   MinVersion=4.0,5.0

; cosmetic-related directives
SetupIconFile="..\audacity.ico"

[INI]
Filename: "{app}\FirstTime.ini"; Section: "FromInno"; Key: "ResetPrefs"; String: "1"; Tasks: resetPrefs;
Filename: "{app}\FirstTime.ini"; Section: "FromInno"; Key: "Language"; String: "{language}"

[Tasks]
Name: desktopicon; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"
Name: resetPrefs; Description:  "{cm:ResetPrefs}"; Flags: unchecked
; No longer allow user to choose whether to associate AUP file type with Audacity.
; Name: associate_aup; Description: "&Associate Audacity project files"; GroupDescription: "Other tasks:"; Flags: checkedonce

[Files]
; Prime the first time .ini file so the permissions can be set
Source: ".\FirstTimeModel.ini"; DestDir: "{app}"; DestName: "FirstTime.ini"; Permissions: users-modify

; Don't display in separate window, rather as InfoAfterFile.   Source: "..\README.txt"; DestDir: "{app}"; Flags: ignoreversion isreadme
Source: "..\..\README.txt"; DestDir: "{app}"; Flags: ignoreversion

Source: "..\..\LICENSE.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#AppExe}"; DestDir: "{app}"; Flags: ignoreversion

; Manual, which should be got from the manual wiki using ..\scripts\mw2html_audacity\wiki2htm.bat
Source: "..\..\help\manual\*"; DestDir: "{app}\help\manual\"; Flags: ignoreversion recursesubdirs

Source: "..\..\presets\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs

; wxWidgets DLLs. Be specific (not *.dll) so we don't accidentally distribute avformat.dll, for example.
; Don't use the WXWIN environment variable, because...
; 1) Can't get the documented {%WXWIN|default dir} parsing to work.
; 2) Need the DLL's in the release dir for testing, anyway.
Source: "..\release\wxbase311u_xml_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\release\wxbase311u_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\release\wxmsw311u_adv_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\release\wxmsw311u_core_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\release\wxmsw311u_html_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\release\wxmsw311u_qa_vc_custom.dll"; DestDir: "{app}"; Flags: ignoreversion

; MSVC runtime DLLs. Some users can't put these in the system dir, so just put them in the EXE dir.
; It's legal, per http://www.fsf.org/licensing/licenses/gpl-faq.html#WindowsRuntimeAndGPL .
; This is not an ideal solution, but should need the least tech support.
; We'll know we have the right version, don't step on anybody else's older version, and
; it's easy to make the zip (and they match better).
; Copy the several required DLL's from 
; "C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\redist\x86\Microsoft.VC120.CRT\"
; or "C:\Program Files\Microsoft Visual Studio 12.0\VC\redist\x86\Microsoft.VC120.CRT\"
; according to your system 
Source: "..\release\concrt140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\release\msvcp140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\release\msvcp140_1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\release\msvcp140_2.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\release\vcruntime140.dll"; DestDir: "{app}"; Flags: ignoreversion

Source: "..\release\languages\*"; DestDir: "{app}\Languages\"; Flags: ignoreversion recursesubdirs
; We don't ship all modules, so the next line is commented out
; Source: "..\release\modules\*"; DestDir: "{app}\Modules\"; Flags: ignoreversion recursesubdirs skipifsourcedoesntexist
Source: "..\release\nyquist\*"; DestDir: "{app}\Nyquist\"; Flags: ignoreversion recursesubdirs
Source: "..\release\plug-ins\*"; DestDir: "{app}\Plug-Ins\"; Flags: ignoreversion
Source: "..\release\modules\mod-script-pipe.dll"; DestDir: "{app}\modules\"; Flags: ignoreversion

[Icons]
Name: "{commonprograms}\Audacity"; Filename: "{app}\audacity.exe"
Name: "{commondesktop}\Audacity"; Filename: "{app}\audacity.exe"; Tasks: desktopicon

[InstallDelete]
; Get rid of Audacity 1.0.0 stuff that's no longer used.
Type: files; Name: "{app}\audacity-help.htb"
Type: files; Name: "{app}\audacity-1.2-help.htb"

; Get rid of previous versions of MSVC runtimes.
Type: files; Name: "{app}\Microsoft.VC80.CRT.manifest"
Type: files; Name: "{app}\Microsoft.VC90.CRT.manifest"
Type: files; Name: "{app}\msvcp80.dll"
Type: files; Name: "{app}\msvcr80.dll"
Type: files; Name: "{app}\msvcp90.dll"
Type: files; Name: "{app}\msvcr90.dll"
Type: files; Name: "{app}\msvcp120.dll"
Type: files; Name: "{app}\msvcr120.dll"

; Get rid of previous help folder.
Type: filesandordirs; Name: "{app}\help"

; Don't want to do this because user may have stored their own.
;   Type: filesandordirs; Name: "{app}\vst"

; We've switched from a folder in the start menu to just the Audacity.exe at the top level.
; Get rid of 1.0.0 folder and its icons.
Type: files; Name: "{commonprograms}\Audacity\audacity.exe"
Type: files; Name: "{commonprograms}\Audacity\unins000.exe"
Type: dirifempty; Name: "{commonprograms}\Audacity"

;Get rid of previous uninstall item
Type: files; Name: "{app}\unins*.*"

; Get rid of no longer used test.lsp.
Type: files; Name: "{app}\Nyquist\test.lsp"

; Get rid of specific LADSPA plug-ins that we now ship with different names.
Type: files; Name: "{app}\Plug-Ins\GVerb.dll"
Type: files; Name: "{app}\Plug-Ins\Hard Limiter.dll"
Type: files; Name: "{app}\Plug-Ins\hard_limiter_1413.dll"
Type: files; Name: "{app}\Plug-Ins\sc4.dll"

;Get rid of any modules that we have ever installed
Type: files; Name: "{app}\Modules\mod-script-pipe.dll"
Type: files; Name: "{app}\Modules\mod-script-pipe.exp"
Type: files; Name: "{app}\Modules\mod-script-pipe.lib"
Type: files; Name: "{app}\Modules\mod-nyq-bench.dll"

;get rid of the Modules dir, if it is empty
Type: dirifempty; Name: "{app}\Modules"

; Get rid of gverb that we no longer ship
Type: files; Name: "{app}\Plug-Ins\gverb_1216.dll"

; Get rid of old nyquist plugins that we no longer ship
Type: files; Name: "{app}\Plug-Ins\crossfadein.ny"
Type: files; Name: "{app}\Plug-Ins\crossfadeout.ny"
Type: files; Name: "{app}\Plug-Ins\clicktrack.ny"
                                            
[Registry]
; No longer allow user to choose whether to associate AUP file type with Audacity.
; Leaving this one commented out example of the old way.
; Root: HKCR; Subkey: ".AUP"; ValueType: string; ValueData: "Audacity.Project"; Flags: createvalueifdoesntexist uninsdeletekey; Tasks: associate_aup
Root: HKCR; Subkey: ".AUP"; ValueType: string; ValueData: "Audacity.Project"; Flags: createvalueifdoesntexist uninsdeletekey;
Root: HKCR; Subkey: "Audacity.Project\OpenWithList\audacity.exe"; Flags: createvalueifdoesntexist uninsdeletekey;
Root: HKCR; Subkey: "Audacity.Project"; ValueType: string; ValueData: "Audacity Project File"; Flags: createvalueifdoesntexist uninsdeletekey;
Root: HKCR; Subkey: "Audacity.Project\shell"; ValueType: string; ValueData: ""; Flags: createvalueifdoesntexist uninsdeletekey;
Root: HKCR; Subkey: "Audacity.Project\shell\open"; Flags: createvalueifdoesntexist uninsdeletekey;
Root: HKCR; Subkey: "Audacity.Project\shell\open\command"; ValueType: string; ValueData: """{app}\audacity.exe"" ""%1"""; Flags: createvalueifdoesntexist uninsdeletekey;

;The following would allow a following 'help' installer to know where to put the 'help' files.
;Root: HKCR; Subkey: "Audacity.Project\Path";  ValueType: string; ValueData: {app}; Flags: createvalueifdoesntexist uninsdeletekey;

[Run]
Filename: "{app}\audacity.exe"; Description: "{cm:LaunchProgram,Audacity}"; Flags: nowait postinstall skipifsilent

[Languages]
; NOTE: "0" in locale name will be translated to "@" when read by Audacity.

; Create subdirectories where we'll store the unofficial and dummy translation files
{#expr Exec("cmd", "/c mkdir """ + CompilerPath + "Languages\dummy""", , , SW_HIDE), \
       Exec("cmd", "/c mkdir """ + CompilerPath + "Languages\unofficial""", , , SW_HIDE)}

; Download Additional Inno Setup translations from:
;
; http://www.jrsoftware.org/files/istrans/
;
; Set this to the base of the unofficial  Inno Setup translations
#define UrlBase "http://raw.github.com/jrsoftware/issrc/master/Files/Languages/Unofficial/"

; This macro will use the Windows PowerShell to download the given translation into
; the Inno Setup Languages folder if it hasn't already been downloaded.
; (Sorry, it's not a quick process, but it only happens once.)
#define Get(URL) \
  Local[0] = "Languages\unofficial\" + Copy(URL, RPos("/", URL) + 1), \
  Local[1] = (FileExists(CompilerPath + Local[0]) \
    ? "alreadyexists" \
    : Exec("powershell", "echo 'Downloading: " + URL + "'; $wc = new-object System.Net.WebClient; $wc.DownloadFile('" + URLBase + URL + "', '" + Local[0] + "')", , , SW_NORMAL)), \
  "compiler:" + Local[0]

; This macro will define a dummy translation based on the Defaults.isl
#define Dummy(NAME, ID) \
  Local[0] = "Languages\dummy\", \
  Local[1] = Local[0] + NAME + ".isl", \
  Local[2] = CompilerPath + Local[1], \
  Local[3] = (FileExists(Local[2]) \
    ? "alreadyexists" \
    : (CopyFile(CompilerPath + "Default.isl", Local[2]), \
       WriteIni(Local[2], "LangOptions", "LanguageName", NAME), \
       WriteIni(Local[2], "LangOptions", "LanguageID", "$" + ID))), \
  "compiler:" + Local[1]

Name: "af"; MessagesFile: "{#Get('Afrikaans.isl')}"
Name: "ar"; MessagesFile: "{#Get('Arabic.isl')}"
Name: "be"; MessagesFile: "{#Get('Belarusian.isl')}"
Name: "bg"; MessagesFile: "{#Get('Bulgarian.isl')}"
Name: "bn"; MessagesFile: "{#Get('Bengali.islu')}"
Name: "bs"; MessagesFile: "{#Get('Bosnian.isl')}"
Name: "ca"; MessagesFile: "compiler:Languages\Catalan.isl"
Name: "ca_ES0valencia"; MessagesFile: "{#Get('Valencian.isl')}"
;Name: "co"; MessagesFile: "compiler:Languages\Corsican.isl"
Name: "cs"; MessagesFile: "compiler:Languages\Czech.isl"
Name: "cy"; MessagesFile: "{#Dummy('Welsh', '0452')}"
Name: "da"; MessagesFile: "compiler:Languages\Danish.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "el"; MessagesFile: "compiler:Languages\Greek.isl"
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "eu"; MessagesFile: "{#Get('Basque.isl')}"
Name: "fa"; MessagesFile: "{#Get('Farsi.isl')}"
Name: "fi"; MessagesFile: "compiler:Languages\Finnish.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "ga"; MessagesFile: "{#Dummy('Gaeilge', '083C')}"
Name: "gl"; MessagesFile: "{#Get('Galician.isl')}"
Name: "he"; MessagesFile: "compiler:Languages\Hebrew.isl"
Name: "hi"; MessagesFile: "{#Get('Hindi.islu')}"
Name: "hr"; MessagesFile: "{#Get('Croatian.isl')}"
Name: "hu"; MessagesFile: "compiler:Languages\Hungarian.isl"
Name: "hy"; MessagesFile: "compiler:Languages\Armenian.islu"
Name: "id"; MessagesFile: "{#Get('Indonesian.isl')}"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "ja"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "ka"; MessagesFile: "{#Get('Georgian.islu')}"
Name: "km"; MessagesFile: "{#Dummy('Khmer', '0409')}"
Name: "ko"; MessagesFile: "{#Dummy('Korean', '0412')}"
Name: "lt"; MessagesFile: "{#Get('Lithuanian.isl')}"
Name: "mk"; MessagesFile: "{#Get('Macedonian.isl')}"
Name: "my"; MessagesFile: "{#Dummy('Burmese', '0409')}"
Name: "nb"; MessagesFile: "compiler:Languages\Norwegian.isl"
;Name: "ne"; MessagesFile: "compiler:Languages\Nepali.islu"
Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
Name: "oc"; MessagesFile: "{#Get('Occitan.isl')}"
Name: "pl"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "pt_PT"; MessagesFile: "compiler:Languages\Portuguese.isl"
Name: "pt_BR"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "ro"; MessagesFile: "{#Get('Romanian.isl')}"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "sk"; MessagesFile: "{#Get('Slovak.isl')}"
Name: "sl"; MessagesFile: "compiler:Languages\Slovenian.isl"
Name: "sr_RS"; MessagesFile: "compiler:Languages\SerbianCyrillic.isl"
Name: "sr_RS0latin"; MessagesFile: "compiler:Languages\SerbianLatin.isl"
Name: "sv"; MessagesFile: "{#Get('Swedish.isl')}"
Name: "ta"; MessagesFile: "{#Dummy('Tamil', '0449')}"
Name: "tg"; MessagesFile: "{#Dummy('Tajik', '0428')}"
Name: "tr"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "uk"; MessagesFile: "compiler:Languages\Ukrainian.isl"
;Name: "vi"; MessagesFile: "{#Get('Vietnamese.islu')}"
Name: "zh_CN"; MessagesFile: "{#Get('ChineseSimplified.isl')}"
Name: "zh_TW"; MessagesFile: "{#Get('ChineseTraditional.isl')}"

; To include additional translations add it to the win/InnoSetupLanguages directory.
; The filename must be the locale name and the ".isl" extension.  For example, "af.isl"
; would have the "Afrikaans" translation.

; Pull in additional translations from the win/InnoSetupLanguages directory
#define FindHandle
#define FindResult

#sub AddLanguage
  #define FileName FindGetFileName(FindHandle)
  #define LangCode Local[0] = Copy(FileName, 1, Pos(".", FileName) - 1)
  Name: {#LangCode}; MessagesFile: "InnoSetupLanguages\{#FileName}"
#endsub

#for {FindHandle = FindResult = FindFirst("InnoSetupLanguages\*.isl", 0); FindResult; FindResult = FindNext(FindHandle)} AddLanguage
#if FindHandle
  #expr FindClose(FindHandle)
#endif

; These could be included from a different file to make it easier to update...
[CustomMessages]
af.ResetPrefs=Reset Preferences
ar.ResetPrefs=Reset Preferences
be.ResetPrefs=Reset Preferences
bg.ResetPrefs=Да се нулират ли настройките?
bn.ResetPrefs=Reset Preferences
bs.ResetPrefs=Reset Preferences
ca.ResetPrefs=Voleu restablir les preferències?
ca_ES0valencia.ResetPrefs=Reset Preferences
;co.ResetPrefs=Reset Preferences
cs.ResetPrefs=Vynulovat nastavení?
cy.ResetPrefs=Reset Preferences
da.ResetPrefs=Gendan indstillinger?
de.ResetPrefs=Einstellungen zurücksetzen?
el.ResetPrefs=Επαναφορά προτιμήσεων;
en.ResetPrefs=Reset Preferences
es.ResetPrefs=¿Desea restablecer las preferencias?
eu.ResetPrefs=Berrezarri Hobespenak?
fa.ResetPrefs=Reset Preferences
fi.ResetPrefs=Reset Preferences
fr.ResetPrefs=Réinitialiser les préférences ?
ga.ResetPrefs=Reset Preferences
gl.ResetPrefs=Restabelecer as preferencias?
he.ResetPrefs=?אתה רוצה לשחזר העדפות
hi.ResetPrefs=वरीयताएँ रीसेट करें?
hr.ResetPrefs=Resetirati Postavke?
hu.ResetPrefs=Alapra állítja a beállításokat?
hy.ResetPrefs=Վերափոխե՞լ կարգավորումները:
id.ResetPrefs=Reset Preferences
it.ResetPrefs=Ripristino Preferenze?
ja.ResetPrefs=設定をリセットする
ka.ResetPrefs=Reset Preferences
km.ResetPrefs=Reset Preferences
ko.ResetPrefs=기본 설정을 재설정하시겠습니까?
lt.ResetPrefs=Reset Preferences
mk.ResetPrefs=Reset Preferences
my.ResetPrefs=Reset Preferences
nb.ResetPrefs=Reset Preferences
;ne.ResetPrefs=Reset Preferences
nl.ResetPrefs=Voorkeuren herstellen?
oc.ResetPrefs=Reset Preferences
pl.ResetPrefs=Zresetować ustawienia?
pt_PT.ResetPrefs=Reconfigurar as Preferências?
pt_BR.ResetPrefs=Repor Preferências?
ro.ResetPrefs=Reset Preferences
ru.ResetPrefs=Сбросить Параметры?
sk.ResetPrefs=Obnoviť nastavenia?
sl.ResetPrefs=Želite ponastaviti možnosti?
sr_RS.ResetPrefs=Да вратим на старе поставке?
sr_RS0latin.ResetPrefs=Da vratim na stare postavke?
sv.ResetPrefs=Återställ inställningar?
ta.ResetPrefs="விருப்பங்களை மீட்டமைக்க?
tg.ResetPrefs=Reset Preferences
tr.ResetPrefs=Ayarlar Sıfırlansın mı?
uk.ResetPrefs=Відновити початкові значення параметрів?
;vi.ResetPrefs=Reset Preferences
zh_CN.ResetPrefs=重置偏好设置
zh_TW.ResetPrefs=重置偏好設定
