package laya.d3.core.fileModel {
	import laya.d3.core.render.RenderState;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.resource.tempelet.SubMeshTemplet;
	
	/**
	 * <code>SkySubMesh</code> 类用于创建天空子网格。
	 */
	public class SkySubMesh extends SubMesh {
		/** @private */
		private var _oriPosition:Vector3 = new Vector3();
		/** @private */
		private var _loaded:Boolean = false
		/** @private */
		private var _tempVector3:Vector3 = new Vector3();
		
		/**
		 * 创建一个 <code>SkySubMesh</code> 实例。
		 */
		public function SkySubMesh(templet:SubMeshTemplet) {
			super(templet);
		}
		
		/**
		 * @private
		 * 渲染。
		 * @param	state 渲染状态。
		 */
		override public function _render(state:RenderState):Boolean {
			var position:Vector3 = state.owner.transform.position;//暂时这么做
			if (!_loaded) {
				_oriPosition.elements[0] = position.x;
				_oriPosition.elements[1] = position.y;
				_oriPosition.elements[2] = position.z;
				_loaded = true;
			}
			var mat:Matrix4x4 = new Matrix4x4();
			state.viewMatrix.invert(mat);
			_tempVector3.elements[0] = _oriPosition.x + mat.elements[12];
			_tempVector3.elements[1] = _oriPosition.y + mat.elements[13];
			_tempVector3.elements[2] = _oriPosition.z + mat.elements[14];
			state.owner.transform.position = _tempVector3;
			state.owner.transform.getWorldMatrix(-1);
			
			return super._render(state);
		}
	}

}