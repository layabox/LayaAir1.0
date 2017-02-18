/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     
	import laya.debug.uicomps.TreeListItem;

	public class NodeTreeUI extends View {
		public var nodeTree:Tree;
		public var controlBar:Box;
		public var settingBtn:Button;
		public var freshBtn:Button;
		public var fliterTxt:TextInput;
		public var closeBtn:Button;
		public var ifShowProps:CheckBox;

		public static var uiView:Object ={"type":"View","props":{"width":200,"height":260,"base64pic":true},"child":[{"type":"Image","props":{"x":-22,"y":-47,"skin":"view/bg_panel.png","width":211,"height":206,"left":0,"right":0,"top":0,"bottom":0,"sizeGrid":"5,5,5,5"}},{"props":{"y":0,"skin":"view/bg_tool.png","left":0,"right":0},"type":"Image"},{"type":"Tree","props":{"x":0,"scrollBarSkin":"comp/vscroll.png","width":195,"height":229,"var":"nodeTree","left":0,"right":0,"top":38,"bottom":20},"child":[{"type":"ListItem","props":{"y":0,"name":"render","left":0,"right":0,"runtime":"laya.debug.uicomps.TreeListItem"}}]},{"type":"Box","props":{"x":3,"y":5,"var":"controlBar","left":3,"right":3,"top":5,"height":23},"child":[{"type":"Button","props":{"x":6,"skin":"view/setting.png","stateNum":3,"var":"settingBtn","toolTip":"设置显示的属性","y":6}},{"type":"Button","props":{"y":6,"skin":"view/refresh.png","var":"freshBtn","left":30,"toolTip":"刷新数据"}},{"type":"TextInput","props":{"y":0,"skin":"view/bg_top.png","height":22,"var":"fliterTxt","left":53,"right":0,"color":"#a0a0a0"}},{"type":"Button","props":{"x":172,"y":2,"skin":"view/btn_close.png","var":"closeBtn","right":1,"visible":false}}]},{"props":{"y":243,"skin":"comp/checkbox.png","label":"显示属性","var":"ifShowProps","bottom":3,"selected":true,"visible":true,"x":2,"width":70,"height":14,"labelColors":"#a0a0a0,#fffff,#ffffff,#fffff"},"type":"CheckBox"}]};
		public function NodeTreeUI(){}
		override protected function createChildren():void {
		  viewMapRegists();
			super.createChildren();
			createView(uiView);
		}
		protected function viewMapRegists():void
		{
			View.regComponent("laya.debug.uicomps.TreeListItem",TreeListItem);

		}
	}
}