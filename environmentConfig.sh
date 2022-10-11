function misc_envTool()
{
	git config --global core.autocrlf false

	remoteOrigin="https://github.com/qwertycody/Bash_Environment.git"
	
	cd ~
	
	git init
	git remote add origin "$remoteOrigin"

	fileList=( ".bash_profile" "environmentConfig.sh" "README.md" )

	if [ "$1" == "push" ]; then
	
		for file in "${fileList[@]}"
		do
			git add "$file"
		done
	
		cd "$SCRIPTS"
		git add *
		cd ~
		git commit -m "Automated Push"
		git push --force -u origin master
	fi

	if [ "$1" == "pull" ]; then
		for file in "${fileList[@]}"
		do
			rm -f "$file"
		done
	
		rm -Rf "$SCRIPTS"
	
		git pull origin master
	fi
	
	cd ~
	rm -Rf .git/
	
	if [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
		echo "source .bash_profile" > .bashrc
	fi
}

alias envTool="misc_envTool"
