/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     

	public class NodeToolUI extends View {
		public var bg:Image;
		public var closeBtn:Button;
		public var tarTxt:Label;
		public var freshBtn:Button;
		public var mouseAnalyseBtn:Clip;
		public var dragIcon:Clip;

		public static var uiView:Object ={"type":"View","props":{"base64pic":true,"width":200,"height":341},"child":[{"type":"Image","props":{"x":195,"y":244,"skin":"view/bg_panel.png","left":0,"right":0,"top":0,"bottom":0,"var":"bg","sizeGrid":"5,5,5,5"}},{"type":"Label","props":{"x":9,"y":5,"text":"当前选中对象","width":67,"height":16,"color":"#a0a0a0"}},{"type":"Button","props":{"x":195,"y":25,"skin":"view/btn_close.png","var":"closeBtn","top":2,"right":2}},{"type":"Label","props":{"x":10,"y":25,"text":"当前对象","width":67,"height":16,"color":"#a0a0a0","var":"tarTxt"}},{"type":"Button","props":{"x":15,"y":65,"skin":"comp/button.png","label":"父链","width":39,"height":23,"mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":66,"y":65,"skin":"comp/button.png","label":"子","width":35,"height":23,"mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":112,"y":65,"skin":"comp/button.png","label":"兄弟","width":49,"height":23,"mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":13,"y":117,"skin":"comp/button.png","label":"Enable链","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":100,"y":117,"skin":"comp/button.png","label":"Size链","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Label","props":{"x":14,"y":97,"text":"节点链信息","width":67,"height":16,"color":"#a0a0a0"}},{"type":"Label","props":{"x":15,"y":45,"text":"对象选取","width":67,"height":16,"color":"#a0a0a0"}},{"type":"Label","props":{"x":16,"y":145,"text":"节点显示","width":67,"height":16,"color":"#a0a0a0"}},{"type":"Button","props":{"x":13,"y":164,"skin":"comp/button.png","label":"隐藏旁支","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":100,"y":164,"skin":"comp/button.png","label":"隐藏兄弟","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":13,"y":197,"skin":"comp/button.png","label":"隐藏子","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":99,"y":197,"skin":"comp/button.png","label":"恢复","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Label","props":{"x":15,"y":228,"text":"其他","width":67,"height":16,"color":"#a0a0a0"}},{"type":"Button","props":{"x":12,"y":247,"skin":"comp/button.png","label":"节点树定位","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":99,"y":247,"skin":"comp/button.png","label":"显示边框","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Label","props":{"x":12,"y":315,"text":"Alt+A分析鼠标能否够点中对象","width":173,"height":16,"color":"#a0a0a0"}},{"type":"Button","props":{"x":156,"y":1,"skin":"view/refresh2.png","var":"freshBtn","left":156,"toolTip":"recache节点"}},{"type":"Button","props":{"x":12,"y":279,"skin":"comp/button.png","label":"输出到控制台","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Button","props":{"x":99,"y":279,"skin":"comp/button.png","label":"显示切换","mouseEnabled":"true","labelColors":"#ffffff,#ffffff,#ffffff,#ffffff"}},{"type":"Clip","props":{"y":44,"skin":"view/clickanalyse.png","var":"mouseAnalyseBtn","toolTip":"拖动到对象上方判断是否能够点中","left":84,"x":84,"clipY":3}},{"type":"Clip","props":{"y":35,"skin":"view/clickanalyse.png","var":"dragIcon","x":94,"clipY":3}}]};
		public function NodeToolUI(){}
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