package laya.debug.tools
{
	import laya.debug.tools.enginehook.SpriteRenderForVisibleAnalyse;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	import laya.debug.view.nodeInfo.NodeUtils;
	import laya.debug.view.nodeInfo.views.NodeListPanelView;
	import laya.debug.view.nodeInfo.views.OutPutView;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.resource.HTMLCanvas;
	
	/**
	 * ...
	 * @author ww
	 */
	public class VisibleAnalyser
	{
		
		public function VisibleAnalyser()
		{
		
		}
		
		public static function analyseTarget(node:Sprite):void
		{
			var isInstage:Boolean;
			isInstage = node.displayedInStage;
			var gRec:Rectangle;
			gRec = NodeUtils.getGRec(node);
			var stageRec:Rectangle = new Rectangle();
			stageRec.setTo(0, 0, Laya.stage.width, Laya.stage.height);
			var isInVisibleRec:Boolean;
			var visibleRec:Rectangle;
			visibleRec = stageRec.intersection(gRec);
			if (visibleRec.width > 0 && visibleRec.height > 0)
			{
				isInVisibleRec = true;
			}
			else
			{
				isInVisibleRec = false;
			}
			var gAlpha:Number;
			gAlpha = NodeUtils.getGAlpha(node);
			var gVisible:Boolean;
			gVisible = NodeUtils.getGVisible(node);
		
			var msg:String;
			msg = "";
			msg += "isInstage:" + isInstage + "\n";
			msg+="isInVisibleRec:"+isInVisibleRec+"\n";
			msg += "gVisible:" + gVisible + "\n";
			msg += "gAlpha:" + gAlpha + "\n";
			
			if (isInstage && isInVisibleRec && gVisible && gAlpha > 0)
			{
				if (Render.isWebGL)
				{
					anlyseRecVisible(node);
				}else
				{
					SpriteRenderForVisibleAnalyse.I.analyseNode(node);
				}
				msg += "coverRate:" + coverRate + "\n";
				if (_coverList.length > 0)
				{
					Laya.timer.once(1000, null, showListLater);
				}
			}
			trace(msg);
			OutPutView.I.showTxt(msg);
		}
		private static function showListLater():void
		{
			NodeListPanelView.I.showList(_coverList);
		}
		
		public static function isCoverByBrother(node:Sprite):void
		{
			var parent:Sprite = node.parent as Sprite;
			if (!parent)
				return;
			var _childs:Array;
			_childs = parent._childs;
			var index:int;
			index = _childs.indexOf(node);
			if (index < 0)
				return;
			var i:int, len:int;
			var canvas:HTMLCanvas;
			var rec:Rectangle;
			rec = parent.getSelfBounds();
			if (rec.width <= 0 || rec.height <= 0)
				return;
		
		}
		
		public static var isNodeWalked:Boolean;
		public static var _analyseTarget:Sprite;
		public static var tarRec:Rectangle = new Rectangle();
		public static var isTarRecOK:Boolean;
		
		public static var mainCanvas:HTMLCanvas;
		public static var preImageData:*;
		public static var tImageData:*;
		public static var tarImageData:*;
		public static var coverRate:Number;
		public static var tColor:int;
		public static function anlyseRecVisible(node:Sprite):void
		{
			isNodeWalked = false;
			_analyseTarget = node;
			if (!mainCanvas)
				mainCanvas = CanvasTools.createCanvas(Laya.stage.width, Laya.stage.height);
			CanvasTools.clearCanvas(mainCanvas);
			tColor = 1;
			resetCoverList();
			WalkTools.walkTargetEX(Laya.stage, recVisibleWalker, null, filterFun);
			if (!isTarRecOK)
			{
				coverRate = 0;
			}
			else
			{
				coverRate = CanvasTools.getDifferRate(preImageData, tarImageData);
			}
			trace("coverRate:", coverRate);
		}
		
		private static var interRec:Rectangle = new Rectangle();
		
		public static function getRecArea(rec:Rectangle):int
		{
			return rec.width * rec.height;
		}
		private static var _coverList:Array=[];
		public static function addCoverNode(node:Sprite, coverRate:Number):void
		{
			var data:Object;
			data = { };
			data.path = node;
			data.label = ClassTool.getNodeClassAndName(node) + ":" + coverRate;
			data.coverRate = coverRate;
			_coverList.push(data);
			trace("coverByNode:",node,coverRate);
		}
		public static function resetCoverList():void
		{
			_coverList.length = 0;
		}
		private static function recVisibleWalker(node:Sprite):void
		{
			if (node == _analyseTarget)
			{
				isNodeWalked = true;
				tarRec.copyFrom(NodeUtils.getGRec(node));
				trace("tarRec:", tarRec.toString());
				if (tarRec.width > 0 && tarRec.height > 0)
				{
					isTarRecOK = true;
					tColor++;
					CanvasTools.fillCanvasRec(mainCanvas, tarRec, ColorTool.toHexColor(tColor));
					preImageData = CanvasTools.getImageDataFromCanvasByRec(mainCanvas, tarRec);
					tarImageData = CanvasTools.getImageDataFromCanvasByRec(mainCanvas, tarRec);
				}
				else
				{
					trace("tarRec Not OK:", tarRec);
				}
			}
			else
			{
				if (isTarRecOK)
				{
					var tRec:Rectangle;
					tRec = NodeUtils.getGRec(node);
					
					interRec = tarRec.intersection(tRec, interRec);
					if (interRec && interRec.width > 0 && interRec.height > 0)
					{
						tColor++;
						CanvasTools.fillCanvasRec(mainCanvas, tRec, ColorTool.toHexColor(tColor));
						tImageData = CanvasTools.getImageDataFromCanvasByRec(mainCanvas, tarRec);
						var dRate:Number;
						dRate = CanvasTools.getDifferRate(preImageData, tImageData);
						//trace("differRate:", dRate);
						preImageData = tImageData;
						addCoverNode(node, dRate);
					}
				}
			}
		}
		
		private static function filterFun(node:Sprite):Boolean
		{
			if (node.visible == false)
				return false;
			if (node.alpha < 0)
				return false;
			if (DebugInfoLayer.I.isDebugItem(node)) return false;
			return true;
		}
	
	}

}