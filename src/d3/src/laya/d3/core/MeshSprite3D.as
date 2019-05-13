package laya.d3.core {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.graphics.DynamicBatchManager;
	import laya.d3.graphics.MeshRenderDynamicBatchManager;
	import laya.d3.graphics.MeshRenderStaticBatchManager;
	import laya.d3.graphics.StaticBatchManager;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.d3.shader.ShaderDefines;
	import laya.net.Loader;
	
	/**
	 * <code>MeshSprite3D</code> 类用于创建网格。
	 */
	public class MeshSprite3D extends RenderableSprite3D {
		public static var SHADERDEFINE_UV0:int;
		public static var SHADERDEFINE_COLOR:int;
		public static var SHADERDEFINE_UV1:int;
		public static var SHADERDEFINE_GPU_INSTANCE:int;
		/**@private */
		public static var shaderDefines:ShaderDefines = new ShaderDefines(RenderableSprite3D.shaderDefines);
		
		/**
		 * @private
		 */
		public static function __init__():void {
			SHADERDEFINE_UV0 = shaderDefines.registerDefine("UV");
			SHADERDEFINE_COLOR = shaderDefines.registerDefine("COLOR");
			SHADERDEFINE_UV1 = shaderDefines.registerDefine("UV1");
			SHADERDEFINE_GPU_INSTANCE = shaderDefines.registerDefine("GPU_INSTANCE");
			StaticBatchManager._registerManager(MeshRenderStaticBatchManager.instance);
			DynamicBatchManager._registerManager(MeshRenderDynamicBatchManager.instance);
		}
		
		/** @private */
		private var _meshFilter:MeshFilter;
		
		/**
		 * 获取网格过滤器。
		 * @return  网格过滤器。
		 */
		public function get meshFilter():MeshFilter {
			return _meshFilter as MeshFilter;
		}
		
		/**
		 * 获取网格渲染器。
		 * @return  网格渲染器。
		 */
		public function get meshRenderer():MeshRenderer {
			return _render as MeshRenderer;
		}
		
		/**
		 * 创建一个 <code>MeshSprite3D</code> 实例。
		 * @param mesh 网格,同时会加载网格所用默认材质。
		 * @param name 名字。
		 */
		public function MeshSprite3D(mesh:Mesh = null, name:String = null) {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			super(name);
			_meshFilter = new MeshFilter(this);
			_render = new MeshRenderer(this);
			(mesh) && (_meshFilter.sharedMesh = mesh);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _parse(data:Object):void {
			super._parse(data);
			var render:MeshRenderer = meshRenderer;
			var lightmapIndex:* = data.lightmapIndex;
			(lightmapIndex != null) && (render.lightmapIndex = lightmapIndex);
			var lightmapScaleOffsetArray:Array = data.lightmapScaleOffset;
			(lightmapScaleOffsetArray) && (render.lightmapScaleOffset = new Vector4(lightmapScaleOffsetArray[0], lightmapScaleOffsetArray[1], lightmapScaleOffsetArray[2], lightmapScaleOffsetArray[3]));
			(data.meshPath!=undefined) && (meshFilter.sharedMesh = Loader.getRes(data.meshPath));
			(data.enableRender!=undefined) && (meshRenderer.enable = data.enableRender);
			var materials:Array = data.materials;
			if (materials) {
				var sharedMaterials:Vector.<BaseMaterial> = render.sharedMaterials;
				var materialCount:int = materials.length;
				sharedMaterials.length = materialCount;
				for (var i:int = 0; i < materialCount; i++) {
					sharedMaterials[i] = Loader.getRes(materials[i].path);
				}
				
				render.sharedMaterials = sharedMaterials;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function _addToInitStaticBatchManager():void {
			MeshRenderStaticBatchManager.instance._addBatchSprite(this);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneTo(destObject:*):void {
			var meshSprite3D:MeshSprite3D = destObject as MeshSprite3D;
			meshSprite3D._meshFilter.sharedMesh = _meshFilter.sharedMesh;
			var meshRender:MeshRenderer = _render as MeshRenderer;
			var destMeshRender:MeshRenderer = meshSprite3D._render as MeshRenderer;
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
			super.destroy(destroyChild);
			_meshFilter.destroy();
		}
	
	}
}