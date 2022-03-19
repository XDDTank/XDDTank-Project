// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.events.ComponentEvent

package com.pickgliss.events
{
    import flash.events.Event;
    import flash.utils.Dictionary;

    public class ComponentEvent extends Event 
    {

        public static const PROPERTIES_CHANGED:String = "propertiesChanged";
        public static const DISPOSE:String = "dispose";

        private var _changedProperties:Dictionary;

        public function ComponentEvent(_arg_1:String, _arg_2:Dictionary=null)
        {
            this._changedProperties = _arg_2;
            super(_arg_1);
        }

        public function get changedProperties():Dictionary
        {
            return (this._changedProperties);
        }


    }
}//package com.pickgliss.events

