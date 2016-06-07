package laya.webgl.utils {
	
	/**
	 * ...
	 * @author ...
	 */
	public class VertexDeclaration {
		private var _vertexStride:int;
		
		public function get vertexStride():int {
			return _vertexStride;
		}
		
		public function VertexDeclaration(vertexStride:int) {
			_vertexStride = vertexStride;
		}
	
	}

}