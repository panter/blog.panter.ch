---
title: 5 rules to Git better
date: 2016-08-25 19:41 UTC
author: lex
tags:
---

Git is one of the greatest developer tools available. But using Git in a wrong
way can lead to a miserable life. The following 5 rules might help to preserve
your developer happiness.

1. **Make commits as small as possible**
1. **Write meaningful commit messages**
1. **Rebase always**
1. **Don't squash everything**
1. **Commit instead of commenting out**

That's it. Those are 5 basic rules that help you fix or enhance your workflow
with Git.

And now let's get into some more detail.


## 1. Make commits as small as possible

A commit can't be too small; it can only be too big. This is the same rule that
applies to programming in general, where a class or a method should be kept
small. Whenever creating a commit, think about the [Single Responsibility
Principle (SRP)](https://en.wikipedia.org/wiki/Single_responsibility_principle)
as well. Does the commit change only one thing or are its changes all over the
place? Make your commit as concise and cohesive as possible.  Another way of
thinking about cohesiveness and SRP is that a commit should be revertable. When
reverting the commit and the changes affect later changes or different aspects
then your commit violates the SRP.


## 2. Write meaningful commit messages

The basic semantic rules for creating a meaningful commit message are the
following:

* Use the present tense
* Describe what you did
* Describe why you did it if it's not obvious. Many times you or some other
  developer will look at code where its purpose is not obvious. In this case
  having the possibility to `git blame` and read a meaningful description of
  the change is very helpful.

The basic structural rules for creating a meaningful commit message are the
following:

* Keep the first line short (not more than 50 chars). Many tools such as Github
  and graphical git clients strip the subject after 50 characters, and people
  working on the command line are better off with text which is not too wide.
* Keep the second line empty
* Use the rest of the commit message to describe the commit. There's no
  restriction on the format nor the length, so be as descriptive and
  informative as possible.

This is what the [man page](https://www.kernel.org/pub/software/scm/git/docs/git-commit.html)
of the `git commit` command says:

> Though not required, it’s a good idea to begin the commit message with a
> single short (less than 50 characters) line summarizing the change, followed
> by a blank line and then a more thorough description.



And if you're not convinced yet, read [the following readme section by Linus
Torvalds](https://github.com/torvalds/subsurface/blob/a48494d2fbed58c751e9b7e8fbff88582f9b2d02/README#L88),
the inventor of Git.


## 3. Rebase always

Rebase. Always. Frequently.

Avoid merging whenever possible. Merge commits are usually meaningless and just
clutter the Git history. Only introduce merge commits when they actually do
something useful, as e.g. when merging a pull request or a feature branch. In
this case, they make the history more readable by providing a point where a
certain feature was introduced. Also, they facilitate reverting a whole merge.

Merge commits such as "Merge branch 'master' into [...]" are totally worthless
and just show that the developer was too lazy to rebase. Whenever you're
syncing a branch with another one, always rebase. Also for `git pull` you
should set your config to 'use rebase' instead of merge.

(Often, having to resolve the merge conflicts on a particular commit makes it
easier to reason about the conflict.)

But, there are also situations when rebasing should not be used. Don't rebase
published changes. You should never rebase commits that someone else might have
already consumed. You should never change the history of origin/master. For
feature branches which are work in progress, it's totally fine to rebase, as
long as you work alone on the branch or your team is aware of the fact that you
rebase. As soon as they land in master, the commits must not be changed anymore.


## 4. Don't squash everything

If you adhere to rule 1, every commit is meaningful and documents your work.
Squashing removes a lot of valuable information about the history and all the
changes done to the codebase.

Squashing is useful when you have commits that semantically belong together, or
if you have commits that amend other commits. So squashing (or interactive
rebasing) is useful whenever a commit is not meaningful on its own.


## 5. Commit instead of commenting out

When some code is not used anymore or even not used temporarily, don't comment
it out. Remove the code and create a commit for this. If you adhere to rule 1,
you'll have a commit that you will find again later in case you need that
removed chunk of code back. Leaving commented out code in your codebase only
degrades maintenance and readability of the code. And by the way, a lot of
commented out code will never be considered again anyway.
