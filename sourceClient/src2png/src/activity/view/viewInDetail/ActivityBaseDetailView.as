// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.viewInDetail.ActivityBaseDetailView

package activity.view.viewInDetail
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import activity.data.ActivityConditionInfo;
    import activity.data.ActivityInfo;
    import activity.ActivityController;
    import ddt.manager.PlayerManager;
    import activity.view.ActivityCell;
    import activity.data.ActivityGiftbagInfo;
    import activity.data.ActivityRewardInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ActivityBaseDetailView extends Sprite implements Disposeable 
    {

        protected var _panel:ScrollPanel;
        protected var _cellList:SimpleTileList;
        protected var _giftBags:DictionaryData;
        protected var _conditions:Vector.<ActivityConditionInfo>;
        protected var _rewars:DictionaryData;
        protected var _cellNumInRow:int = 0;
        protected var _info:ActivityInfo;

        public function ActivityBaseDetailView()
        {
            this.initView();
            this.initEvent();
        }

        public function get log():int
        {
            return (ActivityController.instance.model.getLog(this.info.ActivityId));
        }

        public function get nowState():int
        {
            if (ActivityController.instance.checkOpenFight(this._info))
            {
                return (PlayerManager.Instance.Self.FightPower);
            };
            if (ActivityController.instance.checkOpenLevel(this._info))
            {
                return (PlayerManager.Instance.Self.Grade);
            };
            if (ActivityController.instance.checkOpenConsortiaLevel(this._info))
            {
                return (PlayerManager.Instance.Self.consortiaInfo.Level);
            };
            return (int(ActivityController.instance.model.getState(this.info.ActivityId)));
        }

        public function get info():ActivityInfo
        {
            return (this._info);
        }

        public function setCellFilter(_arg_1:ActivityCell, _arg_2:int):void
        {
            if (_arg_2 <= ActivityController.instance.model.getLog(this._info.ActivityId))
            {
                _arg_1.canGet = false;
                _arg_1.hasGet = true;
            };
        }

        public function get enable():Boolean
        {
            var _local_1:String;
            if (this.canAcceptByRecieveNum)
            {
                for each (_local_1 in this.conditions)
                {
                    if (((this.nowState >= int(_local_1)) && (int(_local_1) > this.log)))
                    {
                        return (true);
                    };
                };
            };
            return (false);
        }

        public function get canAcceptByRecieveNum():Boolean
        {
            if (((this.info.GetWay == 0) || (this.info.receiveNum < this.info.GetWay)))
            {
                return (true);
            };
            return (false);
        }

        public function get conditions():Array
        {
            var _local_2:ActivityConditionInfo;
            var _local_1:Array = new Array();
            for each (_local_2 in this._conditions)
            {
                if (_local_2.ConditionIndex == 0)
                {
                    _local_1.push(_local_2.ConditionValue);
                };
                if (((ActivityController.instance.checkTotalMoeny(this._info)) && (_local_1.length >= 6))) break;
            };
            return (_local_1);
        }

        public function set info(_arg_1:ActivityInfo):void
        {
            var _local_3:ActivityGiftbagInfo;
            var _local_4:Array;
            var _local_5:ActivityConditionInfo;
            var _local_6:DictionaryData;
            var _local_7:ActivityRewardInfo;
            this._info = _arg_1;
            this._rewars = new DictionaryData();
            this._giftBags = new DictionaryData();
            this._conditions = new Vector.<ActivityConditionInfo>();
            if (this._cellList)
            {
                this._cellList.disposeAllChildren();
            };
            var _local_2:Array = ActivityController.instance.getAcitivityGiftBagByActID(this.info.ActivityId);
            for each (_local_3 in _local_2)
            {
                if ((!(this._giftBags[_local_3.GiftbagOrder])))
                {
                    this._giftBags[_local_3.GiftbagOrder] = new DictionaryData();
                };
                this._giftBags[_local_3.GiftbagOrder].add(_local_3.GiftbagId, _local_3);
                _local_4 = ActivityController.instance.getActivityConditionByGiftbagID(_local_3.GiftbagId);
                for each (_local_5 in _local_4)
                {
                    this._conditions.push(_local_5);
                };
                _local_6 = ActivityController.instance.getRewardsByGiftbagID(_local_3.GiftbagId);
                for each (_local_7 in _local_6)
                {
                    this._rewars.add(_local_7.TemplateId, _local_7);
                };
            };
            this.initCells();
        }

        protected function initCells():void
        {
            var _local_1:ActivityCell;
            var _local_2:int;
            while (_local_2 < this._rewars.length)
            {
                _local_1 = new ActivityCell(this._rewars.list[_local_2]);
                _local_1.count = this._rewars.list[_local_2].Count;
                this._cellList.addChild(_local_1);
                if (_local_2 >= this.conditions.length)
                {
                    this.setCellFilter(_local_1, this.conditions[0]);
                }
                else
                {
                    this.setCellFilter(_local_1, this.conditions[_local_2]);
                };
                _local_2++;
            };
            this._panel.vScrollProxy = ((this._cellList.numChildren > this._cellNumInRow) ? 0 : 2);
        }

        protected function initView():void
        {
        }

        protected function initEvent():void
        {
        }

        protected function removeEvent():void
        {
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._cellList)
            {
                this._cellList.disposeAllChildren();
                ObjectUtils.disposeObject(this._cellList);
                this._cellList = null;
            };
            ObjectUtils.disposeObject(this._panel);
            this._panel = null;
            this._giftBags = null;
        }


    }
}//package activity.view.viewInDetail

