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
	
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	
	public class LoadRequest extends EventDispatcher{
		
		// Constants:
		// Public Properties:
		// Private Properties:
		private var _url:String;
		private var _type:String;
		private var _title:String;
		private var _target:*;
		private var _obj:Object;
	
		// Initialization:
		public function LoadRequest(p_url:String,p_type:String,p_title:String='',p_target:*=null,p_obj:Object=null) {
			_url = p_url;
			_type = p_type;
			_target = p_target;
			_title = p_title;
			_obj = p_obj;
		}
	
		// Public Methods:
		
		public function get url():String { return _url; }		
		public function get type():String { return _type; }		
		public function get title():String { return _title; }		
		public function get params():Object { return _obj; }
		public function set params(p_obj:Object):void { _obj = p_obj; }
		public function get target():* { return _target; }
		public function set target(value:*):void { _target = value; }
		
		
		override public function toString():String {
			return "[LoadRequest url='"+_url+"' type='"+_type+"' title='"+_title+"' target='"+_target+"']";
		}
		
		// Protected Methods:
	}
	
}