# Enterprise SIEM & XDR Home Lab (Wazuh 4.11.2)

A self-hosted **Security Information and Event Management (SIEM)** and **Extended Detection and Response (XDR)** home lab deployed with **Wazuh v4.11.2**, **Docker Compose**, and **Ubuntu Server**. This project demonstrates end-to-end log ingestion, SSH dictionary brute-force simulation, correlation rule engineering, and **MITRE ATT&CK** threat mapping.

## Architecture & Data Flow

```mermaid
flowchart TD
    A["Simulated Attacker<br/>IP: 185.220.101.45"] -->|"8-User SSH Dictionary Brute-Force<br/>(attack.sh)"| B["Ubuntu Server VM (192.168.1.9)<br/>Wazuh Manager Container"]
    B -->|"Decodes SSHD Logs & Correlates<br/>Rule 5710 (Level 5) -> Rule 5712 (Level 10)"| C["Wazuh OpenSearch Indexer<br/>(MITRE ATT&CK T1110 Mapping)"]
    C -->|"HTTPS (Port 443)"| D["Wazuh SIEM Web Dashboard<br/>Threat Hunting & Alert Triage"]
    D -->|"SOC Hardening"| E["Remediation: SSH Keys Only,<br/>PermitRootLogin no, Active Response"]

    style A fill:#ffebee,stroke:#c62828,stroke-width:2px,color:#000
    style B fill:#e3f2fd,stroke:#1565c0,stroke-width:2px,color:#000
    style C fill:#fff3e0,stroke:#ef6c00,stroke-width:2px,color:#000
    style D fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px,color:#000
    style E fill:#f3e5f5,stroke:#6a1b9a,stroke-width:2px,color:#000
```

## Tech Stack & Environment

* **SIEM / XDR Engine:** Wazuh v4.11.2 (Wazuh Manager, OpenSearch Indexer, Wazuh Dashboard)
* **Containerization:** Docker Engine & Docker Compose (`single-node` deployment)
* **Host Infrastructure:** Isolated Ubuntu Server VM (`192.168.1.9`, 4 GB RAM) on Oracle VirtualBox (Bridged Networking)
* **Security Frameworks:** MITRE ATT&CK (`T1110`), Syslog / SSHD Rule Correlation (`Rules 5710 & 5712`)

## Attack Simulation & Detection Engineering

Executed [`attack.sh`](attack.sh) to simulate an **8-user SSH dictionary brute-force attack** (`root`, `admin`, `ubuntu`, `oracle`, `postgres`, `test`, `deploy`, `backup`) from external IP `185.220.101.45`:

* **Individual Failed Logins (`Rule ID: 5710`, Level 5):** Captured all 8 authentication attempts against non-existent accounts.
* **Correlated Brute-Force Alert (`Rule ID: 5712`, Level 10):** Automatically escalated the rapid authentication failures into a high-severity correlation alert (*"sshd: brute force trying to get access to the system. Non existent user"*).
* **MITRE ATT&CK Mapping:** Categorized under **Credential Access — Brute Force (`T1110`)**, **Password Guessing (`T1110.001`)**, and **SSH**.

## Lab Screenshots

### 1. Wazuh SIEM Overview Dashboard
![Wazuh SIEM Overview Dashboard](01-Wazuh-Dashboard.PNG)

### 2. Threat Hunting & MITRE ATT&CK Mapping (`Authentication failure: 8`)
![Threat Hunting & MITRE ATT&CK](02-threat-hunting-dashboard.PNG)

### 3. Correlated SSH Brute-Force Alert Triage (`Rule 5712` & `Rule 5710`)
![SSH Brute-Force Events](03-ssh-bruteforce-events.PNG)

## Remediation & Hardening Recommendations

* **Enforce SSH Key Authentication:** Set `PasswordAuthentication no` in `/etc/ssh/sshd_config`.
* **Enable Active Response:** Configure Wazuh `firewall-drop` to automatically block IPs triggering `Rule 5712`.
* **Restrict Root Login:** Set `PermitRootLogin no` and enforce least-privilege access controls.
