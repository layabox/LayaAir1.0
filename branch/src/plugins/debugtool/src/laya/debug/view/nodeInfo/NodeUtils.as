package laya.debug.view.nodeInfo
{
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.StringTool;
	import laya.debug.tools.WalkTools;
	import laya.debug.view.nodeInfo.views.ObjectInfoView;
	import laya.display.Graphics;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.maths.GrahamScan;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	
	/**
	 * ...
	 * @author ww
	 */
	public class NodeUtils
	{
		
		public function NodeUtils()
		{
		
		}
		
		public static const defaultKeys:Array = ["x", "y", "width", "height"];
		
		public static function getFilterdTree(sprite:Sprite, keys:Array):Object
		{
			if (!keys)
				keys = defaultKeys;
			var me:Object;
			me = {};
			var key:String;
			var i:int, len:int;
			len = keys.length;
			for (i = 0; i < len; i++)
			{
				key = keys[i];
				me[key] = sprite[key];
			}
			
			var cList:Array;
			var tChild:Sprite;
			cList = sprite._childs;
			len = cList.length;
			var mClist:Array;
			mClist = [];
			for (i = 0; i < len; i++)
			{
				tChild = cList[i];
				mClist.push(getFilterdTree(tChild, keys));
			}
			me.childs = mClist;
			return me;
		
		}
		
		public static function getPropertyDesO(tValue:*, keys:Array):Object
		{
			if (!keys)
				keys = defaultKeys;
			var rst:Object = {};
			if (tValue is Object)
			{
				rst.label = "" + ClassTool.getNodeClassAndName(tValue);
			}
			else
			{
				rst.label = "" + tValue;
			}
			
			rst.type = "";
			rst.path = tValue;
			rst.childs = [];
			rst.isDirectory = false;
			
			var key:String;
			var i:int, len:int;
			var tChild:Object;
			if (tValue is Node)
			{
				rst.des = ClassTool.getNodeClassAndName(tValue);
				rst.isDirectory = true;
				len = keys.length;
				for (i = 0; i < len; i++)
				{
					key = keys[i];
					tChild = getPropertyDesO(tValue[key], keys);
					if (tValue.hasOwnProperty(key))
					{
						tChild.label = "" + key + ":" + tChild.des;
					}
					else
					{
						tChild.label = "" + key + ":" + ObjectInfoView.getNodeValue(tValue, key);
					}
					
					rst.childs.push(tChild);
				}
				key = "_childs";
				tChild = getPropertyDesO(tValue[key], keys);
				tChild.label = "" + key + ":" + tChild.des;
				tChild.isChilds = true;
				rst.childs.push(tChild);
				
			}
			else if (tValue is Array)
			{
				rst.des = "Array[" + (tValue as Array).length + "]";
				rst.isDirectory = true;
				var tList:Array;
				tList = tValue as Array;
				len = tList.length;
				for (i = 0; i < len; i++)
				{
					tChild = getPropertyDesO(tList[i], keys);
					tChild.label = "" + i + ":" + tChild.des;
					rst.childs.push(tChild);
				}
			}
			else if (tValue is Object)
			{
				rst.des = ClassTool.getNodeClassAndName(tValue);
				rst.isDirectory = true;
				for (key in tValue)
				{
					tChild = getPropertyDesO(tValue[key], keys);
					tChild.label = "" + key + ":" + tChild.des;
					rst.childs.push(tChild);
				}
			}
			else
			{
				rst.des = "" + tValue;
			}
			rst.hasChild = rst.childs.length > 0;
			return rst;
		}
		
		public static function adptShowKeys(keys:Array):Array
		{
			var i:int, len:int;
			len = keys.length;
			for (i = len - 1; i >= 0; i--)
			{
				keys[i] = StringTool.trimSide(keys[i]);
				if (keys[i].length < 1)
				{
					keys.splice(i, 1);
				}
			}
			return keys;
		}
		
		public static function getNodeTreeData(sprite:Sprite, keys:Array):Array
		{
			adptShowKeys(keys);
			var treeO:Object;
			treeO = getPropertyDesO(sprite, keys);
			
			//trace("treeO:", treeO);
			var treeArr:Array;
			treeArr = [];
			getTreeArr(treeO, treeArr);
			return treeArr;
		}
		
		public static function getTreeArr(treeO:Object, arr:Array, add:Boolean = true):void
		{
			if (add)
				arr.push(treeO);
			var tArr:Array = treeO.childs;
			var i:int, len:int = tArr.length;
			for (i = 0; i < len; i++)
			{
				if (!add)
				{
					tArr[i].nodeParent = null;
				}
				else
				{
					tArr[i].nodeParent = treeO;
				}
				if (tArr[i].isDirectory)
				{
					getTreeArr(tArr[i], arr);
				}
				else
				{
					arr.push(tArr[i]);
				}
			}
		}
		
		public static function traceStage():void
		{
			trace(getFilterdTree(Laya.stage, null));
			
			trace("treeArr:", getNodeTreeData(Laya.stage, null));
		}
		
		public static function getNodeCount(node:Sprite,visibleRequire:Boolean=false):int
		{
			if (visibleRequire)
			{
				if (!node.visible) return 0;
			}
			var rst:int;
			rst = 1;
			var i:int, len:int;
			var cList:Array;
			cList = node._childs;
			len = cList.length;
			for (i = 0; i < len; i++)
			{
				rst += getNodeCount(cList[i],visibleRequire);
			}
			
			return rst;
		}
		public static function getGVisible(node:Sprite):Boolean
		{
			while (node)
			{
				if (!node.visible) return false;
				node = node.parent as Sprite;
			}
			return true;
		}
		public static function getGAlpha(node:Sprite):Number
		{
			var rst:Number;
			rst = 1;
			while (node)
			{
				rst *= node.alpha;
				node = node.parent as Sprite;
			}
			return rst;
		}
		public static function getGPos(node:Sprite):Point
		{
			var point:Point;
			point=new Point();
			node.localToGlobal(point);
			return point;
		}
		public static function getGRec(node:Sprite):Rectangle
		{
			var pointList:Array;
			pointList = node._getBoundPointsM(true);
			if (!pointList || pointList.length < 1)
				return Rectangle.TEMP.setTo(0,0,0,0);
			pointList = GrahamScan.pListToPointList(pointList, true);
			WalkTools.walkArr(pointList, node.localToGlobal, node);
			pointList = GrahamScan.pointListToPlist(pointList);
			var _disBoundRec:Rectangle;
			_disBoundRec = Rectangle._getWrapRec(pointList, _disBoundRec);
			return _disBoundRec;
		}
		public static function getGGraphicRec(node:Sprite):Rectangle
		{
			var pointList:Array;
			pointList = node.getGraphicBounds()._getBoundPoints();
			if (!pointList || pointList.length < 1)
				return Rectangle.TEMP.setTo(0,0,0,0);
			pointList = GrahamScan.pListToPointList(pointList, true);
			WalkTools.walkArr(pointList, node.localToGlobal, node);
			pointList = GrahamScan.pointListToPlist(pointList);
			var _disBoundRec:Rectangle;
			_disBoundRec = Rectangle._getWrapRec(pointList, _disBoundRec);
			return _disBoundRec;
		}
		public static function getNodeCmdCount(node:Sprite):int
		{
			var rst:int;
			if (node.graphics)
			{
				if (node.graphics.cmds)
				{
					rst = node.graphics.cmds.length;
				}
				else
				{
					if (node.graphics._one)
					{
						rst = 1;
					}
					else
					{
						rst = 0;
					}
				}
			}
			else
			{
				rst = 0;
			}
			return rst;
		}
		public static function getNodeCmdTotalCount(node:Sprite):int
		{
			var rst:int;
			var i:int, len:int;
			var cList:Array;
			cList = node._childs;
			len = cList.length;
			rst = getNodeCmdCount(node);
			for (i = 0; i < len; i++)
			{
				rst += getNodeCmdTotalCount(cList[i]);
			}
			return rst;
		}
		public static function getRenderNodeCount(node:Sprite):int
		{
			if (node.cacheAs != "none") return 1;
			var rst:int;
			var i:int, len:int;
			var cList:Array;
			cList = node._childs;
			len = cList.length;
			rst = 1;
			for (i = 0; i < len; i++)
			{
				rst += getRenderNodeCount(cList[i]);
			}
			return rst;
		}
		public static function getReFreshRenderNodeCount(node:Sprite):int
		{
			var rst:int;
			var i:int, len:int;
			var cList:Array;
			cList = node._childs;
			len = cList.length;
			rst = 1;
			for (i = 0; i < len; i++)
			{
				rst += getRenderNodeCount(cList[i]);
			}
			return rst;
		}
		
		private static var g:Graphics;
		public static function showCachedSpriteRecs():void
		{
			g = DebugInfoLayer.I.graphicLayer.graphics;
			g.clear();
			WalkTools.walkTarget(Laya.stage, drawCachedBounds, null);
		}
		private static function drawCachedBounds(sprite:Sprite):void
		{
			if (sprite.cacheAs == "none") return;
			if (DebugInfoLayer.I.isDebugItem(sprite)) return;
			var rec:Rectangle;
			rec = getGRec(sprite);
			g.drawRect(rec.x, rec.y, rec.width, rec.height, null, "#0000ff", 2);
			
		}
	}

}