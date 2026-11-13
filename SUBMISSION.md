# How to hand this back

Send us a repository that looks the way your work looks on a normal day. We read it the
way we read a merge request from a colleague.

## Set up the base

Turn this folder into a repository and commit it exactly as you received it. Do this
before you change anything.

```bash
cd <this folder>
git init -b master
git add -A
git commit -m "Challenge as received"
```

That first commit is our baseline. It lets us read your work as a diff instead of guessing
what you changed.

## Do the work on a branch

```bash
git checkout -b review/mr-288
```

## Apply the change you are reviewing

The files in this folder are the state **before** the merge request. `proposed.diff` is the
change itself. You can read the diff without applying it, and for the review that is
enough.

To fix anything, you need the author's version in your working tree. Apply it and commit it
on its own, so that your fixes stay separate from their change:

```bash
git apply proposed.diff       # or: patch -p1 -i proposed.diff
git add -A                    # the diff adds files as well as editing them
git commit -m "Apply !288 as proposed"
```

Now your branch is the merge request. Everything you commit after this is your review in
code, and we can read it as a diff against the author's work rather than against the
original.

Commit as you go, and write the messages so that they explain why the change was needed
rather than restating the diff. Four commits that each carry their reasoning are worth a
great deal more to us than one commit called "changes".

## What the branch contains when you are done

| Path | What it is |
|---|---|
| `REVIEW.md` | Your review of !288. Severity per point. What you would ask the author. |
| `README.md` | Yours, replacing ours. Assumptions, decisions, what you left out and why. |
| `charts/`, `terraform/`, `releases/`, and anything else you touched | The fixes you decided to make. |

## Open it as a merge request

If you use GitLab or GitHub, push both branches and open a merge request from
`review/mr-288` into `master`. Write the merge request description as you normally would.
Send us the link. Make the project visible to us, or add your hiring contact.

If you would rather not use a hosted service, send a bundle. A bundle packs the whole
repository, every branch and all history, into one file we can clone from:

```bash
git status                                  # make sure nothing is left uncommitted
git bundle create submission.bundle --all
```

Attach that file to your reply. We will unpack it and read the branch.

A bundle contains committed work only. Anything you edited but did not commit is not in
the file, and neither of us finds out until we open it. Check `git status` first.

## A note on scope

Fix what you called blocking. Leave alone what you decided was fine, and say in your
readme that you decided it was fine. We are reading for the line you drew. The number of changes
does not matter.

If you run out of time, commit what you have and write the rest as "what I would do next".
That is a complete submission.
