# **STEAM AWS CLI**

<br/>

This repo contains a cli for handling a very basic control of an ec2 instance on aws, ensuring it has both steam and remote desktop protocol (rdp) access present, as well as security-groups that only allow incoming access from the users ip address.

<br/>

## *Contents*

<br/>

* [Purpose](#purpose)
* [Tools and Resources Used](#tools-and-resources-used)
* [Concepts Included](#concepts-included)
* [Final Thoughts](#final-thoughts)
* Other docs:
    * [How to Use (with screenshots!)](./docs/how_to_use.md)

<br/>

## *Purpose*

<br/>

This repo was mostly to give a hand at setting up a steam installation in the cloud as a fun side-project, and also to get some more practise at writing out a bash based utility and learning more about the tools available for bash development.

Not actually recommended to use given the costs of running any instances that would actually be able to handle most modern games!

<br/>

## *Tools And Resources Used*

<br/>

*   bash
    *   shellspec - test suite
    *   shellcheck - linter
    *   shfmt - auto-formatter
*   containers (docker)
*   packer
*   unix (ubuntu)
*   remote desktop access
*   aws
    *   cli
    *   ami
    *   ec2
    *   security groups
    *   volumes
    *   instance profiles
*   commitizen
*   pre-commit
*   github actions
*   jq

<br/>

## *Concepts Included:*

<br/>

*   export modules (similar to C Header Guards)
*   centralised logging
*   containerised usage/development
*   ci (basic) with commitizen/pre-commit/actions running linting/tests on PRs to 'main' and then auto updating versions and taggging on success.
*   a true cli with override flags and help (sub-)commands

<br/>

## *Final Thoughts:*

<br/>

As mentioned near the top I wouldn't recommend actually using this to use steam via the cloud. Checking current prices it would come to around at least $1 an hour to run this, and also probably some pretty bad latency. Using something like nvidia's cloud gaming offering makes a lot for sense for around $10 a month instead.

In terms thoughts on the codebase itself, I wanted to use bash and the aws cli to make this as I usually use JS/TS or Java to create tools/apps and I wanted to get a better feel for what bash could do and what was available for it. If I was to do it again though I'd probably use JS/TS or Java and make use of the SDKs that aws provides. Or maybe even Rust as I've been picking up that in recent times.

With regards to bash itself, learning that it had linting/formatting and even test libraries was interesting! For my JS/TS projects I usually have that all set up from the start and I'll start doing that as well for bash should I try and make anything bigger than a one off script with it in the future. Particularly the testing with shellspec as normally I would have ensured everything was at least unit tested with some integration thrown in too, but by the time I learnt about shellspec I had already spent a week on this and didn't want to extend it much further. I'm glad I'll know for next time though!

I also continue to enjoy the free CI functionality that comes with github, having actions exist removes all the additional effort that would come with setting up some kind of external pipeline provider like jenkins or circleci.

All in all it was fun to try out something more complex with a language I only occasionally use and learn some more about the tooling it has access to. It was also fun to be able to spin up an ec2 and play games off of it on my old laptop, even if the instance I used meant that I could only run the smaller games in my library.

<br/>

-----

## See also:

<br/>

[How to Use](./docs/how_to_use.md)

-----
