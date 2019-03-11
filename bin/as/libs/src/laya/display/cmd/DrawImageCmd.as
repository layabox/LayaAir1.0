package laya.display.cmd {
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	
	/**
	 * 绘制图片
	 */
	public class DrawImageCmd {
		public static const ID:String = "DrawImage";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 纹理。
		 */
		public var texture:Texture;
		/**
		 * （可选）X轴偏移量。
		 */
		public var x:Number;
		/**
		 * （可选）Y轴偏移量。
		 */
		public var y:Number;
		/**
		 * （可选）宽度。
		 */
		public var width:Number;
		/**
		 * （可选）高度。
		 */
		public var height:Number;
		
		/**@private */
		public static function create(texture:Texture, x:Number, y:Number, width:Number, height:Number):DrawImageCmd {
			var cmd:DrawImageCmd = Pool.getItemByClass("DrawImageCmd", DrawImageCmd);
			cmd.texture = texture;
			texture._addReference();
			cmd.x = x;
			cmd.y = y;
			cmd.width = width;
			cmd.height = height;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			texture._removeReference();
			texture = null;
			Pool.recover("DrawImageCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.drawTexture(texture, x + gx, y + gy, width, height);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}