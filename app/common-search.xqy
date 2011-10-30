xquery version "0.9-ml"
(: Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved. :)
(:~ 
: Main library module for all cts:query operations for co-occurrence visualization widgets.  This is based on element-attribute range indices.  Should the content require the use of element-value range indicies, element word lexicons, or attribute word lexicons, this module would have to be adjusted accordingly.
:
: @author MarkLogic Corporation (CS)
: @version 1.1
:)

module "common-search"

(:~ 
: Function that builds the free-text query, optionally constrained by a filter/facet.
:
: @param $query-string The free text to search for in the database.
: @param $filters (Optional) Lexicon name and values in which to limit results by.  This takes the form of lex:value;lex:value;lex:value
: @return cts:query
:)
define function build-query($query-string as xs:string, $filters as xs:string*) as cts:query
{
		cts:and-query((
			(: Place any other arbitrary query types here.  Both the widget and the HTML page will have their search queries funneled to this function :)
			cts:directory-query("/", "infinity"),
				
			(: This is the free text portion of the query.  If a more sophisticated heuristic is required, it should be replaced here. :)
			if ($query-string != "") then cts:word-query($query-string, ("case-insensitive", "punctuation-insensitive")) else (),
			
			(: This is for widget-defined filters and facets. :)
			for $filter-tokens in fn:tokenize($filters, ";")
			return
				let $filter-name := fn:substring-before($filter-tokens, ":")
				let $values := fn:substring-after($filter-tokens, ":")
				for $value in fn:tokenize($values, ",")
				(: Designed for attribute values in the form of <lex1 canonical="VALUE" />.  Change accordingly for content. :)
				return cts:element-attribute-value-query(xs:QName($filter-name), xs:QName("canonical"), $value)
		))		
}

(:~ 
: Utility function to add comma separations to numbers.  e.g.  1000 -> 1,000
:
: @param $num An integer to be commafied
: @return A string representing a commafied version of the inputed number.
:)
define function add-commas($num as xs:integer)
{
	 fn:string-join(
		 fn:reverse(
			 for $i at $x in fn:reverse(for $i in fn:string-to-codepoints(xs:string($num)) return fn:codepoints-to-string($i))
			 return
			 if ($x > 1 and ($x - 1) mod 3 = 0) then 
			 	fn:concat($i, ",") 
			 else $i
		 )
	 , "")
}