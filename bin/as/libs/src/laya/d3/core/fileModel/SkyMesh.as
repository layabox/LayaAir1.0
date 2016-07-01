package laya.d3.core.fileModel {
	import laya.d3.core.material.Material;
	import laya.d3.core.render.RenderObject;
	import laya.d3.core.render.RenderQuene;
	import laya.d3.core.render.RenderState;
	import laya.d3.resource.tempelet.SubMeshTemplet;
	
	/**
	 * <code>SkyMesh</code> 类用于创建网格天空。
	 */
	public class SkyMesh extends Mesh {
		
		/**
		 * 创建一个 <code>SkyMesh</code> 实例。
		 */
		public function SkyMesh() {
			super();
		}
		
		/**
		 * @private
		 */
		override protected function _addToRenderQuene(state:RenderState, material:Material):RenderObject {
			return state.scene.getRenderObject(RenderQuene.NONEWRITEDEPTH)
		}
		
		/**
		 * @private
		 */
		override protected function _praseSubMeshTemplet(subMeshTemplet:SubMeshTemplet):SubMesh {
			return new SkySubMesh(subMeshTemplet);
		}
	
	}
}