package {
	import laya.display.Input;
	import laya.events.Event;
	import laya.net.Loader;
	import laya.utils.Handler;
	import laya.utils.Stat;
	import laya.webgl.WebGL;
	
	
	public class Main {
		
		public function Main() {
			//初始化引擎
			Laya.init(600, 1067, WebGL);
			Laya.stage.bgColor = "#ff0000";
			Stat.show();
			
			//设置适配模式
//			Laya.stage.scaleMode = "showall";
			Laya.stage.alignV = "center";
			Laya.stage.alignH = "center";
			
			//设置横竖屏
//			Laya.stage.screenMode = "none";
			
			
			var input:Input = new Input;
			input.text = "123456";
			input.color = "#ffffff";
			input.borderColor ="#fff000";
			input.editable = true;
			input.x = 174;
			input.y = 504;
			Laya.stage.addChild(input);
		}
	}
}
