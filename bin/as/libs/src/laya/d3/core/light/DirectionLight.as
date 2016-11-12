package laya.d3.core.light {
	import laya.d3.core.render.RenderState;
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.Vector3;
	import laya.d3.shader.ShaderDefines3D;
	import laya.utils.Stat;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.ValusArray;
	
	/**
	 * <code>DirectionLight</code> 类用于创建平行光。
	 */
	public class DirectionLight extends LightSprite {
		/** @private */
		private var _direction:Vector3;
		
		/**
		 * 创建一个 <code>DirectionLight</code> 实例。
		 */
		public function DirectionLight() {
			super();
			
			_diffuseColor = new Vector3(1.0, 1.0, 1.0);
			_ambientColor = new Vector3(0.6, 0.6, 0.6);
			_specularColor = new Vector3(1.0, 1.0, 1.0);
			_reflectColor = new Vector3(1.0, 1.0, 1.0);
			
			_direction = new Vector3(0.0, -0.5, -1.0);
		}
		
		/**
		 * 获取平行光的方向。
		 * @return 平行光的方向。
		 */
		public function get direction():Vector3 {
			return _direction;
		}
		
		/**
		 * 设置平行光的方向。
		 * @param value 平行光的方向。
		 */
		public function set direction(value:Vector3):void {
			_direction = value;
		}
		
		/**
		 * 获取平行光的类型。
		 * @return 平行光的类型。
		 */
		public override function get lightType():int {
			return TYPE_DIRECTIONLIGHT;
		}
		
		/**
		 * 更新平行光相关渲染状态参数。
		 * @param state 渲染状态参数。
		 */
		public override function updateToWorldState(state:RenderState):void {
			if (state.scene.enableLight) {
				var shaderValue:ValusArray = state.worldShaderValue;
				var loopCount:int = Stat.loopCount;
				state.shaderDefs.add(ShaderDefines3D.DIRECTIONLIGHT);
				shaderValue.pushValue(BaseScene.LIGHTDIRDIFFUSE, diffuseColor.elements);
				shaderValue.pushValue(BaseScene.LIGHTDIRAMBIENT, ambientColor.elements);
				shaderValue.pushValue(BaseScene.LIGHTDIRSPECULAR, specularColor.elements);
				shaderValue.pushValue(BaseScene.LIGHTDIRECTION, direction.elements);
			}
		}
	}
}