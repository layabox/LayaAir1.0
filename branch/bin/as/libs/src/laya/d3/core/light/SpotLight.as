package laya.d3.core.light {
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.events.Event;
	import laya.utils.Stat;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * <code>SpotLight</code> 类用于创建聚光。
	 */
	public class SpotLight extends LightSprite {
		/** @private */
		private var _updateDirection:Boolean;
		/** @private */
		private var _direction:Vector3;
		/** @private */
		private var _attenuation:Vector3;
		/** @private */
		private var _spot:Number;
		/** @private */
		private var _range:Number;
		
		/**
		 * 创建一个 <code>SpotLight</code> 实例。
		 */
		public function SpotLight() {
			super();
			
			_diffuseColor = new Vector3(1.0, 1.0, 1.0);
			_ambientColor = new Vector3(0.2, 0.2, 0.2);
			_specularColor = new Vector3(1.0, 1.0, 1.0);
			_reflectColor = new Vector3(1.0, 1.0, 1.0);
			
			transform.position = new Vector3(0.0, 1.0, 1.0);
			_updateDirection = false;
			direction = new Vector3(0.0, -1.0, -1.0);
			_attenuation = new Vector3(0.6, 0.6, 0.6);
			_spot = 96.0;
			_range = 6.0;
			
			transform.on(Event.WORLDMATRIX_NEEDCHANGE, this, _onWorldMatrixChange);
		
		}
		
		/**
		 * @private
		 */
		private function _onWorldMatrixChange():void {
			_updateDirection = true;
		}
		
		/**
		 * 获取平行光的方向。
		 * @return 平行光的方向。
		 */
		public function get direction():Vector3 {
			if (_updateDirection) {
				transform.worldMatrix.getForward(_direction);
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
			_direction = value;
		}
		
		/**
		 * 获取聚光的衰减。
		 * @return 聚光的衰减。
		 */
		public function get attenuation():Vector3 {
			return _attenuation;
		}
		
		/**
		 * 设置聚光的衰减。
		 * @param value 聚光的衰减。
		 */
		public function set attenuation(value:Vector3):void {
			_attenuation = value;
		}
		
		/**
		 * 获取聚光的聚光值。
		 * @return 聚光的聚光值。
		 */
		public function get spot():Number {
			return _spot;
		}
		
		/**
		 * 设置聚光的聚光值。
		 * @param value 聚光的聚光值。
		 */
		public function set spot(value:Number):void {
			_spot = value;
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
		 * 获取聚光的类型。
		 * @return 聚光的类型。
		 */
		public override function get lightType():int {
			return TYPE_SPOTLIGHT;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _clearSelfRenderObjects():void {
			var scene:BaseScene = this.scene;
			var shaderValue:ValusArray = scene._shaderValues;
			shaderValue.setValue(BaseScene.SPOTLIGHTDIFFUSE, null);
			shaderValue.setValue(BaseScene.SPOTLIGHTAMBIENT, null);
			shaderValue.setValue(BaseScene.SPOTLIGHTSPECULAR, null);
			shaderValue.setValue(BaseScene.SPOTLIGHTPOS, null);
			shaderValue.setValue(BaseScene.SPOTLIGHTDIRECTION, null);
			shaderValue.setValue(BaseScene.SPOTLIGHTRANGE, null);
			shaderValue.setValue(BaseScene.SPOTLIGHTSPOT, null);
			shaderValue.setValue(BaseScene.SPOTLIGHTATTENUATION, null);
			(_activeInHierarchy) && (scene.removeShaderDefine(ShaderCompile3D.SHADERDEFINE_SPOTLIGHT));
		}
		
		/**
		 * 更新聚光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public override function updateToWorldState(state:RenderState):Boolean {
			var scene:BaseScene = state.scene;
			if (scene.enableLight && active) {
				var shaderValue:ValusArray = scene._shaderValues;
				scene.addShaderDefine(ShaderCompile3D.SHADERDEFINE_SPOTLIGHT);
				shaderValue.setValue(BaseScene.SPOTLIGHTDIFFUSE, diffuseColor.elements);
				shaderValue.setValue(BaseScene.SPOTLIGHTAMBIENT, ambientColor.elements);
				shaderValue.setValue(BaseScene.SPOTLIGHTSPECULAR, specularColor.elements);
				shaderValue.setValue(BaseScene.SPOTLIGHTPOS, transform.position.elements);
				shaderValue.setValue(BaseScene.SPOTLIGHTDIRECTION, direction.elements);
				shaderValue.setValue(BaseScene.SPOTLIGHTRANGE, range);
				shaderValue.setValue(BaseScene.SPOTLIGHTSPOT, spot);
				shaderValue.setValue(BaseScene.SPOTLIGHTATTENUATION, attenuation.elements);
				return true;
			} else {
				scene.removeShaderDefine(ShaderCompile3D.SHADERDEFINE_SPOTLIGHT);
				return false;
			}
		}
	}

}