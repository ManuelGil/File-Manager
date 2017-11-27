' :: ===========================================================================
' :: NAME:		dialog.vbs
' :: AUTHOR:	Manuel Gil.
' :: DATE:		11/26/2017.
' :: VERSION:	1.0.3.0
' :: ===========================================================================

Dim strApplication
Dim strFunction
Dim strVersion
Dim strArguments
Dim strCustomization
Dim strSource
Dim strDestination
Dim strMessage

Call init()

If strFunction = "createCopy" Then
	Call getSource()
	Call getDestination()
	strMessage = "Are you sure you want to create a backup copy of " & strSource & " in " & strDestination & "?"
ElseIf strFunction = "patchFiles" Then
	Call getSource()
	Call getDestination()
	strMessage = "Are you sure you want to copy the contents of " & strSource & " in " & strDestination & "?"
ElseIf strFunction = "extractCustomization" Then
	Call getCustomization()
	Call getSource()
	Call getDestination()
	strMessage = "Are you sure you want to extract content from " & strSource & " in " & strDestination & "?"
ElseIf strFunction = "createList" Then
	Call getSource()
	strMessage = "Are you sure you want to create a list of " & strSource & "?"
End If

Call showMessage()

Call runCommands()

' Gets the Arguments
Function init()
	Set objArgs = WScript.Arguments
	
	' Minimum 3 Arguments
	If ObjArgs.count < 3 Then
		MsgBox "The arguments are not enough.",vbCritical,"File Manager."
		WScript.quit
	Else
		' Batch File = Argument 1
		strApplication = objArgs(0)
		' Function = Argument 2
		strFunction = objArgs(1)
		' OS Version = Argument 3
		strVersion = objArgs(2)
	End If
End Function

' Gets Custom Folder
Function getCustomization()
	strCustomization = Inputbox("Enter the path where the customization is located:" & vbCrlf & _
				vbCrlf & "Note: The path must not have special characters.","File Manager.","")
	
	' Path end with "\"
	If strCustomization <> "" Then
		If InStr(strCustomization, "(") = 0 And InStr(strCustomization, ")") = 0 Then
			If Right(strCustomization, 1) = "\" Then
				strCustomization = Left(strCustomization, Len(strCustomization) - 1) 
			End If
		Else
			MsgBox "The path contains special characters.",vbCritical,"File Manager."
			WScript.quit
		End If
	Else
		MsgBox "An error has occurred.",vbCritical,"File Manager."
		WScript.quit
	End If
End Function

' Gets Source Folder
Function getSource()
	strSource = Inputbox("Enter the source path:" & vbCrlf & _
				vbCrlf & "Note: The path must not have special characters.","File Manager.","")
	
	' Path end with "\"
	If strSource <> "" Then
		If InStr(strSource, "(") = 0 And InStr(strSource, ")") = 0 Then
			If Right(strSource, 1) = "\" Then
				strSource = Left(strSource, Len(strSource) - 1) 
			End If
		Else
			MsgBox "The path contains special characters.",vbCritical,"File Manager."
			WScript.quit
		End If
	Else
		MsgBox "An error has occurred.",vbCritical,"File Manager."
		WScript.quit
	End If
End Function

' Gets Destination Folder
Function getDestination()
	strDestination = Inputbox("Enter the destination path:" & vbCrlf & _
				vbCrlf & "Note: The path must not have special characters.","File Manager.","")
	
	' Path end with "\"
	If strDestination <> "" Then
		If InStr(strDestination, "(") = 0 And InStr(strDestination, ")") = 0 Then
			If Right(strDestination, 1) = "\" Then
				strDestination = Left(strDestination, Len(strDestination) - 1)
			End If
		Else
			MsgBox "The path contains special characters.",vbCritical,"File Manager."
			WScript.quit
		End If
	Else
		MsgBox "An error has occurred.",vbCritical,"File Manager."
		WScript.quit
	End If
End Function

' Show Confirmation Message
Function showMessage()
	objConfirmacion = MsgBox(strMessage,vbYesNo,"File Manager.")
	
	If objConfirmacion = vbNo Then
		WScript.quit
	End If
End Function

' Start Batch File
Function runCommands()
	Set objShell = CreateObject("Shell.Application")
	
	' Create a JSON Object
	' Function: {Source, Destination, Custom, OS Version}
	strArguments = strFunction & ": {source:" & strSource & "," & _
								"destination:" & strDestination & "," & _
								"custom:" & strCustomization & "," &_
								"version:" & strVersion & "}"
	
	If strVersion = "5.2.3790" Then
		' Run the Batch File in Windows Server 2003 or Windows XP (Without Runas)
		objShell.ShellExecute strApplication, strArguments, "", "", 1
	Else
		' Run the Batch File As Administrator (Runas)
		objShell.ShellExecute strApplication, strArguments, "", "runas", 1
	End If
	
	' Wait 3600 milliseconds
	WScript.Sleep 3600
	
	set objShell = nothing
End Function
