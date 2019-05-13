package laya.webgl.submit {
	import laya.filters.ColorFilter;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.resource.RenderTexture2D;
	import laya.webgl.shader.d2.value.TextureSV;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.Mesh2D;

	public class SubmitTarget implements ISubmit
	{
		public var _mesh:Mesh2D;			//代替 _vb,_ib
		public var _startIdx : int, _numEle : int;		
		
		public var shaderValue:Value2D;
		public var blendType:int = 0;
		public var _ref:int=1;
		public var _key:SubmitKey=new SubmitKey();
		
		//public var proName:String;
		//public var  scope:SubmitCMDScope;
		public var srcRT:RenderTexture2D;
		public function SubmitTarget()
		{
		}
		
		public static var POOL:Array =/*[STATIC SAFE]*/(POOL=[],POOL._length=0,POOL);
		public function renderSubmit():int
		{
			var gl:WebGLContext= WebGL.mainContext;
			_mesh.useMesh(gl);
			
			var target:RenderTexture2D = srcRT;
			if (target)	{//??为什么会出现为空的情况
				shaderValue.texture = target._getSource();
				shaderValue.upload();
				blend();
				Stat.renderBatches++;
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
		
		//TODO:coverage
		public function getRenderType():int
		{
			return 0;
		}
		
		public function releaseRender():void
		{
			if ( (--this._ref) < 1)
			{
				var pool:Array = POOL;
				pool[pool._length++] = this;
			}
		}
		
		//TODO:coverage
		public function reUse(context:WebGLContext2D, pos:int):int
		{
			_startIdx = pos;
			_ref++;
			return pos;
		}
		public static function create(context:WebGLContext2D, mesh:Mesh2D,sv:Value2D,rt:RenderTexture2D):SubmitTarget
		{
			var o:SubmitTarget = POOL._length?POOL[--POOL._length]:new SubmitTarget();
			o._mesh = mesh;
			o.srcRT=rt;
			o._startIdx = mesh.indexNum * CONST3D2D.BYTES_PIDX;
			o._ref = 1;
			o._key.clear();
			o._numEle = 0;
			o.blendType = context._nBlendType;
			o._key.blendShader = o.blendType;
			o.shaderValue=sv;
			o.shaderValue.setValue(context._shader2D);
			if (context._colorFiler) {
				var ft:ColorFilter  = context._colorFiler;
				sv.defines.add(ft.type);
				(sv as TextureSV).colorMat = ft._mat;
				(sv as TextureSV).colorAlpha = ft._alpha;
			}
			return o;
		}
	}
}