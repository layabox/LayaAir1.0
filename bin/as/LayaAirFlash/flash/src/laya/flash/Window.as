/*[IF-FLASH]*/package laya.flash {
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import com.worlize.websocket.FlashWebSocket;
	/**
	 * ...
	 * @author laya
	 */
	public dynamic class Window 
	{
		public static var stage:Stage;
		public var stageIn : Stage;
		public static var window:Window;
		private static var bStarted : Boolean = false;
		
		public var document:Document = new Document();
		public var XMLHttpRequest:*= FlashXMLHttpRequest;
		public var DOMParser:*= FlashDOMParser;
		public var Image:*= FlashImage;
		
		public var WebSocket:*= FlashWebSocket;		

		public var navigator:*= { userAgent:'flash' };		
		
		public var location:Location;
		
		public function Window() 
		{
			FlashEvent.__init__();
			
			window = this;
			window.stageIn = Window.stage;
			location=new Location();
		}
		
		public function requestAnimationFrame(call:Function):void
		{
			//setTimeout(call, 1000/60);
		}
		
		public function addEventListener(type:String, listener:Function):void
		{
			stage.addEventListener(type, listener);
		}
		
		public static function start(sprite:Sprite,startClass:*):void
		{			
			if ( bStarted ) {
				trace( "Window.start exec more than one Times." );
				return;
			}
			bStarted = true;
			var stage:Stage = sprite.stage;
			if (stage) init();
			else sprite.addEventListener(Event.ADDED_TO_STAGE, init);			
			
			function init(e:Event = null):void 
			{
				sprite.removeEventListener(Event.ADDED_TO_STAGE, init);
				stage = sprite.stage;
				
				Window.stage = stage;		
				
				
				stage.scaleMode = StageScaleMode.NO_SCALE; 
				stage.align = StageAlign.TOP_LEFT;
				
				var _stage3d:Stage3D=FlashWebGLContext._stage3d = Window.stage.stage3Ds[0];//这个是如何？？
				_stage3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3DCreate); 
				_stage3d.requestContext3D( Context3DRenderMode.AUTO);
			
				function onContext3DCreate(e:Event):void {
					FlashWebGLContext.context3D = Stage3D( e.target ).context3D;
					FlashInit.__init__(stage);
					new startClass();
				}			
			}			
		}
		
		public function SetupWebglContext(value:*):void
		{
			return;
		}
	}

}
