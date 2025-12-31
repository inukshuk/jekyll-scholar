Feature: Sorting BibTeX Bibliographies
  As a scholar who likes to blog
  I want to sort my bibliographies according to configurable parameters

  @tags @sorting
  Scenario: Sort By Year
    Given I have a scholar configuration with:
      | key     | value             |
      | sort_by | year              |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby1,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      @book{ruby2,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2007},
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
    Then "2007" should come before "2008" in "_site/scholar.html"

  @tags @sorting
  Scenario: Sort By Year With Nil Values
    Given I have a scholar configuration with:
      | key     | value             |
      | sort_by | year              |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby1,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      @book{ruby2,
        title     = {Nil}
      }
      @book{ruby3,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2007},
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
    Then "Nil" should come before "Ruby" in "_site/scholar.html"
    And "2007" should come before "2008" in "_site/scholar.html"

  @tags @sorting
  Scenario: Reverse Sort Order
    Given I have a scholar configuration with:
      | key     | value             |
      | sort_by | year              |
      | order   | descending        |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby1,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      @book{ruby2,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2007},
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
    Then "2008" should come before "2007" in "_site/scholar.html"

  @tags @sorting @cited_only
  Scenario: Sort By Year Cited Only
    Given I have a scholar configuration with:
      | key     | value             |
      | sort_by | year              |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby1,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      @book{ruby2,
        title     = {Ruby Not Cited},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2007},
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
      {% cite ruby1 %}
      {% cite smalltalk %}
      {% bibliography --cited %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    Then "Smalltalk" should come before "Ruby Programming" in "_site/scholar.html"
    And I should not see "<i>Ruby Not Cited</i>" in "_site/scholar.html"

  @tags @sorting @cited_only
  Scenario: Reverse Sort Order Cited Only
    Given I have a scholar configuration with:
      | key     | value             |
      | sort_by | year              |
      | order   | descending        |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby1,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      @book{ruby2,
        title     = {Ruby Not Cited},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2007},
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
      {% cite ruby1 %}
      {% cite smalltalk %}
      {% bibliography --cited %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    Then "Ruby Programming" should come before "Smalltalk" in "_site/scholar.html"
    And I should not see "<i>Ruby Not Cited</i>" in "_site/scholar.html"

  @tags @sorting @cited_in_order
  Scenario: Sort By Year Cited in Order
    Given I have a scholar configuration with:
      | key     | value             |
      | sort_by | year              |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby1,
        title     = {The Ruby Programming Language},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2008},
        publisher = {O'Reilly Media}
      }
      @book{ruby2,
        title     = {Ruby Not Cited},
        author    = {Flanagan, David and Matsumoto, Yukihiro},
        year      = {2007},
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
      {% cite ruby1 %}
      {% cite smalltalk %}
      {% bibliography --cited_in_order %}
      """
    When I run jekyll
    Then the _site directory should exist
    And the "_site/scholar.html" file should exist
    Then "Ruby Programming" should come before "Smalltalk" in "_site/scholar.html"
    And I should not see "<i>Ruby Not Cited</i>" in "_site/scholar.html"

  @tags @sorting
  Scenario: Sort By Year And Month
    Given I have a scholar configuration with:
      | key     | value       |
      | sort_by | year, month |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby1,
        title     = {December 08},
        year      = {2008},
        month     = dec
      }
      @book{ruby2,
        title     = {March 08},
        year      = {2008},
        month     = mar
      }
      @book{ruby3,
        title     = {August 07},
        year      = {2007},
        month     = aug
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
    Then "August 07" should come before "March 08" in "_site/scholar.html"
    And "March 08" should come before "December 08" in "_site/scholar.html"

  @tags @sorting
  Scenario: Multi-level Sort Order
    Given I have a scholar configuration with:
      | key     | value                 |
      | sort_by | year, month           |
      | order   | descending, ascending |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{ruby1,
        title     = {August 07},
        year      = {2007},
        month     = aug
      }
      @book{ruby2,
        title     = {March 08},
        year      = {2008},
        month     = mar
      }
      @book{ruby3,
        title     = {December 08},
        year      = {2008},
        month     = dec
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
    Then "March 08" should come before "December 08" in "_site/scholar.html"
    And "December 08" should come before "August 07" in "_site/scholar.html"

  @tags @sorting
  Scenario: Sort By Name (Author/Editor/Institution/Organization/Publisher Fallback)
    Given I have a scholar configuration with:
      | key     | value |
      | sort_by | name  |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{has_author,
        title     = {Book by Author},
        author    = {Zulu, Zebra},
        year      = {2020}
      }
      @book{has_editor,
        title     = {Book by Editor},
        editor    = {Alpha, Andrew},
        year      = {2020}
      }
      @book{has_both,
        title     = {Book with Both},
        author    = {Meyer, Maria},
        editor    = {Yankee, Yellow},
        year      = {2020}
      }
      @techreport{has_institution,
        title       = {Technical Report},
        institution = {MIT},
        year        = {2020}
      }
      @manual{has_organization,
        title        = {Standards Document},
        organization = {OECD},
        year         = {2020}
      }
      @misc{has_publisher,
        title     = {Anonymous Work},
        publisher = {Publisher House},
        year      = {2020}
      }
      @misc{has_none,
        title = {No Named Entity},
        year  = {2020}
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
    Then "No Named Entity" should come before "Book by Editor" in "_site/scholar.html"
    And "Book by Editor" should come before "Book with Both" in "_site/scholar.html"
    And "Book with Both" should come before "Technical Report" in "_site/scholar.html"
    And "Technical Report" should come before "Standards Document" in "_site/scholar.html"
    And "Standards Document" should come before "Anonymous Work" in "_site/scholar.html"
    And "Anonymous Work" should come before "Book by Author" in "_site/scholar.html"

  @tags @sorting
  Scenario: Sort By Name With Corporate Authors (Double Braces)
    Given I have a scholar configuration with:
      | key     | value |
      | sort_by | name  |
    And I have a "_bibliography" directory
    And I have a file "_bibliography/references.bib":
      """
      @book{personal_author,
        title     = {Book by Personal Author},
        author    = {Smith, John},
        year      = {2020}
      }
      @misc{corporate_double_brace,
        title     = {Annual Vegetable Report},
        author    = {{Cauliflower Appreciation Society}},
        year      = {2020}
      }
      @book{personal_early,
        title     = {Book by Early Author},
        author    = {Baker, Bob},
        year      = {2020}
      }
      @misc{corporate_early,
        title     = {Used Kar Price Guide},
        author    = {{Aardvark Kar Korp LTD}},
        year      = {2020}
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
    Then "Used Kar Price Guide" should come before "Book by Early Author" in "_site/scholar.html"
    And "Book by Early Author" should come before "Annual Vegetable Report" in "_site/scholar.html"
    And "Annual Vegetable Report" should come before "Book by Personal Author" in "_site/scholar.html"
