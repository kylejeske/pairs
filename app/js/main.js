// Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved.

// The relative URL (to ajaxCooc.html) that executes the free text search and provides results
// to HTML page
var url = "html_search.xqy"

// Name of the first lexicon to run co-occurences and first in facet list.  Must include prefix if one is required
// in cooc.xqy.
var lex1 = "disease"

// Name of the second lexicon to run co-occurences and second in facet list.  Must include prefix if one is required
// in cooc.xqy.
var lex2 = "treatment"

// Name of the third lexicon in facet list.  Must include prefix if one is required
// in cooc.xqy.
var lex3 = "diagnostic-method"

// Name of the fourth lexicon in facet list.  Must include prefix if one is required
// in cooc.xqy.
var lex4 = "symptom"


//The querystring starting number.
var qs_s = 1

//the querystring number to return to the AJAX results.
var qs_n = 20


// The number of top co-occurrences to return.  Typographic widget can hold a maxmimum of 10.
var n = 10

var qString = location.search;
var qValue = qString.substring(qString.indexOf("q=") + 2, qString.length);


// The default query when the page is loaded or when the page is reset.  Can be empty.
var defaultQuery;

if (qValue != "") {
	defaultQuery = unescape(qValue).replace(/\+/g, " ") ;
}
else {
	defaultQuery = ""
}

window.onload = initAll;
window.onunload = function(){};

var selectedFacetSet = new Array()
var xhr=null;
var facetSetLex1 = new Array()
var facetSetLex2 = new Array()
var facetSetLex3 = new Array()
var facetSetLex4 = new Array()

var sStr = ""
var sFacets = ""
var s = 1
var lex1facetSet;
var lex2facetSet;

var ieversion;

if (/MSIE (\d+\.\d+);/.test(navigator.userAgent)){
	ieversion = new Number(RegExp.$1)
}
else {
	ieversion = 0;
}

function initAll(){
	document.getElementById("search").onclick = getNewPost;
	document.getElementById("resetFacets").onclick = resetFacets;
    //setup to handle keypress events
    elem = document.getElementById("searchKeyword")

    // assign event handlers for modern DOM browsers
    if (elem) {
        elem.onkeypress = handleEnterKeyPress
    }

    switch(lex1){
		case lex1:
			lex1facetSet = facetSetLex1
			break;
		case lex2:
			lex1facetSet = facetSetLex2
			break;
		case lex3:
			lex1facetSet = facetSetLex3
			break;
		case lex4:
			lex1facetSet = facetSetLex4
			break;
	}
	switch(lex2){
		case lex1:
			lex2facetSet = facetSetLex1
			break;
		case lex2:
			lex2facetSet = facetSetLex2
			break;
		case lex3:
			lex2facetSet = facetSetLex3
			break;
		case lex4:
			lex2facetSet = facetSetLex4
			break;
	}
    
}

function getNewPost(){
	sFacets = ""
	var mySearch = document.getElementById("searchKeyword");
	if (mySearch.value != "") {
		sQuery = mySearch.value
	}
	else {
		mySearch.value = defaultQuery;
		sQuery = defaultQuery;
	}
	sStr = mySearch.name + "=" + mySearch.value
	setTimeout("thisMovie('Cooc').newSearch('" + sQuery + "', '" + lex1 + "', '" + lex2 + "', " + n + ", " + s +")", 0)
	makeRequest(url, sStr, sFacets)

	return false;
}

function widgetLoaded() {
	getNewPost();
}

function makeRequest(url, sStr, sFacets){
	var urlSearch = url + "?" + sStr + "&s="+ qs_s +"&n="+ qs_n + "&facet="+lex1+","+lex2+","+lex3+","+lex4;

	if (sFacets != "") {
	   urlSearch += "&constraint=" + sFacets
	}


	if(window.XMLHttpRequest){
		xhr = new XMLHttpRequest();
	}else{
		if(window.ActiveXObject){
			try{
				xhr = new ActiveXObject("Microsoft.XMLHTTP");
			}
			catch(e){}
		}
	}
	if(xhr){
		xhr.onreadystatechange = showContents;
		xhr.open("GET", urlSearch, true);
		xhr.send(null);
	}else{
		document.getElementsById("updateArea").innerHTML = "Sorry, but I couldn't create an XMLHttprequest";
	}
}
function showContents(){
	var outMsg = "loading..." + xhr.readyState;
	if(xhr.readyState == 4){
		if(xhr.status == 200){
			makeFacetsLists()
			makeDetailList()
			}else{
			var outMsg = "there was a problem with the request " + xhr.status;
			document.getElementById("updateArea").innerHTML = outMsg;
		}
	}
}
function makeFacetsLists(){

	if (ieversion >= 6) {
		makeFacetListsIE();
	}

	else {
		makeFacetListsEverythingElse();
	}
}

