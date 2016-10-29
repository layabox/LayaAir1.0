package {
	
	/**
	 *  Config 用于配置一些全局参数。
	 */
	public class Config {
		 
		/**
		 * WebGL模式下文本缓存最大数量。
		 */
		public static var WebGLTextCacheCount:int = 500; 
		
		/**
		 * 表示是否使用了大图合集功能。
		 */
		public static var atlasEnable:Boolean = false;
		/**
		 * 是否显示画布图边框，用于调试。
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
		public static var animationInterval:int = 50;
		/**
		 * 设置是否抗锯齿，只对2D(WebGL)、3D有效。
		 */
		public static var isAntialias:Boolean = false;
		
	}
}