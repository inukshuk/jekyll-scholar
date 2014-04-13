Feature: Citations
  As a scholar who likes to blog
  I want to reference cool papers and books from my bibliography

  @tags @cite
  Scenario: A Simple Citation
    Given I have a scholar configuration with:
      | key          | value             |
      | source       | ./_bibliography   |
      | bibliography | my_references     |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/my_references.bib":
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
      {% cite ruby %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "Flanagan" in "_site/scholar.html"

  @tags @cite
  Scenario: Missing references
    Given I have a scholar configuration with:
      | key          | value             |
      | source       | ./_bibliography   |
      | bibliography | my_references     |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/my_references.bib":
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
      {% cite java %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "missing reference" in "_site/scholar.html"

  @tags @quote
  Scenario: A Simple Block-Quote
    Given I have a scholar configuration with:
      | key          | value             |
      | source       | ./_bibliography   |
      | bibliography | my_references     |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/my_references.bib":
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
      {% quote ruby %}
      We <3 Ruby
      {% endquote %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "<blockquote><p>We <3 Ruby</p><cite><a .*#ruby.+\(Flanagan" in "_site/scholar.html"

  @tags @cite
  Scenario: A prefixed citation
    Given I have a scholar configuration with:
      | key          | value             |
      | source       | ./_bibliography   |
      | bibliography | my_references     |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/my_references.bib":
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
      {% cite ruby --prefix a %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "#a-ruby" in "_site/scholar.html"

  @tags @cite
  Scenario: Multiple Citations
    Given I have a scholar configuration with:
      | key          | value             |
      | source       | ./_bibliography   |
      | bibliography | my_references     |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/my_references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }

      @book{microscope,
        title     = {Ruby Under a Microscope},
        author    = {Pat Shaughnessy},
        year      = {2013},
        publisher = {No Starch Press}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% cite ruby microscope %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "Flanagan &amp; Matsumoto, 2008; Shaughnessy, 2013" in "_site/scholar.html"

  @tags @cite @locator
  Scenario: Multiple Citations with locators
    Given I have a scholar configuration with:
      | key          | value             |
      | source       | ./_bibliography   |
      | bibliography | my_references     |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/my_references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }

      @book{microscope,
        title     = {Ruby Under a Microscope},
        author    = {Pat Shaughnessy},
        year      = {2013},
        publisher = {No Starch Press}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% cite ruby microscope -l 2-3 --locator 23 & 42 %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "Matsumoto, 2008, pp. 2-3; Shaughnessy, 2013, pp. 23 &amp; 42" in "_site/scholar.html"

  @tags @cite @citation_number
  Scenario: Multiple citations using citation numbers
    Given I have a scholar configuration with:
      | key          | value             |
      | source       | ./_bibliography   |
      | bibliography | my_references     |
      | style        | ieee              |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/my_references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }

      @book{microscope,
        title     = {Ruby Under a Microscope},
        author    = {Pat Shaughnessy},
        year      = {2013},
        publisher = {No Starch Press}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% cite ruby microscope %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "\[1\], \[2\]" in "_site/scholar.html"

