package laya.d3.resource {
	import laya.d3.math.Vector4;
	import laya.d3.utils.Size;
	import laya.events.Event;
	import laya.maths.Arith;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	public class TextureCube extends BaseTexture {
		/**
		 * 加载TextureCube。
		 * @param url TextureCube地址。
		 */
		public static function load(url:String):TextureCube {
			return Laya.loader.create(url, null, null, TextureCube);
		}
		
		/**@private */
		private var _images:Array;
		
		/**
		 * @inheritDoc
		 */
		override public function get defaulteTexture():BaseTexture {
			return SolidColorTextureCube.grayTexture;
		}
		
		public function TextureCube() {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super();
			_type = WebGLContext.TEXTURE_CUBE_MAP;
		}
		
		/**
		 * @private
		 */
		
		private function _onTextureLoaded(images:Array):void {
			_images = images;
			var minWidth:int = 2147483647/*int.MAX_VALUE*/;
			var minHeight:int = 2147483647/*int.MAX_VALUE*/;
			
			for (var i:int = 0; i < 6; i++) {
				var image:* = images[i];
				minWidth = Math.min(minWidth, image.width);
				minHeight = Math.min(minHeight, image.height);
			}
			
			_width = minWidth;
			_height = minHeight;
			_size = new Size(minWidth, minHeight);
		
		}
		
		private function _createWebGlTexture():void {
			const texCount:int = 6;
			var i:int;
			for (i = 0; i < texCount; i++) {
				if (!_images[i]) {
					throw "create GLTextur err:no data:" + _images[i];
				}
			}
			var gl:WebGLContext = WebGL.mainContext;
			var glTex:* = _source = gl.createTexture();
			var w:int = _width;
			var h:int = _height;
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, _type, glTex);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_X, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[0]);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_X, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[1]);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Y, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[2]);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Y, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[3]);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_POSITIVE_Z, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[4]);
			gl.texImage2D(WebGLContext.TEXTURE_CUBE_MAP_NEGATIVE_Z, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _images[5]);
			
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
			for (i = 0; i < 6; i++) {
				_images[i].onload = null;//统一清理回调事件
				_images[i] = null;
			}
			
			if (isPOT)
				memorySize = w * h * 4 * (1 + 1 / 3) * texCount;//使用mipmap则在原来的基础上增加1/3
			else
				memorySize = w * h * 4 * texCount;
		}
		
		override protected function recreateResource():void {
			if (_url == null)
				return;
			_createWebGlTexture();
			completeCreate();//处理创建完成后相关操作
		}
		
		/**
		 * @private
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			_onTextureLoaded(data as Array);
			activeResource();
			_endLoaded();
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