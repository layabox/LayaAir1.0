package laya.d3.resource.models {
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexPositionNormalTexture;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>Sphere</code> 类用于创建方体。
	 */
	public class BoxMesh extends PrimitiveMesh {
		/** @private */
		private var _long:Number;
		/** @private */
		private var _width:Number;
		/** @private */
		private var _height:Number;
		
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
		 * 返回高度
		 * @return 高
		 */
		public function get height():Number {
			return _height;
		}
		
		/**
		 * 设置高度（改变此属性会重新生成顶点和索引）
		 * @param  value 高度
		 */
		public function set height(value:Number):void {
			if (_height !== value) {
				_height = value;
				releaseResource();
				activeResource();
			}
		}
		
		/**
		 * 创建一个方体模型
		 * @param radius 半径
		 * @param stacks 水平层数
		 * @param slices 垂直层数
		 */
		public function BoxMesh(long:Number = 1, width:Number = 1, height:int = 1) {
			super();
			_long = long;
			_width = width;
			_height = height;
			activeResource();
			_positions = _getPositions();
			_generateBoundingObject();
		}
		
		override protected function recreateResource():void {
			_numberVertices = 24;
			_numberIndices = 36;
			
			var vertexDeclaration:VertexDeclaration = VertexPositionNormalTexture.vertexDeclaration;
			var vertexFloatStride:int = vertexDeclaration.vertexStride / 4;
			
			var halfLong:Number = _long / 2;
			var halfHeight:Number = _height / 2;
			var halfWidth:Number = _width / 2;
			
			var vertices:Float32Array = new Float32Array([
			//上
			-halfLong, halfHeight, -halfWidth, 0, 1, 0, 0, 0, halfLong, halfHeight, -halfWidth, 0, 1, 0, 1, 0, halfLong, halfHeight, halfWidth, 0, 1, 0, 1, 1, -halfLong, halfHeight, halfWidth, 0, 1, 0, 0, 1, 
			//下
			-halfLong, -halfHeight, -halfWidth, 0, -1, 0, 0, 1, halfLong, -halfHeight, -halfWidth, 0, -1, 0, 1, 1, halfLong, -halfHeight, halfWidth, 0, -1, 0, 1, 0, -halfLong, -halfHeight, halfWidth, 0, -1, 0, 0, 0, 
			//左
			-halfLong, halfHeight, -halfWidth, -1, 0, 0, 0, 0, -halfLong, halfHeight, halfWidth, -1, 0, 0, 1, 0, -halfLong, -halfHeight, halfWidth, -1, 0, 0, 1, 1, -halfLong, -halfHeight, -halfWidth, -1, 0, 0, 0, 1, 
			//右
			halfLong, halfHeight, -halfWidth, 1, 0, 0, 1, 0, halfLong, halfHeight, halfWidth, 1, 0, 0, 0, 0, halfLong, -halfHeight, halfWidth, 1, 0, 0, 0, 1, halfLong, -halfHeight, -halfWidth, 1, 0, 0, 1, 1, 
			//前
			-halfLong, halfHeight, halfWidth, 0, 0, 1, 0, 0, halfLong, halfHeight, halfWidth, 0, 0, 1, 1, 0, halfLong, -halfHeight, halfWidth, 0, 0, 1, 1, 1, -halfLong, -halfHeight, halfWidth, 0, 0, 1, 0, 1, 
			//后
			-halfLong, halfHeight, -halfWidth, 0, 0, -1, 1, 0, halfLong, halfHeight, -halfWidth, 0, 0, -1, 0, 0, halfLong, -halfHeight, -halfWidth, 0, 0, -1, 0, 1, -halfLong, -halfHeight, -halfWidth, 0, 0, -1, 1, 1]);
			
			var indices:Uint16Array = new Uint16Array([
			//上
			0, 1, 2, 2, 3, 0, 
			//下
			4, 7, 6, 6, 5, 4, 
			//左
			8, 9, 10, 10, 11, 8, 
			//右
			12, 15, 14, 14, 13, 12, 
			//前
			16, 17, 18, 18, 19, 16, 
			//后
			20, 23, 22, 22, 21, 20]);
			
			_vertexBuffer = new VertexBuffer3D(vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, true);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW, true);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			memorySize = (_vertexBuffer._byteLength + _indexBuffer._byteLength) * 2;//修改占用内存,upload()到GPU后CPU中和GPU中各占一份内存
			completeCreate();
		}
	}
}