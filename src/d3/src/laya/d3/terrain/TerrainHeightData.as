package laya.d3.terrain {
	import laya.events.Event;
	import laya.resource.Resource;
	import laya.utils.Handler;
	
	/**
	 * <code>TerrainHeightData</code> 类用于描述地形高度信息。
	 */
	public class TerrainHeightData extends Resource {
		
		public var _terrainHeightData:Float32Array;
		public var _width:int;
		public var _height:int;
		public var _bitType:int;
		public var _value:Number;
		
		/**
		 * 异步回调
		 */
		public static function _pharse(data:*, propertyParams:Object = null, constructParams:Array = null):void {
			var terrainHeightData:TerrainHeightData = new TerrainHeightData(constructParams[0],constructParams[1],constructParams[2],constructParams[3]);
			var buffer:*;
			var ratio:Number;
			if (terrainHeightData._bitType == 8) {
				buffer = new Uint8Array(data);
				ratio = 1.0 / 255.0;
			} else if (terrainHeightData._bitType == 16) {
				buffer = new Int16Array(data);
				ratio = 1.0 / 32766.0;
			}
			terrainHeightData._terrainHeightData = new Float32Array(terrainHeightData._height * terrainHeightData._width);
			for (var i:int = 0, n:int = terrainHeightData._height * terrainHeightData._width; i < n; i++) {
				terrainHeightData._terrainHeightData[i] = (buffer[i] * ratio * terrainHeightData._value) / 2;
			}
		}
		
		/**
		 * 加载地形高度模板,注意:不缓存。
		 * @param url 模板地址。
		 * @param width 高度图的宽。
		 * @param height 高度图的高。
		 */
		public static function load(url:String,complete:Handler, widht:int, height:int, bitType:int, value:Number):void {
			 Laya.loader.create(url, complete, null, Laya3D.TERRAINHEIGHTDATA, [widht, height, bitType, value],null, 1, false);
		}
		
		/**
		 * 创建一个 <code>TerrainHeightData</code> 实例。
		 */
		public function TerrainHeightData(width:int,height:int,bitType:int,value:Number) {
			super();
			_width = width;
			_height = height;
			_bitType = bitType;
			_value = value;
		}
		

	}
}