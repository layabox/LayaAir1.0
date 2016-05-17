package {
	/*[COMPILER OPTIONS:ForcedCompile]*/
	import laya.asyn.Asyn;
	import laya.asyn.Deferred;
	
	/**
	 * @copy laya.asyn.Asyn#load()
	 */
	public function load(url:String, type:String = null):Deferred {
		return Asyn.load(url, type);
	}
}
