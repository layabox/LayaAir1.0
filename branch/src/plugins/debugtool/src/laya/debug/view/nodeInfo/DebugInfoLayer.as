package laya.debug.view.nodeInfo 
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Browser;
	import laya.debug.tools.DisControlTool;
	/**
	 * ...
	 * @author ww
	 */
	public class DebugInfoLayer extends Sprite
	{
		public static var I:DebugInfoLayer;
		public var nodeRecInfoLayer:Sprite;
		public var lineLayer:Sprite;
		public var txtLayer:Sprite;
		public var popLayer:Sprite;
		public var graphicLayer:Sprite;
		public var cacheViewLayer:Sprite;
		
		public function DebugInfoLayer() 
		{
			nodeRecInfoLayer = new Sprite();
			lineLayer = new Sprite();
			txtLayer = new Sprite();
			popLayer = new Sprite();
			graphicLayer = new Sprite();
			cacheViewLayer = new Sprite();
			
			nodeRecInfoLayer.name = "nodeRecInfoLayer";
			lineLayer.name = "lineLayer";
			txtLayer.name = "txtLayer";
			popLayer.name = "popLayer";
			graphicLayer.name = "graphicLayer";
			cacheViewLayer.name = "cacheViewLayer";
			
			addChild(lineLayer);
			addChild(cacheViewLayer);
			addChild(nodeRecInfoLayer);
			addChild(txtLayer);
			addChild(popLayer);
			addChild(graphicLayer);
			
			I = this;
			this.zOrder = 999;
			//if (Browser.onMobile) this.scale(2, 2);
			Laya.stage.on(Event.DOUBLE_CLICK, this, setTop);
		}
		public static function init():void
		{
			if (!I)
			{
				new DebugInfoLayer();
				Laya.stage.addChild(I);
			}
		}
		public function setTop():void
		{
			DisControlTool.setTop(this);
		}
		public function isDebugItem(sprite:Sprite):Boolean
		{
			return DisControlTool.isInTree(this, sprite);
		}
		
	}

}