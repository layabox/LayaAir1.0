package laya.d3.core.particleShuriKen.emitter {
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>ParticleBoxEmitter</code> 类用于创建球形粒子形状。
	 */
	public class ParticleBoxEmitter extends ParticleBaseEmitter {
		/** @private */
		private var _resultPosition:Vector3;
		/** @private */
		private var _resultDirection:Vector3;
		
		/**发射器X轴长度。*/
		public var x:Number;
		/**发射器Y轴长度。*/
		public var y:Number;
		/**发射器Z轴长度。*/
		public var z:Number;
		/**发射器半径。*/
		public var randomDirection:Boolean;
		
		/**
		 * 创建一个 <code>ParticleBoxEmitter</code> 实例。
		 */
		public function ParticleBoxEmitter() {
			super();
			_resultPosition = new Vector3();
			_resultDirection = new Vector3();
			x = 1.0;
			y = 1.0;
			z = 1.0;
			randomDirection = false;
		}
		
		/**
		 * @private
		 */
		private function _generatePosition(scale:Vector3):Vector3 {
			var rpe:Float32Array = _resultPosition.elements;
			var scleE:Float32Array = scale.elements;
			rpe[0] = x * (Math.random() - 0.5)*scleE[0];
			rpe[1] = y * (Math.random() - 0.5)*scleE[1];
			rpe[2] = z * (Math.random() - 0.5)*scleE[2];
			
			return _resultPosition;
		}
		
		/**
		 * @private
		 */
		private function _generateDirection():Vector3 {
			var resultDirectionE:Float32Array = _resultDirection.elements;
			if (randomDirection) {
				resultDirectionE[0] = Math.random() - 0.5;
				resultDirectionE[1] = Math.random() - 0.5;
				resultDirectionE[2] = Math.random() - 0.5;
			} else {
				resultDirectionE[0] = 0.0;
				resultDirectionE[1] = 0.0;
				resultDirectionE[2] = -1.0;
			}
			return _resultDirection;
		}
		
		/**
		 * 球发射器发射函数。
		 */
		override public function emit(scale:Vector3):void {
			_particleSystem.addParticle(_generatePosition(scale), _generateDirection());
		}
	}

}