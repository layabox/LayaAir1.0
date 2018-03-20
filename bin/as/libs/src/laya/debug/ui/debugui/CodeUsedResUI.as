/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     

	public class CodeUsedResUI extends View {
		public var tab:Tab;

		public static var uiView:Object ={"type":"View","child":[{"props":{"x":359,"y":91,"skin":"comp/button1.png"},"type":"Image"},{"props":{"x":309,"y":283,"skin":"comp/line2.png"},"type":"Image"},{"type":"Tab","child":[{"props":{"skin":"view/create.png","label":"  对象创建","width":70,"height":17,"name":"item0"},"type":"CheckBox"},{"props":{"x":70,"skin":"view/rendertime.png","label":"渲染用时","width":70,"height":19,"name":"item1"},"type":"CheckBox"},{"props":{"x":140,"skin":"view/cache.png","label":"Cache","width":70,"height":16,"name":"item2"},"type":"CheckBox"}],"props":{"x":76,"y":210,"selectedIndex":0,"var":"tab"}}],"props":{"width":600,"height":400,"base64pic":true}};
		public function CodeUsedResUI(){}
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