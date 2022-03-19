// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.PetTransFormFrame

package petsBag.view
{
    import __AS3__.vec.Vector;
    import pet.date.PetInfo;
    import ddt.manager.PetInfoManager;
    import ddt.manager.PlayerManager;
    import petsBag.view.item.PetTransFormCell;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import petsBag.view.item.PetBigItem;
    import petsBag.view.item.PetTransformPropertyItem;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import ddt.manager.ServerConfigManager;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.LeavePageManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PetTransFormFrame extends PetRightBaseFrame 
    {

        private var _petsInfos:Vector.<PetInfo> = PetInfoManager.instance.getPetListAdvanced(PlayerManager.Instance.Self.pets);
        private var _cells:Vector.<PetTransFormCell>;
        private var _cellsBox:SimpleTileList;
        private var _petsBg:Bitmap;
        private var _cellsBg:Bitmap;
        private var _leftBtn:BaseButton;
        private var _rightBtn:BaseButton;
        private var _currentTxtLeft:Bitmap;
        private var _currentTxtAfter:Bitmap;
        private var _afterTxtLeft:Bitmap;
        private var _afterTxtAfter:Bitmap;
        private var _leftLabel:Bitmap;
        private var _rightLabel:Bitmap;
        private var _leftNum1:ScaleFrameImage;
        private var _leftNum2:ScaleFrameImage;
        private var _rightNum1:ScaleFrameImage;
        private var _rightNum2:ScaleFrameImage;
        private var _leftPetBg:ScaleFrameImage;
        private var _rightPetBg:ScaleFrameImage;
        private var _leftPet:PetBigItem;
        private var _rightPet:PetBigItem;
        private var _leftIndex:int = -1;
        private var _rightIndex:int = -1;
        private var _propertyList:Vector.<PetTransformPropertyItem>;
        private var _propertyVBox:VBox;
        private var _transformBtn:BaseButton;
        private var _moneyShow:FilterFrameText;
        private var _bigArrow:Bitmap;
        private var _arrowLeft:Bitmap;
        private var _arrowRight:Bitmap;
        private var _currentPage:int = 1;
        private var _page:int = (_petsInfos.length / 4);//1
        private var _alert1:BaseAlerFrame;
        private var _alert2:BaseAlerFrame;
        private var _titleBmp:Bitmap;

        public function PetTransFormFrame()
        {
            if ((this._petsInfos.length % 4) > 0)
            {
                this._page++;
            };
            super();
            this.initView();
            this.initEvent();
        }

        override public function set info(_arg_1:PetInfo):void
        {
            var _local_2:PetInfo;
            this._petsInfos = PetInfoManager.instance.getPetListAdvanced(PlayerManager.Instance.Self.pets);
            this.initCells();
            if (((this._leftPet.info) || (this._rightPet.info)))
            {
                for each (_local_2 in this._petsInfos)
                {
                    if (((this._leftPet.info) && (_local_2.ID == this._leftPet.info.ID)))
                    {
                        this._leftPet.info = _local_2;
                    }
                    else
                    {
                        if (((this._rightPet.info) && (_local_2.ID == this._rightPet.info.ID)))
                        {
                            this._rightPet.info = _local_2;
                        };
                    };
                };
            };
            this.setAdvanceFont();
            this.setProperty();
        }

        private function initView():void
        {
            var _local_2:PetTransformPropertyItem;
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.petTrans.title");
            addToContent(this._titleBmp);
            this._petsBg = ComponentFactory.Instance.creatBitmap("asset.petsBag.transform.bg");
            PositionUtils.setPos(this._petsBg, "petsBag.petTransformFrame.petsBg.pos");
            addToContent(this._petsBg);
            this._cellsBg = ComponentFactory.Instance.creatBitmap("asset.transform.bg");
            addToContent(this._cellsBg);
            this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.petTransformFrame.rightBtn");
            addToContent(this._rightBtn);
            this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.petTransformFrame.leftBtn");
            addToContent(this._leftBtn);
            this._currentTxtLeft = ComponentFactory.Instance.creatBitmap("asset.transform.current.txt");
            PositionUtils.setPos(this._currentTxtLeft, "asset.petsBag.petTransformFrame.currentPosLeft");
            addToContent(this._currentTxtLeft);
            this._currentTxtAfter = ComponentFactory.Instance.creatBitmap("asset.transform.current.txt");
            PositionUtils.setPos(this._currentTxtAfter, "asset.petsBag.petTransformFrame.currentPosRight");
            addToContent(this._currentTxtAfter);
            this._afterTxtLeft = ComponentFactory.Instance.creatBitmap("asset.transform.after.txt");
            PositionUtils.setPos(this._afterTxtLeft, "asset.petsBag.petTransformFrame.afterPosLeft");
            addToContent(this._afterTxtLeft);
            this._afterTxtAfter = ComponentFactory.Instance.creatBitmap("asset.transform.after.txt");
            PositionUtils.setPos(this._afterTxtAfter, "asset.petsBag.petTransformFrame.afterPosRight");
            addToContent(this._afterTxtAfter);
            this._leftLabel = ComponentFactory.Instance.creatBitmap("asset.petsBag.petAdvance.BlueLabel");
            PositionUtils.setPos(this._leftLabel, "asset.petsBag.petAdvance.BlueLabelPos");
            addToContent(this._leftLabel);
            this._rightLabel = ComponentFactory.Instance.creatBitmap("asset.petsBag.petAdvance.RedLabel");
            PositionUtils.setPos(this._rightLabel, "asset.petsBag.petAdvance.RedLabelPos");
            addToContent(this._rightLabel);
            this._leftNum1 = ComponentFactory.Instance.creat("petsBag.petTransformFrame.leftNum1");
            this._leftNum1.visible = false;
            addToContent(this._leftNum1);
            this._leftNum2 = ComponentFactory.Instance.creat("petsBag.petTransformFrame.leftNum2");
            this._leftNum2.visible = false;
            addToContent(this._leftNum2);
            this._rightNum1 = ComponentFactory.Instance.creat("petsBag.petTransformFrame.rightNum1");
            this._rightNum1.visible = false;
            addToContent(this._rightNum1);
            this._rightNum2 = ComponentFactory.Instance.creat("petsBag.petTransformFrame.rightNum2");
            this._rightNum2.visible = false;
            addToContent(this._rightNum2);
            this._leftPetBg = ComponentFactory.Instance.creat("petsBag.petTransformFrame.petBg1");
            this._leftPetBg.setFrame(0);
            addToContent(this._leftPetBg);
            this._rightPetBg = ComponentFactory.Instance.creat("petsBag.petTransformFrame.petBg2");
            this._rightPetBg.setFrame(0);
            addToContent(this._rightPetBg);
            this._leftPet = ComponentFactory.Instance.creat("petsBag.petTransformFrame.leftPet");
            this._leftPet.showTip = false;
            addToContent(this._leftPet);
            this._rightPet = ComponentFactory.Instance.creat("petsBag.petTransformFrame.rightPet");
            this._rightPet.showTip = false;
            addToContent(this._rightPet);
            this._propertyVBox = ComponentFactory.Instance.creat("petsBag.petTransformFrame.vbox");
            addToContent(this._propertyVBox);
            this._propertyList = new Vector.<PetTransformPropertyItem>();
            var _local_1:int;
            while (_local_1 < 5)
            {
                _local_2 = new PetTransformPropertyItem(_local_1);
                this._propertyVBox.addChild(_local_2);
                this._propertyList.push(_local_2);
                _local_1++;
            };
            this._cellsBox = ComponentFactory.Instance.creatCustomObject("petsBag.petTransformFrame.cellBox", [4]);
            addToContent(this._cellsBox);
            this.initCells();
            this._transformBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.infoFrame.transformBtn");
            PositionUtils.setPos(this._transformBtn, "petsBag.view.infoFrame.transformBtnPos");
            addToContent(this._transformBtn);
            this._moneyShow = ComponentFactory.Instance.creatComponentByStylename("petsBag.petTransformFrame.showMoneyTxt");
            this._moneyShow.htmlText = LanguageMgr.GetTranslation("petsBag.view.petTransformFrame.showMoneyTxt", ServerConfigManager.instance.petTransformMoeny);
            addToContent(this._moneyShow);
            this._bigArrow = ComponentFactory.Instance.creatBitmap("asset.transform.transform.arrow");
            addToContent(this._bigArrow);
            this._arrowLeft = ComponentFactory.Instance.creatBitmap("asset.transform.bigArrow2");
            PositionUtils.setPos(this._arrowLeft, "asset.petsBag.petTransformFrame.arrowLeft");
            this._arrowLeft.visible = false;
            addToContent(this._arrowLeft);
            this._arrowRight = ComponentFactory.Instance.creatBitmap("asset.transform.bigArrow2");
            PositionUtils.setPos(this._arrowRight, "asset.petsBag.petTransformFrame.arrowRight");
            this._arrowRight.visible = false;
            addToContent(this._arrowRight);
        }

        private function initEvent():void
        {
            this._transformBtn.addEventListener(MouseEvent.CLICK, this.__sendTransform);
            this._leftBtn.addEventListener(MouseEvent.CLICK, this.__goLeft);
            this._rightBtn.addEventListener(MouseEvent.CLICK, this.__goRight);
        }

        private function setProperty():void
        {
            this._propertyList[0].setInfo(this._leftPet.info, this._rightPet.info);
            this._propertyList[1].setInfo(this._leftPet.info, this._rightPet.info);
            this._propertyList[2].setInfo(this._leftPet.info, this._rightPet.info);
            this._propertyList[3].setInfo(this._leftPet.info, this._rightPet.info);
            this._propertyList[4].setInfo(this._leftPet.info, this._rightPet.info);
        }

        private function initCells():void
        {
            var _local_1:PetTransFormCell;
            this.clearCells();
            var _local_2:int = ((this._currentPage - 1) * 4);
            while (_local_2 < this._petsInfos.length)
            {
                if ((_local_2 - ((this._currentPage - 1) * 4)) >= 4) break;
                _local_1 = new PetTransFormCell();
                _local_1.addEventListener(MouseEvent.CLICK, this.__click);
                _local_1.index = _local_2;
                _local_1.info = this._petsInfos[_local_2];
                _local_1.x = ((_local_2 * 50) + 10);
                this._cellsBox.addChild(_local_1);
                this._cells.push(_local_1);
                if ((((!(this._leftIndex == -1)) && (_local_1.index == this._leftIndex)) || ((!(this._rightIndex == -1)) && (_local_1.index == this._rightIndex))))
                {
                    _local_1.selected = true;
                };
                _local_2++;
            };
        }

        private function __click(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.playButtonSound();
            var _local_2:PetTransFormCell = (_arg_1.currentTarget as PetTransFormCell);
            if (((((this._leftPet.info) && (this._rightPet.info)) && (!(_local_2.info.ID == this._leftPet.info.ID))) && (!(_local_2.info.ID == this._rightPet.info.ID))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.view.petTransformFrame.enoughtPet"));
                return;
            };
            _local_2.selected = (!(_local_2.selected));
            if (_local_2.selected)
            {
                if (this._leftPet.info == null)
                {
                    this._leftPet.info = _local_2.info;
                    this._leftIndex = _local_2.index;
                }
                else
                {
                    if (this._rightPet.info == null)
                    {
                        this._rightPet.info = _local_2.info;
                        this._rightIndex = _local_2.index;
                    };
                };
            }
            else
            {
                if (((this._leftPet.info) && (this._leftPet.info.ID == _local_2.info.ID)))
                {
                    this._leftPet.info = null;
                    this._leftIndex = -1;
                }
                else
                {
                    if (((this._rightPet.info) && (this._rightPet.info.ID == _local_2.info.ID)))
                    {
                        this._rightPet.info = null;
                        this._rightIndex = -1;
                    };
                };
            };
            this._arrowLeft.visible = ((this._leftPet.info) && (this._rightPet.info));
            this._arrowRight.visible = ((this._leftPet.info) && (this._rightPet.info));
            this.setAdvanceFont();
            this.setProperty();
        }

        private function setAdvanceFont():void
        {
            this._leftNum1.visible = (this._leftNum2.visible = (this._leftLabel.visible = (!(this._leftPet.info == null))));
            this._rightNum1.visible = (this._rightNum2.visible = (this._rightLabel.visible = (!(this._rightPet.info == null))));
            if (this._leftPet.info)
            {
                this._leftNum1.setFrame(((this._leftPet.info.OrderNumber / 10) + 1));
                this._leftNum2.setFrame(((this._leftPet.info.OrderNumber % 10) + 1));
                this._leftPetBg.setFrame((this._leftPet.info.OrderNumber / 10));
            }
            else
            {
                this._leftPetBg.setFrame(0);
            };
            if (this._rightPet.info)
            {
                this._rightNum1.setFrame(((this._rightPet.info.OrderNumber / 10) + 1));
                this._rightNum2.setFrame(((this._rightPet.info.OrderNumber % 10) + 1));
                this._rightPetBg.setFrame((this._rightPet.info.OrderNumber / 10));
            }
            else
            {
                this._rightPetBg.setFrame(0);
            };
        }

        private function __sendTransform(_arg_1:MouseEvent):void
        {
            var _local_2:SelectedCheckButton;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (((!(this._leftPet.info)) || (!(this._rightPet.info))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.view.petTransformFrame.sendTransform.no"));
            }
            else
            {
                if (this._leftPet.info.OrderNumber == this._rightPet.info.OrderNumber)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.view.petTransformFrame.sendTransform.same"));
                }
                else
                {
                    if (((this._leftPet.info.OrderNumber > this._rightPet.info.Level) || (this._leftPet.info.Level < this._rightPet.info.OrderNumber)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.view.petTransformFrame.sendTransform.level"));
                    }
                    else
                    {
                        if ((!(PetInfoManager.instance.petTransformCheckBtn)))
                        {
                            _local_2 = ComponentFactory.Instance.creatComponentByStylename("petsBag.petTransformFrame.checkButton");
                            _local_2.addEventListener(MouseEvent.CLICK, this.__checkClick);
                            _local_2.selected = PetInfoManager.instance.petTransformCheckBtn;
                            _local_2.text = LanguageMgr.GetTranslation("ddt.arena.arenareliveview。reliveCheckTxt");
                            this._alert1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("petsBag.view.petTransformFrame.alertText", ServerConfigManager.instance.petTransformMoeny), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                            this._alert1.addToContent(_local_2);
                            this._alert1.addEventListener(FrameEvent.RESPONSE, this.__frameEvent);
                        }
                        else
                        {
                            if (PlayerManager.Instance.Self.totalMoney < ServerConfigManager.instance.petTransformMoeny)
                            {
                                this._alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("noMoney"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                                this._alert2.addEventListener(FrameEvent.RESPONSE, this.__onNoMoneyResponse);
                            }
                            else
                            {
                                this.sendSocket();
                            };
                        };
                    };
                };
            };
        }

        private function __checkClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:SelectedCheckButton = (_arg_1.target as SelectedCheckButton);
            PetInfoManager.instance.petTransformCheckBtn = _local_2.selected;
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._alert1.removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            this._alert1.dispose();
            this._alert1 = null;
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    if (PlayerManager.Instance.Self.totalMoney < ServerConfigManager.instance.petTransformMoeny)
                    {
                        this._alert2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("noMoney"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                        this._alert2.addEventListener(FrameEvent.RESPONSE, this.__onNoMoneyResponse);
                    }
                    else
                    {
                        this.sendSocket();
                    };
                    return;
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    return;
            };
        }

        private function __onNoMoneyResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._alert2.removeEventListener(FrameEvent.RESPONSE, this.__onNoMoneyResponse);
            this._alert2.disposeChildren = true;
            this._alert2.dispose();
            this._alert2 = null;
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                LeavePageManager.leaveToFillPath();
            };
        }

        private function sendSocket():void
        {
            SocketManager.Instance.out.sendPetTransform(this._leftPet.info.Place, this._rightPet.info.Place);
        }

        private function __goLeft(_arg_1:MouseEvent):void
        {
            var _local_2:int = (this._currentPage - 1);
            _local_2 = ((_local_2 < 1) ? 1 : _local_2);
            if (_local_2 != this._currentPage)
            {
                this._currentPage = _local_2;
                this.initCells();
            };
        }

        private function __goRight(_arg_1:MouseEvent):void
        {
            var _local_2:int = (this._currentPage + 1);
            _local_2 = ((_local_2 > this._page) ? this._page : _local_2);
            if (_local_2 != this._currentPage)
            {
                this._currentPage = _local_2;
                this.initCells();
            };
        }

        private function clearCells():void
        {
            var _local_1:PetTransFormCell;
            for each (_local_1 in this._cells)
            {
                ObjectUtils.disposeObject(_local_1);
                _local_1.removeEventListener(MouseEvent.CLICK, this.__click);
                _local_1 = null;
            };
            this._cells = new Vector.<PetTransFormCell>();
        }

        private function removeEvent():void
        {
            this._transformBtn.removeEventListener(MouseEvent.CLICK, this.__sendTransform);
            this._leftBtn.removeEventListener(MouseEvent.CLICK, this.__goLeft);
            this._rightBtn.removeEventListener(MouseEvent.CLICK, this.__goRight);
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.clearCells();
            ObjectUtils.disposeObject(this._titleBmp);
            this._titleBmp = null;
            ObjectUtils.disposeObject(this._cellsBox);
            this._cellsBox = null;
            ObjectUtils.disposeObject(this._petsBg);
            this._petsBg = null;
            ObjectUtils.disposeObject(this._leftBtn);
            this._leftBtn = null;
            ObjectUtils.disposeObject(this._rightBtn);
            this._rightBtn = null;
            ObjectUtils.disposeObject(this._currentTxtLeft);
            this._currentTxtLeft = null;
            ObjectUtils.disposeObject(this._afterTxtLeft);
            this._afterTxtLeft = null;
            ObjectUtils.disposeObject(this._currentTxtAfter);
            this._currentTxtAfter = null;
            ObjectUtils.disposeObject(this._afterTxtAfter);
            this._afterTxtAfter = null;
            ObjectUtils.disposeObject(this._cellsBox);
            this._cellsBox = null;
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
            ObjectUtils.disposeObject(this._leftPet);
            this._leftPet = null;
            ObjectUtils.disposeObject(this._rightPet);
            this._rightPet = null;
            ObjectUtils.disposeObject(this._leftPetBg);
            this._leftPetBg = null;
            ObjectUtils.disposeObject(this._rightPetBg);
            this._rightPetBg = null;
            ObjectUtils.disposeObject(this._transformBtn);
            this._transformBtn = null;
            ObjectUtils.disposeObject(this._bigArrow);
            this._bigArrow = null;
            ObjectUtils.disposeObject(this._arrowLeft);
            this._arrowLeft = null;
            ObjectUtils.disposeObject(this._arrowRight);
            this._arrowRight = null;
            ObjectUtils.disposeObject(this._alert1);
            this._alert1 = null;
            ObjectUtils.disposeObject(this._alert2);
            this._alert2 = null;
            super.dispose();
        }


    }
}//package petsBag.view

