package triggerEventDistributedModule.E_function.cell {

import laya.d3.core.Sprite3D;

import triggerEventDistributedModule.F_data.LayaDictionary;
import triggerEventDistributedModule.F_data.TriggerQueueData;


public class TriggerStateDetection {
    /**
     * eg:function(a:Sprite3D,b:Sprite3D):Boolean
     */
    private var triggerDetection:Function;

    private var _lastTriggerQueue:LayaDictionary;

    private var _triggerQueue:LayaDictionary;

    public function TriggerStateDetection(triggerDetection:Function) {
        this.triggerDetection = triggerDetection;
        this._lastTriggerQueue = new LayaDictionary();
        this._triggerQueue = new LayaDictionary();
    }

    /**
     * 设置触发检测方法
     * @param detection eg:function(a:Sprite3D,b:Sprite3D):Boolean
     */
    public function setTriggerDetectionFunction(detection:Function) {
        if (detection) {
            triggerDetection = detection;
        }
    }

    /**
     * 将两个列表中的数据都进行触发检测
     * @param staticSprite3DQueue
     * @param dynamicSprite3DQueue
     */
    public function allTriggerDetection(staticSprite3DQueue:Vector.<Sprite3D>, dynamicSprite3DQueue:Vector.<Sprite3D>) {
        debugger;
        var mid:LayaDictionary = _lastTriggerQueue;
        _lastTriggerQueue = _triggerQueue;
        _triggerQueue = mid;
        _triggerQueue.release();
        if (!dynamicSprite3DQueue) {
            return;
        }

        for (var i:Number = 0, dlen:Number = dynamicSprite3DQueue.length; i < dlen; i++) {
            for (var j:Number = 0, slen:Number = staticSprite3DQueue.length; j < slen; j++) {
                singleTriggerDetection(dynamicSprite3DQueue[i], staticSprite3DQueue[j]);
            }
            for (var k:Number = i + 1; k < dlen; k++) {
                singleTriggerDetection(dynamicSprite3DQueue[i], dynamicSprite3DQueue[k]);
            }
        }
    }

    /**
     * 对两个对象进行碰撞检测
     * @param thisBody
     * @param otherBody
     */
    public function singleTriggerDetection(thisBody:Sprite3D, otherBody:Sprite3D) {
        if (triggerDetection != null) {
            var isTrigger:Boolean = triggerDetection(thisBody, otherBody);
            if (isTrigger) {
                var data:TriggerQueueData = new TriggerQueueData(thisBody, otherBody);
                _triggerQueue.add(data.getKey(),data);
            }
        }
    }


    public function get lastTriggerQueue():LayaDictionary {
        return _lastTriggerQueue;
    }

    public function get triggerQueue():LayaDictionary {
        return _triggerQueue;
    }
}
}
