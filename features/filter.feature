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
