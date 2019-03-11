package laya.display.cmd {
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	
	/**
	 * 根据坐标集合绘制多个贴图
	 */
	public class DrawTexturesCmd {
		public static const ID:String = "DrawTextures";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 纹理。
		 */
		public var texture:Texture;
		/**
		 * 绘制次数和坐标。
		 */
		public var pos:Array;
		
		/**@private */
		public static function create(texture:Texture, pos:Array):DrawTexturesCmd {
			var cmd:DrawTexturesCmd = Pool.getItemByClass("DrawTexturesCmd", DrawTexturesCmd);
			cmd.texture = texture;
			texture._addReference();
			cmd.pos = pos;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			texture._removeReference();
			texture = null;
			pos = null;
			Pool.recover("DrawTexturesCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.drawTextures(texture, pos, gx, gy);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}