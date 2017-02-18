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
	public class WebSocketConfig
	{
		// 1 MiB max frame size
		public var maxReceivedFrameSize:uint = 0x100000;
		
		// 8 MiB max message size, only applicable if
		// assembleFragments is true
		public var maxMessageSize:uint = 0x800000; // 8 MiB

		// Outgoing messages larger than fragmentationThreshold will be
		// split into multiple fragments.
		public var fragmentOutgoingMessages:Boolean = true;

		// Outgoing frames are fragmented if they exceed this threshold.
		// Default is 16KiB
		public var fragmentationThreshold:uint = 0x4000;
		
		// If true, fragmented messages will be automatically assembled
		// and the full message will be emitted via a 'message' event.
		// If false, each frame will be emitted via a 'frame' event and
		// the application will be responsible for aggregating multiple
		// fragmented frames.  Single-frame messages will emit a 'message'
		// event in addition to the 'frame' event.
		// Most users will want to leave this set to 'true'
		public var assembleFragments:Boolean = true;
		
		// The number of milliseconds to wait after sending a close frame
		// for an acknowledgement to come back before giving up and just
		// closing the socket.
		public var closeTimeout:uint = 5000;
		
	}
}