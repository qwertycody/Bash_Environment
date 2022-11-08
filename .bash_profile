#!/bin/bash
FILE_BASH_PROFILE="$HOME/.bash_profile"
FILE_BASH_PROFILE_PRIVATE="$HOME/.bash_profile_private"
FILE_ENVIRONMENT_CONFIG="$HOME/environmentConfig.sh"
SCRIPTS="$HOME/scripts"

BASH_PROFILE_FILE_LIST=( "$FILE_BASH_PROFILE" "$FILE_BASH_PROFILE_PRIVATE" "$FILE_ENVIRONMENT_CONFIG" )

TMUX_SESSION_NAME=$(whoami)
TMUX_SESSION_NAME="$TMUX_SESSION_NAME-tmux-session"

TMUX_DEFAULT_WINDOW_NAME="default"

SETAF_COLOR_RED="124"
SETAF_COLOR_YELLOW="58"

function echo_background_color_options()
{
	clear 

	n=256

	for f in $(seq $n)
	do
		tput setab "$f"
		printf "This is Option $f"
		tput sgr0
		printf "\n"
	done
}

function echo_foreground_color_options()
{
	clear 

	n=256

	for f in $(seq $n)
	do
		echo_foreground_color "$f" "This is Option $f"
	done
}

function echo_background_color()
{
	BACKGROUND_COLOR_CODE="$1"
	MESSAGE_TO_ECHO="$2"

	tput setab "$BACKGROUND_COLOR_CODE"
	echo -e "$MESSAGE_TO_ECHO$(tput sgr0)"
	tput sgr0
}

function echo_background_color_bold_underline()
{
	BACKGROUND_COLOR_CODE="$1"
	MESSAGE_TO_ECHO="$2"

	tput bold
	tput smul
	tput setab "$BACKGROUND_COLOR_CODE"
	echo -e "$MESSAGE_TO_ECHO$(tput sgr0)"
	tput sgr0
}

function echo_foreground_color()
{
	FOREGROUND_COLOR_CODE="$1"
	MESSAGE_TO_ECHO="$2"

	tput setaf "$FOREGROUND_COLOR_CODE"
	echo -e "$MESSAGE_TO_ECHO"
	tput sgr0
}

function echo_background_yellow()
{
	MESSAGE_TO_ECHO="$1"
	BACKGROUND_COLOR_CODE="$SETAF_COLOR_YELLOW"
	echo_background_color "$BACKGROUND_COLOR_CODE" "$MESSAGE_TO_ECHO"
}

function echo_background_red()
{
	MESSAGE_TO_ECHO="$1"
	BACKGROUND_COLOR_CODE="$SETAF_COLOR_RED"
	echo_background_color "$BACKGROUND_COLOR_CODE" "$MESSAGE_TO_ECHO"
}

function echo_background_red_bold_underline()
{
	MESSAGE_TO_ECHO="$1"
	BACKGROUND_COLOR_CODE="$SETAF_COLOR_RED"
	echo_background_color_bold_underline "$BACKGROUND_COLOR_CODE" "$MESSAGE_TO_ECHO"
}

function echo_italics()
{
	MESSAGE_TO_ECHO="$1"

	tput sitm
	echo -e "$MESSAGE_TO_ECHO"
	tput sgr0
}

function tmux_new()
{
	tmux_kill

	echo "[INFO] [TMUX] Starting New Attached Session at $TMUX_SESSION_NAME with Command $1"
	tmux new -n "$TMUX_DEFAULT_WINDOW_NAME" -s "$TMUX_SESSION_NAME" "$1" || echo "[FAILURE][TMUX] Failed to execute command $1"
}

function tmux_new_detached()
{
	tmux_kill

	echo "[INFO] [TMUX] Starting New Detached Session at $TMUX_SESSION_NAME with Command $1"
	tmux new -n "$TMUX_DEFAULT_WINDOW_NAME" -s "$TMUX_SESSION_NAME" -d "$1" || echo "[FAILURE][TMUX] Failed to execute command $1"
}

