# Mice Invaders

Space Invaders, except the player is a cat and the invaders are mice. A small Godot 4
game, built one increment at a time.

---

## This repository is an exercise

**`main` is deliberately a scaffold.** A Godot project file, a tiny test runner, one
self-test, and this README — no game. The working game lives in a **pull request**, built
end to end by [Pyrrhula](https://github.com/tuturu742/pyrrhula)'s coding agents: a
facilitator persona frames the work, a developer persona builds it inside a container
through a coding harness, and a reviewer reads the diff against the task and approves it
or sends it back.

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

You need a Pyrrhula deployment with an execution engine (a Docker or Podman socket, or
Kubernetes), a model API key, and — unlike the other showcases — **a container image you
build yourself**. Built and tested against **DeepSeek**.

### 1. Fork this repository

Use the **Fork** button. Everything below points at *your* fork.

### 2. Build the runtime image

Godot is not one of Pyrrhula's built-in runtimes (`debian`, `node20`, `python312`,
`java21`), so the delegated container needs an image that has it. It also needs Node,
because the coding harness installs itself with `npm i -g` into that same container — a
Godot-only image fails at setup before the agent ever starts.

```dockerfile
FROM docker.io/library/node:20-bookworm
ARG GODOT_VERSION=4.3-stable

RUN apt-get update \
 && apt-get install -y --no-install-recommends unzip ca-certificates \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL -o /tmp/godot.zip \
      "https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}/Godot_v${GODOT_VERSION}_linux.x86_64.zip" \
 && unzip -q /tmp/godot.zip -d /tmp \
 && mv "/tmp/Godot_v${GODOT_VERSION}_linux.x86_64" /usr/local/bin/godot \
 && chmod +x /usr/local/bin/godot \
 && rm -rf /tmp/godot.zip

ENV HOME=/root
ENV XDG_DATA_HOME=/root/.local/share
ENV XDG_CONFIG_HOME=/root/.config

RUN godot --headless --version
```

```sh
podman build -t localhost/pyr-godot-node:4.3 -f godot.Dockerfile .
```

Where the image has to live depends on your engine. A **Podman or Docker socket** engine
runs containers on the same host, so an image built locally is already reachable by that
name. **Kubernetes and ECS** pull from a registry, so push it to one the cluster can
reach and name it with the registry prefix — and if the registry is private, put its
credentials on the repo row too.

> Pyrrhula does not build this image for you. An image builder is on its roadmap and is
> not in the product yet, so for now a custom runtime is an image an operator builds and
> hosts. There is nothing in the UI that does it, which is why this step is spelled out.

### 3. Make a GitHub token for the agents

A classic personal access token with the **`repo`** scope, able to push to your fork.
Pyrrhula seals it with its encryptor; it is never shown again and never reaches the
container.

> **Two tokens, if you want the review to be real.** GitHub will not let an account
> approve a pull request it opened itself. Give the repository one account's token (the
> one that pushes branches and opens PRs) and bind the facilitator persona to a second
> account's token under **Repos → your repo → Persona credentials**. With one token the
> reviewer's approval is cosmetic. A second account needs to be a collaborator on your
> fork first, or its token sees a 404 rather than a permission error.

### 4. Sign up and choose the workflow

Register with any organization name, then **Workflows → Software Development** — the
workflow that grants repository access at all.

### 5. Add your model connection

**Personas → Model profiles → New model profile**: a name, provider `deepseek`, a model,
and your API key.

### 6. Register your fork

**Repos → New repo**:

| Field | Value |
|---|---|
| Key | `mice-invaders` |
| Source URL | `https://github.com/<you>/mice-invaders` |
| Access token | the token from step 3 |
| Runtime | `custom` |
| Runtime image | `localhost/pyr-godot-node:4.3` (or your registry's name for it) |
| Test command | `godot --headless --path . --script tests/run_tests.gd` |

Pyrrhula clones your fork into its own hosted store. Delegated containers clone *that*
over a scoped, short-lived token and never talk to GitHub at all; only the platform pushes
back to your fork.

### 7. Create the cast

**Personas → New persona**, twice:

| | Type | Harness | Notes |
|---|---|---|---|
| **Wren** | supervisor | none | frames the work and reviews what comes back |
| **Pike** | participant | `opencode` | builds it |

The **Harness** dropdown sits beside *Web search* on the persona roster. `none` is the
default and keeps the one-shot path, where the model answers with whole files and never
runs anything. Choosing a harness gives that persona a real agent loop with a shell inside
its container — it reads, edits, runs the tests, and iterates before anything is
committed.

> If the dropdown is absent, your deployment serves no harness. If `opencode` is missing
> from it, an administrator has withheld it for this organization.

### 8. Set a daily cap first

**Usage → Limits**, a per-persona daily token cap. An agent loop is many calls per task,
and a confused one on a cheap model can spend a great deal before it gives up. The cap
turns that into a clean "on hold" note instead of a bill.

### 9. Start the session

**New session**:

- **Process definition**: `Plan, Implement, Review, Merge`
- **Supervisor**: Wren · **Participant**: Pike
- **Repos**: your fork
- **Agenda**: the brief below

```
Build the cat-vs-mice game one increment at a time. Start with the pure rules: the invader
grid layout, how the formation marches and drops a row at an edge, and how it speeds up as
mice are destroyed. Keep the logic testable without a running scene -- the test container
has no display, so anything that only works inside a running game cannot be verified and
does not count as finished.

Scripts go in scripts/ as plain RefCounted classes with no scene dependencies. Tests go in
tests/ as test_*.gd extending res://tests/test_case.gd, and
`godot --headless --path . --script tests/run_tests.gd` must exit 0 before an item is done.

The scene and the sprites come after the rules, and stay thin: art is optional, so a
missing sprite must never block a green build.
```

---

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
