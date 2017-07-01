:: ===========================================================================
:: NAME:	commands.bat
:: AUTHOR:	Manuel Gil.
:: DATE:	12/06/2017.
:: VERSION:	1.0.2.0
:: ===========================================================================

:: This script contains commands for handling folders and files.
::		@args - %* = All arguments.
::				%~1 = Function name.
::				%~2 = Second argument.
::				...
::				%~9 = Last argument.
::				/source: = Source folder.
::				/destination: = Destination folder.
::				/custom: = Modification folder.
::				/version: = System version.
::		Each function has a separate parameter handling.
:: void main(args[]);
:main
	echo off
	title Process Manager
	cls
	
	set args=%*
	call set args=%%args:%~1=%%
	set args=%args:{="%
	set args=%args:}="%
	
	for %%a in (%args%) do (
		call :initValues %%a
	)
	
	for /f "tokens=1-5 delims=/, " %%a in ("%date%") do (
		set CONST_DATE=%%d%%c%%b%%a
	)
	
	set log=%~dp0log%CONST_DATE%.log
	set catalog=%~dp0catalog.ini
		
	if not exist "%CONST_SOURCE%" (
		echo.                                                                               >>"%log%"
		echo.------------------------------------------------------------------------------->>"%log%"
		echo.    Tool for efficient file copying                                            >>"%log%"
		echo.------------------------------------------------------------------------------->>"%log%"
		echo.                                                                               >>"%log%"
		echo.    Start: %date% %time%,                                                      >>"%log%"
		echo.    ERROR: The folder %CONST_SOURCE% does not exist.                           >>"%log%"
		echo.                                                                               >>"%log%"
		echo.------------------------------------------------------------------------------->>"%log%"
		
		echo.ERROR: The folder %CONST_SOURCE% does not exist.
		pause
		goto :eof
	)
	
	if %~1 EQU {createCopy} (
		goto createCopy
	) else if %~1 EQU {patchFiles} (
		goto patchFiles
	) else if %~1 EQU {extractCustomization} (
		goto extractCustomization
	) else if %~1 EQU {createList} (
		goto createList
	) else (
		echo.                                                                               >>"%log%"
		echo.------------------------------------------------------------------------------->>"%log%"
		echo.    Tool for efficient file copying                                            >>"%log%"
		echo.------------------------------------------------------------------------------->>"%log%"
		echo.                                                                               >>"%log%"
		echo.    Start: %date% %time%,                                                      >>"%log%"
		echo.    ERROR: Could not access function "%~1".                                    >>"%log%"
		echo.                                                                               >>"%log%"
		echo.------------------------------------------------------------------------------->>"%log%"
		
		echo.ERROR: Could not access function "%~1".
		pause
	)
goto :eof

:: This method starts the necessary variables for the use of the script.
::		@param - arguments = Arguments to evaluate.
:: void initValues(arguments);
:initValues
	set arg=%~1
	
	set arg=%arg:source:=%
	if "%~1" NEQ "%arg%" (
		set CONST_SOURCE=%arg%
	)
	
	set arg=%arg:destination:=%
	if "%~1" NEQ "%arg%" (
		set CONST_DESTINATION=%arg%
	)	
	
	set arg=%arg:custom:=%
	if "%~1" NEQ "%arg%" (
		set CONST_CUSTOM=%arg%
	)
	
	set arg=%arg:version:=%
	if "%~1" NEQ "%arg%" (
		set CONST_VERSION=%arg%
	)
goto :eof

:: This method copies the relative path of a file or folder.
::	@param - source = Source folder.
::	@param - value = path to validate.
:: void pathRelativeFolder(source, value);
:pathRelativeFolder
	set source=%~1
	set value=%~2
	call set dir=%%value:%source%=%%
	set dir=.%dir%
	
	echo.dir=%dir%>>"%catalog%"
goto :eof

:: This method copies the relative path of a file or folder.
::	@param - source = Source folder.
::	@param - value = path to validate.
:: void pathRelativeFile(source, value);
:pathRelativeFile
	set source=%~1
	set value=%~2
	call set file=%%value:%source%=%%
	set file=.%file%
	echo.file=%file%>>"%catalog%"
goto :eof

:: This method creates a catalog preserving the structure of the directories.
::	@param - source = Source folder.
:: void createCatalog(source);
:createCatalog
	set source=%~1
	
	echo.                                                                               >>"%log%"
	echo.    Start: %date% %time%,                                                      >>"%log%"
	echo.    A catalog is created preserving the structure of the directories.          >>"%log%"
	echo.                                                                               >>"%log%"
	
	echo.A catalog is created preserving the structure of the directories.
	
	echo.# A catalog of files is created>"%catalog%"
	echo.# Source: "%source%\">>"%catalog%"
	echo.# >>"%catalog%"
	echo.>>"%catalog%"
	echo.[path]>>"%catalog%"
	echo.dir=.\>>"%catalog%"
	
	for /f "tokens=*" %%a in ('dir /b /s /a:d "%source%"') do (
		call :pathRelativeFolder  "%source%" "%%a"
	)
	
	for /f "tokens=*" %%a in ('dir /b /s /a:-d "%source%"') do (
		call :pathRelativeFile "%source%" "%%a"
	)
