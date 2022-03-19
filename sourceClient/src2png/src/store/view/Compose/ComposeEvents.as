// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.Compose.ComposeEvents

package store.view.Compose
{
    import flash.events.Event;

    public class ComposeEvents extends Event 
    {

        public static const ITEM_BIG_UPDATE:String = "itemBigUpdate";
        public static const CLICK_BIG_ITEM:String = "clickBigItem";
        public static const CLICK_MIDDLE_ITEM:String = "clickMiddleItem";
        public static const CLICK_SMALL_ITEM:String = "clickSmallItem";
        public static const START_COMPOSE:String = "startCompose";
        public static const COMPOSE_COMPLETE:String = "composeComplete";
        public static const GET_SKILLS_COMPLETE:String = "getSkillsComplete";

        private var _num:int;

        public function ComposeEvents(_arg_1:String, _arg_2:int=-1, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this._num = _arg_2;
        }

        public function get num():int
        {
            return (this._num);
        }


    }
}//package store.view.Compose

