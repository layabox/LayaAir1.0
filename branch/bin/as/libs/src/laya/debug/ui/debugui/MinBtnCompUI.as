/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     

	public class MinBtnCompUI extends View {
		public var minBtn:Button;
		public var maxUI:Box;
		public var bg:Image;
		public var maxBtn:Button;

		public static var uiView:Object ={"type":"View","child":[{"props":{"x":7,"y":8,"skin":"comp/minBtn.png","stateNum":"3","var":"minBtn","width":22,"height":20,"toolTip":"最小化"},"type":"Button"},{"type":"Box","child":[{"props":{"x":0,"y":0,"skin":"view/bg_panel.png","var":"bg","width":36,"height":36,"sizeGrid":"5,5,5,5"},"type":"Image"},{"props":{"x":6,"y":8,"skin":"view/zoom_out.png","stateNum":"2","var":"maxBtn"},"type":"Button"}],"props":{"var":"maxUI"}}],"props":{"width":36,"height":36,"base64pic":true}};
		public function MinBtnCompUI(){}
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