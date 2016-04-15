package {
	/*[COMPILER OPTIONS:ForcedCompile]*/
	import laya.asyn.Asyn;
	import laya.asyn.Deferred;

	/**
	 * ...
	 * @author laya
	 */
	public function wait(conditions:*):Deferred {
		return Asyn.wait(conditions);
	}
}