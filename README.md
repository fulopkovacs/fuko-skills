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

<p align="center">
      <a href="https://x.com/notacheetah">X (Twitter)</a> | 
      <a href="https://github.com/fulopkovacs">GitHub</a> |
      <a href="https://www.youtube.com/@fyicli">YouTube</a> |
      <a href="https://fulop.dev">🌐 fulop.dev</a>
  </tr>
</table>

## Skills for AI-assisted coding

You'll find these skills useful, if you're like me and you:
- need to review/rebase/fix heavy PR-s frequently (from AI/human collaborators)
- can't hand over the whole development cycle to long-running agents
- like to be in control:
    - the agents do the work, but you do the thinking.

If these resonate with you, you might find the skills below useful too!

## Usage

Install the skills using [skills.sh](https://skills.sh):

```sh
npx skills add fulopkovacs/fuko-skills
```

Follow the prompts to select the skills and agents you want to use.

## Skills

### [rebase-branch](./skills/rebase-branch/SKILL.md)

<p align="center">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://github.com/user-attachments/assets/f3220bcd-6ae0-450d-9eec-520660cea753"
    />
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://github.com/user-attachments/assets/f609ea66-1df2-43d0-9141-e3090c2e6f3a"
    />
    <img
      width="520"
      alt="rebase-branch"
      src="https://github.com/user-attachments/assets/f609ea66-1df2-43d0-9141-e3090c2e6f3a"
    />
  </picture>
</p>


```sh
npx skills add fulopkovacs/fuko-skills --skill rebase-branch
```

- walks you through the rebase interactively
- explains the conflicts to you and offers you solutions
- mostly using it for rebasing other ppl's or the agent's PR-s

### [present-plans](./skills/present-plans/SKILL.md)

<p align="center">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://github.com/user-attachments/assets/729479f2-ad01-4a94-b10c-eb8e1991f37f"
    />
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://github.com/user-attachments/assets/6bbab7f8-2bb1-472d-9a12-d82677beaedc"
    />
    <img
      width="520"
      alt="present-plans"
      src="https://github.com/user-attachments/assets/6bbab7f8-2bb1-472d-9a12-d82677beaedc"
    />
  </picture>
</p>


```sh
npx skills add fulopkovacs/fuko-skills --skill present-plans
```

- presents plans in a way that's easier to overview
- lists the steps, the affected files and how much they'll change
- highlights what to look out for and summarizes the changes


### [execute-plan-in-steps](./skills/execute-plan-in-steps/SKILL.md)
  
<p align="center">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://github.com/user-attachments/assets/29d7b7cc-17a0-42f3-80b2-1eab4156c3fc"
    />
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://github.com/user-attachments/assets/e44ac644-d6f0-4121-bc18-6dd363a51380"
    />
    <img
      width="520"
      alt="execute-plan-in-steps"
      src="https://github.com/user-attachments/assets/e44ac644-d6f0-4121-bc18-6dd363a51380"
    />
  </picture>
</p>


```sh
npx skills add fulopkovacs/fuko-skills --skill execute-plan-in-steps
```

- breaks up the execution of a plan into steps
    - you can make plans with the [`present-plans`](#present-plans) skill
- stops after each step, summarizes the results and tells you what the next step is
- waits for your approval before proceeding to the next step
- suggests you a commit message
- **⚠️ What to look out for**
    - the progress is often off/random (displays 2/4 at the second step for a 5-step process)

### [review-changes](./skills/review-changes/SKILL.md)

<p align="center">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://github.com/user-attachments/assets/f69c938d-ae85-4d2c-9b0f-4ae64bced40f"
    />
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://github.com/user-attachments/assets/98a63f0e-bfec-4622-8075-98044f7f3b23"
    />
    <img
      width="520"
      alt="review-changes"
      src="https://github.com/user-attachments/assets/98a63f0e-bfec-4622-8075-98044f7f3b23"
    />
  </picture>
</p>


```sh
npx skills add fulopkovacs/fuko-skills --skill review-changes
```

- reviews PR-s/uncommitted/staged/unstaged/branch/commit changes
- groups the changes into logical features and walks you through them one by one
- highlights bugs, regressions, security concerns
    - gives you concrete testing steps
