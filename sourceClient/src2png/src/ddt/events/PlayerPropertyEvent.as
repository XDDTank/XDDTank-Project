// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.PlayerPropertyEvent

package ddt.events
{
    import flash.events.Event;
    import flash.utils.Dictionary;

    public class PlayerPropertyEvent extends Event 
    {

        public static const PROPERTY_CHANGE:String = "propertychange";

        private var _changedProperties:Dictionary;
        private var _lastValue:Dictionary;

        public function PlayerPropertyEvent(_arg_1:String, _arg_2:Dictionary, _arg_3:Dictionary=null)
        {
            this._changedProperties = _arg_2;
            this._lastValue = _arg_3;
            super(_arg_1);
        }

        public function get changedProperties():Dictionary
        {
            return (this._changedProperties);
        }

        public function get lastValue():Dictionary
        {
            return (this._lastValue);
        }


    }
}//package ddt.events

