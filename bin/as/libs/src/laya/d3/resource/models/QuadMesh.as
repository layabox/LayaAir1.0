package laya.d3.resource.models
{
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexPositionNormalTexture;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>QuadMesh</code> 类用于创建四边形。
	 */
	public class QuadMesh extends PrimitiveMesh
	{
		/** @private */
		private var _long:Number;
		/** @private */
		private var _width:Number;
		
		/**
		 * 返回长度
		 * @return 长
		 */
		public function get long():Number
		{
			return _long;
		}
		
		/**
		 * 设置长度（改变此属性会重新生成顶点和索引）
		 * @param  value 长度
		 */
		public function set long(value:Number):void
		{
			_long = value;
			recreateResource();
		}
		
		/**
		 * 返回宽度
		 * @return 宽
		 */
		public function get width():Number
		{
			return _width;
		}
		
		/**
		 * 设置宽度（改变此属性会重新生成顶点和索引）
		 * @param  value 宽度
		 */
		public function set width(value:Number):void
		{
			_width = value;
			recreateResource();
		}
		
		/**
		 * 创建一个四边形模型
		 * @param long  长
		 * @param width 宽
		 */
		public function QuadMesh(long:Number = 1, width:Number = 1)
		{
			super();
			_long = long;
			_width = width;
			recreateResource();
			_loaded = true;
			_generateBoundingObject();
		}
		
		override protected function recreateResource():void
		{
			startCreate();
			
			_numberVertices = 4;
			_numberIndices = 6;
			var indices:Uint16Array = new Uint16Array(_numberIndices);
			//定义顶点数据结构
			var vertexDeclaration:VertexDeclaration = VertexPositionNormalTexture.vertexDeclaration;
			//单个顶点数据个数,总共字节数/单个字节数
			var vertexFloatStride:int = vertexDeclaration.vertexStride / 4;
			//顶点数组长度
			var vertices:Float32Array = new Float32Array(_numberVertices * vertexFloatStride);
			
			var halfLong:Number = _long / 2;
			var halfWidth:Number = _width / 2;
			
			var verticeIndex:int = 0;
			vertices[0 + verticeIndex * 8] = -halfLong;
			vertices[1 + verticeIndex * 8] = 0;
			vertices[2 + verticeIndex * 8] = -halfWidth;
			vertices[3 + verticeIndex * 8] = 0;
			vertices[4 + verticeIndex * 8] = 1;
			vertices[5 + verticeIndex * 8] = 0;
			vertices[6 + verticeIndex * 8] = 0;
			vertices[7 + verticeIndex * 8] = 0;
			
			verticeIndex++;
			vertices[0 + verticeIndex * 8] = halfLong;
			vertices[1 + verticeIndex * 8] = 0;
			vertices[2 + verticeIndex * 8] = -halfWidth;
			vertices[3 + verticeIndex * 8] = 0;
			vertices[4 + verticeIndex * 8] = 1;
			vertices[5 + verticeIndex * 8] = 0;
			vertices[6 + verticeIndex * 8] = 1;
			vertices[7 + verticeIndex * 8] = 0;
			
			verticeIndex++;
			vertices[0 + verticeIndex * 8] = halfLong;
			vertices[1 + verticeIndex * 8] = 0;
			vertices[2 + verticeIndex * 8] = halfWidth;
			vertices[3 + verticeIndex * 8] = 0;
			vertices[4 + verticeIndex * 8] = 1;
			vertices[5 + verticeIndex * 8] = 0;
			vertices[6 + verticeIndex * 8] = 1;
			vertices[7 + verticeIndex * 8] = 1;
			
			verticeIndex++;
			vertices[0 + verticeIndex * 8] = -halfLong;
			vertices[1 + verticeIndex * 8] = 0;
			vertices[2 + verticeIndex * 8] = halfWidth;
			vertices[3 + verticeIndex * 8] = 0;
			vertices[4 + verticeIndex * 8] = 1;
			vertices[5 + verticeIndex * 8] = 0;
			vertices[6 + verticeIndex * 8] = 0;
			vertices[7 + verticeIndex * 8] = 1;
			
			var indiceIndex:int = 0;
			indices[0 + indiceIndex * 3] = 0;
			indices[1 + indiceIndex * 3] = 1;
			indices[2 + indiceIndex * 3] = 3;
			
			indiceIndex++;
			indices[0 + indiceIndex * 3] = 1;
			indices[1 + indiceIndex * 3] = 2;
			indices[2 + indiceIndex * 3] = 3;
			
			//初始化顶点缓冲
			_vertexBuffer = new VertexBuffer3D(vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, true);
			//初始化索引缓冲
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW, true);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			memorySize = (_vertexBuffer.byteLength + _indexBuffer.byteLength) * 2;//修改占用内存
			
			completeCreate();
		}
	
	}

}