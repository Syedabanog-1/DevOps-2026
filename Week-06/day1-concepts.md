# Week 06 - Day 1: Git Fundamentals

## 🎯 Topic: Version Control, Local vs. Remote, Commits, and Reverts

---

## 1. What is Version Control?
Version control systems (VCS) track changes to files over time. Git is a *distributed* VCS, meaning every developer has a full local copy of the repository's history.

**Why it's essential for DevOps:**
- Infrastructure as Code (IaC) requires versioning.
- It provides an audit trail (Who changed what and when?).
- It enables rollbacks when things break in production.

---

## 2. Git Concepts & States

Git thinks of your data as a timeline of snapshots.

### The Three States of Git:
1. **Working Directory:** Where you edit files.
2. **Staging Area (Index):** Where you prepare files for the next commit.
3. **Local Repository:** The `.git` folder where committed snapshots are permanently stored.

### Local vs. Remote
- **Local:** The repo on your laptop. You can work fully offline.
- **Remote:** A version of your project hosted on the internet (GitHub, Azure Repos, GitLab). We sync local and remote using `git push` and `git pull`.

---

## 3. Core Commands

| Command | Action |
|---------|--------|
| `git init` | Initializes a new local repository. |
| `git status` | Shows which files are modified or staged. |
| `git add <file>` | Moves a file to the Staging Area. |
| `git commit -m "msg"`| Takes a snapshot of the staging area and saves it to the local repo. |
| `git log` | Shows the commit history. |
| `git revert <hash>` | Creates a *new* commit that undoes the changes of a specific past commit (Safe for shared history). |

---

## 4. Revert vs. Reset (Crucial Difference)

- **git revert:** Safely undoes changes by creating a new, opposing commit. This is the **ONLY** safe way to undo things that have already been pushed to a remote repository.
- **git reset:** Moves the timeline pointer backwards, literally erasing history. **DANGEROUS** if commits have already been pushed/shared with the team.

---

## 5. AI Integration (Day 1 Practice)

```bash
# Ask Claude or Copilot:
"Explain the difference between git reset --soft, --mixed, and --hard."
"Write a git commit message for adding a new Nginx configuration file following conventional commit guidelines."
```

---

## 🧠 Key Takeaways
1. Always check `git status` before you `git add` to avoid staging unintended files (like secrets or large binaries).
2. Write meaningful commit messages. Future you (and your team) will thank you.
3. If it's pushed to origin, use `git revert`. If it's only local, you can use `git reset`.
