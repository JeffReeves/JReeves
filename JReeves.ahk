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

+Break::
    SendInput, %halftarget%
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
+AppsKey:: 
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

; Linux - General
::date +::{Raw}date +%Y-%b-%d
::free %.::{Raw}MEM_TOTAL=$(free | grep 'Mem' | awk '{ print $2 }'); MEM_USED=$(free | grep 'Mem' | awk '{ print $3 }'); USED_PERCENT=$(bc <<< "scale=4; (${MEM_USED} / ${MEM_TOTAL}) * 100"); echo "Memory Used %: ${USED_PERCENT}"
::free top10.::{Raw}echo -e "\nTOP 10 PROCESSES USING MEMORY:\n$(ps aux --sort -rss --width 130 | head)"
::dd wipe mbr.::{Raw}echo 'Wiping MBR...' && sudo dd bs=512 count=1 if=/dev/zero of=/dev/
::df sort.::{Raw}df -h | grep -E '^/' | sort -hr -k4
::du sort.::{Raw}du -ah --max-depth=1 | sort -hr
::du top10.::{Raw}echo -e "\nTOP 10 LARGEST DIRECTORIES IN $(pwd):\n$(du --threshold=4M -Shx $(pwd) | sort -hr | head -n10)"
::find top10 size.::{Raw}echo -e "\nTOP 10 LARGEST FILES IN /:\n$(find / -mount -size +2M -exec ls -alsh {} + | sort -rh -k1 | head -n10)"
::find top10 modified.::{Raw}echo -e "\n10 MOST RECENTLY MODIFIED FILES IN $(pwd):\n$(find $(pwd) -type f -printf '%TY-%Tm-%Td %TT %p\n' | sort -r | head -n10)"
::grep guid.::{Raw}grep -Eo '[0-9a-f]{8}(\-[0-9a-f]{4}){3}\-[0-9a-f]{12}'
::iptables ping disable::{Raw}iptables -I INPUT -p icmp -j DROP && echo "Disabled ICMP"
::iptables ping enable::{Raw}iptables -D INPUT -p icmp -j DROP && echo "Enabled ICMP"
::ps memory.::{Raw}ps -o pid,user,%mem,command ax | sort -b -k3 -r
::tmux4.::{Raw}tmux -u new-session -s quad \; split-window -h\; split-window -v\; select-pane -L\; split-window -v\; select-pane -U\; set-window-option synchronize-panes\; send-keys 'C-l'\;
::tmux6.::{Raw}tmux -u new-session -s t620s \; split-window -v\; split-window -v\; split-window -h\; select-pane -U\; split-window -h\; select-pane -U\; split-window -h\; select-pane -L\; select-layout tiled\; set-window-option synchronize-panes\; send-keys 'C-l'\;

::watch date.::
    SendInput, {Raw}watch -d -n60 "hostname; date"
    Return

::watch ping.::
    SendInput, {Raw}watch -d -n15 "hostname; ping -c2 -w2 "
    SendInput, {Left 1}
    Return

::while loop file.::
    SendInput, {Raw}while IFS='' read -r ITEM || [ -N "${ITEM}" ]; do echo "hi ${ITEM}"; done < /tmp/list.txt
    SendInput, {Left 33}
    Return

::while loop var.::
    SendInput, {Raw}while IFS='' read -r ITEM || [ -N "${ITEM}" ]; do echo "hi ${ITEM}"; done <<< "${LIST}"
    SendInput, {Left 31}
    Return 

::for loop csv.::
    SendInput, {Raw}FIELD_SEPARATOR=$IFS; IFS=','; LIST=""; for ITEM in ${LIST}; do echo "hi ${ITEM}"; done; IFS=${FIELD_SEPARATOR}
    SendInput, {Left 74}
    Return

::for loop ssv.::
    SendInput, {Raw}LIST=""; for ITEM in ${LIST}; do echo "hi ${ITEM}"; done
    SendInput, {Left 50}
    Return

::for loop nsv.::
    SendInput, {Raw}FIELD_SEPARATOR=$IFS; IFS=$'\n'; LIST=""; for ITEM in ${LIST}; do echo "hi ${ITEM}"; done; IFS=${FIELD_SEPARATOR}
    SendInput, {Left 74}
    Return

