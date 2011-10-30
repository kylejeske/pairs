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

package com.morderdesign.utils{

	import flash.utils.getQualifiedClassName;
	public class Utilities {

		public static  function cloneObject(p_data:*):* {
			var n:String;
			var i:Number;
			var l:Number;
			var obj:Object = {}
			var arr:Array=[];
			var item:*;
			var newObj:*;
			switch(getQualifiedClassName(p_data)) {
				case "Object":
					for (n in p_data) {
						var prop:* = p_data[n];
						switch (getQualifiedClassName(p_data[n])) {
							case "Object" :
								obj[n]=cloneObject(p_data[n]);
								break;
							case 'Array' :
								l=prop.length;
								for (i=0; i < l; i++) {
									item=prop[i];
									newObj=cloneObject(item);
									arr.push(newObj);
								}
								obj[n] = arr;
								break;
							default :
								obj[n]=prop;
								break;
						}
					}					
					return obj;
				case "com.twixr.controls.photostyles::SimplePhoto":
					return; // dont return a clone of this..
					break
					
				case "Array":
					arr = new Array(); 
					l = p_data.length;
					for (i=0; i < l; i++) {
						item=p_data[i];
						newObj=cloneObject(item);
						arr.push(newObj);
					}
					return arr.slice();
			}
		}
	}
}