Feature: Citations
  As a scholar who likes to blog
  I want to reference cool papers and books from my bibliography

  @tags
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

  @tags
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
