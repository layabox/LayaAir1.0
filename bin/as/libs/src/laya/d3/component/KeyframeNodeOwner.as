package laya.d3.component {
	
	/**
	 * @private
	 * <code>KeyframeNodeOwner</code> 类用于保存帧节点的拥有者信息。
	 */
	public class KeyframeNodeOwner {
		/**@private */
		public var indexInList:int = -1;
		/**@private */
		public var referenceCount:int = 0;
		/**@private */
		public var updateMark:int = -1;
		
		/**@private */
		public var type:int = -1;
		/**@private */
		public var fullPath:String = null;
		/**@private */
		public var propertyOwner:* = null;
		/**@private */
		public var property:Vector.<String> = null;
		/**@private */
		public var defaultValue:* = null;
		/**@private */
		public var crossFixedValue:* = null;
		
		/**
		 * 创建一个 <code>KeyframeNodeOwner</code> 实例。
		 */
		public function KeyframeNodeOwner() {
		}
		
		/**
		 * @private
		 */
		public function saveCrossFixedValue():void {
			var pro:* = propertyOwner;
			if (pro) {
				switch (type) {
				case 0: 
					var proPat:Vector.<String> = property;
					var m:int = proPat.length - 1;
					for (var j:int = 0; j < m; j++) {
						pro = pro[proPat[j]];
						if (!pro)//属性可能或被置空
							break;
					}
					crossFixedValue = pro[proPat[m]];
					break;
				case 1: 
					var locPosE:Float32Array = pro.localPosition.elements;
					crossFixedValue || (crossFixedValue = new Float32Array(3));
					crossFixedValue[0] = locPosE[0];
					crossFixedValue[1] = locPosE[1];
					crossFixedValue[2] = locPosE[2];
					break;
				case 2: 
					var locRotE:Float32Array = pro.localRotation.elements;
					crossFixedValue || (crossFixedValue = new Float32Array(4));
					crossFixedValue[0] = locRotE[0];
					crossFixedValue[1] = locRotE[1];
					crossFixedValue[2] = locRotE[2];
					crossFixedValue[3] = locRotE[3];
					break;
				case 3: 
					var locScaE:Float32Array = pro.localScale.elements;
					crossFixedValue || (crossFixedValue = new Float32Array(3));
					crossFixedValue[0] = locScaE[0];
					crossFixedValue[1] = locScaE[1];
					crossFixedValue[2] = locScaE[2];
					break;
				case 4: 
					var locEulE:Float32Array = pro.localRotationEuler.elements;
					crossFixedValue || (crossFixedValue = new Float32Array(3));
					crossFixedValue[0] = locEulE[0];
					crossFixedValue[1] = locEulE[1];
					crossFixedValue[2] = locEulE[2];
					break;
				default: 
					throw "Animator:unknown type.";
				}
				
			}
		}
	
	}

}