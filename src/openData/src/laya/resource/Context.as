package laya.resource {
	import laya.filters.ColorFilter;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.renders.Render;
	import laya.utils.Stat;
	
	/**
	 * @private
	 * Context扩展类
	 */
	public dynamic class Context {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public var _canvas:HTMLCanvas;
		public static var ENUM_TEXTALIGN_DEFAULT:int = 0;
		public static var ENUM_TEXTALIGN_CENTER:int = 1;
		public static var ENUM_TEXTALIGN_RIGHT:int = 2;
		
		/**@private */
		public static function __init__(to:* = null):void {
			var from:* = Context.prototype;
			to = to || __JS__("CanvasRenderingContext2D.prototype");
			//--------xiaosong-------------start----
			if(to.init2d) return;
			to.init2d = true;
			//--------xiaosong-------------end----
			//to.fillText = to.fillText;
			//to.fillRect = to.fillRect;
			//to.strokeText = to.strokeText;
			var funs:Array = ["saveTransform","restoreTransform", "transformByMatrix","drawTriangles", "drawTriangle", 'drawTextures', 'fillWords', 'fillBorderWords', 'drawRect', 'strokeWord', 'drawText', 'fillTexture', 'setTransformByMatrix', 'clipRect', 'drawTexture', 'drawTexture2', 'drawTextureWithTransform', 'flush', 'clear', 'destroy', 'drawCanvas', 'fillBorderText', 'drawCurves', "_drawRect", "alpha", "_transform", "_rotate", "_scale", "_drawLine", "_drawLines", "_drawCircle", "_fillAndStroke", "_drawPie", "_drawPoly", "_drawPath","drawTextureWithTransform"];
			funs.forEach(function(i:String):void {
				to[i] = from[i];
			});
		}
		
		/*[IF-FLASH-BEGIN]*/ /**@private */
		public function set font(str:String):void {
		}
		
		/**@private */
		public function set textBaseline(value:String):void {
		}
		
		/**@private */
		public function set fillStyle(value:*):void {
		}
		
		/**@private */
		public function translate(x:Number, y:Number):void {
		}
		
		/**@private */
		public function scale(scaleX:Number, scaleY:Number):void {
		}
		
		/**@private */
		public function drawImage(... args):void {
		}
		
		/**@private */
		public function getImageData(... args):* {
		}
		
		/**@private */
		public function measureText(text:String):* {
			return null;
		}
		
		/**@private */
		public function setTransform(... args):void {
		}
		
		/**@private */
		public function beginPath(convex:Boolean=false):void {
		}
		
		/**@private */
		public function set strokeStyle(value:*):void {
		}
		
		/**@private */
		public function get globalCompositeOperation():String {
			return null;
		}
		
		public function set globalCompositeOperation(value:String):void {
		}
		
		/**获取canvas */
		public function get canvas():HTMLCanvas {
			return _canvas;
		}
		
		/**@private */
		public function rect(x:Number, y:Number, width:Number, height:Number):void {
		}
		
		/**@private */
		public function stroke():void {
		}
		
		/**@private */
		public function $transform(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):void {
		}
		
		/**@private */
		public function save():void {
		}
		
		/**@private */
		public function restore():void {
		}
		
		/**@private */
		public function clip():void {
		}
		
		/**@private */
		public function arcTo(x1:Number, y1:Number, x2:Number, y2:Number, r:Number):void {
		}
		
		/**@private */
		public function quadraticCurveTo(cpx:Number, cpy:Number, x:Number, y:Number):void {
		}
		
		/**@private */
		public function get lineJoin():String {
			return null;
		}
		
		/**@private */
		public function set lineJoin(value:String):void {
		}
		
		/**@private */
		public function get lineCap():String {
			return null;
		}
		
		/**@private */
		public function set lineCap(value:String):void {
		}
		
		/**@private */
		public function get miterLimit():String {
			return null;
		}
		
		/**@private */
		public function set miterLimit(value:String):void {
		}
		
		/**@private */
		public function get globalAlpha():Number {
			return 0;
		}
		
		/**@private */
		public function set globalAlpha(value:Number):void {
		}
		
		/**@private */
		public function clearRect(x:Number, y:Number, width:Number, height:Number):void {
		}
		
		/**@private */
		public function moveTo(x:Number, y:Number,b:Boolean=true):void {
		}
		
		/**@private */
		public function lineTo(x:Number, y:Number,b:Boolean=true):void {
		}
		
		public function closePath():void {
		
		}
		
		/*[IF-FLASH-END]*/
		
		/**@private */
		//TODO:coverage
		public function drawCanvas(canvas:HTMLCanvas, x:Number, y:Number, width:Number, height:Number):void {
			Stat.drawCall++;
			this.drawImage(canvas._source, x, y, width, height);
		}
		
		/**@private */
		//TODO:coverage
		public function _drawRect(x:Number, y:Number, width:Number, height:Number, style:*):void {
			Stat.drawCall++;
			style && (this.fillStyle = style);
			__JS__("this.fillRect(x, y,width,height)");
		}
		
		/**@private */
		//TODO:coverage
		public function drawText(text:*, x:Number, y:Number, font:String, color:String, textAlign:String):void {
			Stat.drawCall++;
			if (arguments.length > 3 && font != null) {
				this.font = font;
				this.fillStyle = color;
				__JS__("this.textAlign = textAlign");
				this.textBaseline = "top";
			}
			__JS__("this.fillText(text, x, y)");
		}
		
		/**@private */
		//TODO:coverage
		public function fillBorderText(text:*, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:int, textAlign:String):void {
			Stat.drawCall++;
			
			this.font = font;
			this.fillStyle = fillColor;
			this.textBaseline = "top";
			
			__JS__("this.strokeStyle = borderColor");
			__JS__("this.lineWidth = lineWidth");
			__JS__("this.textAlign = textAlign");
			__JS__("this.strokeText(text, x, y)");
			__JS__("this.fillText(text, x, y)");
		
		}
		
		/*** @private */
		//TODO:coverage
		public function fillWords(words:Array, x:Number, y:Number, font:String, color:String):void {
			font && (this.font = font);
			color && (this.fillStyle = color);
			this.textBaseline = "top";
			__JS__("this.textAlign = 'left'");
			for (var i:int = 0, n:int = words.length; i < n; i++) {
				var a:* = words[i];
				__JS__("this.fillText(a.char, a.x + x, a.y + y)");
			}
		}
		
		/*** @private */
		//TODO:coverage
		public function fillBorderWords(words:Array, x:Number, y:Number, font:String, color:String, borderColor:String, lineWidth:int):void {
			font && (this.font = font);
			color && (this.fillStyle = color);
			this.textBaseline = "top";
			__JS__("this.lineWidth = lineWidth");
			__JS__("this.textAlign = 'left'");
			__JS__("this.strokeStyle = borderColor");
			for (var i:int = 0, n:int = words.length; i < n; i++) {
				var a:* = words[i];
				__JS__("this.strokeText(a.char, a.x + x, a.y + y)");
				__JS__("this.fillText(a.char, a.x + x, a.y + y)");
			}
		
		}
		
		/**@private */
		//TODO:coverage
		public function strokeWord(text:*, x:Number, y:Number, font:String, color:String, lineWidth:Number, textAlign:String):void {
			Stat.drawCall++;
			if (arguments.length > 3 && font != null) {
				this.font = font;
				__JS__("this.strokeStyle = color");
				__JS__("this.lineWidth = lineWidth");
				__JS__("this.textAlign = textAlign");
				this.textBaseline = "top";
			}
			__JS__("this.strokeText(text, x, y)");
		}
		
		///**@private */
		//public function transformByMatrix(value:Matrix):void {
			//this.transform(value.a, value.b, value.c, value.d, value.tx, value.ty);
		//}
		
		/**@private */
		//TODO:coverage
		public function setTransformByMatrix(value:Matrix):void {
			this.setTransform(value.a, value.b, value.c, value.d, value.tx, value.ty);
		}
		
		/**@private */
		//TODO:coverage
		public function clipRect(x:Number, y:Number, width:Number, height:Number):void {
			Stat.drawCall++;
			this.beginPath();
			//this.strokeStyle = "red";
			this.rect(x, y, width, height);
			//this.stroke();
			this.clip();
		}
		
		/**@private */
		//TODO:coverage
		public function drawTextureWithTransform(tex:Texture, tx:Number, ty:Number, width:Number, height:Number, m:Matrix, gx:Number, gy:Number, alpha:Number, blendMode:String):void {

			//TODO:优化
			if (!tex._getSource())
				return;
			Stat.drawCall++;
			
			var alphaChanged:Boolean = alpha !== 1;
			if (alphaChanged) {
				var temp:Number = this.globalAlpha;
				this.globalAlpha *= alpha;
			}
			if (blendMode)
				this.globalCompositeOperation = blendMode;
			
			var uv:Array = tex.uv, w:Number = tex.bitmap._width, h:Number = tex.bitmap._height;
			if (m) {
				this.save();
				this.transform(m.a, m.b, m.c, m.d, m.tx + gx, m.ty + gy);
				this.drawImage(tex.bitmap._source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, tx, ty, width, height);
				this.restore();
			} else {
				this.drawImage(tex.bitmap._source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, gx + tx, gy + ty, width, height);
			}
			if (alphaChanged)
				this.globalAlpha = temp;
			if (blendMode)
				this.globalCompositeOperation = "source-over";
		}
		
		/**@private */
		//TODO:coverage
		public function drawTexture2(x:Number, y:Number, pivotX:Number, pivotY:Number, m:Matrix, args2:Array):void {
			//drawTextureWithTransform(args2[0], x + args2[1] - pivotX, y + args2[2] - pivotY, args2[3], args2[4], args2[5], args2[6], args2[7]);

			var tex:Texture = args2[0];
			//TODO:优化
			Stat.drawCall++;
			
			var uv:Array = tex.uv, w:Number = tex.bitmap._width, h:Number = tex.bitmap._height;
			if (m) {
				this.save();
				this.transform(m.a, m.b, m.c, m.d, m.tx + x, m.ty + y);
				this.drawImage(tex.bitmap._source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, args2[1] - pivotX, args2[2] - pivotY, args2[3], args2[4]);
				this.restore();
			} else {
				this.drawImage(tex.bitmap._source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, args2[1] - pivotX + x, args2[2] - pivotY + y, args2[3], args2[4]);
			}
		}
		
		//TODO:coverage
		public function fillTexture(texture:Texture, x:Number, y:Number, width:Number, height:Number, type:String, offset:Point, other:*):void {
			if (!other.pat) {
				if (texture.uv != Texture.DEF_UV) {
					var canvas:HTMLCanvas = new HTMLCanvas();
					canvas.getContext('2d');
					canvas.size(texture.width, texture.height);
					canvas.context.drawTexture(texture, 0, 0, texture.width, texture.height);
					texture = new Texture(canvas);
				}
				other.pat = this.createPattern(texture.bitmap._source, type);
			}
			var oX:Number = x, oY:Number = y;
			var sX:Number = 0, sY:Number = 0;
			if (offset) {
				oX += offset.x % texture.width;
				oY += offset.y % texture.height;
				sX -= offset.x % texture.width;
				sY -= offset.y % texture.height;
			}
			this.translate(oX, oY);
			_drawRect(sX, sY, width, height, other.pat);
			this.translate(-oX, -oY);
		}
		
		/**@private */
		public function flush():int {
			return 0;
		}
		
		/**@private */
		public function destroy():void {
			__JS__("this.canvas.width = this.canvas.height = 0");
		}
		
		/**@private */
		public function clear():void {
			if(!Render.isConchApp)this.clearRect(0, 0, Render._mainCanvas.width, Render._mainCanvas.height);
		}
		
		//TODO:coverage
		public function drawTriangle(texture:Texture, vertices:Float32Array, uvs:Float32Array, index0:int, index1:int, index2:int, matrix:Matrix, canvasPadding:Boolean):void {
			var source:Bitmap = texture.bitmap;
			var textureSource:* = source._getSource();
			var textureWidth:Number = texture.width;
			var textureHeight:Number = texture.height;
			var sourceWidth:Number = source.width;
			var sourceHeight:Number = source.height;
			
			//uv数据
			var u0:Number = uvs[index0] * sourceWidth;
			var u1:Number = uvs[index1] * sourceWidth;
			var u2:Number = uvs[index2] * sourceWidth;
			var v0:Number = uvs[index0 + 1] * sourceHeight;
			var v1:Number = uvs[index1 + 1] * sourceHeight;
			var v2:Number = uvs[index2 + 1] * sourceHeight;
			
			//绘制顶点数据
			var x0:Number = vertices[index0];
			var x1:Number = vertices[index1];
			var x2:Number = vertices[index2];
			var y0:Number = vertices[index0 + 1];
			var y1:Number = vertices[index1 + 1];
			var y2:Number = vertices[index2 + 1];
			
			//扩展区域，解决黑边问题
			if (canvasPadding) {
				var paddingX:Number = 1;
				var paddingY:Number = 1;
				var centerX:Number = (x0 + x1 + x2) / 3;
				var centerY:Number = (y0 + y1 + y2) / 3;
				
				var normX:Number = x0 - centerX;
				var normY:Number = y0 - centerY;
				var dist:Number = Math.sqrt((normX * normX) + (normY * normY));
				
				x0 = centerX + ((normX / dist) * (dist + paddingX));
				y0 = centerY + ((normY / dist) * (dist + paddingY));
				
				normX = x1 - centerX;
				normY = y1 - centerY;
				
				dist = Math.sqrt((normX * normX) + (normY * normY));
				x1 = centerX + ((normX / dist) * (dist + paddingX));
				y1 = centerY + ((normY / dist) * (dist + paddingY));
				
				normX = x2 - centerX;
				normY = y2 - centerY;
				
				dist = Math.sqrt((normX * normX) + (normY * normY));
				x2 = centerX + ((normX / dist) * (dist + paddingX));
				y2 = centerY + ((normY / dist) * (dist + paddingY));
			}
			
			this.save();
			if (matrix)
				this.transform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
			
			//创建三角形裁剪区域
			this.beginPath();
			this.moveTo(x0, y0);
			this.lineTo(x1, y1);
			this.lineTo(x2, y2);
			this.closePath();
			this.clip();
			
			// 计算矩阵，将图片变形到合适的位置
			var delta:Number = (u0 * v1) + (v0 * u2) + (u1 * v2) - (v1 * u2) - (v0 * u1) - (u0 * v2);
			var dDelta:Number = 1 / delta;
			var deltaA:Number = (x0 * v1) + (v0 * x2) + (x1 * v2) - (v1 * x2) - (v0 * x1) - (x0 * v2);
			var deltaB:Number = (u0 * x1) + (x0 * u2) + (u1 * x2) - (x1 * u2) - (x0 * u1) - (u0 * x2);
			var deltaC:Number = (u0 * v1 * x2) + (v0 * x1 * u2) + (x0 * u1 * v2) - (x0 * v1 * u2) - (v0 * u1 * x2) - (u0 * x1 * v2);
			var deltaD:Number = (y0 * v1) + (v0 * y2) + (y1 * v2) - (v1 * y2) - (v0 * y1) - (y0 * v2);
			var deltaE:Number = (u0 * y1) + (y0 * u2) + (u1 * y2) - (y1 * u2) - (y0 * u1) - (u0 * y2);
			var deltaF:Number = (u0 * v1 * y2) + (v0 * y1 * u2) + (y0 * u1 * v2) - (y0 * v1 * u2) - (v0 * u1 * y2) - (u0 * y1 * v2);
			
			this.transform(deltaA * dDelta, deltaD * dDelta, deltaB * dDelta, deltaE * dDelta, deltaC * dDelta, deltaF * dDelta);
			this.drawImage(textureSource, texture.uv[0] * sourceWidth, texture.uv[1] * sourceHeight, textureWidth, textureHeight, texture.uv[0] * sourceWidth, texture.uv[1] * sourceHeight, textureWidth, textureHeight);
			this.restore();
		}
		
		//=============新增==================
		public function transformByMatrix(matrix:Matrix,tx:Number,ty:Number):void {
			this.transform(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx + tx, matrix.ty + ty);			
		}
		
		public function saveTransform(matrix:Matrix):void {
			this.save();
		}
		
		public function restoreTransform(matrix:Matrix):void {
			this.restore();
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number, fillColor:*, lineColor:*, lineWidth:Number):void {
			var ctx:* = this;
			
			//填充矩形
			if (fillColor != null) {
				ctx.fillStyle = fillColor;
				ctx.fillRect(x, y, width, height);
			}
			
			//绘制矩形边框
			if (lineColor != null) {
				ctx.strokeStyle = lineColor;
				ctx.lineWidth = lineWidth;
				ctx.strokeRect(x, y, width, height);
			}
		}
		
		/**@private */
		//TODO:coverage
		public function drawTexture(tex:Texture, x:Number, y:Number, width:Number, height:Number):void {
			var source:*= tex._getSource();
			if (!source) return;
			Stat.drawCall++;
			var uv:Array = tex.uv, w:Number = tex.bitmap.width, h:Number = tex.bitmap.height;
			this.drawImage(source, uv[0] * w, uv[1] * h, (uv[2] - uv[0]) * w, (uv[5] - uv[3]) * h, x, y, width, height);
		}
		
		public function drawTextures(tex:Texture, pos:Array, tx:Number, ty:Number):void {
			Stat.drawCall += pos.length / 2;
			var w:Number = tex.width;
			var h:Number = tex.height;
			for (var i:int = 0, sz:int = pos.length; i < sz; i += 2) {
				drawTexture(tex, pos[i] + tx, pos[i + 1] + ty, w, h);
			}
		}
		
		/**
		 * 绘制三角形
		 * @param	x
		 * @param	y
		 * @param	tex
		 * @param	args [x, y, texture,vertices,indices,uvs,matrix]
		 */
		//TODO:coverage
		public function drawTriangles(texture:Texture, x:Number, y:Number, vertices:Float32Array, uvs:Float32Array, indices:Uint16Array, matrix:Matrix, alpha:Number, color:ColorFilter, blendMode:String):void {
			var i:int, len:int = indices.length;
			this.translate(x, y);
			for (i = 0; i < len; i += 3) {
				var index0:int = indices[i] * 2;
				var index1:int = indices[i + 1] * 2;
				var index2:int = indices[i + 2] * 2;
				this.drawTriangle(texture, vertices, uvs, index0, index1, index2, matrix, true);
			}
			this.translate(-x, -y);
		}
		
		public function alpha(value:Number):void {
			this.globalAlpha *= value;
		}
		
		//TODO:coverage
		public function _transform(mat:Matrix, pivotX:Number, pivotY:Number):void {
			this.translate(pivotX, pivotY);
			this.transform(mat.a, mat.b, mat.c, mat.d, mat.tx, mat.ty);
			this.translate(-pivotX, -pivotY);
		}
		
		public function _rotate(angle:Number, pivotX:Number, pivotY:Number):void {
			this.translate(pivotX, pivotY);
			this.rotate(angle);
			this.translate(-pivotX, -pivotY);
		}
		
		public function _scale(scaleX:Number, scaleY:Number, pivotX:Number, pivotY:Number):void {
			this.translate(pivotX, pivotY);
			this.scale(scaleX, scaleY);
			this.translate(-pivotX, -pivotY);
		}
		
		public function _drawLine(x:Number, y:Number, fromX:Number, fromY:Number, toX:Number, toY:Number, lineColor:String, lineWidth:Number, vid:int):void {
			//Render.isWebGL && this.setPathId(vid);
			this.beginPath();
			this.strokeStyle = lineColor;
			this.lineWidth = lineWidth;
			this.moveTo(x + fromX, y + fromY);
			this.lineTo(x + toX, y + toY);
			this.stroke();
		}
		
		public function _drawLines(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number, vid:int):void {
			Render.isWebGL && this.setPathId(vid);
			this.beginPath();
			//x += args[0], y += args[1];
			//Render.isWebGL && this.movePath(x, y);
			this.strokeStyle = lineColor;
			this.lineWidth = lineWidth;
			//var points:Array = args[2];
			var i:int = 2, n:int = points.length;
			if (Render.isWebGL) {
				this.addPath(points.slice(),false,false,x,y);
			} else {
				this.moveTo(x + points[0], y + points[1]);
				while (i < n) {
					this.lineTo(x + points[i++], y + points[i++]);
				}
			}
			this.stroke();
		}
		
		public function drawCurves(x:Number, y:Number, points:Array, lineColor:*, lineWidth:Number):void {
			this.beginPath();
			this.strokeStyle = lineColor;
			this.lineWidth = lineWidth;
			//var points:Array = args[2];
			//x += args[0], y += args[1];
			this.moveTo(x + points[0], y + points[1]);
			var i:int = 2, n:int = points.length;
			while (i < n) {
				this.quadraticCurveTo(x + points[i++], y + points[i++], x + points[i++], y + points[i++]);
			}
			this.stroke();
		}
		
		private function _fillAndStroke(fillColor:String, strokeColor:String, lineWidth:int, isConvexPolygon:Boolean = false):void {
			//绘制填充区域
			if (fillColor != null) {
				this.fillStyle = fillColor;
				this.fill();
			}
			
			//绘制边框
			if (strokeColor != null && lineWidth > 0) {
				this.strokeStyle = strokeColor;
				this.lineWidth = lineWidth;
				this.stroke();
			}
		}
		/**Math.PI*2的结果缓存 */
		public static var PI2:Number =/*[STATIC SAFE]*/ 2 * Math.PI;
		public function _drawCircle(x:Number, y:Number, radius:Number, fillColor:*, lineColor:*, lineWidth:Number, vid:int):void {
			//Render.isWebGL && this.setPathId(vid);
			Stat.drawCall++;
			Render.isWebGL? __JS__('this.beginPath(true)'): this.beginPath();
			this.arc(x, y, radius, 0, PI2);
			this.closePath();
			//绘制
			this._fillAndStroke(fillColor, lineColor, lineWidth);
		}
		
		//矢量方法		
		public function _drawPie(x:Number,y:Number,radius:Number,startAngle:Number,endAngle:Number,fillColor:*,lineColor:*,lineWidth:Number,vid:int):void {
			//Render.isWebGL && this.setPathId(vid);
			//移动中心点
			//ctx.translate(x + args[0], y + args[1]);
			//形成路径
			this.beginPath();
			this.moveTo(x , y);
			this.arc(x, y, radius, startAngle, endAngle);
			this.closePath();
			//绘制
			this._fillAndStroke(fillColor, lineColor, lineWidth);
			//恢复中心点
			//ctx.translate(-x - args[0], -y - args[1]);
		}
		
		public function _drawPoly(x:Number, y:Number, points:Array, fillColor:*, lineColor:*, lineWidth:Number, isConvexPolygon:Boolean, vid:int):void {
			//var points:Array = args[2];
			var i:int = 2, n:int = points.length;
			this.beginPath();
			if (Render.isWebGL) {
				this.setPathId(vid);
				//poly一定是close的
				this.addPath(points.slice(),true,isConvexPolygon,x,y);
			} else {
				//x += args[0], y += args[1];
				this.moveTo(x + points[0], y + points[1]);
				while (i < n) {
					this.lineTo(x + points[i++], y + points[i++]);
				}
			}
			this.closePath();
			this._fillAndStroke(fillColor, lineColor, lineWidth, isConvexPolygon);
		}
		
		public function _drawPath(x:Number, y:Number, paths:Array, brush:Object, pen:Object):void {
			//形成路径
			//Render.isWebGL && this.setPathId(-1);
			this.beginPath();
			//x += args[0], y += args[1];
			
			//var paths:Array = args[2];
			for (var i:int = 0, n:int = paths.length; i < n; i++) {
				
				var path:Array = paths[i];
				switch (path[0]) {
				case "moveTo": 
					this.moveTo(x + path[1], y + path[2]);
					break;
				case "lineTo": 
					this.lineTo(x + path[1], y + path[2]);
					break;
				case "arcTo": 
					this.arcTo(x + path[1], y + path[2], x + path[3], y + path[4], path[5]);
					break;
				case "closePath": 
					this.closePath();
					break;
				}
			}
			
			//var brush:Object = args[3];
			if (brush != null) {
				this.fillStyle = brush.fillStyle;
				this.fill();
			}
			
			//var pen:Object = args[4];
			if (pen != null) {
				this.strokeStyle = pen.strokeStyle;
				this.lineWidth = pen.lineWidth || 1;
				this.lineJoin = pen.lineJoin;
				this.lineCap = pen.lineCap;
				this.miterLimit = pen.miterLimit;
				this.stroke();
			}
		}
		
		public function drawParticle(x:Number, y:Number, pt:*):void{}
	}
}