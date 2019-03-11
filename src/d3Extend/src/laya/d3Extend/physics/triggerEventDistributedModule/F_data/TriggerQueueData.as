package triggerEventDistributedModule.F_data {
import laya.d3.core.Sprite3D;

import triggerEventDistributedModule.E_function.cell.GlobalOnlyValueCell;

public class TriggerQueueData {

    public var thisBody:Sprite3D;
    public var otherBody:Sprite3D;

    public function TriggerQueueData(thisBody:Sprite3D, otherBody:Sprite3D) {
        this.thisBody = thisBody;
        this.otherBody = otherBody;
    }
    /**
     * 根据两个对象，生成key
     * @param thisBody
     * @param otherBody
     * @return
     */
    public function getKey():String
    {
        if(!thisBody["onlyID"])
        {
            thisBody["onlyID"] = GlobalOnlyValueCell.getOnlyID();
        }
        if(!otherBody["onlyID"])
        {
            otherBody["onlyID"] = GlobalOnlyValueCell.getOnlyID();
        }
        return thisBody["onlyID"]>otherBody["onlyID"]?otherBody["onlyID"]+"_"+thisBody["onlyID"]:thisBody["onlyID"]+"_"+otherBody["onlyID"];
    }


}
}
