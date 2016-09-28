package
{
	import laya.display.Stage;
	import laya.ui.TextInput;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
     
    public class UI_Input
    {
		private const SPACING:int = 100;
		private const INPUT_WIDTH:int = 300;
		private const INPUT_HEIGHT:int = 50;
		private const Y_OFFSET:int = 50;
		private var skins:Array;
		
        public function UI_Input()
        {
			// 不支持WebGL时自动切换至Canvas
			Laya.init(800, 600, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
			
			skins = ["../../../../res/ui/input (1).png", "../../../../res/ui/input (2).png", "../../../../res/ui/input (3).png", "../../../../res/ui/input (4).png"];
            Laya.loader.load(skins, Handler.create(this, onLoadComplete));//加载资源。
        }
         
        private function onLoadComplete(e:*=null):void
        {
			for (var i:int = 0; i < skins.length;++i)
			{
				var input:TextInput = createInput(skins[i]);
				input.prompt = 'Type:';
				input.x = (Laya.stage.width - input.width) / 2;
				input.y = i * SPACING + Y_OFFSET;
			}
        }
		
		private function createInput(skin:String):TextInput
		{
			var ti:TextInput = new TextInput();
			
			ti.skin = skin;
			ti.size(300, 50);
			ti.sizeGrid = "0,40,0,40";
            ti.font = "Arial";
            ti.fontSize = 30;
            ti.bold = true;
			ti.color = "#606368";
			
			Laya.stage.addChild(ti);
			
			return ti;
		}
    }
}