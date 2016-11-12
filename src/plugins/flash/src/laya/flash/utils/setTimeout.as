package laya.flash.utils
{
	import laya.utils.Browser;

	public function setTimeout(closure:Function, delay:Number, ... arguments):uint
	{
		arguments.unshift(closure, delay);
		return Browser.window.setTimeout.apply(null, arguments);
	}
}