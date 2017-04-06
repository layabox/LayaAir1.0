package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.debug.ui.debugui.ObjectInfoUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ObjectInfo extends ObjectInfoUI 
	{
		
		public function ObjectInfo() 
		{
			Base64AtlasManager.replaceRes(ObjectInfoUI.uiView);
			createView(ObjectInfoUI.uiView);
		}
		override protected function createChildren():void 
		{
			
		}
	}

}