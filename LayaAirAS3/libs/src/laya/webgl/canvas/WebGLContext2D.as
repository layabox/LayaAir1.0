package laya.webgl.canvas {
	import laya.display.Sprite;
	import laya.display.Text;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.resource.Bitmap;
	import laya.utils.RunDriver;
	import laya.webgl.resource.RenderTargetMAX;
	import laya.webgl.submit.ISubmit;
	import laya.renders.Render;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.HTMLImage;
	import laya.resource.Texture;
	import laya.utils.Browser;
	import laya.utils.Color;
	import laya.utils.HTMLChar;
	import laya.utils.Stat;
	import laya.utils.Utils;
	import laya.webgl.atlas.AtlasResourceManager;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.submit.SubmitCMD;
	import laya.webgl.submit.SubmitCMDScope;
	import laya.webgl.submit.SubmitScissor;
	import laya.webgl.submit.SubmitStencil;
	import laya.webgl.utils.Buffer;
	import laya.webgl.utils.IndexBuffer;
	import laya.webgl.utils.VertexBuffer;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.canvas.save.ISaveData;
	import laya.webgl.canvas.save.SaveBase;
	import laya.webgl.canvas.save.SaveClipRect;
	import laya.webgl.canvas.save.SaveMark;
	import laya.webgl.canvas.save.SaveTransform;
	import laya.webgl.canvas.save.SaveTranslate;
	import laya.webgl.resource.RenderTarget2D;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.ShaderDefines;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.value.Color2dSV;
	import laya.webgl.shader.d2.value.PrimitiveSV;
	import laya.webgl.shader.d2.value.TextSV;
	import laya.webgl.shader.d2.value.TextureSV;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitCanvas;
	import laya.webgl.submit.SubmitOtherIBVB;
	import laya.webgl.submit.SubmitTarget;
	import laya.webgl.text.DrawText;
	import laya.webgl.text.FontInContext;
	import laya.webgl.utils.CONST3D2D;
	import laya.webgl.utils.GlUtils;
	import laya.webgl.utils.RenderState2D;
	
	/**
	 * ...
	 * @author laya
	 */
	public class WebGLContext2D extends Context {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		
		public static const _SUBMITVBSIZE:int = 32000;
		
		public static const _MAXSIZE:int = 99999999;
		
		public static const _RECTVBSIZE:int = 16;
		
		public static const MAXCLIPRECT:Rectangle = /*[STATIC SAFE]*/ new Rectangle(0, 0, _MAXSIZE, _MAXSIZE);
		
		public static var _COUNT:int = 0;
		
		public static var _tmpMatrix:Matrix = /*[STATIC SAFE]*/ new Matrix();
		
		private static var _fontTemp:FontInContext = new FontInContext();
		private static var _drawStyleTemp:DrawStyle = new DrawStyle(null);
		
		public static function __init__():void {
			ContextParams.DEFAULT = new ContextParams();
		}
		
		public var _x:Number = 0;
		public var _y:Number = 0;
		public var _id:int = ++_COUNT;
		
		private var _other:ContextParams;
		
		private var _path:Path = null;
		private var _drawCount:int = 1;
		private var _maxNumEle:int = 0;
		private var _clear:Boolean = false;
		private var _width:Number = _MAXSIZE;
		private var _height:Number = _MAXSIZE;
		
		public var _submits:* = [];
		public var _mergeID:int = 0;
		public var _curSubmit:* = null;
		public var _ib:IndexBuffer = null;
		public var _vb:VertexBuffer = null;// 不同的顶点格式，使用不同的顶点缓冲区		
		public var _clipRect:Rectangle = MAXCLIPRECT;
		public var _curMat:Matrix;
		public var _nBlendType:int = 0;
		public var _save:*;
		public var _targets:RenderTargetMAX;
		
		public var _saveMark:SaveMark = null;
		public var _shader2D:Shader2D = new Shader2D();
		
		/**所cacheAs精灵*/
		public var sprite:Sprite;
		
		public function WebGLContext2D(c:HTMLCanvas) {
			
			__JS__('this.drawTexture = this._drawTextureM');
			
			_canvas = c;
			
			_curMat = Matrix.create();
			
			if (Render.isFlash) 
			{
				_ib = IndexBuffer.create();
				GlUtils.fillIBQuadrangle(_ib, 16);
			}
			else _ib = IndexBuffer.QuadrangleIB;
			
			_vb = VertexBuffer.create();
			
			_other = ContextParams.DEFAULT;
			
			_save = [SaveMark.Create(this)];
			_save.length = 10;
			
			clear();
		}
		
		public function clearBG(r:int, g:int, b:int, a:int):void {
			var gl:WebGLContext = WebGL.mainContext;
			gl.clearColor(r, g, b, a);
			gl.clear(WebGLContext.COLOR_BUFFER_BIT | WebGLContext.DEPTH_BUFFER_BIT);
		}
		
		public function _getSubmits():Array {
			return _submits;
		}
		
		override public function destroy():void {
			_curMat && _curMat.destroy();
			
			_targets && _targets.destroy();
			
			_vb && _vb.releaseResource();
			_ib && (_ib != IndexBuffer.QuadrangleIB) && _ib.releaseResource();
		}
		
		override public function clear():void {
			_vb.clear();
			
			_targets && (_targets.repaint = true);
			
			_other = ContextParams.DEFAULT;
			_clear = true;
			_mergeID = 0;
			
			_repaint = false;
			
			_drawCount = 1;
			
			_other.lineWidth = _shader2D.ALPHA = 1.0;
			
			_nBlendType = 0;// BlendMode.NORMAL;
			
			_clipRect = MAXCLIPRECT;
			
			_curSubmit = Submit.RENDERBASE;
			_shader2D.glTexture = null;
			_shader2D.fillStyle = _shader2D.strokeStyle = DrawStyle.DEFAULT;
			
			for (var i:int = 0, n:int = _submits._length; i < n; i++)
				_submits[i].releaseRender();
			_submits._length = 0;
			
			_curMat.identity();
			_other.clear();
			
			_saveMark = _save[0];
			_save._length = 1;
		
		}
		
		public function size(w:Number, h:Number):void {
			_width = w;
			_height = h;
			_targets && (_targets.size(w, h));
		}
		
		public function set asBitmap(value:Boolean):void {
			if (value) {
				_targets || (_targets = new RenderTargetMAX());
				_targets.repaint = true;
				if (!_width || !_height) throw Error("asBitmap no size!");
				_targets.size(_width, _height);
			} else _targets = null;
		}
		
		public function _getTransformMatrix():Matrix {
			return this._curMat;
		}
		
		override public function set fillStyle(value:*):void {
			_shader2D.fillStyle.equal(value) || (SaveBase.save(this, SaveBase.TYPE_FILESTYLE, _shader2D, false), _shader2D.fillStyle = new DrawStyle(value));
		}
		
		public function get fillStyle():* {
			return _shader2D.fillStyle;
		}
		
		override public function set globalAlpha(value:Number):void {
			
			value = Math.floor(value * 1000) / 1000;
			if (value != _shader2D.ALPHA) {
				SaveBase.save(this, SaveBase.TYPE_ALPHA, _shader2D, true);
				_shader2D.ALPHA = value;
			}
		}
		
		override public function get globalAlpha():Number {
			return _shader2D.ALPHA;
		}
		
		public function set textAlign(value:String):void {
			(_other.textAlign === value) || (_other = _other.make(), SaveBase.save(this, SaveBase.TYPE_TEXTALIGN, _other, false), _other.textAlign = value);
		}
		
		public function get textAlign():String {
			return _other.textAlign;
		}
		
		public override function set enableMerge(value:Boolean):void {
			SaveBase.save(this, SaveBase.TYPE_ENABLEMERGE, this, true);
			_mergeID = _drawCount;
		}
		
		public override function get enableMerge():Boolean {
			return _mergeID > 0;
		}
		
		override public function set textBaseline(value:String):void {
			(_other.textBaseline === value) || (_other = _other.make(), SaveBase.save(this, SaveBase.TYPE_TEXTBASELINE, _other, false), _other.textBaseline = value);
		}
		
		public function get textBaseline():String {
			return _other.textBaseline;
		}
		
		override public function set globalCompositeOperation(value:String):void {
			var n:* = BlendMode.TOINT[value];
			
			n == null || (_nBlendType === n) || (SaveBase.save(this, SaveBase.TYPE_GLOBALCOMPOSITEOPERATION, this, true), _curSubmit = Submit.RENDERBASE, _nBlendType = n/*, _shader2D.ALPHA = 1*/);
		}
		
		override public function get globalCompositeOperation():String {
			return BlendMode.NAMES[_nBlendType];
		}
		
		override public function set strokeStyle(value:*):void {
			_shader2D.strokeStyle.equal(value) || (SaveBase.save(this, SaveBase.TYPE_STROKESTYLE, _shader2D, false), _shader2D.strokeStyle = new DrawStyle(value));
		}
		
		public function get strokeStyle():* {
			return _shader2D.strokeStyle;
		}
		
		override public function translate(x:Number, y:Number):void {
			if (x !== 0 || y !== 0) {
				SaveTranslate.save(this);
				if (_curMat.bTransform) {
					SaveTransform.save(this);
					_curMat.transformPoint(x, y, Point.TEMP);
					x = Point.TEMP.x;
					y = Point.TEMP.y;
				}
				this._x += x;
				this._y += y;
			}
		}
		
		public function set lineWidth(value:Number):void {
			(_other.lineWidth === value) || (_other = _other.make(), SaveBase.save(this, SaveBase.TYPE_LINEWIDTH, _other, false), _other.lineWidth = value);
		}
		
		public function get lineWidth():Number {
			return _other.lineWidth;
		}
		
		override public function save():void {
			_save[_save._length++] = SaveMark.Create(this);
		}
		
		override public function restore():void {
			var sz:int = _save._length;
			if (sz < 1)
				return;
			for (var i:int = sz - 1; i >= 0; i--) {
				var o:ISaveData = _save[i];
				o.restore(this);
				if (o.isSaveMark()) {
					_save._length = i;
					return;
				}
			}
		}
		
		override public function measureText(text:String):* {
			return RunDriver.measureText(text, _other.font.toString());
		}
		
		override public function set font(str:String):void {
			if (str == _other.font.toString())
				return;
			_other = _other.make();
			SaveBase.save(this, SaveBase.TYPE_FONT, _other, false);
			_other.font === FontInContext.EMPTY ? (_other.font = new FontInContext(str)) : (_other.font.setFont(str));
		}
		
		private function _fillText(txt:String, words:Vector.<HTMLChar>, x:Number, y:Number, fontStr:String, color:String, textAlign:String):void {
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = _curSubmit.shaderValue;
			var font:FontInContext = fontStr ? FontInContext.create(fontStr) : _other.font;
			
			if (AtlasResourceManager.enabled) {
				if (shader.ALPHA !== curShader.ALPHA)
					shader.glTexture = null;
				DrawText.drawText(this, txt, words, _curMat, font, textAlign || _other.textAlign, color, null, -1, x, y);
			} else {
				var preDef:int = _shader2D.defines.getValue();
				var colorAdd:Array = color ? Color.create(color)._color : shader.colorAdd;
				if (shader.ALPHA !== curShader.ALPHA || colorAdd !== shader.colorAdd || curShader.colorAdd !== shader.colorAdd) {
					shader.glTexture = null;
					shader.colorAdd = colorAdd;
				}
				shader.defines.add(ShaderDefines2D.COLORADD);
				DrawText.drawText(this, txt, words, _curMat, font, textAlign || _other.textAlign, null, null, -1, x, y);
				shader.defines.setValue(preDef);
			}
		}
		
		public override function fillWords(words:Vector.<HTMLChar>, x:Number, y:Number, fontStr:String, color:String):void {
			words.length > 0 && _fillText(null, words, x, y, fontStr, color, null);
		}
		
		override public function fillText(txt:String, x:Number, y:Number, fontStr:String, color:String, textAlign:String):void {
			txt.length > 0 && _fillText(txt, null, x, y, fontStr, color, textAlign);
		}
		
		override public function strokeText(txt:String, x:Number, y:Number, fontStr:String, color:String, lineWidth:Number, textAlign:String):void {
			if (txt.length === 0)
				return;
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = _curSubmit.shaderValue;
			var font:FontInContext = fontStr ? (_fontTemp.setFont(fontStr), _fontTemp) : _other.font;
			
			if (AtlasResourceManager.enabled) {
				if (shader.ALPHA !== curShader.ALPHA) {
					shader.glTexture = null;
				}
				DrawText.drawText(this, txt, null, _curMat, font, textAlign || _other.textAlign, null, color, lineWidth || 1, x, y);
			} else {
				var preDef:int = _shader2D.defines.getValue();
				
				var colorAdd:Array = color ? Color.create(color)._color : shader.colorAdd;
				if (shader.ALPHA !== curShader.ALPHA || colorAdd !== shader.colorAdd || curShader.colorAdd !== shader.colorAdd) {
					shader.glTexture = null;
					shader.colorAdd = colorAdd;
				}
				
				shader.defines.add(ShaderDefines2D.COLORADD);
				DrawText.drawText(this, txt, null, _curMat, font, textAlign || _other.textAlign, null, color, lineWidth || 1, x, y);
				shader.defines.setValue(preDef);
			}
		}
		
		override public function fillBorderText(txt:String, x:Number, y:Number, fontStr:String, fillColor:String, borderColor:String, lineWidth:int, textAlign:String):void {
			if (txt.length === 0)
				return;
			if (!AtlasResourceManager.enabled) {
				strokeText(txt, x, y, fontStr, borderColor, lineWidth, textAlign);
				fillText(txt, x, y, fontStr, fillColor, textAlign);
				return;
			}
			
			//判断是否大图合集
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = _curSubmit.shaderValue;
			if (shader.ALPHA !== curShader.ALPHA)
				shader.glTexture = null;
			
			var font:FontInContext = fontStr ? (_fontTemp.setFont(fontStr), _fontTemp) : _other.font;
			DrawText.drawText(this, txt, null, _curMat, font, textAlign || _other.textAlign, fillColor, borderColor, lineWidth || 1, x, y);
		}
		
		override public function fillRect(x:Number, y:Number, width:Number, height:Number, fillStyle:*):void {
			var vb:VertexBuffer = _vb;
			if (GlUtils.fillRectImgVb(vb, _clipRect, x, y, width, height, Texture.DEF_UV, _curMat, _x, _y, 0, 0)) {
				var pre:DrawStyle = _shader2D.fillStyle;
				fillStyle && (_shader2D.fillStyle = new DrawStyle(fillStyle));
				
				var shader:Shader2D = _shader2D;
				var curShader:Value2D = _curSubmit.shaderValue;
				
				if (shader.fillStyle !== curShader.fillStyle || shader.ALPHA !== curShader.ALPHA) {
					shader.glTexture = null;
					var submit:Submit = _curSubmit = Submit.create(this, 0, _mergeID, _ib, vb, ((vb._length - _RECTVBSIZE * Buffer.FLOAT32) / 32) * 3, Value2D.create(ShaderDefines2D.COLOR2D, 0));
					submit.shaderValue.color = shader.fillStyle._color._color;
					submit.shaderValue.ALPHA = shader.ALPHA;
					_submits[_submits._length++] = submit;
				}
				_curSubmit._numEle += 6;
				_shader2D.fillStyle = pre;
			}
		}
		
		public function setShader(shader:Shader):void {
			SaveBase.save(this, SaveBase.TYPE_SHADER, _shader2D, true);
			_shader2D.shader = shader;
		}
		
		public function setFilters(value:Array):void {
			SaveBase.save(this, SaveBase.TYPE_FILTERS, _shader2D, true);
			_shader2D.filters = value;
			_curSubmit = Submit.RENDERBASE;
			_drawCount++;
			//_mergeID = _drawCount;
			_mergeID = 0;
		}
		
		private function _findSameSubmit(submitID:Number):Submit {
			for (var i:int = _submits._length - 1; i >= 0; i--) {
				var submit:Submit = _submits[i] as Submit;
				if (submit._mergID && submit._mergID !== _mergeID) break;
				if (submit._submitID === submitID) {
					return submit;
				}
			}
			return null;
		}
		
		public override function drawTexture(tex:Texture, x:Number, y:Number, width:Number, height:Number, tx:Number, ty:Number):void
		{
			_drawTextureM(tex, x, y, width, height, tx, ty, null);
		}
		
		private function _drawTextureM(tex:Texture, x:Number, y:Number, width:Number, height:Number, tx:Number, ty:Number, m:Matrix):void {
			if (!(tex.loaded && tex.bitmap && tex.source))//source内调用tex.active();
			{
				if (sprite) {
					Laya.timer.callLater(this, _repaintSprite);
				}
				return;
			}
			
			var webGLImg:Bitmap = tex.bitmap as Bitmap;
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = _curSubmit.shaderValue;
			_drawCount++;
			
			if (shader.glTexture !== webGLImg || shader.ALPHA !== curShader.ALPHA) {
				shader.glTexture = webGLImg;
				var vb:VertexBuffer = _vb;
				var submit:Submit = null;
				var submitID:Number;
				var vbSize:int = (vb._length / 32) * 3;
				if (_mergeID) {
					submitID = webGLImg.id + shader.ALPHA / 10;
					submit = _findSameSubmit(submitID);
					vb = null;
				}
				if (!submit) {
					submit = Submit.create(this, submitID, _mergeID, _ib, vb, vbSize, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
					_submits[_submits._length++] = submit;
					submit.shaderValue.textureHost = tex;//TODO:阿欢调整
				}
				_curSubmit = submit;
			}
			
			if (GlUtils.fillRectImgVb(_curSubmit._vb || _vb, _clipRect, x + tx, y + ty , width || tex.width, height || tex.height, tex.uv, m || _curMat, _x, _y, 0, 0)) {
				_curSubmit._numEle += 6;
				_maxNumEle = Math.max(_maxNumEle, _curSubmit._numEle);
			}
		}
		
		private  function  _repaintSprite():void
		{
			sprite.repaint();
		}
		
		/**
		 * 请保证图片已经在内存
		 * @param	... args
		 */
		public override function drawImage(... args):void {
			var img:* = args[0];
			var tex:Texture = (img.__texture || (img.__texture = new Texture(new WebGLImage(img)))) as Texture;
			tex.uv = Texture.DEF_UV;
			switch (args.length) {
			case 3: 
				if (!img.__width) {
					img.__width = img.width;
					img.__height = img.height
				}
				drawTexture(tex, args[1], args[2], img.__width, img.__height, 0, 0);
				break;
			case 5: 
				drawTexture(tex, args[1], args[2], args[3], args[4], 0, 0);
				break;
			case 9: 
				var x1:Number = args[1] / img.__width;
				var x2:Number = (args[1] + args[3]) / img.__width;
				var y1:Number = args[2] / img.__height;
				var y2:Number = (args[2] + args[4]) / img.__height;
				tex.uv = [x1, y1, x2, y1, x2, y2, x1, y2];
				drawTexture(tex, args[5], args[6], args[7], args[8], 0, 0);
				break;
			}
		}
		
		public function _drawText(tex:Texture, x:Number, y:Number, width:Number, height:Number, m:Matrix, tx:Number, ty:Number, dx:Number, dy:Number):void {
			var webGLImg:Bitmap = tex.bitmap as Bitmap;
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = _curSubmit.shaderValue;
			_drawCount++;
			
			if (shader.glTexture !== webGLImg) {
				shader.glTexture = webGLImg;
				
				var vb:VertexBuffer = _vb;
				var submit:Submit = null;
				var submitID:Number;
				var vbSize:int = (vb._length / 32) * 3;
				if (_mergeID) {
					submitID = webGLImg.id + shader.ALPHA / 10 + (AtlasResourceManager.enabled ? 0 : (shader.colorAdd.__id / 10000));
					submit = _findSameSubmit(submitID);
					vb = null;
				}
				if (!submit) {
					if (AtlasResourceManager.enabled) {
						//开启了大图合集
						submit = Submit.create(this, submitID, _mergeID, _ib, vb, vbSize, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
					} else {
						submit = Submit.create(this, submitID, _mergeID, _ib, vb, vbSize, TextSV.create());
						submit.shaderValue.colorAdd = shader.colorAdd;
						submit.shaderValue.defines.add(ShaderDefines2D.COLORADD);
					}
					submit.shaderValue.textureHost = tex;//TODO:阿欢调整
					_submits[_submits._length++] = submit;
				}
				_curSubmit = submit;
			}
			tex.active();
			if (GlUtils.fillRectImgVb(_curSubmit._vb || _vb, _clipRect, x + tx, y + ty, width || tex.width, height || tex.height, tex.uv, m || _curMat, _x, _y, dx, dy, true)) {
				_curSubmit._numEle += 6;
				_maxNumEle = Math.max(_maxNumEle, _curSubmit._numEle);
			}
		}
		
		override public function drawTextureWithTransform(tex:Texture, x:Number, y:Number, width:Number, height:Number, transform:Matrix, tx:Number, ty:Number):void {
			var curMat:Matrix = _curMat;
			
			(tx !== 0 || ty !== 0) && (_x = tx * curMat.a + ty * curMat.c, _y = ty * curMat.d + tx * curMat.b);
			
			if (transform && curMat.bTransform) {
				Matrix.mul(transform, curMat, _tmpMatrix);
				transform = _tmpMatrix;
				transform._checkTransform();
			} else {
				_x += curMat.tx;
				_y += curMat.ty;
			}
			_drawTextureM(tex, x, y, width, height, 0, 0, transform);
			_x = _y = 0;
		}
		
		public function fillQuadrangle(tex:Texture, x:Number, y:Number, point4:Array, m:Matrix):void {
			var submit:Submit = this._curSubmit;
			var vb:VertexBuffer = _vb;
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = submit.shaderValue;
			if (tex.bitmap) {
				var t_tex:WebGLImage = tex.bitmap as WebGLImage;
				if (shader.glTexture != t_tex || shader.ALPHA !== curShader.ALPHA) {
					shader.glTexture = t_tex;
					submit = _curSubmit = Submit.create(this, 0, _mergeID, _ib, vb, ((vb._length) / 32) * 3, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
					submit.shaderValue.glTexture = t_tex;
					_submits[_submits._length++] = submit;
				}
				GlUtils.fillQuadrangleImgVb(vb, x, y, point4, tex.uv, m || _curMat, _x, _y);
			} else {
				if (!submit.shaderValue.fillStyle || !submit.shaderValue.fillStyle.equal(tex) || shader.ALPHA !== curShader.ALPHA) {
					shader.glTexture = null;
					submit = _curSubmit = Submit.create(this, 0, _mergeID, _ib, vb, ((vb._length) / 32) * 3, Value2D.create(ShaderDefines2D.COLOR2D, 0));
					submit.shaderValue.defines.add(ShaderDefines2D.COLOR2D);
					submit.shaderValue.fillStyle = new DrawStyle(tex);
					_submits[_submits._length++] = submit;
				}
				GlUtils.fillQuadrangleImgVb(vb, x, y, point4, Texture.DEF_UV, m || _curMat, _x, _y);
			}
			submit._numEle += 6;
		}
		
		override public function drawTexture2(x:Number, y:Number, pivotX:Number, pivotY:Number, transform:Matrix, alpha:Number, blendMode:String, args:Array):void {
			var curMat:Matrix = _curMat;
			_x = x * curMat.a + y * curMat.c;
			_y = y * curMat.d + x * curMat.b;
			
			if (transform) {
				if (curMat.bTransform||transform.bTransform) {
					Matrix.mul(transform, curMat, _tmpMatrix);
					transform = _tmpMatrix;
				} 
				else {
					_x += transform.tx + curMat.tx;
					_y += transform.ty + curMat.ty;
					transform = Matrix.EMPTY;
				}
			}
			
			if (alpha === 1 && !blendMode)
				//tx:Texture, x:Number, y:Number, width:Number, height:Number
				_drawTextureM(args[0], args[1] - pivotX, args[2] - pivotY, args[3], args[4], 0, 0, transform);
			else {
				var preAlpha:Number = _shader2D.ALPHA;
				var preblendType:int = _nBlendType;
				_shader2D.ALPHA = alpha;
				blendMode && (_nBlendType = BlendMode.TOINT(blendMode));
				_drawTextureM(args[0], args[1] - pivotX, args[2] - pivotY, args[3], args[4], 0, 0, transform);
				_shader2D.ALPHA = preAlpha;
				_nBlendType = preblendType;
			}
			_x = _y = 0;
		}
		
		override public function drawCanvas(canvas:HTMLCanvas, x:Number, y:Number, width:Number, height:Number):void {
			var src:WebGLContext2D = canvas.context as WebGLContext2D;
			if (src._targets) {
				this._submits[this._submits._length++] = SubmitCanvas.create(src, 0, null);
				//src._targets.flush(src);
				_curSubmit = Submit.RENDERBASE;
				src._targets.drawTo(this, x, y, width, height);
			} else {
				var submit:SubmitCanvas = this._submits[this._submits._length++] = SubmitCanvas.create(src, _shader2D.ALPHA, _shader2D.filters);
				var sx:Number = width / canvas.width;
				var sy:Number = height / canvas.height;
				var mat:Matrix = submit._matrix;
				_curMat.copy(mat);
				sx != 1 && sy != 1 && mat.scale(sx, sy);
				var tx:Number = mat.tx, ty:Number = mat.ty;
				mat.tx = mat.ty = 0;
				mat.transformPoint(x, y, Point.TEMP);
				mat.translate(Point.TEMP.x + tx, Point.TEMP.y + ty);
				_curSubmit = Submit.RENDERBASE;
			}
			if (Config.showCanvasMark) {
				save();
				lineWidth = 4;
				strokeStyle = src._targets ? "yellow" : "green";
				strokeRect(x - 1, y - 1, width + 2, height + 2, 1);
				strokeRect(x, y, width, height, 1);
				restore();
			}
		}
		
		public function drawTarget(scope:*, x:Number, y:Number, width:Number, height:Number, m:Matrix, proName:String, shaderValue:Value2D, uv:Array = null, blend:int = -1):void {
			var vb:VertexBuffer = _vb;
			if (GlUtils.fillRectImgVb(vb, _clipRect, x, y, width, height, uv || Texture.DEF_UV, m || _curMat, _x, _y, 0, 0)) {
				var shader:Shader2D = _shader2D;
				shader.glTexture = null;
				var curShader:Value2D = _curSubmit.shaderValue;
				var submit:SubmitTarget = _curSubmit = SubmitTarget.create(this, _ib, vb, ((vb._length - _RECTVBSIZE * Buffer.FLOAT32) / 32) * 3, shaderValue, proName);
				if (blend == -1) {
					submit.blendType = _nBlendType;
				} else {
					submit.blendType = blend;
				}
				submit.scope = scope;
				_submits[_submits._length++] = submit;
				_curSubmit._numEle += 6;
			}
		}
		
		override public function transform(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):void {
			SaveTransform.save(this);
			Matrix.mul(Matrix.TEMP.setTo(a, b, c, d, tx, ty), _curMat, _curMat);
			_curMat._checkTransform();
		}
		
		override public function setTransformByMatrix(value:Matrix):void {
			value.copy(_curMat);
		}
		
		override public function transformByMatrix(value:Matrix):void {
			SaveTransform.save(this);
			Matrix.mul(value, _curMat, _curMat);
			_curMat._checkTransform();
		}
		
		public function rotate(angle:Number):void {
			SaveTransform.save(this);
			_curMat.rotate(angle);
		}
		
		override public function scale(scaleX:Number, scaleY:Number):void {
			SaveTransform.save(this);
			_curMat.scale(scaleX, scaleY);
		}
		
		override public function clipRect(x:Number, y:Number, width:Number, height:Number):void {
			width *= _curMat.a;
			height *= _curMat.d;
			var p:Point = Point.TEMP;
			this._curMat.transformPoint(x, y, p);
			
			var submit:SubmitScissor = _curSubmit = SubmitScissor.create(this);
			_submits[this._submits._length++] = submit;
			submit.submitIndex = this._submits._length;
			submit.submitLength = 9999999;
			
			SaveClipRect.save(this, submit);
			
			var clip:Rectangle = this._clipRect;
			var x1:Number = clip.x, y1:Number = clip.y;
			var r:Number = p.x + width, b:Number = p.y + height;
			x1 < p.x && (clip.x = p.x);
			y1 < p.y && (clip.y = p.y);
			clip.width = Math.min(r, x1 + clip.width) - clip.x;
			clip.height = Math.min(b, y1 + clip.height) - clip.y;
			_shader2D.glTexture = null;
			
			submit.clipRect.copyFrom(clip);
			
			_curSubmit = Submit.RENDERBASE;
			
			_mergeID = 0;
		}
		
		public function setIBVB(x:Number, y:Number, ib:IndexBuffer, vb:VertexBuffer, numElement:int, mat:Matrix, shader:Shader, shaderValues:Value2D, startIndex:int = 0, offset:int = 0):void {
			(ib === null) && (GlUtils.expandIBQuadrangle(_ib, (vb.length / (Buffer.FLOAT32 * 16) + 8)), ib = _ib);
			if (!shaderValues || !shader)
				throw Error("setIBVB must input:shader shaderValues");
			var submit:SubmitOtherIBVB = SubmitOtherIBVB.create(this, vb, ib, numElement, shader, shaderValues, startIndex, offset);
			mat || (mat = Matrix.EMPTY);
			mat.translate(x, y);
			Matrix.mul(mat, _curMat, submit._mat);
			mat.translate(-x, -y);
			_submits[this._submits._length++] = submit;
			_curSubmit = Submit.RENDERBASE;
		}
		
		public function addRenderObject(o:ISubmit):void {
			this._submits[this._submits._length++] = o;
		}
		
		public function fillTrangles(tex:Texture, x:Number, y:Number, points:Array, m:Matrix):void {
			var submit:Submit = this._curSubmit;
			var vb:VertexBuffer = _vb;
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = submit.shaderValue;
			var length:int = points.length >> 4 /*16*/;
			var t_tex:WebGLImage = tex.bitmap as WebGLImage;
			
			if (shader.glTexture != t_tex || shader.ALPHA !== curShader.ALPHA) {
				submit = _curSubmit = Submit.create(this, 0, _mergeID, _ib, vb, ((vb._length) / 32) * 3, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
				submit.shaderValue.textureHost = tex;//TODO:阿欢调整
				_submits[_submits._length++] = submit;
			}
			
			GlUtils.fillTranglesVB(vb, x, y, points, m || _curMat, _x, _y);
			submit._numEle += length * 6;
		}
		
		public function arc(x:Number, y:Number, r:Number, sAngle:Number, eAngle:Number, counterclockwise:Boolean = true):void {
			//			debugger;
		}
		
		public function fill():void {
			//			debugger;
		}
		
		public function closePath():void {
		
		}
		
		override public function beginPath():void {
			_other = _other.make();
			_other.path || (_other.path = new Path());
			_other.path.clear();
		}
		
		override public function rect(x:Number, y:Number, width:Number, height:Number):void {
			_other = _other.make();
			_other.path || (_other.path = new Path());
			_other.path.rect(x, y, width, height);
		}
		
		public function strokeRect(x:Number, y:Number, width:Number, height:Number, parameterLineWidth:Number):void {
			var tW:Number = parameterLineWidth * 0.5;
			line(x - tW, y, x + width + tW, y, parameterLineWidth, _curMat);
			line(x + width, y, x + width, y + height, parameterLineWidth, _curMat);
			line(x, y, x, y + height, parameterLineWidth, _curMat);
			line(x - tW, y + height, x + width + tW, y + height, parameterLineWidth, _curMat);
		}
		
		override public function clip():void {
			//			debugger;
		}
		
		override public function stroke():void {
			if (_other !== ContextParams.DEFAULT) {
				if (_other.path._rect) {
					var r:Rectangle = _other.path._rect;
					strokeRect(r.x, r.y, r.width, r.height, _other.lineWidth);
				}
				_other.path.clear();
			}
		}
		
		public function moveTo(x:Number, y:Number):void {
			_other.path._x = x;
			_other.path._y = y;
		}
		
		public function lineTo(x:Number, y:Number):void {
			line(_other.path._x, _other.path._y, x, y, _other.lineWidth, _curMat);
		}
		
		public function line(fromX:Number, fromY:Number, toX:Number, toY:Number, lineWidth:Number, mat:Matrix):void {
			var submit:Submit = _curSubmit;
			var vb:VertexBuffer = _vb;
			if (GlUtils.fillLineVb(vb, _clipRect, fromX, fromY, toX, toY, lineWidth, mat)) {
				var shader:Shader2D = _shader2D;
				var curShader:Value2D = submit.shaderValue;
				if (shader.strokeStyle !== curShader.strokeStyle || shader.ALPHA !== curShader.ALPHA) {
					shader.glTexture = null;
					submit = _curSubmit = Submit.create(this, 0, _mergeID, _ib, vb, ((vb._length - _RECTVBSIZE * Buffer.FLOAT32) / 32) * 3, Value2D.create(ShaderDefines2D.COLOR2D, 0));
					submit.shaderValue.strokeStyle = shader.strokeStyle;
					submit.shaderValue.mainID = ShaderDefines2D.COLOR2D;
					submit.shaderValue.ALPHA = shader.ALPHA;
					_submits[_submits._length++] = submit;
				}
				submit._numEle += 6;
			}
		}
		
		public function submitElement(start:int, end:int):void {
			var renderList:Array = this._submits;
			end < 0 && (end = renderList._length);
			while (start < end) {
				start += renderList[start].renderSubmit();
			}
		}
		
		public function finish():void {
			WebGL.mainContext.finish();
		}
		
		override public function flush():int {
			var maxNum:int = Math.max(_vb.length / (Buffer.FLOAT32 * 16), _maxNumEle / 6) + 8;
			if (maxNum > (_ib.bufferLength / (6 * Buffer.SHORT))) {
				GlUtils.expandIBQuadrangle(_ib, maxNum);
			}
			
			_vb.bind_upload(_ib);
			
			submitElement(0, _submits._length);
			
			_path &&  _path.reset();
			
			_curSubmit = Submit.RENDERBASE;
			
			return _submits._length;
		}
		
		public function fan(x:Number, y:Number, r:Number, sAngle:Number, eAngle:Number, fillColor:uint, lineColor:uint):void {
			_getPath().fan(x, y, r, sAngle, eAngle, fillColor, _other.lineWidth ? _other.lineWidth : 1, lineColor);
			_path.update();
			var submit:Submit = Submit.createShape(this, _path.ib, _path.vb, _path.count, _path.offset, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
			submit.shaderValue.ALPHA = _shader2D.ALPHA;
			submit.shaderValue.u_mmat2 = RenderState2D.mat2MatArray(_curMat, RenderState2D.TEMPMAT4_ARRAY);
			_submits[_submits._length++] = submit;
		}
		
		/*画圆*/
		public function drawCircle(x:Number, y:Number, r:Number, edges:int, boderColor:uint, lineWidth:Number, color:uint):void {
			_getPath().circle(x, y, r, edges, color, lineWidth ? lineWidth : 1, boderColor);
			_path.update();//要传入矩阵才能去转换点的变换，计算量啊。。。哎
			var submit:Submit = Submit.createShape(this, _path.ib, _path.vb, _path.count, _path.offset, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
			submit.shaderValue.ALPHA = _shader2D.ALPHA;
			submit.shaderValue.u_mmat2 = RenderState2D.mat2MatArray(_curMat, RenderState2D.TEMPMAT4_ARRAY);
			//这个啥时候还原TEMPMAT4_ARRAY?
			_submits[_submits._length++] = submit;
		}
		
		/**
		 * 画多边形(用)
		 * @param	x
		 * @param	y
		 * @param	points
		 */
		public function drawPoly(x:Number, y:Number, points:Array, color:uint, lineWidth:Number, boderColor:uint):void {
			_getPath().polygon(x, y, points, color, lineWidth ? lineWidth : 1, boderColor);
			_path.update();
			var tempSubmit:Submit;
			//开启模板缓冲，把模板操作设为GL_INVERT
			//开启模板缓冲，填充模板数据
			var submit:SubmitStencil = SubmitStencil.create(4);
			addRenderObject(submit);
			tempSubmit = Submit.createShape(this, _path.ib, _path.vb, _path.count, _path.offset, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
			tempSubmit.shaderValue.ALPHA = _shader2D.ALPHA;
			tempSubmit.shaderValue.u_mmat2 = RenderState2D.mat2MatArray(_curMat, RenderState2D.TEMPMAT4_ARRAY);
			_submits[_submits._length++] = tempSubmit;
			submit = SubmitStencil.create(5);
			addRenderObject(submit);
			//通过模板数据来开始真实的绘制
			tempSubmit = Submit.createShape(this, _path.ib, _path.vb, _path.count, _path.offset, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
			tempSubmit.shaderValue.ALPHA = _shader2D.ALPHA;
			tempSubmit.shaderValue.u_mmat2 = RenderState2D.mat2MatArray(_curMat, RenderState2D.TEMPMAT4_ARRAY);
			_submits[_submits._length++] = tempSubmit;
			submit = SubmitStencil.create(3);
			addRenderObject(submit);
			//画闭合线
			if (lineWidth > 0) {
				_path.loopLine(x, y, points, lineWidth, boderColor);
				_path.update();
				//开启模板缓冲，把模板操作设为GL_INVERT
				//开启模板缓冲，填充模板数据
				tempSubmit = Submit.createShape(this, _path.ib, _path.vb, _path.count, _path.offset, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
				tempSubmit.shaderValue.ALPHA = _shader2D.ALPHA;
				tempSubmit.shaderValue.u_mmat2 = RenderState2D.mat2MatArray(_curMat, RenderState2D.TEMPMAT4_ARRAY);
				_submits[_submits._length++] = tempSubmit;
			}
		}
		
		public function drawPath(x:Number, y:Number, points:Array, color:uint, lineWidth:uint):void {
			_getPath().drawPath(x, y, points, color, lineWidth);
			_path.update();
			var submit:Submit = Submit.createShape(this, _path.ib, _path.vb, _path.count, _path.offset, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
			_submits[_submits._length++] = submit;
		}
		
		public function drawParticle(x:Number, y:Number, pt:*):void {
			pt.x = x;
			pt.y = y;
			_submits[_submits._length++] = pt;
		}
		
		public function drawLines(x:Number, y:Number, points:Array, color:uint, lineWidth:uint):void {
			
			var tmp:Point = Point.TEMP;
			this._curMat.transformPoint(x, y, tmp);
			if (_curMat.bTransform) {
				points = points.concat();
				this._curMat.transformPointArrayScale(points, points);
			}
			_getPath().drawPath(tmp.x, tmp.y, points, color, lineWidth);
			_path.update();
			var submit:Submit = Submit.createShape(this, _path.ib, _path.vb, _path.count, _path.offset, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
			submit.shaderValue.ALPHA = _shader2D.ALPHA;
			submit.shaderValue.u_mmat2 = RenderState2D.mat2MatArray(_curMat, RenderState2D.TEMPMAT4_ARRAY);
			_submits[_submits._length++] = submit;
		}
		
		private function _getPath():Path
		{
			return _path || (_path = new Path());
		}
		
		
	}
}
import laya.webgl.resource.RenderTargetMAX;
import laya.webgl.text.FontInContext;

class ContextParams {
	public static var DEFAULT:ContextParams;
	
	public var lineWidth:int = 1;
	public var path:*;
	public var textAlign:String;
	public var textBaseline:String;
	public var font:FontInContext = FontInContext.EMPTY;
	
	public function clear():void {
		lineWidth = 1;
		path && path.clear();
		textAlign = textBaseline = null;
		font = FontInContext.EMPTY;
	}
	
	public function make():ContextParams {
		return this === DEFAULT ? new ContextParams() : this;
	}
}