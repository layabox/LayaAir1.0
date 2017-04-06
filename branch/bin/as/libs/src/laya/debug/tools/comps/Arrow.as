///////////////////////////////////////////////////////////
//  Arrow.as
//  Macromedia ActionScript Implementation of the Class Arrow
//  Created on:      2015-12-30 下午1:59:34
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
	 * @created  2015-12-30 下午1:59:34
	 */
	public class Arrow extends Sprite
	{
		public function Arrow()
		{
			drawMe();
		}
		public function drawMe():void
		{
			var g:Graphics;
			g=graphics;
			g.clear();
			g.drawLine(0,0,-1,-1,"#ff0000");
			g.drawLine(0,0,1,-1,"#ff0000");
		}
	}
}