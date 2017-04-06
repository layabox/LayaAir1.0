package laya.flash.utils
{
	import laya.utils.Browser;

	public function setInterval(closure:Function, delay:Number, ... arguments):uint
	{
		arguments.unshift(closure, delay);
		return Browser.window.setInterval.apply(null, arguments);
	}
}