; git 
::git log --::{Raw}git log --graph --all --decorate
::git push --all::{Raw}GIT_REMOTES=$(git remote -v | grep 'push' | awk '{print $1}'); for REMOTE in ${GIT_REMOTES}; do echo "#==[ ${REMOTE} ]====="; git push "${REMOTE}"; echo ''; done

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

::youtube-dl.::
    SendInput,{Raw}VIDEO_ID=''; youtube-dl -o '`%(title)s.`%(ext)s' "${VIDEO_ID}" --restrict-filenames -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' --write-thumbnail
    SendInput,^a
    SendInput,{Right 10}
    Return 

::youtube-dl-thumbs.::
    SendInput,{Raw}VIDEO_ID=''; youtube-dl -o '`%(title)s.`%(ext)s' "${VIDEO_ID}" --skip-download --write-thumbnail
    SendInput,^a
    SendInput,{Right 10}
    Return 

::yt-dlp.::
    SendInput,{Raw}VIDEO_ID=''; yt-dlp -o '`%(title)s.`%(ext)s' "${VIDEO_ID}" --restrict-filenames -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' --write-thumbnail
    SendInput,^a
    SendInput,{Right 10}
    Return 

::yt-dlp-thumbs.::
    SendInput,{Raw}VIDEO_ID=''; yt-dlp -o '`%(title)s.`%(ext)s' "${VIDEO_ID}" --skip-download --write-thumbnail
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

; OpenStack
::neutron list networks.::{Raw}neutron net-list | grep -v '+' | sort -k4 -V
::neutron show mac.::{Raw}neutron port-list | grep ${IP}
::nova list aggregates.::{Raw}AGGREGATE_LIST=$(openstack aggregate list -f value -c "Name" -c "Availability Zone"); echo -e "#==[ AGGREGATE LIST ]=====\n$(openstack aggregate list)\n"; for AGGREGATE in $(echo "${AGGREGATE_LIST}" | cut -d' ' -f1); do echo "#--[ AGGREGATE SHOW ${AGGREGATE} ]-----"; openstack aggregate show -f value -c hosts "${AGGREGATE}" | grep -Po "(?<=')[a-zA-Z0-9\-\.]+(?=')"; echo ""; done
::nova list.::{Raw}nova list --all | sort -k4 -V 
::nova list vm.::{Raw}nova list --all --fields name,instance_name,host,status,power_state,task_state,networks --name 
::nova list host.::{Raw}nova list --all --fields name,instance_name,host,status,power_state,task_state,networks --host 

::nova list flavors.::
    SendInput, {Raw}nova list --fields name,instance_name --all --host  | grep -vE 'Instance Name|\+' | grep -Eo '[0-9a-f]{8}(\-[0-9a-f]{4}){3}\-[0-9a-f]{12}' | xargs -I{} nova show {} | grep -E '\| flavor|\| name|\| instance' | awk '{ print $2"\t"$4 }'
    SendInput, {Left 182}
    Return

::nova list migrations host.::
    SendInput, {Raw}nova migration-list --host  | grep "$(date +`%Y-`%m-`%d`)"
    SendInput, {Left 26}
    Return

::nova show aggregate host.::
    SendInput, {Raw}HOST=''; echo -e "\nHOST: ${HOST}"; AGGREGATE_FOUND=0; AGGREGATE_LIST=$(openstack aggregate list -f value -c "Name" -c "Availability Zone"); for AGGREGATE in $(echo "${AGGREGATE_LIST}" | cut -d' ' -f1); do AGGREGATE_HOSTS=$(openstack aggregate show -f value -c hosts "${AGGREGATE}" | grep -Po "(?<=')[a-zA-Z0-9\-\.]+(?=')"); for AGGREGATE_HOST in ${AGGREGATE_HOSTS}; do if [[ "${AGGREGATE_HOST}" == "${HOST}" ]]; then echo -e "AGGREGATE: ${AGGREGATE}\n\nOther hosts in this aggregate:\n${AGGREGATE_HOSTS}\n"; NOVA_SERVICE_LIST=$(nova service-list | sort -k4 -V); for ITEM in ${LIST}; do echo "${NOVA_SERVICE_LIST}" | grep -i "${ITEM}"; done; AGGREGATE_FOUND=1; break; fi; done; done; if [ ${AGGREGATE_FOUND} -eq 0 ]; then echo "[ERROR] NO AGGREGATE FOUND FOR HOST"; fi
    SendInput, ^a 
    SendInput, {Right 6}
    Return

