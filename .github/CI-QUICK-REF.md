# CI Workflow - Quick Reference

## What is the CI Workflow?

The **CI (Continuous Integration) workflow** defined in `.github/workflows/ci.yml` is an automated process that runs whenever code is pushed or a pull request is created. It ensures code quality, security, and functionality before merging.

## Key Components

### 1. **Trigger Events**
- Push to `main` or `release/*` branches
- Any pull request creation
- Automatically cancels outdated runs

### 2. **13 Automated Jobs**

#### Backend Jobs (5)
1. **backend-fmt** - Code formatting validation
2. **backend-lint** - Linting and code quality
3. **go-mod-tidy** - Dependency management
4. **security-check** - Vulnerability scanning
5. **swagger-check** - API documentation
6. **test-backend** - Unit tests

#### Frontend Jobs (3)
7. **frontend-lint** - JavaScript/TypeScript linting
8. **frontend-test** - Unit tests
9. **frontend-lockfile** - Dependency lock validation

#### Content Jobs (4)
10. **spell-check** - Spelling validation
11. **template-lint** - Template syntax
12. **yaml-validate** - YAML configuration
13. **json-validate** - JSON files

#### Summary
14. **ci-success** - Final status aggregation

### 3. **Smart Conditional Execution**

Jobs only run when relevant files change:
```
backend/*.go → Runs backend jobs
web_src/*.ts → Runs frontend jobs
templates/*.tmpl → Runs template jobs
.github/workflows/*.yml → Runs all jobs
```

This saves time and resources!

### 4. **Automatic Environment Setup**

Each job automatically:
- Checks out your code (with Git LFS support)
- Installs the required Go/Node version
- Downloads dependencies
- Caches for faster subsequent runs

## How to Use It

### Run Locally Before Pushing
```bash
# Quick checks
make checks       # Backend checks
make lint         # All linting

# Run tests
make test-backend    # Go tests
make test-frontend   # JavaScript tests

# Specific fixes
make fmt-check       # See format issues
make fmt             # Fix formatting
```

### Monitor CI Status

**On GitHub:**
- PR shows CI status as checks pass/fail
- ✅ All green = Ready to merge
- ❌ Red = Fix issues before merging

**Common Failures:**
| Job | Fix Command |
|-----|------------|
| backend-fmt | `make fmt` |
| go-mod-tidy | `make tidy` |
| frontend-lockfile | `pnpm install` |
| spell-check | Manual review needed |
| frontend-lint | `make lint-frontend-fix` |

## Architecture

```
Pull Request / Push
        ↓
    files-changed (detect what changed)
        ↓
    ┌───────────────────────────────┐
    ├─ backend-fmt                 │
    ├─ backend-lint                │
    ├─ go-mod-tidy                 │
    ├─ security-check              │
    ├─ swagger-check               │
    ├─ test-backend                │
    ├─ frontend-lint               │
    ├─ frontend-test               │
    ├─ frontend-lockfile           │
    ├─ spell-check                 │
    ├─ template-lint               │
    ├─ yaml-validate               │
    └─ json-validate               │
    ↓
    ci-success (all jobs status)
    ↓
    ✅ Merge Allowed / ❌ Merge Blocked
```

## Customization

To add a new check:

1. **Add a new job** in `.github/workflows/ci.yml`
2. **Set file triggers** using `needs.files-changed.outputs`
3. **Add to ci-success** needs list
4. **Add status check** in final step

Example:
```yaml
new-check:
  if: needs.files-changed.outputs.backend == 'true'
  needs: files-changed
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v6
    - run: your-check-command
```

## Performance

- **Typical run time:** 5-15 minutes
- **Caching:** ~50% faster on repeated pushes
- **Conditional execution:** Only relevant jobs run
- **Parallel execution:** Jobs run simultaneously when possible

## Files Created/Modified

- ✅ `.github/workflows/ci.yml` - Main CI workflow
- ✅ `.github/CI-WORKFLOW.md` - Detailed documentation
- ✅ `.github/workflows/files-changed.yml` - Existing (used by CI)

## Next Steps

1. **Test the workflow:** Push to a feature branch
2. **Monitor execution:** Check Actions tab on GitHub
3. **Fix any failures:** Address issues shown in CI logs
4. **Merge confidently:** Once all checks pass

## Document Structure

| File | Purpose |
|------|---------|
| `ci.yml` | Workflow definition |
| `CI-WORKFLOW.md` | Comprehensive documentation |
| `CI-QUICK-REF.md` | This file (quick reference) |
| `files-changed.yml` | File change detector |

## Additional Commands

```bash
# Frontend
make deps-frontend        # Install npm dependencies
make lint-frontend        # Lint JS/TS
make lint-frontend-fix    # Auto-fix issues
make test-frontend        # Run tests

# Backend
make deps-backend         # Install Go dependencies
make lint-backend         # Full linting
make test-backend         # Unit tests
make fmt                  # Format code

# All
make checks              # All quality checks
make lint                # All linting
```

## Support Resources

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [Contributing Guide](../../CONTRIBUTING.md)
- [Makefile Targets](../../Makefile)
- [Full CI Documentation](.CI-WORKFLOW.md)
