package laya.d3.core {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.graphics.MeshSprite3DStaticBatchManager;
	import laya.d3.graphics.StaticBatchManager;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.renders.Render;
	
	/**
	 * <code>MeshSprite3D</code> 类用于创建网格。
	 */
	public class MeshSprite3D extends RenderableSprite3D {
		/** @private */
		private static var _staticBatchManager:MeshSprite3DStaticBatchManager = new MeshSprite3DStaticBatchManager();
		
		/**
		 * @private
		 */
		public static function __init__():void {
			StaticBatchManager._staticBatchManagers.push(_staticBatchManager);
		}
		
		/**
		 * 加载网格模板。
		 * @param url 模板地址。
		 */
		public static function load(url:String):MeshSprite3D {
			return Laya.loader.create(url, null, null, MeshSprite3D);
		}
		
		/**
		 * 获取网格过滤器。
		 * @return  网格过滤器。
		 */
		public function get meshFilter():MeshFilter {
			return _geometryFilter as MeshFilter;
		}
		
		/**
		 * 获取网格渲染器。
		 * @return  网格渲染器。
		 */
		public function get meshRender():MeshRender {
			return _render as MeshRender;
		}
		
		/**
		 * 创建一个 <code>MeshSprite3D</code> 实例。
		 * @param mesh 网格,同时会加载网格所用默认材质。
		 * @param name 名字。
		 */
		public function MeshSprite3D(mesh:BaseMesh = null, name:String = null) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(name);
			_geometryFilter = new MeshFilter(this);
			_render = new MeshRender(this);
			
			_geometryFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
			_render.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			
			if (mesh) {
				(_geometryFilter as MeshFilter).sharedMesh = mesh;
				
				if (mesh is Mesh)//TODO:待考虑。
					if (mesh.loaded)
						_render.sharedMaterials = (mesh as Mesh).materials;
					else
						mesh.once(Event.LOADED, this, _applyMeshMaterials);
			}
		}
		
		/**
		 * @private
		 */
		private function _changeRenderObjectByMesh(index:int):RenderElement {
			var renderObjects:Vector.<RenderElement> = _render._renderElements;
			
			var renderElement:RenderElement = renderObjects[index];
			(renderElement) || (renderElement = renderObjects[index] = new SubMeshRenderElement());
			renderElement._render = _render;
			
			var material:BaseMaterial = _render.sharedMaterials[index];
			(material) || (material = StandardMaterial.defaultMaterial);//确保有材质,由默认材质代替。
			
			var renderObj:IRenderable = (_geometryFilter as MeshFilter).sharedMesh.getRenderElement(index);
			renderElement._mainSortID = _getSortID(renderObj, material);//根据MeshID排序，处理同材质合并处理。
			renderElement._sprite3D = this;
			
			renderElement.renderObj = renderObj;
			renderElement._material = material;
			
			if (Render.isConchNode) {//NATIVE
				var vertexBuffer:VertexBuffer3D = renderObj._getVertexBuffer();
				renderElement._conchSubmesh.setVBIB(vertexBuffer.vertexDeclaration._conchVertexDeclaration, vertexBuffer.getData(), renderObj._getIndexBuffer().getData());
			}
			return renderElement;
		}
		
		/**
		 * @private
		 */
		private function _changeRenderObjectByMaterial(index:int, material:BaseMaterial):RenderElement {
			var renderElement:RenderElement = _render._renderElements[index];
			
			(material) || (material = StandardMaterial.defaultMaterial);//确保有材质,由默认材质代替。
			var renderObj:IRenderable = (_geometryFilter as MeshFilter).sharedMesh.getRenderElement(index);
			renderElement._mainSortID = _getSortID(renderObj, material);//根据MeshID排序，处理同材质合并处理。
			renderElement._sprite3D = this;
			
			renderElement.renderObj = renderObj;
			renderElement._material = material;
			
			if (Render.isConchNode) {//NATIVE
				renderElement._conchSubmesh.setMaterial(material._conchMaterial);
			}
			return renderElement;
		}
		
		/**
		 * @private
		 */
		private function _changeRenderObjectsByMesh():void {
			if (Render.isConchNode) {//NATIVE
				//var box:BoundBox = (_geometryFilter as MeshFilter).sharedMesh.boundingBox;
				//_render._conchRenderObject.boundingBox(box.min.elements, box.max.elements);
			}
			var renderElementsCount:int = (_geometryFilter as MeshFilter).sharedMesh.getRenderElementsCount();
			_render._renderElements.length = renderElementsCount;
			for (var i:int = 0; i < renderElementsCount; i++)
				_changeRenderObjectByMesh(i);
		}
		
		/**
		 * @private
		 */
		private function _onMeshChanged(meshFilter:MeshFilter):void {
			var mesh:BaseMesh = meshFilter.sharedMesh;
			if (mesh.loaded)
				_changeRenderObjectsByMesh();
			else
				mesh.once(Event.LOADED, this, _onMeshLoaded);//TODO:假设Mesh未加载完成前无效。
		}
		
		/**
		 * @private
		 */
		private function _onMeshLoaded(sender:Mesh):void {
			(sender === meshFilter.sharedMesh) && (_changeRenderObjectsByMesh());
		}
		
		/**
		 * @private
		 */
		private function _onMaterialChanged(meshRender:MeshRender, index:int, material:BaseMaterial):void {//TODO:
			var renderElementCount:int = _render._renderElements.length;
			(index < renderElementCount) && _changeRenderObjectByMaterial(index, material);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_render);
			//if (scene.conchModel) {//NATIVE
			//scene.conchModel.removeChild(_render._conchRenderObject);
			//}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_render);
			//if (scene.conchModel) {//NATIVE
			//scene.conchModel.addChildAt(_render._conchRenderObject);
			//}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _parseCustomProps(rootNode:ComponentNode, innerResouMap:Object, customProps:Object, json:Object):void {
			var render:MeshRender = meshRender;
			var lightmapIndex:* = customProps.lightmapIndex;
			(lightmapIndex != null) && (render.lightmapIndex = lightmapIndex);
			var lightmapScaleOffsetArray:Array = customProps.lightmapScaleOffset;
			(lightmapScaleOffsetArray) && (render.lightmapScaleOffset = new Vector4(lightmapScaleOffsetArray[0], lightmapScaleOffsetArray[1], lightmapScaleOffsetArray[2], lightmapScaleOffsetArray[3]));
			var meshPath:String, mesh:Mesh;
			if (json.instanceParams) {//兼容代码
				meshPath = json.instanceParams.loadPath;
				if (meshPath) {
					mesh = Loader.getRes(innerResouMap[meshPath]);
					meshFilter.sharedMesh = mesh;
					if (mesh.loaded)
						render.sharedMaterials = mesh.materials;
					else
						mesh.once(Event.LOADED, this, _applyMeshMaterials);
				}
			} else {
				meshPath = customProps.meshPath;
				if (meshPath) {
					mesh = Loader.getRes(innerResouMap[meshPath]);
					meshFilter.sharedMesh = mesh;
				}
				
				var materials:Array = customProps.materials;
				if (materials) {
					var sharedMaterials:Vector.<BaseMaterial> = render.sharedMaterials;
					var materialCount:int = materials.length;
					sharedMaterials.length = materialCount;
					for (var i:int = 0; i < materialCount; i++)
						sharedMaterials[i] = Loader.getRes(innerResouMap[materials[i].path]);
					render.sharedMaterials = sharedMaterials;
				}
			}
		}
		
		/**
		 * @private
		 */
		public function _applyMeshMaterials(mesh:Mesh):void {
			var shaderMaterials:Vector.<BaseMaterial> = _render.sharedMaterials;
			var meshMaterials:Vector.<BaseMaterial> = mesh.materials;
			for (var i:int = 0, n:int = meshMaterials.length; i < n; i++)
				(shaderMaterials[i]) || (shaderMaterials[i] = meshMaterials[i]);
			
			_render.sharedMaterials = shaderMaterials;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _addToInitStaticBatchManager():void {
			_staticBatchManager._addInitBatchSprite(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			var meshSprite3D:MeshSprite3D = destObject as MeshSprite3D;
			(meshSprite3D._geometryFilter as MeshFilter).sharedMesh = (_geometryFilter as MeshFilter).sharedMesh;
			var meshRender:MeshRender = _render as MeshRender;
			var destMeshRender:MeshRender = meshSprite3D._render as MeshRender;
			destMeshRender.enable = meshRender.enable;
			destMeshRender.sharedMaterials = meshRender.sharedMaterials;
			destMeshRender.castShadow = meshRender.castShadow;
			var lightmapScaleOffset:Vector4 = meshRender.lightmapScaleOffset;
			lightmapScaleOffset && (destMeshRender.lightmapScaleOffset = lightmapScaleOffset.clone());
			destMeshRender.lightmapIndex = meshRender.lightmapIndex;
			destMeshRender.receiveShadow = meshRender.receiveShadow;
			destMeshRender.sortingFudge = meshRender.sortingFudge;
			super.cloneTo(destObject);//父类函数在最后,组件应该最后赋值，否则获取材质默认值等相关函数会有问题
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			if (destroyed)
				return;
			var mesh:BaseMesh = meshFilter.sharedMesh;
			(mesh.loaded) || (mesh.off(Event.LOADED, this, _applyMeshMaterials));
			super.destroy(destroyChild);
			(_geometryFilter as MeshFilter)._destroy();
		}
		
		/**
		 * @private
		 */
		override public function createConchModel():* {
			return null;
		}
	
	}
}