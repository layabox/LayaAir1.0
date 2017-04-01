package laya.flash.utils
{
	import laya.utils.Browser;

	public function clearInterval(id:uint):void
	{
		Browser.window.clearInterval(id);
	}
}