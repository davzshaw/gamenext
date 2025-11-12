# Script para abrir Firebase Authentication en el navegador

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HABILITAR FIREBASE AUTHENTICATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Abriendo Firebase Console..." -ForegroundColor Yellow
Start-Process "https://console.firebase.google.com/project/gamenext-6c36e/authentication/users"

Write-Host ""
Write-Host "PASOS A SEGUIR:" -ForegroundColor Green
Write-Host ""
Write-Host "1. Click en 'Get started' (botón naranja)" -ForegroundColor White
Write-Host "2. Click en 'Email/Password'" -ForegroundColor White
Write-Host "3. Activa el toggle 'Enable'" -ForegroundColor White
Write-Host "4. Click en 'Save'" -ForegroundColor White
Write-Host ""
Write-Host "Presiona Enter cuando hayas terminado..." -ForegroundColor Yellow
Read-Host

Write-Host ""
Write-Host "Verificando configuración..." -ForegroundColor Yellow
Start-Process "https://console.firebase.google.com/project/gamenext-6c36e/authentication/providers"

Write-Host ""
Write-Host "Deberías ver: Email/Password - Enabled" -ForegroundColor Green
Write-Host ""
Write-Host "Ahora ejecuta: flutter run" -ForegroundColor Cyan
Write-Host ""
