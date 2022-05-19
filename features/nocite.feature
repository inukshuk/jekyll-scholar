Feature: Nocited Bibliographies
  As a scholar who likes to blog
  I want to sort my bibliography by hand
  But do not want to cite anything

  Scenario: Nocite references from a single bibliography
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby1,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      },
      @book{ruby2,
        title     = {Ruby Not Cited},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2007},
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
      {% nocite smalltalk ruby1 %}
      {% bibliography --cited %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "<i>Smalltalk Best Practice Patterns</i>" in "_site/scholar.html"
    And I should see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"
    And I should not see "<i>Ruby Not Cited</i>" in "_site/scholar.html"

Scenario: No nocite references results in empty bibliography
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
      {% bibliography --cited %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should not see "<i>Smalltalk Best Practice Patterns</i>" in "_site/scholar.html"
    And I should not see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"
