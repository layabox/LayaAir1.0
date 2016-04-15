package 
{
	import laya.display.Stage;
	import laya.ui.TextArea;
	import laya.utils.Handler;
    
	public class UI_TextArea
	{
		private var skin:String = "res/ui/textarea.png";
		
		public function UI_TextArea()
		{
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
            Laya.loader.load(skin, Handler.create(this, onLoadComplete));
        }
         
        private function onLoadComplete():void
        {
            var ta:TextArea = new TextArea("");
            ta.skin = skin;
			
			ta.inputElementXAdjuster = -2;
			ta.inputElementYAdjuster = -1;
            
            ta.font = "Arial";
            ta.fontSize = 20;
            ta.bold = true;
            
            ta.color = "#3d3d3d";
            
			ta.pos(100, 15);
            ta.size(375, 355);
            
            ta.padding = "70,8,8,8";
             
            Laya.stage.addChild(ta);
        }
	}
} 