package laya.debug.tools.resizer 
{

	
	import laya.display.Graphics;
	import laya.ui.Box;
	import laya.ui.Component;

	/**
	 * 自动根据大小填充自己全部区域的显示对象
	 * @author ww
	 */
	public class AutoFillRec extends Component
	{
		public var type:int;
		public function AutoFillRec(type:String) 
		{
			//super(type);
		}
		
		override protected function changeSize():void
		{
			// TODO Auto Generated method stub
			super.changeSize();
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