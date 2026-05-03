# Week 07 - Day 1: Branching & Feature Toggles

## 🎯 Topic: Branching Strategies, Trunk-Based Development, and Feature Flags

---

## 1. Why Branching?
Branches allow multiple developers to work on different features simultaneously without stepping on each other's toes or breaking the main production code.

**Key Branching Commands:**
- `git branch` (List branches)
- `git checkout -b feature/login` (Create AND switch to a new branch)
- `git switch main` (Modern way to switch branches)
- `git merge feature/login` (Combine changes from the feature branch into the current branch)

---

## 2. Branching Strategies (2026 Industry Standard)

While GitFlow (Main, Develop, Release, Feature, Hotfix) used to be popular, the modern DevOps standard is **Trunk-Based Development**.

### Trunk-Based Development
- Everyone merges code into `main` (the trunk) multiple times a day.
- Branches are extremely short-lived (hours, not days/weeks).
- Reduces the risk of massive, painful merge conflicts.
- Requires robust CI/CD pipelines and automated testing to ensure `main` is always deployable.

---

## 3. Feature Flags (Toggles)

If everyone is merging to `main` constantly, how do you prevent unfinished features from being visible to users? **Feature Flags.**

- A feature flag is essentially an `if/else` statement wrapped around new code.
- You deploy the code to production, but the feature is turned "off" via configuration.
- Allows you to decouple **Deployment** (putting code on a server) from **Release** (making the feature visible to users).
- E.g., `if (config.get('enable_new_dashboard') == true) { render_new(); } else { render_old(); }`

---

## 4. Rebase vs. Merge

When combining branches, you have two choices:
1. **Merge (`git merge`):** Creates a "merge commit" tying the histories together. Preserves exact history but can make the timeline messy.
2. **Rebase (`git rebase`):** Rewrites history by moving your feature branch to the "tip" of the `main` branch. Creates a clean, linear history.

**Golden Rule of Rebase:** Never rebase a branch that is shared with other developers (like `main`). Only rebase your personal, local feature branches.

---

## 5. AI Integration (Day 1 Practice)

```bash
# Ask Claude or Copilot:
"What is the difference between git merge and git rebase, and when should I use each?"
"Generate a simple Python example of using a dictionary to act as a feature flag configuration."
```
