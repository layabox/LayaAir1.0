package laya.d3.resource.models {
	import laya.d3.core.BufferState;
	import laya.d3.core.GeometryElement;
	import laya.d3.core.IClone;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.SubMeshInstanceBatch;
	import laya.d3.graphics.Vertex.VertexMesh;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	import laya.d3.loaders.MeshReader;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.utils.Utils3D;
	import laya.resource.Resource;
	import laya.utils.Handler;
	
	/**
	 * <code>Mesh</code> 类用于创建文件网格数据模板。
	 */
	public class Mesh extends Resource implements IClone {
		/** @private */
		private static var _nativeTempVector30:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		/** @private */
		private static var _nativeTempVector31:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		/** @private */
		private static var _nativeTempVector32:* = new Laya3D._physics3D.btVector3(0, 0, 0);
		
		/**
		 *@private
		 */
		public static function _parse(data:*, propertyParams:Object = null, constructParams:Array = null):Mesh {
			var mesh:Mesh = new Mesh();
			MeshReader.read(data as ArrayBuffer, mesh, mesh._subMeshes);
			return mesh;
		}
		
		/**
		 * 加载网格模板。
		 * @param url 模板地址。
		 * @param complete 完成回掉。
		 */
		public static function load(url:String, complete:Handler):void {
			Laya.loader.create(url, complete, null, Laya3D.MESH);
		}
		
		/** @private */
		private var _nativeTriangleMesh:*;
		
		/** @private */
		protected var _boundingBox:BoundBox;
		/** @private */
		protected var _boundingSphere:BoundSphere;
		
		/** @private */
		public var _bufferState:BufferState = new BufferState();
		/** @private */
		public var _instanceBufferState:BufferState = new BufferState();
		/** @private */
		public var _subMeshCount:int;
		/** @private 只读,不允许修改。*/
		public var _positions:Vector.<Vector3>;
		/** @private */
		public var _subMeshes:Vector.<SubMesh>;
		/** @private */
		public var _vertexBuffers:Vector.<VertexBuffer3D>;
		/** @private */
		public var _indexBuffer:IndexBuffer3D;
		/** @private */
		public var _boneNames:Vector.<String>;
		/** @private */
		public var _inverseBindPoses:Vector.<Matrix4x4>;
		/** @private */
		public var _inverseBindPosesBuffer:ArrayBuffer;//TODO:[NATIVE]临时
		/** @private */
		public var _bindPoseIndices:Uint16Array;
		/** @private */
		public var _skinDataPathMarks:Vector.<Array>;
		/** @private */
		public var _vertexCount:int = 0;
		
		/**
		 * 获取网格的全局默认绑定动作逆矩阵。
		 * @return  网格的全局默认绑定动作逆矩阵。
		 */
		public function get inverseAbsoluteBindPoses():Vector.<Matrix4x4> {
			return _inverseBindPoses;
		}
		
		/**
		 * 获取顶点个数
		 */
		public function get vertexCount():int {
			return _vertexCount;
		}
		
		/**
		 * 获取SubMesh的个数。
		 * @return SubMesh的个数。
		 */
		public function get subMeshCount():int {
			return _subMeshCount;
		}
		
		/**
		 * 获取AABB包围盒,禁止修改其数据。
		 * @return AABB包围盒。
		 */
		public function get boundingBox():BoundBox {
			return _boundingBox;
		}
		
		/**
		 * 获取包围球,禁止修改其数据。
		 * @return 包围球。
		 */
		public function get boundingSphere():BoundSphere {
			return _boundingSphere;
		}
		
		/**
		 * 创建一个 <code>Mesh</code> 实例,禁止使用。
		 * @param url 文件地址。
		 */
		public function Mesh() {
			super();
			_subMeshes = new Vector.<SubMesh>();
			_vertexBuffers = new Vector.<VertexBuffer3D>();
			_skinDataPathMarks = new Vector.<Array>();
		}
		
		/**
		 * @private
		 */
		protected function _generateBoundingObject():void {
			_boundingSphere = new BoundSphere(new Vector3(), 0);
			BoundSphere.createfromPoints(_positions, _boundingSphere);
			_boundingBox = new BoundBox(new Vector3(), new Vector3());
			BoundBox.createfromPoints(_positions, _boundingBox);
		}
		
		/**
		 * 获取网格顶点，并产生数据
		 * @return 网格顶点。
		 */
		public function _getPositions():Vector.<Vector3> {
			var vertices:Vector.<Vector3> = new Vector.<Vector3>();
			var i:int, j:int, vertexBuffer:VertexBuffer3D, positionElement:VertexElement, vertexElements:Array, vertexElement:VertexElement, ofset:int, verticesData:Float32Array;
			var vertexBufferCount:int = _vertexBuffers.length;
			for (i = 0; i < vertexBufferCount; i++) {
				vertexBuffer = _vertexBuffers[i];
				
				vertexElements = vertexBuffer.vertexDeclaration.vertexElements;
				for (j = 0; j < vertexElements.length; j++) {
					vertexElement = vertexElements[j];
					if (vertexElement.elementFormat === VertexElementFormat.Vector3 && vertexElement.elementUsage === VertexMesh.MESH_POSITION0) {
						positionElement = vertexElement;
						break;
					}
				}
				
				verticesData = vertexBuffer.getData();
				for (j = 0; j < verticesData.length; j += vertexBuffer.vertexDeclaration.vertexStride / 4) {
					ofset = j + positionElement.offset / 4;
					vertices.push(new Vector3(verticesData[ofset + 0], verticesData[ofset + 1], verticesData[ofset + 2]));
				}
			}
			return vertices;
		}
		
		/**
		 *@private
		 */
		public function _setSubMeshes(subMeshes:Vector.<SubMesh>):void {
			_subMeshes = subMeshes
			_subMeshCount = subMeshes.length;
			
			for (var i:int = 0; i < _subMeshCount; i++)
				subMeshes[i]._indexInMesh = i;
			_positions = _getPositions();
			_generateBoundingObject();
		}
		
		/**
		 * @inheritDoc
		 */
		public function _getSubMesh(index:int):GeometryElement {
			return _subMeshes[index];
		}
		
		/**
		 * @private
		 */
		public function _setBuffer(vertexBuffers:Vector.<VertexBuffer3D>, indexBuffer:IndexBuffer3D):void {
			var bufferState:BufferState = _bufferState;
			bufferState.bind();
			bufferState.applyVertexBuffers(vertexBuffers);
			bufferState.applyIndexBuffer(indexBuffer);
			bufferState.unBind();
			
			var instanceBufferState:BufferState = _instanceBufferState;
			instanceBufferState.bind();
			instanceBufferState.applyVertexBuffers(vertexBuffers);
			instanceBufferState.applyInstanceVertexBuffer(SubMeshInstanceBatch.instance.instanceWorldMatrixBuffer);
			instanceBufferState.applyInstanceVertexBuffer(SubMeshInstanceBatch.instance.instanceMVPMatrixBuffer);
			instanceBufferState.applyIndexBuffer(indexBuffer);
			instanceBufferState.unBind();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _disposeResource():void {
			for (var i:int = 0, n:int = _subMeshes.length; i < n; i++)
				_subMeshes[i].destroy();
			_nativeTriangleMesh && Laya3D._physics3D.destroy(_nativeTriangleMesh);
			for (i = 0, n = _vertexBuffers.length; i < n; i++)
				_vertexBuffers[i].destroy();
			_indexBuffer.destroy();
			_setCPUMemory(0);
			_setGPUMemory(0);
			_bufferState.destroy();
			_instanceBufferState.destroy();
			_bufferState = null;
			_instanceBufferState = null;
			_vertexBuffers = null;
			_indexBuffer = null;
			_subMeshes = null;
			_nativeTriangleMesh = null;
			_vertexBuffers = null;
			_indexBuffer = null;
			_boneNames = null;
			_inverseBindPoses = null;
		}
		
		/**
		 * @private
		 */
		public function _getPhysicMesh():* {
			if (!_nativeTriangleMesh) {
				var physics3D:* = Laya3D._physics3D;
				var triangleMesh:* = new physics3D.btTriangleMesh();//TODO:独立抽象btTriangleMesh,增加内存复用
				var nativePositio0:* = _nativeTempVector30;
				var nativePositio1:* = _nativeTempVector31;
				var nativePositio2:* = _nativeTempVector32;
				var positions:Vector.<Vector3> = _getPositions();//TODO:GC问题
				var indices:Uint16Array = _indexBuffer.getData();//TODO:API修改问题
				for (var i:int = 0, n:int = indices.length; i < n; i += 3) {
					var position0:Vector3 = positions[indices[i]];
					var position1:Vector3 = positions[indices[i + 1]];
					var position2:Vector3 = positions[indices[i + 2]];
					Utils3D._convertToBulletVec3(position0, nativePositio0, true);
					Utils3D._convertToBulletVec3(position1, nativePositio1, true);
					Utils3D._convertToBulletVec3(position2, nativePositio2, true);
					triangleMesh.addTriangle(nativePositio0, nativePositio1, nativePositio2, true);
				}
				_nativeTriangleMesh = triangleMesh;
			}
			return _nativeTriangleMesh;
		}
		
		/**
		 * 克隆。
		 * @param	destObject 克隆源。
		 */
		public function cloneTo(destObject:*):void {//[实现IClone接口]
			var destMesh:Mesh = destObject as Mesh;
			for (var i:int = 0; i < _vertexBuffers.length; i++) {
				var vb:VertexBuffer3D = _vertexBuffers[i];
				var destVB:VertexBuffer3D = new VertexBuffer3D(vb._byteLength, vb.bufferUsage, vb.canRead);
				destVB.vertexDeclaration = vb.vertexDeclaration;
				destVB.setData(vb.getData().slice());
				destMesh._vertexBuffers.push(destVB);
				destMesh._vertexCount += destVB.vertexCount;
			}
			var ib:IndexBuffer3D = _indexBuffer;
			var destIB:IndexBuffer3D = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, ib.indexCount,ib.bufferUsage, ib.canRead);
			destIB.setData(ib.getData().slice());
			destMesh._indexBuffer = destIB;
			
			destMesh._setBuffer(destMesh._vertexBuffers, destIB);
			destMesh._setCPUMemory(cpuMemory);
			destMesh._setGPUMemory(gpuMemory);
			
			var boneNames:Vector.<String> = _boneNames;
			var destBoneNames:Vector.<String> = destMesh._boneNames = new Vector.<String>(boneNames.length);
			for (i = 0; i < boneNames.length; i++)
				destBoneNames[i] = boneNames[i];
			
			var inverseBindPoses:Vector.<Matrix4x4> = _inverseBindPoses;
			var destInverseBindPoses:Vector.<Matrix4x4> = destMesh._inverseBindPoses = new Vector.<Matrix4x4>(inverseBindPoses.length);
			for (i = 0; i < inverseBindPoses.length; i++)
				destInverseBindPoses[i] = inverseBindPoses[i];
			
			destMesh._bindPoseIndices = new Uint16Array(_bindPoseIndices);
			
			for (i = 0; i < _skinDataPathMarks.length; i++)
				destMesh._skinDataPathMarks[i] = _skinDataPathMarks[i].slice();
			
			
			for (i = 0; i < subMeshCount; i++) {
				var subMesh:SubMesh = _subMeshes[i];
				var subIndexBufferStart:Vector.<int> = subMesh._subIndexBufferStart;
				var subIndexBufferCount:Vector.<int> = subMesh._subIndexBufferCount;
				var boneIndicesList:Vector.<Uint16Array> = subMesh._boneIndicesList;
				var destSubmesh:SubMesh = new SubMesh(destMesh);
				
				destSubmesh._subIndexBufferStart.length = subIndexBufferStart.length;
				destSubmesh._subIndexBufferCount.length = subIndexBufferCount.length;
				destSubmesh._boneIndicesList.length = boneIndicesList.length;
				
				for (var j:int = 0; j < subIndexBufferStart.length; j++)
					destSubmesh._subIndexBufferStart[j] = subIndexBufferStart[j];
				for (j = 0; j < subIndexBufferCount.length; j++)
					destSubmesh._subIndexBufferCount[j] = subIndexBufferCount[j];
				for (j = 0; j < boneIndicesList.length; j++)
					destSubmesh._boneIndicesList[j] = new Uint16Array(boneIndicesList[j]);
				
				
				destSubmesh._indexBuffer = destIB;
				destSubmesh._indexStart = subMesh._indexStart;
				destSubmesh._indexCount = subMesh._indexCount;
				destSubmesh._indices = new Uint16Array(destIB.getData().buffer, subMesh._indexStart * 2, subMesh._indexCount);
				var vertexBuffer:VertexBuffer3D = destMesh._vertexBuffers[0];
				destSubmesh._vertexBuffer = vertexBuffer;
				destMesh._subMeshes.push(destSubmesh);
			}
			destMesh._setSubMeshes(destMesh._subMeshes);
		}
		
		/**
		 * 克隆。
		 * @return	 克隆副本。
		 */
		public function clone():* {//[实现IClone接口]
			var dest:Mesh = __JS__("new this.constructor()");
			cloneTo(dest);
			return dest;
		}
	}
}

