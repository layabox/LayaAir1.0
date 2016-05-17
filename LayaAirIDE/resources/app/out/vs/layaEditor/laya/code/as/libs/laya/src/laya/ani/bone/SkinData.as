package laya.ani.bone {
	
	/**
	 * @private
	 */
	public class SkinData {
		
		public var name:String;
		public var slotArr:Array = [];
		
		public function initData(data:*):void {
			name = data.name;
			var tMySlotData:SlotData;
			var tSlotData:*;
			var tSlotDataArr:Array = data.slot;
			for (var i:int = 0; i < tSlotDataArr.length; i++) {
				tSlotData = tSlotDataArr[i];
				tMySlotData = new SlotData();
				tMySlotData.initData(tSlotData);
				slotArr.push(tMySlotData);
			}
		}
	}
}