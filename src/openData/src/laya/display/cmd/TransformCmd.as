package laya.display.cmd {
	import laya.maths.Matrix;
	import laya.resource.Context;
	import laya.utils.Pool;
	
	/**
	 * 矩阵命令
	 */
	public class TransformCmd {
		public static const ID:String = "Transform";
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**
		 * 矩阵。
		 */
		public var matrix:Matrix;
		/**
		 * （可选）水平方向轴心点坐标。
		 */
		public var pivotX:Number;
		/**
		 * （可选）垂直方向轴心点坐标。
		 */
		public var pivotY:Number;
		
		/**@private */
		public static function create(matrix:Matrix, pivotX:Number, pivotY:Number):TransformCmd {
			var cmd:TransformCmd = Pool.getItemByClass("TransformCmd", TransformCmd);
			cmd.matrix = matrix;
			cmd.pivotX = pivotX;
			cmd.pivotY = pivotY;
			return cmd;
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			matrix = null;
			Pool.recover("TransformCmd", this);
		}
		
		/**@private */
		public function run(context:Context, gx:Number, gy:Number):void {
			context._transform(matrix, pivotX + gx, pivotY + gy);
		}
		
		/**@private */
		public function get cmdID():String {
			return ID;
		}
	
	}
}