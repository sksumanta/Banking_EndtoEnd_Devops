		sftp.properties
		================

export sftp_user=your_sftp_user
export sftp_host=internal-server.local
export sftp_path=/remote/path/
export sftp_pass=`openssl enc -d -aes-256-cbc-a -pbkdf2 -in sftp_pass.enc -pass file:master.key`

	
		copy_file_from_sftp_server.sh
		===============================
#!/bin/bash

# Usage: ./sftp_copy.sh <file_name> <destination_path>

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <file_name> <destination_path>"
    exit 1
fi

FILE_NAME="$1"
DEST_PATH="$2"

source sftp.properties 

mkdir -p "$DEST_PATH"

sshpass -p ${sftp_pass} sftp ${sftp_user}@${sftp_host} <<EOF
get "${sftp_path}${FILE_NAME}" "${DEST_PATH}/${FILE_NAME}"
bye
EOF

echo "File '$FILE_NAME' copied to '$DEST_PATH'"


