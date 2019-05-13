package laya.display.cmd 
{
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	/**
	 * 绘制带九宫格信息的图片
	 * @private
	 */
	public class Draw9GridTexture 
	{
		public static const ID:String = "Draw9GridTexture";
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
		
		public var sizeGrid:Array;
		

		
		/**@private */
		public static function create(texture:Texture, x:Number, y:Number, width:Number, height:Number,sizeGrid:Array):Draw9GridTexture {
			var cmd:Draw9GridTexture = Pool.getItemByClass("Draw9GridTexture", Draw9GridTexture);
			cmd.texture = texture;
			texture._addReference();
			cmd.x = x;
			cmd.y = y;
			cmd.width = width;
			cmd.height = height;
			cmd.sizeGrid = sizeGrid;
			
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			texture._removeReference();
			Pool.recover("Draw9GridTexture", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.drawTextureWithSizeGrid(texture, x, y, width, height, sizeGrid, gx, gy);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
		public function Draw9GridTexture() 
		{
			
		}
		
	}

}