# M4 Clodfarm setup

This is a clean-room setup for running [Clodfarm](https://github.com/matank001/clodfarm) on a freshly reset M4 Mac. The farm runs autonomous Claude Code agents with `bypassPermissions`, while its projects, database, worktrees, and Claude state stay in Docker-managed volumes—not in macOS folders.

> **Important:** `bypassPermissions` permits an agent to execute arbitrary commands *inside its container*. Do not mount your home folder, a project folder, the Docker socket, cloud credentials, or personal SSH keys. Do not add Stripe, AWS, ad-platform, or browser logins until you deliberately accept that risk.

The only interactive steps are accepting the Homebrew/Docker prompts and completing Claude's device login.

## 1. Bootstrap the M4

Open Terminal and run these commands one block at a time.

```bash
xcode-select --install
```

When the macOS installer finishes:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install git gh
brew install --cask docker ollama
```

Launch Docker Desktop:

```bash
open -a Docker
```

Accept Docker Desktop's terms and recommended settings, wait until it reports that Docker is running, then verify it:

```bash
docker version
```

Start Ollama and wait for its local API:

```bash
open -a Ollama
until curl -fsS http://127.0.0.1:11434/api/tags >/dev/null; do sleep 2; done
```

## 2. Install the farm

```bash
mkdir -p ~/farm-host
cd ~/farm-host
git clone --depth 1 https://github.com/matank001/clodfarm.git
cd clodfarm
```

Create the farm configuration:

```bash
cat > .env <<'EOF'
FARM_NAME=home-m4-farm
FARM_MODEL=opus

# Fully autonomous agent execution inside the Docker container.
FARM_PERMISSION_MODE=bypassPermissions
FARM_MAX_WORKERS=2
FARM_MIN_WORKERS=1
FARM_REMOTE_CONTROL=1
FARM_RC_CAPACITY=1

# Keep capacity for interactive Claude use. No paid overages.
FARM_WEEKLY_TARGET=0.75
FARM_FIVE_HOUR_CEILING=0.80
FARM_ALLOW_OVERAGE=0
FARM_USAGE_REFRESH=300

FARM_TZ=America/Denver
FARM_TASK_TIMEOUT=5400
FARM_STALL_THRESHOLD=3

# Dashboard stays local to the M4. Browser automation starts disabled.
FARM_UI_PRIVATE=1
FARM_UI_PORT=8080
FARM_BROWSER=0
EOF

chmod 600 .env
docker compose pull
docker compose up -d
docker compose logs --tail=100
```

Sign Clodfarm into the Claude subscription:

```bash
docker compose exec -it clodfarm clodfarm login
```

Follow the printed URL and device-code prompt. Once completed, make the farm private and prevent anyone else from hatching an agent:

```bash
docker compose exec clodfarm clodfarm farm private
docker compose exec clodfarm clodfarm farm hatch-closed
open http://localhost:8080
```

If the dashboard asks for its generated password:

```bash
docker compose logs | rg -i 'password|http://|login'
```

## 3. Add a free local coding worker

The primary Claude seat plans and reviews work. The local Ollama worker handles tightly specified implementation, tests, boilerplate, and summaries without consuming Claude usage.

```bash
ollama pull qwen3-coder
ollama run qwen3-coder "Reply with exactly: local worker ready"
```

```bash
docker compose exec -it clodfarm \
  clodfarm bot add local --provider ollama --model qwen3-coder
```

## 4. First test mission

Start with an empty farm workspace—no personal repository or credentials:

```bash
docker compose exec clodfarm \
  clodfarm spawn "Create a demo app" \
  --prompt "Create a polished single-page local web app in the farm workspace. Add tests and a README. Do not use browser automation, cloud services, payments, external credentials, or publish anything."
```

Monitor it:

```bash
docker compose exec clodfarm clodfarm status
docker compose exec clodfarm clodfarm agents
docker compose exec clodfarm clodfarm budget
```

## 5. Use the farm from the M3

Keep port 8080 off the public internet. From the M3, create an SSH tunnel to the M4:

```bash
ssh -N -L 8080:127.0.0.1:8080 FARM_USER@YOUR_M4_ADDRESS
```

Then open `http://localhost:8080` on the M3. Tailscale can provide a stable private M4 address; do not forward port 8080 on a router.

## Daily controls

```bash
cd ~/farm-host/clodfarm
docker compose ps
docker compose logs -f
docker compose exec clodfarm clodfarm status
docker compose exec clodfarm clodfarm budget
docker compose stop
docker compose start
```

## Before connecting a real repository

First make a fresh GitHub repository specifically for farm work. Give it a repository-scoped deploy key only. Do not give the farm your personal GitHub token. Keep `FARM_PUSH` unset until agents consistently produce reviewed, tested work; then add `FARM_REPO_URL` and a project-specific `FARM_VERIFY_CMD`.

Commercial delivery should use a plan and workflow permitted by Anthropic's current terms. A personal Claude subscription is appropriate for your own development and experimentation; do not use it to operate an unattended service for other people without confirming the applicable terms.
