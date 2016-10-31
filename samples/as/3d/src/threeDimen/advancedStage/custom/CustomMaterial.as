package threeDimen.advancedStage.custom {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.resource.BaseTexture;
	import laya.webgl.utils.Buffer2D;

	
	/**
	 * ...
	 * @author ...
	 */
	public class CustomMaterial extends BaseMaterial {
		/** @private */
		private static var _tempMatrix4x40:Matrix4x4 = new Matrix4x4();
		/** @private */
		private static const _diffuseTextureIndex:int = 0;
		
		/**
		 * 获取漫反射贴图。
		 * @return 漫反射贴图。
		 */
		public function get diffuseTexture():BaseTexture {
			return _getTexture(_diffuseTextureIndex);
		}
		
		/**
		 * 设置漫反射贴图。
		 * @param value 漫反射贴图。
		 */
		public function set diffuseTexture(value:BaseTexture):void {
			_setTexture(value, _diffuseTextureIndex, Buffer2D.DIFFUSETEXTURE);
		}
		
		public function CustomMaterial() {
			super();
			setShaderName("CustomShader");
		}
		
		override public function _setLoopShaderParams(state:RenderState, projectionView:Matrix4x4, worldMatrix:Matrix4x4, mesh:IRenderable, material:BaseMaterial):void {
			var pvw:Matrix4x4 = _tempMatrix4x40;
			Matrix4x4.multiply(projectionView, worldMatrix, pvw);
			
			state.shaderValue.pushValue(Buffer2D.MVPMATRIX, pvw.elements);
			state.shaderValue.pushValue(Buffer2D.MATRIX1, worldMatrix.elements);
		}
	
	}

}