function tmux_resume()
{
	tmux a -t "$TMUX_SESSION_NAME"
}

function tmux_kill()
{	
	echo "[INFO] [TMUX] Killing User Session at $TMUX_SESSION_NAME"
	tmux kill-session -t "$TMUX_SESSION_NAME"
}

function tmux_help()
{
	clear 	
	echo ""

	echo_background_red_bold_underline "## Sessions - CTRL+B - Type Command - Press Enter ##"
	echo_italics "- :new \t = new session
- s \t = list sessions
- $ \t = name session"

	echo ""
	
	echo_background_red_bold_underline "## Windows (tabs) ##"
	echo_italics "- c \t = create window
- w \t = list windows
- n \t = next window
- p \t = previous window
- f \t = find window
- , \t = name window
- & \t = kill window"

	echo ""

	echo_background_red_bold_underline "## Panes (splits)"
	echo_italics '- % \t = vertical split
- " \t = horizontal split
- o \t = swap panes
- q \t = show pane numbers (press number to navigate to panel)
- x \t = kill pane
- + \t = break pane into window (e.g. to select text by mouse to copy)
- - \t = restore pane from window
- ⍽ \t = space - toggle between layouts
- { \t = (Move the current pane left)
- } \t = (Move the current pane right)
- z \t = toggle pane zoom'

	echo ""

	echo_background_yellow '[TIP] List all shortcuts = CTRL+B then ?'
	echo_background_yellow '[IMPORTANT][TMUX Prefix Chord] In tmux, do the following combination (hold the keys) for the prefix "CTRL KEY" then "B KEY" - then release.'
}

function tmux_config_create()
{
	# rm -f "$HOME/.tmux.conf"

	if [ ! -f "$HOME/.tmux.conf" ]; then
		echo "
# Default shell
set-option -g default-shell '/bin/bash'
# split panes using | and -
bind | split-window -h
bind - split-window -v
unbind '\"'
unbind %
# switch panes using Alt-arrow without prefix
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
# Legacy - Enable mouse control (clickable windows, panes, resizable panes)
# set -g mouse-select-window on
# set -g mouse-select-pane on
# set -g mouse-resize-pane on
# Current - Enable mouse mode (tmux 2.1 and above)
set -g mouse on
# dont rename windows automatically
set-option -g allow-rename off
######################
### DESIGN CHANGES ###
######################

# loud or quiet?
set -g visual-activity off
set -g visual-bell off
set -g visual-silence off
setw -g monitor-activity off
set -g bell-action none

#  modes
setw -g clock-mode-colour colour5
setw -g mode-style 'fg=colour1 bg=colour18 bold'

# panes
set -g pane-border-style 'fg=colour19 bg=colour0'
set -g pane-active-border-style 'bg=colour0 fg=colour9'

# statusbar
set -g status-position bottom
set -g status-justify left
set -g status-style 'bg=colour18 fg=colour137 dim'
set -g status-left ''
set -g status-right '#[fg=colour233,bg=colour19] %d/%m #[fg=colour233,bg=colour8] %H:%M:%S '
set -g status-right-length 50
set -g status-left-length 20

setw -g window-status-current-style 'fg=colour1 bg=colour19 bold'
setw -g window-status-current-format ' #I#[fg=colour249]:#[fg=colour255]#W#[fg=colour249]#F '

setw -g window-status-style 'fg=colour9 bg=colour18'
setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'

# messages
set -g message-style 'fg=colour232 bg=colour16 bold'" > "$HOME/.tmux.conf"

	fi
}

function tmux_sanity_test()
{
	# Examples:
	# - https://linuxize.com/post/getting-started-with-tmux/
	# - https://unix.stackexchange.com/questions/320465/new-tmux-sessions-do-not-source-bashrc-file

	tmux_config_create

	# Example:
	# - https://stackoverflow.com/a/5752901

	#!/bin/sh
	# tmux new-session -d 'vim'
	# tmux split-window -v 'ipython'
	# tmux split-window -h
	# tmux new-window 'mutt'
	# tmux -2 attach-session -d

	tmux_new_detached "ping google.com"
	tmux split-window -v "ping microsoft.com"

	echo ""
	echo_background_yellow "[INFO][TMUX] Session Built, press enter to continue..."	

	echo ""
	echo_background_red "[IMPORTANT][TMUX] Hold down the SHIFT key to be able to copy lines of text!"
	read

	tmux -2 attach-session -d
}

