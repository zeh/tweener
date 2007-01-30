@echo off
echo ------ Trying to compile using MTASC; You might need to change some of the path or parameters used if you see any error message.
"C:\Program Files\FlashDevelop\tools\mtasc\mtasc.exe" -cp "D:\library_code\as\tweener_googlecode\trunk\as2" -cp "C:\Program Files\Macromedia\Flash 8\en\First Run\Classes" -mx -swf splash_buttons_as2_mtasc.swf SplashButtonsExample.as
echo ------ Done.
pause