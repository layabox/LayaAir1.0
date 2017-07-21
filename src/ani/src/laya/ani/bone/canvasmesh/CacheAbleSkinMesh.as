package laya.ani.bone.canvasmesh 
{
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	/**
	 * @private
	 * 将mesh元素缓存到canvas中并进行绘制
	 */
	public class CacheAbleSkinMesh extends SkinMeshCanvas 
	{
		
		public function CacheAbleSkinMesh() 
		{
			super();
		}
		public var isCached:Boolean = false;
		public var canvas:HTMLCanvas;
		public var tex:Texture;
		public var rec:Rectangle;
		private static var tempMt:Matrix = new Matrix();
		public function getCanvasPic():Texture {
			var canvas:HTMLCanvas = new HTMLCanvas("2D");
			var ctx:* = canvas.getContext('2d');
			rec = mesh.getBounds();
			debugger;
			canvas.size(rec.width, rec.height);
			var preTransform:Matrix;
			preTransform = transform;
			transform = tempMt;
			transform.identity();
			transform.translate(-rec.x, -rec.y);
			renderToContext(ctx);
			transform.translate( +rec.x, +rec.y);
			transform = preTransform;
			return new Texture(canvas);
		}
		override public function render(context:*, x:Number, y:Number):void 
		{
			if (!mesh.texture) return;
			//canvas = new HTMLCanvas();
			if (!isCached)
			{
				isCached = true;
				tex = getCanvasPic();
			}
			if(!transform)
			{
				transform=_tempMatrix;
				transform.identity();
				transform.translate(x, y);
				_renderTextureToContext(context);
				transform.translate(-x, -y);
				transform=null;
			}else
			{
				transform.translate(x, y);
				_renderTextureToContext(context);
				transform.translate(-x, -y);
			}
		}
		public function _renderTextureToContext(context:*):void
		{
			this.context = context.ctx || context;
			context.save();			
			var texture:Texture;
			texture = tex;
			if (transform)
			{
				var mt:Matrix=transform;
				context.transform(mt.a, mt.b, mt.c, mt.d, mt.tx, mt.ty);
				
			}
			rec = mesh.getBounds();
			context.translate(rec.x, rec.y);
			context.drawTexture(texture, 0, 0, texture.width, texture.height,0,0);
			context.restore();
		}
		
	}

}