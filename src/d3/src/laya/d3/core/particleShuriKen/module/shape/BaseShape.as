package laya.d3.core.particleShuriKen.module.shape {
	import laya.d3.core.IClone;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Rand;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>BaseShape</code> 类用于粒子形状。
	 */
	public class BaseShape implements IClone {
		/**是否启用。*/
		public var enable:Boolean;
		/**随机方向。*/
		public var randomDirection:Boolean;
		
		/**
		 * 创建一个 <code>BaseShape</code> 实例。
		 */
		public function BaseShape() {
		}
		
		/**@private */
		protected function _getShapeBoundBox(boundBox:BoundBox):void {
			throw new Error("BaseShape: must override it.");
		}
		
		/**@private */
		protected function _getSpeedBoundBox(boundBox:BoundBox):void {
			throw new Error("BaseShape: must override it.");
		}
		
		/**
		 * 用于生成粒子初始位置和方向。
		 * @param	position 粒子位置。
		 * @param	direction 粒子方向。
		 */
		public function generatePositionAndDirection(position:Vector3, direction:Vector3, rand:Rand = null, randomSeeds:Uint32Array = null):void {
			throw new Error("BaseShape: must override it.");
		}
		
		/** 
		 * @private 
		 */
		public function _calculateProceduralBounds(boundBox:BoundBox, emitterPosScale:Vector3, minMaxBounds:Vector2):void {
			_getShapeBoundBox(boundBox);
		
			var min:Vector3 = boundBox.min;
			var max:Vector3 = boundBox.max;
			Vector3.multiply(min, emitterPosScale,min);
			Vector3.multiply(max, emitterPosScale, max);
			
			var speedBounds:BoundBox = new BoundBox(new Vector3(),new Vector3());
			if (randomDirection/* && (m_Type != kCone) && (m_Type != kConeShell)*/)//TODO:randomDirection应换成0到1
			{
				speedBounds.min = new Vector3(-1, -1, -1);
				speedBounds.max = new Vector3(1, 1, 1);
				//minMaxBounds = Abs(minMaxBounds);
			}
			else
			{
				_getSpeedBoundBox(speedBounds);
			}
			
			
			var  maxSpeedBound:BoundBox = new BoundBox(new Vector3(),new Vector3());
			var maxSpeedMin:Vector3 = maxSpeedBound.min;
			var maxSpeedMax:Vector3 = maxSpeedBound.max;
			Vector3.scale(speedBounds.min, minMaxBounds.y, maxSpeedMin);
			Vector3.scale(speedBounds.max, minMaxBounds.y, maxSpeedMax);
			Vector3.add(boundBox.min, maxSpeedMin, maxSpeedMin);
			Vector3.add(boundBox.max, maxSpeedMax, maxSpeedMax);
			
			Vector3.min(boundBox.min, maxSpeedMin, boundBox.min);
			Vector3.max(boundBox.max, maxSpeedMin, boundBox.max);
			
			
			var  minSpeedBound:BoundBox = new BoundBox(new Vector3(),new Vector3());
			var minSpeedMin:Vector3 = minSpeedBound.min;
			var minSpeedMax:Vector3 = minSpeedBound.max;
			Vector3.scale(speedBounds.min, minMaxBounds.x, minSpeedMin);
			Vector3.scale(speedBounds.max, minMaxBounds.x, minSpeedMax);
			
			Vector3.min(minSpeedBound.min, minSpeedMax, maxSpeedMin);
			Vector3.max(minSpeedBound.min, minSpeedMax, maxSpeedMax);
			
			Vector3.min(boundBox.min, maxSpeedMin, boundBox.min);
			Vector3.max(boundBox.max, maxSpeedMin, boundBox.max);
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {
			var destShape:BaseShape = destObject as BaseShape;
			destShape.enable = enable;
		
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {
			var destShape:Vector3 = __JS__("new this.constructor()");
			cloneTo(destShape);
			return destShape;
		}
	
	}

}