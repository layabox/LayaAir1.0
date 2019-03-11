package laya.display {
	import laya.display.cmd.AlphaCmd;
	import laya.display.cmd.DrawCircleCmd;
	import laya.display.cmd.DrawCurvesCmd;
	import laya.display.cmd.DrawImageCmd;
	import laya.display.cmd.DrawLineCmd;
	import laya.display.cmd.DrawLinesCmd;
	import laya.display.cmd.DrawPathCmd;
	import laya.display.cmd.DrawPieCmd;
	import laya.display.cmd.DrawPolyCmd;
	import laya.display.cmd.DrawRectCmd;
	import laya.display.cmd.DrawTextureCmd;
	import laya.display.cmd.FillTextureCmd;
	import laya.display.cmd.RestoreCmd;
	import laya.display.cmd.RotateCmd;
	import laya.display.cmd.ScaleCmd;
	import laya.display.cmd.TransformCmd;
	import laya.display.cmd.TranslateCmd;
	import laya.maths.Bezier;
	import laya.maths.GrahamScan;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.utils.Utils;
	
	/**
	 * @private
	 * Graphic bounds数据类
	 */
	public class GraphicsBounds {
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
		public function destroy():void {
			_graphics = null;
			_cacheBoundsType = false;
			if (_temp) _temp.length = 0;
			if (_rstBoundPoints) _rstBoundPoints.length = 0;
			if (_bounds) _bounds.recover();
			_bounds = null;
			Pool.recover("GraphicsBounds", this);
		}
		
		/**
		 * 创建
		 */
		public static function create():GraphicsBounds {
			return Pool.getItemByClass("GraphicsBounds", GraphicsBounds);
		}
		
		/**
		 * 重置数据
		 */
		public function reset():void {
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
			var context:Context = Render._context;
			var cmds:Array = _graphics.cmds;
			var rst:Array;
			rst = _temp || (_temp = []);
			
			rst.length = 0;
			if (!cmds && _graphics._one != null) {
				_tempCmds.length = 0;
				_tempCmds.push(_graphics._one);
				cmds = _tempCmds;
			}
			if (!cmds) return rst;
			
			var matrixs:Array = _tempMatrixArrays;
			matrixs.length = 0;
			var tMatrix:Matrix = _initMatrix;
			tMatrix.identity();
			var tempMatrix:Matrix = _tempMatrix;
			var cmd:Object;
			var tex:Texture;
			for (var i:int = 0, n:int = cmds.length; i < n; i++) {
				cmd = cmds[i];
				switch (cmd.cmdID) {
				case AlphaCmd.ID: //save //TODO:是否还需要
					matrixs.push(tMatrix);
					tMatrix = tMatrix.clone();
					break;
				case RestoreCmd.ID: //restore
					tMatrix = matrixs.pop();
					break;
				case ScaleCmd.ID://scale
					tempMatrix.identity();
					tempMatrix.translate(-cmd.pivotX, -cmd.pivotY);
					tempMatrix.scale(cmd.scaleX, cmd.scaleY);
					tempMatrix.translate(cmd.pivotX, cmd.pivotY);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case RotateCmd.ID://case context._rotate: 
					tempMatrix.identity();
					tempMatrix.translate(-cmd.pivotX, -cmd.pivotY);
					tempMatrix.rotate(cmd.angle);
					tempMatrix.translate(cmd.pivotX, cmd.pivotY);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case TranslateCmd.ID://translate
					tempMatrix.identity();
					tempMatrix.translate(cmd.tx, cmd.ty);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case TransformCmd.ID://context._transform:
					tempMatrix.identity();
					tempMatrix.translate(-cmd.pivotX, -cmd.pivotY);
					tempMatrix.concat(cmd.matrix);
					tempMatrix.translate(cmd.pivotX, cmd.pivotY);
					
					_switchMatrix(tMatrix, tempMatrix);
					break;
				case DrawImageCmd.ID://case context._drawTexture: 
				case FillTextureCmd.ID://case context._fillTexture
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x, cmd.y, cmd.width, cmd.height), tMatrix);
					break;
				case DrawTextureCmd.ID://case context._drawTextureTransform: 
					tMatrix.copyTo(tempMatrix);
					if(cmd.matrix)
					tempMatrix.concat(cmd.matrix);
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x, cmd.y, cmd.width, cmd.height), tempMatrix);
					break;
				case DrawImageCmd.ID: 
					tex = cmd.texture;
					if (realSize) {
						if (cmd.width && cmd.height) {
							_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x, cmd.y, cmd.width, cmd.height), tMatrix);
						} else {
							_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x, cmd.y, tex.width, tex.height), tMatrix);
						}
					} else {
						var wRate:Number = (cmd.width || tex.sourceWidth) / tex.width;
						var hRate:Number = (cmd.height || tex.sourceHeight) / tex.height;
						var oWidth:Number = wRate * tex.sourceWidth;
						var oHeight:Number = hRate * tex.sourceHeight;
						
						var offX:Number = tex.offsetX > 0 ? tex.offsetX : 0;
						var offY:Number = tex.offsetY > 0 ? tex.offsetY : 0;
						
						offX *= wRate;
						offY *= hRate;
						
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x - offX, cmd.y - offY, oWidth, oHeight), tMatrix);
					}
					
					break;
				case FillTextureCmd.ID: 
					if (cmd.width && cmd.height) {
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x, cmd.y, cmd.width, cmd.height), tMatrix);
					} else {
						tex = cmd.texture;
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x, cmd.y, tex.width, tex.height), tMatrix);
					}
					break;
				case DrawTextureCmd.ID: 
					var drawMatrix:Matrix;
					if (cmd.matrix) {
						tMatrix.copyTo(tempMatrix);
						tempMatrix.concat(cmd.matrix);
						drawMatrix = tempMatrix;
					} else {
						drawMatrix = tMatrix;
					}
					if (realSize) {
						if (cmd.width && cmd.height) {
							_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x, cmd.y, cmd.width, cmd.height), drawMatrix);
						} else {
							tex = cmd.texture;
							_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x, cmd.y, tex.width, tex.height), drawMatrix);
						}
					} else {
						tex = cmd.texture;
						wRate = (cmd.width || tex.sourceWidth) / tex.width;
						hRate = (cmd.height || tex.sourceHeight) / tex.height;
						oWidth = wRate * tex.sourceWidth;
						oHeight = hRate * tex.sourceHeight;
						
						offX = tex.offsetX > 0 ? tex.offsetX : 0;
						offY = tex.offsetY > 0 ? tex.offsetY : 0;
						
						offX *= wRate;
						offY *= hRate;
						
						_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x - offX, cmd.y - offY, oWidth, oHeight), drawMatrix);
					}
					
					break;
				case DrawRectCmd.ID://case context._drawRect:
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x, cmd.y, cmd.width, cmd.height), tMatrix);
					break;
				case DrawCircleCmd.ID://case context._drawCircle
					_addPointArrToRst(rst, Rectangle._getBoundPointS(cmd.x - cmd.radius, cmd.y - cmd.radius, cmd.radius + cmd.radius, cmd.radius + cmd.radius), tMatrix);
					break;
				case DrawLineCmd.ID://drawLine
					_tempPoints.length = 0;
					var lineWidth:Number;
					lineWidth = cmd.lineWidth * 0.5;
					if (cmd.fromX == cmd.toX) {
						_tempPoints.push(cmd.fromX + lineWidth, cmd.fromY, cmd.toX + lineWidth, cmd.toY, cmd.fromX - lineWidth, cmd.fromY, cmd.toX - lineWidth, cmd.toY);
					} else if (cmd.fromY == cmd.toY) {
						_tempPoints.push(cmd.fromX, cmd.fromY + lineWidth, cmd.toX, cmd.toY + lineWidth, cmd.fromX, cmd.fromY - lineWidth, cmd.toX, cmd.toY - lineWidth);
					} else {
						_tempPoints.push(cmd.fromX, cmd.fromY, cmd.toX, cmd.toY);
					}
					
					_addPointArrToRst(rst, _tempPoints, tMatrix);
					break;
				case DrawCurvesCmd.ID://context._drawCurves:					
					_addPointArrToRst(rst, Bezier.I.getBezierPoints(cmd.points), tMatrix, cmd.x, cmd.y);
					break;
				case DrawLinesCmd.ID://drawpoly
				case DrawPolyCmd.ID://drawpoly
					_addPointArrToRst(rst, cmd.points, tMatrix,  cmd.x, cmd.y);
					break;
				case DrawPathCmd.ID://drawPath
					_addPointArrToRst(rst, _getPathPoints(cmd.paths), tMatrix, cmd.x, cmd.y);
					break;
				case DrawPieCmd.ID://drawPie
					_addPointArrToRst(rst, _getPiePoints(cmd.x, cmd.y, cmd.radius, cmd.startAngle, cmd.endAngle), tMatrix);
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
			var dP:Number = Math.PI / 10;
			var i:Number;
			for (i = startAngle; i < endAngle; i += dP) {
				rst.push(x + radius * Math.cos(i), y + radius * Math.sin(i));
			}
			if (endAngle != i) {
				rst.push(x + radius * Math.cos(endAngle), y + radius * Math.sin(endAngle));
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