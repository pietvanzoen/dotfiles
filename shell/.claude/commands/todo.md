---
name: todo
description: Manage tasks
allowed-tools: Bash(todo *)
disable-model-invocation: true
---

Run the following shell command in the background and respond with a single brief confirmation line:

```bash
todo $ARGUMENTS
```

Keep your response brief. If items were listed, show them verbatim. If an item was added, confirm in one line.
