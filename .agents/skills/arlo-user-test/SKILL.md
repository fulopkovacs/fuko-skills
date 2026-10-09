---
name: arlo-user-test
description: Run short Arlo feature tests (article reading, screenshot preview) with honest continuous video evidence. Always load this skill when the user asks for an Arlo smoke test, Arlo user test, article-reading verification, or screenshot-preview check — first load the agent-browser skill, then follow this Arlo workflow.
license: MIT
compatibility: opencode
metadata:
  audience: developers
---

# Arlo User Test

Run one minimal Arlo feature test per invocation. No app code edits, migrations, or billing changes.

## Prerequisite (soft dependency)

First load the `agent-browser` skill and follow its continuous-capture workflow — not event-only `record start/stop`. Reuse its `scripts/continuous-capture.mjs` and `scripts/export-slower.sh` (resolve the installed path of the `agent-browser` skill; do not duplicate the scripts here).

## App flow

1. Discover the running app URL (check listeners/processes; do not assume a port).
2. Authenticate BEFORE recording; keep login out of the video. Never save credentials in files.
3. If the account has no audits, create one via the normal UI before recording (public site the user approves, e.g. `https://www.wikipedia.org`). Report paywall or creation errors instead of changing billing.
4. Open the target chat (e.g. `/audit/<id>/chat`) and confirm the message box is ready.

## Test design

- One minimal prompt per run. For article reading, use a never-discussed URL to avoid cached screenshots, and say explicitly: "using the retrieved article text, not screenshots".
- Start continuous capture immediately before entering the prompt; stop ~2s after the full answer is readable. No extra interaction while recording.
- For screenshot-preview checks: verify the preview appears, open it to show the image, then reload and reopen it.

## Evidence standard

A generic summary alone does not prove text extraction worked. Check the exposed `/api/chat` tool evidence for a `read_page` call or retrieved article text. Summaries that say "based on the screenshot" pass only the visible-summary check — report the text-extraction fix as NOT VERIFIED in that case. See `references/verification-checklist.md`.

## Report (always use this shape)

1. Article summary: PASS / FAIL / BLOCKED + one-line evidence.
2. Screenshot preview: PASS / FAIL / BLOCKED + one-line evidence.
3. Preview after reload: PASS / FAIL / BLOCKED + one-line evidence.
4. Raw video: path, duration, frame count. Slowed video: path, duration, frame count.
5. Observed errors and what was NOT verified. No passing claims for unseen behavior.
