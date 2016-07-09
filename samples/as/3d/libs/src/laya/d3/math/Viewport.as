package laya.d3.math {
	
	/**
	 * <code>Viewport</code> 类用于创建视口。
	 */
	public class Viewport {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		/**X轴坐标*/
		public var x:Number;
		/**Y轴坐标*/
		public var y:Number;
		/**宽度*/
		public var width:Number;
		/**高度*/
		public var height:Number;
		/**最小深度*/
		public var minDepth:Number = -1.0;
		/**最大深度*/
		public var maxDepth:Number = 1.0;
		
		/**
		 * 创建一个 <code>Viewport</code> 实例。
		 * @param	x x坐标。
		 * @param	y y坐标。
		 * @param	width 宽度。
		 * @param	height 高度。
		 */
		public function Viewport(x:Number, y:Number, width:Number, height:Number) {
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
		public function project(source:Vector3, matrix:Matrix4x4, vector:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			Vector3.transformV3ToV3(source, matrix, vector);
			var sourceEleme:Float32Array = source.elements;
			var matrixEleme:Float32Array = matrix.elements;
			var vectorEleme:Float32Array = vector.elements;
			
			var a:Number = (((sourceEleme[0] * matrixEleme[3]) + (sourceEleme[1] * matrixEleme[7])) + (sourceEleme[2] * matrixEleme[11])) + matrixEleme[15];
			
			if (a !== 1.0)//待优化，经过计算得出的a可能会永远只近似于1，因为是Number类型
			{
				vectorEleme[0] = vectorEleme[0] / a;
				vectorEleme[1] = vectorEleme[1] / a;
				vectorEleme[2] = vectorEleme[2] / a;
			}
			
			vectorEleme[0] = (((vectorEleme[0] + 1.0) * 0.5) * width) + x;
			vectorEleme[1] = (((-vectorEleme[1] + 1.0) * 0.5) * height) + y;
			vectorEleme[2] = (vectorEleme[2] * (maxDepth - minDepth)) + minDepth;
		}
		
		/**
		 * 反变换一个三维向量。
		 * @param	source 源三维向量。
		 * @param	matrix 变换矩阵。
		 * @param	vector 输出三维向量。
		 */
		public function unprojectFromMat(source:Vector3, matrix:Matrix4x4, vector:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var sourceEleme:Float32Array = source.elements;
			var matrixEleme:Float32Array = matrix.elements;
			var vectorEleme:Float32Array = vector.elements;
			
			vectorEleme[0] = (((sourceEleme[0] - x) / (width)) * 2.0) - 1.0;
			vectorEleme[1] = -((((sourceEleme[1] - y) / (height)) * 2.0) - 1.0);
			var halfDepth:Number = (maxDepth - minDepth) / 2;
			vectorEleme[2] = (sourceEleme[2] - minDepth - halfDepth) / halfDepth;
			
			var a:Number = (((vectorEleme[0] * matrixEleme[3]) + (vectorEleme[1] * matrixEleme[7])) + (vectorEleme[2] * matrixEleme[11])) + matrixEleme[15];
			Vector3.transformV3ToV3(vector, matrix, vector);
			
			if (a !== 1.0)//待优化，经过计算得出的a可能会永远只近似于1，因为是Number类型
			{
				vectorEleme[0] = vectorEleme[0] / a;
				vectorEleme[1] = vectorEleme[1] / a;
				vectorEleme[2] = vectorEleme[2] / a;
			}
		}
		
		/**
		 * 反变换一个三维向量。
		 * @param	source 源三维向量。
		 * @param	projection  透视投影矩阵。
		 * @param	view 视图矩阵。
		 * @param	world 世界矩阵。
		 * @return 输出向量。
		 */
		public function unprojectFromWVP(source:Vector3, projection:Matrix4x4, view:Matrix4x4, world:Matrix4x4):Vector3 {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var matrix:Matrix4x4 = new Matrix4x4();
			Matrix4x4.multiply(projection, view, matrix);
			Matrix4x4.multiply(matrix, world, matrix);
			//Matrix4x4.invert(matrix, matrix);//TODO:观察保留，日后删除
			matrix.invert(matrix);
			
			var vector:Vector3 = new Vector3();
			unprojectFromMat(source, matrix, vector);
			return vector;
		}
	}

}