# Suggest Branch Name (from staged changes)

## Overview

Analyze staged (and optionally unstaged) changes, infer the type and scope of work, then recommend 2–3 branch names that follow common conventions and are ready to use.

## Steps

1. **Gather change context**
    - Run `git status` to see staged/unstaged files and current branch
    - Run `git diff --cached` for staged changes (and optionally `git diff` for unstaged if user wants to include them)
    - If nothing is staged, use `git diff` and `git status` to base recommendations on working tree changes
2. **Analyze changes**
    - Identify affected areas: routes, components, API, docs, tests, config, etc.
    - Infer intent: new feature, bugfix, refactor, chore, docs, test, or config
    - Extract a short, descriptive slug (e.g. "auth-token-refresh", "task-kanban-api")
3. **Suggest branch names**
    - Propose 2–3 options using the format: `<type>/<short-slug>` (e.g. `feature/`, `fix/`, `refactor/`, `chore/`, `docs/`, `test/`)
    - Use kebab-case for the slug; keep it concise (2–4 words)
    - If the repo or user context uses issue keys (e.g. Linear, Jira), optionally suggest: `<type>/<issue-key>-<short-slug>` or `<issue-key>-<type>-<short-slug>`
4. **Output**
    - List recommendations with a one-line rationale for each
    - Mark a preferred option if one is clearly best
    - Remind how to create and switch: `git checkout -b <branch-name>`

## Branch type guidelines

| Change character | Suggested prefix | Example slug idea |
|------------------|------------------|-------------------|
| New capability, UI, flow | `feature/` or `feat/` | `feature/child-dashboard` |
| Bug fix, error handling | `fix/` or `bugfix/` | `fix/auth-expired-token` |
| Restructure, no new behavior | `refactor/` | `refactor/task-api-routes` |
| Docs, comments only | `docs/` | `docs/tryout-guide` |
| Tests only | `test/` or `chore/` | `test/task-e2e` |
| Config, deps, tooling | `chore/` | `chore/playwright-config` |

## Rules

- **Evidence-based:** Recommendations must follow from the actual diff and file list, not generic labels.
- **Slug:** Lowercase, kebab-case, no special characters; avoid redundant words (e.g. "fix-fix-auth").
- **Length:** Prefer short slugs; long names are acceptable only when they add clarity.
- **Current branch:** If already on a feature branch, note it and suggest whether to keep working on it or create a new branch.

## Example output format

```
Based on staged changes (e.g. app/api/tasks/route.ts, app/tasks/page.tsx):

1. **feature/task-management-api** (preferred) — New task API routes and task page updates.
2. **feat/tasks-crud** — Shorter alternative focusing on CRUD.
3. **refactor/task-routes** — Use only if this is purely refactoring existing code.

Create and switch: `git checkout -b feature/task-management-api`
```

## Checklist

- [ ] Ran `git status` and `git diff --cached` (and `git diff` if including unstaged)
- [ ] Inferred type (feature / fix / refactor / chore / docs / test) from actual changes
- [ ] Suggested 2–3 branch names in `<type>/<short-slug>` format
- [ ] Gave a one-line rationale per suggestion and a preferred option when clear
- [ ] Included a ready-to-run `git checkout -b` example
