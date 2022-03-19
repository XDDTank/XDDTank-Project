// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.GoodsEvent

package ddt.events
{
    import flash.events.Event;

    public class GoodsEvent extends Event 
    {

        public static const PROPERTY_CHANGE:String = "propertyChange";

        public var property:String = "";
        public var value:*;

        public function GoodsEvent(_arg_1:String, _arg_2:String="", _arg_3:*=null, _arg_4:Boolean=false, _arg_5:Boolean=false)
        {
            this.property = _arg_2;
            this.value = _arg_3;
            super(_arg_1, _arg_4, _arg_5);
        }

    }
}//package ddt.events

