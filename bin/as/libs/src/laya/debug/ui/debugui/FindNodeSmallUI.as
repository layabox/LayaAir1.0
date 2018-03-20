/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     

	public class FindNodeSmallUI extends View {
		public var bg:Image;
		public var closeBtn:Button;
		public var title:Label;
		public var typeSelect:ComboBox;
		public var findTxt:TextInput;
		public var findBtn:Button;

		public static var uiView:Object ={"type":"View","child":[{"props":{"x":185,"y":234,"skin":"view/bg_tool.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg"},"type":"Image"},{"props":{"x":185,"y":15,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2},"type":"Button"},{"props":{"x":6,"y":4,"text":"查找对象","width":67,"height":20,"color":"#288edf","var":"title"},"type":"Label"},{"props":{"x":60,"y":81,"skin":"comp/combobox.png","labels":"name,class","width":63,"height":21,"var":"typeSelect","sizeGrid":"5,35,5,5","labelColors":"#a0a0a0,#fffff,#ffffff#fffff"},"type":"ComboBox"},{"props":{"x":27,"y":83,"text":"类型","width":27,"height":20,"color":"#288edf","align":"right"},"type":"Label"},{"props":{"x":7,"y":40,"text":"包含内容","width":47,"height":20,"color":"#288edf","align":"right"},"type":"Label"},{"props":{"x":60,"y":37,"skin":"comp/textinput.png","text":"Sprite","width":164,"height":22,"var":"findTxt","sizeGrid":"5,5,5,5","color":"#a0a0a0"},"type":"TextInput"},{"props":{"x":158,"y":79,"skin":"comp/button.png","label":"查找","width":65,"height":23,"var":"findBtn","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"},"type":"Button"}],"props":{"base64pic":true,"width":233,"height":120}};
		public function FindNodeSmallUI(){}
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