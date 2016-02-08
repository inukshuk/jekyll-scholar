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

  @tags @bibliography @config @template @cite_details
  Scenario: Raw bibtex template in details page
    Given I have a scholar configuration with:
      | key                   | value            |
      | source                | ./_bibliography  |
      | bibliography_template | {{entry.bibtex}} |
      | details_layout        | details.html     |
      | use_raw_bibtex_entry  | true             |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{a,
        title     = {{'b' | prepend: 'a'}}
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
    
    And the "_site/bibliography/a.html" file should exist
    And I should see "{{'b' | prepend: 'a'}}" in "_site/bibliography/a.html"
    And I should not see "ab" in "_site/bibliography/a.html"
    
  @tags @bibliography @config @template @cite_details
  Scenario: Raw bibtex template in details page
    Given I have a scholar configuration with:
      | key                   | value            |
      | source                | ./_bibliography  |
      | bibliography_template | {{entry.bibtex}} |
      | details_layout        | details.html     |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{a,
        title     = {{'b' | prepend: 'a'}}
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
    
    And the "_site/bibliography/a.html" file should exist
    And I should not see "{{'b' | prepend: 'a'}}" in "_site/bibliography/a.html"
    And I should see "ab" in "_site/bibliography/a.html"
    
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
