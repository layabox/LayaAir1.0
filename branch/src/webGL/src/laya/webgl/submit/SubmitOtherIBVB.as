package laya.webgl.submit {
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.ISubmit;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	public class SubmitOtherIBVB implements ISubmit {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		private static var _cache:Array =/*[STATIC SAFE]*/ (_cache = [], _cache._length = 0, _cache);
		
		private static var tempMatrix4:Array =/*[STATIC SAFE]*/ [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1,];
		
		public static function create(context:WebGLContext2D, vb:VertexBuffer2D, ib:IndexBuffer2D, numElement:int, shader:Shader, shaderValue:Value2D, startIndex:int, offset:int,type:int = 0):SubmitOtherIBVB {
			var o:SubmitOtherIBVB = (!_cache._length) ? (new SubmitOtherIBVB()) : _cache[--_cache._length];
			o._ib = ib;
			o._vb = vb;
			o._numEle = numElement;
			o._shader = shader;
			o._shaderValue = shaderValue;
			var blendType:int = context._nBlendType;
			o._blendFn = context._targets ? BlendMode.targetFns[blendType] : BlendMode.fns[blendType];
				
			switch(type)
			{
				case 0:
					// River: 所有地方都设置此值为零，等后期确保没有使用后，去掉这个数据。	
					// River: 目前的SubmitOtherIBVB只支持triangleList,所以下面的方式合理
					// 4是每个float值4个
					o.offset = 0;
					o.startIndex = offset / (CONST3D2D.BYTES_PE * vb.vertexStride) * 1.5;
					o.startIndex *= CONST3D2D.BYTES_PIDX;
					break;
				case 1:
					o.startIndex = startIndex;
					o.offset = offset;	
					break;
			}
			return o;
		}
		protected var offset:int = 0;
		protected var _vb:VertexBuffer2D;
		protected var _ib:IndexBuffer2D;
		protected var _blendFn:Function;
		
		public var _mat:Matrix;
		public var _shader:Shader;
		public var _shaderValue:Value2D;
		public var _numEle:int;
		
		public var startIndex:int = 0;
		
		public function SubmitOtherIBVB() {
			super();
			_mat = Matrix.create();
		}
		
		public function releaseRender():void {
			var cache:Array = _cache;
			cache[cache._length++] = this;
		}
		
		public function getRenderType():int {
			return Submit.TYPE_OTHERIBVB;
		}
		
		public function renderSubmit():int {
			var _tex:Texture = _shaderValue.textureHost;
			if (_tex) {
				var source:* = _tex.source;
				if (!_tex.bitmap || !source)
					return 1;
				_shaderValue.texture = source;
			}
			
			_vb.bind_upload(_ib);
			
			var w:Array = RenderState2D.worldMatrix4;
			var wmat:Matrix = Matrix.TEMP;
			Matrix.mulPre(_mat, w[0], w[1], w[4], w[5], w[12], w[13], wmat);
			
			var tmp:Array = RenderState2D.worldMatrix4 = tempMatrix4;
			tmp[0] = wmat.a;
			tmp[1] = wmat.b;
			tmp[4] = wmat.c;
			tmp[5] = wmat.d;
			tmp[12] = wmat.tx;
			tmp[13] = wmat.ty;
			_shader._offset = this.offset;
			_shaderValue.refresh();
			_shader.upload(_shaderValue);
			_shader._offset = 0;
			var gl:WebGLContext = WebGL.mainContext;
			if (BlendMode.activeBlendFunction !== _blendFn) {
				gl.enable(WebGLContext.BLEND);
				_blendFn(gl);
				BlendMode.activeBlendFunction = _blendFn;
			}
			Stat.drawCall++;
			Stat.trianglesFaces += _numEle / 3;
			gl.drawElements(WebGLContext.TRIANGLES, this._numEle, WebGLContext.UNSIGNED_SHORT, startIndex);
			RenderState2D.worldMatrix4 = w;
			
			BaseShader.activeShader = null;
			return 1;
		}
	
	}

}