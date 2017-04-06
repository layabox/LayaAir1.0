package laya.debug.tools.layout 
{
	import laya.display.Sprite;
	/**
	 * 布局工具类,目前只支持水平方向布局
	 * @author ww
	 */
	public class Layouter 
	{
		
		public function Layouter() 
		{
			
		}
		/**
		 * 布局用的数据，与布局方法有关
		 */
		public var data:Object;
		/**
		 * 布局涉及的对象
		 */
		public var _items:Array;
		/**
		 * 布局用的函数
		 */
		public var layoutFun:Function;
		private function layout():void
		{
			layoutFun(_width, _items, data,_sX);
		}
		
		public function set items(arr:Array):void
		{
			_items = arr;
			calSize();
		}
		public function get items():Array
		{
			return _items;
		}
		/**
		 * 布局起始x
		 */
		private var _sX:Number=0;
		/**
		 * 布局宽
		 */
		private var _width:Number=0;
		public function set x(v:Number):void
		{
			_sX = v;
			changed();
		}
		public function get x():Number
		{
			return _sX;
		}
		public function set width(v:Number):void
		{
			_width = v;
			changed();
		}
		public function get width():Number
		{
			return _width;
		}
		
		/**
		 * 重新布局 
		 * 
		 */
		public function changed():void
		{
			Laya.timer.callLater(this, layout);
		}
		
		/**
		 * 根据当前的对象状态计算位置大小 
		 * 
		 */
		public function calSize():void
		{
			var i:int, len:int;
			var tItem:Sprite;
			tItem = items[0];
			_sX = tItem.x;
			var maxX:Number;
			maxX = _sX + tItem.width;
			len = items.length;
			for (i = 1; i < len; i++)
			{
				tItem = items[i];
				if (_sX > tItem.x)
				{
					_sX = tItem.x;
				}
				if (maxX < tItem.x + tItem.width)
				{
					maxX = tItem.x + tItem.width;
				}
			}
			_width = maxX - _sX;
			
			//trace("size:",_sX,_width);
		}
	}

}