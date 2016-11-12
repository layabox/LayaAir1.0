package laya.debug.uicomps 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.debug.ui.debugui.comps.ListItemUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class TreeListItem extends ListItemUI 
	{
		
		public function TreeListItem() 
		{
			Base64AtlasManager.replaceRes(ListItemUI.uiView);
			createView(ListItemUI.uiView);
		}
		override protected function createChildren():void 
		{
			
		}
		
	}

}