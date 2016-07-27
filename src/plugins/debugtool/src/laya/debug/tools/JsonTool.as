///////////////////////////////////////////////////////////
//  JsonTool.as
//  Macromedia ActionScript Implementation of the Class JsonTool
//  Created on:      2015-11-27 上午9:58:59
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-11-27 上午9:58:59
	 */
	public class JsonTool
	{
		public function JsonTool()
		{
		}
		public static var singleLineKey:Object=
			{
				"props":true
			};
		public static function getJsonString(obj:Object,singleLine:Boolean=true,split:String="\n",depth:int=0,Width:int=4):String
		{
			
			
			var preStr:String="";
			preStr=getEmptyStr(depth*Width);
			
			
			var rst:String;
			
			var keyValues:Object;
			keyValues={};
			var tKey:String;
			var tValue:*;
			var type:String;
			var keys:Array;
			keys=[];
			for(tKey in obj)
			{
				keys.push(tKey);
				tValue=obj[tKey];
				if(singleLineKey[tKey])
				{
					keyValues[tKey]=getValueStr(tValue,true,split,depth+1,Width);
				}else
				{
					keyValues[tKey]=getValueStr(tValue,singleLine,split,depth+1,Width);
				}
				
			}
			
			var i:int,len:int;
			len=keys.length;
			
			keys.sort();
			keys = keys.reverse();
			var keyPreStr:String;
			keyPreStr=getEmptyStr((depth+1)*Width);
			if(singleLine)
			{
				split="";
				preStr = "";
				keyPreStr = "";
			}
			var keyValueStrArr:Array;
			keyValueStrArr = [];
			
			for(i=0;i<len;i++)
			{
				tKey=keys[i];
				keyValueStrArr.push(keyPreStr+wrapValue(tKey)+":"+keyValues[tKey]);
			}
			rst="{"+split+keyValueStrArr.join(","+split)+split+preStr+"}";
			return rst;
		}
		private static function wrapValue(value:String,wraper:String="\""):String
		{
			return wraper+value+wraper;
		}
		
		private static function  getArrStr(arr:Array,singleLine:Boolean=true,split:String="\n",depth:int=0,Width:int=4):String
		{
			var rst:String;
			
			var i:int,len:int;
			len=arr.length;
			var valueStrArr:Array;
			valueStrArr=[];
			for(i=0;i<len;i++)
			{
				valueStrArr.push(getValueStr(arr[i],singleLine,split,depth+1,Width));
			}
			var preStr:String="";
			preStr=getEmptyStr((depth+1)*Width);
			if(singleLine)
			{
				split="";
				preStr="";
			}
			rst="["+split+preStr+valueStrArr.join(","+split+preStr)+"]";
			return rst;
		}
		private static function getValueStr(tValue:*,singleLine:Boolean=true,split:String="\n",depth:int=0,Width:int=0):String
		{
			var rst:String;
			if(tValue is String )
			{
				rst="\""+tValue+"\"";
			}else if(tValue ==null)
			{
				rst="null";
			}else if(tValue is Number||tValue is int||tValue is Boolean)
			{
				rst=tValue;
			}else if(tValue is Array)
			{
				rst=getArrStr(tValue,singleLine,split,depth,Width);
			}else if(tValue is Object)
			{
				rst=getJsonString(tValue,singleLine,split,depth,Width);
			}else
			{
				rst=tValue;
			}
			return rst;
		}
		
		public static var emptyDic:Object={};
		public static function getEmptyStr(width:int):String
		{
			if(!emptyDic.hasOwnProperty(width))
			{
				var i:int;
				var len:int;
				len=width;
				var rst:String;
				rst="";
				for(i=0;i<len;i++)
				{
					rst+=" ";
				}
				emptyDic[width]=rst;
			}
			return emptyDic[width];
		}
	}
}