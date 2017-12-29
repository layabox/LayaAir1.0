package laya.d3.core.light {
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.Scene;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderCompile3D;
	import laya.d3.shader.ValusArray;
	import laya.events.Event;
	
	/**
	 * <code>SpotLight</code> 类用于创建聚光。
	 */
	public class SpotLight extends LightSprite {
		/** @private */
		private var _updateDirection:Boolean;
		/** @private */
		private var _direction:Vector3;
		/** @private */
		private var _spot:Number;
		/** @private */
		private var _range:Number;
		
		/**
		 * 创建一个 <code>SpotLight</code> 实例。
		 */
		public function SpotLight() {
			super();
			_updateDirection = false;
			direction = new Vector3(0.0, -1.0, -1.0);
			_attenuation = new Vector3(0.6, 0.6, 0.6);//兼容代码
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
		 * @inheritDoc
		 */
		override protected function _clearSelfRenderObjects():void {
			var scene:Scene = this.scene;
			var shaderValue:ValusArray = scene._shaderValues;
			shaderValue.setValue(Scene.SPOTLIGHTCOLOR, null);
			shaderValue.setValue(Scene.SPOTLIGHTPOS, null);
			shaderValue.setValue(Scene.SPOTLIGHTDIRECTION, null);
			shaderValue.setValue(Scene.SPOTLIGHTRANGE, null);
			shaderValue.setValue(Scene.SPOTLIGHTSPOT, null);
			shaderValue.setValue(Scene.SPOTLIGHTATTENUATION, null);//兼容代码
			scene.removeShaderDefine(ShaderCompile3D.SHADERDEFINE_SPOTLIGHT);
		}
		
		/**
		 * 更新聚光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public override function _prepareToScene(state:RenderState):Boolean {
			var scene:Scene = state.scene;
			if (scene.enableLight && _activeInHierarchy) {
				var shaderValue:ValusArray = scene._shaderValues;
				scene.addShaderDefine(ShaderCompile3D.SHADERDEFINE_SPOTLIGHT);
				Vector3.scale(color, _intensity, _intensityColor);
				shaderValue.setValue(Scene.SPOTLIGHTCOLOR, _intensityColor.elements);
				shaderValue.setValue(Scene.SPOTLIGHTPOS, transform.position.elements);
				transform.worldMatrix.getForward(_direction);
				Vector3.normalize(_direction, _direction);
				shaderValue.setValue(Scene.SPOTLIGHTDIRECTION, _direction.elements);
				shaderValue.setValue(Scene.SPOTLIGHTRANGE, range);
				shaderValue.setValue(Scene.SPOTLIGHTSPOT, spot);
				shaderValue.setValue(Scene.SPOTLIGHTATTENUATION, attenuation.elements);//兼容代码
				return true;
			} else {
				scene.removeShaderDefine(ShaderCompile3D.SHADERDEFINE_SPOTLIGHT);
				return false;
			}
		}
		
		//------------------------------------兼容代码-------------------------------------------------
		
		/** @private */
		private var _attenuation:Vector3;
		
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
		 * 获取平行光的方向。
		 * @return 平行光的方向。
		 */
		public function get direction():Vector3 {
			trace("Warning: discard property,please use transform's property instead.");
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
			trace("Warning: discard property,please use transform's property instead.");
			var worldMatrix:Matrix4x4 = transform.worldMatrix;
			worldMatrix.setForward(value);
			transform.worldMatrix = worldMatrix;
			_direction = value;
		}
		//------------------------------------兼容代码-------------------------------------------------
	}

}