package laya.d3.terrain {
	import laya.d3.core.RenderableSprite3D;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.BaseMaterial;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.core.render.RenderElement;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.resource.models.Mesh;
	import laya.net.Loader;
	
	/**
	 * <code>TerrainChunk</code> 类用于创建地块。
	 */
	public class TerrainChunk extends RenderableSprite3D {
		
		/** @private */
		private var _terrainFilter:TerrainFilter;
		
		/**
		 * 获取地形过滤器。
		 * @return  地形过滤器。
		 */
		public function get terrainFilter():TerrainFilter {
			return _terrainFilter;
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
		public function TerrainChunk(chunkOffsetX:int, chunkOffsetZ:int, girdSize:Number, terrainHeightData:Float32Array, heightDataWidth:int, heightDataHeight:int, cameraCoordinateInverse:Boolean, name:String = null) {
			super(name);
			_terrainFilter = new TerrainFilter(this, chunkOffsetX, chunkOffsetZ, girdSize, terrainHeightData, heightDataWidth, heightDataHeight, cameraCoordinateInverse);
			_render = new TerrainRender(this);
		}
		
		public function buildRenderElementAndMaterial(detailNum:int, normalMap:String, alphaMapUrl:String, detailUrl1:String, detailUrl2:String, detailUrl3:String, detailUrl4:String, ambientColor:Vector3, diffuseColor:Vector3, specularColor:Vector4, sx1:Number = 1, sy1:Number = 1, sx2:Number = 1, sy2:Number = 1, sx3:Number = 1, sy3:Number = 1, sx4:Number = 1, sy4:Number = 1):void {
			var terrainMaterial:TerrainMaterial = new TerrainMaterial();
			if (diffuseColor) terrainMaterial.diffuseColor = diffuseColor;
			if (ambientColor) terrainMaterial.ambientColor = ambientColor;
			if (specularColor) terrainMaterial.specularColor = specularColor;
			terrainMaterial.splatAlphaTexture = Loader.getRes(alphaMapUrl);
			terrainMaterial.normalTexture = normalMap ? Loader.getRes(normalMap) : null;
			terrainMaterial.diffuseTexture1 = detailUrl1 ? Loader.getRes(detailUrl1) : null;
			terrainMaterial.diffuseTexture2 = detailUrl2 ? Loader.getRes(detailUrl2) : null;
			terrainMaterial.diffuseTexture3 = detailUrl3 ? Loader.getRes(detailUrl3) : null;
			terrainMaterial.diffuseTexture4 = detailUrl4 ? Loader.getRes(detailUrl4) : null;
			terrainMaterial.setDiffuseScale1(sx1, sy1);
			terrainMaterial.setDiffuseScale2(sx2, sy2);
			terrainMaterial.setDiffuseScale3(sx3, sy3);
			terrainMaterial.setDiffuseScale4(sx4, sy4);
			terrainMaterial.setDetailNum(detailNum);
			if (_render._renderElements.length != 0) {
				terrainMaterial.renderMode = TerrainMaterial.RENDERMODE_TRANSPARENT;
			}
			
			var renderElement:RenderElement = new RenderElement();
			renderElement.setTransform(_transform);
			renderElement.render = _render;
			renderElement.setGeometry(_terrainFilter);
			_render._renderElements.push(renderElement);
			_render.sharedMaterial = terrainMaterial;
			
		}
		
		override public function cloneTo(destObject:*):void {
			trace("Terrain Chunk can't clone");
		}
		
		override public function destroy(destroyChild:Boolean = true):void {
			if (destroyed)
				return;
			super.destroy(destroyChild);
			_terrainFilter.destroy();
			_terrainFilter = null;
		}
	
	}
}