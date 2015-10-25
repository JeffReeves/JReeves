;   JReeves AutoHotKey Multi-Tool
;   Author: Jeffrey Reeves
;
;       (I LIEK TURTLES!~)
;      (   )
;     ( )
;     o
;    __  .--.
;   (' \/    \,
;     ` u----u~
;

; INITIALIZATION ---------------------------------------------------|

#NoEnv
#Persistent
SetKeyDelay, 1, 1
SetTitleMatchMode RegEx
SetWorkingDir %A_ScriptDir%

Menu, Tray, Standard
Menu, Tray, Tip, [Jeffrey Reeves]
Menu, Tray, Icon, icons/jreeves.ico

#Include includes/Library.ahk
#Include includes/WinClipAPI.ahk
#Include includes/WinClip.ahk
wcMain := new WinClip

; VOLUME CONTROL ---------------------------------------------------|


#If MouseIsOver("ahk_class Shell_TrayWnd") ;if over taskbar
  WheelUp::Send {Volume_Up}
  WheelDown::Send {Volume_Down}

MouseIsOver(WinTitle) {
  MouseGetPos,,, Win
  Return WinExist(WinTitle . " ahk_id " . Win)
}


; GENERAL HOTKEYS --------------------------------------------------|

#If

Break::
  SendInput, %fulltarget%
  Return

ScrollLock::
  SendInput, %semitarget%
  Return


; CLIPBOARD OPERATIONS ---------------------------------------------|


~LControl & LButton:: ; copy
  SendInput ^c
  Return

~LControl & MButton:: ; paste parsed HTML
  wcMain.SetHTML(clipboard)
  wcMain.Paste()
  Return

~LControl & RButton:: ; paste
  SendInput ^v
  Return

~LControl & Left:: ; convert text to "Capitalized Case"
  StringUpper, clipboard, clipboard, T
  SendInput ^v
  Return

~LControl & Up:: ; convert text to UPPERCASE
  StringUpper, clipboard, clipboard
  SendInput ^v
  Return

~LControl & Down:: ; convert text to lowercase
  StringLower, clipboard, clipboard
  SendInput ^v
  Return

~LControl & Right:: ; convert text to HTML entities
  ;Transform, clipboard, HTML, %clipboard%
  StringReplace, htmlEntities, clipboard, <, &lt;, All
  StringReplace, clipboard, htmlEntities, >, &gt;, All
  SendInput ^v
  Return

AppsKey:: ; wrap selected text with desired HTML tags
  SendInput ^c
  Gui, Destroy
  Gui, Add, Text, w200, Wrap HTML:
  Gui, Add, Edit, w300 vHTMLTag
  Gui, Add, Button, w75 Default, OK
  MouseGetPos, MouseX, MouseY
  Gui, Show, x%MouseX% y%MouseY% w320 h90, Wrap HTML
  Return

GuiClose:
  Gui, Destroy
  Return

ButtonOK:
  Gui, Submit
  textToWrap = %clipboard%
  TaggedText = <%HTMLTag%>%textToWrap%</%HTMLTag%>
  clipboard := TaggedText
  SendInput ^v
  TaggedText =
  textToWrap =
  return


; WINDOW OPERATIONS ------------------------------------------------|


#a:: ; sets window to always be on top
  Winset, Alwaysontop, , A
  Return


#Up:: ; increases transparency
  WinGet, active_id, ID, A
  if not(transValue%active_id%) {
    transValue%active_id% := 255
  }
  else {
    transValue%active_id% += 10
    WinSet, Transparent, % transValue%active_id%, A
  }
  Return


#Down:: ; decreases transparency
  WinGet, active_id, ID, A
  if not(transValue%active_id%) {
    transValue%active_id% := 255
  }
  else {
    transValue%active_id% -= 10
    WinSet, Transparent, % transValue%active_id%, A
  }
  Return


#LButton:: ; copies the hex color under the cursor
  MouseGetPos, MouseX, MouseY
  PixelGetColor, pColor, %MouseX%, %MouseY%, RGB
  StringReplace, pColor, pColor, 0x, , All
  clipboard := pColor
  TrayTip, Copied Color, %pColor%, 1
  Return


; HOT STRINGS ------------------------------------------------------|

#Include HTML5.ahk ; autocompletion of HTML tags

#Hotstring B * ?0 C1 C

::--m::{Asc 0151}


; RELOAD -----------------------------------------------------------|

+Esc::
  Reload
  Return
