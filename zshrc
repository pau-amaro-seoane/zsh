# ============================================================================ #
#                          ZSHRC CONFIGURATION FILE                            #
# ============================================================================ #
#
# Copyright (c) 2003 Pau Amaro Seoane <amaro@riseup.net>
#
# Permission to use, copy, modify, and distribute this software for any purpose
# with or without fee is hereby granted, provided that the above copyright notice
# and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# ============================================================================ #


# ******************** 1. OS Detection ******************** #
# Zsh sets the builtin $OSTYPE variable automatically at startup.
# We define fast boolean-style integers so the rest of the file can branch
# cleanly between OpenBSD (primary OS) and GNU/Linux without spawning `uname`.

typeset -gi IS_OPENBSD=0
typeset -gi IS_LINUX=0

case "$OSTYPE" in
    openbsd*) IS_OPENBSD=1 ;;
    linux*)   IS_LINUX=1   ;;
esac


# ******************** 2. Typesetting & Locale ******************** #
# Choose en_GB.UTF-8 here not because of Stockholm syndrome, but so that
# the weekday starts on Monday in calendar utilities and ISO-like time formats
# are respected across POSIX tools.

export LANG="en_GB.UTF-8"
export LC_CTYPE="en_GB.UTF-8"
export LC_NUMERIC="en_GB.UTF-8"
export LC_TIME="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"
export LC_MONETARY="en_GB.UTF-8"
export LC_MESSAGES="en_GB.UTF-8"

# Unset LC_ALL so it does not forcibly override individual LC_* variables
unset LC_ALL


# ******************** 3. Startup Message ******************** #
# Only run in interactive shells so we never break non-interactive SCP/rsync/SSH
# transfers that might source this file.

if [[ -o interactive ]]; then
    # "episemos" contains a log file with urgent things to do; this way we're
    # confronted with reality every time we launch the terminal.
    # Check episemos.sh for more info.
    # [[ -r "$HOME/fitx_confg/episemos/episemos" ]] && cat "$HOME/fitx_confg/episemos/episemos"

    # Print a short epigram if 'fortune' is installed (/usr/games/fortune)
    if (( $+commands[fortune] )); then
        print -- "---"
        fortune -s
        print -- "---"
    elif [[ -x /usr/games/fortune ]]; then
        print -- "---"
        /usr/games/fortune -s
        print -- "---"
    fi
fi


# ******************** 4. Environment & Paths ******************** #
# `typeset -U` forces Zsh to keep arrays unique (removing duplicate path entries
# automatically even if ~/.zshrc is re-sourced multiple times).

typeset -U path manpath

path=(
    $path
    /bin
    /usr/bin
    /usr/local/bin
    /sbin
    /usr/sbin
    /usr/local/sbin
    /usr/games
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/treball/tall_i_confeccio_articles/2024/Cross_Terms/SemiKep_PNX/PN_Cross/bin"
    "$HOME/treball/simulacions/GWtools/bin"
)

manpath=(
    "$X11HOME/man"
    /usr/X11R6/man
    /usr/man
    /usr/lang/man
    /usr/local/man
    /usr/share/man
    "$HOME/treball/simulacions/nemo"
    "$HOME/treball/supermongolodeiu/man"
    $manpath
)

export PATH MANPATH

# BSD colorls / ls colour definition string
export LSCOLORS="Exfxcxdxbxegedabagacad"

# Pass raw ANSI colour control sequences through `less`
export LESS="-R"

# Default editors and pagers (using zero-fork $commands[...] lookup)
export EDITOR="vim"
export VISUAL="vim"
export FCEDIT="vim"
export PAGER="${commands[less]:-less}"

