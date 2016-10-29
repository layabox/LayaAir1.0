package laya.webgl.resource {
	import laya.maths.Arith;
	import laya.renders.Render;
	import laya.resource.HTMLImage;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.atlas.AtlasResourceManager;
	
	public class WebGLImage extends HTMLImage implements IMergeAtlasBitmap {
		
		/**HTML Image*/
		private var _image:*;
		/***是否创建私有Source,值为false时不根据src创建私有WebGLTexture,同时销毁时也只清空source=null,不调用WebGL.mainContext.deleteTexture类似函数，调用资源激活前有效*/
		private var _allowMerageInAtlas:Boolean;
		/**是否允许加入大图合集*/
		private var _enableMerageInAtlas:Boolean;
		
		/**是否使用重复模式纹理寻址*/
		public var repeat:Boolean;
		/**是否使用mipLevel*/
		public var mipmap:Boolean;
		/**缩小过滤器*/
		public var minFifter:int;//动态默认值，判断是否可生成miplevel
		/**放大过滤器*/
		public var magFifter:int;//动态默认值，判断是否可生成miplevel
		
		
		/**
		 * 返回HTML Image,as3无internal货friend，通常禁止开发者修改image内的任何属性
		 * @param HTML Image
		 */
		public function get image():* {
			return _image;
		}
		
		public function get atlasSource():* {
			return _image;
		}
		
		/**
		 * 是否创建私有Source
		 * @return 是否创建
		 */
		public function get allowMerageInAtlas():Boolean {
			return _allowMerageInAtlas;
		}
		
		/**
		 * 是否创建私有Source
		 * @return 是否创建
		 */
		public function get enableMerageInAtlas():Boolean {
			return _enableMerageInAtlas;
		}
		
		/**
		 * 是否创建私有Source,通常禁止修改
		 * @param value 是否创建
		 */
		public function set enableMerageInAtlas(value:Boolean):void {
			_enableMerageInAtlas = value;
		}
		
		/***
		 * 设置onload函数
		 * @param value onload函数
		 */
		override public function set onload(value:Function):void {
			_onload = value;
			_image && (_image.onload = _onload != null ? (function():void {
				onresize();
				_onload();
			}) : null);
		}
		
		/***
		 * 设置onerror函数
		 * @param value onerror函数
		 */
		override public function set onerror(value:Function):void {
			_onerror = value;
			_image && (_image.onerror = _onerror != null ? (function():void {
				_onerror()
			}) : null);
		}
		
		public function WebGLImage(src:String,def:*) {
			super(src,def);
			repeat = false;
			mipmap = false;
			minFifter = -1;
			magFifter = -1;
			_src = src;
			_image = new Browser.window.Image();
			if (def)
			{
				def.onload && (this.onload = def.onload);
				def.onerror && (this.onerror = def.onerror);
				def.onCreate && def.onCreate(this);
			}
			_image.crossOrigin = (src && (src.indexOf("data:") == 0)) ? null : "";
			(src) && (_image.src = src);
			_enableMerageInAtlas = true;
		}
		
		override protected function _init_(src:String,def:*):void {
		}
		
		private function _createWebGlTexture():void {
			if (!_image) {
				throw "create GLTextur err:no data:" + _image;
			}
			
			var gl:WebGLContext = WebGL.mainContext;
			var glTex:* = _source = gl.createTexture();
			
			var preTarget:* = WebGLContext.curBindTexTarget;
			var preTexture:* = WebGLContext.curBindTexValue;
			WebGLContext.bindTexture(gl, WebGLContext.TEXTURE_2D, glTex);
			gl.texImage2D(WebGLContext.TEXTURE_2D, 0, WebGLContext.RGBA, WebGLContext.RGBA, WebGLContext.UNSIGNED_BYTE, _image);
			
			var minFifter:int = this.minFifter;
			var magFifter:int = this.magFifter;
			var repeat:int = this.repeat ? WebGLContext.REPEAT : WebGLContext.CLAMP_TO_EDGE;
			
			var isPot:Boolean = Arith.isPOT(_w, _h);//提前修改内存尺寸，忽悠异步影响
			if (isPot) {
				if (this.mipmap)
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR_MIPMAP_LINEAR);
				else
					(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, repeat);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, repeat);
				this.mipmap && gl.generateMipmap(WebGLContext.TEXTURE_2D);
			} else {
				(minFifter !== -1) || (minFifter = WebGLContext.LINEAR);
				(magFifter !== -1) || (magFifter = WebGLContext.LINEAR);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MIN_FILTER, minFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_MAG_FILTER, magFifter);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_S, WebGLContext.CLAMP_TO_EDGE);
				gl.texParameteri(WebGLContext.TEXTURE_2D, WebGLContext.TEXTURE_WRAP_T, WebGLContext.CLAMP_TO_EDGE);
			}
			(preTarget && preTexture) && (WebGLContext.bindTexture(gl, preTarget, preTexture));
			_image.onload = null;
			_image = null;
			
			if (isPot)
				memorySize = _w * _h * 4 * (1 + 1 / 3);//使用mipmap则在原来的基础上增加1/3
			else
				memorySize = _w * _h * 4;
			_recreateLock = false;
		}
		
		/***重新创建资源，如果异步创建中被强制释放再创建，则需等待释放完成后再重新加载创建。*/
		override protected function recreateResource():void {
			if (_src == null || _src === "")
				return;
			_needReleaseAgain = false;
			if (!_image) {
				_recreateLock = true;
				startCreate();
				var _this:WebGLImage = this;
				_image = new Browser.window.Image();
				_image.crossOrigin = _src.indexOf("data:") == 0 ? null : "";
				_image.onload = function():void {
					if (_this._needReleaseAgain)//异步处理，加载完后可能，如果强制释放资源存在已被释放的风险
					{
						_this._needReleaseAgain = false;
						_this._image.onload = null;
						_this._image = null;
						return;
					}
					
					(!(_this._allowMerageInAtlas && _this._enableMerageInAtlas)) ? (_this._createWebGlTexture()) : (memorySize = 0, _recreateLock = false);
					_this.completeCreate();//处理创建完成后相关操作
				};
				_image.src = _src;
			} else {
				if (_recreateLock) {
					return;
				}
				startCreate();
				(!(_allowMerageInAtlas && _enableMerageInAtlas)) ? (_createWebGlTexture()) : (memorySize = 0, _recreateLock = false);
				completeCreate();//处理创建完成后相关操作
			}
		}
		
		/***销毁资源*/
		override protected function detoryResource():void {
			if (_recreateLock) {
				_needReleaseAgain = true;
			}
			if (_source) {
				WebGL.mainContext.deleteTexture(_source);
				_source = null;
				_image = null;
				memorySize = 0;
			}
		}
		
		/***调整尺寸*/
		override protected function onresize():void {
			this._w = this._image.width;
			this._h = this._image.height;
			(AtlasResourceManager.enabled) && (_w < AtlasResourceManager.atlasLimitWidth && _h < AtlasResourceManager.atlasLimitHeight) ? _allowMerageInAtlas = true : _allowMerageInAtlas = false;
		}
		
		public function clearAtlasSource():void {
			_image = null;
		}
	}
}