package laya.d3.core.particleShuriKen.module {
	import laya.d3.core.IClone;
	
	/**
	 * <code>StartFrame</code> 类用于创建开始帧。
	 */
	public class StartFrame implements IClone {
		/**
		 * 通过随机常量旋转创建一个 <code>StartFrame</code> 实例。
		 * @param	constant  固定帧。
		 * @return 开始帧。
		 */
		public static function createByConstant(constant:Number):StartFrame {
			var rotationOverLifetime:StartFrame = new StartFrame();
			rotationOverLifetime._type = 0;
			rotationOverLifetime._constant = constant;
			return rotationOverLifetime;
		}
		
		/**
		 *  通过随机双常量旋转创建一个 <code>StartFrame</code> 实例。
		 * @param	constantMin 最小固定帧。
		 * @param	constantMax 最大固定帧。
		 * @return 开始帧。
		 */
		public static function createByRandomTwoConstant(constantMin:Number, constantMax:Number):StartFrame {
			var rotationOverLifetime:StartFrame = new StartFrame();
			rotationOverLifetime._type = 1;
			rotationOverLifetime._constantMin = constantMin;
			rotationOverLifetime._constantMax = constantMax;
			return rotationOverLifetime;
		}
		
		/**@private */
		private var _type:int;
		
		/**@private */
		private var _constant:Number;
		
		/**@private */
		private var _constantMin:Number;
		/**@private */
		private var _constantMax:Number;
		
		/**
		 *开始帧类型,0常量模式，1随机双常量模式。
		 */
		public function get type():int {
			return _type;
		}
		
		/**
		 * 固定帧。
		 */
		public function get constant():Number {
			return _constant;
		}
		
		/**
		 * 最小固定帧。
		 */
		public function get constantMin():Number {
			return _constantMin;
		}
		
		/**
		 * 最大固定帧。
		 */
		public function get constantMax():Number {
			return _constantMax;
		}
		
		/**
		 * 创建一个 <code>StartFrame,不允许new，请使用静态创建函数。</code> 实例。
		 */
		public function StartFrame() {
		
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destStartFrame:StartFrame = destObject as StartFrame;
			destStartFrame._type = _type;
			destStartFrame._constant = _constant;
			destStartFrame._constantMin = _constantMin;
			destStartFrame._constantMax = _constantMax;
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destStartFrame:StartFrame = __JS__("new this.constructor()");
			cloneTo(destStartFrame);
			return destStartFrame;
		}
	
	}

}