package laya.d3.terrain {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.graphics.RenderObject;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.display.Node;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.utils.Stat;
	
	/**
	 * <code>TerrainChunk</code> 类用于创建地块。
	 */
	public class TerrainChunk extends RenderableSprite3D {
		/**
		 * 加载网格模板,注意:不缓存。
		 * @param url 模板地址。
		 */
		public static function load(url:String):TerrainChunk {
			return Laya.loader.create(url, null, null, TerrainChunk, null, 1, false);
		}
		
		/**
		 * 获取地形过滤器。
		 * @return  地形过滤器。
		 */
		public function get terrainFilter():TerrainFilter {
			return _geometryFilter as TerrainFilter;
		}
		
		/**
		 * 获取地形渲染器。
		 * @return  地形渲染器。
		 */
		public function get terrainRender():TerrainRender {
			return _render as TerrainRender;
		}
		
		/**
		 * 创建一个 <code>MeshSprite3D</code> 实例。
		 * @param mesh 网格,同时会加载网格所用默认材质。
		 * @param name 名字。
		 */
		public function TerrainChunk(gridXNum:int,gridZNum:int,girdSize:int,name:String = null) {
			super(name);
			_geometryFilter = new TerrainFilter(this,gridXNum,gridZNum,girdSize);
			_render = new TerrainRender(this);
			var renderElement:RenderElement = new RenderElement();
			var material:BaseMaterial = _render.sharedMaterial;
			(material) || (material = TerrainMaterial.defaultMaterial);
			renderElement._mainSortID = 0;
			renderElement._sprite3D = this;
			renderElement.renderObj = _geometryFilter as TerrainFilter;
			renderElement._material = material;
			_render.renderObject._renderElements.push(renderElement);
		}
		
		/**
		 * @private
		 */
		override public function createConchModel():* {
			return null;
		}
		
		/**
		 * @private
		 */
		override protected function _clearSelfRenderObjects():void {
			scene.removeFrustumCullingObject(_render.renderObject);
			if (scene.conchModel) {//NATIVE
				scene.conchModel.removeChild(_render.renderObject._conchRenderObject);
			}
		}
		
		/**
		 * @private
		 */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_render.renderObject);
			if (scene.conchModel) {//NATIVE
				scene.conchModel.addChildAt(_render.renderObject._conchRenderObject);
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
		 * @private
		 */
		override public function _prepareShaderValuetoRender(projectionView:Matrix4x4):void {
			super._prepareShaderValuetoRender(projectionView);
		}
		
		override public function cloneTo(destObject:*):void {
			//TODO
			/*
			super.cloneTo(destObject);
			var meshSprite3D:MeshSprite3D = destObject as MeshSprite3D;
			(meshSprite3D._geometryFilter as MeshFilter).sharedMesh = (_geometryFilter as MeshFilter).sharedMesh;
			var meshRender:MeshRender = _render as MeshRender;
			var destMeshRender:MeshRender = meshSprite3D._render as MeshRender;
			destMeshRender.enable = meshRender.enable;
			destMeshRender.sharedMaterials = meshRender.sharedMaterials;
			destMeshRender.castShadow = meshRender.castShadow;
			var lightmapScaleOffset:Vector4 = meshRender.lightmapScaleOffset;
			lightmapScaleOffset && (destMeshRender.lightmapScaleOffset = lightmapScaleOffset.clone());
			destMeshRender.receiveShadow = meshRender.receiveShadow;
			*/
		}
		
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			(_geometryFilter as TerrainFilter)._destroy();
		}
	
	}
}