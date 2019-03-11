package laya.d3.core.pixelLine 
{
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	/**
	 * ...
	 * @author 
	 */
	public class PixelLineVertex 
	{
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration(28, 
		[new VertexElement(0, VertexElementFormat.Vector3, VertexMesh.MESH_POSITION0), 
		new VertexElement(12, VertexElementFormat.Vector4, VertexMesh.MESH_COLOR0)]);
		
		public static function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration;
		}
		
		public function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration;
		}
		
		public function PixelLineVertex() 
		{
			
		}
		
	}

}