package laya.d3.math {
	
	/**
	 * <code>Viewport</code> 类用于创建视口。
	 */
	public class Viewport {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		private static var _tempMatrix4x4:Matrix4x4 = new Matrix4x4();
		
		/**X轴坐标*/
		public var x:Number;
		/**Y轴坐标*/
		public var y:Number;
		/**宽度*/
		public var width:Number;
		/**高度*/
		public var height:Number;
		/**最小深度*/
		public var minDepth:Number;
		/**最大深度*/
		public var maxDepth:Number;
		
		/**
		 * 创建一个 <code>Viewport</code> 实例。
		 * @param	x x坐标。
		 * @param	y y坐标。
		 * @param	width 宽度。
		 * @param	height 高度。
		 */
		public function Viewport(x:Number, y:Number, width:Number, height:Number) {
			minDepth =0.0;//TODO:待确认，-1。
			maxDepth = 1.0;
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		/**
		 * 变换一个三维向量。
		 * @param	source 源三维向量。
		 * @param	matrix 变换矩阵。
		 * @param	vector 输出三维向量。
		 */
		public function project(source:Vector3, matrix:Matrix4x4, out:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			Vector3.transformV3ToV3(source, matrix, out);
			var sourceEleme:Float32Array = source.elements;
			var matrixEleme:Float32Array = matrix.elements;
			var outEleme:Float32Array = out.elements;
			
			var a:Number = (((sourceEleme[0] * matrixEleme[3]) + (sourceEleme[1] * matrixEleme[7])) + (sourceEleme[2] * matrixEleme[11])) + matrixEleme[15];
			
			if (a !== 1.0)//待优化，经过计算得出的a可能会永远只近似于1，因为是Number类型
			{
				outEleme[0] = outEleme[0] / a;
				outEleme[1] = outEleme[1] / a;
				outEleme[2] = outEleme[2] / a;
			}
			
			outEleme[0] = (((outEleme[0] + 1.0) * 0.5) * width) + x;
			outEleme[1] = (((-outEleme[1] + 1.0) * 0.5) * height) + y;
			outEleme[2] = (outEleme[2] * (maxDepth - minDepth)) + minDepth;
		}
		
		/**
		 * 反变换一个三维向量。
		 * @param	source 源三维向量。
		 * @param	matrix 变换矩阵。
		 * @param	vector 输出三维向量。
		 */
		public function unprojectFromMat(source:Vector3, matrix:Matrix4x4, out:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var sourceEleme:Float32Array = source.elements;
			var matrixEleme:Float32Array = matrix.elements;
			var outEleme:Float32Array = out.elements;
			
			outEleme[0] = (((sourceEleme[0] - x) / (width)) * 2.0) - 1.0;
			outEleme[1] = -((((sourceEleme[1] - y) / (height)) * 2.0) - 1.0);
			var halfDepth:Number = (maxDepth - minDepth) / 2;
			outEleme[2] = (sourceEleme[2] - minDepth - halfDepth) / halfDepth;
			
			var a:Number = (((outEleme[0] * matrixEleme[3]) + (outEleme[1] * matrixEleme[7])) + (outEleme[2] * matrixEleme[11])) + matrixEleme[15];
			Vector3.transformV3ToV3(out, matrix, out);
			
			if (a !== 1.0)//待优化，经过计算得出的a可能会永远只近似于1，因为是Number类型
			{
				outEleme[0] = outEleme[0] / a;
				outEleme[1] = outEleme[1] / a;
				outEleme[2] = outEleme[2] / a;
			}
		}
		
		/**
		 * 反变换一个三维向量。
		 * @param	source 源三维向量。
		 * @param	projection  透视投影矩阵。
		 * @param	view 视图矩阵。
		 * @param	world 世界矩阵,可设置为null。
		 * @param   out 输出向量。
		 */
		public function unprojectFromWVP(source:Vector3, projection:Matrix4x4, view:Matrix4x4, world:Matrix4x4, out:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			Matrix4x4.multiply(projection, view, _tempMatrix4x4);
			(world) && (Matrix4x4.multiply(_tempMatrix4x4, world, _tempMatrix4x4));
			_tempMatrix4x4.invert(_tempMatrix4x4);
			unprojectFromMat(source, _tempMatrix4x4, out);
		}
	}

}