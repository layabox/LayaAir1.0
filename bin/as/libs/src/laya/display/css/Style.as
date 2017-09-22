package laya.display.css {
	import laya.display.Sprite;
	import laya.display.css.CSSStyle;
	import laya.maths.Rectangle;
	import laya.renders.RenderContext;
	
	/**
	 * @private
	 * <code>Style</code> 类是元素样式定义类。
	 */
	public class Style {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/** 一个默认样式 <code>Style</code> 对象。*/
		public static var EMPTY:Style;
		/**@private */
		protected static var _TF_EMPTY:TransformInfo;
		/**@private */
		public var _tf:TransformInfo = _TF_EMPTY;
		/**透明度。*/
		public var alpha:Number = 1;
		/**表示是否显示。*/
		public var visible:Boolean = true;
		/**表示滚动区域。*/
		public var scrollRect:Rectangle = null;
		/**混合模式。*/
		public var blendMode:String = null;
		/**@private */
		public var _type:int = 0;
		
		/**@private 初始化。*/
		public static function __init__():void {
			_TF_EMPTY = new TransformInfo();
			EMPTY = new Style();
		}
		
		/**@private */
		//protected static function _createTransform():Object {
		//return {translateX: 0, translateY: 0, scaleX: 1, scaleY: 1, rotate: 0, skewX: 0, skewY: 0};
		//}
		
		/**元素应用的 2D 或 3D 转换的值。该属性允许我们对元素进行旋转、缩放、移动或倾斜。*/
		public function get transform():Object {
			return getTransform();
		}
		
		public function set transform(value:*):void {
			setTransform(value);
		}
		
		public function getTransform():Object {
			return _tf;
		}
		
		public function setTransform(value:*):void {
			_tf = value === 'none' || !value ? _TF_EMPTY : value;
		}
		
		/**定义转换，只是用 X 轴的值。*/
		public function get translateX():Number {
			return _tf.translateX;
		}
		
		public function set translateX(value:Number):void {
			setTranslateX(value);
		}
		
		public function setTranslateX(value:Number):void {
			_tf === _TF_EMPTY && (_tf = new TransformInfo());
			_tf.translateX = value;
		}
		
		/**定义转换，只是用 Y 轴的值。*/
		public function get translateY():Number {
			return _tf.translateY;
		}
		
		public function set translateY(value:Number):void {
			setTranslateY(value);
		}
		
		public function setTranslateY(value:Number):void {
			_tf === _TF_EMPTY && (_tf = new TransformInfo());
			_tf.translateY = value;
		}
		
		/**X 轴缩放值。*/
		public function get scaleX():Number {
			return _tf.scaleX;
		}
		
		public function set scaleX(value:Number):void {
			setScaleX(value);
		}
		
		public function setScaleX(value:Number):void {
			_tf === _TF_EMPTY && (_tf = new TransformInfo());
			_tf.scaleX = value;
		}
		
		public function setScale(x:Number, y:Number):void {
			_tf === _TF_EMPTY && (_tf = new TransformInfo());
			_tf.scaleX = x;
			_tf.scaleY = y;
		}
		
		/**Y 轴缩放值。*/
		public function get scaleY():Number {
			return _tf.scaleY;
		}
		
		public function set scaleY(value:Number):void {
			setScaleY(value);
		}
		
		public function setScaleY(value:Number):void {
			_tf === _TF_EMPTY && (_tf = new TransformInfo());
			_tf.scaleY = value;
		}
		
		/**定义旋转角度。*/
		public function get rotate():Number {
			return _tf.rotate;
		}
		
		public function set rotate(value:Number):void {
			setRotate(value);
		}
		
		public function setRotate(value:Number):void {
			_tf === _TF_EMPTY && (_tf = new TransformInfo());
			_tf.rotate = value;
		}
		
		/**定义沿着 X 轴的 2D 倾斜转换。*/
		public function get skewX():Number {
			return _tf.skewX;
		}
		
		public function set skewX(value:Number):void {
			setSkewX(value);
		}
		
		public function setSkewX(value:Number):void {
			_tf === _TF_EMPTY && (_tf = new TransformInfo());
			_tf.skewX = value;
		}
		
		/**定义沿着 Y 轴的 2D 倾斜转换。*/
		public function get skewY():Number {
			return _tf.skewY;
		}
		
		public function set skewY(value:Number):void {
			setSkewY(value);
		}
		
		public function setSkewY(value:Number):void {
			_tf === _TF_EMPTY && (_tf = new TransformInfo());
			_tf.skewY = value;
		}
		
		/**表示元素是否显示为块级元素。*/
		public function get block():Boolean {
			return (_type & 0x1) != 0;
		}
		
		/**表示元素的左内边距。*/
		public function get paddingLeft():Number {
			return 0;
		}
		
		/**表示元素的上内边距。*/
		public function get paddingTop():Number {
			return 0;
		}
		
		/**是否为绝对定位。*/
		public function get absolute():Boolean {
			return true;
		}
		
		/**销毁此对象。*/
		public function destroy():void {
			scrollRect = null;
		}
		
		/** @private */
		public function render(sprite:Sprite, context:RenderContext, x:Number, y:Number):void {
		
		}
		
		/**@private */
		public function getCSSStyle():CSSStyle {
			return CSSStyle.EMPTY;
		}
		
		/**@private */
		public function _enableLayout():Boolean {
			return false;
		}
	}
}