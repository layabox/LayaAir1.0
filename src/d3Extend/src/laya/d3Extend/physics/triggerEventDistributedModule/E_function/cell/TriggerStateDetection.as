package physics.triggerEventDistributedModule.E_function.cell {

import laya.d3Extend.physics.CubePhysicsCompnent;
import laya.d3Extend.physics.triggerEventDistributedModule.F_data.TriggerQueueData;
import laya.d3Extend.physics.triggerEventDistributedModule.F_data.TriggerQueueDataPool;

public class TriggerStateDetection {

    private var _lastTriggerQueue:Object;

    private var _triggerQueue:Object;

    public function TriggerStateDetection() {
        this._lastTriggerQueue = {};
        this._triggerQueue = {};
        TriggerQueueDataPool.instance.init(100);
    }

    /**
     * 将两个列表中的数据都进行触发检测
     * @param staticSprite3DQueue
     * @param dynamicSprite3DQueue
     */
    public function allTriggerDetection(staticSprite3DQueue:Object, dynamicSprite3DQueue:Object) {
        _lastTriggerQueue = _triggerQueue;
        _triggerQueue = {};
        if (!dynamicSprite3DQueue) {
            return;
        }
        for(var i in dynamicSprite3DQueue)
        {
            var body:CubePhysicsCompnent= dynamicSprite3DQueue[i];
            body.isDetection = false;
        }
        for(var i in dynamicSprite3DQueue)
        {
            var body:CubePhysicsCompnent= dynamicSprite3DQueue[i];
            for(var j in staticSprite3DQueue)
            {
                singleTriggerDetection(body, staticSprite3DQueue[j]);
            }
            for(var k in dynamicSprite3DQueue)
            {
                var target:CubePhysicsCompnent = dynamicSprite3DQueue[k];
                if(!target.isDetection)
                {
                    singleTriggerDetection(body,target);
                }
            }
            body.isDetection = true;
        }
    }

    /**
     * 对两个对象进行碰撞检测
     * @param thisBody
     * @param otherBody
     */
    private function singleTriggerDetection(thisBody:CubePhysicsCompnent, otherBody:CubePhysicsCompnent) {
        if(thisBody.onlyID!=otherBody.onlyID)
        {
            var isTrigger:Boolean = thisBody.isCollision(otherBody);
            if (isTrigger) {
                var data:TriggerQueueData = TriggerQueueDataPool.instance.get();
                data.setBody(thisBody,otherBody);
                var key:String = getKey(thisBody,otherBody);
                _triggerQueue[key] = data;
            }
        }
    }
    /**
     * 根据两个对象，生成key
     * @param thisBody
     * @param otherBody
     * @return
     */
    private function getKey(thisBody:CubePhysicsCompnent, otherBody:CubePhysicsCompnent):String {
        return thisBody.onlyID > otherBody.onlyID ? otherBody.onlyID + "_" + thisBody.onlyID : thisBody.onlyID+ "_" + otherBody.onlyID;
    }

    public function get lastTriggerQueue():Object {
        return _lastTriggerQueue;
    }

    public function get triggerQueue():Object {
        return _triggerQueue;
    }
}
}
