package laya.d3.terrain {
	import laya.d3.core.GeometryFilter;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexPositionTerrain;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>MeshFilter</code> 类用于创建网格过滤器。
	 */
	public class TerrainFilter extends GeometryFilter  implements IRenderable {
		/** @private */
		public var _owner:TerrainChunk;
		public var _indexOfHost:int;
		public var _gridXNum:int;
		public var _gridZNum:int;
		public var _gridSize:int;
		public var _sizeOfY:Vector2;
		public var memorySize:int;
		protected var _numberVertices:int;
		protected var _numberIndices:int;
		protected var _numberTriangle:int;
		protected var _vertexBuffer:VertexBuffer3D;
		protected var _indexBuffer:IndexBuffer3D;
		protected var _boundingSphere:BoundSphere;
		protected var _boundingBox:BoundBox;
		public var _boundingBoxCorners:Vector.<Vector3>;
		public var bUseStrip:Boolean = true;
		/**
		 * 创建一个新的 <code>MeshFilter</code> 实例。
		 * @param owner 所属网格精灵。
		 */
		public function TerrainFilter(owner:TerrainChunk,gridXNum:int,gridZNum:int,gridSize:int) {
			_owner = owner;
			_gridXNum = gridXNum;
			_gridZNum = gridZNum;
			_gridSize = gridSize;
			recreateResource();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get _isAsyncLoaded():Boolean {
			//TODO
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get _originalBoundingSphere():BoundSphere {
			return _boundingSphere;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get _originalBoundingBox():BoundBox {
			return _boundingBox;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _destroy():void {
			super._destroy();
			_owner = null;
			if(_vertexBuffer) _vertexBuffer.dispose();
			if(_indexBuffer) _indexBuffer.dispose();
		}
		
		protected function recreateResource():void 
		{
			if (bUseStrip === false)
			{
				_numberVertices = (_gridXNum + 1) * (_gridZNum + 1);
				_numberTriangle = _gridXNum * _gridZNum * 2;
				_numberIndices = _numberTriangle * 3;
				var indices:Uint16Array = new Uint16Array(_numberIndices);
				var vertexDeclaration:VertexDeclaration = VertexPositionTerrain.vertexDeclaration;
				var vertexFloatStride:int = vertexDeclaration.vertexStride / 4;
				var vertices:Float32Array = new Float32Array(_numberVertices * vertexFloatStride);
				var nNum:int = 0;
				for( var i:int = 0,n:int = _gridXNum + 1 ; i < n; i++ )
				{
					for( var j:int = 0,n1:int = _gridZNum + 1 ; j < n1; j++ )
					{
						vertices[nNum] = i * _gridSize; nNum++; vertices[nNum] = 0; nNum++; vertices[nNum] = j * _gridSize; nNum++;
						vertices[nNum] = 0; nNum++; vertices[nNum] = 1; nNum++; vertices[nNum] = 0; nNum++;
						vertices[nNum] = i/_gridXNum; nNum++; vertices[nNum] = j/_gridZNum; nNum++;
						vertices[nNum] = i; nNum++; vertices[nNum] = j; nNum++;
					}
				}
				nNum = 0;
				for( j = 0; j < _gridZNum; j++ )
				{
					for( i = 0; i < _gridXNum; i++ )
					{
						indices[nNum] = ( j + 1 ) * (_gridXNum + 1) + i;nNum++;
						indices[nNum] = ( j + 1 ) * (_gridXNum + 1) + i + 1;nNum++;
						indices[nNum] = j * ( _gridXNum + 1 )  + i + 1; nNum++;
						indices[nNum] = j * ( _gridXNum + 1 )  + i + 1; nNum++;
						indices[nNum] = j * ( _gridXNum + 1 ) + i;nNum++;
						indices[nNum] = ( j + 1 ) * ( _gridXNum + 1 ) + i;nNum++;
					}
				}
			}
			else 
			{
				_numberVertices = (_gridXNum + 1) * (_gridZNum + 1);
				_numberTriangle = _gridXNum * _gridZNum * 2;//不算退化三角形？
				_numberIndices = _gridXNum * 2 * (_gridZNum + 1) + (_gridXNum - 1);
				indices = new Uint16Array(_numberIndices);
				vertexDeclaration = VertexPositionTerrain.vertexDeclaration;
				vertexFloatStride = vertexDeclaration.vertexStride / 4;
				vertices = new Float32Array(_numberVertices * vertexFloatStride);
				nNum = 0;
				for( i = 0,n = _gridXNum + 1 ; i < n; i++ )
				{
					for( j = 0, n1= _gridZNum + 1 ; j < n1; j++ )
					{
						vertices[nNum] = i * _gridSize; nNum++; vertices[nNum] = 0; nNum++; vertices[nNum] = j * _gridSize; nNum++;
						vertices[nNum] = 0; nNum++; vertices[nNum] = 1; nNum++; vertices[nNum] = 0; nNum++;
						vertices[nNum] = i/_gridXNum; nNum++; vertices[nNum] = j/_gridZNum; nNum++;
						vertices[nNum] = i; nNum++; vertices[nNum] = j; nNum++;
					}
				}
				nNum = 0;
				var currentVertex:int = 0;
				var topToBottom:Boolean = true;
				for( j = 0; j < _gridXNum; j++ )
				{
					for( i = 0; i < _gridZNum + 1; i++ )
					{
						indices[nNum] = currentVertex;nNum++;
						indices[nNum] = currentVertex + _gridZNum + 1; nNum++;
						
						if (i < _gridZNum)
						{
							currentVertex = topToBottom ? currentVertex + 1 : currentVertex -1;
						}
					}
					topToBottom = !topToBottom;
					currentVertex += _gridZNum + 1;
					indices[nNum] = currentVertex; nNum++;
				}
			}
			_sizeOfY = new Vector2(-_gridSize, _gridSize);
			_vertexBuffer = new VertexBuffer3D(vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, true);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW, true);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			memorySize = (_vertexBuffer.byteLength + _indexBuffer.byteLength) * 2;//修改占用内存,upload()到GPU后CPU中和GPU中各占一份内存
			calcBoudingBoxAndSphere();
		}
		public function calcBoudingBoxAndSphere():void
		{
			var min:Vector3 = new Vector3( 0, _sizeOfY.x, 0 );
			var max:Vector3 = new Vector3( _gridXNum * _gridSize, _sizeOfY.y, _gridZNum * _gridSize );
			_boundingBox = new BoundBox(min, max);
			var size:Vector3 = new Vector3();
			Vector3.subtract( max, min, size );
			Vector3.scale(size, 0.5, size);
			_boundingSphere = new BoundSphere(size, Vector3.scalarLength(size));
			_boundingBoxCorners = new Vector.<Vector3>(8);
			_boundingBox.getCorners(_boundingBoxCorners);
		}
		public function get _vertexBufferCount():int
		{
			return _numberVertices;
		}
		public function get indexOfHost():int
		{
			return _indexOfHost;
		}
		public function get triangleCount():int
		{
			return _numberTriangle;
		}
		public function _getVertexBuffer(index:int = 0):VertexBuffer3D
		{
			if ( index == 0)
			{
				return _vertexBuffer;
			}
			return null;
		}
		public function _getIndexBuffer():IndexBuffer3D
		{
			return _indexBuffer;
		}
		public function _beforeRender(state:RenderState):Boolean
		{
			_vertexBuffer._bind();
			_indexBuffer._bind();
			return  true;
		}
		public function _render(state:RenderState):void
		{
			WebGL.mainContext.drawElements((bUseStrip === true) ? WebGLContext.TRIANGLE_STRIP : WebGLContext.TRIANGLES, _numberIndices, WebGLContext.UNSIGNED_SHORT, 0);
			Stat.drawCall++;
			Stat.trianglesFaces += _numberTriangle;
		}
		public function _renderRuntime(conchGraphics3D:*, renderElement:RenderElement, state:RenderState):void
		{
			//TODO
		}
	}
}