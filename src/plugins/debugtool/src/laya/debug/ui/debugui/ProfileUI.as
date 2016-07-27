/**Created by the LayaEditor,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     
	import laya.debug.view.nodeInfo.views.RenderCostRankView;
	import laya.debug.view.nodeInfo.views.ObjectCreateView;
	import laya.debug.view.nodeInfo.views.CacheRankView;

	public class ProfileUI extends View {
		public var renderPanel:RenderCostRankView;
		public var createPanel:ObjectCreateView;
		public var cachePanel:CacheRankView;
		public var tab:Tab;

		public static var uiView:Object ={"type":"View","props":{"base64pic":true,"width":260,"height":329},"child":[{"props":{"y":0,"skin":"view/bg_tool.png","left":0,"right":0},"type":"Image"},{"type":"Rank","props":{"name":"渲染用时","left":0,"right":0,"top":29,"bottom":0,"runtime":"laya.debug.view.nodeInfo.views.RenderCostRankView","var":"renderPanel"}},{"type":"ObjectCreate","props":{"name":"对象创建统计","runtime":"laya.debug.view.nodeInfo.views.ObjectCreateView","top":29,"left":0,"right":0,"bottom":0,"var":"createPanel"}},{"type":"Rank","props":{"name":"cache用时","left":0,"right":0,"top":29,"bottom":0,"runtime":"laya.debug.view.nodeInfo.views.CacheRankView","var":"cachePanel","x":10}},{"type":"Tab","child":[{"props":{"skin":"view/create.png","label":"  对象创建","width":70,"height":17,"name":"item0","labelColors":"#a0a0a0,#ffffff,#ffffff,#ffffff"},"type":"CheckBox"},{"props":{"x":77,"skin":"view/rendertime.png","label":" 渲染用时","width":70,"height":19,"name":"item1","labelColors":"#a0a0a0,#ffffff,#ffffff,#ffffff","y":0},"type":"CheckBox"},{"props":{"x":154,"skin":"view/cache.png","label":" Cache","width":70,"height":16,"name":"item2","labelColors":"#a0a0a0,#ffffff,#ffffff,#ffffff","y":0},"type":"CheckBox"}],"props":{"x":7,"y":9,"selectedIndex":0,"var":"tab","width":191,"height":19}}]};
		public function ProfileUI(){}
		override protected function createChildren():void {
		  viewMapRegists();
			super.createChildren();
			createView(uiView);
		}
		protected function viewMapRegists():void
		{
			View.viewClassMap["laya.debug.view.nodeInfo.views.RenderCostRankView"] = RenderCostRankView;
			View.viewClassMap["laya.debug.view.nodeInfo.views.ObjectCreateView"] = ObjectCreateView;
			View.viewClassMap["laya.debug.view.nodeInfo.views.CacheRankView"] = CacheRankView;

		}
	}
}