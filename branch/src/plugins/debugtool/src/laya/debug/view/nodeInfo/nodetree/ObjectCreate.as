package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	
	import laya.debug.ui.debugui.ObjectCreateUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ObjectCreate extends ObjectCreateUI 
	{
		
		public function ObjectCreate() 
		{
			Base64AtlasManager.replaceRes(ObjectCreateUI.uiView);
			createView(ObjectCreateUI.uiView);
		}
		override protected function createChildren():void 
		{
			super.viewMapRegists();
		}
	}

}