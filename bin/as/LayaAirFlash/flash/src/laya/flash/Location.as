/*[IF-FLASH]*/package laya.flash {
	/**
	 * ...
	 * @author laya
	 */
	public class Location 
	{
		public var protocol:String;//设置或返回当前 URL 的协议。
		public var pathname:String;//设置或返回当前 URL 的路径部分。
		public var href:String;//设置或返回完整的 URL。
		public var origin:String = "";
		public function Location()
		{	
			href = Window.stage.loaderInfo.url;
			var ofs:int = href.indexOf(':');
			protocol=href.substr(0, ofs+1);
			ofs = href.lastIndexOf('/');
			pathname = href.substr(0, ofs+1)+"h5/";
		}
	}
}