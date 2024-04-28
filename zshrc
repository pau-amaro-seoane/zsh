# zshrc configuration file
# Pau Amaro Seoane, Berlin, 25/Jun/2018




            # ******************** typesetting et al ******************* #

# Choose GB here not because of Stockholm syndrom, but to have the 
# weekday starting on Mon in the calendar
export LANG=en_GB.UTF-8
export LC_CTYPE=en_GB.UTF-8
export LC_NUMERIC=en_GB.UTF-8
export LC_TIME=en_GB.UTF-8
export LC_COLLATE=en_GB.UTF-8
export LC_MONETARY=en_GB.UTF-8
export LC_MESSAGES=en_GB.UTF-8
export LC_ALL= # overrides all of them, unset it


            # ******************** start up message ******************* #


# "episemos" contains a log file with urgent things to
# do; this way we're confronted with reality every time
# we launch the terminal, check episemos.sh for more info
cat $HOME/fitx_confg/episemos/episemos
echo "---"
/usr/games/fortune -s
echo "---"


            # ******************** setopt and bindkeys ******************* #



setopt extendedglob
setopt nohup
setopt autocd
set -o vi
setopt rmstarwait
bindkey "OH" beginning-of-line
bindkey "OF" end-of-line
bindkey "" history-incremental-search-forward
bindkey "" history-incremental-search-backward



            # ******************** Paths ******************* #



export PATH="$PATH:/bin:/usr/bin:/usr/local/bin:/sbin:/usr/games:$HOME/bin:$HOME/smbin:/$HOME/.local/bin"
export FPATH="$FPATH:$HOME/fitx_confg/definicions_funcions/"
export MANPATH="$X11HOME/man:/usr/X11R6/man/:/usr/man:/usr/lang/man:/usr/local/man:/usr/share/man:$HOME/treball/simulacions/nemo:$HOME/treball/supermongolodeiu/man"

export LSCOLORS=Exfxcxdxbxegedabagacad
export LESS=-R
export HELPDIR=/usr/local/lib/zsh/help
export EDITOR=vim
export VISUAL=vim
export FCEDIT=vim
export PAGER=`which less`

export TEXINPUTS=".:$HOME/fitx_confg/texinputs/::"
export BIBINPUTS=".:$HOME/fitx_confg/texinputs/:$HOME/articles/::"
export BSTINPUTS=".:$HOME/fitx_confg/texinputs/::"

# Source lal
#. /home/pau/treball/simulacions/lal/etc/lalsuite-user-env.sh



            # ******************** Completion ******************* #



autoload -U compinit compinit
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:cd:*' ignore-parents parent pwd
setopt correctall
fignore=(.o .old .pro)
# Persistent rehash
zstyle ':completion:*' rehash true


            # ******************** Prompt ******************* #



autoload -U promptinit
promptinit
prompt pau grey grey grey grey grey grey,bold
SPROMPT='
-Barbarian: Did you maybe mean >> '%B%r%b' << instead of '%R', my dearest bud of wallflower, %n?
-Catala:    Potser volies dir >> '%B%r%b' << en comptes de '%R', poncella de violer, %n?

'



            # ******************** History ******************* #



setopt hist_ignore_all_dups
HISTSIZE=9000
HISTFILE="$HOME/fitx_confg/zsh/zsh_historia"



            # ******************** Functions ******************* #


# "mata" kills a process
mata ()
{
	local pid
	pid=$(ps -ax | grep $1 | grep -v grep | awk '{ print $1 }')
	echo -n "Killing $1 (PID #$pid)..."
	kill -9 $=pid
}

# redefine exit in a silly way (I know)
function _exit()
{
    RED='\e[1;31m'
    NC='\e[0m'
    echo -e "${RED}fins després, plaerdemavida${NC}"
}
trap _exit EXIT


# xterm "username@hostname: directory and command"
function title {
    echo -en "\033]2;$1\007"
}
function preexec() {
  title "$1" "$USER@%m" "%35<...<%~"
}

rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# Copies the contents of a given file to the system or X Windows clipboard
#
# copyfile <file>
function copyfile {
  emulate -L zsh
  clipcopy $1
}

# copy the active line from the command line buffer 
# onto the system clipboard

copybuffer () {
  if which clipcopy &>/dev/null; then
    printf "%s" "$BUFFER" | clipcopy
  else
    zle -M "clipcopy not found. Please make sure you have Oh My Zsh installed correctly."
  fi
}

zle -N copybuffer

bindkey -M emacs "^O" copybuffer
bindkey -M viins "^O" copybuffer
bindkey -M vicmd "^O" copybuffer

