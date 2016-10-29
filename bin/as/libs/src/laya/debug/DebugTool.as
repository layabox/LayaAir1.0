///////////////////////////////////////////////////////////
//  Debug.as
//  Macromedia ActionScript Implementation of the Class Debug
//  Created on:      2015-9-24 下午3:00:38
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug
{
	
	import laya.debug.tools.CacheAnalyser;
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.CountTool;
	import laya.debug.tools.DTrace;
	import laya.debug.tools.DebugExport;
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.DisController;
	import laya.debug.tools.DisplayHook;
	import laya.debug.tools.MouseEventAnalyser;
	import laya.debug.tools.RunProfile;
	import laya.debug.tools.TraceTool;
	import laya.debug.tools.WalkTools;
	import laya.debug.tools.enginehook.ClassCreateHook;
	import laya.debug.tools.enginehook.LoaderHook;
	import laya.debug.tools.enginehook.RenderSpriteHook;
	import laya.debug.tools.enginehook.SpriteRenderHook;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	import laya.debug.view.nodeInfo.NodeInfoPanel;
	import laya.debug.view.nodeInfo.NodeUtils;
	import laya.debug.view.nodeInfo.ToolPanel;
	import laya.debug.view.nodeInfo.nodetree.NodeTree;
	import laya.debug.view.nodeInfo.views.NodeToolView;
	import laya.debug.view.nodeInfo.views.ObjectCreateView;
	import laya.debug.view.nodeInfo.views.RenderCostRankView;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.events.Event;
	import laya.maths.GrahamScan;
	import laya.maths.Rectangle;
	import laya.renders.RenderSprite;
	import laya.utils.Browser;
	import laya.utils.Stat;
	
	//import tools.debugUI.DMainPain;
	
	/**
	 *
	 * @author ww
	 * @version 1.0
	 *
	 * @created  2015-9-24 下午3:00:38
	 */
	public class DebugTool
	{
		public function DebugTool()
		{
		}
		
		public static var enableCacheAnalyse:Boolean = false;
		public static var enableNodeCreateAnalyse:Boolean = true;
		public static function getMenuShowEvent():String
		{
			//return Event.DOUBLE_CLICK;
			if (Browser.onMobile)
			{
				return Event.DOUBLE_CLICK;
			}else
			{
				return Event.RIGHT_CLICK;
			}
		}
		public static function init(cacheAnalyseEnable:Boolean=true,loaderAnalyseEnable:Boolean=true,createAnalyseEnable:Boolean=true,renderAnalyseEnable:Boolean=true,showCacheRec:Boolean=false):void
		{
			enableCacheAnalyse = cacheAnalyseEnable;
			if (enableCacheAnalyse)
			{
				RenderSpriteHook.init();	
			}
			if (renderAnalyseEnable)
			{
				SpriteRenderHook.init();
			}
			enableNodeCreateAnalyse = createAnalyseEnable;
			if (enableNodeCreateAnalyse)
			{
				ClassCreateHook.I.hookClass(Node);
			}
			if (loaderAnalyseEnable)
			{
				LoaderHook.init();
			}
			CacheAnalyser.showCacheSprite = showCacheRec;
			DisplayHook.initMe();
			NodeInfoPanel.init();
			if (!debugLayer)
			{
				debugLayer = DebugInfoLayer.I.graphicLayer;
				debugLayer.mouseEnabled = false;
				debugLayer.mouseThrough = true;
				showStatu = true;
				//showStatu = false;
				Laya.stage.on(Event.KEY_DOWN, null, keyHandler);
				
				cmdToTypeO[RenderSprite.IMAGE] = "IMAGE";
				cmdToTypeO[RenderSprite.ALPHA] = "ALPHA";
				cmdToTypeO[RenderSprite.TRANSFORM] = "TRANSFORM";
				cmdToTypeO[RenderSprite.CANVAS] = "CANVAS";
				cmdToTypeO[RenderSprite.GRAPHICS] = "GRAPHICS";
				cmdToTypeO[RenderSprite.CUSTOM] = "CUSTOM";
				cmdToTypeO[RenderSprite.CHILDS] = "CHILDS";
				
				DebugExport.export();
				
			}
		}
		
		private static var _traceFun:Function;
		
		/**
		 * 在输出ui中输出
		 * @param str
		 */
		public static function dTrace(str:String):void
		{
			if (_traceFun != null)
			{
				_traceFun(str);
			}
			trace(str);
		}
		
		private static function keyHandler(e:*):void
		{
			var key:String;
			key = String.fromCharCode(e.keyCode);
//			trace("keydown:"+key);
			//trace("keyCode:"+e.keyCode);
			//  trace(e);
			if (!e.altKey)
				return;
			//trace("keydown:"+key);
			switch (e.keyCode)
			{
				case 38: 
					//Up
					showParent();
					break;
				case 40: 
					//Down
					showChild();
					break;
				case 37: 
					//Left
					showBrother(target, 1);
					break;
				case 39: 
					//Right
					showBrother(target, -1);
					break;
			}
			dealCMDKey(key);
		}
		
		public static function dealCMDKey(key:String):void
		{
			switch (key)
			{
				case "上": 
					//Up
					showParent();
					break;
				case "下": 
					//Down
					showChild();
					break;
				case "左": 
					//Left
					showBrother(target, 1);
					break;
				case "右": 
					//Right
					showBrother(target, -1);
					break;
				case "B": 
					//显示所有兄弟节点
					showAllBrother();
					break;
				case "C": 
					//显示所有子对象
					showAllChild();
					break;
				case "E": 
					//显示当前对象MouseEnable链
					traceDisMouseEnable();
					break;
				case "S": 
					//显示当前对象Size链
					traceDisSizeChain();
					break;
				case "D": 
					//下移
					DisControlTool.downDis(target);
					break;
				case "U": 
					//上移
					DisControlTool.upDis(target);
					break;
				case "N": 
					//获取节点信息
					getNodeInfo();
					break;
				case "M": 
					//选中鼠标下的所有对象
					showAllUnderMosue();
					break;
				case "I": 
					//切换debugui显示隐藏
					//switchMyVisible();
					break;
				case "O": 
					//显示对象控制器
					//switchDisController();
					ObjectCreateView.I.show();
					break;
				case "L": 
					//切换长度控制模式
					DisController.I.switchType();
					break;
				case "Q": 
					//切换长度控制模式
					showNodeInfo();
					break;
				case "F": 
					//切换长度控制模式
					showToolPanel();
					break;
				case "P": 
					//切换长度控制模式
					showToolFilter();
					break;
				case "V": 
					//切换长度控制模式
					selectNodeUnderMouse();
					break;
				case "A": 
					//切换长度控制模式
					if (NodeToolView.I.target)
					{
						MouseEventAnalyser.analyseNode(NodeToolView.I.target);
					}
					break;
				case "K": 
					NodeUtils.traceStage();
					break;
				case "T": 
					switchNodeTree();
					break;
				case "R": 
					RenderCostRankView.I.show();
					break;
				case "X": 
					NodeTree.I.fresh();
					break;
				case "mCMD": 
					//获取节点信息
					traceCMD();
					break;
				case "allCMD": 
					//获取节点信息
					traceCMDR();
					break;
			
			}
		}
		
		public static function switchNodeTree():void
		{
			ToolPanel.I.switchShow(ToolPanel.Tree);
		}
		
		public static function analyseMouseHit():void
		{
			if (target)
				MouseEventAnalyser.analyseNode(target);
		}
		
		public static function selectNodeUnderMouse():void
		{
			DisplayHook.instance.selectDisUnderMouse();
			showDisBound();
			return;
		}
		
		public static function showToolPanel():void
		{
			ToolPanel.I.switchShow(ToolPanel.Find);
		}
		
		public static function showToolFilter():void
		{
			ToolPanel.I.switchShow(ToolPanel.Filter);
		}
		
		public static function showNodeInfo():void
		{
			if (NodeInfoPanel.I.isWorkState)
			{
				NodeInfoPanel.I.recoverNodes();
			}
			else
			{
				NodeInfoPanel.I.showDisInfo(target);
			}
		
		}
		
		public static function switchDisController():void
		{
			if (DisController.I.target)
			{
				DisController.I.target = null;
			}
			else
			{
				if (target)
				{
					DisController.I.target = target;
				}
			}
		}
		
		public static function get isThisShow():Boolean
		{
			return false;
		}
		
		public static function showParent(sprite:Sprite = null):*
		{
			if (!sprite)
				sprite = target;
			if (!sprite)
			{
				trace("no targetAvalible");
				return null;
			}
			target = sprite.parent as Sprite;
			autoWork();
		}
		
		public static function showChild(sprite:Sprite = null):*
		{
			if (!sprite)
				sprite = target;
			if (!sprite)
			{
				trace("no targetAvalible");
				return null;
			}
			if (sprite.numChildren > 0)
			{
				target = sprite.getChildAt(0) as Sprite;
				autoWork();
			}
		}
		
		public static function showAllChild(sprite:Sprite = null):*
		{
			if (!sprite)
				sprite = target;
			if (!sprite)
			{
				trace("no targetAvalible");
				return null;
			}
			selectedNodes = DisControlTool.getAllChild(sprite);
			showSelected();
		}
		
		public static function showAllUnderMosue():*
		{
			selectedNodes = DisControlTool.getObjectsUnderGlobalPoint(Laya.stage);
			showSelected();
		}
		
		public static function showParentChain(sprite:Sprite = null):*
		{
			if (!sprite)
				return;
			selectedNodes = [];
			var tar:Sprite;
			tar = sprite.parent as Sprite;
			while (tar)
			{
				selectedNodes.push(tar);
				tar = tar.parent as Sprite;
			}
			showSelected();
		}
		
		public static function showAllBrother(sprite:Sprite = null):*
		{
			if (!sprite)
				sprite = target;
			if (!sprite)
			{
				trace("no targetAvalible");
				return null;
			}
			if (!sprite.parent)
				return;
			selectedNodes = DisControlTool.getAllChild(sprite.parent);
			showSelected();
		}
		
		public static function showBrother(sprite:Sprite, dID:int = 1):*
		{
			if (!sprite)
				sprite = target;
			if (!sprite)
			{
				trace("no targetAvalible");
				return null;
			}
			var p:Node;
			p = sprite.parent;
			if (!p)
				return;
			var n:int;
			n = p.getChildIndex(sprite);
			n += dID;
			if (n < 0)
				n += p.numChildren;
			if (n >= p.numChildren)
				n -= p.numChildren;
			target = p.getChildAt(n) as Sprite;
			autoWork();
		}
		private static var text:Stat = new Stat();
		
		/**
		 * 设置是否显示帧率信息
		 * @param value 是否显示true|false
		 */
		public static function set showStatu(value:Boolean):void
		{
			if (value)
			{
				Stat.show();
			}
			else
			{
				
				Stat.hide();
				clearDebugLayer();
			}
		}
		
		public static function clearDebugLayer():void
		{
			if (debugLayer.graphics)
				debugLayer.graphics.clear();
		}
		/**
		 * debug层
		 */
		public static var debugLayer:Sprite;
		/**
		 * 最后点击的对象
		 */
		public static var _target:Sprite;
		
		public static function set target(v:Sprite):void
		{
			_target = v;
		}
		
		public static function get target():Sprite
		{
			return _target;
		}
		/**
		 * 最后被选中的节点列表
		 */
		public static var selectedNodes:Array = [];
		/**
		 * 是否自动显示选中节点列表
		 */
		public static var autoShowSelected:Boolean = true;
		
		/**
		 * 显示选中的节点列表
		 */
		public static function showSelected():void
		{
			if (!autoShowSelected)
				return;
			if (!selectedNodes || selectedNodes.length < 1)
				return;
			trace("selected:");
			trace(selectedNodes);
			var i:int;
			var len:int;
			len = selectedNodes.length;
			clearDebugLayer();
			for (i = 0; i < len; i++)
			{
				showDisBound(selectedNodes[i], false);
			}
		}
		
		/**
		 * 获取类对象的创建信息
		 * @param className
		 * @return
		 */
		public static function getClassCreateInfo(className:String):Object
		{
			return RunProfile.getRunInfo(className);
		}
		
		private static var _showBound:Boolean = true;
		
		/**
		 * 是否自动显示点击对象的边框
		 * @param value
		 */
		public static function set showBound(value:Boolean):void
		{
			_showBound = value;
			if (!_showBound)
			{
				clearDebugLayer();
			}
		}
		
		public static function get showBound():Boolean
		{
			return _showBound;
		}
		
		/**
		 * 执行默认操作
		 */
		public static function autoWork():void
		{
			if (!isThisShow)
				return;
			if (showBound)
				showDisBound();
			if (autoTraceSpriteInfo && target)
			{
				TraceTool.traceSpriteInfo(target, autoTraceBounds, autoTraceSize, autoTraceTree);
			}
			if (!target)
				return;
			if (autoTraceCMD)
			{
				traceCMD();
			}
			if (autoTraceCMDR)
			{
				traceCMDR();
			}
			if (autoTraceEnable)
			{
				traceDisMouseEnable(target);
			}
		}
		
		public static function traceDisMouseEnable(tar:Sprite = null):*
		{
			trace("traceDisMouseEnable:");
			if (!tar)
				tar = target;
			if (!tar)
			{
				trace("no targetAvalible");
				return null;
			}
			var strArr:Array;
			strArr = ["TraceDisMouseEnable"];
			selectedNodes = [];
			while (tar)
			{
				strArr.push(ClassTool.getNodeClassAndName(tar) + ":" + tar.mouseEnabled+" hitFirst:"+tar.hitTestPrior);
				//dTrace(TraceTool.getClassName(tar)+":"+tar.mouseEnabled);
				selectedNodes.push(tar);
				tar = tar.parent as Sprite;
			}
			showSelected();
			return strArr.join("\n");
		}
		
		public static function traceDisSizeChain(tar:Sprite = null):*
		{
			trace("traceDisSizeChain:");
			if (!tar)
				tar = target;
			if (!tar)
			{
				trace("no targetAvalible");
				return null;
			}
			selectedNodes = [];
			var strArr:Array;
			strArr = ["traceDisSizeChain"];
			while (tar)
			{
				dTrace(TraceTool.getClassName(tar) + ":");
				strArr.push(ClassTool.getNodeClassAndName(tar) + ":");
				strArr.push("Size: x:" + tar.x + " y:" + tar.y + " w:" + tar.width + " h:" + tar.height + " scaleX:" + tar.scaleX + " scaleY:" + tar.scaleY);
				TraceTool.traceSize(tar);
				selectedNodes.push(tar);
				tar = tar.parent as Sprite;
			}
			showSelected();
			return strArr.join("\n");
		}
		private static var _disBoundRec:Rectangle;
		
		/**
		 * 显示对象的边框
		 * @param sprite 对象
		 * @param clearPre 是否清楚原先的边框图
		 */
		public static function showDisBound(sprite:Sprite = null, clearPre:Boolean = true, color:String = "#ff0000"):*
		{
			if (!sprite)
				sprite = target;
			if (!sprite)
			{
				trace("no targetAvalible");
				return null;
			}
			if (clearPre)
				clearDebugLayer();
			var pointList:Array;
//			pointList=target.getSelfBounds().getBoundPoints();
			pointList = sprite._getBoundPointsM(true);
			if (!pointList || pointList.length < 1)
				return;
			pointList = GrahamScan.pListToPointList(pointList, true);
			WalkTools.walkArr(pointList, sprite.localToGlobal, sprite);
			pointList = GrahamScan.pointListToPlist(pointList);
			_disBoundRec = Rectangle._getWrapRec(pointList, _disBoundRec);
			debugLayer.graphics.drawRect(_disBoundRec.x, _disBoundRec.y, _disBoundRec.width, _disBoundRec.height, null, color);
		
			DebugInfoLayer.I.setTop();
		}
		public static function showDisBoundToSprite(sprite:Sprite = null,graphicSprite:Sprite=null,color:String = "#ff0000",lineWidth:int=1):*
		{
			var pointList:Array;
//			pointList=target.getSelfBounds().getBoundPoints();
			pointList = sprite._getBoundPointsM(true);
			if (!pointList || pointList.length < 1)
				return;
			pointList = GrahamScan.pListToPointList(pointList, true);
			WalkTools.walkArr(pointList, sprite.localToGlobal, sprite);
			pointList = GrahamScan.pointListToPlist(pointList);
			_disBoundRec = Rectangle._getWrapRec(pointList, _disBoundRec);
			graphicSprite.graphics.drawRect(_disBoundRec.x, _disBoundRec.y, _disBoundRec.width, _disBoundRec.height, null, color,lineWidth);
		}
		public static var autoTraceEnable:Boolean = false;
		public static var autoTraceBounds:Boolean = false;
		public static var autoTraceSize:Boolean = false;
		public static var autoTraceTree:Boolean = true;
		/**
		 * 是否自动显示节点自身的CMD
		 */
		public static var autoTraceCMD:Boolean = true;
		/**
		 *  是否自动显示节点自身已经子对象的CMD
		 */
		public static var autoTraceCMDR:Boolean = false;
		/**
		 * 是否自动显示节点信息
		 */
		public static var autoTraceSpriteInfo:Boolean = true;
		
		/**
		 *  显示节点统计信息
		 * @return
		 */
		public static function getNodeInfo():Object
		{
			counter.reset();
			WalkTools.walkTarget(Laya.stage, addNodeInfo);
//			trace("total:"+counter.count);
			trace("node info:");
			counter.traceSelf();
			return counter.data;
		}
		private static var _classList:Array;
		private static var _tFindClass:String;
		
		public static function findByClass(className:String):Array
		{
			_classList = [];
			_tFindClass = className;
			WalkTools.walkTarget(Laya.stage, addClassNode);
			selectedNodes = _classList;
			showSelected();
			return _classList;
		}
		
		private static function addClassNode(node:Object):void
		{
			var type:String;
			type = node["constructor"].name;
			if (type == _tFindClass)
			{
				_classList.push(node);
			}
		}
		
		private static var cmdToTypeO:Object = {
			
			};
		
		private static var _rSpList:Array = [];
		
		/**
		 * 显示Sprite 指令信息
		 * @param sprite
		 * @return
		 */
		public static function traceCMD(sprite:Sprite = null):Object
		{
			if (!sprite)
				sprite = target;
			if (!sprite)
			{
				trace("no targetAvalible");
				return null;
			}
			trace("self CMDs:");
			trace(sprite.graphics.cmds);
			var renderSprite:RenderSprite;
			renderSprite = RenderSprite.renders[sprite._renderType];
			trace("renderSprite:", renderSprite);
			_rSpList.length = 0;
			while (renderSprite && renderSprite["_sign"] > 0)
			{
				
				_rSpList.push(cmdToTypeO[renderSprite["_sign"]]);
				renderSprite = renderSprite._next;
			}
			trace("fun:", _rSpList.join(","));
			counter.reset();
			addCMDs(sprite.graphics.cmds);
			counter.traceSelf();
			return counter.data;
		}
		
		private static function addCMDs(cmds:Array):void
		{
			WalkTools.walkArr(cmds, addCMD);
		}
		
		private static function addCMD(cmd:Object):void
		{
			counter.add(cmd.callee);
		}
		private static var counter:CountTool = new CountTool();
		
		/**
		 * 显示Sprite以及其子对象的指令信息
		 * @param sprite
		 * @return
		 */
		public static function traceCMDR(sprite:Sprite = null):Object
		{
			if (!sprite)
				sprite = target;
			if (!sprite)
			{
				trace("no targetAvalible");
				return 0;
			}
			counter.reset();
			WalkTools.walkTarget(sprite, getCMdCount);
			trace("cmds include children");
			counter.traceSelf();
			return counter.data;
		}
		
		private static function getCMdCount(target:Sprite):int
		{
			if (!target)
				return 0;
			if (!target is Sprite)
				return 0;
			if (!target.graphics.cmds)
				return 0;
			addCMDs(target.graphics.cmds);
			var rst:Number = target.graphics.cmds.length;
			return rst;
		}
		
		private static function addNodeInfo(node:Node):void
		{
			var type:String;
			type = node["constructor"].name;
			counter.add(type);
		}
		
		/**
		 * 根据过滤器返回显示对象
		 * @param filter
		 * @return
		 */
		public static function find(filter:Object, ifShowSelected:Boolean = true):Array
		{
			var rst:Array;
			rst = findTarget(Laya.stage, filter);
			selectedNodes = rst;
			if (selectedNodes)
			{
				target = selectedNodes[0];
			}
			if (ifShowSelected)
				showSelected();
			return rst;
		}
		private static var nameFilter:Object = {"name": "name"};
		
		/**
		 * 根据名字获取显示对象
		 * @param name
		 * @return
		 */
		public static function findByName(name:String):Array
		{
			nameFilter.name = name;
			return find(nameFilter);
		}
		
		/**
		 * 获取名字以某个字符串开头的显示对象
		 * @param startStr
		 * @return
		 */
		public static function findNameStartWith(startStr:String):Array
		{
			nameFilter.name = getStartWithFun(startStr);
			return find(nameFilter);
		}
		
		/**
		 * 获取名字包含某个字符串的显示对象
		 * @param hasStr
		 * @return
		 */
		public static function findNameHas(hasStr:String, showSelected:Boolean = true):Array
		{
			nameFilter.name = getHasFun(hasStr);
			return find(nameFilter, showSelected);
		}
		
		private static function getStartWithFun(startStr:String):Function
		{
			var rst:Function = function(str:String):Boolean
			{
				if (!str)
					return false;
				if (str.indexOf(startStr) == 0)
					return true;
				return false;
			};
			return rst;
		}
		
		private static function getHasFun(hasStr:String):Function
		{
			var rst:Function = function(str:String):Boolean
			{
				if (!str)
					return false;
				if (str.indexOf(hasStr) >= 0)
					return true;
				return false;
			};
			return rst;
		}
		
		public static function findTarget(target:Sprite, filter:Object):Array
		{
			var rst:Array = [];
			if (isFit(target, filter))
				rst.push(target);
			var i:int;
			var len:int;
			var tChild:Sprite;
			len = target.numChildren;
			for (i = 0; i < len; i++)
			{
				tChild = target.getChildAt(i) as Sprite;
				if (tChild is Sprite)
				{
					rst = rst.concat(findTarget(tChild, filter));
				}
			}
			return rst;
		}
		
		public static function findClassHas(target:Sprite, str:String):Array
		{
			var rst:Array = [];
			if (ClassTool.getClassName(target).indexOf(str) >= 0)
				rst.push(target);
			var i:int;
			var len:int;
			var tChild:Sprite;
			len = target.numChildren;
			for (i = 0; i < len; i++)
			{
				tChild = target.getChildAt(i) as Sprite;
				if (tChild is Sprite)
				{
					rst = rst.concat(findClassHas(tChild, str));
				}
			}
			return rst;
		}
		
		private static function isFit(tar:Object, filter:Object):Boolean
		{
			if (!tar)
				return false;
			if (!filter)
				return true;
			if (filter is Function)
			{
				return (filter as Function)(tar);
			}
			var key:String;
			for (key in filter)
			{
				if (filter[key] is Function)
				{
					if (!filter[key](tar[key]))
						return false;
				}
				else
				{
					if (tar[key] != filter[key])
						return false;
				}
				
			}
			return true;
		}
		
		
		public static var _logFun:Function;
		public static function log(...args):void
		{
			var arr:Array;
			arr = DTrace.getArgArr(args);
			if (_logFun!=null)
			{
				_logFun(arr.join(" "));
			}	    
		}
	}
}