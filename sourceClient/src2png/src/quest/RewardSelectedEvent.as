// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.RewardSelectedEvent

package quest
{
    import flash.events.Event;

    public class RewardSelectedEvent extends Event 
    {

        public static var ITEM_SELECTED:String = "ItemSelected";

        private var _itemCell:QuestRewardCell;

        public function RewardSelectedEvent(_arg_1:QuestRewardCell, _arg_2:String="ItemSelected", _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_2, _arg_3, _arg_4);
            this._itemCell = _arg_1;
        }

        public function get itemCell():QuestRewardCell
        {
            return (this._itemCell);
        }


    }
}//package quest

