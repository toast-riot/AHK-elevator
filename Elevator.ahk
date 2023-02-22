#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force

DetectHiddenWindows, On

if A_IsAdmin {
elevate()
}

IfExist, .\icon.ico
	Menu, Tray, Icon, .\icon.ico

Menu, Tray, NoStandard
Menu, Tray, Add, Help, HelpHandler
Menu, Tray, Add, Open Startup Folder, StartupHandler
Menu, Tray, Add
Menu, Tray, Add, Exit, ExitHandler

Readme =
(
=== Warnings ===
This script will RE-RUN your scripts. If your scripts have variables in them that have not been saved to a file, they will be lost.

=== Description ===
A simple script that re-runs all of your currently running AHK scripts as administrator. This is useful for when you want your scripts to work while a window running as administrator is focused, such as command prompt.

=== Usage ===
- Run the script (either the exe or the AHK source)
- An icon that looks like a shield will appear on the right of your taskbar (it may be in the menu accessed by clicking the upwards arrow)
- Click the shield icon
- A UAC prompt asking you to "allow this app to make changes to your device" will appear
- Click the "Yes" button
- All of your currently running scripts will be re-run as administrator
I would recommend putting this script in your startup folder. To do this, right click the shield icon and click "open startup folder". Then copy the script (and the icon file) to this folder.

=== Advanced usage ===
- If you right-click the script and run it as an administrator, it will instantly run all of your scripts as administrator.
- The icon can be changed or removed

=== Credits ===
We have a very nice community, you know. Thanks heaps to all the legends out there being so helpful.
- Detect click on tray icon: https://www.autohotkey.com/boards/viewtopic.php?t=91426#p404048
- Run script as administrator: https://www.autohotkey.com/boards/viewtopic.php?p=102526#p102526
- List all running AHK scripts: https://www.autohotkey.com/boards/viewtopic.php?p=262694#p262694

=== Notes ===
It is called elevator because it "Elevates" the scripts in UAC.
)

Gui, Add, Text, +Wrap W100, %Readme%

OnMessage(0x404, Func("AHK_NOTIFYICON").Bind(hGui))
Return

AHK_NOTIFYICON(hGui, wp,  lp) {
	static WM_LBUTTONDOWN := 0x201
	if (lp = WM_LBUTTONDOWN) {
		if A_IsAdmin {
			elevate()
		} else {
			elevateSelf()
		}
	}
}

elevateSelf() {
	try {
		Run *RunAs "%A_ScriptFullPath%"
		ExitApp
	}
}


elevate() {
	WinGet, List, List, ahk_class AutoHotkey
	Loop % List {
   	WinGetTitle, title, % "ahk_id" List%A_Index%
		script = % RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
		if not ("" . A_ScriptFullPath = script) {
			try {
				Run *RunAs "%script%"
			} catch {
				break
			}
		}
	}
}
Return

ExitHandler:
ExitApp
Return

HelpHandler:
Gui, Show, w370 h520 Center, Elevator Help
Return

StartupHandler:
Send #r
WinWaitActive Run
Send shell:startup{Enter}
Return