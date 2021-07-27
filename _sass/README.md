# tufte-mmistakes

Customizations to blend the style of Tufte-CSS into the Minimal Mistakes Jekyll theme

This is a drop-in set of files for customizing the [Minimal Mistakes]
Jekyll theme with styles and page layouts from the [Tufte Pandoc Jekyll]
theme. This project has been forked from the Tufte Pandoc theme and
tries to keep up with its features and version numbering.

:warning: *This is not a self-contained theme and still requires Minimal
Mistakes to be installed*.

[Minimal Mistakes]: https://mmistakes.github.io/minimal-mistakes/
[Tufte Pandoc Jekyll]: https://github.com/jez/tufte-pandoc-jekyll

## Rationale

One might think, at first, that blending the minimalistic [Tufte CSS] with a
highly structured theme such as Minimal Mistakes would debase both
projects, so why bother? For starters, the Minimal Mistakes framework is
quite flexible and can easily be made very plain—all you have to do is
edit a few data and config files to disable the bells and whistles. Even
then, should you require the occasional frills or the robust support
Minimal Mistakes has for authors, archives, and collections, they are
easy to activate.

## Features

- [Tufte Pandoc CSS] forked from the [Tufte Pandoc Jekyll] theme (requires
  [Pandoc sidenote])
- Sass file structure from [Minimal Mistakes], including the ability to
  customize variables
- Sidenotes and margin notes are expanded only in the `wide` and
  `splash` page classes (see the Minimal Mistakes docs); elsewhere they
  use the toggle button for narrow screens
- Supports utility classes in Minimal Mistakes (use the Pandoc syntax
  `{.text-center}` rather than the Kramdown `{: .text-center}` and so
  on)

[Tufte CSS]: https://edwardtufte.github.io/tufte-css/
[Tufte Pandoc CSS]: https://jez.io/tufte-pandoc-css/
[Pandoc sidenote]: https://github.com/jez/pandoc-sidenote

## Installation

Extract (or check out) the `*.scss` files from this repository into the
`_sass` directory of your Jekyll project.

