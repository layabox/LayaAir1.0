package {
	/*[COMPILER OPTIONS:ForcedCompile]*/
	import laya.asyn.Asyn;
	
	/**
	 * 异步处理某个函数。
	 */
	public function await(caller:*, fn:Function, nextLine:int):void {
		Asyn._caller_ = caller;
		Asyn._callback_ = fn;
		Asyn._nextLine_ = nextLine;
	}
}