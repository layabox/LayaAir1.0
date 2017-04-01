/*[IF-FLASH]*/package laya.flash {
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Stage3D;
	import flash.display.StageQuality;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DStencilAction;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import laya.utils.Browser;
	import laya.webgl.utils.Buffer;
	import laya.webgl.WebGLContext;
	import com.adobe.glsl2agal.*;
	import laya.webgl.shader.d2.value.Value2D;
	import laya.webgl.utils.RenderState2D;
	/**
	 * ...
	 * @author laya
	 */
	public class FlashWebGLContext extends WebGLContext 
	{
		public static const TEXTURE_2D                   : uint = 0x0DE1;
		public static const TEXTURE                      : uint = 0x1702;

		public static const TEXTURE_CUBE_MAP             : uint = 0x8513;
		public static const TEXTURE_BINDING_CUBE_MAP     : uint = 0x8514;
		public static const TEXTURE_CUBE_MAP_POSITIVE_X  : uint = 0x8515;
		public static const TEXTURE_CUBE_MAP_NEGATIVE_X  : uint = 0x8516;
		public static const TEXTURE_CUBE_MAP_POSITIVE_Y  : uint = 0x8517;
		public static const TEXTURE_CUBE_MAP_NEGATIVE_Y  : uint = 0x8518;
		public static const TEXTURE_CUBE_MAP_POSITIVE_Z  : uint = 0x8519;
		public static const TEXTURE_CUBE_MAP_NEGATIVE_Z  : uint = 0x851A;
		public static const MAX_CUBE_MAP_TEXTURE_SIZE    : uint = 0x851C;		
		
		public static var _stage3d:Stage3D;
		private static var _context3D:Context3D;
	
		private static var _Context3DVertexBufferFormat:Array = [0, Context3DVertexBufferFormat.FLOAT_1, Context3DVertexBufferFormat.FLOAT_2, Context3DVertexBufferFormat.FLOAT_3, Context3DVertexBufferFormat.FLOAT_4];
		
		private var _r:Number, _g:Number, _b:Number, _alpha:Number;
		
		//@{ 以下数据保存了相当于WebGL的内部渲染状态.
		private var _program:ProgramObject;
		private var _lactPro:ProgramObject = null;
		private var _vsShader:*;
		private var _psShader:*;
		private var _webGLStatus:*= { };
		private var _activeVBuf : FlashVertexBuffer = null;
		private var _activeIBuf : FlashIndexBuffer = null;
		private var _csetMaxTex : int = 0;	
				
		private var _bScissor : Boolean = false;
		private var _scissorRect : Rectangle = new Rectangle();
		private static var _texUnit : int = 0;
		// 当前正在激活操作的TextureUnit索引，Stage3d应该是0-7.WebGL设置则以TEXTURE0开始.
		private var _actTexUnit : int = 0;		
		//@}

		//@{ 以下数据，记录WebGL的StencilBuffer状态.
		private var _stencil : stencilState = new stencilState();
		private var _separateStenVec : Vector.<stencilState> = new Vector.<stencilState>( 4, true );
		private var _setNum : int = 0;
		private var _stencilEnable : Boolean = false;
		//@}
		
		//@{ FrameBuffer与RenderTarget相关的内容
		// 当前绑定的FrameBuffer.
		private var _activeFrameBuffer : FrameBuffObj = null;
		//@}
		
		//@{ viewport设置相关.
		private var _bUpdateVP : Boolean = false;
		private var _vpWidth : int = 0;
		private var _vpHeight : int = 0;
		//@}
	
		//@{ 以下数据，把WebGL的常量与Stage3D的常量对应起来.
		private static var _blendV : Object = { };
		private static var _cullV : Object = { };
		private static var _depthV : Object = { };
		private static var _stencilFV : Object = _depthV;
		private static var _stencilActV : Object = { };
		private static var _trifaceV : Object = { };
		//@}
		
						
		public function FlashWebGLContext() 
		{
			
		}
		
		
		
		public static function set context3D( _ct : Context3D ) : void {
			_context3D = _ct;
			
			// 处理一些初始化的状态:
			_context3D.setCulling( Context3DTriangleFace.NONE );
			_context3D.setDepthTest( false, Context3DCompareMode.ALWAYS );		
			_context3D.enableErrorChecking = true;
			_initConstDict();

			TextureObject._context3D = _context3D;
		}
		
		/**
		 * 把Stage3D的blend常量与WebGL对应起来
		 */
		private static function _initConstDict() : void {
			_blendV[WebGLContext.DST_ALPHA] = Context3DBlendFactor.DESTINATION_ALPHA;
			_blendV[WebGLContext.DST_COLOR] = Context3DBlendFactor.DESTINATION_COLOR;
			_blendV[WebGLContext.ONE] = Context3DBlendFactor.ONE;
			_blendV[WebGLContext.ONE_MINUS_DST_ALPHA] = Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA;
			_blendV[WebGLContext.ONE_MINUS_DST_COLOR] = Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR;
			_blendV[WebGLContext.ONE_MINUS_SRC_ALPHA] = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
			_blendV[WebGLContext.ONE_MINUS_SRC_COLOR] = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
			_blendV[WebGLContext.SRC_ALPHA] = Context3DBlendFactor.SOURCE_ALPHA;
			_blendV[WebGLContext.SRC_COLOR] = Context3DBlendFactor.SOURCE_COLOR;
			_blendV[WebGLContext.ZERO] = Context3DBlendFactor.ZERO;
			
			_cullV[WebGLContext.CW] = Context3DTriangleFace.FRONT;
			_cullV[WebGLContext.CCW] = Context3DTriangleFace.FRONT;
			
			// stencil 与 Stencil共用.
			_depthV[WebGLContext.NEVER]     = Context3DCompareMode.NEVER;
			_depthV[WebGLContext.LESS]      = Context3DCompareMode.LESS;
			_depthV[WebGLContext.EQUAL]     = Context3DCompareMode.EQUAL;
			_depthV[WebGLContext.LEQUAL]    = Context3DCompareMode.LESS_EQUAL;
			_depthV[WebGLContext.GREATER]   = Context3DCompareMode.GREATER;
			_depthV[WebGLContext.NOTEQUAL]  = Context3DCompareMode.NOT_EQUAL;
			_depthV[WebGLContext.GEQUAL]    = Context3DCompareMode.GREATER_EQUAL;
			_depthV[WebGLContext.ALWAYS]    = Context3DCompareMode.ALWAYS;			
			
			_stencilActV[WebGLContext.KEEP]      = Context3DStencilAction.KEEP;
			_stencilActV[WebGLContext.REPLACE]   = Context3DStencilAction.SET;
			_stencilActV[WebGLContext.INCR]      = Context3DStencilAction.INCREMENT_SATURATE;
			_stencilActV[WebGLContext.DECR]      = Context3DStencilAction.DECREMENT_SATURATE;
			_stencilActV[WebGLContext.INVERT]    = Context3DStencilAction.INVERT;
			_stencilActV[WebGLContext.INCR_WRAP] = Context3DStencilAction.INCREMENT_WRAP;
			_stencilActV[WebGLContext.DECR_WRAP] = Context3DStencilAction.DECREMENT_WRAP;
				
			// Stencil face.
			_trifaceV[WebGLContext.FRONT] = Context3DTriangleFace.FRONT;
			_trifaceV[WebGLContext.BACK] = Context3DTriangleFace.BACK;
			_trifaceV[WebGLContext.FRONT_AND_BACK] = Context3DTriangleFace.FRONT_AND_BACK;
			_trifaceV[WebGLContext.NONE] = Context3DTriangleFace.NONE;
		}

		
		public static function get context3D() : Context3D {			
			return _context3D;
		}
		
		public override function clearDepth(depth:*):void{
			
		}
		public override function clearStencil(s:*):void{
			_stencil.clearMask = s;
		}		
		public override function clear(mask:uint):void
		{
			var bcolor : Boolean = Boolean(mask & WebGLContext.COLOR_BUFFER_BIT);
			var bdepth : Boolean = Boolean(mask & WebGLContext.DEPTH_BUFFER_BIT);
			var bstencil : Boolean = Boolean(mask & WebGLContext.STENCIL_BUFFER_BIT);
			
			// 迟一帧清除StencilBuffer Value.
			if ( bstencil && ((!bcolor) && (!bdepth)) ) {
				_stencil.clearBuff = true;
				return;
			}
			
			bstencil = bstencil || _stencil.clearBuff;
			var sval : uint = 0;
			if ( bstencil )
				sval = _stencil.clearMask;
			
			_context3D.clear( _r, _g, _b, _alpha,1,sval );
			WebGLContext._useProgram = null;
			_program = null;
			_context3D.setVertexBufferAt( 0, null );
			_context3D.setVertexBufferAt( 1, null );
			_context3D.setVertexBufferAt( 2, null );
			_context3D.setVertexBufferAt( 3, null );
			_context3D.setVertexBufferAt( 4, null );
			_context3D.setVertexBufferAt( 5, null );
			TextureObject.clearSampler();
			
			
		}

		
		public override function configureBackBuffer(width:int, height:int, antiAlias:int, enableDepthAndStencil:Boolean = true, wantsBestResolution:Boolean = false):void
		{
			if (width < 1 || height < 1) return;
			_context3D.configureBackBuffer(width, height, antiAlias, enableDepthAndStencil, wantsBestResolution);	
		}

		
		public override function colorMask(red:Boolean, green:Boolean, blue:Boolean, alpha:Boolean):void{
			_context3D.setColorMask( red, green, blue, alpha );	
		}
		
		public override function clearColor(red:*, green:*, blue:*, alpha:Number):void
		{
			_r = red;
			_g = green;
			_b = blue;
			_alpha = alpha;
		}
		
		/**
		 * 设置设备相关的Stencil状态.
		 */
		private function _setStencilState() : void {			
			if ( _setNum == 0 ) {
				// River:  经过测试，setStencilReferenceValue的第三个参数，并没有按字面意思进行Mask,有可能是
				//         是Stage3D的Bug,也可能是我理解的问题:
				_context3D.setStencilReferenceValue( _stencil.refVal, _stencil.refMask, _stencil.refWriteMask );		
				_context3D.setStencilActions( _trifaceV[_stencil.faceSta], _stencilFV[_stencil.funcID],
					_stencilActV[_stencil.bothpass], _stencilActV[_stencil.dfail], _stencilActV[_stencil.dpass_sfail] );
			}else {
				var sten:stencilState = null;
				for ( var ti :int = 0; ti < _setNum; ti ++ ) {
					sten = this._separateStenVec[ti];
					_context3D.setStencilReferenceValue( sten.refVal, sten.refMask, sten.refWriteMask );		
					_context3D.setStencilActions( _trifaceV[sten.faceSta], _stencilFV[sten.funcID],
						_stencilActV[sten.bothpass], _stencilActV[sten.dfail], _stencilActV[sten.dpass_sfail] );					
					sten.reset();
				}
				// 设置完成后清空队列:
				_setNum = 0;
			}
		}
		
		public override function enable(cap:*):void {
			switch( cap ) {
				case WebGLContext.DEPTH_TEST:
					_context3D.setDepthTest( Boolean(WebGLContext._depthMask), Context3DCompareMode.LESS_EQUAL );
					break;
				case WebGLContext.BLEND:
					_context3D.setBlendFactors( _blendV[WebGLContext._sFactor], _blendV[WebGLContext._dFactor]);
					break;
				case WebGLContext.CULL_FACE:
					_context3D.setCulling( _cullV[WebGLContext._frontFace] );
					break;
				case WebGLContext.SCISSOR_TEST:
					//return;
					_bScissor = true;
					_context3D.setScissorRectangle( _scissorRect );
					break;
				case WebGLContext.STENCIL_TEST:
					// 
					//_setStencilState();
					_stencilEnable = true;
					break;
				default:
					trace( "Not Supported EnableCap..." );
					break;
			}
		}
		
		public override function disable( cap:* ) : void {
			switch( cap ) {
				case WebGLContext.DEPTH_TEST:
					_context3D.setDepthTest( Boolean(WebGLContext._depthMask), Context3DCompareMode.ALWAYS );
					break;				
				case WebGLContext.BLEND:
					_context3D.setBlendFactors( Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO );
					break;
				case WebGLContext.CULL_FACE:
					_context3D.setCulling( Context3DTriangleFace.NONE );
					break;
				case WebGLContext.SCISSOR_TEST:
					_bScissor = false;
					_context3D.setScissorRectangle( null );
					break;
				case WebGLContext.STENCIL_TEST:
					// 默认的设置，全部通过Stencil,但不修改任何的StencilValue.
					_context3D.setStencilActions();
					_stencilEnable = false;
					break;
				default:
					break;
			}
		}
		
		//@{ 两个StencilBuffer相关的内容
		/**
		 * 仅用于记录数据,在enable函数内设置最终的状态.
		 * @param	func
		 * @param	ref
		 * @param	mask
		 */
		public override function stencilFunc(func:uint, ref:uint, mask:uint):void {
			_stencil.funcID = func;
			_stencil.refVal = ref;
			_stencil.refMask = mask;
		}
		public override function stencilOp(fail:uint, zfail:uint, zpass:uint):void{
			_stencil.dpass_sfail = fail;
			_stencil.dfail = zfail;
			_stencil.bothpass = zpass;
		}
		//@}
		
		private function getFaceIdx( face : uint ) : int {
			for ( var ti:int = 0; ti < this._setNum; ti ++ ) {
				if ( _separateStenVec[ti].faceSta == face ) return ti;
			}
			_separateStenVec[_setNum++].faceSta = face;
			return _setNum-1;
		}
		
		
		//@{ 更加高级的WebGL Stencil操作，平时使用比较少.
		public override function stencilFuncSeparate(face:uint, func:uint, ref:uint, mask:uint):void {
			var sten : stencilState = _separateStenVec[getFaceIdx( face )];
			
			sten.funcID = func;
			sten.refVal = ref;
			sten.refMask = mask;		
		}		
		public override function stencilOpSeparate(face:uint, fail:uint, zfail:uint, zpass:uint):void {			
			var sten : stencilState = _separateStenVec[getFaceIdx( face )];

			sten.dpass_sfail = fail;
			sten.dfail = zfail;
			sten.bothpass = zpass;			
		}	
		public override function stencilMaskSeparate(face:*, mask:*):void {		
			var sten : stencilState = _separateStenVec[getFaceIdx( face )];
			sten.refWriteMask = mask;
		}	
		/**
		 * River: WebGL与Stage3D的机制不同，此处的StencilMask只能大体模拟，在某些情况下会出错
		 * @param	mask
		 */
		public override function stencilMask(mask:*):void {
			_stencil.refWriteMask = mask;
		}		
		//@}
		

		
		/**
		 * 设置剪裁矩形.WebGL与Stage3D的Y值基准不一致，需要转换.
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public override function scissor( x:Number, y:Number, width:Number, height:Number):void {
			var scissorH : Number = RenderState2D.height;
			if ( _activeFrameBuffer ) {
				var tex : TextureObject = _activeFrameBuffer.texture;
				if( tex ){
					x = x / _vpWidth * tex.width;
					y = y / _vpHeight * tex.height;
					width = width / _vpWidth * tex.width;
					height = height / _vpHeight * tex.height;			
					scissorH = tex.height;
				}
			}
			
			_scissorRect.x = x;
			_scissorRect.y = scissorH - (y + height);
			_scissorRect.width = width;
			_scissorRect.height = height;
			
		}
		
		public override function depthFunc(func:*):void {
			WebGLContext._depthFunc = func;
			_context3D.setDepthTest( Boolean(WebGLContext._depthMask), _depthV[func] );
		}
		
		public override function depthMask(flag:*):void {
			WebGLContext._depthMask = flag;
			_context3D.setDepthTest( Boolean(WebGLContext._depthMask), _depthV[WebGLContext._depthFunc] );
		}		
		
		public override function disableVertexAttribArray(index:int):void
		{
			_context3D.setVertexBufferAt(index,null,0 );
		}
		

		private static var _Vect16s:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>;
		private static var _Vect16s_use:int = 0;
		[Inline]
		private function _getVect16():Vector.<Number>
		{
			if (_Vect16s.length > _Vect16s_use)
			{
				_Vect16s_use++;
				return _Vect16s[_Vect16s_use-1];
			}
			return _Vect16s[_Vect16s.length]=new Vector.<Number>( 16, true );
		}
		
		private static var _Vect4s:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>;
		private static var _Vect4s_use:int = 0;
		[Inline]
		private function _getVect4():Vector.<Number>
		{
			if (_Vect4s.length > _Vect4s_use)
			{
				_Vect4s_use++;
				return _Vect4s[_Vect4s_use-1];
			}
			return _Vect4s[_Vect4s.length]=new Vector.<Number>( 4, true );
		}

		public override function flush():void
		{
			finish();
		}
		
		public override function finish():void
		{
			_Vect4s_use = _Vect16s_use = 0;
			// RenderTarget状态，无需Present
			if ( _activeFrameBuffer != null ) {
				return;
			}
			_context3D.present();
			
		}
		
		public override function blendFunc(sfactor:*, dfactor:*):void {
			_context3D.setBlendFactors( _blendV[sfactor], _blendV[dfactor] );
			WebGLContext._sFactor = sfactor;
			WebGLContext._dFactor = dfactor;
		}

		public override function createShader(type:*):*
		{
			return new FlashGlShader(type);
		}
		
		public override function createProgram():*
		{
			var p : ProgramObject = new ProgramObject();
			p.program = _context3D.createProgram();
			return p;
		}
		
		public override function deleteProgram(program:*):void{
			(program as ProgramObject).dispose();
		}
		
		
		public override function attachShader(program:*, shader:*):void {
			_program = program;	
			if ( shader.stype == WebGLContext.VERTEX_SHADER ) {
				_vsShader = shader.compiledObj;
				return;
			}
			if ( shader.stype == WebGLContext.FRAGMENT_SHADER ) {
				_psShader = shader.compiledObj;
				return;
			}
			
			throw new Error( "Not supported shader type..." );
		}
		
		private function updateVP() : void {
			RenderState2D.width = _vpWidth;
			RenderState2D.height = _vpHeight;
			_bUpdateVP = false;
		}
		
		
		public override function useProgram(program:*):void {
			if ( _bUpdateVP ) updateVP();
			if ( (_program == program)&&(_program.deviceset) ) return;
		    			
			if ( _lactPro ) {
			    // 重设上一个Progame对应的顶点缓冲区为null	
				var i : int;
				for ( i = 0; i < _lactPro.maxVa; i ++ ) 
					_context3D.setVertexBufferAt( i, null );
				
				_lactPro.deviceset = false;
			}
			// 把多出来的纹理单元设置为null.
			for ( i = _csetMaxTex -1; i >= (program as ProgramObject).maxTex; i -- )
				_context3D.setTextureAt( i, null );
			
			// 重设SampleSate.
			TextureObject.clearSampler();		
			
			_context3D.setProgram( (program as ProgramObject).program );			
			_program = program;
			_lactPro = _program;
			
			// 设置当前Progame内自带的Shader状态.
			for ( var c : * in _program.stateSet ) {
				var vec : Vector.<Number> = _program.stateSet[c];
				_context3D.setProgramConstantsFromVector( _getUniformType(c), _getLocIdx(c), vec, 1 );
			}			
			
			// 设置编译相关的常量.
			_vsShader = _program.vsShader;
			_psShader = _program.psShader;
			_setShaderConstant();
			
			_program.deviceset = true;
		}
		
		/**
		 * 从编译后的数据中得到某一类寄存器数据的最大数目.
		 * @param _varname
		 * @param _char1  由两个字符来确认Shader寄存器的类型
		 * @param _char2 
		 * @return
		 */
		[Inline]
		private function _getMaxReg( _varname : Object,_char1 : int,_char2 : int ) : int {
			var maxi : int = 0;
			for ( var v : * in _varname ) {
				var str : String = _varname[v];
				if ( (str.charCodeAt(0) === _char1) && (str.charCodeAt(1) === _char2) ) {
					var ti : int = _getLocIdx( str );
					if ( (ti + 1) > maxi ) maxi = ti + 1;
				}
			}
			return maxi;
		}
		
		public override function linkProgram(program:*):void {
			// uploadProgram.
			if ( program && _vsShader && _psShader ) {
				var vsa : AGALMiniAssembler = new AGALMiniAssembler();
				var fsa : AGALMiniAssembler = new AGALMiniAssembler();
				
				_webGLStatus[WebGLContext.LINK_STATUS] = 0;
				
				// 这个必须在运行中编译.
				var vsaArray : ByteArray ;
				var fsaArray : ByteArray ;
				try{
					vsaArray = vsa.assemble( Context3DProgramType.VERTEX, _vsShader.agalasm );
					fsaArray = fsa.assemble( Context3DProgramType.FRAGMENT, _psShader.agalasm );
				}catch ( _e : Error ) {
					trace( "Compile shader Error:" + _e );	
					//m_lastError = _e;
					return;
				}
				
				var p : ProgramObject = program as ProgramObject;
				// va 对应VertexBuffer:
				p.maxVa = _getMaxReg( _vsShader.varnames, 118, 97 );
				// fs 对应纹理设置单元:
				p.maxTex = _getMaxReg( _vsShader.varnames, 102, 115 );
				p.program.upload( vsaArray, fsaArray );
				p.vsShader = _vsShader;
				p.psShader = _psShader;
				_webGLStatus[WebGLContext.LINK_STATUS] = 1;
			}
		}
		
		public override function getAttribLocation(program:*, name:String): * {			
			return (program as ProgramObject).vsShader.varnames[name];
		}
		
		/**
		 * 这个名字必须从vs和ps里都查找一份
		 * @param	program
		 * @param	name
		 * @return
		 */
		public override function getUniformLocation(program:*, name:String):*
		{
			var str : String = null;
			str = (program as ProgramObject).vsShader.varnames[name];
			if ( str ) return str;
			str = (program as ProgramObject).psShader.varnames[name];
			return str;
		}

		public override function shaderSource(shader:*, source:*):void
		{
			shader.source=source;
		}
		
		public override function compileShader(shader:*):void
		{
			var compiledObj : Object;			
			if ( shader.stype == WebGLContext.VERTEX_SHADER ) {
				shader.source = (shader.source as String).replace( "u_mmat2*", "" );
				compiledObj = JSON.parse(com.adobe.glsl2agal.compileShader( shader.source, 0, true,true ));	
			}else {
				compiledObj = JSON.parse(com.adobe.glsl2agal.compileShader( shader.source, 1, true,true ));	
			}
			
			// TEST CODE for shader:
			//compiledObj.glslsource = shader.source;
			
			shader.compiledObj = compiledObj;
		}
		
		public override function enableVertexAttribArray(index:int):void
		{
			//throw "no";
		}
		
		public override function createBuffer():*
		{
			return null;
		}
		
		public override function deleteBuffer(buffer:*):void{
			throw "no";
		}		
		
		public override function bindBuffer(target:*, buffer:*):void {
			if ( buffer == null && target == ARRAY_BUFFER  ){
				_activeVBuf = null;
				return;
			}
			var tbuf : Buffer = buffer as Buffer;
			tbuf.bufferType == WebGLContext.ELEMENT_ARRAY_BUFFER?(_activeIBuf=tbuf as FlashIndexBuffer):(_activeVBuf=tbuf as FlashVertexBuffer);
		}
		
		/**
		 * 辅助函数： 传入字符串，返回Location的索引.
		 * @param	_loc
		 * @return
		 */
		private static var _LocDic:Dictionary = new Dictionary();
		[Inline]
		private function _getLocIdx( _loc : String ) : int {
			var r: * = _LocDic[_loc];
			if (r!=null) return int(r);
			return _LocDic[_loc]=int(_loc.substr( 2 ));
		}
		/**
		 * 辅助函数：返回uniform类型.
		 * @param	_u
		 * @return
		 */
		[Inline]
		private function _getUniformType( _u : String ) : String {
			var c:int = _u.charCodeAt(0);//118 v 102 f
			if(c===118) return Context3DProgramType.VERTEX;
			if(c===102) return Context3DProgramType.FRAGMENT;
			return null;
		}
		
		/**
		 * 设置编译后Object的相关常量.GLSL自动化编译后对应的Constant常量.
		 */
		private function _setShaderConstant() : void {			
            var c:String;
            var constval:Array;
            for(c in _vsShader.consts) {
                constval = _vsShader.consts[c];
				var vec : Vector.<Number> = _getVect4();
				vec[0] = constval[0];
				vec[1] = constval[1];
				vec[2] = constval[2];
				vec[3] = constval[3];
                _context3D.setProgramConstantsFromVector( Context3DProgramType.VERTEX, _getLocIdx( c ), vec );
            }    
            for(c in _psShader.consts) {
                constval = _psShader.consts[c];
				var vec1 : Vector.<Number> = _getVect4();
				vec1[0] = constval[0];
				vec1[1] = constval[1];
				vec1[2] = constval[2];
				vec1[3] = constval[3];				
                _context3D.setProgramConstantsFromVector( Context3DProgramType.FRAGMENT, _getLocIdx( c ), vec1 );
            }			
		}		
		
		public override function vertexAttribPointer(indx:*, size:*, type:*, normalized:*, stride:*, offset:int):void
		{
			if ( _program == null || _activeVBuf == null ) {
				//trace( "Null program or vertex buffer..." );
				return;
			}

			//由size&type决定了最终的长度.
			var fStr : String = null;
			if ( type == WebGLContext.FLOAT ) 
				fStr = _Context3DVertexBufferFormat[size];

			_context3D.setVertexBufferAt( _getLocIdx(indx), _activeVBuf._flashGLBuff , offset, fStr );
		}

		private static var tmpMat : Matrix3D = new Matrix3D;
		public override function uniformMatrix4fv(location:*, transpose:*, value:*):void
		{
			if ( !location ) return;
			var _vect16 : Vector.<Number> = _getVect16();
			for ( var i : int = 0; i < 16; i ++ ) {
				_vect16[i] = value[i];
			}
			//_context3D.setProgramConstantsFromVector( _getUniformType( location ), _getLocIdx( location), _vect16, 4 );
			tmpMat.rawData = _vect16;
			// ATTENTION TO FIX: 必须转置，数据看不需要转置，确认原因!!!!]
			var ty : String = _getUniformType( location );
			var transp : Boolean = true;
			if ( ty == Context3DProgramType.FRAGMENT ) transp = false;
			_context3D.setProgramConstantsFromMatrix( ty, _getLocIdx( location), tmpMat,transp );
		}

		[Inline]
		private function _uniform4(location:*, x:Number, y:Number, z:Number, w:Number):void
		{
			if ( !location ) return;	
			// 加入当前Program相关的Cache
			var tvec : Vector.<Number>;
			if ( _program.inSCache ) {
				tvec = new Vector.<Number>(4, true );
				tvec[0] = x;
				tvec[1] = y;
				tvec[2] = z;
				tvec[3] = w;				
				_program.stateSet[location] = tvec;
			}

			tvec = _program.stateSet[location];
			tvec[0] = x;
			tvec[1] = y;
			tvec[2] = z;
			tvec[3] = w;			
			_context3D.setProgramConstantsFromVector( _getUniformType(location), _getLocIdx(location), tvec, 1 );
		}

		public override function uniform1i(location:*, x:Number):void
		{
			// 如果对应fs0-8的纹理寄存器，则不能设置.
			var str : String = location as String;
			if ( (str.charCodeAt( 0 ) == 102) && (str.charCodeAt(1) == 115 ) ) return;
			
			_uniform4(location, x,0,0,0);
		}
		public override function uniform1iv(location:*, v:*):void{
			
		}
		
		
		public override function uniform1f(location:*, x:Number):void
		{
			_uniform4(location, x,0,0,0);
		}
		
		public override function uniform1fv(location:*, v:*):void
		{
			//uniform4f(location, v, 0, 0, 0);
			var tba : ByteArray = new ByteArray();
			var tv : Array = v as Array;
			var len : int = tv.length;
			for ( var ti:int = 0; ti < len; ti ++ )
				tba.writeFloat( tv[ti] );
			_context3D.setProgramConstantsFromByteArray( _getUniformType(location), _getLocIdx(location), len / 4, tba, 0 );
		}
		
		public override function uniform2f(location:*, x:Number, y:Number):void
		{
			uniform4f(location, x, y, 0, 0);
		}
		
		public override function uniform3f(location:*, x:Number, y:Number, z:Number):void
		{
			uniform4f(location, x, y, 1, 0);
		}
		
		public override function uniform4f(location:*, x:Number, y:Number, z:Number, w:Number):void
		{
			if ( !location ) return;
			var tvec : Vector.<Number> = null;
			if ( _program.inSCache ) {
				tvec = new Vector.<Number>(4, true );
				_program.stateSet[location] = tvec;
			}			
			tvec = _program.stateSet[location];
			tvec[0] = x;
			tvec[1] = y;
			tvec[2] = z;
			tvec[3] = w;				
			_context3D.setProgramConstantsFromVector( _getUniformType(location), _getLocIdx(location), tvec, 1 );
		}		
		
		public override function drawArrays(mode:*, first:int, count:int):void{
			throw "no";
		}
		public override function drawElements(mode:*, count:int, type:*, offset:int):void {
			if ( (_activeVBuf == null) || (!_nInitTex) ) {
				return;
			}
			
			if ( _stencilEnable )
				_setStencilState();
			// 如果已经存在索引缓冲区，直接Draw.
			switch( mode ) {
				case WebGLContext.TRIANGLES:
					_program.inSCache = false;
					_context3D.drawTriangles( _activeIBuf._flashGLBuff, offset, count / 3 );
					return;
				default:
					throw ("Not Support DrawMode" + mode);
			}
		}
		
		/**
		 * 设置当前要激活的纹理单元索引，真正设置纹理需要BindTexture函数
		 * @param	texture
		 */
		public override function activeTexture(texture:*):void
		{			
			_actTexUnit = texture - WebGLContext.TEXTURE0;
			_useTexture[_actTexUnit] = true;
		}
		
		private var _nInitTex : Boolean = true;
		private static var _useTexture : Vector.<Boolean> = new Vector.<Boolean>(8);
		public override function useTexture(value:Boolean):void
		{
			if (!value && _useTexture[_actTexUnit])
			{
				_context3D.setTextureAt( _actTexUnit, null);
			}
			
			if ( value && (!_useTexture[_actTexUnit]) ) {
				var texObj : TextureObject = _activeTex[WebGLContext.TEXTURE_2D] as TextureObject;
				_context3D.setTextureAt(_actTexUnit, texObj.texture );
				_nInitTex = texObj.dinit;
				_csetMaxTex = _actTexUnit + 1;
				texObj.setTexSamplerState( _actTexUnit );				
			}
			_useTexture[_actTexUnit] = value;
		}
		

		private var _activeTex:*= { };
		/**
		 * 
		 * @param	target  两种类型的参数：gl.TEXTURE_2D gl.TEXTURE_CUBE_MAP
		 * @param	texture  
		 */
		public override function bindTexture(target:*, texture:*):void
		{
			_activeTex[target] = texture;			
			_context3D.setTextureAt(_actTexUnit, (texture as TextureObject).texture );
			_nInitTex = (texture as TextureObject).dinit;
			_csetMaxTex = _actTexUnit + 1;
			(texture as TextureObject).setTexSamplerState( _actTexUnit );			
		}
		
		private var _tmpRec : Rectangle = new Rectangle();
		private var _tba : ByteArray = new ByteArray();
		private var _mat : Matrix = new Matrix();
		// 填充纹理Mipmap
		private var _matrix : Matrix = new Matrix();						
		private var _rect : Rectangle = new Rectangle();
		
		public override function texImage2D(... args):void {
			var tex : TextureObject = _activeTex[args[0]];
			if ( !tex ) 
				throw "Not Active texture set to Device...";
		
			var tbi : Bitmap;
			var devTex : Texture;
			var bdata : BitmapData;
			var fbi : BitmapData;
			
			var fwi : int;
			var fhe : int;
						
			// ATTENTION TO OPP:			
			_tba.endian = Endian.LITTLE_ENDIAN;
			_tba.length = 0;
			switch(args.length)
			{
				case 9:					
					//_context3D.setTextureAt( 0, tex );			
					// 从ByteArray上传纹理
					if (args[8]  is ByteArray ) {
						devTex = tex.getTexFromSize( args[3], args[4] );
						devTex.uploadFromByteArray( args[8], 0);
						tex.dinit = true;
					}
					else if ( args[8] is FlashImage ) {
						tbi = (args[5] as FlashImage).bitmap;					
						devTex = tex.getTexFromSize( tbi.width, tbi.height );	
						fwi = tex.width;
						fhe = tex.height;
						
						// ATTENTION TO OPP: 能否找到更加合理的方式?
						_tmpRec.width = fwi;
						_tmpRec.height = fhe;
						bdata = tbi.bitmapData;
						if ( (fwi != bdata.width) || (fhe != bdata.height) ) {
							fbi = new BitmapData( fwi, fhe,true,0 );
							_mat.identity();
							_mat.a = fwi / bdata.width;
							_mat.d = fhe / bdata.height;
							fbi.draw( bdata, _mat,null,null,null,false );
							bdata = fbi;
						}												
						_tba.length = fwi * 4 * fhe;
						bdata.copyPixelsToByteArray( _tmpRec, _tba );
						devTex.uploadFromByteArray( _tba, 0 );
						tex.dinit = true;
					} else if ( args[8] == null ) {
						devTex = tex.getTexFromSize( args[3], args[4] );
					}else {
						// 
					}
					return;
				case 6:
					if ( args[5] is FlashImage ) {
						tbi = (args[5] as FlashImage).bitmap;
						devTex = tex.getTexFromSize( tbi.width, tbi.height );	
						fwi = tex.width;
						fhe = tex.height;
						
						// ATTENTION TO OPP:
						_tmpRec.width = fwi;
						_tmpRec.height = fhe;
						bdata = tbi.bitmapData;					
						if ( (fwi != bdata.width) || (fhe != bdata.height) ) {
							fbi = new BitmapData( fwi, fhe,true,0 );
							_mat.identity();
							_mat.a = fwi / bdata.width;
							_mat.d = fhe / bdata.height;
							fbi.draw( bdata, _mat,null,null,null,false );
							bdata = fbi;
						}						
						_tba.length = fwi * 4 * fhe;
						bdata.copyPixelsToByteArray( _tmpRec, _tba );				
						devTex.uploadFromByteArray( _tba, 0 );
						tex.dinit = true;
						break;
						if ( fwi < 1024 ) break;					
						// Generate Mipmap:
						// 目前暂只有超过1024 Size的Texture生成MipMap 
						var w : uint = fwi;
						var	h : uint = fhe;
						var i : uint = 1;
						var mipmap : BitmapData = new BitmapData(w, h, true);
						w >>= 1;
						h >>= 1;
						_rect.width = w;				
						_rect.height = h;
						while (w >= 1 || h >= 1) {
							_matrix.a = _rect.width/fwi;
							_matrix.d = _rect.height / fhe;
							mipmap.fillRect( _rect, 0);				
							mipmap.draw(bdata, _matrix, null, null, null, false );							
							devTex.uploadFromBitmapData(mipmap, i);
							i ++;
							w >>= 1;
							h >>= 1;

							_rect.width = w > 1? w : 1;
							_rect.height = h > 1? h : 1;
						}	
						
						mipmap.dispose();
						mipmap = null;
					}
				default:
					break;
			}
		}
		
		public override function texParameterf(target:*, pname:*, param:*):void{
			
		}
		
		public override function texParameteri(target:*, pname:*, param:*):void{
			(_activeTex[target] as TextureObject).addTexParameteri( pname, param );
		}
		
		public override function texSubImage2D(... args):void{
			
		}		

		/**
		 * River: Stage3D没有严格意义的ViewPort概念，这是一个比较麻烦的地方,主要是RenderToTexture会有一些麻烦.
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public override function viewport(x:Number, y:Number, width:Number, height:Number):void { 
			// 需要修改全局可以设置size的位置
			_vpWidth = width;
			_vpHeight = height;
			_bUpdateVP = true;
		}	
		
		/**
		 * 底层会维护一个FrameBufferObj.
		 * @return
		 */
		public override function createFramebuffer():*{
			return new FrameBuffObj();
		}
		
		/**
		 * 真正的资源删除操作在Texture内
		 * @param	framebuffer
		 */
		public override function deleteFramebuffer(framebuffer:*):void{
			(framebuffer as FrameBuffObj).texture = null;
		}
		

		public override function bindFramebuffer(target:*, framebuffer:*):void {
			if ( target != WebGLContext.FRAMEBUFFER ) throw Error( "Error Para..." );
			if ( (framebuffer == null) && (_activeFrameBuffer != null) ) 
				_activeFrameBuffer.texture.dinit = true;
			
			this._activeFrameBuffer = framebuffer;
			if ( framebuffer == null ) {
				_context3D.setRenderToBackBuffer();
				return;
			}
			var fbuf : FrameBuffObj = framebuffer as FrameBuffObj;
			if ( fbuf.texture != null ) {
				_context3D.setRenderToTexture( fbuf.texture.texture );					
				if ( _bUpdateVP ) updateVP();
				WebGLContext._sFactor = WebGLContext.SRC_ALPHA;
				WebGLContext._dFactor = WebGLContext.ONE_MINUS_SRC_ALPHA;
			}
		}
		
		/**
		 * 
		 * @param	target
		 * @param	internalformat
		 * @param	width
		 * @param	height
		 */
		public override function renderbufferStorage(target:*, internalformat:*, width:Number, height:Number):void{
			// Do Nothing NOW
		}
		
		/**
		 * 把FrameBuffer和Texture关联起来
		 * @param	target
		 * @param	attachment
		 * @param	textarget
		 * @param	texture
		 * @param	level
		 */
		public override function framebufferTexture2D(target:*, attachment:*, textarget:*, texture:*, level:*):void{
			// 前三个参数暂不处理，只处理第4个参数			
			if ( _activeFrameBuffer == null ) return;
			
			_activeFrameBuffer.texture = texture;			
		}
		
		
		
		public override function createTexture():*{
			return new TextureObject();
		}
		/**
		 * 删除纹理对应的设备相关数据
		 * @param	texture
		 */
		public override function deleteTexture(texture:*):void{
			(texture as TextureObject).dispose();
		}
		
		/**
		 * Shader精度
		 * @param	...arg
		 * @return
		 */
		public override function getShaderPrecisionFormat(...arg): * {
			var tobj : Object = { };
			tobj.precision = true;
			return tobj;
		}
		
		
	}

}

import laya.webgl.WebGLContext;

class stencilState {
	public var faceSta : uint = WebGLContext.FRONT_AND_BACK;
	// clearStencil Value.
	public var clearMask : int = 0;
	// clear function.
	public var clearBuff : Boolean = false;
	
	// stencil ref val & refMask & refWriteMask. 默认的mask都是0xff,全部位通过.
	public var refVal : uint = 0;
	public var refMask : uint = 0xff;
	public var refWriteMask : uint = 0xff;
	// Stencil func.
	public var funcID : int = WebGLContext.ALWAYS;
	
	// stencil OP.
	public var dpass_sfail : int = WebGLContext.KEEP;
	public var dfail : int = WebGLContext.KEEP;
	public var bothpass : int = WebGLContext.KEEP;
	
	/**
	 * 用于separate set的数据重置
	 */
	public function reset() : void {
		faceSta = WebGLContext.FRONT_AND_BACK;
		clearMask = 0;
		clearBuff = false;
		refVal = 0;
		refMask = 0xff;
		funcID = WebGLContext.ALWAYS;
		dpass_sfail = WebGLContext.KEEP;
		dfail = WebGLContext.KEEP;
		bothpass = WebGLContext.KEEP;
	}
}