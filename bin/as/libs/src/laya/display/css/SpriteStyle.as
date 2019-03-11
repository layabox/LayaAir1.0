package laya.display.css {
	import laya.maths.Rectangle;
	import laya.utils.Dragging;
	import laya.utils.Pool;
	
	/**
	 * @private
	 * 元素样式
	 */
	public class SpriteStyle {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const EMPTY:SpriteStyle =/*[STATIC SAFE]*/ new SpriteStyle();
		public var scaleX:Number;
		public var scaleY:Number;
		public var skewX:Number;
		public var skewY:Number;
		public var pivotX:Number;
		public var pivotY:Number;
		public var rotation:Number;
		public var alpha:Number;
		public var scrollRect:Rectangle;
		public var viewport:Rectangle;
		public var hitArea:*;
		public var dragging:Dragging;
		public var blendMode:String;
		
		public function SpriteStyle():void {
			reset();
		}
		
		/**
		 * 重置，方便下次复用
		 */
		public function reset():SpriteStyle {
			scaleX = scaleY = 1;
			skewX = skewY = 0;
			pivotX = pivotY = rotation = 0;
			alpha = 1;
			if(scrollRect) scrollRect.recover();
			scrollRect = null;
			if(viewport) viewport.recover();
			viewport = null;
			hitArea = null;
			dragging = null;
			blendMode = null;
			return this
		}
		
		/**
		 * 回收
		 */
		public function recover():void {
			if (this === EMPTY) return;
			Pool.recover("SpriteStyle", reset());
		}
		
		/**
		 * 从对象池中创建
		 */
		public static function create():SpriteStyle {
			return Pool.getItemByClass("SpriteStyle", SpriteStyle);
		}
	}
}