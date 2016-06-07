package laya.resource 
{
	/**
	 * @private
	 */
	public class HTMLSubImage extends Bitmap
	{
		public static var create:Function = function(canvas:*, offsetX:int, offsetY:int, width:int, height:int, atlasImage:*, src:String, allowMerageInAtlas:Boolean = false):HTMLSubImage
		{
			return new HTMLSubImage(canvas, offsetX, offsetY, width, height, atlasImage, src, allowMerageInAtlas);
		}
		
		//请不要直接使用new HTMLSubImage
		public function HTMLSubImage(canvas:*, offsetX:int, offsetY:int, width:int, height:int, atlasImage:*, src:String, allowMerageInAtlas:Boolean) 
		{
			throw new Error("不允许new！");
		}
		
	}

}