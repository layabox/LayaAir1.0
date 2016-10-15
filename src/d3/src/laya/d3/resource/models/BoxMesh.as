package laya.d3.resource.models {
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexPositionNormalTexture;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Vector3;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.Buffer;
	
	/**
	 * <code>Sphere</code> 类用于创建球体。
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
			_long = value;
			recreateResource();
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
			_width = value;
			recreateResource();
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
			_height = value;
			recreateResource();
		}
		
		/**
		 * 创建一个球体模型
		 * @param radius 半径
		 * @param stacks 水平层数
		 * @param slices 垂直层数
		 */
		public function BoxMesh(long:Number = 1, width:Number = 1, height:int = 1) {
			super();
			_long = long;
			_width = width;
			_height = height;
			recreateResource();
			_loaded = true;
			
			var pos:Vector.<Vector3> = positions;
			_boundingBox = new BoundBox(new Vector3(), new Vector3());
			BoundBox.createfromPoints(pos, _boundingBox);
			_boundingSphere = new BoundSphere(new Vector3(), 0);
			BoundSphere.createfromPoints(pos, _boundingSphere);
		}
		override protected function recreateResource():void {
			//(this._released) || (dispose());//如果已存在，则释放资源
			startCreate();
			_numberVertices = 24;
			_numberIndices = 36;
			var indices:Uint16Array = new Uint16Array(_numberIndices);
			var vertexDeclaration:VertexDeclaration = VertexPositionNormalTexture.vertexDeclaration;
			var vertexFloatStride:int = vertexDeclaration.vertexStride / 4;
			var vertices:Float32Array = new Float32Array(_numberVertices*vertexFloatStride);
			var halfLong:Number = _long / 2;
			var halfWidth:Number = _width / 2;
			//上
			var nPointNum:int = 0;
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 1; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 1; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 1; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 1;nPointNum+=8;
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 1; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 1;nPointNum+=8;
			//下
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = -1; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = -1; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = -1; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 1;nPointNum+=8;
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = -1; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 1;nPointNum+=8;
			//左
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = -1; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = -1; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = -1; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 1;nPointNum+=8;
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = -1; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 1;nPointNum+=8;
			//右
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = 1; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = 1; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = 1; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 1;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = 1; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 0;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 1;nPointNum+=8;
			//前
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 1;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 1;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 1;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 1;nPointNum+=8;
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = 1;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 1;nPointNum+=8;
			//后
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = -1;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = _height; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = -1;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 0;nPointNum+=8;
			vertices[nPointNum + 0] = halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = -1;
			vertices[nPointNum + 6] = 0; vertices[nPointNum + 7] = 1;nPointNum+=8;
			vertices[nPointNum + 0] = -halfLong; vertices[nPointNum + 1] = 0; vertices[nPointNum + 2] = -halfWidth;
			vertices[nPointNum + 3] = 0; vertices[nPointNum + 4] = 0; vertices[nPointNum + 5] = -1;
			vertices[nPointNum + 6] = 1; vertices[nPointNum + 7] = 1;
			//indexBuffer 分别是 上 下 左 右  前 后
			var nFaceNum:int = 0;
			indices[nFaceNum + 0] = 0; indices[nFaceNum + 1] = 1; indices[nFaceNum + 2] = 2; nFaceNum += 3;
			indices[nFaceNum + 0] = 2; indices[nFaceNum + 1] = 3; indices[nFaceNum + 2] = 0; nFaceNum += 3;
			indices[nFaceNum + 0] = 4; indices[nFaceNum + 1] = 7; indices[nFaceNum + 2] = 6; nFaceNum += 3;
			indices[nFaceNum + 0] = 6; indices[nFaceNum + 1] = 5; indices[nFaceNum + 2] = 4; nFaceNum += 3;
			indices[nFaceNum + 0] = 8; indices[nFaceNum + 1] = 9; indices[nFaceNum + 2] = 10; nFaceNum += 3;
			indices[nFaceNum + 0] = 10; indices[nFaceNum + 1] = 11; indices[nFaceNum + 2] = 8; nFaceNum += 3;
			indices[nFaceNum + 0] = 12; indices[nFaceNum + 1] = 15; indices[nFaceNum + 2] = 14; nFaceNum += 3;
			indices[nFaceNum + 0] = 14; indices[nFaceNum + 1] = 13; indices[nFaceNum + 2] = 12; nFaceNum += 3;
			indices[nFaceNum + 0] = 16; indices[nFaceNum + 1] = 17; indices[nFaceNum + 2] = 18; nFaceNum += 3;
			indices[nFaceNum + 0] = 18; indices[nFaceNum + 1] = 19; indices[nFaceNum + 2] = 16; nFaceNum += 3;
			indices[nFaceNum + 0] = 20; indices[nFaceNum + 1] = 23; indices[nFaceNum + 2] = 22; nFaceNum += 3;
			indices[nFaceNum + 0] = 22; indices[nFaceNum + 1] = 21; indices[nFaceNum + 2] = 20;
			//
			_vertexBuffer = new VertexBuffer3D(vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, true);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW, true);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			memorySize = (_vertexBuffer.byteLength + _indexBuffer.byteLength) * 2;//修改占用内存,upload()到GPU后CPU中和GPU中各占一份内存
			completeCreate();
		}
	}
}