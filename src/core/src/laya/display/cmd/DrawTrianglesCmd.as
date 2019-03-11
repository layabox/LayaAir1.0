package laya.display.cmd {
	import laya.filters.ColorFilter;
	import laya.maths.Matrix;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.ColorUtils;
	import laya.utils.Pool;
	
	/**
	 * 绘制三角形命令
	 */
	public class DrawTrianglesCmd {
		public static const ID:String = "DrawTriangles";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 纹理。
		 */
		public var texture:Texture;
		/**
		 * X轴偏移量。
		 */
		public var x:Number;
		/**
		 * Y轴偏移量。
		 */
		public var y:Number;
		/**
		 * 顶点数组。
		 */
		public var vertices:Float32Array;
		/**
		 * UV数据。
		 */
		public var uvs:Float32Array;
		/**
		 * 顶点索引。
		 */
		public var indices:Uint16Array;
		/**
		 * 缩放矩阵。
		 */
		public var matrix:Matrix;
		/**
		 * alpha
		 */
		public var alpha:Number;
		//public var color:String;
		/**
		 * blend模式
		 */
		public var blendMode:String;
		/**
		 * 颜色变换
		 */
		public var color:ColorFilter;
		
		/**@private */
		public static function create(texture:Texture, x:Number, y:Number, vertices:Float32Array, uvs:Float32Array, indices:Uint16Array, matrix:Matrix, alpha:Number, color:String, blendMode:String):DrawTrianglesCmd {
			var cmd:DrawTrianglesCmd = Pool.getItemByClass("DrawTrianglesCmd", DrawTrianglesCmd);
			cmd.texture = texture;
			cmd.x = x;
			cmd.y = y;
			cmd.vertices = vertices;
			cmd.uvs = uvs;
			cmd.indices = indices;
			cmd.matrix = matrix;
			cmd.alpha = alpha;
			if (color) {
				cmd.color = new ColorFilter();
				var c:Array = ColorUtils.create(color).arrColor;
				cmd.color.color(c[0]*255, c[1]*255, c[2]*255, c[3]*255);	//TODO 这个好像设置的是加色，这样并不合理
			}
			cmd.blendMode = blendMode;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			texture = null;
			vertices = null;
			uvs = null;
			indices = null;
			matrix = null;
			Pool.recover("DrawTrianglesCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context.drawTriangles(texture, x + gx, y + gy, vertices, uvs, indices, matrix, alpha, color, blendMode);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}