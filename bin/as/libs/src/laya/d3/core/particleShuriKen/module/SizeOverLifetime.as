package laya.d3.core.particleShuriKen.module {
	import laya.d3.math.Vector3;
	
	/**
	 * <code>SizeOverLifetime</code> 类用于粒子的生命周期尺寸。
	 */
	public class SizeOverLifetime {
		/**@private */
		private var _size:GradientSize;
		
		/**是否启用*/
		public var enbale:Boolean;
		
		/**
		 *获取尺寸。
		 */
		public function get size():GradientSize {
			return _size;
		}
		
		/**
		 * 创建一个 <code>SizeOverLifetime</code> 实例。
		 */
		public function SizeOverLifetime(size:GradientSize) {
			_size = size;
		}
	
	}

}