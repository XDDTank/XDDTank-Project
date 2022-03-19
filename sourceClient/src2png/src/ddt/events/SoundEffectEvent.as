// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.events.SoundEffectEvent

package ddt.events
{
    import flash.events.Event;

    public class SoundEffectEvent extends Event 
    {

        public var soundInfo:Object;

        public function SoundEffectEvent(_arg_1:String, _arg_2:Object, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            this.soundInfo = _arg_2;
            super(_arg_1, _arg_3, _arg_4);
        }

    }
}//package ddt.events

