package laya.d3.core {
	import laya.d3.core.material.Material;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderObject;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.events.Event;
	import laya.utils.Stat;
	
	/**
	 * <code>MeshSprite3D</code> 类用于创建网格。
	 */
	public class MeshSprite3D extends Sprite3D {
		/** @private */
		private var _renderObjects:Vector.<RenderObject>;
		
		/** @private 网格数据模板。*/
		private var _meshFilter:MeshFilter;
		/** @private */
		private var _meshRender:MeshRender;
		
		/** @private */
		public var _iAsyncLodingMeshMaterial:Boolean;
		/** @private */
		public var _iAsyncLodingMeshMaterials:Boolean;
		
		/**
		 * 获取网格过滤器。
		 * @return  网格过滤器。
		 */
		public function get meshFilter():MeshFilter {
			return _meshFilter;
		}
		
		/**
		 * 获取网格渲染器。
		 * @return  网格渲染器。
		 */
		public function get meshRender():MeshRender {
			return _meshRender;
		}
		
		/**
		 * 创建一个 <code>MeshSprite3D</code> 实例。
		 * @param mesh 网格,同时会加载网格所用默认材质。
		 * @param name 名字。
		 */
		public function MeshSprite3D(mesh:BaseMesh, name:String = null) {
			super(name);
			_renderObjects = new Vector.<RenderObject>();
			_meshFilter = new MeshFilter(this);
			_meshRender = new MeshRender(this);
		
			_meshFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
			_meshRender.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			
			_meshFilter.sharedMesh = mesh;
			
			if (mesh is Mesh)//TODO:待考虑。
				if (mesh.loaded) {
					_iAsyncLodingMeshMaterial = _iAsyncLodingMeshMaterials = false;
					_meshRender.shadredMaterials = (mesh as Mesh).materials;
				} else {
					_iAsyncLodingMeshMaterial = _iAsyncLodingMeshMaterials = true;
					mesh.once(Event.LOADED, this, _copyMaterials);
				}
		}
		
		/** @private */
		private function _onMeshChanged(meshFilter:MeshFilter):void {
			
		
		}
		
		/** @private */
		private function _onMaterialChanged(meshRender:MeshRender, materials:Array):void {
			
		}
		
		/** @private */
		private function _copyMaterials(mesh:Mesh):void {
			if (_iAsyncLodingMeshMaterials) {
				if (_iAsyncLodingMeshMaterial)
					_meshRender.shadredMaterials = mesh.materials;
				else {
					var meshMaterials:Vector.<Material> = mesh.materials;
					if (meshMaterials.length > 0) {
						meshMaterials[0] = _meshRender.shadredMaterial;
						_meshRender.shadredMaterials = meshMaterials;
					}
				}
			}
			_iAsyncLodingMeshMaterial = _iAsyncLodingMeshMaterials = false;
		}
		
		/** @private */
		override public function _clearSelfRenderObjects():void {
			for (var i:int = 0, n:int = _renderObjects.length; i < n; i++) {
				var renderObj:RenderObject = _renderObjects[i];
				renderObj.renderQneue.deleteRenderObj(renderObj);
			}
			_renderObjects.length = 0;
		}
		
		/**
		 * @private
		 */
		public override function _update(state:RenderState):void {
			state.owner = this;
			_updateComponents(state);
			if (active) {
				var renderElementsCount:int = _meshFilter.sharedMesh.getRenderElementsCount();
				for (var i:int = 0; i < renderElementsCount; i++) {
					var obj:RenderObject = _renderObjects[i];
					var materials:Vector.<Material> = _meshRender.shadredMaterials;
					if (obj) {
						var material:Material = materials[i];
						var renderQueue:RenderQueue = state.scene.getRenderQueue(material.renderQueue);
						if (obj.renderQneue != renderQueue) {
							obj.renderQneue.deleteRenderObj(obj);
							obj = _addRenderObject(state, i, material);
						}
					} else {
						obj = _addRenderObject(state, i, materials[i]);
					}
				}
				_lateUpdateComponents(state);
			} else {
				_clearSelfRenderObjects();
			}
			
			Stat.spriteCount++;
			_childs.length && _updateChilds(state);
		}
		
		private function _addRenderObject(state:RenderState, index:int, material:Material):RenderObject {
			var renderObj:RenderObject = state.scene.getRenderObject(material.renderQueue);
			_renderObjects[index] = renderObj;
			
			var renderElement:IRenderable = _meshFilter.sharedMesh.getRenderElement(index);
			renderObj.mainSortID = state.owner._getSortID(renderElement, material);//根据MeshID排序，处理同材质合并处理。
			renderObj.triangleCount = renderElement.triangleCount;
			renderObj.owner = state.owner;
			
			renderObj.renderElement = renderElement;
			renderObj.material = material;
			return renderObj;
		}
		
		override public function dispose():void {
			super.dispose();
			_meshFilter.off(Event.MESH_CHANGED, this, _onMeshChanged);
			_meshRender.off(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
		}
	
	}
}