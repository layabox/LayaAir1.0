package {
	
	/**
	 * ...
	 * @author laya
	 */
	public class Config {
		//是否显示log信息
		public static var showLog:Boolean=false;
		public static var atlasEnable:Boolean = false;
		public static var atlasLimitWidth:int =0;
		public static var atlasLimitHeight:int = 0;
		//显示cacheAs的标记，常用于调试
		public static var showCanvasMark:Boolean = false;
		//内存限制
		public static var CPUMemoryLimit:int = 120 * 1024 * 1024;
		public static var GPUMemoryLimit:int = 160 * 1024 * 1024;
		
		/**默认动画播放时间间隔，单位为毫秒*/
		public static var animationInterval:int = 30;
	}
}