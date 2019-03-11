package laya.layagl {
	import laya.display.Graphics;
	import laya.renders.Render;
	import laya.layagl.LayaGLTemplate;
	import laya.webgl.WebGLContext;
	import laya.webgl.resource.CharBook;
	import laya.webgl.resource.CharPages;
	import laya.webgl.resource.CharRender_Canvas;
	import laya.webgl.resource.CharRender_Native;
	import laya.webgl.text.TextRender;
	
	/**
	 * ...
	 * @author James
	 */
	public class LayaNative2D {
		public static var _SIMPLE_TEXTURE_CMDENCODER_:* = null;
		public static var _SIMPLE_RECT_CMDENCODER_:* = null;
		public static var _RECT_BORDER_CMD_ENCODER_:* = null;
		
		//定义3个shader
		public static var PROGRAMEX_DRAWTEXTURE:int = 0;
		public static var PROGRAMEX_DRAWVG:int = 0;
		public static var PROGRAMEX_DRAWRECT:int = 0;
		public static var PROGRAMEX_DRAWPARTICLE:int = 0;
		//VDO定义
		public static var VDO_MESHQUADTEXTURE:int = 0;	//xyuv,rgba,
		public static var VDO_MESHVG:int = 0;
		public static var VDO_MESHPARTICLE:int = 0;
		//全局数据区
		public static var GLOBALVALUE_VIEWS:int = 0;//runtime中保留的，屏幕的宽和高
		public static var GLOBALVALUE_MATRIX32:int = 0;
		public static var GLOBALVALUE_DRAWTEXTURE_COLOR:int = 0;
		public static var GLOBALVALUE_ITALICDEG:int = 0;
		public static var GLOBALVALUE_CLIP_MAT_DIR:int = 0;	//vec4
		public static var GLOBALVALUE_CLIP_MAT_POS:int = 0; //vec2
		public static var GLOBALVALUE_BLENDFUNC_SRC:int = 0; //int
		public static var GLOBALVALUE_BLENDFUNC_DEST:int = 0; //int
		public static var GLOBALVALUE_COLORFILTER_COLOR:int = 0; //4X4
		public static var GLOBALVALUE_COLORFILTER_ALPHA:int = 0; //vec4
		public static var GLOBALVALUE_BLURFILTER_STRENGTH:int = 0; //vec4
		public static var GLOBALVALUE_BLURFILTER_BLURINFO:int = 0; //vec2
		
		
		//shader宏定义
		public static var SHADER_MACRO_COLOR_FILTER:int = 0;
		public static var SHADER_MACRO_BLUR_FILTER:int = 0;
		public static var SHADER_MACRO_GLOW_FILTER:int = 0;
		public static var GLOBALVALUE_GLOWFILTER_COLOR:int = 0;
		public static var GLOBALVALUE_GLOWFILTER_BLURINFO1:int = 0;
		public static var GLOBALVALUE_GLOWFILTER_BLURINFO2:int = 0;

		public function LayaNative2D() {
		
		}
		
		//TODO:coverage
		public static function _init_simple_texture_cmdEncoder_():void {
			_SIMPLE_TEXTURE_CMDENCODER_ = LayaGL.instance.createCommandEncoder(172, 32, true);
			_SIMPLE_TEXTURE_CMDENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
			_SIMPLE_TEXTURE_CMDENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
			_SIMPLE_TEXTURE_CMDENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
			_SIMPLE_TEXTURE_CMDENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
			_SIMPLE_TEXTURE_CMDENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
			_SIMPLE_TEXTURE_CMDENCODER_.uniformTextureByParamData(0, 1 * 4, 2 * 4);
			_SIMPLE_TEXTURE_CMDENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
			_SIMPLE_TEXTURE_CMDENCODER_.setRectMeshByParamData(3 * 4, 5 * 4, 4 * 4);
			_SIMPLE_TEXTURE_CMDENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
			_SIMPLE_TEXTURE_CMDENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
			LayaGL.syncBufferToRenderThread(_SIMPLE_TEXTURE_CMDENCODER_);
		}
		
		public static function _init_simple_rect_cmdEncoder_():void {
			_SIMPLE_RECT_CMDENCODER_ = LayaGL.instance.createCommandEncoder(136, 32, true);
			_SIMPLE_RECT_CMDENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWTEXTURE);//programID
			_SIMPLE_RECT_CMDENCODER_.useVDO(LayaNative2D.VDO_MESHQUADTEXTURE);//VAO ID
			_SIMPLE_RECT_CMDENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
			_SIMPLE_RECT_CMDENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
			_SIMPLE_RECT_CMDENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
			_SIMPLE_RECT_CMDENCODER_.setRectMeshByParamData(0*4, 2 * 4, 1 * 4 );
			_SIMPLE_RECT_CMDENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
			_SIMPLE_RECT_CMDENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);
			LayaGL.syncBufferToRenderThread( _SIMPLE_RECT_CMDENCODER_ );
		}
		
		public static function _init_rect_border_cmdEncoder_():void {
			_RECT_BORDER_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(152, 32, true);
			_RECT_BORDER_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWVG);//programID
			_RECT_BORDER_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHVG);//VAO ID
			_RECT_BORDER_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_VIEWS, 0);//valueID,  name
			_RECT_BORDER_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_DIR, 1);
			_RECT_BORDER_CMD_ENCODER_.uniformEx(LayaNative2D.GLOBALVALUE_CLIP_MAT_POS, 2);
			_RECT_BORDER_CMD_ENCODER_.setMeshByParamData(5 * 4, 0 * 4, 1 * 4, 35 * 4, 2 * 4, 3 * 4, 4 * 4 );
			_RECT_BORDER_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 0, LayaGL.VALUE_OPERATE_M32_MUL);
			_RECT_BORDER_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_DRAWTEXTURE_COLOR, 1, LayaGL.VALUE_OPERATE_BYTE4_COLOR_MUL);				
			LayaGL.syncBufferToRenderThread( _RECT_BORDER_CMD_ENCODER_ );
		}
		
		//TODO:coverage
		public static function __init__():void {
			if (Render.isConchApp) {
				//定义全局数据区
				var layaGL:* = LayaGL.instance;
				GLOBALVALUE_MATRIX32 = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 6, new Float32Array([1, 0, 0, 1, 0, 0]));
				GLOBALVALUE_DRAWTEXTURE_COLOR = layaGL.addGlobalValueDefine(0, WebGLContext.INT, 1, new Uint32Array([0xFFFFFFFF]));
				GLOBALVALUE_ITALICDEG = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 1, new Float32Array([0]));
				GLOBALVALUE_CLIP_MAT_DIR = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 4, new Float32Array([1e6, 0, 0, 1e6]));
				GLOBALVALUE_CLIP_MAT_POS = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 2, new Float32Array([0, 0]));
				GLOBALVALUE_BLENDFUNC_SRC = layaGL.addGlobalValueDefine(0, WebGLContext.INT, 1, new Int32Array([WebGLContext.ONE]));
				GLOBALVALUE_BLENDFUNC_DEST = layaGL.addGlobalValueDefine(0, WebGLContext.INT, 1, new Int32Array([WebGLContext.ONE_MINUS_SRC_ALPHA]));
				GLOBALVALUE_COLORFILTER_COLOR = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 16, new Float32Array([1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]));
				GLOBALVALUE_COLORFILTER_ALPHA = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 4, new Float32Array([0, 0, 0, 1]));
				GLOBALVALUE_BLURFILTER_STRENGTH = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 4, new Float32Array([0,0,0,0]));
				GLOBALVALUE_BLURFILTER_BLURINFO = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 2, new Float32Array([0, 0]));
				GLOBALVALUE_GLOWFILTER_COLOR = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 4, new Float32Array([0, 0,0,0]));
				GLOBALVALUE_GLOWFILTER_BLURINFO1 = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 4, new Float32Array([0, 0,0,0]));
				GLOBALVALUE_GLOWFILTER_BLURINFO2 = layaGL.addGlobalValueDefine(0, WebGLContext.FLOAT, 4, new Float32Array([0, 0,0,0]));
				layaGL.endGlobalValueDefine();
				
				//初始化shader
				//-------------------------------------------------
				PROGRAMEX_DRAWTEXTURE = LayaGL.instance.createProgramEx(__INCLUDESTR__('../webgl/shader/d2/files/texture.vs'), __INCLUDESTR__('../webgl/shader/d2/files/texture.ps'), "posuv,attribColor,attribFlags", "size,clipMatDir,clipMatPos,texture,colorMat,colorAlpha,strength_sig2_2sig2_gauss1,blurInfo,u_color,u_blurInfo1,u_blurInfo2");
				
				PROGRAMEX_DRAWVG = LayaGL.instance.createProgramEx(__INCLUDESTR__('../webgl/shader/d2/files/primitive.vs'), __INCLUDESTR__('../webgl/shader/d2/files/primitive.ps'), "position,attribColor", "size,clipMatDir,clipMatPos");
				
				PROGRAMEX_DRAWPARTICLE = LayaGL.instance.createProgramEx(__INCLUDESTR__('../webgl/shader/d2/files/Particle.vs'), __INCLUDESTR__('../webgl/shader/d2/files/Particle.ps'), "a_CornerTextureCoordinate,a_Position,a_Velocity,a_StartColor,a_EndColor,a_SizeRotation,a_Radius,a_Radian,a_AgeAddScale,a_Time", "u_CurrentTime,u_Duration,u_EndVelocity,u_Gravity,size,u_mmat,u_texture");
				//初始化VDO
				VDO_MESHQUADTEXTURE = layaGL.createVDO(new Int32Array([WebGLContext.FLOAT, 0, 4, 24, WebGLContext.UNSIGNED_BYTE, 16, 4, 24, WebGLContext.UNSIGNED_BYTE, 20, 4, 24]));
				VDO_MESHVG = layaGL.createVDO(new Int32Array([WebGLContext.FLOAT, 0, 2, 12, WebGLContext.UNSIGNED_BYTE, 8, 4, 12]));
				VDO_MESHPARTICLE = layaGL.createVDO(new Int32Array([WebGLContext.FLOAT, 0, 4, 116,WebGLContext.FLOAT, 16, 3, 116, WebGLContext.FLOAT, 28, 3, 116, WebGLContext.FLOAT, 40, 4, 116, WebGLContext.FLOAT, 56, 4, 116, WebGLContext.FLOAT, 72, 3, 116, WebGLContext.FLOAT, 84, 2, 116, WebGLContext.FLOAT, 92, 4, 116, WebGLContext.FLOAT, 108, 1, 116, WebGLContext.FLOAT, 112, 1, 116]));
				
				//初始化simple texture的指令集
				_init_simple_texture_cmdEncoder_();
				
				//初始化simple rect的指令集
				_init_simple_rect_cmdEncoder_();
				
				//初始化rect border的指令集
				_init_rect_border_cmdEncoder_();
				
				//初始化宏定义
				SHADER_MACRO_COLOR_FILTER = LayaGL.instance.defineShaderMacro("#define COLOR_FILTER", [ { uname: 4, id: GLOBALVALUE_COLORFILTER_COLOR }, { uname: 5, id: GLOBALVALUE_COLORFILTER_ALPHA } ]);
				SHADER_MACRO_BLUR_FILTER = LayaGL.instance.defineShaderMacro("#define BLUR_FILTER", [ { uname: 6, id: GLOBALVALUE_BLURFILTER_STRENGTH }, { uname: 7, id: GLOBALVALUE_BLURFILTER_BLURINFO } ]);
				SHADER_MACRO_GLOW_FILTER = LayaGL.instance.defineShaderMacro("#define GLOW_FILTER", [ { uname: 8, id: GLOBALVALUE_GLOWFILTER_COLOR }, { uname: 9, id: GLOBALVALUE_GLOWFILTER_BLURINFO1 }, { uname: 10, id: GLOBALVALUE_GLOWFILTER_BLURINFO2 }]);
				
				//初始化模板
				LayaGLTemplate.__init__();
				LayaGLTemplate.__init_END_();
				
				if( TextRender.useOldCharBook) new CharBook();
				else new TextRender();
				CharPages.charRender = new CharRender_Native() as CharRender_Canvas;
			}
		}
	}
}