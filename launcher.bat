:: ===========================================================================
:: NAME:	launcher.bat
:: AUTHOR:	Manuel Gil.
:: DATE:	12/06/2017.
:: VERSION:	1.0.2.0
:: ===========================================================================

:main
	echo off
	title File Manager
	mode con cols=80 lines=30
	color f2
	cls
	
	call :name
	
	goto menu
goto :eof

:name
	for /f "tokens=4 delims=[] " %%a in ('ver') do set version=%%a
	if %version% EQU 5.2.3790 set name=Microsoft Windows Server 2003.
	if %version% EQU 6.0.6000 set name=Microsoft Windows Server 2008.
	if %version% EQU 6.0.6001 set name=Microsoft Windows Server 2008 SP1.
	if %version% EQU 6.0.6002 set name=Microsoft Windows Server 2008 SP2.
	if %version% EQU 6.1.7600 set name=Microsoft Windows Server 2008 R2.
	if %version% EQU 6.1.7601 set name=Microsoft Windows Server 2008 R2 SP1.
	if %version% EQU 6.2.9200 set name=Microsoft Windows Server 2012.
	if %version% EQU 6.3.9200 set name=Microsoft Windows Server 2012 R2.
	if %version% EQU 10.0.14393 set name=Microsoft Windows Server 2016.
goto :eof

:menu
	cls
	
	echo.
	echo. File Manager.
	echo.-------------------------------------------------------------------------------
	echo. %name% Build %version%.
	echo.-------------------------------------------------------------------------------
	echo.
	echo. This script modifies files between two folders.
	echo.
	echo.     1. Create a backup.
	echo.        Creates a copy of the files from an folder to a security folder.
	echo.
	echo.
	echo.     2. Perform update.
	echo.        Take the files from the source folder and place them inside the  
	echo.        destination folder.
	echo.
	echo.     3. Extract custom files.
	echo.        The files of a modification folder are compared and copied with 
	echo.        the client files to a source folder.
	echo.
	echo.     4. Create a list of files.
	echo.
	echo.
	echo.
	echo.                                                                   0. Close.
	echo.-------------------------------------------------------------------------------
	echo.
	
	set /p option=Select option: 
	
	if %option% EQU 0 (
		goto :eof
	) else if %option% EQU 1 (
		call wscript //nologo "%~dp0dialog.vbs" "%~dp0process.bat" "createCopy" "%version%"
	) else if %option% EQU 2 (
		call wscript //nologo "%~dp0dialog.vbs" "%~dp0process.bat" "patchFiles" "%version%"
	) else if %option% EQU 3 (
		call wscript //nologo "%~dp0dialog.vbs" "%~dp0process.bat" "extractCustomization" "%version%"
	) else if %option% EQU 4 (
		call wscript //nologo "%~dp0dialog.vbs" "%~dp0process.bat" "createList" "%version%"
	)
	
	goto menu
goto :eof
