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
    When I load the bibliography
    Then I should have a bibliography cache entry for "_bibliography/references.bib"

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
    When I load the bibliography
    Then I should have a bibliography cache entry for "_bibliography/references.bib"
    And I should have 1 bibliography cache entry
    When I have a file "_bibliography/references.bib":
      """
      @book{ruby,
        title     = {The Ruby Programming Language but different},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      """
    Then I should have a bibliography cache entry for "_bibliography/references.bib"
    And I should have 2 bibliography cache entries
