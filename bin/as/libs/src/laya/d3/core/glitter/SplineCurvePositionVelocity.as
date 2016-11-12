package laya.d3.core.glitter {
	import laya.d3.math.Vector3;
	
	/**
	 * <code>SplineCurvePositionVelocity</code> 类用于通过顶点和速度创建闪光插值。
	 */
	public class SplineCurvePositionVelocity {
		
		/** @private */
		protected var _tempVector30:Vector3 = new Vector3();
		/** @private */
		protected var _tempVector31:Vector3 = new Vector3();
		/** @private */
		protected var _tempVector32:Vector3 = new Vector3();
		
		/** @private */
		protected var _a:Vector3 = new Vector3();
		/** @private */
		protected var _b:Vector3 = new Vector3();
		/** @private */
		protected var _c:Vector3 = new Vector3();
		/** @private */
		protected var _d:Vector3 = new Vector3();
		
		//根据首尾点的位置(x0,x1)和速度矢量(y0,y1)插值出一条曲线，满足首尾点通过控制点
		//由于有四个已知常量，故考虑使用下面的函数
		//f(t) = a * t ^ 3 + b * t ^ 2 + c * t + d		[0 <= t <= 1]
		//则
		//f'(t) = 3 * a * t ^ 2 + 2 * b * t + c
		//所以
		//f(0) = d = position0
		//f(1) = a + b + c + d = position1
		//f'(0) = c = velocity0
		//f'(1) = 3 * a + 2 * b + c = velocity1
		//联合上面四个式子可解得
		//a = 2 * x0 - 2 * x1 + y0 + y1
		//b = 3 * x1 - 3 * x0 - y1 - 2 * y0
		//c = y0
		//d = x0
		
		/**
		 * 创建一个 <code>SplineCurvePositionVelocity</code> 实例。
		 */
		public function SplineCurvePositionVelocity() {
		
		}
		
		/**
		 * 初始化插值所需信息。
		 * @param	position0 顶点0的位置。
		 * @param	velocity0 顶点0的速度。
		 * @param	position1 顶点1的位置。
		 * @param	velocity1 顶点1的速度。
		 */
		public function Init(position0:Vector3, velocity0:Vector3, position1:Vector3, velocity1:Vector3):void {
			position0.cloneTo(_d);
			velocity0.cloneTo(_c);
			
			Vector3.scale(position0, 2.0, _a);
			Vector3.scale(position1, 2.0, _tempVector30);
			Vector3.subtract(_a, _tempVector30, _a);
			Vector3.add(_a, velocity0, _a);
			Vector3.add(_a, velocity1, _a);
			
			Vector3.scale(position1, 3.0, _b);
			Vector3.scale(position0, 3.0, _tempVector30);
			Vector3.subtract(_b, _tempVector30, _b);
			Vector3.subtract(_b, velocity1, _b);
			Vector3.scale(velocity0, 2.0, _tempVector30);
			Vector3.subtract(_b, _tempVector30, _b);
		
			//d = x0;
			//c = y0;
			//a = 2.0f * x0 - 2.0f * x1 + y0 +  y1;
			//b = 3.0f * x1 - 3.0f * x0 - y1 - 2.0f * y0;
		}
		
		/**
		 * 初始化插值所需信息。
		 * @param	t 插值比例
		 * @param	out 输出结果
		 */
		public function Slerp(t:Number, out:Vector3):void {
			Vector3.scale(_a, t * t * t, _tempVector30);
			Vector3.scale(_b, t * t, _tempVector31);
			Vector3.scale(_c, t, _tempVector32);
			Vector3.add(_tempVector30, _tempVector31, out);
			Vector3.add(out, _tempVector32, out);
			Vector3.add(out, _d, out);
		
			//return a * t * t * t + b * t * t + c * t + d;
		}
	}

}