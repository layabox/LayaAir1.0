package laya.webgl.canvas {
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.filters.ColorFilter;
	import laya.layagl.LayaGL;
	import laya.maths.Bezier;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.Render;
	import laya.resource.Bitmap;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.utils.ColorUtils;
	import laya.utils.FontInfo;
	import laya.utils.HTMLChar;
	import laya.utils.Stat;
	import laya.utils.StringKey;
	import laya.utils.VectorGraphManager;
	import laya.utils.WordText;
	import laya.webgl.WebGL;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.save.ISaveData;
	import laya.webgl.canvas.save.SaveBase;
	import laya.webgl.canvas.save.SaveClipRect;
	import laya.webgl.canvas.save.SaveMark;
	import laya.webgl.canvas.save.SaveTransform;
	import laya.webgl.canvas.save.SaveTranslate;
	import laya.webgl.resource.BaseTexture;
	import laya.webgl.resource.CharRenderInfo;
	import laya.webgl.resource.RenderTexture2D;
	import laya.webgl.resource.Texture2D;
	import laya.webgl.shader.BaseShader;
	import laya.webgl.shader.Shader;
	import laya.webgl.shader.ShaderValue;
	import laya.webgl.shader.d2.Shader2D;
	import laya.webgl.shader.d2.ShaderDefines2D;
	import laya.webgl.shader.d2.skinAnishader.SkinMeshBuffer;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.shapes.BasePoly;
	import laya.webgl.shapes.Earcut;
	import laya.webgl.submit.ISubmit;
	import laya.webgl.submit.Submit;
	import laya.webgl.submit.SubmitCMD;
	import laya.webgl.submit.SubmitCanvas;
	import laya.webgl.submit.SubmitKey;
	import laya.webgl.submit.SubmitTarget;
	import laya.webgl.submit.SubmitTexture;
	import laya.webgl.text.TextRender;
	import laya.webgl.utils.Buffer2D;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.Mesh2D;
	import laya.webgl.utils.MeshQuadTexture;
	import laya.webgl.utils.MeshTexture;
	import laya.webgl.utils.MeshVG;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.utils.VertexBuffer2D;
	import laya.webgl.text.CharSubmitCache;
	
	public class WebGLContext2D extends Context {
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static const _SUBMITVBSIZE:int = 32000;
		
		public static const _MAXSIZE:int = 99999999;
		private static const _MAXVERTNUM:int = 65535;
		
		public static const MAXCLIPRECT:Rectangle = /*[STATIC SAFE]*/ new Rectangle(0,0, _MAXSIZE, _MAXSIZE);
		
		public static var _COUNT:int = 0;
			
		public var _tmpMatrix:Matrix = new Matrix();		// chrome下静态的访问比从this访问要慢
		
		private static var SEGNUM:int = 32;
			 
		private static var _contextcount:int = 0;
		
		private var _drawTexToDrawTri_Vert:Float32Array = new Float32Array(8);		// 从速度考虑，不做成static了
		private var _drawTexToDrawTri_Index:Uint16Array = new Uint16Array([0, 1, 2, 0, 2, 3]);
		private var _tempUV:Float32Array = new Float32Array(8);
		private var _drawTriUseAbsMatrix:Boolean = false;	//drawTriange函数的矩阵是全局的，不用再乘以当前矩阵了。这是一个补丁。
		
		public static function __init__():void {
			ContextParams.DEFAULT = new ContextParams();
			WebGLCacheAsNormalCanvas;
		}
		
		public static function set2DRenderConfig():void{
			var gl:*= LayaGL.instance;
			WebGLContext.setBlend(gl, true);//还原2D设置
			WebGLContext.setBlendFunc(gl, WebGLContext.ONE, WebGLContext.ONE_MINUS_SRC_ALPHA);
			WebGLContext.setDepthTest(gl, false);
			WebGLContext.setCullFace(gl, false);
			WebGLContext.setDepthMask(gl, true);
			WebGLContext.setFrontFace(gl, WebGLContext.CCW);
			if (!Render.isConchApp)
			{
				gl.viewport(0, 0, RenderState2D.width, RenderState2D.height);//还原2D视口
			}
		}
		
		public var _id:int = ++_COUNT;
		
		private var _other:ContextParams=null;
		private var _renderNextSubmitIndex:int=0;
		
		private var _path:Path = null;
		private var _primitiveValue2D:Value2D;
		public  var _drawCount:int = 1;
		private var _width:Number = _MAXSIZE;
		private var _height:Number = _MAXSIZE;
		private var _renderCount:int = 0;
		private var _isConvexCmd:Boolean = true;	//arc等是convex的，moveTo,linTo就不是了
		public var _submits:* = null;
		public var _curSubmit:* = null;
		public var _submitKey:SubmitKey = new SubmitKey();	//当前将要使用的设置。用来跟上一次的_curSubmit比较
		
		public var _mesh:MeshQuadTexture=null;			//用Mesh2D代替_vb,_ib. 当前使用的mesh
		public var _pathMesh:MeshVG=null;			//矢量专用mesh。
		public var _triangleMesh:MeshTexture=null;	//drawTriangles专用mesh。由于ib不固定，所以不能与_mesh通用
		
		public var meshlist:Array = [];	//本context用到的mesh
		
		//public var _vbs:Array = [];	//双buffer管理。TODO 临时删掉，需要mesh中加上
		private var _transedPoints:Array = new Array(8);	//临时的数组，用来计算4个顶点的转换后的位置。
		private var _temp4Points:Array = new Array(8);		//临时数组。用来保存4个顶点的位置。
		
		public var _clipRect:Rectangle = MAXCLIPRECT;
		//public var _transedClipInfo:Array = [0, 0, WebGLContext2D._MAXSIZE, 0, 0, WebGLContext2D._MAXSIZE];	//应用矩阵后的clip。ox,oy, xx,xy,yx,yy 	xx,xy等是缩放*宽高
		public var _globalClipMatrix:Matrix = new Matrix(WebGLContext2D._MAXSIZE, 0, 0, WebGLContext2D._MAXSIZE, 0, 0);	//用矩阵描述的clip信息。最终的点投影到这个矩阵上，在0~1之间就可见。
		public var _clipInCache:Boolean = false; 	// 当前记录的clipinfo是在cacheas normal后赋值的，因为cacheas normal会去掉当前矩阵的tx，ty，所以需要记录一下，以便在是shader中恢复
		public var _clipInfoID:uint = 0;					//用来区分是不是clipinfo已经改变了
		private static var _clipID_Gen:uint = 0;			//生成clipid的，原来是  _clipInfoID=++_clipInfoID 这样会有问题，导致兄弟clip的id都相同
		public var _curMat:Matrix=null;
		
		//计算矩阵缩放的缓存
		public var _lastMatScaleX:Number = 1.0;
		public var _lastMatScaleY:Number = 1.0;
		private var _lastMat_a:Number = 1.0;
		private var _lastMat_b:Number = 0.0;
		private var _lastMat_c:Number = 0.0;
		private var _lastMat_d:Number = 1.0;
		
		public var _nBlendType:int = 0;
		public var _save:*=null;
		public var _targets:RenderTexture2D=null;
		public var _charSubmitCache:CharSubmitCache=null;
		
		public var _saveMark:SaveMark = null;
		
		public var _shader2D:Shader2D = new Shader2D();	//
		
		/**
		 * 所cacheAs精灵
		 * 对于cacheas bitmap的情况，如果图片还没准备好，需要有机会重画，所以要保存sprite。例如在图片
		 * 加载完成后，调用repaint
		 */
		public var sprite:Sprite=null;	
		
		//文字颜色。使用顶点色
		public var _drawTextureUseColor:Boolean = false;
		
		private static var _textRender:TextRender = new TextRender();
		
		public var _italicDeg:Number = 0;//文字的倾斜角度
		public var _lastTex:Texture = null; //上次使用的texture。主要是给fillrect用，假装自己也是一个drawtexture
		
		private var _fillColor:uint = 0;
		private var _flushCnt:int = 0;
		
		private static var defTexture:Texture=null;	//给fillrect用
		
		public var _colorFiler:ColorFilter=null;
		
		public var drawTexAlign:Boolean = false;		// 按照像素对齐
			
		public var _incache:Boolean = false;			// 正处在cacheas normal过程中
		
		public function WebGLContext2D(){
			_contextcount++;
			
			//_ib = IndexBuffer2D.QuadrangleIB;
			if (!defTexture) {
				var defTex2d:Texture2D = new Texture2D(2,2);
				defTex2d.setPixels(new Uint8Array(16));
				defTex2d.lock = true;
				defTexture = new Texture(defTex2d);
			}
			_lastTex = defTexture;
			clear();
		}
		
		public function clearBG(r:Number, g:Number, b:Number, a:Number):void {
			var gl:WebGLContext = WebGL.mainContext;
			gl.clearColor(r, g, b, a);
			gl.clear(WebGLContext.COLOR_BUFFER_BIT);
		}
		
		//TODO:coverage
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
			_charSubmitCache.clear();
			
			for (var i:int = 0, n:int = _submits._length; i < n; i++)
			{
				_submits[i].releaseRender();
			}
			_submits.length = 0;
			_submits._length = 0;
			_submits = null;
			_curSubmit = null;

			_path = null;
			//_other && (_other.font = null);
			_save = null;			

			var sz:int;
			for ( i = 0, sz= meshlist.length; i < sz; i++) {
				var curm:Mesh2D = meshlist[i];
				curm.destroy();
			}
			meshlist.length = 0;
			
			sprite = null;
			_targets && (_targets.destroy());
			_targets = null;
			
			//TODO mesh 暂时releaseMem了
		}
		
		//TODO:coverage
		override public function destroy():void
		{
			--_contextcount;
			
			sprite = null;
			
			_releaseMem();
			
			_charSubmitCache.destroy();
			
			_targets && _targets.destroy();//用回收么？可能没什么重复利用的价值
			_targets = null;
			//_ib && (_ib != IndexBuffer2D.QuadrangleIB) && _ib.releaseResource();
			_mesh.destroy();
		}
		
		override public function clear():void
		{
			if (!_submits)
			{//第一次
				_other = ContextParams.DEFAULT;
				_curMat = Matrix.create();
				_charSubmitCache = new CharSubmitCache();
				//_vb = _vbs[0] = VertexBuffer2D.create( -1);
				_mesh = MeshQuadTexture.getAMesh();
				meshlist.push(_mesh);
				_pathMesh = MeshVG.getAMesh();
				meshlist.push(_pathMesh);
				_triangleMesh = MeshTexture.getAMesh();
				meshlist.push(_triangleMesh);
				//if(Config.smartCache) _vbs[1] = VertexBuffer2D.create( -1);
				_submits = [];
				_save = [SaveMark.Create(this)];
				_save.length = 10;
				_shader2D = new Shader2D();
			}
			
			_submitKey.clear();
			
			//_vb = _vbs[_renderCount%2];
			//_vb.clear();
			_mesh.clearVB();
			
			_renderCount++;
			
			//_targets && (_targets.repaint = true);
			
			_drawCount = 1;
			
			_other = ContextParams.DEFAULT;
			_other.lineWidth = _shader2D.ALPHA = 1.0;
			
			_nBlendType = 0;
			
			_clipRect = MAXCLIPRECT;
			
			_curSubmit = Submit.RENDERBASE;
			Submit.RENDERBASE._ref = 0xFFFFFF;
			Submit.RENDERBASE._numEle = 0;
			
			_shader2D.fillStyle = _shader2D.strokeStyle = DrawStyle.DEFAULT;
			
			for (var i:int = 0, n:int = _submits._length; i < n; i++)
				_submits[i].releaseRender();
				
			_submits._length = 0;
			
			_curMat.identity();
			_other.clear();
			
			_saveMark = _save[0];
			_save._length = 1;
		
		}
		
		/**
		 * 设置ctx的size，这个不允许直接设置，必须是canvas调过来的。所以这个函数里也不用考虑canvas相关的东西
		 * @param	w
		 * @param	h
		 */
		public function size(w:Number, h:Number):void {
			if (_width != w || _height != h) {
				_width = w;
				_height = h;
				//TODO 问题：如果是rendertarget 计算内存会有问题，即canvas算一次，rt又算一次,所以这里要修改
				//这种情况下canvas应该不占内存
				if (_targets) {
					_targets.destroy();
					_targets = new RenderTexture2D(w, h, BaseTexture.FORMAT_R8G8B8A8, -1);
				}
				//如果是主画布，要记录窗口大小
				//如果不是 TODO
				if ( Render._context==this) {
					WebGL.mainContext.viewport(0, 0, w, h);
					RenderState2D.width = w;
					RenderState2D.height = h;
				}
			}
			if (w === 0 && h === 0) _releaseMem();
		}
		
		/**
		 * 当前canvas请求保存渲染结果。
		 * 实现：
		 * 如果value==true，就要给_target赋值
		 * @param value {Boolean} 
		 */
		public function set asBitmap(value:Boolean):void {
			if (value) {
				//缺省的RGB没有a，不合理把。况且没必要自定义一个常量。
				//深度格式为-1表示不用深度缓存。
				_targets || (_targets = new RenderTexture2D(_width, _height,BaseTexture.FORMAT_R8G8B8A8,-1));
				if (!_width || !_height)
					throw Error("asBitmap no size!");
			} else {
				_targets && _targets.destroy();	
				_targets = null;
			}
		}
		
		/**
		 * 获得当前矩阵的缩放值
		 * 避免每次都计算getScaleX
		 * @return
		 */
		public function getMatScaleX():Number {
			if (_lastMat_a == _curMat.a && _lastMat_b == _curMat.b)
				return _lastMatScaleX;
			_lastMatScaleX = _curMat.getScaleX();
			_lastMat_a = _curMat.a;
			_lastMat_b = _curMat.b;
			return _lastMatScaleX;
		}
		
		public function getMatScaleY():Number {
			if (_lastMat_c == _curMat.c && _lastMat_d == _curMat.d)
				return _lastMatScaleY;
			_lastMatScaleY = _curMat.getScaleY();
			_lastMat_c = _curMat.c;
			_lastMat_d = _curMat.d;
			return _lastMatScaleY;
		}
		
		//TODO
		public function setFillColor(color:uint):void {
			_fillColor = color;
		}
		public function getFillColor():uint {
			return _fillColor;
		}
		
		override public function set fillStyle(value:*):void {
			if (!_shader2D.fillStyle.equal(value)) {
				SaveBase.save(this, SaveBase.TYPE_FILESTYLE, _shader2D, false);
				_shader2D.fillStyle = DrawStyle.create(value);
				_submitKey.other =-_shader2D.fillStyle.toInt();
			}
		}
		
		public function get fillStyle():* {
			return _shader2D.fillStyle;
		}
		
		override public function set globalAlpha(value:Number):void {
			value = Math.floor(value * 1000) / 1000;
			if (value != _shader2D.ALPHA) {
				SaveBase.save(this, SaveBase.TYPE_ALPHA, _shader2D, false);
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
			
			n == null || (_nBlendType === n) || (SaveBase.save(this, SaveBase.TYPE_GLOBALCOMPOSITEOPERATION, this, true), _curSubmit = Submit.RENDERBASE, _nBlendType = n /*, _shader2D.ALPHA = 1*/);
		}
		
		override public function get globalCompositeOperation():String {
			return BlendMode.NAMES[_nBlendType];
		}
		
		override public function set strokeStyle(value:*):void {
			_shader2D.strokeStyle.equal(value) || (SaveBase.save(this, SaveBase.TYPE_STROKESTYLE, _shader2D, false), _shader2D.strokeStyle = DrawStyle.create(value),_submitKey.other=-_shader2D.strokeStyle.toInt());
		}
		
		public function get strokeStyle():* {
			return _shader2D.strokeStyle;
		}
		
		override public function translate(x:Number, y:Number):void {
			if (x !== 0 || y !== 0) {
				SaveTranslate.save(this);
				if (_curMat._bTransform) {
					SaveTransform.save(this);
					//_curMat.transformPointN(Point.TEMP.setTo(x, y));
					//x = Point.TEMP.x;
					//y = Point.TEMP.y;
					//translate的话，相当于在当前坐标系下移动x,y，所以直接修改_curMat,然后x,y就消失了。
					_curMat.tx += (x * _curMat.a + y * _curMat.c);
					_curMat.ty += (x * _curMat.b + y * _curMat.d);
				}else {
					_curMat.tx = x;
					_curMat.ty = y;
				}
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
			var lastBlend:int = _nBlendType;
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
			if (lastBlend != _nBlendType) {
				//阻止合并
				_curSubmit = Submit.RENDERBASE;
			}
		}
		
		override public function set font(str:String):void {
			//if (str == _other.font.toString())
			//	return;
			_other = _other.make();
			SaveBase.save(this, SaveBase.TYPE_FONT, _other, false);
			//_other.font === FontInContext.EMPTY ? (_other.font = new FontInContext(str)) : (_other.font.setFont(str));
		}
		
		//TODO:coverage
		public function fillText(txt:String,x:Number, y:Number, fontStr:String, color:String, align:String):void {
			_fillText(txt, null, x, y, fontStr, color, null,0,null);
		}
		
		/**
		 * 
		 * @param	txt
		 * @param	words		HTMLChar 数组，是已经在外面排好版的一个数组
		 * @param	x
		 * @param	y
		 * @param	fontStr
		 * @param	color
		 * @param	strokeColor
		 * @param	lineWidth
		 * @param	textAlign
		 * @param	underLine
		 */
		private function _fillText(txt:*, words:Vector.<HTMLChar>, x:Number, y:Number, fontStr:String, color:String, strokeColor:String, lineWidth:int, textAlign:String, underLine:int = 0):void {
			/*
			if (!window.testft) {
				//测试文字
				var teststr = 'a丠両丢丣两严並丧丨丩个丫丬中丮丯';
				_charBook.filltext(this, teststr, 0, 0, 'normal 100 66px 华文行楷', '#ff0000');
				window.testft = true;
			}
			*/
			if (txt)
				_textRender.filltext(this, txt, x, y, fontStr, color, strokeColor, lineWidth, textAlign, underLine);
			else if( words)
				_textRender.fillWords(this, words, x, y, fontStr, color, strokeColor, lineWidth);
		}
		
		public function _fast_filltext(data:WordText, x:Number, y:Number, fontObj:Object, color:String, strokeColor:String, lineWidth:int, textAlign:int, underLine:int = 0 ):void {
			_textRender._fast_filltext(this, data,null, x, y, fontObj as FontInfo, color, strokeColor, lineWidth, textAlign, underLine);
		}
		
		//TODO:coverage
		public override function fillWords(words:Array, x:Number, y:Number, fontStr:String, color:String):void {
			_fillText(null, words as Vector.<HTMLChar>, x, y, fontStr, color, null, -1, null,0);
		}
		
		//TODO:coverage
		override public function fillBorderWords(words:Array, x:Number, y:Number, font:String, color:String, borderColor:String, lineWidth:int):void {
			_fillBorderText(null, words as Vector.<HTMLChar>, x, y, font, color, borderColor, lineWidth, null);
		}
		
		override public function drawText(text:*, x:Number, y:Number, font:String, color:String, textAlign:String):void 
		{
			_fillText(text, null, x, y, font, ColorUtils.create(color).strColor, null, -1, textAlign);
		}
		
		//override public function fillText(txt:*, x:Number, y:Number, fontStr:String, color:String, textAlign:String):void {
			//_fillText(txt, null, x, y, fontStr, color, null, -1, textAlign);
		//}
		
		/**
		 * 只画边框
		 * @param	text
		 * @param	x
		 * @param	y
		 * @param	font
		 * @param	color
		 * @param	lineWidth
		 * @param	textAlign
		 */
		override public function strokeWord(text:*, x:Number, y:Number, font:String, color:String, lineWidth:Number, textAlign:String):void {
			//webgl绘制不了，需要解决
			;
			_fillText(text, null, x, y, font, null, ColorUtils.create(color).strColor, lineWidth || 1, textAlign);
		}
		
		/**
		 * 即画文字又画边框
		 * @param	txt
		 * @param	x
		 * @param	y
		 * @param	fontStr
		 * @param	fillColor
		 * @param	borderColor
		 * @param	lineWidth
		 * @param	textAlign
		 */
		override public function fillBorderText(txt:*, x:Number, y:Number, fontStr:String, fillColor:String, borderColor:String, lineWidth:int, textAlign:String):void {
			//webgl绘制不了，需要解决
			_fillBorderText(txt, null, x, y, fontStr,  ColorUtils.create(fillColor).strColor,  ColorUtils.create(borderColor).strColor, lineWidth, textAlign);
		}
		
		private function _fillBorderText(txt:*, words:Vector.<HTMLChar>, x:Number, y:Number, fontStr:String, fillColor:String, borderColor:String, lineWidth:int, textAlign:String):void {
			_fillText(txt, words, x, y, fontStr, fillColor, borderColor, lineWidth || 1, textAlign);
		}
		
		private function _fillRect(x:Number, y:Number, width:Number, height:Number, rgba:uint):void {
			var submit:Submit = _curSubmit;
			var sameKey:Boolean = submit  && (submit._key.submitType === Submit.KEY_DRAWTEXTURE && submit._key.blendShader === _nBlendType);
			if ( _mesh.vertNum + 4 > _MAXVERTNUM) {
				_mesh = MeshQuadTexture.getAMesh();//创建新的mesh  TODO 如果_mesh不是常见格式，这里就不能这么做了。以后把_mesh单独表示成常用模式 
				meshlist.push(_mesh);
				sameKey = false;
			}
			
			//clipinfo
			sameKey && (sameKey &&= isSameClipInfo(submit));
			
			transformQuad(x, y, width, height, 0, _curMat, _transedPoints);
			if(!clipedOff(_transedPoints)){
				_mesh.addQuad(_transedPoints, Texture.NO_UV, rgba, false);
				//if (GlUtils.fillRectImgVb(_mesh._vb, _clipRect, x, y, width, height, Texture.DEF_UV, _curMat, rgba,this)){
				if (!sameKey) {
					submit = _curSubmit =  SubmitTexture.create(this, _mesh, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
					_submits[_submits._length++] = submit;
					_copyClipInfo(submit, _globalClipMatrix);
					submit.shaderValue.textureHost = _lastTex;
					//这里有一个问题。例如 clip1, drawTex(tex1), clip2, fillRect, drawTex(tex2)	会被分成3个submit，
					//submit._key.copyFrom2(_submitKey, Submit.KEY_DRAWTEXTURE, (_lastTex && _lastTex.bitmap)?_lastTex.bitmap.id: -1);
					submit._key.other = (_lastTex && _lastTex.bitmap)?_lastTex.bitmap.id: -1
					submit._renderType = Submit.TYPE_TEXTURE;
				}				
				_curSubmit._numEle += 6;
				_mesh.indexNum += 6;
				_mesh.vertNum += 4;
			}			
		}
		
		public function fillRect(x:Number, y:Number, width:Number, height:Number, fillStyle:*):void {
			var drawstyle:DrawStyle = fillStyle? DrawStyle.create(fillStyle) : _shader2D.fillStyle;
			//var rgb = drawstyle.toInt() ;
			//由于显卡的格式是 rgba，所以需要处理一下
			//var rgba:uint = ((rgb & 0xff0000) >> 16) | (rgb & 0x00ff00) | ((rgb & 0xff) << 16) | (_shader2D.ALPHA * 255) << 24;
			var rgba:int = mixRGBandAlpha(drawstyle.toInt());
			_fillRect(x, y, width, height, rgba);
		}		
		
		//TODO:coverage
		public override function fillTexture(texture:Texture, x:Number, y:Number, width:Number, height:Number, type:String, offset:Point, other:*):void {
			//test
			/*
			var aa = 95 / 274, bb = 136 / 341, cc = (95 + 41) / 274, dd = (136 + 48) / 341;
			texture.uv = [aa,bb, cc,bb, cc,dd, aa,dd];
			texture.width = 41;
			texture.height = 48;
			*/
			//test
			
			if (!texture._getSource()){
				sprite && Laya.systemTimer.callLater(this, _repaintSprite);
				return;
			}
			_fillTexture(texture,texture.width,texture.height, texture.uvrect,x,y,width,height,type,offset.x,offset.y);
		}
        
		public function _fillTexture(texture:Texture, texw:Number, texh:Number, texuvRect:Array, x:Number, y:Number, width:Number, height:Number, type:String, offsetx:Number, offsety:Number):void {
			var submit:Submit = _curSubmit;
			var sameKey:Boolean = false;
			if ( _mesh.vertNum + 4 > _MAXVERTNUM) {
				_mesh = MeshQuadTexture.getAMesh();
				meshlist.push(_mesh);
				sameKey = false;
			}
			
			//filltexture相关逻辑。计算rect大小以及对应的uv
			var repeatx:Boolean = true;
			var repeaty:Boolean = true;
			switch(type) {
			case "repeat": break;
			case "repeat-x": repeaty = false; break;
			case "repeat-y": repeatx = false; break;
			case "no-repeat": repeatx = repeaty = false; break;
			default:break;
			}
			//用 _temp4Points 来存计算出来的顶点的uv。这里的uv用0到1表示纹理的uv区域。这样便于计算，直到shader中才真的转成了实际uv
			var uv:Array =_temp4Points;
			var stu:Number = 0; //uv起点
			var stv:Number = 0;
			var stx:Number = 0, sty:Number = 0, edx:Number = 0, edy:Number = 0;
			if (offsetx < 0) {
				stx = x; 
				stu = (-offsetx %texw) / texw ;//有偏移的情况下的u不是从头开始
			}else { 
				stx = x + offsetx;
			}
			if (offsety < 0) { 
				sty = y; 
				stv = (-offsety %texh) / texh;//有偏移的情况下的v不是从头开始
			}else { 
				sty = y + offsety; 
			}
			
			edx = x + width;
			edy = y + height;
			(!repeatx) && (edx = Math.min(edx, x + offsetx + texw));//x不重复的话，最多只画一个
			(!repeaty) && (edy = Math.min(edy, y + offsety + texh));//y不重复的话，最多只画一个
			if (edx < x || edy < y)
				return;
			if (stx > edx || sty > edy)
				return;
				
			//计算最大uv
			var edu:Number = (edx-x-offsetx)/texw;
			var edv:Number = (edy - y - offsety) / texh;
			
			transformQuad(stx, sty, edx-stx, edy-sty, 0, _curMat, _transedPoints);
			//四个点对应的uv。必须在transformQuad后面，因为共用了_temp4Points
			uv[0] = stu; uv[1] = stv; uv[2] = edu; uv[3] = stv; uv[4] = edu; uv[5] = edv; uv[6] = stu; uv[7] = edv;
			if (!clipedOff(_transedPoints)) {
				//不依赖于wrapmode了，都走filltexture流程，自己修改纹理坐标
				//tex2d.wrapModeU = BaseTexture.WARPMODE_REPEAT;	//这里会有重复判断
				//tex2d.wrapModeV = BaseTexture.WARPMODE_REPEAT;
				//var rgba:int = mixRGBandAlpha(0xffffffff);
				//rgba = _mixRGBandAlpha(rgba, alpha);	这个函数有问题，不能连续调用，输出作为输入
				var rgba:int = _mixRGBandAlpha( 0xffffffff, _shader2D.ALPHA );
				
				_mesh.addQuad(_transedPoints, uv, rgba, true);
			
				var sv:Value2D = Value2D.create(ShaderDefines2D.TEXTURE2D, 0);
				//这个优化先不要了，因为没太弄明白wrapmode的设置，总是不起作用。
				//if(texture.uvrect[2]<1.0||texture.uvrect[3]<1.0)//这表示是大图集中的一部分，只有这时候才用特殊shader
					sv.defines.add(ShaderDefines2D.FILLTEXTURE);
				(sv as Object).u_TexRange = texuvRect;
				submit = _curSubmit =  SubmitTexture.create(this, _mesh, sv );
				_submits[_submits._length++] = submit;
				_copyClipInfo(submit, _globalClipMatrix);
				submit.shaderValue.textureHost = texture;
				submit._renderType = Submit.TYPE_TEXTURE;
				_curSubmit._numEle += 6;
				_mesh.indexNum += 6;
				_mesh.vertNum += 4;
			}
			breakNextMerge();	//暂不合并
		}
        
		
		/**
		 * 反正只支持一种filter，就不要叫setFilter了，直接叫setColorFilter
		 * @param	value
		 */
		public function setColorFilter(filter:ColorFilter):void {
			SaveBase.save(this, SaveBase.TYPE_COLORFILTER, this, true);
			//_shader2D.filters = value;
			_colorFiler = filter;
			_curSubmit = Submit.RENDERBASE;
			//_reCalculateBlendShader();
		}
		
		public override function drawTexture(tex:Texture, x:Number, y:Number, width:Number, height:Number):void {
			_drawTextureM(tex, x, y, width, height, null, 1,null);
		}
		
		public override function drawTextures(tex:Texture, pos:Array,tx:Number, ty:Number):void {
			if (!tex._getSource()) //source内调用tex.active();
			{
				sprite && Laya.systemTimer.callLater(this, _repaintSprite);
				return;
			}
			
			//TODO 还没实现
			var n:int = pos.length / 2;
			var ipos:int = 0;
			var bmpid:int = tex.bitmap.id;
			for (var i:int = 0; i < n; i++) {
				_inner_drawTexture(tex, bmpid, pos[ipos++]+tx, pos[ipos++]+ty,0,0,null,null, 1.0,false);
			}
			
			/*
			var pre:Rectangle = _clipRect;
			_clipRect = MAXCLIPRECT;
			if (!_drawTextureM(tex, pos[0], pos[1], tex.width, tex.height,null, 1)) {
				throw "drawTextures err";
				return;
			}
			_clipRect = pre;
			
			Stat.drawCall++;//= pos.length / 2;
			
			if (pos.length < 4)
				return;
			
			var finalVB:VertexBuffer2D = _curSubmit._vb || _vb;
			var sx:Number = _curMat.a, sy:Number = _curMat.d;
			var vpos:int = finalVB._byteLength >> 2;// + WebGLContext2D._RECTVBSIZE;
			finalVB.byteLength = finalVB._byteLength + (pos.length / 2 - 1) * WebGLContext2D._RECTVBSIZEBYTE;
			var vbdata:Float32Array = finalVB.getFloat32Array();
			for (var i:int = 2, sz:int = pos.length; i < sz; i += 2) {
				GlUtils.copyPreImgVb(finalVB,vpos, (pos[i] - pos[i - 2]) * sx, (pos[i + 1] - pos[i - 1]) * sy,vbdata);
				_curSubmit._numEle += 6;
				vpos += WebGLContext2D._RECTVBSIZE;
			}
			*/
		}
		
		/**
		 * 为drawTexture添加一个新的submit。类型是 SubmitTexture
		 * @param	vbSize
		 * @param	alpha
		 * @param	webGLImg
		 * @param	tex
		 */
		//TODO:coverage
		private function _drawTextureAddSubmit(imgid:int,tex:Texture):void
		{
			//var alphaBack:Number = shader.ALPHA;
			//shader.ALPHA *= alpha;
			
			var submit:SubmitTexture = null;			
			submit = SubmitTexture.create(this, _mesh, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
			_submits[_submits._length++] = submit;
			submit.shaderValue.textureHost = tex;
			//submit._key.copyFrom2(_submitKey, Submit.KEY_DRAWTEXTURE, imgid);
			submit._key.other = imgid;
			//submit._key.alpha = shader.ALPHA;
			submit._renderType = Submit.TYPE_TEXTURE;
			_curSubmit = submit;
			
			//shader.ALPHA = alphaBack;
		}
		
		public function _drawTextureM(tex:Texture, x:Number, y:Number, width:Number, height:Number, m:Matrix, alpha:Number,uv:Array):Boolean{
			if (!tex._getSource()){ //source内调用tex.active();
				if (sprite) {
					Laya.systemTimer.callLater(this, _repaintSprite);
				}
				return false;
			}
			return _inner_drawTexture(tex, tex.bitmap.id, x, y, width, height, m, uv, alpha,false);
		}
		
		public function _drawRenderTexture(tex:RenderTexture2D, x:Number, y:Number, width:Number, height:Number, m:Matrix, alpha:Number, uv:Array):Boolean {
			return _inner_drawTexture(tex as Texture, -1, x, y, width, height, m, uv, 1.0,false);
		}
		
		//TODO:coverage
		public function submitDebugger():void {
			_submits[_submits._length++] = SubmitCMD.create([], function():void { debugger; },this );
		}
		
		/*
		private function copyClipInfo(submit:Submit, clipInfo:Array):void {
			var cd:Array = submit.shaderValue.clipDir;
			cd[0] = clipInfo[2]; cd[1] = clipInfo[3]; cd[2] = clipInfo[4]; cd[3] = clipInfo[5];
			var cp:Array = submit.shaderValue.clipRect;
			cp[0] = clipInfo[0]; cp[1] = clipInfo[1];
			submit.clipInfoID = this._clipInfoID;
		}
		*/
		public function _copyClipInfo(submit:Submit, clipInfo:Matrix):void {
			var cm:Array = submit.shaderValue.clipMatDir;
			cm[0] = clipInfo.a; cm[1] = clipInfo.b; cm[2] = clipInfo.c; cm[3] = clipInfo.d; 
			var cmp:Array = submit.shaderValue.clipMatPos;
			cmp[0] = clipInfo.tx; cmp[1] = clipInfo.ty;
			submit.clipInfoID = this._clipInfoID;
			
			if (_clipInCache) {
				submit.shaderValue.clipOff[0] = 1;
			}
		}
				
		
		private function isSameClipInfo(submit:Submit):Boolean {
			return (submit.clipInfoID === _clipInfoID);
			/*
			var cd:Array = submit.shaderValue.clipDir;
			var cp:Array = submit.shaderValue.clipRect;
			
			if (clipInfo[0] != cp[0] || clipInfo[1] != cp[1] || clipInfo[2] != cd[0] || clipInfo[3] != cd[1] || clipInfo[4] != cd[2] || clipInfo[5] != cd[3] ) 
				return false;
			return true;
			*/
		}
		
		/**
		 * 这个还是会检查是否合并
		 * @param	tex
		 * @param	minVertNum
		 */
		public function _useNewTex2DSubmit(tex:Texture, minVertNum:int):void {
			//var sameKey:Boolean = tex.bitmap.id >= 0 && preKey.submitType === Submit.KEY_DRAWTEXTURE && preKey.other === tex.bitmap.id ;
			
			if (_mesh.vertNum + minVertNum > _MAXVERTNUM) {
				_mesh = MeshQuadTexture.getAMesh();//创建新的mesh  TODO 如果_mesh不是常见格式，这里就不能这么做了。以后把_mesh单独表示成常用模式 
				meshlist.push(_mesh);
				//sameKey = false;
			}	
			
			var submit:SubmitTexture  = SubmitTexture.create(this, _mesh, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
			_submits[_submits._length++] = _curSubmit = submit;
			submit.shaderValue.textureHost = tex;
			_copyClipInfo(submit, _globalClipMatrix);
		}
		
		/**
		 * 使用上面的设置（texture，submit，alpha，clip），画一个rect
		 */
		public function _drawTexRect(x:Number, y:Number, w:Number, h:Number, uv:Array):void {
			transformQuad(x, y, w, h, _italicDeg, _curMat, _transedPoints);
			//这个是给文字用的，为了清晰，必须要按照屏幕像素对齐，并且四舍五入。
			var ops:Array = _transedPoints;
			ops[0] = (ops[0] + 0.5) | 0;
			ops[1] = (ops[1] + 0.5) | 0;
			ops[2] = (ops[2] + 0.5) | 0;
			ops[3] = (ops[3] + 0.5) | 0;
			ops[4] = (ops[4] + 0.5) | 0;
			ops[5] = (ops[5] + 0.5) | 0;
			ops[6] = (ops[6] + 0.5) | 0;
			ops[7] = (ops[7] + 0.5) | 0;
			
			if (!clipedOff(_transedPoints)) {
				_mesh.addQuad(_transedPoints, uv , _fillColor, true);
				_curSubmit._numEle += 6;
				_mesh.indexNum += 6;
				_mesh.vertNum += 4;
			}
		}
		
		public function drawCallOptimize(enbale:Boolean):Boolean
		{
			_charSubmitCache.enable(enbale, this);
			return enbale;
		}
		
		/**
		 * 
		 * @param	tex {Texture | RenderTexture }
		 * @param  imgid 图片id用来比较合并的
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	m
		 * @param	alpha
		 * @param	uv
		 * @return
		 */
		public function _inner_drawTexture(tex:Texture, imgid:int, x:Number, y:Number, width:Number, height:Number, m:Matrix, uv:Array, alpha:Number, lastRender:Boolean):Boolean {
			var preKey:SubmitKey = _curSubmit._key;
			uv = uv || __JS__("tex._uv")
			//为了优化，如果上次是画三角形，并且贴图相同，会认为他们是一组的，把这个也转成三角形，以便合并。
			//因为好多动画是drawTexture和drawTriangle混用的
			if ( preKey.submitType === Submit.KEY_TRIANGLES && preKey.other === imgid) {
				var tv:Float32Array = _drawTexToDrawTri_Vert;
				tv[0] = x; tv[1] = y; tv[2] = x + width, tv[3] = y, tv[4] = x + width, tv[5] = y + height, tv[6] = x, tv[7] = y + height;
				_drawTriUseAbsMatrix = true;
				var tuv:Float32Array = _tempUV;
				tuv[0] = uv[0];tuv[1] = uv[1];tuv[2] = uv[2];tuv[3] = uv[3];tuv[4] = uv[4];tuv[5] = uv[5];tuv[6] = uv[6];tuv[7] = uv[7];
				drawTriangles(tex, 0, 0, tv, tuv, _drawTexToDrawTri_Index, m, alpha,null,null);//用tuv而不是uv会提高效率
				_drawTriUseAbsMatrix = false;
				return true;
			}

			var mesh:MeshQuadTexture = this._mesh;
			var submit:SubmitTexture = _curSubmit;
			var ops:Array = lastRender?_charSubmitCache.getPos():_transedPoints;
			
			//凡是这个都是在_mesh上操作，不用考虑samekey
			transformQuad(x, y, width || tex.width, height || tex.height, _italicDeg, m || _curMat, ops);
			
			if (drawTexAlign) {
				var round:Function = Math.round;
				ops[0] = round(ops[0]);//  (ops[0] + 0.5) | 0;	// 这么计算负的时候会有问题
				ops[1] = round(ops[1]);
				ops[2] = round(ops[2]);
				ops[3] = round(ops[3]);
				ops[4] = round(ops[4]);
				ops[5] = round(ops[5]);
				ops[6] = round(ops[6]);
				ops[7] = round(ops[7]);
				drawTexAlign = false;	//一次性的
			}

			var rgba:int = _mixRGBandAlpha( 0xffffffff, _shader2D.ALPHA * alpha);
			
			//lastRender = false;
			if (lastRender)
			{
				_charSubmitCache.add(this, tex, imgid, ops, uv , rgba);
				return true;
			}

			_drawCount++;
			
			var sameKey:Boolean = imgid >= 0 && preKey.submitType === Submit.KEY_DRAWTEXTURE && preKey.other === imgid ;
			
			//clipinfo
			sameKey && (sameKey &&= isSameClipInfo(submit));
			
			_lastTex = tex;
			
			if (mesh.vertNum + 4 > _MAXVERTNUM) {
				mesh = _mesh = MeshQuadTexture.getAMesh();//创建新的mesh  TODO 如果_mesh不是常见格式，这里就不能这么做了。以后把_mesh单独表示成常用模式 
				meshlist.push(mesh);
				sameKey = false;	//新的mesh不能算samekey了
			}
			
			{
				mesh.addQuad(ops, uv , rgba, true);
				if (!sameKey) {
					_submits[_submits._length++] = _curSubmit = submit = SubmitTexture.create(this, mesh, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
					submit.shaderValue.textureHost = tex;
					submit._key.other = imgid;
					_copyClipInfo(submit, _globalClipMatrix);
				}
				submit._numEle += 6;
				mesh.indexNum += 6;
				mesh.vertNum += 4;
				return true;
			}
			return false;
		}
		
		/**
		 * 转换4个顶点。为了效率这个不做任何检查。需要调用者的配合。
		 * @param	a		输入。8个元素表示4个点
		 * @param	out		输出
		 */
		public function transform4Points(a:Array, m:Matrix, out:Array):void {
		/*
			out[0] = 846;
			out[1] = 656;
			out[2] = 881;
			out[3] = 657;
			out[4] = 880;
			out[5] = 732;
			out[6] = 844;
			out[7] = 731;
			return ;
		*/
			//var m:Matrix = _curMat;
			var tx:Number = m.tx;
			var ty:Number = m.ty;
			var ma:Number = m.a;
			var mb:Number = m.b;
			var mc:Number = m.c;
			var md:Number = m.d;
			var a0:Number = a[0];
			var a1:Number = a[1];
			var a2:Number = a[2];
			var a3:Number = a[3];
			var a4:Number = a[4];
			var a5:Number = a[5];
			var a6:Number = a[6];
			var a7:Number = a[7];
			if (m._bTransform) {
				out[0] = a0 * ma + a1 * mc + tx; out[1] = a0 * mb + a1 * md + ty;
				out[2] = a2 * ma + a3 * mc + tx; out[3] = a2 * mb + a3 * md + ty;
				out[4] = a4 * ma + a5 * mc + tx; out[5] = a4 * mb + a5 * md + ty;
				out[6] = a6 * ma + a7 * mc + tx; out[7] = a6 * mb + a7 * md + ty;
			}else {
				out[0] = a0 + tx; out[1] = a1 + ty;
				out[2] = a2 + tx; out[3] = a3 + ty;
				out[4] = a4 + tx; out[5] = a5 + ty;
				out[6] = a6 + tx; out[7] = a7 + ty;
			}
		}
		
		/**
		 * pt所描述的多边形完全在clip外边，整个被裁掉了
		 * @param	pt
		 * @return
		 */
		public function clipedOff(pt:Array) :Boolean{
			//TODO
			if (_clipRect.width <= 0 || _clipRect.height <= 0)
				return true;
			return false;
		}
		
		/**
		 * 应用当前矩阵。把转换后的位置放到输出数组中。 
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 * @param   italicDeg 倾斜角度，单位是度。0度无，目前是下面不动。以后要做成可调的
		 */
		public function transformQuad(x:Number, y:Number, w:Number, h:Number, italicDeg:Number, m:Matrix, out:Array):void {
			/*
			out[0] = 100.1; out[1] = 100.1;
			out[2] = 101.1; out[3] = 100.1;
			out[4] = 101.1; out[5] = 101.1;
			out[6] = 100.1; out[7] = 101.1;
			return;
			*/
			var xoff:Number = 0;
			if (italicDeg != 0) {
				xoff = Math.tan(italicDeg * Math.PI / 180) * h;
			}
			var maxx:Number = x + w; var maxy:Number = y + h;
			
			var tx:Number = m.tx;
			var ty:Number = m.ty;
			var ma:Number = m.a;
			var mb:Number = m.b;
			var mc:Number = m.c;
			var md:Number = m.d;
			var a0:Number = x+xoff;
			var a1:Number = y;
			var a2:Number = maxx+xoff;
			var a3:Number = y;
			var a4:Number = maxx;
			var a5:Number = maxy;
			var a6:Number = x;
			var a7:Number = maxy;
			if (m._bTransform) {
				out[0] = a0 * ma + a1 * mc + tx; out[1] = a0 * mb + a1 * md + ty;
				out[2] = a2 * ma + a3 * mc + tx; out[3] = a2 * mb + a3 * md + ty;
				out[4] = a4 * ma + a5 * mc + tx; out[5] = a4 * mb + a5 * md + ty;
				out[6] = a6 * ma + a7 * mc + tx; out[7] = a6 * mb + a7 * md + ty;
			}else {
				out[0] = a0 + tx; out[1] = a1 + ty;
				out[2] = a2 + tx; out[3] = a3 + ty;
				out[4] = a4 + tx; out[5] = a5 + ty;
				out[6] = a6 + tx; out[7] = a7 + ty;
			}			
		}
		
		public function pushRT():void {
			addRenderObject(SubmitCMD.create(null, RenderTexture2D.pushRT,this));
		}
		public function popRT():void {
			addRenderObject(SubmitCMD.create(null, RenderTexture2D.popRT, this));
			breakNextMerge();
		}
		
		//TODO:coverage
		public function useRT(rt:RenderTexture2D):void {
			//这里并没有做cliprect的保存恢复。因为认为调用这个函数的话，就是完全不走context流程了，完全自己控制。
			function _use(rt:RenderTexture2D):void {
				if (!rt) {
					throw 'error useRT'
				}else{
					rt.start();
					rt.clear(0, 0, 0, 0);
				}
			}
				
			addRenderObject(SubmitCMD.create([rt], _use,this));
			breakNextMerge();
		}
		
		/**
		 * 异步执行rt的restore函数
		 * @param	rt
		 */
		//TODO:coverage
		public function RTRestore(rt:RenderTexture2D):void {
			function _restore(rt:RenderTexture2D):void {
				rt.restore();
			}
			addRenderObject(SubmitCMD.create([rt], _restore,this));
			breakNextMerge();
		}
		
		/**
		 * 强制拒绝submit合并
		 * 例如切换rt的时候
		 */
		public function breakNextMerge():void {
			_curSubmit = Submit.RENDERBASE;			
		}
		
		//TODO:coverage
		private function _repaintSprite():void {
			sprite && sprite.repaint();
		}
		
		/**
		 * 
		 * @param	tex
		 * @param	x			
		 * @param	y
		 * @param	width
		 * @param	height
		 * @param	transform	图片本身希望的矩阵
		 * @param	tx			节点的位置
		 * @param	ty
		 * @param	alpha
		 */
		override public function drawTextureWithTransform(tex:Texture, x:Number, y:Number, width:Number, height:Number, transform:Matrix, tx:Number, ty:Number, alpha:Number, blendMode:String, colorfilter:ColorFilter = null):void {
			var oldcomp:String = null;
			var curMat:Matrix = _curMat;
			if (blendMode) {
				oldcomp = globalCompositeOperation;
				globalCompositeOperation = blendMode;
			}
			var oldColorFilter:ColorFilter = _colorFiler;
			if (colorfilter) {
				setColorFilter(colorfilter);
			}
			
			if (!transform) {
				_drawTextureM(tex, x + tx, y + ty, width, height, curMat, alpha, null);
				if (blendMode) {
					globalCompositeOperation = oldcomp;
				}
				if ( colorfilter) {
					setColorFilter(oldColorFilter);
				}
				return;
			}
			var tmpMat:Matrix = _tmpMatrix;
			//克隆transform,因为要应用tx，ty，这里不能修改原始的transform
			tmpMat.a = transform.a; tmpMat.b = transform.b; tmpMat.c = transform.c; tmpMat.d = transform.d; tmpMat.tx = transform.tx + tx; tmpMat.ty = transform.ty + ty;
			tmpMat._bTransform = transform._bTransform;
			if (transform && curMat._bTransform) {
				Matrix.mul(tmpMat, curMat, tmpMat);
				transform = tmpMat;
				transform._bTransform = true;
			}else {
				//如果curmat没有旋转。
				transform = tmpMat;
			}
			_drawTextureM(tex, x, y, width, height, transform, alpha, null);
			if (blendMode) {
				globalCompositeOperation = oldcomp;
			}
			if ( colorfilter) {
				setColorFilter(oldColorFilter);
			}
		}

		/**
		 * * 把ctx中的submits提交。结果渲染到target上
		 * @param	ctx
		 * @param	target
		 */
		private function _flushToTarget(context:WebGLContext2D, target:RenderTexture2D):void {
			//if (target._destroy) return;
			//var preworldClipRect:Rectangle = RenderState2D.worldClipRect;
			//裁剪不用考虑，现在是在context内部自己维护，不会乱窜
			RenderState2D.worldScissorTest = false;
			WebGL.mainContext.disable(WebGLContext.SCISSOR_TEST);
			
			var preAlpha:Number = RenderState2D.worldAlpha;
			var preMatrix4:Array = RenderState2D.worldMatrix4;
			var preMatrix:Matrix = RenderState2D.worldMatrix;
			
			var preShaderDefines:ShaderDefines2D = RenderState2D.worldShaderDefines;
			
			RenderState2D.worldMatrix = Matrix.EMPTY;
			
			RenderState2D.restoreTempArray();
			RenderState2D.worldMatrix4 = RenderState2D.TEMPMAT4_ARRAY;
			RenderState2D.worldAlpha = 1;
			//RenderState2D.worldFilters = null;
			//RenderState2D.worldShaderDefines = null;
			BaseShader.activeShader = null;
			
			target.start();
			// 如果没有命令就不要clear。这么改是因为嵌套cacheas出问题了
			// 如果一个sprite cacheas normal ，他的子节点有cacheas bitmap的（包括mask等）就会不断的执行 _flushToTarget和drawCamvase,从而把target上的内容清掉
			// 由于cacheas normal 导致 RenderSprite没有机会执行 _cacheStyle.canvas 存在的分支。在
			if(context._submits._length>0)
				target.clear(0, 0, 0, 0);			
			
			context._curSubmit = Submit.RENDERBASE;
			context.flush();
			context.clear();
			target.restore();
			context._curSubmit = Submit.RENDERBASE;
			//context._canvas
			BaseShader.activeShader = null;
			RenderState2D.worldAlpha = preAlpha;
			RenderState2D.worldMatrix4 = preMatrix4;
			RenderState2D.worldMatrix = preMatrix;
			//RenderState2D.worldFilters = preFilters;
			//RenderState2D.worldShaderDefines = preShaderDefines;
		}		
		
		override public function drawCanvas(canvas:HTMLCanvas, x:Number, y:Number, width:Number, height:Number):void {
			if (!canvas) return;
			var src:WebGLContext2D = canvas.context as WebGLContext2D;
			var submit:ISubmit;
			if (src._targets) {
				//生成渲染结果到src._targets上
				/*
				this._submits[this._submits._length++] = SubmitCanvas.create(src, 0, null);
				_curSubmit = Submit.RENDERBASE;
				//画出src._targets
				//drawTexture(src._targets.target.getTexture(), x, y, width, height, 0, 0);
				*/
				//应用并清空canvas中的指令。如果内容需要重画，RenderSprite会给他重新加入submit
				if ( src._submits._length > 0) {
					submit = SubmitCMD.create([src, src._targets], _flushToTarget,this);
					_submits[_submits._length++] = submit;
				}
				//在这之前就已经渲染出结果了。
				_drawRenderTexture(src._targets, x, y, width, height, null, 1.0, RenderTexture2D.flipyuv);
				_curSubmit = Submit.RENDERBASE;
				/*
				this._submits[this._submits._length++] = SubmitCanvas.create(src, 0, null);
				//src._targets.flush(src);
				_curSubmit = Submit.RENDERBASE;
				//src._targets.drawTo(this, x, y, width, height);
				//drawTexture(src._targets.target.getTexture(), x, y, width, height, 0, 0);
				_drawRenderTexture(src._targets, x, y, width, height,null,1.0, RenderTexture.flipyuv);
				*/
			} else {
				var canv:WebGLCacheAsNormalCanvas = canvas as WebGLCacheAsNormalCanvas;
				if (canv.touches) {
					(canv.touches as Array).forEach(function(v:CharRenderInfo):void { v.touch(); } );
				}
								
				submit = SubmitCanvas.create(canvas, _shader2D.ALPHA, _shader2D.filters);
				this._submits[this._submits._length++] = submit;
				(submit as SubmitCanvas)._key.clear();
				//var sx:Number = width / canvas.width;
				//var sy:Number = height / canvas.height;
				var mat:Matrix = (submit as SubmitCanvas)._matrix;
				_curMat.copyTo(mat);
				//sx != 1 && sy != 1 && mat.scale(sx, sy);
				// 先加上位置，最后再乘逆
				var tx:Number = mat.tx, ty:Number = mat.ty;
				mat.tx = mat.ty = 0;
				mat.transformPoint(Point.TEMP.setTo(x, y));	// 用当前矩阵变换 (x,y)
				mat.translate(Point.TEMP.x + tx, Point.TEMP.y + ty);	// 加上原来的 (tx,ty)
				
				Matrix.mul(canv.invMat, mat,  mat);

				_curSubmit = Submit.RENDERBASE;
			}
		}
		
		public function drawTarget(rt:RenderTexture2D, x:Number, y:Number, width:Number, height:Number, m:Matrix, shaderValue:Value2D, uv:Array = null, blend:int = -1):Boolean {
			_drawCount++;
			var rgba:int = mixRGBandAlpha(_drawTextureUseColor?(fillStyle?fillStyle.toInt():0):0xffffffff);
			if (_mesh.vertNum + 4 > _MAXVERTNUM) {
				_mesh = MeshQuadTexture.getAMesh();//创建新的mesh  TODO 如果_mesh不是常见格式，这里就不能这么做了。以后把_mesh单独表示成常用模式 
				meshlist.push(_mesh);
			}
			
			//凡是这个都是在_mesh上操作，不用考虑samekey
			transformQuad(x, y, width, height, 0, m || _curMat, _transedPoints);
			if(!clipedOff(_transedPoints)){
				_mesh.addQuad(_transedPoints, uv || Texture.DEF_UV, 0xffffffff, true);
				//if (GlUtils.fillRectImgVb( _mesh._vb, _clipRect, x, y, width , height , uv || Texture.DEF_UV, m || _curMat, rgba, this)) {
				var submit:SubmitTarget = _curSubmit = SubmitTarget.create(this,_mesh,shaderValue, rt);
				submit.blendType = (blend == -1)?_nBlendType:blend;
				_copyClipInfo(submit as Submit, _globalClipMatrix);
				submit._numEle = 6;
				_mesh.indexNum += 6;
				_mesh.vertNum += 4;
				_submits[_submits._length++] = submit;
				//暂时drawTarget不合并
				_curSubmit = Submit.RENDERBASE
				return true;
			}
			//暂时drawTarget不合并
			_curSubmit = Submit.RENDERBASE
			return false;			
		}
		
		override public function drawTriangles(tex:Texture, x:Number, y:Number, vertices:Float32Array, uvs:Float32Array, indices:Uint16Array, matrix:Matrix, alpha:Number, color:ColorFilter, blendMode:String):void {
			if (!tex._getSource()){ //source内调用tex.active();
				if (sprite) {
					Laya.systemTimer.callLater(this, _repaintSprite);
				}
				return ;
			}
			_drawCount++;
			
            // 为了提高效率，把一些变量放到这里
            var tmpMat:Matrix = _tmpMatrix;
			var triMesh:MeshTexture = _triangleMesh;
			
			var oldColorFilter:ColorFilter=null;
			var needRestorFilter:Boolean = false;
			if (color) {
				oldColorFilter = _colorFiler;
				//这个不用save，直接修改就行
				_colorFiler = color;
				_curSubmit = Submit.RENDERBASE;
				needRestorFilter = oldColorFilter!=color;
			}
			var webGLImg:Bitmap = tex.bitmap as Bitmap;
			var preKey:SubmitKey = _curSubmit._key;
			var sameKey:Boolean = preKey.submitType === Submit.KEY_TRIANGLES && preKey.other === webGLImg.id && preKey.blendShader== _nBlendType;
			
			//var rgba:int = mixRGBandAlpha(0xffffffff);
			//rgba = _mixRGBandAlpha(rgba, alpha);	这个函数有问题，不能连续调用，输出作为输入
			if (triMesh.vertNum + vertices.length / 2 > _MAXVERTNUM) {
				triMesh = _triangleMesh = MeshTexture.getAMesh();//创建新的mesh  TODO 如果_mesh不是常见格式，这里就不能这么做了。以后把_mesh单独表示成常用模式 
				meshlist.push(triMesh);
				sameKey = false;	//新的mesh不能算samekey了
			}
			if (!sameKey) {
				//添加一个新的submit
				var submit:SubmitTexture = _curSubmit = SubmitTexture.create(this, triMesh, Value2D.create(ShaderDefines2D.TEXTURE2D, 0));
				submit.shaderValue.textureHost = tex;
				submit._renderType = Submit.TYPE_TEXTURE;
				submit._key.submitType = Submit.KEY_TRIANGLES;
				submit._key.other = webGLImg.id;
				_copyClipInfo(submit, _globalClipMatrix);				
				_submits[_submits._length++] = submit;
			}
			
			var rgba:int = _mixRGBandAlpha( 0xffffffff, _shader2D.ALPHA * alpha);
			if(!_drawTriUseAbsMatrix){
				if (!matrix) {
					tmpMat.a = 1; tmpMat.b = 0; tmpMat.c = 0; tmpMat.d = 1; tmpMat.tx = x; tmpMat.ty = y;
				} else {
					tmpMat.a = matrix.a; tmpMat.b = matrix.b; tmpMat.c = matrix.c; tmpMat.d = matrix.d; tmpMat.tx = matrix.tx + x; tmpMat.ty = matrix.ty + y;
				}
				Matrix.mul(tmpMat, _curMat, tmpMat);
				triMesh.addData(vertices, uvs, indices, tmpMat, rgba);
			}else {
				// 这种情况是drawtexture转成的drawTriangle，直接使用matrix就行，传入的xy都是0
				triMesh.addData(vertices, uvs, indices, matrix, rgba);
			}
			_curSubmit._numEle += indices.length;
			
			if (needRestorFilter) {
				_colorFiler = oldColorFilter;
				_curSubmit = Submit.RENDERBASE;
			}	
			//return true;
		}
		
		public function transform(a:Number, b:Number, c:Number, d:Number, tx:Number, ty:Number):void {
			SaveTransform.save(this);			
			Matrix.mul(Matrix.TEMP.setTo(a, b, c, d, tx, ty), _curMat, _curMat);	//TODO 这里会有效率问题。一堆的set
			_curMat._checkTransform();
		}
		
		//TODO:coverage
		public function _transformByMatrix(matrix:Matrix, tx:Number, ty:Number):void {
			matrix.setTranslate(tx, ty);
			Matrix.mul(matrix, _curMat, _curMat);
			matrix.setTranslate(0, 0);
			_curMat._bTransform = true;
		}
		
		//TODO:coverage
		override public function setTransformByMatrix(value:Matrix):void {
			value.copyTo(_curMat);
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
			SaveClipRect.save(this);
			if (this._clipRect == MAXCLIPRECT) {
				this._clipRect = new Rectangle(x, y, width, height);
			}else {
				_clipRect.width = width;
				_clipRect.height = height;
				
				//把xy转换到当前矩阵空间。宽高不用转换，这样在shader中计算的时候就不用把方向normalize了
				_clipRect.x = x;
				_clipRect.y = y;
			}
			_clipID_Gen++;
			_clipID_Gen %= 10000;
			_clipInfoID = _clipID_Gen;
			var cm:Matrix = _globalClipMatrix;
			//TEMP 处理clip交集问题，这里有点问题，无法处理旋转，翻转 是临时瞎写的
			var minx:Number = cm.tx;
			var miny:Number = cm.ty;
			var maxx:Number = minx + cm.a;
			var maxy:Number = miny + cm.d;
			//TEMP end
			
			if (_clipRect.width >= WebGLContext2D._MAXSIZE) {
				cm.a = cm.d = WebGLContext2D._MAXSIZE; 
				cm.b = cm.c = cm.tx = cm.ty = 0;
			}else {
				//其实就是矩阵相乘
				if (_curMat._bTransform) {
					cm.tx = _clipRect.x * _curMat.a + _clipRect.y * _curMat.c + _curMat.tx;
					cm.ty = _clipRect.x * _curMat.b + _clipRect.y * _curMat.d + _curMat.ty;
					cm.a = _clipRect.width * _curMat.a;
					cm.b = _clipRect.width * _curMat.b;
					cm.c = _clipRect.height * _curMat.c;
					cm.d = _clipRect.height * _curMat.d;
				}else {
					cm.tx = _clipRect.x + _curMat.tx;
					cm.ty = _clipRect.y + _curMat.ty;
					cm.a = _clipRect.width ;
					cm.b = cm.c  = 0;
					cm.d = _clipRect.height;
				}
				if (_incache) {
					_clipInCache = true;
				}
			}
			
			//TEMP 处理clip交集问题，这里有点问题，无法处理旋转,翻转
			if ( cm.a > 0 && cm.d > 0) {
				var cmaxx:Number = cm.tx + cm.a;
				var cmaxy:Number = cm.ty + cm.d;
				if (cmaxx <= minx ||cmaxy<=miny || cm.tx>=maxx || cm.ty>=maxy) {
					//超出范围了
					cm.a =-0.1; cm.d =-0.1;
				}else{
					if (cm.tx < minx) {
						cm.a -= (minx - cm.tx);
						cm.tx = minx;
					}
					if (cmaxx > maxx) {
						cm.a -= (cmaxx - maxx);
					}
					if (cm.ty < miny) {
						cm.d -= (miny-cm.ty);
						cm.ty = miny;
					}
					if (cmaxy > maxy) {
						cm.d -= (cmaxy - maxy);
					}
					if (cm.a <= 0) cm.a =-0.1;
					if (cm.d <= 0) cm.d =-0.1;
				}
			}
			//TEMP end
			
			
		}
		
		/**
		 * 从setIBVB改为drawMesh
		 * type 参数不知道是干什么的，先删掉。offset好像跟attribute有关，删掉
		 * @param	x
		 * @param	y
		 * @param	ib
		 * @param	vb
		 * @param	numElement
		 * @param	mat
		 * @param	shader
		 * @param	shaderValues
		 * @param	startIndex
		 * @param	offset
		 */
		//TODO:coverage
		public function drawMesh(x:Number, y:Number, ib:IndexBuffer2D, vb:VertexBuffer2D, numElement:int, mat:Matrix, shader:Shader, shaderValues:Value2D, startIndex:int = 0):void {
			;
		}
		
		public function addRenderObject(o:ISubmit):void {
			this._submits[this._submits._length++] = o;
		}
		
		/**
		 * 
		 * @param	start
		 * @param	end
		 */
		public function submitElement(start:int, end:int):int {
			//_ib._bind_upload() || _ib._bind();
			//_vb._bind_upload() || _vb._bind();
			var mainCtx:Boolean = Render._context === this;
			var renderList:Array = this._submits;
			var ret:int = (renderList as Object)._length;
			end < 0 && (end = (renderList as Object)._length);			
			var submit:Submit=Submit.RENDERBASE;
			while (start < end) {
				_renderNextSubmitIndex = start + 1;
				if (renderList[start] === Submit.RENDERBASE) 
				{
					start++;
					continue;
				}
				Submit.preRender = submit;
				submit = renderList[start];
				//只有submitscissor才会返回多个
				start += submit.renderSubmit();
				//本来做了个优化，如果是主画布，用完立即releaseRender. 但是实际没有什么效果，且由于submit需要用来对比，即使用完也不能修改，所以这个优化又去掉了
			}
			return ret;
		}
		
		override public function flush():int {
			var ret:int =  submitElement(0, _submits._length);
			_path && _path.reset();
			SkinMeshBuffer.instance && SkinMeshBuffer.getInstance().reset();
			
			//Stat.mesh2DNum += meshlist.length;
			_curSubmit = Submit.RENDERBASE;
			
			for (var i:int= 0, sz:int= meshlist.length; i < sz; i++) {
				var curm:Mesh2D = meshlist[i];
				curm.canReuse?(curm.releaseMesh()):(curm.destroy());
			}
			meshlist.length = 0;
			
			_mesh = MeshQuadTexture.getAMesh();	//TODO 不要这样。
			_pathMesh = MeshVG.getAMesh();
			_triangleMesh = MeshTexture.getAMesh();
			meshlist.push(_mesh, _pathMesh, _triangleMesh);
			
			_flushCnt++;
			//charbook gc
			if (_flushCnt % 60 == 0 && Render._context == this) {
				var texRender:* = Laya['textRender'] ;
				if(texRender)
				texRender.GC(false);
			}
			
			return ret;
		}
		
		/*******************************************start矢量绘制***************************************************/
		private var mId:int = -1;
		private var mHaveKey:Boolean = false;
		private var mHaveLineKey:Boolean = false;
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
		
		override public function beginPath(convex:Boolean=false):void {
			var tPath:Path = _getPath();
			tPath.beginPath(convex);
		}
		
		override public function closePath():void {
			//_path.closePath = true;
			_path.closePath();
		}
		
		/**
		 * 添加一个path。
		 * @param	points [x,y,x,y....]	这个会被保存下来，所以调用者需要注意复制。
		 * @param	close	是否闭合
		 * @param   convex 是否是凸多边形。convex的优先级是这个最大。fill的时候的次之。其实fill的时候不应该指定convex，因为可以多个path
		 * @param	dx  需要添加的平移。这个需要在应用矩阵之前应用。
		 * @param	dy
		 */
		public function addPath(points:Array, close:Boolean, convex:Boolean, dx:Number, dy:Number):void {
			var ci:int = 0;
			for (var i:int = 0, sz:int = points.length / 2; i < sz; i++) {
				var x1:Number = points[ci]+dx, y1:Number = points[ci + 1]+dy;
				points[ci] = x1;
				points[ci + 1] = y1;
				ci += 2;
			}
			_getPath().push(points, convex);
		}
		
		public function fill():void {
			var m:Matrix = _curMat;
			var tPath:Path = _getPath();
			var submit:Submit = _curSubmit;
			var sameKey:Boolean = (submit._key.submitType === Submit.KEY_VG && submit._key.blendShader === _nBlendType);
			sameKey && (sameKey&&=isSameClipInfo(submit));
			if (!sameKey) {
				_curSubmit = addVGSubmit(_pathMesh);
			}
			var rgba:uint = mixRGBandAlpha(fillStyle.toInt());
			var curEleNum:int = 0;
			var idx:Array;
			//如果有多个path的话，要一起填充mesh，使用相同的颜色和alpha
			for ( var i:int = 0, sz:int = tPath.paths.length; i < sz; i++) {
				var p:* = tPath.paths[i];
				var vertNum:int = p.path.length / 2;
				if (vertNum < 3 ||(vertNum==3 && !p.convex))
					continue;
				var cpath:Array = p.path.concat();
				// 应用矩阵转换顶点
				var pi:int = 0;
				var xp:int, yp:int;
				var _x:Number, _y:Number;
				if ( m._bTransform) {
					for ( pi = 0; pi < vertNum; pi++) {
						xp = pi << 1;
						yp = xp+1;
						_x = cpath[xp];
						_y = cpath[yp];
						
						cpath[xp] = m.a * _x + m.c * _y + m.tx;
						cpath[yp] = m.b * _x + m.d * _y + m.ty;
					}
				}else {
					for ( pi = 0; pi < vertNum; pi++) {
						xp = pi << 1;
						yp = xp+1;
						_x = cpath[xp];
						_y = cpath[yp];
						cpath[xp] = _x + m.tx;
						cpath[yp] = _y + m.ty;
					}
				}
				
				if ( _pathMesh.vertNum + vertNum > _MAXVERTNUM ) {
					//;
					//顶点数超了，要先提交一次
					_curSubmit._numEle += curEleNum;
					curEleNum = 0;
					//然后用新的mesh，和新的submit。
					_pathMesh = MeshVG.getAMesh();
					_curSubmit = addVGSubmit(_pathMesh);
				}
				
				var curvert:int = _pathMesh.vertNum;
				//生成 ib
				if (p.convex) { //convex的ib比较容易
					var faceNum:int = vertNum - 2;
					idx = new Array(faceNum * 3);
					var idxpos:int = 0;
					for (var fi:int = 0; fi < faceNum; fi++) {
						idx[idxpos++] = curvert ;
						idx[idxpos++] = fi+1 + curvert;
						idx[idxpos++] = fi+2 + curvert;
					}
				}
				else {
					idx = Earcut.earcut(cpath, null, 2);	//返回索引
					if (curvert > 0) {
						//修改ib
						for (var ii:int = 0; ii < idx.length; ii++) {
							idx[ii] += curvert;
						}
					}
				}
				//填充mesh
				_pathMesh.addVertAndIBToMesh(this, cpath, rgba, idx);
				curEleNum += idx.length;
			}
			_curSubmit._numEle+=  curEleNum;			
		}
		
		private function addVGSubmit(mesh:Mesh2D):Submit {
			//elenum设为0，后面再加
			var submit:Submit = Submit.createShape(this, mesh, 0, Value2D.create(ShaderDefines2D.PRIMITIVE, 0));
			//submit._key.clear();
			//submit._key.blendShader = _submitKey.blendShader;	//TODO 这个在哪里赋值的啊
			submit._key.submitType = Submit.KEY_VG;
			_submits[_submits._length++] = submit;
			_copyClipInfo(submit, _globalClipMatrix);
			return submit;
		}
		
		override public function stroke():void {
			if (lineWidth > 0) {
				var rgba:uint = mixRGBandAlpha(strokeStyle._color.numColor);
				var tPath:Path = _getPath();
				var submit:Submit = _curSubmit;
				var sameKey:Boolean = (submit._key.submitType === Submit.KEY_VG && submit._key.blendShader === _nBlendType);
				sameKey && (sameKey &&= isSameClipInfo(submit));
				
				if (!sameKey) {
					_curSubmit = addVGSubmit(_pathMesh);
				}
				var curEleNum:int = 0;
				//如果有多个path的话，要一起填充mesh，使用相同的颜色和alpha
				for ( var i:int = 0, sz:int = tPath.paths.length; i < sz; i++) {
					var p:* = tPath.paths[i];
					if (p.path.length <= 0)
						continue;
					var idx:Array = [];
					var vertex:Array = [];//x,y
					//p.path.loop;
					//填充vbib
					var maxVertexNum:int = p.path.length * 2;	//最大可能产生的顶点数。这个需要考虑考虑
					if (maxVertexNum < 2)
						continue;
					if ( _pathMesh.vertNum + maxVertexNum > _MAXVERTNUM ) {
						//;
						//顶点数超了，要先提交一次
						_curSubmit._numEle += curEleNum;
						curEleNum = 0;
						//然后用新的mesh，和新的submit。
						_pathMesh = MeshVG.getAMesh();
						meshlist.push(_pathMesh);
						_curSubmit = addVGSubmit(_pathMesh);
					}
					//这个需要放在创建新的mesh的后面，因为需要mesh.vertNum,否则如果先调用这个，再创建mesh，那么ib就不对了
					BasePoly.createLine2(p.path, idx, lineWidth, _pathMesh.vertNum, vertex, p.loop);	//_pathMesh.vertNum 是要加到生成的ib上的
					// 变换所有的点
					var ptnum:int = vertex.length / 2;
					var m:Matrix = _curMat;
					var pi:int = 0;
					var xp:int, yp:int;
					var _x:Number, _y:Number;
					if ( m._bTransform) {
						for ( pi = 0; pi < ptnum; pi++) {
							xp = pi << 1;
							yp = xp+1;
							_x = vertex[xp];
							_y = vertex[yp];
							
							vertex[xp] = m.a * _x + m.c * _y + m.tx;
							vertex[yp] = m.b * _x + m.d * _y + m.ty;
						}
					}else {
						for ( pi = 0; pi < ptnum; pi++) {
							xp = pi << 1;
							yp = xp+1;
							_x = vertex[xp];
							_y = vertex[yp];
							vertex[xp] = _x + m.tx;
							vertex[yp] = _y + m.ty;
						}
					}
					
					//this.drawPoly(0, 0, p.path, fillStyle._color.numColor, 0, 0, p.convex);
					//填充mesh
					_pathMesh.addVertAndIBToMesh(this, vertex, rgba, idx);
					curEleNum += idx.length;
				}
				_curSubmit._numEle+=  curEleNum;
			}
		}
		
		public override function moveTo(x:Number, y:Number):void {
			var tPath:Path = _getPath();
			tPath.newPath();
			tPath._lastOriX = x;
			tPath._lastOriY = y;
			tPath.addPoint(x, y);
		}
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	b 是否应用矩阵
		 */
		public override function lineTo(x:Number, y:Number):void {
			var tPath:Path = _getPath();
			if (Math.abs(x-tPath._lastOriX)<1e-3 && Math.abs(y - tPath._lastOriY)<1e-3)//不判断的话，下面的画线算法受不了
				return;
			tPath._lastOriX = x;
			tPath._lastOriY = y;
			tPath.addPoint(x, y);
		}
		/*
		override public function drawCurves(x:Number, y:Number,points:Array, lineColor:*, lineWidth:Number = 1):void {
			//setPathId(-1);
			beginPath();
			strokeStyle = lineColor;
			this.lineWidth = lineWidth;
			var points:Array = points;
			//movePath(x, y); TODO 这个被去掉了
			moveTo(points[0], points[1]);
			var i:int = 2, n:int = points.length;
			while (i < n) {
				quadraticCurveTo(points[i++], points[i++], points[i++], points[i++]);
			}
			stroke();
		}
		*/
		
		override public function arcTo(x1:Number, y1:Number, x2:Number, y2:Number, r:Number):void {
			/*
			if (mId != -1) {
				if (mHaveKey) {
					return;
				}
			}
			*/
			var i:int = 0;
			var x:Number = 0, y:Number = 0;
			var dx:Number = _path._lastOriX - x1;
			var dy:Number = _path._lastOriY - y1;
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
  
			var orilen:Number = Math.sqrt(len1 * len1 + r * r);
			//圆心
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
		
			//x = _curMat.a * ptx1 + _curMat.c * pty1 /*+ _curMat.tx*/;
			//y = _curMat.b * ptx1 + _curMat.d * pty1 /*+ _curMat.ty*/;
			var lastx:Number=_path._lastOriX, lasty:Number=_path._lastOriY;	//没有矩阵转换的上一个点
			var _x1:Number = ptx1 , _y1:Number = pty1 ;
			if ( Math.abs(_x1- _path._lastOriX)>0.1 || Math.abs( _y1- _path._lastOriY)>0.1 ) {
				x = _x1;// _curMat.a * _x1 + _curMat.c * _y1 + _curMat.tx;
				y = _y1;//_curMat.b * _x1 + _curMat.d * _y1 + _curMat.ty;
				lastx = _x1;
				lasty = _y1;
				_path.addPoint(x, y);
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
			
				//x1 = _curMat.a * x + _curMat.c * y /*+ _curMat.tx*/;
				//y1 = _curMat.b * x + _curMat.d * y /*+ _curMat.ty*/;
				//x = x1;
				//y = y1;
				if ( Math.abs(lastx-x)>0.1 || Math.abs(lasty - y)>0.1) {
					//var _tx1:Number = x, _ty1:Number = y;
					//x = _curMat.a * _tx1 + _curMat.c * _ty1 + _curMat.tx;
					//y = _curMat.b * _tx1 + _curMat.d * _ty1 + _curMat.ty;
					_path.addPoint(x, y);
					lastx = x;
					lasty = y;
				}
				cvx = cx;
				cvy = cy;
			}
		}
		
		public function arc(cx:Number, cy:Number, r:Number, startAngle:Number, endAngle:Number, counterclockwise:Boolean = false, b:Boolean = true):void {
			/* TODO 缓存还没想好
			if (mId != -1) {
				var tShape:IShape = VectorGraphManager.getInstance().shapeDic[this.mId];
				if (tShape) {
					if (mHaveKey && !tShape.needUpdate(_curMat))
						return;
				}
				cx = 0;
				cy = 0;
			}
			*/
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
			var sx:Number = getMatScaleX();
			var sy:Number = getMatScaleY();
			var sr:Number = r * (sx > sy?sx:sy);
			var cl:Number = 2 * Math.PI * sr;
			ndivs = (Math.max(cl / 10,10))|0;
			
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
				if ( x != _path._lastOriX || y != _path._lastOriY) {
					//var _tx1:Number = x, _ty1:Number = y;
					//x = _curMat.a * _tx1 + _curMat.c * _ty1 + _curMat.tx;
					//y = _curMat.b * _tx1 + _curMat.d * _ty1 + _curMat.ty;
					tPath.addPoint(x, y);
				}
			}
			dx = Math.cos(endAngle);
			dy = Math.sin(endAngle);
			x = cx + dx * r;
			y = cy + dy * r;
			if (x != _path._lastOriX|| y != _path._lastOriY) {
				//var _x2:Number = x, _y2:Number = y;
				//x = _curMat.a * _x2 + _curMat.c * _y2 + _curMat.tx;
				//y = _curMat.b * _x2 + _curMat.d * _y2 + _curMat.ty;
				tPath.addPoint(x, y);
			}
		}
		
		override public function quadraticCurveTo(cpx:Number, cpy:Number, x:Number, y:Number):void {
			var tBezier:Bezier = Bezier.I;
			var tResultArray:Array = [];
			//var _x1:Number = x, _y1:Number = y;
			//x = _curMat.a * _x1 + _curMat.c * _y1 ;// + _curMat.tx;
			//y = _curMat.b * _x1 + _curMat.d * _y1;// + _curMat.ty;
			//_x1 = cpx, _y1 = cpy;
			//cpx = _curMat.a * _x1 + _curMat.c * _y1;// + _curMat.tx;
			//cpy = _curMat.b * _x1 + _curMat.d * _y1;// + _curMat.ty;
			var tArray:Array = tBezier.getBezierPoints([_path._lastOriX, _path._lastOriY, cpx, cpy, x, y], 30, 2);
			for (var i:int = 0, n:int = tArray.length / 2; i < n; i++) {
				lineTo(tArray[i * 2], tArray[i * 2 + 1]);
			}
			lineTo(x, y);
		}
		
		//TODO:coverage
		override public function rect(x:Number, y:Number, width:Number, height:Number):void {
			_other = _other.make();
			_other.path || (_other.path = new Path());
			_other.path.rect(x, y, width, height);
		}
		
		/**
		 * 把颜色跟当前设置的alpha混合
		 * @return
		 */
		public function mixRGBandAlpha(color:uint):uint {
			return _mixRGBandAlpha(color, _shader2D.ALPHA);
		}
		public function _mixRGBandAlpha(color:uint, alpha:Number):uint {
			if (alpha >= 1) {
				return color;
			}
			var a:int = ((color & 0xff000000) >>> 24);
			//TODO 这里容易出问题，例如颜色的alpha部分虽然为0，但是他的意义就是0，不能假设是没有设置alpha。例如级联多个alpha就会生成这种结果
			if (a != 0) {
				a*= alpha;
			}else {
				a=alpha*255;
			}
			return (color & 0x00ffffff) | (a << 24);	
		}		
		
		public function strokeRect(x:Number, y:Number, width:Number, height:Number, parameterLineWidth:Number):void {
			var tW:Number = parameterLineWidth * 0.5;
			//line(x - tW, y, x + width + tW, y, parameterLineWidth, _curMat);
			//line(x + width, y, x + width, y + height, parameterLineWidth, _curMat);
			//line(x, y, x, y + height, parameterLineWidth, _curMat);
			//line(x - tW, y + height, x + width + tW, y + height, parameterLineWidth, _curMat);
			/**
			 * p1-------------------------------p2
			 * |  x,y                      x+w,y|
			 * |     p4--------------------p3   |
			 * |     |                     |    |
			 * |     p6--------------------p7   |
			 * |  x,y+h                  x+w,y+h|
			 * p5-------------------------------p8
			 * 
			 * 不用了
			 * 这个其实用4个fillrect拼起来更好，能与fillrect合并。虽然多了几个点。
			 */
			//TODO 这里能不能与下面的stroke合并一下
			if (lineWidth > 0) {
				var rgba:uint = mixRGBandAlpha(strokeStyle._color.numColor);
				var hw:int = lineWidth / 2;
				_fillRect(x - hw, y - hw, width + lineWidth, lineWidth, rgba);				//上
				_fillRect(x - hw, y - hw + height, width + lineWidth, lineWidth, rgba);		//下
				_fillRect(x - hw, y + hw, lineWidth, height - lineWidth, rgba);					//左
				_fillRect(x - hw + width, y + hw, lineWidth, height - lineWidth, rgba);			//右
			}			
		}
		
		override public function clip():void {
		}
		
		/*******************************************end矢量绘制***************************************************/
		//TODO:coverage
		override public function drawParticle(x:Number, y:Number, pt:*):void {
			pt.x = x;
			pt.y = y;
			_submits[_submits._length++] = pt;
		}
		
		private function _getPath():Path {
			return _path || (_path = new Path());
		}
		
		/**获取canvas*/
		//注意这个是对外接口
		public override function get canvas():HTMLCanvas {
			return _canvas;
		}
		//=============新增==================	
		/* 下面的方式是有bug的。canvas是直接save，restore，现在是为了优化，但是有bug，所以先不重载了
		override public function saveTransform(matrix:Matrix):void {
			this._curMat.copyTo(matrix);
		}
		
		override public function restoreTransform(matrix:Matrix):void {
			matrix.copyTo(this._curMat);
		}
		
		override public function transformByMatrix(matrix:Matrix,tx:Number,ty:Number):void {
			var mat:Matrix = _curMat;
			matrix.setTranslate(tx, ty);
			Matrix.mul(matrix, mat, mat);
			matrix.setTranslate(0, 0);
			mat._bTransform = true;
		}
		*/
		
		/* 下面的是错误的。位置没有被缩放
		override public function transformByMatrix(matrix:Matrix, tx:Number, ty:Number):void {
			SaveTransform.save(this);			
			Matrix.mul(matrix, _curMat, _curMat);	
			_curMat.tx += tx;
			_curMat.ty += ty;
			_curMat._checkTransform();
		}
				
		public function transformByMatrixNoSave(matrix:Matrix, tx:Number, ty:Number):void {
			Matrix.mul(matrix, _curMat, _curMat);	
			_curMat.tx += tx;
			_curMat.ty += ty;
			_curMat._checkTransform();
		}
		*/
		
		private static var tmpuv1:Array = [0, 0, 0, 0, 0, 0, 0, 0];
		/**
		 * 专用函数。通过循环创建来水平填充
		 * @param	tex
		 * @param	bmpid
		 * @param	uv		希望循环的部分的uv
		 * @param	oriw
		 * @param	orih
		 * @param	x
		 * @param	y
		 * @param	w
		 */
		private function _fillTexture_h(tex:Texture, imgid:int, uv:Array,oriw:Number, orih:Number, x:Number, y:Number, w:Number):void {
			var stx:Number = x;
			var num:int = Math.floor( w / oriw);
			var left:Number = w % oriw;
			for (var i:int = 0; i < num; i++) {
				_inner_drawTexture(tex, imgid, stx, y, oriw, orih, _curMat, uv, 1, false);
				stx += oriw;
			}
			// 最后剩下的
			if (left > 0) {
				var du:Number = uv[2] - uv[0];
				var uvr:Number = uv[0] + du * (left / oriw);
				var tuv:Array = tmpuv1;
				tuv[0] = uv[0]; tuv[1] = uv[1]; tuv[2] = uvr; tuv[3] = uv[3];
				tuv[4] = uvr; tuv[5] = uv[5]; tuv[6] = uv[6]; tuv[7] = uv[7];
				_inner_drawTexture(tex, imgid, stx, y, left, orih, _curMat, tuv, 1, false);
			}
		}
		
		/**
		 * 专用函数。通过循环创建来垂直填充
		 * @param	tex
		 * @param	imgid
		 * @param	uv
		 * @param	oriw
		 * @param	orih
		 * @param	x
		 * @param	y
		 * @param	h
		 */
		private function _fillTexture_v(tex:Texture, imgid:int, uv:Array,oriw:Number, orih:Number, x:Number, y:Number, h:Number):void {
			var sty:Number = y;
			var num:int = Math.floor( h / orih);
			var left:Number = h % orih;
			for (var i:int = 0; i < num; i++) {
				_inner_drawTexture(tex, imgid, x, sty, oriw, orih, _curMat, uv, 1, false);
				sty += orih;
			}
			// 最后剩下的
			if (left > 0) {
				var dv:Number = uv[7] - uv[1];
				var uvb:Number = uv[1] + dv * (left / orih);
				var tuv:Array = tmpuv1;
				tuv[0] = uv[0]; tuv[1] = uv[1]; tuv[2] = uv[2]; tuv[3] = uv[3];
				tuv[4] = uv[4]; tuv[5] = uvb; tuv[6] = uv[6]; tuv[7] = uvb;
				_inner_drawTexture(tex, imgid, x, sty, oriw, left, _curMat, tuv, 1, false);
			}
		}		
		
		private static var tmpUV:Array = [0, 0, 0, 0, 0, 0, 0, 0];
		private static var tmpUVRect:Array = [0, 0, 0, 0];
		override public function drawTextureWithSizeGrid(tex:Texture, tx:Number, ty:Number, width:Number, height:Number, sizeGrid:Array, gx:Number, gy:Number):void {
			if (!tex._getSource())
				return;
			tx += gx;
			ty += gy;
			
			var uv:Array = tex.uv, w:Number = tex.bitmap._width, h:Number = tex.bitmap._height;
			
			var top:Number = sizeGrid[0];
			var left:Number = sizeGrid[3];
			var d_top:Number = top / h;
			var d_left:Number = left / w;
			var right:Number = sizeGrid[1];
			var bottom:Number = sizeGrid[2];
			var d_right:Number = right / w;
			var d_bottom:Number = bottom / h;
			var repeat:Boolean = sizeGrid[4];
			var needClip:Boolean = false;
			
			if (width == w) {
				left = right = 0;
			}
			if (height == h) {
				top = bottom = 0;
			}
			
			//处理进度条不好看的问题
			if (left + right > width) {
				var clipWidth:Number = width;
				needClip = true;
				width = left + right;
				save();
				clipRect(0+tx, 0+ty, clipWidth, height);
			}
			
			var imgid:int = tex.bitmap.id;
			var mat:Matrix = _curMat;
			var tuv:Array = _tempUV;
			// 整图的uv
			// 一定是方的，所以uv只要左上右下就行
			var uvl:Number = uv[0];
			var uvt:Number = uv[1];
			var uvr:Number = uv[4];
			var uvb:Number = uv[5];
			
			// 小图的uv
			var uvl_:Number = uvl;
			var uvt_:Number = uvt;
			var uvr_:Number = uvr;
			var uvb_:Number = uvb;
			
			//绘制四个角
			// 构造uv
			if(left && top){
				uvr_ = uvl + d_left;
				uvb_ = uvt + d_top;
				tuv[0] = uvl, tuv[1] = uvt, 	tuv[2] = uvr_, tuv[3] = uvt, 
				tuv[4] = uvr_, tuv[5] = uvb_, 		tuv[6] = uvl, tuv[7] = uvb_;
				_inner_drawTexture(tex, imgid, tx, ty, left, top, mat, tuv, 1, false);
			}
			if ( right && top) {
				uvl_ = uvr - d_right; uvt_ = uvt;
				uvr_ = uvr; uvb_ = uvt + d_top;
				tuv[0] = uvl_, tuv[1] = uvt_, 	tuv[2] = uvr_, tuv[3] = uvt_, 
				tuv[4] = uvr_, tuv[5] = uvb_, 	tuv[6] = uvl_, tuv[7] = uvb_;
				_inner_drawTexture(tex, imgid, width - right + tx, 0 + ty, right, top, mat, tuv, 1, false);
			}
			if (left && bottom) {
				uvl_ = uvl; uvt_ = uvb-d_bottom;
				uvr_ = uvl+d_left; uvb_ = uvb;
				tuv[0] = uvl_, tuv[1] = uvt_, 	tuv[2] = uvr_, tuv[3] = uvt_, 
				tuv[4] = uvr_, tuv[5] = uvb_, 	tuv[6] = uvl_, tuv[7] = uvb_;
				_inner_drawTexture(tex, imgid, 0+tx, height - bottom+ty, left, bottom, mat, tuv, 1, false);
			}
			if (right && bottom) {
				uvl_ = uvr-d_right; uvt_ = uvb-d_bottom;
				uvr_ = uvr; uvb_ = uvb;
				tuv[0] = uvl_, tuv[1] = uvt_, 	tuv[2] = uvr_, tuv[3] = uvt_, 
				tuv[4] = uvr_, tuv[5] = uvb_, 	tuv[6] = uvl_, tuv[7] = uvb_;
				_inner_drawTexture(tex, imgid,width - right+tx, height - bottom+ty, right, bottom, mat, tuv, 1, false);
			}
			//绘制上下两个边
			if (top) {
				uvl_ = uvl+d_left; uvt_ = uvt;
				uvr_ = uvr-d_right; uvb_ = uvt+d_top;
				tuv[0] = uvl_, tuv[1] = uvt_, 	tuv[2] = uvr_, tuv[3] = uvt_, 
				tuv[4] = uvr_, tuv[5] = uvb_, 	tuv[6] = uvl_, tuv[7] = uvb_;
				if (repeat) {
					_fillTexture_h(tex, imgid, tuv, tex.width - left - right, top, left + tx, ty, width - left - right);
				}else {
					_inner_drawTexture(tex, imgid,left + tx, ty, width - left - right, top, mat, tuv, 1, false);	
				}
				
			}
			if (bottom ) {
				uvl_ = uvl+d_left; uvt_ = uvb-d_bottom;
				uvr_ = uvr - d_right; uvb_ = uvb;
				tuv[0] = uvl_, tuv[1] = uvt_, 	tuv[2] = uvr_, tuv[3] = uvt_, 
				tuv[4] = uvr_, tuv[5] = uvb_, 	tuv[6] = uvl_, tuv[7] = uvb_;
				if (repeat) {
					_fillTexture_h(tex, imgid, tuv, tex.width - left - right, bottom, left + tx, height - bottom + ty, width - left - right);
				}else{
					_inner_drawTexture(tex, imgid, left + tx, height - bottom + ty, width - left - right, bottom, mat, tuv, 1, false);
				}
			}
			//绘制左右两边
			if (left) {
				uvl_ = uvl; uvt_ = uvt+d_top;
				uvr_ = uvl+d_left; uvb_ = uvb-d_bottom;
				tuv[0] = uvl_, tuv[1] = uvt_, 	tuv[2] = uvr_, tuv[3] = uvt_, 
				tuv[4] = uvr_, tuv[5] = uvb_, 	tuv[6] = uvl_, tuv[7] = uvb_;
				if (repeat) {
					_fillTexture_v(tex, imgid, tuv, left, tex.height - top - bottom, tx, top + ty, height - top - bottom);
				}else{	
					_inner_drawTexture(tex, imgid, tx, top + ty, left, height - top - bottom, mat, tuv, 1, false);
				}
			}
			if (right) {
				uvl_ = uvr-d_right; uvt_ = uvt+d_top;
				uvr_ = uvr; uvb_ = uvb-d_bottom;
				tuv[0] = uvl_, tuv[1] = uvt_, 	tuv[2] = uvr_, tuv[3] = uvt_, 
				tuv[4] = uvr_, tuv[5] = uvb_, 	tuv[6] = uvl_, tuv[7] = uvb_;
				if (repeat) {
					_fillTexture_v(tex, imgid, tuv, right, tex.height - top - bottom, width - right + tx, top + ty, height - top - bottom);
				}else{
					_inner_drawTexture(tex, imgid, width - right + tx, top + ty, right, height - top - bottom, mat, tuv, 1, false);
				}
			}
			//绘制中间
			uvl_ = uvl+d_left; uvt_ = uvt+d_top;
			uvr_ = uvr-d_right; uvb_ = uvb-d_bottom;
			tuv[0] = uvl_, tuv[1] = uvt_, 	tuv[2] = uvr_, tuv[3] = uvt_, 
			tuv[4] = uvr_, tuv[5] = uvb_, 	tuv[6] = uvl_, tuv[7] = uvb_;
			if (repeat) {
				var tuvr:Array = tmpUVRect;
				tuvr[0] = uvl_; tuvr[1] = uvt_;
				tuvr[2] = uvr_ -uvl_; tuvr[3] = uvb_ -uvt_;
				// 这个如果用重复的可能比较多，所以采用filltexture的方法，注意这样会打断合并
				_fillTexture(tex, tex.width - left - right, tex.height - top - bottom, tuvr, left + tx, top + ty, width - left - right, height - top - bottom, 'repeat', 0, 0);
			}else{
				_inner_drawTexture(tex, imgid, left + tx, top + ty, width - left - right, height - top - bottom, mat, tuv, 1, false);
			}
			
			if (needClip) restore();			
		}
	}
}

class ContextParams {
	public static var DEFAULT:ContextParams;
	
	public var lineWidth:int = 1;
	public var path:*;
	public var textAlign:String;
	public var textBaseline:String;
	
	public function clear():void {
		lineWidth = 1;
		path && path.clear();
		textAlign = textBaseline = null;
	}
	
	public function make():ContextParams {
		return this === DEFAULT ? new ContextParams() : this;
	}
}