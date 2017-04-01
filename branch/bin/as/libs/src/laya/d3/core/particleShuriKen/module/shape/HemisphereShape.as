package laya.d3.core.particleShuriKen.module.shape {
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Rand;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>HemisphereShape</code> 类用于创建半球形粒子形状。
	 */
	public class HemisphereShape extends BaseShape {
		/**发射器半径。*/
		public var radius:Number;
		/**从外壳发射。*/
		public var emitFromShell:Boolean;
		/**随机方向。*/
		public var randomDirection:Boolean;
		
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
		 *  用于生成粒子初始位置和方向。
		 * @param	position 粒子位置。
		 * @param	direction 粒子方向。
		 */
		override public function generatePositionAndDirection(position:Vector3, direction:Vector3, rand:Rand = null, randomSeeds:Uint32Array = null):void {
			var rpE:Float32Array = position.elements;
			
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
			
			var z:Number = rpE[2];
			(z > 0.0) && (rpE[2] = z * -1.0);
			
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