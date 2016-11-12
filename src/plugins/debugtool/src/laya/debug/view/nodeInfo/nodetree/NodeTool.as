package laya.debug.view.nodeInfo.nodetree 
{
	import laya.debug.data.Base64AtlasManager;
	import laya.debug.ui.debugui.NodeToolUI;
	
	/**
	 * ...
	 * @author ww
	 */
	public class NodeTool extends NodeToolUI 
	{
		
		public function NodeTool() 
		{
			super();
			Base64AtlasManager.replaceRes(NodeToolUI.uiView);
			createView(NodeToolUI.uiView);
		}
		override protected function createChildren():void 
		{
			
		}
	}

}