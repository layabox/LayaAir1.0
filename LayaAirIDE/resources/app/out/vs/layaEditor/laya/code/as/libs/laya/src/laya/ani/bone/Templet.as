package laya.ani.bone
{
	import laya.display.Graphics;
	import laya.maths.Arith;
	import laya.maths.Matrix;
	import laya.resource.Texture;
	import laya.utils.Byte;
	
	public class Templet
	{
		/*[DISABLE-ADD-VARIABLE-DEFAULT-VALUE]*/
		public static var ANIMLEN:int = 8;
		public static var SRC_ANIMLEN:int = 10;
		
		private var _vision:String = "";
		private var _usePack:int;
		private var _uv:*;
		private var _bones:*;
		private var _anims:* = []; //动画组 插值之前
		private var _strArr:Array; //字符索引
		private var _targetAnim:Array = []; //插值之后
		private var _boneCount:int = 0; //骨骼个数
		private var _boneMatrix:*; //骨骼原始矩阵
		private var _textures:Array = [];
		private var _textureWidth:Number
		private var _textureHeight:Number;
		
		public var frameCount:int = 0;
		public var frameRate:int = 0;
		public var animNames:Object = {};
		public var _graphicsArrs_:Array = [];
		public var _texture:*;
		
		public function get textureWidth():Number
		{
			return _textureWidth;
		}
		
		public function get textureHeight():Number
		{
			return _textureHeight;
		}
		
		public function Templet(data:*, tex:*)
		{
			this._texture = tex;
			_textureWidth = tex.width;
			_textureHeight = tex.height;
			_execute(data);
		}
		
		private function _execute(data:*):void
		{
			var b:Byte = new Byte(data);
			_vision = [b.getUint8(), b.getUint8(), b.getUint8(), b.getUint8()].join(",");
			frameRate = b.getUint8();
			_usePack = b.getUint8();
			_strArr = b.getString().split("\n");
			var len:int = b.getInt16();
			_uv = b.getInt16Array(b.pos, len * 8 * 2);
			for (var i:int = 0; i < len; ++i)
			{
				var u1:Number = _texture.uv[0],v1:Number = _texture.uv[1],u2:Number = _texture.uv[4],v2:Number = _texture.uv[5];
				var inAltasUVWidth:Number = (u2 - u1),inAltasUVHeight:Number = (v2 - v1);
				var uvStart:int = i * 8, l:Number = _uv[uvStart], u:Number = _uv[uvStart + 1], w:Number = _uv[uvStart + 2], h:Number = _uv[uvStart + 3];
				var oriU1:Number = l / this._textureWidth, oriU2:Number = (l + w) / this._textureWidth, oriV1:Number = u / this._textureHeight, oriV2:Number = (u + h) / this._textureHeight;
				var oriUV:Array = [oriU1, oriV1, oriU2, oriV1, oriU2, oriV2, oriU1, oriV2];
				var tex:* = _textures[i] = new Texture(_texture.bitmap, [u1 + oriUV[0] * inAltasUVWidth, v1 + oriUV[1] * inAltasUVHeight, u2 - (1 - oriUV[2]) * inAltasUVWidth, v1 + oriUV[3] * inAltasUVHeight, u2 - (1 - oriUV[4]) * inAltasUVWidth, v2 - (1 - oriUV[5]) * inAltasUVHeight, u1 + oriUV[6] * inAltasUVWidth, v2 - (1 - oriUV[7]) * inAltasUVHeight]);
				//资源恢复时需重新计算
				tex.w = _uv[uvStart + 4];
				tex.h = _uv[uvStart + 5];
				tex.__w = w;
				tex.__h = h;
				tex._offsetX = _uv[uvStart + 6];
				tex._offsetY = _uv[uvStart + 7];
			}
			_boneCount = len = b.getInt16()
			_boneMatrix = b.getFloat32Array(b.pos, len * 6 * 4);
			_bones = b.getInt16Array(b.pos, len * 4 * 2);
			len = b.getInt16();
			for (var k:int = 0; k < len; k++)
			{
				var arr:Array = [];
				arr._index_ = k;
				_graphicsArrs_.push(arr);
				var nameIndex:int = b.getInt16();
				animNames[_strArr[nameIndex]] = k;
				frameCount = b.getInt16();
				arr.length = arr._length = frameCount;
				var blockNum:int = b.getInt16(); //数据块个数
				_anims.push(b.getFloat32Array(b.pos, blockNum * SRC_ANIMLEN * 4));
				var outPut:* = new Float32Array(frameCount * _boneCount * ANIMLEN);
				_targetAnim.push(outPut);
				interpolation(_anims[k], outPut, blockNum);
			}
		}
		
		public function planish(i:int, _index_:int):Graphics
		{
			var outAnim:* = _targetAnim[_index_];
			var gr:Graphics = new Graphics();
			var planishMat:Array = [];
			var i_animlen:int = i * ANIMLEN;
			for (var j:int = 0; j < _boneCount; j++)
			{
				var bStart:int = j * 4;
				var mStart:int = j * 6;
				var pIndex:int = _bones[bStart];
				var mAStart:int = j * frameCount * ANIMLEN + i_animlen;
				var mM:Matrix = _getMat(_boneMatrix, mStart);
				var mAM:Matrix, tmp:Matrix, outM:Matrix = new Matrix();
				if (pIndex > -1)
				{
					var mpAStart:int = pIndex * frameCount * ANIMLEN + i_animlen;
					var mpAM:Matrix = planishMat[pIndex];
					var nodeType:int = _bones[bStart + 2];
					switch (nodeType)
					{
					case 0: 
						mAM = _getMat(outAnim, mAStart);
						tmp = Matrix.TEMP;
						var tx:Number = mAM.tx, ty:Number = mAM.ty;
						mAM.setTranslate(0, 0);
						Matrix.mul(mAM, mM, tmp);
						tmp.translate(tx, ty); //mAM.setTranslate(tx,ty);
						Matrix.mul(tmp, mpAM, planishMat[j] = outM);
						mAM = null;
						break;
					case 1: 
						var texIndex:int = outAnim[mAStart + 7];
						if (texIndex == -1)
							continue;
						
						var alpha:int = outAnim[mAStart + 6];
						if (alpha < 0.001) continue;
						
						texIndex = outAnim[mAStart + 7];
						var tex:* = _textures[texIndex];
						mM.tx -= tex._offsetX;
						mM.ty -= tex._offsetY;
						Matrix.mul(mM, mpAM, outM);
						if (alpha < 0.9999)
						{
							gr.save();
							gr.alpha(alpha);
							gr.drawTexture(tex, -tex.w / 2, -tex.w / 2, tex.__w, tex.__h, outM);
							gr.restore();
						}
						else
						{
							gr.drawTexture(tex, -tex.w / 2, -tex.w / 2, tex.__w, tex.__h, outM);
						}
						break;
					case 2: 
						break;
					default: 
						break;
					}
				}
				else
				{
					mAM = _getMat(outAnim, mAStart);
					Matrix.mul(mAM, mM, planishMat[j] = outM);
				}
			}
			return gr;
		}
		
		private function interpolation(input:*, outPut:*, blockNum:int):void
		{
			var outFrameNum:int = 0, i:int, j:int, k:int, start:int = 0, duration:int, type:int, outStart:int, delta:Number, next:int;
			for (i = 0; i < blockNum; i++, start += SRC_ANIMLEN)
			{
				duration = input[start + 6];
				type = input[start + 7];
				if (duration > 1)
				{
					next = start + SRC_ANIMLEN;
					for (j = 0; j < duration; j++)
					{
						outStart = outFrameNum++ * ANIMLEN;
						if (type == -1)
						{
							for (k = 0; k < 6; k++)
							{
								outPut[outStart + k] = input[start + k];
							}
							outPut[outStart + 6] = input[start + 8];
							outPut[outStart + 7] = input[start + 9];
						}
						else
						{
							for (k = 0; k < 6; k++)
							{
								delta = input[next + k] - input[start + k];
								if (k == 1 || k == 2)
									delta = Arith.formatR(delta);
								delta /= duration;
								outPut[outStart + k] = j * delta + input[start + k];
							}
							delta = (input[next + 8] - input[start + 8]) / duration;
							outPut[outStart + 6] = j * delta + input[start + 8];
							outPut[outStart + 7] = input[start + 9];
						}
					}
				}
				else
				{
					outStart = outFrameNum++ * ANIMLEN;
					for (j = 0; j < 6; j++)
						outPut[outStart + j] = input[start + j];
					outPut[outStart + 6] = 1;
					outPut[outStart + 7] = input[start + 9]; //贴图索引
				}
			}
		}
		
		private function _getMat(tran:*, start:int):Matrix
		{
			var mat:Matrix = new Matrix();
			var a:Number = tran[start], b:Number = tran[start + 1], c:Number = tran[start + 2], d:Number = tran[start + 3], tx:Number = tran[start + 4], ty:Number = tran[start + 5];
			if (c != 0 || b != 0)
			{
				var cos:Number = Math.cos(b), sin:Number = Math.sin(b);
				mat.setTo(a * cos, a * sin, d * -sin, d * cos, tx, ty);
			}
			else
				mat.setTo(a, b, c, d, tx, ty);
			return mat;
		}
	}
}