// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.TransportCarInfoTip

package consortion
{
    import com.pickgliss.ui.tip.BaseTip;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.TimeManager;
    import consortion.transportSence.TransportCar;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class TransportCarInfoTip extends BaseTip 
    {

        private var _tempData:Vector.<String>;
        private var _bg:ScaleBitmapImage;
        private var _ownerNameText:FilterFrameText;
        private var _levelText1:FilterFrameText;
        private var _levelText2:FilterFrameText;
        private var _consortionText:FilterFrameText;
        private var _useCarText:FilterFrameText;
        private var _hijackTimesText:FilterFrameText;
        private var _leftTimeText:FilterFrameText;
        private var _guarderNameText:FilterFrameText;
        private var _hijackRewardText:FilterFrameText;
        private var _describeText:FilterFrameText;
        private var _goldText:FilterFrameText;
        private var _goldText2:FilterFrameText;
        private var _rule1:ScaleBitmapImage;
        private var _rule2:ScaleBitmapImage;
        private var _carStartTime:int;
        private var _carSpeed:Number;


        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creat("asset.transportConfirm.carTip");
            this._ownerNameText = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.titleText");
            this._levelText1 = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.levelText1");
            this._levelText2 = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.levelText2");
            this._consortionText = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.playerInfoText");
            this._useCarText = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.playerInfoText");
            this._hijackTimesText = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.playerInfoText");
            this._leftTimeText = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.playerInfoText");
            this._guarderNameText = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.playerInfoText");
            this._hijackRewardText = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.playerInfoText");
            this._describeText = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.playerInfoText");
            this._goldText = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.goldText");
            this._goldText2 = ComponentFactory.Instance.creatComponentByStylename("asset.transportCarTip.goldText");
            this._rule1 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._rule2 = ComponentFactory.Instance.creatComponentByStylename("HRuleAsset");
            this._rule1.x = (this._rule2.x = 3);
            this.tipbackgound = this._bg;
            this._describeText.text = LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.describe.txt");
            this._levelText1.text = (LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.level.txt") + ":");
            this._hijackRewardText.text = (LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.hijackReward.txt") + ":");
        }

        override protected function addChildren():void
        {
            super.addChildren();
            mouseChildren = false;
            mouseEnabled = false;
            addChild(this._ownerNameText);
            addChild(this._levelText1);
            addChild(this._levelText2);
            addChild(this._consortionText);
            addChild(this._useCarText);
            addChild(this._hijackTimesText);
            addChild(this._leftTimeText);
            addChild(this._guarderNameText);
            addChild(this._hijackRewardText);
            addChild(this._describeText);
            addChild(this._goldText);
            addChild(this._goldText2);
            addChild(this._rule1);
            addChild(this._rule2);
        }

        override public function get tipData():Object
        {
            return (this._tempData);
        }

        override public function set tipData(_arg_1:Object):void
        {
            this._tempData = (_arg_1 as Vector.<String>);
            this._ownerNameText.y = 8;
            this._ownerNameText.text = ((_arg_1[0] == null) ? "" : _arg_1[0]);
            this._levelText1.y = (this._levelText2.y = ((this._ownerNameText.textHeight + this._ownerNameText.y) + 5));
            this._levelText2.x = ((this._levelText1.textWidth + this._levelText1.x) + 5);
            this._levelText2.text = ((_arg_1[1] == null) ? "" : _arg_1[1]);
            this._rule1.y = ((this._levelText2.textHeight + this._levelText2.y) + 8);
            this._consortionText.y = (this._rule1.y + 8);
            this._consortionText.text = ((_arg_1[2] == null) ? "" : _arg_1[2]);
            this._useCarText.y = ((this._consortionText.y + this._consortionText.textHeight) + 5);
            this._useCarText.text = ((_arg_1[3] == null) ? "" : _arg_1[3]);
            this._hijackTimesText.y = ((this._useCarText.y + this._useCarText.textHeight) + 5);
            this._hijackTimesText.text = ((_arg_1[4] == null) ? "" : _arg_1[4]);
            this._leftTimeText.y = ((this._hijackTimesText.y + this._hijackTimesText.textHeight) + 5);
            this._carStartTime = ((_arg_1[5] == null) ? TimeManager.Instance.Now().valueOf() : int(_arg_1[5]));
            this._carSpeed = ((_arg_1[6] == null) ? 0 : Number(_arg_1[6]));
            var _local_2:int = ((((TransportCar.MOVE_DISTANCE / this._carSpeed) * 1000) + this._carStartTime) - TimeManager.Instance.Now().valueOf());
            if (_local_2 <= 0)
            {
                _local_2 = 0;
            };
            this._leftTimeText.text = ((LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.leftTime.txt") + ":") + TimeManager.Instance.formatTimeToString1(_local_2, false));
            this._guarderNameText.y = ((this._leftTimeText.y + this._leftTimeText.textHeight) + 5);
            this._guarderNameText.text = ((_arg_1[7] == null) ? "" : _arg_1[7]);
            this._hijackRewardText.y = (this._goldText.y = ((this._guarderNameText.y + this._guarderNameText.textHeight) + 5));
            this._goldText.x = (this._goldText2.x = ((this._hijackRewardText.textWidth + this._hijackRewardText.x) + 5));
            this._goldText.text = ((_arg_1[8] == null) ? "" : _arg_1[8]);
            this._goldText2.y = ((this._goldText.y + this._goldText.textHeight) + 5);
            this._goldText2.text = ((_arg_1[9] == null) ? "" : _arg_1[9]);
            this._rule2.y = ((this._goldText2.textHeight + this._goldText2.y) + 8);
            this._describeText.y = (this._rule2.y + 8);
            this.drawBG();
        }

        public function updateTime():void
        {
            var _local_1:int = ((((TransportCar.MOVE_DISTANCE / this._carSpeed) * 1000) + this._carStartTime) - TimeManager.Instance.Now().valueOf());
            this._leftTimeText.text = ((LanguageMgr.GetTranslation("consortion.ConsortionTransport.carInfoTip.leftTime.txt") + ":") + TimeManager.Instance.formatTimeToString1(_local_1, false));
        }

        private function reset():void
        {
            this._bg.height = 0;
            this._bg.width = 0;
        }

        private function drawBG(_arg_1:int=0):void
        {
            this.reset();
            this._bg.width = 161;
            this._bg.height = ((this._describeText.y + this._describeText.textHeight) + 16);
            this._rule1.width = 150;
            this._rule2.width = 150;
            _width = this._bg.width;
            _height = this._bg.height;
        }

        override public function dispose():void
        {
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            this._tempData = null;
            this._bg = null;
            this._ownerNameText = null;
            this._levelText1 = null;
            this._levelText2 = null;
            this._consortionText = null;
            this._useCarText = null;
            this._hijackTimesText = null;
            this._leftTimeText = null;
            this._guarderNameText = null;
            this._hijackRewardText = null;
            this._describeText = null;
            this._goldText = null;
            this._rule1 = null;
            this._rule2 = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package consortion

