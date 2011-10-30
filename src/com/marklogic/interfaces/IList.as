/* ----------------------------------------------------------------------
	Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved.
---------------------------------------------------------------------- */

package com.marklogic.interfaces {

	import com.marklogic.interfaces.IDisplayObject
	import com.marklogic.interfaces.IListItem;
	
	public interface IList extends IDisplayObject{
		
		function removeItems():void;		
		function addFilter(value:*):void;		
		function clearFilter():void;		
		function set renderer(value:Class):void;		
		function set dataProvider(value:XMLList):void;		
		function showItems():void;		
		function set index(value:int):void;		
		function set mode(value:String):void;		
		function set label(value:String):void;		
		function get label():String;
		function recalculateWidth():void;
		function hideItems(p_tween:Boolean=true):void;
		function set searchLabel(value:String):void;
		function showSelectedState():void;
		function findSearchItem():IListItem;
		
	}
	
}