var getChildElements = function(node)
{
    var a = [];
    var tags = node.getElementsByTagName("*");
    
    for (var i = 0; i < tags.length; ++i)
    {
        if (node == tags[i].parentNode)
        {
            a.push(tags[i]);
        }
    }
    return a;
} 

function makeFacetListsIE() {
	var facetSet = xhr.responseXML.getElementsByTagName("facet")
	var pxW = 734/parseInt(facetSet.length);
	var gapPx = 10/parseInt(facetSet.length-1);
	var myFacetDiv = "";
	for(i=0;i<facetSet.length;i++){
		var mySet = "";
		myFacetDiv += "<div class=facet style='width:"+pxW+"px;"
		if(i<facetSet.length-1){
			myFacetDiv += "margin-right:" + gapPx + "px;"
		}else{
			myFacetDiv +=""
		}
		myFacetDiv += "'>"
		myFacetDiv += "<div class=label><strong>";
		myFacetDiv += facetSet[i].attributes.getNamedItem("name").value +"<br /></strong></div>";
		myFacetDiv += "<div class=list>";
		var childElements = getChildElements(facetSet[i]);
		for(j=0;j<childElements.length;j++){
			if(childElements[j].nodeName == "value"){
				mySet += "<div class='listItem'"
				mySet += "style='width:100%;"
				if(j%2==1){
					mySet += "background-color:#FFFFFF;"
				}else{
					mySet += "background-color:#c6dde6"
				}

				mySet += "'><table width=90% border=0 cellspacing=0 cellpadding=0 class='facetItemTable'><tr><td><a name='facetItem' style='"
				switch (facetSet[i].attributes.getNamedItem("name").value){
					case lex1:
						for(k=0;k<facetSetLex1.length;k++){
							if(childElements[j].text == facetSetLex1[k]){
								mySet+="color:#000000;font-weight:bold"
							}
						}
					break;
					case lex2:
						for(k=0;k<facetSetLex2.length;k++){
							if(childElements[j].text == facetSetLex2[k]){
								mySet+="color:#000000;font-weight:bold"
							}
						}
					break;
					case lex3:
						for(k=0;k<facetSetLex3.length;k++){
							if(childElements[j].text == facetSetLex3[k]){
								mySet+="color:#000000;font-weight:bold"
							}
						}
					break;
					case lex4:
						for(k=0;k<facetSetLex4.length;k++){
							if(childElements[j].text == facetSetLex4[k]){
								mySet+="color:#000000;font-weight:bold"
							}
						}
					break;
				}
				mySet+= "' href='#' id='" + facetSet[i].attributes.getNamedItem("name").value+ ":" + childElements[j].text +"'>" + childElements[j].text + "</a></td><td align='right'>" + childElements[j].attributes.getNamedItem("freq").value + "</td></tr></table></div>";
			}
		}
		myFacetDiv += mySet
		myFacetDiv += "</div></div>"
	}
	document.getElementById("facetArea").innerHTML = myFacetDiv;
	var elementsArray = document.getElementsByName("facetItem")
	for(var n=0;n<elementsArray.length;n++){
		elementsArray[n].onclick = selectFacet;
	}
}

