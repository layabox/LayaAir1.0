package laya.d3.terrain {
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.StandardMaterial;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.render.IRenderable;
	import laya.d3.core.render.RenderElement;
	import laya.d3.core.render.RenderQueue;
	import laya.d3.core.render.RenderState;
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.BaseMesh;
	import laya.d3.resource.models.Mesh;
	import laya.d3.resource.Texture2D;
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
		public function TerrainChunk(chunkOffsetX:int,chunkOffsetZ:int,girdSize:Number,terrainHeightData:Float32Array,heightDataWidth:int,heightDataHeight:int,name:String = null) {
			super(name);
			_geometryFilter = new TerrainFilter(this,chunkOffsetX,chunkOffsetZ,girdSize,terrainHeightData,heightDataWidth,heightDataHeight);
			_render = new TerrainRender(this);
		}
		
		public function buildRenderElementAndMaterial( detailNum:int,normalMap:String,alphaMapUrl:String, detailUrl1:String, detailUrl2:String, detailUrl3:String, detailUrl4:String,
													sx1:Number=1,sy1:Number=1,sx2:Number=1,sy2:Number=1,sx3:Number=1,sy3:Number=1,sx4:Number=1,sy4:Number=1 ):void
		{
			var terrainMaterial:TerrainMaterial = new TerrainMaterial();
			terrainMaterial.splatAlphaTexture = Texture2D.load(alphaMapUrl);
			terrainMaterial.splatAlphaTexture.repeat = false;
			terrainMaterial.normalTexture = normalMap ? Texture2D.load(normalMap) : null;
			terrainMaterial.diffuseTexture1 = detailUrl1 ? Texture2D.load(detailUrl1) : null;
			terrainMaterial.diffuseTexture2 = detailUrl2 ? Texture2D.load(detailUrl2) : null;
			terrainMaterial.diffuseTexture3 = detailUrl3 ? Texture2D.load(detailUrl3) : null;
			terrainMaterial.diffuseTexture4 = detailUrl4 ? Texture2D.load(detailUrl4) : null;
			terrainMaterial.setDiffuseScale1(sx1, sy1);
			terrainMaterial.setDiffuseScale2(sx2, sy2);
			terrainMaterial.setDiffuseScale3(sx3, sy3);
			terrainMaterial.setDiffuseScale4(sx4, sy4);
			terrainMaterial.setDetailNum( detailNum );
			if ( _render._renderElements.length != 0 )
			{
				terrainMaterial.renderMode = TerrainMaterial.RENDERMODE_TRANSPARENT;
			}
			var renderElement:RenderElement = new RenderElement();
			renderElement._mainSortID = 0;
			renderElement._sprite3D = this;
			renderElement.renderObj = _geometryFilter as TerrainFilter;
			renderElement._material = terrainMaterial;
			_render._materials.push( terrainMaterial );
			_render._renderElements.push(renderElement);
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
			scene.removeFrustumCullingObject(_render);
			/*
			if (scene.conchModel) {//NATIVE
				scene.conchModel.removeChild(_render._conchRenderObject);
			}
			*/
		}
		
		/**
		 * @private
		 */
		override protected function _addSelfRenderObjects():void {
			scene.addFrustumCullingObject(_render);
			/*
			if (scene.conchModel) {//NATIVE
				scene.conchModel.addChildAt(_render._conchRenderObject);
			}
			*/
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
		override public function _renderUpdate(projectionView:Matrix4x4):void {
			super._renderUpdate(projectionView);
		}
		
		override public function cloneTo(destObject:*):void {
			trace("Terrain Chunk can't clone");
		}
		
		override public function destroy(destroyChild:Boolean = true):void {
			super.destroy(destroyChild);
			(_geometryFilter as TerrainFilter)._destroy();
		}
	
	}
}