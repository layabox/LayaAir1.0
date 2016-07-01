package laya.d3.core.render {
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>RenderConfig</code> 类用于实现渲染配置。
	 */
	public class RenderConfig {
		/**是否进行深度测试。*/
		public var depthTest:Boolean = true;
		/**深度遮罩。*/
		public var depthMask:int = 1;
		
		//public  var depthFunc:int = -1;// Write it!!!
		
		/**是否透明混合。*/
		public var blend:Boolean = false;
		/**透明混合源混值。*/
		public var sFactor:int = WebGLContext.ONE;
		/**透明混合目标值。*/
		public var dFactor:int = WebGLContext.ZERO;
		/**是否单面渲染。*/
		public var cullFace:Boolean = true;
		/**渲染顺序。*/
		public var frontFace:int = WebGLContext.CW;
		
		/**
		 * 创建一个 <code>RenderConfig</code> 实例。
		 */
		public function RenderConfig() {
		
		}
	
	}

}