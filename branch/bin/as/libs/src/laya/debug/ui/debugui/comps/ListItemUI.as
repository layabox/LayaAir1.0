/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui.comps {
	import laya.ui.*;                     

	public class ListItemUI extends View {

		public static var uiView:Object ={"type":"View","props":{"base64pic":true,"width":244,"height":19},"child":[{"type":"Clip","props":{"y":-1,"skin":"comp/clip_selectBox.png","clipY":2,"height":19,"name":"selectBox","left":2,"right":2,"x":0}},{"type":"Label","props":{"x":25,"text":"render","color":"#dcea36","width":77,"height":17,"name":"label","y":2,"fontSize":12}},{"type":"Clip","props":{"skin":"comp/clip_tree_arrow.png","clipY":2,"name":"arrow","x":8,"y":4,"mouseEnabled":false}}]};
		public function ListItemUI(){}
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