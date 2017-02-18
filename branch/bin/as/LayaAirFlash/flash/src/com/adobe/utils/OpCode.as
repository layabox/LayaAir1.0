/*[IF-FLASH]*/package com.adobe.utils
{
	public class OpCode
	{
		private var _emitCode:uint;
		private var _flags:uint;
		private var _name:String;
		private var _numRegister:uint;
		
		// ======================================================================
		//	Getters
		// ----------------------------------------------------------------------
		public function get emitCode():uint		{ return _emitCode; }
		public function get flags():uint		{ return _flags; }
		public function get name():String		{ return _name; }
		public function get numRegister():uint	{ return _numRegister; }
		
		// ======================================================================
		//	Constructor
		// ----------------------------------------------------------------------
		public function OpCode( name:String, numRegister:uint, emitCode:uint, flags:uint)
		{
			_name = name;
			_numRegister = numRegister;
			_emitCode = emitCode;
			_flags = flags;
		}		
		
		// ======================================================================
		//	Methods
		// ----------------------------------------------------------------------
		public function toString():String
		{
			return "[OpCode name=\""+_name+"\", numRegister="+_numRegister+", emitCode="+_emitCode+", flags="+_flags+"]";
		}
	}
}