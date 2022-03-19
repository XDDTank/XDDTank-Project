// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.ManagerFrame

package consortion.view.selfConsortia
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.TextInput;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import consortion.ConsortionModelControl;
    import consortion.event.ConsortionEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SocketManager;
    import __AS3__.vec.Vector;
    import consortion.data.ConsortiaAssetLevelOffer;

    public class ManagerFrame extends Frame 
    {

        private var _bg:ScaleBitmapImage;
        private var _consortionShop:Bitmap;
        private var _consortionStore:Bitmap;
        private var _consortionSkill:Bitmap;
        private var _contributionText1:FilterFrameText;
        private var _contributionText2:FilterFrameText;
        private var _contributionText3:FilterFrameText;
        private var _contributionText4:FilterFrameText;
        private var _contributionText5:FilterFrameText;
        private var _contributionText6:FilterFrameText;
        private var _contributionText7:FilterFrameText;
        private var _noticeText:FilterFrameText;
        private var _inputBG:MutipleImage;
        private var _textBG:MutipleImage;
        private var _taxBtn:TextButton;
        private var _okBtn:TextButton;
        private var _cancelBtn:TextButton;
        private var _shopLevelTxt1:TextInput;
        private var _shopLevelTxt2:TextInput;
        private var _shopLevelTxt3:TextInput;
        private var _shopLevelTxt4:TextInput;
        private var _shopLevelTxt5:TextInput;
        private var _smithTxt:TextInput;
        private var _skillTxt:TextInput;
        private var _valueArray:Array = [100, 100, 100, 100, 100, 100, 100];

        public function ManagerFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            escEnable = true;
            disposeChildren = true;
            titleText = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ConsortiaAssetManagerFrame.titleText");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.bg");
            this._inputBG = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.inputBG");
            this._textBG = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.textBG");
            this._consortionShop = ComponentFactory.Instance.creatBitmap("asset.consortion.ConsortiaAssetManagerFrame.consortionShop");
            this._consortionStore = ComponentFactory.Instance.creatBitmap("asset.consortion.ConsortiaAssetManagerFrame.consortionStore");
            this._consortionSkill = ComponentFactory.Instance.creatBitmap("asset.consortion.ConsortiaAssetManagerFrame.consortionSkill");
            this._contributionText1 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText1");
            this._contributionText2 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText2");
            this._contributionText3 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText3");
            this._contributionText4 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText4");
            this._contributionText5 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText5");
            this._contributionText6 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText6");
            this._contributionText7 = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.contributionText7");
            this._taxBtn = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.offerBtn");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.okBtn");
            this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.cancelBtn");
            this._shopLevelTxt1 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt1");
            this._shopLevelTxt2 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt2");
            this._shopLevelTxt3 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt3");
            this._shopLevelTxt4 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt4");
            this._shopLevelTxt5 = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.shopLevelTxt5");
            this._smithTxt = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.smithTxt");
            this._skillTxt = ComponentFactory.Instance.creatComponentByStylename("core.ConsortiaAssetManagerFrame.skillTxt");
            this._noticeText = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortiaAssetManagerFrame.noticeText");
            addToContent(this._bg);
            addToContent(this._inputBG);
            addToContent(this._textBG);
            addToContent(this._consortionShop);
            addToContent(this._consortionStore);
            addToContent(this._consortionSkill);
            addToContent(this._contributionText1);
            addToContent(this._contributionText2);
            addToContent(this._contributionText3);
            addToContent(this._contributionText4);
            addToContent(this._contributionText5);
            addToContent(this._contributionText6);
            addToContent(this._contributionText7);
            addToContent(this._taxBtn);
            addToContent(this._okBtn);
            addToContent(this._cancelBtn);
            addToContent(this._shopLevelTxt1);
            addToContent(this._shopLevelTxt2);
            addToContent(this._shopLevelTxt3);
            addToContent(this._shopLevelTxt4);
            addToContent(this._shopLevelTxt5);
            addToContent(this._smithTxt);
            addToContent(this._skillTxt);
            addToContent(this._noticeText);
            this._contributionText1.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText1");
            this._contributionText2.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText2");
            this._contributionText3.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText3");
            this._contributionText4.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText4");
            this._contributionText5.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText5");
            this._contributionText6.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText6");
            this._contributionText7.text = this._contributionText6.text;
            this._noticeText.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.noticeText");
            this._taxBtn.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.facilityDonate");
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
            this._cancelBtn.text = LanguageMgr.GetTranslation("cancel");
            if (PlayerManager.Instance.Self.DutyLevel == 1)
            {
                this.inputText(this._shopLevelTxt1);
                this.inputText(this._shopLevelTxt2);
                this.inputText(this._shopLevelTxt3);
                this.inputText(this._shopLevelTxt4);
                this.inputText(this._shopLevelTxt5);
                this.inputText(this._smithTxt);
                this.inputText(this._skillTxt);
            }
            else
            {
                this.DynamicText(this._shopLevelTxt1);
                this.DynamicText(this._shopLevelTxt2);
                this.DynamicText(this._shopLevelTxt3);
                this.DynamicText(this._shopLevelTxt4);
                this.DynamicText(this._shopLevelTxt5);
                this.DynamicText(this._smithTxt);
                this.DynamicText(this._skillTxt);
            };
            this._shopLevelTxt1.text = LanguageMgr.GetTranslation("hundred");
            this._shopLevelTxt2.text = LanguageMgr.GetTranslation("hundred");
            this._shopLevelTxt3.text = LanguageMgr.GetTranslation("hundred");
            this._shopLevelTxt4.text = LanguageMgr.GetTranslation("hundred");
            this._shopLevelTxt5.text = LanguageMgr.GetTranslation("hundred");
            this._smithTxt.text = LanguageMgr.GetTranslation("hundred");
            this._skillTxt.text = LanguageMgr.GetTranslation("hundred");
        }

        private function inputText(_arg_1:TextInput):void
        {
            _arg_1.textField.restrict = "0-9";
            _arg_1.textField.maxChars = 8;
            _arg_1.mouseChildren = true;
            _arg_1.mouseEnabled = true;
            _arg_1.textField.selectable = true;
        }

        private function DynamicText(_arg_1:TextInput):void
        {
            _arg_1.textField.selectable = false;
            _arg_1.mouseEnabled = false;
            _arg_1.mouseChildren = false;
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._okBtn.addEventListener(MouseEvent.CLICK, this.__okHandler);
            this._cancelBtn.addEventListener(MouseEvent.CLICK, this.__cancelHandler);
            this._taxBtn.addEventListener(MouseEvent.CLICK, this.__taxHandler);
            ConsortionModelControl.Instance.model.addEventListener(ConsortionEvent.USE_CONDITION_CHANGE, this.__conditionChangeHandler);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._okBtn.removeEventListener(MouseEvent.CLICK, this.__okHandler);
            this._cancelBtn.removeEventListener(MouseEvent.CLICK, this.__cancelHandler);
            this._taxBtn.removeEventListener(MouseEvent.CLICK, this.__taxHandler);
            ConsortionModelControl.Instance.model.removeEventListener(ConsortionEvent.USE_CONDITION_CHANGE, this.__conditionChangeHandler);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        private function __okHandler(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            SoundManager.instance.play("008");
            if (((PlayerManager.Instance.Self.bagLocked) && (this.checkChange())))
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (PlayerManager.Instance.Self.DutyLevel == 1)
            {
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.ConsortiaAssetManagerFrame.okFunction"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                _local_2.addEventListener(FrameEvent.RESPONSE, this.__alertResponse);
            }
            else
            {
                this.dispose();
            };
        }

        private function checkChange():Boolean
        {
            var _local_1:int = this.checkInputValue(this._shopLevelTxt1);
            var _local_2:int = this.checkInputValue(this._shopLevelTxt2);
            var _local_3:int = this.checkInputValue(this._shopLevelTxt3);
            var _local_4:int = this.checkInputValue(this._shopLevelTxt4);
            var _local_5:int = this.checkInputValue(this._shopLevelTxt5);
            var _local_6:int = this.checkInputValue(this._smithTxt);
            var _local_7:int = this.checkInputValue(this._skillTxt);
            var _local_8:Array = [_local_1, _local_2, _local_3, _local_4, _local_5, _local_6, _local_7];
            var _local_9:Boolean;
            var _local_10:int;
            while (_local_10 < 7)
            {
                if (this._valueArray[_local_10] != _local_8[_local_10])
                {
                    _local_9 = true;
                };
                _local_10++;
            };
            return (_local_9);
        }

        private function __alertResponse(_arg_1:FrameEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:Array;
            SoundManager.instance.play("008");
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__alertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
            if ((((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)) && (this.checkChange())))
            {
                _local_2 = this.checkInputValue(this._shopLevelTxt1);
                _local_3 = this.checkInputValue(this._shopLevelTxt2);
                _local_4 = this.checkInputValue(this._shopLevelTxt3);
                _local_5 = this.checkInputValue(this._shopLevelTxt4);
                _local_6 = this.checkInputValue(this._shopLevelTxt5);
                _local_7 = this.checkInputValue(this._smithTxt);
                _local_8 = this.checkInputValue(this._skillTxt);
                _local_9 = [_local_2, _local_3, _local_4, _local_5, _local_6, _local_7, _local_8];
                SocketManager.Instance.out.sendConsortiaEquipConstrol(_local_9);
            };
        }

        private function checkInputValue(_arg_1:TextInput):int
        {
            if (_arg_1.text == "")
            {
                return (0);
            };
            return (int(_arg_1.text));
        }

        private function __cancelHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        private function __taxHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            ConsortionModelControl.Instance.alertTaxFrame();
        }

        private function __conditionChangeHandler(_arg_1:ConsortionEvent):void
        {
            var _local_2:Vector.<ConsortiaAssetLevelOffer> = ConsortionModelControl.Instance.model.useConditionList;
            var _local_3:int = _local_2.length;
            var _local_4:int;
            while (_local_4 < _local_3)
            {
                if (_local_2[_local_4].Type == 1)
                {
                    switch (_local_2[_local_4].Level)
                    {
                        case 1:
                            this._shopLevelTxt1.text = (this._valueArray[0] = String(_local_2[_local_4].Riches));
                            break;
                        case 2:
                            this._shopLevelTxt2.text = (this._valueArray[1] = String(_local_2[_local_4].Riches));
                            break;
                        case 3:
                            this._shopLevelTxt3.text = (this._valueArray[2] = String(_local_2[_local_4].Riches));
                            break;
                        case 4:
                            this._shopLevelTxt4.text = (this._valueArray[3] = String(_local_2[_local_4].Riches));
                            break;
                        case 5:
                            this._shopLevelTxt5.text = (this._valueArray[4] = String(_local_2[_local_4].Riches));
                            break;
                    };
                }
                else
                {
                    if (_local_2[_local_4].Type == 2)
                    {
                        this._smithTxt.text = (this._valueArray[5] = String(_local_2[_local_4].Riches));
                    }
                    else
                    {
                        if (_local_2[_local_4].Type == 3)
                        {
                            this._skillTxt.text = (this._valueArray[6] = String(_local_2[_local_4].Riches));
                        };
                    };
                };
                _local_4++;
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            this._bg = null;
            this._inputBG = null;
            this._textBG = null;
            if (this._consortionShop)
            {
                ObjectUtils.disposeObject(this._consortionShop);
                this._consortionShop.bitmapData.dispose();
            };
            this._consortionShop = null;
            if (this._consortionStore)
            {
                ObjectUtils.disposeObject(this._consortionStore);
                this._consortionStore.bitmapData.dispose();
            };
            this._consortionStore = null;
            if (this._consortionSkill)
            {
                ObjectUtils.disposeObject(this._consortionSkill);
                this._consortionSkill.bitmapData.dispose();
            };
            this._consortionSkill = null;
            this._contributionText1 = null;
            this._contributionText2 = null;
            this._contributionText3 = null;
            this._contributionText4 = null;
            this._contributionText5 = null;
            this._contributionText6 = null;
            this._contributionText7 = null;
            this._noticeText = null;
            this._taxBtn = null;
            this._okBtn = null;
            this._cancelBtn = null;
            this._shopLevelTxt1 = null;
            this._shopLevelTxt2 = null;
            this._shopLevelTxt3 = null;
            this._shopLevelTxt4 = null;
            this._shopLevelTxt5 = null;
            this._smithTxt = null;
            this._skillTxt = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

