# Adventures in Fenestra

| Links                          | Related Books                  |
|:-------------------------------|:-------------------------------|
| [Download][goblin hole]        | [Core book][core]              |
| [Email an idea][issues email]  | [Oneshot Adventure][oneshot]   |

*Adventures in Fenestra* will be a collection of modules for the BIND RPG.
Currently, only one module is complete: [the Goblin Hole][goblin hole].

## Getting the Book

You can compile the book in four steps:

1. Install the required packages:
    * For Debian/ Mint/ Ubuntu: `apt install inkscape make texlive-full git-lfs latexmk`.
    * For Arch Linux: `pacman -S inkscape make git git-lfs texlive-binextra texlive-latexextra texlive-fontsrecommended texlive-fontsextra && git lfs install`
    * For Void Linux: `xbps-install inkscape make texlive-full git-lfs texlive-latexmk`.
1. Clone this repo.
1. Enter the repo, and do `make all`.
1. Take the pdf to your local, friendly, print-shop.

For full setup instructions, see the [wiki][compiling].

Or just click [download][goblin hole].

[compiling]: https://gitlab.com/bindrpg/core/-/wikis/dev/Compiling
[oneshot]: https://gitlab.com/bindrpg/oneshot/-/jobs/artifacts/master/raw/Escape_from_the_Goblin_Horde.pdf?job=build
[core]: https://gitlab.com/bindrpg/metabind/-/jobs/artifacts/master/raw/complete/Core_Rules.pdf?job=build
[aif]: https://gitlab.com/bindrpg/aif/-/jobs/artifacts/master/raw/Adventures_in_Fenestra.pdf?job=build
[goblin hole]: https://gitlab.com/bindrpg/aif/-/jobs/artifacts/master/raw/The_Goblin_Hole.pdf?job=build
[issues email]: mailto:contact-project+bindrpg-aif-16324948-issue-@incoming.gitlab.com
