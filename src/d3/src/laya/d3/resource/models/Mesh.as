package laya.d3.resource.models {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.graphics.IndexBuffer3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.loaders.MeshReader;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.events.Event;
	
	/**
	 * <code>Mesh</code> 类用于创建文件网格数据模板。
	 */
	public class Mesh extends BaseMesh {
		/**
		 * 加载网格模板。
		 * @param url 模板地址。
		 */
		public static function load(url:String):Mesh {
			return Laya.loader.create(url, null, null, Mesh);
		}
		
		/** @private */
		private var _materials:Vector.<BaseMaterial>;
		/** @private */
		private var _subMeshes:Vector.<SubMesh>;
		/** @private */
		public var _vertexBuffers:Vector.<VertexBuffer3D>;
		/** @private */
		public var _indexBuffer:IndexBuffer3D;
		/** @private */
		public var _boneNames:Vector.<String>;
		/** @private */
		public var _inverseBindPoses:Vector.<Matrix4x4>;
		/** @private */
		public var _skinnedDatas:Float32Array;
		
		
		
		/**
		 * 获取材质队列的浅拷贝。
		 * @return  材质队列的浅拷贝。
		 */
		public function get materials():Vector.<BaseMaterial> {//兼容代码
			return _materials.slice();
		}
		
		/**
		 * 获取网格的全局默认绑定动作逆矩阵。
		 * @return  网格的全局默认绑定动作逆矩阵。
		 */
		public function get InverseAbsoluteBindPoses():Vector.<Matrix4x4> {
			return _inverseBindPoses;
		}
		
		/**
		 * 创建一个 <code>Mesh</code> 实例,禁止使用。
		 * @param url 文件地址。
		 */
		public function Mesh() {
			super();
			_subMeshes = new Vector.<SubMesh>();
			_materials = new Vector.<BaseMaterial>();
			_vertexBuffers = new Vector.<VertexBuffer3D>();
		}
		
		/**
		 * 获取网格顶点，并产生数据
		 * @return 网格顶点。
		 */
		override public function _getPositions():Vector.<Vector3> {
			var vertices:Vector.<Vector3> = new Vector.<Vector3>();
			var i:int, j:int, vertexBuffer:VertexBuffer3D, positionElement:VertexElement, vertexElements:Array, vertexElement:VertexElement, ofset:int, verticesData:Float32Array;
			if (_vertexBuffers.length !== 0) {
				var vertexBufferCount:int = _vertexBuffers.length;
				for (i = 0; i < vertexBufferCount; i++) {
					vertexBuffer = _vertexBuffers[i];
					
					vertexElements = vertexBuffer.vertexDeclaration.getVertexElements();
					for (j = 0; j < vertexElements.length; j++) {
						vertexElement = vertexElements[j];
						if (vertexElement.elementFormat === VertexElementFormat.Vector3 && vertexElement.elementUsage === VertexElementUsage.POSITION0) {
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
			} else {//兼容旧格式
				var submesheCount:int = _subMeshes.length;
				for (i = 0; i < submesheCount; i++) {
					var subMesh:SubMesh = _subMeshes[i];
					vertexBuffer = subMesh._getVertexBuffer();
					
					vertexElements = vertexBuffer.vertexDeclaration.getVertexElements();
					for (j = 0; j < vertexElements.length; j++) {
						vertexElement = vertexElements[j];
						if (vertexElement.elementFormat === VertexElementFormat.Vector3 && vertexElement.elementUsage === VertexElementUsage.POSITION0) {
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
			}
			return vertices;
		}
		
		/**
		 * 添加子网格（开发者禁止修改）。
		 * @param subMesh 子网格。
		 */
		public function _setSubMeshes(subMeshes:Vector.<SubMesh>):void {
			//TODO：SubMesh为私有问题。
			_subMeshes = subMeshes
			_subMeshCount = subMeshes.length;
			
			for (var i:int = 0; i < _subMeshCount; i++)
				subMeshes[i]._indexInMesh = i;
			_positions = _getPositions();
			_generateBoundingObject();
		}
		
		/**
		 *@private
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var bufferData:Object = data[0];
			var textureMap:Object = data[1];
			MeshReader.read(bufferData as ArrayBuffer, this, _materials, _subMeshes, textureMap);
			completeCreate();//TODO:应该和解析函数绑定
			_endLoaded();
		}
		
		/**
		 * 获得子网格。
		 * @param index 子网格索引。
		 * @return  子网格。
		 */
		public function getSubMesh(index:int):SubMesh {
			return _subMeshes[index];
		}
		
		/**
		 * 获得子网格数量。
		 * @return  子网格数量。
		 */
		public function getSubMeshCount():int {
			return _subMeshes.length;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getRenderElementsCount():int {
			return _subMeshes.length;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getRenderElement(index:int):IRenderable {
			return _subMeshes[index];
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function disposeResource():void {
			for (var i:int = 0; i < _subMeshes.length; i++)
				_subMeshes[i].dispose();
			_materials = null;
			_subMeshes = null;
			_vertexBuffers = null;
			_indexBuffer = null;
			_boneNames = null;
			_inverseBindPoses = null;
		}
	}
}

