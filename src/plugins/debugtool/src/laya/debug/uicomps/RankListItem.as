package laya.debug.uicomps 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.debug.ui.debugui.comps.RankListItemUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class RankListItem extends RankListItemUI 
	{
		
		public function RankListItem() 
		{
			super();
			Base64AtlasManager.replaceRes(RankListItemUI.uiView);
			createView(RankListItemUI.uiView);
		}
		override protected function createChildren():void 
		{
			
		}
		
	}

}