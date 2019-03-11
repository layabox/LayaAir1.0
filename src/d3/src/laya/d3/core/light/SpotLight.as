package laya.d3.core.light {
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.shader.DefineDatas;
	import laya.d3.shader.ShaderData;
	import laya.events.Event;
	
	/**
	 * <code>SpotLight</code> 类用于创建聚光。
	 */
	public class SpotLight extends LightSprite {
		/** @private */
		private static var _tempMatrix0:Matrix4x4 = new Matrix4x4();
		/** @private */
		private static var _tempMatrix1:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		private var _direction:Vector3;
		/** @private */
		private var _spotAngle:Number;
		/** @private */
		private var _range:Number;
		
		/** @private */
		//private var _tempMatrix:Matrix4x4 = new Matrix4x4();
		
		/**
		 * 创建一个 <code>SpotLight</code> 实例。
		 */
		public function SpotLight() {
			super();
			_spotAngle = 30.0;
			_range = 10.0;
			_direction = new Vector3();
		}
		
		/**
		 * 获取聚光灯的锥形角度。
		 * @return 聚光灯的锥形角度。
		 */
		public function get spotAngle():Number {
			return _spotAngle;
		}
		
		/**
		 * 设置聚光灯的锥形角度。
		 * @param value 聚光灯的锥形角度。
		 */
		public function set spotAngle(value:Number):void {
			_spotAngle = Math.max(Math.min(value, 180), 0);
		}
		
		/**
		 * 获取聚光的范围。
		 * @return 聚光的范围值。
		 */
		public function get range():Number {
			return _range;
		}
		
		/**
		 * 设置聚光的范围。
		 * @param value 聚光的范围值。
		 */
		public function set range(value:Number):void {
			_range = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onActive():void {
			super._onActive();
			(_lightmapBakedType!==LightSprite.LIGHTMAPBAKEDTYPE_BAKED)&&((scene as Scene3D)._defineDatas.add(Scene3D.SHADERDEFINE_SPOTLIGHT));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onInActive():void {
			super._onInActive();
			(_lightmapBakedType!==LightSprite.LIGHTMAPBAKEDTYPE_BAKED)&&((scene as Scene3D)._defineDatas.remove(Scene3D.SHADERDEFINE_SPOTLIGHT));
		}
		
		/**
		 * 更新聚光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public override function _prepareToScene():Boolean {
			var scene:Scene3D = _scene as Scene3D;
			if (scene.enableLight && activeInHierarchy) {
				var defineDatas:DefineDatas = scene._defineDatas;
				var shaderValue:ShaderData = scene._shaderValues;
				Vector3.scale(color, _intensity, _intensityColor);
				shaderValue.setVector(Scene3D.SPOTLIGHTCOLOR, _intensityColor);
				shaderValue.setVector(Scene3D.SPOTLIGHTPOS, transform.position);
				transform.worldMatrix.getForward(_direction);
				Vector3.normalize(_direction, _direction);
				shaderValue.setVector(Scene3D.SPOTLIGHTDIRECTION, _direction);
				shaderValue.setNumber(Scene3D.SPOTLIGHTRANGE, range);
				shaderValue.setNumber(Scene3D.SPOTLIGHTSPOTANGLE, spotAngle * Math.PI / 180);
				
				//----------------------------------To do SpotLight Attenuate----------------------------------
				//var tempMatrix:Matrix4x4 = _tempMatrix0;
				//var tempMatrixE:Float32Array = tempMatrix.elements;
				//tempMatrix.identity();
				//var halfRad:Number = (spotAngle / 2) * Math.PI / 180;
				//var cotanHalfSpotAngle:Number = 1 / Math.tan(halfRad);
				//tempMatrixE[14] = 2.0 / cotanHalfSpotAngle;
				//tempMatrixE[15] = 0.0;
				//
				//var lightMatrix:Matrix4x4 = _lightMatrix;
				//var lightMatrixE:Float32Array = lightMatrix.elements;
				//lightMatrix.identity();
				//lightMatrixE[0] = lightMatrixE[5] = lightMatrixE[10] = 1.0 / _range;
				//Matrix4x4.multiply(lightMatrix, tempMatrix, lightMatrix);
				//
				//var toLightMatrix:Matrix4x4 = _tempMatrix1;
				//transform.worldMatrix.invert(toLightMatrix);
				//Matrix4x4.multiply(lightMatrix, toLightMatrix, lightMatrix);
				//shaderValue.setMatrix4x4(Scene3D.SPOTLIGHTMATRIX, lightMatrix);
				//----------------------------------To do SpotLight Attenuate----------------------------------
				
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			super._parse(data);
			range = data.range;
			spotAngle = data.spotAngle;
		}
	}

}