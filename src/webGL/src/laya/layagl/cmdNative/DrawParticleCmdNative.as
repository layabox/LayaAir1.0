package laya.layagl.cmdNative {
	import laya.layagl.LayaGL;
	import laya.layagl.LayaNative2D;
	import laya.maths.Point;
	import laya.resource.Context;
	import laya.resource.Texture;
	import laya.utils.Pool;
	import laya.maths.Matrix;
	import laya.webgl.WebGLContext;
	import laya.webgl.utils.IndexBuffer2D;
	import laya.webgl.utils.MeshParticle2D;
	import laya.webgl.utils.RenderState2D;
	import laya.webgl.utils.VertexBuffer2D;
	
	public class DrawParticleCmdNative  {
		public static const ID:String = "DrawParticleCmd";
		public static var _DRAW_PARTICLE_CMD_ENCODER_:* = null;
		public static var _PARAM_VB1_POS_:int = 0;
		public static var _PARAM_VB2_POS_:int = 1;
		public static var _PARAM_VB1_SIZE_POS_:int = 2;
		public static var _PARAM_VB2_SIZE_POS_:int = 3;
		public static var _PARAM_CURRENTTIME_POS_:int = 4;
		public static var _PARAM_DURATION_POS_:int = 5;
		public static var _PARAM_ENDVEL_POS_:int = 6;
		public static var _PARAM_GRAVITY_POS_:int = 7;
		public static var _PARAM_SIZE_POS_:int = 10;
		public static var _PARAM_MAT_POS_:int = 12;
		public static var _PARAM_TEXTURE_LOC_POS_:int = 28;
		public static var _PARAM_TEXTURE_POS_:int = 29;
		public static var _PARAM_REGDATA_POS_:int = 30;
		public static var _PARAM_TEXTURE_UNIFORMLOC_POS_:int = 31;
		public static var _PARAM_RECT1_NUM_POS_:int = 32;
		public static var _PARAM_RECT2_NUM_POS_:int = 33;
		public static var _PARAM_VB1_OFFSET_POS_:int = 34;
		public static var _PARAM_VB2_OFFSET_POS_:int = 35;
		
		private var _graphicsCmdEncoder:*;
		private var _paramData:*= null;
		private var vbBuffer:*;
		
		private var _template:*;
		private var _floatCountPerVertex:int = 29;//0~2为Position,3~5Velocity,6~9为StartColor,10~13为EndColor,14~16位SizeRotation,17到18位Radius,19~22位Radian,23为DurationAddScaleShaderValue,24为Time,25~28为CornerTextureCoordinate
		private var _firstNewElement:int = 0;
		private var _firstFreeElement:int = 0;
		private var _firstActiveElement:int = 0;
		private var _firstRetiredElement:int = 0;
		private var _maxParticleNum:int = 0;
		
		public static function create(_temp:*):DrawParticleCmdNative {
			var cmd:DrawParticleCmdNative = Pool.getItemByClass("DrawParticleCmd", DrawParticleCmdNative);
			cmd._graphicsCmdEncoder = __JS__("this._commandEncoder;");
			
			if (!_DRAW_PARTICLE_CMD_ENCODER_)
			{
				_DRAW_PARTICLE_CMD_ENCODER_ = LayaGL.instance.createCommandEncoder(284, 32, true);
				_DRAW_PARTICLE_CMD_ENCODER_.blendFuncByGlobalValue(LayaNative2D.GLOBALVALUE_BLENDFUNC_SRC, LayaNative2D.GLOBALVALUE_BLENDFUNC_DEST);
				_DRAW_PARTICLE_CMD_ENCODER_.useProgramEx(LayaNative2D.PROGRAMEX_DRAWPARTICLE);//programID
				_DRAW_PARTICLE_CMD_ENCODER_.useVDO(LayaNative2D.VDO_MESHPARTICLE);//VAO ID
				
				// Set uniform
				_DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(0, _PARAM_CURRENTTIME_POS_ * 4);
				_DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(1, _PARAM_DURATION_POS_ * 4);
				_DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(2, _PARAM_ENDVEL_POS_ * 4);
				_DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(3, _PARAM_GRAVITY_POS_ * 4);
				_DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(4, _PARAM_SIZE_POS_ * 4);
				_DRAW_PARTICLE_CMD_ENCODER_.uniformByParamData(5, _PARAM_MAT_POS_ * 4);
				_DRAW_PARTICLE_CMD_ENCODER_.uniformTextureByParamData(_PARAM_TEXTURE_UNIFORMLOC_POS_*4, _PARAM_TEXTURE_LOC_POS_*4, _PARAM_TEXTURE_POS_*4);				
				
				_DRAW_PARTICLE_CMD_ENCODER_.setRectMeshExByParamData(_PARAM_RECT1_NUM_POS_*4, _PARAM_VB1_POS_ * 4, _PARAM_VB1_SIZE_POS_ * 4, _PARAM_VB1_OFFSET_POS_ * 4);
				_DRAW_PARTICLE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 1, LayaGL.VALUE_OPERATE_M32_MUL);
				
				_DRAW_PARTICLE_CMD_ENCODER_.loadDataToRegByParamData(0, _PARAM_REGDATA_POS_*4, 4);
				_DRAW_PARTICLE_CMD_ENCODER_.ifGreater0(0, 2);	// Skip two commands below if registed data is greater than 0.
				
				_DRAW_PARTICLE_CMD_ENCODER_.setRectMeshExByParamData(_PARAM_RECT2_NUM_POS_*4, _PARAM_VB2_POS_ * 4, _PARAM_VB2_SIZE_POS_ * 4, _PARAM_VB2_OFFSET_POS_ * 4);
				_DRAW_PARTICLE_CMD_ENCODER_.modifyMesh(LayaNative2D.GLOBALVALUE_MATRIX32, 1, LayaGL.VALUE_OPERATE_M32_MUL);
				
				LayaGL.syncBufferToRenderThread( _DRAW_PARTICLE_CMD_ENCODER_ );
			}
			
			if (!cmd._paramData)
			{
				cmd._paramData = __JS__("new ParamData(36*4, true)");
			}	
			
			
			//给参数赋值
			{
				cmd._template = _temp;
				cmd._maxParticleNum = _temp.settings.maxPartices;
			
				// Set uniform location			    
				var _i32b:Int32Array = cmd._paramData._int32Data;
				
				// Set uniform value
				var _sv:* = _temp._sv;
				var _fb:Float32Array = cmd._paramData._float32Data;
				var i:int = 0;
				_fb[_PARAM_CURRENTTIME_POS_] = -1;
				_fb[_PARAM_DURATION_POS_] = -1;
				_fb[_PARAM_ENDVEL_POS_] = -1;
				_fb[_PARAM_GRAVITY_POS_] = -1;
				_fb[_PARAM_GRAVITY_POS_ +1] = -1;
				_fb[_PARAM_GRAVITY_POS_ +2] = -1;
				_fb[_PARAM_SIZE_POS_] = -1;
				_fb[_PARAM_SIZE_POS_ +1] = -1;
				for (i = 0; i < 16; i++) {
					_fb[_PARAM_MAT_POS_ + i] = -1;
				}
				_i32b[_PARAM_TEXTURE_LOC_POS_] = -1;
				_i32b[_PARAM_TEXTURE_POS_] = -1;
				_i32b[_PARAM_TEXTURE_UNIFORMLOC_POS_] = 6;
				
				_i32b[_PARAM_REGDATA_POS_] = 0;

				_i32b[_PARAM_VB1_POS_] = -1;
				_i32b[_PARAM_VB2_POS_] = -1;
				_i32b[_PARAM_VB1_SIZE_POS_] = -1;
				_i32b[_PARAM_VB2_SIZE_POS_] = -1;
				_i32b[_PARAM_RECT1_NUM_POS_] = -1;
				_i32b[_PARAM_RECT2_NUM_POS_] = -1;
				LayaGL.syncBufferToRenderThread( cmd._paramData );
			}
			cmd._graphicsCmdEncoder.useCommandEncoder(_DRAW_PARTICLE_CMD_ENCODER_.getPtrID(), cmd._paramData.getPtrID(), -1);
			LayaGL.syncBufferToRenderThread( cmd._graphicsCmdEncoder );
			return cmd;
		}
		
		public function updateParticle():void {
			// Calculate _firstNewElement and _firstFreeElement. Update new ib and vb.
			if (_template.texture) {
				
				_template.updateParticleForNative();
				
				var _sv:* = _template.sv;
				var _i32b:Int32Array = _paramData._int32Data;
				var _fb:Float32Array = _paramData._float32Data;
				var i:int = 0;
				var n:int = 0;
				_fb[_PARAM_CURRENTTIME_POS_] = _sv.u_CurrentTime;
				_fb[_PARAM_DURATION_POS_] = _sv.u_Duration;
				_fb[_PARAM_ENDVEL_POS_] = _sv.u_EndVelocity;
				_fb[_PARAM_GRAVITY_POS_] = _sv.u_Gravity[0];
				_fb[_PARAM_GRAVITY_POS_ +1] = _sv.u_Gravity[1];
				_fb[_PARAM_GRAVITY_POS_ +2] = _sv.u_Gravity[2];
				_sv.size[0] = RenderState2D.width;
				_sv.size[1] = RenderState2D.height;
				_fb[_PARAM_SIZE_POS_] = _sv.size[0];
				_fb[_PARAM_SIZE_POS_ +1] = _sv.size[1];
				_fb[_PARAM_MAT_POS_] = 1; _fb[_PARAM_MAT_POS_ +1] = 0; _fb[_PARAM_MAT_POS_ +2] = 0; _fb[_PARAM_MAT_POS_ +3] = 0; 
				_fb[_PARAM_MAT_POS_ +4] = 0; _fb[_PARAM_MAT_POS_ +5] = 1; _fb[_PARAM_MAT_POS_ +6] = 0; _fb[_PARAM_MAT_POS_ +7] = 0; 
				_fb[_PARAM_MAT_POS_ +8] = 0; _fb[_PARAM_MAT_POS_ +9] = 0; _fb[_PARAM_MAT_POS_ +10] = 1; _fb[_PARAM_MAT_POS_ +11] = 0; 
				_fb[_PARAM_MAT_POS_ +12] = 0; _fb[_PARAM_MAT_POS_ +13] = 0; _fb[_PARAM_MAT_POS_ +14] = 0; _fb[_PARAM_MAT_POS_ +15] = 1; 
				_i32b[_PARAM_TEXTURE_LOC_POS_] = WebGLContext.TEXTURE0;
				_i32b[_PARAM_TEXTURE_POS_] = _template.texture.bitmap._glTexture.id;
				
				vbBuffer = _template.getConchMesh();
				
				_firstNewElement = _template.getFirstNewElement();
				_firstFreeElement = _template.getFirstFreeElement();
				_firstActiveElement = _template.getFirstActiveElement();
				_firstRetiredElement = _template.getFirstRetiredElement();
				// set vb and ib buffer
				var vb1Size:int = 0;
				var vb2Size:int = 0;
				var vb1Offset:int = 0;
				var vb2Offset:int = 0;
				var rect1_num:int = 0;
				var rect2_num:int = 0;
				
				if (_firstActiveElement != _firstFreeElement) 
				{
					if (_firstActiveElement < _firstFreeElement) {
						// 如果新增加的粒子在Buffer中是连续的区域，只set一次
						// Set skip registereddata
						_i32b[_PARAM_REGDATA_POS_] = 1;
						rect1_num = _firstFreeElement - _firstActiveElement;
						vb1Size = (_firstFreeElement - _firstActiveElement) * _floatCountPerVertex * 4 * 4;
						vb1Offset = _firstActiveElement * _floatCountPerVertex * 4 * 4;
					}
					else
					{
						//如果新增粒子区域超过Buffer末尾则循环到开头，需set两次
						// Set skip registereddata
						_i32b[_PARAM_REGDATA_POS_] = 0;
						// First part
						{
							rect1_num = _maxParticleNum - _firstActiveElement;
							vb1Size = (_maxParticleNum - _firstActiveElement) * _floatCountPerVertex * 4 * 4;
							vb1Offset = _firstActiveElement * _floatCountPerVertex * 4 * 4;
						}
						// Second part
						{
							if (_firstFreeElement > 0) {
								rect2_num = _firstFreeElement;
								vb2Size = _firstFreeElement * _floatCountPerVertex * 4 * 4;
								vb2Offset = 0;
							} else {
								_i32b[_PARAM_REGDATA_POS_] = 1;
							}
						}
					}
				}
				_i32b[_PARAM_VB1_POS_] = vbBuffer.getPtrID();
				_i32b[_PARAM_RECT1_NUM_POS_] = rect1_num;
				_i32b[_PARAM_VB1_SIZE_POS_] = vb1Size;
				_i32b[_PARAM_VB1_OFFSET_POS_] = vb1Offset;
				LayaGL.syncBufferToRenderThread(vbBuffer);
				if (vb2Size > 0) {
					_i32b[_PARAM_VB2_POS_] = vbBuffer.getPtrID();
					_i32b[_PARAM_RECT2_NUM_POS_] = rect2_num;
					_i32b[_PARAM_VB2_SIZE_POS_] = vb2Size;
					_i32b[_PARAM_VB2_OFFSET_POS_] = vb2Offset;
				}
				LayaGL.syncBufferToRenderThread(_paramData);
				
				_template.addDrawCounter();				
			}
		}
		
		/**
		 * 回收到对象池
		 */
		public function recover():void {
			_template = null;
			Pool.recover("DrawParticleCmd", this);
		}
		
		public function get cmdID():String
		{
			return ID;
		}
	}
}