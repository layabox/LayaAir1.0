package laya.resource {
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.RunDriver;
	
	/**
	 * 资源加载完成后调度。
	 * @eventType Event.READY
	 */
	[Event(name = "ready", type = "laya.events.Event")]
	
	/**
	 * <code>Texture</code> 是一个纹理处理类。
	 */
	public class Texture extends EventDispatcher {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**@private 默认 UV 信息。*/
		public static var DEF_UV:Array = /*[STATIC SAFE]*/ [0, 0, 1.0, 0, 1.0, 1.0, 0, 1.0];
		/**@private */
		public static var NO_UV:Array = /*[STATIC SAFE]*/ [0, 0, 0, 0, 0, 0, 0, 0];
		/**@private 反转 UV 信息。*/
		public static var INV_UV:Array = /*[STATIC SAFE]*/ [0, 1, 1.0, 1, 1.0, 0.0, 0, 0.0];
		/**@private uv的范围*/
		public var uvrect:Array = [0, 0, 1, 1]; //startu,startv, urange,vrange
		/**@private */
		private static var _rect1:Rectangle = /*[STATIC SAFE]*/ new Rectangle();
		/**@private */
		private static var _rect2:Rectangle = /*[STATIC SAFE]*/ new Rectangle();
		
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
			return _create(source, x, y, width, height, offsetX, offsetY, sourceWidth, sourceHeight);
		}
		
		/**
		 * @private
		 * 根据指定资源和坐标、宽高、偏移量等创建 <code>Texture</code> 对象。
		 * @param	source 绘图资源 img 或者 Texture 对象。
		 * @param	x 起始绝对坐标 x 。
		 * @param	y 起始绝对坐标 y 。
		 * @param	width 宽绝对值。
		 * @param	height 高绝对值。
		 * @param	offsetX X 轴偏移量（可选）。
		 * @param	offsetY Y 轴偏移量（可选）。
		 * @param	sourceWidth 原始宽度，包括被裁剪的透明区域（可选）。
		 * @param	sourceHeight 原始高度，包括被裁剪的透明区域（可选）。
		 * @param	outTexture 返回的Texture对象。
		 * @return  <code>Texture</code> 对象。
		 */
		public static function _create(source:*, x:Number, y:Number, width:Number, height:Number, offsetX:Number = 0, offsetY:Number = 0, sourceWidth:Number = 0, sourceHeight:Number = 0, outTexture:Texture = null):Texture {
			var btex:Boolean = source is Texture;
			var uv:Array = btex ? source.uv : DEF_UV;
			var bitmap:* = btex ? source.bitmap : source;
			
			if (bitmap.width && (x + width) > bitmap.width)
				width = bitmap.width - x;
			if (bitmap.height && (y + height) > bitmap.height)
				height = bitmap.height - y;
			var tex:Texture;
			if (outTexture) {
				tex = outTexture;
				tex.setTo(bitmap, null, sourceWidth || width, sourceHeight || height);
			} else {
				tex = new Texture(bitmap, null, sourceWidth || width, sourceHeight || height)
			}
			tex.width = width;
			tex.height = height;
			tex.offsetX = offsetX;
			tex.offsetY = offsetY;
			
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
			
			var bitmapScale:Number = bitmap.scaleRate;
			if (bitmapScale && bitmapScale != 1) {
				tex.sourceWidth /= bitmapScale;
				tex.sourceHeight /= bitmapScale;
				tex.width /= bitmapScale;
				tex.height /= bitmapScale;
				tex.scaleRate = bitmapScale;
			} else {
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
			if (texScaleRate != 1) {
				x *= texScaleRate;
				y *= texScaleRate;
				width *= texScaleRate;
				height *= texScaleRate;
			}
			var rect:Rectangle = Rectangle.TEMP.setTo(x - texture.offsetX, y - texture.offsetY, width, height);
			var result:Rectangle = rect.intersection(_rect1.setTo(0, 0, texture.width, texture.height), _rect2);
			if (result)
				var tex:Texture = create(texture, result.x, result.y, result.width, result.height, result.x - rect.x, result.y - rect.y, width, height);
			else
				return null;
			return tex;
		}
		
		/** @private */
		private var _w:Number = 0;
		/** @private */
		private var _h:Number = 0;
		/**@private */
		private var _destroyed:Boolean = false;
		/**@private */
		private var _bitmap:Bitmap;
		/**@private */
		private var _uv:Array;
		/**@private */
		private var _referenceCount:int = 0;
		/** @private [NATIVE]*/
		public var _nativeObj:*;
		
		/**@private 唯一ID*/
		public var $_GID:Number;
		/**沿 X 轴偏移量。*/
		public var offsetX:Number = 0;
		/**沿 Y 轴偏移量。*/
		public var offsetY:Number = 0;
		/**原始宽度（包括被裁剪的透明区域）。*/
		public var sourceWidth:Number = 0;
		/**原始高度（包括被裁剪的透明区域）。*/
		public var sourceHeight:Number = 0;
		/**图片地址*/
		public var url:String;
		/** @private */
		public var scaleRate:Number = 1;
		
		public function get uv():Array {
			return _uv;
		}
		
		public function set uv(value:Array):void {
			uvrect[0] = Math.min(value[0], value[2], value[4], value[6]);
			uvrect[1] = Math.min(value[1], value[3], value[5], value[7]);
			uvrect[2] = Math.max(value[0], value[2], value[4], value[6]) - uvrect[0];
			uvrect[3] = Math.max(value[1], value[3], value[5], value[7]) - uvrect[1];
			_uv = value;
		}
		
		/** 实际宽度。*/
		public function get width():Number {
			if (_w)
				return _w;
			if (!bitmap) return 0;
			return (uv && uv !== DEF_UV) ? (uv[2] - uv[0]) * bitmap.width : bitmap.width;
		}
		
		public function set width(value:Number):void {
			_w = value;
			sourceWidth || (sourceWidth = value);
		}
		
		/** 实际高度。*/
		public function get height():Number {
			if (_h)
				return _h;
			if (!bitmap) return 0;
			return (uv && uv !== DEF_UV) ? (uv[5] - uv[1]) * bitmap.height : bitmap.height;
		}
		
		public function set height(value:Number):void {
			_h = value;
			sourceHeight || (sourceHeight = value);
		}
		
		/**
		 * 获取位图。
		 * @return 位图。
		 */
		public function get bitmap():* {
			return _bitmap;
		}
		
		/**
		 * 设置位图。
		 * @param 位图。
		 */
		public function set bitmap(value:*):void {
			_bitmap && _bitmap._removeReference(_referenceCount);
			_bitmap = value;
			value && (value._addReference(_referenceCount));
		}
		
		/**
		 * 获取是否已经销毁。
		 * @return 是否已经销毁。
		 */
		public function get destroyed():Boolean {
			return _destroyed;
		}
		
		/**
		 * 创建一个 <code>Texture</code> 实例。
		 * @param	bitmap 位图资源。
		 * @param	uv UV 数据信息。
		 */
		public function Texture(bitmap:Bitmap = null, uv:Array = null, sourceWidth:Number = 0, sourceHeight:Number = 0) {
			setTo(bitmap, uv, sourceWidth, sourceHeight);
		}
		
		/**
		 * @private
		 */
		public function _addReference():void {
			_bitmap && _bitmap._addReference();
			_referenceCount++;
		}
		
		/**
		 * @private
		 */
		public function _removeReference():void {
			_bitmap && _bitmap._removeReference();
			_referenceCount--;
		}
		
		/**
		 * @private
		 */
		public function _getSource():* {
			if (_destroyed || !_bitmap)
				return null;
			recoverBitmap();
			return _bitmap.destroyed ? null : bitmap._getSource();
		}
		
		/**
		 * @private
		 */
		private function _onLoaded(complete:Handler, context:*):void {
			if (!context) {
			} else if (context == this) {
				
			} else if (context is Texture) {
				var tex:Texture = context;
				_create(context, 0, 0, tex.width, tex.height, 0, 0, tex.sourceWidth, tex.sourceHeight, this);
			} else {
				this.bitmap = context;
				sourceWidth = _w = context.width;
				sourceHeight = _h = context.height;
			}
			complete && complete.run();
			event(Event.READY, this);
		}
		
		/**
		 * 获取是否可以使用。
		 */
		public function getIsReady():Boolean {
			return _destroyed ? false : (_bitmap ? true : false);
		}
		
		/**
		 * 设置此对象的位图资源、UV数据信息。
		 * @param	bitmap 位图资源
		 * @param	uv UV数据信息
		 */
		public function setTo(bitmap:Bitmap = null, uv:Array = null, sourceWidth:Number = 0, sourceHeight:Number = 0):void {
			this.bitmap = bitmap;
			this.sourceWidth = sourceWidth;
			this.sourceHeight = sourceHeight;
			
			if (bitmap) {
				_w = bitmap.width;
				_h = bitmap.height;
				this.sourceWidth = this.sourceWidth || _w;
				this.sourceHeight = this.sourceHeight || _h
				var _this:Texture = this;
			}
			this.uv = uv || DEF_UV;
		}
		
		/**
		 * 加载指定地址的图片。
		 * @param	url 图片地址。
		 * @param	complete 加载完成回调
		 */
		public function load(url:String, complete:Handler = null):void {
			if (!_destroyed)
				Laya.loader.load(url, Handler.create(this, _onLoaded, [complete]), null, "htmlimage", 1, false, null, true);
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
			if (Render.isWebGL) {
				return RunDriver.getTexturePixels(this, x, y, width, height);
			} else if (Render.isConchApp) {
				return this._nativeObj.getImageData(0, 0, width, height);
			} else {
				Browser.canvas.size(width, height);
				Browser.canvas.clear();
				Browser.context.drawImage(this, -x, -y, this.width, this.height, 0, 0);
				var info:* = Browser.context.getImageData(0, 0, width, height);
				return info.data;
			}
		}
		
		/**
		 * 通过url强制恢复bitmap。
		 */
		public function recoverBitmap():void {
			if (!_destroyed && (!_bitmap || _bitmap.destroyed) && url)
				load(url);
		}
		
		/**
		 * 强制释放Bitmap,无论是否被引用。
		 */
		public function disposeBitmap():void {
			if (!_destroyed && _bitmap) {
				_bitmap.destroy();
			}
		}
		
		/**
		 * 销毁纹理。
		 */
		public function destroy():void {
			if (!_destroyed) {
				_destroyed = true;
				if (bitmap) {
					bitmap._removeReference(_referenceCount);
					bitmap = null;
				}
				if (url && this === Laya.loader.getRes(url))
					Laya.loader.clearRes(url);
			}
		}
	}
}