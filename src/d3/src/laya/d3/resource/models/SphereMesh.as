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
	public class SphereMesh extends PrimitiveMesh {
		/** @private */
		private var _radius:Number;
		/** @private */
		private var _slices:int;
		/** @private */
		private var _stacks:int;
		
		/**
		 * 返回半径
		 * @return 半径
		 */
		public function get radius():Number {
			return _radius;
		}
		
		/**
		 * 设置半径（改变此属性会重新生成顶点和索引）
		 * @param  value 半径
		 */
		public function set radius(value:Number):void {
			_radius = value;
			recreateResource();
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
			_slices = value;
			recreateResource();
		}
		
		/**
		 * 获取高度分段
		 * @return 高度分段
		 */
		public function get stacks():int {
			return _stacks;
		}
		
		/**
		 * 设置高度分段（改变此属性会重新生成顶点和索引）
		 * @param  value高度分段
		 */
		public function set stacks(value:int):void {
			_stacks = value;
			recreateResource();
		}
		
		/**
		 * 创建一个球体模型
		 * @param radius 半径
		 * @param stacks 水平层数
		 * @param slices 垂直层数
		 */
		public function SphereMesh(radius:Number = 10, stacks:int = 8, slices:int = 8) {
			super();
			_radius = radius;
			_stacks = stacks;
			_slices = slices;
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
			_numberVertices = (_stacks + 1) * (_slices + 1);
			_numberIndices = (3 * _stacks * (_slices + 1)) * 2;
			
			var indices:Uint16Array = new Uint16Array(_numberIndices);
			var vertexDeclaration:VertexDeclaration = VertexPositionNormalTexture.vertexDeclaration;
			var vertexFloatStride:int = vertexDeclaration.vertexStride / 4;
			var vertices:Float32Array = new Float32Array(_numberVertices * vertexFloatStride);
			
			var stackAngle:Number = Math.PI / _stacks;
			var sliceAngle:Number = (Math.PI * 2.0) / _slices;
			
			// Generate the group of Stacks for the sphere  
			var vertexIndex:int = 0;
			var vertexCount:int = 0;
			var indexCount:int = 0;
			
			for (var stack:int = 0; stack < (_stacks + 1); stack++) {
				var r:Number = Math.sin(stack * stackAngle);
				var y:Number = Math.cos(stack * stackAngle);
				
				// Generate the group of segments for the current Stack  
				for (var slice:int = 0; slice < (_slices + 1); slice++) {
					var x:Number = r * Math.sin(slice * sliceAngle);
					var z:Number = r * Math.cos(slice * sliceAngle);
					vertices[vertexCount + 0] = x * _radius;
					vertices[vertexCount + 1] = y * _radius;
					vertices[vertexCount + 2] = z * _radius;
					
					vertices[vertexCount + 3] = x;
					vertices[vertexCount + 4] = y;
					vertices[vertexCount + 5] = z;
					
					vertices[vertexCount + 6] = slice / _slices;
					vertices[vertexCount + 7] = stack / _stacks;
					vertexCount += vertexFloatStride;
					if (stack != (_stacks - 1)) {
						// First Face
						indices[indexCount++] = vertexIndex + (_slices + 1);
						indices[indexCount++] = vertexIndex;
						indices[indexCount++] = vertexIndex + 1;
						// Second 
						indices[indexCount++] = vertexIndex + (_slices);
						indices[indexCount++] = vertexIndex;
						indices[indexCount++] = vertexIndex + (_slices + 1);
						vertexIndex++;
					}
				}
			}
			
			_vertexBuffer = new VertexBuffer3D(vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, true);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW, true);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			memorySize = (_vertexBuffer.byteLength + _indexBuffer.byteLength) * 2;//修改占用内存,upload()到GPU后CPU中和GPU中各占一份内存
			completeCreate();
		}
	}
}