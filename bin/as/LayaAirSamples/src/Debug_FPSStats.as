package 
{
	import laya.utils.Browser;
	import laya.utils.Stat;
	import laya.webgl.WebGL;

	public class Debug_FPSStats 
	{
		
		public function Debug_FPSStats() 
		{
			Laya.init(1, 1);
			Stat.show(Browser.clientWidth - 120 >> 1, Browser.clientHeight - 100 >> 1);
		}
	}
}