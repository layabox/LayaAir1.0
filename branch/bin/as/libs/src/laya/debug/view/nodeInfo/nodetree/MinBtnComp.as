package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.utils.Handler;
	import laya.debug.tools.DisControlTool;
	import laya.debug.ui.debugui.MinBtnCompUI;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	
	/**
	 * ...
	 * @author ww
	 */
	public class MinBtnComp extends MinBtnCompUI 
	{
		
		public function MinBtnComp() 
		{
			super();
			Base64AtlasManager.replaceRes(MinBtnCompUI.uiView);
			createView(MinBtnCompUI.uiView);
			init();
		}
		override protected function createChildren():void 
		{
			
		}
		private function init():void
		{
			minBtn.on(Event.CLICK, this, onMinBtn);
			maxBtn.on(Event.CLICK, this, onMaxBtn);
			minState = false;
			maxUI.removeSelf();
			DisControlTool.setDragingItem(bg, maxUI);
		}
		private function onMaxBtn():void
		{
			
			maxUI.removeSelf();
			if (maxHandler)
			{
				maxHandler.run();
			}
			if (tar)
			{
				tar.x += maxUI.x - prePos.x;
				tar.y += maxUI.y - prePos.y;
			}
		}
		public var tar:Sprite;
		private var prePos:Point=new Point();
		private function onMinBtn():void
		{
			if (!this.displayedInStage) return;
			var tPos:Point;
			tPos = Point.TEMP;
			tPos.setTo(0, 0);
			tPos = this.localToGlobal(tPos);
			tPos = DebugInfoLayer.I.popLayer.globalToLocal(tPos);
			maxUI.pos(tPos.x, tPos.y);
			DebugInfoLayer.I.popLayer.addChild(maxUI);
		    if (tar)
			{
				prePos.setTo(tPos.x,tPos.y);
			}
			if (minHandler)
			{
				minHandler.run();
			}
		}
		
		public var minHandler:Handler;
		public var maxHandler:Handler;
		
		public function set minState(v:Boolean):void
		{

		}
	}

}