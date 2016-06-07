package laya.ani.bone {
	import laya.ani.bone.Skeleton;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	
	/**
	 * <p> <code>SkeletonPlayer</code> 用于播放经过工具处理后的骨骼动画。</p>
	 */
	public class SkeletonPlayer extends Skeleton {
		/**
		 * 播放完成函数处理器。
		 */
		public var completeHandler:Handler;
		/**
		 * 骨骼动画的数据资源地址。
		 */
		public var dataUrl:String;
		/**
		 * 骨骼动画的图片资源地址。
		 */
		public var imgUrl:String;
		
		/**
		 * 创建一个 <code>SkeletonPlayer</code> 实例。
		 * @param	tmplete  数据模板 Templet 对象。
		 */
		public function SkeletonPlayer(tmplete:* = null) {
			super(tmplete);
			this.on(Event.COMPLETE, this, _complete);
		}
		
		private function _complete():void {
			if (completeHandler) {
				var tHd:Handler;
				tHd = completeHandler;
				completeHandler = null;
				tHd.run();
				
			}
		}
		
		/**
		 * 资源地址。
		 */
		public function set url(path:String):void {
			load(path);
		}
		
		/**
		 * 加载资源。
		 * @param	baseURL 资源地址。
		 */
		public function load(baseURL:String):void {
			dataUrl = baseURL;
			imgUrl = baseURL.replace(".sk", ".png");
			Laya.loader.load([{url: dataUrl, type: Loader.BUFFER}, {url: imgUrl, type: Loader.IMAGE}], Handler.create(this, _resLoaded));
		}
		
		private function _resLoaded():void {
			var _templet:Templet
			_templet = new Templet();
			_templet.parseData(Loader.getRes(imgUrl), Loader.getRes(dataUrl));
			init(_templet, _templet.rate);
		}
	}

}