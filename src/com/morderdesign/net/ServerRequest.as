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

package com.morderdesign.net{
	
	import flash.xml.XMLNode;
	import com.morderdesign.events.ServerRequestEvent	
	import flash.events.EventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;

	public class ServerRequest extends EventDispatcher{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		private var _params:Object;
		private var _method:String;
		private var _data:String;		
		// Initialization:
		public function ServerRequest(p_method:String='',p_params:Object = null) {
			_params = {};			
			_method = p_method
			// setup params object.
			for(var n in p_params){	_params[n] = p_params[n]; }			
		}
		
		public function handleError(p_name:String,p_event:*):void {
			switch(p_name){
				case 'IOError':	
				case 'SecurityError':
					dispatchEvent(new ServerRequestEvent(ServerRequestEvent.ERROR));
					break;
			}
		}
	
		// Public Methods:
		public function clearParams():void { _params = {}; }
		
		// set/get params;
		public function set params(p_params:Object):void{	for(var n in p_params){	_params[n] = p_params[n]; }	}		
		public function get params():Object{ return _params; }
		
		public function addParam(p_name:String,value:*):void {
			_params[p_name] = value;
		}
		
		public function removeParam(p_name:String):void {
			delete _params[p_name];
		}
		
		// set/get method name;
		public function get method():String{ return _method; }
		public function set method(p_method:String):void { _method = p_method; }
		
		public function get data():XML{ return new XML(_data); }
		
		// object or xml string??
		public function setData(p_data:String):void{
			_data = p_data;
			dispatchEvent(new ServerRequestEvent(ServerRequestEvent.COMPLETE,_data,_method));	
		}
		
		// Semi-Private Methods:
		// Private Methods:
	}
}