package laya.layagl
{
	import laya.display.SpriteConst;
	import laya.renders.Render;
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	
	/**
	 * @private
	 * 命令模板，用来优化合并命令执行
	 */
	public class LayaGLTemplate
	{
		public static var GLS:Array = [];
		public static var GLSE:Array = [];
		private static var __FUN_PARAM__:Array = [];
		private static var __FUN_PARAM_END_:Array = [];
		
		//TODO:coverage
		public static function createByRenderType(renderType:int):LayaGLTemplate
		{
			var template:LayaGLTemplate = GLS[renderType] = new LayaGLTemplate();
			if (Render.isConchApp)
			{
				LayaGL.instance.setGLTemplate(renderType, template._commandEncoder.getPtrID());
			}
			var n:int = SpriteConst.ALPHA;
			while (n <= SpriteConst.CHILDS)
			{
				var tempType:int = renderType & n;
				if ( tempType && __FUN_PARAM__[n])
				{
					var objArr:Array = __FUN_PARAM__[n];
					for (var i:int = 0, sz:int = objArr.length; i < sz; i++) {
						var obj:* = objArr[i];
						template.addComd(obj.func,obj.args);
					}
				}
				n <<= 1;
			}
			template._id = renderType;
			trace("template=" + template._commStr);
			return template;
		}
		
		//TODO:coverage
		public static function createByRenderTypeEnd(renderType:int):LayaGLTemplate
		{
			var template:LayaGLTemplate = GLSE[renderType] = new LayaGLTemplate();
			if (Render.isConchApp)
			{
				LayaGL.instance.setEndGLTemplate(renderType, template._commandEncoder.getPtrID());
			}
			var n:int = SpriteConst.CHILDS;
			while (n > SpriteConst.ALPHA)
			{
				var tempType:int = renderType & n;
				if ( tempType && __FUN_PARAM_END_[n])
				{
					var objArr:Array = __FUN_PARAM_END_[n];
					for (var i:int = 0, sz:int = objArr.length; i < sz; i++) {
						var obj:* = objArr[i];
						template.addComd(obj.func,obj.args);
					}
				}
				n >>= 1;
			}
			template._id = renderType;
			trace("templateEnd=" + template._commStr);
			return template;
		}
		
		//TODO:coverage
		public static function __init__():void
		{
			__FUN_PARAM__[SpriteConst.ALPHA] = [{ func:"setGlobalValueByParamData",args:[LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR,LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL,SpriteConst.POSCOLOR*4] }];
			__FUN_PARAM__[SpriteConst.TRANSFORM] = [ {func:"calcLocalMatrix32",args:[SpriteConst.POSTRANSFORM_FLAG*4, SpriteConst.POSMATRIX*4, SpriteConst.POSX*4, SpriteConst.POSY*4, SpriteConst.POSPIVOTX*4, SpriteConst.POSPIVOTY*4, SpriteConst.POSSCALEX*4, SpriteConst.POSSCALEY*4, SpriteConst.POSSKEWX*4, SpriteConst.POSSKEWY*4, SpriteConst.POSROTATION*4]},
												{ func:"setGlobalValueByParamData", args:[LayaNative2D.GLOBALVALUE_MATRIX32, LayaGL.VALUE_OPERATE_M32_MUL, SpriteConst.POSMATRIX * 4] } ];
			
			__FUN_PARAM__[SpriteConst.BLEND] = [ { func:"setGlobalValueByParamData", args:[LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaGL.VALUE_OPERATE_SET, SpriteConst.POSBLEND_SRC * 4] },
												 { func:"setGlobalValueByParamData", args:[LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST, LayaGL.VALUE_OPERATE_SET, SpriteConst.POSBLEND_DEST * 4] }];
			
			__FUN_PARAM__[SpriteConst.TEXTURE] = [{ func:"useCommandEncoderByParamData", args:[SpriteConst.POSSIM_TEXTURE_ID*4, SpriteConst.POSSIM_TEXTURE_DATA * 4, LayaGL.EXECUTE_RENDER_THREAD_BUFFER] }];
			__FUN_PARAM__[SpriteConst.GRAPHICS] = [ { func:"callbackJSByParamData", args:[SpriteConst.POSCALLBACK_OBJ_ID*4, SpriteConst.POSGRAPHICS_CALLBACK_FUN_ID * 4] },
													{ func:"useCommandEncoderByParamData", args:[SpriteConst.POSGRAPICS * 4, -1, LayaGL.EXECUTE_RENDER_THREAD_BUFFER] } ];
			__FUN_PARAM__[SpriteConst.LAYAGL3D] = [{ func:"callbackJSByParamData", args:[SpriteConst.POSCALLBACK_OBJ_ID*4,SpriteConst.POSLAYA3D_FUN_ID * 4] },
													{ func:"useCommandEncoderByParamData", args:[SpriteConst.POSLAYAGL3D * 4, -1, LayaGL.EXECUTE_COPY_TO_RENDER3D] }];
			__FUN_PARAM__[SpriteConst.CUSTOM] = [{ func:"callbackJSByParamData", args:[SpriteConst.POSCALLBACK_OBJ_ID*4,SpriteConst.POSCUSTOM_CALLBACK_FUN_ID * 4] },
												{ func:"useCommandEncoderByParamData", args:[SpriteConst.POSCUSTOM * 4, -1, LayaGL.EXECUTE_RENDER_THREAD_BUFFER] }];
			__FUN_PARAM__[SpriteConst.CLIP] = [ { func:"setClipByParamData", args:[LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, LayaNative2D.GLOBALVALUE_MATRIX32, SpriteConst.POSCLIP * 4] },
												{ func:"setGlobalValueByParamData", args:[LayaNative2D.GLOBALVALUE_MATRIX32, LayaGL.VALUE_OPERATE_M32_TRANSLATE,SpriteConst.POSCLIP_NEG_POS * 4 ] } ];
			
			__FUN_PARAM__[SpriteConst.FILTERS] = [ { func:"callbackJSByParamData", args:[SpriteConst.POSCALLBACK_OBJ_ID * 4, SpriteConst.POSFILTER_CALLBACK_FUN_ID * 4] },
												   { func:"useCommandEncoderByParamData", args:[SpriteConst.POSFILTER_BEGIN_CMD_ID * 4, -1, LayaGL.EXECUTE_JS_THREAD_BUFFER] }];
			
			__FUN_PARAM__[SpriteConst.MASK] = [ { func:"callbackJSByParamData", args:[SpriteConst.POSCALLBACK_OBJ_ID * 4, SpriteConst.POSMASK_CALLBACK_FUN_ID * 4] },
												   { func:"useCommandEncoderByParamData", args:[SpriteConst.POSMASK_CMD_ID * 4, -1, LayaGL.EXECUTE_JS_THREAD_BUFFER] }];
			
			__FUN_PARAM__[SpriteConst.CANVAS] = [ { func:"callbackJSByParamData", args:[SpriteConst.POSCALLBACK_OBJ_ID * 4, SpriteConst.POSCANVAS_CALLBACK_FUN_ID * 4] },
												  { func:"loadDataToRegByParamData", args:[0, SpriteConst.POSCACHE_CANVAS_SKIP_PAINT_FLAG * 4,4] },
												  { func:"ifGreater0", args:[0, 2147483647] },
												  { func:"useCommandEncoderByParamData", args:[SpriteConst.POSCANVAS_BEGIN_CMD_ID * 4, -1, LayaGL.EXECUTE_JS_THREAD_BUFFER] }];
												  
			__FUN_PARAM__[SpriteConst.STYLE] = [{ func:"useCommandEncoderByParamData", args:[SpriteConst.POSSIM_RECT_FILL_CMD * 4, SpriteConst.POSSIM_RECT_FILL_DATA * 4, LayaGL.EXECUTE_RENDER_THREAD_BUFFER] },
												{ func:"useCommandEncoderByParamData", args:[SpriteConst.POSSIM_RECT_STROKE_CMD * 4, SpriteConst.POSSIM_RECT_STROKE_DATA * 4, LayaGL.EXECUTE_RENDER_THREAD_BUFFER] }];
		}
		
		//TODO:coverage
		public static function __init_END_():void
		{
			
			__FUN_PARAM_END_[SpriteConst.FILTERS] = [ { func:"loadDataToRegByParamData", args:[0, SpriteConst.POSCACHE_CANVAS_SKIP_PAINT_FLAG * 4,4] },
													  { func:"ifGreater0", args:[0, 2] },
													  { func:"callbackJSByParamData", args:[SpriteConst.POSCALLBACK_OBJ_ID * 4, SpriteConst.POSFILTER_END_CALLBACK_FUN_ID * 4] },
												      { func:"useCommandEncoderByParamData", args:[SpriteConst.POSFILTER_END_CMD_ID * 4, -1, LayaGL.EXECUTE_RENDER_THREAD_BUFFER] } ];
												  
			__FUN_PARAM_END_[SpriteConst.CANVAS] = [ { func:"callbackJSByParamData", args:[SpriteConst.POSCALLBACK_OBJ_ID * 4, SpriteConst.POSCANVAS_CALLBACK_END_FUN_ID * 4] },
												  { func:"useCommandEncoderByParamData", args:[SpriteConst.POSCANVAS_END_CMD_ID * 4, -1, LayaGL.EXECUTE_JS_THREAD_BUFFER] },
												  { func:"useCommandEncoderByParamData", args:[SpriteConst.POSCANVAS_DRAW_TARGET_CMD_ID*4, SpriteConst.POSCANVAS_DRAW_TARGET_PARAM_ID*4, LayaGL.EXECUTE_RENDER_THREAD_BUFFER] }];
		}
		
		public var _commStr:String = "";
		public var _commandEncoder:*;
		public var _id:int;
		public function LayaGLTemplate() 
		{
			this._commandEncoder = LayaGL.instance.createCommandEncoder(64, 16, false);
		}
		
		//TODO:coverage
		public function addComd(funcName:String,argsArray:Array):void
		{
			_commStr += funcName + "(" + argsArray + ");";
			_commandEncoder[funcName].apply(_commandEncoder,argsArray);
		}
	}
}