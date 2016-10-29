/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui.comps {
	import laya.ui.*;                     

	public class RankListItemUI extends View {

		public static var uiView:Object ={"type":"View","child":[{"props":{"y":-1,"skin":"comp/clip_selectBox.png","clipY":2,"height":19,"name":"selectBox","left":0,"right":0,"x":0},"type":"Clip"},{"props":{"text":"render","color":"#a0a0a0","height":15,"name":"label","y":2,"left":11,"right":5,"fontSize":12,"x":11,"width":163},"type":"Label"}],"props":{"width":179,"height":19}};
		public function RankListItemUI(){}
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