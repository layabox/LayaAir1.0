///////////////////////////////////////////////////////////
//  CommonTools.as
//  Macromedia ActionScript Implementation of the Class CommonTools
//  Created on:      2015-9-29 下午12:53:31
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
	 * @created  2015-9-29 下午12:53:31
	 */
	public class CommonTools
	{
		public function CommonTools()
		{
		}
		public static function bind(fun:Function,scope:*):Function
		{
			var rst:Function;
			__JS__("rst=fun.bind(scope)");
			return rst;
		}
		private  static var count:int = 0;
		public  static function insertP(tar:Sprite,x:Number,y:Number,scaleX:Number,scaleY:Number,rotation:Number):void
		{
			var nSp:Sprite;
			nSp=new Sprite();
			tar.parent.addChild(nSp);
			nSp.x=x;
			nSp.y=y;
			nSp.scaleX=scaleX;
			nSp.scaleY=scaleY;
			nSp.rotation=rotation;
			nSp.addChild(tar);
			count++;
			nSp.name = "insertP:" + count;
		}
		public  static function insertChild(tar:Sprite,x:Number,y:Number,scaleX:Number,scaleY:Number,rotation:Number,color:String="#ff00ff"):Sprite
		{
			var nSp:Sprite;
			nSp=new Sprite();
			tar.addChild(nSp);
			nSp.x=x;
			nSp.y=y;
			nSp.scaleX=scaleX;
			nSp.scaleY=scaleY;
			nSp.rotation = rotation;
//			nSp.graphics.fillRect(0, 0, 20, 10,color);
			nSp.graphics.drawRect(0,0,20,20,color);
			nSp.name = "child:" + tar.numChildren;
			return nSp;
		}
		public static function createSprite(width:Number, height:Number, color:String = "#ff0000"):Sprite
		{
			var sp:Sprite;
			sp = new Sprite();
			sp.graphics.drawRect(0, 0, width, height, color);
			sp.size(width, height);
			return sp;
		}
		public static function createBtn(txt:String,width:Number=100,height:Number=40):Sprite
		{
			var sp:Sprite;
			sp = new Sprite();
			sp.size(width, height);
			sp.graphics.drawRect(0, 0, sp.width, sp.height, "#ff0000");
			sp.graphics.fillText(txt, sp.width * 0.5, sp.height * 0.5, null, "#ffff00", "center");
			return sp;
		}
	}
}