package PathFinding.core
{
	
	/**
	 * ...
	 * @author dongketao
	 */
	public class Heuristic
	{
		
		public function Heuristic()
		{
		
		}
		
		public static function manhattan(dx:Number, dy:Number):Number
		{
			return dx + dy;
		}
		
		public static function euclidean(dx:Number, dy:Number):Number
		{
			return Math.sqrt(dx * dx + dy * dy);
		}
		
		public static function octile(dx:Number, dy:Number):Number
		{
			var F:Number = Math.SQRT2 - 1;
			return (dx < dy) ? F * dx + dy : F * dy + dx;
		}
		
		public static function chebyshev(dx:Number, dy:Number):Number
		{
			return Math.max(dx, dy);
		}
	}
}