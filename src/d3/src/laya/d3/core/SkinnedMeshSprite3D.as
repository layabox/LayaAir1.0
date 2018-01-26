package laya.d3.core {
	import laya.d3.component.Animator;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.SubMeshRenderElement;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shader.ShaderDefines;
	import laya.events.Event;
	import laya.net.Loader;
	
	/**
	 * <code>SkinnedMeshSprite3D</code> 类用于创建网格。
	 */
	public class SkinnedMeshSprite3D extends RenderableSprite3D {
		/**精灵级着色器宏定义,蒙皮动画。*/
		public static var SHADERDEFINE_BONE:int = 0x8;
		
		/**着色器变量名，蒙皮动画。*/
		public static const BONES:int = 0;
		
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(RenderableSprite3D.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_BONE = shaderDefines.registerDefine("BONE");
		}
		
		/**
		 * 加载网格模板。
		 * @param url 模板地址。
		 */
		public static function load(url:String):SkinnedMeshSprite3D {
			return Laya.loader.create(url, null, null, SkinnedMeshSprite3D);
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
			
			_geometryFilter = new MeshFilter(this);
			_render = new SkinnedMeshRender(this);
			
			_geometryFilter.on(Event.MESH_CHANGED, this, _onMeshChanged);
			_render.on(Event.MATERIAL_CHANGED, this, _onMaterialChanged);
			(mesh) && ((_geometryFilter as MeshFilter).sharedMesh = mesh);
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
		 * @inheritDoc
		 */
		override protected function _parseCustomProps(rootNode:ComponentNode, innerResouMap:Object, customProps:Object, json:Object):void {
			var render:SkinnedMeshRender = skinnedMeshRender;
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
				
				var rootBone:String = customProps.rootBone;
				(rootBone) && (render._setRootBone(rootBone));
				var boundBox:Object = customProps.boundBox;
				if (boundBox) {
					var min:Array = boundBox.min;
					var max:Array = boundBox.max;
					var localBoundBox:BoundBox = new BoundBox(new Vector3(min[0], min[1], min[2]), new Vector3(max[0], max[1], max[2]));
					render.localBoundBox = localBoundBox;
				} else {
					render._hasIndependentBound = false;
				}
				var boundSphere:Object = customProps.boundSphere;
				if (boundSphere) {
					var center:Array = boundSphere.center;
					var localBoundSphere:BoundSphere = new BoundSphere(new Vector3(center[0], center[1], center[2]), boundSphere.radius);
					render.localBoundSphere = localBoundSphere;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _changeHierarchyAnimator(animator:Animator):void {
			if (animator) {
				var render:SkinnedMeshRender = skinnedMeshRender;
				render._setCacheAnimator(animator);
				var avatar:Avatar = animator.avatar;
				(avatar) && (render._setCacheAvatar(avatar));
			}
			super._changeHierarchyAnimator(animator);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _clearSelfRenderObjects():void {
			_scene.removeFrustumCullingObject(_render);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _addSelfRenderObjects():void {
			_scene.addFrustumCullingObject(_render);
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
			destMeshRender._rootBone = meshRender._rootBone;
			var lbp:BoundSphere = meshRender.localBoundSphere;
			(lbp) && (destMeshRender.localBoundSphere = lbp.clone());
			var lbb:BoundBox = meshRender.localBoundBox;
			(lbb) && (destMeshRender.localBoundBox = lbb.clone());
			destMeshRender._hasIndependentBound = meshRender._hasIndependentBound;//兼容代码
			super.cloneTo(destObject);//父类函数在最后,组件应该最后赋值，否则获取材质默认值等相关函数会有问题
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy(destroyChild:Boolean = true):void {
			if (destroyed)
				return;
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