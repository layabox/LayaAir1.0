package laya.debug.view.nodeInfo
{
	import laya.display.Sprite;
	import laya.maths.Point;
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.IDTools;
	
	/**
	 * ...
	 * @author ww
	 */
	public class NodeInfoPanel extends Sprite
	{
		
		
		public static var I:NodeInfoPanel;
		
		public static function init():void
		{
			if (!I)
			{
				I = new NodeInfoPanel();
				NodeInfosItem.init();
				ToolPanel.init();
			}
		
		}
		
		public function NodeInfoPanel()
		{
			super();
		}
		private var _stateDic:Object = {};
		public var isWorkState:Boolean = false;
		public function showDisInfo(node:Sprite):void
		{
			recoverNodes();
			NodeInfosItem.showDisInfos(node);
			showOnly(node);
			isWorkState = true;
		}
		
		public function showOnly(node:Sprite):void
		{
			if (!node)
				return;
			hideBrothers(node);
			showOnly(node.parent as Sprite);
		}
		public function recoverNodes():void
		{
			NodeInfosItem.hideAllInfos();
			var key:String;
			var data:Object;
			var tTar:Sprite;
			for (key in _stateDic)
			{
				data = _stateDic[key];
				tTar = data["target"];
				if (tTar)
				{
					try
					{
						tTar.visible = data.visible;
					}catch (e:*)
					{
						
					}
					
				}
			}
			isWorkState = false;
		}
		public function hideOtherChain(node:Sprite):void
		{
			if (!node)
				return;
			while (node)
			{
				hideBrothers(node);
				node = node.parent as Sprite;
			}
		}
		public function hideChilds(node:Sprite):void
		{
			if (!node)
				return;
			var i:int, len:int;
			var cList:Array;
			cList = node._childs;
			len = cList.length;
			var tChild:Sprite;
			for (i = 0; i < len; i++)
			{
				tChild = cList[i];
				if (tChild == NodeInfosItem.NodeInfoContainer) continue;
				
				saveNodeInfo(tChild);
				tChild.visible = false;
				
			}
		}
		public function hideBrothers(node:Sprite):void
		{
			if (!node)
				return;
			var p:Sprite;
			p = node.parent as Sprite;
			if (!p)
				return;
			var i:int, len:int;
			var cList:Array;
			cList = p._childs;
			len = cList.length;
			var tChild:Sprite;
			for (i = 0; i < len; i++)
			{
				tChild = cList[i];
				if (tChild == NodeInfosItem.NodeInfoContainer) continue;
				if (tChild != node)
				{
					saveNodeInfo(tChild);
					tChild.visible = false;
				}
			}
		}
		
		public function saveNodeInfo(node:Sprite):void
		{
			
			IDTools.idObj(node);
			if(_stateDic.hasOwnProperty(IDTools.getObjID(node))) return;
			var data:Object;
			data = { };
			data.target = node;
			data.visible = node.visible;
			_stateDic[IDTools.getObjID(node)] = data;
		}
		
		public function recoverNodeInfo(node:Sprite):void
		{
			IDTools.idObj(node);
			if (_stateDic.hasOwnProperty(IDTools.getObjID(node)))
			{
				var data:Object;
				data = _stateDic[IDTools.getObjID(node)];
				node["visible"] = data.visible;
			}
		}
	}

}