package physics.triggerEventDistributedModule.E_function.cell {

public class GlobalOnlyValueCell {

    private static var currentID:Number=0;

    public static function getOnlyID():Number
    {
        currentID +=1;
        return currentID;
    }
}
}
