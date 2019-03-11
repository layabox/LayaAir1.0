package laya.d3Extend.worldMaker {
	import laya.d3.math.Vector3;
	public class Vec3Pool {
		private static var vecstack:Array = [];		// 可用的
		
		public static function getVec3():Vector3 {
			var ret:Vector3 ;
			if (vecstack.length) {
				ret = vecstack.pop();
			}else {
				ret = new Vector3();
			}
			return ret;
		}
		
		public static function discardVec3(v:Vector3):void {
			v.elements[0] = v.elements[1] = v.elements[2] = 0;
			vecstack.push(v);
		}
	}
}	