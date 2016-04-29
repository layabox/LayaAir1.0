package laya.ani.bone 
{
	import laya.ani.bone.Skeleton;
	import laya.ani.bone.Templet;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author ww
	 */
	public class SkeletonPlayer extends Skeleton 
	{
		public var completeHandler:Handler;
		public var dataUrl:String;
		public var imgUrl:String;
		
		public function SkeletonPlayer(tmplete:*=null) 
		{
			super(tmplete);
			this.on(Event.COMPLETE, this, _complete);
		}
		
		private function _complete():void
		{
			if (completeHandler)
			{
				var tHd:Handler;
				tHd = completeHandler;
				completeHandler = null;
				tHd.run();
				
			}
		}
		public function set skin(path:String):void
		{
			load(path);
		}
		
		public function load(baseURL:String):void
		{
			dataUrl = baseURL;		
			imgUrl = baseURL.replace(".sk",".png");
			Laya.loader.load( [ { url:dataUrl, type:Loader.BUFFER },{ url:imgUrl, type:Loader.IMAGE } ], Handler.create(this,_resLoaded));
		}
		
		private function _resLoaded():void
		{
			_tp_ = new Templet(Loader.getRes(dataUrl), Loader.getRes(imgUrl));
			setTpl(_tp_);
			play();
		}
	}

}