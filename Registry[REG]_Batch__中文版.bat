set "params=%*" && cd /d "%CD%" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/C cd ""%CD%"" && %~s0 %params%", "", "runas", 1 >>"%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )
@ECHO OFF
TITLE Registry[REG]_Batch__���媩(Administrator)

GOTO MAIN

:MAIN
CLS
ECHO.
ECHO.
ECHO ==============================================================
ECHO                           ��ܥ\��
ECHO ==============================================================
ECHO.
ECHO --------------------------------------------------------------
ECHO [1] �޲z���X
ECHO [2] �޲z�n����
ECHO --------------------------------------------------------------
ECHO.
CHOICE /C 21 /N /M "��ܥ\��[1~2]: "
IF ERRORLEVEL 2 (
	GOTO Switch_Registry_Keys
)ELSE (
	GOTO Switch_Registry_Value
)


::REM ===============================================================================================================================
::REM =========================================================Registry_Keys=========================================================
::REM ===============================================================================================================================


:Switch_Registry_Keys
CLS
ECHO.
ECHO =======================================================
ECHO.
CHOICE /C 4321 /N /M "[1]�s�W���X [2]�R�����X [3]���s�R�W���X [4]��^���: "
IF ERRORLEVEL 4 (
	GOTO Add-Registry_Keys-Ask
)ELSE IF ERRORLEVEL 3 (
	GOTO Delete-Registry_Keys-Ask
)ELSE IF ERRORLEVEL 2 (
	GOTO Rename-Registry_Keys-Ask
)ELSE IF ERRORLEVEL 1 (
	GOTO MAIN
)


::REM =======================================Add-Registry_Keys=======================================


:Add-Registry_Keys-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
SET "Reg_Keys="
SET /P Reg_Keys="�п�J�n�s�W�����X���|[B/b:Back Menu]: "
IF NOT DEFINED Reg_Keys (
	ECHO.
	ECHO �п�J���X���|!
	ECHO.
	PAUSE
	GOTO Add-Registry_Keys-Ask
)ELSE IF /I "%Reg_Keys%" EQU "B" (
	GOTO Switch_Registry_Keys
)
ECHO.

CALL :Is_Exist_Registry_Keys REM �T�{���|�O�_�s�b
IF %ERRORLEVEL% NEQ 0 (
	REM ���s�b�A�إ�!
	CALL :Add-Registry_Keys-Add
)ELSE (
	REM �s�b�A�߰��л\!
	CALL :Add-Registry_Keys-OverWrite-Ask
)
ECHO. && PAUSE && GOTO Add-Registry_Keys-Ask

:Add-Registry_Keys-Add
ECHO.
ECHO �Ыؤ�...
ECHO.
powershell -command New-Item -Path Registry::'%Reg_Keys%'
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO �Ыإ��ѡA�п�J���T���|!
)ELSE (
	ECHO. && ECHO �Ыئ��\!
)
EXIT /B

:Add-Registry_Keys-OverWrite-Ask
ECHO.
CHOICE /C NY /N /M "�w���ۦP���X�s�b! �O�_�л\?[Y/N]: "
IF ERRORLEVEL 2 (
	CALL :Add-Registry_Keys-OverWrite
)ELSE IF ERRORLEVEL 1 (
	ECHO.
	ECHO �w�����л\!
)
EXIT /B

:Add-Registry_Keys-OverWrite
ECHO.
ECHO �л\��...
ECHO.
powershell -command New-Item -Path Registry::'%Reg_Keys%' -Force
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO �л\����!
)ELSE (
	ECHO. && ECHO �л\���\!
)
EXIT /B


::REM =======================================Delete-Registry_Keys====================================


:Delete-Registry_Keys-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
SET "Reg_Keys="
SET /P Reg_Keys="�п�J�n�R�������X���|[B/b:Back Menu]: "
IF NOT DEFINED Reg_Keys (
	ECHO. 
	ECHO �п�J���X���|!
	ECHO.
	PAUSE
	GOTO Delete-Registry_Keys-Ask
)ELSE IF /I "%Reg_Keys%" EQU "B" (
	GOTO Switch_Registry_Keys
)
ECHO.

