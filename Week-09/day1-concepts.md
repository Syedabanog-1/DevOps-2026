# 🐍 Week 09 - Day 1: Python for DevOps

## 🎯 Overview
Python is the glue of modern DevOps. Unlike Bash, Python provides robust error handling, data structures, and libraries for interacting with Cloud APIs, Kubernetes, and OS-level resources.

## 🚀 Why Python for DevOps?
1. **Readability**: Easier to maintain complex logic than Bash.
2. **Library Ecosystem**: `requests` (APIs), `os`/`subprocess` (CLI interaction), `argparse` (CLI tools).
3. **Data Handling**: Native support for JSON, YAML, and CSV.
4. **Cloud SDKs**: `boto3` (AWS), `azure-sdk-for-python`, `google-cloud-python`.

## 🛠 Core Libraries to Master
- **`os` & `sys`**: Interacting with the operating system and environment variables.
- **`subprocess`**: Running shell commands and capturing their output safely.
- **`argparse`**: Creating professional CLI tools with flags and help menus.
- **`requests`**: Making HTTP calls to health endpoints or APIs.
- **`json`**: Parsing and generating configuration data.

## 📝 Key Reference Commands
```python
# Capturing shell output safely
import subprocess
result = subprocess.run(['df', '-h'], capture_output=True, text=True)
print(result.stdout)

# Reading an environment variable
import os
db_url = os.getenv('DATABASE_URL', 'localhost:5432')

# Simple CLI parser
import argparse
parser = argparse.ArgumentParser(description='DevOps Tool')
parser.add_argument('--force', action='store_true')
args = parser.parse_args()
```

## 🧠 Best Practices
- **Use Virtual Environments (`venv`)**: Avoid polluting system Python.
- **Error Handling**: Use `try/except` blocks to prevent scripts from crashing silently.
- **Exit Codes**: Always return `sys.exit(0)` for success or `sys.exit(1)` for failure.
- **Shebang**: Use `#!/usr/bin/env python3` for portability.
