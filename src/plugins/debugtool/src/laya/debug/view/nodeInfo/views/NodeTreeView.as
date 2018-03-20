package laya.debug.view.nodeInfo.views 
{
	import laya.display.Sprite;
	import laya.debug.view.nodeInfo.NodeUtils;
	import laya.debug.view.nodeInfo.nodetree.NodeTree;

	/**
	 * ...
	 * @author ww
	 */
	public class NodeTreeView extends UIViewBase 
	{
		
		public function NodeTreeView() 
		{
			super();
			
		}
		private var nodeTree:NodeTree;
		override public function show():void 
		{
			showByNode();
		}
		public function showByNode(node:Sprite=null):void
		{
			if (!node) node = Laya.stage;		
			nodeTree.setDis(node);
			//addChild(nodeTree);
			//super.show();
		}
		override public function createPanel():void 
		{
			super.createPanel();
			if (!nodeTree) nodeTree = new NodeTree();
			dis = null;
			var view:NodeTree;
			view = nodeTree;
			view.top = view.bottom = view.left = view.right = 0;
			addChild(view);
			showByNode(Laya.stage);
		}
		public function showSelectInStage(node:Sprite):void
		{
			showByNode(Laya.stage);
			nodeTree.selectByNode(node);
			
		}
	}

}