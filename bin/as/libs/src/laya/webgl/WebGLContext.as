package laya.webgl
{
	
	public class WebGLContext
	{
		public static const DEPTH_BUFFER_BIT:int = 0x00000100;
		public static const STENCIL_BUFFER_BIT:int = 0x00000400;
		public static const COLOR_BUFFER_BIT:int = 0x00004000;
		public static const POINTS:int = 0x0000;
		public static const LINES:int = 0x0001;
		public static const LINE_LOOP:int = 0x0002;
		public static const LINE_STRIP:int = 0x0003;
		public static const TRIANGLES:int = 0x0004;
		public static const TRIANGLE_STRIP:int = 0x0005;
		public static const TRIANGLE_FAN:int = 0x0006;
		public static const ZERO:int = 0;
		public static const ONE:int = 1;
		public static const SRC_COLOR:int = 0x0300;
		public static const ONE_MINUS_SRC_COLOR:int = 0x0301;
		public static const SRC_ALPHA:int = 0x0302;
		public static const ONE_MINUS_SRC_ALPHA:int = 0x0303;
		public static const DST_ALPHA:int = 0x0304;
		public static const ONE_MINUS_DST_ALPHA:int = 0x0305;
		public static const DST_COLOR:int = 0x0306;
		public static const ONE_MINUS_DST_COLOR:int = 0x0307;
		public static const SRC_ALPHA_SATURATE:int = 0x0308;
		public static const FUNC_ADD:int = 0x8006;
		public static const BLEND_EQUATION:int = 0x8009;
		public static const BLEND_EQUATION_RGB:int = 0x8009;
		public static const BLEND_EQUATION_ALPHA:int = 0x883D;
		public static const FUNC_SUBTRACT:int = 0x800A;
		public static const FUNC_REVERSE_SUBTRACT:int = 0x800B;
		public static const BLEND_DST_RGB:int = 0x80C8;
		public static const BLEND_SRC_RGB:int = 0x80C9;
		public static const BLEND_DST_ALPHA:int = 0x80CA;
		public static const BLEND_SRC_ALPHA:int = 0x80CB;
		public static const CONSTANT_COLOR:int = 0x8001;
		public static const ONE_MINUS_CONSTANT_COLOR:int = 0x8002;
		public static const CONSTANT_ALPHA:int = 0x8003;
		public static const ONE_MINUS_CONSTANT_ALPHA:int = 0x8004;
		public static const BLEND_COLOR:int = 0x8005;
		public static const ARRAY_BUFFER:int = 0x8892;
		public static const ELEMENT_ARRAY_BUFFER:int = 0x8893;
		public static const ARRAY_BUFFER_BINDING:int = 0x8894;
		public static const ELEMENT_ARRAY_BUFFER_BINDING:int = 0x8895;
		public static const STREAM_DRAW:int = 0x88E0;
		public static const STATIC_DRAW:int = 0x88E4;
		public static const DYNAMIC_DRAW:int = 0x88E8;
		public static const BUFFER_SIZE:int = 0x8764;
		public static const BUFFER_USAGE:int = 0x8765;
		public static const CURRENT_VERTEX_ATTRIB:int = 0x8626;
		public static const FRONT:int = 0x0404;
		public static const BACK:int = 0x0405;
		public static const CULL_FACE:int = 0x0B44;
		public static const FRONT_AND_BACK:int = 0x0408;
		public static const BLEND:int = 0x0BE2;
		public static const DITHER:int = 0x0BD0;
		public static const STENCIL_TEST:int = 0x0B90;
		public static const DEPTH_TEST:int = 0x0B71;
		public static const SCISSOR_TEST:int = 0x0C11;
		public static const POLYGON_OFFSET_FILL:int = 0x8037;
		public static const SAMPLE_ALPHA_TO_COVERAGE:int = 0x809E;
		public static const SAMPLE_COVERAGE:int = 0x80A0;
		public static const NO_ERROR:int = 0;
		public static const INVALID_ENUM:int = 0x0500;
		public static const INVALID_VALUE:int = 0x0501;
		public static const INVALID_OPERATION:int = 0x0502;
		public static const OUT_OF_MEMORY:int = 0x0505;
		public static const CW:int = 0x0900;
		public static const CCW:int = 0x0901;
		public static const LINE_WIDTH:int = 0x0B21;
		public static const ALIASED_POINT_SIZE_RANGE:int = 0x846D;
		public static const ALIASED_LINE_WIDTH_RANGE:int = 0x846E;
		public static const CULL_FACE_MODE:int = 0x0B45;
		public static const FRONT_FACE:int = 0x0B46;
		public static const DEPTH_RANGE:int = 0x0B70;
		public static const DEPTH_WRITEMASK:int = 0x0B72;
		public static const DEPTH_CLEAR_VALUE:int = 0x0B73;
		public static const DEPTH_FUNC:int = 0x0B74;
		public static const STENCIL_CLEAR_VALUE:int = 0x0B91;
		public static const STENCIL_FUNC:int = 0x0B92;
		public static const STENCIL_FAIL:int = 0x0B94;
		public static const STENCIL_PASS_DEPTH_FAIL:int = 0x0B95;
		public static const STENCIL_PASS_DEPTH_PASS:int = 0x0B96;
		public static const STENCIL_REF:int = 0x0B97;
		public static const STENCIL_VALUE_MASK:int = 0x0B93;
		public static const STENCIL_WRITEMASK:int = 0x0B98;
		public static const STENCIL_BACK_FUNC:int = 0x8800;
		public static const STENCIL_BACK_FAIL:int = 0x8801;
		public static const STENCIL_BACK_PASS_DEPTH_FAIL:int = 0x8802;
		public static const STENCIL_BACK_PASS_DEPTH_PASS:int = 0x8803;
		public static const STENCIL_BACK_REF:int = 0x8CA3;
		public static const STENCIL_BACK_VALUE_MASK:int = 0x8CA4;
		public static const STENCIL_BACK_WRITEMASK:int = 0x8CA5;
		public static const VIEWPORT:int = 0x0BA2;
		public static const SCISSOR_BOX:int = 0x0C10;
		public static const COLOR_CLEAR_VALUE:int = 0x0C22;
		public static const COLOR_WRITEMASK:int = 0x0C23;
		public static const UNPACK_ALIGNMENT:int = 0x0CF5;
		public static const PACK_ALIGNMENT:int = 0x0D05;
		public static const MAX_TEXTURE_SIZE:int = 0x0D33;
		public static const MAX_VIEWPORT_DIMS:int = 0x0D3A;
		public static const SUBPIXEL_BITS:int = 0x0D50;
		public static const RED_BITS:int = 0x0D52;
		public static const GREEN_BITS:int = 0x0D53;
		public static const BLUE_BITS:int = 0x0D54;
		public static const ALPHA_BITS:int = 0x0D55;
		public static const DEPTH_BITS:int = 0x0D56;
		public static const STENCIL_BITS:int = 0x0D57;
		public static const POLYGON_OFFSET_UNITS:int = 0x2A00;
		public static const POLYGON_OFFSET_FACTOR:int = 0x8038;
		public static const TEXTURE_BINDING_2D:int = 0x8069;
		public static const SAMPLE_BUFFERS:int = 0x80A8;
		public static const SAMPLES:int = 0x80A9;
		public static const SAMPLE_COVERAGE_VALUE:int = 0x80AA;
		public static const SAMPLE_COVERAGE_INVERT:int = 0x80AB;
		public static const NUM_COMPRESSED_TEXTURE_FORMATS:int = 0x86A2;
		public static const COMPRESSED_TEXTURE_FORMATS:int = 0x86A3;
		public static const DONT_CARE:int = 0x1100;
		public static const FASTEST:int = 0x1101;
		public static const NICEST:int = 0x1102;
		public static const GENERATE_MIPMAP_HINT:int = 0x8192;
		public static const BYTE:int = 0x1400;
		public static const UNSIGNED_BYTE:int = 0x1401;
		public static const SHORT:int = 0x1402;
		public static const UNSIGNED_SHORT:int = 0x1403;
		public static const INT:int = 0x1404;
		public static const UNSIGNED_INT:int = 0x1405;
		public static const FLOAT:int = 0x1406;
		public static const DEPTH_COMPONENT:int = 0x1902;
		public static const ALPHA:int = 0x1906;
		public static const RGB:int = 0x1907;
		public static const RGBA:int = 0x1908;
		public static const LUMINANCE:int = 0x1909;
		public static const LUMINANCE_ALPHA:int = 0x190A;
		public static const UNSIGNED_SHORT_4_4_4_4:int = 0x8033;
		public static const UNSIGNED_SHORT_5_5_5_1:int = 0x8034;
		public static const UNSIGNED_SHORT_5_6_5:int = 0x8363;
		public static const FRAGMENT_SHADER:int = 0x8B30;
		public static const VERTEX_SHADER:int = 0x8B31;
		public static const MAX_VERTEX_ATTRIBS:int = 0x8869;
		public static const MAX_VERTEX_UNIFORM_VECTORS:int = 0x8DFB;
		public static const MAX_VARYING_VECTORS:int = 0x8DFC;
		public static const MAX_COMBINED_TEXTURE_IMAGE_UNITS:int = 0x8B4D;
		public static const MAX_VERTEX_TEXTURE_IMAGE_UNITS:int = 0x8B4C;
		public static const MAX_TEXTURE_IMAGE_UNITS:int = 0x8872;
		public static const MAX_FRAGMENT_UNIFORM_VECTORS:int = 0x8DFD;
		public static const SHADER_TYPE:int = 0x8B4F;
		public static const DELETE_STATUS:int = 0x8B80;
		public static const LINK_STATUS:int = 0x8B82;
		public static const VALIDATE_STATUS:int = 0x8B83;
		public static const ATTACHED_SHADERS:int = 0x8B85;
		public static const ACTIVE_UNIFORMS:int = 0x8B86;
		public static const ACTIVE_ATTRIBUTES:int = 0x8B89;
		public static const SHADING_LANGUAGE_VERSION:int = 0x8B8C;
		public static const CURRENT_PROGRAM:int = 0x8B8D;
		public static const NEVER:int = 0x0200;
		public static const LESS:int = 0x0201;
		public static const EQUAL:int = 0x0202;
		public static const LEQUAL:int = 0x0203;
		public static const GREATER:int = 0x0204;
		public static const NOTEQUAL:int = 0x0205;
		public static const GEQUAL:int = 0x0206;
		public static const ALWAYS:int = 0x0207;
		public static const KEEP:int = 0x1E00;
		public static const REPLACE:int = 0x1E01;
		public static const INCR:int = 0x1E02;
		public static const DECR:int = 0x1E03;
		public static const INVERT:int = 0x150A;
		public static const INCR_WRAP:int = 0x8507;
		public static const DECR_WRAP:int = 0x8508;
		public static const VENDOR:int = 0x1F00;
		public static const RENDERER:int = 0x1F01;
		public static const VERSION:int = 0x1F02;
		public static const NEAREST:int = 0x2600;
		public static const LINEAR:int = 0x2601;
		public static const NEAREST_MIPMAP_NEAREST:int = 0x2700;
		public static const LINEAR_MIPMAP_NEAREST:int = 0x2701;
		public static const NEAREST_MIPMAP_LINEAR:int = 0x2702;
		public static const LINEAR_MIPMAP_LINEAR:int = 0x2703;
		public static const TEXTURE_MAG_FILTER:int = 0x2800;
		public static const TEXTURE_MIN_FILTER:int = 0x2801;
		public static const TEXTURE_WRAP_S:int = 0x2802;
		public static const TEXTURE_WRAP_T:int = 0x2803;
		public static const TEXTURE_2D:int = 0x0DE1;
		public static const TEXTURE:int = 0x1702;
		public static const TEXTURE_CUBE_MAP:int = 0x8513;
		public static const TEXTURE_BINDING_CUBE_MAP:int = 0x8514;
		public static const TEXTURE_CUBE_MAP_POSITIVE_X:int = 0x8515;
		public static const TEXTURE_CUBE_MAP_NEGATIVE_X:int = 0x8516;
		public static const TEXTURE_CUBE_MAP_POSITIVE_Y:int = 0x8517;
		public static const TEXTURE_CUBE_MAP_NEGATIVE_Y:int = 0x8518;
		public static const TEXTURE_CUBE_MAP_POSITIVE_Z:int = 0x8519;
		public static const TEXTURE_CUBE_MAP_NEGATIVE_Z:int = 0x851A;
		public static const MAX_CUBE_MAP_TEXTURE_SIZE:int = 0x851C;
		public static const TEXTURE0:int = 0x84C0;
		public static const TEXTURE1:int = 0x84C1;
		public static const TEXTURE2:int = 0x84C2;
		public static const TEXTURE3:int = 0x84C3;
		public static const TEXTURE4:int = 0x84C4;
		public static const TEXTURE5:int = 0x84C5;
		public static const TEXTURE6:int = 0x84C6;
		public static const TEXTURE7:int = 0x84C7;
		public static const TEXTURE8:int = 0x84C8;
		public static const TEXTURE9:int = 0x84C9;
		public static const TEXTURE10:int = 0x84CA;
		public static const TEXTURE11:int = 0x84CB;
		public static const TEXTURE12:int = 0x84CC;
		public static const TEXTURE13:int = 0x84CD;
		public static const TEXTURE14:int = 0x84CE;
		public static const TEXTURE15:int = 0x84CF;
		public static const TEXTURE16:int = 0x84D0;
		public static const TEXTURE17:int = 0x84D1;
		public static const TEXTURE18:int = 0x84D2;
		public static const TEXTURE19:int = 0x84D3;
		public static const TEXTURE20:int = 0x84D4;
		public static const TEXTURE21:int = 0x84D5;
		public static const TEXTURE22:int = 0x84D6;
		public static const TEXTURE23:int = 0x84D7;
		public static const TEXTURE24:int = 0x84D8;
		public static const TEXTURE25:int = 0x84D9;
		public static const TEXTURE26:int = 0x84DA;
		public static const TEXTURE27:int = 0x84DB;
		public static const TEXTURE28:int = 0x84DC;
		public static const TEXTURE29:int = 0x84DD;
		public static const TEXTURE30:int = 0x84DE;
		public static const TEXTURE31:int = 0x84DF;
		public static const ACTIVE_TEXTURE:int = 0x84E0;
		public static const REPEAT:int = 0x2901;
		public static const CLAMP_TO_EDGE:int = 0x812F;
		public static const MIRRORED_REPEAT:int = 0x8370;
		public static const FLOAT_VEC2:int = 0x8B50;
		public static const FLOAT_VEC3:int = 0x8B51;
		public static const FLOAT_VEC4:int = 0x8B52;
		public static const INT_VEC2:int = 0x8B53;
		public static const INT_VEC3:int = 0x8B54;
		public static const INT_VEC4:int = 0x8B55;
		public static const BOOL:int = 0x8B56;
		public static const BOOL_VEC2:int = 0x8B57;
		public static const BOOL_VEC3:int = 0x8B58;
		public static const BOOL_VEC4:int = 0x8B59;
		public static const FLOAT_MAT2:int = 0x8B5A;
		public static const FLOAT_MAT3:int = 0x8B5B;
		public static const FLOAT_MAT4:int = 0x8B5C;
		public static const SAMPLER_2D:int = 0x8B5E;
		public static const SAMPLER_CUBE:int = 0x8B60;
		public static const VERTEX_ATTRIB_ARRAY_ENABLED:int = 0x8622;
		public static const VERTEX_ATTRIB_ARRAY_SIZE:int = 0x8623;
		public static const VERTEX_ATTRIB_ARRAY_STRIDE:int = 0x8624;
		public static const VERTEX_ATTRIB_ARRAY_TYPE:int = 0x8625;
		public static const VERTEX_ATTRIB_ARRAY_NORMALIZED:int = 0x886A;
		public static const VERTEX_ATTRIB_ARRAY_POINTER:int = 0x8645;
		public static const VERTEX_ATTRIB_ARRAY_BUFFER_BINDING:int = 0x889F;
		public static const COMPILE_STATUS:int = 0x8B81;
		public static const LOW_FLOAT:int = 0x8DF0;
		public static const MEDIUM_FLOAT:int = 0x8DF1;
		public static const HIGH_FLOAT:int = 0x8DF2;
		public static const LOW_INT:int = 0x8DF3;
		public static const MEDIUM_INT:int = 0x8DF4;
		public static const HIGH_INT:int = 0x8DF5;
		public static const FRAMEBUFFER:int = 0x8D40;
		public static const RENDERBUFFER:int = 0x8D41;
		public static const RGBA4:int = 0x8056;
		public static const RGB5_A1:int = 0x8057;
		public static const RGB565:int = 0x8D62;
		public static const DEPTH_COMPONENT16:int = 0x81A5;
		public static const STENCIL_INDEX:int = 0x1901;
		public static const STENCIL_INDEX8:int = 0x8D48;
		public static const DEPTH_STENCIL:int = 0x84F9;
		public static const RENDERBUFFER_WIDTH:int = 0x8D42;
		public static const RENDERBUFFER_HEIGHT:int = 0x8D43;
		public static const RENDERBUFFER_INTERNAL_FORMAT:int = 0x8D44;
		public static const RENDERBUFFER_RED_SIZE:int = 0x8D50;
		public static const RENDERBUFFER_GREEN_SIZE:int = 0x8D51;
		public static const RENDERBUFFER_BLUE_SIZE:int = 0x8D52;
		public static const RENDERBUFFER_ALPHA_SIZE:int = 0x8D53;
		public static const RENDERBUFFER_DEPTH_SIZE:int = 0x8D54;
		public static const RENDERBUFFER_STENCIL_SIZE:int = 0x8D55;
		public static const FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE:int = 0x8CD0;
		public static const FRAMEBUFFER_ATTACHMENT_OBJECT_NAME:int = 0x8CD1;
		public static const FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL:int = 0x8CD2;
		public static const FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE:int = 0x8CD3;
		public static const COLOR_ATTACHMENT0:int = 0x8CE0;
		public static const DEPTH_ATTACHMENT:int = 0x8D00;
		public static const STENCIL_ATTACHMENT:int = 0x8D20;
		public static const DEPTH_STENCIL_ATTACHMENT:int = 0x821A;
		public static const NONE:int = 0;
		public static const FRAMEBUFFER_COMPLETE:int = 0x8CD5;
		public static const FRAMEBUFFER_INCOMPLETE_ATTACHMENT:int = 0x8CD6;
		public static const FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:int = 0x8CD7;
		public static const FRAMEBUFFER_INCOMPLETE_DIMENSIONS:int = 0x8CD9;
		public static const FRAMEBUFFER_UNSUPPORTED:int = 0x8CDD;
		public static const FRAMEBUFFER_BINDING:int = 0x8CA6;
		public static const RENDERBUFFER_BINDING:int = 0x8CA7;
		public static const MAX_RENDERBUFFER_SIZE:int = 0x84E8;
		public static const INVALID_FRAMEBUFFER_OPERATION:int = 0x0506;
		public static const UNPACK_FLIP_Y_WEBGL:int = 0x9240;
		public static const UNPACK_PREMULTIPLY_ALPHA_WEBGL:int = 0x9241;
		public static const CONTEXT_LOST_WEBGL:int = 0x9242;
		public static const UNPACK_COLORSPACE_CONVERSION_WEBGL:int = 0x9243;
		public static const BROWSER_DEFAULT_WEBGL:int = 0x9244;
		
		
		public static var _useProgram:* = null;
		
		public static function UseProgram(program:*):Boolean
		{
			if (_useProgram === program) return false;
			WebGL.mainContext.useProgram(program);
			_useProgram = program;
			return true;
		}
		
		//潜在问题 WebGLContext为实例对象，以下渲染配置均属于实例对象，非静态
		public static var _depthTest:Boolean = true;
		public static var _depthMask:Boolean = true;
		public static var _depthFunc:int = WebGLContext.LESS; 
	
		public static var _blend:Boolean = false;
		public static var _sFactor:int =WebGLContext.ONE;//待确认
		public static var _dFactor:int =WebGLContext.ZERO;//待确认
		
		public static var _cullFace:Boolean = false;
		public static var _frontFace:int = WebGLContext.CCW;
		
		public static var curBindTexTarget:*;
		public static var curBindTexValue:*;
	
		public static function setDepthTest(gl:WebGLContext, value:Boolean):void
		{
			value !== _depthTest && (_depthTest=value, value?gl.enable(WebGLContext.DEPTH_TEST):gl.disable(WebGLContext.DEPTH_TEST));
		}
		
		public static function setDepthMask(gl:WebGLContext, value:Boolean):void
		{
			value !== _depthMask && (_depthMask=value, gl.depthMask(value));
		}
		
		public static function setDepthFunc(gl:WebGLContext, value:int):void
		{
			value !== _depthFunc && (_depthFunc=value, gl.depthFunc(value));
		}
		
		public static function setBlend(gl:WebGLContext, value:Boolean):void
		{
			value !== _blend && (_blend=value, value?gl.enable(WebGLContext.BLEND):gl.disable(WebGLContext.BLEND));
		}
		
		public static function setBlendFunc(gl:WebGLContext, sFactor:int, dFactor:int):void
		{
			(sFactor!==_sFactor||dFactor!==_dFactor) && (_sFactor=sFactor,_dFactor=dFactor,gl.blendFunc(sFactor, dFactor));
		}
		
		public static function setCullFace(gl:WebGLContext, value:Boolean):void
		{
			 value !== _cullFace && (_cullFace = value, value?gl.enable(WebGLContext.CULL_FACE):gl.disable(WebGLContext.CULL_FACE));
		}
		
		public static function setFrontFace(gl:WebGLContext, value:int):void
		{
			value !== _frontFace && (_frontFace = value, gl.frontFace(value));
		}
		
		public static function bindTexture(gl:WebGLContext,target:*, texture:*):void
		{
			gl.bindTexture(target, texture);
			curBindTexTarget = target;
			curBindTexValue = texture;
		}
	
		
		/*[IF-FLASH-BEGIN]*/
		public var alpha:Number = 0;
		public var depth:Number = 0;
		public var stencil:Number = 0;
		public var antialias:Number = 0;
		public var premultipliedAlpha:Number = 0;
		public var preserveDrawingBuffer:Number = 0;
		public var drawingBufferWidth:Number = 0;
		public var drawingBufferHeight:Number = 0;
		public var getAttachedShaders:*;
		public var uniform_float:*;
		
		public function getContextAttributes():*{return null;}
		
		public function isContextLost():void{}
		
		public function getSupportedExtensions():*{return null;}
		
		public function getExtension(name:String):*{return null;}
		
		public function activeTexture(texture:*):void{}
		
		public function attachShader(program:*, shader:*):void{}
		
		public function bindAttribLocation(program:*, index:int, name:String):void{}
		
		public function bindBuffer(target:*, buffer:*):void{}
		
		public function bindFramebuffer(target:*, framebuffer:*):void{}
		
		public function bindRenderbuffer(target:*, renderbuffer:*):void{}
		
		public function bindTexture(target:*, texture:*):void { }
		
		public function useTexture(value:Boolean):void{}
		
		public function blendColor(red:*, green:*, blue:*, alpha:Number):void{}
		
		public function blendEquation(mode:*):void{}
		
		public function blendEquationSeparate(modeRGB:*, modeAlpha:*):void{}
		
		public function blendFunc(sfactor:*, dfactor:*):void{}
		
		public function blendFuncSeparate(srcRGB:*, dstRGB:*, srcAlpha:*, dstAlpha:*):void{}
		
		public function bufferData(target:*, size:*, usage:*):void{}
		
		public function bufferSubData(target:*, offset:int, data:*):void{}
		
		public function checkFramebufferStatus(target:*):*{ return null; }
		
		public function clear(mask:uint):void{}
		
		public function clearColor(red:*, green:*, blue:*, alpha:Number):void{}
		
		public function clearDepth(depth:*):void{}
		
		public function clearStencil(s:*):void{}
		
		public function colorMask(red:Boolean, green:Boolean, blue:Boolean, alpha:Boolean):void{}
		
		public function compileShader(shader:*):void{}
		
		public function copyTexImage2D(target:*, level:*, internalformat:*, x:Number, y:Number, width:Number, height:Number, border:*):void{}
		
		public function copyTexSubImage2D(target:*, level:*, xoffset:int, yoffset:int, x:Number, y:Number, width:Number, height:Number):void{}
		
		public function createBuffer():*{}
		
		public function createFramebuffer():*{}
		
		public function createProgram():*{}
		
		public function createRenderbuffer():*{}
		
		public function createShader(type:*):*{}
		
		public function createTexture():*{return null}
		
		public function cullFace(mode:*):void{}
		
		public function deleteBuffer(buffer:*):void{}
		
		public function deleteFramebuffer(framebuffer:*):void{}
		
		public function deleteProgram(program:*):void{}
		
		public function deleteRenderbuffer(renderbuffer:*):void{}
		
		public function deleteShader(shader:*):void{}
		
		public function deleteTexture(texture:*):void{}
		
		public function depthFunc(func:*):void{}
		
		public function depthMask(flag:*):void{}
		
		public function depthRange(zNear:*, zFar:*):void{}
		
		public function detachShader(program:*, shader:*):void{}
		
		public function disable(cap:*):void{}
		
		public function disableVertexAttribArray(index:int):void{}
		
		public function drawArrays(mode:*, first:int, count:int):void{}
		
		public function drawElements(mode:*, count:int, type:*, offset:int):void{}
		
		public function enable(cap:*):void{}
		
		public function enableVertexAttribArray(index:int):void{}
		
		public function finish():void{}
		
		public function flush():void{}
		
		public function framebufferRenderbuffer(target:*, attachment:*, renderbuffertarget:*, renderbuffer:*):void{}
		
		public function framebufferTexture2D(target:*, attachment:*, textarget:*, texture:*, level:*):void{}
		
		public function frontFace(mode:*):*{return null;}
		
		public function generateMipmap(target:*):*{return null;}
		
		public function getActiveAttrib(program:*, index:int):*{return null;}
		
		public function getActiveUniform(program:*, index:int):*{return null;}
		
		public function getAttribLocation(program:*, name:String):*{return 0;}
		
		public function getParameter(pname:*):*{return null;}
		
		public function getBufferParameter(target:*, pname:*):*{return null;}
		
		public function getError():*{return null;}
		
		public function getFramebufferAttachmentParameter(target:*, attachment:*, pname:*):void{}
		
		public function getProgramParameter(program:*, pname:*):int{return 0;}
		
		public function getProgramInfoLog(program:*):*{return null;}
		
		public function getRenderbufferParameter(target:*, pname:*):*{return null; }
	
		public function getShaderPrecisionFormat(...arg):*{return null; }
		
		public function getShaderParameter(shader:*, pname:*):*{}
		
		public function getShaderInfoLog(shader:*):*{return null;}
		
		public function getShaderSource(shader:*):*{return null;}
		
		public function getTexParameter(target:*, pname:*):void{}
		
		public function getUniform(program:*, location:int):void{}
		
		public function getUniformLocation(program:*, name:String):*{return null;}
		
		public function getVertexAttrib(index:int, pname:*):*{return null;}
		
		public function getVertexAttribOffset(index:int, pname:*):*{return null;}
		
		public function hint(target:*, mode:*):void{}
		
		public function isBuffer(buffer:*):void{}
		
		public function isEnabled(cap:*):void{}
		
		public function isFramebuffer(framebuffer:*):void{}
		
		public function isProgram(program:*):void{}
		
		public function isRenderbuffer(renderbuffer:*):void{}
		
		public function isShader(shader:*):void{}
		
		public function isTexture(texture:*):void{}
		
		public function lineWidth(width:Number):void{}
		
		public function linkProgram(program:*):void{}
		
		public function pixelStorei(pname:*, param:*):void{}
		
		public function polygonOffset(factor:*, units:*):void{}
		
		public function readPixels(x:Number, y:Number, width:Number, height:Number, format:*, type:*, pixels:*):void{}
		
		public function renderbufferStorage(target:*, internalformat:*, width:Number, height:Number):void{}
		
		public function sampleCoverage(value:*, invert:*):void{}
		
		public function scissor(x:Number, y:Number, width:Number, height:Number):void{}
		
		public function shaderSource(shader:*, source:*):void{}
		
		public function stencilFunc(func:uint, ref:uint, mask:uint):void{}
		
		public function stencilFuncSeparate(face:uint, func:uint, ref:uint, mask:uint):void{}
		
		public function stencilMask(mask:*):void{}
		
		public function stencilMaskSeparate(face:*, mask:*):void{}
		
		public function stencilOp(fail:uint, zfail:uint, zpass:uint):void{}
		
		public function stencilOpSeparate(face:uint, fail:uint, zfail:uint, zpass:uint):void{}
		
		public function texImage2D(... args):void{}
		
		public function texParameterf(target:*, pname:*, param:*):void{}
		
		public function texParameteri(target:*, pname:*, param:*):void{}
		
		public function texSubImage2D(... args):void{}
		
		public function uniform1f(location:*, x:Number):void{}
		
		public function uniform1fv(location:*, v:*):void{}
		
		public function uniform1i(location:*, x:Number):void{}
		
		public function uniform1iv(location:*, v:*):void{}
		
		public function uniform2f(location:*, x:Number, y:Number):void{}
		
		public function uniform2fv(location:*, v:*):void{}
		
		public function uniform2i(location:*, x:Number, y:Number):void{}
		
		public function uniform2iv(location:*, v:*):void{}
		
		public function uniform3f(location:*, x:Number, y:Number, z:Number):void{}
		
		public function uniform3fv(location:*, v:*):void{}
		
		public function uniform3i(location:*, x:Number, y:Number, z:Number):void{}
		
		public function uniform3iv(location:*, v:*):void{}
		
		public function uniform4f(location:*, x:Number, y:Number, z:Number, w:Number):void{}
		
		public function uniform4fv(location:*, v:*):void{}
		
		public function uniform4i(location:*, x:Number, y:Number, z:Number, w:Number):void{}
		
		public function uniform4iv(location:*, v:*):void{}
		
		public function uniformMatrix2fv(location:*, transpose:*, value:*):void{}
		
		public function uniformMatrix3fv(location:*, transpose:*, value:*):void{}
		
		public function uniformMatrix4fv(location:*, transpose:*, value:*):void{}
		
		public function useProgram(program:*):void{}
		
		public function validateProgram(program:*):void{}
		
		public function vertexAttrib1f(indx:*, x:Number):void{}
		
		public function vertexAttrib1fv(indx:*, values:*):void{}
		
		public function vertexAttrib2f(indx:*, x:Number, y:Number):void{}
		
		public function vertexAttrib2fv(indx:*, values:*):void{}
		
		public function vertexAttrib3f(indx:*, x:Number, y:Number, z:Number):void{}
		
		public function vertexAttrib3fv(indx:*, values:*):void{}
		
		public function vertexAttrib4f(indx:*, x:Number, y:Number, z:Number, w:Number):void{}
		
		public function vertexAttrib4fv(indx:*, values:*):void{}
		
		public function vertexAttribPointer(indx:*, size:*, type:*, normalized:*, stride:*, offset:int):void{}
		
		public function viewport(x:Number, y:Number, width:Number, height:Number):void { }
		
		public function configureBackBuffer(width:int, height:int, antiAlias:int, enableDepthAndStencil:Boolean = true, wantsBestResolution:Boolean = false):void{};
		
		public function compressedTexImage2D(... args):void{}
	/*[IF-FLASH-END]*/
	}

}