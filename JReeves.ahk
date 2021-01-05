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

; paste plain text
~LControl & MButton:: 
    SendInput, %clipboard%
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

; convert text to plain text
~LControl & Right:: 
    clipboard = %clipboard%
    SendInput ^v
    Return

; convert text to HTML entities
~LControl & PgUp:: 
    ;Transform, clipboard, HTML, %clipboard%
    StringReplace, htmlEntities, clipboard, <, &lt;, All
    StringReplace, clipboard, htmlEntities, >, &gt;, All
    SendInput ^v
    Return

; paste parsed HTML
~LControl & PgDn:: 
    wcMain.SetHTML(clipboard)
    wcMain.Paste()
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

::--m ::{Asc 0151}{space}
::#=140::{#}==========================================================================================================================================
::#=120::{#}======================================================================================================================
::#=100::{#}==================================================================================================
::#=80::{#}==============================================================================

; emoticons / emojis 
::.shrug.::¯\_(`ツ`)_/¯

; Discord
::~~69::{~}{~}--------------------------------------------------------------------{~}{~}

; Linux
::date +::{Raw}date +%Y-%b-%d
::free %.::{Raw}MEM_TOTAL=$(free | grep 'Mem' | awk '{ print $2 }'); MEM_USED=$(free | grep 'Mem' | awk '{ print $3 }'); USED_PERCENT=$(bc <<< "scale=4; (${MEM_USED} / ${MEM_TOTAL}) * 100"); echo "Memory Used %: ${USED_PERCENT}"
::free top10.::{Raw}echo -e "\nTOP 10 PROCESSES USING MEMORY:\n$(ps aux --sort -rss --width 130 | head)"
::find top10.::{Raw}echo -e "\nTOP 10 LARGEST FILES:\n$(find ./ -mount -size +2M -exec ls -alsh {} + | sort -rh -k1 | head -n10)"
::du top10.::{Raw}echo -e "\nTOP 10 LARGEST DIRECTORIES:\n$(du --threshold=4M -Shx ./ | sort -hr | head -n10)"
::tmux4.::{Raw}tmux -u new-session -s quad \; split-window -h\; split-window -v\; select-pane -L\; split-window -v\; select-pane -U\; set-window-option synchronize-panes\; send-keys 'C-l'\;
::tmux6.::{Raw}tmux -u new-session -s t620s \; split-window -v\; split-window -v\; split-window -h\; select-pane -U\; split-window -h\; select-pane -U\; split-window -h\; select-pane -L\; select-layout tiled\; set-window-option synchronize-panes\; send-keys 'C-l'\;

::watch ping.::
    SendInput, {Raw}watch -d -n15 "hostname; ping -c2 -w2 "
    SendInput, {Left 1}
    Return

; git 
::git log --::{Raw}git log --graph --all --decorate

; homelab Linux
::add dvorak toggle.::
DVORAK_TOGGLE =
(
# toggle between Dvorak and QWERTY with Ctrl+Shift
setxkbmap \
    -model pc105 \
    -layout 'us(dvorak),us' \
    -option \
    -option grp:ctrl_shift_toggle \
    -option compose:rwin

)
    SendInput, {Raw}%DVORAK_TOGGLE%
    Return

::sudo apt-get update &::{Raw}sudo apt-get update && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y

::ssh rtunnel.::
    SendInput, {Raw}ssh remoteUser@remoteHost -R 21919:localhost:22
    SendInput, {Left 33}
    Return 

::scp rtunnel.::
    SendInput, {Raw}scp -P 21919 remotefile jeff@localhost:/tmp
    SendInput, {Left 20}
    Return 

::youtubedl.::
    SendInput,{Raw}VIDEO_ID=''; youtube-dl -o '`%(title)s.`%(ext)s' "${VIDEO_ID}" --restrict-filenames -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'
    SendInput,^a
    SendInput,{Right 10}
    Return 

::rm zone.::{Raw}find /share -type f -name "*Zone.Identifier" -print0 | xargs -i{} -0 rm -v {}
::mkvtomp4.::{Raw}find ./ -maxdepth 1 -type f -name '*.mkv' -print0 | xargs -0 -I{} ffmpeg -i {} -codec copy $(echo "{}" | cut -f2 -d'.').mp4
::mkvtomp4subs.::{Raw}find ./ -maxdepth 1 -type f -name '*.mkv' -print0 | xargs -0 -I{} ffmpeg -i {} -vf subtitles={} -codec copy $(echo "{}" | cut -f2 -d'.').mp4
::concatmp4.::{Raw}ffmpeg -safe 0 -f concat -i <(find . -maxdepth 1 -type f -name '*.mp4' -printf "file '$PWD/%p'\n" | sort) -c copy ConcatenatedVideo.mp4
::tmuxrpis.::{Raw}tmux -u new-session -s rpis \; split-window -h\; split-window -v\; select-pane -L\; split-window -v\; send-keys -t top-left 'ssh jeff@pecan' 'C-m'\; send-keys -t top-right 'ssh jeff@apple' 'C-m'\; send-keys -t bottom-left 'ssh jeff@strawberry' 'C-m'\; send-keys -t bottom-right 'ssh jeff@blueberry' 'C-m'\; select-pane -U\; set-window-option synchronize-panes\; send-keys 'C-l'\;
::tmuxt620s.::{Raw}tmux -u new-session -s t620s \; split-window -v\; split-window -v\; split-window -v\; split-window -h\; select-pane -U\; split-window -h\; select-pane -U\; split-window -h\; select-pane -U\; split-window -h\; select-pane -L\; select-layout tiled\; send-keys -t 0 'ssh jeff@triforce' 'C-m'\; send-keys -t 1 'ssh jeff@link' 'C-m'\; send-keys -t 2 'ssh jeff@zelda' 'C-m'\; send-keys -t 3 'ssh jeff@ganon' 'C-m'\; send-keys -t 4 'ssh jeff@mushroom' 'C-m'\; send-keys -t 5 'ssh jeff@mario' 'C-m'\; send-keys -t 6 'ssh jeff@luigi' 'C-m'\; send-keys -t 7 'ssh jeff@peach' 'C-m'\; set-window-option synchronize-panes\; send-keys 'C-l'\;
::tmuxloz.::{Raw}tmux -u new-session -s loz \; split-window -h\; split-window -v\; select-pane -L\; split-window -v\; send-keys -t top-left 'ssh jeff@triforce' 'C-m'\; send-keys -t top-right 'ssh jeff@link' 'C-m'\; send-keys -t bottom-left 'ssh jeff@zelda' 'C-m'\; send-keys -t bottom-right 'ssh jeff@ganon' 'C-m'\; select-pane -U\; set-window-option synchronize-panes\; send-keys 'C-l'\;
::tmuxsmb.::{Raw}tmux -u new-session -s smb \; split-window -h\; split-window -v\; select-pane -L\; split-window -v\; send-keys -t top-left 'ssh jeff@mushroom' 'C-m'\; send-keys -t top-right 'ssh jeff@mario' 'C-m'\; send-keys -t bottom-left 'ssh jeff@luigi' 'C-m'\; send-keys -t bottom-right 'ssh jeff@peach' 'C-m'\; select-pane -U\; set-window-option synchronize-panes\; send-keys 'C-l'\;

; RRTK
::rrtk.::
    SendInput, ^v 
    SendInput, {Raw} = "" (RRTK)
    SendInput,{Left 8}
    Return 

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


; VR CHAT ----------------------------------------------------------|

; needed for Dvorak keyboard rebindings
#IfWinActive ahk_exe VRChat.exe
.::w
o::a 
e::s 
u::d