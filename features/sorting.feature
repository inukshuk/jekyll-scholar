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

