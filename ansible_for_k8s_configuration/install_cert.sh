

		cert.properties
		================
export SRC_CERT_PATH=/tmp/company-root.crt
export CERT_ALIAS=company_cert
export DEST_PATH=/etc/ssl/certs/java/cacerts
export KEY_PASSWORD=`openssl enc -d -aes-256-cbc-a -pbkdf2 -in cert_pass.enc -pass file:master.key`

		install_cert.sh
		================

#!/bin/bash

source cert.properties

if [ ! -f "$SRC_CERT_PATH" ]; then
    echo "Certificate not found at sorce $SRC_CERT_PATH" to install
    exit 1
fi

# Check if certificate already exists in keystore
keytool -list -keystore "$DEST_PATH" -storepass "$KEY_PASSWORD" -alias "$CERT_ALIAS" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "Certificate with alias $CERT_ALIAS already exists."
	EXPIRY=$(keytool -list -v -keystore "$DEST_PATH" \
        -storepass "$KEY_PASSWORD" \
        -alias "$CERT_ALIAS" | grep "until")

    echo "Certificate expiry date:"
    echo "$EXPIRY"
else
    echo "Importing certificate..."

    keytool -importcert \
        -alias "$CERT_ALIAS" \
        -file "$SRC_CERT_PATH" \
        -keystore "$DEST_PATH" \
        -storepass "$KEY_PASSWORD" \
        -noprompt

    if [ $? -eq 0 ]; then
        echo "Certificate successfully imported."
		
		EXPIRY=$(keytool -list -v -keystore "$DEST_PATH" \
        -storepass "$KEY_PASSWORD" \
        -alias "$CERT_ALIAS" | grep "until")

		echo "Certificate expiry date:"
		echo "$EXPIRY"
    else
        echo "Certificate import failed."
        exit 1
    fi
fi
