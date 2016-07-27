package laya.debug.tools.resizer 
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Rectangle;
	
	import laya.debug.tools.DisControlTool;

	/**
	 * 本类用于调整对象的宽高以及坐标
	 * @author ww
	 */
	public class DisResizer 
	{
		/**
		 * 最边缘的拖动条
		 */
		public static const Side:int = 2;
		/**
		 * 垂直方向的拖动条
		 */
		public static const Vertical:int = 1;
		/**
		 * 水平方向的拖动条
		 */
		public static const Horizon:int = 0;
		public function DisResizer() 
		{
			
		}
		private static var _up:AutoFillRec;
		private static var _down:AutoFillRec;
		private static var _left:AutoFillRec;
		private static var _right:AutoFillRec;
		
		private static var _barList:Array;
		private static var _tar:Sprite;
		public static const barWidth:int = 2;
		public static var useGetBounds:Boolean=false;
		public static function init():void
		{
			if (_up) return;
			
			_up=new AutoFillRec("T");
			_up.height = barWidth;
			_up.type = Horizon;
			
			_down=new AutoFillRec("T");
			_down.height = barWidth;
			_down.type = Horizon;
			
			_left=new AutoFillRec("R");
			_left.width = barWidth;
			_left.type = Vertical;
			
			_right=new AutoFillRec("R");
			_right.width = barWidth;
			_right.type =Vertical;
			
			_barList = [_up, _down, _left, _right];
			addEvent();
		}
		private static function stageDown(e:Event):void
		{
			var target:Sprite;
			target = e.target as Sprite;
		    if (_tar && DisControlTool.isInTree(_tar, target))
			{
				return;
			}
			clear();
		}
		public static function clear():void
		{
			_tar = null;
			Laya.stage.off(Event.MOUSE_UP, null, stageDown);
			DisControlTool.removeItems(_barList);
			clearDragEvents();
		}
		private static function addEvent():void
		{
			var i:int, len:int;
			var tBar:AutoFillRec;
			len = _barList.length;
			for (i = 0; i < len; i++)
			{
				tBar = _barList[i];
				tBar.on(Event.MOUSE_DOWN, null, barDown);
			}
		}
		private static var tBar:AutoFillRec;
		private static function barDown(e:Event):void
		{
			clearDragEvents();
			tBar = e.target as AutoFillRec;
			if (!tBar) return;
			var area:Rectangle;
			area = new Rectangle();
			if (tBar.type == Horizon)
			{
				area.x = tBar.x;
				area.width = 0;
				area.y = tBar.y - 200;
				area.height = 400;
			}else
			{
				area.x = tBar.x-200;
				area.width = 400;
				area.y = 0;
				area.height = 0;
			}
			var option:Object;
			option = { };
			option.area = area;
			tBar.record();
			//tBar.startDrag(option);
			tBar.startDrag(area);
			tBar.on(Event.DRAG_MOVE, null, draging);
			tBar.on(Event.DRAG_END, null, dragEnd);
		}
		private static function draging(e:Event):void
		{
			trace("draging");
			if (!tBar) return;
			if (!_tar) return;
			switch(tBar)
			{
				case _left:
					_tar.x += tBar.getDx();
					_tar.width -= tBar.getDx();
					_up.width -= tBar.getDx();
					_down.width-=tBar.getDx();
					
					_right.x -= tBar.getDx();		
					tBar.x -= tBar.getDx();
					break;
				case _right:
					_tar.width += tBar.getDx();
					_up.width += tBar.getDx();
					_down.width+=tBar.getDx();
						
					break;
				case _up:
					_tar.y += tBar.getDy();
					_tar.height -= tBar.getDy();
					_right.height -= tBar.getDy();
					_left.height-=tBar.getDy();
					
					_down.y -= tBar.getDy();		
					tBar.y -= tBar.getDy();
					break;
				case _down:

					_tar.height += tBar.getDy();
					_right.height += tBar.getDy();
					_left.height+=tBar.getDy();
					

					break;
				
			}
			
			tBar.record();
		}
		private static function dragEnd(e:Event):void
		{
			trace("dragEnd");
			clearDragEvents();
			updates();
		}
		private static function clearDragEvents():void
		{
			if (!tBar) return;
			tBar.off(Event.DRAG_MOVE, null, draging);
			tBar.off(Event.DRAG_END, null, dragEnd);
		}
		public static function setUp(dis:Sprite, force:Boolean = false ):void
		{
			if (force && dis == _tar) 
			{
//				updates();
				return;
			};
			DisControlTool.removeItems(_barList);
			if (_tar == dis)
			{
				_tar = null;
				clearDragEvents();
				if(!force)
				return;
			}
			_tar = dis;
			updates();
			
			DisControlTool.addItems(_barList, dis);
			
			Laya.stage.off(Event.MOUSE_UP, null, stageDown);
			Laya.stage.on(Event.MOUSE_UP, null, stageDown);
			
		}
		public static function updates():void
		{
			var dis:Sprite;
			dis=_tar;
			if(!dis) return;
			var bounds:Rectangle;
//			bounds=dis.getSelfBounds();
			bounds=new Rectangle(0,0,dis.width,dis.height);
			
			_up.x=bounds.x;
			_up.y=bounds.y;
			_up.width=bounds.width;
			
			_down.x=bounds.x;
			_down.y=bounds.y+bounds.height-barWidth;
			_down.width=bounds.width;
			
			_left.x=bounds.x;
			_left.y=bounds.y;
			_left.height=bounds.height;
			
			_right.x=bounds.x+bounds.width-barWidth;
			_right.y=bounds.y;
			_right.height=bounds.height;
		}
		
	}

}