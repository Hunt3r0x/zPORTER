# zHTTP-portscaner

## Description
This script performs a port scan on given IP addresses or domains. It's designed to scan a range of ports and identify open ports using `httpx`.

## Features
- Scan a custom range of ports on multiple hosts.
- Option to specify custom port ranges.
- Output can be directed to a file.
- Handles both IP addresses and domain names, sanitizing input to extract only the domain or subdomain part.

## Requirements
- `httpx`
- `bash ENV`

## Usage

### Basic Usage
To scan a single domain or IP address with the default port range (1-65535):

```bash
./zporter.sh -d example.com
```

To scan a list of domains/IPs from a file:

```bash
./zporter.sh -l hosts.txt
```

### Advanced Usage
To specify an output file for the scan results:

```bash
./zporter.sh -d example.com -o results.txt
```

To specify a custom port range:

```bash
./zporter.sh -d example.com -range 1000-5000
```

## Options
- `d <domain or IP>     `:       Specify a single domain or IP to scan"
- `l <list of domains>  `:       Specify a file containing a list of domains to scan"
- `o <output file>      `:       Specify the output file to save scan results"
- `t <threads>`          :       Specify the number of threads for httpx (default is 50)"
- `range <start-end>    `:       Specify a port range (e.g., 1-1000)"
- `h                    `:       Display this help message"

## Disclaimer
This tool is for educational and ethical testing purposes only. The user is responsible for ensuring all scans comply with relevant laws and regulations.
