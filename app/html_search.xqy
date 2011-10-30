xquery version "0.9-ml"
(: Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved. :)
(:~ 
:  Main module called by AJAX within js/main.js.  Only changes that are required the XPaths within the <result> element to extract the content from the markup.
:
: @author MarkLogic Corporation (CS)
: @version 1.0
:)

import module namespace search = "common-search" at "common-search.xqy"

declare namespace dc = "http://purl.org/dc/elements/1.1/"

let $query := search:build-query(xdmp:get-request-field("q"), xdmp:get-request-field("constraint"))
let $shim := xdmp:log(fn:concat("Page query: ", $query))
let $start := xs:integer(xdmp:get-request-field("s"))
let $end := xs:integer(xdmp:get-request-field("n")) - $start + 1
let $search := cts:search(fn:input()/doc, $query)[$start to $end]
return
<search>
	{
	if (xdmp:get-request-field("facet")) then
		<facets>
		{
			for $facet in fn:tokenize(xdmp:get-request-field("facet"), ",")
			return
			<facet name="{$facet}">
			{
				for $facet-values in cts:element-attribute-values(xs:QName($facet), xs:QName("canonical"), (), ("frequency-order"), $query)[1 to 10]
				return <value freq={search:add-commas(cts:frequency($facet-values))}>{$facet-values}</value>
				
			}
			</facet>
		}
		</facets>
	else ()
	}
	<results estimate="{search:add-commas(xdmp:estimate(cts:search(fn:input()/doc, $query)))}">
	{
		for $i in $search
		return <result>
					<title>{$i/dc:title//text()}</title>
					<text>{fn:string-join($i/text//text(), "")}</text>
					{
						for $entities in ("treatment", "diagnostic-method", "disease", "symptom")
						return 
						if ($i/(text|dc:title)/child::*[fn:local-name(.) = $entities]) then
							element {$entities} 
							{
								text {fn:string-join(fn:distinct-values($i/(text|dc:title)/child::*[fn:local-name(.) = $entities]/@canonical), ", ")}
							}
						else ()
					}
				</result>
	}
	</results>
</search>