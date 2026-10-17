@echo off
setlocal EnableDelayedExpansion
cd /d "%~dp0"

set "CONFIG_FILE=theme.conf"
set "THEME_NAME=SpicetifyCat"
set "SELECTED_THEME="

if not exist "%CONFIG_FILE%" (
    echo [ERROR] Could not find %CONFIG_FILE% in %cd%
    pause
    exit /b 1
)

for /f "usebackq eol=# tokens=1,2 delims== " %%A in ("%CONFIG_FILE%") do (
    if /i "%%A"=="THEME" set "SELECTED_THEME=%%B"
)

if "!SELECTED_THEME!"=="" (
    echo [ERROR] No THEME value found in %CONFIG_FILE%.
    echo Make sure there is a line like: THEME = Reze_Neon
    pause
    exit /b 1
)

echo ============================================================
echo  SpicetifyCat Theme Installer ^& Switcher
echo ============================================================
echo  Selected sub-theme : !SELECTED_THEME!

set "SPICETIFY_DIR=%APPDATA%\spicetify"
for /f "delims=" %%P in ('spicetify path userdata 2^>nul') do set "SPICETIFY_DIR=%%P"

set "TARGET_DIR=!SPICETIFY_DIR!\Themes\!THEME_NAME!"
echo  Target directory   : !TARGET_DIR!
echo ============================================================

echo [1/3] Copying theme files to Spicetify Themes folder...
if not exist "!TARGET_DIR!" mkdir "!TARGET_DIR!"
robocopy "%cd%" "!TARGET_DIR!" /E /XD .git .vscode /NFL /NDL /NJH /NJS /NC /NS >nul

echo [2/3] Updating Spicetify configuration...
call spicetify config current_theme !THEME_NAME!
call spicetify config color_scheme !SELECTED_THEME!
call spicetify config inject_css 1
call spicetify config replace_colors 1
call spicetify config overwrite_assets 1
call spicetify config inject_theme_js 1

echo [3/3] Applying theme to Spotify...
call spicetify apply

echo.
echo ============================================================
echo  Done! "!SELECTED_THEME!" is now active in Spotify.
echo  Tip: You can also switch themes anytime inside Spotify by
echo  clicking your profile icon (top-right) ^> "Cat Theme".
echo ============================================================
pause
