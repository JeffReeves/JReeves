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

; control volume with mouse wheel when hovering over the taskbar
#If MouseIsOver("ahk_class Shell_TrayWnd")
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

; SCREENSHOTS ------------------------------------------------------|

; snip to clipboard
F6::
    SendInput, +#s
    Return

; printscreen (handy for Greenshot)
F7::
    SendInput, {PrintScreen}
    Return

; CLIPBOARD OPERATIONS ---------------------------------------------|

; copy
~LControl & LButton:: 
    SendInput ^c
    Return

; paste parsed HTML
~LControl & MButton:: 
    wcMain.SetHTML(clipboard)
    wcMain.Paste()
    Return

; paste
~LControl & RButton:: 
    SendInput ^v
    Return

; convert text to "Capitalized Case"
~LControl & Left:: 
    StringUpper, clipboard, clipboard, T
    SendInput ^v
    Return

; convert text to UPPERCASE
~LControl & Up:: 
    StringUpper, clipboard, clipboard
    SendInput ^v
    Return

; convert text to lowercase
~LControl & Down:: 
    StringLower, clipboard, clipboard
    SendInput ^v
    Return

; convert text to HTML entities
~LControl & Right:: 
    ;Transform, clipboard, HTML, %clipboard%
    StringReplace, htmlEntities, clipboard, <, &lt;, All
    StringReplace, clipboard, htmlEntities, >, &gt;, All
    SendInput ^v
    Return

~RAlt::
    MouseClick, left
    Return

; wrap selected text with desired HTML tags
AppsKey:: 
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

; sets window to always be on top
#a:: 
    Winset, Alwaysontop, , A
    Return

; increases transparency
#Up:: 
    WinGet, active_id, ID, A
    if not(transValue%active_id%) {
        transValue%active_id% := 255
    }
    else {
        transValue%active_id% += 10
        WinSet, Transparent, % transValue%active_id%, A
    }
    Return

; decreases transparency
#Down:: 
    WinGet, active_id, ID, A
    if not(transValue%active_id%) {
        transValue%active_id% := 255
    }
    else {
        transValue%active_id% -= 10
        WinSet, Transparent, % transValue%active_id%, A
    }
    Return

; toggles always on top, click through, and removes title bar
#c:: 
    WinGet, active_id, ID, A
    if not(toggle%active_id%) {
        Winset, Alwaysontop, , A
        WinSet, Style, -0xC40000, A
        WinSet, ExStyle, +0x20, A
        toggle%active_id% = 1
    }
    else {
        Winset, Alwaysontop, , A
        WinSet, Style, +0xC40000, A
        WinSet, ExStyle, -0x20, A
        toggle%active_id% = 0
    }
    Return

; copies the hex color under the cursor
#LButton:: 
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
::#=140::{#}==========================================================================================================================================
::#=120::{#}======================================================================================================================
::#=100::{#}==================================================================================================
::#=80::{#}==============================================================================

; Linux
::date +::{Raw}date +%Y%b%d
::free %::{Raw}MEM_TOTAL=$(free | grep 'Mem' | awk '{ print $2 }'); MEM_USED=$(free | grep 'Mem' | awk '{ print $3 }'); USED_PERCENT=$(bc <<< "scale=4; (${MEM_USED} / ${MEM_TOTAL}) * 100"); echo "Memory Used %: ${USED_PERCENT}"
::free top10::{Raw}echo -e "\nTOP 10 PROCESSES USING MEMORY:\n$(ps aux --sort -rss --width 130 | head)"
::tmux 4panel::{Raw}tmux -u new-session -s quad \; split-window -h\; split-window -v\; select-pane -L\; split-window -v\; send-keys -t top-left 'C-l'\; send-keys -t top-right 'C-l'\; send-keys -t bottom-left 'C-l'\; send-keys -t bottom-right 'C-l'\; select-pane -U\; send-keys 'C-l'\;

; homelab Linux
::rm zone.::{Raw}find /share -type f -name "*Zone.Identifier" -print0 | xargs -i{} -0 rm -v {}


; FOLDER CREATION --------------------------------------------------|

; create multiple folders based on clipboard content
#f:: 
    ; iterate over each line on the clipboard
    Loop, parse, clipboard, `n, `r
    {
        line := A_LoopField
        ; strip out characters that cannot be used in folder name
        StringReplace, line, line, +, and, All
        StringReplace, line, line, :, --, All
        StringReplace, line, line, ?, , All
        ; create a new folder
        SendInput, ^+n
        Sleep 20
        ; name the folder
        SendInput, %line%
        Sleep 20
        ; save the folder
        SendInput, {Enter}
        Sleep 20
    }
    Return


; RELOAD -----------------------------------------------------------|

+Esc::
    Reload
    Return
