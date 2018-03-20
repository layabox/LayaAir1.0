package laya.webgl.canvas {
	import laya.display.Sprite;
	import laya.maths.Bezier;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.resource.Bitmap;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.utils.Color;
	import laya.utils.HTMLChar;
	import laya.utils.RunDriver;
	import laya.utils.Stat;
	import laya.utils.VectorGraphManager;
	import laya.webgl.canvas.save.SaveClipRectStencil;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.atlas.AtlasResourceManager;
	import laya.webgl.canvas.save.ISaveData;
	import laya.webgl.canvas.save.SaveBase;
	import laya.webgl.canvas.save.SaveClipRect;
	import laya.webgl.canvas.save.SaveMark;
	import laya.webgl.canvas.save.SaveTransform;
	import laya.webgl.canvas.save.SaveTranslate;
	import laya.webgl.resource.RenderTargetMAX;
	import laya.webgl.resource.WebGLImage;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.skinAnishader.SkinMeshBuffer;
	import laya.webgl.shader.d2.value.FillTextureSV;
	import laya.webgl.shader.d2.value.PrimitiveSV;
	import laya.webgl.shader.d2.value.TextSV;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.shapes.IShape;
	import laya.webgl.submit.ISubmit;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitCanvas;
	import laya.webgl.submit.SubmitOtherIBVB;
	import laya.webgl.submit.SubmitScissor;
	import laya.webgl.submit.SubmitStencil;
	import laya.webgl.submit.SubmitTarget;
	import laya.webgl.submit.SubmitTexture;
	import laya.webgl.text.DrawText;
	import laya.webgl.text.FontInContext;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.GlUtils;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	public class WebGLContext2D extends Context {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const _tempPoint:Point = /*[STATIC SAFE]*/ new Point();
		public static const _SUBMITVBSIZE:int = 32000;
		
		public static const _MAXSIZE:int = 99999999;
		
		public static const _RECTVBSIZE:int = 16;
		
		public static const MAXCLIPRECT:Rectangle = /*[STATIC SAFE]*/ new Rectangle(0, 0, _MAXSIZE, _MAXSIZE);
		
		public static var _COUNT:int = 0;
			
		public static var _tmpMatrix:Matrix = /*[STATIC SAFE]*/ new Matrix();
		
		private static var SEGNUM:int = 32;
			 
		private static var _fontTemp:FontInContext = new FontInContext();
		private static var _drawStyleTemp:DrawStyle = new DrawStyle(null);
		private static var _contextcount:int = 0;
		
		public static function __init__():void {
			ContextParams.DEFAULT = new ContextParams();
		}
		
		public var _x:Number = 0;
		public var _y:Number = 0;
		public var _id:int = ++_COUNT;
		
		private var _other:ContextParams;
		
		private var _path:Path = null;
		private var _primitiveValue2D:Value2D;
		private var _drawCount:int = 1;
		private var _maxNumEle:int = 0;
		private var _clear:Boolean = false;
		private var _width:Number = _MAXSIZE;
		private var _height:Number = _MAXSIZE;
		private var _isMain:Boolean = false;
		private var _atlasResourceChange:int = 0;
		
		public var _submits:* = null;
		public var _curSubmit:* = null;
		public var _ib:IndexBuffer2D = null;
		public var _vb:VertexBuffer2D = null; // 不同的顶点格式，使用不同的顶点缓冲区		
		public var _clipRect:Rectangle = MAXCLIPRECT;
		public var _curMat:Matrix;
		public var _nBlendType:int = 0;
		public var _save:*;
		public var _targets:RenderTargetMAX;
		public var _renderKey:Number;
		
		public var _saveMark:SaveMark = null;
		public var _shader2D:Shader2D = null;
		
		/**所cacheAs精灵*/
		public var sprite:Sprite;
		
		public function WebGLContext2D(c:HTMLCanvas) {
			
			//__JS__('this.drawTexture = this._drawTextureM');
			
			_canvas = c;
			
			_contextcount++;
			
			if (Render.isFlash) {
				_ib = IndexBuffer2D.create(WebGLContext.STATIC_DRAW);
				GlUtils.fillIBQuadrangle(_ib, 16);
			} else
				_ib = IndexBuffer2D.QuadrangleIB;
			
			clear();
		}
		
		public override function setIsMainContext():void {
			this._isMain = true;
		}
		
		public function clearBG(r:Number, g:Number, b:Number, a:Number):void {
			var gl:WebGLContext = WebGL.mainContext;
			gl.clearColor(r, g, b, a);
			gl.clear(WebGLContext.COLOR_BUFFER_BIT);
		}
		
		public function _getSubmits():Array {
			return _submits;
		}
		
private function _releaseMem():void
		{			
			if (!_submits)
				return;
				
			_curMat.destroy();
			_curMat = null;			
			_shader2D.destroy();
			_shader2D = null;
			for (var i:int = 0, n:int = _submits._length; i < n; i++)
				_submits[i].releaseRender();
			_submits.length = 0;
			_submits._length = 0;
			_submits = null;
			_curSubmit = null;

			_path && _path.recover();
			_path = null;
			_other && (_other.font = null);
			_save = null;			
			
			if (_vb)
			{
				_vb.releaseResource();
				_vb.destroy();
				_vb.destory();
				_vb = null;
			}
		}
		
		override public function destroy():void
		{
			--_contextcount;
			
			sprite = null;
			
			_releaseMem();
			
			_targets && _targets.destroy();
			_targets = null;
			_canvas = null;
			_ib && (_ib != IndexBuffer2D.QuadrangleIB) && _ib.releaseResource();
		}
		
		override public function clear():void
		{
			if (!_submits)
			{
				_other = ContextParams.DEFAULT;
				_curMat = Matrix.create();
				_vb = VertexBuffer2D.create( -1);
				_submits = [];
				_save = [SaveMark.Create(this)];
				_save.length = 10;
				_shader2D = new Shader2D();				
			}
			
			_vb.clear();
			
			_targets && (_targets.repaint = true);
			
			_other = ContextParams.DEFAULT;
			_clear = true;
			
			_repaint = false;
			
			_drawCount = 1;
			
			_renderKey = 0;
			
			_other.lineWidth = _shader2D.ALPHA = 1.0;
			
			_nBlendType = 0; // BlendMode.NORMAL;
			
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
			if (_width != w || _height != h) {
				if (w == 0 || h == 0) {
					if (_vb._byteLength != 0) {
						_width = w;
						_height = h;
						_vb.clear();
						_vb.upload();
					}
					for (var i:int = 0, n:int = _submits._length; i < n; i++)
						_submits[i].releaseRender();
					_submits.length = 0;
					_submits._length = 0;
					_curSubmit = null;
					_path && _path.recover();
					_path = null;
					sprite = null;
					_targets && (_targets.destroy());
					_targets = null;
				} else {
					_width = w;
					_height = h;
					_targets && (_targets.size(w, h));
					_canvas.memorySize -= _canvas.memorySize;//webGLCanvas为0;
				}
			}
			if (w === 0 && h === 0) _releaseMem();
		}
		
		public function set asBitmap(value:Boolean):void {
			if (value) {
				_targets || (_targets = new RenderTargetMAX());
				_targets.repaint = true;
				if (!_width || !_height)
					throw Error("asBitmap no size!");
				_targets.setSP(sprite);
				_targets.size(_width, _height);
			} else
				_targets = null;
		}
		
		public function _getTransformMatrix():Matrix {
			return this._curMat;
		}
		
		override public function set fillStyle(value:*):void {
			_shader2D.fillStyle.equal(value) || (SaveBase.save(this, SaveBase.TYPE_FILESTYLE, _shader2D, false), _shader2D.fillStyle = DrawStyle.create(value));
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
		
		override public function set textBaseline(value:String):void {
			(_other.textBaseline === value) || (_other = _other.make(), SaveBase.save(this, SaveBase.TYPE_TEXTBASELINE, _other, false), _other.textBaseline = value);
		}
		
		public function get textBaseline():String {
			return _other.textBaseline;
		}
		
		override public function set globalCompositeOperation(value:String):void {
			var n:* = BlendMode.TOINT[value];
			
			n == null || (_nBlendType === n) || (SaveBase.save(this, SaveBase.TYPE_GLOBALCOMPOSITEOPERATION, this, true), _curSubmit = Submit.RENDERBASE, _renderKey = 0, _nBlendType = n /*, _shader2D.ALPHA = 1*/);
		}
		
		override public function get globalCompositeOperation():String {
			return BlendMode.NAMES[_nBlendType];
		}
		
		override public function set strokeStyle(value:*):void {
			_shader2D.strokeStyle.equal(value) || (SaveBase.save(this, SaveBase.TYPE_STROKESTYLE, _shader2D, false), _shader2D.strokeStyle = DrawStyle.create(value));
		}
		
		public function get strokeStyle():* {
			return _shader2D.strokeStyle;
		}
		
		override public function translate(x:Number, y:Number):void {
			if (x !== 0 || y !== 0) {
				SaveTranslate.save(this);
				if (_curMat.bTransform) {
					SaveTransform.save(this);
					_curMat.transformPointN(Point.TEMP.setTo(x, y));
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
		
		override public function set font(str:String):void {
			if (str == _other.font.toString())
				return;
			_other = _other.make();
			SaveBase.save(this, SaveBase.TYPE_FONT, _other, false);
			_other.font === FontInContext.EMPTY ? (_other.font = new FontInContext(str)) : (_other.font.setFont(str));
		}
		
		private function _fillText(txt:*, words:Vector.<HTMLChar>, x:Number, y:Number, fontStr:String, color:String, strokeColor:String, lineWidth:int, textAlign:String,underLine:int=0):void {
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = _curSubmit.shaderValue;
			var font:FontInContext = fontStr ? FontInContext.create(fontStr) : _other.font;
			
			if (AtlasResourceManager.enabled) {
				if (shader.ALPHA !== curShader.ALPHA)
					shader.glTexture = null;
				DrawText.drawText(this, txt, words, _curMat, font, textAlign || _other.textAlign, color, strokeColor, lineWidth, x, y,underLine);
			} else {
				var preDef:int = _shader2D.defines.getValue();
				var colorAdd:Array = color ? Color.create(color)._color : shader.colorAdd;
				if (shader.ALPHA !== curShader.ALPHA || colorAdd !== shader.colorAdd || curShader.colorAdd !== shader.colorAdd) {
					shader.glTexture = null;
					shader.colorAdd = colorAdd;
				}
				//shader.defines.add(ShaderDefines2D.COLORADD);
				DrawText.drawText(this, txt, words, _curMat, font, textAlign || _other.textAlign, color, strokeColor, lineWidth, x, y,underLine);
					//shader.defines.setValue(preDef);
			}
			//TODO:实现下划线
		}
		
		public override function fillWords(words:Vector.<HTMLChar>, x:Number, y:Number, fontStr:String, color:String,underLine:int):void {
			_fillText(null, words, x, y, fontStr, color, null, -1, null,underLine);
		}
		
		override public function fillBorderWords(words:Vector.<HTMLChar>, x:Number, y:Number, font:String, color:String, borderColor:String, lineWidth:int):void {
			_fillBorderText(null, words, x, y, font, color, borderColor, lineWidth, null);
		}
		
		override public function fillText(txt:*, x:Number, y:Number, fontStr:String, color:String, textAlign:String):void {
			_fillText(txt, null, x, y, fontStr, color, null, -1, textAlign);
		}
		
		override public function strokeText(txt:*, x:Number, y:Number, fontStr:String, color:String, lineWidth:Number, textAlign:String):void {
			_fillText(txt, null, x, y, fontStr, null, color, lineWidth || 1, textAlign);
		}
		
		override public function fillBorderText(txt:*, x:Number, y:Number, fontStr:String, fillColor:String, borderColor:String, lineWidth:int, textAlign:String):void {
			_fillBorderText(txt, null, x, y, fontStr, fillColor, borderColor, lineWidth, textAlign);
		}
		
		private function _fillBorderText(txt:*, words:Vector.<HTMLChar>, x:Number, y:Number, fontStr:String, fillColor:String, borderColor:String, lineWidth:int, textAlign:String):void {
			if (!AtlasResourceManager.enabled) {
				_fillText(txt, words, x, y, fontStr, null, borderColor, lineWidth || 1, textAlign);
				_fillText(txt, words, x, y, fontStr, fillColor, null, -1, textAlign);
				return;
			}
			//判断是否大图合集
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = _curSubmit.shaderValue;
			if (shader.ALPHA !== curShader.ALPHA)
				shader.glTexture = null;
			
			var font:FontInContext = fontStr ? (_fontTemp.setFont(fontStr), _fontTemp) : _other.font;
			DrawText.drawText(this, txt, words, _curMat, font, textAlign || _other.textAlign, fillColor, borderColor, lineWidth || 1, x, y,0);
		}
		
		override public function fillRect(x:Number, y:Number, width:Number, height:Number, fillStyle:*):void {
			var vb:VertexBuffer2D = _vb;
			if (GlUtils.fillRectImgVb(vb, _clipRect, x, y, width, height, Texture.DEF_UV, _curMat, _x, _y, 0, 0)) {
				_renderKey = 0;
				
				var pre:DrawStyle = _shader2D.fillStyle;
				fillStyle && (_shader2D.fillStyle = DrawStyle.create(fillStyle));

				var shader:Shader2D = _shader2D;
				var curShader:Value2D = _curSubmit.shaderValue;
				
				if (shader.fillStyle !== curShader.fillStyle || shader.ALPHA !== curShader.ALPHA) {
					shader.glTexture = null;
					var submit:Submit = _curSubmit = Submit.createSubmit(this, _ib, vb, ((vb._byteLength - _RECTVBSIZE * Buffer2D.FLOAT32) / 32) * 3, Value2D.create(ShaderDefines2D.COLOR2D, 0));
					submit.shaderValue.color = shader.fillStyle._color._color;
					submit.shaderValue.ALPHA = shader.ALPHA;
					_submits[_submits._length++] = submit;
				}
				_curSubmit._numEle += 6;
				_shader2D.fillStyle = pre;
			}
		}
		
		public override function fillTexture(texture:Texture, x:Number, y:Number, width:Number, height:Number, type:String, offset:Point, other:*):void {
			if (!(texture.loaded && texture.bitmap && texture.source)) {
				if (this.sprite) {
					Laya.timer.callLater(this, this._repaintSprite);
				}
				return;
			}
			;
			var vb:VertexBuffer2D = _vb;
			var w:Number = texture.bitmap.width, h:Number = texture.bitmap.height, uv:Array = texture.uv;
			var ox:Number = offset.x % texture.width, oy:Number = offset.y % texture.height;
			if (w != other.w || h != other.h) {
				if (!other.w && !other.h) {
					other.oy = other.ox = 0;
					switch (type) {
					case "repeat": 
						other.width = width;
						other.height = height;
						break;
					case "repeat-x": 
						other.width = width;
						if (oy < 0) {
							if (texture.height + oy > height) {
								other.height = height;
							} else {
								other.height = texture.height + oy;
							}
						} else {
							other.oy = oy;
							if (texture.height + oy > height) {
								other.height = height - oy;
							} else {
								other.height = texture.height;
							}
						}
						break;
					case "repeat-y": 
						if (ox < 0) {
							if (texture.width + ox > width) {
								other.width = width;
							} else {
								other.width = texture.width + ox;
							}
						} else {
							other.ox = ox;
							if (texture.width + ox > width) {
								other.width = width - ox;
							} else {
								other.width = texture.width;
							}
						}
						other.height = height;
						break;
					default: 
						other.width = width;
						other.height = height;
						break;
					}
				}
				other.w = w;
				other.h = h;
				other.uv = [0, 0, other.width / w, 0, other.width / w, other.height / h, 0, other.height / h];
			}
			
			x += other.ox;
			y += other.oy;
			ox -= other.ox;
			oy -= other.oy;
			if (GlUtils.fillRectImgVb(vb, _clipRect, x, y, other.width, other.height, other.uv, _curMat, _x, _y, 0, 0)) {
				
				_renderKey = 0;
				var submit:SubmitTexture = SubmitTexture.create(this, _ib, vb, ((vb._byteLength - _RECTVBSIZE * Buffer2D.FLOAT32) / 32) * 3, Value2D.create(ShaderDefines2D.FILLTEXTURE, 0));
				
				_submits[_submits._length++] = submit;
				var shaderValue:FillTextureSV = submit.shaderValue as FillTextureSV;
				shaderValue.textureHost = texture;
				
				var tTextureX:Number = uv[0] * w;
				var tTextureY:Number = uv[1] * h;
				var tTextureW:Number = (uv[2] - uv[0]) * w;
				var tTextureH:Number = (uv[5] - uv[3]) * h;
				
				var tx:Number = -ox / w;
				var ty:Number = -oy / h;
				shaderValue.u_TexRange[0] = tTextureX / w;
				shaderValue.u_TexRange[1] = tTextureW / w;
				shaderValue.u_TexRange[2] = tTextureY / h;
				shaderValue.u_TexRange[3] = tTextureH / h;
				
				shaderValue.u_offset[0] = tx;
				shaderValue.u_offset[1] = ty;
				//var curShader:Value2D = _curSubmit.shaderValue;
				//var shader:Shader2D = _shader2D;
				
				if (AtlasResourceManager.enabled && !this._isMain) //而且不是主画布
					submit.addTexture(texture, (vb._byteLength >> 2) - WebGLContext2D._RECTVBSIZE);
				//submit._preIsSameTextureShader = _curSubmit._renderType === Submit.TYPE_FILLTEXTURE && shader.ALPHA === curShader.ALPHA;
				_curSubmit = submit;
				
				submit._renderType = Submit.TYPE_FILLTEXTURE;
				submit._numEle += 6;
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
			
			_renderKey = 0;
			
			_drawCount++;
		}
		
		public override function drawTexture(tex:Texture, x:Number, y:Number, width:Number, height:Number, tx:Number, ty:Number):void {
			_drawTextureM(tex, x, y, width, height, tx, ty, null, 1);
		}
		
		public function addTextureVb(invb:Array, x:Number, y:Number):void {
			
			var finalVB:VertexBuffer2D = _curSubmit._vb || _vb;
			var vpos:int = (finalVB._byteLength >> 2) /*FLOAT32*/; // + WebGLContext2D._RECTVBSIZE;
			finalVB.byteLength = ((vpos + WebGLContext2D._RECTVBSIZE) << 2);
			var vbdata:* = finalVB.getFloat32Array();
			
			for (var i:int = 0, ci:int = 0; i < 16; i += 4) {
				vbdata[vpos++] = invb[i] + x;
				vbdata[vpos++] = invb[i + 1] + y;
				vbdata[vpos++] = invb[i + 2];
				vbdata[vpos++] = invb[i + 3];
			}
			
			_curSubmit._numEle += 6;
			_maxNumEle = Math.max(_maxNumEle, _curSubmit._numEle);
			finalVB._upload = true;
		}
		
		public function willDrawTexture(tex:Texture, alpha:Number):Number {
			if (!(tex.loaded && tex.bitmap && tex.source)) //source内调用tex.active();
			{
				if (sprite) {
					Laya.timer.callLater(this, _repaintSprite);
				}
				return 0;
			}
			var webGLImg:Bitmap = tex.bitmap as Bitmap;
			
			var rid:Number = webGLImg.id + _shader2D.ALPHA * alpha + Submit.TYPE_TEXTURE;
			
			if (rid == _renderKey) return rid;
			
			var shader:Shader2D = _shader2D;
			var preAlpha:Number = shader.ALPHA;
			var curShader:Value2D = _curSubmit.shaderValue;
			shader.ALPHA *= alpha;
			
			_renderKey = rid;
			_drawCount++;
			shader.glTexture = webGLImg;
			var vb:VertexBuffer2D = _vb;
			var submit:SubmitTexture = null;
			var vbSize:int = (vb._byteLength / 32) * 3;
			submit = SubmitTexture.create(this, _ib, vb, vbSize, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
			_submits[_submits._length++] = submit;
			submit.shaderValue.textureHost = tex;
			submit._renderType = Submit.TYPE_TEXTURE;
			submit._preIsSameTextureShader = _curSubmit._renderType === Submit.TYPE_TEXTURE && shader.ALPHA === curShader.ALPHA;
			_curSubmit = submit;
			
			shader.ALPHA = preAlpha;
			
			return rid;
		}
		
		public override function drawTextures(tex:Texture, pos:Array, tx:Number, ty:Number):void {
			if (!(tex.loaded && tex.bitmap && tex.source)) //source内调用tex.active();
			{
				sprite && Laya.timer.callLater(this, _repaintSprite);
				return;
			}
			
			var pre:Rectangle = _clipRect;
			_clipRect = MAXCLIPRECT;
			if (!_drawTextureM(tex, pos[0], pos[1], tex.width, tex.height, tx, ty, null, 1)) {
				alert("drawTextures err");
				return;
			}
			
			_clipRect = pre;
			
			Stat.drawCall++;//= pos.length / 2;
			
			if (pos.length < 4)
				return;
			
			var finalVB:VertexBuffer2D = _curSubmit._vb || _vb;
			var sx:Number = _curMat.a, sy:Number = _curMat.d;
			for (var i:int = 2, sz:int = pos.length; i < sz; i += 2) {
				GlUtils.copyPreImgVb(finalVB, (pos[i] - pos[i - 2]) * sx, (pos[i + 1] - pos[i - 1]) * sy);
				_curSubmit._numEle += 6;
			}
			_maxNumEle = Math.max(_maxNumEle, _curSubmit._numEle);
		}
		
		private function _drawTextureM(tex:Texture, x:Number, y:Number, width:Number, height:Number, tx:Number, ty:Number, m:Matrix, alpha:Number):Boolean {
			if (!(tex.loaded && tex.source)) //source内调用tex.active();
			{
				if (sprite) {
					Laya.timer.callLater(this, _repaintSprite);
				}
				return false;
			}
			var finalVB:VertexBuffer2D = _curSubmit._vb || _vb;
			var webGLImg:Bitmap = tex.bitmap as Bitmap;
			
			x += tx;
			y += ty;
			
			_drawCount++;
			
			var rid:Number = webGLImg.id + _shader2D.ALPHA * alpha + Submit.TYPE_TEXTURE;
			
			if (rid != _renderKey) {
				_renderKey = rid;
				
				var curShader:Value2D = _curSubmit.shaderValue;
				var shader:Shader2D = _shader2D;
				var alphaBack:Number = shader.ALPHA;
				shader.ALPHA *= alpha;
				
				shader.glTexture = webGLImg;
				var vb:VertexBuffer2D = _vb;
				var submit:SubmitTexture = null;
				var vbSize:int = (vb._byteLength / 32) * 3;
				submit = SubmitTexture.create(this, _ib, vb, vbSize, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
				_submits[_submits._length++] = submit;
				submit.shaderValue.textureHost = tex;
				submit._renderType = Submit.TYPE_TEXTURE;
				submit._preIsSameTextureShader = _curSubmit._renderType === Submit.TYPE_TEXTURE && shader.ALPHA === curShader.ALPHA;
				_curSubmit = submit;
				finalVB = _curSubmit._vb || _vb;
				
				shader.ALPHA = alphaBack;
			}
			
			if (GlUtils.fillRectImgVb(finalVB, _clipRect, x, y, width || tex.width, height || tex.height, tex.uv, m || _curMat, _x, _y, 0, 0)) {
				if (AtlasResourceManager.enabled && !this._isMain) //而且不是主画布
					(_curSubmit as SubmitTexture).addTexture(tex, (finalVB._byteLength >> 2) - WebGLContext2D._RECTVBSIZE);
				_curSubmit._numEle += 6;
				_maxNumEle = Math.max(_maxNumEle, _curSubmit._numEle);
				return true;
			}
			return false;
		}
		
		private function _repaintSprite():void {
			if(sprite)
			sprite.repaint();
		}
		
		///**
		//* 请保证图片已经在内存
		//* @param	... args
		//*/
		//public override function drawImage(... args):void {
		//var img:* = args[0];
		//var tex:Texture = (img.__texture || (img.__texture = new Texture(new WebGLImage(img)))) as Texture;
		//tex.uv = Texture.DEF_UV;
		//switch (args.length) {
		//case 3: 
		//if (!img.__width) {
		//img.__width = img.width;
		//img.__height = img.height
		//}
		//drawTexture(tex, args[1], args[2], img.__width, img.__height, 0, 0);
		//break;
		//case 5: 
		//drawTexture(tex, args[1], args[2], args[3], args[4], 0, 0);
		//break;
		//case 9: 
		//var x1:Number = args[1] / img.__width;
		//var x2:Number = (args[1] + args[3]) / img.__width;
		//var y1:Number = args[2] / img.__height;
		//var y2:Number = (args[2] + args[4]) / img.__height;
		//tex.uv = [x1, y1, x2, y1, x2, y2, x1, y2];
		//drawTexture(tex, args[5], args[6], args[7], args[8], 0, 0);
		//break;
		//}
		//}
		
		public function _drawText(tex:Texture, x:Number, y:Number, width:Number, height:Number, m:Matrix, tx:Number, ty:Number, dx:Number, dy:Number):void {
			var webGLImg:Bitmap = tex.bitmap as Bitmap;
			
			_drawCount++;
			
			var rid:Number = webGLImg.id + _shader2D.ALPHA + Submit.TYPE_TEXTURE;
			if (rid != _renderKey) {
				_renderKey = rid;
				
				var curShader:Value2D = _curSubmit.shaderValue;
				var shader:Shader2D = _shader2D;
				
				shader.glTexture = webGLImg;
				
				var vb:VertexBuffer2D = _vb;
				var submit:SubmitTexture = null;
				var submitID:Number;
				var vbSize:int = (vb._byteLength / 32) * 3;
				if (AtlasResourceManager.enabled) {
					//开启了大图合集
					submit = SubmitTexture.create(this, _ib, vb, vbSize, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
				} else {
					submit = SubmitTexture.create(this, _ib, vb, vbSize, TextSV.create());
						//submit.shaderValue.colorAdd = shader.colorAdd;
						//submit.shaderValue.defines.add(ShaderDefines2D.COLORADD);
				}
				
				submit._preIsSameTextureShader = _curSubmit._renderType === Submit.TYPE_TEXTURE && shader.ALPHA === curShader.ALPHA;
				
				_submits[_submits._length++] = submit;
				submit.shaderValue.textureHost = tex;
				submit._renderType = Submit.TYPE_TEXTURE;
				_curSubmit = submit;
			}
			tex.active();
			
			var finalVB:VertexBuffer2D = _curSubmit._vb || _vb;
			if (GlUtils.fillRectImgVb(finalVB, _clipRect, x + tx, y + ty, width || tex.width, height || tex.height, tex.uv, m || _curMat, _x, _y, dx, dy, true)) {
				if (AtlasResourceManager.enabled && !this._isMain) {
					(_curSubmit as SubmitTexture).addTexture(tex, (finalVB._byteLength >> 2) - WebGLContext2D._RECTVBSIZE);
				}
				
				_curSubmit._numEle += 6;
				_maxNumEle = Math.max(_maxNumEle, _curSubmit._numEle);
			}
		}
		
		override public function drawTextureWithTransform(tex:Texture, x:Number, y:Number, width:Number, height:Number, transform:Matrix, tx:Number, ty:Number, alpha:Number):void {
			if (!transform) {
				_drawTextureM(tex, x, y, width, height, tx, ty, null, alpha);
				return;
			}
			var curMat:Matrix = _curMat;
			var prex:Number = _x;
			var prey:Number = _y;
			(tx !== 0 || ty !== 0) && (_x = tx * curMat.a + ty * curMat.c, _y = ty * curMat.d + tx * curMat.b);
			
			if (transform && curMat.bTransform) {
				Matrix.mul(transform, curMat, _tmpMatrix);
				transform = _tmpMatrix;
				transform._checkTransform();
			} else {
				_x += curMat.tx;
				_y += curMat.ty;
			}
			_drawTextureM(tex, x, y, width, height, 0, 0, transform, alpha);
			_x = prex;
			_y = prey;
		}
		
		public function fillQuadrangle(tex:Texture, x:Number, y:Number, point4:Array, m:Matrix):void {
			var submit:Submit = this._curSubmit;
			var vb:VertexBuffer2D = _vb;
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = submit.shaderValue;
			_renderKey = 0;
			if (tex.bitmap) {
				var t_tex:WebGLImage = tex.bitmap as WebGLImage;
				if (shader.glTexture != t_tex || shader.ALPHA !== curShader.ALPHA) {
					shader.glTexture = t_tex;
					submit = _curSubmit = Submit.createSubmit(this, _ib, vb, ((vb._byteLength) / 32) * 3, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
					submit.shaderValue.glTexture = t_tex;
					_submits[_submits._length++] = submit;
				}
				GlUtils.fillQuadrangleImgVb(vb, x, y, point4, tex.uv, m || _curMat, _x, _y);
			} else {
				if (!submit.shaderValue.fillStyle || !submit.shaderValue.fillStyle.equal(tex) || shader.ALPHA !== curShader.ALPHA) {
					shader.glTexture = null;
					submit = _curSubmit = Submit.createSubmit(this, _ib, vb, ((vb._byteLength) / 32) * 3, Value2D.create(ShaderDefines2D.COLOR2D, 0));
					submit.shaderValue.defines.add(ShaderDefines2D.COLOR2D);
					submit.shaderValue.fillStyle = DrawStyle.create(tex);
					_submits[_submits._length++] = submit;
				}
				GlUtils.fillQuadrangleImgVb(vb, x, y, point4, Texture.DEF_UV, m || _curMat, _x, _y);
			}
			submit._numEle += 6;
		}
		
		override public function drawTexture2(x:Number, y:Number, pivotX:Number, pivotY:Number, transform:Matrix, alpha:Number, blendMode:String, args:Array):void {
			if (alpha == 0) return;
			var curMat:Matrix = _curMat;
			_x = x * curMat.a + y * curMat.c;
			_y = y * curMat.d + x * curMat.b;
			
			if (transform) {
				if (curMat.bTransform || transform.bTransform) {
					Matrix.mul(transform, curMat, _tmpMatrix);
					transform = _tmpMatrix;
				} else {
					_x += transform.tx + curMat.tx;
					_y += transform.ty + curMat.ty;
					transform = Matrix.EMPTY;
				}
			}
			
			if (alpha === 1 && !blendMode)
				//tx:Texture, x:Number, y:Number, width:Number, height:Number
				_drawTextureM(args[0], args[1] - pivotX, args[2] - pivotY, args[3], args[4], 0, 0, transform, 1);
			else {
				var preAlpha:Number = _shader2D.ALPHA;
				var preblendType:int = _nBlendType;
				_shader2D.ALPHA = alpha;
				blendMode && (_nBlendType = BlendMode.TOINT(blendMode));
				_drawTextureM(args[0], args[1] - pivotX, args[2] - pivotY, args[3], args[4], 0, 0, transform, 1);
				_shader2D.ALPHA = preAlpha;
				_nBlendType = preblendType;
			}
			_x = _y = 0;
		}
		
		override public function drawCanvas(canvas:HTMLCanvas, x:Number, y:Number, width:Number, height:Number):void {
			var src:WebGLContext2D = canvas.context as WebGLContext2D;
			_renderKey = 0;
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
				_curMat.copyTo(mat);
				sx != 1 && sy != 1 && mat.scale(sx, sy);
				var tx:Number = mat.tx, ty:Number = mat.ty;
				mat.tx = mat.ty = 0;
				mat.transformPoint(Point.TEMP.setTo(x, y));
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
			var vb:VertexBuffer2D = _vb;
			if (GlUtils.fillRectImgVb(vb, _clipRect, x, y, width, height, uv || Texture.DEF_UV, m || _curMat, _x, _y, 0, 0)) {
				_renderKey = 0;
				var shader:Shader2D = _shader2D;
				shader.glTexture = null;
				var curShader:Value2D = _curSubmit.shaderValue;
				var submit:SubmitTarget = _curSubmit = SubmitTarget.create(this, _ib, vb, ((vb._byteLength - _RECTVBSIZE * Buffer2D.FLOAT32) / 32) * 3, shaderValue, proName);
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
			value.copyTo(_curMat);
		}
		
		override public function transformByMatrix(value:Matrix):void {
			SaveTransform.save(this);
			Matrix.mul(value, _curMat, _curMat);
			_curMat._checkTransform();
		}
		
		public function rotate(angle:Number):void {
			SaveTransform.save(this);
			_curMat.rotateEx(angle);
		}
		
		override public function scale(scaleX:Number, scaleY:Number):void {
			SaveTransform.save(this);
			_curMat.scaleEx(scaleX, scaleY);
		}
		
		override public function clipRect(x:Number, y:Number, width:Number, height:Number):void {
			if (_curMat.b != 0 || _curMat.c != 0) {
				_renderKey = 0;
				//1、创建模板缓冲区
				var submitStencil0:SubmitStencil = SubmitStencil.create(4);
				addRenderObject(submitStencil0);
				//2、创建Rect顶点并绘制Rect

				var vb:VertexBuffer2D = _vb;
				var nPos:int = (vb._byteLength >> 2);
				if (GlUtils.fillRectImgVb(vb, null, x, y, width, height, Texture.DEF_UV, _curMat, _x, _y, 0, 0)) {
					var shader:Shader2D = _shader2D;
					shader.glTexture = null;
					var submit:Submit = _curSubmit = Submit.createSubmit(this, _ib, vb, ((vb._byteLength - _RECTVBSIZE * Buffer2D.FLOAT32) / 32) * 3, Value2D.create(ShaderDefines2D.COLOR2D, 0));
					submit.shaderValue.ALPHA = 1.0;
					_submits[_submits._length++] = submit;
					_curSubmit._numEle += 6;
				} else {
					alert("clipRect calc stencil rect error");
				}
				
				//3、设置模板缓冲区
				var submitStencil1:SubmitStencil = SubmitStencil.create(5);
				addRenderObject(submitStencil1);
				
				
				//4、计算clipRect
				var vbdata:* = vb.getFloat32Array();
				var minx:Number = Math.min(Math.min(Math.min(vbdata[nPos + 0], vbdata[nPos + 4]), vbdata[nPos + 8]), vbdata[nPos + 12]);
				var maxx:Number = Math.max(Math.max(Math.max(vbdata[nPos + 0], vbdata[nPos + 4]), vbdata[nPos + 8]), vbdata[nPos + 12]);
				var miny:Number = Math.min(Math.min(Math.min(vbdata[nPos + 1], vbdata[nPos + 5]), vbdata[nPos + 9]), vbdata[nPos + 13]);
				var maxy:Number = Math.max(Math.max(Math.max(vbdata[nPos + 1], vbdata[nPos + 5]), vbdata[nPos + 9]), vbdata[nPos + 13]);

				SaveClipRectStencil.save(this, submitStencil1, x, y, width, height, minx, miny, maxx - minx, maxy - miny);
				
				_curSubmit = Submit.RENDERBASE;
				//5、在restore中进行恢复
				//代码在SaveClipRectStencil.as中，进行恢复的模板缓冲区
			} else {
				width *= _curMat.a;
				height *= _curMat.d;
				var p:Point = Point.TEMP;
				this._curMat.transformPoint(p.setTo(x, y));
				
				if (width < 0)
				{
					p.x = p.x + width;
					width = -width;
				}
				if (height < 0)
				{
					p.y = p.y + height;
					height = -height;
				}

				_renderKey = 0;
				var submitSc:SubmitScissor = _curSubmit = SubmitScissor.create(this);
				_submits[this._submits._length++] = submitSc;
				submitSc.submitIndex = this._submits._length;
				submitSc.submitLength = 9999999;
				SaveClipRect.save(this, submitSc);
				var clip:Rectangle = this._clipRect;
				var x1:Number = clip.x, y1:Number = clip.y;
				var r:Number = p.x + width, b:Number = p.y + height;
				x1 < p.x && (clip.x = p.x);
				y1 < p.y && (clip.y = p.y);
				clip.width = Math.min(r, x1 + clip.width) - clip.x;
				clip.height = Math.min(b, y1 + clip.height) - clip.y;
				_shader2D.glTexture = null;
				submitSc.clipRect.copyFrom(clip);
				_curSubmit = Submit.RENDERBASE;
			}
		}
		
		public function setIBVB(x:Number, y:Number, ib:IndexBuffer2D, vb:VertexBuffer2D, numElement:int, mat:Matrix, shader:Shader, shaderValues:Value2D, startIndex:int = 0, offset:int = 0, type:int = 0):void {
			if (ib === null) {
				if (!Render.isFlash) {
					ib = _ib;
				} else {
					var falshVB:* = vb;
					(falshVB._selfIB) || (falshVB._selfIB = IndexBuffer2D.create(WebGLContext.STATIC_DRAW));
					falshVB._selfIB.clear();
					ib = falshVB._selfIB;
				}
				GlUtils.expandIBQuadrangle(ib, (vb._byteLength / (Buffer2D.FLOAT32 * vb.vertexStride * 4)));
			}
			
			if (!shaderValues || !shader)
				throw Error("setIBVB must input:shader shaderValues");
			var submit:SubmitOtherIBVB = SubmitOtherIBVB.create(this, vb, ib, numElement, shader, shaderValues, startIndex, offset, type);
			mat || (mat = Matrix.EMPTY);
			mat.translate(x, y);
			Matrix.mul(mat, _curMat, submit._mat);
			mat.translate(-x, -y);
			_submits[this._submits._length++] = submit;
			_curSubmit = Submit.RENDERBASE;
			_renderKey = 0;
		}
		
		public function addRenderObject(o:ISubmit):void {
			this._submits[this._submits._length++] = o;
		}
		
		public function fillTrangles(tex:Texture, x:Number, y:Number, points:Array, m:Matrix):void {
			var submit:Submit = this._curSubmit;
			var vb:VertexBuffer2D = _vb;
			var shader:Shader2D = _shader2D;
			var curShader:Value2D = submit.shaderValue;
			var length:int = points.length >> 4 /*16*/;
			var t_tex:WebGLImage = tex.bitmap as WebGLImage;
			
			_renderKey = 0;
			
			if (shader.glTexture != t_tex || shader.ALPHA !== curShader.ALPHA) {
				submit = _curSubmit = Submit.createSubmit(this, _ib, vb, ((vb._byteLength) / 32) * 3, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
				submit.shaderValue.textureHost = tex;
				_submits[_submits._length++] = submit;
			}
			
			GlUtils.fillTranglesVB(vb, x, y, points, m || _curMat, _x, _y);
			submit._numEle += length * 6;
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
			var maxNum:int = Math.max(_vb._byteLength / (Buffer2D.FLOAT32 * 16), _maxNumEle / 6) + 8;
			if (maxNum > (_ib.bufferLength / (6 * Buffer2D.SHORT))) {
				GlUtils.expandIBQuadrangle(_ib, maxNum);
			}
			
			if (!this._isMain && AtlasResourceManager.enabled && AtlasResourceManager._atlasRestore > _atlasResourceChange) //这里还要判断大图合集是否修改
			{
				_atlasResourceChange = AtlasResourceManager._atlasRestore;
				var renderList:Array = this._submits;
				for (var i:int = 0, s:int = renderList._length; i < s; i++) {
					var submit:ISubmit = renderList[i] as ISubmit;
					if (submit.getRenderType() === Submit.TYPE_TEXTURE)
						(submit as SubmitTexture).checkTexture();
				}
			}
			
			//_vb.bind_upload(_ib);//重复绑定
			submitElement(0, _submits._length);
			
			_path && _path.reset();
			SkinMeshBuffer.instance && SkinMeshBuffer.getInstance().reset();
			
			_curSubmit = Submit.RENDERBASE;
			_renderKey = 0;
			return _submits._length;
		}
		
		/*******************************************start矢量绘制***************************************************/
		private var mId:int = -1;
		private var mHaveKey:Boolean = false;
		private var mHaveLineKey:Boolean = false;
		private var mX:Number = 0;
		private var mY:Number = 0;
		private var mOutPoint:Point
		
		public function setPathId(id:int):void {
			mId = id;
			if (mId != -1) {
				mHaveKey = false;
				var tVGM:VectorGraphManager = VectorGraphManager.getInstance();
				if (tVGM.shapeDic[mId]) {
					mHaveKey = true;
				}
				mHaveLineKey = false;
				if (tVGM.shapeLineDic[mId]) {
					mHaveLineKey = true;
				}
			}
		}
		
		public function movePath(x:Number, y:Number):void {
			var _x1:Number = x, _y1:Number = y;
			x = _curMat.a * _x1 + _curMat.c * _y1 + _curMat.tx;
			y = _curMat.b * _x1 + _curMat.d * _y1 + _curMat.ty;
			mX += x;
			mY += y;
		}
		
		override public function beginPath():void {
			var tPath:Path = _getPath();
			tPath.tempArray.length = 0;
			tPath.closePath = false;
			mX = 0;
			mY = 0;
		}
		
		public function closePath():void {
			_path.closePath = true;
		}
		
		public function fill(isConvexPolygon:Boolean = false):void {
			var tPath:Path = _getPath();
			this.drawPoly(0, 0, tPath.tempArray, fillStyle._color.numColor, 0, 0, isConvexPolygon);
		}
		
		override public function stroke():void {
			var tPath:Path = _getPath();
			if (lineWidth > 0) {
				if (mId == -1) {
					tPath.drawLine(0, 0, tPath.tempArray, lineWidth, this.strokeStyle._color.numColor);
				} else {
					if (mHaveLineKey) {
						var tShapeLine:IShape = VectorGraphManager.getInstance().shapeLineDic[mId];
						tShapeLine.rebuild(tPath.tempArray);
						tPath.setGeomtry(tShapeLine);
					} else {
						VectorGraphManager.getInstance().addLine(mId, tPath.drawLine(0, 0, tPath.tempArray, lineWidth, this.strokeStyle._color.numColor));
					}
				}
				
				tPath.update();
				//var tArray:Array = RenderState2D.getMatrArray();
				//RenderState2D.mat2MatArray(_curMat, tArray);
				var tPosArray:Array = [mX, mY];
				var tempSubmit:Submit = Submit.createShape(this, tPath.ib, tPath.vb, tPath.count, tPath.offset, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
				tempSubmit.shaderValue.ALPHA = _shader2D.ALPHA;
				(tempSubmit.shaderValue as PrimitiveSV).u_pos = tPosArray;
				tempSubmit.shaderValue.u_mmat2 = RenderState2D.TEMPMAT4_ARRAY;
				_submits[_submits._length++] = tempSubmit;
			}
		}
		
		public function line(fromX:Number, fromY:Number, toX:Number, toY:Number, lineWidth:Number, mat:Matrix):void {
			var submit:Submit = _curSubmit;
			var vb:VertexBuffer2D = _vb;
			if (GlUtils.fillLineVb(vb, _clipRect, fromX, fromY, toX, toY, lineWidth, mat)) {
				_renderKey = 0;
				
				var shader:Shader2D = _shader2D;
				var curShader:Value2D = submit.shaderValue;
				if (shader.strokeStyle !== curShader.strokeStyle || shader.ALPHA !== curShader.ALPHA) {
					shader.glTexture = null;
					submit = _curSubmit = Submit.createSubmit(this, _ib, vb, ((vb._byteLength - _RECTVBSIZE * Buffer2D.FLOAT32) / 32) * 3, Value2D.create(ShaderDefines2D.COLOR2D, 0));
					submit.shaderValue.strokeStyle = shader.strokeStyle;
					submit.shaderValue.mainID = ShaderDefines2D.COLOR2D;
					submit.shaderValue.ALPHA = shader.ALPHA;
					_submits[_submits._length++] = submit;
				}
				submit._numEle += 6;
			}
		}
		
		public function moveTo(x:Number, y:Number, b:Boolean = true):void {
			var tPath:Path = _getPath();
			if (b) {
				var _x1:Number = x, _y1:Number = y;
				x = _curMat.a * _x1 + _curMat.c * _y1 /*+ _curMat.tx*/;
				y = _curMat.b * _x1 + _curMat.d * _y1 /*+ _curMat.ty*/;
			}
			tPath.addPoint(x, y);
		}
		
		public function lineTo(x:Number, y:Number, b:Boolean = true):void {
			var tPath:Path = _getPath();
			if (b) {
				var _x1:Number = x, _y1:Number = y;
				x = _curMat.a * _x1 + _curMat.c * _y1/* + _curMat.tx*/;
				y = _curMat.b * _x1 + _curMat.d * _y1/* + _curMat.ty*/;
			}
			tPath.addPoint(x, y);
		}
		
		override public function drawCurves(x:Number, y:Number, args:Array):void {
			setPathId(-1);
			beginPath();
			strokeStyle = args[3];
			lineWidth = args[4];
			var points:Array = args[2];
			x += args[0], y += args[1];
			movePath(x, y);
			moveTo(points[0], points[1]);
			var i:int = 2, n:int = points.length;
			while (i < n) {
				quadraticCurveTo(points[i++], points[i++], points[i++], points[i++]);
			}
			stroke();
		}
		
		override public function arcTo(x1:Number, y1:Number, x2:Number, y2:Number, r:Number):void {
			if (mId != -1) {
				if (mHaveKey) {
					return;
				}
			}
			var i:int = 0;
			var x:Number = 0, y:Number = 0;
			var tPath:Path = _getPath();
			_curMat.copyTo(_tmpMatrix);
			_tmpMatrix.tx = _tmpMatrix.ty = 0;
			_tempPoint.setTo(tPath.getEndPointX(), tPath.getEndPointY());
			_tmpMatrix.invertTransformPoint(_tempPoint);
		
			var dx:Number = _tempPoint.x - x1;
			var dy:Number = _tempPoint.y - y1;
			var len1:Number = Math.sqrt(dx*dx + dy*dy);
			if (len1 <= 0.000001) {
				return;
			}
			var ndx:Number = dx / len1;
			var ndy:Number = dy / len1;
			var dx2:Number = x2 - x1;
			var dy2:Number = y2 - y1;
			var len22:Number = dx2*dx2 + dy2*dy2;
			var len2:Number = Math.sqrt(len22);
			if (len2 <= 0.000001) {
				return;
			}
			var ndx2:Number = dx2 / len2;
			var ndy2:Number = dy2 / len2;
			var odx:Number = ndx + ndx2;
			var ody:Number = ndy + ndy2;
			var olen:Number = Math.sqrt(odx*odx + ody*ody);
			if (olen <= 0.000001) {
				return;
			}

			var nOdx:Number = odx / olen;
			var nOdy:Number = ody / olen;

			var alpha:Number = Math.acos(nOdx*ndx + nOdy*ndy);
			var halfAng:Number = Math.PI / 2 - alpha; 
                                
			len1 = r / Math.tan(halfAng);
			var ptx1:Number = len1*ndx + x1;
			var pty1:Number = len1*ndy + y1;
  
			var orilen:Number = Math.sqrt(len1*len1 + r*r);
			var orix:Number = x1 + nOdx*orilen;
			var oriy:Number = y1 + nOdy*orilen;

			var ptx2:Number = len1*ndx2 + x1;
			var pty2:Number = len1*ndy2 + y1;

			var dir:Number = ndx * ndy2 - ndy * ndx2;

			var fChgAng:Number = 0;
			var sinx:Number = 0.0;
			var cosx:Number = 0.0;
			if (dir >= 0) {
				fChgAng = halfAng * 2;
				var fda:Number = fChgAng / SEGNUM;
				sinx = Math.sin(fda);
				cosx = Math.cos(fda);
			}
			else {
				fChgAng = -halfAng * 2;
				fda = fChgAng / SEGNUM;
				sinx = Math.sin(fda);
				cosx = Math.cos(fda);
			}
		
			x = _curMat.a * ptx1 + _curMat.c * pty1 /*+ _curMat.tx*/;
			y = _curMat.b * ptx1 + _curMat.d * pty1 /*+ _curMat.ty*/;
			if (x != _path.getEndPointX() || y != _path.getEndPointY()) {
				tPath.addPoint(x, y);
			}
			var cvx:Number = ptx1 - orix;
			var cvy:Number = pty1 - oriy;
			var tx:Number = 0.0;
			var ty:Number = 0.0;
			for (i = 0; i < SEGNUM; i++) {
				var cx:Number = cvx*cosx + cvy*sinx;
				var cy:Number = -cvx*sinx + cvy*cosx;
				x = cx + orix;
				y = cy + oriy;
			
				x1 = _curMat.a * x + _curMat.c * y /*+ _curMat.tx*/;
				y1 = _curMat.b * x + _curMat.d * y /*+ _curMat.ty*/;
				x = x1;
				y = y1;
				if (x != _path.getEndPointX() || y != _path.getEndPointY()) {
					tPath.addPoint(x, y);
				}
				cvx = cx;
				cvy = cy;
			}
		}
		
		public function arc(cx:Number, cy:Number, r:Number, startAngle:Number, endAngle:Number, counterclockwise:Boolean = false, b:Boolean = true):void {
			if (mId != -1) {
				var tShape:IShape = VectorGraphManager.getInstance().shapeDic[this.mId];
				if (tShape) {
					if (mHaveKey && !tShape.needUpdate(_curMat))
						return;
				}
				cx = 0;
				cy = 0;
			}
			var a:Number = 0, da:Number = 0, hda:Number = 0, kappa:Number = 0;
			var dx:Number = 0, dy:Number = 0, x:Number = 0, y:Number = 0, tanx:Number = 0, tany:Number = 0;
			var px:Number = 0, py:Number = 0, ptanx:Number = 0, ptany:Number = 0;
			var i:int, ndivs:int, nvals:int;
			
			// Clamp angles
			da = endAngle - startAngle;
			if (!counterclockwise) {
				if (Math.abs(da) >= Math.PI * 2) {
					da = Math.PI * 2;
				} else {
					while (da < 0.0) {
						da += Math.PI * 2;
					}
				}
			} else {
				if (Math.abs(da) >= Math.PI * 2) {
					da = -Math.PI * 2;
				} else {
					while (da > 0.0) {
						da -= Math.PI * 2;
					}
				}
			}
			if (r < 101) {
				ndivs = Math.max(10, da * r / 5);
			} else if (r < 201) {
				ndivs = Math.max(10, da * r / 20);
			} else {
				ndivs = Math.max(10, da * r / 40);
			}
			
			hda = (da / ndivs) / 2.0;
			kappa = Math.abs(4 / 3 * (1 - Math.cos(hda)) / Math.sin(hda));
			if (counterclockwise)
				kappa = -kappa;
			
			nvals = 0;
			var tPath:Path = _getPath();
			var _x1:Number, _y1:Number;
			for (i = 0; i <= ndivs; i++) {
				a = startAngle + da * (i / ndivs);
				dx = Math.cos(a);
				dy = Math.sin(a);
				x = cx + dx * r;
				y = cy + dy * r;
				if (b) {
					_x1 = x, _y1 = y;
					x = _curMat.a * _x1 + _curMat.c * _y1 /*+ _curMat.tx*/;
					y = _curMat.b * _x1 + _curMat.d * _y1 /*+ _curMat.ty*/;
				}
				if (x != _path.getEndPointX() || y != _path.getEndPointY()) {
					tPath.addPoint(x, y);
				}
			}
			dx = Math.cos(endAngle);
			dy = Math.sin(endAngle);
			x = cx + dx * r;
			y = cy + dy * r;
			if (b) {
				_x1 = x, _y1 = y;
				x = _curMat.a * _x1 + _curMat.c * _y1 /*+ _curMat.tx*/;
				y = _curMat.b * _x1 + _curMat.d * _y1 /*+ _curMat.ty*/;
			}
			if (x != _path.getEndPointX() || y != _path.getEndPointY()) {
				tPath.addPoint(x, y);
			}
		}
		
		override public function quadraticCurveTo(cpx:Number, cpy:Number, x:Number, y:Number):void {
			var tBezier:Bezier = Bezier.I;
			var tResultArray:Array = [];
			var _x1:Number = x, _y1:Number = y;
			x = _curMat.a * _x1 + _curMat.c * _y1 /*+ _curMat.tx*/;
			y = _curMat.b * _x1 + _curMat.d * _y1 /*+ _curMat.ty*/;
			_x1 = cpx, _y1 = cpy;
			cpx = _curMat.a * _x1 + _curMat.c * _y1 /*+ _curMat.tx*/;
			cpy = _curMat.b * _x1 + _curMat.d * _y1 /*+ _curMat.ty*/;
			var tArray:Array = tBezier.getBezierPoints([_path.getEndPointX(), _path.getEndPointY(), cpx, cpy, x, y], 30, 2);
			for (var i:int = 0, n:int = tArray.length / 2; i < n; i++) {
				lineTo(tArray[i * 2], tArray[i * 2 + 1], false);
			}
			lineTo(x, y, false);
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
		}
		
		/**
		 * 画多边形(用)
		 * @param	x
		 * @param	y
		 * @param	points
		 */
		public function drawPoly(x:Number, y:Number, points:Array, color:uint, lineWidth:Number, boderColor:uint, isConvexPolygon:Boolean = false):void {
			_renderKey = 0;
			_shader2D.glTexture = null; //置空下，打断纹理相同合并
			var tPath:Path = _getPath();
			if (mId == -1) {
				tPath.polygon(x, y, points, color, lineWidth ? lineWidth : 1, boderColor)
			} else {
				if (mHaveKey) {
					var tShape:IShape = VectorGraphManager.getInstance().shapeDic[mId];
					tShape.setMatrix(_curMat);
					tShape.rebuild(tPath.tempArray);
					tPath.setGeomtry(tShape);
				} else {
					var t:IShape = tPath.polygon(x, y, points, color, lineWidth ? lineWidth : 1, boderColor);
					VectorGraphManager.getInstance().addShape(mId, t);
					t.setMatrix(_curMat);
				}
			}
			
			tPath.update();
			var tPosArray:Array = [mX, mY];
			//var tArray:Array = RenderState2D.getMatrArray();
			//RenderState2D.mat2MatArray(_curMat, tArray);
			var tempSubmit:Submit;
			//通过模板数据来开始真实的绘制
			tempSubmit = Submit.createShape(this, tPath.ib, tPath.vb, tPath.count, tPath.offset, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
			tempSubmit.shaderValue.ALPHA = _shader2D.ALPHA;
			(tempSubmit.shaderValue as PrimitiveSV).u_pos = tPosArray;
			tempSubmit.shaderValue.u_mmat2 = RenderState2D.EMPTYMAT4_ARRAY;
			_submits[_submits._length++] = tempSubmit;
			//画闭合线
			if (lineWidth > 0) {
				if (mHaveLineKey) {
					var tShapeLine:IShape = VectorGraphManager.getInstance().shapeLineDic[mId];
					tShapeLine.rebuild(tPath.tempArray);
					tPath.setGeomtry(tShapeLine);
				} else {
					VectorGraphManager.getInstance().addShape(mId, tPath.drawLine(x, y, points, lineWidth, boderColor));
				}
				tPath.update();
				tempSubmit = Submit.createShape(this, tPath.ib, tPath.vb, tPath.count, tPath.offset, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
				tempSubmit.shaderValue.ALPHA = _shader2D.ALPHA;
				tempSubmit.shaderValue.u_mmat2 = RenderState2D.EMPTYMAT4_ARRAY;
				_submits[_submits._length++] = tempSubmit;
			}
		}
		
		/*******************************************end矢量绘制***************************************************/
		public function drawParticle(x:Number, y:Number, pt:*):void {
			pt.x = x;
			pt.y = y;
			_submits[_submits._length++] = pt;
		}
		
		private function _getPath():Path {
			return _path || (_path = new Path());
		}
	}
}
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