function follow_all_logs_tmux_option_1()
{
	tmux_config_create

	# Used to make sure we inherit the functions into the shell session
	SRC_PROFILE="source '$FILE_BASH_PROFILE'"
	
	# Create the Initial TMUX Session with bash command as default
	tmux_new_detached "$SRC_PROFILE && bash"

	# Create a new 'logging window'
	WINDOW_LOGGING="logging"

	tmux new-window -n "$WINDOW_LOGGING" "$SRC_PROFILE && mariadb_logs_follow"
	tmux split-window -t "$WINDOW_LOGGING" -h "$SRC_PROFILE && follow_all_logs"
	tmux join-pane -s "$TMUX_DEFAULT_WINDOW_NAME" -t "$WINDOW_LOGGING"
	
	echo ""
	echo_background_yellow "[INFO][TMUX] Session Built, press enter to continue..."
	echo ""
	echo_background_red "[IMPORTANT][TMUX] Hold down the SHIFT key to be able to copy lines of text!"
	echo ""
	echo "[INFO] Press enter to continue ..."
	read
	tmux -2 attach-session -d
}

function follow_all_logs_tmux_option_2()
{
	tmux_config_create

	# Used to make sure we inherit the functions into the shell session
	SRC_PROFILE="source '$FILE_BASH_PROFILE'"
	
	# Create the Initial TMUX Session with bash command as default
	tmux_new_detached "$SRC_PROFILE && follow_all_logs"

	# Create a new 'logging window'
	WINDOW_LOGGING="logging"

	tmux split-window -t "$TMUX_DEFAULT_WINDOW_NAME" -v "$SRC_PROFILE && mariadb_logs_follow"
	
	echo ""
	echo_background_yellow "[INFO][TMUX] Session Built, press enter to continue..."
	echo ""
	echo_background_red "[IMPORTANT][TMUX] Hold down the SHIFT key to be able to copy lines of text!"
	echo ""
	echo "[INFO] Press enter to continue ..."
	read
	tmux -2 attach-session -d
}

function pkill(){
	if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
		wmic Path win32_process Where "CommandLine Like '%$2%'" Call Terminate
	else
		/bin/pkill "$@"
	fi
}

function install_deb(){
	command -v sudo

	if [ "$?" == "0" ]; then
		sudo dpkg -i "$@"
		sudo apt-get -f install
	else
		echo "[INFO] sudo not detected as installed - running without elevation"
		dpkg -i "$@"
		apt-get -f install
	fi
}

function fix_logitech_headset()
{
	taskkill //f //im lcore.exe
	sleep 1
	start "" "/c/Program Files/Logitech Gaming Software/LCore.exe"
	sleep 5
}

function open_Program()
{
	DIR=$(dirname "${1}")
	cd "$DIR"
	start "" "$1"
}

function misc_search_activeDirectory()
{
	start "" "Rundll32" dsquery.dll OpenQueryWindow
}

function open_Here()
{
	start .
}

function bash_refresh()
{
	source "$HOME/.bash_profile"
}

function bash_edit()
{
	vscode_open_directory "$SCRIPTS"
	vscode_open_file "$HOME/.bash_profile"
	vscode_open_file "$HOME/.bash_profile_private"
}

function apache2_logs_open()
{
	vscode_open_directory "//var/log/apache2/"
}

function apache2_config_open()
{
	vscode_open_directory "//etc/apache2/"
}

function mariadb_logs_follow()
{
	# find "/var/lib/mysql" -name "*.log" | xargs sudo tail -f 
	find "/var/log/mysql/" -name "*.log" | xargs tail -f 
}

