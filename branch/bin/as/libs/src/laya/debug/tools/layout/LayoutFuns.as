package laya.debug.tools.layout
{
	import laya.display.Sprite;
	
	/**
	 * ...
	 * @author ww
	 */
	public class LayoutFuns
	{
		
		public function LayoutFuns()
		{
		
		}
		
		/**
		 * 水平等宽布局
		 * @param totalWidth
		 * @param items
		 * @param data
		 * @param sX
		 *
		 */
		public static function sameWidth(totalWidth:Number, items:Array, data:Object = null, sX:Number = 0):void
		{
			var dWidth:Number = 0;
			if (data && data.dWidth)
				dWidth = data.dWidth;
			var perWidth:Number;
			perWidth = (totalWidth - (items.length - 1) * dWidth) / items.length;
			var tItem:Sprite;
			var i:int, len:int;
			var tX:Number;
			tX = sX;
			len = items.length;
			for (i = 0; i < len; i++)
			{
				tItem = items[i];
				tItem.x = tX;
				tItem.width = perWidth;
				tX += dWidth + perWidth;
			}
		}
		
		public static function getSameWidthLayout(items:Array, dWidth:Number):Layouter
		{
			var data:Object;
			data = {};
			data.dWidth = dWidth;
			return getLayouter(items, data, LayoutFuns.sameWidth);
		}
		
		public static function getLayouter(items:Array, data:Object, fun:Function):Layouter
		{
			var layouter:Layouter;
			layouter = new Layouter();
			layouter.items = items;
			layouter.data = data;
			layouter.layoutFun = fun;
			return layouter;
		}
		
		/**
		 * 水平等间距布局
		 * @param totalWidth
		 * @param items
		 * @param data
		 * @param sX
		 *
		 */
		public static function sameDis(totalWidth:Number, items:Array, data:Object = null, sX:Number = 0):void
		{
			var dWidth:Number;
			dWidth = totalWidth;
			var tItem:Sprite;
			var i:int, len:int;
			len = items.length;
			prepareForLayoutWidth(totalWidth, items);
			for (i = 0; i < len; i++)
			{
				tItem = items[i];
				dWidth -= tItem.width;
			}
			if (items.length > 1)
				dWidth = dWidth / (items.length - 1);
			var tX:Number;
			tX = sX;
			len = items.length;
			for (i = 0; i < len; i++)
			{
				tItem = items[i];
				tItem.x = tX;
				tX += dWidth + tItem.width;
			}
		}
		
		public static function getSameDisLayout(items:Array, rateSame:Boolean = false):Layouter
		{
			var data:Object;
			data = {};
			if (rateSame)
			{
				var i:int, len:int;
				len = items.length;
				var tItem:Sprite;
				var totalWidth:Number;
				totalWidth = 0;
				for (i = 0; i < len; i++)
				{
					tItem = items[i];
					totalWidth += tItem.width;
				}
				totalWidth = tItem.x + tItem.width;
				for (i = 0; i < len; i++)
				{
					tItem = items[i];
					setItemRate(tItem, tItem.width / totalWidth);
				}
			}
			
			return getLayouter(items, data, LayoutFuns.sameDis);
		}
		
		/**
		 * 水平铺满布局
		 * @param totalWidth
		 * @param items
		 * @param data
		 * @param sX
		 *
		 */
		public static function fullFill(totalWidth:Number, items:Array, data:Object = null, sX:Number = 0):void
		{
			var dL:Number = 0, dR:Number = 0;
			if (data)
			{
				if (data.dL)
					dL = data.dL;
				if (data.dR)
					dR = data.dR;
			}
			var item:Sprite;
			var i:int, len:int;
			len = items.length;
			for (i = 0; i < len; i++)
			{
				item = items[i];
				item.x = sX + dL;
				item.width = totalWidth - dL - dR;
			}
		
		}
		
		public static function getFullFillLayout(items:Array, dL:Number = 0, dR:Number = 0):Layouter
		{
			var data:Object;
			data = {};
			data.dL = dL;
			data.dR = dR;
			return getLayouter(items, data, LayoutFuns.fullFill);
		}
		
		/**
		 * 水平固定x绝对值或者比例布局, 并用最后一个元素铺满布局宽
		 * @param totalWidth
		 * @param items
		 * @param data
		 * @param sX
		 *
		 */
		public static function fixPos(totalWidth:Number, items:Array, data:Object = null, sX:Number = 0):void
		{
			var dLen:Number = 0;
			var poss:Array = [];
			var isRate:Boolean = false;
			if (data)
			{
				if (data.dLen)
					dLen = data.dLen;
				if (data.poss)
					poss = data.poss;
				if (data.isRate)
					isRate = data.isRate;
			}
			var item:Sprite;
			var i:int, len:int;
			len = poss.length;
			var tX:Number;
			tX = sX;
			var tValue:Number;
			var preItem:Sprite;
			preItem = null;
			for (i = 0; i < len; i++)
			{
				item = items[i];
				tValue = sX + poss[i];
				if (isRate)
				{
					tValue = sX + poss[i] * totalWidth;
				}
				item.x = tValue;
				if (preItem)
				{
					preItem.width = item.x - dLen - preItem.x;
				}
				preItem = item;
			}
			var lastItem:Sprite;
			lastItem = items[items.length - 1];
			lastItem.width = sX + totalWidth - dLen - lastItem.x;
		}
		
		public static function getFixPos(items:Array, dLen:Number = 0, isRate:Boolean = false, poss:Array = null):Layouter
		{
			var data:Object;
			data = {};
			var layout:Layouter;
			layout = getLayouter(items, data, fixPos);
			var i:int, len:int;
			var sX:Number;
			var totalWidth:Number;
			sX = layout.x;
			totalWidth = layout.width;
			if (!poss)
			{
				poss = [];
				len = items.length;
				var tValue:Number;
				for (i = 0; i < len; i++)
				{
					tValue = items[i].x - sX;
					if (isRate)
					{
						tValue = tValue / totalWidth;
					}
					else
					{
						
					}
					poss.push(tValue);
				}
			}
			
			data.dLen = dLen;
			data.poss = poss;
			data.isRate = isRate;
			return layout;
		}
		
		/**
		 * 清除对象上的相对布局数据
		 * @param items
		 *
		 */
		public static function clearItemsRelativeInfo(items:Array):void
		{
			var i:int, len:int;
			len = items.length;
			for (i = 0; i < len; i++)
			{
				clearItemRelativeInfo(items[i]);
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
		}
		
		public static const RateSign:String = "layoutRate";
		
		public static function prepareForLayoutWidth(totalWidth:Number, items:Array):void
		{
			var i:int, len:int;
			len = items.length;
			for (i = 0; i < len; i++)
			{
				prepareItemForLayoutWidth(totalWidth, items[i]);
			}
		}
		public static function getSumWidth(items:Array):Number
		{
			var sum:Number;
			sum=0;
			var i:int, len:int;
			len = items.length;
			for (i = 0; i < len; i++)
			{
				sum+=items[i].width;
			}
			return sum;
		}
		public static function prepareItemForLayoutWidth(totalWidth:Number, item:Object):void
		{
			if (getItemRate(item) > 0)
			{
				item.width = totalWidth * getItemRate(item);
			}
		}
		
		public static function setItemRate(item:Object, rate:Number):void
		{
			item[RateSign] = rate;
		}
		
		public static function getItemRate(item:Object):Number
		{
			return item[RateSign] ? item[RateSign] : -1;
		}
		
		
		public static const FreeSizeSign:String="layoutFreeSize";
		public static function setItemFreeSize(item:Object,free:Boolean=true):void
		{
			item[FreeSizeSign]=free;
	    }
		public static function isItemFreeSize(item:Object):Boolean
		{
			return item[FreeSizeSign];
		}
		
		/**
		 * 锁定间距布局，需要有一个对象为freeSize，表示通过调整该对象大小来铺满宽 
		 * @param totalWidth
		 * @param items
		 * @param data
		 * @param sX
		 * 
		 */
		public static function lockedDis(totalWidth:Number, items:Array, data:Object = null, sX:Number = 0):void
		{
			var dists:Array;
			dists=data.dists;
			var sumDis:Number;
			sumDis=data.sumDis;
			
			var sumWidth:Number;
			
			
			
			var i:int,len:int;
			var tItem:Sprite;
			var preItem:Sprite;
			prepareForLayoutWidth(totalWidth,items);
			
			sumWidth=getSumWidth(items);
			var dWidth:Number;
			dWidth=totalWidth-sumDis-sumWidth;
			
			var freeItem:Sprite;
			freeItem=getFreeItem(items);
			if(freeItem)
			{
				freeItem.width+=dWidth;
			}
			
			preItem=items[0];
			preItem.x=sX;
			len=items.length;
			for(i=1;i<len;i++)
			{
				tItem=items[i];
				tItem.x=preItem.x+preItem.width+dists[i-1];
				preItem=tItem;
			}
			
			
		}
		public static function getFreeItem(items:Array):Sprite
		{
			var i:int, len:int;
			len = items.length;
			for (i = 0; i < len; i++)
			{
				if(isItemFreeSize(items[i]))
				{
					return items[i];
				}
			}
			return null;
		}
		public static function getLockedDis(items:Array):Layouter
		{
			var data:Object;
			data = {};
			
			var dists:Array;
			var i:int,len:int;
			var tItem:Sprite;
			var preItem:Sprite;
			
			var sumDis:Number;
			sumDis=0;
			var tDis:Number;
			preItem=items[0];
			dists=[];
			len=items.length;
			for(i=1;i<len;i++)
			{
				tItem=items[i];
				tDis=tItem.x-preItem.x-preItem.width;
				dists.push(tDis);
				sumDis+=tDis;
				preItem=tItem;
			}
			
			data.dists=dists;
			data.sumDis=sumDis;
			
			return getLayouter(items, data, LayoutFuns.lockedDis);
		}
	
	}

}