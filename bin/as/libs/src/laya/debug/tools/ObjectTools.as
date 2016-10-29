///////////////////////////////////////////////////////////
//  ObjectTools.as
//  Macromedia ActionScript Implementation of the Class ObjectTools
//  Created on:      2015-10-21 下午2:03:36
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	import laya.display.Sprite;
	import laya.utils.Utils;
	
	/**
	 * 本类提供obj相关的一些操作
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-21 下午2:03:36
	 */
	public class ObjectTools
	{
		public function ObjectTools()
		{
		}
		public static var sign:String="_";
		public static function getFlatKey(tKey:String,aKey:String):String
		{
			if(tKey=="") return aKey;
			return tKey+sign+aKey;
		}
		public static function flatObj(obj:Object,rst:Object=null,tKey:String=""):Object
		{
			rst=rst?rst:{};
			var key:String;
			var tValue:*;
			for(key in obj)
			{
				if(obj[key] is Object)
				{
					flatObj(obj[key],rst,getFlatKey(tKey,key));
				}else
				{
					tValue=obj[key];
					//if(tValue is String||tValue is Number)
					rst[getFlatKey(tKey,key)]=obj[key];
				}
			}
			
			return rst;
		}
		public static function recoverObj(obj:Object):Object
		{
			var rst:Object={};
			var tKey:String;
			for(tKey in obj)
			{
				setKeyValue(rst,tKey,obj[tKey]);
			}
			return rst;
			
		}
		public static function differ(objA:Object,objB:Object):Object
		{
			var tKey:String;
			var valueA:String;
			var valueB:String;
			objA=flatObj(objA);
			objB=flatObj(objB);
			
			var rst:Object={};
			for(tKey in objA)
			{
				if(!objB.hasOwnProperty(tKey))
				{
					rst[tKey]="被删除";
				}
			}
			
			for(tKey in objB)
			{
				if(objB[tKey]!=objA[tKey])
				{
					rst[tKey]={"pre":objA[tKey],"now":objB[tKey]};
				}
			}
			
			return rst;
		}
		public static function traceDifferObj(obj:Object):void
		{
			var key:String;
			var tO:Object;
			for(key in obj)
			{
				if(obj[key] is String)
				{
					trace(key+":",obj[key]);
				}else
				{
					tO=obj[key];
					trace(key+":","now:",tO["now"],"pre:",tO["pre"]);
				}
			}
		}
		public static function setKeyValue(obj:Object,flatKey:String,value:*):void
		{
			if(flatKey.indexOf(sign)>=0)
			{
				var keys:Array=flatKey.split(sign);
				var tKey:String;
				while(keys.length>1)
				{
					tKey=keys.shift();
					if(!obj[tKey])
					{
						obj[tKey]={};
						trace("addKeyObj:",tKey);
					}
					obj=obj[tKey];
					if(!obj)
					{
						trace("wrong flatKey:",flatKey);
						return;
					}
				}
				obj[keys.shift()]=value;
			}else
			{
				obj[flatKey]=value;
			}
		}
		public static function clearObj(obj:Object):void
		{
			var key:String;
			for (key in obj)
			{
				delete obj[key];
			}
		}
		public static function copyObjFast(obj:Object):Object
		{
			var jsStr:String;
			jsStr=ObjectTools.getJsonString(obj);
			return ObjectTools.getObj(jsStr);
			
		}
		public static function copyObj(obj:Object):Object
		{
			if(obj is Array) return copyArr(obj as Array);
			var rst:Object={};
			var key:String;
			for(key in obj)
			{
				if(obj[key] is Array)
				{
					rst[key]=copyArr(obj[key]);
				}
				else
					if(obj[key] is Object)
					{
						rst[key]=copyObj(obj[key]);
					}else
					{
						rst[key]=obj[key];
					}
			}
			return rst;
		}
		public static function copyArr(arr:Array):Array
		{
			var rst:Array;
			rst=[];
			var i:int,len:int;
			len=arr.length;
			for(i=0;i<len;i++)
			{
				rst.push(copyObj(arr[i]));
			}
			return rst;
		}
		public static function concatArr(src:Array, a:Array):Array {
			if (!a) return src;
			if (!src) return a;
			var i:int, len:int = a.length;
			for (i = 0; i < len; i++) {
				src.push(a[i]);
			}
			return src;
		}
		
		public static function clearArr(arr:Array):Array {
			if (!arr) return arr;
			arr.length = 0;
			return arr;
		}
		
		public static function removeFromArr(arr:Array,item:*):void
		{
			var i:int,len:int;
			len=arr.length;
			for(i=0;i<len;i++)
			{
				if(arr[i]==item)
				{
					arr[i].splice(i,1);
					return;
				}
			}
		}
		public static function setValueArr(src:Array, v:Array):Array {
			src || (src = []);
			src.length = 0;
			return concatArr(src, v);
		}
		
		public static function getFrom(rst:Array, src:Array, count:int):Array {
			var i:int;
			for (i = 0; i < count; i++) {
				rst.push(src[i]);
			}
			return rst;
		}
		
		public static function getFromR(rst:Array, src:Array, count:int):Array {
			var i:int;
			for (i = 0; i < count; i++) {
				rst.push(src.pop());
			}
			return rst;
		}
		public static function enableDisplayTree(dis:Sprite):void {
			
			while (dis) {
				dis.mouseEnabled = true;
				dis = dis.parent as Sprite;
			}
		}
		public static function getJsonString(obj:Object):String
		{
			var rst:String;
			__JS__("rst=JSON.stringify(obj)");
			return rst;
		}
		public static function getObj(jsonStr:String):Object
		{
			var rst:Object;
			__JS__("rst=JSON.parse(jsonStr)");
			return rst;
		}
		
		public static function getKeyArr(obj:Object):Array
		{
			var rst:Array;
			var key:String;
			rst=[];
			for(key in obj)
			{
				rst.push(key);
			}
			return rst;
		}
		public static function getObjValues(dataList:Array,key:String):Array
		{
			var rst:Array;
			var i:int,len:int;
			len=dataList.length;
			rst=[];
			for(i=0;i<len;i++)
			{
				rst.push(dataList[i][key]);
			}
			return rst;
		}
		public static function hasKeys(obj:Object,keys:Array):Boolean
		{
			var i:int,len:int;
			len=keys.length;
			for(i=0;i<len;i++)
			{
				if(!obj.hasOwnProperty(keys[i])) return false;
			}
			return true;
		}
		public static function copyValueByArr(tar:Object,src:Object,keys:Array):void
		{
			var i:int,len:int=keys.length;
			for(i=0;i<len;i++)
			{
				if(!(src[keys[i]]===null))
					tar[keys[i]]=src[keys[i]];
			}
		}
		public static function insertValue(tar:Object, src:Object):void
		{
			var key:String;
			for (key in src)
			{
				tar[key] = src[key];
			}
		}
		public static function replaceValue(obj:Object,replaceO:Object):void
		{
			var key:String;
			for(key in obj)
			{
				if(replaceO.hasOwnProperty(obj[key]))
				{
					obj[key]=replaceO[obj[key]];
				}
				if(obj[key] is Object)
				{
					replaceValue(obj[key],replaceO);
				}
			}
		}
		public static function setKeyValues(items:Array,key:String,value:*):void
		{
			var i:int,len:int;
			len=items.length;
			for(i=0;i<len;i++)
			{
				items[i][key]=value;
			}
		}
		public static function findItemPos(items:Array,sign:String,value:*):int
		{
			var i:int,len:int;
			len=items.length;
			for(i=0;i<len;i++)
			{
				if(items[i][sign]==value)
				{
					return i;
				}
			}
			return -1;
		}
		public static function setObjValue(obj:Object,key:String,value:*):Object
		{
			obj[key]=value;
			return obj;
		}
		public static function setAutoTypeValue(obj:Object,key:String,value:*):Object
		{
			if(obj.hasOwnProperty(key))
			{
				if(isNumber(obj[key]))
				{
					obj[key]=parseFloat(value);
				}else
				{
					obj[key]=value;
				}
			}else
			{
				obj[key]=value;
			}
			return obj;
		}
		public static function getAutoValue(value:*):*
		{
			if (parseFloat(value)==value) return parseFloat(value);
			return value;
		}
		public static function isNumber(value:*):Boolean
		{
			return  (parseFloat(value)==value);
		}
		public static function isNaNS(value:*):Boolean
		{
			return ( value.toString()=="NaN");
		}
		public static function isNaN(value:*):Boolean
		{
			if(typeof(value)=="number") return false;
			if(typeof(value)=="string")
			{
				if(parseFloat(value).toString()!="NaN")
				{
					if(parseFloat(value)==value)
					{
						return false;
					}
				}
			}
			return true;
//			if(value===undefined) return true;
//			if(value ===null) return true;
//			if( value.toString()=="NaN") return true;
//			if(value===true) return false;
//			if(value ===false) return false;
//			if(value is String)
//			{
//				if(parseFloat(value)==value) return false;
//			}
//			return true;
			//			return !isNumber(value);
		}
		public static function getStrTypedValue(value:String):*
		{
			if(value=="false")
			{
				return false;
			}else
				if(value=="true")
				{
					return true;
				}else
					if(value=="null")
					{
						return null;
					}else
						if(value=="undefined")
						{
							return null;
						}else
						{
							return getAutoValue(value);
						}
		}
		public static function createKeyValueDic(dataList:Array,keySign:String):Object
		{
			var rst:Object;
			rst={};
			var i:int,len:int;
			len=dataList.length;
			var tItem:Object;
			var tKey:String;
			for(i=0;i<len;i++)
			{
				tItem=dataList[i];
				tKey=tItem[keySign];
				rst[tKey]=tItem;
			}
			return rst;
		}
	}
}