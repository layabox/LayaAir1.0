package laya.d3.resource {
	import laya.d3.math.Vector4;
	import laya.d3.utils.Size;
	import laya.maths.Arith;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	public class SolidColorTextureCube extends BaseTexture {
		/**洋红色纯色纹理。*/
		public static var magentaTexture:SolidColorTextureCube = new SolidColorTextureCube(new Vector4(1.0, 0.0, 1.0, 1.0));
		/**灰色纯色纹理。*/
		public static var grayTexture:SolidColorTextureCube = new SolidColorTextureCube(new Vector4(0.5, 0.5, 0.5, 1.0));
		
		/**@private */
		private var _color:Vector4;
		/**@private */
		private var _pixels:Uint8Array;
		
		/**@private */
		private const _texCount:int = 6;
		
		public function SolidColorTextureCube(color:Vector4) {
			super();
			_type = WebGLContext.TEXTURE_CUBE_MAP;
			_width = 1;
			_height = 1;
			_size = new Size(width, height);
			_color = color;
			_pixels = new Uint8Array([color.x * 255, color.y * 255, color.z * 255, color.w * 255]);
		}
		
		private function _createWebGlTexture():void {
			var gl:WebGLContext = WebGL.mainContext;
			var glTex:* = _source = gl.createTexture();
			var w:int = _width;
			var h:int = _height;
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, _type, glTex);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_X, 0, WebGLContext.RGBA, w, h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _pixels);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_X, 0, WebGLContext.RGBA, w, h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _pixels);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Y, 0, WebGLContext.RGBA, w, h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _pixels);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, WebGLContext.RGBA, w, h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _pixels);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Z, 0, WebGLContext.RGBA, w, h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _pixels);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, WebGLContext.RGBA, w, h, 0, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _pixels);
			
			var minFifter:int = this.minFifter;
			var magFifter:int = this.magFifter;
			var repeat:int = this._repeat ? WebGLContext.REPEAT : WebGLContext.CLAMP_TO_EDGE
			
			var isPOT:Boolean = Arith.isPOT(w, h);
			if (isPOT) {
				if (this.mipmap)
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR_MIPMAP_LINEAR);
				else
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				
				gl.texParameteri(_type, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_S, repeat);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_T, repeat);
				this.mipmap && gl.generateMipmap(_type);
			} else {
				(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				gl.texParameteri(_type, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
				gl.texParameteri(_type, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			}
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
			
			if (isPOT)
				memorySize = w * h * 4 * (1 + 1 / 3) * _texCount;//使用mipmap则在原来的基础上增加1/3
			else
				memorySize = w * h * 4 * _texCount;
		}
		
		override protected function recreateResource():void {
			_createWebGlTexture();
			completeCreate();//处理创建完成后相关操作
		}
		
		override protected function disposeResource():void {
			if (_source) {
				WebGL.mainContext.deleteTexture(_source);
				_source = null;
				memorySize = 0;
			}
		}
	
	}

}