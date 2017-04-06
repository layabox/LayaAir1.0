///////////////////////////////////////////////////////////
//  LayoutTools.as
//  Macromedia ActionScript Implementation of the Class LayoutTools
//  Created on:      2015-11-9 下午3:26:01
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.display.Sprite;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-11-9 下午3:26:01
	 */
	public class LayoutTools
	{
		public function LayoutTools()
		{
		}
		public static function layoutToXCount(items:Array, xCount:int=1, dx:Number=0, dY:Number=0, sx:Number=0, sy:Number=0):void
		{
			var tX:Number, tY:Number;
			var tItem:Sprite;
			var i:int, len:int;
			var tCount:int;
			var maxHeight:int;
			tCount = 0;
			maxHeight = 0;
			tX = sx;
			tY = sy;
			len = items.length;
			for (i = 0; i < len; i++)
			{
				tItem = items[i];
				tItem.x = tX;
				tItem.y = tY;
				if (tItem.height > maxHeight)
				{
					maxHeight = tItem.height;
				}
				tCount++;
				if (tCount >= xCount)
				{
					tCount = tCount % xCount;
					tItem.y += maxHeight + dY;
					maxHeight = 0;
				}else
				{
					tX += tItem.width + dx;
				}
			}
		}
		public static function layoutToWidth(items:Array,width:Number,dX:Number,dY:Number,sx:Number,sy:Number):void
		{
			var tX:Number,tY:Number;
			var tItem:Sprite;
			var i:int,len:int;
			tX=sx;
			tY=sy;
			len=items.length;
			for(i=0;i<len;i++)
			{
				tItem=items[i];
				if(tX+tItem.width+dX>width)
				{
					tX=sx;
					tY+=dY+tItem.height;
				}else
				{
					
				}
				tItem.x=tX;
				tItem.y=tY;
				tX+=dX+tItem.width;
				
			}
		}
	}
}