package laya.debug.tools.enginehook
{
	import laya.debug.tools.CanvasTools;
	import laya.debug.tools.VisibleAnalyser;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	import laya.display.Sprite;
	import laya.display.css.Style;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.HTMLCanvas;
	
	/**
	 * ...
	 * @author ww
	 */
	public class SpriteRenderForVisibleAnalyse
	{
		
		public function SpriteRenderForVisibleAnalyse()
		{
		
		}
		public static var I:SpriteRenderForVisibleAnalyse = new SpriteRenderForVisibleAnalyse();
		
		public function setRenderHook():void
		{
			Sprite["prototype"]["render"] = I.render;
		}
		/** @private */
		protected var _repaint:int = 1;
		public var _renderType:int = 1;
		public var _x:int;
		public var _y:int;
		
		/**
		 * 更新、呈现显示对象。
		 * @param	context 渲染的上下文引用。
		 * @param	x X轴坐标。
		 * @param	y Y轴坐标。
		 */
		public function render(context:RenderContext, x:Number, y:Number):void
		{
			var me:Sprite;
			me=this as Sprite;
			if (DebugInfoLayer.I.isDebugItem(me)) return ;
			if (me == SpriteRenderForVisibleAnalyse.I.target)
			{
				SpriteRenderForVisibleAnalyse.allowRendering = true;
				SpriteRenderForVisibleAnalyse.I.isTargetRenderd = true;
				CanvasTools.clearCanvas(mainCanvas);
			}
			RenderSprite.renders[_renderType]._fun(this, context, x + _x, y + _y);
			if (me == SpriteRenderForVisibleAnalyse.I.target)
			{
				tarRec = CanvasTools.getCanvasDisRec(SpriteRenderForVisibleAnalyse.mainCanvas);
				trace("rec", tarRec.toString());
				if (tarRec.width >0&& tarRec.height > 0)
				{
					isTarRecOK = true;
					preImageData = CanvasTools.getImageDataFromCanvasByRec(mainCanvas, tarRec);
					tarImageData=CanvasTools.getImageDataFromCanvasByRec(mainCanvas, tarRec);
				}else
				{
					trace("tarRec Not OK:",tarRec);
				}
			}else
			{
				if (isTarRecOK)
				{
					tImageData = CanvasTools.getImageDataFromCanvasByRec(mainCanvas, tarRec);
					var dRate:Number;
					dRate = CanvasTools.getDifferRate(preImageData, tImageData);
					
					preImageData = tImageData;
					if (dRate > 0)
					{
						//trace("differRate:", dRate);
					    VisibleAnalyser.addCoverNode(me, dRate);
					}
					
				}
			}
			
		}
		
		public var target:Sprite;
		public var isTargetRenderd:Boolean = false;
		public static var tarCanvas:HTMLCanvas;
		public static var mainCanvas:HTMLCanvas;
		public static var preImageData:*;
		public static var tImageData:*;
		public static var tarImageData:*;
		public static var tarRec:Rectangle;
		public static var isTarRecOK:Boolean = false;
		
		
		private var preFun:Function;
		public static var isVisibleTesting:Boolean = false;
		public static var allowRendering:Boolean = true;
		
		public static var coverRate:Number;
		
		
		public function analyseNode(node:Sprite):void
		{
			VisibleAnalyser.resetCoverList();
			if (Sprite["prototype"]["render"] != I.render)
			{
				preFun = Sprite["prototype"]["render"];
			}
			target = node;
			Sprite["prototype"]["render"] = render;
			if (!tarCanvas)
				tarCanvas = CanvasTools.createCanvas(Laya.stage.width, Laya.stage.height);
			if (!mainCanvas)
				mainCanvas = CanvasTools.createCanvas(Laya.stage.width, Laya.stage.height);
			isTargetRenderd = false;
			isVisibleTesting = true;
			allowRendering = false;
			//noRenderMode();
			CanvasTools.clearCanvas(mainCanvas);
			CanvasTools.clearCanvas(tarCanvas);
			isTarRecOK = false;

			var ctx:RenderContext=new RenderContext(mainCanvas.width, mainCanvas.height,mainCanvas);
			//var ctx:RenderContext=new RenderContext(mainCanvas.width, mainCanvas.height,null);
			mainCanvas = ctx.canvas;
			//Laya.stage.render(ctx, 0, 0);
			render.call(Laya.stage, ctx, 0, 0);

			if (!isTarRecOK)
			{
				coverRate = 0;
				
			}else
			{
				coverRate = CanvasTools.getDifferRate(preImageData, tarImageData);
			}
			VisibleAnalyser.coverRate = coverRate;
			VisibleAnalyser.isTarRecOK = isTarRecOK;
			trace("coverRate:",coverRate);
	
			isTargetRenderd = false;
			isVisibleTesting = false;
			allowRendering = true;
			//normalMode();
			Sprite["prototype"]["render"] = preFun;
		}
		public var pgraphic:Function = RenderSprite["prototype"]["_graphics"];
		public var pimage:Function = RenderSprite["prototype"]["_image"];
		public var pimage2:Function = RenderSprite["prototype"]["_image2"];
		
		private function noRenderMode():void
		{
			return;
			RenderSprite["prototype"]["_graphics"] = m_graphics;
			RenderSprite["prototype"]["_image"] = m_image;
			RenderSprite["prototype"]["_image2"] = m_image2;
		}
		private function normalMode():void
		{
			RenderSprite["prototype"]["_graphics"] = pgraphic;
			RenderSprite["prototype"]["_image"] = pimage;
			RenderSprite["prototype"]["_image2"] = pimage2;
		}
		public function inits():void
		{
		    noRenderMode();
		}
		
		public var _next:RenderSprite;
		public function m_graphics(sprite:Sprite, context:RenderContext, x:Number, y:Number):void
		{
			
			if (SpriteRenderForVisibleAnalyse.allowRendering)
			{
				var tf:Object = sprite._style._tf;
				sprite._graphics && sprite._graphics._render(sprite, context, x - tf.translateX, y - tf.translateY);
				
			}
			var next:RenderSprite = this._next;
			next._fun.call(next, sprite, context, x, y);
		}
		
		public function m_image(sprite:Sprite, context:RenderContext, x:Number, y:Number):void
		{
			if (SpriteRenderForVisibleAnalyse.allowRendering)
			{
				var style:Style = sprite._style;
				
				context.ctx.drawTexture2(x, y, style._tf.translateX, style._tf.translateY, sprite.transform, style.alpha, style.blendMode, sprite._graphics._one);
			}
		
		}
		
		public function m_image2(sprite:Sprite, context:RenderContext, x:Number, y:Number):void
		{
			if (SpriteRenderForVisibleAnalyse.allowRendering)
			{
				var tf:Object = sprite._style._tf;
				context.ctx.drawTexture2(x, y, tf.translateX, tf.translateY, sprite.transform, 1, null, sprite._graphics._one);
			}
		
		}
	}

}