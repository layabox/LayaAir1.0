package {
	import laya.display.Input;
	import laya.renders.Render;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author yung
	 */
	public class AutoTest2 {
		private static var typeMap:Object = {"mousedown": 1, "mouseup": 2, "mousemove": 3, "click": 4, "keydown": 21, "keyup": 22, "keypress": 23,"input":26, "mousewheel": 31};
		private static var idMap:Object;
		private static var list:Array = [];
		private static var startTime:int = 0;
		private static var index:int = 0;
		//private static var canvas:*;
		private static var testName:String;
		private static var speed:Number = 1;
		private static var clientX:Number;
		private static var clientY:Number;
		private static var input:*;
		public function AutoTest2() {
			startRecord();
		}
		
		public static function startRecord():void {
			if (!idMap) {
				idMap = {};
				for (var name:String in typeMap) {
					idMap[typeMap[name]] = name;
				}
			}
			
			//trace(canvas.width, canvas.height);
			try {
				testName = window.prompt("请输入测试名称", "test1");
			} catch (e:*) {
				testName = "test1";
			}
			if (testName) {
				trace("--------start record(" + testName + ")--------");
				startTime = now();
				list.length = 0;
				var doc:* = window.document;
				doc.addEventListener("mousedown", addData);
				doc.addEventListener("mouseup", addData);
				//doc.addEventListener("mousemove", addData);
				//doc.addEventListener("mousewheel", addData);
				//doc.addEventListener("keydown", addData);
				//doc.addEventListener("keyup", addData);
				//doc.addEventListener("keypress", addData);
			}
		}
		
		private static function addData(e:*):void {
			trace(e,e.target);
			var time:int = now();
			var type:int = typeMap[e.type];
			
			if (type < 20) {//鼠标				
				list.push(time - startTime, type, e.altKey ? 1 : 0, e.ctrlKey ? 1 : 0, e.shiftKey ? 1 : 0, e.clientX, e.clientY, e.button);
			
				if (type === typeMap.mouseup) {
					list.push(time - startTime, 4, e.altKey ? 1 : 0, e.ctrlKey ? 1 : 0, e.shiftKey ? 1 : 0, e.clientX, e.clientY, e.button);
				}
			} else if (type < 30) {//键盘
				if (type === typeMap.keyup && e.target is window.HTMLInputElement) {
					list.push(time - startTime, typeMap.input, e.altKey ? 1 : 0, e.ctrlKey ? 1 : 0, e.shiftKey ? 1 : 0, e.target.value);
					trace("save",e.target.value);
				}else {
					list.push(time - startTime, type, e.altKey ? 1 : 0, e.ctrlKey ? 1 : 0, e.shiftKey ? 1 : 0, e.keyCode, e.location);
				}
			} else {//滚轴
				list.push(time - startTime, type, e.altKey ? 1 : 0, e.ctrlKey ? 1 : 0, e.shiftKey ? 1 : 0, e.clientX, e.clientY, e.deltaY);
			}
			startTime = time;
		}
		
		private static function run():void {
			var type:int = list[++index];
			var typeStr:String = idMap[type];
			var altKey:Boolean = list[++index] ? true : false;
			var ctrlKey:Boolean = list[++index] ? true : false;
			var shiftKey:Boolean = list[++index] ? true : false;
			
			if (type < 20) {//鼠标
				clientX = list[++index];
				clientY = list[++index];
				var button:Number = list[++index];
				
				var event:* = new window.MouseEvent(typeStr, {
					altKey: altKey, 
					ctrlKey: ctrlKey, 
					shiftKey: shiftKey,
					clientX: clientX, 
					clientY: clientY, 
					button: button					
				});
			}else if (type === typeMap.input) {
				var value:Number = list[++index];
				var input:* = this.input || Input.inputElement;
				input.value = value;
				trace("show",value);
			}else if (type < 30) {//键盘				
				var keyCode:Number = list[++index];
				var location:Number = list[++index];
				
				var event:* = new window.KeyboardEvent(typeStr, {
					altKey: altKey, 
					ctrlKey: ctrlKey, 
					shiftKey: shiftKey,
					location: location,
					keyCode:keyCode
				});
				delete event.keyCode;  
				Object.defineProperty(event, "keyCode", { value:keyCode } ); 
			}else {//滚轴
				clientX = list[++index];
				clientY = list[++index];
				var deltaY:Number = list[++index];
				
				var event:* = new window.WheelEvent(typeStr, {
					altKey: altKey, 
					ctrlKey: ctrlKey, 
					shiftKey: shiftKey,
					deltaY: deltaY					
				});			
			}
			if (type !== typeMap.input) {
				var ele:* = window.document.elementFromPoint(clientX, clientY);
				ele.dispatchEvent(event);
				trace(event,ele);
				if (type === typeMap.mousedown && ele is window.HTMLInputElement) {
					input = ele;
				}
			}			
			
			if (index >= list.length - 1) {
				trace("--------stop test(" + testName + ")--------");
				return;
			}
			setTimeout(function():void {
				run();
			}, this.speed * list[++index]);
		}
		
		private static function now():int {
			return __JS__("Date.now();")
		}
		
		public static function stopRecord():void {
			var doc:* = window.document;
			doc.removeEventListener("mousedown", addData);
			doc.removeEventListener("mouseup", addData);
			doc.removeEventListener("mousemove", addData);
			doc.removeEventListener("mousewheel", addData);
			doc.removeEventListener("keydown", addData);
			doc.removeEventListener("keyup", addData);
			doc.removeEventListener("keypress", addData);
			trace("record", list.length);
		}
		
		public static function saveRecord():void {
			var blob:* = new window.Blob([JSON.stringify(list)], {type: "text/plain;charset=utf-8"});
			window.saveAs(blob, testName + ".json");
		}
		
		public static function replay(speed:int = 1):void {
			stopRecord();
			if (list.length > 1) {
				trace("--------play test(" + testName + ")--------");
				this.speed = 1 / speed;
				index = 0;
				setTimeout(function():void {
					run();
				}, this.speed * list[index]);
			}
		}
		
		public static function load(url:String):void {
			testName = url;
			Laya.loader.load(url, Handler.create(this, onLoaded), null, null, 1, false);
		}
		
		static private function onLoaded(json:Object):void {
			trace("--------loaded test(" + testName + ")--------");
			if (json) {
				list = json;
				replay();
			}
		}
	}
}