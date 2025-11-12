# Script para ejecutar Flutter en modo debug con logs

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  EJECUTANDO GAMENEXT EN DEBUG MODE" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Limpiando proyecto..." -ForegroundColor Yellow
flutter clean

Write-Host "Obteniendo dependencias..." -ForegroundColor Yellow
flutter pub get

Write-Host ""
Write-Host "Dispositivos disponibles:" -ForegroundColor Green
flutter devices

Write-Host ""
Write-Host "Ejecutando en Chrome con logs..." -ForegroundColor Cyan
Write-Host ""
Write-Host "BUSCA ESTOS LOGS EN LA CONSOLA:" -ForegroundColor Yellow
Write-Host "  🚀 Initializing AuthProvider..." -ForegroundColor White
Write-Host "  🔐 Attempting sign in..." -ForegroundColor White
Write-Host "  ✅ Sign in successful" -ForegroundColor White
Write-Host "  👤 Auth state changed" -ForegroundColor White
Write-Host ""

flutter run -d chrome --debug
