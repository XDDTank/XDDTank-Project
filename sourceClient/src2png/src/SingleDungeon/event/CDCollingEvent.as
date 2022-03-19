// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.event.CDCollingEvent

package SingleDungeon.event
{
    import flash.events.Event;

    public class CDCollingEvent extends Event 
    {

        public static const CD_COLLING:String = "CD_colling";
        public static const CD_UPDATE:String = "CDUpdate";
        public static const CD_STOP:String = "CDStop";

        public var ID:int;
        public var count:int;
        public var collingTime:int;

        public function CDCollingEvent(_arg_1:String)
        {
            super(_arg_1);
        }

    }
}//package SingleDungeon.event

