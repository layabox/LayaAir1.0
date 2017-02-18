package laya.ui {
	import laya.events.Event;
	
	/**
	 * <code>UIEvent</code> 类用来定义UI组件类的事件类型。
	 */
	public class UIEvent extends Event {
		/**
		 * 显示提示信息。
		 */
		public static const SHOW_TIP:String = "showtip";
		/**
		 * 隐藏提示信息。
		 */
		public static const HIDE_TIP:String = "hidetip";
	}
}