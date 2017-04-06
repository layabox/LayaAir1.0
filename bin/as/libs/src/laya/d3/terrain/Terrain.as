package laya.d3.terrain {
	import laya.d3.core.scene.BaseScene;
	import laya.d3.math.Vector2;
	import laya.d3.terrain.unit.ChunkInfo;
	import laya.events.Event;
	
	/**
	 * <code>Terrain</code> 类用于创建地块。
	 */
	public class Terrain{
		public var _scene:BaseScene;
		public var _terrainChunks:Vector.<TerrainChunk>;
		/**
		 * 加载网格模板,注意:不缓存。
		 * @param url 模板地址。
		 */
		public static function load(url:String):Terrain {
			return Laya.loader.create(url, null, null, Terrain, null, 1, false);
		}
		
		/**
		 * 创建一个 <code>MeshSprite3D</code> 实例。
		 * @param mesh 网格,同时会加载网格所用默认材质。
		 * @param name 名字。
		 */
		public function Terrain( scene:BaseScene,terrainRes:TerrainRes ) 
		{	
			_scene = scene;
			if (terrainRes)
			{
				if (terrainRes.loaded)
					buildTerrain(terrainRes);
				else
					terrainRes.once(Event.LOADED, this, buildTerrain);
			}
		}
		
		public function buildTerrain( terrainRes:TerrainRes ):void
		{
			var chunkNumX:int =  terrainRes._chunkNumX;
			var chunkNumZ:int =  terrainRes._chunkNumZ;
			_terrainChunks = new Vector.<TerrainChunk>(chunkNumZ * chunkNumX );
			var heightData:TerrainHeightData = terrainRes._heightData;
			var n:int = 0;
			for ( var i:int = 0; i < chunkNumZ; i++ )
			{
				for ( var j:int = 0; j < chunkNumX; j++ )
				{
					var terrainChunk:TerrainChunk = new TerrainChunk( j, i, terrainRes._gridSize, heightData._terrainHeightData, heightData._width, heightData._height );
					var chunkInfo:ChunkInfo = terrainRes._chunkInfos[n];
					for ( var k:int = 0; k < chunkInfo.alphaMap.length; k++ )
					{
						var nNum:int = chunkInfo.detailID[k].length;						
						var sDetialTextureUrl1:String = ( nNum > 0 ) ? terrainRes._detailTextureInfos[ chunkInfo.detailID[k][0] ].diffuseTexture : null;
						var sDetialTextureUrl2:String = ( nNum > 1 ) ? terrainRes._detailTextureInfos[ chunkInfo.detailID[k][1] ].diffuseTexture : null;
						var sDetialTextureUrl3:String = ( nNum > 2 ) ? terrainRes._detailTextureInfos[ chunkInfo.detailID[k][2] ].diffuseTexture : null;
						var sDetialTextureUrl4:String = ( nNum > 3 ) ? terrainRes._detailTextureInfos[ chunkInfo.detailID[k][3] ].diffuseTexture : null;
						
						var detialScale1:Vector2 = ( nNum > 0 ) ? terrainRes._detailTextureInfos[ chunkInfo.detailID[k][0] ].scale : null;
						var detialScale2:Vector2 = ( nNum > 1 ) ? terrainRes._detailTextureInfos[ chunkInfo.detailID[k][1] ].scale : null;
						var detialScale3:Vector2 = ( nNum > 2 ) ? terrainRes._detailTextureInfos[ chunkInfo.detailID[k][2] ].scale : null;
						var detialScale4:Vector2 = ( nNum > 3 ) ? terrainRes._detailTextureInfos[ chunkInfo.detailID[k][3] ].scale : null;
						terrainChunk.buildRenderElementAndMaterial(nNum,chunkInfo.normalMap,chunkInfo.alphaMap[k], sDetialTextureUrl1, sDetialTextureUrl2, sDetialTextureUrl3, sDetialTextureUrl4,
											detialScale1?detialScale1.x:1, detialScale1?detialScale1.y:1,detialScale2?detialScale2.x:1, detialScale2?detialScale2.y:1,
											detialScale3?detialScale3.x:1, detialScale3?detialScale3.y:1,detialScale4?detialScale4.x:1, detialScale4?detialScale4.y:1 );
					}
					terrainChunk.transform.localScale = terrainRes._scale;
					terrainChunk.transform.localRotation = terrainRes._rotation;
					terrainChunk.transform.localPosition = terrainRes._position;
					terrainChunk.terrainRender.receiveShadow = true;
					_terrainChunks[n] = terrainChunk;
					_scene.addChild( terrainChunk );
					n++;
				}
			}
		}
	}
}