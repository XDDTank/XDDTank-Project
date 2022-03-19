// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.player.AcademyPlayerInfo

package ddt.data.player
{
    import flash.events.EventDispatcher;

    public class AcademyPlayerInfo extends EventDispatcher 
    {

        private var _info:PlayerInfo;
        public var Introduction:String;
        public var IsPublishEquip:Boolean;


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

