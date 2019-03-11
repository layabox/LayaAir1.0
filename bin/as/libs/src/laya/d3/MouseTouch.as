package laya.d3 {
	import laya.d3.core.Sprite3D;
	import laya.resource.ISingletonElement;
	
	/**
	 * @private
	 */
	public class MouseTouch {
		/**@private */
		public var _pressedSprite:Sprite3D = null;
		/**@private */
		public var _pressedLoopCount:int = -1;
		/**@private */
		public var sprite:Sprite3D = null;
		/**@private */
		public var mousePositionX:int = 0;
		/**@private */
		public var mousePositionY:int = 0;
		
		public function MouseTouch() {
		
		}
	}

}