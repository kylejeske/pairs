/* ----------------------------------------------------------------------
	Copyright 2002-2010 MarkLogic Corporation.  All Rights Reserved.
---------------------------------------------------------------------- */

package com.marklogic.interfaces {
	
	import com.marklogic.interfaces.IDisplayObject
 	
	public interface IListItem extends IDisplayObject {
		
		function fromXML(value:XML):void		
		function set data(value:Object):void		
		function get data():Object
		function set state(value:String):void		
		function set size(value:int):void		
		function show(p_delay:Number):void		
		function hide():void		
		function recalculateWidth():void;	
		function origPosition(p_x:Number,p_y:Number):void;		
		function getPos(p_value:String):Number;			
		function set index(value:Number):void;
		function get index():Number
		
	}
	
}