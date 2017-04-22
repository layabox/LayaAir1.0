package laya.d3.terrain {
	import laya.d3.core.scene.BaseScene;
	import laya.d3.core.Sprite3D;
	import laya.d3.graphics.VertexBuffer3D;
	import laya.d3.math.BoundBox;
	import laya.d3.math.BoundSphere;
	import laya.d3.math.Matrix4x4;
	import laya.d3.math.Vector2;
	import laya.d3.terrain.unit.ChunkInfo;
	import laya.events.Event;
	
	/**
	 * <code>Terrain</code> 类用于创建地块。
	 */
	public class Terrain extends Sprite3D {
		public static var RENDER_LINE_MODEL:Boolean = false;
		public static var LOD_TOLERANCE_VALUE:Number = 4;
		public static var LOD_DISTANCE_FACTOR:Number = 2.0;
		public var _terrainRes:TerrainRes = null;
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
		public function Terrain( terrainRes:TerrainRes ) 
		{
			if (terrainRes)
			{
				_terrainRes = terrainRes;
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
			var heightData:TerrainHeightData = terrainRes._heightData;
			var n:int = 0;
			for ( var i:int = 0; i < chunkNumZ; i++ )
			{
				for ( var j:int = 0; j < chunkNumX; j++ )
				{
					var terrainChunk:TerrainChunk = new TerrainChunk( j, i, terrainRes._gridSize, heightData._terrainHeightData, heightData._width, heightData._height );
					var chunkInfo:ChunkInfo = terrainRes._chunkInfos[n++];
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
					terrainChunk.terrainRender.receiveShadow = true;
					addChild(terrainChunk);
				}
			}
		}
		/**
		 * 获取地形X轴长度。
		 * @return  地形X轴长度。
		 */
		public function width():Number
		{
			return _terrainRes._chunkNumX* TerrainLeaf.CHUNK_GRID_NUM * _terrainRes._gridSize;
		}
			/**
		 * 获取地形Z轴长度。
		 * @return  地形Z轴长度。
		 */
		public function depth():Number
		{
			return _terrainRes._chunkNumZ * TerrainLeaf.CHUNK_GRID_NUM * _terrainRes._gridSize;
		}
		/**
		 * 获取地形高度。
		 * @param x X轴坐标。
		 * @param z Z轴坐标。
		 */
		public function getHeightXZ(x:Number,z:Number):Number
		{
			if (!_terrainRes || !_terrainRes.loaded)
				return NaN;
				
			x -= transform.position.x;
			z -= transform.position.z;
			
			if (x < 0 || x > width() || z < 0 || z > depth())
				return NaN;
			
			var gridSize:Number = _terrainRes._gridSize;
			var nIndexX:int = parseInt("" + x / gridSize);
			var nIndexZ:int = parseInt("" + z / gridSize);
			
			var offsetX:Number = x - nIndexX * gridSize;
			var offsetZ:Number = z - nIndexZ * gridSize;
			var h1:Number;
			var h2:Number;
			var h3:Number;
			var u:Number;
			var v:Number;
			
			var heightData:TerrainHeightData = _terrainRes._heightData;
			
			if(offsetX + offsetZ > gridSize)
			{
				h1 = heightData._terrainHeightData[(nIndexZ + 1 - 1) * heightData._width + nIndexX + 1];
				h2 = heightData._terrainHeightData[(nIndexZ + 1 - 1) * heightData._width + nIndexX];
				h3 = heightData._terrainHeightData[(nIndexZ - 1) * heightData._width + nIndexX + 1];
				u = (gridSize - offsetX) / gridSize;
				v = (gridSize - offsetZ) / gridSize;
				return h1 + (h2 - h1) * u + (h3 - h1) * v;
			}
			else
			{
				h1 = heightData._terrainHeightData[Math.max(0.0, nIndexZ - 1) * heightData._width + nIndexX];
				h2 = heightData._terrainHeightData[Math.min(heightData._width * heightData._height - 1, (nIndexZ + 1 - 1) * heightData._width + nIndexX)];
				h3 = heightData._terrainHeightData[Math.min(heightData._width * heightData._height - 1, Math.max(0.0, nIndexZ - 1) * heightData._width + nIndexX+1)];
				u = offsetX / gridSize;
				v = offsetZ / gridSize;
				return h1 + (h2 - h1) * v + (h3 - h1) * u;
			}
		}
	}
}