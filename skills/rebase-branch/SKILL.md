---
name: rebase-branch
description: Rebase the current Git branch, defaulting to origin/main, while listing incoming commits and summarizing both sides of every conflict. Use when the user asks to rebase, update a branch with rebase, or handle rebase conflicts.
license: MIT
compatibility: opencode
metadata:
  audience: developers
---

# Rebase Branch

Rebase the current branch onto a target ref. Use `origin/main` unless the user
explicitly provides another target.

## Safety checks

Before fetching or rebasing:

1. Confirm the working directory is inside a Git worktree.
2. Record the current branch name. Stop if `HEAD` is detached.
3. Check for an existing rebase, merge, cherry-pick, or revert. If one exists,
   explain the state and ask the user how to proceed.
4. Run `git status --short`. If the worktree or index is dirty, show the status
   and stop. Do not stash, discard, or commit changes automatically.

## Prepare the rebase

1. Fetch the target before inspecting commits. For the default target, run
   `git fetch origin main`. For another remote-tracking target, fetch its remote
   and branch. Do not fetch when the target is a local ref.
2. Verify that the target resolves to a commit.
3. Record these values for use throughout the rebase:
   - `original_tip`: `git rev-parse HEAD`
   - `merge_base`: `git merge-base HEAD <target>`
   - `target_tip`: `git rev-parse <target>`
4. List the upstream commits that will be incorporated into the current branch,
   oldest first, using:

   ```sh
   git log --reverse --format='%h %s' HEAD..<target>
   ```

5. Clearly say when there are no upstream commits to incorporate. Still explain
   whether the current branch has commits to replay before starting the rebase.

## Start the rebase

Run:

```sh
git rebase <target>
```

If it succeeds, report the new branch tip and a concise final status. Do not
push unless the user explicitly asks.

## Report every conflict

When Git stops on conflicts, do not resolve, stage, skip, abort, or continue
before presenting a conflict report.

Collect the conflicted paths with:

```sh
git diff --name-only --diff-filter=U
```

Inspect the relevant patches, not only their statistics. Build the report from:

- The replayed current-branch commit: `REBASE_HEAD`, including its short hash,
  title, and changes to the conflicted paths.
- The target branch changes: the diff from `merge_base` to `target_tip`, limited
  to the conflicted paths.
- The current branch changes: the diff from `merge_base` to `original_tip`,
  limited to the conflicted paths.
- The index stages or conflict markers when needed to explain the exact overlap.

Present this format:

```markdown
⚠️ **Rebase conflict**
🎯 Target: `<target>` at `<short target_tip>`
🔁 Replaying: `<short REBASE_HEAD> <title>`

📁 **Conflicted files**
- `<path>`

🌳 **Target branch changes** (`target-branch-name`)
- Concise semantic summary of relevant changes made on the target branch.

🌿 **Current branch changes** (`current-branch-name`)
- Concise semantic summary of relevant changes made on the current branch.

💥 **Exact conflict**
- Explain which edits overlap or why Git cannot combine them safely.
```

Never describe the sides only as "ours" and "theirs". During a rebase, Git's
terminology is counterintuitive: "ours" is the rebased result containing the
target plus already replayed commits, while "theirs" is the current branch
commit being replayed. Name the target and current branch explicitly.

After the report, ask the user how they want the conflict resolved. Once the
user approves a resolution, apply it, stage only the resolved paths, and run
`git rebase --continue`. If another conflict appears, repeat the full report.
Never use `git rebase --skip` or `git rebase --abort` without explicit approval.

## Completion

After the rebase completes:

1. Run `git status --short --branch`.
2. Show the rebased commits relative to the target with short hashes and titles.
3. Report success without pushing. If the branch was previously published,
   explain that updating it may require `git push --force-with-lease`, but DO NOT run
   that command unless the user requests it.
