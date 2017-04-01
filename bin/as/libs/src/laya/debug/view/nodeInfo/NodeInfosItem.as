package laya.debug.view.nodeInfo 
{
	
	import laya.display.Graphics;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.maths.GrahamScan;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.utils.Pool;
	
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.DisControlTool;
	import laya.debug.tools.IDTools;
	import laya.debug.tools.WalkTools;

	/**
	 * ...
	 * @author ww
	 */
	public class NodeInfosItem extends Sprite
	{
		public static var NodeInfoContainer:DebugInfoLayer;
		public static function init():void
		{
			if (!NodeInfoContainer)
			{
				DebugInfoLayer.init();
				NodeInfoContainer = DebugInfoLayer.I;
				Laya.stage.addChild(NodeInfoContainer);
			}
		
		}
		public function NodeInfosItem() 
		{
			_infoTxt = new Text();
			_infoTxt.color = "#ff0000";
			_infoTxt.bgColor = "#00ff00";
			_infoTxt.fontSize = 12;
			//addChild(_infoTxt);
		}
		
		private var _infoTxt:Text;
		public static var showValues:Array = ["x", "y", "scaleX", "scaleY","width","height","visible", "mouseEnabled"];
		
		private static var _nodeInfoDic:Object = { };
		public static function getNodeInfoByNode(node:Sprite):NodeInfosItem
		{
			IDTools.idObj(node);
			var key:int;
			key = IDTools.getObjID(node);
			if (!_nodeInfoDic[key])
			{
				_nodeInfoDic[key] = new NodeInfosItem();
			}
			return _nodeInfoDic[key];
		}
		public static function hideAllInfos():void
		{
			var key:String;
			var tInfo:NodeInfosItem;
			for (key in _nodeInfoDic)
			{
				tInfo = _nodeInfoDic[key];
				tInfo.removeSelf();
			}
			clearRelations();
		}
		
		override public function removeSelf():Node 
		{
			_infoTxt.removeSelf();
			return super.removeSelf();
		}
		public function showToUI():void
		{
			NodeInfoContainer.nodeRecInfoLayer.addChild(this);
			
			
			_infoTxt.removeSelf();
			
			NodeInfoContainer.txtLayer.addChild(_infoTxt);
			findOkPos();
			
			
		}
		public function randomAPos(r:Number):void
		{
			//var angle:Number;
			//angle = Math.random() * 360/Math.PI;
			//_infoTxt.x = this.x + r * Math.sin(angle);
			//_infoTxt.y = this.y + r * Math.cos(angle);
			
			_infoTxt.x = this.x + Laya.stage.width*Math.random();
			_infoTxt.y = this.y + r *  Math.random();
		}
		public function findOkPos():void
		{
			var len:int;
			len = 20;
			randomAPos(len);
			return;
			var count:int;
			count = 1;
			while (!isPosOk())
			{
				count++;
				if (count >= 500)
				{
					len += 10;
					count = 0;
				}
				randomAPos(len);
			}
		}
		public function isPosOk():Boolean
		{
			var tParent:Sprite;
			tParent = NodeInfoContainer.nodeRecInfoLayer;
			var i:int, len:int;
			var cList:Array;
			cList = tParent._childs;
			len = cList.length;
			var tChild:Sprite;
			var mRec:Rectangle;
			mRec = _infoTxt.getBounds();
			if (mRec.x < 0) return false;
			if (mRec.y < 0) return false;
			if (mRec.right > Laya.stage.width) return false;
			//if (mRec.bottom > Laya.stage.height) return false;
			for (i = 0; i < len; i++)
			{
				tChild = cList[i];
				if (tChild == _infoTxt) continue;
				if (mRec.intersects(tChild.getBounds())) return false;
			}
			return true;
		}
		private static var _disBoundRec:Rectangle=new Rectangle();
		
		public static function showNodeInfo(node:Sprite):void
		{
			var nodeInfo:NodeInfosItem;
			nodeInfo = getNodeInfoByNode(node);
			nodeInfo.showInfo(node);		
		    nodeInfo.showToUI();
		}
		public static function showDisInfos(node:Sprite):void
		{
			var _node:Sprite;
	        _node = node;
			if (!node)
				return;
			while (node)
			{
				showNodeInfo(node);
				node = node.parent as Sprite;
			}
			DisControlTool.setTop(NodeInfoContainer);
			apdtTxtInfoPoss(_node);
			updateRelations();
		}
		public static function apdtTxtInfoPoss(node:Sprite):void
		{
			var disList:Array;
			disList = [];
		    while (node)
			{
				disList.push(node);
				node = node.parent as Sprite;
			}
			var i:int, len:int;
			var tInfo:NodeInfosItem;
			var tTxt:Text;
			len = disList.length;
			var xPos:Number;
			xPos = Laya.stage.width - 150;
			var heightLen:int;
			heightLen = 100;
			node = disList[0];
			if (node)
			{
				tInfo = getNodeInfoByNode(node);
				if (tInfo)
				{
					
					tTxt = tInfo._infoTxt;
					xPos = Laya.stage.width - tTxt.width - 10;
					heightLen = tTxt.height + 10;
					//trace("rePos:",node,tTxt,xPos, heightLen * i );
				}
			}
			disList = disList.reverse();
			for (i = 0; i < len; i++)
			{
				node = disList[i];
				tInfo = getNodeInfoByNode(node);
				if (tInfo)
				{
					
					tTxt = tInfo._infoTxt;
					tTxt.pos(xPos, heightLen * i );
					//trace("rePos:",node,tTxt,xPos, heightLen * i );
				}
			}
		}
		private static function clearRelations():void
		{
			var g:Graphics;
			g = NodeInfoContainer.lineLayer.graphics;
			g.clear();
		}
		public static function updateRelations():void
		{
			var g:Graphics;
			g = NodeInfoContainer.lineLayer.graphics;
			g.clear();
			var key:String;
			var tInfo:NodeInfosItem;
			for (key in _nodeInfoDic)
			{
				tInfo = _nodeInfoDic[key];
				if (tInfo.parent)
				{
					g.drawLine(tInfo.x, tInfo.y, tInfo._infoTxt.x, tInfo._infoTxt.y,"#0000ff");
				}
			}
		}
		private static var _txts:Array = [];
		private var _tar:Sprite;
		
		private static var _nodePoint:Point = new Point();
		public static function getNodeValue(node:Sprite, key:String):String
		{
			var rst:String;
			_nodePoint.setTo(0, 0);
			switch(key)
			{
				case "x":
					rst=node["x"]+" (g:"+node.localToGlobal(_nodePoint).x+")"
					break;
				case "y":
					rst=node["y"]+" (g:"+node.localToGlobal(_nodePoint).y+")"
					break;
				default:
					rst = node[key];
			}
			return rst;
		}
		public function showInfo(node:Sprite):void
		{
			
			_tar = node;
			if (!node) return;
			_txts.length = 0;
			var i:int, len:int;
			var tKey:String;
			len = showValues.length;
			if (node.name)
			{
				_txts.push(ClassTool.getClassName(node)+"("+node.name+")");
			}else
			{
				_txts.push(ClassTool.getClassName(node));
			}
			
			for (i = 0; i < len; i++)
			{
				tKey = showValues[i];
				_txts.push(tKey+":"+getNodeValue(node,tKey));		
			}
			_infoTxt.text = _txts.join("\n");
			this.graphics.clear();
			
			var pointList:Array;
			pointList=node._getBoundPointsM(true);
			if(!pointList||pointList.length<1) return;
			pointList=GrahamScan.pListToPointList(pointList,true);	
			WalkTools.walkArr(pointList,node.localToGlobal,node);	
			pointList=GrahamScan.pointListToPlist(pointList);
			_disBoundRec=Rectangle._getWrapRec(pointList,_disBoundRec);
			//debugLayer.graphics.drawRect(_disBoundRec.x, _disBoundRec.y, _disBoundRec.width, _disBoundRec.height, null, "#ff0000");
			this.graphics.drawRect(0, 0, _disBoundRec.width, _disBoundRec.height, null, "#00ffff");
			this.pos(_disBoundRec.x, _disBoundRec.y);
		}
		public function fresh():void
		{
			showInfo(_tar);
		}
		public function clearMe():void
		{
			_tar = null;
		}
		public function recover():void
		{
			Pool.recover("NodeInfosItem", this);
		}
	}

}