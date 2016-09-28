(function()
{
	var Browser = Laya.Browser;
	var Stat    = Laya.Stat;

	Laya.init(Browser.clientWidth, Browser.clientHeight);
	Stat.show(Browser.clientWidth - 120 >> 1, Browser.clientHeight - 100 >> 1);
})();