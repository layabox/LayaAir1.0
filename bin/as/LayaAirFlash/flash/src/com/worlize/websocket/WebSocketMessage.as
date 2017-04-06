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
	import flash.utils.ByteArray;
	
	public class WebSocketMessage
	{
		public static const TYPE_BINARY:String = "binary";
		public static const TYPE_UTF8:String = "utf8";
		
		public var type:String;
		public var utf8Data:String;
		public var binaryData:ByteArray;
	}
}