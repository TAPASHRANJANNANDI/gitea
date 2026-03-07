#!/bin/bash
# Gitea CI Local Testing Script - macOS/Linux
# Usage: ./run-ci-local.sh [--quick|--backend|--frontend|--all]

QUICK=false
BACKEND=false
FRONTEND=false
ALL=false

for arg in "$@"; do
    case $arg in
        --quick) QUICK=true ;;
        --backend) BACKEND=true ;;
        --frontend) FRONTEND=true ;;
        --all) ALL=true ;;
    esac
done

# If no flags, default to all
if [ "$QUICK" = false ] && [ "$BACKEND" = false ] && [ "$FRONTEND" = false ] && [ "$ALL" = false ]; then
    ALL=true
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

passed=0
failed=0

# Check Makefile
if [ ! -f "Makefile" ]; then
    echo -e "${RED}ERROR: Makefile not found!${NC}"
    exit 1
fi

echo ""
echo -e "${CYAN}Gitea CI Local Testing${NC}"
echo ""

# Check tools
echo -e "${CYAN}CHECKING TOOLS:${NC}"
for tool in git make go node pnpm; do
    printf "  $tool... "
    if command -v $tool &> /dev/null; then
        echo -e "${GREEN}OK${NC}"
    else
        echo -e "${RED}MISSING${NC}"
    fi
done
echo ""

# Run tests
if [ "$BACKEND" = true ] || [ "$ALL" = true ]; then
    echo -e "${CYAN}BACKEND CHECKS:${NC}"
    for test in fmt-check lint-backend tidy-check security-check swagger-check; do
        printf "  $test... "
        if make $test > /dev/null 2>&1; then
            echo -e "${GREEN}OK${NC}"
            ((passed++))
        else
            echo -e "${RED}FAIL${NC}"
            ((failed++))
        fi
    done
    if [ "$QUICK" = false ]; then
        printf "  test-backend... "
        if make test-backend > /dev/null 2>&1; then
            echo -e "${GREEN}OK${NC}"
            ((passed++))
        else
            echo -e "${RED}FAIL${NC}"
            ((failed++))
        fi
    fi
    echo ""
fi

if [ "$FRONTEND" = true ] || [ "$ALL" = true ]; then
    echo -e "${CYAN}FRONTEND CHECKS:${NC}"
    for test in lint-frontend test-frontend lockfile-check; do
        printf "  $test... "
        if make $test > /dev/null 2>&1; then
            echo -e "${GREEN}OK${NC}"
            ((passed++))
        else
            echo -e "${RED}FAIL${NC}"
            ((failed++))
        fi
    done
    echo ""
fi

if [ "$ALL" = true ] || [ "$QUICK" = true ]; then
    echo -e "${CYAN}CONTENT CHECKS:${NC}"
    for test in lint-spell lint-templates lint-yaml lint-json; do
        printf "  $test... "
        if make $test > /dev/null 2>&1; then
            echo -e "${GREEN}OK${NC}"
            ((passed++))
        else
            echo -e "${RED}FAIL${NC}"
            ((failed++))
        fi
    done
    echo ""
fi

echo -e "${CYAN}SUMMARY:${NC}"
echo -e "  ${GREEN}Passed: $passed${NC}"
if [ $failed -gt 0 ]; then
    echo -e "  ${RED}Failed: $failed${NC}"
fi
echo ""

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}All checks passed!${NC}"
    exit 0
else
    echo -e "${RED}Some checks failed. Run: make fmt, make tidy, pnpm install${NC}"
    exit 1
fi
