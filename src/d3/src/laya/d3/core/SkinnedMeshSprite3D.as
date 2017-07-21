package laya.d3.core {
	import laya.d3.component.Animator;
	import laya.d3.component.animation.SkinAnimations;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.graphics.MeshSprite3DStaticBatchManager;
	import laya.d3.graphics.StaticBatchManager;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.models.SubMesh;
	import laya.display.Node;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.utils.Stat;
	
	/**
	 * <code>MeshSprite3D</code> 类用于创建网格。
	 */
	public class SkinnedMeshSprite3D extends RenderableSprite3D {
		/**着色器变量名，蒙皮动画。*/
		public static const BONES:int = 0;
		/**@private 精灵级着色器宏定义,蒙皮动画。*/
		public static var SHADERDEFINE_BONE:int = 0x8;
		
		/**
		 * 加载网格模板,注意:不缓存。
		 * @param url 模板地址。
		 */
		public static function load(url:String):MeshSprite3D {
			return Laya.loader.create(url, null, null, MeshSprite3D, null, 1, false);
		}
		
		/**@private */
		private var _subMeshOffset:Vector.<int>;
		
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
		public function get skinnedMeshRender():SkinnedMeshRender {
			return _render as SkinnedMeshRender;
		}
		
		/**
		 * 创建一个 <code>MeshSprite3D</code> 实例。
		 * @param mesh 网格,同时会加载网格所用默认材质。
		 * @param name 名字。
		 */
		public function SkinnedMeshSprite3D(mesh:BaseMesh = null, name:String = null) {
			super(name);
			_subMeshOffset = new Vector.<int>();
			
			var _this:* = this;
			_geometryFilter = new MeshFilter(_this);
			_render = new SkinnedMeshRender(_this);
			
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
			return renderElement;
		}
		
		/**
		 * @private
		 */
		private function _changeRenderObjectByMaterial(index:int, material:BaseMaterial):RenderElement {
			var renderElement:RenderElement = _render._renderElements[index];
			
			var renderObj:IRenderable = (_geometryFilter as MeshFilter).sharedMesh.getRenderElement(index);
			renderElement._mainSortID = _getSortID(renderObj, material);//根据MeshID排序，处理同材质合并处理。
			renderElement._sprite3D = this;
			renderElement.renderObj = renderObj;
			renderElement._material = material;
			return renderElement;
		}
		
		/**
		 * @private
		 */
		private function _changeRenderObjectsByMesh():void {
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
				mesh.once(Event.LOADED, this, _changeRenderObjectsByMesh);//TODO:假设Mesh未加载完成前无效。
		}
		
		/**
		 * @private
		 */
		private function _onMaterialChanged(meshRender:SkinnedMeshRender, index:int, material:BaseMaterial):void {//TODO:
			var renderElementCount:int = _render._renderElements.length;
			(index < renderElementCount) && _changeRenderObjectByMaterial(index, material);
		}
		
		/**
		 * @private
		 */
		override protected function _clearSelfRenderObjects():void {
			_scene.removeFrustumCullingObject(_render);
		}
		
		/**
		 * @private
		 */
		override protected function _addSelfRenderObjects():void {
			_scene.addFrustumCullingObject(_render);
			_getAvatar(this);
		}
		
		/**
		 * @private
		 */
		private function _getAvatar(sprite:Sprite3D):void {
			var animations:Animator = sprite.getComponentByType(Animator) as Animator;
			if (animations) {
				skinnedMeshRender._cacheAnimator = animations;
				return;
			}
			
			if (sprite._parent)
				_getAvatar(sprite._parent as Sprite3D);
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
		override public function cloneTo(destObject:*):void {
			super.cloneTo(destObject);
			var meshSprite3D:MeshSprite3D = destObject as MeshSprite3D;
			(meshSprite3D._geometryFilter as MeshFilter).sharedMesh = (_geometryFilter as MeshFilter).sharedMesh;
			var meshRender:SkinnedMeshRender = _render as SkinnedMeshRender;
			var destMeshRender:SkinnedMeshRender = meshSprite3D._render as SkinnedMeshRender;
			destMeshRender.enable = meshRender.enable;
			destMeshRender.sharedMaterials = meshRender.sharedMaterials;
			destMeshRender.castShadow = meshRender.castShadow;
			var lightmapScaleOffset:Vector4 = meshRender.lightmapScaleOffset;
			lightmapScaleOffset && (destMeshRender.lightmapScaleOffset = lightmapScaleOffset.clone());
			destMeshRender.receiveShadow = meshRender.receiveShadow;
			destMeshRender.sortingFudge = meshRender.sortingFudge;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
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