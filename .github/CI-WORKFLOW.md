# GitHub Actions CI Workflow Guide

## Overview

The GitHub Actions CI workflow is a continuous integration pipeline that automatically runs code quality checks, linting, and tests when code is pushed or a pull request is created.

**File Location:** `.github/workflows/ci.yml`

## Workflow Trigger

The CI workflow is triggered on:

1. **Push events** to:
   - `main` branch
   - `release/*` branches

2. **Pull requests** targeting any branch

3. All jobs run concurrently, with automatic cancellation of outdated runs

## Jobs Overview

### 1. File Change Detection (`files-changed`)
**Purpose:** Reusable workflow that detects which files have changed  
**Output:** Determines what type of changes were made:
- `backend` - Go source files
- `frontend` - JavaScript/TypeScript files
- `templates` - Go template files
- `docs` - Documentation files
- `actions` - Workflow files
- `docker` - Docker-related files
- `swagger` - API specification files
- `yaml` - YAML configuration files
- `json` - JSON configuration files

This optimization ensures that only relevant checks run based on what changed.

### 2. Backend Code Quality Jobs

#### `backend-fmt` - Code Formatting Check
- **Trigger:** Backend or workflow changes
- **Command:** `make fmt-check`
- **Purpose:** Ensures all Go code follows the project's formatting standards
- **Failure:** Code formatting doesn't comply with standards
- **Fix:** Run `make fmt` locally and commit the changes

#### `backend-lint` - Linting Check
- **Trigger:** Backend or workflow changes
- **Command:** `make lint-backend`
- **Purpose:** Runs golangci-lint and other Go linting tools
- **Checks:** Style violations, potential bugs, code quality issues
- **Failure:** Code violates linting rules

#### `go-mod-tidy` - Dependency Management Check
- **Trigger:** Backend or workflow changes
- **Command:** `make tidy-check`
- **Purpose:** Ensures `go.mod` and `go.sum` are properly maintained
- **Checks:** Dependencies are correctly declared and sorted
- **Failure:** Requires running `make tidy`

#### `security-check` - Vulnerability Scan
- **Trigger:** Backend or workflow changes
- **Command:** `make security-check`
- **Purpose:** Scans dependencies for known vulnerabilities
- **Tool:** govulncheck
- **Failure:** Vulnerable dependencies detected
- **Action:** Dependencies must be updated before merging

#### `swagger-check` - API Documentation
- **Trigger:** Swagger, backend, or workflow changes
- **Commands:** `make swagger-check` and `make swagger-validate`
- **Purpose:** Generates and validates OpenAPI/Swagger specification
- **Checks:** Ensures API documentation is generated from code and is valid
- **Output:** `templates/swagger/v1_json.tmpl`

#### `test-backend` - Backend Unit Tests
- **Trigger:** Backend or workflow changes
- **Command:** `make test-backend`
- **Purpose:** Runs all Go unit tests
- **Environment:** SQLite with binary data
- **Checks:** Tests run without errors, validations pass
- **Additional:** `make test-check` validates test files don't create permanent artifacts

### 3. Frontend Code Quality Jobs

#### `frontend-lint` - JavaScript/TypeScript Linting
- **Trigger:** Frontend or workflow changes
- **Command:** `make lint-frontend`
- **Purpose:** Lints JavaScript, TypeScript, and Vue files
- **Tools:** ESLint, Vue TypeScript plugin
- **Files Checked:** `web_src/js`, `tools`, `*.ts` config files

#### `frontend-test` - Frontend Unit Tests
- **Trigger:** Frontend or workflow changes
- **Command:** `make test-frontend`
- **Purpose:** Runs Vitest for frontend components and utilities
- **Config:** `vitest.config.ts`

#### `frontend-lockfile` - Dependency Lock File Check
- **Trigger:** Frontend or workflow changes
- **Command:** `make lockfile-check`
- **Purpose:** Ensures `pnpm-lock.yaml` is in sync with `package.json`
- **Failure:** Dependencies are out of sync
- **Fix:** Run `pnpm install` and commit lockfile

### 4. Additional Quality Checks

