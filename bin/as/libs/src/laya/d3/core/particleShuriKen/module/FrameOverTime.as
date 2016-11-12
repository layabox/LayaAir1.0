package laya.d3.core.particleShuriKen.module {
	import laya.d3.math.Vector3;
	
	/**
	 * <code>FrameOverTime</code> 类用于创建时间帧。
	 */
	public class FrameOverTime {
		/**
		 * 通过固定帧创建一个 <code>FrameOverTime</code> 实例。
		 * @param	constant 固定帧。
		 * @return 时间帧。
		 */
		public static function createByConstant(constant:Number):FrameOverTime {
			var rotationOverLifetime:FrameOverTime = new FrameOverTime();
			rotationOverLifetime._type = 0;
			rotationOverLifetime._constant = constant;
			return rotationOverLifetime;
		}
		
		/**
		 * 通过时间帧创建一个 <code>FrameOverTime</code> 实例。
		 * @param	overTime 时间帧。
		 * @return 时间帧。
		 */
		public static function createByOverTime(overTime:GradientDataInt):FrameOverTime {
			var rotationOverLifetime:FrameOverTime = new FrameOverTime();
			rotationOverLifetime._type = 1;
			rotationOverLifetime._overTime = overTime;
			return rotationOverLifetime;
		}
		
		/**
		 * 通过随机双固定帧创建一个 <code>FrameOverTime</code> 实例。
		 * @param	constantMin 最小固定帧。
		 * @param	constantMax 最大固定帧。
		 * @return 时间帧。
		 */
		public static function createByRandomTwoConstant(constantMin:Number, constantMax:Number):FrameOverTime {
			var rotationOverLifetime:FrameOverTime = new FrameOverTime();
			rotationOverLifetime._type = 2;
			rotationOverLifetime._constantMin = constantMin;
			rotationOverLifetime._constantMax = constantMax;
			return rotationOverLifetime;
		}
		
		/**
		 * 通过随机双时间帧创建一个 <code>FrameOverTime</code> 实例。
		 * @param	gradientFrameMin 最小时间帧。
		 * @param	gradientFrameMax 最大时间帧。
		 * @return 时间帧。
		 */
		public static function createByRandomTwoOverTime(gradientFrameMin:GradientDataInt, gradientFrameMax:GradientDataInt):FrameOverTime {
			var rotationOverLifetime:FrameOverTime = new FrameOverTime();
			rotationOverLifetime._type = 3;
			rotationOverLifetime._overTimeMin = gradientFrameMin;
			rotationOverLifetime._overTimeMax = gradientFrameMax;
			return rotationOverLifetime;
		}
		
		/**@private */
		private var _type:int;
		
		/**@private */
		private var _constant:int;
		
		/**@private */
		private var _overTime:GradientDataInt;
		
		/**@private */
		private var _constantMin:int;
		/**@private */
		private var _constantMax:int;
		
		/**@private */
		private var _overTimeMin:GradientDataInt;
		/**@private */
		private var _overTimeMax:GradientDataInt;
		
		/**
		 *生命周期旋转类型,0常量模式，1曲线模式，2随机双常量模式，3随机双曲线模式。
		 */
		public function get type():int {
			return _type;
		}
		
		/**
		 * 固定帧。
		 */
		public function get constant():int {
			return _constant;
		}
		
		/**
		 * 时间帧。
		 */
		public function get frameOverTimeData():GradientDataInt {
			return _overTime;
		}
		
		/**
		 * 最小固定帧。
		 */
		public function get constantMin():int {
			return _constantMin;
		}
		
		/**
		 * 最大固定帧。
		 */
		public function get constantMax():int {
			return _constantMax;
		}
		
		/**
		 * 最小时间帧。
		 */
		public function get frameOverTimeDataMin():GradientDataInt {
			return _overTimeMin;
		}
		
		/**
		 * 最大时间帧。
		 */
		public function get frameOverTimeDataMax():GradientDataInt {
			return _overTimeMax;
		}
		
		/**
		 * 创建一个 <code>FrameOverTime,不允许new，请使用静态创建函数。</code> 实例。
		 */
		public function FrameOverTime() {
		
		}
	
	}

}