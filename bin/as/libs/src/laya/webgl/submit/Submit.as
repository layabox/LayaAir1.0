package laya.webgl.submit {
	import laya.maths.Matrix;
	import laya.webgl.submit.ISubmit;
	import laya.utils.Stat;
	import laya.webgl.utils.IndexBuffer;
	import laya.webgl.utils.VertexBuffer;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.VertexDeclaration;

	/**
	 * ...
	 * @author River
	 */
	public class Submit implements ISubmit
	{		
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const TYPE_2D:int = 1;
		public static const TYPE_CANVAS:int = 3;
		public static const TYPE_CMDSETRT:int = 4;
		public static const TYPE_CUSTOM:int = 5;
		public static const TYPE_BLURRT:int = 6;
		public static const TYPE_CMDDESTORYPRERT:int = 7;
		public static const TYPE_DISABLESTENCIL:int = 8;
		public static const TYPE_OTHERIBVB:int = 9;
		public static const TYPE_PRIMITIVE:int = 10;
		public static const TYPE_RT:int = 11;
		public static const TYPE_BLUR_RT:int = 12;
		public static const TYPE_TARGET:int = 13;
		public static const TYPE_CHANGE_VALUE:int=14;
		public static const TYPE_SHAPE:int=15;

		public static var RENDERBASE:Submit;
		

		private static var _cache:Array =/*[STATIC SAFE]*/(_cache=[],_cache._length=0,_cache);

		protected var _renderType:int;		
		protected var _selfVb : VertexBuffer;
		protected var _ib : IndexBuffer;
		protected var _blendFn:Function;

		public var _vb : VertexBuffer;

		// 从VB中什么地方开始画，画到哪
		public var _startIdx : int, _numEle : int;	
		public var _submitID:Number, _mergID:int;		
		public var shaderValue:Value2D;

		public static function __init__():void
		{
			var s:Submit=RENDERBASE=new Submit(-1);
			s.shaderValue=new Value2D(0,0);
			s.shaderValue.ALPHA=-1234;
		}
		
		public function Submit(renderType:int=TYPE_2D) 
		{	
			_renderType = renderType;
		}
		
		public  function releaseRender():void
		{
			var cache:Array = _cache;
			cache[cache._length++] = this;
			shaderValue.release();
			_submitID = -1;
			_vb = null;
		}
				
		public function getRenderType():int
		{
			return _renderType;
		}

		public function renderSubmit() : int {

			if (_numEle === 0) return 1;//怎么会有_numEle是0的情况?
			
			if (shaderValue.textureHost) //TODO:阿欢调整
			{
				if ( !shaderValue.textureHost.bitmap||!shaderValue.textureHost.source) //bitmap可能为空造成崩溃，上层应调整
					return 1;
				shaderValue.texture = shaderValue.textureHost.source;
			}

			_vb.bind_upload(_ib);

			var gl:WebGLContext = WebGL.mainContext;

			///*[IF-FLASH]*/gl.useTexture(shaderValue.texture!=null);

			shaderValue.upload();

			if (BlendMode.activeBlendFunction !== _blendFn)
			{
				gl.enable( WebGLContext.BLEND );
				_blendFn(gl);
				BlendMode.activeBlendFunction = _blendFn;
			}
			
			Stat.drawCall++;
			Stat.trianglesFaces += _numEle / 3;
			gl.drawElements(WebGLContext.TRIANGLES, this._numEle, WebGLContext.UNSIGNED_SHORT, this._startIdx);
			return 1;
		}
		
		/*
		 create方法只传对submit设置的值
		*/
		public static function create(context:WebGLContext2D,submitID:Number,mergID:int,ib:IndexBuffer, vb:VertexBuffer, pos:int,sv:Value2D):Submit
		{
			var o:Submit = _cache._length?_cache[--_cache._length]:new Submit();
			
			if (vb == null)
			{
				vb = o._selfVb || (o._selfVb=VertexBuffer.create(new VertexDeclaration(-1)));
				vb.clear();
				pos = 0;
			}
			o._ib = ib;
			o._vb = vb;

			o._submitID = submitID;
			o._mergID = mergID;			
			o._startIdx = pos * CONST3D2D.BYTES_PIDX;
			o._numEle = 0;
			var blendType:int = context._nBlendType;
			o._blendFn = context._targets?BlendMode.targetFns[blendType]:BlendMode.fns[blendType];
			o.shaderValue=sv;
			o.shaderValue.setValue(context._shader2D);
			var filters:Array = context._shader2D.filters;
			filters && o.shaderValue.setFilters(filters);
			return o;
		}
		
		public static function createShape(ctx:WebGLContext2D,ib:IndexBuffer,vb:VertexBuffer,numEle:int,offset:int,sv:Value2D):Submit
		{
			var o:Submit = (!_cache._length)?(new Submit()):_cache[--_cache._length];
			o._ib=ib;
			o._vb=vb;
			o._numEle=numEle;
			o._startIdx=offset;
			o.shaderValue=sv;
			o.shaderValue.setValue(ctx._shader2D);
			var blendType:int = ctx._nBlendType;
			o._blendFn = ctx._targets?BlendMode.targetFns[blendType]:BlendMode.fns[blendType];
			return o;
		}
	}

}