package {
	import laya.renders.Render;
	import laya.utils.Handler;
	
	/**
	 * ...
	 * @author yung
	 */
	public class AutoTest3 {
		private static var typeMap:Object = {"mousedown": 1, "mouseup": 2, "mousemove": 3, "keydown": 21, "keyup": 22, "keypress": 23, "mousewheel": 31};
		private static var idMap:Object;
		private static var list:Array = [];
		private static var startTime:int = 0;
		private static var index:int = 0;
		private static var canvas:*;
		private static var testName:String;
		private static var speed:Number = 1;
		
		public static function startRecord(canvasNode:* = null):void {
			if (!idMap) {
				idMap = {};
				for (var name:String in typeMap) {
					idMap[typeMap[name]] = name;
				}
			}
			
			canvas = canvasNode || Render.canvas;
			trace(canvas.width, canvas.height);
			try {
				testName = window.prompt("请输入测试名称", "test1");
			} catch (e:*) {
				testName = "test1";
			}
			if (testName) {
				startTime = now();
				list.length = 0;
				canvas.addEventListener("mousedown", addData);
				canvas.addEventListener("mouseup", addData);
				//canvas.addEventListener("mousemove", addData);
				canvas.addEventListener("mousewheel", addData);
				window.document.addEventListener("keydown", addData);
				window.document.addEventListener("keyup", addData);
				window.document.addEventListener("keypress", addData);
			}
		}
		
		private static function addData(e:*):void {
			trace(e);
			var time:int = now();
			var type:int = typeMap[e.type];
			
			if (type < 20) {//鼠标
				list.push(time - startTime, type, e.altKey ? 1 : 0, e.ctrlKey ? 1 : 0, e.shiftKey ? 1 : 0, e.clientX, e.clientY, e.button);
			} else if (type < 30) {//键盘
				list.push(time - startTime, type, e.altKey ? 1 : 0, e.ctrlKey ? 1 : 0, e.shiftKey ? 1 : 0, e.keyCode, e.location);
			} else {//滚轴
				list.push(time - startTime, type, e.altKey ? 1 : 0, e.ctrlKey ? 1 : 0, e.shiftKey ? 1 : 0, e.deltaY);
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
				var clientX:Number = list[++index];
				var clientY:Number = list[++index];
				var button:Number = list[++index];
				
				var event:* = new window.MouseEvent(typeStr, {
					altKey: altKey, 
					ctrlKey: ctrlKey, 
					shiftKey: shiftKey,
					clientX: clientX, 
					clientY: clientY, 
					button: button					
				});
				canvas.dispatchEvent(event);
			} else if(type < 30) {//键盘
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
				
				window.document.dispatchEvent(event);
			}else {//滚轴
				var deltaY:Number = list[++index];
				
				var event:* = new window.WheelEvent(typeStr, {
					altKey: altKey, 
					ctrlKey: ctrlKey, 
					shiftKey: shiftKey,
					deltaY: deltaY					
				});
				canvas.dispatchEvent(event);				
			}
			trace(event);
			
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
			canvas.removeEventListener("mousedown", addData);
			canvas.removeEventListener("mouseup", addData);
			canvas.removeEventListener("mousemove", addData);
			canvas.removeEventListener("mousewheel", addData);
			window.document.removeEventListener("keydown", addData);
			window.document.removeEventListener("keyup", addData);
			window.document.removeEventListener("keypress", addData);
			trace("record",list.length);
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