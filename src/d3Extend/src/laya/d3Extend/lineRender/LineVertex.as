package laya.d3.extension.lineRender 
{
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	/**
	 * @author 
	 * ...
	 */
	public class LineVertex 
	{
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration(36, 
		[new VertexElement(0, VertexElementFormat.Vector3, VertexMesh.MESH_POSITION0), 
		new VertexElement(12, VertexElementFormat.Vector4, VertexMesh.MESH_COLOR0),
		new VertexElement(28, VertexElementFormat.Vector2, VertexMesh.MESH_TEXTURECOORDINATE0)]);
		
		public static function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration;
		}
		
		public function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration;
		}
		
		public function LineVertex()
		{
			
		}
	}

}