Feature: Set custom class or attributes in lists
  As a scholar who likes to blog
  I want to publish my BibTeX bibliography on my blog
  In order to share my awesome references with my peers

  @tags @bibliography
   Scenario: Default bibliography_list_attributes: {}
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
      | bibliography_list_attributes | {} |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
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
      {% bibliography -f references %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"
    And I should see "<i>Smalltalk Best Practice Patterns</i>" in "_site/scholar.html"
    And I should see "<ol class=\"bibliography\">" in "_site/scholar.html"
    And I should see "</ol>" in "_site/scholar.html"

  @tags @bibliography
   Scenario: Default bibliography_list_attributes: {} with reverse override
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
      | bibliography_list_attributes | {} |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
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
      {% bibliography -f references %}
      """
    And I have a page "scholar-reversed.html":
      """
      ---
      ---
      {% bibliography -f references --bibliography_list_attributes {:reversed=>'reversed'} %}
      """
 
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"
    And I should see "<i>Smalltalk Best Practice Patterns</i>" in "_site/scholar.html"
    And I should see "<ol class=\"bibliography\">" in "_site/scholar.html"
    And I should see "</ol>" in "_site/scholar.html"
    And I should see "<ol class=\"bibliography\" reversed=\"reversed\">" in "_site/scholar-reversed.html"
    And I should see "</ol>" in "_site/scholar-reversed.html"

  @tags @bibliography
   Scenario: Default bibliography_list_attributes: {} with reverse override and custom class
    Given I have a scholar configuration with:
      | key    | value             |
      | source | ./_bibliography   |
      | bibliography_list_attributes | {} |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
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
      {% bibliography -f references %}
      """
    And I have a page "scholar-reversed-custom.html":
      """
      ---
      ---
      {% bibliography -f references --bibliography_list_attributes {:reversed=>'reversed', :class=>'bibliography__custom'} %}
      """
 
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"
    And I should see "<i>Smalltalk Best Practice Patterns</i>" in "_site/scholar.html"
    And I should see "<ol class=\"bibliography\">" in "_site/scholar.html"
    And I should see "</ol>" in "_site/scholar.html"
    And I should see "<ol class=\"bibliography__custom\" reversed=\"reversed\">" in "_site/scholar-reversed-custom.html"
    And I should see "</ol>" in "_site/scholar-reversed-custom.html"
