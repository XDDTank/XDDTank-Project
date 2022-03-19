// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.SelfConsortionHallLeftView

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.core.Component;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import ddt.data.ConsortiaInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameTextWithTips;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import consortion.ConsortionModelControl;
    import ddt.manager.LanguageMgr;
    import ddt.events.PlayerPropertyEvent;
    import consortion.event.ConsortionEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import flash.utils.ByteArray;
    import road7th.utils.StringHelper;
    import ddt.manager.MessageTipManager;
    import ddt.utils.FilterWordManager;
    import ddt.manager.SocketManager;
    import ddt.manager.ConsortiaDutyManager;
    import ddt.data.ConsortiaDutyType;
    import consortion.data.ConsortiaLevelInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class SelfConsortionHallLeftView extends Component implements Disposeable 
    {

        public static const dataFormat:String = "YYYY-MM-DD";

        private var _bg:Bitmap;
        private var _bgI:Bitmap;
        private var _bulletinBg:Bitmap;
        private var _consortiaInfo:ConsortiaInfo;
        private var _consortionName:FilterFrameText;
        private var _level:ScaleFrameImage;
        private var _repute:FilterFrameText;
        private var _riches:FilterFrameText;
        private var _weekPay:FilterFrameTextWithTips;
        private var _placard:TextArea;
        private var _placardBtn:TextButton;
        private var _placardEditBtn:TextButton;
        private var _placardCancelBtn:TextButton;
        private var _inputMaxChars:FilterFrameText;
        private var _lastPlacard:String;
        private var _levelProgress:SelfConsortionInfoLevelProgress;
        private var _count:FilterFrameTextWithTips;

        public function SelfConsortionHallLeftView()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.conortionHall.leftBg");
            this._bgI = ComponentFactory.Instance.creatBitmap("asset.conortionHall.leftBgI");
            this._bulletinBg = ComponentFactory.Instance.creatBitmap("asset.conortionAnnouncement.bg");
            this._consortionName = ComponentFactory.Instance.creatComponentByStylename("consortion.nameInputText");
            this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.level");
            this._repute = ComponentFactory.Instance.creatComponentByStylename("consortion.repute");
            this._count = ComponentFactory.Instance.creatComponentByStylename("consortion.countTip");
            this._count.selectable = false;
            this._riches = ComponentFactory.Instance.creatComponentByStylename("consortion.riches");
            if (PlayerManager.Instance.Self.consortiaInfo.Riches < ConsortionModelControl.Instance.model.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level).Deduct)
            {
                this._weekPay = ComponentFactory.Instance.creatComponentByStylename("consortion.weekPayI");
            }
            else
            {
                this._weekPay = ComponentFactory.Instance.creatComponentByStylename("consortion.weekPay");
            };
            this._weekPay.mouseEnabled = true;
            this._weekPay.selectable = false;
            this._placard = ComponentFactory.Instance.creatComponentByStylename("placardAndEvent.placardText");
            this._placard.editable = false;
            this._placard.mouseChildren = false;
            this._placardBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.placardBtn");
            this._placardBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.baglocked.modifyBtn");
            this._placardCancelBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.placardBtn");
            this._placardCancelBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
            this._placardCancelBtn.visible = false;
            this._placardEditBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.placardeditBtn");
            this._placardEditBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionTask.publish");
            this._placardEditBtn.visible = false;
            this._inputMaxChars = ComponentFactory.Instance.creatComponentByStylename("consortion.inputMaxCharsTxt");
            this._inputMaxChars.visible = false;
            this._levelProgress = ComponentFactory.Instance.creat("SelfConsortionInfoLevelProgress");
            this._levelProgress.tipStyle = "ddt.view.tips.OneLineTip";
            this._levelProgress.tipDirctions = "3,7,6";
            this._levelProgress.tipGapV = 4;
            addChild(this._bg);
            addChild(this._bgI);
            addChild(this._bulletinBg);
            addChild(this._consortionName);
            addChild(this._level);
            addChild(this._repute);
            addChild(this._riches);
            addChild(this._weekPay);
            addChild(this._placard);
            addChild(this._placardBtn);
            addChild(this._placardCancelBtn);
            addChild(this._placardEditBtn);
            addChild(this._inputMaxChars);
            addChild(this._levelProgress);
            addChild(this._count);
            this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
            this.upPlacard();
        }

        private function initEvent():void
        {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this._consortiaInfoChange);
            PlayerManager.Instance.Self.consortiaInfo.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__consortiaInfoPropChange);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.LEVEL_UP_RULE_CHANGE, this._levelUpRuleChange);
            this._placardBtn.addEventListener(MouseEvent.CLICK, this.__mouseClickHandler);
            this._placard.textField.addEventListener(Event.CHANGE, this.__inputHandler);
            this._placardCancelBtn.addEventListener(MouseEvent.CLICK, this.__cancelHandler);
            this._placardEditBtn.addEventListener(MouseEvent.CLICK, this.__edit);
        }

        private function removeEvent():void
        {
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this._consortiaInfoChange);
            if (PlayerManager.Instance.Self.consortiaInfo)
            {
                PlayerManager.Instance.Self.consortiaInfo.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__consortiaInfoPropChange);
            };
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.LEVEL_UP_RULE_CHANGE, this._levelUpRuleChange);
            if (this._placardBtn)
            {
                this._placardBtn.removeEventListener(MouseEvent.CLICK, this.__mouseClickHandler);
            };
            if (this._placardCancelBtn)
            {
                this._placardCancelBtn.removeEventListener(MouseEvent.CLICK, this.__cancelHandler);
            };
            if (this._placard)
            {
                this._placard.textField.removeEventListener(Event.CHANGE, this.__inputHandler);
            };
            if (this._placardEditBtn)
            {
                this._placardEditBtn.removeEventListener(MouseEvent.CLICK, this.__edit);
            };
        }

        private function __mouseClickHandler(_arg_1:MouseEvent):void
        {
            this._placard.editable = true;
            this._placard.mouseChildren = true;
            this._placardBtn.visible = false;
            this._placardEditBtn.visible = true;
            this._placardCancelBtn.visible = true;
            this._inputMaxChars.visible = true;
            this._inputMaxChars.text = LanguageMgr.GetTranslation("ddtcosrtion.inputMacChars", this._placard.textField.length);
        }

        private function __edit(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeUTF(StringHelper.trim(this._placard.textField.text));
            if (this._placard.textField.length > 50)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaAfficheFrame.long"));
                return;
            };
            if (FilterWordManager.isGotForbiddenWords(this._placard.textField.text))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaAfficheFrame"));
                return;
            };
            var _local_3:String = FilterWordManager.filterWrod(this._placard.textField.text);
            _local_3 = StringHelper.trim(_local_3);
            SocketManager.Instance.out.sendConsortiaUpdatePlacard(_local_3);
            this._placardBtn.visible = true;
            this._placardEditBtn.visible = false;
            this._placard.editable = false;
            this._placardCancelBtn.visible = false;
            this._placard.mouseChildren = false;
        }

        private function __cancelHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:String = PlayerManager.Instance.Self.consortiaInfo.Placard;
            this._placard.text = ((_local_2 == "") ? LanguageMgr.GetTranslation("tank.consortia.myconsortia.systemWord") : _local_2);
            this._placardBtn.visible = true;
            this._placardEditBtn.visible = false;
            this._placardCancelBtn.visible = false;
            this._inputMaxChars.visible = false;
            this._placard.mouseChildren = false;
        }

        private function __inputHandler(_arg_1:Event):void
        {
            if (this._placard.textField.textHeight > 80)
            {
                _arg_1.stopImmediatePropagation();
                this._placard.text = this._lastPlacard;
                return;
            };
            this._lastPlacard = this._placard.text;
            this._inputMaxChars.text = LanguageMgr.GetTranslation("ddtcosrtion.inputMacChars", this._placard.textField.length);
        }

        private function upPlacard():void
        {
            var _local_1:String = PlayerManager.Instance.Self.consortiaInfo.Placard;
            this._placard.text = ((_local_1 == "") ? LanguageMgr.GetTranslation("tank.consortia.myconsortia.systemWord") : _local_1);
            this._lastPlacard = this._placard.text;
            this._placardBtn.visible = ConsortiaDutyManager.GetRight(PlayerManager.Instance.Self.Right, ConsortiaDutyType._4_Notice);
        }

        private function _levelUpRuleChange(_arg_1:ConsortionEvent):void
        {
            this.setWeekyPay();
        }

        private function setWeekyPay():void
        {
            if ((((this._consortiaInfo) && (!(this._consortiaInfo.Level == 0))) && (!(ConsortionModelControl.Instance.model.levelUpData == null))))
            {
                this._weekPay.text = String(ConsortionModelControl.Instance.model.getLevelData(this._consortiaInfo.Level).Deduct);
                if (this._weekPay.text != "")
                {
                    this._weekPay.mouseEnabled = true;
                }
                else
                {
                    this._weekPay.mouseEnabled = false;
                };
                this._weekPay.tipData = StringHelper.parseTime(this._consortiaInfo.DeductDate, 1);
            };
        }

        private function _consortiaInfoChange(_arg_1:PlayerPropertyEvent):void
        {
            if ((((_arg_1.changedProperties["consortiaInfo"]) || (_arg_1.changedProperties["experience"])) || (_arg_1.changedProperties["count"])))
            {
                this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
            };
            if (_arg_1.changedProperties["riches"])
            {
                this._riches.text = String(PlayerManager.Instance.Self.consortiaInfo.Riches);
            };
            if (_arg_1.changedProperties["Right"])
            {
                this.upPlacard();
            };
        }

        private function __consortiaInfoPropChange(_arg_1:PlayerPropertyEvent):void
        {
            if (((_arg_1.changedProperties[ConsortiaInfo.PLACARD]) || (_arg_1.changedProperties[ConsortiaInfo.IS_VOTING])))
            {
                this.upPlacard();
            };
            this.consortionInfo = PlayerManager.Instance.Self.consortiaInfo;
        }

        private function set consortionInfo(_arg_1:ConsortiaInfo):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:ConsortiaLevelInfo;
            if (_arg_1 == null)
            {
                return;
            };
            this._consortiaInfo = _arg_1;
            var _local_2:ConsortiaLevelInfo = ConsortionModelControl.Instance.model.getLevelData(((this._consortiaInfo.Level == 10) ? this._consortiaInfo.Level : (this._consortiaInfo.Level + 1)));
            this._consortionName.text = this._consortiaInfo.ConsortiaName;
            this._level.setFrame(_arg_1.Level);
            if (_arg_1.Level == 10)
            {
                this._level.x = 140;
            };
            this._repute.text = LanguageMgr.GetTranslation("ddtcosrtion.requet", _arg_1.Repute);
            this._riches.text = String(_arg_1.Riches);
            if (_arg_1.Level != 0)
            {
                this._count.text = ((String(_arg_1.Count) + "/") + String(ConsortionModelControl.Instance.model.getLevelData(_arg_1.Level).Count));
                this._count.mouseEnabled = true;
                this._count.tipData = _arg_1;
            };
            this.setWeekyPay();
            if (this._consortiaInfo.Level <= 1)
            {
                _local_3 = this._consortiaInfo.Experience;
                _local_4 = _local_2.Experience;
            }
            else
            {
                _local_5 = ConsortionModelControl.Instance.model.getLevelData(_arg_1.Level);
                _local_3 = (this._consortiaInfo.Experience - _local_5.Experience);
                _local_4 = (_local_2.Experience - _local_5.Experience);
            };
            if (_arg_1.Level >= 10)
            {
                this._levelProgress.setProgress(0, 100);
                this._levelProgress.tipData = LanguageMgr.GetTranslation("ddt.consortion.upgradeHallTip");
            }
            else
            {
                this._levelProgress.setProgress(Number(_local_3), Number(_local_4));
                this._levelProgress.tipData = ((Number(_local_3) + "/") + Number(_local_4));
            };
        }

        private function getExperience():int
        {
            var _local_4:ConsortiaLevelInfo;
            var _local_1:int = (this._consortiaInfo.Level + 1);
            var _local_2:int;
            var _local_3:int = 1;
            while (_local_3 < _local_1)
            {
                _local_4 = ConsortionModelControl.Instance.model.getLevelData(_local_3);
                _local_2 = (_local_2 + _local_4.Experience);
                _local_3++;
            };
            return (_local_2);
        }

        override public function dispose():void
        {
            this.removeEvent();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._bgI)
            {
                ObjectUtils.disposeObject(this._bgI);
            };
            this._bgI = null;
            if (this._bulletinBg)
            {
                ObjectUtils.disposeObject(this._bulletinBg);
            };
            this._bulletinBg = null;
            if (this._consortionName)
            {
                ObjectUtils.disposeObject(this._consortionName);
            };
            this._consortionName = null;
            if (this._level)
            {
                ObjectUtils.disposeObject(this._level);
            };
            this._level = null;
            if (this._repute)
            {
                ObjectUtils.disposeObject(this._repute);
            };
            this._repute = null;
            if (this._riches)
            {
                ObjectUtils.disposeObject(this._riches);
            };
            this._riches = null;
            if (this._weekPay)
            {
                ObjectUtils.disposeObject(this._weekPay);
            };
            this._weekPay = null;
            if (this._placard)
            {
                ObjectUtils.disposeObject(this._placard);
            };
            if (this._levelProgress)
            {
                ObjectUtils.disposeObject(this._levelProgress);
            };
            this._levelProgress = null;
            this._placard = null;
            if (this._placardBtn)
            {
                ObjectUtils.disposeObject(this._placardBtn);
            };
            this._placardBtn = null;
            if (this._placardCancelBtn)
            {
                ObjectUtils.disposeObject(this._placardCancelBtn);
            };
            this._placardCancelBtn = null;
            if (this._inputMaxChars)
            {
                ObjectUtils.disposeObject(this._inputMaxChars);
            };
            this._inputMaxChars = null;
            if (this._count)
            {
                ObjectUtils.disposeObject(this._count);
            };
            this._count = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

