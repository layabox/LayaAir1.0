package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	
	import laya.debug.ui.debugui.RankUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class Rank extends RankUI 
	{
		
		public function Rank() 
		{
			Base64AtlasManager.replaceRes(RankUI.uiView);
			createView(RankUI.uiView);
		}
		override protected function createChildren():void 
		{
			super.viewMapRegists();
		}
		
	}

}