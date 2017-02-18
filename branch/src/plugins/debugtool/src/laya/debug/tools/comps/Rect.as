///////////////////////////////////////////////////////////
//  Rect.as
//  Macromedia ActionScript Implementation of the Class Rect
//  Created on:      2015-12-30 下午3:23:06
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools.comps
{
	import laya.display.Graphics;
	import laya.display.Sprite;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-12-30 下午3:23:06
	 */
	public class Rect extends Sprite
	{
		public function Rect()
		{
			drawMe();
		}
		public var recWidth:Number=10;
		public function drawMe():void
		{
			var g:Graphics;
			g=graphics;
			g.clear();
			g.drawRect(0,0,recWidth,recWidth,"#22ff22");
			this.size(recWidth,recWidth);
		}
		public function posTo(x:Number,y:Number):void
		{
			this.x=x-recWidth*0.5;
			this.y=y-recWidth*0.5;
		}
	}
}