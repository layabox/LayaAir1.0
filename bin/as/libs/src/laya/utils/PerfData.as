package laya.utils {
	public class PerfData {
		public var id:int;
		public var name:String;
		public var color:int;
		public var scale:Number=1.0;
		public var datas:Array = new Array(PerfHUD.DATANUM);
		public var datapos:int = 0;
		public function PerfData(id:int, color:int, name:String, scale:Number) {
			this.id = id;
			this.color = color;
			this.name = name;
			this.scale = scale;
		}
		public function addData(v:Number):void {
			datas[datapos] = v;
			datapos++;
			datapos %= PerfHUD.DATANUM;
		}
	}
}