function ubuntu_add_spacer()
{
	uuid=$(uuidgen)
	tmp_filename="separator-$uuid.desktop"
	echo "[Desktop Entry]
Type=Application
Icon=$HOME/scripts/separator_vertical.png
Name=Unity Separator - $uuid" > "/tmp/$tmp_filename"
sudo mv "/tmp/$tmp_filename" "/usr/share/applications/$tmp_filename"
}

function follow_all_logs()
{
	pm2_logs_follow & 
	apache2_logs_follow &
	apache2_other_follow & 
	apache2_sym_follow
}

function pm2_logs_follow()
{
	find "/home/$USER/.pm2/logs" -name "*.log" | xargs tail -f | sed 's/\\n/\n/g'
}

function apache2_sym_follow()
{
	sudo find "/home/ubuntu/Documents/Repository/" -name "*.log" | xargs tail -f | sed 's/\\n/\n/g'
}

function apache2_other_follow()
{
	find "/var/www/html/" -name "*.log" | xargs tail -f | sed 's/\\n/\n/g'
}

function apache2_logs_follow()
{
	find "/var/log/apache2/" -name "*.log" | xargs tail -f | sed 's/\\n/\n/g'
}

function apache2_logs_find_error()
{
	find "/var/log/apache2/" -name "*.log" | xargs grep -i "$1" | sed 's/\\n/\n/g'
}

function phinx_create()
{
	./vendor/bin/phinx create $1
}

function phinx_migrate()
{
	./vendor/bin/phinx migrate
}

function phinx_rollback()
{
	./vendor/bin/phinx rollback -t 0
}

function redis_flush()
{
	redis-cli FLUSHALL
	token_generate
}

function php_config_open()
{
	vscode_open_directory "//etc/php/"
}

function misc_tomcat_start()
{
	cd "$1"
	cd bin
	sh startup.sh
	misc_tomcat_tail "$1"
}

function misc_tomcat_stop()
{
	cd "$1"
	cd bin
	sh shutdown.sh
	misc_tomcat_tail "$1"
}

function open_Docker()
{
	sh "/c/Program Files/Docker Toolbox/start.sh"
}

function misc_tomcat_tail()
{
	cd "$1"
	cd logs
	tail -f catalina.out
}

function open_Eclipse()
{
	open_Program "$ECLIPSE_PATH"
}

function open_SqlDeveloper()
{
	open_Program "$SQLDEVELOPER_PATH"
}

function vscode_open_file()
{
	if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
		start "" "$VSCODE_PATH" "$1"
	else
		"$VSCODE_PATH" "$1"
	fi
}

function vscode_open_directory()
{
	DIRECTORY_TO_OPEN="$1"

	if [ -z "$1" ]; then
		DIRECTORY_TO_OPEN=$(pwd)
	fi

	if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
		start "" "$VSCODE_PATH" "$DIRECTORY_TO_OPEN"
	else
		"$VSCODE_PATH" "$DIRECTORY_TO_OPEN"
	fi
}

function switchTo_privateScripts()
{
	cd "$PRIVATE_SCRIPTS"
}

function switchTo_scripts()
{
	cd "$SCRIPTS"
}

function help()
{
	commandsToOutput=""
	
	#Spaces in a String will mess up a for loop - https://askubuntu.com/questions/344407/how-to-read-complete-line-in-for-loop-with-spaces
	IFS=$'\n'

	for file in "${BASH_PROFILE_FILE_LIST[@]}"
	do
		commandsToOutput+=$(cat "$file" | grep "function " | sed 's/function //' | sed 's/{//' | sed 's/}//' |sed 's/()//' | grep -v ".bash_profile")
		commandsToOutput+="\n"
	done

	
	#Spaces in a String will mess up a for loop - https://askubuntu.com/questions/344407/how-to-read-complete-line-in-for-loop-with-spaces
	unset IFS

	echo "################################"
	echo "##### Available Functions: #####"
	echo "################################"
	
	echo "$commandsToOutput" | sort
}

