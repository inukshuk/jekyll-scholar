Jekyll-Scholar
==============

Jekyll-Scholar is for all the academic bloggers out there. It is a set of
extensions to [Jekyll](http://jekyllrb.com/), the awesome, blog aware, static
site generator; it formats your bibliographies and reading lists for the web
and gives your blog posts citation super-powers.

For additional features you may also want to take a look at
[jekyll-scholar-extras](https://github.com/jgoodall/jekyll-scholar-extras).

[![Build Status](https://travis-ci.org/inukshuk/jekyll-scholar.png?branch=master)](https://travis-ci.org/inukshuk/jekyll-scholar)
[![Coverage Status](https://coveralls.io/repos/inukshuk/jekyll-scholar/badge.png)](https://coveralls.io/r/inukshuk/jekyll-scholar)
[![Dependency Status](https://gemnasium.com/inukshuk/jekyll-scholar.png)](https://gemnasium.com/inukshuk/jekyll-scholar)

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

Alternatively, add `jekyll-scholar` to your `gem` list in your Jekyll
configuration:

    gems: ['jekyll/scholar']

In your configuration you can now adjust the Jekyll-Scholar settings. The
default configuration is as follows:

    scholar:
      style: apa
      locale: en

      sort_by: none
      order: ascending

      source: ./_bibliography
      bibliography: references.bib
      bibliography_template: "{{reference}}"

      replace_strings: true
      join_strings:    true

      details_dir:    bibliography
      details_layout: bibtex.html
      details_link:   Details

      query: "@*"

You can use any style that ships with
[CiteProc-Ruby](https://github.com/inukshuk/citeproc-ruby) by name (e.g.,
apa, mla, chicago-fullnote-bibliography), or else you can add a link
to any CSL style (e.g., you could link to any of the styles available at
the official [CSL style repository](https://github.com/citation-style-language/styles)).

The `locale` settings defines what language to use when formatting
your references (this typically applies to localized terms, e.g., 'Eds.' for
editors in English).

The `source` option indicates where your bibliographies are stored;
`bibliography` is the name of your default bibliography. For best results,
please ensure that your Bibliography is encoded as ASCII or UTF-8.


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

This makes it very easy for you to add your bibliography to your Jekyll-powered
blog or website.

If your using other converters to generate your site, don't worry, you can
still generate bibliographies using the `bibliography` tag. In your site
or blog post, simply call:

    {% bibliography %}

This will generate your default bibliography; if you use multiple, you can
also pass in a name to tell Jekyll-Scholar which bibliography it should render.

Let's say you have two bibliographies stored in `_bibliography/books.bib` and
`_bibliography/papers.bib`; you can include the bibliographies on your site
by respectively calling `{% bibliography --file books %}` and
`{% bibliography --file papers %}`. For example, you could have a file `references.md`
with several reference lists:

    ---
    title: My References
    ---

    {{ page.title }}
    ================

    The default Bibliography
    ------------------------

    {% bibliography %}

    Secondary References
    --------------------

    {% bibliography --file secondary %}

Finally, the bibliography tag supports an optional filter parameter. This
filter takes precedence over the global filter defined in your configuration.

    {% bibliography --query @*[year=2013] %}

The example above would print a bibliography of all entires published in
the year 2013. Of course you can also combine the file and filter parameters
like this:

    {% bibliography -f secondary -q @*[year=2013] %}

This would print the publications from 2013 of the bibliography at
`_bibliography/secondary.bib`.

For more details about filters, see the corresponding section below or
consult the [BibTeX-Ruby](https://github.com/inukshuk/bibtex-ruby)
documentation.

If you need to limit the number of entries in your bibliography, you can
use the `--max` option:

    {% bibliography --max 5 %}

This would generate a bibliography containing only the first 5 entries
of your bibliography (after query filters and sort options have been applied).

### Bibliography Template

Your bibliography is always rendered as an ordered list. Additionally,
each reference is wrapped in an HTML tag (`span` by default but you can
change this using the `reference_tagname` setting) with the cite key
as id. The reference string itself is governed by the rules in your
CSL style but you can also customize the main template a little bit.
By default, the template is `{{reference}}` – this renders only the
reference tag. The template uses Liquid to render and, in
addition to the reference, exposes the cite-key (as `key`), the
entry's `type`, the `index` in the bibliography, and the link to
file repository as `link`. Thus, you could
customize the template in your configuration as follows:

    scholar:
      bibliography_template: <abbr>[{{key}}]</abbr>{{reference}}

This would be processed into something like:

    <li><abbr>[ruby]</abbr><span id="ruby">Matsumoto, Y. (2008). <i>The Ruby Programming Language</i>. O&#8217;Reilly Media.</span></li>

If you have more complex requirements, it quickly becomes tedious to
have the template inside the configuration; for this reason, you can
also put the bibliography template into your layouts directory. Jekyll-Scholar
will load this template if the option set in your configuration matches
an existing layout (without the file extension). That is to say, if you set:

    scholar:
      bibliography_template: bib

And there is a file `_layouts/bib.html` (or with another extension) the
contents of this file will be used as the template. Please note that it is
important for this file to contain the YAML front matter! For example, this
would be a more complex template file:

    ---
    ---
    {{ reference }}

    {% if entry.abstract %}
    <p>{{ entry.abstract }}</p>
    {% endif %}

    <pre>{{ entry.bibtex }}</pre>

You can also override the default bibliography template, by passing the
`--template` or `-T` option parameter to the bibliography tag.

### Citations

If you want to reference books or papers from your bibliography in your blog
posts, Jekyll-Scholar can help you, too. Simply use the `cite` tag with
the appropriate key of the item you want to cite and Jekyll-Scholar will
create a formatted citation reference for you. For a quick example, take
following blog post:

    ---
    layout: default
    title: A Blogging Scholar
    ---

    {{ page.title }}
    ================

    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
    incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
    nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
    Duis 'aute irure dolor in reprehenderit in voluptate' {% cite derrida:purveyor %}
    velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
    cupidatat non proident, 'sunt in culpa qui officia deserunt mollit anim id est
    laborum' {% cite rabinowitz %}.

    Duis 'aute irure dolor in reprehenderit in voluptate' {% cite breton:surrealism %}
    velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
    cupidatat non proident, 'sunt in culpa qui officia deserunt mollit anim id est
    laborum' {% cite rainey %}.

    References
    ----------

    {% bibliography %}

Note that this will print your entire bibliography in the Reference section.
If you would like to include only those entries you cited on the page, pass
the `cited` option to the bibliography tag:

    {% bibliography --cited %}

By default, the `--cited` option will still sort your bibliography if you set
the sort option. Especially for styles using citation numbers, this is usually
not the desired behaviour. In such cases you can use `--cited_in_order` instead
of `--cited` and your bibliography will contain all cited items in the order
they were cited on the page.

For longer quotes, Jekyll-Scholar provides a `quote` tag:

    {% quote derrida:purveyor %}
    Lorem ipsum dolor sit amet, consectetur adipisicing elit,
    sed do eiusmod tempor.

    Lorem ipsum dolor sit amet, consectetur adipisicing.
    {% endquote %}

For example, this could be rendered as:

    <blockquote>
      <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit,<br/>
      sed do eiusmod tempor.</p>
      <p>Lorem ipsum dolor sit amet, consectetur adipisicing.</p>
      <cite>
        <a href="#derrida:purveyor">(Derrida, 1975)</a>
      </cite>
    </blockquote>

#### Multiple citation

You can cite multiple items in a single citation by referencing all ids
of the items you wish to quote separated by spaces. For example,
`{% cite ruby microscope %}` would produce a cite tag like:

    <a href="#ruby">(Flanagan &amp; Matsumoto 2008; Shaughnessy 2013)</a>

#### Suppressing author names

Sometimes you want to suppress author names in a citation, because the
name has already been mentioned in your text; for such cases Jekyll-Scholar
provides the `--suppress_author` option (short form: `-A`):
`...as Matz explains {% cite ruby -A -l 42 %}` would produce something
like: `...as Matz explains (2008, p. 42)`.

#### Page numbers and locators

If you would like to add page numbers to your citation, you can use the
`-l` or `--locator` option. For example, `{% cite ruby -l 23-5 %}` would
produce a citation like `(Matsumoto, 2008, pp. 23-5)`.

When quoting multiple items (see above) you can add multiple locators after
the list of ids. For example, `{% cite ruby microscope -l 2 -l 24 & 32 %}`.

#### Displaying formatted references

If you want to display the full formatted reference entry, you can use the
`reference` tag. For example, given the following Bibtex entry,

    @book{ruby,
      title     = {The Ruby Programming Language},
      author    = {Flanagan, David and Matsumoto, Yukihiro},
      year      = {2008},
      publisher = {O'Reilly Media}
    }

using `{% reference ruby %}` anywhere in your page, it will print
"Flanagan, D., & Matsumoto, Y. (2008). *The Ruby Programming Language.*.
O'Reilly Media" (the exact result depends on your formatting style).

The `reference` tag accepts the same --file/-f parameter as the bibliography
tag. This can be handy if you want to use a special BibTeX file as input for
a specific page. As an example, the tag

    {% reference ruby --file /home/foo/bar.bib %}

will attempt to read the key `ruby` from file `/home/foo/bar.bib`. It will not
fallback to the default BibTeX file.

#### Multiple bibliographies within one document (like [multibib.sty](http://www.ctan.org/pkg/multibib))

When you have multiple `{% bibliography %}` sections in one file,
Jekyll-Scholar will generate several lists containing the same
publications that have the same `id` attributes. As a result, when you
cite a reference the link to an `id` attribute cannot be resolved
uniquely. Your browser will always take you take you to the first
occurrence of the `id`. Moreover, valid HTML requires unique `id`
attributes. This scenario may happen, for example, if you cite the
same reference in different blog posts, and all of these posts are
shown in one html document.

As a solution, Jekyll-Scholar provides the `--prefix` tag. In your
first post you might cite as

    ---
    title: Post 1
    ---
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor
    incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
    nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
    Duis 'aute irure dolor in reprehenderit in voluptate'
    {% cite derrida:purveyor --prefix post1 %} velit esse cillum
    dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
    non proident, 'sunt in culpa qui officia deserunt mollit anim id
    est laborum' {% cite rabinowitz --prefix post1 %}.

    References
    ----------

    {% bibliography --cited --prefix post1 %}


For the second blog post you would cite as follows:

    ---
    title: Post 2
    ---
    Duis 'aute irure dolor in reprehenderit in voluptate'
    {% cite rabinowitz --prefix post2 %} velit esse cillum
    dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat
    non proident, 'sunt in culpa qui officia deserunt mollit anim id
    est laborum' {% cite rainey --prefix post2  %}.

    References
    ----------

    {% bibliography --cited --prefix post2 %}

Even though both posts cite 'rabinowitz', both citations will be
assigned unique identifiers linking to the respective references
section, although both posts will be rendered into a single HTML
document.


### File Repositories

File repository support was added to Jekyll-Scholar starting at version
2.0. Currently, if you have a folder in your site that contains PDF or
Postscript files of your papers, you can use the configuration option
`repository` to indicate this directory. When generating bibliographies,
Jekyll-Scholar will look in that folder to see if it contains a filename
matching each entry's BibTeX key: if it does, the path to that file
will be exposed to the bibliography template as the `link` property.

Since version 4.1.0 repositories are not limited to PDF and PS files.
These files are mapped to the `links` property in your bibliography
template. Here is an example of template that utilizes this feature
to link to supporting material in a ZIP archive:

    {{ reference }} [<a href="{{links.zip}}">Supporting Materials</a>]

### Detail Pages

If your layouts directory contains a layout file for bibliography details
(the `details_layout` configuration options), Jekyll-Scholar will generate
a details page for each entry in you main bibliography. That is to say, if
your bibliography contains the following entry:

    @book{ruby,
      title     = {The Ruby Programming Language},
      author    = {Flanagan, David and Matsumoto, Yukihiro},
      year      = {2008},
      publisher = {O'Reilly Media}
    }

Then a page 'bibliography/ruby.html' will be generated according to your
details page layout. In the layout file, you have access to all fields
of your BibTeX entry. Here is an example of a details page layout:

    ---
    ---
    <html>
    <head></head>
    <body>
      <h1>{{ page.entry.title }}</h1>
      <h2>{{ page.entry.author }}</h2>
      <p>{{ page.entry.abstract }}</p>
    </body>
    </html>

When Jekyll-Scholar generates detail pages, it also adds links to each
entry's detail page to the generated bibliography. You can alter the
name of the link via the 'details_link' configuration option.

Jekyll-Scholar also provides a Liquid tag for conveniently adding links
to individual detail pages. For example, if you would like to add a simple
link to one of the items in your bibliography on a page or in a blog post
you can use the `cite_details` tag to generate the link. For this to work,
you need to pass the BibTeX key of the element you want to reference to
the tag and, optionally, provide a text for the link (the default text
can be set via the 'details_link' configuration option).

    Duis 'aute irure dolor in reprehenderit in voluptate' velit esse cillum
    dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
    proident {% cite_details key --text Click Here For More Details %}.


### Bibliography Filters

By default, Jekyll-Scholar includes all entries in you main BibTeX file
when generating bibliographies. If you want to include only those entries
matching certain criteria, you can do so by adjusting the 'query'
configuration option. For example:

    query: "@book" #=> includes only books
    query: "@article[year>=2003]" #=> includes only articles published 2003 or later
    query: "@*[url]" #=> includes all entries with a url field
    query: "@*[status!=review]" #=> includes all entries whose status field is not set to 'review'
    query: "@book[year <= 1900 && author ^= Poe]" #=> Books published before 1900 where the author matches /Poe/
    query: "!@book" #=> includes all entries with a type other than book

Please note that some of these queries require BibTeX-Ruby 2.3.0 or
later versions. You can also overwrite the configuration's query parameter
in each bibliography tag individually as described above.

Contributing
------------

The Jekyll-Scholar source code is
[hosted on GitHub](http://github.com/inukshuk/jekyll-scholar/).
You can check out a copy of the latest code using Git:

    $ git clone https://github.com/inukshuk/jekyll-scholar.git

To use this lasted version instead of the one provide by RubyGems,
just add the line

    $:.unshift '/full/path/to/the/repository/lib'

to your `_plugins/ext.rb` before requiring 'jekyll/scholar', where
`/full/path/to/the/repository` is the path to your local version
of Jekyll-Scholar.

When contributing to Jekyll-Scholar, please make sure to install
all dependencies and run the cucumber features:

    $ bundle install
    $ rake

If you've found a bug or have a question, please open an issue on the
[Jekyll-Scholar issue tracker](http://github.com/inukshuk/jekyll-scholar/issues).
Or, for extra credit, clone the Jekyll-Scholar repository, write a failing
example, fix the bug and submit a pull request.

Additionally, if we merged at least one of your pull request you will get
write permissions to the repository if you want them.

License
-------

Jekyll-Scholar is distributed under the same license as Jekyll.

Copyright (c) 2011-2014 [Sylvester Keil](http://sylvester.keil.or.at/)

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
