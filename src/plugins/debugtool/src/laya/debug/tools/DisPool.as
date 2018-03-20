///////////////////////////////////////////////////////////
//  DisPool.as
//  Macromedia ActionScript Implementation of the Class DisPool
//  Created on:      2015-11-13 下午8:05:13
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	
	/**
	 * 简单的显示对象对象池
	 * 从父容器上移除时即被视为可被重用
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-11-13 下午8:05:13
	 */
	public class DisPool
	{
		public function DisPool()
		{
		}
		private static var _objDic:Object={};
		public static function getDis(clz:Class):*
		{
			var clzName:String;
			clzName=ClassTool.getClassNameByClz(clz);
			if(!_objDic[clzName])
			{
				_objDic[clzName]=[];
			}
			var disList:Array;
			disList=_objDic[clzName];
			var i:int,len:int;
			len=disList.length;
			for(i=0;i<len;i++)
			{
				if(!disList[i].parent)
				{
					return disList[i];
				}
			}
			disList.push(new clz());
			return disList[disList.length-1];
		}
		
	}
}