package laya.d3.core.render {
	import laya.d3.core.Sprite3D;
	
	/**
	 * <code>RenderClip</code> 类用于实现渲染裁剪。
	 */
	public class RenderClip {
		
		/**
		 * 创建一个 <code>RenderClip</code> 实例。
		 */
		public function RenderClip() {
		
		}
		
		/**
		 * 处理3D物理是否可见。
		 * @param o 3D精灵。
		 */
		public function view(o:Sprite3D):Boolean {
			return true;
		}
	
	}

}