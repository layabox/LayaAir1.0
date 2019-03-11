package laya.d3.resource {
	import laya.renders.Render;
	import laya.webgl.resource.BaseTexture;
	import laya.webgl.resource.Texture2D;
	
	/**
	 * ...
	 * @author
	 */
	public class TextureGenerator {
		
		public function TextureGenerator() {
		
		}
		
		public static function lightAttenTexture(x:int, y:int, maxX:int, maxY:int, index:int, data:Uint8Array):void {
			
			var sqrRange:Number = x / maxX;
			var atten:Number = 1.0 / (1.0 + 25.0 * sqrRange);
			if (sqrRange >= 0.64) {
				if (sqrRange > 1.0) {
					atten = 0;
				} else {
					atten *= 1 - (sqrRange - 0.64) / (1 - 0.64);
				}
			}
			data[index] = Math.floor(atten * 255.0 + 0.5);
		}
		
		public static function haloTexture(x:int, y:int, maxX:int, maxY:int, index:int, data:Uint8Array):void {
			
			maxX >>= 1;
			maxY >>= 1;
			var xFac:Number = (x - maxX) / maxX;
			var yFac:Number = (y - maxY) / maxY;
			var sqrRange:Number = xFac * xFac + yFac * yFac;
			if (sqrRange > 1.0) {
				sqrRange = 1.0;
			}
			data[index] = Math.floor((1.0 - sqrRange) * 255.0 + 0.5);
		}
		
		public static function _generateTexture2D(texture:Texture2D, textureWidth:int, textureHeight:int, func:Function):void {
			var index:int = 0;
			var size:int = 0;
			switch (texture.format) {
			case BaseTexture.FORMAT_R8G8B8: 
				size = 3;
				break;
			case BaseTexture.FORMAT_R8G8B8A8: 
				size = 4;
				break;
			case BaseTexture.FORMAT_ALPHA8: 
				size = 1;
				break;
			default: 
				throw "GeneratedTexture._generateTexture: unkonw texture format.";
			}

			var data:Uint8Array = new Uint8Array(textureWidth * textureHeight * size);
			for (var y:int = 0; y < textureHeight; y++) {
				for (var x:int = 0; x < textureWidth; x++) {
					func(x, y, textureWidth, textureHeight, index, data);
					index += size;
				}
			}
			texture.setPixels(data);
		}
	
	}

}