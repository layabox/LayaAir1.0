package laya.display 
{
	import laya.maths.Bezier;
	import laya.maths.GrahamScan;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.renders.RenderContext;
	import laya.resource.Texture;
	import laya.utils.Utils;

	/**
	 * @private
	 * Graphic bounds数据类
	 */
	public class GraphicsBounds 
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**@private */
		private static var _tempMatrix:Matrix = new Matrix();
		/**@private */
		private static var _initMatrix:Matrix = new Matrix();
		/**@private */
		private static var _tempPoints:Array = [];
		/**@private */
		private static var _tempMatrixArrays:Array = [];
		/**@private */
		private static var _tempCmds:Array = [];
		/**@private */
		private var _temp:Array;
		/**@private */
		private var _bounds:Rectangle;
		/**@private */
		private var _rstBoundPoints:Array;
		/**@private */
		private var _cacheBoundsType:Boolean = false;
		/**@private */
		public var _graphics:Graphics;
		
		/**
		 * 销毁 
		 */		
		public function destroy():void
		{
			_graphics=null;
			_temp=null;
			_rstBoundPoints=null;
			_bounds=null;
		}
		
		/**
		 * 重置数据 
		 */		
		public function reset():void
		{
			_temp && (_temp.length = 0);
		}
		
		/**
		 * 获取位置及宽高信息矩阵(比较耗CPU，频繁使用会造成卡顿，尽量少用)。
		 * @param realSize	（可选）使用图片的真实大小，默认为false
		 * @return 位置与宽高组成的 一个 Rectangle 对象。
		 */
		public function getBounds(realSize:Boolean = false):Rectangle {
			if (!_bounds || !_temp || _temp.length < 1 || realSize != _cacheBoundsType) {
				_bounds = Rectangle._getWrapRec(getBoundPoints(realSize), _bounds)
			}
			_cacheBoundsType = realSize;
			return _bounds;
		}
		
		/**
		 * @private
		 * @param realSize	（可选）使用图片的真实大小，默认为false
		 * 获取端点列表。
		 */
		public function getBoundPoints(realSize:Boolean = false):Array {
			if (!_temp || _temp.length < 1 || realSize != _cacheBoundsType)
				_temp = _getCmdPoints(realSize);
			_cacheBoundsType = realSize;
			return _rstBoundPoints = Utils.copyArray(_rstBoundPoints, _temp);
		}
		
		private function _getCmdPoints(realSize:Boolean = false):Array {
			var context:RenderContext = Render._context;
			var cmds:Array = _graphics.cmds;
			var rst:Array;
			rst = _temp || (_temp = []);
			
			rst.length = 0;
			if (!cmds && _graphics._one != null) {
				_tempCmds.length = 0;
				_tempCmds.push(_graphics._one);
				cmds = _tempCmds;
			}
			if (!cmds)
				return rst;
			
			var matrixs:Array;
			matrixs = _tempMatrixArrays;
			matrixs.length = 0;
			var tMatrix:Matrix = _initMatrix;
			tMatrix.identity();
			var tempMatrix:Matrix = _tempMatrix;
			var cmd:Object;
			var tex:Texture;
			
			var wRate:Number;
			var hRate:Number;
			var oWidth:Number;
			var oHeight:Number;
			
			var offX:Number;
			var offY:Number;
						
			for (var i:int = 0, n:int = cmds.length; i < n; i++) {
				cmd = cmds[i];
				if (!cmd.callee) continue;
				switch (cmd.callee) {
				case context._save: 
				case 7: //save
					matrixs.push(tMatrix);
					tMatrix = tMatrix.clone();
					break;
				case context._restore: 
				case 8: //restore
					tMatrix = matrixs.pop();
					break;
				case context._scale: 
				case 5://scale
					tempMatrix.identity();
					tempMatrix.translate(-cmd[2], -cmd[3]);
					tempMatrix.scale(cmd[0], cmd[1]);
					tempMatrix.translate(cmd[2], cmd[3]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case context._rotate: 
				case 3://case context._rotate: 
					tempMatrix.identity();
					tempMatrix.translate(-cmd[1], -cmd[2]);
					tempMatrix.rotate(cmd[0]);
					tempMatrix.translate(cmd[1], cmd[2]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case context._translate: 
				case 6://translate
					tempMatrix.identity();
					tempMatrix.translate(cmd[0], cmd[1]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case context._transform: 
				case 4://context._transform:
					tempMatrix.identity();
					tempMatrix.translate(-cmd[1], -cmd[2]);
					tempMatrix.concat(cmd[0]);
					tempMatrix.translate(cmd[1], cmd[2]);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case 16://case context._drawTexture: 
				case 24://case context._fillTexture
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[0], cmd[1], cmd[2], cmd[3]), tMatrix);
					break;
				case 17://case context._drawTextureTransform: 
					tMatrix.copyTo(tempMatrix);
					tempMatrix.concat(cmd[4]);
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[0], cmd[1], cmd[2], cmd[3]), tempMatrix);
					break;
				case context._drawTexture: 
					//width = width - tex.sourceWidth + tex.width;
					//height = height - tex.sourceHeight + tex.height;
					tex = cmd[0];
					if (realSize) {
						if (cmd[3] && cmd[4]) {
							_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], cmd[3], cmd[4]), tMatrix);
						} else {
							tex = cmd[0];
							_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], tex.width, tex.height), tMatrix);
						}
					} else {
						//var wRate:Number = owidth / tex.sourceWidth;
						//var hRate:Number =oheight / tex.sourceHeight;
						//twidth = tex.width*wRate;
						//theight = tex.height * hRate;
						wRate = (cmd[3] || tex.sourceWidth) / tex.width;
						hRate = (cmd[4] || tex.sourceHeight) / tex.height;
						oWidth = wRate * tex.sourceWidth;
						oHeight = hRate * tex.sourceHeight;
						
						offX = tex.offsetX > 0 ? tex.offsetX : 0;
						offY = tex.offsetY > 0 ? tex.offsetY : 0;
						
						offX *= wRate;
						offY *= hRate;
						
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1] - offX, cmd[2] - offY, oWidth,oHeight), tMatrix);
						//if (cmd[3] && cmd[4]) {
							//_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1] - offX, cmd[2] - offY, oWidth, oHeight), tMatrix);
						//} else {
							//_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1] - offX, cmd[2] - offY, tex.width + tex.sourceWidth - tex.width, tex.height + tex.sourceHeight - tex.height), tMatrix);
						//}
					}
					
					break;
				case context._fillTexture: 
					if (cmd[3] && cmd[4]) {
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], cmd[3], cmd[4]), tMatrix);
					} else {
						tex = cmd[0];
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], tex.width, tex.height), tMatrix);
					}
					break;
				case context._drawTextureWithTransform: 
					var drawMatrix:Matrix;
					if (cmd[5]) {
						tMatrix.copyTo(tempMatrix);
						tempMatrix.concat(cmd[5]);
						drawMatrix = tempMatrix;
					} else {
						drawMatrix = tMatrix;
					}
					if (realSize) {
						if (cmd[3] && cmd[4]) {
							_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], cmd[3], cmd[4]), drawMatrix);
						} else {
							tex = cmd[0];
							_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1], cmd[2], tex.width, tex.height), drawMatrix);
						}
					} else {
						tex = cmd[0];
						wRate = (cmd[3] || tex.sourceWidth) / tex.width;
						hRate = (cmd[4] || tex.sourceHeight) / tex.height;
						oWidth = wRate * tex.sourceWidth;
						oHeight = hRate * tex.sourceHeight;
						
						offX = tex.offsetX > 0 ? tex.offsetX : 0;
						offY = tex.offsetY > 0 ? tex.offsetY : 0;
						
						offX *= wRate;
						offY *= hRate;
						
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1] - offX, cmd[2] - offY, oWidth, oHeight), drawMatrix);
						//if (cmd[3] && cmd[4]) {
							//_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1] - offX, cmd[2] - offY, cmd[3] + tex.sourceWidth - tex.width, cmd[4] + tex.sourceHeight - tex.height), drawMatrix);
						//} else {
							//_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[1] - offX, cmd[2] - offY, tex.width + tex.sourceWidth - tex.width, tex.height + tex.sourceHeight - tex.height), drawMatrix);
						//}
					}
					
					break;
				case context._drawRect: 
				case 13://case context._drawRect:
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[0], cmd[1], cmd[2], cmd[3]), tMatrix);
					break;
				case context._drawCircle: 
				case context._fillCircle: 
				case 14://case context._drawCircle
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd[0] - cmd[2], cmd[1] - cmd[2], cmd[2] + cmd[2], cmd[2] + cmd[2]), tMatrix);
					break;
				case context._drawLine: 
				case 20://drawLine
					_tempPoints.length = 0;
					var lineWidth:Number;
					lineWidth = cmd[5] * 0.5;
					if (cmd[0] == cmd[2]) {
						_tempPoints.push(cmd[0] + lineWidth, cmd[1], cmd[2] + lineWidth, cmd[3], cmd[0] - lineWidth, cmd[1], cmd[2] - lineWidth, cmd[3]);
					} else if (cmd[1] == cmd[3]) {
						_tempPoints.push(cmd[0], cmd[1] + lineWidth, cmd[2], cmd[3] + lineWidth, cmd[0], cmd[1] - lineWidth, cmd[2], cmd[3] - lineWidth);
					} else {
						_tempPoints.push(cmd[0], cmd[1], cmd[2], cmd[3]);
					}
					
					_addPointArrToRst(rst, _tempPoints, tMatrix);
					break;
				case context._drawCurves: 
				case 22://context._drawCurves: 
					//addPointArrToRst(rst, [cmd[0], cmd[1]], tMatrix);
					//addPointArrToRst(rst, cmd[2], tMatrix, cmd[0], cmd[1]);
					_addPointArrToRst(rst, Bezier.I.getBezierPoints(cmd[2]), tMatrix, cmd[0], cmd[1]);
					break;
				case context._drawPoly: 
				case context._drawLines: 
				case 18://drawpoly
					//addPointArrToRst(rst, [cmd[0], cmd[1]], tMatrix);
					_addPointArrToRst(rst, cmd[2], tMatrix, cmd[0], cmd[1]);
					break;
				case context._drawPath: 
				case 19://drawPath
					//addPointArrToRst(rst, [cmd[0], cmd[1]], tMatrix);
					_addPointArrToRst(rst, _getPathPoints(cmd[2]), tMatrix, cmd[0], cmd[1]);
					break;
				case context._drawPie: 
				case 15://drawPie
					_addPointArrToRst(rst, _getPiePoints(cmd[0], cmd[1], cmd[2], cmd[3], cmd[4]), tMatrix);
					break;
					
				}
			}
			if (rst.length > 200) {
				rst = Utils.copyArray(rst, Rectangle._getWrapRec(rst)._getBoundPoints());
			} else if (rst.length > 8)
				rst = GrahamScan.scanPList(rst);
			return rst;
		}
		
		private function _switchMatrix(tMatix:Matrix, tempMatrix:Matrix):void {
			tempMatrix.concat(tMatix);
			tempMatrix.copyTo(tMatix);
		}
		
		private static function _addPointArrToRst(rst:Array, points:Array, matrix:Matrix, dx:Number = 0, dy:Number = 0):void {
			var i:int, len:int;
			len = points.length;
			for (i = 0; i < len; i += 2) {
				_addPointToRst(rst, points[i] + dx, points[i + 1] + dy, matrix);
			}
		}
		
		private static function _addPointToRst(rst:Array, x:Number, y:Number, matrix:Matrix):void {
			var _tempPoint:Point = Point.TEMP;
			_tempPoint.setTo(x ? x : 0, y ? y : 0);
			matrix.transformPoint(_tempPoint);
			rst.push(_tempPoint.x, _tempPoint.y);
		}
		
		private function _getPiePoints(x:Number, y:Number, radius:Number, startAngle:Number, endAngle:Number):Array {
			var rst:Array = _tempPoints;
			_tempPoints.length = 0;
			rst.push(x, y);
			var delta:Number =  (endAngle - startAngle) % ( 2 * Math.PI);
			var segnum:int = 10;
			var step:Number = delta / segnum;		
			var i:Number;
			var angle:Number = startAngle;
			for (i = 0; i <= segnum; i++) {
				rst.push(x + radius * Math.cos(angle), y + radius * Math.sin(angle));
				angle += step;
			}
			return rst;
		}
		
		private function _getPathPoints(paths:Array):Array {
			var i:int, len:int;
			var rst:Array = _tempPoints;
			rst.length = 0;
			len = paths.length;
			var tCMD:Array;
			for (i = 0; i < len; i++) {
				tCMD = paths[i];
				if (tCMD.length > 1) {
					rst.push(tCMD[1], tCMD[2]);
					if (tCMD.length > 3) {
						rst.push(tCMD[3], tCMD[4]);
					}
				}
			}
			return rst;
		}
		
		
	}

}