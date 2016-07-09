package laya.ui
{
	import laya.events.EventDispatcher;
	import laya.maths.MathUtil;
	import laya.utils.Ease;	
	/**
	 * 动画播放完毕后调度。
	 * @eventType Event.COMPLETE
	 */
	[Event(name = "complete", type = "laya.events.Event")]
	
	/**
	 * 播放到某标签后调度。
	 * @eventType Event.LABEL
	 */
	[Event(name = "label", type = "laya.events.Event")]
	/**
	 * 关键帧动画播放类
	 * 
	 */
	public class KeyFrameAnimation extends AnimationPlayerBase
	{
		public function KeyFrameAnimation()
		{
			if(sortIndexFun==null)
			{
				sortIndexFun=MathUtil.SortByKey("index",false,true);	
			}
		}
		/**@private */
		private static var sortIndexFun:Function;
		/**
		 * id对象表
		 */
		public var targetDic:Object;
		/**
		 *  动画数据
		 */
		public var animationData:Object;
		
		/**
		 * 初始化动画数据
		 * @param targetDic 对象表
		 * @param animationData 动画数据
		 * 
		 */
		public function setUp(targetDic:Object,animationData:Object):void
		{
			_labels = null;
			this.targetDic=targetDic;
			this.animationData = animationData;
			interval = 1000 / animationData.frameRate;
			calculateDatas();
		}
		/**@inheritDoc */
		override public function clear():void
		{
			super.clear();
			targetDic=null;
			animationData=null;
		}
		/**
		 * 将节点设置到某一帧的状态
		 * @param frame
		 * 
		 */
		public function displayToFrame(frame:int):void
		{
			if(!animationData) return;
			if(frame<0) frame=0;
			if(frame>_count) frame=_count;
			var nodes:Array=animationData.nodes,i:int,len:int=nodes.length;		
			for(i=0;i<len;i++)
			{
				displayNodeToFrame(nodes[i],frame);
			}
		}
		/**@inheritDoc */
		override protected function displayToIndex(value:int):void
		{
			displayToFrame(value);
		}
		/**
		 * 将节点设置到某一帧的状态
		 * @param node 节点ID
		 * @param frame 
		 * @param targetDic 节点表
		 * 
		 */
		public function displayNodeToFrame(node:Object,frame:int,targetDic:Object=null):void
		{
			if(!targetDic) targetDic=this.targetDic;
			var target:Object=targetDic[node.target];
			if(!target)
			{
				//trace("loseTarget:",node.target);
				return;
			}
			var frames:Array=node.frames,key:String,propFrames:Array,value:*;
			for(key in frames)
			{
				propFrames=frames[key];
				if(propFrames.length>frame)
				{
					value=propFrames[frame];
				}else
				{
					value=propFrames[propFrames.length-1];
				}
				target[key]=value;
			}
		}
		/**
		 * @private
		 * 计算帧数据
		 * 
		 */
		private function calculateDatas():void
		{
			if(!animationData) return;
			var nodes:Array=animationData.nodes,i:int,len:int=nodes.length,tNode:Object;
			_count=0;
			for(i=0;i<len;i++)
			{
				tNode=nodes[i];
				calculateNodeKeyFrames(tNode);
			}
		}
		/**
		 * @private
		 * 计算某个节点的帧数据
		 * @param node
		 * 
		 */
		private function calculateNodeKeyFrames(node:Object):void
		{			
			var keyFrames:Object=node.keyframes,key:String,tKeyFrames:Array,target:int=node.target;
			if(!node.frames)
			{
				node.frames={};
			}
			for(key in keyFrames)
			{
				tKeyFrames=keyFrames[key];
				if(!node.frames[key])
				{
					node.frames[key]=[];
				}	
				tKeyFrames.sort(sortIndexFun);	
				calculateNodePropFrames(tKeyFrames,node.frames[key],key,target);
			}
		}		
		/**
		 * @private
		 * 计算节点某个属性的帧数据
		 * @param keyframes
		 * @param frames
		 * @param key
		 * @param target
		 * 
		 */
		private function calculateNodePropFrames(keyframes:Array,frames:Array,key:String,target:int):void
		{		
			var i:int,len:int=keyframes.length-1;	
			frames.length=keyframes[len].index+1;
			for(i=0;i<len;i++)
			{
				dealKeyFrame(keyframes[i]);
				calculateFrameValues(keyframes[i],keyframes[i+1],frames);
			}
			if(len==0)
			{
				frames[0]=keyframes[0].value;
			}		
			dealKeyFrame(keyframes[i]);
		}
		/**
		 * @private 
		 * 
		 */		
		private function dealKeyFrame(keyFrame:Object):void
		{
			if (keyFrame.label&&keyFrame.label != "") addLabel(keyFrame.label, keyFrame.index);
		}
		/**
		 * @private
		 * 计算两个关键帧直接的帧数据
		 * @param startFrame
		 * @param endFrame
		 * @param result
		 * 
		 */
		private function calculateFrameValues(startFrame:Object,endFrame:Object,result:Array):void
		{
			var i:int,easeFun:Function;
			var start:int=startFrame.index,end:int=endFrame.index;
			var startValue:Number=startFrame.value;
			var dValue:Number=endFrame.value-startFrame.value;
			var dLen:int=end-start;
			if(end>_count) _count=end;
			if(startFrame.tween)
			{
				easeFun=Ease[startFrame.tweenMethod];
				if(easeFun==null)
				{
					easeFun=Ease.linearNone;
				}		
				for(i=start;i<end;i++)
				{
					result[i]=easeFun(i-start,startValue,dValue,dLen);
				}
			}else
			{
				for(i=start;i<end;i++)
				{
					result[i]=startValue;
				}
			}
			result[endFrame.index]=endFrame.value;
		}
	}	
}