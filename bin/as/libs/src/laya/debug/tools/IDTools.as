///////////////////////////////////////////////////////////
//  IDTools.as
//  Macromedia ActionScript Implementation of the Class IDTools
//  Created on:      2015-10-29 上午9:45:33
//  Original author: ww
///////////////////////////////////////////////////////////

package laya.debug.tools
{
	
	
	/**
	 * 
	 * @author ww
	 * @version 1.0
	 * 
	 * @created  2015-10-29 上午9:45:33
	 */
	public class IDTools
	{
		public function IDTools()
		{
		}
		public var tID:int=1;
		public function getID():int
		{
			return tID++;
		}
		public static var _ID:IDTools=new IDTools();
		public static function getAID():int
		{
			return _ID.getID();
		}
		private static var _idDic:Object={"default":new IDTools()};
		public static function idObjE(obj:Object,sign:String="default"):Object
		{
			if (obj[idSign]) return obj;
			if(!sign)
			{
				sign="default";
			}
			if(!_idDic[sign])
			{
				_idDic[sign]=new IDTools();
			}
			obj[idSign]=_idDic[sign].getAID();
			return obj;
		}
		public static function setObjID(obj:Object, id:int):Object
		{
			obj[idSign] = id;
			return obj;
		}
		public static const idSign:String="_M_id_";
		public static function idObj(obj:Object):Object
		{
			if (obj[idSign]) return obj;
			obj[idSign]=getAID();
			return obj;
		}
		public static function getObjID(obj:Object):int
		{
			if(!obj) return -1;
			return obj[idSign];
		}
	}
}