package vox {
	/**
	 * 用median cut算法实现的颜色量化算法，即真彩转256色调色板
	 * 源码来自：
	 * https://github.com/phg1024/ImageProcJS/blob/master/algorithms/mediancut.js
	 */
	public class  ColorQuantization_Mediancut {
		private var tmpCol:VoxelColor = new VoxelColor(0, 0, 0, null);
		/**
		 * mediancut 颜色分类法
		 * @param src rgb格式的数组
		 * @param n  颜色数目
		 * @return {uint8[]}  256色调色板. 每个占3个字节
		 */
		public function mediancut( src:Uint8Array, n:int = 256 ):Vector.<int> {
			var incolorNum:int = src.length/3;
			// 统计
			var inColors :Object = { };
			var hex:String;
			var ci:Number = 0;
			var i:int = 0;
			for(i=0; i<incolorNum; i++){
				var r:int=src[ci++];
				var g:int=src[ci++];
				var b:int=src[ci++];
				hex = ((r<<16)|(g<<8)|b).toString(16);
				if( !(hex in inColors) ) {
					inColors[hex] = 1;
				}else {
					inColors[hex] ++;		// 统计相同颜色的个数
				}        
			}

			var tmp:Vector.<VoxelColor> = new Vector.<VoxelColor>();
			for (hex in inColors) {
				var intv:int = parseInt(hex,16);
				var c:VoxelColor =  new VoxelColor(intv>>>16, (intv>>>8)&0xff, intv&0xff,null);
				c.w = inColors[hex];

				tmp.push(c);
			}

			// build the mean cut tree
			var root:ColorBoundingBox = new ColorBoundingBox( tmp );

			var Q:Vector.<ColorBoundingBox> = new Vector.<ColorBoundingBox>();
			Q.push(root);
			// 每次都是把所有的节点切成两半，所以结果一定是2的n次方
			while(Q.length < n ) {
				// recursively refine the tree
				var cur:ColorBoundingBox = Q[0];
				Q.shift();

				var children:Object = cur.split();

				Q.push(children.left);
				Q.push(children.right);
			}

			// 这时候Q中保留下来的都是还没有拆分的
			var colors:Vector.<int> = new Vector.<int>();
			for(i=0;i< Q.length;i++) {
				Q[i].meanColor(i,tmpCol);
				//colors.push( Q[i].meanColor() );
				colors.push(tmpCol.r,tmpCol.g,tmpCol.b);
			}
			return colors;
		}

		// 已经统计好各个颜色的数量了，这样可以快速一些。直接返回 Uint8Array
		public function mediancut1( colorData:Object, colNum:int, n:int = 256 ):Uint8Array {
			var ret8:Uint8Array = new Uint8Array(n * 3);
			
			var colors:Vector.<VoxelColor> = new Vector.<VoxelColor>(colNum );	// r,g,b,num
			
			var ci:int = 0;
			for (var c:* in colorData) {
				var ic:int = c | 0;
				var b:int=((ic>>>10)&0x1f);// 用的直接是555的
				var g:int=((ic>>>5)&0x1f);
				var r:int = (ic & 0x1f);
				var o:Object = colorData[c];
				var cc:VoxelColor = colors[ci] = new VoxelColor(r, g, b, o);
				cc.w = o[1];
				ci++;
			}

			// build the mean cut tree
			var root:ColorBoundingBox = new ColorBoundingBox( colors );

			var Q:Vector.<ColorBoundingBox> = new Vector.<ColorBoundingBox>();
			Q.push(root);
			// 每次都是把所有的节点切成两半，所以结果一定是2的n次方
			while(Q.length < n ) {
				// recursively refine the tree
				var cur:ColorBoundingBox = Q[0];
				Q.shift();

				var children:Object = cur.split();

				Q.push(children.left);
				Q.push(children.right);
			}

			// 这时候Q中保留下来的都是还没有拆分的
			for(var i:int=0;i< Q.length;i++) {
				Q[i].meanColor(i,tmpCol);
				ret8[i * 3] = tmpCol.r;
				ret8[i * 3 + 1] = tmpCol.g;
				ret8[i * 3 + 2] = tmpCol.b;
			}
			return ret8;
		}		
		
		/**
		 * 传入rgb，返回调色板中最接近的index
		 * @param	r
		 * @param	g
		 * @param	b
		 * @param	pal
		 * @return {int} 调色板索引
		 */
		public function getNearestIndex( r:Number, g:Number, b:Number, pal:Vector.<Number>):Number{
			var minV:Number=Number.MAX_VALUE;
			var minIdx:Number=0;
			var pi:int=0;
			for(var i:int=0; i<256; i++){
				var pr:int = pal[pi++];
				var pg:int = pal[pi++];
				var pb:int = pal[pi++];
				var dr:int = pr - r;
				var dg:int = pg - g;
				var db:int = pb - b;
				var dist:Number = Math.sqrt(dr*dr+dg*dg+db*db);
				if(dist<minV){
					minIdx=i;
					minV=dist;
				}
			}
			return minIdx;
		}

		public function trueColorToIndexColor(img:Uint8Array, pal:Vector.<Number>):Object{
			var ptNum:int = img.length/4;
			var ret:Uint8Array = new Uint8Array(ptNum);
			var retImg:Uint8Array = new Uint8Array(img.length);
			var pi:int=0;
			for(var i:int=0; i<ptNum; i++){
				var r:int = img[pi++];
				var g:int = img[pi++];
				var b:int = img[pi++];
				pi++;
				var idx:int = getNearestIndex(r,g,b, pal);
				ret[i] = idx;
				retImg[i*4]=pal[idx*3];
				retImg[i*4+1]=pal[idx*3+1];
				retImg[i*4+2]=pal[idx*3+2];
				retImg[i*4+3]=255;
			}
			return {idxdt:ret, idximg:retImg };
		}
	}
}	