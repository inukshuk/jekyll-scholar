Jekyll-Scholar
==============

Jekyll-Scholar is for all the academic bloggers out there. It is a set of
extensions to [Jekyll](http://jekyllrb.com/), the awesome, blog aware, static
site generator; it formats your bibliographies and reading lists for the web
and gives your blog posts citation super-powers.

Installation
------------

    $ [sudo] gem install jekyll-scholar


Usage
-----

Install and setup a new [Jekyll](http://jekyllrb.com/) directory (see the
[Jekyll-Wiki](https://github.com/mojombo/jekyll/wiki/Usage) for detailed
instructions). To enable the Jekyll-Scholar add the following statement
to a file in your plugin directory (e.g., to `_plugins/ext.rb`):

    require 'jekyll/scholar'

In your configuration you can now adjust the Jekyll-Scholar settings

    citation_style: apa
    citation_language: en

You can use any style that ships with
[CiteProc-Ruby](https://github.com/inukshuk/citeproc-ruby) by name (e.g.,
apa, mla, chicago-fullnote-bibliography), or else you can add a link
to any CSL style (e.g., you could link to any of the styles available at
the official [CSL style repository](https://github.com/citation-style-language/styles)).

The `citation_language` settings defines what language to use when formatting
your references (this typically applies to localized terms, e.g., 'Eds.' for
editors in English).

### Bibliographies

Once you have loaded Jekyll-Scholar, all files with the extension `.bib` or
`.bibtex` will be converted when you run Jekyll (don't forget to add a YAML
header to the files); the file can contain regular HTML or Markdown and
BibTeX entries; the latter will be formatted by Jekyll-Scholar according to
the citation style and language defined in your configuration file.

For example, if you had a file `bibliography.bib` in your root directory:

      ---
      ---
      References
      ==========

      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }

It would be converted to `bibliography.html` with the following content:

    <h1 id='references'>References</h1>

    <p>Flanagan, D., &#38; Matsumoto, Y. (2008). <i>The Ruby Programming Language</i>. O&#8217;Reilly Media.</p>

This makes it very easy for you to add you bibliography to your Jekyll-powered
blog or website.


### Citations

Jekyll-Scholar will support inline citations and automatic generation of
a list of references for individual blog posts. Stay tuned.


License
-------

Jekyll-Scholar is distributed under the same license as Jekyll.

Copyright (c) 2011-2012 [Sylvester Keil](http://sylvester.keil.or.at/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
