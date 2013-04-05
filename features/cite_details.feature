Feature: Citations
  As a scholar who likes to blog
  I want to reference cool papers and books from my bibliography

  @tags @cite_details
  Scenario: A Simple Cite Details Link
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
      {% cite_details ruby %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "Details</a>" in "_site/scholar.html"

  @tags @cite_details
  Scenario: A Simple Cite Details Link With A Text Argument
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
      {% cite_details ruby --text Click For More %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    And I should see "Click For More</a>" in "_site/scholar.html"
