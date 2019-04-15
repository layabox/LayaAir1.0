package laya.d3.core.particleShuriKen.module.shape {
	import laya.d3.math.Rand;
	import laya.d3.math.Vector2;
	import laya.d3.math.Vector3;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ShapeUtils {
		public static function _randomPointUnitArcCircle(arc:Number, out:Vector2, rand:Rand = null):void {
			var angle:Number;
			if (rand)
				angle = rand.getFloat() * arc;
			else
				angle = Math.random() * arc;
			out.x = Math.cos(angle);
			out.y = Math.sin(angle);
		}
		
		public static function _randomPointInsideUnitArcCircle(arc:Number, out:Vector2, rand:Rand = null):void {
			_randomPointUnitArcCircle(arc, out,rand);
			var range:Number;
			if (rand)
				range = Math.pow(rand.getFloat(), 1.0 / 2.0);
			else
				range = Math.pow(Math.random(), 1.0 / 2.0);
			out.x = out.x * range;
			out.y = out.y * range;
		}
		
		public static function _randomPointUnitCircle(out:Vector2, rand:Rand = null):void {
			var angle:Number;
			if (rand)
				angle = rand.getFloat() * Math.PI * 2;
			else
				angle = Math.random() * Math.PI * 2;
			out.x = Math.cos(angle);
			out.y = Math.sin(angle);
		}
		
		public static function _randomPointInsideUnitCircle(out:Vector2, rand:Rand = null):void {
			_randomPointUnitCircle(out);
			var range:Number;
			if (rand)
				range = Math.pow(rand.getFloat(), 1.0 / 2.0);
			else
				range = Math.pow(Math.random(), 1.0 / 2.0);
			out.x = out.x * range;
			out.y = out.y * range;
		}
		
		public static function _randomPointUnitSphere(out:Vector3, rand:Rand = null):void {
			var z:Number;
			var a:Number;
			if (rand) {
				z = out.z = rand.getFloat() * 2 - 1.0;
				a = rand.getFloat() * Math.PI * 2;
			} else {
				z = out.z = Math.random() * 2 - 1.0;
				a = Math.random() * Math.PI * 2;
			}
			
			var r:Number = Math.sqrt(1.0 - z * z);
			
			out.x = r * Math.cos(a);
			out.y = r * Math.sin(a);
		}
		
		public static function _randomPointInsideUnitSphere(out:Vector3, rand:Rand = null):void {;
			_randomPointUnitSphere(out);
			var range:Number;
			if (rand)
				range = Math.pow(rand.getFloat(), 1.0 / 3.0);
			else
				range = Math.pow(Math.random(), 1.0 / 3.0);
			out.x = out.x * range;
			out.y = out.y * range;
			out.z = out.z * range;
		}
		
		public static function _randomPointInsideHalfUnitBox(out:Vector3, rand:Rand = null):void {
			if (rand) {
				out.x = (rand.getFloat() - 0.5);
				out.y = (rand.getFloat() - 0.5);
				out.z = (rand.getFloat() - 0.5);
			} else {
				out.x = (Math.random() - 0.5);
				out.y = (Math.random() - 0.5);
				out.z = (Math.random() - 0.5);
			}
		}
		
		public function ShapeUtils() {
		}
	
	}

}