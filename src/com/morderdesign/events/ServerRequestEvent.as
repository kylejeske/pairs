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

package com.morderdesign.events { 
	
	import flash.events.Event;
	import flash.xml.XMLNode;

	public class ServerRequestEvent extends Event {
		
		// Constants:
		// Public Properties:
		public static const COMPLETE:String = 'onComplete';
		public static const ERROR:String = 'onError';
		// Private Properties:
		public var source:String;
		public var method:String;
	
		// Initialization:
		public function ServerRequestEvent(p_type:String,p_data:String=null,p_method:String=null) {
			super(p_type);
			source = p_data;		
			method = p_method;
		}
		
		override public function toString():String{
			// RM: took out value and triggerEvent... was giving me errors..
			return formatToString('ServerEvent','type','bubbles','cancelable')	
		}
		
		override public function clone():Event{
			return new ServerRequestEvent(type,source, method);
		}
	
		// Public Methods:
		// Semi-Private Methods:
		// Private Methods:
	}
}