CALL :Is_Exist_Registry_Keys REM �T�{���|�O�_�s�b
IF %ERRORLEVEL% NEQ 0 (
	REM ���s�b�A���ݧR��!
	ECHO.
	ECHO ���|���s�b�A�L���R��!
)ELSE (
	REM �s�b�A�i�R��!
	CALL :Delete-Registry_Keys-Del-Ask
)
ECHO. && PAUSE && GOTO Delete-Registry_Keys-Ask

:Delete-Registry_Keys-Del-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
CALL :Is_Exist_Registry_SubKeys
IF %Sum% EQU 0 (
	REM ���s�b�l���X�A�i�R��!
	ECHO.
	ECHO �w�T�{���X�U�L�l���X�s�b!
	ECHO.
)ELSE (
	REM �s�b�l���X�A�T�{�O�_�R��!
	CALL :Delete-Registry_SubKeys-Del-Ask
	GOTO Delete-Registry_Keys-Del-Ask
)
ECHO.
CALL :Delete-Registry_Keys-Del-Entries-Ask
EXIT /B

:Delete-Registry_Keys-Del-Entries-Ask
ECHO.
CALL :Is_Exist_Registry_Keys_Value
IF %Sum2% EQU 0 (
	REM ���s�b���X���ءA�i�R��!
	ECHO.
	CHOICE /C NY /N /M "�w�T�{���X�U�L���ئs�b! �O�_�i��R��?[Y/N]: "
	IF ERRORLEVEL 2 (
		ECHO.
		CALL :Delete-Registry_Keys_And_SubKeys-Del
	ELSE IF ERRORLEVEL 1 (
		GOTO Delete-Registry_Keys-Ask
	)
)ELSE (
	REM �s�b���X���ءA�T�{�O�_�R��!
	ECHO.
	CALL :Delete-Registry_Vulues-Del-Ask
	GOTO Delete-Registry_Keys-Del-Entries-Ask
)
ECHO.
pause
GOTO Delete-Registry_Keys-Ask
EXIT /B

:Delete-Registry_Vulues-Del-Ask
CLS
ECHO.
ECHO ����w���X: %Reg_Keys%
ECHO.
CALL :Show_Registry_Keys_Value
CHOICE /C NY /N /M "���w���X�U�s�b����! �O�_���R�����إ\��?[Y/N]: "
IF ERRORLEVEL 2 (
	SET Reg_Value_Path="%Reg_Keys%"
	CALL :Del-Registry_Vulue-Name-Ask
	GOTO Delete-Registry_Keys-Del-Ask
)ELSE IF ERRORLEVEL 1 (
	ECHO.
	CHOICE /C NY /N /M "�T�{���R������! �O�_�i��R�����X?[Y/N]: "
	IF ERRORLEVEL 2 (
		ECHO.
		CALL :Delete-Registry_Keys_And_SubKeys-Del
	ELSE IF ERRORLEVEL 1 (
		echo 123
		pause
		GOTO Delete-Registry_Keys-Ask
	)
)
ECHO.
pause
EXIT /B

:Delete-Registry_Vulues-Del-Ask-B
CLS
CALL :Show_Registry_Keys_Value-B
CHOICE /C NY /N /M "�l���X�U�s�b����! �O�_���R���@�~?[Y/N]: "
IF ERRORLEVEL 2 (
	SET Reg_Value_Path="%Reg_SubKeys%"
	CALL :Del-Registry_Vulue-Name-Ask
	ECHO.
	PAUSE
	GOTO Delete-Registry_Keys-Del-Ask
)ELSE IF ERRORLEVEL 1 (
	ECHO.
	CHOICE /C NY /N /M "�T�{���R������! �O�_�i��R���l���X?[Y/N]: "
	IF ERRORLEVEL 2 (
		ECHO.
		CALL :Delete-Registry_Keys_And_SubKeys-Del-B
	ELSE IF ERRORLEVEL 1 (
		ECHO.
		ECHO �w�����R��!
		ECHO.
		PAUSE
	)
)
EXIT /B

:Delete-Registry_SubKeys-Del-Ask
CLS
ECHO.
ECHO ����w���X: %Reg_Keys%
ECHO.
CALL :ALL_Registry_SubKeys
CHOICE /C 4321 /N /M "���w���X�U�s�b��L�l���X! [1]�R�����w�l���X [2]�R���Ҧ��l���X[���]�A���w���X] [3]�R���Ҧ��l���X[�]�A���w���X] [4]�����ާ@: "
IF ERRORLEVEL 4 (
	CALL :Delete-Registry_Some_SubKeys-Del
)ELSE IF ERRORLEVEL 3 (
	CALL :Delete-Registry_All_SubKeys-Del
)ELSE IF ERRORLEVEL 2 (
	CALL :Delete-Registry_Keys_And_SubKeys-Del
)ELSE IF ERRORLEVEL 1 (
	ECHO.
	ECHO �w�����R���l���X!
	ECHO.
	PAUSE
	GOTO Delete-Registry_Keys-Del-Entries-Ask
)
EXIT /B

:Delete-Registry_SubKeys-Del-Ask-B
CLS
ECHO.
ECHO ����w���X: %Reg_Keys%
ECHO.
ECHO ���w�R�����l���X: %Reg_SubKeys%
ECHO.
CALL :ALL_Registry_SubKeys-B
CHOICE /C 4321 /N /M "���w�l���X�U�s�b��L�l���X! [1]�R�����w�l���X [2]�R���Ҧ��l���X[���]�A���w���X] [3]�R���Ҧ��l���X[�]�A���w���X] [4]�����ާ@: "
IF ERRORLEVEL 4 (
	CALL :Delete-Registry_Some_SubKeys-Del-B
)ELSE IF ERRORLEVEL 3 (
	CALL :Delete-Registry_All_SubKeys-Del-B
)ELSE IF ERRORLEVEL 2 (
	CALL :Delete-Registry_Keys_And_SubKeys-Del-B
)ELSE IF ERRORLEVEL 1 (
	ECHO.
	ECHO �w�����ާ@!
)
EXIT /B

:Delete-Registry_Some_SubKeys-Del
CLS
ECHO.
ECHO =======================================================
CALL :ALL_Registry_SubKeys
SET "Reg_SubKeys="
SET /P Reg_SubKeys="�п�J�n�R�����l���X���|[B/b:Back Menu]: "
IF NOT DEFINED Reg_SubKeys (
	ECHO.
	ECHO �п�J�l���X�W��!
	ECHO.
	PAUSE
	GOTO Delete-Registry_Some_SubKeys-Del
)ELSE IF /I "%Reg_SubKeys%" EQU "B" (
	GOTO Delete-Registry_SubKeys-Del-Ask-B
)
ECHO.
CALL :Is_Exist_Registry_Keys-B REM �T�{��J���l���X���|�O�_���T
IF %ERRORLEVEL% NEQ 0 (
	REM ���s�b�A���ݧR��!
	ECHO.
	ECHO ���X�U�L���l���X�A�Э��s��J!
	ECHO.
	PAUSE
	GOTO Delete-Registry_Some_SubKeys-Del
)
ECHO.
CALL :Delete-Registry_Some_SubKeys-Del-Ask
EXIT /B

:Delete-Registry_Some_SubKeys-Del-B
CLS
ECHO.
ECHO =======================================================
CALL :ALL_Registry_SubKeys-B
SET "Reg_SubKeys="
SET /P Reg_SubKeys="�п�J�n�R�����l���X���|[B/b:Back Menu]: "
IF NOT DEFINED Reg_SubKeys (
	ECHO.
	ECHO �п�J�l���X�W��!
	ECHO.
	PAUSE
	GOTO Delete-Registry_Some_SubKeys-Del-B
)ELSE IF /I "%Reg_SubKeys%" EQU "B" (
	GOTO Delete-Registry_SubKeys-Del-Ask-B
)
ECHO.
CALL :Is_Exist_Registry_Keys-B REM �T�{��J���l���X���|�O�_���T
IF %ERRORLEVEL% NEQ 0 (
	REM ���s�b�A���ݧR��!
	ECHO.
	ECHO �l���X�U�L���l���X�A�Э��s��J!
	ECHO.
	PAUSE
	GOTO Delete-Registry_Some_SubKeys-Del-B
)
ECHO.
CALL :Delete-Registry_Some_SubKeys-Del-Ask
EXIT /B

:Delete-Registry_Some_SubKeys-Del-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
CALL :Is_Exist_Registry_SubKeys
IF %Sum% EQU 0 (
	REM ���s�b�l���X�A�i�R��!
	ECHO.
	ECHO �w�T�{���X�U�L�l���X�s�b!
	ECHO.
)ELSE (
	REM �s�b�l���X�A�T�{�O�_�R��!
	CALL :Delete-Registry_SubKeys-Del-Ask-B
	GOTO Delete-Registry_Some_SubKeys-Del-Ask
)
ECHO.
CALL :Delete-Registry_Some_SubKeys-Del-Entries-Ask
EXIT /B

:Delete-Registry_Some_SubKeys-Del-Entries-Ask
ECHO.
CALL :Is_Exist_Registry_Keys_Value
IF %Sum2% EQU 0 (
	REM ���s�b���X���ءA�i�R��!
	ECHO.
	CHOICE /C NY /N /M "�w�T�{���X�U�L���ئs�b! �O�_�i��R���l���X?[Y/N]: "
	IF ERRORLEVEL 2 (
		ECHO.
		CALL :Delete-Registry_Keys_And_SubKeys-Del-B
	ELSE IF ERRORLEVEL 1 (
		ECHO.
		ECHO �w�����R��!
	)
)ELSE (
	REM �s�b���X���ءA�T�{�O�_�R��!
	ECHO.
	CALL :Delete-Registry_Vulues-Del-Ask-B
	GOTO Delete-Registry_Some_SubKeys-Del-Entries-Ask
)
ECHO.
pause
EXIT /B

:Delete-Registry_All_SubKeys-Del
CLS
ECHO.
ECHO =======================================================
CALL :ALL_Registry_SubKeys
ECHO �R���Ҧ��l���X��...
ECHO.
powershell -command Remove-Item -Path Registry::'%Reg_Keys%\*' -Recurse
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO �R������!
)ELSE (
	ECHO. && ECHO �R�����\!
)
EXIT /B

:Delete-Registry_All_SubKeys-Del-B
CLS
ECHO.
ECHO =======================================================
CALL :ALL_Registry_SubKeys-B
ECHO �R���Ҧ��l���X��...
ECHO.
powershell -command Remove-Item -Path Registry::'%Reg_SubKeys%\*' -Recurse
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO �R������!
)ELSE (
	ECHO. && ECHO �R�����\!
)
EXIT /B

:Delete-Registry_Keys_And_SubKeys-Del
CLS
ECHO.
ECHO =======================================================
ECHO �R�����X��...
ECHO.
powershell -command Remove-Item -Path Registry::'%Reg_Keys%' -Recurse
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO �R������!
)ELSE (
	ECHO. && ECHO �R�����\!
)
EXIT /B

:Delete-Registry_Keys_And_SubKeys-Del-B
CLS
ECHO.
ECHO =======================================================
ECHO �R���l���X��...
ECHO.
powershell -command Remove-Item -Path Registry::'%Reg_SubKeys%' -Recurse
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO �R������!
)ELSE (
	ECHO. && ECHO �R�����\!
)
EXIT /B

::REM =======================================Rename-Registry_Keys====================================


:Rename-Registry_Keys-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
SET "Reg_Keys="
SET /P Reg_Keys="�п�J�n���s�R�W�����X���|[B/b:Back Menu]: "
IF NOT DEFINED Reg_Keys (
	ECHO. 
	ECHO �п�J���X���|!
	ECHO.
	PAUSE
	GOTO Rename-Registry_Keys-Ask
)ELSE IF /I "%Reg_Keys%" EQU "B" (
	GOTO Switch_Registry_Keys
)
ECHO.

CALL :Is_Exist_Registry_Keys REM �T�{���X���|�O�_�s�b
IF %ERRORLEVEL% NEQ 0 (
	REM ���s�b�A����ާ@!
	ECHO.
	ECHO ���s�b���X���|�A�Э��s��J!
)ELSE (
	REM �s�b�A�~�����ާ@!
	CALL :Rename-Registry_Keys-NewName-Ask
)
ECHO. && PAUSE && GOTO Rename-Registry_Keys-Ask

:Rename-Registry_Keys-NewName-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
CALL :Registry_Keys
SET "Reg_keys-NewName="
SET /P Reg_keys-NewName="�п�J���᪺���X�s�W��[��JE ��^]: "
IF NOT DEFINED Reg_keys-NewName (
	ECHO. && ECHO �п�J���X�s�W��! && ECHO. && PAUSE && GOTO Rename-Registry_Keys-NewName-Ask
)ELSE IF /I "%Reg_keys-NewName%" EQU "E" (
	GOTO Rename-Registry_Keys-Ask
)
CALL :Is_Exist_Registry_Other_Keys
IF %ERRORLEVEL% NEQ 0 (
	CALL :Rename-Registry_Keys
)ELSE (
	ECHO.
	ECHO �w���ۦP�W�١A�Э��s����L�W��
	ECHO.
	PAUSE
	GOTO Rename-Registry_Keys-NewName-Ask
)
EXIT /B

:Rename-Registry_Keys
ECHO.
ECHO =======================================================
ECHO.
ECHO ���s�R�W��...
ECHO.
powershell -command Rename-Item -Path Registry::"%Reg_Keys%" -NewName '"%Reg_keys-NewName%"' -passthru
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO ��異��!
)ELSE (
	ECHO. && ECHO ��令�\!
)
EXIT /B


::REM =======================================Module-Registry_Keys====================================


REM �T�{���|�O�_�s�b
:Is_Exist_Registry_Keys
powershell -command Get-item -Path Registry::'%Reg_Keys%' > nul 2>&1
EXIT /B

REM �T�{���|�O�_�s�b(�l���X�ܼƥ�)
:Is_Exist_Registry_Keys-B
powershell -command Get-item -Path Registry::'%Reg_SubKeys%' > nul 2>&1
EXIT /B

REM �T�{�l���X�O�_�s�b
:Is_Exist_Registry_SubKeys
for /F "delims=" %%i IN ('"powershell -command (Get-ChildItem -Path Registry::'%Reg_Keys%' -Recurse).length"') do SET Sum=%%i > nul 2>&1
EXIT /B

REM �T�{�l���X�O�_�s�b(�l���X�ܼƥ�)
:Is_Exist_Registry_SubKeys-B
for /F "delims=" %%i IN ('"powershell -command (Get-ChildItem -Path Registry::'%Reg_SubKeys%' -Recurse).length"') do SET Sum=%%i > nul 2>&1
EXIT /B

REM �T�{���X���O�_�s�b���ح�
:Is_Exist_Registry_Keys_Value
for /F "delims=" %%k IN ('"powershell -command (reg query "%Reg_Keys%" /s).length"') do SET Sum2=%%k > nul 2>&1
EXIT /B

REM �T�{���X���O�_�s�b���ح�(�l���X�ܼƥ�)
:Is_Exist_Registry_Keys_Value-B
for /F "delims=" %%k IN ('"powershell -command (reg query "%Reg_SubKeys%" /s).length"') do SET Sum2=%%k > nul 2>&1
EXIT /B

REM �T�{���s�R�W�᪺���|�W�٬O�_�Ĭ�
:Is_Exist_Registry_Other_Keys
REM ���o���|
for /F %%a in ("%Reg_Keys%") do SET path1=%%~dpa > nul 2>&1
REM �h��REG�H�~�����|
for /F "tokens=* delims=%cd%" %%b in ("%path1%") do SET Reg_keys_Path=H%%b > nul 2>&1
REM �h���Ů�
SET "Reg_keys_Path=%Reg_keys_Path:  =%"
powershell -command Get-item -Path Registry::'%Reg_keys_Path%%Reg_keys-NewName%' > nul 2>&1
EXIT /B

REM ��ܩҦ��l���X
:ALL_Registry_SubKeys
ECHO.
ECHO ���w���X�U���Ҧ��l���X
ECHO -----------------------------------------
powershell -command Get-ChildItem -Path Registry::'%Reg_Keys%' -Recurse ^| Select-Object Name
ECHO �l���X�ƶq:%Sum%
ECHO -----------------------------------------
ECHO.
EXIT /B

REM ��ܩҦ��l���X(�l���X�ܼƥ�)
:ALL_Registry_SubKeys-B
ECHO.
ECHO ���w�l���X�U���Ҧ��l���X
ECHO -----------------------------------------
powershell -command Get-ChildItem -Path Registry::'%Reg_SubKeys%' -Recurse ^| Select-Object Name
ECHO �l���X�ƶq:%Sum%
ECHO -----------------------------------------
ECHO.
EXIT /B

REM ��ܾ��X�����ح�
:Show_Registry_Keys_Value
ECHO.
IF %Sum2% NEQ 0 (
	ECHO --------------------------------------------------
	ECHO ���X�������ح�!
	ECHO.
	powershell -command Get-ItemProperty -Path Registry::'%Reg_Keys%'
	ECHO --------------------------------------------------
)
EXIT /B

REM ��ܾ��X�����ح�(�l���X�ܼƥ�)
:Show_Registry_Keys_Value-B
ECHO.
IF %Sum2% NEQ 0 (
	ECHO --------------------------------------------------
	ECHO �l���X�������ح�!
	ECHO.
	powershell -command Get-ItemProperty -Path Registry::'%Reg_SubKeys%'
	ECHO --------------------------------------------------
)
EXIT /B

REM ��ܫ��w���X
:Registry_Keys
ECHO.
ECHO ���w�����X
ECHO -----------------------------------------
powershell -command Get-Item -Path Registry::'%Reg_Keys%'
ECHO -----------------------------------------
ECHO.
EXIT /B


::REM ===============================================================================================================================
::REM =========================================================Registry Value========================================================
::REM ===============================================================================================================================


:Switch_Registry_Value
CLS
ECHO.
ECHO =======================================================
ECHO.
CHOICE /C 54321 /N /M "[1]�s�W���X���� [2]�R�����X���� [3]���s�R�W���X���� [4]�����X���ح� [5]��^���: "
IF ERRORLEVEL 5 (
	GOTO Add-Registry_Vulue-Ask
)ELSE IF ERRORLEVEL 4 (
	GOTO Delete-Registry_Vulue-Ask
)ELSE IF ERRORLEVEL 3 (
	GOTO Rename-Registry_Vulue-Ask
)ELSE IF ERRORLEVEL 2 (
	GOTO Change-Registry_Vulue-Ask
)ELSE IF ERRORLEVEL 1 (
	GOTO MAIN
)


::REM =======================================Add-Registry_Vulue======================================


:Add-Registry_Vulue-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
SET "Reg_Value_Path="
SET /P Reg_Value_Path="�п�J�n�s�W�����X���ظ��|[B/b:Back Menu]: "
IF NOT DEFINED Reg_Value_Path (
	ECHO.
	ECHO �п�J���X���ظ��|!
	ECHO.
	PAUSE 
	GOTO Add-Registry_Vulue-Ask
)ELSE IF /I "%Reg_Value_Path%" EQU "B" (
	GOTO Switch_Registry_Value
)
ECHO.

CALL :Is_Exist_Registry_Value_Path REM �T�{���X���|�O�_�s�b
IF %ERRORLEVEL% NEQ 0 (
	REM ���s�b�A����ާ@!
	ECHO.
	ECHO ���s�b���X���|�A�Э��s��J!
	ECHO.
	PAUSE
	GOTO Add-Registry_Vulue-Ask
)ELSE (
	REM �s�b�A�~�����ާ@!
	CALL :Add-Registry_Vulue-Name-Ask
)
ECHO. && PAUSE && GOTO Add-Registry_Vulue-Ask

:Add-Registry_Vulue-Name-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
CALL :ALL_Registry_Value
SET "Reg_Vulue-Name="
SET /P Reg_Vulue-Name="�п�J�n�s�W�����X���ئW��: "
IF NOT DEFINED Reg_Vulue-Name (ECHO. && ECHO �п�J���X���ئW��! && ECHO. && PAUSE && GOTO Add-Registry_Vulue-Name-Ask)
CALL :Is_Exist_Registry_Value
IF %ERRORLEVEL% NEQ 0 (CALL :Add-Registry_Vulue-Type-Ask)ELSE (ECHO. && ECHO ���ئW�w�s�b�A�Э��s��J! && ECHO. && PAUSE && GOTO Add-Registry_Vulue-Name-Ask)
EXIT /B

:Add-Registry_Vulue-Type-Ask
ECHO.
ECHO =======================================================
ECHO.
CHOICE /C 7654321 /N /M "�п�ܶ�������[1]String [2]Binary [3]DWord [4]QWord [5]MultiString [6]ExpandString [7]Back: "
IF ERRORLEVEL 7 (
	SET Vulue_Type=String
)ELSE IF ERRORLEVEL 6 (
	SET Vulue_Type=Binary
)ELSE IF ERRORLEVEL 5 (
	SET Vulue_Type=DWord
)ELSE IF ERRORLEVEL 4 (
	SET Vulue_Type=QWord
)ELSE IF ERRORLEVEL 3 (
	SET Vulue_Type=MultiString
)ELSE IF ERRORLEVEL 2 (
	SET Vulue_Type=ExpandString
)ELSE IF ERRORLEVEL 1 (
	GOTO Add-Registry_Vulue-Name-Ask
)
CALL :Add-Registry_Vulue-Vulues-Ask
EXIT /B

:Add-Registry_Vulue-Vulues-Ask
ECHO.
ECHO =======================================================
ECHO.
SET "Reg_Vulue-Vulues="
SET /P Reg_Vulue-Vulues="�п�J���ؤ��e��: "
IF NOT DEFINED Reg_Vulue-Vulues (
	ECHO.
	ECHO �п�J���ح�!
	ECHO.
	PAUSE
	GOTO Add-Registry_Vulue-Vulues-Ask
)
CALL :Add-Registry_Vulue
EXIT /B

:Add-Registry_Vulue
ECHO.
ECHO =======================================================
ECHO.
ECHO �Ыؤ�...
powershell -command New-ItemProperty -Path Registry::"%Reg_Value_Path%" -Name '"%Reg_Vulue-Name%"' -PropertyType "%Vulue_Type%" -Value '"%Reg_Vulue-Vulues%"'
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO �Ыإ���!
)ELSE (
	ECHO. && ECHO �Ыئ��\!
)
EXIT /B


::REM =======================================Delete-Registry_Vulue===================================


:Delete-Registry_Vulue-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
SET "Reg_Value_Path="
SET /P Reg_Value_Path="�п�J�n�R�������X���ظ��|[B/b:Back Menu]: "
IF NOT DEFINED Reg_Value_Path (
	ECHO.
	ECHO �п�J���X���ظ��|!
	ECHO.
	PAUSE 
	GOTO Delete-Registry_Vulue-Ask
)ELSE IF /I "%Reg_Value_Path%" EQU "B" (
	GOTO Switch_Registry_Value
)
ECHO.

CALL :Is_Exist_Registry_Value_Path REM �T�{���X���|�O�_�s�b
IF %ERRORLEVEL% NEQ 0 (
	REM ���s�b�A����ާ@!
	ECHO.
	ECHO ���s�b���X���|�A�Э��s��J!
)ELSE (
	REM �s�b�A�~�����ާ@!
	CALL :Del-Registry_Vulue-Name-Ask
)
ECHO. && PAUSE && GOTO Delete-Registry_Vulue-Ask

:Del-Registry_Vulue-Name-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
CALL :ALL_Registry_Value
SET "Reg_Vulue-Name="
SET /P Reg_Vulue-Name="�п�J�n�R�������X���ئW��[��JB ��^]: "
IF NOT DEFINED Reg_Vulue-Name (
	ECHO. && ECHO �п�J���X���ئW��! && ECHO. && PAUSE && GOTO Del-Registry_Vulue-Name-Ask
)ELSE IF /I "%Reg_Vulue-Name%" EQU "B" (
	GOTO Delete-Registry_Vulue-Ask
)
CALL :Is_Exist_Registry_Value
IF %ERRORLEVEL% NEQ 0 (ECHO. && ECHO ���ئW���s�b�A�Э��s��J! && ECHO. && PAUSE && GOTO Del-Registry_Vulue-Name-Ask)ELSE (CALL :Del-Registry_Vulue)
EXIT /B

:Del-Registry_Vulue
ECHO.
ECHO =======================================================
ECHO.
ECHO �R����...
powershell -command Remove-ItemProperty -Path Registry::"%Reg_Value_Path%" -Name '"%Reg_Vulue-Name%"'
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO �R������!
)ELSE (
	ECHO. && ECHO �R�����\!
)
EXIT /B


::REM =======================================Rename-Registry_Vulue===================================


:Rename-Registry_Vulue-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
SET "Reg_Value_Path="
SET /P Reg_Value_Path="�п�J�n���s�R�W�����X���ظ��|[B/b:Back Menu]: "
IF NOT DEFINED Reg_Value_Path (
	ECHO.
	ECHO �п�J���X���ظ��|!
	ECHO.
	PAUSE 
	GOTO Rename-Registry_Vulue-Ask
)ELSE IF /I "%Reg_Value_Path%" EQU "B" (
	GOTO Switch_Registry_Value
)
ECHO.

CALL :Is_Exist_Registry_Value_Path REM �T�{���X���|�O�_�s�b
IF %ERRORLEVEL% NEQ 0 (
	REM ���s�b�A����ާ@!
	ECHO.
	ECHO ���s�b���X���|�A�Э��s��J!
)ELSE (
	REM �s�b�A�~�����ާ@!
	CALL :Rename-Registry_Vulue-Name-Ask
)
ECHO. && PAUSE && GOTO Rename-Registry_Vulue-Ask

:Rename-Registry_Vulue-Name-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
CALL :ALL_Registry_Value
SET "Reg_Vulue-Name="
SET /P Reg_Vulue-Name="�п�J�n���s�R�W�����X���ئW��[��JE ��^]: "
IF NOT DEFINED Reg_Vulue-Name (
	ECHO. && ECHO �п�J�s���X���ئW��! && ECHO. && PAUSE && GOTO Rename-Registry_Vulue-Name-Ask
)ELSE IF /I "%Reg_Vulue-Name%" EQU "E" (
	GOTO Rename-Registry_Vulue-Ask
)
CALL :Is_Exist_Registry_Value
IF %ERRORLEVEL% NEQ 0 (ECHO. && ECHO ���ئW���s�b�A�Э��s��J! && ECHO. && PAUSE && GOTO Rename-Registry_Vulue-Name-Ask)ELSE (CALL :Rename-Registry_Vulue-NewName-Ask)
EXIT /B

:Rename-Registry_Vulue-NewName-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
ECHO ��ܪ����X����: "%Reg_Vulue-Name%"
ECHO.
SET "Reg_Vulue-NewName="
SET /P Reg_Vulue-NewName="�п�J�s�������X���ئW��[��JE ��^]: "
IF NOT DEFINED Reg_Vulue-NewName (
	ECHO. && ECHO �п�J�s���X���ئW��! && ECHO. && PAUSE && GOTO Rename-Registry_Vulue-NewName-Ask
)ELSE IF /I "%Reg_Vulue-NewName%" EQU "E" (
	GOTO Rename-Registry_Vulue-Name-Ask
)
CALL :Is_Exist_Registry_New_Entries
IF %ERRORLEVEL% NEQ 0 (
	CALL :Rename-Registry_Vulue
)ELSE (
	ECHO. && ECHO ���ئW�w�s�b�A�Э��s��J! && ECHO. && PAUSE && GOTO Rename-Registry_Vulue-Name-Ask
)
EXIT /B

:Rename-Registry_Vulue
ECHO.
ECHO =======================================================
ECHO.
ECHO ���s�R�W��...
ECHO.
powershell -command Rename-ItemProperty -Path Registry::"%Reg_Value_Path%" -Name '"%Reg_Vulue-Name%"' -NewName '"%Reg_Vulue-NewName%"' -passthru
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO ��異��!
)ELSE (
	ECHO. && ECHO ��令�\!
)
EXIT /B


::REM =======================================Change-Registry_Vulue===================================


:Change-Registry_Vulue-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
SET "Reg_Value_Path="
SET /P Reg_Value_Path="�п�J�n��諸���X���حȸ��|[B/b:Back Menu]: "
IF NOT DEFINED Reg_Value_Path (
	ECHO.
	ECHO �п�J���X���ظ��|!
	ECHO.
	PAUSE 
	GOTO Change-Registry_Vulue-Ask
)ELSE IF /I "%Reg_Value_Path%" EQU "B" (
	GOTO Switch_Registry_Value
)
ECHO.

CALL :Is_Exist_Registry_Value_Path REM �T�{���X���|�O�_�s�b
IF %ERRORLEVEL% NEQ 0 (
	REM ���s�b�A����ާ@!
	ECHO.
	ECHO ���s�b���X���|�A�Э��s��J!
)ELSE (
	REM �s�b�A�~�����ާ@!
	CALL :Change-Registry_Vulue-Name-Ask
)
ECHO. && PAUSE && GOTO Change-Registry_Vulue-Ask

:Change-Registry_Vulue-Name-Ask
CLS
ECHO.
ECHO =======================================================
ECHO.
CALL :ALL_Registry_Value
SET "Reg_Vulue-Name="
SET /P Reg_Vulue-Name="�п�J�n��諸���X���ئW��[��JE ��^]: "
IF NOT DEFINED Reg_Vulue-Name (
	ECHO.
	ECHO �п�J���X���ئW��!
	ECHO.
	PAUSE
	GOTO Change-Registry_Vulue-Name-Ask
)ELSE IF /I "%Reg_Vulue-Name%" EQU "E" (
	GOTO Change-Registry_Vulue-Ask
)

CALL :Is_Exist_Registry_Value
IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO ���ئW���s�b�A�Э��s��J!
	ECHO.
	PAUSE
	GOTO Change-Registry_Vulue-Name-Ask
)ELSE (
	CALL :Change-Registry_Vulue-NewValue-Ask
)
EXIT /B

:Change-Registry_Vulue-NewValue-Ask
ECHO.
ECHO =======================================================
ECHO.
SET "Reg_Vulue-NewValue="
SET /P Reg_Vulue-NewValue="�п�J�s�������ح�[��JE ��^]: "
IF NOT DEFINED Reg_Vulue-NewValue (
	ECHO.
	ECHO �п�J�s���ح�!
	ECHO.
	PAUSE
	GOTO Change-Registry_Vulue-NewValue-Ask
)ELSE IF /I "%Reg_Vulue-NewValue%" EQU "E" (
	GOTO Change-Registry_Vulue-Name-Ask
)
CALL :Change-Registry_Vulue
EXIT /B

:Change-Registry_Vulue
ECHO.
ECHO =======================================================
ECHO.
ECHO ��襤...
ECHO.
powershell -command Set-ItemProperty -Path Registry::"%Reg_Value_Path%" -Name '"%Reg_Vulue-Name%"' -Value '"%Reg_Vulue-NewValue%"' -passthru
IF %ERRORLEVEL% NEQ 0 (
	ECHO. && ECHO ��異��!
)ELSE (
	ECHO. && ECHO ��令�\!
)
EXIT /B


::REM =======================================Module-Registry_Vulue===================================


REM �T�{���ظ��|�O�_�s�b
:Is_Exist_Registry_Value_Path
powershell -command Get-item -Path Registry::'%Reg_Value_Path%' > nul 2>&1
EXIT /B

REM �T�{���جO�_�s�b
:Is_Exist_Registry_Value
powershell -command Get-ItemProperty -Path Registry::'%Reg_Value_Path%' -name '"%Reg_Vulue-Name%"' ^| findstr '"%Reg_Vulue-Name%"' > nul 2>&1
EXIT /B

REM �T�{���s�R�W�᪺���ئW�٬O�_�Ĭ�
:Is_Exist_Registry_New_Entries
powershell -command Get-ItemProperty -Path Registry::'%Reg_Value_Path%' -name '"%Reg_Vulue-NewName%"' ^| findstr '"%Reg_Vulue-NewName%"' > nul 2>&1
EXIT /B

:ALL_Registry_Value
ECHO.
ECHO ���X�U���Ҧ�����[�p�S����ܧY�L���ئs�b!]
ECHO -----------------------------------------
powershell -command Get-ItemProperty -Path Registry::'%Reg_Value_Path%'
ECHO -----------------------------------------
ECHO.
EXIT /B