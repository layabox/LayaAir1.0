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
	 * <code>MeshCylinder</code> 类用于创建圆柱。
	 */
	public class CylinderMesh extends PrimitiveMesh {
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
		public function CylinderMesh(radius:Number = 10, height:int=10, stacks:int = 8, slices:int = 8) {
			super();
			_radius = radius;
			_height = height;
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
			_numberVertices = (_stacks + 1 + 2) * (_slices + 1);	//结合的地方是有缝的，所以_slices+1
			_numberIndices = (_slices -1+_stacks*_slices)*2*3;
			
			var indices:Uint16Array = new Uint16Array(_numberIndices);
			var vertexDeclaration:VertexDeclaration = VertexPositionNormalTexture.vertexDeclaration;
			var vertexFloatStride:int = vertexDeclaration.vertexStride / 4;
			var vertices:Float32Array = new Float32Array(_numberVertices * vertexFloatStride); //TODO 多少
			
			var sliceAngle:Number = (Math.PI * 2.0) / _slices;
			
			var cAng:Number = 0;
			var buttomUVCenterX:Number = 0.5;
			var buttomUVCenterY:Number = 0.5;
			var buttomUVR:Number = 0.5;
			var capUVCenterX:Number = 0.5;
			var capUVCenterY:Number = 0.5;
			var wallUVLeft:Number = 0;
			var wallUVTop:Number = 0;
			var wallUVRight:Number = 1;
			var wallUVBottom:Number = 1;
			
			var indexCount:int = 0;
			var vertexIndex:int = 0;
			var vertexCount:int = 0;
			
			//底
			var cv:int = 0;
			for ( var slice:int = 0; slice < (_slices +1); slice++) {
				var x:Number = Math.cos(cAng);
				var y:Number = Math.sin(cAng);
				cAng += sliceAngle;
				vertices[cv++] = _radius *x; vertices[cv++] = _radius * y; vertices[cv++] = 0;	//pos
				vertices[cv++] = 0; vertices[cv++] = 0; vertices[cv++] = -1;	//normal
				vertices[cv++] = buttomUVR * x + buttomUVCenterX; vertices[cv++] = buttomUVR * y + buttomUVCenterY; 	//uv
			}
			for ( slice = 2; slice < (_slices + 1); slice++) {
				indices[indexCount++] = 0;
				indices[indexCount++] = slice-1;
				indices[indexCount++] = slice;
			}
			vertexCount += (_slices+1);
			//壁
			var hdist:Number = _height / _stacks;
			var cz:Number = 0;
			for ( var h:int = 0; h < _stacks + 1; h++) {
				for (slice = 0; slice < (_slices+1);slice++){
					var tx:Number = vertices[ slice*vertexFloatStride ];
					var ty:Number = vertices[ slice*vertexFloatStride + 1];
					vertices[cv++] = tx; vertices[cv++] = ty; vertices[cv++] = cz;	//pos
					vertices[cv++] = tx; vertices[cv++] = ty; vertices[cv++] = 0;	//normal
					vertices[cv++] = wallUVLeft + slice * (wallUVRight - wallUVLeft) / _slices; //u
					vertices[cv++] = wallUVBottom + h * (wallUVTop - wallUVBottom) / _stacks; 	//v
					if (h > 0 && slice > 0) {
						var v1:int = vertexCount - 1;
						var v2:int = vertexCount;
						var v3:int = vertexCount - (_slices + 1);
						var v4:int = vertexCount - (_slices + 1) - 1;
						indices[indexCount++] = v4; indices[indexCount++] = v1; indices[indexCount++] = v2;
						indices[indexCount++] = v4; indices[indexCount++] = v2; indices[indexCount++] = v3;
					}
					vertexCount++;
				}
				cz += hdist;
			}
			//盖
			for ( slice = 0; slice < (_slices + 1);slice++) {
				tx = vertices[ slice*vertexFloatStride ];
				ty = vertices[ slice*vertexFloatStride + 1];
				vertices[cv++] = tx; vertices[cv++] = ty; vertices[cv++] = _height;	//pos
				vertices[cv++] = 0; vertices[cv++] = 0; vertices[cv++] = 1;	//normal
				vertices[cv++] = buttomUVR*tx/_radius+capUVCenterX; vertices[cv++] = buttomUVR*ty/_radius+capUVCenterY; 	//uv
			}
			for ( slice = 2; slice < (_slices + 1); slice++) {
				indices[indexCount++] = vertexCount;
				indices[indexCount++] = vertexCount + slice;
				indices[indexCount++] = vertexCount + slice-1;
			}
			vertexCount += (_slices + 1);
			
			_vertexBuffer = new VertexBuffer3D(vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, true);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _numberIndices, WebGLContext.STATIC_DRAW, true);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(indices);
			memorySize = (_vertexBuffer.byteLength + _indexBuffer.byteLength) * 2;//修改占用内存,upload()到GPU后CPU中和GPU中各占一份内存
			completeCreate();
		}
	}
}