#### `spell-check` - Spelling Validation
- **Trigger:** Backend, frontend, docs, or workflow changes
- **Command:** `make lint-spell`
- **Purpose:** Finds and reports spelling errors
- **Files Checked:** Source code, templates, documentation, locale files
- **Tool:** misspell

#### `template-lint` - Template Validation
- **Trigger:** Template or workflow changes
- **Command:** `make lint-templates`
- **Purpose:** Validates Go template syntax and structure
- **Files Checked:** `templates/**`

#### `yaml-validate` - YAML Validation  
- **Trigger:** YAML or workflow changes
- **Command:** `make lint-yaml`
- **Purpose:** Validates YAML file syntax
- **Files Checked:** Configuration files in YAML format

#### `json-validate` - JSON Validation
- **Trigger:** JSON or workflow changes
- **Command:** `make lint-json`
- **Purpose:** Validates JSON file syntax
- **Files Checked:** Configuration and data files in JSON format

### 5. CI Success Summary (`ci-success`)
- **Runs:** After all other jobs (always)
- **Purpose:** Aggregates results and provides final status
- **Checks:** Ensures no required jobs failed
- **Status:** Reports pass/fail with detailed failure reasons

## Key Features

### Conditional Execution
Jobs only run when relevant files change, saving time and resources:
- Backend jobs skip if only frontend changes
- Frontend jobs skip if only backend changes
- Spell check skips if only binary files change

### Smart Caching
- Go module cache per version
- pnpm dependency cache using lockfile hash
- Faster build times on repeated runs

### Concurrency Control
- Multiple runs on the same branch cancel previous runs
- Prevents wasting CI resources
- Latest commits get priority

### Permissions
- Read-only access to repository contents
- Safe for use with external Pull Requests
- No opportunity for credential leakage

## Environment Setup

The workflow automatically:

1. **Checks out the code** with:
   - Full history (`fetch-depth: 0`)
   - Git LFS support (for binary files)

2. **Sets up Go:**
   - Version from `go.mod` file
   - Latest patch version
   - Module cache enabled

3. **Sets up Node/pnpm:**
   - Node.js 24 LTS
   - pnpm for consistent package management
   - Cached dependencies

4. **Installs dependencies:**
   - Backend: `make deps-backend deps-tools`
   - Frontend: `make deps-frontend`
   - Templates: `make deps-py` (Python)

## Common Troubleshooting

### Backend Format Check Fails
```bash
# Local fix
make fmt
git add .
git commit -m "style: Format code"
```

### Frontend Tests Fail
```bash
# Debug locally
make test-frontend

# Check dependencies
pnpm install
```

### Go Module Tidy Fails
```bash
# Fix dependencies
make tidy
git add go.mod go.sum
git commit -m "chore: Tidy go modules"
```

### Lockfile Out of Sync
```bash
# Fix pnpm lockfile
pnpm install
git add pnpm-lock.yaml
git commit -m "chore: Update pnpm lockfile"
```

### Security Check Fails
```bash
# Review vulnerabilities
make security-check

# Update packages (as needed)
go get -u <package>
```

## Updating the Workflow

When adding new checks:

1. Add new job with clear name and description
2. Set appropriate `if` conditions using `needs.files-changed.outputs`
3. List job in `ci-success.needs`
4. Update status check in `ci-success` step
5. Test on feature branch first

## Integration with GitHub

The workflow status appears as:
- ✅ Check passing (all jobs pass or skipped appropriately)
- ❌ Check failing (one or more jobs failed)
- ⏳ Check pending (jobs in progress)

Required status checks prevent merging PRs that fail CI.

## Performance Tips

1. **Push to feature branches first** to catch CI issues early
2. **Run checks locally** before pushing:
   ```bash
   make checks    # Quick backend checks
   make lint      # Full linting
   ```
3. **Keep branches recent** - rebase on main to avoid outdated dependencies
4. **Watch for slow jobs** - profile and optimize as needed

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Makefile Targets](../../Makefile)
- [Contributing Guide](../../CONTRIBUTING.md)
- [Gitea Development Guide](https://docs.gitea.com/)
