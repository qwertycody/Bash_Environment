```bash
#Run the Below Commands for Setup
cd ~
rm -Rf .git/
remoteOrigin="https://github.com/qwertycody/Bash_Environment.git"
git init
git remote add origin "$remoteOrigin"
git pull origin master
rm -Rf .git/

#Task Scheduler Command Template for Startup Commands
#Program = %comspec%
#Arguments = /c start "" /min "C:\Program Files\Git\git-bash.exe" -c "fix_teams" ^& exit
```
