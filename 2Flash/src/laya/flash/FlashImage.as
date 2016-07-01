/*[IF-FLASH]*/
package laya.flash {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author laya
	 */
	public class FlashImage extends EventDispatcher {
		public static var tempRectangle:Rectangle;
		public static var tempPoint:Point;
		
		public var onload:Function;
		public var onerror:Function;
		public var bitmap:Bitmap;
		
		private var _w:Number;
		private var _h:Number;
		
		private var _src:String;
		
		public var crossOrigin : *= null;
		
		public function FlashImage() {
		
		}
		
		public function set width(value:Number):void {
			_w = value;
		}
		
		public function get width():Number {
			return _w;
		}
		
		public function set height(value:Number):void {
			_h = value;
		}
		
		public function get height():Number {
			return _h;
		}
		
		public function get bitmapdata():BitmapData {
			return bitmap.bitmapData;
		}
		
		private function _to2(x:Number):Number {
			x--;
			x |= x >> 1;
			x |= x >> 2;
			x |= x >> 4;
			x |= x >> 8;
			x |= x >> 16;
			x++;
			return x;
		}
		
		public function set src(value:String):void {
			_src = value;
			var tl:Loader = new Loader();
			tl.contentLoaderInfo.addEventListener(Event.COMPLETE, function cload(_ev:Event):void {
				var image:Bitmap = bitmap = tl.content as Bitmap;
				_w = image.width;
				_h = image.height;
				onload && onload();
			});
			tl.load(new URLRequest(value));
		}
		
		public function createCanvas(w:int, h:int):void {
			if (_src) {
				throw new Error("src不能有任何值");
			}
			bitmap = new Bitmap();
			bitmap.bitmapData = new BitmapData(w, h, true, 0x00000000);
			//bitmap.width = w;
			//bitmap.height = h;	
		}
		
		public function copyPixels(sourceBitmapData:BitmapData, sourceX:int, sourceY:int, sourceWidth:int, sourceHeight:int, destX:int, destY:int):void {
			(tempRectangle) || (tempRectangle = new Rectangle());
			(tempPoint) || (tempPoint = new Point());
			tempRectangle.x = sourceX;
			tempRectangle.y = sourceY;
			tempRectangle.width = sourceWidth;
			tempRectangle.height = sourceHeight;
			tempPoint.x = destX;
			tempPoint.y = destY;
			
			bitmap.bitmapData.copyPixels(sourceBitmapData, tempRectangle, tempPoint);
		}
		
		public function get src():String {
			return _src;
		}
	
	}

}