# "extreu" extracts any compressed, tarred etc file $1
extreu () {
   if [ -f $1 ] ; then
       case $1 in
        *.tar.bz2) tar xvjf   $1 ;;
        *.tar.gz)  tar xvzf   $1 ;;
        *.bz2)     bunzip2    $1 ;;
        *.rar)     unrar x    $1 ;;
        *.gz)      gunzip     $1 ;;
        *.tar)     tar xvf    $1 ;;
        *.tbz2)    tar xvjf   $1 ;;
        *.tgz)     tar xvzf   $1 ;;
        *.zip)     unzip      $1 ;;
        *.Z)       uncompress $1 ;;
        *.7z)      7z x       $1 ;;
        *.tar.xz)  tar xfz    $1 ;;
        *.txz)     tar xfz    $1 ;; 
        *.xz)      unxz       $1 ;;
        *)         echo "What the heck is that '$1'? I have no idea what to do here, plonker..." ;;
       esac
   else
       echo "I don't have the slightest idea of what is this '$1'..."
   fi
 }

VIM=`which vim 2> /dev/null`
VI=`which vi 2> /dev/null`
NVI=`which nvi 2> /dev/null`
EOG=`which eog 2> /dev/null`
EOM=`which eom 2> /dev/null`
VLC=`which vlc 2> /dev/null`
XINE=`which xine 2> /dev/null`
MPLAYER=`which mplayer 2> /dev/null`
EVINCE=`which evince 2> /dev/null`
ATRIL=`which atril 2> /dev/null`
MUPDF=`which mupdf 2> /dev/null`
XPDF=`which xpdf 2> /dev/null`
LIBREOFFICE=`which libreoffice 2> /dev/null`

# "obri" opens any kind of file $1 according to these definitions
obri () {
   if [ -f $1 ] ; then
       case $1 in
        *.tex|*.bbl|*.bib|*.sh|*.py|*.pl|*.txt)
                         if [ -s $VIM ]
                          then $VIM $1
                             else
                              if [ -s $VI ]
                              then $VI $1
                                else
                                 if [ -s $NVI ]
                                 then $NVI $1
                                 else echo "You don't have either vim, nor vi, nor nvi. And I will _not_ use emacs, man... I give up."
                                 fi
                              fi
                        fi;;

        *.pdf|*.ps|*.eps|*.ps.gz|*.eps.gz|*.PDF|*.Ps|*.EPS|*.PS.GZ|*.EPS.GZ)

                         if [ -s $EVINCE ]
                          then $EVINCE $1
                             else
                              if [ -s $ATRIL ]
                              then $ATRIL $1
                                else $MUPDF $1
                              if [ -s $XPDF ]
                                then $XPDF $1
                                 else echo "You don't either evince, nor atril, nor mupdf nor xpdf... I give up."
                                fi
                              fi
                        fi;;

        *.jp*g|*.JP*G|*.png|*.PNG|*.gif|*.GIF)

                         if [ -s $EOG ]
                          then $EOG $1
                             else
                              if [ -s $EOM ]
                              then eom $1
                                else qiv -t $1
                              fi
                        fi;;

        *.ogg|*.ogv|*.mp4|*.MP4|*.mkv|*.MKV|*.avi|*.AVI|*.flv|*.FLV|.*mov|.*MOV)

                         if [ -s $VLC ]
                          then $VLC $1
                             else
                              if [ -s $XINE ]
                              then $XINE $1
                                else $MPLAYER $1
                              fi
                        fi;;

        *.doc|*.DOC|*.docx|*.DOCX|*.odp|*.ODP|*.xls|*.XLS|*.rtf|*.RTF)

                         if [ -s $LIBREOFFICE ]
                          then $LIBREOFFICE $1
                             else
                              echo "You do not have libreoffice... sorry, mate."
                         fi;;

        *.tgz)          tar xvzf   $1 ;;
        *.tar.bz2)      tar xvjf   $1 ;;
        *.tar.gz)       tar xvzf   $1 ;;
        *.tar.xz)       tar Jxvf   $1 ;;
        *.tar)          tar  xvf   $1 ;;
        *.tbz2)         tar xvjf   $1 ;;
        *.zip)          unzip      $1 ;;
        *.Z)            uncompress $1 ;;
        *.7z)           7z x       $1 ;;
        *)              echo "What the heck is that '$1'? I am lost, man..." ;;
       esac
   else
       echo "I don't have the slightest idea of what is this '$1'... Or maybe you got the wrong path?"
   fi
 }



            # ******************** alias ******************* #



alias rm='$HOME/bin/fem.sh'
alias mv='nocorrect mv -f'
alias cp='nocorrect cp -p'
alias mkdir='nocorrect mkdir'
alias d='dirs -v'
alias j='jobs -l'
alias e='exit'
alias cal='cal -mw ;  date "+Today is %v, %Hh%M"'
alias -g '...'='cd ../..'
alias -g '....'='cd ../../..'
alias -g '.....'='cd ../../../..'
alias ls='colorls -GF'
alias la='ls -F -lartsRh | sort -nr'
alias rsync='rsync --relative --delete --archive --verbose --compress --human-readable --progress --times'
