package
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.inputDevice.Video;
	import laya.renders.Render;
	import laya.ui.HSlider;
	import laya.ui.Slider;
	import laya.ui.TextInput;
	import laya.utils.Browser;
	import laya.utils.Handler;
	import laya.utils.StringKey;
	
	/**
	 * ...
	 * @author Survivor
	 */
	public class VideoTest
	{
		private var SLIDER_PADDING:int = 100;
		private var video:Video;
		private var resizeHandle:Sprite;
		private var togglePlayButton:Text;
		
		public function VideoTest()
		{
			Laya.init(550, 400);
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			
			//Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			Laya.stage.bgColor = "#232628";
			
			setupUI();
		}
		
		private function setupUI():void
		{
			createResizeHandle();
			togglePlayButton = createButton("暂停", 20, 350, onTogglePlay);
			createVideo();
		}
		
		private function createResizeHandle():void
		{
			resizeHandle = new Sprite();
			resizeHandle.graphics.drawPoly(0, 0, [0, 0, -20, 0, 0, -20], "#FF7F50");
			
			resizeHandle.mouseThrough = true;
			resizeHandle.zOrder = 1;
			
			Laya.stage.addChild(resizeHandle);
			resizeHandle.on(Event.MOUSE_OVER, this, function():void
			{
				resizeHandle.alpha = 0.5;
				Render.canvas.style.cursor = "pointer";
			});
			resizeHandle.on(Event.MOUSE_OUT, this, function():void
			{
				resizeHandle.alpha = 1;
				Render.canvas.style.cursor = "default";
			});
			var isMouseDown:Boolean = false;
			var prevX:int;
			var prevY:int;
			resizeHandle.on(Event.MOUSE_DOWN, this, function():void
			{
				isMouseDown = true;
				
				prevX = Laya.stage.mouseX;
				prevY = Laya.stage.mouseY;
			});
			Laya.stage.on(Event.MOUSE_MOVE, this, function():void
			{
				if(isMouseDown)
				{
					resizeHandle.x += Laya.stage.mouseX - prevX;
					resizeHandle.y += Laya.stage.mouseY - prevY;
					
					prevX = Laya.stage.mouseX;
					prevY = Laya.stage.mouseY;
					
					video.width = resizeHandle.x;
					video.height = resizeHandle.y;
				}
			});
			Laya.stage.on(Event.MOUSE_UP, this, function():void
			{
				isMouseDown = false;
			});
			
		}
		
		private function createSlider(x:int, y:int, width:int, min:int, max:int, value:int, tick:int, changeHandler:Function):HSlider
		{
			var hs:HSlider = new HSlider();
			hs.width = width;
			hs.skin = "../../../../res/ui/hslider.png";
			hs.pos(x, y);
			hs.min = min;
			hs.max = max;
			hs.value = value;
			hs.tick = tick;
			Laya.stage.addChild(hs);
			
			hs.changeHandler = new Handler(this, changeHandler);
			
			return hs;
		}
		
		private function createButton(label:String, x:int, y:int, clickHandler:Function):void
		{
			var text:Text = new Text();
			Laya.stage.addChild(text);
			
			text.text = label;
			text.fontSize = 20;
			text.bold = true;
			text.color = "#FFFFFF";
			text.padding = [5, 5, 1, 5];
			text.borderColor = "#FFFFFF";
			
			text.pos(x, y);
			
			text.on(Event.CLICK, this, clickHandler);
			
			return text;
		}
		
		private function createVideo():void 
		{
			video = new Video();
			
			// 检查浏览器兼容性
			if (video.canPlayType(Video.MP4) == Video.SUPPORT_NO &&
				video.canPlayType(Video.OGG) == Video.SUPPORT_NO)
			{
				alert("当前浏览器不支持播放本视频");
			}
			
			video.on('ready', this, onVideoReady);
			video.on('complete', this, onVideoPlayEnded);
			
			video.setSource("mov_bbb", Video.MP4 | Video.OGG);
			video.play();
			Laya.stage.addChild(video);
			
			// DOM Video
			var videoElement:* = video.getVideoElement();
			videoElement.controls = true;
			Browser.document.body.appendChild(videoElement);
		}
		
		private function onTogglePlay(e:Event):void
		{
			if (video.paused)
			{
				video.play();
				togglePlayButton.text = "暂停";
			}
			else
			{
				video.pause();
				togglePlayButton.text = "播放";
			}
		}
		
		private function onVideoPlayEnded(e:Event):void
		{
			togglePlayButton.text = "重播";
		}
		
		private function onVideoReady():void
		{
			trace("当前使用源：" + video.currentSrc);
			
			video.width = video.videoWidth;
			video.height = video.videoHeight;
			
			resizeHandle.pos(video.width, video.height);
		}
	}

}