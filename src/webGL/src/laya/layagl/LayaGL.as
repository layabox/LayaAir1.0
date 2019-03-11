package laya.layagl {
	
	import laya.display.Text;
	import laya.display.cmd.DrawImageCmd;
	import laya.display.cmd.FillTextCmd;
	import laya.display.cmd.RestoreCmd;
	import laya.display.cmd.RotateCmd;
	import laya.display.cmd.SaveCmd;
	import laya.display.cmd.ScaleCmd;
	import laya.display.cmd.TransformCmd;
	import laya.display.cmd.TranslateCmd;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.webgl.WebGLContext;
	/**
	 * @private
	 * 封装GL命令
	 */
	public class LayaGL {
		//-------------------------------------------------------------------------------------
		public static const EXECUTE_JS_THREAD_BUFFER:int = 0;			//直接执行JS线程中的buffer
		public static const EXECUTE_RENDER_THREAD_BUFFER:int = 1;		//直接执行渲染线程的buffer
		public static const EXECUTE_COPY_TO_RENDER:int = 2;				//拷贝buffer到渲染线程
		public static const EXECUTE_COPY_TO_RENDER3D:int = 3;			//拷贝3Dbuffer到渲染线程
		
		//-------------------------------------------------------------------------------------
		public static const VALUE_OPERATE_ADD:int = 0;
		public static const VALUE_OPERATE_SUB:int = 1;
		public static const VALUE_OPERATE_MUL:int = 2;
		public static const VALUE_OPERATE_DIV:int = 3;
		public static const VALUE_OPERATE_M2_MUL:int = 4;
		public static const VALUE_OPERATE_M3_MUL:int = 5;
		public static const VALUE_OPERATE_M4_MUL:int = 6;
		public static const VALUE_OPERATE_M32_MUL:int = 7;
		public static const VALUE_OPERATE_SET:int = 8;
		public static const VALUE_OPERATE_M32_TRANSLATE:int = 9;
		public static const VALUE_OPERATE_M32_SCALE:int = 10;
		public static const VALUE_OPERATE_M32_ROTATE:int = 11;
		public static const VALUE_OPERATE_M32_SCALE_PIVOT:int = 12;
		public static const VALUE_OPERATE_M32_ROTATE_PIVOT:int = 13;
		public static const VALUE_OPERATE_M32_TRANSFORM_PIVOT:int = 14;
		public static const VALUE_OPERATE_BYTE4_COLOR_MUL:int = 15;
		
		//-------------------------------------------------------------------------------------
		public static const ARRAY_BUFFER_TYPE_DATA:int = 0;           	//创建ArrayBuffer时的类型为Data
		public static const ARRAY_BUFFER_TYPE_CMD:int = 1;            	//创建ArrayBuffer时的类型为Command
		
		public static const ARRAY_BUFFER_REF_REFERENCE:int = 0;			//创建ArrayBuffer时的类型为引用
		public static const ARRAY_BUFFER_REF_COPY:int = 1;				//创建ArrayBuffer时的类型为拷贝
		
		public static const UPLOAD_SHADER_UNIFORM_TYPE_ID:int = 0;      //data按照ID传入
		public static const UPLOAD_SHADER_UNIFORM_TYPE_DATA:int = 1;    //data按照数据传入
	
		
		public static var instance:*;
		
		//TODO:coverage
		public function createCommandEncoder(reserveSize:int = 128, adjustSize:int = 64, isSyncToRenderThread:Boolean = false):CommandEncoder {
			return new CommandEncoder(this, reserveSize, adjustSize, isSyncToRenderThread);
		}
		
		public function beginCommandEncoding(commandEncoder:CommandEncoder):void {
		
		}
		
		public function endCommandEncoding():void {
		
		}
		
		//TODO:coverage
		public static function getFrameCount():int {
			return 0;
		}
		
		public static function syncBufferToRenderThread(value:*,index:int=0):void 
		{
		
		}
		public static function createArrayBufferRef(arrayBuffer:*, type:Number, syncRender:Boolean):void 
		{
		
		}
		public static function createArrayBufferRefs(arrayBuffer:*, type:Number, syncRender:Boolean,refType:Number):void 
		{
		
		}
		public function calcMatrixFromScaleSkewRotation(nArrayBufferID:int, matrixFlag:int, matrixResultID:int, x:int, y:int, pivotX:int, pivotY:int, scaleX:int, scaleY:int, skewX:int, skewY:int, rotate:int):void
		{
			
		}
		public function setGLTemplate(type:int,templateID:int):void
		{
			
		}
		public function setEndGLTemplate(type:int,templateID:int):void
		{
			
		}
		public function matrix4x4Multiply(m1:*,m2:*,out:*):void
		{
			
		}
		public function evaluateClipDatasRealTime(nodes:*, playCurTime:int, realTimeCurrentFrameIndexs:*, addtive:Boolean):void
		{
			
		}
		
	}
}

