MarkLogic Co-Occurrence Typographic Visualization Demo
-------------------------------------------------------


OVERVIEW

This is a deployable version of the typographic co-occurrence demonstration found at http://pairs.demo.marklogic.com.
This demo shows how MarkLogic Server's co-occurrence analytics can be combined with its search capabilities to deliver
an interactive typographic visualization allowing the user to explore the relationship between two types of entities
in the search results.  This package provides all the necessary files to deploy this demo on appropriately marked up
data sets  It also includes the Flash source code for the visualization widget itself, allowing you to adapt the
widget to your needs.


USE

This demo will visualize frequencies of co-occurring values across two selected lexicons within a given search result
set.  To start:

1.  Enter a search term and hit the "search" button.
2.  To view the top co-occurrences of a particular value within the widget, select it in the widget.  The result will
    be a "tree" view of the selected view and the top 10 co-ocurring values within the result set of the query.
3.  To filter the result set by a value:
      - command/control click a value in the widget
      - select a value within one of the facet boxes
4.  To remove a filter:
      - command/control click the filter bar containing the value to be removed on the left side of the widget
      - select "Reset All Facet Selections" to remove all filters.


CONTENTS

This package consists of the following:

- README.txt -- this file
- src -- the Flash IDE project files along with the source, written in ActionScript 3
- app -- the server deployables including all html, javascript and XQuery assets.  This is designed to
  be the virtual root of a MarkLogic HTTP Server.


INSTALLATION AND CONFIGURATION

To install on an internal environment, please follow the following steps:

1.  Copy contents of entire app directory to a modules database or root of an HTTP Server.

2.  Ensure that the appropriate element value lexicons or element-attribute value lexicons have been configured
    for your content.

3.  In index.html, following parameters can be altered on lines 29-31:
       primaryColor:  The color to use for the text of the values; Will default to "0x000000" if not specified.
       secondaryColor:  The color to use for the text of the counts; Will default to "0xA00132" if not specified.
       filtering:  Toggles whether command clicking a value/filter bar can filter or unfilter respectively; Will default to
                   "true" if not specified.
       serverURL:  Specifies which XQuery module will fetch co-occurrence data; will default to "cooc.xqy" if not specified.	
	
4.  In js/main.js, 4 parameters need to be altered:
      - Line 9 var lex1 --> this is the name of the containing element of the first lexicon of the co-occurrence and facet list.  This may need a namespace prefix.
      - Line 13 var lex2 --> this is the name of the containing element of the second lexicon of the co-occurrence and facet list.  This may need a namespace prefix.
      - Line 17 var lex3 --> this is the name of the containing element of the third lexicon in the facet list.  This may need a namespace prefix.
      - Line 21 var lex4 --> this is the name of the containing element of the fourth lexicon in the facet list.  This may need a namespace prefix.
	
    The following parameters can be altered if so desired:
      - Line 5 var url --> the url of the XQuery module that provides search results to the html page
      - Line 32 var n --> the number of results to retrieve from the lexicon.  Please note that the typographic visualization
        widget is limited to displaying a maximum of 10 co-occurrence pairs.
      - Line 45 var defaultQuery --> the text query to run on load or when the widget is reset.  Can be empty to
        return everything.
	
5.  In cooc.xqy and common-search.xqy:  
      - By default, both XQuery modules are designed to work with value lexicons defined by element-attribute-value range
        indexes.  To accomodate different markup:
          - Lines 44, 47, 51, 64 in cooc.xqy must be changed accordingly with the correct element-attribute query or lexicon lookup.
          - Line 37 in common-search.xqy must be changed accordingly with the correct element-attribute query.
          - Other arbitrary queries can be included (such as an xdmp:directory-query) on line 25 of common-search.xqy.
		
6.  In html_search.xqy:
      - By default, this module is designed to work with value lexicon defined by element-attribute-value range indexes.  To accommodate different markup, change line 31 to the correct query or lexicon lookup.
      - Values for displayed search results need to be altered for specific markup including the title of each record
        (line 44), descriptive text (line 45) and the associated lexicon values (lines 47-54).
	
v1.1  October 27, 2008