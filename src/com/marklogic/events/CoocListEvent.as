/* ----------------------------------------------------------------------
	Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved.
---------------------------------------------------------------------- */

package com.marklogic.events {
	
	import flash.events.Event
	
	public class CoocListEvent extends Event{
		
		// Constants:
		public static const ITEM_CLICK:String = 'itemClick';
		public static const BACK:String = 'backClick';
		public static const FILTER_CLICK:String = 'filterClick';
		// Public Properties:
		// Private Properties:
		protected var _data:Object;
		protected var _ctrl:Boolean = false;
	
		// Initialization:
		public function CoocListEvent(p_type:String,p_data:Object,p_bubbles:Boolean=true,p_ctrl:Boolean = false) {
			
			super(p_type,p_bubbles,true);
			
			_data = p_data;
			_ctrl = p_ctrl;
			
		}
		
		// Public Methods:
		
		public function get data():Object { 
			return _data;
		}
		public function get ctrl():Boolean {
			return _ctrl;
		}
		
		override public function clone():Event {
			return new CoocListEvent(type,_data,bubbles,_ctrl);
		}
		
		override public function toString():String {
			return "[CoocListEvent type='"+type+"' _data='"+_data+"']";
		}
		
		// Protected Methods:
	}
	
}