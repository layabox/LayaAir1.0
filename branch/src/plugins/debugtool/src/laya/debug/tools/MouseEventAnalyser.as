package laya.debug.tools
{
	import laya.display.Sprite;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.debug.view.nodeInfo.ToolPanel;
	import laya.debug.DebugTool;
	
	/**
	 * ...
	 * @author ww
	 */
	public class MouseEventAnalyser
	{
		
		public function MouseEventAnalyser()
		{
		
		}
		
		public static var infoO:Object = {};
		public static var nodeO:Object = {};
		public static var hitO:Object = {};
		
		public static function analyseNode(node:Sprite):void
		{
			DebugTool.showDisBound(node, true);
			var _node:Sprite;
			_node = node;
			ObjectTools.clearObj(infoO);
			ObjectTools.clearObj(nodeO);
			ObjectTools.clearObj(hitO);
			var nodeList:Array;
			nodeList = [];
			while (node)
			{
				IDTools.idObj(node);
				nodeO[IDTools.getObjID(node)] = node;
				nodeList.push(node);
				node = node.parent as Sprite;
			}
			check(Laya.stage, Laya.stage.mouseX, Laya.stage.mouseY, null);
			var canStr:String;
			if (hitO[IDTools.getObjID(_node)])
			{
				trace("can hit");
				canStr = "can hit";
			}
			else
			{
				trace("can't hit");
				canStr = "can't hit";
			}
			var i:int, len:int;
			nodeList = nodeList.reverse();
			len = nodeList.length;
			var rstTxts:Array;
			rstTxts = ["[分析对象]:"+ClassTool.getNodeClassAndName(_node)+":"+canStr];
			for (i = 0; i < len; i++)
			{
				node = nodeList[i];
				if (hitO[IDTools.getObjID(node)])
				{
					trace("can hit:", ClassTool.getNodeClassAndName(node));
					trace("原因:", infoO[IDTools.getObjID(node)]);
					rstTxts.push("can hit:"+" "+ClassTool.getNodeClassAndName(node));
					rstTxts.push("原因:"+" "+infoO[IDTools.getObjID(node)]);
				}
				else
				{
					trace("can't hit:" + ClassTool.getNodeClassAndName(node));
					trace("原因:", infoO[IDTools.getObjID(node)] ? infoO[IDTools.getObjID(node)] : "鼠标事件在父级已停止派发");
					rstTxts.push("can't hit:" +" "+ ClassTool.getNodeClassAndName(node));
					rstTxts.push("原因:"+" "+(infoO[IDTools.getObjID(node)] ? infoO[IDTools.getObjID(node)] : "鼠标事件在父级已停止派发"));
				}
			}
			var rstStr:String;
			rstStr = rstTxts.join("\n");
			
			ToolPanel.I.showTxtInfo(rstStr);
			
		}
		private static var _matrix:Matrix = new Matrix();
		private static var _point:Point = new Point();
		private static var _rect:Rectangle = new Rectangle();
		
		public static function check(sp:Sprite, mouseX:Number, mouseY:Number, callBack:Function):Boolean
		{
			IDTools.idObj(sp);
			var isInAnlyseChain:Boolean;
			isInAnlyseChain = nodeO[IDTools.getObjID(sp)];
			var transform:Matrix = sp.transform || _matrix;
			var pivotX:Number = sp.pivotX;
			var pivotY:Number = sp.pivotY;
			
			//设置矩阵信息为相对父亲的偏移
			if (pivotX === 0 && pivotY === 0)
			{
				transform.setTranslate(sp.x, sp.y);
			}
			else
			{
				//如果有轴心旋转，则矩阵信息加上轴心的影响
				if (transform === _matrix)
				{
					transform.setTranslate(sp.x - pivotX, sp.y - pivotY);
				}
				else
				{
					var cos:Number = transform.cos;
					var sin:Number = transform.sin;
					transform.setTranslate(sp.x - (pivotX * cos - pivotY * sin) * sp.scaleX, sp.y - (pivotX * sin + pivotY * cos) * sp.scaleY);
				}
			}
			
			//变换鼠标坐标到节点坐标系
			transform.invertTransformPoint(_point.setTo(mouseX, mouseY));
			//重置transform
			transform.setTranslate(0, 0);
			mouseX = _point.x;
			mouseY = _point.y;
			
			//如果有裁剪，则先判断是否在裁剪范围内
			var scrollRect:Rectangle = sp.scrollRect;
			if (scrollRect)
			{
				_rect.setTo(0, 0, scrollRect.width, scrollRect.height);
				var isHit:Boolean = _rect.contains(mouseX, mouseY);
				if (!isHit)
				{
					if (isInAnlyseChain)
					{
						infoO[IDTools.getObjID(sp)] = "scrollRect没有包含鼠标" + _rect.toString() + ":" + mouseX + "," + mouseY;
					}
					return false;
				}
			}
			
			//先判定子对象是否命中
			
			var i:int, len:int;
			var cList:Array;
			cList = sp._childs;
			len = cList.length;
			var child:Sprite;
			var childInChain:Sprite;
			childInChain = null;
			for (i = 0; i < len; i++)
			{
				child = cList[i];
				IDTools.idObj(child);
				if (nodeO[IDTools.getObjID(child)])
				{
					childInChain = child;
					break;
				}
			}
			var coverByOthers:Boolean;
			coverByOthers = childInChain ? true : false;
			var flag:Boolean = false;
			//优先判断父对象
			if (sp.hitTestPrior && !sp.mouseThrough && !hitTest(sp, mouseX, mouseY)) {
				infoO[IDTools.getObjID(sp)] = "hitTestPrior=true，宽高区域不包含鼠标:" + ":" + mouseX + "," + mouseY+" size:"+sp.width+","+sp.height;
				return false;
			}
			for (i = sp._childs.length - 1; i > -1; i--)
			{
				child = sp._childs[i];
				if (child == childInChain)
				{
					if (!childInChain.mouseEnabled)
					{
						infoO[IDTools.getObjID(childInChain)] = "mouseEnabled=false";
					}
					if (!childInChain.visible)
					{
						infoO[IDTools.getObjID(childInChain)] = "visible=false";
					}
					coverByOthers = false;
				}
				//只有接受交互事件的，才进行处理
				if (child.mouseEnabled && child.visible)
				{
					flag = check(child, mouseX + (scrollRect ? scrollRect.x : 0), mouseY + (scrollRect ? scrollRect.y : 0), callBack);
					
					if (flag)
					{
						hitO[IDTools.getObjID(sp)] = true;
						infoO[IDTools.getObjID(sp)] = "子对象被击中";
						if (child == childInChain)
						{
							infoO[IDTools.getObjID(sp)] = "子对象被击中," + "击中对象在分析链中";
						}
						else
						{
							infoO[IDTools.getObjID(sp)] = "子对象被击中," + "击中对象不在分析链中";
							if (coverByOthers)
							{
								
								infoO[IDTools.getObjID(childInChain)] = "被兄弟节点挡住,兄弟节点信息:" + ClassTool.getNodeClassAndName(child) + "," + child.getBounds().toString();
								DebugTool.showDisBound(child, false,"#ffff00");
							}
						}
						
						return true;
					}
					else
					{
						if (child == childInChain)
						{
							coverByOthers = false;
						}
					}
				}
			}
			
			var mHitRect:Rectangle = new Rectangle();
			//判断是否在矩形区域内
			var graphicHit:Boolean = false;
			graphicHit=sp.getGraphicBounds().contains(mouseX, mouseY);
			if (sp.width > 0 && sp.height > 0)
			{
				
				var hitRect:Rectangle = _rect;
				if (!sp.mouseThrough)
				{
					if (sp.hitArea)
						hitRect = sp.hitArea;
					else
						hitRect.setTo(0, 0, sp.width, sp.height);
					mHitRect.copyFrom(hitRect);
					isHit = hitRect.contains(mouseX, mouseY);
				}
				else
				{
					//如果可穿透，则根据子对象实际大小进行碰撞
					isHit = graphicHit;
					mHitRect.copyFrom(sp.getGraphicBounds());
				}

				if (isHit)
				{
//					_target = sp;
					hitO[IDTools.getObjID(sp)] = true;
				}
			}else
			{
				
			}
			if (!isHit)
			{
				if (graphicHit)
				{
					infoO[IDTools.getObjID(sp)] = "子对象未包含鼠标，实际绘图区域包含鼠标，设置的宽高区域不包含鼠标:" + ":" + mouseX + "," + mouseY+" hitRec:"+mHitRect.toString()+" graphicBounds:"+sp.getGraphicBounds().toString()+"，设置mouseThrough=true或将宽高设置到实际绘图区域可解决问题";
				}else
				{
					infoO[IDTools.getObjID(sp)] = "子对象未包含鼠标，实际绘图区域不包含鼠标，设置的宽高区域不包含鼠标:" + ":" + mouseX + "," + mouseY+" hitRec:"+mHitRect.toString()+" graphicBounds:"+sp.getGraphicBounds().toString();
				}
				
			}
			else
			{
				infoO[IDTools.getObjID(sp)] = "自身区域被击中";
			}
			return isHit;
		}
		private static function hitTest(sp:Sprite, mouseX:Number, mouseY:Number):Boolean {
			var isHit:Boolean = false;
			if (sp.width > 0 && sp.height > 0 || sp.mouseThrough || sp.hitArea) {
				//判断是否在矩形区域内
				var hitRect:Rectangle = _rect;
				if (!sp.mouseThrough) {
					if (sp.hitArea) hitRect = sp.hitArea;
					else hitRect.setTo(0, 0, sp.width, sp.height);
					isHit = hitRect.contains(mouseX, mouseY);
				} else {
					//如果可穿透，则根据子对象实际大小进行碰撞
					isHit = sp.getGraphicBounds().contains(mouseX, mouseY);
				}
			}
			return isHit;
		}
	}

}