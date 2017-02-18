package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.events.Event;
	import laya.debug.tools.DisControlTool;
	import laya.debug.ui.debugui.NodeTreeSettingUI;
	import laya.debug.view.nodeInfo.views.NodeTreeSettingView;
	
	/**
	 * ...
	 * @author ww
	 */
	public class NodeTreeSetting extends NodeTreeSettingUI 
	{
		
		public function NodeTreeSetting() 
		{
			Base64AtlasManager.replaceRes(NodeTreeSettingUI.uiView);
			createView(NodeTreeSettingUI.uiView);
			//inits();
		}
		override protected function createChildren():void 
		{
			
		}
		

	}

}