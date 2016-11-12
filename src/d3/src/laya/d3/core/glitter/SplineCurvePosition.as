package laya.d3.core.glitter {
	import laya.d3.math.Vector3;
	
	/**
	 * <code>SplineCurvePosition</code> 类用于通过顶点创建闪光插值。
	 */
	public class SplineCurvePosition extends SplineCurvePositionVelocity {
		
		/**
		 * 创建一个 <code>SplineCurvePosition</code> 实例。
		 */
		public function SplineCurvePosition() {
			//为了应用上面的插值方法，当已知4个控制点(x0,x1,x2,x3)时，需要推倒出x1,x2点的速率矢量。
			//假定每个控制点经过的时间相同，则有
			//则在已知x2,x0点的速度，可得x1点的速率是
			//(x2 - x0) * 0.5f
		}
		
		/**
		 * @private
		 * 计算速度。
		 */
		private function _CalcVelocity(left:Vector3, right:Vector3, out:Vector3):void {
			Vector3.subtract(left, right, out);
			Vector3.scale(out, 0.5, out);
		}
		
		/**
		 * 初始化插值所需信息。
		 * @param	lastPosition0 顶点0的上次位置。
		 * @param	position0 顶点0的位置。
		 * @param	lastPosition1 顶点1的上次位置。
		 * @param	position1 顶点1的位置。
		 */
		override public function Init(lastPosition0:Vector3, position0:Vector3, lastPosition1:Vector3, position1:Vector3):void {
			_CalcVelocity(position0, lastPosition0, _tempVector30);
			_CalcVelocity(position1, lastPosition1, _tempVector31);
			super.Init(position0, _tempVector30, position1, _tempVector31);
		}
	}

}