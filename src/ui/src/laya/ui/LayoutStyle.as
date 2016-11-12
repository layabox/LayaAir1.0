package laya.ui {
	
	/**
	 * <code>LayoutStyle</code> 是一个布局样式类。
	 */
	public class LayoutStyle {
		
		/**一个已初始化的 <code>LayoutStyle</code> 实例。*/
		public static const EMPTY:LayoutStyle = new LayoutStyle();
		/**表示距顶边的距离（以像素为单位）。*/
		public var top:Number = NaN;
		/**表示距底边的距离（以像素为单位）。*/
		public var bottom:Number = NaN;
		/**表示距左边的距离（以像素为单位）。*/
		public var left:Number = NaN;
		/**表示距右边的距离（以像素为单位）。*/
		public var right:Number = NaN;
		/**表示距水平方向中心轴的距离（以像素为单位）。*/
		public var centerX:Number = NaN;
		/**表示距垂直方向中心轴的距离（以像素为单位）。*/
		public var centerY:Number = NaN;
		/**X锚点，值为0-1。*/
		public var anchorX:Number = NaN;
		/**Y锚点，值为0-1。*/
		public var anchorY:Number = NaN;
		/**一个布尔值，表示是否有效。*/
		public var enable:Boolean = false;
	}
}