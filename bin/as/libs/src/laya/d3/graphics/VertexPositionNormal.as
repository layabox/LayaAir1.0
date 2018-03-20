package laya.d3.graphics 
{
	import laya.d3.math.Vector3;
	public class VertexPositionNormal implements IVertex 
	{
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration( 24, [
		new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0),
		new VertexElement(12, VertexElementFormat.Vector3, VertexElementUsage.NORMAL0)]);
		
		/* INTERFACE laya.d3.graphics.IVertex */
		public static function get vertexDeclaration():VertexDeclaration 
		{
			return _vertexDeclaration;
		}
		
		private var _position:Vector3;
		private var _normal:Vector3;
		
		public function get position():Vector3
		{
			return _position;
		}
		
		public function get normal():Vector3
		{
			return _normal;
		}
		
		public function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration;
		}
		
		public function VertexPositionNormal(position:Vector3, normal:Vector3) 
		{
			_position = position;
			_normal = normal;
		}
	}
}