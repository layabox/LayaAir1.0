package laya.flash.utils
{
	import laya.utils.Browser;

	public function clearTimeout(id:uint):void
	{
		Browser.window.clearTimeout(id);
	}
}