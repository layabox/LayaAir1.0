/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     
	import laya.debug.uicomps.RankListItem;

	public class FindNodeUI extends View {
		public var bg:Image;
		public var closeBtn:Button;
		public var title:Label;
		public var typeSelect:ComboBox;
		public var findTxt:TextInput;
		public var result:List;
		public var findBtn:Button;

		public static var uiView:Object ={"type":"View","child":[{"props":{"x":185,"y":234,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":185,"y":15,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2},"type":"Button"},{"props":{"x":6,"y":4,"text":"查找对象","width":67,"height":20,"color":"#88ef19","var":"title"},"type":"Label"},{"props":{"x":52,"y":75,"skin":"comp/combobox.png","labels":"name,class","width":63,"height":21,"var":"typeSelect","sizeGrid":"5,35,5,5","labelColors":"#a0a0a0,#fffff,#ffffff#fffff"},"type":"ComboBox"},{"props":{"x":10,"y":77,"text":"类型","width":27,"height":20,"color":"#88ef19","align":"right"},"type":"Label"},{"props":{"x":7,"y":34,"text":"包含内容","width":47,"height":20,"color":"#88ef19","align":"right"},"type":"Label"},{"props":{"x":59,"y":31,"skin":"comp/textinput.png","text":"Sprite","width":131,"height":22,"var":"findTxt","sizeGrid":"5,5,5,5","color":"#a0a0a0"},"type":"TextInput"},{"type":"List","child":[{"type":"RankListItem","props":{"y":30,"left":5,"right":5,"name":"render","x":30,"runtime":"laya.debug.uicomps.RankListItem"}}],"props":{"x":6,"y":106,"width":188,"height":180,"vScrollBarSkin":"comp/vscroll.png","var":"result"}},{"props":{"x":125,"y":73,"skin":"comp/button.png","label":"查找","width":65,"height":23,"var":"findBtn","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"},"type":"Button"}],"props":{"width":200,"height":300,"base64pic":true}};
		public function FindNodeUI(){}
		override protected function createChildren():void {
		  viewMapRegists();
			super.createChildren();
			createView(uiView);
		}
		protected function viewMapRegists():void
		{
			View.regComponent("laya.debug.uicomps.RankListItem",RankListItem);

		}
	}
}