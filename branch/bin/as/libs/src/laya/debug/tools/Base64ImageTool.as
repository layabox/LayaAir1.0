package laya.debug.tools 
{
	import laya.net.Loader;
	import laya.resource.Texture;
	import laya.utils.Browser;
	/**
	 * ...
	 * @author ww
	 */
	public class Base64ImageTool 
	{
		
		public function Base64ImageTool() 
		{
			
		}
		public static function getCanvasPic(img:Texture):*
		{
			img=img.bitmap;
			//var canvas:*= Browser.createElement("syscanvas");
			var canvas:*=Browser.createElement("canvas");
			var ctx:*=canvas.getContext('2d');
			
			canvas.height=img.height;
			canvas.width=img.width;
			ctx.drawImage(img.source,0,0);
			return canvas;
		}
		public static function getBase64Pic(img:Texture):String
		{
			return getCanvasPic(img).toDataURL("image/png");
		}
		
		public static function getPreloads(base64Data:Object):Array
		{
			var rst:Array;
			rst = [];
			var key:String;
			for (key in base64Data)
			{
				rst.push( { url: base64Data[key], type: Loader.IMAGE } );
			}
			return rst;
		}
	}

}