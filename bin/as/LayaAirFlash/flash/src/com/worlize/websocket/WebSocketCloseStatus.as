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
	public final class WebSocketCloseStatus
	{
		// http://tools.ietf.org/html/rfc6455#section-7.4
		public static const NORMAL:int = 1000;
		public static const GOING_AWAY:int = 1001;
		public static const PROTOCOL_ERROR:int = 1002;
		public static const UNPROCESSABLE_INPUT:int = 1003;
		public static const UNDEFINED:int = 1004;
		public static const NO_CODE:int = 1005;
		public static const NO_CLOSE:int = 1006;
		public static const BAD_PAYLOAD:int = 1007;
		public static const POLICY_VIOLATION:int = 1008;
		public static const MESSAGE_TOO_LARGE:int = 1009;
		public static const REQUIRED_EXTENSION:int = 1010;
		public static const SERVER_ERROR:int = 1011;
		public static const FAILED_TLS_HANDSHAKE:int = 1015;
	}
}