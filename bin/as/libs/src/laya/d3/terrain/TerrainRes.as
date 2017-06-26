package laya.d3.terrain {
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.math.Vector4;
	import laya.d3.terrain.unit.ChunkInfo;
	import laya.d3.terrain.unit.DetailTextureInfo;
	import laya.d3.terrain.unit.MaterialInfo;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.resource.Resource;
	
	/**
	 * <code>TerrainRes</code> 类用于描述地形信息。
	 */
	public class TerrainRes extends Resource {
		public var _version:Number;
		public var _cameraCoordinateInverse:Boolean;
		public var _gridSize:Number;
		public var _chunkNumX:int;
		public var _chunkNumZ:int;
		public var _heightDataX:int;
		public var _heightDataZ:int;
		public var _heightDataBitType:int;
		public var _heightDataValue:Number;
		public var _heightDataUrl:String;
		public var _detailTextureInfos:Vector.<DetailTextureInfo>;
		public var _chunkInfos:Vector.<ChunkInfo>;
		public var _heightData:TerrainHeightData;
		public var _materialInfo:MaterialInfo;
		public var _alphaMaps:Vector.<String>;
		public var _normalMaps:Vector.<String>;
		
		/**
		 * 加载地形模板,注意:不缓存。
		 * @param url 模板地址。
		 */
		public static function load(url:String):TerrainRes {
			return Laya.loader.create(url, null, null, TerrainRes, null, 1, false);
		}
		
		/**
		 * 创建一个 <code>TerrainHeightData</code> 实例。
		 */
		public function TerrainRes() {
			super();
		}
		
		public function parseData(data:*):Boolean {
			var json:* = data[0];
			var resouMap:Object = data[1];
			_version = json.version;
			if (_version == 1.0) {
				_cameraCoordinateInverse = json.cameraCoordinateInverse;
				_gridSize = json.gridSize;
				_chunkNumX = json.chunkNumX;
				_chunkNumZ = json.chunkNumZ;
				var heightData:* = json.heightData;
				_heightDataX = heightData.numX;
				_heightDataZ = heightData.numZ;
				_heightDataBitType = heightData.bitType;
				_heightDataValue = heightData.value;
				_heightDataUrl = resouMap[heightData.url];
				_materialInfo = new MaterialInfo();
				if (json.material) {
					var ambient:* = json.material.ambient;
					var diffuse:* = json.material.diffuse;
					var specular:* = json.material.specular;
					_materialInfo.ambientColor = new Vector3(ambient[0], ambient[1], ambient[2]);
					_materialInfo.diffuseColor = new Vector3(diffuse[0], diffuse[1], diffuse[2]);
					_materialInfo.specularColor = new Vector4(specular[0], specular[1], specular[2], specular[3]);
				}
				var detailTextures:* = json.detailTexture;
				_detailTextureInfos = new Vector.<DetailTextureInfo>(detailTextures.length);
				for (var i:int = 0; i < detailTextures.length; i++) {
					var detail:* = detailTextures[i];
					var info:DetailTextureInfo = new DetailTextureInfo();
					info.diffuseTexture = resouMap[detail.diffuse];
					info.normalTexture = detail.normal ? resouMap[detail.normal] : null;
					if (detail.scale) {
						info.scale = new Vector2(detail.scale[0], detail.scale[1]);
					} else {
						info.scale = new Vector2(1, 1);
					}
					if (detail.offset) {
						info.offset = new Vector2(detail.offset[0], detail.offset[1]);
					} else {
						info.offset = new Vector2(0, 0);
					}
					_detailTextureInfos[i] = info;
				}
				var alphaMaps:* = json.alphaMap;
				_alphaMaps = new Vector.<String>(alphaMaps.length);
				for (i = 0; i < _alphaMaps.length; i++) {
					_alphaMaps[i] = json.alphaMap[i];
				}
				var normalMaps:* = json.normalMap;
				_normalMaps = new Vector.<String>(normalMaps.length);
				for (i = 0; i < _normalMaps.length; i++) {
					_normalMaps[i] = json.normalMap[i];
				}
				
				var jchunks:* = json.chunkInfo;
				if (_chunkNumX * _chunkNumZ != jchunks.length) {
					alert("terrain data error");
					return false;
				}
				_chunkInfos = new Vector.<ChunkInfo>(jchunks.length);
				for (i = 0; i < jchunks.length; i++) {
					var jchunk:* = jchunks[i];
					var chunkinfo:ChunkInfo = new ChunkInfo();
					var nAlphaMapNum:int = jchunk.alphaMap.length;
					var nDetailIDNum:int = jchunk.detailID.length;
					if (nAlphaMapNum != nDetailIDNum) {
						alert("terrain chunk data error");
						return false;
					}
					chunkinfo.alphaMap = new Vector.<String>(nAlphaMapNum);
					chunkinfo.detailID = new Vector.<Uint8Array>(nDetailIDNum);
					chunkinfo.normalMap = resouMap[_normalMaps[jchunk.normalMap]];
					for (var j:int = 0; j < nAlphaMapNum; j++) {
						chunkinfo.alphaMap[j] = resouMap[_alphaMaps[jchunk.alphaMap[j]]];
						var jid:* = jchunk.detailID[j];
						var nIDNum:int = jid.length;
						chunkinfo.detailID[j] = new Uint8Array(nIDNum);
						for (var k:int = 0; k < nIDNum; k++) {
							chunkinfo.detailID[j][k] = jid[k];
						}
					}
					_chunkInfos[i] = chunkinfo;
				}
				
				_heightData = Loader.getRes(_heightDataUrl);
				onLoadTerrainComplete(_heightData);
			}
			return true;
		}
		
		public function onLoadTerrainComplete(heightData:TerrainHeightData):void {
			_endLoaded();
		}
		
		/**
		 * 异步回调
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			parseData(data);
		}
	}
}