function misc_Setup_Environment()
{
	if [ ! -f "$FILE_ENVIRONMENT_CONFIG" ]; then
		touch "$FILE_ENVIRONMENT_CONFIG"
	fi

	if [ ! -d "$SCRIPTS" ]; then
		mkdir "$SCRIPTS"
	fi

	PATH="$PATH:$SCRIPTS"

	#Create Private Bash File if Doesn't Exist and Seed with Variables
	if [ ! -f "$FILE_BASH_PROFILE_PRIVATE" ]; then
		touch "$FILE_BASH_PROFILE_PRIVATE"
		echo '#!/bin/bash' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo '' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'PRIVATE_SCRIPTS="$HOME/private_scripts"' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'PATH="$PATH:$PRIVATE_SCRIPTS"' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo '' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'PROXY_ADDRESS=""' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'PROXY_PORT=""' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'PROXY_BYPASS=""' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo '' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'ECLIPSE_PATH=""' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'SQLDEVELOPER_PATH=""' >> "$FILE_BASH_PROFILE_PRIVATE"
		echo 'VSCODE_PATH="code"' >> "$FILE_BASH_PROFILE_PRIVATE"
	fi

	#Spaces in a String will mess up a for loop - https://askubuntu.com/questions/344407/how-to-read-complete-line-in-for-loop-with-spaces
	IFS=$'\n'

	for file in "${BASH_PROFILE_FILE_LIST[@]}"
	do
		if [ "$file" != "$FILE_BASH_PROFILE" ]; then
			source "$file"
		fi
	done

	#Turn it off after - https://askubuntu.com/questions/344407/how-to-read-complete-line-in-for-loop-with-spaces
	unset IFS
}

function example_ssh_connect()
{
    ssh -i "$SERVER_KEYFILE" $SERVER_USERNAME@$SERVER_IPADDRESS
}

function example_ssh_reverseTunnel_connect()
{
    VARIABLE_REMOTE_SSH_SERVER="$SERVER_IPADDRESS"
    VARIABLE_REMOTE_SSH_PORT="22"
    VARIABLE_REMOTE_SSH_USER="ubuntu"
    VARIABLE_REMOTE_SSH_KEYFILE="$SERVER_KEYFILE"
    
    VARIABLE_LOCAL_PORT_FOR_RELAY="1993"
    
    VARIABLE_REMOTE_ADDRESS_FOR_RELAY="127.0.0.1"
    VARIABLE_REMOTE_PORT_FOR_RELAY="1993"

    pkill -f "$VARIABLE_LOCAL_PORT_FOR_RELAY"
    ssh -fN -o StrictHostKeyChecking=no -o ServerAliveInterval=50 -L $VARIABLE_LOCAL_PORT_FOR_RELAY:$VARIABLE_REMOTE_ADDRESS_FOR_RELAY:$VARIABLE_REMOTE_PORT_FOR_RELAY -l $VARIABLE_REMOTE_SSH_USER $VARIABLE_REMOTE_SSH_SERVER -p $VARIABLE_REMOTE_SSH_PORT -i "$VARIABLE_REMOTE_SSH_KEYFILE" &
    ssh -i "$VARIABLE_REMOTE_SSH_KEYFILE" $SERVER_USERNAME@$SERVER_IPADDRESS
}

function bash_save()
{	
	cd "$HOME"
	rm -Rf .git/
	remoteOrigin="https://github.com/qwertycody/Bash_Environment.git"
	git init
	git remote add origin "$remoteOrigin"
	git pull origin master
	
	git add "$HOME/.bash_profile"
	git add "$HOME/environmentConfig.sh"
	git add "$HOME/README.md"

	cd "$SCRIPTS"
	
	git add "."

	git commit -m "Updated"

	git push --force --set-upstream origin master

	rm -Rf "$HOME/.git/"
}

# Function to disable hardware keys on Teams so it doesn't hijack the play button on the keyboard
# - https://techcommunity.microsoft.com/t5/microsoft-teams/media-keys-and-teams-notifications/m-p/1949714
function fix_teams()
{
	pkill -f teams
	$HOME/AppData/Local/Microsoft/Teams/Update.exe --processStart "Teams.exe" -disable-features=HardwareMediaKeyHandling
}

misc_Setup_Environment
help
