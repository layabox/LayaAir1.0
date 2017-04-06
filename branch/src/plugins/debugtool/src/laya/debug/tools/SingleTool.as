///////////////////////////////////////////////////////////
//  SingleTool.as
//  Macromedia ActionScript Implementation of the Class SingleTool
//  Created on:      2016-6-24 下午6:07:30
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2016-6-24 下午6:07:30
	 */
	public class SingleTool
	{
		public function SingleTool()
		{
		}
		public static var I:SingleTool=new SingleTool();
		private var _objDic:Object={};
		public function getArr(sign:String):Array
		{
			var dic:Object;
			dic=getTypeDic("Array");
			if(!dic[sign]) dic[sign]=[];
			return dic[sign];
		}
		public function getObject(sign:String):Object
		{
			var dic:Object;
			dic=getTypeDic("Object");
			if(!dic[sign]) dic[sign]={};
			return dic[sign];
		}
		public function getByClass(sign:String,clzSign:String,clz:Class):*
		{
			var dic:Object;
			dic=getTypeDic(clzSign);
			if(!dic[sign]) dic[sign]=new clz();
			return dic[sign];
		}
		public function getTypeDic(type:String):Object
		{
			if(!_objDic[type]) _objDic[type]={};
			return _objDic[type];
		}
	}
}