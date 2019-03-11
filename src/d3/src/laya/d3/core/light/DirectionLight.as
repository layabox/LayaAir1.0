package laya.d3.core.light {
	import laya.d3.core.render.RenderContext3D;
	import laya.d3.core.scene.Scene3D;
	import laya.d3.math.Vector3;
	import laya.d3.shader.DefineDatas;
	import laya.d3.shader.ShaderData;
	import laya.d3.shadowMap.ParallelSplitShadowMap;
	
	/**
	 * <code>DirectionLight</code> 类用于创建平行光。
	 */
	public class DirectionLight extends LightSprite {
		/** @private */
		private var _direction:Vector3;
		
		/**
		 * @inheritDoc
		 */
		override public function set shadow(value:Boolean):void {
			if (_shadow !== value) {
				_shadow = value;
				(scene) && (_initShadow());
			}
		}
		
		/**
		 * 创建一个 <code>DirectionLight</code> 实例。
		 */
		public function DirectionLight() {
			super();
			_direction = new Vector3();
		}
		
		/**
		 * @private
		 */
		private function _initShadow():void {
			if (_shadow) {
				_parallelSplitShadowMap = new ParallelSplitShadowMap();
				scene.parallelSplitShadowMaps.push(_parallelSplitShadowMap);
				transform.worldMatrix.getForward(_direction);
				Vector3.normalize(_direction, _direction);
				_parallelSplitShadowMap.setInfo(scene, _shadowFarPlane, _direction, _shadowMapSize, _shadowMapCount, _shadowMapPCFType);
			} else {
				var defineDatas:DefineDatas = (_scene as Scene3D)._defineDatas;
				var parallelSplitShadowMaps:Vector.<ParallelSplitShadowMap> = scene.parallelSplitShadowMaps;
				parallelSplitShadowMaps.splice(parallelSplitShadowMaps.indexOf(_parallelSplitShadowMap), 1);
				_parallelSplitShadowMap.disposeAllRenderTarget();
				_parallelSplitShadowMap = null;
				defineDatas.remove(Scene3D.SHADERDEFINE_SHADOW_PSSM1);
				defineDatas.remove(Scene3D.SHADERDEFINE_SHADOW_PSSM2);
				defineDatas.remove(Scene3D.SHADERDEFINE_SHADOW_PSSM3);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onActive():void {
			super._onActive();
			_shadow && (_initShadow());
			(_lightmapBakedType!==LightSprite.LIGHTMAPBAKEDTYPE_BAKED)&&((_scene as Scene3D)._defineDatas.add(Scene3D.SHADERDEFINE_DIRECTIONLIGHT));
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _onInActive():void {
			super._onInActive();
			(_lightmapBakedType!==LightSprite.LIGHTMAPBAKEDTYPE_BAKED)&&((_scene as Scene3D)._defineDatas.remove(Scene3D.SHADERDEFINE_DIRECTIONLIGHT));
		}
		
		/**
		 * 更新平行光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public override function _prepareToScene():Boolean {
			var scene:Scene3D = _scene as Scene3D;
			if (scene.enableLight && activeInHierarchy) {
				var defineDatas:DefineDatas = scene._defineDatas;
				var shaderValue:ShaderData = scene._shaderValues;
				Vector3.scale(color, _intensity, _intensityColor);
				shaderValue.setVector(Scene3D.LIGHTDIRCOLOR, _intensityColor);
				transform.worldMatrix.getForward(_direction);
				Vector3.normalize(_direction, _direction);
				shaderValue.setVector(Scene3D.LIGHTDIRECTION, _direction);
				return true;
			} else {
				return false;
			}
		}
	}
}