package laya.ani.bone {
	import laya.ani.bone.SkinSlotDisplayData;
	
	/**
	 * @private
	 */
	public class SlotData {
		
		public var name:String;
		public var displayArr:Array = [];
		
		public function initData(data:*):void {
			name = data.name;
			var tMyDisplayData:SkinSlotDisplayData;
			var tDisplayData:*;
			var tDisplayDataArr:Array = data.display;
			for (var h:int = 0; h < tDisplayDataArr.length; h++) {
				tDisplayData = tDisplayDataArr[h];
				tMyDisplayData = new SkinSlotDisplayData();
				tMyDisplayData.initData(tDisplayData);
				displayArr.push(tMyDisplayData);
			}
		}
	}
}