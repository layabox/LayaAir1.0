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
		public function matrix4x4Multiply(m1:*,m2:*,out:*):void
		{
			
		}
		public function evaluateClipDatasRealTime(nodes:*, playCurTime:int, realTimeCurrentFrameIndexs:*, addtive:Boolean):void
		{
			
		}
		
	}
}

