package laya.d3.core.particleShuriKen.module.shape {
	import laya.d3.math.BoundBox;
	import laya.d3.math.Rand;
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
		 * @inheritDoc
		 */
		override protected function _getShapeBoundBox(boundBox:BoundBox):void {
			const  coneRadius2:Number = radius + length * Math.sin(angle);
			const  coneLength:Number = length * Math.cos(angle);
			
			var min:Vector3 = boundBox.min;
			min.x = min.y = -coneRadius2;
			min.z = 0;
			
			var max:Vector3 = boundBox.max;
			max.x = max.y = coneRadius2;
			max.z = coneLength;//TODO:是否为负
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _getSpeedBoundBox(boundBox:BoundBox):void {
			const  sinA:Number = Math.sin(angle);
			var min:Vector3 = boundBox.min;
			min.x = min.y = -sinA;
			min.z= 0;
			var max:Vector3 = boundBox.max;
			max.x = max.y = sinA;
			max.z = 1;
		}
		
		/**
		 *  用于生成粒子初始位置和方向。
		 * @param	position 粒子位置。
		 * @param	direction 粒子方向。
		 */
		override public function generatePositionAndDirection(position:Vector3, direction:Vector3, rand:Rand = null, randomSeeds:Uint32Array = null):void {
			var positionPointE:Vector2 = _tempPositionPoint;
			var positionX:Number;
			var positionY:Number;
			var directionPointE:Vector2;
			
			var dirCosA:Number = Math.cos(angle);
			var dirSinA:Number = Math.sin(angle);
			switch (emitType) {
			case 0: 
				if (rand) {
					rand.seed = randomSeeds[16];
					ShapeUtils._randomPointInsideUnitCircle(_tempPositionPoint, rand);
					randomSeeds[16] = rand.seed;
				} else {
					ShapeUtils._randomPointInsideUnitCircle(_tempPositionPoint);
				}
				positionX = positionPointE.x;
				positionY = positionPointE.y;
				position.x = positionX * radius;
				position.y = positionY * radius;
				position.z = 0;
				
				if (randomDirection) {
					if (rand) {
						rand.seed = randomSeeds[17];
						ShapeUtils._randomPointInsideUnitCircle(_tempDirectionPoint, rand);
						randomSeeds[17] = rand.seed;
					} else {
						ShapeUtils._randomPointInsideUnitCircle(_tempDirectionPoint);
					}
					directionPointE = _tempDirectionPoint;
					direction.x = directionPointE.x * dirSinA;
					direction.y = directionPointE.y * dirSinA;
				} else {
					direction.x = positionX * dirSinA;
					direction.y = positionY * dirSinA;
				}
				direction.z = dirCosA;
				break;
			case 1: 
				if (rand) {
					rand.seed = randomSeeds[16];
					ShapeUtils._randomPointUnitCircle(_tempPositionPoint, rand);
					randomSeeds[16] = rand.seed;
				} else {
					ShapeUtils._randomPointUnitCircle(_tempPositionPoint);
				}
				positionX = positionPointE.x;
				positionY = positionPointE.y;
				position.x = positionX * radius;
				position.y = positionY * radius;
				position.z = 0;
				
				if (randomDirection) {
					if (rand) {
						rand.seed = randomSeeds[17];
						ShapeUtils._randomPointInsideUnitCircle(_tempDirectionPoint, rand);
						randomSeeds[17] = rand.seed;
					} else {
						ShapeUtils._randomPointInsideUnitCircle(_tempDirectionPoint);
					}
					directionPointE = _tempDirectionPoint;
					direction.x = directionPointE.x * dirSinA;
					direction.y = directionPointE.y * dirSinA;
				} else {
					direction.x = positionX * dirSinA;
					direction.y = positionY * dirSinA;
				}
				direction.z = dirCosA;
				break;
			case 2: 
				if (rand) {
					rand.seed = randomSeeds[16];
					ShapeUtils._randomPointInsideUnitCircle(_tempPositionPoint, rand);
					
				} else {
					ShapeUtils._randomPointInsideUnitCircle(_tempPositionPoint);
				}
				positionX = positionPointE.x;
				positionY = positionPointE.y;
				position.x = positionX * radius;
				position.y = positionY * radius;
				position.z = 0;
				
				direction.x = positionX * dirSinA;
				direction.y = positionY * dirSinA;
				direction.z = dirCosA;
				
				Vector3.normalize(direction, direction);
				if (rand) {
					Vector3.scale(direction, length * rand.getFloat(), direction);
					randomSeeds[16] = rand.seed;
				} else {
					Vector3.scale(direction, length * Math.random(), direction);
				}
				Vector3.add(position, direction, position);
				
				if (randomDirection) {
					if (rand) {
						rand.seed = randomSeeds[17];
						ShapeUtils._randomPointUnitSphere(direction, rand);
						randomSeeds[17] = rand.seed;
					} else {
						ShapeUtils._randomPointUnitSphere(direction);
					}
				}
				
				break;
			case 3: 
				if (rand) {
					rand.seed = randomSeeds[16];
					ShapeUtils._randomPointUnitCircle(_tempPositionPoint, rand);
				} else {
					ShapeUtils._randomPointUnitCircle(_tempPositionPoint);
				}
				
				positionX = positionPointE.x;
				positionY = positionPointE.y;
				position.x = positionX * radius;
				position.y = positionY * radius;
				position.z = 0;
				
				direction.x = positionX * dirSinA;
				direction.y = positionY * dirSinA;
				direction.z = dirCosA;
				
				Vector3.normalize(direction, direction);
				if (rand) {
					Vector3.scale(direction, length * rand.getFloat(), direction);
					randomSeeds[16] = rand.seed;
				} else {
					Vector3.scale(direction, length * Math.random(), direction);
				}
				
				Vector3.add(position, direction, position);
				
				if (randomDirection) {
					if (rand) {
						rand.seed = randomSeeds[17];
						ShapeUtils._randomPointUnitSphere(direction, rand);
						randomSeeds[17] = rand.seed;
					} else {
						ShapeUtils._randomPointUnitSphere(direction);
					}
				}
				
				break;
			default: 
				throw new Error("ConeShape:emitType is invalid.");
			}
		}
		
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var destShape:ConeShape = destObject as ConeShape;
			destShape.angle = angle;
			destShape.radius = radius;
			destShape.length = length;
			destShape.emitType = emitType;
			destShape.randomDirection = randomDirection;
		}
	
	}

}