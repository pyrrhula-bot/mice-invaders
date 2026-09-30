# Mice Invaders

Space Invaders, except the player is a cat and the invaders are mice. A small Godot 4
game, built one increment at a time.

---

## This repository is an exercise

**`main` is deliberately a scaffold.** A Godot project file, a tiny test runner, one
self-test, and this README — no game. The working rules live in **[pull request
#3](https://github.com/tuturu742/mice-invaders/pull/3)**, built end to end by
[Pyrrhula](https://github.com/tuturu742/pyrrhula)'s coding agents: a studio lead frames the
work, a developer builds it inside a container through a coding harness, and the lead reads
the diff against the task and approves it or sends it back. It was opened by one GitHub
account and approved by another, because an account cannot approve its own pull request.

Read the pull request to see what the loop produces. Then **do it yourself, in your own
fork**, and compare.

> **Why a fork, and not this repository?** You do not have push access here, and you never
> will — delegated work pushes branches and opens pull requests under a credential *you*
> give Pyrrhula, and that credential has to own the repository it writes to. GitHub will
> let anyone open a pull request *from* a fork of a public repo, but nobody can push a
> branch into someone else's repository. So: fork, then point Pyrrhula at your fork.

There is also a **conversation-only** version of this scenario in
[pyrrhula-samples](https://github.com/tuturu742/pyrrhula-samples) — two agents discussing
the same game without a repository, importable as a `.pyr` bundle. That one needs no
execution engine and takes a minute to run. This one builds the thing.

---

## The test contract

```sh
godot --headless --path . --script tests/run_tests.gd
```

Exit `0` if every test passed, `1` if any failed, and the failures printed with what they
compared. That is the whole contract, and it is the *point* of the scaffold: a delegated
agent verifies its own work by running this in a container with no display, then reads the
output and fixes what it says.

`tests/run_tests.gd` loads every `tests/test_*.gd`, instantiates it, and calls every method
named `test_*`. Assertions come from `tests/test_case.gd` — five of them, no framework.
Adding a test is adding a file. Reach for GUT or gdUnit4 when the project outgrows that,
not before.

A suite that finds no test files **fails**, rather than passing with nothing to do. A green
build that verified nothing is worse than a red one.

`tests/test_scaffold.gd` exists so a fresh clone is green; delete it once there are real
tests.

---

## Running the exercise yourself

The steps live with the sample, in
**[pyrrhula-samples/mice-invaders-delegated](https://github.com/tuturu742/pyrrhula-samples/tree/main/mice-invaders-delegated)**:
a `.pyr` bundle carrying the two personas (including the developer's harness selection) and
a README that starts at building the runtime image and ends at a pull request on your fork.

They are kept there rather than repeated here because they are re-checked against a purged
deployment whenever they change — a second copy would drift from the one that gets tested.

The one step worth knowing before you start: **Godot is not a built-in runtime**, so you
build a container image with Godot *and* Node (the harness installs itself with `npm i -g`
into the same container) and push it to a registry the engine can pull from. The sample's
README has the Dockerfile and the two traps — a socket engine pulls too, and a plain-HTTP
registry has to be trusted rather than merely reachable.

## What you should see

Wren turns the agenda into work items — real records, not a list in a message — and hands
each to Pike. Pike's container comes up, installs the harness, clones the branch, and then
the agent *works*: list the files, read the test runner to learn the contract, write
`scripts/formation.gd`, write `tests/test_formation.gd`, run the suite, read the failure,
fix it. A bounded summary comes back into the transcript in Pike's own voice — how many
steps, which tools, what it concluded, what it cost.

Then Wren reviews the diff against what it asked for. If the work is short, the item goes
back with comments and Pike reworks it in the same container. When it passes, the branch
is pushed to your fork and a pull request is opened.

Every model call the harness makes goes through Pyrrhula's own inference proxy, so it
lands in `usage_record` under `purpose='delegation'` and your caps apply to it. No provider
key ever enters the container — the agent gets a short-lived, scoped token that can only
spend on the connection its persona was given.

---

## Licence

MIT. See `LICENSE`.
