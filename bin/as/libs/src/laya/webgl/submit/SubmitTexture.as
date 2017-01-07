package laya.webgl.submit {
	import laya.resource.Bitmap;
	import laya.resource.Texture;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.WebGLContext2D;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	public class SubmitTexture extends Submit {
		private static var _cache:Array =/*[STATIC SAFE]*/ (_cache = [], _cache._length = 0, _cache);
		
		protected var _texs:Vector.<Texture> = new Vector.<Texture>;
		protected var _texsID:Vector.<int> = new Vector.<int>;
		protected var _vbPos:Vector.<int> = new Vector.<int>;
		public var _preIsSameTextureShader:Boolean = false;
		public var _isSameTexture:Boolean = true;
		
		public function SubmitTexture(renderType:int = TYPE_2D) {
			super(renderType);
		}
		
		public override function releaseRender():void {
			var cache:Array = _cache;
			cache[cache._length++] = this;
			shaderValue.release();
			_preIsSameTextureShader = false;
			_vb = null;
			_texs.length = 0;
			_vbPos.length = 0;
			_isSameTexture = true;
		}
		
		public function addTexture(tex:Texture, vbpos:int):void {
			_texsID[_texs.length] = tex._uvID;
			_texs.push(tex);
			_vbPos.push(vbpos);
		}
		
		//检查材质是否修改，修改UV，设置是否是同一材质
		public function checkTexture():void {
			if (_texs.length < 1)//如果不是同一个材质了，要拆开提交
			{
				_isSameTexture = true;
				return;
			}
			var _tex:Texture = shaderValue.textureHost;
			
			var webGLImg:Bitmap = _tex.bitmap as Bitmap;
			if (webGLImg === null) return;
			
			var vbdata:* = _vb.getFloat32Array();
			for (var i:int = 0, s:int = _texs.length; i < s; i++) {
				var tex:Texture = _texs[i];
				tex.active();
				var newUV:Array = tex.uv;
				if (_texsID[i] !== tex._uvID) {
					//修改UV
					_texsID[i] = tex._uvID;
					var vbPos:int = _vbPos[i];
					
					vbdata[vbPos + 2] = newUV[0];
					vbdata[vbPos + 3] = newUV[1];
					vbdata[vbPos + 6] = newUV[2];
					vbdata[vbPos + 7] = newUV[3];
					vbdata[vbPos + 10] = newUV[4];
					vbdata[vbPos + 11] = newUV[5];
					vbdata[vbPos + 14] = newUV[6];
					vbdata[vbPos + 15] = newUV[7];
					_vb.setNeedUpload();
				}
				if (tex.bitmap !== webGLImg) {
					_isSameTexture = false;
				}
			}
		
		}
		private static var _shaderSet:Boolean = true;
		
		public override function renderSubmit():int {
			if (_numEle === 0)
			{
				_shaderSet = false;
				return 1;
			}
			var _tex:Texture = shaderValue.textureHost;
			if (_tex) {
				var source:* = _tex.source;
				if (!_tex.bitmap || !source) {
					_shaderSet = false;
					return 1;
				}
				shaderValue.texture = source;
			}
			
			_vb.bind_upload(_ib);
			
			var gl:WebGLContext = WebGL.mainContext;
			
			if (BlendMode.activeBlendFunction !== _blendFn) {
				gl.enable(WebGLContext.BLEND);
				_blendFn(gl);
				BlendMode.activeBlendFunction = _blendFn;
			}
			
			Stat.drawCall++;
			Stat.trianglesFaces += _numEle / 3;
			
			if (_preIsSameTextureShader && BaseShader.activeShader && _shaderSet)
				(BaseShader.activeShader as Shader).uploadTexture2D(shaderValue.texture);
			else shaderValue.upload();
			_shaderSet = true;
			
			//_isSameTexture = true;//暂时使用
			if (_texs.length > 1 && !_isSameTexture)//如果不是同一个材质了，要拆开提交
			{
				var webGLImg:Bitmap = _tex.bitmap as Bitmap;
				var index:int = 0;
				var shader:Shader = BaseShader.activeShader as Shader;
				for (var i:int = 0, s:int = _texs.length; i < s; i++) {
					var tex2:Texture = _texs[i];
					if (tex2.bitmap !== webGLImg || (i + 1) === s) {
						shader.uploadTexture2D(tex2.source);
						gl.drawElements(WebGLContext.TRIANGLES, (i - index + 1) * 6, WebGLContext.UNSIGNED_SHORT, this._startIdx + index * 6 * CONST3D2D.BYTES_PIDX);
						webGLImg = tex2.bitmap;
						index = i;
					}
				}
			} else {
				gl.drawElements(WebGLContext.TRIANGLES, this._numEle, WebGLContext.UNSIGNED_SHORT, this._startIdx);
			}
			return 1;
		}
		
		/*
		   create方法只传对submit设置的值
		 */
		public static function create(context:WebGLContext2D, ib:IndexBuffer2D, vb:VertexBuffer2D, pos:int, sv:Value2D):SubmitTexture {
			var o:SubmitTexture = _cache._length ? _cache[--_cache._length] : new SubmitTexture();
			
			if (vb == null) {
				vb = o._selfVb || (o._selfVb = VertexBuffer2D.create(-1));
				vb.clear();
				pos = 0;
			}
			o._ib = ib;
			o._vb = vb;
			
			o._startIdx = pos * CONST3D2D.BYTES_PIDX;
			o._numEle = 0;
			var blendType:int = context._nBlendType;
			o._blendFn = context._targets ? BlendMode.targetFns[blendType] : BlendMode.fns[blendType];
			o.shaderValue = sv;
			o.shaderValue.setValue(context._shader2D);
			var filters:Array = context._shader2D.filters;
			filters && o.shaderValue.setFilters(filters);
			return o;
		}
	
	}

}