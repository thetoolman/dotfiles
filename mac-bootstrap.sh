
## prime for zsh

dotFolder="$(dirname "${BASH_SOURCE}")";

# git pull origin main;

function doIt() {

# T4 selective symlinks 
#if [ -f ~/.bash_profile ]
for file in ".zshrc" ".aliases" ; do

# ensure nothing is in the way
backupSymlinkFix $file

# make symlink
ln -s "$dotFolder"/"$file" ~/"$file"

done




	source ~/.bash_profile;
}


function backupSymlinkFix() {
bsfFile="$1"
# exists ?
if [[ -e ~/"$bsfFile" ]]; then
	# is a (file / symlink) ?
	if [[ -f ~/"$bsfFile" ]]; then
		if [[ -L ~/"$bsfFile" ]]; then
			echo "$bsfFile is a symlink: delete"
			rm -f ~/"$bsfFile"
		else
			echo "$bsfFile is a regular file: move to backup"
			mv ~/"$bsfFile" ~/"$bsfFile-`date -Iseconds`"
		fi
	else
		# file is a directory or something? bail.
		echo "ERROR: $bsfFile is a dir or special, abort."
		exit
	fi
else 

	if [[ -L ~/"$bsfFile" ]]; then
		echo "$bsfFile is a dead symlink: delete "
		rm -f ~/"$bsfFile"	
	else
		# no file, no-op
		echo "$bsfFile doesnt exist."
	fi


fi
}


if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This will rename existing dot files in your home directory, and delete existing dotfile symlinks: Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;

unset backupSymlinkFix;
unset doIt;