::nova show flavor.::
    SendInput, {Raw}nova show  | grep flavor
    SendInput, {Left 14}
    Return

::nova show uuid.::
    SendInput, {Raw}nova list --all --name  | grep -Eo '[0-9a-f]{8}(\-[0-9a-f]{4}){3}\-[0-9a-f]{12}'
    SendInput, {Left 14}
    Return

::nova show volumes.::
    SendInput, {Raw}nova show  | grep volume
    SendInput, {Left 14}
    Return

::nova service disable.::
    SendInput, {Raw}nova service-disable --reason "$(date +`%Y-`%b-`%d) - Jeff R"  nova-compute
    SendInput, {Left 13}
    Return

::nova service enable.::
    SendInput, {Raw}nova service-enable  nova-compute
    SendInput, {Left 13}
    Return

::watch stack list.::{Raw}watch -d -n15 'echo "[OPENSTACK STACK LIST]"; STACK_LIST=$(openstack stack list --nested -f "value" -c "Stack Name" -c "Stack Status" -c "Updated Time" | grep -v "COMPL"); echo "${STACK_LIST}"; echo -e "\n[OPENSTACK STACK RESOURCE LIST]"; RESOURCE_NAME=$(echo "${STACK_LIST}" | grep -i "update_in_progress" | head -n1 | awk '\''{ print $1 }'\''); openstack stack resource list "${RESOURCE_NAME}"'

; RRTK
; Copies the current line and formats it into:
; <italic_text> = <bold_text>
; <underline_text>: <bold_text>
; <bold_text>
AppsKey::
    Random, red,   0, 225 ; 255
    Random, blue,  0, 225 ; 255
    Random, green, 0, 225 ; 255
    randomHexColor := Format("{1:0.2X}{2:0.2X}{3:0.2X}`r`n", red, blue, green)
    randomHexColor := Trim(randomHexColor)
    SendInput, {End}
    SendInput, +{Home}
    Sleep, 50
    SendInput, ^c
    ClipWait, 2
    Sleep 100
    line := clipboard
    If InStr(line, "=")
    {
        story_array := StrSplit(line, "=")
        story := Trim(story_array[1])
        keyword := Trim(story_array[2])
        htmlString := "<i>" story "</i> = <b><font color='#" randomHexColor "'>" keyword "</font></b>"
        htmlString := StrReplace(htmlString, "`r`n", "")
        wcMain.SetHTML(htmlString)
        wcMain.Paste()
    }
    Else If InStr(line, ":")
    {
        primitive_array := StrSplit(line, ":")
        ;primitive := Trim(primitive_array[1])
        keyword := Trim(primitive_array[2])
        htmlString := "<u>primitive:</u> <b><font color='#" randomHexColor "'>" keyword "</font></b>"
        htmlString := StrReplace(htmlString, "`r`n", "")
        wcMain.SetHTML(htmlString)
        wcMain.Paste()
    }
    Else
    {
        keyword := Trim(line)
        htmlString := "<b><font color='#" randomHexColor "'>" keyword "</font></b>"
        htmlString := StrReplace(htmlString, "`r`n", "")
        wcMain.SetHTML(htmlString)
        wcMain.Paste()
    }
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

; STEAM ACHIEVEMENT MANAGER ----------------------------------------|
#s::
    ; 85X, 100Y
    MouseClick, left, 85, 100
    Sleep 200

    ; 580X, 45Y
    MouseClick, left, 580, 45
    Sleep 200

    ; Enter
    SendInput, {Enter}
    Sleep 1000

    ; Close Window
    WinClose, A
    Return

; HEADSPACE LOGIN --------------------------------------------------|

+PrintScreen::
    SendInput, pip uninstall pyheadspace -y; python setup.py build; python setup.py install; headspace login{Enter} 
    sleep 2000
    SendInput, jeff{@}binary.run{Enter}
    sleep 150
    SendInput, {#}15MinutesADay{!}
    Return

; RELOAD -----------------------------------------------------------|

+Esc::
    Reload
    Return

; JAPANESE WINDOWS IME ---------------------------------------------|

; switch between hiragana and katakana
#Space::vk1D


; VR CHAT ----------------------------------------------------------|

; needed for Dvorak keyboard rebindings
#IfWinActive ahk_exe VRChat.exe
.::w
o::a 
e::s 
u::d