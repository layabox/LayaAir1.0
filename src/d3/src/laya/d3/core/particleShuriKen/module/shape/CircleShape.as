package laya.d3.core.particleShuriKen.module.shape {
	import laya.d3.math.BoundBox;
	import laya.d3.math.Rand;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>CircleShape</code> 类用于创建环形粒子形状。
	 */
	public class CircleShape extends BaseShape {
		/** @private */
		protected static var _tempPositionPoint:Vector2 = new Vector2();
		
		/**发射器半径。*/
		public var radius:Number;
		/**环形弧度。*/
		public var arc:Number;
		/**从边缘发射。*/
		public var emitFromEdge:Boolean;
		
		/**
		 * 创建一个 <code>CircleShape</code> 实例。
		 */
		public function CircleShape() {
			super();
			radius = 1.0;
			arc = 360.0 / 180.0 * Math.PI;
			emitFromEdge = false;
			randomDirection = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _getShapeBoundBox(boundBox:BoundBox):void {
			var min:Vector3 = boundBox.min;
			min.x  = min.z = -radius;
			min.y = 0;
			var max:Vector3 = boundBox.max;
			max.x = max.z = radius;
			max.y = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _getSpeedBoundBox(boundBox:BoundBox):void {
			var min:Vector3 = boundBox.min;
			min.x = min.y =-1;
			min.z = 0;
			var max:Vector3 = boundBox.max;
			max.x = max.y = 1;
			max.z = 0;
		}
		
		/**
		 *  用于生成粒子初始位置和方向。
		 * @param	position 粒子位置。
		 * @param	direction 粒子方向。
		 */
		override public function generatePositionAndDirection(position:Vector3, direction:Vector3, rand:Rand = null, randomSeeds:Uint32Array = null):void {
			var positionPoint:Vector2 = _tempPositionPoint;
			if (rand) {
				rand.seed = randomSeeds[16];
				if (emitFromEdge)
					ShapeUtils._randomPointUnitArcCircle(arc, _tempPositionPoint, rand);
				else
					ShapeUtils._randomPointInsideUnitArcCircle(arc, _tempPositionPoint, rand);
				randomSeeds[16] = rand.seed;
			} else {
				if (emitFromEdge)
					ShapeUtils._randomPointUnitArcCircle(arc, _tempPositionPoint);
				else
					ShapeUtils._randomPointInsideUnitArcCircle(arc, _tempPositionPoint);
			}
			
			position.x = -positionPoint.x;
			position.y = positionPoint.y;
			position.z = 0;
			
			Vector3.scale(position, radius, position);
			
			if (randomDirection) {
				if (rand) {
					rand.seed = randomSeeds[17];
					ShapeUtils._randomPointUnitSphere(direction, rand);
					randomSeeds[17] = rand.seed;
				} else {
					ShapeUtils._randomPointUnitSphere(direction);
				}
			} else {
				position.cloneTo(direction);
			}
		}
		
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destShape:CircleShape = destObject as CircleShape;
			destShape.radius = radius;
			destShape.arc = arc;
			destShape.emitFromEdge = emitFromEdge;
			destShape.randomDirection = randomDirection;
		}
	
	}

}