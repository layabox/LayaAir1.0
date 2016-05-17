package laya.filters
{
	import laya.utils.Browser;
	
	/**
	 * @private
	 */
	public class GlowFilterAction implements IFilterAction
	{
		public static var Canvas:*=Browser.createElement("canvas");;
		public static var Ctx:*=Canvas.getContext('2d');
		
		public var data:GlowFilter;
		public function GlowFilterAction(){}
		
		public function apply(srcCanvas:*):*
		{
			var sCtx:*=srcCanvas.ctx.ctx;
			var sCanvas:*=srcCanvas.ctx.ctx.canvas;
			var canvas:*=Canvas;
			var ctx:*=Ctx;
			canvas.width=sCanvas.width;
			canvas.height=sCanvas.height;
			ctx.shadowBlur=data.blur;
			//ctx.shadowColor=data.color;
			ctx.shadowOffsetX=data.offX;
			ctx.shadowOffsetY=data.offY;
			ctx.drawImage(sCanvas,0,0);
			sCtx.width=sCtx.width;
			sCtx.drawImage(canvas,0,0);
			return sCanvas;
		}
	}
}