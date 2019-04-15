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
			minDepth = 0.0;//TODO:待确认，-1。
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
			var matrixEleme:Float32Array = matrix.elements;
			
			var a:Number = (((source.x * matrixEleme[3]) + (source.y * matrixEleme[7])) + (source.z * matrixEleme[11])) + matrixEleme[15];
			
			if (a !== 1.0)//待优化，经过计算得出的a可能会永远只近似于1，因为是Number类型
			{
				out.x = out.x / a;
				out.y = out.y / a;
				out.z = out.z / a;
			}
			
			out.x = (((out.x + 1.0) * 0.5) * width) + x;
			out.y = (((-out.y + 1.0) * 0.5) * height) + y;
			out.z = (out.z * (maxDepth - minDepth)) + minDepth;
		}
		
		public function project1(source:Vector3, matrix:Matrix4x4, out:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var v4:Vector4 = Vector3._tempVector4;
			Vector3.transformV3ToV4(source, matrix, v4);
			//v4e[3]是z，是相对于摄像机的位置。注意有时候可能为0
			var dist:Number = v4.w;
			if (dist < 1e-1 && dist > -1e-6) dist = 1e-6;
			v4.x /= dist;
			v4.y /= dist;
			v4.z /= dist;
			
			out.x = (v4.x + 1) * width / 2 + x;
			out.y = (-v4.y + 1) * height / 2 + y;
			out.z = v4.w;
			return;
		}
		
		/**
		 * 反变换一个三维向量。
		 * @param	source 源三维向量。
		 * @param	matrix 变换矩阵。
		 * @param	vector 输出三维向量。
		 */
		public function unprojectFromMat(source:Vector3, matrix:Matrix4x4, out:Vector3):void {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var matrixEleme:Float32Array = matrix.elements;
			
			out.x = (((source.x - x) / (width)) * 2.0) - 1.0;
			out.y = -((((source.y - y) / (height)) * 2.0) - 1.0);
			var halfDepth:Number = (maxDepth - minDepth) / 2;
			out.z = (source.z - minDepth - halfDepth) / halfDepth;
			
			var a:Number = (((out.x * matrixEleme[3]) + (out.y * matrixEleme[7])) + (out.z * matrixEleme[11])) + matrixEleme[15];
			Vector3.transformV3ToV3(out, matrix, out);
			
			if (a !== 1.0)//待优化，经过计算得出的a可能会永远只近似于1，因为是Number类型
			{
				out.x = out.x / a;
				out.y = out.y / a;
				out.z = out.z / a;
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
		
		/**
		 * 克隆
		 * @param	out
		 */
		public function cloneTo(out:Viewport):void {
			out.x = x;
			out.y = y;
			out.width = width;
			out.height = height;
			out.minDepth = minDepth;
			out.maxDepth = maxDepth;
		}
	}

}