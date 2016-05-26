Feature: Details
  As a scholar who likes to blog
  I want to publish my BibTeX bibliography on my blog
  And I want Jekyll to generate detail pages for all the entries in my bibliography

  @generators
  Scenario: A bibliography with a single entry
    Given I have a scholar configuration with:
      | key            | value             |
      | source         | ./_bibliography   |
      | details_layout | details.html      |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        comment   = {A Comment},
        publisher = {O'Reilly Media}
      }
      """
    And I have a "_layouts" directory
    And I have a file "_layouts/details.html":
      """
      ---
      ---
      <html>
      <head></head>
      <body>
      {{ page.title }}
      {{ page.entry.comment }}
      </body>
      </html>
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/bibliography/ruby.html" file should exist
    And I should see "The Ruby Programming Language" in "_site/bibliography/ruby.html"
    And I should see "A Comment" in "_site/bibliography/ruby.html"

  @generators
  Scenario: LaTeX conversion is applied to everything except the bibtex field
    Given I have a scholar configuration with:
      | key            | value             |
      | source         | ./_bibliography   |
      | details_layout | details.html      |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {An Umlaut \"a!},
      }
      """
    And I have a "_layouts" directory
    And I have a file "_layouts/details.html":
      """
      ---
      ---
      <html>
      <head></head>
      <body>
      Page title: {{ page.title }}
      Title: {{ page.entry.title }}
      {{ page.entry.bibtex }}
      </body>
      </html>
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/bibliography/ruby.html" file should exist
    And I should see "Page title: An Umlaut ä!" in "_site/bibliography/ruby.html"
    And I should see "Title: An Umlaut ä!" in "_site/bibliography/ruby.html"
    And I should see "title = {An Umlaut \\\"a!}" in "_site/bibliography/ruby.html"

  @generators
  Scenario: LaTeX conversion can be turned off
    Given I have a scholar configuration with:
      | key            | value             |
      | source         | ./_bibliography   |
      | details_layout | details.html      |
      | bibtex_filters |                   |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {An Umlaut \"a!},
      }
      """
    And I have a "_layouts" directory
    And I have a file "_layouts/details.html":
      """
      ---
      ---
      <html>
      <head></head>
      <body>
      Page title: {{ page.title }}
      Title: {{ page.entry.title }}
      {{ page.entry.bibtex }}
      </body>
      </html>
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/bibliography/ruby.html" file should exist
    And I should see "Page title: An Umlaut \\\"a!" in "_site/bibliography/ruby.html"
    And I should see "Title: An Umlaut \\\"a!" in "_site/bibliography/ruby.html"
    And I should see "title = {An Umlaut \\\"a!}" in "_site/bibliography/ruby.html"

  @tags @details
  Scenario: Links to Detail Pages are Generated Automatically
    Given I have a scholar configuration with:
      | key            | value             |
      | source         | ./_bibliography   |
      | bibliogaphy    | references        |
      | details_layout | details.html      |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      """
    And I have a "_layouts" directory
    And I have a file "_layouts/details.html":
      """
      ---
      ---
      <html>
      <head></head>
      <body>
      {{ page.entry.title }}
      </body>
      </html>
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
    And the "_site/bibliography/ruby.html" file should exist
    And I should see "<a[^>]+href=\"/bibliography/ruby.html\">" in "_site/scholar.html"

  @tags @details
  Scenario: Links to Detail Pages Work With Pretty URLs
    Given I have a configuration file with "permalink" set to "pretty"
    And I have a scholar configuration with:
      | key            | value             |
      | source         | ./_bibliography   |
      | bibliogaphy    | references        |
      | details_layout | details.html      |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      """
    And I have a "_layouts" directory
    And I have a file "_layouts/details.html":
      """
      ---
      ---
      <html>
      <head></head>
      <body>
      {{ page.entry.title }}
      </body>
      </html>
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And I should see "pretty" in "_config.yml"
    And the "_site/scholar/index.html" file should exist
    And I should see "<a[^>]+href=\"/bibliography/ruby/\">" in "_site/scholar/index.html"
    And the "_site/bibliography/ruby/index.html" file should exist

  @generators @parse_months
  Scenario: Months are parsed by default
    Given I have a scholar configuration with:
      | key            | value             |
      | details_layout | details.html      |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{august,
        month     = {August}
      }
      """
    And I have a "_layouts" directory
    And I have a file "_layouts/details.html":
      """
      ---
      ---
      {{ page.entry.bibtex }}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/bibliography/august.html" file should exist
    And I should see "month = aug" in "_site/bibliography/august.html"

  @generators @parse_months
  Scenario: Month parsing can be turned off
    Given I have a scholar configuration with:
      | key            | value             |
      | details_layout | details.html      |
    And I have the following BibTeX options:
      | key            | value             |
      | parse_months   | false             |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{august,
        month     = {August}
      }
      """
    And I have a "_layouts" directory
    And I have a file "_layouts/details.html":
      """
      ---
      ---
      {{ page.entry.bibtex }}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/bibliography/august.html" file should exist
    And I should see "month = {August}" in "_site/bibliography/august.html"
