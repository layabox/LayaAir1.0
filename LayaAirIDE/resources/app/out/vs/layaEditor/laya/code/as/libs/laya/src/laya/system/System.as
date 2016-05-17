package laya.system {
	import laya.display.Graphics;
	import laya.display.Sprite;
	import laya.filters.ColorFilterAction;
	import laya.filters.IFilterAction;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.renders.RenderSprite;
	import laya.resource.HTMLCanvas;
	import laya.utils.RunDriver;
	
	/**
	 * @private
	 */
	public class System {
		/**
		 * 替换指定名称的定义。用来动态更改类的定义。
		 * @param	name 属性名。
		 * @param	classObj 属性值。
		 */
		public static function changeDefinition(name:String, classObj:*):void {
			Laya[name] = classObj;
			var str:String = name + "=classObj";
			__JS__("eval(str)");
		}
		
		/**
		 * @private
		 * 初始化。
		 */
		public static function __init__():void {
			Render.isConchApp = __JS__("window.conch ? true : false;");
			if (Render.isConchApp) {
				__JS__("conch.disableConchResManager()");
				__JS__("conch.disableConchAutoRestoreLostedDevice()");
			}
		}
	}
}