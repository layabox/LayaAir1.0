package laya.layagl 
{
	/**
	 * ...
	 * @author Tianjing
	 */
	
	import laya.maths.Rectangle;
	 
	public class ConchPropertyAdpt 
	{
		
		public function ConchPropertyAdpt() 
		{
			
		}
		
		public static function rewriteProperties() : void
		{
			// rewrite Rectangle
			ConchPropertyAdpt.rewriteNumProperty(Rectangle.prototype, "x");
			ConchPropertyAdpt.rewriteNumProperty(Rectangle.prototype, "y");
			ConchPropertyAdpt.rewriteNumProperty(Rectangle.prototype, "width");
			ConchPropertyAdpt.rewriteNumProperty(Rectangle.prototype, "height");
			ConchPropertyAdpt.rewriteFunc(Rectangle.prototype, "recover");
		}
		
		private static function rewriteNumProperty(proto:*, p:String):void
		{		
			Object["defineProperty"](proto, p, {
				"get":function():* {
					return this["_"+p] || 0;
				},
				"set":function(v:*):void {
					this["_" + p] = v;
					if (this.onPropertyChanged) {
						this.onPropertyChanged(this);
					}
				}
			});
		}
		
		private static function rewriteFunc(proto:*, p:String):void
		{
			proto["__" + p] = proto[p];
			proto[p] = function():void {
				proto["__" + p].call(this);
				if (this.onPropertyChanged)
					this.onPropertyChanged = null;
			}
		}
	}
}