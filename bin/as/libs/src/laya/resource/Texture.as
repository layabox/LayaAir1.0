package laya.resource {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.maths.Rectangle;
	import laya.net.URL;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.RunDriver;
	
	/**
	 * 资源加载完成后调度。
	 * @eventType Event.LOADED
	 */
	[Event(name = "loaded", type = "laya.events.Event")]
	
	/**
	 * <code>Texture</code> 是一个纹理处理类。
	 */
	public class Texture extends EventDispatcher {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**默认 UV 信息。*/
		public static var DEF_UV:Array =/*[STATIC SAFE]*/ [0, 0, 1.0, 0, 1.0, 1.0, 0, 1.0];
		/**反转 UV 信息。*/
		/*[IF-FLASH]*/
		public static var INV_UV:Array =/*[STATIC SAFE]*/ [0, 0, 1.0, 0, 1.0, 1.0, 0, 1.0];
		//[IF-JS]public static var INV_UV:Array =/*[STATIC SAFE]*/ [0, 1, 1.0, 1, 1.0, 0.0, 0, 0.0];
		/**@private */
		private static var _rect1:Rectangle =/*[STATIC SAFE]*/ new Rectangle();
		/**@private */
		private static var _rect2:Rectangle =/*[STATIC SAFE]*/ new Rectangle();
		
		/** 图片或者canvas 。*/
		public var bitmap:*;
		/** UV信息。*/
		public var uv:Array;
		/**沿 X 轴偏移量。*/
		public var offsetX:Number = 0;
		/**沿 Y 轴偏移量。*/
		public var offsetY:Number = 0;
		/**原始宽度（包括被裁剪的透明区域）。*/
		public var sourceWidth:Number = 0;
		/**原始高度（包括被裁剪的透明区域）。*/
		public var sourceHeight:Number = 0;
		/** @private */
		public var _loaded:Boolean;
		/** @private */
		protected var _w:Number = 0;
		/** @private */
		protected var _h:Number = 0;
		/**@private 唯一ID*/
		public var $_GID:Number;
		/**图片地址*/
		public var url:String;
		//public var repeat:Boolean = false;
		/** @private */
		public var _uvID:int = 0;
		
		public var _atlasID:int = -1;
		/** @private */
		public var scaleRate:Number = 1;
		
		/**
		 * 创建一个 <code>Texture</code> 实例。
		 * @param	bitmap 位图资源。
		 * @param	uv UV 数据信息。
		 */
		public function Texture(bitmap:Bitmap = null, uv:Array = null) {
			if (bitmap) {
				bitmap._addReference();
				//bitmap._referenceCount++;
			}
			setTo(bitmap, uv);
		}
		
		/**
		 * @private
		 */
		public function _setUrl(url:String):void {
			this.url = url;
		}
		
		/**
		 * 设置此对象的位图资源、UV数据信息。
		 * @param	bitmap 位图资源
		 * @param	uv UV数据信息
		 */
		public function setTo(bitmap:Bitmap = null, uv:Array = null):void {
			if (__JS__("bitmap instanceof window.HTMLElement") ) {
				var canvas:HTMLCanvas = HTMLCanvas.create("2D",bitmap);
				this.bitmap = canvas;
				
			}else{
				this.bitmap = bitmap;
			}
			this.uv = uv || DEF_UV;
			if (bitmap) {
				_w = bitmap.width;
				_h = bitmap.height;
				sourceWidth = sourceWidth || _w;
				sourceHeight = sourceHeight || _h
				_loaded = _w > 0;
				var _this:Texture = this;
				if (_loaded) {
					RunDriver.addToAtlas && RunDriver.addToAtlas(_this);
				} else {
					var bm:* = bitmap;
					if (bm is HTMLImage && bm.image)//必须是webglImage(只有webglImage包含image)
						bm.image.addEventListener('load', function(e:*):void {
							RunDriver.addToAtlas && RunDriver.addToAtlas(_this);
						}, false);
				}
			}
		}
		
		/**
		 * 平移 UV。
		 * @param offsetX 沿 X 轴偏移量。
		 * @param offsetY 沿 Y 轴偏移量。
		 * @param uv 需要平移操作的的 UV。
		 * @return 平移后的UV。
		 */
		public static function moveUV(offsetX:Number, offsetY:Number, uv:Array):Array {
			for (var i:int = 0; i < 8; i += 2) {
				uv[i] += offsetX;
				uv[i + 1] += offsetY;
			}
			return uv;
		}
		
		/**
		 *  根据指定资源和坐标、宽高、偏移量等创建 <code>Texture</code> 对象。
		 * @param	source 绘图资源 img 或者 Texture 对象。
		 * @param	x 起始绝对坐标 x 。
		 * @param	y 起始绝对坐标 y 。
		 * @param	width 宽绝对值。
		 * @param	height 高绝对值。
		 * @param	offsetX X 轴偏移量（可选）。
		 * @param	offsetY Y 轴偏移量（可选）。
		 * @param	sourceWidth 原始宽度，包括被裁剪的透明区域（可选）。
		 * @param	sourceHeight 原始高度，包括被裁剪的透明区域（可选）。
		 * @return  <code>Texture</code> 对象。
		 */
		public static function create(source:*, x:Number, y:Number, width:Number, height:Number, offsetX:Number = 0, offsetY:Number = 0, sourceWidth:Number = 0, sourceHeight:Number = 0):Texture {
			var btex:Boolean = source is Texture;
			var uv:Array = btex ? source.uv : DEF_UV;
			var bitmap:* = btex ? source.bitmap : source;
			var bIsAtlas:* = RunDriver.isAtlas(bitmap);
			if (bIsAtlas) {
				var atlaser:* = bitmap._atlaser;
				var nAtlasID:int = (source as Texture)._atlasID;
				if (nAtlasID == -1) {
					throw new Error("create texture error");
				}
				bitmap = atlaser._inAtlasTextureBitmapValue[nAtlasID];
				uv = atlaser._inAtlasTextureOriUVValue[nAtlasID];
			}
			var tex:Texture = new Texture(bitmap, null);
			if (bitmap.width && (x + width) > bitmap.width) width = bitmap.width - x;
			if (bitmap.height && (y + height) > bitmap.height) height = bitmap.height - y;
			tex.width = width;
			tex.height = height;
			tex.offsetX = offsetX;
			tex.offsetY = offsetY;
			tex.sourceWidth = sourceWidth || width;
			tex.sourceHeight = sourceHeight || height;
			
			var dwidth:Number = 1 / bitmap.width;
			var dheight:Number = 1 / bitmap.height;
			x *= dwidth;
			y *= dheight;
			width *= dwidth;
			height *= dheight;
			
			var u1:Number = tex.uv[0], v1:Number = tex.uv[1], u2:Number = tex.uv[4], v2:Number = tex.uv[5];
			var inAltasUVWidth:Number = (u2 - u1), inAltasUVHeight:Number = (v2 - v1);
			var oriUV:Array = moveUV(uv[0], uv[1], [x, y, x + width, y, x + width, y + height, x, y + height]);
			tex.uv = [u1 + oriUV[0] * inAltasUVWidth, v1 + oriUV[1] * inAltasUVHeight, u2 - (1 - oriUV[2]) * inAltasUVWidth, v1 + oriUV[3] * inAltasUVHeight, u2 - (1 - oriUV[4]) * inAltasUVWidth, v2 - (1 - oriUV[5]) * inAltasUVHeight, u1 + oriUV[6] * inAltasUVWidth, v2 - (1 - oriUV[7]) * inAltasUVHeight];
			if (bIsAtlas) {
				tex.addTextureToAtlas();
			}
			
			var bitmapScale:Number = bitmap.scaleRate;
			if (bitmapScale && bitmapScale != 1)
			{
				tex.sourceWidth /= bitmapScale;
				tex.sourceHeight /= bitmapScale;
				tex.width /= bitmapScale;
				tex.height /= bitmapScale;
				tex.scaleRate = bitmapScale;
				tex.offsetX /= bitmapScale;
				tex.offsetY /= bitmapScale;
			}else
			{
				tex.scaleRate = 1;
			}
			
			return tex;
		}
		
		/**
		 * 截取Texture的一部分区域，生成新的Texture，如果两个区域没有相交，则返回null。
		 * @param	texture	目标Texture。
		 * @param	x		相对于目标Texture的x位置。
		 * @param	y		相对于目标Texture的y位置。
		 * @param	width	截取的宽度。
		 * @param	height	截取的高度。
		 * @return 返回一个新的Texture。
		 */
		public static function createFromTexture(texture:Texture, x:Number, y:Number, width:Number, height:Number):Texture {
			
			var texScaleRate:Number = texture.scaleRate;
			if (texScaleRate != 1)
			{
				x *= texScaleRate;
				y *= texScaleRate;
				width *= texScaleRate;
				height *= texScaleRate;
			}
			var rect:Rectangle = Rectangle.TEMP.setTo(x - texture.offsetX, y - texture.offsetY, width, height);
			var result:Rectangle = rect.intersection(_rect1.setTo(0, 0, texture.width, texture.height), _rect2);
			if (result)
				var tex:Texture = create(texture, result.x, result.y, result.width, result.height, result.x - rect.x, result.y - rect.y, width, height);
			else return null;
			tex.bitmap._removeReference();
			return tex;
		}
		
		/**
		 * 表示是否加载成功，只能表示初次载入成功（通常包含下载和载入）,并不能完全表示资源是否可立即使用（资源管理机制释放影响等）。
		 */
		public function get loaded():Boolean {
			return _loaded;
		}
		
		/**
		 * 表示资源是否已释放。
		 */
		public function get released():Boolean {
			if (!bitmap) return true;
			return bitmap.released;
		}
		
		/** @private 激活资源。*/
		public function active():void {
			if (bitmap) bitmap.activeResource();
		}
		
		/** 激活并获取资源。*/
		public function get source():* {
			if (!bitmap) return null;
			bitmap.activeResource();
			return bitmap.source;
		}
		
		/**
		 * 销毁纹理（分直接销毁，跟计数销毁两种）。
		 * @param	forceDispose	(default = false)true为强制销毁主纹理，false是通过计数销毁纹理。
		 */
		public function destroy(forceDispose:Boolean = false):void {
			if (bitmap && (bitmap as Bitmap).referenceCount > 0) {
				var temp:* = this.bitmap;
				if (forceDispose) {
					if (Render.isConchApp && temp.source && temp.source.conchDestroy) {
						this.bitmap.source.conchDestroy();
					}
					this.bitmap = null;
					temp.dispose();
					(temp as Bitmap)._clearReference();
				} else {
					(temp as Bitmap)._removeReference();
					if ((temp as Bitmap).referenceCount == 0) {
						if (Render.isConchApp && temp.source && temp.source.conchDestroy) {
							this.bitmap.source.conchDestroy();
						}
						this.bitmap = null;
						temp.dispose();
					}
				}
				
				if (url && this === Laya.loader.getRes(url)) Laya.loader.clearRes(url, forceDispose);
				_loaded = false;
			}
		}
		
		/** 实际宽度。*/
		public function get width():Number {
			if (_w) return _w;
			return (uv && uv !== DEF_UV) ? (uv[2] - uv[0]) * bitmap.width : bitmap.width;
		}
		
		public function set width(value:Number):void {
			_w = value;
			sourceWidth || (sourceWidth = value);
		}
		
		/** 实际高度。*/
		public function get height():Number {
			if (_h) return _h;
			return (uv && uv !== DEF_UV) ? (uv[5] - uv[1]) * bitmap.height : bitmap.height;
		}
		
		public function set height(value:Number):void {
			_h = value;
			sourceHeight || (sourceHeight = value);
		}
		
		/**
		 * 获取当前纹理是否启用了线性采样。
		 */
		public function get isLinearSampling():Boolean {
			return Render.isWebGL ? (bitmap.minFifter != 0x2600) : true;
		}
		
		/**
		 * 设置线性采样的状态（目前只能第一次绘制前设置false生效,来关闭线性采样）。
		 */
		public function set isLinearSampling(value:Boolean):void {
			if (!value && Render.isWebGL) {
				if (!value && (bitmap.minFifter == -1) && (bitmap.magFifter == -1)) {
					bitmap.minFifter = 0x2600;
					bitmap.magFifter = 0x2600;
					bitmap.enableMerageInAtlas = false;
				}
			}
		}
		
		/**
		 * 获取当前纹理是否启用了纹理平铺
		 */
		public function get repeat():Boolean {
			if (Render.isWebGL && bitmap) {
				return bitmap.repeat;
			}
			return true;
		}
		
		/**
		 * 通过外部设置是否启用纹理平铺(后面要改成在着色器里计算)
		 */
		public function set repeat(value:Boolean):void {
			if (value) {
				if (Render.isWebGL && bitmap) {
					bitmap.repeat = value;
					if (value) {
						bitmap.enableMerageInAtlas = false;
					}
				}
			}
		}
		
		/**
		 * 加载指定地址的图片。
		 * @param	url 图片地址。
		 */
		public function load(url:String):void {
			_loaded = false;
			url = URL.customFormat(url);
			var fileBitmap:FileBitmap = (this.bitmap || (this.bitmap = HTMLImage.create(url))) as FileBitmap;//WebGl模式被自动替换为WebGLImage
			if (fileBitmap) fileBitmap._addReference();
			var _this:Texture = this;
			fileBitmap.onload = function():void {
				fileBitmap.onload = null;
				_this._loaded = true;
				sourceWidth = _w = fileBitmap.width;
				sourceHeight = _h = fileBitmap.height;
				_this.event(Event.LOADED, this);//this为WebGLImage 待调整
				(RunDriver.addToAtlas) && (RunDriver.addToAtlas(_this));
			};
		}
		
		/**@private */
		public function addTextureToAtlas(e:* = null):void {
			RunDriver.addTextureToAtlas(this);
		}
		
		/**
		 * 获取Texture上的某个区域的像素点
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @return  返回像素点集合
		 */
		public function getPixels(x:Number, y:Number, width:Number, height:Number):Array {
			if (Render.isConchApp) {
				var temp:* = this.bitmap;
				if (temp.source && temp.source.getImageData) {
					var arraybuffer:ArrayBuffer = temp.source.getImageData(x, y, width, height);
					var tUint8Array:Uint8Array = new Uint8Array(arraybuffer);
					return __JS__("Array.from(tUint8Array)");
				}
				return null;
			} else if (Render.isWebGL) {
				return RunDriver.getTexturePixels(this, x, y, width, height);
			} else {
				Browser.canvas.size(width, height);
				Browser.canvas.clear();
				Browser.context.drawTexture(this, -x, -y, this.width, this.height, 0, 0);
				var info:* = Browser.context.getImageData(0, 0, width, height);
			}
			return info.data;
		}
		
		/**@private */
		public function onAsynLoaded(url:String, bitmap:Bitmap):void {
			if (bitmap) bitmap._addReference();
			setTo(bitmap, uv);
		}
	}
}