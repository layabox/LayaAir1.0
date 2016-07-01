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
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	public class WebSocketEvent extends Event
	{
		public static const OPEN:String = "open";
		public static const CLOSED:String = "closed";
		public static const MESSAGE:String = "message";
		public static const FRAME:String = "frame";
		public static const PING:String = "ping";
		public static const PONG:String = "pong";
		
		public var message:WebSocketMessage;
		public var frame:WebSocketFrame;
		// River TEST CODE: 非通用数据，先测试文本
		public var data : String;
		
		public function WebSocketEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}