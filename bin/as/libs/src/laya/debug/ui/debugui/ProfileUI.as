/**Created by the LayaAirIDE,do not modify.*/
package laya.debug.ui.debugui {
	import laya.ui.*;                     
	import laya.debug.view.nodeInfo.views.RenderCostRankView;
	import laya.debug.view.nodeInfo.views.ObjectCreateView;
	import laya.debug.view.nodeInfo.views.CacheRankView;
	import laya.debug.view.nodeInfo.views.ResRankView;

	public class ProfileUI extends View {
		public var renderPanel:RenderCostRankView;
		public var createPanel:ObjectCreateView;
		public var cachePanel:CacheRankView;
		public var tab:Tab;
		public var resPanel:ResRankView;

		public static var uiView:Object ={"type":"View","props":{"width":260,"height":329,"base64pic":true},"child":[{"type":"Image","props":{"y":0,"skin":"view/bg_tool.png","right":0,"left":0}},{"type":"Rank","props":{"var":"renderPanel","top":29,"runtime":"laya.debug.view.nodeInfo.views.RenderCostRankView","right":0,"name":"渲染用时","left":0,"bottom":0}},{"type":"ObjectCreate","props":{"var":"createPanel","top":29,"runtime":"laya.debug.view.nodeInfo.views.ObjectCreateView","right":0,"name":"对象创建统计","left":0,"bottom":0}},{"type":"Rank","props":{"x":10,"var":"cachePanel","top":29,"runtime":"laya.debug.view.nodeInfo.views.CacheRankView","right":0,"name":"cache用时","left":0,"bottom":0}},{"type":"Tab","props":{"y":9,"x":7,"width":191,"var":"tab","selectedIndex":0,"height":19},"child":[{"type":"CheckBox","props":{"y":0,"x":0,"width":50,"skin":"view/create.png","name":"item0","labelColors":"#a0a0a0,#ffffff,#ffffff,#ffffff","label":"  对象","height":17}},{"type":"CheckBox","props":{"y":0,"x":55,"width":50,"skin":"view/rendertime.png","name":"item1","labelColors":"#a0a0a0,#ffffff,#ffffff,#ffffff","label":" 渲染","height":19}},{"type":"CheckBox","props":{"y":0,"x":110,"width":50,"skin":"view/cache.png","name":"item2","labelColors":"#a0a0a0,#ffffff,#ffffff,#ffffff","label":" 重绘","height":16}},{"type":"CheckBox","props":{"y":0,"x":165,"width":50,"skin":"view/cache.png","name":"item3","labelColors":"#a0a0a0,#ffffff,#ffffff,#ffffff","label":" 资源","height":16}}]},{"type":"Rank","props":{"y":40,"x":50,"var":"resPanel","top":29,"runtime":"laya.debug.view.nodeInfo.views.ResRankView","right":0,"name":"资源缓存","left":0,"bottom":0}}]};
		public function ProfileUI(){}
		override protected function createChildren():void {
		  viewMapRegists();
			super.createChildren();
			createView(uiView);
		}
		protected function viewMapRegists():void
		{
			View.regComponent("laya.debug.view.nodeInfo.views.RenderCostRankView",RenderCostRankView);
			View.regComponent("laya.debug.view.nodeInfo.views.ObjectCreateView",ObjectCreateView);
			View.regComponent("laya.debug.view.nodeInfo.views.CacheRankView",CacheRankView);
			View.regComponent("laya.debug.view.nodeInfo.views.ResRankView",ResRankView);

		}
	}
}