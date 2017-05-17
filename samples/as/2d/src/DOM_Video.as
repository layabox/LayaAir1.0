package 
{
	import laya.display.Sprite;
	import laya.display.Stage;
	import laya.events.Event;
	import laya.renders.Render;
	import laya.utils.Browser;
	import laya.utils.Utils;
	/**
	 * ...
	 * @author 
	 */
	public class DOM_Video 
	{
		
		public function DOM_Video() 
		{
			Laya.init(800, 600);
			Laya.stage.bgColor = "#FFFFFF";
			Laya.stage.alignH = Stage.ALIGN_CENTER;
			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			
			// 创建Video元素
			var videoElement:Object = Browser.createElement("video");
			Browser.document.body.appendChild(videoElement);
			
			// 设置Video元素地样式和属性
			videoElement.style.zInddex = Render.canvas.style.zIndex + 1;
			videoElement.src = "../../../../res/av/mov_bbb.mp4";
			videoElement.controls = true;
			// 阻止IOS视频全屏
			videoElement.setAttribute("webkit-playsinline", true);
			videoElement.setAttribute("playsinline", true);
			
			// 设置画布上的对齐参照物
			var reference:Sprite = new Sprite();
			Laya.stage.addChild(reference);
			reference.pos(100, 100);
			reference.size(600, 400);
			reference.graphics.drawRect(0, 0, reference.width, reference.height, "#CCCCCC");
			
			// 每次舞台尺寸变更时，都会调用Utils.fitDOMElementInArea设置Video的位置，对齐的位置和refence重合
			Laya.stage.on(Event.RESIZE, this, Utils.fitDOMElementInArea, [videoElement, reference, 0, 0, reference.width, reference.height]);
		}
		
	}

}