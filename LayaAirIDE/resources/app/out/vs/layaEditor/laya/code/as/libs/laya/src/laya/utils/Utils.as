package laya.utils {
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	
	/**
	 * <code>Utils</code> 是工具类。
	 */
	public class Utils {
		private static var _gid:int = 1;
		private static var _pi:Number = /*[STATIC SAFE]*/ 180 / Math.PI;
		private static var _pi2:Number = /*[STATIC SAFE]*/ Math.PI / 180;
		private static var _charSizeTestDiv:*;
		private static var _systemClass:* =/*[STATIC SAFE]*/ {'Sprite': 'laya.display.Sprite', 'Sprite3D': 'laya.d3.display.Sprite3D', 'Mesh': 'laya.d3.display.Mesh', 'Sky': 'laya.d3.display.Sky', 'div': 'laya.html.dom.HTMLDivElement', 'img': 'laya.html.dom.HTMLImageElement', 'span': 'laya.html.dom.HTMLElement', 'br': 'laya.html.dom.HTMLBrElement', 'style': 'laya.html.dom.HTMLStyleElement', 'font': 'laya.html.dom.HTMLElement', 'a': 'laya.html.dom.HTMLElement', '#text': 'laya.html.dom.HTMLElement'}
		public static var _attachAllClassTimeDelay:int = -1;
		
		/**
		 * 角度转弧度。
		 * @param	angle 角度值。
		 * @return	返回弧度值。
		 */
		public static function toRadian(angle:Number):Number {
			return angle * _pi2;
		}
		
		/**
		 * 弧度转换为角度。
		 * @param	radian 弧度值。
		 * @return	返回角度值。
		 */
		public static function toAngle(radian:Number):Number {
			return radian * _pi;
		}
		
		/**
		 * 将传入的 uint 类型颜色值转换为字符串型颜色值。
		 * @param color 颜色值。
		 * @return 字符串型颜色值。
		 */
		public static function toHexColor(color:Number):String {
			if (color < 0 || isNaN(color)) return null;
			var str:String = color.toString(16);
			while (str.length < 6) str = "0" + str;
			return "#" + str;
		}
		
		/**获取一个全局唯一ID。*/
		public static function getGID():int {
			return _gid++;
		}
		
		/**
		 * 将字符串解析成 XML 对象。
		 * @param value 需要解析的字符串。
		 * @return js原生的XML对象。
		 */
		public static function parseXMLFromString(value:String):XmlDom {
			var rst:*;
			__JS__("rst=(new DOMParser()).parseFromString(value,'text/xml')");
			return rst;
		}
		
		/**
		 * <p>根据传入的数字，和位数。返回此数字补齐至相应位数的字符串。</p>
		 * 例如num=1，len=3，会返回 "001";
		 * @param	num 数字。
		 * @param	strLen 需要补齐的总位数。
		 * @return	补齐后字符串。
		 */
		public static function preFixNumber(num:int, strLen:int):String {
			return ("0000000000" + num).slice(-strLen);
		}
		
		/**
		 * <p>连接数组。</p>
		 * <b>注意：</b>若 参数 a 不为空，则会改变参数 src 的值为连接后的数组。
		 * @param	src 待连接的数组对象。
		 * @param	a 待连接的数组对象。
		 * @return 连接后的数组。
		 */
		public static function concatArr(src:Array, a:Array):Array {
			if (!a) return src;
			if (!src) return a;
			var i:int, len:int = a.length;
			for (i = 0; i < len; i++) {
				src.push(a[i]);
			}
			return src;
		}
		
		/**
		 * 清空数组对象的长度。
		 * @param	arr 数组。
		 * @return 清空后的 arr 对象。
		 */
		public static function clearArr(arr:Array):Array {
			if (!arr) return arr;
			arr.length = 0;
			return arr;
		}
		
		/**
		 * 重设数组的值。
		 * @param	src 需要重设值的数组。
		 * @param	v 新的数组值。
		 * @return 重设值后的数据 src 。
		 */
		public static function setValueArr(src:Array, v:Array):Array {
			src || (src = []);
			src.length = 0;
			return concatArr(src, v);
		}
		
		/**
		 * 将数组 src 从索引0位置 依次取 cout 个项添加至 tst 数组的尾部。
		 * @param	rst 原始数组，用于添加新的子元素。
		 * @param	src 用于取子元素的数组。
		 * @param	count 需要取得子元素个数。
		 * @return 添加完子元素的 rst 对象。
		 */
		public static function getFrom(rst:Array, src:Array, count:int):Array {
			var i:int;
			for (i = 0; i < count; i++) {
				rst.push(src[i]);
			}
			return rst;
		}
		
		/**
		 * 将数组 src 从末尾索引位置往头部索引位置方向 依次取 cout 个项添加至 tst 数组的尾部。
		 * @param	rst 原始数组，用于添加新的子元素。
		 * @param	src 用于取子元素的数组。
		 * @param	count 需要取得子元素个数。
		 * @return 添加完子元素的 rst 对象。
		 */
		public static function getFromR(rst:Array, src:Array, count:int):Array {
			var i:int;
			for (i = 0; i < count; i++) {
				rst.push(src.pop());
			}
			return rst;
		}
		
		/**
		 * 计算 <code>Sprite</code> 对象在全局坐标系中的矩形显示区域。
		 * @param	sprite <code>Sprite</code>对象。
		 * @return  全局坐标系中的矩形显示区域对象 <code>Rectangle</code>。
		 */
		public static function getGlobalRec(sprite:Sprite):Rectangle {
			return getGlobalRecByPoints(sprite, 0, 0, sprite.width, sprite.height);
		}
		
		/**
		 * 根据传入的显示对象 <code>Sprite</code> 和此显示对象上的 两个点，返回此对象上的两个点在舞台坐标系上组成的最小的矩形区域对象。
		 * @param	sprite 显示对象 <code>Sprite</code>。
		 * @param	x0	点一的 X 轴坐标点。
		 * @param	y0	点一的 Y 轴坐标点。
		 * @param	x1	点二的 X 轴坐标点。
		 * @param	y1	点二的 Y 轴坐标点。
		 * @return 两个点在舞台坐标系组成的矩形对象 <code>Rectangle</code>。
		 */
		public static function getGlobalRecByPoints(sprite:Sprite, x0:Number, y0:Number, x1:Number, y1:Number):Rectangle {
			var newLTPoint:Point;
			newLTPoint = new Point(x0, y0);
			newLTPoint = sprite.localToGlobal(newLTPoint);
			var newRBPoint:Point;
			newRBPoint = new Point(x1, y1);
			newRBPoint = sprite.localToGlobal(newRBPoint);
			
			var rst:Rectangle;
			rst = Rectangle._getWrapRec([newLTPoint.x, newLTPoint.y, newRBPoint.x, newRBPoint.y]);
			return rst;
		}
		
		/**
		 * 计算传入的显示对象 <code>Sprite</code> 的全局坐标系的坐标和缩放值，返回 <code>Rectangle</code> 对象存放计算出的坐标X值、Y值、ScaleX值、ScaleY值。
		 * @param	sprite <code>Sprite</code> 对象。
		 * @return  矩形对象 <code>Rectangle</code>
		 */
		public static function getGlobalPosAndScale(sprite:Sprite):Rectangle {
			return getGlobalRecByPoints(sprite, 0, 0, 1, 1);
		}
		
		/**
		 * 将传入的 <code>Sprite</code> 对象加入显示列表。
		 * @param	dis <code>Sprite</code> 对象。
		 */
		public static function enableDisplayTree(dis:Sprite):void {
			while (dis) {
				dis.mouseEnabled = true;
				dis = dis.parent as Sprite;
			}
		}
		
		/**
		 * 给传入的函数绑定作用域，返回绑定后的函数。
		 * @param	fun 函数对象。
		 * @param	_scope 函数作用域。
		 * @return 绑定后的函数。
		 */
		public static function bind(fun:Function, _scope:*):Function {
			var rst:Function;
			__JS__("rst=fun.bind(_scope);");
			return rst;
		}
		
		/**
		 * 拷贝另一个对象的属性值。
		 * @param	src 待填充属性值的对象。
		 * @param	dec 被拷贝的对象。
		 * @param	permitOverrides 表示是否允许重写已有属性的值。
		 */
		public static function copyFunction(src:Object, dec:Object, permitOverrides:Boolean):void {
			for (var i:String in src) {
				if (!permitOverrides && dec[i]) continue;
				dec[i] = src[i];
			}
		}
		
		/**
		 * 测量文本在指定样式下的宽度、高度信息。
		 * @param	txt 文本内容。
		 * @param	font 文本字体样式。
		 * @return 文本的宽高信息对象。如：{width:xxx,height:xxx}
		 */
		public static function measureText(txt:String, font:String):* {
			if (_charSizeTestDiv == null) {
				_charSizeTestDiv = Browser.createElement('div');
				_charSizeTestDiv.style.cssText = "z-index:10000000;padding:0px;position: absolute;left:0px;visibility:hidden;top:0px;background:white";
				Browser.document.body.appendChild(_charSizeTestDiv);
			}
			_charSizeTestDiv.style.font = font;
			_charSizeTestDiv.innerText = txt == " " ? "i" : txt;
			var out:* = {width: _charSizeTestDiv.offsetWidth, height: _charSizeTestDiv.offsetHeight};
			//if (txt == ' ') out.width = out.height * 0.25;
			return out;
		}
		
		/**
		 * 根据传入的类别名和类的全路径，给全路径的类注册一个别名。
		 * @param	className 类的别名。
		 * @param	fullClassName 类的全路径。
		 */
		public static function regClass(className:String, fullClassName:String):void {
			_systemClass[className] = fullClassName;
		}
		
		/**
		 * 根据传入的类全路径字符，创建并返回此类的一个实例对象。
		 * @param	className 类全路径字符。
		 * @return 此类的一个实例对象。
		 */
		public static function New(className:String):* {
			className = _systemClass[className] || className;
			return __JS__("new Laya.__classmap[className]");
		}
		
		/**
		 * 对传入的数组列表，根据子项的属性 Z 值进行重新排序。返回是否已重新排序的 Boolean 值。
		 * @param	childs 子对象数组。
		 * @return Boolean 值，表示是否已重新排序。
		 */
		public static function updateOrder(childs:Array):Boolean {
			if (childs.length < 2) return false;
			
			var c:Sprite = childs[0];
			var i:int = 1, sz:int = childs.length;
			var z:Number = c._zOrder, low:Number, high:Number, mid:Number, zz:Number;
			var repaint:Boolean = false;
			
			for (i = 1; i < sz; i++) {
				c = childs[i] as Sprite;
				if (!c) continue;
				if ((z = c._zOrder) < 0) z = c._zOrder;
				if (z < childs[i - 1]._zOrder)//如果z小于前面，找到z>=的位置插入
				{
					mid = low = 0;
					high = i - 1;
					while (low <= high) {
						mid = (low + high) >>> 1;
						if (!childs[mid]) break;//这里有问题
						zz = childs[mid]._zOrder;
						if (zz < 0) zz = childs[mid]._zOrder;
						
						if (zz < z)
							low = mid + 1;
						else if (zz > z)
							high = mid - 1;
						else break;
					}
					if (z > childs[mid]._zOrder) mid++;
					childs.splice(i, 1);
					childs.splice(mid, 0, c);
					repaint = true;
				}
			}
			return repaint;
		}
		
		/**
		 * 检查所有类的函数的调用延时。
		 * @param	timeout 超时时间，单位为毫秒。
		 * @param	exclude 待排除检测的类路径数组。排除此数组里面类下所有函数。
		 */
		public static function attachAllClassTimeDelay(timeout:Number, exclude:Array):void {
			_attachAllClassTimeDelay = timeout;
			var __classmap:* = Laya["__classmap"];
			var excludes:Array = ((exclude ? exclude.join('%') : "") + "%Laya%laya.ui.%laya.utils.Log%laya2.display%laya.utils2%laya.asyn%laya.display.css%laya.maths%laya.utils").split("%");
			var j:int, excludelen:int = excludes.length;
			for (var i:String in __classmap) {
				if (i.indexOf('.') < 0) continue;
				for (j = 0; j < excludelen; j++) {
					if (i.indexOf(excludes[j]) == 0) {
						j = -1;
						break;
					}
				}
				if (j > 0) attachClassTimeDelay(__classmap[i], i, timeout);
			}
		}
		/**
		 * 批量操作点坐标。
		 * @param pList 坐标列表。
		 * @param x x轴偏移量。
		 * @param y y轴偏移量。
		 *
		 */
		public static function transPointList(pList:Array, x:Number, y:Number):void {
			var i:int, len:int = pList.length;
			for (i = 0; i < len; i += 2) {
				pList[i] += x;
				pList[i + 1] += y;
			}
		}
		/**
		 * 检测类的函数的调用延时。
		 * 如果函数执行超时，则打印超时的类、函数信息。
		 * @param	_class 待检测的类对象。
		 * @param	className 类名全路径。
		 * @param	timeout 超时时间，单位为毫秒。
		 */
		public static function attachClassTimeDelay(_class:*, className:String, timeout:Number):void {
			//[IF-SCRIPT-BEGIN]
			var i:String;
			var pre:*;
			for (i in _class) {
				if (_class['_$GET_' + i] != null || i.charAt(0) == '_') continue;
				pre = _class[i];
				if ((pre is Function)) {
					_class[i] = function(_class:*, className:String, protoName:String, pre:Function, timeout:Number):Function {
						return function():* {
							var tm:Number = Browser.now();
							var r:* = pre.apply(_class, arguments);
							if ((Browser.now() - tm) > timeout) Log.print("static prototype delay: " + className + "." + protoName + " " + (Browser.now() - tm));
							return r;
						}
					}(_class, className, i, pre, timeout);
				}
			}
			var __proto:* = _class.prototype;
			for (i in __proto) {
				if (__proto['_$get_' + i] != null || i.charAt(0) == '_') continue;
				
				pre = __proto[i];
				if ((pre is Function) && !pre.__ISCHECK) {
					//trace(className, i);
					pre.__ISCHECK = true;
					__proto[i] = function(_class:*, className:String, protoName:String, pre:Function, timeout:Number):Function {
						return function():* {
							var tm:Number = Browser.now();
							var r:* = pre.apply(this, arguments);
							if ((Browser.now() - tm) > timeout) Log.print("prototype delay:" + className + "." + protoName + " " + (Browser.now() - tm));
							return r;
						}
					}(_class, className, i, pre, timeout);
					__proto[i].__ISCHECK = true;
				}
			}
			//[IF-SCRIPT-END]
		}
	}
}