# OS-dependent Fortran compiler and Zsh built-in help directory:
# - OpenBSD ports name the GNU Fortran compiler `egfortran` and place zsh help
#   under /usr/local/share/zsh/help (or /usr/local/lib/zsh/help).
# - GNU/Linux distributions name it `gfortran` and store help under /usr/share/zsh/help.
if (( IS_OPENBSD )); then
    export FC="${commands[egfortran]:-egfortran}"
    if [[ -d /usr/local/share/zsh/help ]]; then
        export HELPDIR="/usr/local/share/zsh/help"
    else
        export HELPDIR="/usr/local/lib/zsh/help"
    fi
elif (( IS_LINUX )); then
    export FC="${commands[gfortran]:-gfortran}"
    export HELPDIR="/usr/share/zsh/help"
fi

# TeX / LaTeX / BibTeX search paths (trailing double-colon `::` appends system defaults)
export TEXINPUTS=".:$HOME/fitx_confg/texinputs/::"
export BIBINPUTS=".:$HOME/fitx_confg/texinputs/:$HOME/articles/::"
export BSTINPUTS=".:$HOME/fitx_confg/texinputs/::"

# Source LALSuite environment if needed
# [[ -f "$HOME/treball/simulacions/lal/etc/lalsuite-user-env.sh" ]] && \
#     source "$HOME/treball/simulacions/lal/etc/lalsuite-user-env.sh"


# ******************** 5. Shell Options & Keybindings ******************** #

setopt extendedglob         # Treat '#', '~', and '^' as patterns for filename generation
setopt nohup                # Do not send HUP signal to running jobs when the shell exits
setopt autocd               # If a command is a directory name, perform 'cd' to it automatically
setopt rmstarwait           # Wait 10 seconds before executing 'rm *'
setopt correctall           # Try to correct the spelling of all arguments in a line
setopt interactivecomments  # Allow '# comments' even inside interactive command lines

# Enable Vi command-line editing mode (`set -o vi`)
bindkey -v

# Restore standard cursor movement, backspace, and incremental search inside Vi insert mode.
# Different terminal emulators (xterm, st, urxvt, wscons) emit different escape sequences
# for Home and End; binding all three variants guarantees compatibility across OpenBSD & Linux.
bindkey "^[[H"  beginning-of-line                  # Home (xterm / Linux console)
bindkey "^[OH"  beginning-of-line                  # Home (Application mode / BSD)
bindkey "^[[1~" beginning-of-line                  # Home (vt220 / urxvt / tmux)
bindkey "^[[F"  end-of-line                        # End  (xterm / Linux console)
bindkey "^[OF"  end-of-line                        # End  (Application mode / BSD)
bindkey "^[[4~" end-of-line                        # End  (vt220 / urxvt / tmux)
bindkey "^R"    history-incremental-search-backward # Ctrl+R
bindkey "^S"    history-incremental-search-forward  # Ctrl+S
bindkey "^?"    backward-delete-char               # Backspace (DEL)
bindkey "^H"    backward-delete-char               # Backspace (BS)

