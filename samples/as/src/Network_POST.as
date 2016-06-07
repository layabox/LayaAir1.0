package
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.net.HttpRequest;
	import laya.utils.Browser;
	import laya.webgl.WebGL;
	
	public class Network_POST
	{
		private var hr:HttpRequest;
		private var logger:Text;
		
		public function Network_POST() 
		{	
			// 不支持WebGL时自动切换至Canvas
			Laya.init(Browser.clientWidth, Browser.clientHeight, WebGL);

			Laya.stage.alignV = Stage.ALIGN_MIDDLE;
			Laya.stage.alignH = Stage.ALIGN_CENTER;

			Laya.stage.scaleMode = "showall";
			Laya.stage.bgColor = "#232628";


			connect();
			showLogger();
		}

		private function connect():void
		{
			hr = new HttpRequest();
			hr.once(Event.PROGRESS, this, onHttpRequestProgress);
			hr.once(Event.COMPLETE, this, onHttpRequestComplete);
			hr.once(Event.ERROR, this, onHttpRequestError);
			hr.send('http://xkxz.zhonghao.huo.inner.layabox.com/api/getData', 'name=myname&psword=xxx', 'post', 'text');
		}

		private function showLogger():void
		{
			logger = new Text();

			logger.fontSize = 30;
			logger.color = "#FFFFFF";
			logger.align = 'center';
			logger.valign = 'middle';
			
			logger.size(Laya.stage.width, Laya.stage.height);
			logger.text = "等待响应...\n";
			Laya.stage.addChild(logger);
		}
		
		private function onHttpRequestError(e:*):void
		{
			trace(e);
		}
		
		private function onHttpRequestProgress(e:*):void
		{
			trace(e)
		}
		
		private function onHttpRequestComplete(e:*):void
		{
			logger.text += "收到数据：" + hr.data;
		}
	}
}