goto :eof

:: This method creates folders in a target location.
::		@param - destination = Destination folder.
::		@param - name = Folder name.
:: void createFolder(destination, name);
:createFolder
	set destination=%~1
	set name=%~2
	set name=%name:.\=%
	set dir=%destination%\%name%
	
	echo.    Start: %date% %time%,                                                     >>"%log%"
	echo.    Action: Creating the folder %dir%.                                        >>"%log%"
	
	echo.Creating the folder %dir%.
	
	mkdir "%dir%"
goto :eof

:: This method copies the files preserving the structure.
::		@param - source = Source folder.
::		@param - destination = Destination folder.
::		@param - file = File name.
:: void copyFile(source, destination, file);
:copyFile
	set name=%~nx3
	set dir=%~3
	set dir=%dir:.\=%
	set source=%~1\%dir%
	call set source=%%source:%name%=%%\
	set source=%source:\\=%
	set destination=%~2\%dir%
	call set destination=%%destination:%name%=%%\
	set destination=%destination:\\=%
	
	set /a process+=1
	
	echo.    Start: %date% %time%,                                                      >>"%log%"
	echo.    Action: Copying the file %name%.                                           >>"%log%"
	
	echo.Copying the file %name%.
	
	if "%version%" EQU "5.2.3790" (
		robocopy /?>nul
		if %errorlevel% EQU 9009 (
			echo.Make sure you install Windows Server 2003 Resource Kit Tools and try again.
			pause
			goto :eof
		)
	)
	
	if exist "%source%\%name%" (
		set /a found+=1
		
		cd \
		cd /d "%source%"
	
		if "%version%" EQU "6.1.7601" (
			robocopy "%source%" "%destination%" "%name%" /mt:128 /njh /ns /np /ts /log+:"%log%"
		) else (
			robocopy "%source%" "%destination%" "%name%" /njh /ns /np /ts /log+:"%log%"
		)
	) else (
		echo.    Start: %date% %time%,                                                      >>"%log%"
		echo.    ERROR: The file %name% does not exist in source folder.                    >>"%log%"
		echo.                                                                               >>"%log%"
		echo.------------------------------------------------------------------------------->>"%log%"
		
		echo.ERROR: The file %name% does not exist in source folder.
		echo.
	)
goto :eof

:: This method creates a backup of the files and folders.
:: void createCopy();
:createCopy
	set backup=%CONST_DESTINATION%\Backups\%CONST_DATE%
	
	echo.                                                                               >>"%log%"
	echo.------------------------------------------------------------------------------->>"%log%"
	echo.    Tool for efficient file copying                                            >>"%log%"
	echo.------------------------------------------------------------------------------->>"%log%"
	echo.                                                                               >>"%log%"
	echo.    Start: %date% %time%,                                                      >>"%log%"
	echo.    Backup files and folders.                                                  >>"%log%"
	echo.                                                                               >>"%log%"
	
	echo.    Start: %date% %time%,                                                     >>"%log%"
	echo.    Action: Creating folder "Backup".                                          >>"%log%"
	
	mkdir "%backup%"
	
	echo.    Start: %date% %time%,                                                     >>"%log%"
	echo.    Action: Copying files starts.                                             >>"%log%"
	
	echo.Copying files starts.
	
	if "%version%" EQU "5.2.3790" (
		robocopy /?>nul
		if %errorlevel% EQU 9009 (
			echo.Make sure you install Windows Server 2003 Resource Kit Tools and try again.
			pause
			goto :eof
		)
	)
	
	cd \
	cd /d "%CONST_SOURCE%"
	
	if "%version%" EQU "6.1.7601" (
		robocopy "%CONST_SOURCE%" "%backup%" /e /mt:128 /tee /njh /ns /np /ts /log+:"%log%"
	) else (
		robocopy "%CONST_SOURCE%" "%backup%" /e /tee /njh /ns /np /ts /log+:"%log%"
	)
	
	if %ERRORLEVEL% EQU 0 (
		echo.    Enf: %date% %time%,                                                        >>"%log%"
		echo.    Action: The process has ended correctly.                                   >>"%log%"
		echo.The process has ended correctly.
	) else if %ERRORLEVEL% EQU 1 (
		echo.    Enf: %date% %time%,                                                        >>"%log%"
		echo.    Action: The process has ended correctly.                                   >>"%log%"
		echo.The process has ended correctly.
	) else (
		echo.    Enf: %date% %time%,                                                        >>"%log%"
		echo.    ERROR: An error %ERRORLEVEL% has occurred in the command.                  >>"%log%"
		echo.ERROR: An error %ERRORLEVEL% has occurred in the command.
	)
	
	pause
	
	echo.------------------------------------------------------------------------------->>"%log%"
