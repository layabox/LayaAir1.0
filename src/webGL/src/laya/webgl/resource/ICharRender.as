package laya.webgl.resource { 
	public class ICharRender {
		public function getWidth(font:String, str:String):Number{return 0; }
		
		public function scale(sx:Number, sy:Number):void {
		}
		
		public function get canvasWidth():int {
			return 0;	
		}
		
		public function set canvasWidth(w:int):void {
			
		}
		/**
		 *TODO stroke 
		 * @param	char
		 * @param	font
		 * @param	size  返回宽高
		 * @return
		 */
		public function getCharBmp( char:String, font:String, lineWidth:int, colStr:String, strokeColStr:String, size:CharRenderInfo, margin_left:int, margin_top:int, margin_right:int, margin_bottom:int, rect:Array=null):ImageData {
			return null;
		}
	}
}