package laya.d3 {
	import laya.d3.core.Sprite3D;
	import laya.d3.math.Vector2;
	import laya.resource.ISingletonElement;
	
	/**
	 * <code>Touch</code> 类用于实现触摸描述。
	 */
	public class Touch implements ISingletonElement {
		/** @private  [实现IListPool接口]*/
		private var _indexInList:int = -1;
		
		/** @private */
		public var _identifier:int = -1;
		/** @private */
		public var _position:Vector2 = new Vector2();
		
		/**
		 * 获取唯一识别ID。
		 * @return 唯一识别ID。
		 */
		public function get identifier():int {
			return _identifier;
		}
		
		/**
		 * 获取触摸点的像素坐标。
		 * @return 触摸点的像素坐标 [只读]。
		 */
		public function get position():Vector2 {
			return _position;
		}
		
		/**
		 * @private
		 * 创建一个 <code>Touch</code> 实例。
		 */
		public function Touch() {
		}
		
		/**
		 * @private [实现ISingletonElement接口]
		 */
		public function _getIndexInList():int {
			return _indexInList;
		}
		
		/**
		 * @private [实现ISingletonElement接口]
		 */
		public function _setIndexInList(index:int):void {
			_indexInList = index;
		}
	
	}

}