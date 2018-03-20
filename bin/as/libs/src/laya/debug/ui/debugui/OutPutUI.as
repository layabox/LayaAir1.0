/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     

	public class OutPutUI extends View {
		public var bg:Image;
		public var txt:Label;
		public var closeBtn:Button;
		public var clearBtn:Button;

		public static var uiView:Object ={"type":"View","props":{"width":300,"height":200,"base64pic":true},"child":[{"type":"Image","props":{"x":205,"y":254,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"}},{"type":"Label","props":{"skin":"comp/textarea.png","text":"TextArea","color":"#a0a0a0","var":"txt","left":5,"right":5,"top":22,"bottom":5,"mouseEnabled":true,"sizeGrid":"3,3,3,3"}},{"type":"Button","props":{"x":185,"y":15,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2}},{"props":{"x":253,"y":1,"skin":"view/re.png","stateNum":"2","var":"clearBtn","right":25},"type":"Button"},{"props":{"x":169,"y":247,"skin":"view/resize.png","right":2,"bottom":2,"name":"resizeBtn","stateNum":3},"type":"Button"}]};
		public function OutPutUI(){}
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