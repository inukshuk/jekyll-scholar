Feature: BibTeX
  As a scholar who likes to blog
  I want to apply filters to my BibTeX bibliography
  In order to have control over the references that go up on my website

  @tags @filters
  Scenario: Filter by Year
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
      | query  | "@*[year=2009]"   |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      @book{pickaxe,
        title     = {Programming Ruby 1.9: The Pragmatic Programmer's Guide},
        author    = {Thomas, Dave and Fowler, Chad and Hunt, Andy},
        year      = {2009},
        edition   = 3,
        publisher = {Pragmatic Bookshelf}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "Programming Ruby" in "_site/scholar.html"
    And I should not see "The Ruby Programming Language" in "_site/scholar.html"

  @tags @filters
  Scenario: Jekyll Filters
    Given I have a scholar configuration with:
      | key                   | value             |
      | source                | ./_bibliography   |
      | bibliography_template | template          |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
    @book{ruby:2008-Foo,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      """
    And I have a "_layouts" directory
    And I have a file "_layouts/template.html":
      """
      ---
      ---
      {{ entry.key | slugify }}
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "ruby-2008-foo" in "_site/scholar.html"

  @tags @max
  Scenario: Limit number of entries
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      @book{pickaxe,
        title     = {Programming Ruby 1.9: The Pragmatic Programmer's Guide},
        author    = {Thomas, Dave and Fowler, Chad and Hunt, Andy},
        year      = {2009},
        edition   = 3,
        publisher = {Pragmatic Bookshelf}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography --max 1 %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should not see "Programming Ruby" in "_site/scholar.html"
    And I should see "The Ruby Programming Language" in "_site/scholar.html"

  @tags @offset
  Scenario: Start listing entries with an offset
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      @book{pickaxe,
        title     = {Programming Ruby 1.9: The Pragmatic Programmer's Guide},
        author    = {Thomas, Dave and Fowler, Chad and Hunt, Andy},
        year      = {2009},
        edition   = 3,
        publisher = {Pragmatic Bookshelf}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography --offset 1 %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "Programming Ruby" in "_site/scholar.html"
    And I should not see "The Ruby Programming Language" in "_site/scholar.html"

  @tags @urls
  Scenario: URLs as text
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{pickaxe,
        title     = {Programming Ruby 1.9: The Pragmatic Programmer's Guide},
        author    = {Thomas, Dave and Fowler, Chad and Hunt, Andy},
        year      = {2009},
        edition   = 3,
        publisher = {Pragmatic Bookshelf},
        url       = {https://pragprog.com}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "from https://pragprog.com" in "_site/scholar.html"

  @tags @urls
  Scenario: URLs as Markdown links
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have the following BibTeX filters:
      | markdown |
      | latex    |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{pickaxe,
        title     = {Programming Ruby 1.9: The Pragmatic Programmer's Guide},
        author    = {Thomas, Dave and Fowler, Chad and Hunt, Andy},
        year      = {2009},
        edition   = 3,
        publisher = {Pragmatic Bookshelf},
        url       = {https://pragprog.com}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "from \[https://pragprog.com\]\(https://pragprog.com\)" in "_site/scholar.html"

  @tags @urls
  Scenario: LaTeX links as Markdown links
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have the following BibTeX filters:
      | markdown |
      | latex    |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{pickaxe,
        title     = {Programming Ruby 1.9: The Pragmatic Programmer's Guide},
        author    = {Thomas, Dave and Fowler, Chad and Hunt, Andy},
        year      = {2009},
        edition   = 3,
        publisher = {\href\{https://pragprog.com\}\{Pragmatic Bookshelf\}},
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "\[Pragmatic Bookshelf\]\(https://pragprog.com\)" in "_site/scholar.html"

  @tags @superscript
  Scenario: LaTeX Superscript as HTML
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have the following BibTeX filters:
      | superscript |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @misc{pickaxe,
        title     = {This is \textsuperscript{superscript text}.}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "This is <sup>superscript text</sup>." in "_site/scholar.html"

  @tags @superscript
  Scenario: LaTeX Superscript with embedded LaTeX chars as HTML
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have the following BibTeX filters:
      | superscript |
      | latex       |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @misc{pickaxe,
        title     = {\textsuperscript{\"u \"{u} \v{z}}}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "<sup>ü ü ž</sup>" in "_site/scholar.html"

  @tags @superscript
  Scenario: LaTeX Superscript as HTML with embedded LaTeX chars left untouched
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have the following BibTeX filters:
      | superscript |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @misc{pickaxe,
        title     = {\textsuperscript{\"u \"{u} \v{z}}}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "<sup>\\"u \\"\{u\} \\v\{z\}</sup>" in "_site/scholar.html"

  @tags @superscript
  Scenario: LaTeX Superscript with subsequent groups as HTML
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have the following BibTeX filters:
      | superscript |
      | latex       |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @misc{pickaxe,
        title     = {This is \textsuperscript{superscript text} this should not be superscript {even} {with {additional} groups}.}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "This is <sup>superscript text</sup> this should not be superscript even with additional groups." in "_site/scholar.html"

  @tags @superscript
  Scenario: LaTeX Superscript with subsequent groups untouched in HTML
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have the following BibTeX filters:
      | superscript |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @misc{pickaxe,
        title     = {This is \textsuperscript{superscript text} this should not be superscript {even} {with {additional} groups}.}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "This is <sup>superscript text</sup> this should not be superscript \{even\} \{with \{additional\} groups\}." in "_site/scholar.html"
