// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//civil.CivilEvent

package civil
{
    import flash.events.Event;

    public class CivilEvent extends Event 
    {

        public static const CIVIL_PLAYERINFO_ARRAY_CHANGE:String = "civilplayerinfoarraychange";
        public static const CIVIL_MARRY_STATE_CHANGE:String = "civilmarrystatechange";
        public static const SELECT_CLICK_ITEM:String = "selectclickitem";
        public static const CIVIL_UPDATE:String = "CivilUpdate";
        public static const CIVIL_UPDATE_BTN:String = "CivilUpdateBtn";
        public static const SELECTED_CHANGE:String = "selected_change";
        public static const REGISTER_CHANGE:String = "register_change";

        public var data:Object;

        public function CivilEvent(_arg_1:String, _arg_2:Object=null)
        {
            super(_arg_1, _arg_2);
            this.data = _arg_2;
        }

    }
}//package civil

