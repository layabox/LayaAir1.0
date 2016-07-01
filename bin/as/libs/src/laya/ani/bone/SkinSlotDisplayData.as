package laya.ani.bone {
	
	
	/**
	 * @private
	 */
	public class SkinSlotDisplayData {
		
		public var name:String;
		public var type:String;
		public var transform:Transform;
		
		public function initData(data:*):void {
			name = data.name;
			type = data.type;
			transform = new Transform();
			transform.initData(data.transform);
		}
	}
}