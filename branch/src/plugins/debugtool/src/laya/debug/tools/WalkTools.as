///////////////////////////////////////////////////////////
//  WalkTools.as
//  Macromedia ActionScript Implementation of the Class WalkTools
//  Created on:      2015-9-24 下午6:15:01
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.display.Node;
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-9-24 下午6:15:01
	 */
	public class WalkTools
	{
		public function WalkTools()
		{
		}
		public static function walkTarget(target:Node,fun:Function,_this:*=null):void
		{			
			fun.apply(_this,[target]);
			var i:int;
			var len:int;
			var tChild:Node;
			len=target.numChildren;
			for(i=0;i<len;i++)
			{
				tChild=target.getChildAt(i);
//				fun.apply(_this,[tChild]);
				walkTarget(tChild,fun,tChild);
			}
		}
		public static function walkTargetEX(target:Node,fun:Function,_this:*=null,filterFun:Function=null):void
		{			
			if (filterFun != null && !filterFun(target)) return;
			fun.apply(_this,[target]);
			var i:int;
			var len:int;
			var tChild:Node;
			var childs:Array;
			childs = target._childs;
			len=childs.length;
			for(i=0;i<len;i++)
			{
				tChild=childs[i];
//				fun.apply(_this,[tChild]);
				walkTarget(tChild,fun,tChild);
			}
		}
		public static function walkChildren(target:Node,fun:Function,_this:*=null):void
		{
		     if(!target||target.numChildren<1) return;
			 walkArr(DisControlTool.getAllChild(target),fun,_this);
		}
		public static function walkArr(arr:Array,fun:Function,_this:*=null):void
		{
			if(!arr) return;
			var i:int;
			var len:int;
			len=arr.length;
			for(i=0;i<len;i++)
			{
				fun.apply(_this,[arr[i],i]);
			}
		}
	}
}