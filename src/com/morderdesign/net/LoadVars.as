/* ----------------------------------------------------------------------
	Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved.
---------------------------------------------------------------------- */

/**
 * @author		Kyle Jeske
 * @version		1.0.1
 */

/*
Licensed under the MIT License

Copyright (c) 2006-2008 Kyle Jeske

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

http://www.morderdesign.com
*/

package com.morderdesign.net {
	
	
    import flash.net.URLRequest;
    import flash.net.URLVariables;
	import flash.net.URLRequestHeader;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	//import flash.utils.*;
	
	public class LoadVars extends URLLoader {
		
		private var __urlVariables:URLVariables;
		private var __urlRequest:URLRequest;
		
		public function LoadVars(p_request:* = null):void{					
			super(p_request);
			__urlVariables = new URLVariables();			
			__urlRequest = new URLRequest();
		}
		/*
		Gives you the abilit to pass
		url,loadVar CallBack,type:'POST', requestHeader, codePage
		*/
		public function sendAndLoad(p_url:String,p_callBackObj:*,p_type:String="POST"):void {
			if(p_callBackObj == undefined || p_callBackObj == null) { p_callBackObj = this; }
			__urlRequest.url = p_url;
			__urlRequest.method = URLRequestMethod[p_type.toUpperCase()];			
			__urlRequest.data = __urlVariables;
			p_callBackObj.load(__urlRequest);		
		}
		
		public function buildQuery(p_query:Object):void{			
			for(var n:String in p_query){
				__urlVariables[n] = p_query[n];
			}	
		}
		
		public function addParam(p_name:String,p_val:*):void{
			__urlVariables[p_name] = p_val;
		}
		
		public function getParam(p_name:String):*{ 
			return __urlVariables[p_name];
		}
		
		override public function toString():String{			
			var tmp:String = "******************************\n";
			    tmp += "*     LOADVARS AS3 v1.0      \n";	
				tmp += "*     LOADVAR VARIABLES:    \n";
				for(var n in __urlVariables){					
					var wordLength = 20 - n.length;
					tmp += "*        "+n+":"+((String(__urlVariables[n]).length > 60) ? String(__urlVariables[n]).slice(0,60) + '...' : String(__urlVariables[n]));
					for(var w:int=0;w<=wordLength;w++){
						if(w== wordLength){  tmp += "\n"; continue;}
						 tmp += " ";
					}
				}
				tmp += "******************************";
			return tmp;
		}
		
		// PRIVATE METHODS:		
		
	}	
}