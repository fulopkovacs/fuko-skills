---
name: execute-plan-in-steps
description: Execute plans one step at a time, pausing after each step so the user can review the results before proceeding
license: MIT
compatibility: opencode
metadata:
  audience: developers
---

## What I do

- I break up the execution of the plan into steps
- I stop after each step, summarize the results, tell the user what the next step is and wait until the user tells me to proceed

## When to use me

- Whenever I start executing a plan.

## Summary format

This is how summarizing the step should look like for step 2 (5 steps in total)

**2/5 <Step title>**
Short description of what I did

⚠️ **Warning** (optional):
- Things I couldn't do as requested

❓ **Questions** (optional):
- things I need to know for the next step

🖋️ **Commit message suggestion**
```
A short commit message suggestion (not conventional commit, imperative, short and starts with a capital letter.)
```

**Next step: <Next step title>**
Short description of the next step
