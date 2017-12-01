package laya.d3.resource.models {
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexPositionNormalTexture;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>QuadMesh</code> 类用于创建平面。
	 */
	public class PlaneMesh extends PrimitiveMesh {
		/** @private */
		private var _long:Number;
		/** @private */
		private var _width:Number;
		/** @private */
		private var _stacks:int;
		/** @private */
		private var _slices:int;
		
		/**
		 * 返回长度
		 * @return 长
		 */
		public function get long():Number {
			return _long;
		}
		
		/**
		 * 设置长度（改变此属性会重新生成顶点和索引）
		 * @param  value 长度
		 */
		public function set long(value:Number):void {
			if (_long !== value) {
				_long = value;
				releaseResource();
				activeResource();
			}
		}
		
		/**
		 * 返回宽度
		 * @return 宽
		 */
		public function get width():Number {
			return _width;
		}
		
		/**
		 * 设置宽度（改变此属性会重新生成顶点和索引）
		 * @param  value 宽度
		 */
		public function set width(value:Number):void {
			if (_width !== value) {
				_width = value;
				releaseResource();
				activeResource();
			}
		}
		
		/**
		 * 获取长度分段
		 * @return 长度分段
		 */
		public function get stacks():int {
			return _stacks;
		}
		
		/**
		 * 设置长度分段（改变此属性会重新生成顶点和索引）
		 * @param  value长度分段
		 */
		public function set stacks(value:int):void {
			if (_stacks !== value) {
				_stacks = value;
				releaseResource();
				activeResource();
			}
		}
		
		/**
		 * 获取宽度分段
		 * @return 宽度分段
		 */
		public function get slices():int {
			return _slices;
		}
		
		/**
		 * 设置宽度分段（改变此属性会重新生成顶点和索引）
		 * @param  value 宽度分段
		 */
		public function set slices(value:int):void {
			if (_slices !== value) {
				_slices = value;
				releaseResource();
				activeResource();
			}
		}
		
		/**
		 * 创建一个平面模型
		 * @param long  长
		 * @param width 宽
		 */
		public function PlaneMesh(long:Number = 10, width:Number = 10, stacks:int = 10, slices:int = 10) {
			super();
			_long = long;
			_width = width;
			_stacks = stacks;
			_slices = slices;
			activeResource();
			_positions = _getPositions();
			_generateBoundingObject();
		}
		
		override protected function recreateResource():void {
			_numberVertices = (_stacks + 1) * (_slices + 1);
			_numberIndices = _stacks * _slices * 2 * 3;
			var indices:Uint16Array = new Uint16Array(_numberIndices);
			//定义顶点数据结构
			var vertexDeclaration:VertexDeclaration = VertexPositionNormalTexture.vertexDeclaration;
			//单个顶点数据个数,总共字节数/单个字节数
			var vertexFloatStride:int = vertexDeclaration.vertexStride / 4;
			//顶点数组长度
			var vertices:Float32Array = new Float32Array(_numberVertices * vertexFloatStride);
			
			var halfLong:Number = _long / 2;
			var halfWidth:Number = _width / 2;
			var stacksLong:Number = _long / _stacks;
			var slicesWidth:Number = _width / _slices;
			
			var verticeCount:int = 0;
			
			for (var i:int = 0; i <= _slices; i++) {
				
				for (var j:int = 0; j <= _stacks; j++) {
					
					vertices[verticeCount++] = j * stacksLong - halfLong;
					vertices[verticeCount++] = 0;
					vertices[verticeCount++] = i * slicesWidth - halfWidth;
					vertices[verticeCount++] = 0;
					vertices[verticeCount++] = 1;
					vertices[verticeCount++] = 0;
					vertices[verticeCount++] = j * 1 / _stacks;
					vertices[verticeCount++] = i * 1 / _slices;
				}
			}
			
			var indiceIndex:int = 0;
			
			for (i = 0; i < _slices; i++) {
				
				for (j = 0; j < _stacks; j++) {
					
					indices[indiceIndex++] = (i + 1) * (_stacks + 1) + j;
					indices[indiceIndex++] = i * (_stacks + 1) + j;
					indices[indiceIndex++] = (i + 1) * (_stacks + 1) + j + 1;
					
					indices[indiceIndex++] = i * (_stacks + 1) + j;
					indices[indiceIndex++] = i * (_stacks + 1) + j + 1;
					indices[indiceIndex++] = (i + 1) * (_stacks + 1) + j + 1;
				}
			}
			
			//初始化顶点缓冲
			_vertexBuffer = new VertexBuffer3D(vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, true);
			//初始化索引缓冲
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW, true);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			memorySize = (_vertexBuffer._byteLength + _indexBuffer._byteLength) * 2;//修改占用内存
			
			completeCreate();
		}
	
	}

}