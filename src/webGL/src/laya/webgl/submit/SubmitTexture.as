package laya.webgl.submit
{
	import laya.filters.ColorFilter;
	import laya.filters.Filter;
	import laya.resource.Bitmap;
	import laya.resource.Texture;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.TextureSV;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.Mesh2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	public class SubmitTexture extends Submit
	{
		private static var _poolSize:int = 0;
		private static var POOL:Array = [];
		
		public function SubmitTexture(renderType:int = TYPE_2D)
		{
			super(renderType);
		}
		
		public override function clone(context:WebGLContext2D, mesh:Mesh2D, pos:int):ISubmit
		{
			var o:SubmitTexture = _poolSize ? POOL[--_poolSize] : new SubmitTexture();
			_cloneInit(o, context, mesh, pos);
			return o;
		}
		
		public override function releaseRender():void
		{
			if ((--this._ref) < 1)
			{
				POOL[_poolSize++] = this;
				shaderValue.release();
				//_vb = null;
				_mesh = null;		//下次create会重新赋值。既然会重新赋值，那还设置干嘛
				_parent && (_parent.releaseRender(), _parent = null);
			}
		}
		
		public override function renderSubmit():int
		{
			if (_numEle === 0)
				return 1;
			
			var tex:Texture = shaderValue.textureHost;
			if(tex){//现在fillrect也用的这个submit，所以不必要求有texture
				var source:* = tex?tex._getSource():null;
				if (!source) return 1;
			}
			
			var gl:WebGLContext = WebGL.mainContext;

			_mesh.useMesh(gl);	
			//如果shader参数都相同，只要提交texture就行了
			var lastSubmit:SubmitTexture = Submit.preRender as SubmitTexture;
			var prekey:SubmitKey = (Submit.preRender as Submit)._key;
			if (_key.blendShader === 0 && (	_key.submitType === prekey.submitType && _key.blendShader === prekey.blendShader) && BaseShader.activeShader &&
					(Submit.preRender as Submit).clipInfoID == clipInfoID &&
					lastSubmit.shaderValue.defines._value === shaderValue.defines._value && //shader define要相同. 
					(shaderValue.defines._value & ShaderDefines2D.NOOPTMASK)==0 //只有基本类型的shader走这个，像blur，glow，filltexture等都不要这样优化
					) {
				(BaseShader.activeShader as Shader).uploadTexture2D(source);
			}
			else
			{
				if (BlendMode.activeBlendFunction !== _blendFn)
				{
					WebGLContext.setBlend(gl,true);
					_blendFn(gl);
					BlendMode.activeBlendFunction = _blendFn;
				}
				shaderValue.texture = source; 
				shaderValue.upload();
			}
			
			gl.drawElements(WebGLContext.TRIANGLES, this._numEle, WebGLContext.UNSIGNED_SHORT, this._startIdx);
			
			Stat.renderBatches++;
			Stat.trianglesFaces += _numEle / 3;
			
			return 1;
		}
		
		/*
		   create方法只传对submit设置的值
		 */
		public static function create(context:WebGLContext2D, mesh:Mesh2D, sv:Value2D):SubmitTexture
		{
			var o:SubmitTexture = _poolSize ? POOL[--_poolSize] : new SubmitTexture(Submit.TYPE_TEXTURE);
			o._mesh = mesh;
			o._key.clear();
			o._key.submitType = Submit.KEY_DRAWTEXTURE;
			o._ref = 1;
			o._startIdx = mesh.indexNum * CONST3D2D.BYTES_PIDX;
			o._numEle = 0;
			var blendType:int = context._nBlendType;
			o._key.blendShader = blendType;
			o._blendFn = context._targets ? BlendMode.targetFns[blendType] : BlendMode.fns[blendType];
			o.shaderValue = sv;
			//sv.setValue(context._shader2D);
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