package laya.d3.terrain {
	import laya.d3.core.ComponentNode;
	import laya.d3.core.Sprite3D;
	import laya.d3.core.material.TerrainMaterial;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.terrain.unit.ChunkInfo;
	import laya.events.Event;
	import laya.net.Loader;
	
	/**
	 * <code>Terrain</code> 类用于创建地块。
	 */
	public class Terrain extends Sprite3D {
		public static var RENDER_LINE_MODEL:Boolean = false;
		public static var LOD_TOLERANCE_VALUE:Number = 4;
		public static var LOD_DISTANCE_FACTOR:Number = 2.0;
		public static var __VECTOR3__:Vector3;
		private var _terrainRes:TerrainRes = null;
		private var _lightmapScaleOffset:Vector4;
		
		public function set terrainRes(value:TerrainRes):void {
			if (value) {
				_terrainRes = value;
				if (value.loaded)
					buildTerrain(value);
				else
					value.once(Event.LOADED, this, buildTerrain);
			}
		}
		
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
		public function Terrain(terrainRes:TerrainRes = null) {
			_lightmapScaleOffset = new Vector4(1, 1, 0, 0);
			if (terrainRes) {
				_terrainRes = terrainRes;
				if (terrainRes.loaded)
					buildTerrain(terrainRes);
				else
					terrainRes.once(Event.LOADED, this, buildTerrain);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function _parseCustomProps(rootNode:ComponentNode, innerResouMap:Object, customProps:Object, json:Object):void {
			terrainRes = Loader.getRes(innerResouMap[customProps.dataPath]);
			
			var lightmapIndex:* = customProps.lightmapIndex;
			if (lightmapIndex != null)
				setLightmapIndex(lightmapIndex);
			
			var lightmapScaleOffsetArray:Array = customProps.lightmapScaleOffset;
			if (lightmapScaleOffsetArray)
				setLightmapScaleOffset(new Vector4(lightmapScaleOffsetArray[0], lightmapScaleOffsetArray[1], lightmapScaleOffsetArray[2], lightmapScaleOffsetArray[3]));
		}
		
		public function setLightmapIndex(value:int):void {
			for (var i:int = 0; i < _childs.length; i++) {
				var terrainChunk:TerrainChunk = _childs[i];
				terrainChunk.terrainRender.lightmapIndex = value;
			}
		}
		
		public function setLightmapScaleOffset(value:Vector4):void {
			if (!value) return;
			value.cloneTo(_lightmapScaleOffset);
			for (var i:int = 0; i < _childs.length; i++) {
				var terrainChunk:TerrainChunk = _childs[i];
				terrainChunk.terrainRender.lightmapScaleOffset = _lightmapScaleOffset;
			}
		}
		
		public function disableLight():void {
			for (var i:int = 0, n:int = _childs.length; i < n; i++) {
				var terrainChunk:TerrainChunk = _childs[i];
				for (var j:int = 0, m:int = terrainChunk._render.sharedMaterials.length; j < m; j++) {
					var terrainMaterial:TerrainMaterial = terrainChunk._render.sharedMaterials[j] as TerrainMaterial;
					terrainMaterial.disableLight();
				}
			}
		}
		
		public function buildTerrain(terrainRes:TerrainRes):void {
			var chunkNumX:int = terrainRes._chunkNumX;
			var chunkNumZ:int = terrainRes._chunkNumZ;
			var heightData:TerrainHeightData = terrainRes._heightData;
			var n:int = 0;
			for (var i:int = 0; i < chunkNumZ; i++) {
				for (var j:int = 0; j < chunkNumX; j++) {
					var terrainChunk:TerrainChunk = new TerrainChunk(j, i, terrainRes._gridSize, heightData._terrainHeightData, heightData._width, heightData._height, terrainRes._cameraCoordinateInverse);
					var chunkInfo:ChunkInfo = terrainRes._chunkInfos[n++];
					for (var k:int = 0; k < chunkInfo.alphaMap.length; k++) {
						var nNum:int = chunkInfo.detailID[k].length;
						var sDetialTextureUrl1:String = (nNum > 0) ? terrainRes._detailTextureInfos[chunkInfo.detailID[k][0]].diffuseTexture : null;
						var sDetialTextureUrl2:String = (nNum > 1) ? terrainRes._detailTextureInfos[chunkInfo.detailID[k][1]].diffuseTexture : null;
						var sDetialTextureUrl3:String = (nNum > 2) ? terrainRes._detailTextureInfos[chunkInfo.detailID[k][2]].diffuseTexture : null;
						var sDetialTextureUrl4:String = (nNum > 3) ? terrainRes._detailTextureInfos[chunkInfo.detailID[k][3]].diffuseTexture : null;
						
						var detialScale1:Vector2 = (nNum > 0) ? terrainRes._detailTextureInfos[chunkInfo.detailID[k][0]].scale : null;
						var detialScale2:Vector2 = (nNum > 1) ? terrainRes._detailTextureInfos[chunkInfo.detailID[k][1]].scale : null;
						var detialScale3:Vector2 = (nNum > 2) ? terrainRes._detailTextureInfos[chunkInfo.detailID[k][2]].scale : null;
						var detialScale4:Vector2 = (nNum > 3) ? terrainRes._detailTextureInfos[chunkInfo.detailID[k][3]].scale : null;
						terrainChunk.buildRenderElementAndMaterial(nNum, chunkInfo.normalMap, chunkInfo.alphaMap[k], sDetialTextureUrl1, sDetialTextureUrl2, sDetialTextureUrl3, sDetialTextureUrl4, terrainRes._materialInfo.ambientColor, terrainRes._materialInfo.diffuseColor, terrainRes._materialInfo.specularColor, detialScale1 ? detialScale1.x : 1, detialScale1 ? detialScale1.y : 1, detialScale2 ? detialScale2.x : 1, detialScale2 ? detialScale2.y : 1, detialScale3 ? detialScale3.x : 1, detialScale3 ? detialScale3.y : 1, detialScale4 ? detialScale4.x : 1, detialScale4 ? detialScale4.y : 1);
					}
					terrainChunk.terrainRender.receiveShadow = true;
					terrainChunk.terrainRender.lightmapScaleOffset = _lightmapScaleOffset;
					addChild(terrainChunk);
				}
			}
		}
		
		/**
		 * 获取地形X轴长度。
		 * @return  地形X轴长度。
		 */
		public function width():Number {
			return _terrainRes._chunkNumX * TerrainLeaf.CHUNK_GRID_NUM * _terrainRes._gridSize;
		}
		
		/**
		 * 获取地形Z轴长度。
		 * @return  地形Z轴长度。
		 */
		public function depth():Number {
			return _terrainRes._chunkNumZ * TerrainLeaf.CHUNK_GRID_NUM * _terrainRes._gridSize;
		}
		
		/**
		 * 获取地形高度。
		 * @param x X轴坐标。
		 * @param z Z轴坐标。
		 */
		public function getHeightXZ(x:Number, z:Number):Number {
			if (!_terrainRes || !_terrainRes.loaded)
				return NaN;
			
			x -= transform.position.x;
			z -= transform.position.z;
			
			if (!__VECTOR3__) {
				__VECTOR3__ = new Vector3();
				
			}
			__VECTOR3__.elements[0] = x;
			__VECTOR3__.elements[1] = 0;
			__VECTOR3__.elements[2] = z;
			
			Vector3.transformV3ToV3(__VECTOR3__, TerrainLeaf.__ADAPT_MATRIX_INV__, __VECTOR3__);
			
			x = __VECTOR3__.elements[0];
			z = __VECTOR3__.elements[2];
			
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
			
			if (offsetX + offsetZ > gridSize) {
				h1 = heightData._terrainHeightData[(nIndexZ + 1 - 1) * heightData._width + nIndexX + 1];
				h2 = heightData._terrainHeightData[(nIndexZ + 1 - 1) * heightData._width + nIndexX];
				h3 = heightData._terrainHeightData[(nIndexZ - 1) * heightData._width + nIndexX + 1];
				u = (gridSize - offsetX) / gridSize;
				v = (gridSize - offsetZ) / gridSize;
				return h1 + (h2 - h1) * u + (h3 - h1) * v;
			} else {
				h1 = heightData._terrainHeightData[Math.max(0.0, nIndexZ - 1) * heightData._width + nIndexX];
				h2 = heightData._terrainHeightData[Math.min(heightData._width * heightData._height - 1, (nIndexZ + 1 - 1) * heightData._width + nIndexX)];
				h3 = heightData._terrainHeightData[Math.min(heightData._width * heightData._height - 1, Math.max(0.0, nIndexZ - 1) * heightData._width + nIndexX + 1)];
				u = offsetX / gridSize;
				v = offsetZ / gridSize;
				return h1 + (h2 - h1) * v + (h3 - h1) * u;
			}
		}
	}
}