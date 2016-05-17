package laya.particle.particleUtils
{
	import laya.utils.Browser;
	import laya.resource.Texture;
	
	/**
	 * 
	 * @private
	 * 
	 * @created  2015-8-26 下午7:22:26
	 */
	public class PicTool
	{
		public function PicTool()
		{
		}
		public static function getCanvasPic(img:*,color:int):*
		{
			img=img.bitmap;
			//var canvas:*= Browser.createElement("syscanvas");
			var canvas:*=Browser.createElement("canvas");
			var ctx:*=canvas.getContext('2d');
			
			canvas.height=img.height;
			canvas.width=img.width;
			ctx.drawImage(img.source,0,0);
			var imgdata:*=ctx.getImageData(0,0,canvas.width,canvas.height);
			var data:*=imgdata.data;
			var red:int = (color >> 16 & 0xFF);
			var green:int = (color >> 8 & 0xFF);
			var blue:int = (color & 0xFF) ;

			for(var i:int=0,n:int=data.length;i<n;i+=4){
				if(data[i+3]==0) continue;
				data[i]=red;
				data[i+1]=green;
				data[i+2]=blue;
			}
			ctx.putImageData(imgdata, 0, 0);
			canvas.source = canvas;
			return canvas;
//			var imgSrc =canvas.toDataURL("image/png");
//			var img:*=Browser.createElement("img");
//			img.src=imgSrc;
//			return img;
		}
		public static function getRGBPic(img:*):Array
		{
			var rst:Array;
			rst=[new Texture(getCanvasPic(img,0xFF0000)),new Texture(getCanvasPic(img,0x00FF00)),new Texture(getCanvasPic(img,0x0000FF))];
			return rst;
		}
	}
}