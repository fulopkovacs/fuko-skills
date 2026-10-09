# Verification checklist (Arlo user test)

## Video

- Raw duration ≈ actual elapsed test time; frame count ≈ elapsed × fps.
- Slowed duration ≈ raw × factor (default 10x).
- `ffmpeg -f null -` decode succeeds for both files.
- Start frame shows the prompt being entered; middle frame shows waiting/generation; end frame shows the complete answer held visible.
- Retain both raw and slowed videos; report both paths.

## Article reading

- PASS only with a grounded summary of the requested article (not a refusal, not navigation-only complaints).
- Text-extraction fix VERIFIED only with tool evidence: a `read_page` call or retrieved article text in the `/api/chat` response. A summary saying "based on the screenshot" is a visible-summary PASS but a fix NOT VERIFIED.
- Prefer a never-discussed article URL so cached screenshots cannot masquerade as fresh reads.

## Screenshot preview

- Preview appears after the screenshot request; opening it shows the page image.
- After reload, the saved preview opens again.
- Confirm the preview image is loaded (`complete && naturalWidth > 0`) and visible in the viewport.
