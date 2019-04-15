package laya.d3.core.particleShuriKen.module.shape {
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.Rand;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>HemisphereShape</code> 类用于创建半球形粒子形状。
	 */
	public class HemisphereShape extends BaseShape {
		/**发射器半径。*/
		public var radius:Number;
		/**从外壳发射。*/
		public var emitFromShell:Boolean;
		
		/**
		 * 创建一个 <code>HemisphereShape</code> 实例。
		 */
		public function HemisphereShape() {
			super();
			radius = 1.0;
			emitFromShell = false;
			randomDirection = false;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _getShapeBoundBox(boundBox:BoundBox):void {
			var min:Vector3 = boundBox.min;
			min.x = min.y =min.z= -radius;
			var max:Vector3 = boundBox.max;
			max.x = max.y = radius;
			max.z = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _getSpeedBoundBox(boundBox:BoundBox):void {
			var min:Vector3 = boundBox.min;
			min.x = min.y =-1;
			min.z= 0;
			var max:Vector3 = boundBox.max;
			max.x = max.y =max.z= 1;
		}
		
		/**
		 *  用于生成粒子初始位置和方向。
		 * @param	position 粒子位置。
		 * @param	direction 粒子方向。
		 */
		override public function generatePositionAndDirection(position:Vector3, direction:Vector3, rand:Rand = null, randomSeeds:Uint32Array = null):void {
			if (rand) {
				rand.seed = randomSeeds[16];
				if (emitFromShell)
					ShapeUtils._randomPointUnitSphere(position, rand);
				else
					ShapeUtils._randomPointInsideUnitSphere(position, rand);
				randomSeeds[16] = rand.seed;
			} else {
				if (emitFromShell)
					ShapeUtils._randomPointUnitSphere(position);
				else
					ShapeUtils._randomPointInsideUnitSphere(position);
			}
			
			Vector3.scale(position, radius, position);
			
			var z:Number = position.z;
			(z < 0.0) && (position.z = z * -1.0);
			
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
			var destShape:HemisphereShape = destObject as HemisphereShape;
			destShape.radius = radius;
			destShape.emitFromShell = emitFromShell;
			destShape.randomDirection = randomDirection;
		}
	
	}

}