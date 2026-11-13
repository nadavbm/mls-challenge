# Senior DevOps Engineer: technical challenge

## Context

This challenge is the kind of work the role owns directly. Our SRE team maintains the
standard Helm chart that about 40 platform services deploy from. We also own the Flux setup
that rolls it out, and the Terraform that grants those services access to Google Cloud.

A large part of the job is reviewing changes to that shared code and deciding what is safe
to merge. That is what this challenge asks you to do.

There is no answer key. We are interested in what you block on, what you let through, and
how you explain the difference.

## The situation

A colleague opened merge request !288 against the platform repository. The title is "Give
checkout-service access to the receipts bucket". They want to merge it today.

You are the reviewer.

Read these files in this order.

| File | What it is |
|---|---|
| `CONTEXT.md` | How our platform is set up. You need this to review the change. |
| `MERGE_REQUEST.md` | The merge request description, as the author wrote it. |
| `charts/service/` | The chart today, before the change. |
| `releases/` | The two Flux releases for the service, dev and prod. |
| `terraform/checkout-service.tf` | The Terraform for its identity and its bucket. |
| `proposed.diff` | The change itself. |

Nothing needs to be installed and nothing needs to run. Everything you need is text in
this repository.

If you have Helm and want to render the chart, you are welcome to. It is not required, and
the change can be reviewed entirely by reading.

## Your task

Three things.

**1. Review the change.** Write `REVIEW.md`. For each point you raise, say how strongly
you feel about it: what blocks the merge, what you would want fixed but would not block
on, and what is only a preference. Say what you would ask the author.

The change does several things at once. Tell us what you think should happen to the merge
request as a whole. Splitting it or sending it back is a fair answer. Put that at the end,
after you review what is in it.

Whatever you recommend for the merge request overall, go through what is in it. "This does
too much" is a recommendation rather than a review, and the author is going on leave, so
somebody has to read the code.

Going through it does not mean writing something about every line. It means no part of the
change goes unlooked at, so that when you stay quiet about something we know you decided to.
A review that flags ten things at equal weight is not a useful review, and we would rather
see where you draw the line than read a complete list of everything that could be better.

**2. Fix what you called blocking.** The files here are the state before the change, so
apply `proposed.diff` first and commit it on its own, for which `SUBMISSION.md` gives the
commands. Then fix those. You do not have to fix everything you raised, and
you should not fix the things you decided were fine. If you run out of time,
commit what you have and say so.

Write the commit messages so that they say why, not only what. We can see what changed from
the diff, so the message is where the reasoning goes, and it is where we would look first
if this landed in our repository and broke something six months from now. One or two
sentences for each is plenty:

> Raise the client timeout to 30s
>
> The payment provider answers in about 8s at the ninety-ninth percentile and our timeout
> was 5s, so we were abandoning requests the provider went on to complete and the customer
> was charged twice. 30s is their published ceiling.

**3. Write the readme.** Replace `README.md` with your own. Cover your assumptions, the
decisions you made and why, and what you deliberately did not do. This is the part we read
most closely. Write it in your own words. A generated summary of your own diff tells us
nothing we cannot see in the diff.

At least one thing in this change has no clean answer. We want your position on it, not
the right one.

## Time

One hour. If you reach it before you are finished, stop there and put the rest in the
readme under what you would have done next. We would rather read an hour of your judgement
than an evening of your patience, and a submission that stops at the hour is a complete
one.

A shorter submission with clear reasoning beats a longer one. If you find yourself
polishing, you are over the line.

## AI usage

If you normally use AI, use it here. It is not required and you are not penalised either
way. We use these tools daily and we are not testing whether you can work without them.

If you used AI, add a short section to your readme: which tool, and one place where you did
not take what it gave you. Three sentences is enough. If you did not use AI, say that
instead.

## What to submit

A git repository, arranged the way you would hand it to a colleague for review. See
`SUBMISSION.md`.

GitLab is what we use, so a GitLab repository is easiest for us. GitHub or a bundle is
fine too.

## What we will discuss

We use your submission as the starting point for a technical conversation. Expect questions about your findings, the trade-offs you made, and how you would take the work further. There are no wrong answers. We want to hear your reasoning.

Questions about the task? Ask your hiring contact before you start.
