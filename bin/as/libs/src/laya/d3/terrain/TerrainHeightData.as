package laya.d3.terrain {
	import laya.events.Event;
	import laya.resource.Resource;
	
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
		 * 加载地形高度模板,注意:不缓存。
		 * @param url 模板地址。
		 * @param width 高度图的宽。
		 * @param height 高度图的高。
		 */
		public static function load(url:String,widht:int,height:int,bitType:int,value:Number):TerrainHeightData {
			return Laya.loader.create(url, null, null, TerrainHeightData, [widht,height,bitType,value], 1, false);
		}
		/**
		 * 创建一个 <code>TerrainHeightData</code> 实例。
		 */
		public function TerrainHeightData() 
		{	
			super();
		}
		/**
		 * 异步回调
		 */
		override public function onAsynLoaded(url:String, data:*, params:Array):void {
			_width = params[0];
			_height = params[1];
			_bitType = params[2];
			_value = params[3];
			var buffer:*;
			var ratio:Number;
			if ( _bitType == 8 )
			{
				buffer = new Uint8Array(data);
				ratio = 1.0 / 255.0;
			}
			else if ( _bitType == 16 )
			{
				buffer = new Int16Array(data);
				ratio = 1.0 / 32766.0;
			}
			_terrainHeightData = new Float32Array(_height * _width);
			for ( var i:int = 0, n:int = _height * _width; i < n; i++ )
			{
				_terrainHeightData[i] = (buffer[i] * ratio * _value)/2;
			}
			_endLoaded();
		}
	}
}