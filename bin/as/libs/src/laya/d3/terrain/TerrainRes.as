package laya.d3.terrain {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	import laya.d3.terrain.unit.ChunkInfo;
	import laya.d3.terrain.unit.DetailTextureInfo;
	import laya.events.Event;
	import laya.resource.Resource;
	
	/**
	 * <code>TerrainRes</code> 类用于描述地形信息。
	 */
	public class TerrainRes extends Resource {
		public var _version:Number;
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
		public function TerrainRes() 
		{	
			super();
		}
		
		public function parseData( data:*,path:String ):Boolean
		{
			var json:* = data;
			_version = json.version;
			if ( _version == 1.0 )
			{
				_gridSize = json.gridSize;
				_chunkNumX = json.chunkNumX;
				_chunkNumZ = json.chunkNumZ;
				var heightData:* = json.heightData;
				_heightDataX = heightData.numX;
				_heightDataZ = heightData.numZ;
				_heightDataBitType = heightData.bitType;
				_heightDataValue = heightData.value;
				_heightDataUrl = path + heightData.url;
				var detailTextures:* = json.detailTexture;
				_detailTextureInfos = new Vector.<DetailTextureInfo>( detailTextures.length );
				for ( var i:int = 0; i < detailTextures.length; i++ )
				{
					var detail:* = detailTextures[i];
					var info:DetailTextureInfo = new DetailTextureInfo();
					info.diffuseTexture = path + detail.diffuse;
					info.normalTexture = detail.normal ? path + detail.normal : null;
					if ( detail.scale )
					{
						info.scale = new Vector2( detail.scale[0],detail.scale[1] );
					}
					else
					{
						info.scale = new Vector2(1, 1);
					}
					if ( detail.offset )
					{
						info.offset = new Vector2( detail.offset[0],detail.offset[1] );
					}
					else
					{
						info.offset = new Vector2(0, 0);
					}
					_detailTextureInfos[i] = info;
				}
				
				var jchunks:* = json.chunkInfo;
				if ( _chunkNumX * _chunkNumZ != jchunks.length )
				{
					alert("terrain data error");
					return false;
				}
				_chunkInfos = new Vector.<ChunkInfo>( jchunks.length );
				for ( i = 0; i < jchunks.length; i++ )
				{
					var jchunk:* = jchunks[i];
					var chunkinfo:ChunkInfo = new ChunkInfo();
					var nAlphaMapNum:int = jchunk.alphaMap.length;
					var nDetailIDNum:int = jchunk.detailID.length;
					if ( nAlphaMapNum != nDetailIDNum )
					{
						alert("terrain chunk data error");
						return false;
					}
					chunkinfo.alphaMap = new Vector.<String>( nAlphaMapNum );
					chunkinfo.detailID = new Vector.<Uint8Array>( nDetailIDNum );
					chunkinfo.normalMap = path + jchunk.normalMap;
					for ( var j:int = 0; j < nAlphaMapNum; j++ )
					{
						chunkinfo.alphaMap[j] = path + jchunk.alphaMap[j];
						var jid:* = jchunk.detailID[j];
						var nIDNum:int = jid.length;
						chunkinfo.detailID[j] = new Uint8Array(nIDNum);
						for ( var k:int = 0; k < nIDNum; k++ )
						{
							chunkinfo.detailID[j][k] = jid[k];
						}
					}
					_chunkInfos[i] = chunkinfo;
				}
				_heightData = TerrainHeightData.load(_heightDataUrl, _heightDataX, _heightDataZ,_heightDataBitType,_heightDataValue );
				if (_heightData.loaded)
					onLoadTerrainComplete(_heightData);
				else
					_heightData.once(Event.LOADED, this, onLoadTerrainComplete);
			}
			return true;
		}
		public function onLoadTerrainComplete( heightData:TerrainHeightData ):void
		{
			_loaded = true;
			event(Event.LOADED, this);
		}
		/**
		 * 异步回调
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			var sBuffer:Array = url.split('/');
			var sPath:String="";
			for (var i:int = 0, n:int = sBuffer.length-1; i < n; i++ )
			{
				sPath += sBuffer[i];
				sPath += "/";
			}
			parseData(data,sPath);
		}
	}
}