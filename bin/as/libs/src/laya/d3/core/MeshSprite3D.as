package laya.d3.core {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.graphics.RenderObject;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.display.Node;
	import laya.events.Event;
	import laya.utils.Stat;
	
	/**
	 * <code>MeshSprite3D</code> 类用于创建网格。
	 */
	public class MeshSprite3D extends Sprite3D {
		/** @private 网格数据模板。*/
		private var _meshFilter:MeshFilter;
		/** @private */
		private var _meshRender:MeshRender;
		
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
			_meshFilter = new MeshFilter(this);
			_meshRender = new MeshRender(this);
			
			_meshFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
			_meshRender.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			
			_meshFilter.sharedMesh = mesh;
			
			if (mesh is Mesh)//TODO:待考虑。
				if (mesh.loaded)
					_meshRender.sharedMaterials = (mesh as Mesh).materials;
				else
					mesh.once(Event.LOADED, this, _applyMeshMaterials);
		
		}
		
		/** @private */
		private function _applyMeshMaterials(mesh:Mesh):void {
			var shaderMaterials:Vector.<BaseMaterial> = _meshRender.sharedMaterials;
			var meshMaterials:Vector.<BaseMaterial> = mesh.materials;
			for (var i:int = 0, n:int = meshMaterials.length; i < n; i++)
				(shaderMaterials[i]) || (shaderMaterials[i] = meshMaterials[i]);
			
			_meshRender.sharedMaterials = shaderMaterials;
		}
		
		/** @private */
		private function _changeRenderObjectByMesh(index:int):RenderElement {
			var renderObjects:Vector.<RenderElement> = _meshRender.renderCullingObject._renderElements;
			
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new RenderElement());
			renderElement._renderObject = _meshRender.renderCullingObject;
			
			var material:BaseMaterial = _meshRender.sharedMaterials[index];
			(material) || (material = StandardMaterial.defaultMaterial);//确保有材质,由默认材质代替。
			
			var element:IRenderable = _meshFilter.sharedMesh.getRenderElement(index);
			renderElement._mainSortID = _getSortID(element, material);//根据MeshID排序，处理同材质合并处理。
			renderElement._sprite3D = this;
			
			renderElement.renderObj = element;
			renderElement._material = material;
			return renderElement;
		}
		
		/** @private */
		private function _changeRenderObjectByMaterial(index:int, material:BaseMaterial):RenderElement {
			var renderElement:RenderElement = _meshRender.renderCullingObject._renderElements[index];
			
			var element:IRenderable = _meshFilter.sharedMesh.getRenderElement(index);
			renderElement._mainSortID = _getSortID(element, material);//根据MeshID排序，处理同材质合并处理。
			renderElement._sprite3D = this;
			
			renderElement.renderObj = element;
			renderElement._material = material;
			return renderElement;
		}
		
		/** @private */
		private function _changeRenderObjectsByMesh():void {
			var renderElementsCount:int = _meshFilter.sharedMesh.getRenderElementsCount();
			_meshRender.renderCullingObject._renderElements.length = renderElementsCount;
			for (var i:int = 0; i < renderElementsCount; i++)
				_changeRenderObjectByMesh(i);
		}
		
		/** @private */
		private function _onMeshChanged(meshFilter:MeshFilter):void {
			var mesh:BaseMesh = meshFilter.sharedMesh;
			if (mesh.loaded)
				_changeRenderObjectsByMesh();
			else
				mesh.once(Event.LOADED, this, _onMeshLoaded);//TODO:假设Mesh未加载完成前无效。
		}
		
		/** @private */
		private function _onMeshLoaded(sender:Mesh):void {
			(sender === meshFilter.sharedMesh) && (_changeRenderObjectsByMesh());
		}
		
		/** @private */
		private function _onMaterialChanged(meshRender:MeshRender,index:int,material:BaseMaterial):void {//TODO:
			var renderElementCount:int = _meshRender.renderCullingObject._renderElements.length;
			(index<renderElementCount)&&_changeRenderObjectByMaterial(index, material);
		}
		
		/** @private */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_meshRender.renderCullingObject);
		}
		
		/** @private */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_meshRender.renderCullingObject);
		}
		
		/**
		 * @private
		 */
		public override function _update(state:RenderState):void {
			state.owner = this;
			if (_enable) {
				_updateComponents(state);
				_lateUpdateComponents(state);
			}
			
			Stat.spriteCount++;
			_childs.length && _updateChilds(state);
		}
		
		override public function dispose():void {
			super.dispose();
			_meshFilter.off(Event.MESH_CHANGED, this, _onMeshChanged);
			_meshRender.off(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
		}
	
	}
}