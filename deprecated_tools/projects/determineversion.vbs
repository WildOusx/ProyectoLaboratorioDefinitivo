Option Explicit

Dim FSO
Set FSO = CreateObject("Scripting.FileSystemObject")

Sub FindReplaceInFile(filename, to_find, replacement)
    Dim file, data
    Set file = FSO.OpenTextFile(filename, 1, 0, 0)
    data = file.ReadAll
    file.Close
    data = Replace(data, to_find, replacement)
    Set file = FSO.CreateTextFile(filename, -1, 0)
    file.Write data
    file.Close
End Sub

Sub UpdateFile(modified, revision, version, cur_date, filename)
    FSO.CopyFile filename & ".in", filename
    FindReplaceInFile filename, "!!MODIFIED!!", modified
    FindReplaceInFile filename, "!!REVISION!!", revision
    FindReplaceInFile filename, "!!VERSION!!", version
    FindReplaceInFile filename, "!!DATE!!", cur_date
End Sub

Sub UpdateFiles(version)
    Dim modified, revision, cur_date
    cur_date = DatePart("D", Date) & "." & DatePart("M", Date) & "." & DatePart("YYYY", Date)

    If InStr(version, Chr(9)) Then
        revision = Mid(version, InStr(version, Chr(9)) + 1)
        modified = Mid(revision, InStr(revision, Chr(9)) + 1)
        revision = Mid(revision, 1, InStr(revision, Chr(9)) - 1)
        modified = Mid(modified, 1, InStr(modified, Chr(9)) - 1)
        version  = Mid(version, 1, InStr(version, Chr(9)) - 1)
    Else
        revision = 0
        modified = 1
    End If

    UpdateFile modified, revision, version, cur_date, "../src/rev.c"
End Sub

Function ReadRegistryKey(shive, subkey, valuename, architecture)
    ReadRegistryKey = ""
End Function

Function DetermineSVNVersion()
    DetermineSVNVersion = ""
End Function
