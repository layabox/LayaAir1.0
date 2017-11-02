package laya.webgl.submit {
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.resource.Texture;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.GlUtils;
	import laya.webgl.utils.VertexBuffer2D;

	public class SubmitStencil implements ISubmit
	{

		public static var _cache:Array =/*[STATIC SAFE]*/(_cache=[],_cache._length=0,_cache);
		public var step:int;
		public var blendMode:String;
		private static var _mask:Number = /*[STATIC SAFE]*/0;
		public function SubmitStencil()
		{
		}
		
		public function renderSubmit():int
		{
			switch(step)
			{
				case 1:
					do1();
					break;
				case 2:
					do2();
					break;
				case 3:
					do3();
					break;
				case 4:
					do4();
					break;
				case 5:
					do5();
					break;
				case 6:
					do6();
					break;
				case 7:
					do7();
					break;
				case 8:
					do8();
					break;
			}
			return 1;
		}
		
		public function getRenderType():int
		{
			return 0;
		}
		
		public function releaseRender():void
		{
			var cache:Array = _cache;
			cache[cache._length++] = this;
		}
		
		
		private var level:int=0;
				
		public static function restore(context:WebGLContext2D,clip:Rectangle, m:Matrix, _x:Number, _y:Number):void
		{
			var submitStencil:SubmitStencil;
			context._renderKey = 0;
			if (_mask > 0)
			{
				_mask--;
			}
			if (_mask == 0)
			{
				submitStencil = SubmitStencil.create(3);
				context.addRenderObject(submitStencil);
				
				context._curSubmit = Submit.RENDERBASE;
			}
			else 
			{
				submitStencil = SubmitStencil.create(7);
				context.addRenderObject(submitStencil);

				var vb:VertexBuffer2D = context._vb;
				var nPos:int = (vb._byteLength >> 2);

				if (GlUtils.fillRectImgVb(vb, null, clip.x, clip.y, clip.width, clip.height, Texture.DEF_UV, m, _x, _y, 0, 0)) {
					var shader:Shader2D = context._shader2D;
					shader.glTexture = null;
					var submit:Submit = context._curSubmit = Submit.createSubmit(context, context._ib, vb, ((vb._byteLength - WebGLContext2D._RECTVBSIZE * Buffer2D.FLOAT32) / 32) * 3, Value2D.create(ShaderDefines2D.COLOR2D, 0));
					submit.shaderValue.ALPHA = 1.0;
					context._submits[context._submits._length++] = submit;
					context._curSubmit._numEle += 6;
					context._curSubmit = Submit.RENDERBASE;
				} else {
					alert("clipRect calc stencil rect error");
				}

				submitStencil = SubmitStencil.create(8);
				context.addRenderObject(submitStencil);
			}
		}
		public static function restore2(context:WebGLContext2D, submit:Submit):void
		{
			var submitStencil:SubmitStencil;
			context._renderKey = 0;
			if (_mask > 0)
			{
				_mask--;
			}
			if (_mask == 0)
			{
				submitStencil = SubmitStencil.create(3);
				context.addRenderObject(submitStencil);
				
				context._curSubmit = Submit.RENDERBASE;
			}
			else 
			{
				submitStencil = SubmitStencil.create(7);
				context.addRenderObject(submitStencil);

				context._submits[context._submits._length++] = submit;
				
				submitStencil = SubmitStencil.create(8);
				context.addRenderObject(submitStencil);
			}
		}
		private function do1():void
		{
			var gl : WebGLContext = WebGL.mainContext;
			gl.enable(WebGLContext.STENCIL_TEST);
			gl.clear(WebGLContext.STENCIL_BUFFER_BIT);
			gl.colorMask(false, false, false, false);
			gl.stencilFunc(WebGLContext.EQUAL,level, 0xFF);
			gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.INCR);
			//gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.INVERT);//测试通过给模版缓冲 写入值 一开始是0 现在是 0xFF (模版缓冲中不知道是多少位的数据)
		}
		
		
		private function do2():void
		{
			var gl : WebGLContext = WebGL.mainContext;
			gl.stencilFunc(WebGLContext.EQUAL,level+1, 0xFF);
			gl.colorMask(true, true, true, true);
			gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.KEEP);
		}
		
		
		private function do3():void
		{
			var gl : WebGLContext = WebGL.mainContext;
			gl.colorMask(true, true, true, true);
			gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.KEEP);
			gl.clear(WebGLContext.STENCIL_BUFFER_BIT);
			gl.disable(WebGLContext.STENCIL_TEST);
		}
		
		private function do4():void
		{
			var gl : WebGLContext = WebGL.mainContext;
			if (level == 0)
			{
				gl.enable(WebGLContext.STENCIL_TEST);
				gl.clear(WebGLContext.STENCIL_BUFFER_BIT);
			}
			gl.colorMask(false, false, false, false);
			gl.stencilFunc(WebGLContext.ALWAYS,0, 0xFF);
			gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.INCR);
		}
		
		private function do5():void
		{
			var gl : WebGLContext = WebGL.mainContext;		
			gl.stencilFunc(WebGLContext.EQUAL, level, 0xFF);
			gl.colorMask(true, true, true, true);
			gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.KEEP);
		}
		
		private function do6():void
		{
			var gl : WebGLContext = WebGL.mainContext;
			BlendMode.targetFns[BlendMode.TOINT[blendMode]](gl);
		}
		
		private function do7():void
		{
			var gl : WebGLContext = WebGL.mainContext;
			gl.colorMask(false, false, false, false);
			//gl.stencilFunc(WebGLContext.ALWAYS,0, 0xFF);
			gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.DECR);
		}
		
		private function do8():void
		{
			var gl : WebGLContext = WebGL.mainContext;
			gl.colorMask(true, true, true, true);
			gl.stencilFunc(WebGLContext.EQUAL, level, 0xFF);
			gl.stencilOp(WebGLContext.KEEP,WebGLContext.KEEP,WebGLContext.KEEP);
		}
		
		public static function create(step:int):SubmitStencil
		{
			var o:SubmitStencil=_cache._length?_cache[--_cache._length]:new SubmitStencil();
			o.step = step;
			if (step == 5)
				++_mask;
			o.level = _mask;
			return o;
		}
	}
}