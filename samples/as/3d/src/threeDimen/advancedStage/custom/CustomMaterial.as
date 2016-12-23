package threeDimen.advancedStage.custom {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.BaseTexture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CustomMaterial extends BaseMaterial {
		public static const DIFFUSETEXTURE:int = 0;
		private static var _DIFFUSETEXTURE_ID:int;
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get diffuseTexture():BaseTexture {
			return _getTexture(_DIFFUSETEXTURE_ID);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set diffuseTexture(value:BaseTexture):void {
			_setTexture(_DIFFUSETEXTURE_ID, value);
		}
		
		override public function setShaderName(name:String):void {
			super.setShaderName(name);
		}
		
		public function CustomMaterial() {
			super();
			setShaderName("CustomShader");
		}
	
	}

}