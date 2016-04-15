package laya.webgl.submit {
	import laya.maths.Matrix;
	import laya.maths.Rectangle;
	import laya.utils.Stat;
	import laya.webgl.submit.ISubmit;
	import laya.webgl.shader.ShaderDefines;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.Shader;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.CONST3D2D;
	/**
	 * ...
	 * @author wk
	 */
	public class SubmitCanvas   extends  Submit
	{
		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static function create(ctx_src:WebGLContext2D,alpha:Number,filters:Array):SubmitCanvas
		{
			var o:SubmitCanvas = (!_cache._length)?(new SubmitCanvas()):_cache[--_cache._length];
			o._ctx_src = ctx_src;
			o._alpha = alpha;
			if (filters && filters.length)
			{
				o._shaderDefines || (o._shaderDefines = new ShaderDefines(_name2int, _int2name, _int2nameMap));
				var n:int = filters.length;
				o._filters.length = n;
				var f:*;
				for (var i:int = 0; i < n; i++)
				{
					o._filters[i] = f=filters[i];
					o._shaderDefines.add(f.type);
				}
			}
			else  o._filters.length=0;
			return o;
		}
		
		private static var _name2int:Object = {};
		private static var _int2name:Array = [];
		private static var _int2nameMap:Array = [];
		
		public var _matrix:Matrix = new Matrix();
		public var _ctx_src:WebGLContext2D;
		public var _alpha:Number;
		public var _matrix4:Array = CONST3D2D.defaultMatrix4.concat();
		public var _filters:Array = [];
		public var _shaderDefines:ShaderDefines;
		
		public override function renderSubmit() : int {
			if (_ctx_src._targets)
			{
				_ctx_src._targets.flush(_ctx_src);
				return 1;
			}

			var preAlpha:Number = RenderState2D.worldAlpha;
			var preMatrix4:Array = RenderState2D.worldMatrix4;
			var preMatrix:Matrix = RenderState2D.worldMatrix;
			
			var preFilters:Array = RenderState2D.worldFilters;
			var preShaderDefinesValue:int = RenderState2D.worldShaderDefinesValue;
			
			var m:Matrix = this._matrix;
			var m4:Array = _matrix4;
			var mout:Matrix = Matrix.TEMP;
			Matrix.mul(m,preMatrix,mout);
			m4[0] = mout.a;
			m4[1] = mout.b;
			m4[4] = mout.c;
			m4[5] = mout.d;
			m4[12] =mout.tx;
			m4[13] =mout.ty;
			
			RenderState2D.worldMatrix = mout.clone();
			RenderState2D.worldMatrix4 = m4;
			RenderState2D.worldAlpha = RenderState2D.worldAlpha * _alpha;
			if (_filters.length)
			{
				RenderState2D.worldFilters = _filters;
				RenderState2D.worldShaderDefinesValue = _shaderDefines._value;
			}
			
			_ctx_src.flush();
			RenderState2D.worldAlpha = preAlpha;
			RenderState2D.worldMatrix4 = preMatrix4;
			RenderState2D.worldMatrix.destroy();
			RenderState2D.worldMatrix = preMatrix;
			
			RenderState2D.worldFilters = preFilters;
			RenderState2D.worldShaderDefinesValue = preShaderDefinesValue;
			
			return 1;
		}
		
		public override  function releaseRender():void
		{
			var cache:Array = _cache;
			cache[cache._length++] = this;
		}
		
		public override function getRenderType():int
		{
			return Submit.TYPE_CANVAS;
		}
		private static var _cache:Array=/*[STATIC SAFE]*/(_cache = [], _cache._length = 0, _cache);
	}

}