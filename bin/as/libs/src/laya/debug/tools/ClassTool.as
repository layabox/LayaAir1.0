///////////////////////////////////////////////////////////
//  ClassTool.as
//  Macromedia ActionScript Implementation of the Class ClassTool
//  Created on:      2015-10-23 下午2:24:04
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-23 下午2:24:04
	 */
	public class ClassTool
	{
		public function ClassTool()
		{
		}
		
		public static function defineProperty(obj:Object,name:String,des:Object):void
		{
			__JS__("Object.defineProperty(obj,name,des);");
		}
		
		public static function getOwnPropertyDescriptor(obj:Object,name:String):Object
		{
			var rst:Object;
			__JS__("rst=Object.getOwnPropertyDescriptor(obj,name);");
			return rst;
		}
		public static function getOwnPropertyDescriptors(obj:Object):Object
		{
			var rst:Object;
			__JS__("rst=Object.getOwnPropertyDescriptors(obj);");
			return rst;
		}
		public static function getOwnPropertyNames(obj:Object):Array
		{
			var rst:Array;
			__JS__("rst=Object.getOwnPropertyNames(obj);");
			return rst;
		}
		public static function getObjectGetSetKeys(obj:Object,rst:Array=null):Array
		{
			if (!rst) rst = [];
			var keys:Array;
			//keys = ClassTool.getOwnPropertyDescriptors(obj);
			keys = ClassTool.getOwnPropertyNames(obj);
			//trace("keys", getOwnPropertyNames(obj));
			//trace("keys", Object.getOwnPropertySymbols(obj));
			//trace("keys",Object.keys(obj));
			var key:String;
			for (key in keys)
			{
				key = keys[key];
				if (key.indexOf("_$get_")>=0)
				{
					key = key.replace("_$get_", "");
					rst.push(key);
				}
			}
			if (obj["__proto__"])
			{
				getObjectGetSetKeys(obj["__proto__"],rst);
			}
			return rst;
		}
		
		public static var displayTypes:Object = { "boolean":true, "number":true, "string":true };
		public static function getObjectDisplayAbleKeys(obj:Object,rst:Array=null):Array
		{
			if (!rst) rst = [];
			var key:String;
			var tValue:*;
			var tType:String;
			for (key in obj)
			{
				tValue = obj[key];
				tType = typeof(tValue);
				if (key.charAt(0) == "_") continue;

				rst.push(key);
				
			}
			getObjectGetSetKeys(obj, rst);
			rst = ObjectTools.getNoSameArr(rst);
			return rst;
		}
		public static function getClassName(tar:Object):String
		{
			if (tar is Function) return tar.name;
			return tar["constructor"].name;
		}
		public static function getNodeClassAndName(tar:Object):String
		{
			if (!tar) return "null";
			var rst:String;
			if (tar.name)
			{
				rst = getClassName(tar) + "("+tar.name+")";
			}else
			{
				rst = getClassName(tar);
			}
			return rst;
		}
		public static function getClassNameByClz(clz:Class):String
		{
			return clz["name"];
		}
		public static function getClassByName(className:String):Class
		{
			var rst:Class;
			rst=__JS__("eval(className)");
			return rst;
		}
		public static function createObjByName(className:String):*
		{
			var clz:Class;
			clz=getClassByName(className);
			return new clz();
		}
	}
}