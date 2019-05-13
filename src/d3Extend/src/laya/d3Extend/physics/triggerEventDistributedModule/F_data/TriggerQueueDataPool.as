package physics.triggerEventDistributedModule.F_data {

public class TriggerQueueDataPool {
    private static var _instance:TriggerQueueDataPool;

    public var pool:Array;
    public var point:int = 0;

    public function TriggerQueueDataPool() {
    }

    public function init(len:int) {
        pool = [];
        pool.length = len;
        for (var i = 0; i < len; i++) {
            if (!pool[i]) {
                pool[i] = new TriggerQueueData();
            }
        }
    }

    public function get():TriggerQueueData {
        point--;
        if (point == -1) {
            point = 0;
            return new TriggerQueueData();
        }
        else {
            return pool[point];
        }
    }

    public function giveBack(value:TriggerQueueData) {
        point++;
        if (point == pool.length) {
            pool.push(value);
        }
        else {
            pool[point] = value;
        }
    }

    public static function get instance():TriggerQueueDataPool {
        if (!_instance) {
            _instance = new TriggerQueueDataPool();
        }
        return _instance;
    }
}
}