# Rationalise dot: typing '...' expands to '../..', and each subsequent '.' adds '/..'
rationalise-dot() {
    if [[ $LBUFFER == *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# Do not trigger rationalise-dot while typing a literal dot inside Ctrl+R / Ctrl+S search
bindkey -M isearch . self-insert


# ******************** 6. History Configuration ******************** #

HISTSIZE=9000                                  # Number of lines kept in memory per session
SAVEHIST=9000                                  # Number of lines saved to disk (required!)
HISTFILE="$HOME/fitx_confg/zsh/zsh_historia"   # Persistent history file location

# Ensure the parent directory for the history file exists so Zsh never fails silently
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

setopt hist_ignore_all_dups  # If a new command duplicates an older one, remove the older one
setopt hist_ignore_space     # Do not record commands starting with a leading space
setopt hist_reduce_blanks    # Strip superfluous whitespace before recording a command
setopt inc_append_history    # Append commands to $HISTFILE immediately, not just on exit


# ******************** 7. Completion System ******************** #

# Load and initialize the modern completion system (`compinit`).
autoload -Uz compinit
if [[ -f "${ZDOTDIR:-$HOME}/.zcompdump" ]]; then
    compinit -C
else
    compinit
fi

# Configure completion styles: exact match first, then pattern match, then 1-typo approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Automatically find new binaries placed in $PATH without needing manual `rehash`
zstyle ':completion:*' rehash true

# Ignore object files, backups, IDL .pro files, and Fortran .mod files during tab completion
fignore=(.o .old .pro .mod)

# Bilingual (English / Catalan) spelling correction prompt
SPROMPT='
-Barbarian: Did you maybe mean >> %B%r%b << instead of %R, my dearest bud of wallflower, %n?
-Catala:    Potser volies dir >> %B%r%b << en comptes de %R, poncella de violer, %n?
[nyae]? '


# ******************** 8. Prompt Configuration ******************** #
# Renders the exact two-line prompt layout:
#   -(~/treball/tall_i_confeccio_articles/2024)-------------------------(13:21)-
#   aemonius(p1)| 
#
# Line 1: `-(%~)` on the left, hyphen padding across $COLUMNS, `(%T)-` on the right.
# Line 2: `%m` (hostname) + `(%l)` (short tty name, e.g. p1) + `| ` (or `# ` if root).

autoload -Uz add-zsh-hook
setopt prompt_cr prompt_subst prompt_percent

prompt_pau_precmd() {
    setopt noxtrace localoptions

    # Expand current directory (%~) and 24h time (%T) to compute exact character widths
    local exp_pwd="${(%):-%~}"
    local exp_time="${(%):-%T}"

    local left_part="-(${exp_pwd})"
    local right_part="(${exp_time})-"

    # Calculate how many hyphens are needed to span the full terminal width
    local pad_width=$(( COLUMNS - ${#left_part} - ${#right_part} ))
    local top_line

    if (( pad_width >= 1 )); then
        # Fill the gap between `-(path)` and `(HH:MM)-` with hyphens
        local hyphens="${(l:${pad_width}::-:)}"
        top_line="${left_part}${hyphens}${right_part}"
    else
        # If the directory path is longer than the terminal width, truncate the left
        # side of the path with '...' so the top bar never wraps onto a third line
        local max_pwd=$(( COLUMNS - ${#right_part} - 4 ))
        (( max_pwd < 5 )) && max_pwd=5
        local trunc_pwd="${(%):-%${max_pwd}<...<%~%<<}"
        local rem_pad=$(( COLUMNS - ${#trunc_pwd} - 3 - ${#right_part} ))
        (( rem_pad < 1 )) && rem_pad=1
        local hyphens="${(l:${rem_pad}::-:)}"
        top_line="-(${trunc_pwd})${hyphens}${right_part}"
    fi

    # Set PS1 (bold white monochrome to match the terminal screenshot)
    PS1="%B${top_line}"$'\n'"%m(%l)%(!.#.|) %b"
    PS2="%B%_> %b"
    PS3="%B?# %b"

    # Keep user-typed text bold
    zle_highlight[(r)default:*]="default:bold"
}

add-zsh-hook precmd prompt_pau_precmd


# ******************** 9. Terminal Title & Exit Trap ******************** #

# Set xterm/st/rxvt window title to "command — user@hostname: /current/dir"
title() {
    [[ $TERM == (xterm*|rxvt*|st*|alacritty*|tmux*|screen*) ]] || return
    print -Pn "\e]2;$1:q\a"
}

preexec_set_title() {
    title "$1 — $USER@%m: %35<...<%~"
}
add-zsh-hook preexec preexec_set_title

# Redefine exit message in a silly way (I know)
_exit() {
    print -P "%B%F{red}fins després, plaerdemavida%f%b"
}
trap _exit EXIT


# ******************** 10. Functions ******************** #

# "Kill" searches for a process by name, prints its PID(s), and sends SIGKILL (-9).
# Uses `pgrep -f` (available on both OpenBSD and GNU/Linux) with a `ps -ax` fallback.
Kill() {
    if [[ -z $1 ]]; then
        print "Usage: Kill <process_pattern>"
        return 1
    fi
    local pids
    if (( $+commands[pgrep] )); then
        pids=( $(pgrep -f -- "$1") )
    else
        pids=( $(ps -ax | grep -- "$1" | grep -v grep | awk '{ print $1 }') )
    fi

    if (( ${#pids} == 0 )); then
        print "No running process matches '$1'."
        return 1
    fi

    print -n "Killing $1 (PID #${pids[*]})... "
    kill -9 "${pids[@]}" && print "done."
}

# "extract" unpacks any compressed or tarred archive passed as $1.
# Uses lowercase conversion `${1:l}` so `.TAR.GZ` and `.tar.gz` match identically.
extract() {
    if [[ -f $1 ]]; then
        case "${1:l}" in
            *.tar.bz2|*.tbz2) tar xvjf        "$1" ;;
            *.tar.gz|*.tgz)   tar xvzf        "$1" ;;
            *.tar.xz|*.txz)   tar xvJf        "$1" ;;
            *.tar.zst)        tar --zstd -xvf "$1" ;;
            *.bz2)            bunzip2         "$1" ;;
            *.rar)            unrar x         "$1" ;;
            *.gz)             gunzip          "$1" ;;
            *.tar)            tar xvf         "$1" ;;
            *.zip)            unzip           "$1" ;;
            *.z)              uncompress      "$1" ;;
            *.7z)             7z x            "$1" ;;
            *.xz)             unxz            "$1" ;;
            *) print "What the heck is that '$1'? I have no idea what to do here, plonker..." ;;
        esac
    else
        print "I don't have the slightest idea of what is this '$1'..."
        return 1
    fi
}

# Helper for `open`: executes the first installed binary from the candidate list
# using Zsh's internal `$commands` hash table (zero external `which` calls).
_open_with_first() {
    local target="$1"; shift
    local bin
    for bin in "$@"; do
        if (( $+commands[$bin] )); then
            "$bin" "$target"
            return 0
        fi
    done
    return 1
}

# "open" opens any file $1 according to its extension using preferred lightweight tools.
open() {
    if [[ ! -f $1 ]]; then
        print "I don't have the slightest idea of what is this '$1'... Or maybe you got the wrong path?"
        return 1
    fi

    case "${1:l}" in
        # Source code, LaTeX manuscripts, shell/Python scripts, Fortran & C/C++
        *.tex|*.bbl|*.bib|*.bst|*.sty|*.cls|*.sh|*.py|*.pl|*.txt|*.md|*.f|*.f90|*.f95|*.for|*.c|*.cpp|*.h|*.hpp|*.gnu|*.gp|makefile)
            _open_with_first "$1" vim vi nvi || \
                print "You don't have either vim, nor vi, nor nvi. And I will _not_ use emacs, man... I give up."
            ;;

        # PostScript, PDF, and scientific documents
        *.pdf|*.ps|*.eps|*.ps.gz|*.eps.gz|*.djvu)
            _open_with_first "$1" evince atril mupdf xpdf zathura gv || \
                print "You don't have either evince, nor atril, nor mupdf nor xpdf... I give up."
            ;;

        # Plots and raster images
        *.jpg|*.jpeg|*.png|*.gif|*.bmp|*.tiff|*.webp|*.svg)
            if (( $+commands[eog] )); then
                eog "$1"
            elif (( $+commands[eom] )); then
                eom "$1"
            elif (( $+commands[qiv] )); then
                qiv -t "$1"
            elif (( $+commands[feh] )); then
                feh "$1"
            else
                print "You don't have eog, eom, qiv, or feh installed."
            fi
            ;;

        # Video and audio streams
        *.ogg|*.ogv|*.mp4|*.mkv|*.avi|*.flv|*.mov|*.webm|*.mp3|*.flac|*.wav)
            _open_with_first "$1" vlc xine mplayer mpv || \
                print "You don't have vlc, xine, mplayer, or mpv installed."
            ;;

        # Office documents
        *.doc|*.docx|*.odp|*.ods|*.odt|*.xls|*.xlsx|*.rtf)
            _open_with_first "$1" libreoffice soffice || \
                print "You do not have libreoffice... sorry, mate."
            ;;

        # Compressed archives -> delegate directly to `extract`
        *.tgz|*.tar.bz2|*.tar.gz|*.tar.xz|*.txz|*.tar.zst|*.tar|*.tbz2|*.zip|*.z|*.7z|*.bz2|*.gz|*.xz)
            extract "$1"
            ;;

        *)
            print "What the heck is that '$1'? I am lost, man..."
            ;;
    esac
}


