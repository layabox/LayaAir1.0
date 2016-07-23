package laya.d3.resource.models {
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.Material;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderObject;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.loaders.LoadModel;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
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
			_subMeshes = new Vector.<SubMesh>();
			_materials = new Vector.<Material>();
			_url = url;
			super();
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
		 * @private
		 */
		override public function updateToRenderQneue(state:RenderState, materials:Vector.<Material>):void {
			var subMeshes:Vector.<SubMesh> = _subMeshes;
			if (subMeshes.length === 0)
				return;
			
			for (var i:int = 0, n:int = subMeshes.length; i < n; i++) {
				var subMesh:SubMesh = subMeshes[i];
				var material:Material = subMesh.getMaterial(materials);
				
				var o:RenderObject = _addToRenderQuene(state, material);
				
				o.sortID = state.owner._getSortID(subMesh, material);//根据MeshID排序，处理同材质合并处理。
				o.owner = state.owner;
				
				o.renderElement = subMesh;
				o.material = material;
				o.tag || (o.tag = new Object());
				o.tag.worldTransformModifyID = state.worldTransformModifyID;
			}
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
