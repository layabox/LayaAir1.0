package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>SizeOverLifetime</code> 类用于粒子的生命周期尺寸。
	 */
	public class SizeOverLifetime implements IClone {
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
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destSizeOverLifetime:SizeOverLifetime = destObject as SizeOverLifetime;
			_size.cloneTo(destSizeOverLifetime._size);
			destSizeOverLifetime.enbale = enbale;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destSize:GradientSize;
			switch (_size.type) {
			case 0: 
				if (_size.separateAxes)
					destSize = GradientSize.createByGradientSeparate(_size.gradientX.clone(),_size.gradientY.clone(),_size.gradientZ.clone());
				else
					destSize = GradientSize.createByGradient(_size.gradient.clone());
				break;
			case 1: 
				if (_size.separateAxes)
					destSize = GradientSize.createByRandomTwoConstantSeparate(_size.constantMinSeparate.clone(),_size.constantMaxSeparate.clone());
				else
					destSize = GradientSize.createByRandomTwoConstant(_size.constantMin,_size.constantMax);
				break;
			case 2: 
				if (_size.separateAxes)
					destSize = GradientSize.createByRandomTwoGradientSeparate(_size.gradientXMin.clone(), _size.gradientYMin.clone(),_size.gradientZMin.clone(),_size.gradientXMax.clone(), _size.gradientYMax.clone(),_size.gradientZMax.clone());
				else
					destSize = GradientSize.createByRandomTwoGradient(_size.gradientMin.clone(), _size.gradientMax.clone());
				break;
			}
			
			var destSizeOverLifetime:SizeOverLifetime = __JS__("new this.constructor(destSize)");
			destSizeOverLifetime.enbale = enbale;
			return destSizeOverLifetime;
		}
	
	}

}