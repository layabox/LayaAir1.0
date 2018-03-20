/************************************************************************
 *  Copyright 2010-2012 Worlize Inc.
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ***********************************************************************/

/*[IF-FLASH]*/package com.worlize.websocket
{
	public final class WebSocketOpcode
	{
		// non-control opcodes		
		public static const CONTINUATION:int = 0x00;
		public static const TEXT_FRAME:int = 0x01;
		public static const BINARY_FRAME:int = 0x02;
		public static const EXT_DATA:int = 0x03;
		// 0x04 - 0x07 = Reserved for further control frames
		
		// Control opcodes 
		public static const CONNECTION_CLOSE:int = 0x08;
		public static const PING:int = 0x09;
		public static const PONG:int = 0x0A;
		public static const EXT_CONTROL:int = 0x0B;
		// 0x0C - 0x0F = Reserved for further control frames
	}
}