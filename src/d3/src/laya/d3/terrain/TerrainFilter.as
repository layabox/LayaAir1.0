package laya.d3.terrain {
	import laya.d3.core.Camera;
	import laya.d3.core.GeometryFilter;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexDeclaration;
	import laya.d3.graphics.VertexPositionTerrain;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	
	/**
	 * <code>TerrainFilter</code> 类用于创建TerrainFilter过滤器。
	 */
	public class TerrainFilter extends GeometryFilter implements IRenderable {
		/** @private */
		public static var _TEMP_ARRAY_BUFFER:Uint32Array = new Uint32Array(TerrainLeaf.CHUNK_GRID_NUM / TerrainLeaf.LEAF_GRID_NUM * TerrainLeaf.CHUNK_GRID_NUM / TerrainLeaf.LEAF_GRID_NUM);
		public var _owner:TerrainChunk;
		public var _gridSize:Number;
		public var memorySize:int;
		protected var _numberVertices:int;
		protected var _maxNumberIndices:int;
		protected var _currentNumberIndices:int;
		protected var _numberTriangle:int;
		protected var _vertexBuffer:VertexBuffer3D;
		protected var _indexBuffer:IndexBuffer3D;
		protected var _boundingSphere:BoundSphere;
		protected var _boundingBox:BoundBox;
		protected var _indexArrayBuffer:Uint16Array;
		public var _boundingBoxCorners:Vector.<Vector3>;
		private var _leafs:Vector.<TerrainLeaf>;
		private var _leafNum:int;
		private var _terrainHeightData:Float32Array;
		private var _terrainHeightDataWidth:int;
		private var _terrainHeightDataHeight:int;
		private var _chunkOffsetX:int;
		private var _chunkOffsetZ:int;
		private var _cameraCoordinateInverse:Boolean;
		private var _cameraPos:Vector3;
		private var _currentLOD:uint;//LOD级别 4个叶子节点  第1个叶子的level<<24 + 第2个叶子的level<<16 + 第3个叶子的level<<8 + 第4个叶子的level
		private var _perspectiveFactor:Number;
		private var _LODTolerance:int;
		
		/**
		 * 创建一个新的 <code>MeshFilter</code> 实例。
		 * @param owner 所属网格精灵。
		 */
		public function TerrainFilter(owner:TerrainChunk, chunkOffsetX:int, chunkOffsetZ:int, gridSize:Number, terrainHeightData:Float32Array, heightDataWidth:int, heightDataHeight:int, cameraCoordinateInverse:Boolean) {
			_owner = owner;
			_cameraPos = new Vector3();
			_chunkOffsetX = chunkOffsetX;
			_chunkOffsetZ = chunkOffsetZ;
			_gridSize = gridSize;
			_terrainHeightData = terrainHeightData;
			_terrainHeightDataWidth = heightDataWidth;
			_terrainHeightDataHeight = heightDataHeight;
			_leafNum = (TerrainLeaf.CHUNK_GRID_NUM / TerrainLeaf.LEAF_GRID_NUM) * (TerrainLeaf.CHUNK_GRID_NUM / TerrainLeaf.LEAF_GRID_NUM);
			_leafs = new Vector.<TerrainLeaf>(_leafNum);
			_cameraCoordinateInverse = cameraCoordinateInverse;
			for (var i:int = 0; i < _leafNum; i++) {
				_leafs[i] = new TerrainLeaf();
			}
			recreateResource();
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
			if (_vertexBuffer) _vertexBuffer.destroy();
			if (_indexBuffer) _indexBuffer.destroy();
		}
		
		protected function recreateResource():void {
			_currentNumberIndices = 0;
			_numberTriangle = 0;
			var nLeafVertexCount:int = TerrainLeaf.LEAF_VERTEXT_COUNT;
			var nLeafIndexCount:int = TerrainLeaf.LEAF_MAX_INDEX_COUNT;
			_numberVertices = nLeafVertexCount * _leafNum;
			_maxNumberIndices = nLeafIndexCount * _leafNum;
			_indexArrayBuffer = new Uint16Array(_maxNumberIndices);
			var vertexDeclaration:VertexDeclaration = VertexPositionTerrain.vertexDeclaration;
			var vertexFloatStride:int = vertexDeclaration.vertexStride / 4;
			var vertices:Float32Array = new Float32Array(_numberVertices * vertexFloatStride);
			var nNum:int = TerrainLeaf.CHUNK_GRID_NUM / TerrainLeaf.LEAF_GRID_NUM;
			var i:int = 0, x:int = 0, z:int = 0;
			for (i = 0; i < _leafNum; i++) {
				x = i % nNum;
				z = Math.floor(i / nNum);
				_leafs[i].calcVertextBuffer(_chunkOffsetX, _chunkOffsetZ, x * TerrainLeaf.LEAF_GRID_NUM, z * TerrainLeaf.LEAF_GRID_NUM, _gridSize, vertices, i * TerrainLeaf.LEAF_PLANE_VERTEXT_COUNT, vertexFloatStride, _terrainHeightData, _terrainHeightDataWidth, _terrainHeightDataHeight, _cameraCoordinateInverse);
			}
			for (i = 0; i < _leafNum; i++) {
				x = i % nNum;
				z = Math.floor(i / nNum);
				_leafs[i].calcSkirtVertextBuffer(_chunkOffsetX, _chunkOffsetZ, x * TerrainLeaf.LEAF_GRID_NUM, z * TerrainLeaf.LEAF_GRID_NUM, _gridSize, vertices, _leafNum * TerrainLeaf.LEAF_PLANE_VERTEXT_COUNT + i * TerrainLeaf.LEAF_SKIRT_VERTEXT_COUNT, vertexFloatStride, _terrainHeightData, _terrainHeightDataWidth, _terrainHeightDataHeight);
			}
			assembleIndexInit();
			_vertexBuffer = new VertexBuffer3D(vertexDeclaration, _numberVertices, WebGLContext.STATIC_DRAW, false);
			_indexBuffer = new IndexBuffer3D(IndexBuffer3D.INDEXTYPE_USHORT, _maxNumberIndices, WebGLContext.STATIC_DRAW, false);
			_vertexBuffer.setData(vertices);
			_indexBuffer.setData(_indexArrayBuffer);
			memorySize = (_vertexBuffer._byteLength + _indexBuffer._byteLength) * 2;//修改占用内存,upload()到GPU后CPU中和GPU中各占一份内存
			calcOriginalBoudingBoxAndSphere();
		}
		
		private function setLODLevel(leafsLODLevel:Uint32Array):Boolean {
			if (leafsLODLevel.length != 4) return true;
			var nLOD:int = ((leafsLODLevel[0] + 1) << 24) + ((leafsLODLevel[1] + 1) << 16) + ((leafsLODLevel[2] + 1) << 8) + (leafsLODLevel[3] + 1);
			if (_currentLOD == nLOD) {
				return false;
			}
			_currentLOD = nLOD;
			return true;
		}
		
		protected function assembleIndexInit():void {
			_currentNumberIndices = 0;
			_numberTriangle = 0;
			var nOffsetIndex:int = 0;
			for (var i:int = 0; i < _leafNum; i++) {
				var planeLODIndex:Uint16Array = TerrainLeaf.getPlaneLODIndex(i, 0);
				_indexArrayBuffer.set(planeLODIndex, nOffsetIndex);
				nOffsetIndex += planeLODIndex.length;
				var skirtLODIndex:Uint16Array = TerrainLeaf.getSkirtLODIndex(i, 0);
				_indexArrayBuffer.set(skirtLODIndex, nOffsetIndex);
				nOffsetIndex += skirtLODIndex.length;
				_currentNumberIndices += (planeLODIndex.length + skirtLODIndex.length);
			}
			
			_numberTriangle = _currentNumberIndices / 3;
		}
		
		protected function isNeedAssemble(camera:Camera, cameraPostion:Vector3):int {
			//TODO是否可以存储到摄影机中
			var perspectiveFactor:Number = Math.min(camera.viewport.width, camera.viewport.height) / (2 * Math.tan(Math.PI * camera.fieldOfView / 180.0));
			if (_perspectiveFactor != perspectiveFactor) {
				_perspectiveFactor = perspectiveFactor;
				return 1;
			}
			if (_LODTolerance != Terrain.LOD_TOLERANCE_VALUE) {
				_LODTolerance = Terrain.LOD_TOLERANCE_VALUE;
				return 1;
			}
			if (Vector3.equals(cameraPostion, _cameraPos) == false) {
				_cameraPos.x = cameraPostion.x;
				_cameraPos.y = cameraPostion.y;
				_cameraPos.z = cameraPostion.z;
				return 2;
			}
			return 0;
		}
		
		protected function assembleIndex(camera:Camera, cameraPostion:Vector3):Boolean {
			var nNeedType:int = isNeedAssemble(camera, cameraPostion);
			if (nNeedType > 0) {
				for (var i:int = 0; i < _leafNum; i++) {
					_TEMP_ARRAY_BUFFER[i] = _leafs[i].determineLod(cameraPostion, _perspectiveFactor, Terrain.LOD_TOLERANCE_VALUE, nNeedType == 1);
				}
				if (setLODLevel(_TEMP_ARRAY_BUFFER)) {
					_currentNumberIndices = 0;
					_numberTriangle = 0;
					var nOffsetIndex:int = 0;
					for (i = 0; i < _leafNum; i++) {
						var nLODLevel:int = _TEMP_ARRAY_BUFFER[i];
						var planeLODIndex:Uint16Array = TerrainLeaf.getPlaneLODIndex(i, nLODLevel);
						_indexArrayBuffer.set(planeLODIndex, nOffsetIndex);
						nOffsetIndex += planeLODIndex.length;
						var skirtLODIndex:Uint16Array = TerrainLeaf.getSkirtLODIndex(i, nLODLevel);
						_indexArrayBuffer.set(skirtLODIndex, nOffsetIndex);
						nOffsetIndex += skirtLODIndex.length;
						_currentNumberIndices += (planeLODIndex.length + skirtLODIndex.length);
					}
					_numberTriangle = _currentNumberIndices / 3;
					return true;
				}
			}
			return false;
		}
		
		public function calcOriginalBoudingBoxAndSphere():void {
			var sizeOfY:Vector2 = new Vector2(2147483647, -2147483647);
			for (var i:int = 0; i < _leafNum; i++) {
				sizeOfY.x = _leafs[i]._sizeOfY.x < sizeOfY.x ? _leafs[i]._sizeOfY.x : sizeOfY.x;
				sizeOfY.y = _leafs[i]._sizeOfY.y > sizeOfY.y ? _leafs[i]._sizeOfY.y : sizeOfY.y;
			}
			var min:Vector3 = new Vector3(_chunkOffsetX * TerrainLeaf.CHUNK_GRID_NUM * _gridSize, sizeOfY.x, _chunkOffsetZ * TerrainLeaf.CHUNK_GRID_NUM * _gridSize);
			var max:Vector3 = new Vector3((_chunkOffsetX + 1) * TerrainLeaf.CHUNK_GRID_NUM * _gridSize, sizeOfY.y, (_chunkOffsetZ + 1) * TerrainLeaf.CHUNK_GRID_NUM * _gridSize);
			if (TerrainLeaf.__ADAPT_MATRIX__) {
				Vector3.transformV3ToV3(min, TerrainLeaf.__ADAPT_MATRIX__, min);
				Vector3.transformV3ToV3(max, TerrainLeaf.__ADAPT_MATRIX__, max);
			}
			_boundingBox = new BoundBox(min, max);
			var size:Vector3 = new Vector3();
			Vector3.subtract(max, min, size);
			Vector3.scale(size, 0.5, size);
			var center:Vector3 = new Vector3();
			Vector3.add(min, size, center);
			_boundingSphere = new BoundSphere(center, Vector3.scalarLength(size));
			_boundingBoxCorners = new Vector.<Vector3>(8);
			_boundingBox.getCorners(_boundingBoxCorners);
		}
		
		public function calcLeafBoudingBox(worldMatrix:Matrix4x4):void {
			for (var i:int = 0; i < _leafNum; i++) {
				_leafs[i].calcLeafBoudingBox(worldMatrix);
			}
		}
		
		public function calcLeafBoudingSphere(worldMatrix:Matrix4x4, maxScale:Number):void {
			for (var i:int = 0; i < _leafNum; i++) {
				_leafs[i].calcLeafBoudingSphere(worldMatrix, maxScale);
			}
		}
		
		public function get _vertexBufferCount():int {
			return _numberVertices;
		}
		
		public function get triangleCount():int {
			return _numberTriangle;
		}
		
		public function _getVertexBuffer(index:int = 0):VertexBuffer3D {
			if (index == 0) {
				return _vertexBuffer;
			}
			return null;
		}
		
		public function _getIndexBuffer():IndexBuffer3D {
			return _indexBuffer;
		}
		
		public function _beforeRender(state:RenderState):Boolean {
			_vertexBuffer._bind();			
			_indexBuffer._bind();
			var terrainMaterial:TerrainMaterial = state.renderElement._material as TerrainMaterial;
			if (terrainMaterial.blend == BaseMaterial.BLEND_DISABLE) {
				var camera:Camera = state.camera as Camera;
				if (assembleIndex(camera, camera.position)) {
					_indexBuffer.setData(_indexArrayBuffer);
				}
			}
			return true;
		}
		
		/**
		 * @private
		 */
		public function _getVertexBuffers():Vector.<VertexBuffer3D>{
			return null;
		}
		
		public function _render(state:RenderState):void {
			/*
			   //绘制第二遍的时候，如果DEPTHFUNC_LEQUAL有bug，就可以用这种偏移的方式
			   if ( (state.renderElement._material as TerrainMaterial).renderMode == TerrainMaterial.RENDERMODE_TRANSPARENT )
			   {
			   WebGL.mainContext.enable( WebGLContext.POLYGON_OFFSET_FILL );
			   WebGL.mainContext.polygonOffset(-1,0);
			   }
			   else
			   {
			   WebGL.mainContext.disable( WebGLContext.POLYGON_OFFSET_FILL );
			   }
			 */
			WebGL.mainContext.drawElements(Terrain.RENDER_LINE_MODEL ? WebGLContext.LINES : WebGLContext.TRIANGLES, _currentNumberIndices, WebGLContext.UNSIGNED_SHORT, 0);
			Stat.trianglesFaces += _numberTriangle;
			Stat.drawCall++;
		}
		
		public function _renderRuntime(conchGraphics3D:*, renderElement:RenderElement, state:RenderState):void {
			//TODO
		}
	}
}