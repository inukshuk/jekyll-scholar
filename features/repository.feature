Feature: PDF Repository
  As a scholar who likes to blog
  I want to publish my BibTeX bibliography on my blog
  And I want Jekyll to generate links to PDFs of my references automatically

  @repository
  Scenario: A bibliography with a single entry and a repository
    Given I have a scholar configuration with:
      | key                   | value             |
      | source                | ./_bibliography   |
      | repository            | papers            |
      | bibliography_template | bibliography      |
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
    And I have a "papers" directory
    And I have a file "papers/ruby.pdf":
      """
      The PDF
      """
    And I have a file "papers/ruby.ppt":
      """
      The PPT
      """
    And I have a "_layouts" directory
    And I have a file "_layouts/bibliography.html":
      """
      ---
      ---
      {{ reference }} Link: {{ link }} Slides: {{ links.ppt }}
      """
    And I have a page "scholar.html":
      """
      ---
      ---
      {% bibliography %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/papers/ruby.pdf" file should exist
    And I should see "The Ruby Programming Language" in "_site/scholar.html"
    And I should see "Link: /papers/ruby.pdf" in "_site/scholar.html"
    And I should see "Slides: /papers/ruby.ppt" in "_site/scholar.html"



