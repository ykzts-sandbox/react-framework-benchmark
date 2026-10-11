# Agent instructions

## Lint and format

After you edit files, run:

- `npm run fix` formats the project and applies Ultracite fixes.
- `npm run check` reports lint and format issues. The `ultracite` GitHub Actions job runs this script on pull requests and on pushes to `main`.

`npm run check` must pass before the work is finished.

## Commits

Follow the commit messages already in this repository. Use a Conventional Commits subject, add a short body when the subject is not enough, and end the message with an `Assisted-by` trailer. Leave one blank line before the trailer.

```text
chore: describe the change

Explain why the change is needed.

Assisted-by: grok-build:grok-4.7
```

The trailer value is `<tool>:<model>`. Commits from Grok Build use `grok-build:grok-4.7`.
