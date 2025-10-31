@echo off
setlocal enableextensions enabledelayedexpansion

REM === UPDATE: your project folder ===
set "PROJECT_DIR=C:\Users\seun_\Downloads\The_Oladipupo_Lab_Backend\theoladipupolab"

REM === Try to auto-detect Quarto on PATH ===
set "QUARTO_EXE="
for /f "delims=" %%A in ('where quarto 2^>NUL') do if not defined QUARTO_EXE set "QUARTO_EXE=%%A"

REM === Fallback (optional): old portable location, change if needed ===
if not defined QUARTO_EXE if exist "C:\Users\seun_\Downloads\bin\quarto.exe" set "QUARTO_EXE=C:\Users\seun_\Downloads\bin\quarto.exe"

echo.
echo === Verifying paths ===
if not exist "%PROJECT_DIR%\" (
  echo [ERROR] Project folder not found: "%PROJECT_DIR%"
  goto :end
)
if not defined QUARTO_EXE (
  echo [ERROR] Could not find quarto.exe on PATH, and no fallback matched.
  echo Fix: Install Quarto or set QUARTO_EXE manually at top of this file.
  goto :end
)
if not exist "%QUARTO_EXE%" (
  echo [ERROR] Quarto not found at: "%QUARTO_EXE%"
  echo Fix: Install Quarto or set QUARTO_EXE manually at top of this file.
  goto :end
)

pushd "%PROJECT_DIR%"

REM === Ensure this is a git repo (auto-init if needed) ===
git rev-parse --is-inside-work-tree >NUL 2>&1
if errorlevel 1 (
  echo [WARN] Not a git repository. Initializing...
  git init
  git branch -M main
  REM Update the remote URL below ONLY if your repo name/user differs:
  git remote remove origin 2>NUL
  git remote add origin https://github.com/Oladipupo-hub/theoladipupolab-site.git
)

echo.
echo === Staging and committing changes ===
git add -A
git commit -m "Site update %date% %time%" 2>NUL
REM (No error if nothing to commit)

echo.
echo === Pushing to origin/main ===
git push -u origin main
if errorlevel 1 (
  echo [ERROR] Git push failed. Check network/credentials or remote URL.
  echo You can verify with:  git remote -v
  popd
  goto :end
)

echo.
echo === Publishing with Quarto to gh-pages ===
"%QUARTO_EXE%" publish gh-pages
if errorlevel 1 (
  echo [ERROR] Quarto publish failed. See errors above.
  popd
  goto :end
)

echo.
echo === Opening live site ===
start https://Oladipupo-hub.github.io/theoladipupolab-site/

popd
:end
echo.
pause