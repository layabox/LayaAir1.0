package laya.ui {
	import laya.display.Sprite;
	import laya.filters.ColorFilter;
	import laya.filters.IFilter;
	import laya.utils.Utils;
	
	/**
	 * <code>UIUtils</code> 是文本工具集。
	 */
	public class UIUtils {
		private static const grayFilter:ColorFilter = new ColorFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);
		
		/**
		 * 用字符串填充数组，并返回数组副本。
		 * @param	arr 源数组对象。
		 * @param	str 用逗号连接的字符串。如"p1,p2,p3,p4"。
		 * @param	type 如果值不为null，则填充的是新增值得类型。
		 * @return 填充后的数组。
		 */
		public static function fillArray(arr:Array, str:String, type:Class = null):Array {
			var temp:Array = arr.concat();
			if (str) {
				var a:Array = str.split(",");
				for (var i:int = 0, n:int = Math.min(temp.length, a.length); i < n; i++) {
					var value:String = a[i];
					temp[i] = (value == "true" ? true : (value == "false" ? false : value));
					if (type != null) temp[i] = type(value);
				}
			}
			return temp;
		}
		
		/**
		 * 转换uint类型颜色值为字符型颜色值。
		 * @param color uint颜色值。
		 * @return 字符型颜色值。
		 */
		public static function toColor(color:uint):String {
			return Utils.toHexColor(color);
		}
		
		/**
		 * 给指定的目标显示对象添加或移除灰度滤镜。
		 * @param	traget 目标显示对象。
		 * @param	isGray 如果值true，则添加灰度滤镜，否则移除灰度滤镜。
		 */
		public static function gray(traget:Sprite, isGray:Boolean = true):void {
			if (isGray) {
				addFilter(traget, grayFilter);
			} else {
				clearFilter(traget, ColorFilter);
			}
		}
		
		/**
		 * 给指定的目标显示对象添加滤镜。
		 * @param	target 目标显示对象。
		 * @param	filter 滤镜对象。
		 */
		public static function addFilter(target:Sprite, filter:IFilter):void {
			var filters:Array = target.filters || [];
			filters.push(filter);
			target.filters = filters;
		}
		
		/**
		 * 移除目标显示对象的指定类型滤镜。
		 * @param	target 目标显示对象。
		 * @param	filterType 滤镜类型。
		 */
		public static function clearFilter(target:Sprite, filterType:Class):void {
			var filters:Array = target.filters;
			if (filters != null && filters.length > 0) {
				for (var i:int = filters.length - 1; i > -1; i--) {
					var filter:* = filters[i];
					if (filter is filterType) filters.splice(i, 1);
				}
				target.filters = filters;
			}
		}
	}
}