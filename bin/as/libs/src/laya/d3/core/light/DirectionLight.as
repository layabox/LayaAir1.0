package laya.d3.core.light {
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	import laya.events.Event;
	
	/**
	 * <code>DirectionLight</code> 类用于创建平行光。
	 */
	public class DirectionLight extends LightSprite {
		/** @private */
		private var _updateDirection:Boolean;
		/** @private */
		private var _direction:Vector3;
		
		/**
		 * 获取平行光的方向。
		 * @return 平行光的方向。
		 */
		public function get direction():Vector3 {
			if (_updateDirection) {
				transform.worldMatrix.getForward(_direction);
				Vector3.normalize(_direction, _direction);
				_updateDirection = false;
			}
			return _direction;
		}
		
		/**
		 * 设置平行光的方向。
		 * @param value 平行光的方向。
		 */
		public function set direction(value:Vector3):void {
			var worldMatrix:Matrix4x4 = transform.worldMatrix;
			worldMatrix.setForward(value);
			transform.worldMatrix = worldMatrix;
			Vector3.normalize(value, value);
			_direction = value;
			(shadow) && (_parallelSplitShadowMap._setGlobalParallelLightDir(_direction));
		}
		
		/**
		 * @inheritDoc
		 */
		public override function get lightType():int {
			return TYPE_DIRECTIONLIGHT;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set shadow(value:Boolean):void {
			if (_shadow !== value) {
				_shadow = value;
				if (value) {
					_parallelSplitShadowMap = new ParallelSplitShadowMap();
					scene.parallelSplitShadowMaps.push(_parallelSplitShadowMap);
					_parallelSplitShadowMap.setInfo(scene, _shadowFarPlane, direction, _shadowMapSize, _shadowMapCount, _shadowMapPCFType);
				} else {
					var parallelSplitShadowMaps:Vector.<ParallelSplitShadowMap> = scene.parallelSplitShadowMaps;
					parallelSplitShadowMaps.splice(parallelSplitShadowMaps.indexOf(_parallelSplitShadowMap), 1);
					_parallelSplitShadowMap.disposeAllRenderTarget();
					_parallelSplitShadowMap = null;
					scene.removeShaderDefine(ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PSSM1);
					scene.removeShaderDefine(ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PSSM2);
					scene.removeShaderDefine(ParallelSplitShadowMap.SHADERDEFINE_SHADOW_PSSM3);
				}
			}
		}
		
		/**
		 * 创建一个 <code>DirectionLight</code> 实例。
		 */
		public function DirectionLight() {
			super();
			
			_diffuseColor = new Vector3(1.0, 1.0, 1.0);
			_ambientColor = new Vector3(0.6, 0.6, 0.6);
			_specularColor = new Vector3(1.0, 1.0, 1.0);
			_reflectColor = new Vector3(1.0, 1.0, 1.0);
			
			_updateDirection = false;
			direction = new Vector3(0.0, -0.5, -1.0);
			
			transform.on(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatrixChange);
		}
		
		/**
		 * @private
		 */
		private function _onWorldMatrixChange():void {
			_updateDirection = true;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _clearSelfRenderObjects():void {
			var scene:BaseScene = this.scene;
			var shaderValue:ValusArray = scene._shaderValues;
			shaderValue.setValue(BaseScene.LIGHTDIRDIFFUSE, null);
			shaderValue.setValue(BaseScene.LIGHTDIRAMBIENT, null);
			shaderValue.setValue(BaseScene.LIGHTDIRSPECULAR, null);
			shaderValue.setValue(BaseScene.LIGHTDIRECTION, null);
			(_activeHierarchy) && (scene.removeShaderDefine(ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT));
		}
		
		/**
		 * 更新平行光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public override function updateToWorldState(state:RenderState):Boolean {
			var scene:BaseScene = state.scene;
			if (scene.enableLight && active) {
				var shaderValue:ValusArray = scene._shaderValues;
				scene.addShaderDefine(ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT);
				shaderValue.setValue(BaseScene.LIGHTDIRDIFFUSE, diffuseColor.elements);
				shaderValue.setValue(BaseScene.LIGHTDIRAMBIENT, ambientColor.elements);
				shaderValue.setValue(BaseScene.LIGHTDIRSPECULAR, specularColor.elements);
				shaderValue.setValue(BaseScene.LIGHTDIRECTION, direction.elements);
				return true;
			} else {
				scene.removeShaderDefine(ShaderCompile3D.SHADERDEFINE_DIRECTIONLIGHT);
				return false;
			}
		}
	}
}