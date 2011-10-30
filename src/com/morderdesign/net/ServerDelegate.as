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
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.utils.ByteArray;
	import com.morderdesign.net.LoadVars;
	import com.marklogic.core.Preferences;

	public class ServerDelegate extends EventDispatcher {
		
		// Constants:
		protected static const SERVICE_URL:String = 'Application.php?action=%%METHOD%%';// <-- uncomment for local testing
		public static var APPLICATION_URL:String = './';
		// REQUEST;
		
		// Public Properties:
		// Private Properties:
		protected static var _instance:ServerDelegate;
		protected var requestQueue:Array;
		protected var _currentRequest:ServerRequest
		// Initialization:
		public function ServerDelegate() { requestQueue = []; }
		
		public static function getInstance():ServerDelegate{
			if(_instance == null){ _instance = new ServerDelegate(); }
			return _instance;		
		}
		
		public static function addRequest(p_request:ServerRequest):void{
			// build in priority settings for queue;
			getInstance().iSendRequest(p_request);
		}		
		
		public static function urlHelper(p_request:ServerRequest):String {
			return getInstance().iURLHelper(p_request);
		}
		
		public static function set applicationURL(value:String):void {
			APPLICATION_URL = value;
		}
	
		// Public Methods:
		// Semi-Private Methods:
		// Private Methods:
		
		private function iSendRequest(p_request:ServerRequest):void{
			requestQueue.push({request:p_request});
			if(requestQueue.length == 1){
				iRequestHelper(p_request);	
			}
		}
		
		private function iURLHelper(p_request:ServerRequest):String {
			var request:ServerRequest = p_request;
			var url:String = APPLICATION_URL;
			// comment for real application;
			/**/
			if(Preferences.serverURL.indexOf('morderdesign') != -1) {
				trace("DEBUG");
				switch(request.method){						
					default:
						url += SERVICE_URL.split('%%METHOD%%').join(request.method);
						break;
				}
				return url; // ---------
			}/**/
			return url;
		}
		
		private function iRequestHelper(p_request:ServerRequest):void{
			_currentRequest = p_request;
			var lv:LoadVars = new LoadVars();
			for(var n in p_request.params){	lv.addParam(n,_currentRequest.params[n]); }
			lv.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0 , true);
			lv.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0 , true);
			lv.addEventListener(Event.COMPLETE, onComplete, false, 0 , true);
			// check the method type
			var url:String = iURLHelper(_currentRequest);
			lv.sendAndLoad(url,lv,"POST");
			//trace(lv)
		}
		
		//EVENTS:
		private function onIOError(p_event:IOErrorEvent):void{
			_currentRequest.handleError('IOError',p_event);
			iNextRequest();
		}
		
		private function onSecurityError(p_event:SecurityErrorEvent):void{
			_currentRequest.handleError('SecurityError',p_event);
			iNextRequest();			
		}
		
		private function onComplete(p_event:Event):void{
			_currentRequest.setData(p_event.target.data);
			iNextRequest();	
		}
		
		private function iNextRequest():void{
			requestQueue.shift();
			if(requestQueue.length > 0){
				iRequestHelper(requestQueue[0].request);
			}
		}
		
	}
}