# zHTTP-portscaner

## Description
This script performs a port scan on given IP addresses or domains. It's designed to scan a range of ports and identify open ports using `httpx`.

## Features
- Scan a range of ports on multiple hosts.
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
./port_scan.sh -d example.com
```

To scan a list of domains/IPs from a file:

```bash
./port_scan.sh -l hosts.txt
```

### Advanced Usage
To specify an output file for the scan results:

```bash
./port_scan.sh -d example.com -o results.txt
```

To specify a custom port range:

```bash
./port_scan.sh -d example.com -p 1000-2000
```

## Options
- `-d <domain/IP>`: Specify a single domain or IP for scanning.
- `-l <file>`: Specify a file containing a list of domains/IPs to scan.
- `-o <output_file>`: (Optional) Specify an output file for the results.

## Disclaimer
This tool is for educational and ethical testing purposes only. The user is responsible for ensuring all scans comply with relevant laws and regulations.
