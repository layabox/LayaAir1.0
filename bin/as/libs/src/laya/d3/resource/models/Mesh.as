package laya.d3.resource.models {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderObject;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.graphics.VertexElement;
	import laya.d3.graphics.VertexElementFormat;
	import laya.d3.graphics.VertexElementUsage;
	import laya.d3.loaders.LoadModel;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Vector3;
	import laya.events.Event;
	import laya.events.EventDispatcher;
	import laya.net.Loader;
	import laya.net.URL;
	import laya.resource.Resource;
	import laya.webgl.utils.VertexBuffer2D;
	
	/**
	 * <code>Mesh</code> 类用于创建文件网格数据模板。
	 */
	public class Mesh extends BaseMesh {
		/**
		 * 加载网格模板。
		 * @param url 模板地址。
		 */
		public static function load(url:String):Mesh {
			url = URL.formatURL(url);
			var mesh:Mesh = Resource.meshCache[url];
			if (!mesh) {
				mesh = Resource.meshCache[url] = new Mesh(url);
				var loader:Loader = new Loader();
				loader.once(Event.COMPLETE, null, function(data:ArrayBuffer):void {
					new LoadModel(data, mesh, mesh._materials, url);
					mesh._loaded = true;
					mesh.event(Event.LOADED, mesh);
				});
				loader.load(url, Loader.BUFFER);
			}
			return mesh;
		}
		
		/** @private */
		private var _materials:Vector.<Material>;
		/** @private */
		private var _subMeshes:Vector.<SubMesh>;
		
		/** @private */
		private var _useFullBone:Boolean = true;
		/** @private */
		private var _url:String;
		/** @private */
		private var _loaded:Boolean = false;
		
		/**
		 * 获取网格顶点
		 * @return 网格顶点。
		 */
		override public function get positions():Vector.<Vector3> {
			var vertices:Vector.<Vector3> = new Vector.<Vector3>();
			var submesheCount:int = _subMeshes.length;
			for (var i:int = 0; i < submesheCount; i++) {
				var subMesh:SubMesh = _subMeshes[i];
				var vertexBuffer:VertexBuffer3D = subMesh.getVertexBuffer();
				
				var positionElement:VertexElement;
				var vertexElements:Array = vertexBuffer.vertexDeclaration.getVertexElements();
				var j:int;
				for (j = 0; j < vertexElements.length; j++) {
					var vertexElement:VertexElement = vertexElements[j];
					if (vertexElement.elementFormat === VertexElementFormat.Vector3 && vertexElement.elementUsage === VertexElementUsage.POSITION0) {
						positionElement = vertexElement;
						break;
					}
				}
				
				var verticesData:Float32Array = vertexBuffer.getData();
				for (j = 0; j < verticesData.length; j += vertexBuffer.vertexDeclaration.vertexStride / 4) {
					var ofset:int = j + positionElement.offset / 4;
					var position:Vector3 = new Vector3(verticesData[ofset + 0], verticesData[ofset + 1], verticesData[ofset + 2]);
					vertices.push(position);
				}
			}
			return vertices;
		}
		
		/**
		 * 获取材质队列。
		 * @return  材质队列。
		 */
		public function get materials():Vector.<Material> {
			return _materials;
		}
		
		/**
		 * 获取是否已载入。
		 * @return  是否已载入。
		 */
		public function get loaded():Boolean {
			return _loaded;
		}
		
		/**
		 * 创建一个 <code>Mesh</code> 实例。
		 * @param url 文件地址。
		 */
		public function Mesh(url:String) {
			super();
			_subMeshes = new Vector.<SubMesh>();
			_materials = new Vector.<Material>();
			_url = url;
			
			if (_loaded)
				_generateBoundingObject();
			else
				once(Event.LOADED, this, _generateBoundingObject);
		}
		
		private function _generateBoundingObject():void {
			var pos:Vector.<Vector3> = positions;
			BoundBox.fromPoints(pos, _boundingBox);
			BoundSphere.fromPoints(pos, _boundingSphere);
		}
		
		/**
		 * 添加子网格（开发者禁止修改）。
		 * @param subMesh 子网格。
		 */
		public function add(subMesh:SubMesh):void {
			//TODO：SubMesh为私有问题。
			subMesh._indexOfHost = _subMeshes.length;
			_subMeshes.push(subMesh);
			_subMeshCount++;
		}
		
		/**
		 * 移除子网格。
		 * @param subMesh 子网格。
		 * @return  是否成功。
		 */
		public function remove(subMesh:SubMesh):Boolean {
			var index:int = _subMeshes.indexOf(subMesh);
			if (index < 0) return false;
			_subMeshes.splice(index, 1);
			_subMeshCount--;
			return true;
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
		 * 清除子网格。
		 * @return  子网格。
		 */
		public function clear():Mesh {
			_subMeshes.length = 0;
			_subMeshCount = 0;
			return this;
		}
		
		/** @private */
		public function disableUseFullBone():void {
			_useFullBone = false;
		}
		
		/**
		 * @private
		 */
		private function _addToRenderQuene(state:RenderState, material:Material):RenderObject {
			var o:RenderObject;
			if (material.isSky) {//待考虑
				o = state.scene.getRenderObject(RenderQueue.NONEWRITEDEPTH);
			} else {
				if (!material.transparent || (material.transparent && material.transparentMode === 0))
					o = material.cullFace ? state.scene.getRenderObject(RenderQueue.OPAQUE) : state.scene.getRenderObject(RenderQueue.OPAQUE_DOUBLEFACE);
				else if (material.transparent && material.transparentMode === 1) {
					if (material.transparentAddtive)
						o = material.cullFace ? state.scene.getRenderObject(RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND) : state.scene.getRenderObject(RenderQueue.DEPTHREAD_ALPHA_ADDTIVE_BLEND_DOUBLEFACE);
					else
						o = material.cullFace ? state.scene.getRenderObject(RenderQueue.DEPTHREAD_ALPHA_BLEND) : state.scene.getRenderObject(RenderQueue.DEPTHREAD_ALPHA_BLEND_DOUBLEFACE);
				}
			}
			return o;
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
			
			_subMeshes = null;
			_subMeshCount = 0;
			//_vb = null;
		}
	
		//public function regMaterials(name:String, materials:Vector.<Material>):void {
		//_materialsMap || (_materialsMap = {});
		//_materialsMap[name] = materials;
		//}
	
		//public function cloneActiveMaterials(materials:Vector.<Material>):Vector.<Material> {
		//materials || (materials = new Vector.<Material>());
		//materials.length = _materials.length;
		//for (var i:int = 0, n:int = _materials.length; i < n; i++) {
		//materials[i] || (materials[i] = new Material());
		//_materials[i].copy(materials[i]);
		//}
		//return materials;
		//}
	}
}

