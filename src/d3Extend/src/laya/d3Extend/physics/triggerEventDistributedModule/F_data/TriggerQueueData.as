package physics.triggerEventDistributedModule.F_data {
import laya.d3Extend.physics.CubePhysicsCompnent;
public class TriggerQueueData {

    public var thisBody:CubePhysicsCompnent;
    public var otherBody:CubePhysicsCompnent;

    public function TriggerQueueData() {
    }

    /**
     * 根据两个对象，生成key
     * @param thisBody
     * @param otherBody
     * @return
     */
    public function getKey():String {
        return thisBody.onlyID > otherBody.onlyID ? otherBody.onlyID + "_" + thisBody.onlyID : thisBody.onlyID+ "_" + otherBody.onlyID;
    }

    public function setBody(thisBody:CubePhysicsCompnent, otherBody:CubePhysicsCompnent) {
        this.thisBody = thisBody;
        this.otherBody = otherBody;
    }

}
}
