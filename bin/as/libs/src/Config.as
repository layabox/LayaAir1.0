package {
	
	/**
	 *  Config 用于配置一些全局参数。如需更改，请在初始化引擎之前设置。
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
		 * 动画 Animation 的默认播放时间间隔，单位为毫秒。
		 */
		public static var animationInterval:int = 50;
		/**
		 * 设置是否抗锯齿，只对2D(WebGL)、3D有效。
		 */
		public static var isAntialias:Boolean = false;
		/**
		 * 设置画布是否透明，只对2D(WebGL)、3D有效。
		 */
		public static var isAlpha:Boolean = false;
		/**
		 * 设置画布是否预乘，只对2D(WebGL)、3D有效。
		 */
		public static var premultipliedAlpha:Boolean = true;
		/**
		 * 设置画布的模板缓冲，只对2D(WebGL)、3D有效。
		 */
		public static var isStencil:Boolean = true;
		/**
		 * 是否强制WebGL同步刷新。
		 */
		public static var preserveDrawingBuffer:Boolean = false;
	}
}