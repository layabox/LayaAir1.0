package laya.display.cmd {
	import laya.maths.Matrix;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	
	/**
	 * 绘制单个贴图
	 */
	public class DrawTextureCmd {
		public static const ID:String = "DrawTexture";
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
		/**
		 * （可选）矩阵信息。
		 */
		public var matrix:Matrix;
		/**
		 * （可选）透明度。
		 */
		public var alpha:Number;
		/**
		 * （可选）颜色滤镜。
		 */
		public var color:String;
		/**
		 * （可选）混合模式。
		 */
		public var blendMode:String;
		
		/**@private */
		public static function create(texture:Texture, x:Number, y:Number, width:Number, height:Number, matrix:Matrix, alpha:Number, color:String, blendMode:String):DrawTextureCmd {
			var cmd:DrawTextureCmd = Pool.getItemByClass("DrawTextureCmd", DrawTextureCmd);
			cmd.texture = texture;
			texture._addReference();
			cmd.x = x;
			cmd.y = y;
			cmd.width = width;
			cmd.height = height;
			cmd.matrix = matrix;
			cmd.alpha = alpha;
			cmd.color = color;
			cmd.blendMode = blendMode;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			texture._removeReference();
			texture = null;
			matrix = null;
			Pool.recover("DrawTextureCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.drawTextureWithTransform(texture, x, y, width, height, matrix, gx, gy, alpha, blendMode);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}