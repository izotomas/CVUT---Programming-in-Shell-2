#!/bin/zsh
#######################
#	script for backing up files or directories
#	creates a folder named backup_YYYYMMDD (if it doesn't exists) and copies all arguments in it
#	maintains an index file as list of copied items
#######################
# test arguments
if [ $# -lt 1 ]
then
	echo "$0[error]: Missing items to backup" >&2 # redirect to error output
	echo "$0[info]: Usage: $0 file..." >&2
	exit
fi
PREFIX=backup
# backup dir
BACKUP=~/${PREFIX}_$(date +%Y%m%d) # {} encapsulates the variable

# copy, and exit if copying fails (for example, a file with same name exists)
mkdir -p "$BACKUP" || exit
cp -r "$@" "$BACKUP"

# save exit code of copy operation (in case some files failed to copy)
EXIT=$?

# create index file
ls "$BACKUP" > "$BACKUP/index.txt"
exit "$EXIT"
