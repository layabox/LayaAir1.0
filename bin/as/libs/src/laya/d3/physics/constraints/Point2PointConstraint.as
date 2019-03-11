package laya.d3.physics.constraints {
	import laya.d3.math.Vector3;
	
	/**
	 * <code>Point2PointConstraint</code> 类用于创建物理组件的父类。
	 */
	public class Point2PointConstraint {
		/**@private */
		private var _pivotInA:Vector3 = new Vector3();
		/**@private */
		private var _pivotInB:Vector3 = new Vector3();
		/**@private */
		private var _damping:Number;
		/**@private */
		private var _impulseClamp:Number;
		/**@private */
		private var _tau:Number;
		
		public function get pivotInA():Vector3 {
			return _pivotInA;
		}
		
		public function set pivotInA(value:Vector3):void {
			_pivotInA = value;
		}
		
		public function get pivotInB():Vector3 {
			return _pivotInB;
		}
		
		public function set pivotInB(value:Vector3):void {
			_pivotInB = value;
		}
		
		public function get damping():Number {
			return _damping;
		}
		
		public function set damping(value:Number):void {
			_damping = value;
		}
		
		public function get impulseClamp():Number {
			return _impulseClamp;
		}
		
		public function set impulseClamp(value:Number):void {
			_impulseClamp = value;
		}
		
		public function get tau():Number {
			return _tau;
		}
		
		public function set tau(value:Number):void {
			_tau = value;
		}
		
		/**
		 * 创建一个 <code>Point2PointConstraint</code> 实例。
		 */
		public function Point2PointConstraint() {
		
		}
	
	}

}