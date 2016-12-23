package laya.d3.core.light {
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderDefines3D;
	import laya.d3.shader.ValusArray;
	import laya.utils.Stat;
	import laya.webgl.utils.Buffer2D;
	
	/**
	 * <code>PointLight</code> 类用于创建点光。
	 */
	public class PointLight extends LightSprite {
		/** @private */
		private var _attenuation:Vector3;
		/** @private */
		private var _range:Number;
		
		/**
		 * 创建一个 <code>PointLight</code> 实例。
		 */
		public function PointLight() {
			super();
			
			_diffuseColor = new Vector3(1.0, 1.0, 1.0);
			_ambientColor = new Vector3(0.2, 0.2, 0.2);
			_specularColor = new Vector3(1.0, 0.0, 0.0);
			_reflectColor = new Vector3(1.0, 1.0, 1.0);
			
			transform.position = new Vector3(0.0, 0.0, 0.0);
			_range = 6.0;
			_attenuation = new Vector3(0.6, 0.6, 0.6);
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
		 * 获取点光的衰减。
		 * @return 点光的衰减。
		 */
		public function get attenuation():Vector3 {
			return _attenuation;
		}
		
		/**
		 * 设置点光的衰减。
		 * @param value 点光的衰减。
		 */
		public function set attenuation(value:Vector3):void {
			_attenuation = value;
		}
		
		/**
		 * 获取点光的类型。
		 * @return 点光的类型。
		 */
		public override function get lightType():int {
			return TYPE_POINTLIGHT;
		}
		
		/**
		 * 更新点光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public override function updateToWorldState(state:RenderState):void {
			var scene:BaseScene = state.scene;
			if (scene.enableLight) {
				var shaderValue:ValusArray = scene._shaderValues;
				state.shaderDefines.add(ShaderDefines3D.POINTLIGHT);
				shaderValue.setValue(BaseScene.POINTLIGHTDIFFUSE, diffuseColor.elements);
				shaderValue.setValue(BaseScene.POINTLIGHTAMBIENT, ambientColor.elements);
				shaderValue.setValue(BaseScene.POINTLIGHTSPECULAR, specularColor.elements);
				shaderValue.setValue(BaseScene.POINTLIGHTPOS, transform.position.elements);
				shaderValue.setValue(BaseScene.POINTLIGHTRANGE, range);
				shaderValue.setValue(BaseScene.POINTLIGHTATTENUATION, attenuation.elements);
			}
		}
	
	}

}