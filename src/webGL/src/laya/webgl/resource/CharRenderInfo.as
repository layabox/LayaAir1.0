package laya.webgl.resource {
	import laya.display.Stage;
	import laya.utils.Stat;
	/**
	 * TODO如果占用内存较大,这个结构有很多成员可以临时计算
	 */
	public class CharRenderInfo {
		public var char:String='';				// 调试用
		public var tex:*;						//
		public var deleted:Boolean = false; 	// 已经被删除了
		public var uv:Array = new Array(8);// [0, 0, 1, 1];		//uv
		public var pos:int = 0;					//数组下标
		public var width:int;					//字体宽度。测量的宽度，用来排版。没有缩放
		public var height:int; 				//字体高度。没有缩放
		public var bmpWidth:int ;				//实际图片的宽度。可能与排版用的width不一致。包含缩放和margin
		public var bmpHeight:int;
		public var orix:int = 0;				// 原点位置，通常都是所在区域的左上角
		public var oriy:int = 0;
		public var touchTick:Number = 0;		//
		public var isSpace:Boolean = false;		//是否是空格，如果是空格，则只有width有效
		public function touch():void {
			var curLoop:int = Stat.loopCount;
			if (touchTick != curLoop) {// 这个保证每帧只调用一次
				tex.touchRect(this, curLoop);
			}
			touchTick = curLoop;
		}
	}
}