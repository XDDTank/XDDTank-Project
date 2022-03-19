// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.viewInDetail.open.ActivityOpenConsortiaLevel

package activity.view.viewInDetail.open
{
    import activity.view.viewInDetail.ActivityBaseDetailView;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.controls.ScrollPanel;
    import ddt.manager.PlayerManager;
    import activity.data.ActivityGiftbagInfo;
    import activity.data.ActivityConditionInfo;
    import activity.data.ActivityRewardInfo;
    import activity.ActivityController;
    import activity.data.ActivityInfo;
    import activity.view.ActivityCell;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class ActivityOpenConsortiaLevel extends ActivityBaseDetailView 
    {

        private var _cellList2:SimpleTileList;
        private var _rewars2:DictionaryData;
        private var _panel2:ScrollPanel;


        override public function get enable():Boolean
        {
            if (PlayerManager.Instance.isLeadOfConsortia)
            {
                return (super.enable);
            };
            return (false);
        }

        override public function set info(_arg_1:ActivityInfo):void
        {
            var _local_3:ActivityGiftbagInfo;
            var _local_4:Array;
            var _local_5:ActivityConditionInfo;
            var _local_6:DictionaryData;
            var _local_7:ActivityRewardInfo;
            _info = _arg_1;
            _rewars = new DictionaryData();
            this._rewars2 = new DictionaryData();
            _giftBags = new DictionaryData();
            _conditions = new Vector.<ActivityConditionInfo>();
            _cellList.disposeAllChildren();
            this._cellList2.disposeAllChildren();
            var _local_2:Array = ActivityController.instance.getAcitivityGiftBagByActID(info.ActivityId);
            for each (_local_3 in _local_2)
            {
                if ((!(_giftBags[_local_3.GiftbagOrder])))
                {
                    _giftBags[_local_3.GiftbagOrder] = new DictionaryData();
                };
                _giftBags[_local_3.GiftbagOrder][_local_3.GiftbagId] = _local_3;
                _local_4 = ActivityController.instance.getActivityConditionByGiftbagID(_local_3.GiftbagId);
                for each (_local_5 in _local_4)
                {
                    _conditions.push(_local_5);
                };
                _local_6 = ActivityController.instance.getRewardsByGiftbagID(_local_3.GiftbagId);
                for each (_local_7 in _local_6)
                {
                    if (_local_3.RewardMark == 0)
                    {
                        _rewars.add(_local_7.TemplateId, _local_7);
                    }
                    else
                    {
                        if (_local_3.RewardMark == 1)
                        {
                            this._rewars2.add(_local_7.TemplateId, _local_7);
                        };
                    };
                };
            };
            this.initCells();
        }

        override protected function initCells():void
        {
            var _local_1:ActivityCell;
            var _local_2:int;
            while (_local_2 < _rewars.length)
            {
                _local_1 = new ActivityCell(_rewars.list[_local_2]);
                _local_1.count = _rewars.list[_local_2].Count;
                setCellFilter(_local_1, conditions[0]);
                _cellList.addChild(_local_1);
                _local_2++;
            };
            var _local_3:int;
            while (_local_3 < this._rewars2.length)
            {
                _local_1 = new ActivityCell(this._rewars2.list[_local_3]);
                _local_1.count = this._rewars2.list[_local_3].Count;
                setCellFilter(_local_1, conditions[0]);
                this._cellList2.addChild(_local_1);
                _local_3++;
            };
            _panel.vScrollProxy = ((_cellList.numChildren > _cellNumInRow) ? 0 : 2);
            this._panel2.vScrollProxy = ((this._cellList2.numChildren > _cellNumInRow) ? 0 : 2);
        }

        override protected function initView():void
        {
            _cellNumInRow = 2;
            _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenConsortiaLevel.cellList", [_cellNumInRow]);
            addChild(_cellList);
            _panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.OpenConsortiaLevel.cellPanel");
            addChild(_panel);
            _panel.setView(_cellList);
            this._cellList2 = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityOpenConsortiaLevel.cellList2", [_cellNumInRow]);
            addChild(this._cellList2);
            this._panel2 = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.OpenConsortiaLevel.cellPanel2");
            addChild(this._panel2);
            this._panel2.setView(this._cellList2);
            super.initView();
        }

        override public function dispose():void
        {
            this._cellList2.disposeAllChildren();
            ObjectUtils.disposeObject(this._cellList2);
            this._cellList2 = null;
            ObjectUtils.disposeObject(this._panel2);
            this._panel2 = null;
            super.dispose();
        }


    }
}//package activity.view.viewInDetail.open

