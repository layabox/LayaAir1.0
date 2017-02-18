package threeDimen.common {
	import laya.d3.math.Vector3;
	
	public class GlitterStripSampler {
		public var pos1:Vector3 = new Vector3(0, 0, 0);
		public var pos2:Vector3 = new Vector3(0, 0.6, 0);
		private var nCount:int = 0;
		private var direction:Boolean = true;
		
		public function GlitterStripSampler() {
		
		}
		
		public function getSampleP4():void {
			if (direction) {
				this.nCount += 0.5;
				if (this.nCount >= 12) {
					this.direction = false;
				}
			} else {
				this.nCount -= 0.5;
				if (this.nCount <= -12) {
					this.direction = true;
				}
			}
			//TODO
			this.pos1.elements[0] = this.nCount;
			this.pos2.elements[0] = this.nCount * 1.3;
		}
	}
}