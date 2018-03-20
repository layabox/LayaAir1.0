///////////////////////////////////////////////////////////
//  DisControlTool.as
//  Macromedia ActionScript Implementation of the Class DisControlTool
//  Created on:      2015-9-25 下午7:19:44
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	
	import laya.debug.tools.resizer.DisResizer;
	import laya.debug.tools.resizer.SimpleResizer;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-9-25 下午7:19:44
	 */
	public class DisControlTool
	{
		public function DisControlTool()
		{
		}
		private static var tempP:Point = new Point();
		public static function getObjectsUnderPoint(sprite:Sprite,x:Number,y:Number,rst:Array=null,filterFun:Function=null):Array
		{
			rst=rst?rst:[];
			if(filterFun!=null&&!filterFun(sprite)) return rst;
			if (sprite.getBounds().contains(x, y))
			{
				rst.push(sprite);
//				var i:int, len:int = sprite.numChildren;
				var tS:Sprite;
				var tempP:Point=new Point();
				tempP.setTo(x, y);
				tempP = sprite.fromParentPoint(tempP);
				x = tempP.x;
				y = tempP.y;
				for (var i:int = sprite._childs.length - 1; i > -1; i--) {
					var child:Sprite = sprite._childs[i];
					if(child is Sprite)
						getObjectsUnderPoint(child,x,y,rst,filterFun);
				}

			}
			return rst;
		}
		public static function getObjectsUnderGlobalPoint(sprite:Sprite,filterFun:Function=null):Array
		{
			var point:Point = new Point();
			point.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
			if(sprite.parent)
			point = (sprite.parent as Sprite).globalToLocal(point);
			return getObjectsUnderPoint(sprite, point.x, point.y,null,filterFun);
		}
		public static function findFirstObjectsUnderGlobalPoint():Sprite
		{
			var disList:Array;
			disList = getObjectsUnderGlobalPoint(Laya.stage);
			if (!disList) return null;
			var i:int, len:int;
			var tDis:Sprite;
			len = disList.length;
			for (i = len-1; i>=0; i--)
			{
				tDis = disList[i];
				if (tDis && tDis.numChildren < 1)
				{
					return tDis;
				}
			}
			return tDis;
		}
		public static function visibleAndEnableObjFun(tar:Sprite):Boolean
		{
			return tar.visible&&tar.mouseEnabled;
		}
		public static function visibleObjFun(tar:Sprite):Boolean
		{
			return tar.visible;
		}
		public static function getMousePoint(sprite:Sprite):Point
		{
			var point:Point = new Point();
			point.setTo(Laya.stage.mouseX, Laya.stage.mouseY);
			point = sprite.globalToLocal(point);
			return point;
		}
		public static function isChildE(parent:Node, child:Node):Boolean
		{
			if (!parent) return false;
			while (child)
			{
				if (child.parent == parent) return true;
				child = child.parent;
			}
			return false;
		}
		public static function isInTree(pNode:Node, child:Node):Boolean
		{
			return pNode == child || isChildE(pNode,child);
		}
		public static function setTop(tar:Node):void
		{
			if(tar&&tar.parent)
			{
				var tParent:Node;
				tParent=tar.parent;
				tParent.setChildIndex(tar,tParent.numChildren-1);
			}
		}
		/**
		 * 清除对象上的相对布局数据
		 * @param items
		 *
		 */
		public static function clearItemRelativeInfo(item:Object):void
		{
			var Nan:* = "NaN";
			item.getLayout().left = Nan;
			item.getLayout().right = Nan;
			item.getLayout().top = Nan;
			item.getLayout().bottom = Nan;
		}
		public static function swap(tarA:Node, tarB:Node):void
		{
			if (tarA == tarB) return;
			var iA:int;
			iA = tarA.parent.getChildIndex(tarA);
			var iB:int;
			iB = tarB.parent.getChildIndex(tarB);
			var bP:Node;
			bP = tarB.parent;
			tarA.parent.addChildAt(tarB, iA);
			bP.addChildAt(tarA,iB);
		}
		public static function insertToTarParent(tarA:Node,tars:Array,after:Boolean=false):void
		{
			var tIndex:int;
			var parent:Node;
			if(!tarA) return;
			parent=tarA.parent;
			if(!parent) return;
			tIndex=parent.getChildIndex(tarA);
			if(after) tIndex++;
			insertToParent(parent,tars,tIndex);
		}
		public static function insertToParent(parent:Node,tars:Array,index:int=-1):void
		{
			if(!parent) return;
			if(index<0) index=parent.numChildren;
			var i:int,len:int;
			len=tars.length;
			for(i=0;i<len;i++)
			{
				transParent(tars[i],parent as Sprite);
				parent.addChildAt(tars[i],index);
			}
		}
		public static function transParent(tar:Sprite,newParent:Sprite):void
		{
			if(!tar||!newParent) return;
			if(!tar.parent) return;
			var preParent:Sprite;
			preParent=tar.parent as Sprite;
			var pos:Point;
			pos=new Point(tar.x,tar.y);
			pos=preParent.localToGlobal(pos);
			pos=newParent.globalToLocal(pos);
			tar.pos(pos.x,pos.y);
		}
		public static function transPoint(nowParent:Sprite,tarParent:Sprite,point:Point):Point
		{
			point=nowParent.localToGlobal(point);
			point=tarParent.globalToLocal(point);
			return point;
		}
		public static function removeItems(itemList:Array):void
		{
			var i:int, len:int;
			len = itemList.length;
			for (i = 0; i < len; i++)
			{
				(itemList[i] as Node).removeSelf();
			}
		}
		public static function addItems(itemList:Array,parent:Node):void
		{
			var i:int, len:int;
			len = itemList.length;
			for (i = 0; i < len; i++)
			{
				parent.addChild(itemList[i]);
			}
		}
		public static function getAllChild(tar:Node):Array
		{
			if(!tar) return [];
			var i:int;
			var len:int;
			var rst:Array=[];
			len=tar.numChildren;
			for(i=0;i<len;i++)
			{
				rst.push(tar.getChildAt(i));
			}
			return rst;
		}
		public static function upDis(child:Node):void
		{
			if(child&&child.parent)
			{
				var tParent:Node;
				tParent=child.parent;
				var newIndex:int;
				newIndex=tParent.getChildIndex(child)+1;
				if(newIndex>=tParent.numChildren)
				{
					newIndex=tParent.numChildren-1;
				}
				trace("setChildIndex:"+newIndex);
				tParent.setChildIndex(child,newIndex);
			}
		}
		public static function downDis(child:Node):void
		{
			if(child&&child.parent)
			{
				var tParent:Node;
				tParent=child.parent;
				var newIndex:int;
				newIndex=tParent.getChildIndex(child)-1;
				if(newIndex<0) newIndex=0;
				trace("setChildIndex:"+newIndex);
				tParent.setChildIndex(child,newIndex);
			}
		}
		public static function setResizeAbleEx(node:Sprite):void
		{
			var clickItem:Sprite;
			clickItem = node.getChildByName("resizeBtn") as Sprite;
			if (clickItem)
			{
				SimpleResizer.setResizeAble(clickItem, node);
			}
			//node.on(Event.CLICK, null, resizeHandler, [node]);
		}
		public static function setResizeAble(node:Sprite):void
		{
			node.on(Event.CLICK, null, resizeHandler, [node]);
		}
		public static function resizeHandler(tar:Sprite):void
		{
			DisResizer.setUp(tar);
		}
		public static function setDragingItem(dragBar:Sprite, tar:Sprite):void
		{
			dragBar.on(Event.MOUSE_DOWN, null, dragingHandler, [tar]);
			tar.on(Event.DRAG_END, null, dragingEnd, [tar]);
		}
		
		public static function dragingHandler(tar:Sprite):void
		{
			if (tar)
			{
				tar.startDrag();
			}
		}
		public static function dragingEnd(tar:Sprite):void
		{
			intFyDisPos(tar);
			trace(tar.x,tar.y);
		}
		public static function showToStage(dis:Sprite, offX:int = 0, offY:int = 0):void
		{
			var rec:Rectangle = dis.getBounds();
			dis.x = Laya.stage.mouseX + offX;
			dis.y = Laya.stage.mouseY + offY;
			if (dis.x + rec.width > Laya.stage.width)
			{
				dis.x -= rec.width + offX;
			}
			if (dis.y + rec.height > Laya.stage.height)
			{
				dis.y -= rec.height + offY;
				//dis.y -= 100;
			}
			intFyDisPos(dis);
		}
		public static function intFyDisPos(dis:Sprite):void
		{
			if (!dis) return;
			dis.x = Math.round(dis.x);
			dis.y = Math.round(dis.y);
		}
		public static function showOnly(disList:Array, showItem:Sprite):void
		{
			var i:int, len:int;
			len = disList.length;
			for (i = 0; i < len; i++)
			{
				disList[i].visible = disList[i] == showItem;
			}
		}
		public static function showOnlyByIndex(disList:Array, index:int):void
		{
			showOnly(disList, disList[index]);
		}
		public static function addOnly(disList:Array, showItem:Sprite,parent:Sprite):void
		{
			var i:int, len:int;
			len = disList.length;
			for (i = 0; i < len; i++)
			{
				if (disList[i] != showItem)
				{
					disList[i].removeSelf();
				}else
				{
					parent.addChild(disList[i]);
				}
			}
		}
		public static function addOnlyByIndex(disList:Array, index:int,parent:Sprite):void
		{
			addOnly(disList, disList[index],parent);
		}
	}
}