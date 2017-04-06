package laya.debug.tools 
{
	import laya.debug.DebugTool;
	import laya.display.Sprite;
	import laya.debug.view.nodeInfo.DebugInfoLayer;
	import laya.debug.view.nodeInfo.recinfos.ReCacheRecInfo;
	/**
	 * ...
	 * @author ww
	 */
	public class CacheAnalyser 
	{
		
		public function CacheAnalyser() 
		{
			
		}
		public static function renderLoopBegin():void
		{
			DebugInfoLayer.I.cacheViewLayer.graphics.clear();
		}
		public static var counter:ObjTimeCountTool = new ObjTimeCountTool();
		public static var I:CacheAnalyser = new CacheAnalyser();
		private static var _nodeInfoDic:Object = { };
		public static var showCacheSprite:Boolean = false;
		public static var showRecacheSprite:Boolean = true;
		public static function getNodeInfoByNode(node:Sprite):ReCacheRecInfo
		{
			IDTools.idObj(node);
			var key:int;
			key = IDTools.getObjID(node);
			if (!_nodeInfoDic[key])
			{
				_nodeInfoDic[key] = new ReCacheRecInfo();
			}
			(_nodeInfoDic[key] as ReCacheRecInfo).setTarget(node);
			return _nodeInfoDic[key];
		}
		public function renderCanvas(sprite:Sprite,time:int=0):void
		{
			if (!showCacheSprite) return;
			if (DebugInfoLayer.I.isDebugItem(sprite)) return;
			DebugTool.showDisBoundToSprite(sprite, DebugInfoLayer.I.cacheViewLayer, DebugConsts.CANVAS_REC_COLOR, 4);
		}
		public function reCacheCanvas(sprite:Sprite,time:int=0):void
		{
			if (!showRecacheSprite) return;
			if (DebugInfoLayer.I.isDebugItem(sprite)) return;
			var info:ReCacheRecInfo;
			info = getNodeInfoByNode(sprite);
			info.addCount(time);
			counter.addTime(sprite, time);
			if (!info.parent)
			{
				DebugInfoLayer.I.nodeRecInfoLayer.addChild(info);
			}
		}
	}

}