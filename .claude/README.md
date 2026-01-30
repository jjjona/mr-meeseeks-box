## Ralph example

- Create folder 00-docs
- Add PROMPT.md
- create .claude/settings.json with kill command in stop hook to close interactive mode after each iteration
- execute following command in terminal:

`while :; do cat 00-docs/PROMPT.md | claude --dangerously-skip-permissions; done`

Congrats, this is Ralph.

---

Fixed number of iterations:

`for i in {1..10}; do cat 00-docs/PROMPT.md | claude --dangerously-skip-permissions; done`