function makeFacetListsEverythingElse() {
	var facetSet = xhr.responseXML.getElementsByTagName("facet")
	var pxW = 734/parseInt(facetSet.length);
	var gapPx = 10/parseInt(facetSet.length-1);
	var myFacetDiv = "";
	for(i=0;i<facetSet.length;i++){
		var mySet = "";
		myFacetDiv += "<div class=facet style='width:"+pxW+"px;"
		if(i<facetSet.length-1){
			myFacetDiv += "margin-right:" + gapPx + "px;"
		}else{
			myFacetDiv +=""
		}
		myFacetDiv += "'>"
		myFacetDiv += "<div class=label><strong>";
		myFacetDiv += facetSet[i].attributes.getNamedItem("name").value +"<br /></strong></div>";
		myFacetDiv += "<div class=list>";
		var childElements = getChildElements(facetSet[i]);
		for(j=0;j<childElements.length;j++){
			if(childElements[j].nodeName == "value"){
				mySet += "<div class='listItem'"
				mySet += "style='width:97.5%;"
				if(j%2==1){
					mySet += "background-color:#FFFFFF;"
				}else{
					mySet += "background-color:#c6dde6"
				}

				mySet += "'><table width=100% border=0 cellspacing=0 cellpadding=0 class='facetItemTable'><tr><td><a name='facetItem' style='"
				switch (facetSet[i].attributes.getNamedItem("name").value){
					case lex1:
						for(k=0;k<facetSetLex1.length;k++){
							if(childElements[j].textContent == facetSetLex1[k]){
								mySet+="color:#000000;font-weight:bold"
							}
						}
					break;
					case lex2:
						for(k=0;k<facetSetLex2.length;k++){
							if(childElements[j].textContent == facetSetLex2[k]){
								mySet+="color:#000000;font-weight:bold"
							}
						}
					break;
					case lex3:
						for(k=0;k<facetSetLex3.length;k++){
							if(childElements[j].textContent == facetSetLex3[k]){
								mySet+="color:#000000;font-weight:bold"
							}
						}
					break;
					case lex4:
						for(k=0;k<facetSetLex4.length;k++){
							if(childElements[j].textContent == facetSetLex4[k]){
								mySet+="color:#000000;font-weight:bold"
							}
						}
					break;
				}
				mySet+= "' href='#' id='" + facetSet[i].attributes.getNamedItem("name").value+ ":" + childElements[j].textContent +"'>" + childElements[j].textContent + "</a></td><td align='right'>" + childElements[j].attributes.getNamedItem("freq").value + "</td></tr></table></div>";
			}
		}
		myFacetDiv += mySet
		myFacetDiv += "</div></div>"
	}
	document.getElementById("facetArea").innerHTML = myFacetDiv;
	var elementsArray = document.getElementsByName("facetItem")
	for(var n=0;n<elementsArray.length;n++){
		elementsArray[n].onclick = selectFacet;
	}
}

function makeDetailList(){

	if (ieversion >= 6) {
		makeDetailListIE();
	}
	else {
		makeDetailListEverythingElse();
	}
}

function makeDetailListIE() {
	var myResults = xhr.responseXML.getElementsByTagName("result")
	var outLabel = null
	outLabel = "<div id=resultsLabel>Results (" + xhr.responseXML.getElementsByTagName("results")[0].attributes.getNamedItem("estimate").value + ") </div>"
	var outMsg = null
	outMsg = "<div id=resultsList><table cellspacing='10' cellpadding='10' align='center' width='100%'>"


	for(i=0;i<myResults.length;i++){
		var childElements = getChildElements(myResults[i]);
		outMsg += "<td bgcolor='#c6dde6'><b>" + childElements[0].text + "</b><br />"
		outMsg +=  childElements[1].text.substr(0, 250) + "... <br />"


		var lex1Set = new Array()
		var lex2Set = new Array()
		var lex3Set = new Array()
		var lex4Set = new Array()
		for(j=0;j<childElements.length;j++){
			switch (childElements[j].nodeName){
				case lex1:
					lex1Set.push(childElements[j].text)
					break;
				case lex2:
					lex2Set.push(childElements[j].text)
					break;
				case lex3:
					lex3Set.push(childElements[j].text)
					break;
				case lex4:
					lex4Set.push(childElements[j].text)
					break;
				default:
					break;

			}
		}
		if(lex1Set.length>0){
			outMsg+= "<span class='sourceFacets'>"+toTitleCase(lex1)+": "
			for (y=0;y<lex1Set.length;y++){
				if(y<lex1Set.length-1){
					outMsg += lex1Set[y] + ", "
				}else{
					outMsg += lex1Set[y] + "</span><br />"
				}
			}
		}
		if(lex2Set.length>0){
			outMsg+= "<span class='sourceFacets'>"+toTitleCase(lex2)+": "
			for (y=0;y<lex2Set.length;y++){
				if(y<lex2Set.length-1){
					outMsg += lex2Set[y] + ", "
				}else{
					outMsg += lex2Set[y] + "</span><br />"
				}
			}
		}
		if(lex3Set.length>0){
			outMsg+= "<span class='sourceFacets'>" + toTitleCase(lex3) +": "
			for (y=0;y<lex3Set.length;y++){
				if(y<lex3Set.length-1){
					outMsg += lex3Set[y] + ", "
				}else{
					outMsg += lex3Set[y] + "</span><br />"
				}
			}
		}
		if(lex4Set.length>0){
			outMsg += "<span class='sourceFacets'>"+ toTitleCase(lex4) +": "
			for (y=0;y<lex4Set.length;y++){
				if(y<lex4Set.length-1){
					outMsg += lex4Set[y] + ", "
				}else{
					outMsg += lex4Set[y] + "</span>"
				}
			}
		}

		outMsg += "</td></tr>"
	}
	outMsg += "</table></div>";
	document.getElementById("updateArea").innerHTML = outLabel + outMsg;
}


