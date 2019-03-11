package laya.device.media
{
	import laya.resource.Bitmap;
	import laya.utils.Browser;
	
	/**
	 * @private
	 */
	public class HtmlVideo extends Bitmap
	{
		protected var video:*;
		protected var _source:*;
		public function HtmlVideo()
		{
			super();
			
			_width = 1;
			_height = 1;
			
			createDomElement();
		}
		
		public static var create:Function = function():HtmlVideo
		{
			return new HtmlVideo();
		}
		
		private function createDomElement():void
		{
			_source = video = Browser.createElement("video");
			
			var style:* = video.style;
			style.position = 'absolute';
			style.top = '0px';
			style.left = '0px';
			
			video.addEventListener("loadedmetadata", (function():void
			{
				this._w = video.videoWidth;
				this._h = video.videoHeight;
			})['bind'](this));
		}
		
		public function setSource(url:String, extension:int):void
		{
			while(video.childElementCount)
				video.firstChild.remove();
			
			if (extension & Video.MP4)
				appendSource(url, "video/mp4");
			if (extension & Video.OGG)
				appendSource(url + ".ogg", "video/ogg");
		}
		
		private function appendSource(source:String, type:String):void
		{
			var sourceElement:* = Browser.createElement("source");
			sourceElement.src = source;
			sourceElement.type = type;
			video.appendChild(sourceElement);
		}
		
		public function getVideo():*
		{
			return video;
		}
		
		override public function _getSource():*
		{
			// TODO Auto Generated method stub
			return _source;
		}
		
		
	}
}