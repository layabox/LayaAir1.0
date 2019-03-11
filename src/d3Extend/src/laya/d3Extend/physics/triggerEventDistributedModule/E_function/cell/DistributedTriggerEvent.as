package triggerEventDistributedModule.E_function.cell {
import triggerEventDistributedModule.F_data.LayaDictionary;
import triggerEventDistributedModule.F_data.TriggerEvent;
import triggerEventDistributedModule.F_data.TriggerQueueData;

public class DistributedTriggerEvent {
    /**
     * 感觉触发对派发事件
     * @param lastTriggerQueue 上一帧触发对列表会被修改
     * @param currentTriggerQueue 当前帧触发对列表不会被修改
     */
    public static function distributedAllEvent(lastTriggerQueue:LayaDictionary,currentTriggerQueue:LayaDictionary)
    {
        debugger;
        for(var i:Number = 0,len = currentTriggerQueue.length;i<len;i++)
        {
            var key:String = currentTriggerQueue.keys[i];
            if(lastTriggerQueue.indexOf(key)!=-1)
            {
                /**
                 * 派发事件：如果上一帧触发对列表中存在该触发对，则表示该触发对处于Stay状态
                 */
                distributedEvent(TriggerEvent.TRIGGER_STAY,currentTriggerQueue.values[i]);
                /**
                 * 从上一针触发对列表中移除该触发对，为Exit状态做准备
                 */
                lastTriggerQueue.remove(key);
            }
            else
            {
                /**
                 * 派发事件：如果上一帧触发对列表中不存在该触发对，则表示该触发对处于Enter状态
                 */
                distributedEvent(TriggerEvent.TRIGGER_ENTER,currentTriggerQueue.values[i]);
            }
        }
        for(var i:Number = 0,len = lastTriggerQueue.length;i<len;i++)
        {
            /**
             * 派发事件：上一帧触发对列表中存在，但是当前帧列表中不存在的触发对，说明处于Exit状态
             */
            distributedEvent(TriggerEvent.TRIGGER_EXIT,lastTriggerQueue.values[i]);
        }
    }
    public static function distributedEvent(triggerEvent:String,queue:TriggerQueueData)
    {
        queue.thisBody.event(triggerEvent,queue.otherBody);
        queue.otherBody.event(triggerEvent,queue.thisBody);
    }
}
}
