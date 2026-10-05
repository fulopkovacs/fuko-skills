---
name: post-review-comments
description: Draft and post GitHub pull request review comments with user-facing repro steps, technical reproduction, a bug explanation, and a proposed fix. Use when the user asks to post review findings, leave inline PR feedback, or write review comments.
license: MIT
compatibility: opencode
metadata:
  audience: developers
---

# Post Review Comments

Turn concrete review findings into concise, actionable inline GitHub comments.
Use `gh` to inspect the PR and post comments. Do not modify the reviewed code.

## Prepare the comments

1. Identify the repository and PR from the user's request or the current branch.
   Ask if the target is ambiguous.
2. Read the PR diff, relevant surrounding code, and existing review threads.
   Validate each finding against the current PR head; avoid duplicate comments
   and findings already fixed. Use supplied findings as starting points, not as
   proof.
3. Pick the smallest relevant changed line or range for each finding. Keep one
   issue per comment and anchor it where the problem originates.
4. Draft using the format below. If the user asked only for drafts, do not post.
   If they explicitly asked to post, that authorizes posting to the identified
   PR; otherwise show the drafts and ask for approval before publishing.

## Comment format

Use these four headings in this order. Use numbered steps in the first and
second sections, restarting at 1 in each section. Use short bullets in the last
two sections.

```markdown
### 👤 User experience
1. [Describe the realistic starting state and what the user does.]
2. [Describe the next action.]
3. [Describe the observable issue and the expected behavior.]

### 🔁 Reproduction
1. [Set up the minimal technical state, fixture, or prerequisites.]
2. [Run the concrete command, request, or code path.]
3. [State the actual result and the expected result.]

### 🐛 Bug
- [Explain the faulty logic and why it causes the issue.]

### 🛠️ Proposed fix
- [Suggest the smallest actionable correction.]
```

The first section is the repro from the user's perspective: how someone would
actually run into the issue, not just a synthetic edge case. The second gives
the developer enough detail to reproduce or isolate it. Adjust the number of
steps to the issue rather than padding either section to three steps.

Keep identifiers, commands, flags, and relevant values in backticks. Distinguish
confirmed behavior from possible downstream impact. Do not claim to have run a
test unless you did; label unexecuted reproduction steps as such. If no user
journey or reliable repro can be established, say so instead of inventing one,
and clarify the finding before posting.

Reference style: https://github.com/uxstudioteam/arlo/pull/205#discussion_r4182850104
Use the format above with numbered steps, even though that example uses bullets.

## Publish

1. Resolve the current PR head SHA and confirm the selected lines still belong
   to its diff. Use `gh api repos/{owner}/{repo}/pulls/{number}/comments` to post
   inline comments with `body`, `commit_id`, `path`, `line`, and `side`. For a
   range, also provide `start_line` and `start_side`. Use `RIGHT` for new code
   and `LEFT` for deleted code; use file line numbers, not diff positions.
2. Send Markdown through a JSON payload file or safely quoted input so shell
   expansion cannot alter backticks or other comment content. Do not submit an
   approval or request-changes review unless the user explicitly requested it.
3. If posting fails, report the failure. Recheck the head and existing comments
   before retrying so a partial success does not create duplicates. Never move
   a comment to an unrelated line just to satisfy the API.
4. Return links to the posted comments. If any findings were skipped or could
   not be posted, briefly explain why.
