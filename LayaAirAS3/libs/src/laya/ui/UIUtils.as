package laya.ui {
	import laya.display.Sprite;
	import laya.filters.ColorFilter;
	import laya.filters.IFilter;
	
	/**
	 * 文本工具集。
	 * @author yung
	 */
	public class UIUtils {
		private static const grayFilter:ColorFilter = new ColorFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0]);
		
		/**
		 * 用字符串填充数组，并返回数组副本。
		 * @param arr
		 * @param str
		 * @param type
		 * @return 
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
		 * 转换uint类型颜色值为字符串。
		 * @param color uint颜色值。
		 * @return 
		 */		
		public static function toColor(color:uint):String {
			var str:String = color.toString("16");
			while (str.length < 6) str = "0"+str;
			return "#" + str;
		}
		
		
		/**让显示对象变成灰色*/
		public static function gray(traget:Sprite, isGray:Boolean = true):void {
			if (isGray) {
				addFilter(traget, grayFilter);
			} else {
				clearFilter(traget, ColorFilter);
			}
		}
		
		/**添加滤镜*/
		public static function addFilter(target:Sprite, filter:IFilter):void {
			var filters:Array = target.filters || [];
			filters.push(filter);
			target.filters = filters;
		}
		
		/**清除滤镜*/
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