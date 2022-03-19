// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.event.ConsortionEvent

package consortion.event
{
    import flash.events.Event;

    public class ConsortionEvent extends Event 
    {

        public static const CONSORTIONLIST_IS_CHANGE:String = "consortionListIsChange";
        public static const MY_APPLY_LIST_IS_CHANGE:String = "myApplyListIsChange";
        public static const INVENT_LIST_IS_CHANGE:String = "inventListIsChange";
        public static const LEVEL_UP_RULE_CHANGE:String = "levelUpRuleChange";
        public static const EVENT_LIST_CHANGE:String = "eventListChange";
        public static const USE_CONDITION_CHANGE:String = "useConditionChange";
        public static const DUTY_LIST_CHANGE:String = "dutyListChange";
        public static const POLL_LIST_CHANGE:String = "pollListChange";
        public static const SKILL_LIST_CHANGE:String = "skillListChange";
        public static const SKILL_STATE_CHANGE:String = "skillStateChange";
        public static const MEMBERLIST_COMPLETE:String = "memberListLoadComplete";
        public static const MEMBER_ADD:String = "addMember";
        public static const MEMBER_REMOVE:String = "removeMember";
        public static const MEMBER_UPDATA:String = "memberUpdata";
        public static const CONSORTION_STATE_CHANGE:String = "consortionStateChange";
        public static const CONSORTION_TASK_LEVEL_CHANGE:String = "consortionTaskLevelChange";
        public static const TRANSPORT_ADD_CAR:String = "transportAddCar";
        public static const TRANSPORT_REMOVE_CAR:String = "transportRemoveCar";
        public static const UPDATE_MY_INFO:String = "update_my_info";
        public static const BUY_HIGH_LEVEL_CAR:String = "buy_high_level_car";
        public static const REFLASH_CAMPAIGN_ITEM:String = "reflash_campaign_item";
        public static const TRANSPORT_ADD_MESSAGE:String = "transportAddMessage";
        public static const TRANSPORT_CAR_BEGIN_CONVOY:String = "transportCarBeginConvoy";
        public static const REMOVE_GUARDER:String = "remove_guarder";
        public static const ENABLE_SENDCAR_BTN:String = "enable_sendcar_btn";
        public static const GUARDER_IS_LEAVING:String = "guarderIsleaving";
        public static const CHARMAN_CHANGE:String = "charmanChange";
        public static const CLUB_ITEM_SELECTED:String = "ClubItemSelected";
        public static const CLUB_ITEM_APPLY:String = "clubItemApply";
        public static const REFRESH_GOOD:String = "RefreshGood";

        public var data:Object;

        public function ConsortionEvent(_arg_1:String, _arg_2:Object=null)
        {
            super(_arg_1);
            this.data = _arg_2;
        }

    }
}//package consortion.event

