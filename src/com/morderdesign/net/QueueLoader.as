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
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.events.NetStatusEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.display.DisplayObjectContainer;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.media.Sound;
	import com.morderdesign.net.LoadRequest;
	import com.morderdesign.net.LoadRequestType;
	import com.morderdesign.events.QueueLoaderEvent;
	import com.morderdesign.controls.Image;
	import flash.events.IOErrorEvent;
	
	public class QueueLoader extends EventDispatcher {
		
		// Constants:
		// Public Properties:
		// Private Properties:
		private var _dataProvider:Array;
		private var loadIndex:Number = 0;
		private var _urlRequest:URLRequest;
		private var _genericLoader:*;
		private var _loaderContext:LoaderContext;
		private var _currentRequest:LoadRequest;
		private var _maxItems:Number;
		private var _queuePercentage:Number;
		private var _ns:NetStream;
		private var _nc:NetConnection;
		private var _baseURL:String = './';
		//
	
		// Initialization:
		public function QueueLoader() {
			_dataProvider = [];
			_urlRequest = new URLRequest();			
			_loaderContext = new LoaderContext();
			_loaderContext.applicationDomain = ApplicationDomain.currentDomain;
		}
		
		public function addItem(p_item:LoadRequest):void {
			_dataProvider.push(p_item);
			_maxItems = _dataProvider.length;
		}
		
		public function set dataProvider(p_value:Array):void {
			_dataProvider = toLoaderArray(p_value);
		}
		public function get dataProvider():Array { return _dataProvider; }
		
		public function load(p_value:*){
			if(p_value is XMLList){ _dataProvider = toLoaderArray(p_value); }
			if(p_value is Array){ _dataProvider = p_value; }
			start();
		}
		
		public function start():void {		
			loadIndex = 0;
			_maxItems = _dataProvider.length;
			loadHelper(loadIndex); 
		}
		
		public function set baseURL(value:String):void { _baseURL = value; }
		
		private function loadHelper(p_index:Number):void {
			if(p_index > _maxItems-1){
				dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.QUEUE_COMPLETE,'','',0,0,1,_queuePercentage))
				return;
			}
			_currentRequest = _dataProvider[p_index];
			var url:String = _currentRequest.url;
			var type:String = _currentRequest.type;
			_urlRequest.url = _baseURL+url;
			switch(type){
				case LoadRequestType.SWF:					
					_genericLoader = new Loader();
					configureListeners(_genericLoader.contentLoaderInfo);
					_genericLoader.load(_urlRequest, _loaderContext);
					if(!_currentRequest.target){ _currentRequest.target = new Sprite(); }					
					_currentRequest.target.addChild(_genericLoader.content);						
					break;
				case LoadRequestType.IMAGE:
					if(!_currentRequest.target){ _currentRequest.target = new Image(); }					
					_genericLoader = new Loader();
					configureListeners(_genericLoader.contentLoaderInfo);
					_genericLoader.load(_urlRequest, _loaderContext);						
					break;
				case LoadRequestType.AUDIO:
					if(!_currentRequest.target) { _currentRequest.target = new Sound(); }
					configureListeners(_currentRequest.target)					
					_currentRequest.target.load(_urlRequest);
					break;
				case LoadRequestType.XML:
				case LoadRequestType.CSS:
					_genericLoader = new URLLoader();
					configureListeners(_genericLoader);
					_genericLoader.load(_urlRequest);						
					break;
				case LoadRequestType.FLV:
					_nc = new NetConnection();
					_nc.connect(null);
					_ns = new NetStream(_nc);
					if(!_currentRequest.target) { _currentRequest.target = new Video(); }
					_currentRequest.target.attachNetStream(_ns);
					_ns.play(url);
					_ns.addEventListener(NetStatusEvent.NET_STATUS, netstat);	
					break;
			}
			dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_START,_currentRequest.type,_currentRequest.title,0,0,0,_queuePercentage,null,_currentRequest))
		}					
		
		protected function netstat(event:NetStatusEvent):void{
			//TODO Track events
			 switch (event.info.code) {
                case "NetStream.Play.Start":
                 	onFileComplete(null);
                    break;
                case "NetStream.Play.StreamNotFound":
                    break;
            }
			
		}		
		
		protected function onFileProgress(p_event:ProgressEvent):void {
			var percent:Number = round((p_event.bytesLoaded / p_event.bytesTotal),.0001);
			_queuePercentage = (((loadIndex * (100 / (_maxItems))) + ((p_event.bytesLoaded / p_event.bytesTotal) * (100 / (_maxItems)))) * .01);
			_queuePercentage = round(_queuePercentage,.001);
			dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_PROGRESS,_currentRequest.type,_currentRequest.title,p_event.bytesTotal,p_event.bytesLoaded,percent,_queuePercentage,null,_currentRequest))
			dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.QUEUE_PROGRESS,_currentRequest.type,_currentRequest.title,p_event.bytesTotal,p_event.bytesLoaded,percent,_queuePercentage,null,_currentRequest))
		}
		
		protected function onFileIOError(p_event:IOErrorEvent):void {
			dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_ERROR,_currentRequest.type,_currentRequest.title))
			loadHelper(++loadIndex);
		}
		
		protected function onFileComplete(p_event:Event):void {			
			var _currTarget:* = _currentRequest.target;
			var data:*;
			var image:Image;
			switch(_currentRequest.type){
				case LoadRequestType.IMAGE:
					if(_currTarget is Image){
						image = (_currTarget as Image);
						image.URL = _currentRequest.url;
						image.drawImage(_genericLoader.content);						
					}else if(_currTarget is Sprite || _currTarget is MovieClip){
						image = new Image();
						image.URL = _currentRequest.url;
						image.drawImage(_genericLoader.content);
						_currTarget.addChild(image);
					}else if(_currTarget is Array){
						var l:Number = _currTarget.length;
						for(var i:int=0;i<l;i++){
							var item:* = _currTarget[i];							
							if(item is Image){
								image = (item as Image);												
							}else if(item is Sprite || item is MovieClip){
								image = new Image();
								item.addChild(image);
							}
							image.URL = _currentRequest.url;
							image.drawImage(_genericLoader.content);									
						}
					}else if(_currTarget is Object){
						var args:Array = _currTarget.args;
						image = new Image();
						image.URL = _currentRequest.url;
						image.drawImage(_genericLoader.content);
						args.push(image.bitmap.clone())
						image.unloadImage();
						_currTarget.func.apply(_currTarget.scope,_currTarget.args);
					}
				break;
				case LoadRequestType.XML:
				case LoadRequestType.CSS:
					data = p_event.target.data;
					break;
				case LoadRequestType.FLV:
					data = _ns;
					break;
				case LoadRequestType.AUDIO:
					break;
			}
			dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.ITEM_COMPLETE,_currentRequest.type,_currentRequest.title,0,0,1,_queuePercentage,data,_currentRequest))
			
			if(loadIndex != _dataProvider.length-1){
				loadHelper(++loadIndex);
			}else{
				dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.QUEUE_COMPLETE,null,'',0,0,1,_queuePercentage))
			}
			
		}
		
		protected function configureListeners(p_dispatcher:IEventDispatcher):void {
			p_dispatcher.addEventListener(ProgressEvent.PROGRESS,onFileProgress,false,0,true);
			p_dispatcher.addEventListener(IOErrorEvent.IO_ERROR,onFileIOError,false,0,true);
			p_dispatcher.addEventListener(Event.COMPLETE,onFileComplete,false,0,true);
		}
		
		private function toLoaderArray(p_value:*):Array {
			var arr:Array = new Array();
			var url:String;
			var type:String;
			var title:String;
			var obj:Object
			var target:*;
			switch(getQualifiedClassName(p_value)){
				case 'XMLList':
					for each(var xml:XML in p_value){
						obj = {}
						url = xml.@url;
						title = xml.@title;
						var attributes:XMLList = xml.attributes()
						for each(var attribute:XML in attributes){ obj[attribute.name().toString()] = attribute }						
						type = (xml.hasOwnProperty('type')) ? xml.@type : findItemType(url);						
						var request:LoadRequest = new LoadRequest(url,type,title,null,obj);
						arr.push(request);
					}
					break;
				case 'Array':
					var l:Number = p_value.length; 
					for(var i:Number=0;i<l;i++){
						obj = {}
						var item:* = p_value[i];
						if(item is LoadRequest){
							arr.push(item);
						}else{
							url = item.url;
							for(var n:String in item){ obj[n] = item[n]; }
							title = item.title;
							type = (item.type) ? item.type : findItemType(url);
							target = item.target;
							arr.push(new LoadRequest(url,type,title,target,obj));
						}
					}
					break;
			}			
			return arr;
		}
		
		private function findItemType(url:String):String {
			if(url.match(".jpg") != null) return LoadRequestType.IMAGE;
			if(url.match(".gif") != null) return LoadRequestType.IMAGE;
			if(url.match(".png") != null) return LoadRequestType.IMAGE;
			if(url.match(".swf") != null) return LoadRequestType.SWF;
			if(url.match(".mp3") != null) return LoadRequestType.AUDIO;
			if(url.match(".mp4") != null) return LoadRequestType.AUDIO;
			if(url.match(".xml") != null) return LoadRequestType.XML;
			if(url.match(".flv") != null) return LoadRequestType.FLV;
			return url;
		}
		
		
		private function round(nNumber:Number, decimal:Number = 1):Number {
			return (new int(nNumber / decimal)) * decimal;
		}
	
		// Public Methods:
		// Protected Methods:
	}
	
}