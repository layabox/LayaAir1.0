package {
	
	/**
	 *  Config 用于配置一些全局参数。
	 */
	public class Config {
		/**
		 * 是否显示 log 信息。
		 */public static var showLog:Boolean = false;
		/**
		 * 表示是否使用了大图合集功能。
		 */
		public static var atlasEnable:Boolean = false;
		/**
		 * 是否显示遮罩图边框。
		 */
		public static var showCanvasMark:Boolean = false;
		/**
		 * CPU 内存限制。
		 */
		public static var CPUMemoryLimit:int = 120 * 1024 * 1024;
		/**
		 * GPU 内存限制。
		 */
		public static var GPUMemoryLimit:int = 160 * 1024 * 1024;
		/**
		 * 动画 Animation 的默认播放时间间隔，单位为毫秒。
		 */
		public static var animationInterval:int = 30;
	}
}