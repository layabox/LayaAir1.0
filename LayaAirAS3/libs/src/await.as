package {
	/*[COMPILER OPTIONS:ForcedCompile]*/
	import laya.asyn.Asyn;
	
	/**
	 * ...
	 * @author laya
	 */
	public function await(caller:*, fn:Function, nextLine:int):void {
		Asyn._caller_ = caller;
		Asyn._callback_ = fn;
		Asyn._nextLine_ = nextLine;
	}
}