# ******************** 11. Aliases (OS-Aware: OpenBSD vs GNU/Linux) ******************** #

# Safe deletion script (falls back to interactive `rm -i` if ~/bin/fem.sh is absent on a machine)
if [[ -x "$HOME/bin/fem.sh" ]]; then
    alias rm='$HOME/bin/fem.sh'
else
    alias rm='rm -i'
fi

# Prevent spelling correction on file/directory creation and movement commands
alias mv='nocorrect mv -f'
alias cp='nocorrect cp -p'
alias mkdir='nocorrect mkdir'

# Directory stack, jobs, and quick exit
alias d='dirs -v'
alias j='jobs -l'
alias e='exit'

# Global aliases for fast upward directory traversal (works with `autocd` or after `cd`)
alias -g '...'='../..'
alias -g '....'='../../..'
alias -g '.....'='../../../..'

# OS-Specific Aliases:
if (( IS_OPENBSD )); then
    # --- OpenBSD ---
    # Use `colorls` from ports if installed, otherwise standard OpenBSD `ls -F`
    if (( $+commands[colorls] )); then
        alias ls='colorls -GF'
    else
        alias ls='ls -F'
    fi

    # OpenBSD `cal` supports `-m` (Monday first) and `-w` (week numbers),
    # and OpenBSD `date` supports `%v` (dd-Mmm-yyyy).
    alias cal='cal -mw ; date "+Today is %v, %Hh%M"'

    # Quick OpenBSD package/system helpers
    alias top='top -s 1'
    alias df='df -h'
    alias du='du -h'

