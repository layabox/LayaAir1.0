package laya.d3.graphics 
{
	import laya.d3.math.Vector3;
	public class VertexPosition implements IVertex 
	{
		private static const _vertexDeclaration:VertexDeclaration = new VertexDeclaration( 12, [
		new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.POSITION0)]);
		
		/* INTERFACE laya.d3.graphics.IVertex */
		public static function get vertexDeclaration():VertexDeclaration 
		{
			return _vertexDeclaration;
		}
		
		private var _position:Vector3;
		
		public function get position():Vector3
		{
			return _position;
		}
		
		public function get vertexDeclaration():VertexDeclaration {
			return _vertexDeclaration;
		}
		
		public function VertexPosition(position:Vector3) 
		{
			_position = position;
		}
	}
}