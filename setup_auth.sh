#!/bin/bash

# Script para habilitar Firebase Authentication

echo "Habilitando Firebase Authentication..."

# Usar el proyecto correcto
firebase use gamenext-6c36e

# Nota: Firebase CLI no tiene comando directo para habilitar Auth
# Debes hacerlo manualmente en la consola

echo ""
echo "Por favor, sigue estos pasos:"
echo ""
echo "1. Abre: https://console.firebase.google.com/project/gamenext-6c36e/authentication/users"
echo ""
echo "2. Click en 'Get started' (el botón naranja)"
echo ""
echo "3. Ve a la pestaña 'Sign-in method'"
echo ""
echo "4. Click en 'Email/Password'"
echo ""
echo "5. Activa el toggle 'Enable'"
echo ""
echo "6. Click en 'Save'"
echo ""
echo "7. Vuelve aquí y presiona Enter para continuar..."
read

echo "Reconfigurando FlutterFire..."
flutterfire configure --project=gamenext-6c36e

echo ""
echo "¡Listo! Ahora ejecuta: flutter run"
