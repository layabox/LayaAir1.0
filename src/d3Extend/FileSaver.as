package laya.d3Extend 
{
	import laya.utils.Browser;
	
	/**
	 * ...
	 * @author ww
	 */
	public class FileSaver
	{
		
		public function FileSaver()
		{
		
		}
		public static function dataURLtoBlob(dataurl:String):*
		{
			var arr:Array = dataurl.split(',');
			var mime:String = arr[0].match(/:(.*?);/)[1];
			var bstr:String = Browser.window.atob(arr[1]);
			var n:int = bstr.length;
			var u8arr:Uint8Array = new Uint8Array(n);
			while (n--)
			{
				u8arr[n] = bstr.charCodeAt(n);
			}
			return new (createBlob([u8arr], {type: mime}) as Class);
		}
		
		public static function createBlob(arr:Array, option:Object):*
		{
			var blob:*;
			__JS__('blob = new Blob(arr, option);');
			return blob;
		}
		
		public static function saveBlob(blob:*, filename:String):void
		{
			Browser.window.saveAs(blob, filename);
		}
		public static function saveTxtFile(filename:String, content:String):void
		{ //保存
			saveBlob(createBlob([content],{type: "text/plain;charset=utf-8"}),filename);
		}
		public static function saveCanvas(filename:String, canvas:*):void
		{
			var dataurl:String = canvas.toDataURL('image/png');
			var blob:*= dataURLtoBlob(dataurl);
			saveBlob(blob, filename);
		}
	}

}