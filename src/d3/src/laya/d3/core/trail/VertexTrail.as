package laya.d3.core.trail
{
	import laya.d3.graphics.IVertex;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	import laya.d3.math.Vector3;
	/**
	 * <code>VertexTrail</code> 类用于创建拖尾顶点结构。
	 */
	public class VertexTrail implements IVertex
	{
		public static const TRAIL_POSITION0:int = 0;
		public static const TRAIL_OFFSETVECTOR:int = 1;
		public static const TRAIL_TIME0:int = 2;
		public static const TRAIL_TEXTURECOORDINATE0Y:int = 3;
		public static const TRAIL_TEXTURECOORDINATE0X:int = 4;
		
		private static const _vertexDeclaration1:VertexDeclaration = new VertexDeclaration(32, 
		[new VertexElement(0, VertexElementFormat.Vector3, VertexTrail.TRAIL_POSITION0), 
		new VertexElement(12, VertexElementFormat.Vector3, VertexTrail.TRAIL_OFFSETVECTOR),
		new VertexElement(24, VertexElementFormat.Single, VertexTrail.TRAIL_TIME0), 
		new VertexElement(28, VertexElementFormat.Single, VertexTrail.TRAIL_TEXTURECOORDINATE0Y)]);
		
		private static const _vertexDeclaration2:VertexDeclaration = new VertexDeclaration(4, 
		[new VertexElement(0, VertexElementFormat.Single, VertexTrail.TRAIL_TEXTURECOORDINATE0X)]);
		
		public static function get vertexDeclaration1():VertexDeclaration
		{
			return _vertexDeclaration1;
		}
		
		public static function get vertexDeclaration2():VertexDeclaration
		{
			return _vertexDeclaration2;
		}
		
		public function get vertexDeclaration():VertexDeclaration
		{
			return _vertexDeclaration1;
		}
		
		public function VertexTrail()
		{
			
		}
	}
}