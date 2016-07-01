package 
{
	import laya.display.Stage;
	import laya.ui.TextArea;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.webgl.WebGL;
    
	public class UI_TextArea
	{
		private var skin:String = "res/ui/textarea.png";
		
		public function UI_TextArea()
		{
			// 不支持WebGL时自动切换至Canvas
			Laya.init(550, 400, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";

			
            Laya.loader.load(skin, Handler.create(this, onLoadComplete));
        }
        
        private function onLoadComplete(e:*=null):void
        {
            var ta:TextArea = new TextArea("");
            ta.skin = skin;
			
			ta.inputElementXAdjuster = -2;
			ta.inputElementYAdjuster = -1;
            
            ta.font = "Arial";
            ta.fontSize = 18;
            ta.bold = true;
            
            ta.color = "#3d3d3d";
            
			ta.pos(100, 15);
            ta.size(375, 355);
            
            ta.padding = "70,8,8,8";
            
			var scaleFactor:Number = Browser.pixelRatio;
			
            Laya.stage.addChild(ta);
        }
	}
} 