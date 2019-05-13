package physics.triggerEventDistributedModule.D_manager {

import physics.CubePhysicsCompnent;
import physics.triggerEventDistributedModule.E_function.cell.DistributedTriggerEvent;
import physics.triggerEventDistributedModule.E_function.cell.TriggerStateDetection;


public class TriggerManager {
    private static var _instance:TriggerManager;
    public static function get instance():TriggerManager {
        if (!_instance) {
            _instance = new TriggerManager();
        }
        return _instance;
    }

    private var staticSprite3D:Object;

    private var dySprite3D:Object;

    public var triggerStateDetection:TriggerStateDetection;

    public var distributedTriggerEvent:DistributedTriggerEvent;
    public function TriggerManager() {
        staticSprite3D = {};
        dySprite3D = {};
        triggerStateDetection = new TriggerStateDetection();
        distributedTriggerEvent=new DistributedTriggerEvent();
        Laya.timer.frameLoop(1, this, detection)
    }

    private function detection() {
        triggerStateDetection.allTriggerDetection(staticSprite3D, dySprite3D);

        distributedTriggerEvent.distributedAllEvent(triggerStateDetection.lastTriggerQueue, triggerStateDetection.triggerQueue);
    }

    public function addStatic(trigger:CubePhysicsCompnent) {
        staticSprite3D[trigger.onlyID] = trigger;
    }

    public function addDY(trigger:CubePhysicsCompnent) {
        dySprite3D[trigger.onlyID] = trigger;
    }

    public function removeStatic(trigger:CubePhysicsCompnent) {
        delete staticSprite3D[trigger.onlyID];
    }

    public function removeDY(trigger:CubePhysicsCompnent) {
        delete dySprite3D[trigger.onlyID];
    }
}
}
