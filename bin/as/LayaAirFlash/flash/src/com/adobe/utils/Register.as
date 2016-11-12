/*[IF-FLASH]*/package com.adobe.utils
{
	public class Register
	{
		// ======================================================================
		//	Properties
		// ----------------------------------------------------------------------
		private var _emitCode:uint;
		private var _name:String;
		private var _longName:String;
		private var _flags:uint;
		private var _range:uint;
		
		// ======================================================================
		//	Getters
		// ----------------------------------------------------------------------
		public function get emitCode():uint		{ return _emitCode; }
		public function get longName():String	{ return _longName; }
		public function get name():String		{ return _name; }
		public function get flags():uint		{ return _flags; }
		public function get range():uint		{ return _range; }
		
		// ======================================================================
		//	Constructor
		// ----------------------------------------------------------------------
		public function Register( name:String, longName:String, emitCode:uint, range:uint, flags:uint)
		{
			_name = name;
			_longName = longName;
			_emitCode = emitCode;
			_range = range;
			_flags = flags;
		}
		
		// ======================================================================
		//	Methods
		// ----------------------------------------------------------------------
		public function toString():String
		{
			return "[Register name=\""+_name+"\", longName=\""+_longName+"\", emitCode="+_emitCode+", range="+_range+", flags="+ _flags+"]";
		}
	}
}