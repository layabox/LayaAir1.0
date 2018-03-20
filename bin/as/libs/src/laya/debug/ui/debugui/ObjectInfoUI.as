/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     

	public class ObjectInfoUI extends View {
		public var bg:Image;
		public var title:Label;
		public var showTxt:TextArea;
		public var closeBtn:Button;
		public var autoUpdate:CheckBox;
		public var settingBtn:Button;

		public static var uiView:Object ={"type":"View","child":[{"props":{"x":-1,"y":0,"skin":"view/bg_panel.png","left":-1,"right":1,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":7,"y":5,"text":"对象类型","width":67,"height":20,"color":"#ffffff","var":"title","left":7,"right":6},"type":"Label"},{"props":{"x":2,"skin":"comp/textinput.png","text":"属性内容","width":196,"height":228,"left":2,"right":2,"var":"showTxt","top":25,"bottom":20,"editable":false,"multiline":true,"sizeGrid":"5,5,5,5","color":"#a0a0a0"},"type":"TextArea"},{"props":{"x":178,"y":4,"skin":"view/btn_close.png","var":"closeBtn","top":4,"right":2},"type":"Button"},{"props":{"skin":"comp/checkbox.png","label":"自动刷新属性","var":"autoUpdate","bottom":2,"x":3,"labelColors":"#a0a0a0,#fffff,#ffffff,#fffff"},"type":"CheckBox"},{"props":{"x":164,"skin":"view/setting.png","stateNum":"3","var":"settingBtn","y":6,"top":6,"right":24,"toolTip":"设置显示属性"},"type":"Button"},{"props":{"x":179,"y":257,"skin":"view/resize.png","right":2,"bottom":2,"name":"resizeBtn","stateNum":3},"type":"Button"}],"props":{"base64pic":true,"width":200,"height":200}};
		public function ObjectInfoUI(){}
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