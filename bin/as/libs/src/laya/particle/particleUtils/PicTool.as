package laya.particle.particleUtils {
	import laya.renders.Render;
	import laya.resource.HTMLCanvas;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	public class PicTool {
		
		public static function getCanvasPic(img:*, color:int):* {
			img = img.bitmap;
			var canvas:HTMLCanvas = new HTMLCanvas("2D");
			var ctx:* = canvas.getContext('2d');
			canvas.size(img.width, img.height);
		    var red:int = (color >> 16 & 0xFF);
			var green:int = (color >> 8 & 0xFF);
			var blue:int = (color & 0xFF);
			if(Render.isConchApp)
			{
				ctx.setFilter(red/255,green/255,blue/255,0);
			}
			ctx.drawImage(img.source, 0, 0);
			if (!Render.isConchApp)
			{
				var imgdata:* = ctx.getImageData(0, 0, canvas.width, canvas.height);
				var data:* = imgdata.data;

				
				for (var i:int = 0, n:int = data.length; i < n; i += 4) {
					if (data[i + 3] == 0) continue;
					data[i] = red;
					data[i + 1] = green;
					data[i + 2] = blue;
				}
				ctx.putImageData(imgdata, 0, 0);
			}
			return canvas;
		}
		
		public static function getRGBPic(img:*):Array {
			var rst:Array;
			rst = [new Texture(getCanvasPic(img, 0xFF0000)), new Texture(getCanvasPic(img, 0x00FF00)), new Texture(getCanvasPic(img, 0x0000FF))];
			return rst;
		}
	}
}