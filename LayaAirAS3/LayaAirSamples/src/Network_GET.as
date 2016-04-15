package
{
	import laya.display.Stage;
	import laya.display.Text;
	import laya.events.Event;
	import laya.net.HttpRequest;
	
	public class Network_GET
	{
		private var hr:HttpRequest;
		private var info:Text;
		
		public function Network_GET() 
		{	
			Laya.init(550, 400);
			Laya.stage.scaleMode = Stage.SCALE_SHOWALL;
			
			hr = new HttpRequest();
			hr.once(Event.PROGRESS, this, onHttpRequestProgress);
			hr.once(Event.COMPLETE, this, onHttpRequestComplete);
			hr.once(Event.ERROR, this, onHttpRequestError);
			hr.send('http://xkxz.zhonghao.huo.inner.layabox.com/api/getData?name=myname&psword=xxx', null, 'get', 'text');
			
			info = new Text();
			info.fontSize = 20;
			info.align = 'center';
			info.size(550 , 30);
			info.y = 180;
			info.color = "#FFFFFF";
			info.text = "等待响应...";
			Laya.stage.addChild(info);
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
			info.text = "收到数据：" + hr.data;
		}
	}
}