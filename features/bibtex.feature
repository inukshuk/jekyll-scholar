Feature: BibTeX
  As a scholar who likes to blog
  I want to publish my BibTeX bibliography on my blog
  In order to share my awesome references with my peers

  @converters
  Scenario: Simple Bibliography
    Given I have a scholar configuration with:
      | key   | value |
      | style | apa   |
     And I have a page "references.bib":
      """
      ---
      ---
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/references.html" file should exist
    And I should see "<i>The Ruby Programming Language</i>" in "_site/references.html"

  Scenario: Markdown Formatted Bibliography
    Given I have a scholar configuration with:
      | key   | value |
      | style | apa   |
    And I have a page "references.bib":
      """
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
      """
    When I run jekyll
    Then I should see "<h1[^>]*>References</h1>" in "_site/references.html"

  @latex
  Scenario: Simple Bibliography with LaTeX directives
    Given I have a scholar configuration with:
      | key   | value |
      | style | apa   |
    And I have a page "references.bib":
      """
      ---
      ---
      @misc{umlaut,
        title     = {Look, an umlaut: \"u!},
      }
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/references.html" file should exist
    And I should see "Look, an umlaut: ü!" in "_site/references.html"

  @tags @bibtex @wip
  Scenario: Embedded BibTeX
    Given I have a scholar configuration with:
      | key   | value |
      | style | apa   |
     And I have a page "references.md":
      """
      ---
      ---
      References
      ==========

      {% bibtex %}
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      {% endbibtex %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/references.html" file should exist
    And I should see "<i>The Ruby Programming Language</i>" in "_site/references.html"

  @tags
  Scenario: Simple Bibliography Loaded From Default Directory
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
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography -f references %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"

  @tags @bibliography @config
  Scenario: Simple Bibliography With Custom Template
    Given I have a scholar configuration with:
      | key                   | value                                         |
      | source                | ./_bibliography                               |
      | bibliography_template | <abbr>{{index}} {{entry.type}} [{{key}}]</abbr>{{reference}} |
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
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography -f references %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"
    And I should see "<abbr>1 book \[ruby\]</abbr><span" in "_site/scholar.html"

  @tags @filter
  Scenario: Filtered Bibliography Loaded From Default Directory
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
      },
      @book{smalltalk,
        title     = {Smalltalk Best Practice Patterns},
        author    = {Kent Beck},
        year      = {1996},
        publisher = {Prentice Hall}
      }

      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography -f references --query @book[year <= 2000] %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should not see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"
    And I should see "<i>Smalltalk Best Practice Patterns</i>" in "_site/scholar.html"

  @tags @filter @variables
  Scenario: Filter using interpolated query variable
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
      },
      @book{smalltalk,
        title     = {Smalltalk Best Practice Patterns},
        author    = {Kent Beck},
        year      = {1996},
        publisher = {Prentice Hall}
      }

      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% assign yr = 2000 %}
      {% bibliography -f references --query @book[year <= {{ yr }}] %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should not see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"
    And I should see "<i>Smalltalk Best Practice Patterns</i>" in "_site/scholar.html"

  @tags @bibliography @prefix
  Scenario: A Prefixed Bibliography
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
      },
      @book{smalltalk,
        title     = {Smalltalk Best Practice Patterns},
        author    = {Kent Beck},
        year      = {1996},
        publisher = {Prentice Hall}
      }

      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography --file references --prefix a -q @book[year <= 2000] %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should not see "ruby" in "_site/scholar.html"
    And I should see "id=\"a-smalltalk\"" in "_site/scholar.html"

  @tags @bibliography @style
  Scenario: Simple Bibliography Loaded From Default Directory
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
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography  --style modern-language-association %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "<i>The Ruby Programming Language</i>. O’Reilly Media, 2008" in "_site/scholar.html"
