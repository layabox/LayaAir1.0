package laya.d3.core.light {
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.shader.DefineDatas;
	import laya.d3.shader.ShaderData;
	
	/**
	 * <code>PointLight</code> 类用于创建点光。
	 */
	public class PointLight extends LightSprite {
		/** @private */
		private static var _tempMatrix0:Matrix4x4 = new Matrix4x4();
		
		/** @private */
		private var _range:Number;
		/** @private */
		private var _lightMatrix:Matrix4x4 = new Matrix4x4();
		
		/**
		 * 创建一个 <code>PointLight</code> 实例。
		 */
		public function PointLight() {
			super();
			_range = 6.0;
		}
		
		/**
		 * 获取点光的范围。
		 * @return 点光的范围。
		 */
		public function get range():Number {
			return _range;
		}
		
		/**
		 * 设置点光的范围。
		 * @param  value 点光的范围。
		 */
		public function set range(value:Number):void {
			_range = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onActive():void {
			super._onActive();
			(_lightmapBakedType!==LightSprite.LIGHTMAPBAKEDTYPE_BAKED)&&((_scene as Scene3D)._defineDatas.add(Scene3D.SHADERDEFINE_POINTLIGHT));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onInActive():void {
			super._onInActive();
			(_lightmapBakedType!==LightSprite.LIGHTMAPBAKEDTYPE_BAKED)&&((_scene as Scene3D)._defineDatas.remove(Scene3D.SHADERDEFINE_POINTLIGHT));
		}
		
		/**
		 * 更新点光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public override function _prepareToScene():Boolean {
			var scene:Scene3D = _scene as Scene3D;
			if (scene.enableLight && activeInHierarchy) {
				var defineDatas:DefineDatas = scene._defineDatas;
				var shaderValue:ShaderData = scene._shaderValues;
				Vector3.scale(color, _intensity, _intensityColor);
				shaderValue.setVector(Scene3D.POINTLIGHTCOLOR, _intensityColor);
				shaderValue.setVector(Scene3D.POINTLIGHTPOS, transform.position);
				shaderValue.setNumber(Scene3D.POINTLIGHTRANGE, range);
				
				var lightMatrix:Matrix4x4 = _lightMatrix;
				var lightMatrixE:Float32Array = lightMatrix.elements;
				lightMatrix.identity();
				lightMatrixE[0] = lightMatrixE[5] = lightMatrixE[10] = 1.0 / _range;
				var toLightMatrix:Matrix4x4 = _tempMatrix0;
				transform.worldMatrix.invert(toLightMatrix);
				Matrix4x4.multiply(lightMatrix, toLightMatrix, lightMatrix);
				shaderValue.setMatrix4x4(Scene3D.POINTLIGHTMATRIX, lightMatrix);
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
		}
	}
}