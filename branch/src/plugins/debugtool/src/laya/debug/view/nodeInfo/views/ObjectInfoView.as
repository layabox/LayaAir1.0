package laya.debug.view.nodeInfo.views
{
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.utils.Handler;
	import laya.utils.Pool;
	import laya.debug.tools.RenderAnalyser;
	import laya.debug.view.StyleConsts;
	
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.ObjectTools;
	
	import laya.debug.view.nodeInfo.NodeUtils;
	import laya.debug.view.nodeInfo.nodetree.ObjectInfo;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ObjectInfoView extends UIViewBase
	{
		
		public var view:ObjectInfo;
		
		public function ObjectInfoView()
		{
			super();
		
		}
		
		override public function createPanel():void
		{
			super.createPanel();
			view = new ObjectInfo();
			StyleConsts.setViewScale(view);
			addChild(view);
			inits();
		}
		
		private function inits():void
		{
			view.closeBtn.on(Event.CLICK, this, close);
			view.settingBtn.on(Event.CLICK, this, onSettingBtn);
			view.autoUpdate.on(Event.CHANGE, this, onAutoUpdateChange);
			
			DisControlTool.setDragingItem(view.bg, view);
			DisControlTool.setResizeAbleEx(view);
			
			_closeSettingHandler = new Handler(this, closeSetting);
			dis = view;
		}
		
		private function onAutoUpdateChange():void
		{
			autoUpdate = view.autoUpdate.selected;
		}
		
		private function onSettingBtn():void
		{
			NodeTreeSettingView.I.showSetting(showKeys, _closeSettingHandler, _tar);
		}
		
		public function reset():void
		{
			showKeys=["x", "y", "width", "height", "renderCost"];
		}
		public var showKeys:Array = ["x", "y", "width", "height", "renderCost"];
		private var _closeSettingHandler:Handler;
		
		public function closeSetting(newKeys:Array):void
		{
			showKeys = newKeys;
			this.fresh();
		}
		
		public function showObjectInfo(obj:Object):void
		{
			_tar = obj;
			fresh();
			show();
			onAutoUpdateChange();
		}
		private var _tar:Object;
		
		public function fresh():void
		{
			//trace("fresh");
			if (!_tar)
			{
				view.showTxt.text = "";
				view.title.text = "未选中对象";
			}
			else
			{
				view.title.text = ClassTool.getNodeClassAndName(_tar);
				view.showTxt.text = getObjValueStr(_tar, showKeys,false);
			}
		}
		
		private function set autoUpdate(v:Boolean):void
		{
			Laya.timer.clear(this, freshKeyInfos);
			if (v)
			{
				Laya.timer.loop(2000, this, freshKeyInfos);
			}
		}
		
		private function freshKeyInfos():void
		{
			fresh();
		}
		private static var _txts:Array = [];
		
		public static function getObjValueStr(obj:Object, keys:Array, withTitle:Boolean = true):String
		{
			var i:int, len:int;
			var tKey:String;
			_txts.length = 0;
			len = keys.length;
			if (withTitle)
			{
				if (obj.name)
				{
					_txts.push(ClassTool.getClassName(obj) + "(" + obj.name + ")");
				}
				else
				{
					_txts.push(ClassTool.getClassName(obj));
				}
			}
			
			for (i = 0; i < len; i++)
			{
				tKey = keys[i];
				_txts.push(tKey + ":" + getNodeValue(obj, tKey));
			}
			return _txts.join("\n");
		}
		
		public static function getNodeValue(node:Object, key:String):String
		{
			var rst:String;
			if (node is Sprite)
			{
				var tNode:Sprite;
				tNode = node as Sprite;
				switch (key)
				{
					case "gRec": 
						rst = NodeUtils.getGRec(tNode).toString();
						break;
					case "gAlpha": 
						rst = NodeUtils.getGAlpha(tNode) + "";
						break;
					case "cmdCount": 
						rst = NodeUtils.getNodeCmdCount(tNode) + "";
						break;
					case "cmdAll": 
						rst = NodeUtils.getNodeCmdTotalCount(tNode) + "";
						break;
					case "nodeAll": 
						rst = "" + NodeUtils.getNodeCount(tNode);
						break;
					case "nodeVisible": 
						rst = "" + NodeUtils.getNodeCount(tNode,true);
						break;
					case "nodeRender": 
						rst = "" + NodeUtils.getRenderNodeCount(tNode);
						break;
					case "nodeReCache": 
						rst = "" + NodeUtils.getReFreshRenderNodeCount(tNode);
						break;
					case "renderCost": 
						rst = "" + RenderAnalyser.I.getTime(tNode);
						break;
					case "renderCount": 
						rst = "" + RenderAnalyser.I.getCount(tNode);
						break;
					default: 
						rst = node[key] + "";
				}
			}
			else
			{
				rst = node[key] + "";
			}
			
			return rst;
		}
		
		override public function close():void
		{
			super.close();
			autoUpdate = false;
			Pool.recover("ObjectInfoView", this);
		}
		
		override public function show():void
		{
			super.show();
		}
		
		public static function showObject(obj:Object):void
		{
			var infoView:ObjectInfoView;
			infoView = Pool.getItemByClass("ObjectInfoView", ObjectInfoView);
			infoView.reset();
			infoView.showObjectInfo(obj);
		}
	}

}