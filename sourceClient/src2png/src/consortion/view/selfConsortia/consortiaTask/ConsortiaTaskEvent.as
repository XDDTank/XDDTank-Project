// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.consortiaTask.ConsortiaTaskEvent

package consortion.view.selfConsortia.consortiaTask
{
    import flash.events.Event;

    public class ConsortiaTaskEvent extends Event 
    {

        public static const GETCONSORTIATASKINFO:String = "getConsortiaTaskInfo";

        public var value:int;

        public function ConsortiaTaskEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

    }
}//package consortion.view.selfConsortia.consortiaTask