function makeDetailListEverythingElse() {
	var myResults = xhr.responseXML.getElementsByTagName("result")
	var outLabel = null
	outLabel = "<div id=resultsLabel>Results (" + xhr.responseXML.getElementsByTagName("results")[0].attributes.getNamedItem("estimate").value + ") </div>"
	var outMsg = null
	outMsg = "<div id=resultsList><table cellspacing='10' cellpadding='10' align='center' width='100%'>"


	for(i=0;i<myResults.length;i++){
		var childElements = getChildElements(myResults[i]);
		outMsg += "<td bgcolor='#c6dde6'><b>" + childElements[0].textContent + "</b></span><br />"
		outMsg +=  childElements[1].textContent.substr(0, 250) + "... <br />"


		var lex1Set = new Array()
		var lex2Set = new Array()
		var lex3Set = new Array()
		var lex4Set = new Array()
		for(j=0;j<childElements.length;j++){
			switch (childElements[j].nodeName){
				case lex1:
					lex1Set.push(childElements[j].textContent)
					break;
				case lex2:
					lex2Set.push(childElements[j].textContent)
					break;
				case lex3:
					lex3Set.push(childElements[j].textContent)
					break;
				case lex4:
					lex4Set.push(childElements[j].textContent)
					break;
				default:
					break;

			}
		}
		if(lex1Set.length>0){
			outMsg+= "<span class='sourceFacets'>"+toTitleCase(lex1)+": "
			for (y=0;y<lex1Set.length;y++){
				if(y<lex1Set.length-1){
					outMsg += lex1Set[y] + ", "
				}else{
					outMsg += lex1Set[y] + "</span><br />"
				}
			}
		}
		if(lex2Set.length>0){
			outMsg+= "<span class='sourceFacets'>"+toTitleCase(lex2)+": "
			for (y=0;y<lex2Set.length;y++){
				if(y<lex2Set.length-1){
					outMsg += lex2Set[y] + ", "
				}else{
					outMsg += lex2Set[y] + "</span><br />"
				}
			}
		}
		if(lex3Set.length>0){
			outMsg+= "<span class='sourceFacets'>" + toTitleCase(lex3) +": "
			for (y=0;y<lex3Set.length;y++){
				if(y<lex3Set.length-1){
					outMsg += lex3Set[y] + ", "
				}else{
					outMsg += lex3Set[y] + "</span><br />"
				}
			}
		}
		if(lex4Set.length>0){
			outMsg += "<span class='sourceFacets'>"+ toTitleCase(lex4) +": "
			for (y=0;y<lex4Set.length;y++){
				if(y<lex4Set.length-1){
					outMsg += lex4Set[y] + ", "
				}else{
					outMsg += lex4Set[y] + "</span>"
				}
			}
		}

		outMsg += "</td></tr>"
	}
	outMsg += "</table></div>";
	document.getElementById("updateArea").innerHTML = outLabel + outMsg;

}

