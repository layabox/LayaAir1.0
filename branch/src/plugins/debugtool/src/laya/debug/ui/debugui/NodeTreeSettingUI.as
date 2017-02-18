/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     

	public class NodeTreeSettingUI extends View {
		public var bg:Image;
		public var showTxt:TextInput;
		public var okBtn:Button;
		public var closeBtn:Button;

		public static var uiView:Object ={"type":"View","child":[{"props":{"x":0,"y":0,"skin":"view/bg_panel.png","left":0,"top":0,"bottom":0,"right":0,"var":"bg","width":200,"height":300,"sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":9,"y":7,"text":"要显示的属性","width":76,"height":16,"color":"#ffffff","align":"left"},"type":"Label"},{"props":{"x":6,"y":29,"skin":"comp/textinput.png","text":"x\\ny\\nwidth\\nheight","width":188,"height":230,"multiline":true,"var":"showTxt","color":"#a0a0a0","sizeGrid":"5,5,5,5"},"type":"TextInput"},{"props":{"x":57,"y":269,"skin":"comp/button.png","label":"确定","var":"okBtn","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"},"type":"Button"},{"props":{"x":175,"y":5,"skin":"view/btn_close.png","var":"closeBtn"},"type":"Button"}],"props":{"base64pic":true,"width":200,"height":300}};
		public function NodeTreeSettingUI(){}
		override protected function createChildren():void {
		  viewMapRegists();
			super.createChildren();
			createView(uiView);
		}
		protected function viewMapRegists():void
		{

		}
	}
}