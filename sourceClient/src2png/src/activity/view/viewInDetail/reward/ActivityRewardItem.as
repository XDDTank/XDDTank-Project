// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.viewInDetail.reward.ActivityRewardItem

package activity.view.viewInDetail.reward
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import road7th.data.DictionaryData;
    import activity.data.ActivityConditionInfo;
    import flash.display.Bitmap;
    import activity.view.ActivityNum;
    import com.pickgliss.ui.controls.TextButton;
    import activity.data.ActivityInfo;
    import activity.ActivityController;
    import activity.data.ActivityChildTypes;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.MessageTipManager;
    import activity.ActivityEvent;
    import activity.view.ActivityCell;
    import activity.data.ActivityGiftbagInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityRewardItem extends Sprite implements Disposeable 
    {

        private var _cellNum:int;
        private var _cellList:SimpleTileList;
        private var _giftBagInfoDic:DictionaryData;
        private var _conditionInfo:ActivityConditionInfo;
        private var _bg:Bitmap;
        private var _moneyTxt:Bitmap;
        private var _moneyMC:ActivityNum;
        private var _button:TextButton;
        private var _type:String;
        private var _activityInfo:ActivityInfo;

        public function ActivityRewardItem(_arg_1:ActivityInfo, _arg_2:DictionaryData, _arg_3:ActivityConditionInfo, _arg_4:int)
        {
            this._activityInfo = _arg_1;
            this._cellNum = _arg_4;
            this._giftBagInfoDic = _arg_2;
            this._conditionInfo = _arg_3;
            this._type = ((ActivityController.instance.checkCostReward(this._activityInfo)) ? "Cost" : "Charge");
            this.initView();
            this.initCells();
        }

        private function initView():void
        {
            var _local_1:String = (("ddtactivity.total" + this._type) + "bg");
            if (((this._activityInfo.ActivityChildType == ActivityChildTypes.COST_REWARD_ONCE) || (this._activityInfo.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_ONCE)))
            {
                _local_1 = (("ddtactivity.one" + this._type) + "bg");
            };
            this._bg = ComponentFactory.Instance.creatBitmap(_local_1);
            addChild(this._bg);
            this._moneyTxt = ComponentFactory.Instance.creatBitmap((("ddtactivity." + this._type) + "moneyTxt"));
            if (this._activityInfo.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_ONCE)
            {
                this._moneyTxt.x = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityRewardItem.MoneyTxt").y;
            };
            addChild(this._moneyTxt);
            this._cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityCoseReward.cellList", [this._cellNum]);
            addChild(this._cellList);
            this._button = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityCoseReward.itemButton");
            this._button.text = LanguageMgr.GetTranslation("tank.timeBox.awardsBtn");
            this._button.enable = this.checkEnable();
            this._button.addEventListener(MouseEvent.CLICK, this.__clickButton);
            addChild(this._button);
            this._moneyMC = new ActivityNum();
            if (this._activityInfo.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_ONCE)
            {
                this._moneyMC.type = "ChargeOnce";
            }
            else
            {
                this._moneyMC.type = this._type;
            };
            this._moneyMC.setNum(int(this._conditionInfo.ConditionValue));
            addChild(this._moneyMC);
            this._moneyTxt.x = (this._moneyMC.x + this._moneyMC.width);
        }

        private function __clickButton(_arg_1:MouseEvent):void
        {
            if ((!(ActivityController.instance.isInValidShowDate(this._activityInfo))))
            {
                return (MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.ActiveState.TimeOut")));
            };
            var _local_2:Object = new Object();
            _local_2["ID"] = this._activityInfo.ActivityId;
            _local_2["giftbagOrder"] = this._giftBagInfoDic.list[0].GiftbagOrder;
            ActivityController.instance.model.dispatchEvent(new ActivityEvent(ActivityEvent.GET_RAWARD, _local_2));
        }

        private function checkEnable():Boolean
        {
            if (ActivityController.instance.model.getGiftbagRecordByID(this._activityInfo.ActivityId, this._giftBagInfoDic.list[0].GiftbagOrder).value > 0)
            {
                return (true);
            };
            return (false);
        }

        private function initCells():void
        {
            var _local_1:ActivityCell;
            var _local_2:DictionaryData;
            var _local_3:ActivityGiftbagInfo;
            var _local_4:int;
            for each (_local_3 in this._giftBagInfoDic)
            {
                _local_2 = ActivityController.instance.getRewardsByGiftbagID(_local_3.GiftbagId);
                _local_4 = 0;
                while (_local_4 < _local_2.length)
                {
                    if (this._type == "Cost")
                    {
                        _local_1 = new ActivityCell(_local_2.list[_local_4], true, ComponentFactory.Instance.creatBitmap("ddtactivity.CostReward.cellBg"));
                    }
                    else
                    {
                        _local_1 = new ActivityCell(_local_2.list[_local_4]);
                    };
                    _local_1.count = _local_2.list[_local_4].Count;
                    this._cellList.addChild(_local_1);
                    _local_4++;
                };
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._moneyTxt);
            this._moneyTxt = null;
            this._cellList.disposeAllChildren();
            ObjectUtils.disposeObject(this._cellList);
            this._cellList = null;
            if (this._button)
            {
                this._button.removeEventListener(MouseEvent.CLICK, this.__clickButton);
                ObjectUtils.disposeObject(this._button);
                this._button = null;
            };
            ObjectUtils.disposeObject(this._moneyMC);
            this._moneyMC = null;
        }


    }
}//package activity.view.viewInDetail.reward

