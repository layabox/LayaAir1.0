package laya.layagl {
	import laya.display.Graphics;
	import laya.display.Node;
	import laya.display.Sprite;
	import laya.display.SpriteConst;
	import laya.layagl.cmdNative.DrawCanvasCmdNative;
	import laya.layagl.cmdNative.DrawParticleCmdNative;
	import laya.layagl.cmdNative.DrawTextureCmdNative;
	import laya.display.css.CacheStyle;
	import laya.display.css.SpriteStyle;
	import laya.events.Event;
	//import laya.filters.BlurFilter;
	import laya.filters.ColorFilter;
	//import laya.filters.GlowFilter;
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.layagl.cmdNative.DrawCanvasCmdNative;
	import laya.maths.Matrix;
	import laya.maths.Point;
	import laya.maths.Rectangle;
	import laya.renders.RenderSprite;
	import laya.resource.Context;
	import laya.resource.HTMLCanvas;
	import laya.resource.Texture;
	import laya.utils.ColorUtils;
	import laya.webgl.WebGLContext;
	import laya.webgl.canvas.BlendMode;
	import laya.webgl.resource.RenderTexture2D;
	import laya.webgl.resource.WebGLRTMgr;
	import laya.webgl.shapes.BasePoly;
	
	/**
	 * ...
	 * @author ww
	 */
	public class ConchSpriteAdpt extends Node {
		
		public var _drawSimpleImageData:*;
		public var _drawCanvasParamData:*;
		public var _drawSimpleRectParamData:*;
		public var _drawRectBorderParamData:*;
		public var _canvasBeginCmd:*;
		public var _canvasEndCmd:*;
		public var _customRenderCmd:* = null;
		public var _customCmds:Array = null;
		public var _callbackFuncObj:*;
		public var _filterBeginCmd:*;
		public var _filterEndCmd:*;
		public var _maskCmd:*;
		
		public var _dataf32:Float32Array;
		public var _datai32:Int32Array;
		/**@private */
		public var _x:Number = 0;
		/**@private */
		public var _y:Number = 0;
		/**@private */
		public var _renderType:Number = 0;
		
		//TODO:coverage
		public static function createMatrix(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0, nums:Float32Array = null):MatrixConch
		{
			return new MatrixConch(a, b, c, d, tx, ty, nums);
		}
		
		public function createData():void {
			var nSize:int = SpriteConst.POSSIZE * 4;
			_conchData = __JS__("new ParamData(nSize, false)");
			_datai32 = _conchData._int32Data;
			_dataf32 = _conchData._float32Data;
			_dataf32[SpriteConst.POSREPAINT] = 1;
			_datai32[SpriteConst.POSFRAMECOUNT] = -1;
			_datai32[SpriteConst.POSBUFFERBEGIN] = 0;
			_datai32[SpriteConst.POSBUFFEREND] = 0;
			_datai32[SpriteConst.POSCOLOR] = 0xFFFFFFFF;
			_datai32[SpriteConst.POSVISIBLE_NATIVE] = 1;
			_dataf32[SpriteConst.POSPIVOTX] = 0;
			_dataf32[SpriteConst.POSPIVOTY] = 0;
			_dataf32[SpriteConst.POSSCALEX] = 1;
			_dataf32[SpriteConst.POSSCALEY] = 1;
			_dataf32[SpriteConst.POSMATRIX] = 1;
			_dataf32[SpriteConst.POSMATRIX + 1] = 0;
			_dataf32[SpriteConst.POSMATRIX + 2] = 0;
			_dataf32[SpriteConst.POSMATRIX + 3] = 1;
			_dataf32[SpriteConst.POSMATRIX + 4] = 0;
			_dataf32[SpriteConst.POSMATRIX + 5] = 0;
			_datai32[SpriteConst.POSSIM_TEXTURE_ID] = -1;
			_datai32[SpriteConst.POSSIM_TEXTURE_DATA] = -1;
			_datai32[SpriteConst.POSCUSTOM] = -1;
			_datai32[SpriteConst.POSCLIP] = 0;
			_datai32[SpriteConst.POSCLIP + 1] = 0;
			_datai32[SpriteConst.POSCLIP + 2] = 1000000;
			_datai32[SpriteConst.POSCLIP + 3] = 1000000;
			_datai32[SpriteConst.POSCACHE_CANVAS_SKIP_PAINT_FLAG] = 0;
			_datai32[SpriteConst.POSBLEND_SRC] = WebGLContext.ONE;
			_datai32[SpriteConst.POSBLEND_DEST] = WebGLContext.ONE_MINUS_SRC_ALPHA;
			_datai32[SpriteConst.POSGRAPHICS_CALLBACK_FUN_ID] = -1;
			
			//默认增加 transform的type
			_renderType |= SpriteConst.TRANSFORM;
			_setRenderType(_renderType);
		}
		//TODO:coverage
		public static function init():void {
			ConchCmdReplace.__init__();
			ConchGraphicsAdpt.__init__();
			var spP:* = Sprite["prototype"];
			var mP:*= ConchSpriteAdpt["prototype"];
			var funs:Array = [
			"_createTransform",
			"_setTransform",
			"_setGraphics",
			"_setGraphicsCallBack",
			"_setCacheAs",
			"_setX",
			"_setY",
			"_setPivotX",
			"_getPivotX",
			"_setPivotY",
			"_getPivotY",
			"_setAlpha",
			"_getAlpha",
			"_setScaleX",
			"_setScaleY",
			"_setSkewX",
			"_setSkewY",
			"_setRotation",
			"_adjustTransform",
			"_setRenderType",
			"_setTexture",
			"_setTextureEx",
			"_setCustomRender",
			"_setScrollRect",
			"_setColorFilter",
			"customRenderFromNative",
			"canvasBeginRenderFromNative",
			"canvasEndRenderFromNative",
			"setChildrenNativeVisible",
			"filterBeginRenderFromNative",
			"filterEndRenderFromNative",
			"updateParticleFromNative",
			"_setMask",
			"maskRenderFromNative",
			"_setBlendMode",
			"_setBgStyleColor",
			"_setBorderStyleColor",
			"_setWidth",
			"_setHeight",
			"_setTranformChange",
			];
			var i:int, len:int;
			len = funs.length;
			var tFunName:String;
			for (i = 0; i < len; i++)
			{
				tFunName = funs[i];
				spP[tFunName] = mP[tFunName];
			}
			spP["createGLBuffer"] = mP["createData"];
			Matrix._createFun = createMatrix;
			
			var sprite:*= Sprite;
			spP.render = spP.renderToNative = ConchSprite.prototype.renderToNative;
			spP.repaint = spP.repaintForNative = ConchSprite.prototype.repaintForNative;
			spP.parentRepaint = spP.parentRepaintForNative = ConchSprite.prototype.parentRepaintForNative;
			spP._renderChilds = ConchSprite.prototype._renderChilds;
			spP.writeBlockToNative = ConchSprite.prototype.writeBlockToNative;
			spP._writeBlockChilds = ConchSprite.prototype._writeBlockChilds;
		}
		
		//TODO:coverage
		public function _createTransform():*
		{
			//TODO 临时这样写的，等webgl统一以后tx,ty后，再做处理
			return MatrixConch.create( new Float32Array(6) );
			//return MatrixConch.create( new Float32Array(_dataf32.buffer, SpriteConst.POSMATRIX*4, 6) );
		}
		
		//TODO:coverage
		public function _setTransform(value:Matrix):void
		{
			var f32:Float32Array = this._conchData._float32Data;
			f32[SpriteConst.POSTRANSFORM_FLAG] = 0;
			f32[SpriteConst.POSMATRIX] = value.a;
			f32[SpriteConst.POSMATRIX + 1] = value.b;
			f32[SpriteConst.POSMATRIX + 2] = value.c;
			f32[SpriteConst.POSMATRIX + 3] = value.d;
			f32[SpriteConst.POSMATRIX + 4] = value.tx;
			f32[SpriteConst.POSMATRIX + 5] = value.ty;
		}
		
		/**@private */
		public function _setTranformChange():void
		{
			(this as Object)._tfChanged = true;
			(this as Object).parentRepaint(SpriteConst.REPAINT_CACHE);
		}
		//TODO:coverage
		public function _setGraphics(value:Graphics):void
		{
			_datai32[SpriteConst.POSGRAPICS] = (value as Object)._commandEncoder.getPtrID();
		}
		
		public function _setGraphicsCallBack():void {
			if (!_callbackFuncObj)
			{
				_callbackFuncObj = __JS__("new CallbackFuncObj()");
			}
			_datai32[SpriteConst.POSCALLBACK_OBJ_ID] = this._callbackFuncObj.id;
			_callbackFuncObj.addCallbackFunc(5, (updateParticleFromNative as Object).bind(this));
			_datai32[SpriteConst.POSGRAPHICS_CALLBACK_FUN_ID] = 5;
		}
		
		//TODO:coverage
		public function _setCacheAs(value:String):void {
			DrawCanvasCmdNative.createCommandEncoder();
			if ( !_drawCanvasParamData )
			{
				_drawCanvasParamData = __JS__("new ParamData(33 * 4, true)");
			}
			if (!_callbackFuncObj)
			{
				_callbackFuncObj = __JS__("new CallbackFuncObj()");
			}
			if (!_canvasBeginCmd)
			{
				this._canvasBeginCmd = LayaGL.instance.createCommandEncoder(128, 64, false);
			}
			if (!_canvasEndCmd)
			{
				this._canvasEndCmd = LayaGL.instance.createCommandEncoder(128, 64, false);
			}
			_datai32[SpriteConst.POSCALLBACK_OBJ_ID] = this._callbackFuncObj.id;
			_callbackFuncObj.addCallbackFunc(1, (canvasBeginRenderFromNative as Object).bind(this));
			_callbackFuncObj.addCallbackFunc(2, (canvasEndRenderFromNative as Object).bind(this));
			_datai32[SpriteConst.POSCANVAS_CALLBACK_FUN_ID] = 1;
			_datai32[SpriteConst.POSCANVAS_CALLBACK_END_FUN_ID] = 2;
			_datai32[SpriteConst.POSCANVAS_BEGIN_CMD_ID] = this._canvasBeginCmd.getPtrID();
			_datai32[SpriteConst.POSCANVAS_END_CMD_ID] = this._canvasEndCmd.getPtrID();
			_datai32[SpriteConst.POSCANVAS_DRAW_TARGET_CMD_ID] = DrawCanvasCmdNative._DRAW_CANVAS_CMD_ENCODER_.getPtrID();
			_datai32[SpriteConst.POSCANVAS_DRAW_TARGET_PARAM_ID] = _drawCanvasParamData.getPtrID();
		}
		
		//TODO:coverage
		public function _setX(value:Number):void {
			this._x = _dataf32[SpriteConst.POSX] = value;
			_dataf32[SpriteConst.POSTRANSFORM_FLAG] = 1.0;
		}
		
		//TODO:coverage
		public function _setY(value:Number):void {
			this._y = _dataf32[SpriteConst.POSY] = value;
			_dataf32[SpriteConst.POSTRANSFORM_FLAG] = 1.0;
		}
		
		//TODO:coverage
		public function _setWidth(texture:Texture, width:Number):void {
			if ( texture && texture.getIsReady()){
				_setTextureEx(texture,true);
			}
		}
		
		//TODO:coverage
		public function _setHeight(texture:Texture, height:Number):void {
			if ( texture && texture.getIsReady()){
				_setTextureEx(texture,true);
			}
		}
		
		//TODO:coverage
		public function _setPivotX(value:Number):void {
			_renderType |= SpriteConst.TRANSFORM;
			_dataf32[SpriteConst.POSPIVOTX] = value;
			_dataf32[SpriteConst.POSTRANSFORM_FLAG] = 1.0;
		}
		
		//TODO:coverage
		public function _getPivotX():Number {
			return _dataf32[SpriteConst.POSPIVOTX];
		}
		
		//TODO:coverage
		public function _setPivotY(value:Number):void {
			_renderType |= SpriteConst.TRANSFORM;
			_dataf32[SpriteConst.POSPIVOTY] = value;
			_dataf32[SpriteConst.POSTRANSFORM_FLAG] = 1.0;
		}
		
		//TODO:coverage
		public function _getPivotY():Number {
			return _dataf32[SpriteConst.POSPIVOTY];
		}
		
		//TODO:coverage
		public function _setAlpha(value:Number):void {
			var style:SpriteStyle = __JS__('this.getStyle()');
			style.alpha = value;
			value = value > 1 ? 1 : value;
			value = value < 0 ? 0 : value;
			var nColor:int = _datai32[SpriteConst.POSCOLOR];
			var nAlpha:int = nColor >> 24;
			nAlpha = value * 255;
			nColor = (nColor & 0xffffff) | nAlpha<<24;
			_datai32[SpriteConst.POSCOLOR] = nColor;
			if (value !== 1)
				_renderType |= SpriteConst.ALPHA;
			else
				_renderType &= ~SpriteConst.ALPHA;
			_setRenderType(_renderType);
			parentRepaint();
		}
		
		//TODO:coverage
		public function _setRenderType(type:Number):void
		{
			_datai32[SpriteConst.POSRENDERTYPE] = type;
			if (!LayaGLTemplate.GLS[type])
			{
				LayaGLTemplate.createByRenderType(type);
				LayaGLTemplate.createByRenderTypeEnd(type);
			}
		}
		private function parentRepaint():void {
			
		}
		
		public function _getAlpha():Number {
			return (_datai32[SpriteConst.POSCOLOR]>>>24)/255;
		}
		
		public function _setScaleX(value:Number):void {
			(this as Sprite)._style.scaleX=_dataf32[SpriteConst.POSSCALEX] = value;
			_dataf32[SpriteConst.POSTRANSFORM_FLAG] = 1.0;
		}

		public function _setScaleY(value:Number):void {
			(this as Sprite)._style.scaleY=_dataf32[SpriteConst.POSSCALEY] = value;
			_dataf32[SpriteConst.POSTRANSFORM_FLAG] = 1.0;
		}

		public function _setSkewX(value:Number):void {
			(this as Sprite)._style.skewX=_dataf32[SpriteConst.POSSKEWX] = value;
			_dataf32[SpriteConst.POSTRANSFORM_FLAG] = 1.0;
		}

		public function _setSkewY(value:Number):void {
			(this as Sprite)._style.skewY=_dataf32[SpriteConst.POSSKEWY] = value;
			_dataf32[SpriteConst.POSTRANSFORM_FLAG] = 1.0;
		}

		public function _setRotation(value:Number):void {
			(this as Sprite)._style.rotation=_dataf32[SpriteConst.POSROTATION] = value;
			_dataf32[SpriteConst.POSTRANSFORM_FLAG] = 1.0;
		}
		public function _setBgStyleColor(x:Number, y:Number, width:Number, height:Number, fillColor:*):void {
			var _fb:Float32Array = null;
			var _i32b:Int32Array = null;
			if (!_drawSimpleRectParamData) {
				_drawSimpleRectParamData = __JS__("new ParamData(26 * 4, true)");					
			}
			_fb = _drawSimpleRectParamData._float32Data;
			_i32b = _drawSimpleRectParamData._int32Data;
			
			var c1:ColorUtils = ColorUtils.create(fillColor);
			var nFillColor:uint = c1.numColor;
			_i32b[0] = 1;
			_i32b[1] = 24 * 4;
			var ix:int = 2;
			_fb[ix++] = x; 			_fb[ix++] = y;    		_fb[ix++] = 0; _fb[ix++] = 0;		_i32b[ix++] = nFillColor; _fb[ix++] = 0xffffffff;
			_fb[ix++] = x + width; 	_fb[ix++] = y; 		 	_fb[ix++] = 0; _fb[ix++] = 0;		_i32b[ix++] = nFillColor; _fb[ix++] = 0xffffffff;
			_fb[ix++] = x + width; 	_fb[ix++] = y + height; _fb[ix++] = 0; _fb[ix++] = 0;		_i32b[ix++] = nFillColor; _fb[ix++] = 0xffffffff;
			_fb[ix++] = x;			_fb[ix++] = y + height;	_fb[ix++] = 0; _fb[ix++] = 0;		_i32b[ix++] = nFillColor; _fb[ix++] = 0xffffffff;
			
			_datai32[SpriteConst.POSSIM_RECT_FILL_DATA] = _drawSimpleRectParamData.getPtrID();
			LayaGL.syncBufferToRenderThread( _drawSimpleRectParamData );
			_datai32[SpriteConst.POSSIM_RECT_FILL_CMD] = LayaNative2D._SIMPLE_RECT_CMDENCODER_.getPtrID();
		}
		public function _setBorderStyleColor(x:Number, y:Number, width:Number, height:Number, fillColor:*, borderWidth:Number):void {
			var _fb:Float32Array = null;
			var _i32b:Int32Array = null;
			if (!_drawRectBorderParamData) {
				_drawRectBorderParamData = __JS__("new ParamData(59 * 4, true)");					
			}
			_fb = _drawRectBorderParamData._float32Data;
			_i32b = _drawRectBorderParamData._int32Data;

			// Calculate vertices for border
			var _linePoints:Array = new Array();
			var _line_ibArray:Array = new Array();
			var _line_vbArray:Array = new Array();
			_linePoints.push(x);			_linePoints.push(y);
			_linePoints.push(x + width);	_linePoints.push(y);
			_linePoints.push(x + width);	_linePoints.push(y + height);
			_linePoints.push(x);			_linePoints.push(y + height);
			_linePoints.push(x);			_linePoints.push(y - borderWidth / 2)
			BasePoly.createLine2(_linePoints, _line_ibArray, borderWidth, 0, _line_vbArray, false);	
			var _line_vertNum:int = _linePoints.length;
			
			_fb = _drawRectBorderParamData._float32Data;
			_i32b = _drawRectBorderParamData._int32Data;
			var _i16b:Int16Array = _drawRectBorderParamData._int16Data;
			var c1:ColorUtils = ColorUtils.create(fillColor);
			var nLineColor:uint = c1.numColor;
			_i32b[0] = 0;
			_i32b[1] = 30 * 4;
			_i32b[2] = 0;
			_i32b[3] = _line_ibArray.length * 2;
			_i32b[4] = 0;
			// Set vb
			var ix:int = 5;
			for (var i:int = 0; i < _line_vertNum; i++)
			{
				_fb[ix++] = _line_vbArray[i * 2]; 	_fb[ix++] = _line_vbArray[i * 2 + 1]; 	_i32b[ix++] = nLineColor;
			}
			// Set ib
			ix = 35 * 2;
			for (var ii:int = 0; ii < _line_ibArray.length; ii++) 
			{
				_i16b[ix++] = _line_ibArray[ii];
			}
			
			_datai32[SpriteConst.POSSIM_RECT_STROKE_DATA] = _drawRectBorderParamData.getPtrID();
			LayaGL.syncBufferToRenderThread( _drawRectBorderParamData );
			_datai32[SpriteConst.POSSIM_RECT_STROKE_CMD] = LayaNative2D._RECT_BORDER_CMD_ENCODER_.getPtrID();
		}
		private function _setTextureEx(value:Texture,isloaded: Boolean):void{
			var _fb:Float32Array = null;
			var _i32b:Int32Array = null;
			if (!_drawSimpleImageData)
			{
				_drawSimpleImageData = __JS__("new ParamData(29 * 4, true)");
				_fb = _drawSimpleImageData._float32Data;
				_i32b = _drawSimpleImageData._int32Data;
				_i32b[0] = 3;
				_i32b[1] = WebGLContext.TEXTURE0;
				_i32b[2] = isloaded?value.bitmap._glTexture.id:0;
				_i32b[3] = 1;
				_i32b[4] = 24 * 4;
				var uv:Array = value.uv;
				_fb[5] = 0; 	_fb[6] = 0; 	_fb[7] = uv[0]; 	_fb[8] = uv[1]; 	_i32b[9] = 0xffffffff; 	_i32b[10] = 0xffffffff;
				_fb[11] = 0; 	_fb[12] = 0; 	_fb[13] = uv[2]; 	_fb[14] = uv[3]; 	_i32b[15] = 0xffffffff; _i32b[16] = 0xffffffff;
				_fb[17] = 0; 	_fb[18] = 0;	_fb[19] = uv[4];  	_fb[20] = uv[5]; 	_i32b[21] = 0xffffffff; _i32b[22] = 0xffffffff;
				_fb[23] = 0;	_fb[24] = 0;  	_fb[25] = uv[6];	_fb[26] = uv[7]; 	_i32b[27] = 0xffffffff; _i32b[28] = 0xffffffff;
			}
			_fb = _drawSimpleImageData._float32Data;
			_i32b = _drawSimpleImageData._int32Data;
			_i32b[2] = isloaded?value.bitmap._glTexture.id:0;
			var w:Number = isloaded?value.width:0;
			var h:Number = isloaded?value.height:0;
			var spW:Number = (this as Object)._width;
			var spH:Number = (this as Object)._height;
			w = spW > 0 ? spW : w;
			h = spH > 0 ? spH : h;
			_fb[11] = _fb[17] = w;
			_fb[18] = _fb[24] = h;
			var nPtrID:int = _drawSimpleImageData.getPtrID();
			_datai32[SpriteConst.POSSIM_TEXTURE_DATA] = nPtrID;
			LayaGL.syncBufferToRenderThread( _drawSimpleImageData );
			_datai32[SpriteConst.POSSIM_TEXTURE_ID] = LayaNative2D._SIMPLE_TEXTURE_CMDENCODER_.getPtrID();
			
		}
		
		//TODO:coverage
		public function _setTexture(value:Texture):void {
			if (!value) return;		
			if (value.getIsReady()){
				_setTextureEx(value,true);
			}
			else{
				_setTextureEx(value,false);
				value.on(Event.READY, this, _setTextureEx, [value,true]);
			}
		}
		
		//TODO:coverage
		public function _setCustomRender():void {
			if (!_callbackFuncObj)
			{
				_callbackFuncObj = __JS__("new CallbackFuncObj()");
			}
			this._customCmds = [];
			//这个时候应该是sprite
			_callbackFuncObj.addCallbackFunc(0, (customRenderFromNative as Object).bind(this));
			this._customRenderCmd = LayaGL.instance.createCommandEncoder(128, 64, true);
			_datai32[SpriteConst.POSCALLBACK_OBJ_ID] = this._callbackFuncObj.id;
			_datai32[SpriteConst.POSCUSTOM_CALLBACK_FUN_ID] = 0;
			_datai32[SpriteConst.POSCUSTOM] = this._customRenderCmd.getPtrID();
		}
		//TODO:coverage
		public function _setScrollRect(value:Rectangle):void {
			_dataf32[SpriteConst.POSCLIP] = 0;// value.x;
			_dataf32[SpriteConst.POSCLIP + 1] = 0;// value.y;
			_dataf32[SpriteConst.POSCLIP+2] = value.width;
			_dataf32[SpriteConst.POSCLIP + 3] = value.height;
			
			_dataf32[SpriteConst.POSCLIP_NEG_POS] = -value.x;
			_dataf32[SpriteConst.POSCLIP_NEG_POS + 1] = -value.y;
			
			value["onPropertyChanged"] = (this._setScrollRect as Object).bind(this);
		}
		//TODO:coverage
		public function _setColorFilter(value:*):void
		{
			/*
			var colorFilter:ColorFilter = value;
			_dataf32.set(colorFilter._mat, SpriteConst.POSCOLORFILTER_COLOR);
			_dataf32.set(colorFilter._alpha, SpriteConst.POSCOLORFILTER_ALPHA);
			*/
			if (!_callbackFuncObj)
			{
				_callbackFuncObj = __JS__("new CallbackFuncObj()");
			}
			if (!_filterBeginCmd)
			{
				this._filterBeginCmd = LayaGL.instance.createCommandEncoder(128, 64, false);
			}
			if (!_filterEndCmd)
			{
				this._filterEndCmd = LayaGL.instance.createCommandEncoder(128, 64, true);
			}
			_datai32[SpriteConst.POSCALLBACK_OBJ_ID] = this._callbackFuncObj.id;
			_callbackFuncObj.addCallbackFunc(3, (filterBeginRenderFromNative as Object).bind(this));
			_callbackFuncObj.addCallbackFunc(4, (filterEndRenderFromNative as Object).bind(this));
			_datai32[SpriteConst.POSFILTER_CALLBACK_FUN_ID] = 3;
			_datai32[SpriteConst.POSFILTER_BEGIN_CMD_ID] = this._filterBeginCmd.getPtrID();
			_datai32[SpriteConst.POSFILTER_END_CALLBACK_FUN_ID] = 4;
			_datai32[SpriteConst.POSFILTER_END_CMD_ID] = this._filterEndCmd.getPtrID();
		}		
		public function _setMask(value:Sprite):void
		{
			value.cacheAs = "bitmap";
			if (!_callbackFuncObj)
			{
				_callbackFuncObj = __JS__("new CallbackFuncObj()");
			}
			if (!_maskCmd)
			{
				this._maskCmd = LayaGL.instance.createCommandEncoder(128, 64, false);
			}
			_datai32[SpriteConst.POSCALLBACK_OBJ_ID] = this._callbackFuncObj.id;
			_callbackFuncObj.addCallbackFunc(6, (maskRenderFromNative as Object).bind(this));
			_datai32[SpriteConst.POSMASK_CALLBACK_FUN_ID] = 6;
			_datai32[SpriteConst.POSMASK_CMD_ID] = this._maskCmd.getPtrID();
		}
		//TODO:coverage
		protected function _adjustTransform():Matrix {
			var m:Matrix= (this as Sprite)._transform || ((this as Sprite)._transform=_createTransform());
			m._bTransform = true;
			LayaGL.instance.calcMatrixFromScaleSkewRotation( this._conchData._data["_ptrID"],SpriteConst.POSTRANSFORM_FLAG*4, SpriteConst.POSMATRIX*4, SpriteConst.POSX*4, SpriteConst.POSY*4, SpriteConst.POSPIVOTX*4, 
										SpriteConst.POSPIVOTY*4, SpriteConst.POSSCALEX*4, SpriteConst.POSSCALEY*4, SpriteConst.POSSKEWX*4, SpriteConst.POSSKEWY*4, SpriteConst.POSROTATION*4);
			//临时这样写，
			var f32:Float32Array = this._conchData._float32Data;
			m.a = f32[SpriteConst.POSMATRIX];
			m.b = f32[SpriteConst.POSMATRIX+1];
			m.c = f32[SpriteConst.POSMATRIX+2];
			m.d = f32[SpriteConst.POSMATRIX+3];
			m.tx = 0;
			m.ty = 0;
			return m;
		}
		public function _setBlendMode(value:String):void
		{
			switch(value)
			{
			case BlendMode.NORMAL:
				_datai32[SpriteConst.POSBLEND_SRC] = WebGLContext.ONE;
				_datai32[SpriteConst.POSBLEND_DEST] = WebGLContext.ONE_MINUS_SRC_ALPHA;
				break;
			case BlendMode.ADD:
			case BlendMode.LIGHTER:
				_datai32[SpriteConst.POSBLEND_SRC] = WebGLContext.ONE;
				_datai32[SpriteConst.POSBLEND_DEST] = WebGLContext.DST_ALPHA;
				break;
			case BlendMode.MULTIPLY:
				_datai32[SpriteConst.POSBLEND_SRC] = WebGLContext.DST_COLOR;
				_datai32[SpriteConst.POSBLEND_DEST] = WebGLContext.ONE_MINUS_SRC_ALPHA;
				break;
			case BlendMode.SCREEN:
				_datai32[SpriteConst.POSBLEND_SRC] = WebGLContext.ONE;
				_datai32[SpriteConst.POSBLEND_DEST] = WebGLContext.ONE;
				break;
			case BlendMode.OVERLAY:
				_datai32[SpriteConst.POSBLEND_SRC] = WebGLContext.ONE;
				_datai32[SpriteConst.POSBLEND_DEST] = WebGLContext.ONE_MINUS_SRC_COLOR;
				break;
			case BlendMode.LIGHT:
				_datai32[SpriteConst.POSBLEND_SRC] = WebGLContext.ONE;
				_datai32[SpriteConst.POSBLEND_DEST] = WebGLContext.ONE;
				break;
			case BlendMode.MASK:
				_datai32[SpriteConst.POSBLEND_SRC] = WebGLContext.ZERO;
				_datai32[SpriteConst.POSBLEND_DEST] = WebGLContext.SRC_ALPHA;
				break;
			case BlendMode.DESTINATIONOUT:
				_datai32[SpriteConst.POSBLEND_SRC] = WebGLContext.ZERO;
				_datai32[SpriteConst.POSBLEND_DEST] = WebGLContext.ZERO;
				break;
			default:
				alert("_setBlendMode Unknown type");
				break;
			}
		}
		//TODO:coverage
		public function customRenderFromNative():void
		{
			var context:* = LayaGL.instance.getCurrentContext();
			_customRenderCmd.beginEncoding();
			_customRenderCmd.clearEncoding();
			context["_commandEncoder"] = _customRenderCmd;
			context["_customCmds"] = _customCmds;
			for (var i:int = 0, n:int = _customCmds.length; i < n; i++ )
			{
				_customCmds[i].recover();
			}
			_customCmds.length = 0;
			(this as Sprite).customRender(context, 0, 0);
			_customRenderCmd.endEncoding();
		}
		private var _bRepaintCanvas:Boolean = false;
		private var _lastContext:* = null;
		private static var _tempFloatArrayBuffer2:Float32Array = new Float32Array(2);
		public static var _tempFloatArrayMatrix:Float32Array = new Float32Array(6);
		private static var _tempInt1:Int32Array = new Int32Array(1);
		
		//TODO:coverage
		public function canvasBeginRenderFromNative():void
		{
			var layagl:* = LayaGL.instance;
			var htmlCanvas:* = null;
			var htmlContext:* = null;
			var cacheStyle:CacheStyle = (this as Sprite)._cacheStyle;
			if (cacheStyle.canvas && _datai32[SpriteConst.POSREPAINT] == 0 )
			{
				htmlCanvas = cacheStyle.canvas;
				//修改变量POSVISIBLE_NATIVE
				if (_bRepaintCanvas != false)
				{
					setChildrenNativeVisible(false);
					_bRepaintCanvas = false;
				}
				_datai32[SpriteConst.POSCACHE_CANVAS_SKIP_PAINT_FLAG] = 1;
			}
			else
			{
				_canvasBeginCmd.beginEncoding();
				_canvasBeginCmd.clearEncoding();
				htmlCanvas = ConchSpriteAdpt.buildCanvas((this as Sprite), 0, 0);
				if (htmlCanvas)
				{
					_datai32[SpriteConst.POSCACHE_CANVAS_SKIP_PAINT_FLAG] = 0;
					_lastContext = layagl.getCurrentContext();
					htmlContext = htmlCanvas.context;
					var target:RenderTexture2D = htmlContext._targets;
					DrawCanvasCmdNative.setParamData(_drawCanvasParamData, target, -CacheStyle.CANVAS_EXTEND_EDGE,-CacheStyle.CANVAS_EXTEND_EDGE, target.width, target.height);
					layagl.setCurrentContext(htmlContext);
					htmlContext.beginRT();
					
					//调整绘制的位置，正常要偏移x=16,y=16
					layagl.save();//cacheCanvas的save
					_tempFloatArrayMatrix[0] = 1; _tempFloatArrayMatrix[1] = 0; _tempFloatArrayMatrix[2] = 0; _tempFloatArrayMatrix[3] = 1;
					//_tempFloatArrayMatrix[4] = -left; _tempFloatArrayMatrix[5] = -top;
					_tempFloatArrayMatrix[4] = CacheStyle.CANVAS_EXTEND_EDGE; _tempFloatArrayMatrix[5] = CacheStyle.CANVAS_EXTEND_EDGE;
					layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_MATRIX32, LayaGL.VALUE_OPERATE_SET, _tempFloatArrayMatrix);
					
					//修改变量POSVISIBLE_NATIVE
					if (_bRepaintCanvas != true)
					{
						setChildrenNativeVisible(true);
						_bRepaintCanvas = true;
					}
				}
				_canvasBeginCmd.endEncoding();
			}
		}
		//TODO:coverage
		public function setChildrenNativeVisible(visible:Boolean):void
		{
			var childs:Array = this._children, ele:*;
			var n:int = childs.length;		
			for (var i:int = 0; i < n; ++i)
			{
				ele = childs[i];
				ele._datai32[SpriteConst.POSVISIBLE_NATIVE] = visible?1:0;
				ele.setChildrenNativeVisible(visible);
			}
		}
		//TODO:coverage
		public function canvasEndRenderFromNative():void
		{
			var layagl:* = LayaGL.instance;
			_canvasEndCmd.beginEncoding();
			_canvasEndCmd.clearEncoding();
			if (_bRepaintCanvas)
			{
				var context:* = LayaGL.instance.getCurrentContext();
				layagl.restore();//对应的canvasBeginRenderFromNative中的save
				layagl.setCurrentContext(this._lastContext);
				layagl.commitContextToGPU(context);
				context.endRT();
				layagl.blendFunc(WebGLContext.ONE, WebGLContext.ONE_MINUS_SRC_ALPHA);
			}
			_canvasEndCmd.endEncoding();
		}
		//TODO:coverage
		public function filterBeginRenderFromNative():void
		{
			var sprite:Sprite = this as Sprite;
			var layagl:* = LayaGL.instance;
			_filterBeginCmd.beginEncoding();
			_filterBeginCmd.clearEncoding();
			var filters:Array = (this as Sprite)._getCacheStyle().filters;
			var len:int = filters.length;
			if (filters[0] is ColorFilter)
			{
				layagl.addShaderMacro( LayaNative2D.SHADER_MACRO_COLOR_FILTER);
				var colorFilter:ColorFilter = filters[0];
				layagl.setGlobalValue( LayaNative2D.GLOBALVALUE_COLORFILTER_COLOR, LayaGL.VALUE_OPERATE_SET, colorFilter._mat );
				layagl.setGlobalValue( LayaNative2D.GLOBALVALUE_COLORFILTER_ALPHA, LayaGL.VALUE_OPERATE_SET, colorFilter._alpha );
			}
			else
			{
				var p:Point = Point.TEMP;
				//var tMatrix:Matrix = context._getTransformMatrix();//TODO
				var mat:Matrix = Matrix.create();
				//tMatrix.copyTo(mat);//TODO
				var tPadding:int = 0;	//给glow用
				var tHalfPadding:int = 0;
				var tIsHaveGlowFilter:Boolean = sprite._isHaveGlowFilter();
				
				//计算target的size
				//------------------------------------------------------------
				//glow需要扩展边缘
				if (tIsHaveGlowFilter) {
					tPadding = 50;
					tHalfPadding = 25;
				}
				var b:Rectangle = new Rectangle();
				b.copyFrom((sprite as Sprite).getSelfBounds());
				b.x += (sprite as Sprite).x;
				b.y += (sprite as Sprite).y;
				b.x -= (sprite as Sprite).pivotX + 4;//blur 
				b.y -= (sprite as Sprite).pivotY + 4;//blur
				var tSX:Number = b.x;
				var tSY:Number = b.y;
				//重新计算宽和高
				b.width += (tPadding + 8);//增加宽度 blur  由于blur系数为9
				b.height += (tPadding + 8);//增加高度 blur
				p.x = b.x * mat.a + b.y * mat.c;
				p.y = b.y * mat.d + b.x * mat.b;
				b.x = p.x;
				b.y = p.y;
				p.x = b.width * mat.a + b.height * mat.c;
				p.y = b.height * mat.d + b.width * mat.b;
				b.width = p.x;
				b.height = p.y;
				if (b.width <= 0 || b.height <= 0) 
				{
					return;
				}
				//------------------------------------------------------------
				var filterTarget:RenderTexture2D = sprite._getCacheStyle().filterCache;
				if (filterTarget) {
					WebGLRTMgr.releaseRT(filterTarget);
				}
				filterTarget = WebGLRTMgr.getRT(b.width, b.height);
				sprite._getCacheStyle().filterCache = filterTarget;
				//使用renderTarget
				useRenderTarget(filterTarget);
				//调整要绘制的位置
				_tempFloatArrayMatrix[0] = 1; _tempFloatArrayMatrix[1] = 0; _tempFloatArrayMatrix[2] = 0; _tempFloatArrayMatrix[3] = 1;
				_tempFloatArrayMatrix[4] = sprite.x - tSX + tHalfPadding;
				_tempFloatArrayMatrix[5] = sprite.y - tSY + tHalfPadding;
				layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_MATRIX32, LayaGL.VALUE_OPERATE_SET, _tempFloatArrayMatrix);
			}
			_filterBeginCmd.endEncoding();
		}
		//TODO:coverage
		public static function useRenderTarget(target:RenderTexture2D):void
		{
			var layagl:* = LayaGL.instance;
			RenderTexture2D.pushRT();
			target.start();
			layagl.clearColor(0, 0, 0, 0);
			layagl.clear(WebGLContext.COLOR_BUFFER_BIT | WebGLContext.DEPTH_BUFFER_BIT | WebGLContext.STENCIL_BUFFER_BIT);
			layagl.save();
			_tempFloatArrayBuffer2[0] = target.width;
			_tempFloatArrayBuffer2[1] = target.height;
			layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_VIEWS, LayaGL.VALUE_OPERATE_SET, _tempFloatArrayBuffer2);
		}
		//TODO:coverage
		public function filterEndRenderFromNative():void
		{
			_filterEndCmd.beginEncoding();
			_filterEndCmd.clearEncoding();
			var sprite:Sprite = this as Sprite;
			var layagl:* = LayaGL.instance;
			var filters:Array = (this as Sprite)._getCacheStyle().filters;
			if (filters[0] is ColorFilter)
			{
				//不用处理
			}
			else
			{
				layagl.restore();//对应filterBeginRenderFromNative中的useRenderTarget的save
				var context:* = LayaGL.instance.getCurrentContext();
				/*
				var len:int = filters.length;
				for (var i:int = 1; i < len; i++) 
				{
				}
				*/
				var target:RenderTexture2D = RenderTexture2D.currentActive;
				RenderTexture2D.popRT();//对应filterBeginRenderFromNative里面的useRenderTarget
				//if (filters[0] is Laya['BlurFilter'])
				if(__JS__('filters[0] instanceof Laya.BlurFilter'))
				{
					layagl.addShaderMacro( LayaNative2D.SHADER_MACRO_BLUR_FILTER);
					var blurFilter:* = filters[0];
					_tempFloatArrayBuffer2[0] = target.width;
					_tempFloatArrayBuffer2[1] = target.height;
					layagl.setGlobalValue( LayaNative2D.GLOBALVALUE_BLURFILTER_BLURINFO, LayaGL.VALUE_OPERATE_SET,_tempFloatArrayBuffer2  );
					layagl.setGlobalValue( LayaNative2D.GLOBALVALUE_BLURFILTER_STRENGTH, LayaGL.VALUE_OPERATE_SET, blurFilter.getStrenth_sig2_2sig2_native() );
					//因为上面target一边扩充了4个像素，绘制的时候需要偏移回来
					//TODO 这个-4应该计算一下
					context.drawTarget(this._filterEndCmd, target, -4, -4, 0, 0);
				}
				//else if (filters[0] is Laya['GlowFilter'])
				else if(__JS__('filters[0] instanceof Laya.GlowFilter'))
				{
					//把target的用模糊的方式绘制到target1上
					//------------------------------------------------------------
					var w:int = target.width;
					var h:int = target.height;
					var target1:RenderTexture2D = WebGLRTMgr.getRT(w,h);
					useRenderTarget(target1);//下面要restore
					
					layagl.addShaderMacro( LayaNative2D.SHADER_MACRO_GLOW_FILTER);
					var glowFilter:* = filters[0];
					var info2:Float32Array = glowFilter.getBlurInfo2Native();
					info2[0] = w;
					info2[1] = h;
					layagl.setGlobalValue( LayaNative2D.GLOBALVALUE_GLOWFILTER_COLOR, LayaGL.VALUE_OPERATE_SET, glowFilter.getColorNative()  );
					layagl.setGlobalValue( LayaNative2D.GLOBALVALUE_GLOWFILTER_BLURINFO1, LayaGL.VALUE_OPERATE_SET, glowFilter.getBlurInfo1Native());
					layagl.setGlobalValue( LayaNative2D.GLOBALVALUE_GLOWFILTER_BLURINFO2, LayaGL.VALUE_OPERATE_SET, info2  );
					//因为canvas的那个偏移，所以要偏移回来-16，但是当扩充的大小变化的时候，需要修改一下数值
					context.drawTarget(this._filterEndCmd, target, -CacheStyle.CANVAS_EXTEND_EDGE, -CacheStyle.CANVAS_EXTEND_EDGE, 0, 0);
					
					layagl.restore();//对应上面的useRenderTarget
					RenderTexture2D.popRT();//对应上面的useRenderTarget
					//------------------------------------------------------------
					
					//把模糊的target1  和  普通的target 绘制到 cacheAs的那个target上
					context.drawTarget(this._filterEndCmd, target1, -29, -29, 0, 0);
					context.drawTarget(this._filterEndCmd, target, -29, -29, 0, 0);
				}
			}
			_filterEndCmd.endEncoding();
			LayaGL.syncBufferToRenderThread(_filterEndCmd);
		}
		public function maskRenderFromNative():void
		{
			/*
			_maskCmd.beginEncoding();
			_maskCmd.clearEncoding();
			var layagl:* = LayaGL.instance;
			var context:* = layagl.getCurrentContext();
			var mask:Sprite = (this as Sprite).mask;
			if (mask)
			{
				var tRect:Rectangle = new Rectangle();
				//裁剪范围是根据mask来定的
				tRect.copyFrom(mask.getBounds());
				tRect.width = Math.round(tRect.width);
				tRect.height = Math.round(tRect.height);
				tRect.x = Math.round(tRect.x);
				tRect.y = Math.round(tRect.y);
				if (tRect.width > 0 && tRect.height > 0)
				{
					var target:RenderTexture2D = WebGLRTMgr.getRT(tRect.width,tRect.height);
					useRenderTarget(target);//下面要restore
					//还原偏移值
					_tempFloatArrayMatrix[0] = 1; _tempFloatArrayMatrix[1] = 0; _tempFloatArrayMatrix[2] = 0; _tempFloatArrayMatrix[3] = 1;
					_tempFloatArrayMatrix[4] = 0; _tempFloatArrayMatrix[5] = 0;
					layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_MATRIX32, LayaGL.VALUE_OPERATE_SET, _tempFloatArrayMatrix);
					
					if (mask._children.length > 0)
					{
						layagl.blockStart(mask._conchData);
						(mask as Object)._renderChilds(context);
						layagl.blockEnd(mask._conchData);
					}
					else
					{
						layagl.block(mask._conchData);
					}
					layagl.restore();
					RenderTexture2D.popRT();
					_maskTarget = target;
				}
			}
			_maskCmd.endEncoding();
			*/
			_maskCmd.beginEncoding();
			_maskCmd.clearEncoding();
			var layagl:* = LayaGL.instance;
			var context:* = layagl.getCurrentContext();
			var mask:Sprite = (this as Sprite).mask;
			if (mask)
			{
				//mask._datai32[SpriteConst.POSREPAINT] = 1;
				if (mask._children.length > 0)       
				{
					layagl.blockStart(mask._conchData);
					(mask as Object)._renderChilds(context);
					layagl.blockEnd(mask._conchData);
				}
				else
				{
					layagl.block(mask._conchData);
				}
			}
			_tempInt1[0] = WebGLContext.DST_ALPHA;
			layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaGL.VALUE_OPERATE_SET, _tempInt1);
			_tempInt1[0] = WebGLContext.ZERO;
			layagl.setGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST, LayaGL.VALUE_OPERATE_SET, _tempInt1);
			_maskCmd.endEncoding();
		}
		
		public function updateParticleFromNative():void{
			(this as Object).tempCmd.updateParticle();
		}
		
		public static function buildCanvas(sprite:Sprite, x:Number, y:Number):HTMLCanvas {
			/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
			var _cacheStyle:CacheStyle = sprite._cacheStyle;
			var tx:Context;
			var canvas:HTMLCanvas=_cacheStyle.canvas;
			var left:Number;
			var top:Number;
			var tRec:Rectangle;
			var tCacheType:String = _cacheStyle.cacheAs;
			
			var w:Number, h:Number;
			var scaleX:Number, scaleY:Number;
			
			var scaleInfo:Point;
			scaleInfo = _cacheStyle._calculateCacheRect(sprite, tCacheType, x, y);
			scaleX = scaleInfo.x;
			scaleY = scaleInfo.y;
				
			//显示对象实际的绘图区域
			tRec = _cacheStyle.cacheRect;
			
			//计算cache画布的大小
			w = tRec.width * scaleX;
			h = tRec.height * scaleY;
			left = tRec.x;
			top = tRec.y;
			
			if (tCacheType === 'bitmap' && (w > 2048 || h > 2048)) {
				alert("cache bitmap size larger than 2048,cache ignored");
				_cacheStyle.releaseContext();
				return null;
			}
			if (!canvas) {
				_cacheStyle.createContext();
				canvas = _cacheStyle.canvas;
			}

			tx = canvas.context;
			
			//WebGL用
			canvas.context.sprite = sprite;
			
			if (canvas.width != w || canvas.height != h) 
			{
				canvas.size(w, h);//asbitmap需要合理的大小，所以size放到前面
				if ( tx._targets )
				{
					tx._targets.destroy();
					tx._targets = null;
					//tx._targets = new RenderTexture2D(w, h, 1, -1);
				}
			}
			
			//创建RenderTexture2D
			if (tCacheType === 'bitmap') canvas.context.asBitmap = true;
			else if (tCacheType === 'normal') canvas.context.asBitmap = false;
			
			//清理画布。之前记录的submit会被全部清掉
			//canvas.clear();
			
			if (tCacheType === 'normal') {
				//记录需要touch的资源
				tx.touches = [];
			}
			return canvas;
		}
	}
}