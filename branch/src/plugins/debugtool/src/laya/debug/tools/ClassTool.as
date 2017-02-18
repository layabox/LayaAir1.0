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
		
		public static function getOwnPropertyNames(obj:Object):Array
		{
			var rst:Array;
			__JS__("rst=Object.getOwnPropertyNames(obj);");
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