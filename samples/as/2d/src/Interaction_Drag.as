package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.maths.Rectangle;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
	
	public class Interaction_Drag
	{
		private const ApePath:String = "res/apes/monkey2.png";

		private var ape:Sprite;
		private var dragRegion:Rectangle;
		
		public function Interaction_Drag()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";

			Laya.loader.load(ApePath, Handler.create(this, setup));
		}

		private function setup(_e:*=null):void
		{
			createApe();
			showDragRegion();
		}
		
		private function createApe():void 
		{
			ape = new Sprite();
			
			ape.loadImage(ApePath);
			Laya.stage.addChild(ape);
			
			var texture:Texture = Laya.loader.getRes(ApePath);
			ape.pivot(texture.width / 2, texture.height / 2);
			ape.x = Laya.stage.width / 2;
			ape.y = Laya.stage.height / 2;
			
			ape.on(Event.MOUSE_DOWN, this, onStartDrag);
		}

		private function showDragRegion():void
		{
			//拖动限制区域
			var dragWidthLimit:int = 350;
			var dragHeightLimit:int = 200;
			dragRegion = new Rectangle(Laya.stage.width - dragWidthLimit >> 1, Laya.stage.height - dragHeightLimit >> 1, dragWidthLimit, dragHeightLimit);
			
			//画出拖动限制区域
			Laya.stage.graphics.drawRect(
				dragRegion.x, dragRegion.y, dragRegion.width, dragRegion.height,
				null, "#FFFFFF", 2);
		}
		
		private function onStartDrag(e:Event=null):void
		{
			//鼠标按下开始拖拽(设置了拖动区域和超界弹回的滑动效果)
			ape.startDrag(dragRegion, true, 100);
		}
	}
}