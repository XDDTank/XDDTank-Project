// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.viewInDetail.reward.ActivityRewardView

package activity.view.viewInDetail.reward
{
    import activity.view.viewInDetail.ActivityBaseDetailView;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import activity.ActivityController;
    import activity.data.ActivityChildTypes;
    import activity.data.ActivityInfo;
    import road7th.data.DictionaryData;

    public class ActivityRewardView extends ActivityBaseDetailView 
    {

        private var _totalTxt:ScaleFrameImage;
        private var _alreadyTxt:FilterFrameText;
        private var _type:String;


        override protected function initView():void
        {
            _cellNumInRow = 5;
            _cellList = ComponentFactory.Instance.creatCustomObject("ddtactivity.ActivityReward.itemList", [1]);
            addChild(_cellList);
            _panel = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityCoseReward.itemPanel");
            addChild(_panel);
            _panel.setView(_cellList);
            this._totalTxt = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.totalTxtImage");
            this._totalTxt.setFrame(1);
            addChild(this._totalTxt);
            this._alreadyTxt = ComponentFactory.Instance.creatComponentByStylename("ddtactivity.ActivityReward.alreadyTxt");
            addChild(this._alreadyTxt);
        }

        override public function set info(_arg_1:ActivityInfo):void
        {
            if (ActivityController.instance.checkChargeReward(_arg_1))
            {
                this._type = "Charge";
                this._totalTxt.setFrame(1);
                _panel.vScrollbarStyle = "core.newVScrollbar";
            }
            else
            {
                if (ActivityController.instance.checkCostReward(_arg_1))
                {
                    this._type = "Cost";
                    this._totalTxt.setFrame(2);
                    _panel.vScrollbarStyle = "core.ddtchurchVScrollbar";
                };
            };
            this._alreadyTxt.textFormatStyle = (("ddtcalendar.ActivityRewardTxt." + this._type) + "TF");
            this._alreadyTxt.filterString = (("ddtcalendar.ActivityRewardTxt." + this._type) + "GF");
            super.info = _arg_1;
            this._alreadyTxt.text = nowState.toString();
            this._totalTxt.visible = (this._alreadyTxt.visible = ((info.ActivityChildType == ActivityChildTypes.COST_REWARD_TOTAL) || (info.ActivityChildType == ActivityChildTypes.CHARGE_REWARD_TOTAL)));
        }

        override protected function initCells():void
        {
            var _local_1:ActivityRewardItem;
            var _local_3:DictionaryData;
            var _local_2:int;
            for each (_local_3 in _giftBags)
            {
                _local_1 = new ActivityRewardItem(info, _local_3, _conditions[_local_2], _cellNumInRow);
                _cellList.addChild(_local_1);
                _local_2 = (_local_2 + 2);
            };
        }


    }
}//package activity.view.viewInDetail.reward