elif (( IS_LINUX )); then
    # --- GNU/Linux ---
    # GNU coreutils `ls` uses `--color=auto` instead of `-G`
    alias ls='ls --color=auto -F'

    # On Linux, util-linux `cal` uses `--monday --week`, while BSD `ncal` uses `-M -w`.
    # GNU `date` also supports `%e-%b-%Y` as the exact equivalent of BSD `%v`.
    if cal --monday --week >/dev/null 2>&1; then
        alias cal='cal --monday --week ; date "+Today is %e-%b-%Y, %Hh%M"'
    elif (( $+commands[ncal] )); then
        alias cal='ncal -b -M -w ; date "+Today is %e-%b-%Y, %Hh%M"'
    else
        alias cal='cal ; date "+Today is %e-%b-%Y, %Hh%M"'
    fi

    alias df='df -hT'
    alias du='du -h'

else
    # --- Fallback for other UNIX systems (FreeBSD / macOS / NetBSD) ---
    alias ls='ls -GF'
    alias cal='cal ; date "+Today is %v, %Hh%M"'
fi

# Recursive size-sorted listing (uses whichever `ls` alias was selected above)
alias la='ls -F -lartsRh | sort -nr'

# Verbose, archive-preserving, compressed rsync with progress bar
alias rsync='rsync --relative --delete --archive --verbose --compress --human-readable --progress --times'

# Nightly GitHub repository synchronisations
alias hecate-sync='python3 ~/Hamiltonian_partitioning/scripts/nightly_sync.py'
alias dncag-sync='python3 ~/DNCAG_EMRI/scripts/nightly_sync.py'

# Sync both HECATE and DNCAG_EMRI in one command
alias night-sync='hecate-sync && dncag-sync'
