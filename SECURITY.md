Security Policy

Overview

Security is a core principle of ArbCore Pro.

The platform is designed with a security-first mindset and follows industry best practices for smart contract development, backend infrastructure and operational security.

This document outlines our security model, vulnerability reporting process and responsible disclosure guidelines.

⸻

Supported Versions

Version	Supported
1.x	Yes
0.x	No

⸻

Security Architecture

ArbCore Pro uses multiple layers of protection.

Infrastructure Security

* HTTPS Everywhere
* Environment Variable Isolation
* Secret Separation
* API Rate Limiting
* Request Validation
* Server Monitoring

⸻

Backend Security

Sensitive information is never exposed to the frontend.

Examples:

* Exchange API Secrets
* Wallet Private Keys
* RPC Credentials
* Treasury Credentials

All sensitive values must remain server-side.

Example:

PRIVATE_KEY=
BINANCE_SECRET=
RPC_URL=

⸻

Smart Contract Security

Core contracts utilize OpenZeppelin security standards.

Implemented modules:

* AccessControl
* Ownable2Step
* Pausable
* ReentrancyGuard
* SafeERC20

⸻

Risk Controls

The execution layer includes:

* Trade Size Limits
* Profit Threshold Validation
* Router Whitelisting
* Token Whitelisting
* Emergency Shutdown Procedures

⸻

Treasury Security

Treasury assets are isolated from execution logic.

Benefits:

* Reduced attack surface
* Better permission management
* Improved auditing
* Safer asset custody

⸻

Vulnerability Reporting

If you discover a security issue, please report it responsibly.

Do NOT publicly disclose vulnerabilities before they have been reviewed.

Please include:

* Detailed Description
* Reproduction Steps
* Impact Assessment
* Suggested Mitigation
* Screenshots or Logs (if applicable)

⸻

Responsible Disclosure

We ask security researchers to:

1. Report vulnerabilities privately.
2. Allow reasonable time for investigation.
3. Avoid public disclosure until a fix is available.
4. Avoid actions that may impact users or infrastructure.

⸻

Out of Scope

The following are generally considered out of scope:

* Social Engineering
* Physical Attacks
* Third-Party Service Outages
* Denial-of-Service Testing
* Vulnerabilities requiring stolen credentials

⸻

Security Checklist

Before every release:

* Smart contract tests completed
* Backend security review completed
* Dependency audit completed
* Environment variables verified
* Access controls verified
* Emergency pause verified
* Treasury permissions verified
* CI/CD security checks passed

⸻

Smart Contract Audit Status

Current Status:

Internal Review
External Audit Pending

⸻

Production Requirements

Before enabling live execution:

* Smart Contract Audit
* Penetration Testing
* Infrastructure Review
* Key Management Review
* Risk Engine Validation
* Monitoring Deployment

⸻

Contact

Security-related issues should be reported privately to the project maintainers.

Please do not disclose vulnerabilities publicly before review.

⸻

ArbCore Pro Security Team
