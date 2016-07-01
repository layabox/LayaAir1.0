/*[IF-FLASH]*/package com.adobe.utils
{
	public class Sampler
	{
		private var _flag:uint;
		private var _mask:uint;
		private var _name:String;
		
		// ======================================================================
		//	Getters
		// ----------------------------------------------------------------------
		public function get flag():uint		{ return _flag; }
		public function get mask():uint		{ return _mask; }
		public function get name():String	{ return _name; }
		
		// ======================================================================
		//	Constructor
		// ----------------------------------------------------------------------
		public function Sampler( name:String, flag:uint, mask:uint )
		{
			_name = name;
			_flag = flag;
			_mask = mask;
		}
		
		// ======================================================================
		//	Methods
		// ----------------------------------------------------------------------
		public function toString():String
		{
			return "[Sampler name=\""+_name+"\", flag=\""+_flag+"\", mask="+mask+"]";
		}
	}
}