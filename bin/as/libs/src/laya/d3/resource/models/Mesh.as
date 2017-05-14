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
		public var _bindPoses:Vector.<Matrix4x4>;
		/** @private */
		public var _inverseBindPoses:Vector.<Matrix4x4>;
		
		/**
		 * 获取网格顶点
		 * @return 网格顶点。
		 */
		override public function get positions():Array {
			var vertices:Array = [];
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
		 * 获取材质队列的浅拷贝。
		 * @return  材质队列的浅拷贝。
		 */
		public function get materials():Vector.<BaseMaterial> {
			return _materials.slice();
		}
		
		/**
		 * 获取网格的默认绑定动作矩阵。
		 * @return  网格的默认绑定动作矩阵。
		 */
		public function get bindPoses():Vector.<Matrix4x4> {
			return _bindPoses;
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
			
			if (_loaded)
				_generateBoundingObject();
			else
				once(Event.LOADED, this, _generateBoundingObject);
		}
		
		/**
		 * 添加子网格（开发者禁止修改）。
		 * @param subMesh 子网格。
		 */
		public function _add(subMesh:SubMesh):void {
			//TODO：SubMesh为私有问题。
			subMesh._indexInMesh = _subMeshes.length;
			_subMeshes.push(subMesh);
			_subMeshCount++;
		}
		
		/**
		 * 移除子网格（开发者禁止修改）。
		 * @param subMesh 子网格。
		 * @return  是否成功。
		 */
		public function _remove(subMesh:SubMesh):Boolean {
			var index:int = _subMeshes.indexOf(subMesh);
			if (index < 0) return false;
			_subMeshes.splice(index, 1);
			_subMeshCount--;
			return true;
		}
		
		/**
		 *@private
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var bufferData:Object = data[0];
			var textureMap:Object = data[1];
			MeshReader.read(bufferData as ArrayBuffer, this, _materials, textureMap);
			_loaded = true;
			event(Event.LOADED, this);
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
		
		override public function getRenderElementsCount():int {
			return _subMeshes.length;
		}
		
		override public function getRenderElement(index:int):IRenderable {
			return _subMeshes[index];
		}
		
		/**
		 * <p>彻底清理资源。</p>
		 * <p><b>注意：</b>会强制解锁清理。</p>
		 */
		override public function dispose():void {
			_resourceManager.removeResource(this);
			super.dispose();
			
			for (var i:int = 0; i < _subMeshes.length; i++)
				_subMeshes[i].dispose();
			_materials = null;
			_subMeshes = null;
			_vertexBuffers = null;
			_indexBuffer = null;
			_boneNames = null;
			_bindPoses = null;
			_inverseBindPoses = null;
		}
	}
}

