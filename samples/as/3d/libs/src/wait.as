package {
	/*[COMPILER OPTIONS:ForcedCompile]*/
	import laya.asyn.Asyn;
	import laya.asyn.Deferred;
	
	/**
	 * @copy laya.asyn.Asyn#wait()
	 */
	public function wait(conditions:*):Deferred {
		return Asyn.wait(conditions);
	}
}