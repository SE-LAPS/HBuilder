@echo off
echo ================================================
echo Deploying Firebase Storage Rules for Washtron
echo ================================================
echo.

echo Checking if Firebase CLI is installed...
firebase --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Firebase CLI is not installed!
    echo.
    echo Please install Firebase CLI first:
    echo npm install -g firebase-tools
    echo.
    echo Then run this script again.
    pause
    exit /b 1
)

echo Firebase CLI found!
echo.

echo Deploying storage rules...
firebase deploy --only storage

if %errorlevel% equ 0 (
    echo.
    echo ================================================
    echo SUCCESS! Storage rules deployed successfully!
    echo ================================================
    echo.
    echo Your profile image upload should now work.
    echo.
) else (
    echo.
    echo ================================================
    echo ERROR: Failed to deploy storage rules
    echo ================================================
    echo.
    echo Make sure you are logged in to Firebase:
    echo firebase login
    echo.
    echo And that you have initialized your project:
    echo firebase init
    echo.
)

pause
