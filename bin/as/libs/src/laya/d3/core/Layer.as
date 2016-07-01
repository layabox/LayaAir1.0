package laya.d3.core {
	
	/**
	 * <code>Layer</code> 类用于实现遮罩层。
	 */
	public class Layer {
		/**唯一标识ID计数器。*/
		protected static var _uniqueIDCounter:int = 1/*int.MIN_VALUE*/;
		/**Layer数量。*/
		protected static const _layerCount:int = 31;//JavaScript中为动态位数，32或64还有符号位，所有暂时使用31
		/**Layer列表。*/
		protected static var _layerList:Array = [];
		/**Layer激活层。*/
		protected static var _activeLayers:int;
		/**Layer显示层。*/
		protected static var _visibleLayers:int;
		
		/**当前相机遮罩。*/
		public static var _currentCameraCullingMask:int;
		
		/**当前创建精灵所属遮罩层。*/
		public static var currentCreationLayer:Layer;
		
		/**
		 *获取Layer激活层。
		 * @return 激活层。
		 */
		public static function get activeLayers():int {
			return _activeLayers;
		}
		
		/**
		 * 设置Layer激活层。
		 * @param value 激活层。
		 */
		public static function set activeLayers(value:int):void {
			//29和30为预留蒙版层,不能禁用
			_activeLayers = value | getLayerByNumber(29).mask | getLayerByNumber(30).mask;
			for (var i:int = 0; i < _layerList.length; i++) {
				var layer:Layer = _layerList[i];
				layer._active = (layer._mask & _activeLayers) !== 0;
			}
		}
		
		/**
		 *获取Layer显示层。
		 * @return 显示层。
		 */
		public static function get visibleLayers():int {
			return _visibleLayers;
		}
		
		/**
		 *设置Layer显示层。
		 * @param value 显示层。
		 */
		public static function set visibleLayers(value:int):void {
			//29和30为预留蒙版层,不能禁用
			_visibleLayers = value | getLayerByNumber(29).mask | getLayerByNumber(30).mask;
			for (var i:int = 0; i < _layerList.length; i++) {
				var layer:Layer = _layerList[i];
				layer._visible = (layer._mask & _visibleLayers) !== 0;
			}
		}
		
		/**
		 * @private
		 */
		public static function __init__():void {
			_layerList.length = _layerCount;
			for (var i:int = 0; i < _layerCount; i++) {
				var layer:Layer = new Layer();
				_layerList[i] = layer;
				if (i === 0)
					layer.name = "Default Layer";
				else if (i === 29)
					layer.name = "Reserved Layer0";
				else if (i === 30)
					layer.name = "Reserved Layer1";
				else
					layer.name = "Layer-" + i;
				layer._number = i;
				layer._mask = Math.pow(2, i);//Number转int
			}
			_activeLayers = 2147483647/*int.MAX_VALUE*/;
			_visibleLayers = 2147483647/*int.MAX_VALUE*/;
			_currentCameraCullingMask = 2147483647/*int.MAX_VALUE*/;
			currentCreationLayer = _layerList[0];
		}
		
		/**
		 *通过编号获取蒙版。
		 * @param number 编号。
		 * @return 蒙版。
		 */
		public static function getLayerByNumber(number:int):Layer {
			if (number < 0 || number > 30)
				throw new Error("无法返回指定Layer，该number超出范围！");
			return _layerList[number];
		}
		
		/**
		 *通过蒙版值获取蒙版。
		 * @param mask 编号。
		 * @return 蒙版。
		 */
		public static function getLayerByMask(mask:int):Layer {
			//var index=Math.log(mask)/Math.log(2)//Best  Fast,但是存在浮点精度问题，无法良好切科学的解决
			for (var i:int = 0; i < _layerCount; i++) {
				if (_layerList[i].mask === mask)
					return _layerList[i];
			}
			throw new Error("无法返回指定Layer,该mask不存在");
		}
		
		/**
		 *通过蒙版值获取蒙版。
		 * @param name 名字。
		 * @return 蒙版。
		 */
		public static function getLayerByName(name:String):Layer {
			for (var i:int = 0; i < _layerCount; i++) {
				if (_layerList[i].name === name)
					return _layerList[i];
			}
			throw new Error("无法返回指定Layer,该name不存在");
		}
		
		/**
		 *通过蒙版值获取蒙版是否激活。
		 * @param mask 蒙版值。
		 * @return 是否激活。
		 */
		public static function isActive(mask:int):Boolean {
			return (mask & _activeLayers) != 0;
		}
		
		/**
		 *通过蒙版值获取蒙版是否显示。
		 * @param mask 蒙版值。
		 * @return 是否显示。
		 */
		public static function isVisible(mask:int):Boolean {
			return (mask & _currentCameraCullingMask & _visibleLayers) != 0;
		}
		
		/**唯一标识ID。*/
		protected var _id:int;
		/**编号。*/
		protected var _number:int;
		/**蒙版值。*/
		protected var _mask:int;
		/**是否激活。*/
		protected var _active:Boolean = true;
		/**是否显示。*/
		protected var _visible:Boolean = true;
		
		/**名字。*/
		public var name:String;
		
		/**
		 *获取编号。
		 * @return 编号。
		 */
		public function get number():int {
			return _number;
		}
		
		/**
		 *获取蒙版值。
		 * @return 蒙版值。
		 */
		public function get mask():int {
			return _mask;
		}
		
		/**
		 *获取是否激活。
		 * @return 是否激活。
		 */
		public function get active():Boolean {
			return _active;
		}
		
		/**
		 *设置是否激活。
		 * @param value 是否激活。
		 */
		public function set active(value:Boolean):void {
			//29和30为预留蒙版层,不能禁用
			if (_number === 29 || _number == 30)
				return;
			_active = value;
			
			if (value)
				_activeLayers = _activeLayers | mask;
			else
				_activeLayers = _activeLayers & ~mask;
		}
		
		/**
		 *获取是否显示。
		 * @return 是否显示。
		 */
		public function get visible():Boolean {
			return _visible;
		}
		
		/**
		 *设置是否显示。
		 * @param value 是否显示。
		 */
		public function set visible(value:Boolean):void {
			//29和30为预留蒙版层,不能禁用
			if (_number === 29 || _number == 30)
				return;
			_visible = value;
			
			if (value)
				_visibleLayers = _visibleLayers | mask;
			else
				_visibleLayers = _visibleLayers & ~mask;
		}
		
		/**
		 * 创建一个 <code>Layer</code> 实例。
		 */
		public function Layer() {
			//由于AS3中无私有构造函数声明，只能在new时进行异常检测
			_id = _uniqueIDCounter;
			_uniqueIDCounter++;
			if (_id > 1/*int.MIN_VALUE*/ + _layerCount)
				throw new Error("不允许创建Layer，请参考函数getLayerByNumber、getLayerByMask、getLayerByName！");
		}
	
	}
}