package laya.d3.core.particleShuriKen.emitter {
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Vector3;
	
	/**
	 * <code>ParticleHemisphereEmitter</code> 类用于创建半球形粒子形状。
	 */
	public class ParticleHemisphereEmitter extends ParticleBaseEmitter {
		/** @private */
		private var _resultPosition:Vector3;
		/** @private */
		private var _resultDirection:Vector3;
		
		/**发射器半径。*/
		public var radius:Number;
		/**从外壳发射。*/
		public var emitFromShell:Boolean;
		/**随机方向。*/
		public var randomDirection:Boolean;
		
		/**
		 * 创建一个 <code>ParticleHemisphereEmitter</code> 实例。
		 */
		public function ParticleHemisphereEmitter() {
			super();
			_resultPosition = new Vector3();
			_resultDirection = new Vector3();
			radius = 1.0;
			emitFromShell = false;
			randomDirection = false;
		}
		
		/**
		 * @private
		 */
		private function _generatePosition(scale:Vector3):Vector3 {
			var rpe:Float32Array = _resultPosition.elements;
			var scleE:Float32Array = scale.elements;
			var rad:Number = emitFromShell ? radius : radius * Math.random();
			
			var angleVer:Number = Math.random() * Math.PI * 2;
			var angleHor:Number = Math.random() * Math.PI * 2;
			var r:Number = Math.cos(angleVer) * rad;
			rpe[0] = Math.cos(angleHor) * r*scleE[0];
			rpe[1] = Math.sin(angleVer) * rad*scleE[1];
			var z:Number = Math.sin(angleHor) * r*scleE[2];
			rpe[2] = (z > 0.0) ? (z *= -1.0) : z;
			return _resultPosition;
		}
		
		/**
		 * @private
		 */
		private function _generateDirection():Vector3 {
			if (randomDirection) {
				var resultDirectionE:Float32Array = _resultDirection.elements;
				resultDirectionE[0] = Math.random() - 0.5;
				resultDirectionE[1] = Math.random() - 0.5;
				resultDirectionE[2] = Math.random() - 0.5;
			} else {
				_resultPosition.cloneTo(_resultDirection);
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