Feature: BibTex
  As as scholar who likes to blog and has limited time
  I want to render my bibliography quickly
  by caching the bibliography entries

  Scenario: Normal usage
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
      {% cite ruby %}
      {% bibliography -f references %}
      """
    And I clear the jekyll caches
    When I run jekyll
    Then I should have 1 bibliography cache entry
    And I should have 1 cite cache entry
    And I should have a cite cache entry for ruby

  Scenario: Changed file
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
      {% cite ruby %}
      {% bibliography -f references %}
      """
    And I clear the jekyll caches
    When I run jekyll
    Then I should have 1 bibliography cache entry
    And I should have 1 cite cache entry
    And I should have a cite cache entry for ruby
    And I should see "Ruby" in "_site/scholar.html"
    When I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Scooby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      @book{newbie,
        title     = {The Newbie Programming Language},
        author    = {Programmer, Tennex},
        year      = {2009},
        publisher = {O'Reilly Media}
      }
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% cite ruby %}
      {% cite newbie %}
      {% bibliography -f references %}
      """
    And I run jekyll
    Then I should have 2 bibliography cache entries
    And I should have 2 cite cache entries
    And I should have a cite cache entry for ruby
    And I should have a cite cache entry for newbie
    And I should see "Scooby" in "_site/scholar.html"
    And I should see "Newbie" in "_site/scholar.html"
