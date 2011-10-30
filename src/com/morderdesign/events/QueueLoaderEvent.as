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
	import com.morderdesign.net.LoadRequest;
	
	public class QueueLoaderEvent extends Event {
		
		// Constants:
		public static const ITEM_START : String = "itemStart";
		public static const ITEM_PROGRESS : String = "itemProgress";
		public static const ITEM_COMPLETE : String = "itemComplete";
		public static const ITEM_ERROR : String = "itemError";
		public static const QUEUE_START : String = "queueStart";
		public static const QUEUE_PROGRESS : String = "queueProgress";
		public static const QUEUE_COMPLETE : String = "queueComplete";
		// Public Properties:
		// Private Properties:
		private var _type:String;
		private var _bytesTotal:Number;
		private var _bytesLoaded:Number;
		private var _percent:Number;
		private var _fileFormat:String;
		private var _queuePercent:Number;
		private var _data:*;
		private var _request:LoadRequest;
		private var _title:String;
	
		// Initialization:
		public function QueueLoaderEvent(p_type:String,p_fileFormat:String='',p_title:String='',p_bytesTotal:Number=-1,p_bytesLoaded:Number=-1,p_percent:Number=0,p_queuePercent:Number=-1,p_data:*=null,p_request:LoadRequest=null,p_bubbles:Boolean=false,p_cancelable:Boolean=true) {
			_type = p_type;
			_fileFormat = p_fileFormat;
			_bytesTotal = p_bytesTotal;
			_bytesLoaded = p_bytesLoaded;
			_percent = p_percent;
			_queuePercent = p_queuePercent;
			_data = p_data;
			_request = p_request;
			_title = p_title;
			super(_type,p_bubbles,p_cancelable);
		}
	
		// Public Methods:
		override public function get type():String { return _type; }
		public function get fileFormat():String { return _fileFormat; }
		public function get title():String { return _title; }
		public function get bytesTotal():Number { return _bytesTotal; }
		public function get bytesLoaded():Number { return _bytesLoaded; }
		public function get percent():Number { return _percent; }
		public function get queuePercent():Number { return _queuePercent; }
		public function get data():* { return _data; }
		public function get request():LoadRequest {return _request; }
		// Protected Methods:
	}
	
}