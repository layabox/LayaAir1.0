package laya.d3.core.particleShuriKen.module.shape {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>ConeShape</code> 类用于创建锥形粒子形状。
	 */
	public class ConeShape extends BaseShape {
		/** @private */
		protected static var _tempPositionPoint:Vector2 = new Vector2();
		/** @private */
		protected static var _tempDirectionPoint:Vector2 = new Vector2();
		
		/**发射角度。*/
		public var angle:Number;
		/**发射器半径。*/
		public var radius:Number;
		/**椎体长度。*/
		public var length:Number;
		/**发射类型,0为Base,1为BaseShell,2为Volume,3为VolumeShell。*/
		public var emitType:int;
		/**随机方向。*/
		public var randomDirection:Boolean;
		
		/**
		 * 创建一个 <code>ConeShape</code> 实例。
		 */
		public function ConeShape() {
			super();
			angle = 25.0 / 180.0 * Math.PI;
			radius = 1.0;
			length = 5.0;
			emitType = 0;
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
			var positionPointE:Float32Array = _tempPositionPoint.elements;
			var positionX:Number;
			var positionY:Number;
			var directionPointE:Float32Array;
			
			var dirCosA:Number = Math.cos(angle);
			var dirSinA:Number = Math.sin(angle);
			switch (emitType) {
			case 0: 
				ShapeUtils._randomPointInsideUnitCircle(_tempPositionPoint);
				positionX = positionPointE[0];
				positionY = positionPointE[1];
				rpE[0] = positionX * radius;
				rpE[1] = positionY * radius;
				rpE[2] = 0;
				
				if (randomDirection) {
					ShapeUtils._randomPointInsideUnitCircle(_tempDirectionPoint);
					directionPointE = _tempDirectionPoint.elements;
					rdE[0] = directionPointE[0] * dirSinA;
					rdE[1] = directionPointE[1] * dirSinA;
				} else {
					rdE[0] = positionX * dirSinA;
					rdE[1] = positionY * dirSinA;
				}
				rdE[2] = -dirCosA;
				break;
			case 1: 
				ShapeUtils._randomPointUnitCircle(_tempPositionPoint);
				positionX = positionPointE[0];
				positionY = positionPointE[1];
				rpE[0] = positionX * radius;
				rpE[1] = positionY * radius;
				rpE[2] = 0;
				
				if (randomDirection) {
					ShapeUtils._randomPointInsideUnitCircle(_tempDirectionPoint);
					directionPointE = _tempDirectionPoint.elements;
					rdE[0] = directionPointE[0] * dirSinA;
					rdE[1] = directionPointE[1] * dirSinA;
				} else {
					rdE[0] = positionX * dirSinA;
					rdE[1] = positionY * dirSinA;
				}
				rdE[2] = -dirCosA;
				break;
			case 2: 
				ShapeUtils._randomPointInsideUnitCircle(_tempPositionPoint);
				positionX = positionPointE[0];
				positionY = positionPointE[1];
				rpE[0] = positionX * radius;
				rpE[1] = positionY * radius;
				rpE[2] = 0;
				
				rdE[0] = positionX * dirSinA;
				rdE[1] = positionY * dirSinA;
				rdE[2] = -dirCosA;
				
				Vector3.normalize(direction, direction);
				Vector3.scale(direction, length * Math.random(), direction);
				Vector3.add(position, direction, position);
				
				if (randomDirection)
					ShapeUtils._randomPointUnitSphere(direction);
				
				break;
			case 3: 
				ShapeUtils._randomPointUnitCircle(_tempPositionPoint);
				positionX = positionPointE[0];
				positionY = positionPointE[1];
				rpE[0] = positionX * radius;
				rpE[1] = positionY * radius;
				rpE[2] = 0;
				
				rdE[0] = positionX * dirSinA;
				rdE[1] = positionY * dirSinA;
				rdE[2] = -dirCosA;
				
				Vector3.normalize(direction, direction);
				Vector3.scale(direction, length * Math.random(), direction);
				Vector3.add(position, direction, position);
				
				if (randomDirection)
					ShapeUtils._randomPointUnitSphere(direction);
				
				break;
			default: 
				throw new Error("ConeShape:emitType is invalid.");
			}
		}
	
	}

}