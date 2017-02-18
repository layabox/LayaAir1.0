///////////////////////////////////////////////////////////
//  VarHook.as
//  Macromedia ActionScript Implementation of the Class VarHook
//  Created on:      2015-10-23 下午2:52:48
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools.hook
{
	import laya.debug.tools.ClassTool;
	import laya.debug.tools.TraceTool;
	
	/**
	 * 本类用于监控对象 set get 函数的调用
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-23 下午2:52:48
	 */
	public class VarHook
	{
		public function VarHook()
		{
		}
		
		public static function hookVar(obj:Object,name:String,setHook:Array=null,getHook:Array=null):void
		{
			if(!setHook) setHook=[];
			if(!getHook) getHook=[];
			var preO:Object = obj;
			var preValue:*=obj[name];
			var des:Object;
			des=ClassTool.getOwnPropertyDescriptor(obj,name);
			var ndes:Object = { };
			var mSet:Function=function(value:*):void
			{
				trace("var hook set "+name+":",value);
				preValue=value;
			};
			
			var mGet:Function=function():*
			{
				trace("var hook get"+name+":",preValue);
				return preValue;
			}
			if(des)
			{
				
				
				ndes.set=mSet;
				ndes.get=mGet;
				ndes.enumerable=des.enumerable;
				setHook.push(ndes.set);
				getHook.push(ndes.get);
				FunHook.hookFuns(ndes,"set",setHook);
				FunHook.hookFuns(ndes,"get",getHook,getHook.length-1);
				//delete obj[name];
				ClassTool.defineProperty(obj,name,ndes);
				return;
			}
			while(!des&&obj["__proto__"])
			{
				
				obj=obj["__proto__"];
				des = ClassTool.getOwnPropertyDescriptor(obj, name);
				
				
			}
			if (des)
			{
				ndes.set=des.set?des.set:mSet;
				ndes.get=des.get?des.get:mGet;
				ndes.enumerable=des.enumerable;
				setHook.push(ndes.set);
				getHook.push(ndes.get);
				FunHook.hookFuns(ndes,"set",setHook);
				FunHook.hookFuns(ndes,"get",getHook,getHook.length-1);
				//delete obj[name];
				ClassTool.defineProperty(preO,name,ndes);
			}
			if(!des)
			{
				trace("get des fail add directly");
				ndes.set=mSet;
				ndes.get=mGet;
				//ndes.enumerable=des.enumerable;
				setHook.push(ndes.set);
				getHook.push(ndes.get);
				FunHook.hookFuns(ndes,"set",setHook);
				FunHook.hookFuns(ndes,"get",getHook,getHook.length-1);
				//delete obj[name];
				ClassTool.defineProperty(obj,name,ndes);
			}
			
			
			
		}
		
		public static function getLocFun(msg:String="",level:int=0):Function
		{
			level += 1;
			
			var rst:Function;
			rst=function ():void
			{
				FunHook.traceLoc(level,msg);
			}
			return rst;
		}
		
	}
}