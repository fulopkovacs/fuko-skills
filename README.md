# Fuko's skills

<p align="center">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://github.com/user-attachments/assets/6e91611c-ff80-45cd-a1cc-f729f6df0667"
    />
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://github.com/user-attachments/assets/fde88c94-cdf2-480d-8e63-692b43b6c9e9"
    />
    <img
      width="184"
      height="72"
      alt="fuko-badge"
      src="https://github.com/user-attachments/assets/fde88c94-cdf2-480d-8e63-692b43b6c9e9"
    />
  </picture>
</p>

<table align="center">
  <tr>
    <td align="center">
      <a href="https://x.com/notacheetah">
        <img src="https://cdn.simpleicons.org/x/000000/ffffff" width="20" height="20" alt="X" />
      </a>
    </td>
    <td align="center">
      <a href="https://www.youtube.com/@fyicli">
        <img src="https://cdn.simpleicons.org/youtube/000000/ffffff" width="20" height="20" alt="YouTube" />
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/fulopkovacs">
        <img src="https://cdn.simpleicons.org/github/000000/ffffff" width="20" height="20" alt="GitHub" />
      </a>
    </td>
    <td align="center">
      <a href="https://fulop.dev">🌐 fulop.dev</a>
    </td>
  </tr>
</table>

## About these skills

All of them solve real issues that I've seen at work.

Some words about me:
- work on full-stack applications (mainly TanStack Start)
- mostly using OpenCode and Claude (planning/controlling workers from Claude (Fable), doing the actual work in OpenCode with GPT 5.6 Sol)
- had to review a lot of heavy PR-s from my teammates in the last month
- technical leader in our small team, so architecture/infra-related tasks also land on my table
- one of our contributor is a designer (not a dev), so requires extra attention
- working with several agents in parallel on the same project using [`herdr`](https://herdr.dev) and git worktrees ([`wt`](https://worktrunk.dev))
- manually written code vs generated %
    - prototypes: 90% generated, not necessarily reviewed manually
    - mvp-s: 60-80% generated, but I still review every single line
        - I usually do a lot of planning, and iterations

## Usage

Install the skills using [skills.sh](https://skills.sh):

```sh
npx skills add fulopkovacs/fuko-skills
```

Follow the prompts to select the skills and agents you want to use.

## Skills

### [rebase-branch](./skills/rebase-branch/SKILL.md)

```sh
npx skills add fulopkovacs/fuko-skills --skill rebase-branch
```

- walks you through the rebase interactively
- explains the conflicts to you and offers you solutions
- mostly using it for rebasing other ppl's or the agent's PR-s