goto :eof

:: This method copies the update files to the destination folder.
:: void patchFiles();
:patchFiles
	echo.                                                                               >>"%log%"
	echo.------------------------------------------------------------------------------->>"%log%"
	echo.    Tool for efficient file copying                                            >>"%log%"
	echo.------------------------------------------------------------------------------->>"%log%"
	echo.                                                                               >>"%log%"
	echo.    Start: %date% %time%,                                                      >>"%log%"
	echo.    The update files are copied to the destination folder       .              >>"%log%"
	echo.                                                                               >>"%log%"
	
	call :createCatalog "%CONST_SOURCE%"
	
	echo.    Start: %date% %time%,                                                     >>"%log%"
	echo.    Action: Folder creation starts.                                           >>"%log%"
	
	echo.Folder creation starts.
	
	if "%version%" EQU "5.2.3790" (
		robocopy /?>nul
		if %errorlevel% EQU 9009 (
			echo.Make sure you install Windows Server 2003 Resource Kit Tools and try again.
			pause
			goto :eof
		)
	)
	
	cd \
	cd /d "%CONST_SOURCE%"
	
	if "%version%" EQU "6.1.7601" (
		robocopy "%CONST_SOURCE%" "%CONST_DESTINATION%" /e /mt:128 /tee /njh /ns /np /ts /log+:"%log%"
	) else (
		robocopy "%CONST_SOURCE%" "%CONST_DESTINATION%" /e /tee /njh /ns /np /ts /log+:"%log%"
	)
	
	if %ERRORLEVEL% EQU 0 (
		echo.    Enf: %date% %time%,                                                        >>"%log%"
		echo.    Action: The process has ended correctly.                                   >>"%log%"
		echo.The process has ended correctly.
	) else if %ERRORLEVEL% EQU 1 (
		echo.    Enf: %date% %time%,                                                        >>"%log%"
		echo.    Action: The process has ended correctly.                                   >>"%log%"
		echo.The process has ended correctly.
	) else (
		echo.    Enf: %date% %time%,                                                        >>"%log%"
		echo.    ERROR: An error %ERRORLEVEL% has occurred in the command.                  >>"%log%"
		echo.ERROR: An error %ERRORLEVEL% has occurred in the command.
	)
	
	pause
	
	echo.------------------------------------------------------------------------------->>"%log%"
goto :eof

:: This method extracts custom files.
:: void extractCustomization();
:extractCustomization
	echo.                                                                               >>"%log%"
	echo.------------------------------------------------------------------------------->>"%log%"
	echo.    Tool for efficient file copying                                            >>"%log%"
	echo.------------------------------------------------------------------------------->>"%log%"
	echo.                                                                               >>"%log%"
	echo.    Start: %date% %time%,                                                      >>"%log%"
	echo.    Action: Folder creation starts.                                            >>"%log%"
	echo.                                                                               >>"%log%"
	
	call :createCatalog "%CONST_CUSTOM%"
	
	echo.    Start: %date% %time%,                                                      >>"%log%"
	echo.    Action: Folder creation starts.                                            >>"%log%"
	
	echo.Folder creation starts.
	
	if not exist "%CONST_DESTINATION%" (
		mkdir "%CONST_DESTINATION%"
	)
	
	for /f "tokens=2 delims==" %%a in ('findstr "dir" "%catalog%"') do (
		call :createFolder "%CONST_DESTINATION%" "%%a"
	)
	
	echo.    Start: %date% %time%,                                                     >>"%log%"
	echo.    Action: Copying files starts.                                             >>"%log%"
	
	echo.Copying files starts.
	
	set process=0
	set found=0
	
	for /f "tokens=2 delims==" %%a in ('findstr "file" "%catalog%"') do (
		call :copyFile "%CONST_SOURCE%" "%CONST_DESTINATION%" "%%a"
	)
	
	echo.Were processed %process% file(s).
	echo.Were found %found% coincidences.
	pause
	
	echo.------------------------------------------------------------------------------->>"%log%"
goto :eof

:: This method creates a list of files and folders.
:: void createList();
:createList
	set list=%~dp0list.txt
	
	echo.Start: %date% %time%,>>"%list%"
	echo.Source: "%CONST_SOURCE%\">>"%list%"
	echo.>>"%list%"
	dir /s /a:-d "%CONST_SOURCE%">>"%list%"
	
	echo.
	echo.A list of files and folders has been created in %list%.
	pause
goto :eof
