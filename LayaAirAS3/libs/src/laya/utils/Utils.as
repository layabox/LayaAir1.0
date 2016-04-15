package laya.utils {
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	
	/**
	 * 工具类
	 * @author yung
	 */
	public class Utils {
		private static var _gid:int = 1;
		private static var _pi:Number = /*[STATIC SAFE]*/ 180 / Math.PI;
		private static var _pi2:Number = /*[STATIC SAFE]*/ Math.PI / 180;
		
		/**
		 * 角度转弧度
		 * @param	angle 角度值
		 * @return	返回弧度值
		 */
		public static function toRadian(angle:Number):Number {
			return angle * _pi2;
		}
		
		/**
		 * 弧度转换为角度
		 * @param	radian 弧度值
		 * @return	返回角度值
		 */
		public static function toAngle(radian:Number):Number {
			return radian * _pi;
		}
		
		/**
		 * 转换uint类型颜色值为字符串。
		 * @param color 颜色值。
		 * @return
		 */
		public static function toHexColor(color:Number):String {
			if (color < 0 || isNaN(color)) return null;
			var str:String = color.toString(16);
			while (str.length < 6) str = "0" + str;
			return "#" + str;
		}
		
		/**获取全局唯一ID*/
		public static function getGID():int {
			return _gid++;
		}
		
		/**
		 * 将字符串解析成XML
		 * @param value 要解析的字符串
		 * @return js原生的XML对象
		 */
		public static function parseXMLFromString(value:String):XmlDom {
			var rst:*;
			__JS__("rst=(new DOMParser()).parseFromString(value,'text/xml')");
			return rst;
		}
		
		/**
		 * 补齐数字，比如num=1，len=3，会返回001
		 * @param	num 数字
		 * @param	strLen 要返回的字符串长度	
		 * @return	返回一个字符串
		 */
		public static function preFixNumber(num:int, strLen:int):String
		{
			return ("0000000000" + num).slice(-strLen);
		}
		
		public static function concatArr(src:Array, a:Array):Array {
			if (!a) return src;
			if (!src) return a;
			var i:int, len:int = a.length;
			for (i = 0; i < len; i++) {
				src.push(a[i]);
			}
			return src;
		}
		
		public static function clearArr(arr:Array):Array {
			if (!arr) return arr;
			arr.length = 0;
			return arr;
		}
		
		public static function setValueArr(src:Array, v:Array):Array {
			src || (src = []);
			src.length = 0;
			return concatArr(src, v);
		}
		
		public static function getFrom(rst:Array, src:Array, count:int):Array {
			var i:int;
			for (i = 0; i < count; i++) {
				rst.push(src[i]);
			}
			return rst;
		}
		
		public static function getFromR(rst:Array, src:Array, count:int):Array {
			var i:int;
			for (i = 0; i < count; i++) {
				rst.push(src.pop());
			}
			return rst;
		}
		
		public static function getGlobalRec(sprite:Sprite):Rectangle {
			return getGlobalRecByPoints(sprite, 0, 0, sprite.width, sprite.height);
		}
		
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
		
		public static function getGlobalPosAndScale(sprite:Sprite):Rectangle {
			return getGlobalRecByPoints(sprite, 0, 0, 1, 1);
		}
		
		public static function enableDisplayTree(dis:Sprite):void {			
			while (dis) {
				dis.mouseEnabled = true;
				dis = dis.parent as Sprite;
			}
		}
		
		public static function bind(fun:Function, _scope:*):Function {
			var rst:Function;
			__JS__("rst=fun.bind(_scope);");
			return rst;
		}
		
		public static function copyFunction(src:Object, dec:Object, permitOverrides:Boolean):void {
			for (var i:String in src) {
				if (!permitOverrides && dec[i]) continue;
				dec[i] = src[i];
			}
		}
		
		private static var _charSizeTestDiv:*;
		
		public static function measureText(txt:String, font:String):* {
			if (_charSizeTestDiv == null) {
				_charSizeTestDiv = Browser.createElement('div');
				_charSizeTestDiv.style.cssText = "z-index:10000000;padding:0px;position: absolute;left:0px;visibility:hidden;top:0px;background:white";
				Browser.document.body.appendChild(_charSizeTestDiv);
			}
			_charSizeTestDiv.style.font = font;
			_charSizeTestDiv.innerText = txt == " " ? "i" : txt;
			var out:* = {width: _charSizeTestDiv.offsetWidth, height: _charSizeTestDiv.offsetHeight};
			if (txt == ' ') out.width = out.height * 0.25;
			return out;
		}
		
		private static var _systemClass:* =/*[STATIC SAFE]*/ {'Sprite': 'laya.display.Sprite', 'Sprite3D': 'laya.d3.display.Sprite3D', 'Mesh': 'laya.d3.display.Mesh', 'Sky': 'laya.d3.display.Sky', 'div': 'laya.html.dom.HTMLDivElement', 'img': 'laya.html.dom.HTMLImageElement', 'span': 'laya.html.dom.HTMLElement', 'br': 'laya.html.dom.HTMLBrElement', 'style': 'laya.html.dom.HTMLStyleElement', 'font': 'laya.html.dom.HTMLElement','a': 'laya.html.dom.HTMLElement','#text':'laya.html.dom.HTMLElement'}
		
		public static function regClass(className:String, fullClassName:String):void {
			_systemClass[className] = fullClassName;
		}
		
		public static function New(className:String):* {
			className = _systemClass[className] || className;
			return __JS__("new Laya.__classmap[className]");
		}
		
		public static function updateOrder(childs:Array):Boolean {
			if (childs.length < 2) return false;
			
			var c:Sprite = childs[0];
			var i:int = 1,sz:int=childs.length;
			var z:Number = c._zOrder, low:Number, high:Number, mid:Number, zz:Number;
			var repaint:Boolean = false;
			
			for (i= 1; i < sz;i++ )
			{
				c = childs[i] as Sprite;
				if (!c) continue;
				if ( (z = c._zOrder) < 0) z = c._zOrder;
				if(z<childs[i-1]._zOrder)//如果z小于前面，找到z>=的位置插入
				{
					mid=low=0;
					high=i-1;
					while (low <= high) 
					{
						mid =(low + high)>>>1;
						if (!childs[mid]) break;//这里有问题
						zz = childs[mid]._zOrder;
						if (zz < 0) zz = childs[mid]._zOrder;
						
						if ( zz< z)
								low = mid + 1;
						else if (zz > z) 
								high = mid - 1;
						else	break;
					}
					if(z>childs[mid]._zOrder) mid++;
					childs.splice(i, 1);
					childs.splice(mid, 0, c);
					repaint = true;
				}
			}
			return repaint;
		}
		
		public static var _attachAllClassTimeDelay:int = -1;
		/**
		 * 检查函数的调用延时，
		 * @param	timeout:显示大于此值的函数调用
		 * @param	exclude:排除此数组里面类下所有函数
		 */
		public static function attachAllClassTimeDelay(timeout:Number,exclude:Array):void
		{
			_attachAllClassTimeDelay = timeout;
			var __classmap:*= Laya["__classmap"];
			var excludes:Array = ( (exclude?exclude.join('%'):"")+"%Laya%laya.ui.%laya.utils.Log%laya2.display%laya.utils2%laya.asyn%laya.display.css%laya.maths%laya.utils").split("%");
			var j:int,excludelen:int=excludes.length;
			for (var i:String in __classmap)
			{
				if (i.indexOf('.') < 0) continue;
				for (j = 0; j < excludelen; j++)
				{
					if (i.indexOf( excludes[j] ) == 0)
					{
						j = -1;
						break;
					}
				}
				if(j>0) attachClassTimeDelay(__classmap[i],i,timeout);
			}
		}
		
		public static function attachClassTimeDelay(_class:*,className:String,timeout:Number):void
		{
			//[IF-SCRIPT-BEGIN]
			var i:String;
			var pre:*;
			for (i in _class)
			{
				if (_class['_$GET_' + i] != null || i.charAt(0)=='_') continue;
				pre= _class[i];
				if ( (pre is Function))
				{
					_class[i]=function (_class:*, className:String,protoName:String,pre:Function,timeout:Number):Function
					{
						return function():*
						{
							var tm:Number = Browser.now();
							var r:*=pre.apply(_class, arguments);
							if ( (Browser.now() - tm) > timeout)  Log.print("static prototype delay: " +className+"."+protoName+" "+(Browser.now() - tm));
							return r;
						}
					}(_class,className,i,pre,timeout);
				}
			}
			var __proto:*= _class.prototype;
			for (i in __proto)
			{
				if (__proto['_$get_' + i] != null || i.charAt(0)=='_') continue;
				
				pre= __proto[i];
				if ( (pre is Function) && !pre.__ISCHECK)
				{
					//trace(className, i);
					pre.__ISCHECK=true;
					__proto[i]=function(_class:*, className:String,protoName:String,pre:Function,timeout:Number):Function
					{
						return function():*
						{
							var tm:Number = Browser.now();
							var r:*=pre.apply(this, arguments);
							if ( (Browser.now() - tm) > timeout)  Log.print("prototype delay:" +className+"." + protoName + " " + (Browser.now() - tm) );
							return r;
						}
					}(_class,className,i,pre,timeout);
					__proto[i].__ISCHECK=true;
				}
			}
			//[IF-SCRIPT-END]
		}
	}
}