function handleFacet(tmpAry){

	var myFacetAry = tmpAry.split(":")
	sFacets = assignFacet(myFacetAry)
	this.onclick = function(){return false;};
	makeRequest(url,sStr,sFacets.substr(0, sFacets.length-1))
	thisMovie("Cooc").newConstraint(sQuery, lex1, lex2, n, s, sFacets.substr(0, sFacets.length-1), myFacetAry[1])
}

function selectFacet(){
		handleFacet(this.id)
	}

function resetFacets(){
	resetFacetSets()
	getNewPost()
}

function divideString(str){
	var splitArray = str.split(":")
	return splitArray
}


function assignFacet(facetAry){
	switch(facetAry[0]){
		case lex1:
			facetSetLex1.push(facetAry[1])
			break;
		case lex2:
			facetSetLex2.push(facetAry[1])
			break;
		case lex3:
			facetSetLex3.push(facetAry[1])
			break;
		case lex4:
			facetSetLex4.push(facetAry[1])
			break;
		default:
			break;
	}
	return updateFacetString();
}

function updateFacetString() {
	var myFacetSetString = ""
	if(facetSetLex1.length>0){
		myFacetSetString += lex1 + ":"
		for (j=0;j<facetSetLex1.length;j++){
			myFacetSetString += facetSetLex1[j]
			if(j<facetSetLex1.length-1){
				myFacetSetString += ","
			}else{
				myFacetSetString += ";"
			}
		}
	}
	if(facetSetLex2.length>0){
		myFacetSetString += lex2 + ":"
		for (j=0;j<facetSetLex2.length;j++){
			myFacetSetString += facetSetLex2[j]
			if(j<facetSetLex2.length-1){
				myFacetSetString += ","
			}else{
				myFacetSetString += ";"
			}
		}
	}
	if(facetSetLex3.length>0){
		myFacetSetString += lex3+":"
		for (j=0;j<facetSetLex3.length;j++){
			myFacetSetString += facetSetLex3[j]
			if(j<facetSetLex3.length-1){
				myFacetSetString += ","
			}else{
				myFacetSetString += ";"
			}
		}
	}
	if(facetSetLex4.length>0){
		myFacetSetString += lex4+":"

		for(m=0;m<facetSetLex4.length;m++){

			myFacetSetString += facetSetLex4[m]
			if(m<facetSetLex4.length-1){
				myFacetSetString += ","
			}else{
				myFacetSetString += ";"
			}
		}
	}
	return myFacetSetString;
}

function resetFacetSets(){
	facetSetLex1 = []
	facetSetLex2 = []
	facetSetLex3 = []
	facetSetLex4 =[]
	sFacets = ""

}

function doConstraint(lexID, word) {
	var tmpAry = lexID + ":" + word
	handleFacet(tmpAry)
}

function handleEnterKeyPress(evt) {
    evt = (evt) ? evt : ((window.event) ? window.event : "")
    if (evt) {
    	if(evt.keyCode==13){
    		getNewPost()
    	}
    }
}

function removeConstraint(p_obj) {	
	
	if (p_obj.lex1.length != 0 || p_obj.lex2.length != 0) {	
		for (var i=0;i<p_obj.lex1.length;i++){
			lex1facetSet.remove(p_obj.lex1[i])
		}
		
		for (var i=0;i<p_obj.lex2.length;i++){
			lex2facetSet.remove(p_obj.lex2[i])
		}
		sFacets = updateFacetString();

		makeRequest(url,sStr,sFacets.substr(0, sFacets.length-1))
	}
}

Array.prototype.remove=function(s){
	var index = this.indexOf(s);
	if(this.indexOf(s) != -1)this.splice(index, 1);
}

if(!Array.indexOf){
	Array.prototype.indexOf = function(obj){
		for(var i=0; i<this.length; i++){
			if(this[i]==obj){
			 return i;
			}
		}
		return -1;
	}
}

//Title case handler, could probably go into a separate .js file
function toTitleCase(str)
{
	return str.replace(/\w\S+/g, function(txt){return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();});
}
