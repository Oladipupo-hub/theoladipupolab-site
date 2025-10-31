@echo off
REM Navigate to your Quarto project directory
cd /d C:\Users\seun_\Downloads\bin\theoladipupolab

REM Stage all changes
git add .

REM Commit with a timestamp
git commit -m "Site update %date% %time%"

REM Push to GitHub main branch
git push origin main

REM Publish the site to gh-pages
..\quarto.exe publish gh-pages

REM Open the live site in your browser
start https://Oladipupo-hub.github.io/theoladipupolab-site/

pause