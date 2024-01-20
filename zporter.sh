#!/bin/bash

CYAN="\e[1;36m"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

output=""
prange="1 65535"

# pscan() {
#     local host=$1
#     local command

#     command="seq $prange | xargs -P 100 -I {} httpx -silent -sc -cl -title -u ${host}:{}"

#     if [ -n "$output_file" ]; then
#         command+=" | tee -a $output_file"
#         # seq $prange | xargs -P 100 -I {} httpx -silent -sc -cl -title -u "${host}:{}" | tee -a "$output_file"
#     fi

#     eval "$command"
# }

displayusage() {
    echo -e "${CYAN}OPTIONS:${NC}"
    echo -e "  -d <domain or IP>            Specify a single domain or IP to scan"
    echo -e "  -l <list of domains>         Specify a file containing a list of domains to scan"
    echo -e "  -o <output file>             Specify the output file to save scan results"
    echo -e "  -h                           Display this help message"
    echo -e "${CYAN}EXAMPLE:"
    echo -e "${YELLOW}      ./zporter.sh -d x.com -o out.txt${NC}"
    echo -e "${YELLOW}      ./zporter.sh -l list.txt -o out.txt${NC}"
}

pscan() {
    local host=$1

    if [ -n "$output" ]; then
        echo -e "${GREEN} results will be saved --> ${YELLOW}${output}${NC}\n"
        seq $prange | xargs -P 100 -I {} httpx -silent -sc -cl -title -u ${host}:{} | tee -a "$output"
    else
        seq $prange | xargs -P 100 -I {} httpx -silent -sc -cl -title -u ${host}:{}
    fi
}

filter() {
    local input=$1

    echo "$input" | grep -oP '^(?:http:\/\/|https:\/\/)?\K[^\/\?:#]+' | sort -u # i realy hate this ):
}

while [[ $# -gt 0 ]]; do
    case "$1" in
    -d)
        single_domain="$2"
        shift
        ;;
    -l)
        file="$2"
        if [ ! -f "$file" ]; then
            echo -e "${RED}FILE NOT FOUND! --> $file${RESET}" >&2
            exit 1
        fi
        shift
        ;;
    -o)
        output="$2"
        if [ -z "$output" ]; then
            echo -e "${RED}NO OUTPUT FILE SPECIFIED!${RESET}" >&2
            exit 1
        fi
        output_valid="true"
        if [ ! -w "$(dirname "$output")" ]; then
            echo -e "${RED}FILE PATH IS WRONG --> $output${RESET}" >&2
            exit 1
        fi
        shift
        ;;
    -h)
        displayusage
        exit 0
        ;;
    \?)
        echo -e "${RED}INVALID OPTION -$OPTARG${RESET}" >&2
        displayusage
        exit 1
        ;;
    :)
        echo -e "${RED}OPTION -$OPTARG REQUIRES AN ARGUMENT!${RESET}" >&2
        displayusage
        exit 1
        ;;
    *)
        echo -e "${RED}FLAG PROVIDED BUT NOT DEFINED --> $1${RESET}" >&2
        exit 1
        ;;
    esac
    shift
done

if [ -n "$file" ]; then
    # if [ ! -f "$file" ]; then
    #     echo -e "${YELLOW}File $file does not exist.${NC}"
    #     exit 1
    # fi

    while IFS= read -r line; do
        domain=$(filter "$line")
        pscan "$domain"
    done <"$file"

elif [ -n "$single_domain" ]; then
    domain=$(filter "$single_domain")
    pscan "$domain"
else
    displayusage
fi
