package laya.d3.core.render {
	
	/**
	 * @private
	 */
	public class SubMeshRenderElement extends RenderElement {
		/** @private */
		public var _batchIndexStart:int;
		/** @private */
		public var _batchIndexEnd:int;
		/** @private */
		public var _skinAnimationDatas:Vector.<Float32Array>;//TODO:
		
		public function SubMeshRenderElement() {
			super();
		}
	
	}

}