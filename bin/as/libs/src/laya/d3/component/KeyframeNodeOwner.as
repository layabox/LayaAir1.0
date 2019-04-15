package laya.d3.component {
	import laya.d3.math.Quaternion;
	import laya.d3.math.Vector3;
	
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
					var locPos:Vector3 = pro.localPosition;
					crossFixedValue || (crossFixedValue = new Vector3());
					crossFixedValue.x = locPos.x;
					crossFixedValue.y = locPos.y;
					crossFixedValue.z = locPos.z;
					break;
				case 2: 
					var locRot:Quaternion = pro.localRotation;
					crossFixedValue || (crossFixedValue = new Quaternion());
					crossFixedValue.x = locRot.x;
					crossFixedValue.y = locRot.y;
					crossFixedValue.z = locRot.z;
					crossFixedValue.w = locRot.w;
					break;
				case 3: 
					var locSca:Vector3 = pro.localScale;
					crossFixedValue || (crossFixedValue = new Vector3());
					crossFixedValue.x = locSca.x;
					crossFixedValue.y = locSca.y;
					crossFixedValue.z = locSca.z;
					break;
				case 4: 
					var locEul:Vector3 = pro.localRotationEuler;
					crossFixedValue || (crossFixedValue = new Vector3());
					crossFixedValue.x = locEul.x;
					crossFixedValue.y = locEul.y;
					crossFixedValue.z = locEul.z;
					break;
				default: 
					throw "Animator:unknown type.";
				}
				
			}
		}
	
	}

}