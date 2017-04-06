package laya.debug.tools 
{
	import laya.display.Sprite;
	/**
	 * ...
	 * @author ww
	 */
	public class ObjTimeCountTool 
	{
		
		public function ObjTimeCountTool() 
		{
			
		}
		public var timeDic:Object = { };
		public var resultDic:Object = { };
		
		public var countDic:Object = { };
		public var resultCountDic:Object = { };
		public var nodeDic:Object = { };
		public var resultNodeDic:Object = { };
		public function addTime(sprite:Sprite, time:int):void
		{
			IDTools.idObj(sprite);
			var key:int;
			key = IDTools.getObjID(sprite);
		    if (!timeDic.hasOwnProperty(key))
			{
				timeDic[key] = 0;
			}
			timeDic[key] = timeDic[key] + time;
			if (!countDic.hasOwnProperty(key))
			{
				countDic[key] = 0;
			}
			countDic[key] = countDic[key] +1;
			nodeDic[key] = sprite;
		}
		public function getTime(sprite:Sprite):int
		{
			IDTools.idObj(sprite);
			var key:int;
			key = IDTools.getObjID(sprite);
			if (!resultDic[key]) return 0;
			return resultDic[key];
		}
		public function getCount(sprite:Sprite):int
		{
			IDTools.idObj(sprite);
			var key:int;
			key = IDTools.getObjID(sprite);
			return resultCountDic[key];
		}
		public function reset():void
		{
			var key:String;
			for (key in timeDic)
			{
				timeDic[key] = 0;
				countDic[key] = 0;
			}
			ObjectTools.clearObj(nodeDic);
		}
		public function updates():void
		{
			ObjectTools.clearObj(resultDic);
			ObjectTools.insertValue(resultDic, timeDic);
			ObjectTools.clearObj(resultCountDic);
			ObjectTools.insertValue(resultCountDic, countDic);
			ObjectTools.insertValue(resultNodeDic, nodeDic);
			reset();
		}
	}

}