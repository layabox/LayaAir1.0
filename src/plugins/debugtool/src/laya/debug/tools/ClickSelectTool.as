package laya.debug.tools 
{
	import laya.debug.DebugTool;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	import laya.debug.view.nodeInfo.NodeUtils;
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.maths.Rectangle;
	import laya.utils.Browser;
	import laya.debug.uicomps.ContextMenuItem;
	import laya.utils.Handler;
	/**
	 * ...
	 * @author ww
	 */
	public class ClickSelectTool 
	{
		private static var _I:ClickSelectTool;
		public static function get I():ClickSelectTool
		{
			if (!_I) _I = new ClickSelectTool();
			return _I;
		}
		public function ClickSelectTool() 
		{
			_selectTip.setBounds(new Rectangle(0, 0, 0, 0 ));
			Notice.listen(DisplayHook.ITEM_CLICKED, this, itemClicked);
		}
		public static var isClickSelectState:Boolean = false;
		private var completeHandler:Handler;
		public function beginClickSelect(complete:Handler = null):void
		{
			this.completeHandler = complete;
			isClickSelectState = true;
			clickSelectChange();
		}
		
		private function clickSelectChange():void
		{		
			if (!Browser.onPC) return;
			tSelectTar = null;
			clearSelectTip();
			if (isClickSelectState)
			{
				Laya.timer.loop(200, this, updateSelectTar, null, true);
			}else
			{
				Laya.timer.clear(this, updateSelectTar);
			}
		}
		private function clearSelectTip():void
		{
			_selectTip.removeSelf();
		}
		private var _selectTip:Sprite=new Sprite();
		private var tSelectTar:Sprite;
		private function updateSelectTar():void
		{
			clearSelectTip();
			tSelectTar = DisplayHook.instance.getDisUnderMouse();
			if (!tSelectTar)
			{
				return;
			} 
			if (DebugInfoLayer.I.isDebugItem(tSelectTar)) return;
			var g:Graphics;
			g = _selectTip.graphics;
			g.clear();
			var rec:Rectangle;
			rec = NodeUtils.getGRec(tSelectTar);
			DebugInfoLayer.I.popLayer.addChild(_selectTip);
			//_selectTip.alpha = 0.2;
			g.drawRect(0, 0, rec.width, rec.height, null,DebugConsts.CLICK_SELECT_COLOR,2);
			_selectTip.pos(rec.x, rec.y);
		}
		public static var ignoreDebugTool:Boolean = false;
		private function itemClicked(tar:Sprite):void
		{
			if (!isClickSelectState) return;
			if (ignoreDebugTool)
			{
				if (DebugInfoLayer.I.isDebugItem(tar)) return;
			}
			if (tar is ContextMenuItem || tar.parent is ContextMenuItem)
			{
				return ;
			}
			DebugTool.showDisBound(tar);
			if (completeHandler)
			{
				completeHandler.runWith(tar);
			}
			isClickSelectState = false;
			clickSelectChange();
		}
	}

}