// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.effort.EffortInfo

package ddt.data.effort
{
    import flash.events.EventDispatcher;
    import com.pickgliss.ui.controls.cell.INotSameHeightListCellData;
    import road7th.data.DictionaryData;
    import ddt.events.EffortEvent;

    public class EffortInfo extends EventDispatcher implements INotSameHeightListCellData 
    {

        public var ID:int;
        public var PlaceID:int;
        public var Title:String;
        public var Detail:String;
        public var NeedMinLevel:int;
        public var NeedMaxLevel:int;
        public var PreAchievementID:String;
        public var IsOther:Boolean;
        public var AchievementType:int;
        public var CanHide:Boolean;
        public var StartDate:Date;
        public var EndDate:Date;
        public var AchievementPoint:int;
        public var EffortQualificationList:DictionaryData;
        public var effortRewardArray:Array;
        private var effortCompleteState:EffortCompleteStateInfo;
        public var isAddToList:Boolean;
        public var picId:int;
        public var completedDate:Date;
        public var isSelect:Boolean;
        public var maxHeight:int = 95;
        public var minHeight:int = 95;


        public function set CompleteStateInfo(_arg_1:EffortCompleteStateInfo):void
        {
            this.effortCompleteState = _arg_1;
        }

        public function get CompleteStateInfo():EffortCompleteStateInfo
        {
            return (this.effortCompleteState);
        }

        public function update():void
        {
            dispatchEvent(new EffortEvent(EffortEvent.CHANGED));
        }

        public function testIsComplete():void
        {
        }

        public function addEffortQualification(_arg_1:EffortQualificationInfo):void
        {
            if ((!(this.EffortQualificationList)))
            {
                this.EffortQualificationList = new DictionaryData();
            };
            this.EffortQualificationList[_arg_1.CondictionType] = _arg_1;
            this.update();
        }

        public function addEffortReward(_arg_1:EffortRewardInfo):void
        {
            if ((!(this.effortRewardArray)))
            {
                this.effortRewardArray = [];
            };
            this.effortRewardArray.push(_arg_1);
        }

        public function getCellHeight():Number
        {
            if (this.isSelect)
            {
                return (this.maxHeight);
            };
            return (this.minHeight);
        }


    }
}//package ddt.data.effort

