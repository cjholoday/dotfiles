# Print an X509 certificate. This function is overloaded. It takes a single argument that can be either...
#  (A) A path to a PEM/DER certificate
#  (B) A PEM string beginning with "---"
function showcert() {
    local input="$1"

    if [[ -z "$input" ]]; then
        echo "Format: showcert INPUT"
        echo
        echo "where INPUT is a file path to an x509 certificate or a PEM string beginning with '---'"
        return 1
    fi

    # If the input begins with '---' assume it is a PEM string like '-------BEGIN CERTIFICATE------- ...'
    if [[ $input == ---* ]] ; then
        local pem_string="$input"
        echo "$pem_string" | openssl x509 -text -noout
        return
    fi

    local cert_path="$input"
    openssl x509 -text -noout -in "$cert_path"
}

# Print the certificates in a PEM file
function showcerts() {
    local input="$1"

    if [[ -z "$input" ]]; then
        echo "Format: showcert INPUT"
        echo
        echo "where INPUT is a file path to a bundle of x509 certificates or a PEM string beginning with '---'"
        return 1
    fi

    if [[ $input == ---* ]]; then
        local pem_data="$input"
    else
        local pem_path="$input"
        local pem_data="$(cat "$pem_path")"
    fi

    # Read the file and extract each certificate block
    awk '
    /-----BEGIN CERTIFICATE-----/ {in_cert=1; cert=""; }
    in_cert { cert = cert $0 "\n"; }
    /-----END CERTIFICATE-----/ {
        in_cert=0;
        # Pipe the certificate to openssl for printing
        cmd = "openssl x509 -text -noout"
        print cert | cmd
        close(cmd)
        print "\n====================================\n"
    }
    ' <(echo "$pem_data")

    echo "<end of bundle>"
}

# Print the certificates inside of a PFX file
function showpfx() {
    local pfx_path="$1"

    if [[ -z "$pfx_path" ]]; then
        echo "Format: showcert PFX_PATH"
        echo "    where PFX_PATH is a file path to a PFX file"
        return 1
    fi

    echo "Enter the PKCS12 file password:"
    read -s password

    # List out all certificates in the PKCS12 file in PEM form
    echo "-----------------------------------------------------------------"
    echo "All certificates in the PKCS12 file in PEM form:"
    echo "-----------------------------------------------------------------"
    openssl pkcs12 -legacy -in "$pfx_path" -nokeys -passin pass:"$password"

    echo
    echo
    echo
    echo "-----------------------------------------------------------------"
    echo "The signing certificate / leaf certificate / client certificate:"
    echo "-----------------------------------------------------------------"
    openssl pkcs12 -legacy -in "$pfx_path" -nokeys -clcerts -chain -passin pass:"$password" | openssl x509 -noout -text
}

# Print fingerprints for an X509 certificate.  This function is overloaded. It takes a single argument that can be either...
#  (A) A path to a PEM/DER certificate
#  (B) A PEM string beginning with "---"
function showfp() {
    local input="$1"

    if [ -z "$input" ]; then
        echo "Format: showfp INPUT"
        echo
        echo "where INPUT is a file path to an x509 certificate or a PEM string beginning with '---'"
        return
    fi

    # If the input begins with '---' assume it is a PEM string like '-------BEGIN CERTIFICATE------- ...'
    if [[ $input == ---* ]] ; then
        local pem_string="$input"
        return
    else
        local cert_path="$input"
        local pem_string="$(cat "$cert_path")"
    fi

    echo "$pem_string" | openssl x509 -noout -fingerprint -sha256
    echo "$pem_string" | openssl x509 -noout -fingerprint -sha1
}


# Print out the certificates in the PKCS7 file. This function is overloaded. It takes a single argument that can be either...
#  (A) A path to a PEM/DER PKCS7 file
#  (B) A PEM string beginning with "---"
showp7() {
    local input="$1"

    if [ -z "$input" ]; then
        echo "Format: showp7 INPUT"
        echo
        echo "where INPUT is a file path to a PKCS7 file or a string beginning with '---'"
        return
    fi

    # If the input string begins with '---' assume it is a PEM string like '-----BEGIN PKCS7----- ... '
    if [[ $input == ---* ]] ; then
        local pkcs7_data="$input"
    else
        local pkcs7_path="$input"
        local pkcs7_data="$(cat "$pkcs7_path")"
    fi

    if [[ $pkcs7_data == ---* ]]; then
        local encoding_format='PEM'
    else
        local encoding_format='DER'
    fi

    echo '-----------------------------------------'
    echo "PKCS7 contents presented hierarchically:"
    echo '-----------------------------------------'
    echo
    echo "$pkcs7_data" | openssl cms -cmsout -inform "$encoding_format" -noout -print
    echo
    echo '-----------------------------------------'
    echo 'Certificates in PKCS7 File:'
    echo '-----------------------------------------'
    echo
    echo "$pkcs7_data" | openssl cms -cmsout -inform "$encoding_format" -noout -certsout >(showcerts /dev/stdin)
}