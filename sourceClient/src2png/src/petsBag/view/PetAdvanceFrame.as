// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.PetAdvanceFrame

package petsBag.view
{
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import petsBag.view.item.PetBigItem;
    import petsBag.view.item.PetAdvanceBar;
    import __AS3__.vec.Vector;
    import petsBag.view.item.PetAdvancePropertyItem;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.text.FilterFrameText;
    import petsBag.view.item.PetBlessBar;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.display.MovieClip;
    import pet.date.PetInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.events.BagEvent;
    import flash.events.Event;
    import ddt.command.QuickBuyFrame;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.manager.PetInfoManager;
    import pet.date.PetAdvanceInfo;
    import ddt.manager.PetBagManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PetAdvanceFrame extends PetRightBaseFrame 
    {

        private var _bg2:MutipleImage;
        private var _btnBg:Scale9CornerImage;
        private var _leftLabel:Bitmap;
        private var _rightLabel:Bitmap;
        private var _leftNum1:ScaleFrameImage;
        private var _leftNum2:ScaleFrameImage;
        private var _rightNum1:ScaleFrameImage;
        private var _rightNum2:ScaleFrameImage;
        private var _currentBg:ScaleFrameImage;
        private var _nextBg:ScaleFrameImage;
        private var _currentPet:PetBigItem;
        private var _nextPet:PetBigItem;
        private var _advanceBar:PetAdvanceBar;
        private var _propertyList:Vector.<PetAdvancePropertyItem>;
        private var _vBox:VBox;
        private var _advanceBlessLabel:FilterFrameText;
        private var _blessBar:PetBlessBar;
        private var _advanceBlessTipTxt:FilterFrameText;
        private var _advanceNeedTxt:FilterFrameText;
        private var _advanceNeedLabel:Bitmap;
        private var _stoneCountTxt:FilterFrameText;
        private var _advanceCountBg:Bitmap;
        private var _advanceBtn:BaseButton;
        private var _advanceShine:MovieClip;
        private var _lastInfo:PetInfo;
        private var _titleBmp:Bitmap;
        private var _bloodLabel:MutipleImage;
        private var _attackLabel:MutipleImage;
        private var _defenceLabel:MutipleImage;
        private var _agilityLabel:MutipleImage;
        private var _luckLabel:MutipleImage;

        public function PetAdvanceFrame()
        {
            this.initEvent();
        }

        override protected function init():void
        {
            var _local_2:PetAdvancePropertyItem;
            super.init();
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.petAdv.title");
            addToContent(this._titleBmp);
            this._bg2 = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.bg");
            addToContent(this._bg2);
            this._btnBg = ComponentFactory.Instance.creatComponentByStylename("asset.newpetsBag.petadvacebtnBg");
            addToContent(this._btnBg);
            this._leftLabel = ComponentFactory.Instance.creatBitmap("asset.petsBag.petAdvance.BlueLabel");
            addToContent(this._leftLabel);
            this._rightLabel = ComponentFactory.Instance.creatBitmap("asset.petsBag.petAdvance.RedLabel");
            addToContent(this._rightLabel);
            this._leftNum1 = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.currentNum1");
            addToContent(this._leftNum1);
            this._leftNum2 = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.currentNum2");
            addToContent(this._leftNum2);
            this._rightNum1 = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.nextNum1");
            addToContent(this._rightNum1);
            this._rightNum2 = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.nextNum2");
            addToContent(this._rightNum2);
            this._currentBg = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.petBg1");
            addToContent(this._currentBg);
            this._nextBg = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.petBg2");
            addToContent(this._nextBg);
            this._currentPet = ComponentFactory.Instance.creat("petsBag.petAdvanceView.currentPet");
            this._currentPet.showTip = false;
            addToContent(this._currentPet);
            this._nextPet = ComponentFactory.Instance.creat("petsBag.petAdvanceView.nextPet");
            this._nextPet.showTip = false;
            addToContent(this._nextPet);
            this._bloodLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.bloodLabel");
            addToContent(this._bloodLabel);
            this._attackLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.attackLabel");
            addToContent(this._attackLabel);
            this._defenceLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.defenceLabel");
            addToContent(this._defenceLabel);
            this._agilityLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.agilityLabel");
            addToContent(this._agilityLabel);
            this._luckLabel = ComponentFactory.Instance.creatComponentByStylename("petsBag.petAdvanceFrame.propertyItem.luckLabel");
            addToContent(this._luckLabel);
            this._advanceBar = ComponentFactory.Instance.creat("petsBag.petAdvanceView.advanceBar");
            addToContent(this._advanceBar);
            this._vBox = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.vbox");
            addToContent(this._vBox);
            this._propertyList = new Vector.<PetAdvancePropertyItem>();
            var _local_1:int;
            while (_local_1 < 5)
            {
                _local_2 = new PetAdvancePropertyItem(_local_1);
                this._vBox.addChild(_local_2);
                this._propertyList.push(_local_2);
                _local_1++;
            };
            this._advanceBlessLabel = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceBlessLabel");
            this._advanceBlessLabel.text = LanguageMgr.GetTranslation("petsBag.view.petAdvanceFrame.blessLabel");
            addToContent(this._advanceBlessLabel);
            this._blessBar = ComponentFactory.Instance.creat("petsBag.petAdvanceView.blessBar");
            this._blessBar.maxValue = 100;
            addToContent(this._blessBar);
            this._advanceBlessTipTxt = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceBlessTipTxt");
            this._advanceBlessTipTxt.text = LanguageMgr.GetTranslation("petsBag.view.petAdvanceFrame.blessTipLabel");
            addToContent(this._advanceBlessTipTxt);
            this._advanceNeedLabel = ComponentFactory.Instance.creatBitmap("asset.advanceNeed.label");
            addToContent(this._advanceNeedLabel);
            this._advanceNeedTxt = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.advanceNeedTxt");
            addToContent(this._advanceNeedTxt);
            this._advanceCountBg = ComponentFactory.Instance.creatBitmap("asset.advanceNum.bg");
            addToContent(this._advanceCountBg);
            this._stoneCountTxt = ComponentFactory.Instance.creat("petsBag.petAdvanceFrame.stoneCountTxt");
            addToContent(this._stoneCountTxt);
            this._advanceBtn = ComponentFactory.Instance.creat("petsBag.view.infoFrame.advanceBtn");
            addToContent(this._advanceBtn);
            PositionUtils.setPos(this._advanceBtn, "petsBag.view.infoFrame.advanceBtn.Pos");
        }

        protected function initEvent():void
        {
            this._advanceBtn.addEventListener(MouseEvent.CLICK, this.__btnClick);
            PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE, this.__bagUpdate);
        }

        protected function removeEvent():void
        {
            this._advanceBtn.removeEventListener(MouseEvent.CLICK, this.__btnClick);
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE, this.__bagUpdate);
            if (this._advanceShine)
            {
                this._advanceShine.removeEventListener(Event.COMPLETE, this.__onComplete);
            };
        }

        protected function __btnClick(_arg_1:MouseEvent):void
        {
            var _local_4:QuickBuyFrame;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:PetAdvanceInfo = PetInfoManager.instance.getAdvanceInfo((_info.OrderNumber + 1));
            if ((!(_local_2)))
            {
                return;
            };
            var _local_3:int = PetBagManager.instance().petModel.getAdvanceStoneCount();
            if (_local_3 < _local_2.StoneNum)
            {
                _local_4 = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                _local_4.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                _local_4.itemID = PetBagManager.instance().petModel.AdvanceStoneTemplateId;
                _local_4.stoneNumber = (_local_2.StoneNum - _local_3);
                LayerManager.Instance.addToLayer(_local_4, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            }
            else
            {
                if (_local_2.Grade > _info.Level)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.view.petAdvanceFrame.advanceFailed"));
                }
                else
                {
                    SocketManager.Instance.out.sendPetAdvance(_info.Place);
                };
            };
        }

        protected function __bagUpdate(_arg_1:Event):void
        {
            var _local_2:PetAdvanceInfo = PetInfoManager.instance.getAdvanceInfo((_info.OrderNumber + 1));
            this.updateNeedCondition(_local_2);
        }

        override public function set info(_arg_1:PetInfo):void
        {
            var _local_2:PetAdvanceInfo;
            var _local_3:PetInfo;
            _info = _arg_1;
            if (((_info) && (_info.MagicLevel > 0)))
            {
                this.setAdvanceFont(_info.OrderNumber);
                this._advanceBar.type = ((_info.OrderNumber < 10) ? 0 : 1);
                this._advanceBar.level = _info.OrderNumber;
                this._blessBar.value = _info.Bless;
                _local_2 = PetInfoManager.instance.getAdvanceInfo((_info.OrderNumber + 1));
                this.updateNeedCondition(_local_2);
                if (_local_2)
                {
                    this.setProperty(_info, true);
                    this._advanceBtn.enable = true;
                }
                else
                {
                    this.setProperty(_info, false);
                    this._advanceBtn.enable = false;
                };
                this._currentPet.info = _info;
                _local_3 = PetInfoManager.instance.getPetInfoByTemplateID(_info.TemplateID);
                _local_3.OrderNumber = ((_info.OrderNumber >= 60) ? 60 : int((int(((_info.OrderNumber / 10) + 1)) * 10)));
                this._nextPet.info = _local_3;
                this.checkAdvanceShine();
                this.checkBless();
            }
            else
            {
                dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
            };
            this._lastInfo = _info;
        }

        override public function reset():void
        {
            this._lastInfo = null;
        }

        private function updateNeedCondition(_arg_1:PetAdvanceInfo):void
        {
            var _local_2:Boolean;
            var _local_3:Boolean;
            if (_arg_1)
            {
                _local_2 = (PetBagManager.instance().petModel.getAdvanceStoneCount() < _arg_1.StoneNum);
                _local_3 = (_arg_1.Grade > _info.Level);
                this._advanceNeedTxt.htmlText = LanguageMgr.GetTranslation("petsBag.view.petAdvanceFrame.advanceNeedTxt", ((_local_2) ? "#00b4ff" : "#00b4ff"), _arg_1.StoneNum, ((_local_3) ? "#00b4ff" : "#00b4ff"), _arg_1.Grade);
                this.setProperty(_info, true);
            }
            else
            {
                this._advanceNeedTxt.htmlText = LanguageMgr.GetTranslation("petsBag.view.petAdvanceFrame.advanceNeedTxtMax");
                this.setProperty(_info, false);
            };
            this._stoneCountTxt.text = String(PetBagManager.instance().petModel.getAdvanceStoneCount());
        }

        private function checkAdvanceShine():void
        {
            if (((this._lastInfo) && ((_info.OrderNumber - this._lastInfo.OrderNumber) >= 1)))
            {
                if ((!(this._advanceShine)))
                {
                    this._advanceShine = ComponentFactory.Instance.creat("petsBag.petAdvanceView.advanceShine");
                    this._advanceShine.addEventListener(Event.COMPLETE, this.__onComplete);
                };
                this._advanceShine.gotoAndPlay(1);
                addToContent(this._advanceShine);
            };
        }

        private function checkBless():void
        {
            if (((this._lastInfo) && ((_info.Bless - this._lastInfo.Bless) >= 1)))
            {
                this._blessBar.shine();
            };
        }

        protected function __onComplete(_arg_1:Event):void
        {
            this._advanceShine.stop();
            if (this._advanceShine.parent)
            {
                this._advanceShine.parent.removeChild(this._advanceShine);
            };
        }

        private function setAdvanceFont(_arg_1:int):void
        {
            this._leftNum1.setFrame(((_arg_1 / 10) + 1));
            this._leftNum2.setFrame(((_arg_1 % 10) + 1));
            this._currentBg.setFrame((_arg_1 / 10));
            var _local_2:int = ((_arg_1 >= 60) ? 6 : int(((_arg_1 / 10) + 1)));
            this._rightNum1.setFrame((_local_2 + 1));
            this._rightNum2.setFrame(1);
            this._nextBg.setFrame(_local_2);
        }

        private function setProperty(_arg_1:PetInfo, _arg_2:Boolean):void
        {
            this._propertyList[0].value = (_arg_1.Blood / 100);
            this._propertyList[1].value = (_arg_1.Attack / 100);
            this._propertyList[2].value = (_arg_1.Defence / 100);
            this._propertyList[3].value = (_arg_1.Agility / 100);
            this._propertyList[4].value = (_arg_1.Luck / 100);
            if (_arg_2)
            {
                this._propertyList[0].addValue = ((_arg_1.VBloodGrow / 100) * PetBagManager.instance().petModel.getAddLife(_arg_1.OrderNumber));
                this._propertyList[1].addValue = ((_arg_1.VAttackGrow / 100) * PetBagManager.instance().petModel.getAddProperty(_arg_1.OrderNumber));
                this._propertyList[2].addValue = ((_arg_1.VDefenceGrow / 100) * PetBagManager.instance().petModel.getAddProperty(_arg_1.OrderNumber));
                this._propertyList[3].addValue = ((_arg_1.VAgilityGrow / 100) * PetBagManager.instance().petModel.getAddProperty(_arg_1.OrderNumber));
                this._propertyList[4].addValue = ((_arg_1.VLuckGrow / 100) * PetBagManager.instance().petModel.getAddProperty(_arg_1.OrderNumber));
            }
            else
            {
                this._propertyList[0].addValue = (this._propertyList[1].addValue = (this._propertyList[2].addValue = (this._propertyList[3].addValue = (this._propertyList[4].addValue = 0))));
            };
        }

        private function getFormatNum(_arg_1:int):int
        {
            if (_arg_1 == 0)
            {
                return (10);
            };
            return (_arg_1);
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            if (this._titleBmp)
            {
                ObjectUtils.disposeObject(this._titleBmp);
            };
            this._titleBmp = null;
            ObjectUtils.disposeObject(this._bg2);
            this._bg2 = null;
            ObjectUtils.disposeObject(this._btnBg);
            this._btnBg = null;
            ObjectUtils.disposeObject(this._leftLabel);
            this._leftLabel = null;
            ObjectUtils.disposeObject(this._rightLabel);
            this._rightLabel = null;
            ObjectUtils.disposeObject(this._leftNum1);
            this._leftNum1 = null;
            ObjectUtils.disposeObject(this._leftNum2);
            this._leftNum2 = null;
            ObjectUtils.disposeObject(this._rightNum1);
            this._rightNum1 = null;
            ObjectUtils.disposeObject(this._rightNum2);
            this._rightNum2 = null;
            ObjectUtils.disposeObject(this._currentBg);
            this._currentBg = null;
            ObjectUtils.disposeObject(this._nextBg);
            this._nextBg = null;
            ObjectUtils.disposeObject(this._currentPet);
            this._currentPet = null;
            ObjectUtils.disposeObject(this._nextPet);
            this._nextPet = null;
            ObjectUtils.disposeObject(this._advanceBar);
            this._advanceBar = null;
            while (this._propertyList.length > 0)
            {
                this._propertyList.shift().dispose();
            };
            this._propertyList = null;
            ObjectUtils.disposeObject(this._vBox);
            this._vBox = null;
            ObjectUtils.disposeObject(this._bloodLabel);
            this._bloodLabel = null;
            ObjectUtils.disposeObject(this._attackLabel);
            this._attackLabel = null;
            ObjectUtils.disposeObject(this._defenceLabel);
            this._defenceLabel = null;
            ObjectUtils.disposeObject(this._agilityLabel);
            this._agilityLabel = null;
            ObjectUtils.disposeObject(this._luckLabel);
            this._luckLabel = null;
            ObjectUtils.disposeObject(this._advanceBlessLabel);
            this._advanceBlessLabel = null;
            ObjectUtils.disposeObject(this._blessBar);
            this._blessBar = null;
            ObjectUtils.disposeObject(this._advanceBlessTipTxt);
            this._advanceBlessTipTxt = null;
            ObjectUtils.disposeObject(this._advanceNeedTxt);
            this._advanceNeedTxt = null;
            ObjectUtils.disposeObject(this._stoneCountTxt);
            this._stoneCountTxt = null;
            ObjectUtils.disposeObject(this._advanceBtn);
            this._advanceBtn = null;
            ObjectUtils.disposeObject(this._advanceShine);
            this._advanceShine = null;
            ObjectUtils.disposeObject(this._advanceNeedLabel);
            this._advanceNeedLabel = null;
            ObjectUtils.disposeObject(this._advanceCountBg);
            this._advanceCountBg = null;
        }


    }
}//package petsBag.view

