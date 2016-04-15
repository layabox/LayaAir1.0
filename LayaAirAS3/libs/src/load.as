package {
	/*[COMPILER OPTIONS:ForcedCompile]*/
	/**
	 * ...
	 * @author laya
	 */
	import laya.asyn.Asyn;
	import laya.asyn.Deferred;
	/**
	 * ...
	 * @author laya
	 */
	public function load(url:String, type:String = null):Deferred {
		return Asyn.load(url, type);
	}
}
