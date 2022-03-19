// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.player.CivilPlayerInfo

package ddt.data.player
{
    import flash.events.EventDispatcher;

    public class CivilPlayerInfo extends EventDispatcher 
    {

        private var _info:PlayerInfo;
        public var MarryInfoID:int;
        public var IsPublishEquip:Boolean;
        public var Introduction:String;
        public var IsConsortia:Boolean;
        public var UserId:Number;


        public function set info(_arg_1:PlayerInfo):void
        {
            this._info = _arg_1;
        }

        public function get info():PlayerInfo
        {
            return (this._info);
        }


    }
}//package ddt.data.player

