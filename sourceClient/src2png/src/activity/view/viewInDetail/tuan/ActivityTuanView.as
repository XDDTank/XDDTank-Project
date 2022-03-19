// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.viewInDetail.tuan.ActivityTuanView

package activity.view.viewInDetail.tuan
{
    import activity.view.viewInDetail.ActivityBaseDetailView;
    import activity.data.ActivityTuanInfo;
    import activity.view.ActivityCell;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import road7th.data.DictionaryData;
    import activity.ActivityController;
    import ddt.manager.TimeManager;
    import ddt.manager.ItemManager;
    import activity.data.ActivityInfo;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.command.QuickBuyFrame;
    import ddt.events.ShortcutBuyEvent;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityTuanView extends ActivityBaseDetailView 
    {

        private var _tuanInfo:ActivityTuanInfo;
        private var _cell:ActivityCell;
        private var _buyButton:TextButton;
        private var _timeLast:FilterFrameText;
        private var _currentRebackRate:FilterFrameText;
        private var _nextRebackRate:FilterFrameText;
        private var _needBuyCount:FilterFrameText;
        private var _alreadyCountArea:FilterFrameText;
        private var _alreadyCountSelf:FilterFrameText;
        private var _currentRebackMoney:FilterFrameText;
        private var _nextRebackMoney:FilterFrameText;


        override protected function initView():void
        {
            this._cell = new ActivityCell(null);
            this._cell.showBg(false);
            this._cell.showCount(false);
            PositionUtils.setPos(this._cell, "activity.view.viewInDetail.tuan.cellPos");
            addChild(this._cell);
            this._buyButton = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.buyButton");
            this._buyButton.text = LanguageMgr.GetTranslation("tank.calendar.ActivityTuanView.buy");
            addChild(this._buyButton);
            this._timeLast = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.timeLast");
            addChild(this._timeLast);
            this._currentRebackRate = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.currentRebackRate");
            addChild(this._currentRebackRate);
            this._nextRebackRate = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.nextRebackRate");
            addChild(this._nextRebackRate);
            this._needBuyCount = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.needBuyCount");
            addChild(this._needBuyCount);
            this._alreadyCountArea = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.alreadyCountArea");
            addChild(this._alreadyCountArea);
            this._alreadyCountSelf = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.alreadyCountSelf");
            addChild(this._alreadyCountSelf);
            this._currentRebackMoney = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.currentRebackMoney");
            addChild(this._currentRebackMoney);
            this._nextRebackMoney = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityTuanView.nextRebackMoney");
            addChild(this._nextRebackMoney);
        }

        override protected function initEvent():void
        {
            this._buyButton.addEventListener(MouseEvent.CLICK, this.__buyItem);
        }

        override public function set info(_arg_1:ActivityInfo):void
        {
            var _local_5:DictionaryData;
            var _local_6:DictionaryData;
            super.info = _arg_1;
            this._tuanInfo = ActivityController.instance.model.getTuanInfoByID(info.ActivityId);
            var _local_2:int = int(int((((((info.endShowDate.time - TimeManager.Instance.Now().time) / 1000) / 60) / 60) / 24)));
            var _local_3:String = LanguageMgr.GetTranslation("tank.calendar.activityDay");
            if (_local_2 <= 0)
            {
                _local_2 = int(int(((((info.endShowDate.time - TimeManager.Instance.Now().time) / 1000) / 60) / 60)));
                _local_3 = LanguageMgr.GetTranslation("tank.calendar.activityHour");
            };
            if (_local_2 <= 0)
            {
                _local_2 = int(int((((info.endShowDate.time - TimeManager.Instance.Now().time) / 1000) / 60)));
                if (((_local_2 == 0) && (info.endShowDate.time > TimeManager.Instance.Now().time)))
                {
                    _local_2 = 1;
                };
                _local_3 = LanguageMgr.GetTranslation("tank.calendar.activityMinute");
            };
            this._timeLast.text = ((_local_2 + " ") + _local_3);
            var _local_4:int;
            while (_local_4 < _conditions.length)
            {
                switch (_conditions[_local_4].Remain2)
                {
                    case "Item":
                        this._tuanInfo.itemID = int(_conditions[_local_4].ConditionValue);
                        this._tuanInfo.itemPrice = _conditions[_local_4].Remain1;
                        break;
                    case "BackRate":
                        _local_5 = new DictionaryData();
                        _local_5.add("level", _conditions[_local_4].ConditionIndex);
                        _local_5.add("fp", _conditions[_local_4].ConditionValue);
                        _local_5.add("count", _conditions[_local_4].Remain1);
                        this._tuanInfo.backRate.add(_conditions[_local_4].ConditionIndex, _local_5);
                        break;
                    case "AdjustTime":
                        _local_6 = new DictionaryData();
                        _local_6.add("time", _conditions[_local_4].ConditionIndex);
                        _local_6.add("value", _conditions[_local_4].ConditionValue);
                        _local_6.add("count", _conditions[_local_4].Remain1);
                        this._tuanInfo.adjustTime.add(_conditions[_local_4].ConditionIndex, _local_6);
                        break;
                    case "PriceType":
                        this._tuanInfo.priceType = int(_conditions[_local_4].ConditionValue);
                        break;
                };
                _local_4++;
            };
            this._cell.info = ItemManager.Instance.getTemplateById(this._tuanInfo.itemID);
            this.setText();
        }

        private function setText():void
        {
            var _local_1:DictionaryData;
            var _local_5:Number;
            var _local_2:int;
            while (_local_2 < this._tuanInfo.backRate.list.length)
            {
                if (this._tuanInfo.backRate.list[_local_2]["count"] <= this._tuanInfo.allCount)
                {
                    _local_1 = this._tuanInfo.backRate.list[_local_2];
                };
                _local_2++;
            };
            if (_local_1 == null)
            {
                _local_1 = new DictionaryData();
                _local_1.add("fp", 10);
                _local_1.add("level", -1);
            };
            if (_local_1["fp"] == 10)
            {
                this._currentRebackRate.text = LanguageMgr.GetTranslation("tank.calendar.activityWu");
            }
            else
            {
                this._currentRebackRate.text = (((10 - _local_1["fp"]) * 10) + "%");
            };
            var _local_3:DictionaryData = this._tuanInfo.backRate[(_local_1["level"] + 1)];
            if (_local_3 == null)
            {
                this._nextRebackRate.text = LanguageMgr.GetTranslation("tank.calendar.ActivityTuanView.toohight");
                this._nextRebackMoney.text = "0";
                this._needBuyCount.text = "";
            }
            else
            {
                this._nextRebackRate.text = (((10 - _local_3["fp"]) * 10) + "%");
                _local_5 = ((10 - _local_3["fp"]) / 10);
                this._nextRebackMoney.text = (this._tuanInfo.alreadyMoney * _local_5).toString().toString();
                this._needBuyCount.text = LanguageMgr.GetTranslation("tank.calendar.ActivityTuanView.needBuyCount", _local_3["count"]);
            };
            this._alreadyCountArea.text = this._tuanInfo.allCount.toString();
            this._alreadyCountSelf.text = this._tuanInfo.alreadyCount.toString();
            var _local_4:Number = ((10 - _local_1["fp"]) / 10);
            this._currentRebackMoney.text = (this._tuanInfo.alreadyMoney * _local_4).toString();
        }

        override protected function initCells():void
        {
        }

        private function __buyItem(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            if ((!(ActivityController.instance.isInValidShowDate(_info))))
            {
                return (MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.ActiveState.TimeOut")));
            };
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _local_2.addEventListener(ShortcutBuyEvent.SHORTCUT_BUY, this.__shortCutBuyHandler);
            _local_2.buyFrom = QuickBuyFrame.ACTIVITY;
            _local_2.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _local_2.unitPrice = this._tuanInfo.itemPrice;
            _local_2.priceType = this._tuanInfo.priceType;
            _local_2.setItemID(this._tuanInfo.itemID, false);
            LayerManager.Instance.addToLayer(_local_2, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __shortCutBuyHandler(_arg_1:ShortcutBuyEvent):void
        {
            var _local_2:QuickBuyFrame = (_arg_1.target as QuickBuyFrame);
            _local_2.removeEventListener(ShortcutBuyEvent.SHORTCUT_BUY, this.__shortCutBuyHandler);
            if (((_arg_1.ItemID > 0) && (_arg_1.ItemNum > 0)))
            {
                ActivityController.instance.sendBuyItem(info.ActivityType, info.ActivityId, _arg_1.ItemID, _arg_1.ItemNum);
            };
        }

        override protected function removeEvent():void
        {
            this._buyButton.removeEventListener(MouseEvent.CLICK, this.__buyItem);
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeObject(this._buyButton);
            this._buyButton = null;
            ObjectUtils.disposeObject(this._cell);
            this._cell = null;
            ObjectUtils.disposeObject(this._alreadyCountArea);
            this._alreadyCountArea = null;
            ObjectUtils.disposeObject(this._alreadyCountSelf);
            this._alreadyCountSelf = null;
            ObjectUtils.disposeObject(this._currentRebackMoney);
            this._currentRebackMoney = null;
            ObjectUtils.disposeObject(this._needBuyCount);
            this._needBuyCount = null;
            ObjectUtils.disposeObject(this._nextRebackMoney);
            this._nextRebackMoney = null;
            ObjectUtils.disposeObject(this._nextRebackRate);
            this._nextRebackRate = null;
            ObjectUtils.disposeObject(this._currentRebackRate);
            this._currentRebackRate = null;
        }


    }
}//package activity.view.viewInDetail.tuan

