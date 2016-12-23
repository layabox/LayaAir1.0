package laya.d3.core.particleShuriKen.module.shape {
	import laya.d3.core.render.RenderState;
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
		/**发射器半径。*/
		public var randomDirection:Boolean;
		
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
		 *  用于生成粒子初始位置和方向。
		 * @param	position 粒子位置。
		 * @param	direction 粒子方向。
		 */
		override public function generatePositionAndDirection(position:Vector3, direction:Vector3):void {
			var rpE:Float32Array = position.elements;
			var rdE:Float32Array = direction.elements;
			ShapeUtils._randomPointInsideHalfUnitBox(position);
			rpE[0] = x * rpE[0];
			rpE[1] = y * rpE[1];
			rpE[2] = z * rpE[2];
			if (randomDirection) {
				ShapeUtils._randomPointUnitSphere(direction);
			} else {
				rdE[0] = 0.0;
				rdE[1] = 0.0;
				rdE[2] = -1.0;
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