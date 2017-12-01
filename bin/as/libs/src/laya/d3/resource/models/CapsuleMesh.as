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
	 * <code>CapsuleMesh</code> 类用于创建胶囊体。
	 */
	public class CapsuleMesh extends PrimitiveMesh {
		/** @private */
		private var _radius:Number;
		/** @private */
		private var _height:Number;
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
		 * 创建一个胶囊体模型
		 * @param radius 半径
		 * @param height 高度
		 * @param stacks 水平层数,一般设为垂直层数的一半
		 * @param slices 垂直层数
		 */
		public function CapsuleMesh(radius:Number = 0.5, height:Number = 2, stacks:int = 16, slices:int = 32) {
			super();
			_radius = radius;
			_height = height < radius * 2 ? radius * 2 : height;
			_stacks = stacks;
			_slices = slices;
			recreateResource();
			_positions = _getPositions();
			_generateBoundingObject();
		
		}
		
		override protected function recreateResource():void {
			_numberVertices = (_stacks + 1) * (slices + 1) * 2 + (_slices + 1) * 2;
			_numberIndices = (3 * _stacks * (_slices + 1)) * 2 * 2 + 2 * _slices * 3;
			
			//定义顶点数据结构
			var vertexDeclaration:VertexDeclaration = VertexPositionNormalTexture.vertexDeclaration;
			//单个顶点数据个数,总共字节数/单个字节数
			var vertexFloatStride:int = vertexDeclaration.vertexStride / 4;
			//顶点
			var vertices:Float32Array = new Float32Array(_numberVertices * vertexFloatStride);
			//顶点索引
			var indices:Uint16Array = new Uint16Array(_numberIndices);
			
			var stackAngle:Number = (Math.PI / 2.0) / _stacks;
			var sliceAngle:Number = (Math.PI * 2.0) / _slices;
			
			//圆柱体高度的一半
			var hcHeight:Number = _height / 2 - _radius;
			
			var posX:Number = 0;
			var posY:Number = 0;
			var posZ:Number = 0;
			
			var vc:int = 0;
			var ic:int = 0;
			
			var verticeCount:int = 0;
			
			var stack:int, slice:int;
			
			//顶部半球
			for (stack = 0; stack <= _stacks; stack++) {
				
				for (slice = 0; slice <= _slices; slice++) {
					
					posX = _radius * Math.cos(stack * stackAngle) * Math.cos(slice * sliceAngle + Math.PI);
					posY = _radius * Math.sin(stack * stackAngle);
					posZ = _radius * Math.cos(stack * stackAngle) * Math.sin(slice * sliceAngle + Math.PI);
					
					//pos
					vertices[vc++] = posX;
					vertices[vc++] = posY + hcHeight;
					vertices[vc++] = posZ;
					
					//normal
					vertices[vc++] = posX;
					vertices[vc++] = posY;
					vertices[vc++] = posZ;
					
					//uv
					vertices[vc++] = 1 - slice / _slices;
					vertices[vc++] = (1 - stack / _stacks) * ((Math.PI * _radius / 2) / (_height + Math.PI * _radius));
					
					if (stack < _stacks) {
						
						// First
						indices[ic++] = (stack * (_slices + 1)) + slice + (_slices + 1);
						indices[ic++] = (stack * (_slices + 1)) + slice;
						indices[ic++] = (stack * (_slices + 1)) + slice + 1;
						// Second
						indices[ic++] = (stack * (_slices + 1)) + slice + (_slices);
						indices[ic++] = (stack * (_slices + 1)) + slice;
						indices[ic++] = (stack * (_slices + 1)) + slice + (_slices + 1);
						
					}
					
				}
			}
			
			verticeCount += (_stacks + 1) * (_slices + 1);
			
			//底部半球
			for (stack = 0; stack <= _stacks; stack++) {
				
				for (slice = 0; slice <= _slices; slice++) {
					
					posX = _radius * Math.cos(stack * stackAngle) * Math.cos(slice * sliceAngle + Math.PI);
					posY = _radius * Math.sin(-stack * stackAngle);
					posZ = _radius * Math.cos(stack * stackAngle) * Math.sin(slice * sliceAngle + Math.PI);
					
					//pos
					vertices[vc++] = posX;
					vertices[vc++] = posY - hcHeight;
					vertices[vc++] = posZ;
					
					//normal
					vertices[vc++] = posX;
					vertices[vc++] = posY;
					vertices[vc++] = posZ;
					
					//uv
					vertices[vc++] = 1 - slice / _slices;
					vertices[vc++] = ((stack / _stacks) * (Math.PI * _radius / 2) + (_height + Math.PI * _radius / 2)) / (_height + Math.PI * _radius);
					
					if (stack < _stacks) {
						
						// First
						indices[ic++] = verticeCount + (stack * (_slices + 1)) + slice;
						indices[ic++] = verticeCount + (stack * (_slices + 1)) + slice + (_slices + 1);
						indices[ic++] = verticeCount + (stack * (_slices + 1)) + slice + 1;
						// Second
						indices[ic++] = verticeCount + (stack * (_slices + 1)) + slice;
						indices[ic++] = verticeCount + (stack * (_slices + 1)) + slice + (_slices);
						indices[ic++] = verticeCount + (stack * (_slices + 1)) + slice + (_slices + 1);
						
					}
				}
			}
			
			verticeCount += (_stacks + 1) * (_slices + 1);
			
			//侧壁
			for (slice = 0; slice <= _slices; slice++) {
				posX = _radius * Math.cos(slice * sliceAngle + Math.PI);
				posY = hcHeight;
				posZ = _radius * Math.sin(slice * sliceAngle + Math.PI);
				
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
				vertices[vc++] = 1 - slice * 1 / _slices;
				vertices[vc + (_slices + 1) * 8 - 1] = 1 - slice * 1 / _slices;
				vertices[vc++] = (Math.PI * _radius / 2) / (_height + Math.PI * _radius);
				vertices[vc + (_slices + 1) * 8 - 1] = (Math.PI * _radius / 2 + _height) / (_height + Math.PI * _radius);
			}
			
			for (slice = 0; slice < _slices; slice++) {
				
				indices[ic++] = slice + verticeCount + (_slices + 1);
				indices[ic++] = slice + verticeCount + 1;
				indices[ic++] = slice + verticeCount;
				
				indices[ic++] = slice + verticeCount + (_slices + 1);
				indices[ic++] = slice + verticeCount + (_slices + 1) + 1;
				indices[ic++] = slice + verticeCount + 1;
			}
			
			verticeCount += 2 * (_slices + 1);
			
			_vertexBuffer = new VertexBuffer3D(vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, true);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW, true);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			memorySize = (_vertexBuffer._byteLength + _indexBuffer._byteLength) * 2;//修改占用内存,upload()到GPU后CPU中和GPU中各占一份内存
			completeCreate();
		
		}
	
	}

}