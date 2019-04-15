package laya.d3Extend.vox {
	public class EncodeBase {
		public var curmem:int=4*1024;
		public var dataBuffer:ArrayBuffer; 
		public var dataView:DataView = null;
		protected var uint8Data:Uint8Array = null;
		protected var uint16Data:Uint16Array = null;
		public var dataPos:int = 0;

		public function EncodeBase(encode:Boolean=true):void {
			encode && initMem();
		}
		
		public function initMem():void {
			dataBuffer = new ArrayBuffer(curmem);   //先分配这么多
			dataView = new DataView(dataBuffer);
			uint8Data = new Uint8Array(dataBuffer);
			uint16Data = new Uint16Array(dataBuffer);
			dataPos=0;
		}
		
		// 要保证还有s这么大的空间
		protected function needSize(s:Number):void{
			if(dataPos+s>curmem){
				expMem(s);
			}
		}		
		
		protected function expMem(s:Number):void {
			//console.log('start expmem');
			//var expsz:Number = Math.max(s,4*1024);
			var expsz:int = curmem * 2;	// 否则对于频繁请求太慢了
			var buf:ArrayBuffer = new ArrayBuffer(expsz);
			this.curmem = expsz;
			//copy
			var olddt:Uint8Array = uint8Data;
			uint8Data = new Uint8Array(buf);
			uint8Data.set( olddt );
			this.dataView = new DataView( buf );
			uint16Data = new Uint16Array(buf);
			this.dataBuffer = buf;
			//console.log('end expmem cur:',this.curmem);
		}
				
		protected function appendBuffer(buff:ArrayBuffer):void {
			needSize(buff.byteLength);
			uint8Data.set(new Uint8Array(buff), dataPos);
			dataPos += buff.byteLength;
		}
	}
}	