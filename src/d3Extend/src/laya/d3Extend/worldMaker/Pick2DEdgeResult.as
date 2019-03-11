package laya.d3Extend.worldMaker {
	public class Pick2DEdgeResult {
		public var ObjID:int =-1;
		public var PtIdx:int =-1;			// TODO 如果是图的话，用点来指示边是不对的
		
		public var projX:Number = 0;		// 投影到线上点
		public var projY:Number = 0;
		
		public var dist2:Number = 0;		// 投影点到自己的距离的平方
		
		public var offX:Number = 0; 		//距离实际点的距离
		public var offY:Number = 0;
	}
}