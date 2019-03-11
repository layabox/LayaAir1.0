package laya.debug.tools.resizer 
{

	
	import laya.display.Graphics;
	import laya.display.Sprite;

	/**
	 * 自动根据大小填充自己全部区域的显示对象
	 * @author ww
	 */
	public class AutoFillRec extends Sprite
	{
		public var type:int;
		public function AutoFillRec(type:String) 
		{
			//super(type);
		}
		

		
		override public function set width(value:Number):void 
		{
			super.width = value;
			changeSize();
		}
		
		
		override public function set height(value:Number):void 
		{
			super.height = value;
			changeSize();
		}
		protected function changeSize():void
		{
			// TODO Auto Generated method stub
			
			var g:Graphics = graphics;
			g.clear();
			g.drawRect(0, 0, width, height, "#33c5f5");
		}
		public var preX:Number;
		public var preY:Number;
		public function record():void
		{
			preX = x;
			preY = y;
		}
		public function getDx():Number
		{
			return x - preX;
		}
		public function getDy():Number
		{
			return y - preY;
		}
		
	}

}