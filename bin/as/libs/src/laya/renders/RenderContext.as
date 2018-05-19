package laya.renders {
	
	import laya.maths.Matrix;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.utils.HTMLChar;
	import laya.utils.RunDriver;
	import laya.utils.Stat;
	
	/**
	 * @private
	 * 渲染环境
	 */
	public class RenderContext {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		/**Math.PI*2的结果缓存 */
		public static var PI2:Number =/*[STATIC SAFE]*/ 2 * Math.PI;
		/**全局x坐标 */
		public var x:Number = 0;
		/**全局y坐标 */
		public var y:Number = 0;
		/**当前使用的画布 */
		public var canvas:HTMLCanvas;
		/**当前使用的画布上下文 */
		public var ctx:*;
		
		/**销毁当前渲染环境*/
		public function destroy():void {
			if (canvas) {
				canvas.destroy();
				canvas = null;
				ctx = null;
			}
			if (ctx) {
				ctx.destroy();
				ctx = null;
			}
		}
		
		public function RenderContext(width:Number, height:Number, canvas:HTMLCanvas = null) {
			if (canvas) {
				ctx = canvas.getContext('2d') as Context;
			} else {
				canvas = HTMLCanvas.create("3D");
				ctx = RunDriver.createWebGLContext2D(canvas);
				canvas._setContext(ctx);
			}
			canvas.size(width, height);
			this.canvas = canvas;
		}
		
		public function drawTexture(tex:Texture, x:Number, y:Number, width:Number, height:Number):void {
			if (tex.loaded) this.ctx.drawTexture(tex, x, y, width, height, this.x, this.y);
		}
		
		public var _drawTexture:Function = function(x:Number, y:Number, args:Array):void {
			if (args[0].loaded) this.ctx.drawTexture(args[0], args[1], args[2], args[3], args[4], x, y);
		}
		
		public function _drawTextures(x:Number, y:Number, args:Array):void
		{
			if (args[0].loaded) this.ctx.drawTextures(args[0], args[1], x+this.x, y+this.y);
		}
		
		public var _fillTexture:Function = function(x:Number, y:Number, args:Array):void {
			if (args[0].loaded) this.ctx.fillTexture(args[0], args[1]+x, args[2]+y, args[3], args[4], args[5], args[6],args[7]);
		}
		
		public function drawTextureWithTransform(tex:Texture, x:Number, y:Number, width:Number, height:Number, m:Matrix, alpha:Number):void {
			if (tex.loaded) this.ctx.drawTextureWithTransform(tex, x, y, width, height, m, this.x, this.y,alpha);
		}
		public var _drawTextureWithTransform:Function = function(x:Number, y:Number, args:Array):void {
			if (args[0].loaded) this.ctx.drawTextureWithTransform(args[0], args[1], args[2], args[3], args[4], args[5], x, y,args[6]);
		}
		
		public function fillQuadrangle(tex:*, x:Number, y:Number, point4:Array, m:Matrix):void {
			this.ctx.fillQuadrangle(tex, x, y, point4, m);
		}
		public var _fillQuadrangle:Function = function(x:Number, y:Number, args:Array):void {
			//this.ctx.fillQuadrangle(args[0], args[1], args[2], args[3],args[4],x,y);
			this.ctx.fillQuadrangle(args[0], args[1], args[2], args[3], args[4]);
		}
		
		public function drawCanvas(canvas:HTMLCanvas, x:Number, y:Number, width:Number, height:Number):void {
			this.ctx.drawCanvas(canvas, x + this.x, y + this.y, width, height);
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number, color:String, lineWidth:Number = 1):void {
			var ctx:* = this.ctx;
			ctx.strokeStyle = color;
			ctx.lineWidth = lineWidth;
			ctx.strokeRect(x + this.x, y + this.y, width, height, lineWidth);
		}
		public var _drawRect:Function = function(x:Number, y:Number, args:Array):void {
			var ctx:* = this.ctx;
			
			//填充矩形
			if (args[4] != null) {
				ctx.fillStyle = args[4];
				ctx.fillRect(x + args[0], y + args[1], args[2], args[3], null);
			}
			
			//绘制矩形边框
			if (args[5] != null) {
				ctx.strokeStyle = args[5];
				ctx.lineWidth = args[6];
				ctx.strokeRect(x + args[0], y + args[1], args[2], args[3], args[6]);
			}
		}
		
		private function _fillAndStroke(fillColor:String, strokeColor:String, lineWidth:int, isConvexPolygon:Boolean = false):void {
			//绘制填充区域
			var ctx:* = this.ctx;
			if (fillColor != null) {
				ctx.fillStyle = fillColor;
				if (Render.isWebGL) {
					ctx.fill(isConvexPolygon);
				} else {
					ctx.fill();
				}
			}
			
			//绘制边框
			if (strokeColor != null && lineWidth > 0) {
				ctx.strokeStyle = strokeColor;
				ctx.lineWidth = lineWidth;
				ctx.stroke();
			}
		}
		
		//矢量方法		
		public var _drawPie:Function = function(x:Number, y:Number, args:Array):void {
			var ctx:* = this.ctx;
			Render.isWebGL && ctx.setPathId(args[8]);
			//移动中心点
			//ctx.translate(x + args[0], y + args[1]);
			//形成路径
			ctx.beginPath();
			if (Render.isWebGL) {
				ctx.movePath(args[0] + x, args[1] + y);
				ctx.moveTo(0, 0);
			} else {
				ctx.moveTo(x + args[0], y + args[1]);
			}
			ctx.arc(x + args[0], y + args[1], args[2], args[3], args[4]);
			ctx.closePath();
			//绘制
			this._fillAndStroke(args[5], args[6], args[7], true);
			//恢复中心点
			//ctx.translate(-x - args[0], -y - args[1]);
		}
		
		public function clipRect(x:Number, y:Number, width:Number, height:Number):void {
			ctx.clipRect(x + this.x, y + this.y, width, height);
		}
		public var _clipRect:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.clipRect(x + args[0], y + args[1], args[2], args[3]);
		}
		
		public function fillRect(x:Number, y:Number, width:Number, height:Number, fillStyle:*):void {
			//this.ctx.fillStyle = color;
			this.ctx.fillRect(x + this.x, y + this.y, width, height, fillStyle);
		}
		public var _fillRect:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.fillRect(x + args[0], y + args[1], args[2], args[3], args[4]);
		}
		
		public function drawCircle(x:Number, y:Number, radius:Number, color:String, lineWidth:Number = 1):void {
			Stat.drawCall++;
			var ctx:* = this.ctx;
			ctx.beginPath();
			ctx.strokeStyle = color;
			ctx.lineWidth = lineWidth;
			ctx.arc(x + this.x, y + this.y, radius, 0, PI2);
			ctx.stroke();
		}
		
		public var _drawCircle:Function = function(x:Number, y:Number, args:Array):void {
			var ctx:* = this.ctx;
			Render.isWebGL && ctx.setPathId(args[6]);
			Stat.drawCall++;
			ctx.beginPath();
			Render.isWebGL && ctx.movePath(args[0] + x, args[1] + y);
			ctx.arc(args[0] + x, args[1] + y, args[2], 0, PI2);
			ctx.closePath();
			//绘制
			this._fillAndStroke(args[3], args[4], args[5], true);
		}
		
		/**
		 * 绘制三角形
		 * @param	x
		 * @param	y
		 * @param	tex
		 * @param	args [x, y, texture,vertices,indices,uvs,matrix]
		 */
		public function drawTriangles(x:Number, y:Number, args:Array):void {
			if (Render.isWebGL) {
				this.ctx.drawTriangles(args[0],x+args[1],y+args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]);
			}else {
				var indices:Uint16Array = args[5];
				var i:int, len:int = indices.length;
				var ctx:Context = this.ctx;
				
				for (i = 0; i < len; i += 3) {
					var index0:int = indices[i] * 2;
					var index1:int = indices[i + 1] * 2;
					var index2:int = indices[i + 2] * 2;
					ctx.drawTriangle(args[0], args[3], args[4], index0, index1, index2, args[6], true);
				}
			}
		}		
		
		public function fillCircle(x:Number, y:Number, radius:Number, color:String):void {
			Stat.drawCall++;
			var ctx:* = this.ctx;
			ctx.beginPath();
			ctx.fillStyle = color;
			ctx.arc(x + this.x, y + this.y, radius, 0, PI2);
			ctx.fill();
		}
		public var _fillCircle:Function = function(x:Number, y:Number, args:Array):void {
			Stat.drawCall++;
			var ctx:* = this.ctx;
			ctx.beginPath();
			ctx.fillStyle = args[3];
			ctx.arc(args[0] + x, args[1] + y, args[2], 0, PI2);
			ctx.fill();
		}
		
		public function setShader(shader:*):void {
			this.ctx.setShader(shader);
		}
		public var _setShader:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.setShader(args[0]);
		}
		
		public function drawLine(fromX:Number, fromY:Number, toX:Number, toY:Number, color:String, lineWidth:Number = 1):void {
			var ctx:* = this.ctx;
			ctx.beginPath();
			ctx.strokeStyle = color;
			ctx.lineWidth = lineWidth;
			ctx.moveTo(this.x + fromX, this.y + fromY);
			ctx.lineTo(this.x + toX, this.y + toY);
			ctx.stroke();
		}
		public var _drawLine:Function = function(x:Number, y:Number, args:Array):void {
			var ctx:* = this.ctx;
			Render.isWebGL && ctx.setPathId(args[6]);
			ctx.beginPath();
			ctx.strokeStyle = args[4];
			ctx.lineWidth = args[5];
			if (Render.isWebGL) {
				ctx.movePath(x, y);
				ctx.moveTo(args[0], args[1]);
				ctx.lineTo(args[2], args[3]);
			} else {
				ctx.moveTo(x + args[0], y + args[1]);
				ctx.lineTo(x + args[2], y + args[3]);
			}
			ctx.stroke();
		}
		
		public var _drawLines:Function = function(x:Number, y:Number, args:Array):void {
			var ctx:* = this.ctx;
			Render.isWebGL && ctx.setPathId(args[5]);
			ctx.beginPath();
			x += args[0], y += args[1];
			Render.isWebGL && ctx.movePath(x, y);
			ctx.strokeStyle = args[3];
			ctx.lineWidth = args[4];
			var points:Array = args[2];
			var i:int = 2, n:int = points.length;
			if (Render.isWebGL) {
				ctx.moveTo(points[0], points[1]);
				while (i < n) {
					ctx.lineTo(points[i++], points[i++]);
				}
			} else {
				ctx.moveTo(x + points[0], y + points[1]);
				while (i < n) {
					ctx.lineTo(x + points[i++], y + points[i++]);
				}
			}
			ctx.stroke();
		}
		
		public var _drawLinesWebGL:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.drawLines(x + this.x + args[0], y + this.y + args[1], args[2], args[3], args[4]);
		}
		
		//x:Number, y:Number, points:Array, lineColor:String, lineWidth:Number = 1
		public var _drawCurves:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.drawCurves(x, y, args);
		}
		
		public var _draw:Function = function(x:Number, y:Number, args:Array):void {
			args[0].call(null, this, x, y);
		}
		
		public function clear():void {
			this.ctx.clear();
		}
		
		public function transformByMatrix(value:Matrix):void {
			
			this.ctx.transformByMatrix(value);
		}
		public var _transformByMatrix:Function = function(x:Number, y:Number, args:Array):void {
			
			this.ctx.transformByMatrix(args[0]);
		}
		
		public function setTransform(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):void {
			this.ctx.setTransform(a, b, c, d, tx, ty);
		}
		public var _setTransform:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.setTransform(args[0], args[1], args[2], args[3], args[4], args[5]);
		}
		
		public function setTransformByMatrix(value:Matrix):void {
			this.ctx.setTransformByMatrix(value);
		}
		public var _setTransformByMatrix:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.setTransformByMatrix(args[0]);
		}
		
		public function save():void {
			this.ctx.save();
		}
		public var _save:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.save();
		}
		
		public function restore():void {
			this.ctx.restore();
		}
		public var _restore:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.restore();
		}
		
		public function translate(x:Number, y:Number):void {
			this.ctx.translate(x, y);
		}
		public var _translate:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.translate(args[0], args[1]);
		}
		
		public function transform(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):void {
			this.ctx.transform(a, b, c, d, tx, ty);
		}
		public var _transform:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.translate(args[1] + x, args[2] + y);
			var mat:Matrix = args[0];
			this.ctx.transform(mat.a, mat.b, mat.c, mat.d, mat.tx, mat.ty);
			this.ctx.translate(-x - args[1], -y - args[2]);
		}
		
		public function rotate(angle:Number):void {
			this.ctx.rotate(angle);
		}
		public var _rotate:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.translate(args[1] + x, args[2] + y);
			this.ctx.rotate(args[0]);
			this.ctx.translate(-x - args[1], -y - args[2]);
		}
		
		public function scale(scaleX:Number, scaleY:Number):void {
			this.ctx.scale(scaleX, scaleY);
		}
		public var _scale:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.translate(args[2] + x, args[3] + y);
			this.ctx.scale(args[0], args[1]);
			this.ctx.translate(-x - args[2], -y - args[3]);
		}
		
		public function alpha(value:Number):void {
			this.ctx.globalAlpha *= value;
		}
		public var _alpha:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.globalAlpha *= args[0];
		}
		
		public function setAlpha(value:Number):void {
			this.ctx.globalAlpha = value;
		}
		public var _setAlpha:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.globalAlpha = args[0];
		}
		
		public function fillWords(words:Vector.<HTMLChar>, x:Number, y:Number, font:String, color:String,underLine:int=0):void {
			this.ctx.fillWords(words, x, y, font, color,underLine);
		}
		/*** @private */
		public function fillBorderWords(words:Vector.<HTMLChar>, x:Number, y:Number, font:String, fillColor:String, borderColor:String, lineWidth:int):void {	
			this.ctx.fillBorderWords(words, x, y, font, fillColor,borderColor,lineWidth);
		}
		public function fillText(text:String, x:Number, y:Number, font:String, color:String, textAlign:String):void {
			this.ctx.fillText(text, x + this.x, y + this.y, font, color, textAlign);
		}
		public var _fillText:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.fillText(args[0], args[1] + x, args[2] + y, args[3], args[4], args[5]);
		}
		
		public function strokeText(text:String, x:Number, y:Number, font:String, color:String, lineWidth:Number, textAlign:String):void {
			ctx.strokeText(text, x + this.x, y + this.y, font, color, lineWidth, textAlign);
		}
		public var _strokeText:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.strokeText(args[0], args[1] + x, args[2] + y, args[3], args[4], args[5], args[6]);
		}
		
		public var _fillBorderText:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.fillBorderText(args[0], args[1] + x, args[2] + y, args[3], args[4], args[5], args[6], args[7]);
		}
		
		public function blendMode(type:String):void {
			this.ctx.globalCompositeOperation = type;
		}
		public var _blendMode:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.globalCompositeOperation = args[0];
		}
		
		public function flush():void {
			this.ctx.flush && this.ctx.flush();
		}
		
		public function addRenderObject(o:*):void {
			this.ctx.addRenderObject(o);
		}
		
		public function beginClip(x:Number, y:Number, w:Number, h:Number):void {
			this.ctx.beginClip && this.ctx.beginClip(x, y, w, h);
		}
		public var _beginClip:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.beginClip && this.ctx.beginClip(x + args[0], y + args[1], args[2], args[3]);
		}
		
		public function endClip():void {
			this.ctx.endClip && this.ctx.endClip();
		}
		
		public var _setIBVB:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.setIBVB(args[0] + x, args[1] + y, args[2], args[3], args[4], args[5], args[6], args[7]);
		}
		
		public function fillTrangles(x:Number, y:Number, args:Array):void {
			this.ctx.fillTrangles(args[0], args[1], args[2], args[3], args.length > 4 ? args[4] : null);
		}
		public var _fillTrangles:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.fillTrangles(args[0], args[1] + x, args[2] + y, args[3], args[4]);
		}
		
		//x:Number, y:Number, paths:Array, brush:Object = null, pen:Object = null
		public var _drawPath:Function = function(x:Number, y:Number, args:Array):void {
			//形成路径
			var ctx:* = this.ctx;
			Render.isWebGL && ctx.setPathId(-1);
			ctx.beginPath();
			x += args[0], y += args[1];
			Render.isWebGL && ctx.movePath(x, y);
			var paths:Array = args[2];
			for (var i:int = 0, n:int = paths.length; i < n; i++) {
				
				var path:Array = paths[i];
				switch (path[0]) {
				case "moveTo": 
					Render.isWebGL ? ctx.moveTo(path[1], path[2]) : ctx.moveTo(x + path[1], y + path[2]);
					break;
				case "lineTo": 
					Render.isWebGL ? ctx.lineTo(path[1], path[2]) : ctx.lineTo(x + path[1], y + path[2]);
					break;
				case "arcTo": 
					Render.isWebGL ? ctx.arcTo(path[1], path[2], path[3], path[4], path[5]) : ctx.arcTo(x + path[1], y + path[2], x + path[3], y + path[4], path[5]);
					break;
				case "closePath": 
					ctx.closePath();
					break;
				}
			}
			
			var brush:Object = args[3];
			if (brush != null) {
				ctx.fillStyle = brush.fillStyle;
				ctx.fill();
			}
			
			var pen:Object = args[4];
			if (pen != null) {
				ctx.strokeStyle = pen.strokeStyle;
				ctx.lineWidth = pen.lineWidth || 1;
				ctx.lineJoin = pen.lineJoin;
				ctx.lineCap = pen.lineCap;
				ctx.miterLimit = pen.miterLimit;
				ctx.stroke();
			}
		}
		
		//这个和_drawPoly的区别？
		//		polygon(x:Number,y:Number,r:Number,edges:Number,color:uint,borderWidth:int=2,borderColor:uint=0)
		public var drawPoly:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.drawPoly(x + this.x + args[0], y + this.y + args[1], args[2], args[3], args[4], args[5], args[6]);
		}
		//x:Number, y:Number, points:Array, fillColor:String, lineColor:String = null, lineWidth:Number = 1
		public var _drawPoly:Function = function(x:Number, y:Number, args:Array):void {
			var ctx:* = this.ctx;
			var points:Array = args[2];
			var i:int = 2, n:int = points.length;
			if (Render.isWebGL) {
				ctx.setPathId(args[6]);
				ctx.beginPath();
				x += args[0], y += args[1];
				ctx.movePath(x, y);
				ctx.moveTo(points[0], points[1]);
				while (i < n) {
					ctx.lineTo(points[i++], points[i++]);
				}
			} else {
				ctx.beginPath();
				x += args[0], y += args[1];
				ctx.moveTo(x + points[0], y + points[1]);
				while (i < n) {
					ctx.lineTo(x + points[i++], y + points[i++]);
				}				
			}
			ctx.closePath();
			this._fillAndStroke(args[3], args[4], args[5], args[7]);
		}
		
		public var _drawSkin:Function = function(x:Number, y:Number, args:Array):void {
			var tSprite:* = args[0];
			if (tSprite)
			{
				var ctx:* = this.ctx;
				tSprite.render(ctx,x,y);
			}
		}
		
		public var _drawParticle:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.drawParticle(x + this.x, y + this.y, args[0]);
		}
		
		
		public var _setFilters:Function = function(x:Number, y:Number, args:Array):void {
			this.ctx.setFilters(args);
		}
		//(f:ColorFilter):void
	}
}