// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//cityWide.CityWideEvent

package cityWide
{
    import flash.events.Event;
    import ddt.data.player.PlayerInfo;

    public class CityWideEvent extends Event 
    {

        public static const ONS_PLAYERINFO:String = "ons_playerInfo";

        private var _playerInfo:PlayerInfo;

        public function CityWideEvent(_arg_1:String, _arg_2:PlayerInfo=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this._playerInfo = _arg_2;
        }

        public function get playerInfo():PlayerInfo
        {
            return (this._playerInfo);
        }


    }
}//package cityWide

