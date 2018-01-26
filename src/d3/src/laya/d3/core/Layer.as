package laya.d3.core {
	import laya.d3.component.physics.Collider;
	import laya.d3.utils.Physics;
	
	/**
	 * <code>Layer</code> 类用于实现层。
	 */
	public class Layer {
		/** @private */
		private static var _layerList:Array = [];
		/** @private */
		private static var _visibleLayers:int = 2147483647/*int.MAX_VALUE*/;
		
		/** @private 只读,不允许修改。*/
		public static var _collsionTestList:Vector.<int> = new Vector.<int>();
		/** @private */
		public static var _currentCameraCullingMask:int = 2147483647/*int.MAX_VALUE*/;
		
		/** @private */
		public static const maxCount:int = 31;//JS中为动态位数，32或64还有符号位，所有暂时使用31
		/**当前创建精灵所属遮罩层。*/
		public static var currentCreationLayer:Layer;
		
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
			_visibleLayers = value;
			for (var i:int = 0, n:int = _layerList.length; i < n; i++) {
				var layer:Layer = _layerList[i];
				layer._visible = (layer._mask & _visibleLayers) !== 0;
			}
		}
		
		/**
		 * @private
		 */
		public static function __init__():void {
			_layerList.length = maxCount;
			for (var i:int = 0; i < maxCount; i++) {
				var layer:Layer = new Layer();
				_layerList[i] = layer;
				if (i === 0) {
					layer.name = "Default Layer";
					layer.visible = true;
				} else {
					layer.name = "Layer-" + i;
					layer.visible = false;
				}
				layer._number = i;
				layer._mask = Math.pow(2, i);
			}
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
		 * @param name 名字。
		 * @return 蒙版。
		 */
		public static function getLayerByName(name:String):Layer {
			for (var i:int = 0; i < maxCount; i++) {
				if (_layerList[i].name === name)
					return _layerList[i];
			}
			throw new Error("无法返回指定Layer,该name不存在");
		}
		
		/**
		 *通过蒙版值获取蒙版是否显示。
		 * @param mask 蒙版值。
		 * @return 是否显示。
		 */
		public static function isVisible(mask:int):Boolean {
			return (mask & _currentCameraCullingMask & _visibleLayers) != 0;
		}
		
		/** @private 编号。*/
		private var _number:int;
		/** @private 蒙版值。*/
		private var _mask:int;
		/** @private 是否显示。*/
		private var _visible:Boolean;
		
		/** @private 只读,不允许修改。*/
		public var _nonRigidbodyOffset:int;
		/** @private 只读,不允许修改。*/
		public var _colliders:Vector.<Collider>;
		
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
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			_visible = true;
			_nonRigidbodyOffset = 0;
			_colliders = new Vector.<Collider>();
		}
		
		/**
		 * @private
		 */
		private function _binarySearchIndex():int {
			var start:int = 0;
			var end:int = _collsionTestList.length - 1;
			var mid:int;
			while (start <= end) {
				mid = Math.floor((start + end) / 2);
				var midValue:int = _collsionTestList[mid];
				if (midValue == _number)
					return mid;
				else if (midValue > _number)
					end = mid - 1;
				else
					start = mid + 1;
			}
			return start;
		}
		
		/**
		 * @private
		 */
		public function _addCollider(collider:Collider):void {
			(_colliders.length === 0) && (_collsionTestList.splice(_binarySearchIndex(), 0, _number));
			if (collider._isRigidbody) {
				_colliders.unshift(collider);
				_nonRigidbodyOffset++;
			} else {
				_colliders.push(collider);
			}
		}
		
		/**
		 * @private
		 */
		public function _removeCollider(collider:Collider):void {
			var index:int = _colliders.indexOf(collider);
			if (index < _nonRigidbodyOffset)
				_nonRigidbodyOffset--;
			_colliders.splice(index, 1);
			(_colliders.length === 0) && (_collsionTestList.splice(_collsionTestList.indexOf(_number), 1));
		}
	}
}