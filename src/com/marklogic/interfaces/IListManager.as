/* ----------------------------------------------------------------------
	Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved.
---------------------------------------------------------------------- */

package com.marklogic.interfaces {
	
	import com.marklogic.interfaces.IDisplayObject
	import com.marklogic.controls.FilterBox;
	import flash.display.Sprite;
	
	public interface IListManager extends IDisplayObject{
		
		function addDataSet(value:XML, p_mode:String,p_item:Sprite,p_filterBox:FilterBox):void;
		function gotoDataSet(value:int):void;		
		function get currentIndex():Number;
		function clear():void;		
		function draw():void;		
		function getFilterData(p_index:Number):Object;		
		function invalidate():void;
		
	}
	
}