///////////////////////////////////////////////////////////
//  RecInfo.as
//  Macromedia ActionScript Implementation of the Class RecInfo
//  Created on:      2015-12-23 下午12:00:48
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.display.Sprite;
	import laya.maths.Point;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-12-23 下午12:00:48
	 */
	public class RecInfo
	{
		public function RecInfo()
		{
		}
		public var oX:Number=0;
		public var oY:Number=0;
		public var hX:Number=1;
		public var hY:Number = 0;
		public var vX:Number = 0;
		public var vY:Number = 1;
		
		public function get x():Number
		{
			return oX;
		}
		public function get y():Number
		{
			return oY;
		}
		public function get width():Number
		{
			return Math.sqrt((hX-oX)*(hX-oX)+(hY-oY)*(hY-oY));
		}
		public function get height():Number
		{
			return Math.sqrt((vX-oX)*(vX-oX)+(vY-oY)*(vY-oY));
		}
		
		public function get rotation():Number
		{
			return rotationRad/Math.PI*180;
		}
		public function get rotationRad():Number
		{
			var dx:Number=hX-oX;
			var dy:Number=hY-oY;
			return Math.atan2(dy,dx);
		}
		
		public function get rotationV():Number
		{
			return rotationRadV/Math.PI*180;
		}
		public function get rotationRadV():Number
		{
			var dx:Number=vX-oX;
			var dy:Number=vY-oY;
			return Math.atan2(dy,dx);
		}
		public function initByPoints(oPoint:Point,ePoint:Point,vPoint:Point):void
		{
			oX=oPoint.x;
			oY=oPoint.y;
			hX=ePoint.x;
			hY = ePoint.y;
			vX = vPoint.x;
			vY = vPoint.y;
		}
		
		public static function createByPoints(oPoint:Point,ePoint:Point,vPoint:Point):RecInfo
		{
			var rst:RecInfo;
			rst=new RecInfo();
			rst.initByPoints(oPoint,ePoint,vPoint);
			return rst;
		}
		
		public static function getGlobalPoints(sprite:Sprite, x:Number, y:Number):Point
		{
			return sprite.localToGlobal(new Point(x,y));
		}
		
		public static function getGlobalRecInfo(sprite:Sprite, x0:Number=0, y0:Number=0, x1:Number=1, y1:Number=0, x2:Number=0, y2:Number=1):RecInfo
		{
			return createByPoints(getGlobalPoints(sprite,x0,y0),getGlobalPoints(sprite,x1,y1),getGlobalPoints(sprite,x2,y2));
		}
	}
}