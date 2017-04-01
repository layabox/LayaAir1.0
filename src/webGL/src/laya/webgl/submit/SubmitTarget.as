package laya.webgl.submit {
	import laya.webgl.submit.ISubmit;
	import laya.utils.Stat;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.resource.RenderTarget2D;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.CONST3D2D;

	public class SubmitTarget implements ISubmit
	{
		protected var _renderType:int;		
		protected var _vb : VertexBuffer2D;
		protected var _ib : IndexBuffer2D;	
		public var _startIdx : int, _numEle : int;		
		
		public var shaderValue:Value2D;
		public var blendType:int = 0;
		public var proName:String;
		
		public var scope:SubmitCMDScope;
		public function SubmitTarget()
		{
			
		}
		
		public static var _cache:Array =/*[STATIC SAFE]*/(_cache=[],_cache._length=0,_cache);
		public function renderSubmit():int
		{
			_vb.bind_upload(_ib);
			
			var target:RenderTarget2D = scope.getValue(proName);
			if (target)	{//??为什么会出现为空的情况
				shaderValue.texture = target.source;
				
				if (shaderValue["strength"] && !shaderValue["blurInfo"])
				{
					shaderValue["blurInfo"] = [target.width, target.height];
				}
				shaderValue.upload();
				blend();
				Stat.drawCall++;
				Stat.trianglesFaces += _numEle/3;
				WebGL.mainContext.drawElements(WebGLContext.TRIANGLES, this._numEle, WebGLContext.UNSIGNED_SHORT, this._startIdx);
			}
			return 1;
		}
		
		public function blend():void
		{
			if (BlendMode.activeBlendFunction !== BlendMode.fns[blendType])
			{
				var gl:WebGLContext= WebGL.mainContext;
				gl.enable( WebGLContext.BLEND );
				BlendMode.fns[blendType]( gl);
				BlendMode.activeBlendFunction = BlendMode.fns[blendType];
			}
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
		
		public static function create(context:WebGLContext2D,ib:IndexBuffer2D, vb:VertexBuffer2D, pos:int,sv:Value2D,proName:String):SubmitTarget
		{
			var o:SubmitTarget=_cache._length?_cache[--_cache._length]:new SubmitTarget();
			o._ib = ib;
			o._vb = vb;
			o.proName=proName;
			o._startIdx = pos * CONST3D2D.BYTES_PIDX;
			o._numEle = 0;
			o.blendType = context._nBlendType;
			o.shaderValue=sv;
			o.shaderValue.setValue(context._shader2D);
			return o;
		}
	}
}