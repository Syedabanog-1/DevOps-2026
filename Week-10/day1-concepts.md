# 📝 Week 10 - Day 1: YAML for Everyone

## 🎯 What is YAML?
YAML (Yet Another Markup Language) is just a way to write information that both people and computers can understand. Think of it like a **very organized grocery list**.

DevOps engineers use YAML to tell tools like Kubernetes or GitHub Actions exactly what to do.

## 💡 The Basic Rules
YAML follows simple rules to keep things tidy:

1. **Spaces Matter**: You use spaces (usually 2) to show that one thing belongs to another. **Never use tabs!**
2. **Key: Value**: You write a "label" followed by a "value".
   - Example: `fruit: Apple`
3. **Lists**: Use a dash `-` for lists.
   - Example:
     ```yaml
     fruits:
       - Apple
       - Banana
       - Orange
     ```

## 🛠 Why do we care?
Most DevOps tools use YAML files as "Instruction Manuals". If you have a small error in your YAML (like a missing space), the computer won't understand the instructions and will stop working.

## 🧠 Best Practice
- **Keep it Simple**: Don't make the files too long.
- **Use a Validator**: Use tools to check your work before you save it.
- **Spaces, not Tabs**: This is the #1 mistake people make!
