---
name: review-changes
description: Review PR, uncommitted, staged, unstaged, branch, or commit changes in interactive or one-shot mode. Use when the user asks for a code review or to review changes.
license: MIT
compatibility: opencode
metadata:
  audience: developers
---

# Review Changes

Review the actual diff, focusing on behavior, regressions, risks, and missing
tests. Be brief.

## Choose the mode

Honor an explicit mode or a clear preference in the user's request:

- **Interactive**: walk through one logical change at a time, pausing for the
  user's confirmation. Use for requests such as "walk me through the changes"
  or "review this interactively".
- **One-shot**: give the complete review and all feedback in one response,
  without pausing between changes. Use for requests such as "fast review",
  "one-shot review", or "give me all the feedback at once". This changes delivery,
  not review depth.

If the intended mode is unclear, ask the user to choose Interactive or One-shot
before presenting the review. If scope also needs clarification, ask about both
together.

## Choose the scope

Honor an explicit scope. Otherwise inspect the repository and ask the user to
choose from only the scopes that currently contain changes, such as:

- Current PR (recommended and default when available)
- All uncommitted changes
- Staged changes
- Unstaged and untracked changes
- Current branch compared with its base
- A user-specified commit or range

Put Current PR first and mark it recommended. Do not assume staged, unstaged,
and untracked changes are equivalent. Never modify the reviewed changes.

## Review overview

Briefly summarize the review scope and changes. Then show up to three non-empty
tables, grouping rows by logical feature rather than by file:

### ✨ Added features

| Summary | Changed files | Change size |
| --- | --- | ---: |

### 🔄 Changed features

| Summary | Changed files | Change size |
| --- | --- | ---: |

### 🗑️ Removed features

| Summary | Changed files | Change size |
| --- | --- | ---: |

Report `Change size` as modified lines: additions plus deletions. Include the
breakdown when available, for example `18 (+12/-6)`. Omit empty tables and use
no more than these three tables.

In Interactive mode, end by naming the first logical change to review and ask
to continue. In One-shot mode, proceed directly to the complete review in the
same response.

## Review each logical change

In Interactive mode, after confirmation, present one logical change per message.
In One-shot mode, cover all logical changes in the same response, using a separate
heading for each. For each change:

1. Explain what it does.
2. Add a `👀 Visual changes` section describing the user-visible before and after,
   including affected screens, states, and interactions. If there is no visual
   impact, explicitly state that.
3. Add a `🔍 How to test` section with concrete commands or manual steps,
   prerequisites when relevant, and the expected result. Keep the steps focused
   on the logical change being reviewed.
4. Show relevant files as a Markdown bullet list, then note important
   implementation choices. Never display file lists inline.
5. Highlight concrete bugs, regressions, security concerns, and missing tests;
   otherwise state what deserves attention.
   - Use these severity levels (include the emojis):
       - 🔴 Major
       - 🟠 Medium
       - 🟡 Low
6. In Interactive mode only, ask before moving to the next change.

Include file and line references for findings. Keep snippets minimal. After the
last change, briefly summarize findings by severity and note remaining testing
gaps.
