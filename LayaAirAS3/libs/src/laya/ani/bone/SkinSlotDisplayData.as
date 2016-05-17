package laya.ani.bone {
	import laya.maths.Point;
	
	/**
	 * @private
	 */
	public class SkinSlotDisplayData {
		
		public var name:String;
		public var type:String;
		public var transform:Transform;
		public var pivot:Point;
		public var uvs:Array;
		public var triangles:Array;
		public var weights:Array;
		public var vertices:Array;
		public var slotPos:Array;
		public var bonePose:Array;
		public var edges:Array;
		public var userEdges:Array;
		
		public function initData(data:*):void {
			name = data.name;
			type = data.type;
			transform = new Transform();
			transform.initData(data.transform);
		}
	}
}