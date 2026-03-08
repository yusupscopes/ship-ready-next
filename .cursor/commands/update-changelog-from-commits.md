# Update CHANGELOG from commit history

## Overview

Update `CHANGELOG.md` by appending new entries under **\[Unreleased]** based on commit history from the last version already recorded in the changelog up to the latest commit (HEAD). Preserve the existing [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format and semantic sections (Added, Changed, Fixed, etc.).

## Steps

1. **Locate last recorded version in CHANGELOG**
    - Read `CHANGELOG.md` and find the first released version after the `## [Unreleased]` block (e.g. `## [1.2.4-rc.2]` or `## [1.2.0-rc.1] - date`).
    - That version is the “changelog is complete up to here” anchor.
2. **Resolve git ref for “since when”**
    - Prefer a tag: try `v<version>` and `<version>` (e.g. `v1.2.4-rc.2`, `1.2.4-rc.2`). If found, use it as the exclusive start ref.
    - If no tag exists, find the commit that introduced that version line:  
      `git log -1 --format=%H -S "## [X.Y.Z..." -- CHANGELOG.md`  
      Use that commit’s hash as the start ref (commits *after* this commit will be used).
3. **Get commit list since that ref**
    - Run: `git log <start-ref>..HEAD --oneline --no-merges` (or with `--format="%h %s"` if you need more detail).
    - Optionally include body: `git log <start-ref>..HEAD --no-merges --format="%h %s%n%b"` to improve categorization.
4. **Categorize commits**
    - Map each commit to **Added**, **Changed**, **Fixed**, or (if needed) **Deprecated** / **Removed** / **Security**.
    - Use conventional commit prefixes as a hint: `feat`, `feature` → Added; `fix` → Fixed; `chore`, `refactor`, `docs`, `style`, `test`, `ci` → Changed (or Added for docs/test if user-facing); breakings → call out under Changed or a dedicated note.
    - Normalize message into a short, user-facing bullet: **Scope** or area, then description (e.g. **Task Board**: Drag-and-drop and date picker). Deduplicate or merge closely related commits into one line.
5. **Update \[Unreleased] in CHANGELOG.md**
    - Keep the existing `## [Unreleased]` block and its section headers (`### Added`, `### Changed`, `### Fixed`, etc.).
    - **Append** new bullets under the appropriate sections; do not remove existing content unless it’s a duplicate. If a section has no new items, leave it with no bullets (or “(none)” per project preference).
    - Preserve the separator (e.g. `---`) and the rest of the file below unchanged.
6. **Write the file**
    - Apply the edits to `CHANGELOG.md` and re-read the file to verify formatting and that no duplicate or misplaced entries were introduced.

## Commit → section mapping (guideline)

| Commit prefix / intent | Preferred section | Example |
|------------------------|-------------------|--------|
| feat, feature, add     | Added             | New dialog, new API, new UI |
| fix                   | Fixed             | Bug fix, error handling |
| chore, refactor, docs, ci, test, style | Changed | Tooling, docs, tests, refactors |
| breaking change       | Changed (or note) | API/behavior change |
| deprecate             | Deprecated        | Deprecated API/feature |
| remove                | Removed           | Removed feature |
| security              | Security          | Security fix |

## CHANGELOG format (this project)

- Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
- Sections: `### Added`, `### Changed`, `### Fixed` (and others only if needed).
- Bullets: `- **Scope**: Short description.` (sentence case, no period at end if one line).
- Version block separator: `---` and blank line between versions.

## Rules

- **Do not** remove or alter existing version blocks or their content; only add under **\[Unreleased]**.
- **Do not** invent commits; every new bullet must correspond to a commit in the computed range.
- Prefer one user-facing bullet per logical change; merge trivial follow-up commits (e.g. “fix typo”) into the main bullet or omit.
- If there are no new commits since the last version, leave **\[Unreleased]** sections empty and do not add placeholder text like “None” unless the project already uses it.

## Checklist

- [ ] Read CHANGELOG.md and identified the last released version header
- [ ] Resolved start ref (tag or commit that added that version)
- [ ] Ran `git log <ref>..HEAD --no-merges` and listed commits
- [ ] Mapped each commit to Added / Changed / Fixed (or other) and normalized messages
- [ ] Appended new bullets only under `## [Unreleased]`, preserving existing structure
- [ ] Re-read CHANGELOG.md to verify formatting and no duplicates
