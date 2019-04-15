package laya.d3.core.particleShuriKen.module.shape {
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Rand;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>BoxShape</code> 类用于创建球形粒子形状。
	 */
	public class BoxShape extends BaseShape {
		/**发射器X轴长度。*/
		public var x:Number;
		/**发射器Y轴长度。*/
		public var y:Number;
		/**发射器Z轴长度。*/
		public var z:Number;
		
		/**
		 * 创建一个 <code>BoxShape</code> 实例。
		 */
		public function BoxShape() {
			super();
			x = 1.0;
			y = 1.0;
			z = 1.0;
			randomDirection = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _getShapeBoundBox(boundBox:BoundBox):void {
			var min:Vector3 = boundBox.min;
			min.x =-x * 0.5;
			min.y =-y * 0.5;
			min.z =-z * 0.5;
			var max:Vector3 = boundBox.max;
			max.x =x * 0.5;
			max.y =y * 0.5;
			max.z =z * 0.5;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _getSpeedBoundBox(boundBox:BoundBox):void {
			var min:Vector3 = boundBox.min;
			min.x =0.0;
			min.y =0.0;
			min.z =0.0;
			var max:Vector3 = boundBox.max;
			max.x =0.0;
			max.y =1.0;
			max.z =0.0;
		}
		
		/**
		 *  用于生成粒子初始位置和方向。
		 * @param	position 粒子位置。
		 * @param	direction 粒子方向。
		 */
		override public function generatePositionAndDirection(position:Vector3, direction:Vector3, rand:Rand = null, randomSeeds:Uint32Array = null):void {
			if (rand) {
				rand.seed = randomSeeds[16];
				ShapeUtils._randomPointInsideHalfUnitBox(position, rand);
				randomSeeds[16] = rand.seed;
			} else {
				ShapeUtils._randomPointInsideHalfUnitBox(position);
			}
			position.x = x * position.x;
			position.y = y * position.y;
			position.z = z * position.z;
			if (randomDirection) {
				if (rand) {
					rand.seed = randomSeeds[17];
					ShapeUtils._randomPointUnitSphere(direction, rand);
					randomSeeds[17] = rand.seed;
				} else {
					ShapeUtils._randomPointUnitSphere(direction);
				}
			} else {
				direction.x = 0.0;
				direction.y = 0.0;
				direction.z = 1.0;
			}
		}
		
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destShape:BoxShape = destObject as BoxShape;
			destShape.x = x;
			destShape.y = y;
			destShape.z = z;
			destShape.randomDirection = randomDirection;
		}
	
	}

}