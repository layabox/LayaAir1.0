package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.debug.ui.debugui.OutPutUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class OutPut extends OutPutUI 
	{
		
		public function OutPut() 
		{
			Base64AtlasManager.replaceRes(OutPutUI.uiView);
			createView(OutPutUI.uiView);
		}
		override protected function createChildren():void 
		{
			
		}
		
	}

}