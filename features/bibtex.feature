Feature: BibTeX
  As a scholar who likes to blog
  I want to publish my BibTeX bibliography on my blog
  In order to share my awesome references with my peers

  @converters
	Scenario: Simple Bibliography
	  Given I have a scholar configuration with:
		  | key   | value |
		  | style | apa   |
		 And I have a page "references.bib":
			"""
			---
			---
			@book{ruby,
			  title     = {The Ruby Programming Language},
			  author    = {Flanagan, David and Matsumoto, Yukihiro},
			  year      = {2008},
			  publisher = {O'Reilly Media}
			}
			"""
	  When I run jekyll
	  Then the _site directory should exist
		And the "_site/references.html" file should exist
	  And I should see "<i>The Ruby Programming Language</i>" in "_site/references.html"

  @converters
	Scenario: Markdown Formatted Bibliography
    Given I have a scholar configuration with:
  	  | key   | value |
  	  | style | apa   |
	  And I have a page "references.bib":
			"""
			---
			---
			References
			==========
			
			@book{ruby,
			  title     = {The Ruby Programming Language},
			  author    = {Flanagan, David and Matsumoto, Yukihiro},
			  year      = {2008},
			  publisher = {O'Reilly Media}
			}
			"""
	  When I run jekyll
	  Then I should see "<h1[^>]*>References</h1>" in "_site/references.html"

  @latex
	Scenario: Simple Bibliography with LaTeX directives
    Given I have a scholar configuration with:
  	  | key   | value |
  	  | style | apa   |
	  And I have a page "references.bib":
			"""
			---
			---
			@misc{umlaut,
			  title     = {Look, an umlaut: \"u!},
			}
			"""
	  When I run jekyll
	  Then the _site directory should exist
		And the "_site/references.html" file should exist
	  And I should see "Look, an umlaut: ü!" in "_site/references.html"

  @tags
	Scenario: Simple Bibliography Loaded From Default Directory
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
			{% bibliography references %}
			"""
	  When I run jekyll
	  Then the _site directory should exist
		And the "_site/scholar.html" file should exist
	  And I should see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"

  @tags @filter
	Scenario: Filtered Bibliography Loaded From Default Directory
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
			{% bibliography references filter: @book[year <= 2000] %}
			"""
	  When I run jekyll
	  Then the _site directory should exist
		And the "_site/scholar.html" file should exist
	  And I should not see "<i>The Ruby Programming Language</i>" in "_site/scholar.html"
	  And I should see "<i>Smalltalk Best Practice Patterns</i>" in "_site/scholar.html"

  @tags @bibliography @prefix
	Scenario: A Prefixed Bibliography
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
			{% bibliography references prefix: a filter: @book[year <= 2000] %}
			"""
	  When I run jekyll
	  Then the _site directory should exist
		And the "_site/scholar.html" file should exist
	  And I should not see "ruby" in "_site/scholar.html"
	  And I should see "id=\"a-smalltalk\"" in "_site/scholar.html"
