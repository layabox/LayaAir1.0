package laya.debug.view.nodeInfo.recinfos 
{
	import laya.debug.tools.ClassTool;
	/**
	 * ...
	 * @author ww
	 */
	public class ReCacheRecInfo extends NodeRecInfo 
	{
		
		public function ReCacheRecInfo() 
		{
			super();
			txt.fontSize = 12;
		}
		public function addCount(time:int=0):void
		{
			count++;
			mTime += time;
			if (!isWorking)
			{
				working = true;
			}
		}
		public var isWorking:Boolean = false;
		public var count:int;
		public var mTime:int = 0;
		public static const showTime:int = 3000;
		public function updates():void
		{
			if (!_tar["displayedInStage"])
			{
				working = false;
				removeSelf();
			}
			txt.text = ClassTool.getNodeClassAndName(_tar)+"\n"+"reCache:" + count+"\ntime:"+mTime;
			if (count > 0)
			{
				
				fresh();

				Laya.timer.clear(this, removeSelfLater);
			}else
			{
				
				working = false;
				Laya.timer.once(showTime, this, removeSelfLater);
			}
			count = 0;
		    mTime = 0;
		}
		private function removeSelfLater():void
		{
			working = false;
			removeSelf();
		}
		public function set working(v:Boolean):void
		{
			isWorking = v;
			if (v)
			{
				Laya.timer.loop(1000, this, updates);
			}else
			{
				Laya.timer.clear(this,updates);
			}
		}
	}

}