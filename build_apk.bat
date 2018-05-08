@echo off
title Builing apk
call flutter clean
call flutter build apk
copy build\app\outputs\apk\release\app-release.apk  "C:\Users\larsk\Google Drive"