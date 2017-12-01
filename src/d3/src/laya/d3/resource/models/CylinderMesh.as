package laya.d3.resource.models {
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexPositionNormalTexture;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>CylinderMesh</code> 类用于创建圆柱体。
	 */
	public class CylinderMesh extends PrimitiveMesh {
		/** @private */
		private var _radius:Number;
		/** @private */
		private var _height:Number;
		/** @private */
		private var _slices:int;
		
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
			if (_radius !== value) {
				_radius = value;
				releaseResource();
				activeResource();
			}
		}
		
		/**
		 * 返回高度
		 * @return 高度
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
		 * 创建一个圆柱体模型
		 * @param radius 半径
		 * @param height 高度
		 * @param slices 垂直层数
		 */
		public function CylinderMesh(radius:Number = 0.5, height:Number = 2, slices:int = 32) {
			super();
			_radius = radius;
			_height = height;
			_slices = slices;
			recreateResource();
			_positions = _getPositions();
			_generateBoundingObject();
		}
		
		override protected function recreateResource():void {
			//(this._released) || (dispose());//如果已存在，则释放资源
			_numberVertices = (_slices + 1 + 1) + (_slices + 1) * 2 + (_slices + 1 + 1);
			_numberIndices = 3 * _slices + 6 * _slices + 3 * _slices;
			
			//定义顶点数据结构
			var vertexDeclaration:VertexDeclaration = VertexPositionNormalTexture.vertexDeclaration;
			//单个顶点数据个数,总共字节数/单个字节数
			var vertexFloatStride:int = vertexDeclaration.vertexStride / 4;
			//顶点
			var vertices:Float32Array = new Float32Array(_numberVertices * vertexFloatStride);
			//顶点索引
			var indices:Uint16Array = new Uint16Array(_numberIndices);
			
			var sliceAngle:Number = (Math.PI * 2.0) / _slices;
			
			var halfHeight:Number = _height / 2;
			var curAngle:Number = 0;
			var verticeCount:Number = 0;
			var posX:Number = 0;
			var posY:Number = 0;
			var posZ:Number = 0;
			
			var vc:int = 0;
			var ic:int = 0;
			
			//顶
			for (var tv:int = 0; tv <= _slices; tv++) {
				
				if (tv === 0) {
					//pos
					vertices[vc++] = 0;
					vertices[vc++] = halfHeight;
					vertices[vc++] = 0;
					//normal
					vertices[vc++] = 0;
					vertices[vc++] = 1;
					vertices[vc++] = 0;
					//uv
					vertices[vc++] = 0.5;
					vertices[vc++] = 0.5;
					
				}
				
				curAngle = tv * sliceAngle;
				posX = Math.cos(curAngle) * _radius;
				posY = halfHeight;
				posZ = Math.sin(curAngle) * _radius;
				
				//pos
				vertices[vc++] = posX;
				vertices[vc++] = posY;
				vertices[vc++] = posZ;
				//normal
				vertices[vc++] = 0;
				vertices[vc++] = 1;
				vertices[vc++] = 0;
				
				//uv
				vertices[vc++] = 0.5 + Math.cos(curAngle) * 0.5;
				vertices[vc++] = 0.5 + Math.sin(curAngle) * 0.5;
			}
			
			for (var ti:int = 0; ti < _slices; ti++) {
				indices[ic++] = 0;
				indices[ic++] = ti + 1;
				indices[ic++] = ti + 2;
			}
			verticeCount += _slices + 1 + 1;
			
			//壁
			for (var rv:int = 0; rv <= _slices; rv++) {
				curAngle = rv * sliceAngle;
				posX = Math.cos(curAngle + Math.PI) * _radius;
				posY = halfHeight;
				posZ = Math.sin(curAngle + Math.PI) * _radius;
				
				//pos
				vertices[vc++] = posX;
				vertices[vc + (_slices + 1) * 8 - 1] = posX;
				vertices[vc++] = posY;
				vertices[vc + (_slices + 1) * 8 - 1] = -posY;
				vertices[vc++] = posZ;
				vertices[vc + (_slices + 1) * 8 - 1] = posZ;
				//normal
				vertices[vc++] = posX;
				vertices[vc + (_slices + 1) * 8 - 1] = posX;
				vertices[vc++] = 0;
				vertices[vc + (_slices + 1) * 8 - 1] = 0;
				vertices[vc++] = posZ;
				vertices[vc + (_slices + 1) * 8 - 1] = posZ;
				//uv    
				vertices[vc++] = 1 - rv * 1 / _slices;
				vertices[vc + (_slices + 1) * 8 - 1] = 1 - rv * 1 / _slices;
				vertices[vc++] = 0;
				vertices[vc + (_slices + 1) * 8 - 1] = 1;
				
			}
			
			vc += (_slices + 1) * 8;
			
			for (var ri:int = 0; ri < _slices; ri++) {
				indices[ic++] = ri + verticeCount + (_slices + 1);
				indices[ic++] = ri + verticeCount + 1;
				indices[ic++] = ri + verticeCount;
				
				indices[ic++] = ri + verticeCount + (_slices + 1);
				indices[ic++] = ri + verticeCount + (_slices + 1) + 1;
				indices[ic++] = ri + verticeCount + 1;
				
			}
			
			verticeCount += 2 * (_slices + 1);
			
			//底
			for (var bv:int = 0; bv <= _slices; bv++) {
				if (bv === 0) {
					//pos
					vertices[vc++] = 0;
					vertices[vc++] = -halfHeight;
					vertices[vc++] = 0;
					//normal
					vertices[vc++] = 0;
					vertices[vc++] = -1;
					vertices[vc++] = 0;
					//uv
					vertices[vc++] = 0.5;
					vertices[vc++] = 0.5;
					
				}
				
				curAngle = bv * sliceAngle;
				posX = Math.cos(curAngle + Math.PI) * _radius;
				posY = -halfHeight;
				posZ = Math.sin(curAngle + Math.PI) * _radius;
				
				//pos
				vertices[vc++] = posX;
				vertices[vc++] = posY;
				vertices[vc++] = posZ;
				//normal
				vertices[vc++] = 0;
				vertices[vc++] = -1;
				vertices[vc++] = 0;
				//uv
				vertices[vc++] = 0.5 + Math.cos(curAngle) * 0.5;
				vertices[vc++] = 0.5 + Math.sin(curAngle) * 0.5;
				
			}
			
			for (var bi:int = 0; bi < _slices; bi++) {
				indices[ic++] = 0 + verticeCount;
				indices[ic++] = bi + 2 + verticeCount;
				indices[ic++] = bi + 1 + verticeCount;
			}
			
			verticeCount += _slices + 1 + 1;
			_vertexBuffer = new VertexBuffer3D(vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, true);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW, true);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			memorySize = (_vertexBuffer._byteLength + _indexBuffer._byteLength) * 2;
			completeCreate();
		}
	}
}
