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
	public final class WebSocketState
	{
		public static const CONNECTING:int = 0;
		public static const OPEN:int = 1;
		public static const CLOSED:int = 2;
		public static const INIT:int = 3;
	}
}