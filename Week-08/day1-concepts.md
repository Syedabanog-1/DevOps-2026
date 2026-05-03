# Week 08 - Day 1: Pull Requests & Environment Promotion

## 🎯 Topic: PR Workflows, Code Review, and Deployment Pipelines

---

## 1. The Pull Request (PR) Workflow
A Pull Request (or Merge Request in GitLab) is a formal request to merge your feature branch into the `main` branch. It acts as the primary quality gate in modern DevOps.

### Anatomy of a Good PR:
- **Title:** Follows conventional commits (e.g., `feat: added user authentication`).
- **Description:** Explains *why* the change was made, not just *what* was changed.
- **Reviewers:** At least one other engineer must review the code.
- **Automated Checks:** CI/CD pipelines run unit tests, linting, and security scans automatically on the PR code.

---

## 2. Environment Promotion (The CI/CD Path)

Code doesn't just go straight to users. It moves through environments.

1. **DEV (Development):** Where engineers test their code locally or in a shared messy sandbox.
2. **SIT (System Integration Testing):** Code from multiple developers is combined and tested together. Usually triggered when a PR is merged to `main`.
3. **UAT (User Acceptance Testing):** A production-like environment where product managers or clients verify the feature works as expected.
4. **PROD (Production):** The live system.

*Promotion:* Moving an artifact (like a Docker image) from SIT → UAT → PROD. You do not rebuild the code for each environment; you promote the exact same compiled binary/image.

---

## 3. Merge Conflicts (The Inevitable)

Merge conflicts happen when two developers edit the **exact same line** of the **exact same file** concurrently, and Git doesn't know whose change to keep.

### Resolving Conflicts:
1. Git marks the file as conflicted.
2. You open the file. Git adds conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
3. You manually delete the markers and keep the code you want.
4. You run `git add <file>` and `git commit` to finalize the merge.

---

## 4. AI Integration (Day 1 Practice)

```bash
# Ask Claude or Copilot:
"Review this code snippet and generate a constructive code review comment that I can paste into a Pull Request."
"Write a Git commit message explaining how I resolved a merge conflict in package.json."
```
