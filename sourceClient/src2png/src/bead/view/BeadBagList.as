// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadBagList

package bead.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.utils.Dictionary;
    import ddt.data.BagInfo;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.TextButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.ProgressBar;
    import ddt.events.BagEvent;
    import ddt.manager.PlayerManager;
    import ddt.events.PlayerPropertyEvent;
    import bead.BeadManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.utils.DoubleClickManager;
    import ddt.utils.PositionUtils;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.LeavePageManager;
    import ddt.events.CrazyTankSocketEvent;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.data.goods.InventoryItemInfo;
    import road7th.data.DictionaryData;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;
    import ddt.manager.TaskManager;
    import com.pickgliss.ui.ShowTipManager;
    import road7th.utils.MovieClipWrapper;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.greensock.TweenLite;
    import flash.events.Event;
    import ddt.manager.SavePointManager;
    import com.pickgliss.utils.ObjectUtils;

    public class BeadBagList extends Sprite implements Disposeable 
    {

        private const EquipBagStartPlace:int = 0;
        private const EquipBagEndPlace:int = 4;
        private const BeadBagStartPlace:int = 12;
        private const BeadBagEndPlace:int = 27;

        private var _beadList:Dictionary;
        private var _beadBag:BagInfo;
        private var _levelLimitData:Array;
        private var _beadPowerTxt:BeadPowerText;
        private var _combineOnekeyCellLight:MovieClip;
        private var _recordExp:int;
        private var _splitBtn:TextButton;
        private var _sellSmallBg:Bitmap;
        private var _progressBar:ProgressBar;
        private var _isLock:Boolean;

        public function BeadBagList()
        {
            this.initView();
            this.initEvent();
        }

        public function get beadList():Dictionary
        {
            return (this._beadList);
        }

        private function initEvent():void
        {
            this._beadBag.addEventListener(BagEvent.UPDATE, this.updateBeadCell, false, 0, true);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__lockChange);
        }

        private function initView():void
        {
            var _local_5:BeadCell;
            var _local_6:int;
            var _local_7:BeadCell;
            this._beadBag = PlayerManager.Instance.Self.getBag(BagInfo.BEADBAG);
            this._beadList = new Dictionary();
            var _local_1:String = BeadManager.instance.beadConfig.GemHoleNeedLevel;
            this._levelLimitData = _local_1.split("|");
            var _local_2:int = PlayerManager.Instance.Self.Grade;
            var _local_3:int = this.EquipBagStartPlace;
            while (_local_3 <= this.EquipBagEndPlace)
            {
                _local_5 = ComponentFactory.Instance.creatCustomObject(("equipBeadCell_" + _local_3), [_local_3, null]);
                _local_5.addEventListener(InteractiveEvent.CLICK, this.startBeadDrag, false, 0, true);
                _local_5.addEventListener(InteractiveEvent.DOUBLE_CLICK, this.doubleClickHandler, false, 0, true);
                DoubleClickManager.Instance.enableDoubleClick(_local_5);
                addChild(_local_5);
                this._beadList[_local_3] = _local_5;
                _local_5.info = this._beadBag.items[_local_3];
                _local_5.setBGVisible(false);
                _local_6 = int(this._levelLimitData[_local_3]);
                if (((_local_2 < _local_6) || (_local_6 == -1)))
                {
                    _local_5.lockCell(_local_6);
                };
                _local_3++;
            };
            var _local_4:int = this.BeadBagStartPlace;
            while (_local_4 <= this.BeadBagEndPlace)
            {
                _local_7 = new BeadCell(_local_4, null);
                if (_local_4 == this.BeadBagStartPlace)
                {
                    PositionUtils.setPos(_local_7, "bead.beadcell.centpos");
                    _local_7.bgVisible(false);
                }
                else
                {
                    _local_7.x = ((((_local_4 - 13) % 5) * (12.5 + _local_7.width)) - 4);
                    _local_7.y = ((int(((_local_4 - 13) / 5)) * (8 + _local_7.height)) - 52);
                };
                _local_7.addEventListener(InteractiveEvent.CLICK, this.startBeadDrag, false, 0, true);
                _local_7.addEventListener(InteractiveEvent.DOUBLE_CLICK, this.doubleClickHandler, false, 0, true);
                DoubleClickManager.Instance.enableDoubleClick(_local_7);
                addChild(_local_7);
                this._beadList[_local_4] = _local_7;
                _local_7.info = this._beadBag.items[_local_4];
                _local_4++;
            };
            this._beadPowerTxt = ComponentFactory.Instance.creatCustomObject("beadInsetView.beadPower.txt");
            this.refreshBeadPowerTxt();
            addChild(this._beadPowerTxt);
            this._combineOnekeyCellLight = ComponentFactory.Instance.creat("asset.core.beadCellShine");
            this._combineOnekeyCellLight.x = -6;
            this._combineOnekeyCellLight.y = -6;
            this._combineOnekeyCellLight.scaleX = 1.2;
            this._combineOnekeyCellLight.scaleY = 1.2;
            this._combineOnekeyCellLight.gotoAndStop(1);
            this._beadList[12].addChild(this._combineOnekeyCellLight);
            this.playExpTipHandler(false);
            if (this._beadBag.items[this.BeadBagStartPlace])
            {
                this.showSplitSellBtn();
            };
            this._progressBar = ComponentFactory.Instance.creatComponentByStylename("beadSystem.BeadProgressBar");
            addChild(this._progressBar);
            this.updateProgress(this._beadBag.items[this.BeadBagStartPlace]);
        }

        private function __lockChange(_arg_1:PlayerPropertyEvent):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:int;
            if (_arg_1.changedProperties["Grade"])
            {
                _local_2 = PlayerManager.Instance.Self.Grade;
                _local_3 = this.EquipBagStartPlace;
                while (_local_3 <= this.EquipBagEndPlace)
                {
                    _local_4 = int(this._levelLimitData[_local_3]);
                    if ((((!(_local_4 == -1)) && (_local_2 >= _local_4)) && (this._beadList[_local_3].locked)))
                    {
                        this._beadList[_local_3].unlockCell();
                    };
                    _local_3++;
                };
            };
        }

        private function openBeadPlace(_arg_1:MouseEvent):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("beadSystem.bead.vipBeadUnlock.tip"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
            _local_2.addEventListener(FrameEvent.RESPONSE, this.onStack, false, 0, true);
        }

        private function onStack(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.onStack);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.Money < 9980)
                {
                    LeavePageManager.showFillFrame();
                    return;
                };
                this.openVipBeadHandler(null);
            };
        }

        private function openVipBeadHandler(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._beadList[5])
            {
                (this._beadList[5] as BeadCell).buttonMode = false;
                (this._beadList[5] as BeadCell).removeEventListener(MouseEvent.CLICK, this.openBeadPlace);
                (this._beadList[5] as BeadCell).unlockCell();
            };
        }

        private function doubleClickHandler(_arg_1:InteractiveEvent):void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_8:String;
            if (this._isLock)
            {
                return;
            };
            var _local_2:BeadCell = (_arg_1.currentTarget as BeadCell);
            if (((!(_local_2.info)) || (_local_2.locked)))
            {
                return;
            };
            SoundManager.instance.play("008");
            NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAD);
            var _local_3:int = (_local_2.info as InventoryItemInfo).Place;
            var _local_4:DictionaryData = (this._beadBag.items as DictionaryData);
            var _local_5:int = -1;
            if (((_local_3 >= this.EquipBagStartPlace) && (_local_3 <= this.EquipBagEndPlace)))
            {
                _local_6 = 13;
                while (_local_6 <= this.BeadBagEndPlace)
                {
                    if ((!(_local_4[_local_6])))
                    {
                        _local_5 = _local_6;
                        break;
                    };
                    _local_6++;
                };
            }
            else
            {
                if (((_local_3 >= this.BeadBagStartPlace) && (_local_3 <= this.BeadBagEndPlace)))
                {
                    _local_7 = this.EquipBagStartPlace;
                    while (_local_7 <= this.EquipBagEndPlace)
                    {
                        if ((((this._beadList[_local_7] as BeadCell).levelLimit == 0) && (!(_local_4[_local_7]))))
                        {
                            _local_5 = _local_7;
                            break;
                        };
                        _local_7++;
                    };
                };
            };
            if (_local_5 == -1)
            {
                if (((_local_3 >= this.EquipBagStartPlace) && (_local_3 <= this.EquipBagEndPlace)))
                {
                    _local_8 = LanguageMgr.GetTranslation("beadSystem.bead.move.tip");
                }
                else
                {
                    _local_8 = LanguageMgr.GetTranslation("beadSystem.bead.move.tip2");
                };
                MessageTipManager.getInstance().show(_local_8);
            }
            else
            {
                _local_2.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
                BeadManager.instance.doWhatHandle = 3;
                PlayerManager.Instance.Self.isBeadUpdate = false;
                SocketManager.Instance.out.sendBeadMove(_local_3, _local_5);
            };
        }

        private function updateBeadCell(_arg_1:BagEvent):void
        {
            var _local_3:InventoryItemInfo;
            var _local_4:Boolean;
            var _local_5:int;
            var _local_6:InventoryItemInfo;
            var _local_2:Dictionary = _arg_1.changedSlots;
            for each (_local_3 in _local_2)
            {
                _local_5 = _local_3.Place;
                if ((((_local_5 >= this.EquipBagStartPlace) && (_local_5 <= this.EquipBagEndPlace)) || ((_local_5 >= this.BeadBagStartPlace) && (_local_5 <= this.BeadBagEndPlace))))
                {
                    _local_6 = this._beadBag.getItemAt(_local_5);
                    if (_local_6)
                    {
                        this.setCellInfo(_local_5, _local_6);
                    }
                    else
                    {
                        this.setCellInfo(_local_5, null);
                    };
                };
            };
            BeadManager.instance.comineCount--;
            _local_4 = BeadManager.instance.doJudgeLevelUp();
            if (_local_4)
            {
                this.showLevelUpCartoon();
                TaskManager.instance.checkHighLight();
            };
            this.playExpTipHandler((!(_local_4)));
            this.refreshBeadPowerTxt();
            this.updateProgress(this._beadBag.items[this.BeadBagStartPlace]);
            if (BeadManager.instance.comineCount <= 0)
            {
                BeadManager.instance.doWhatHandle = -1;
            };
            this.judgeCombineOnekeyCell();
            ShowTipManager.Instance.removeAllTip();
        }

        private function showLevelUpCartoon():void
        {
            var _local_1:MovieClipWrapper;
            SoundManager.instance.play("173");
            _local_1 = new MovieClipWrapper(ClassUtils.CreatInstance("asset.beadSystem.levelUpCartoon"), true, true);
            var _local_2:int = BeadManager.instance.curPlace;
            _local_1.movie.x = (this._beadList[_local_2].x + (this._beadList[_local_2].width / 2));
            _local_1.movie.y = (this._beadList[_local_2].y + (this._beadList[_local_2].height / 2));
            addChild(_local_1.movie);
        }

        private function playExpTipHandler(isShowExpCartoon:Boolean):void
        {
            var addExp:int;
            var txt:FilterFrameText;
            if (((BeadManager.instance.doWhatHandle == 2) && (isShowExpCartoon)))
            {
                addExp = ((this._beadBag.items[this.BeadBagStartPlace] as InventoryItemInfo).beadExp - this._recordExp);
                if (((BeadManager.instance.comineCount <= 0) && (addExp > 0)))
                {
                    var moveCartoonStep1:Function = function (txt:FilterFrameText):void
                    {
                        var moveCartoonStep2:Function;
                        moveCartoonStep2 = function (_arg_1:FilterFrameText):void
                        {
                            TweenLite.to(_arg_1, 0.4, {
                                "y":(_arg_1.y - 46),
                                "alpha":0,
                                "onComplete":disposeExpTipTxt,
                                "onCompleteParams":[_arg_1]
                            });
                        };
                        TweenLite.to(txt, 0.4, {
                            "y":txt.y,
                            "alpha":1,
                            "onComplete":moveCartoonStep2,
                            "onCompleteParams":[txt]
                        });
                    };
                    SoundManager.instance.play("174");
                    txt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.combineOnekey.expTip");
                    txt.text = LanguageMgr.GetTranslation("beadSystem.bead.combineOneKey.expTip", addExp);
                    txt.x = ((this._beadList[this.BeadBagStartPlace].x + (this._beadList[this.BeadBagStartPlace].width / 2)) - (txt.width / 2));
                    txt.y = ((this._beadList[this.BeadBagStartPlace].y + this._beadList[this.BeadBagStartPlace].height) - 20);
                    addChild(txt);
                    txt.alpha = 0;
                    TweenLite.to(txt, 0.4, {
                        "y":(txt.y - (this._beadList[this.BeadBagStartPlace].height / 2)),
                        "alpha":1,
                        "onComplete":moveCartoonStep1,
                        "onCompleteParams":[txt]
                    });
                };
            }
            else
            {
                if (this._beadBag.items[this.BeadBagStartPlace])
                {
                    this._recordExp = (this._beadBag.items[this.BeadBagStartPlace] as InventoryItemInfo).beadExp;
                };
            };
        }

        private function disposeExpTipTxt(_arg_1:FilterFrameText):void
        {
            if (((_arg_1) && (_arg_1.parent)))
            {
                _arg_1.parent.removeChild(_arg_1);
            };
        }

        private function judgeCombineOnekeyCell():void
        {
            if (this._beadBag.items[this.BeadBagStartPlace])
            {
                this.hideCombineOnekeyCellLight();
                this.showSplitSellBtn();
            }
            else
            {
                this.hideSplitSellBtn();
            };
        }

        private function updateProgress(_arg_1:InventoryItemInfo):void
        {
            var _local_3:String;
            var _local_4:int;
            var _local_5:Array;
            var _local_6:Array;
            var _local_2:Object = BeadManager.instance.list;
            if ((!(_local_2)))
            {
                return;
            };
            this._progressBar.visible = ((_arg_1) ? true : false);
            if (((!(_arg_1)) || (_arg_1.beadLevel == 30)))
            {
                _local_3 = "100";
                this._progressBar.progress = 1;
            }
            else
            {
                _local_4 = ((_arg_1.beadLevel == 30) ? 29 : _arg_1.beadLevel);
                _local_5 = BeadManager.instance.calExpLimit((_arg_1 as InventoryItemInfo));
                this._progressBar.progress = (_local_5[0] / _local_5[1]);
                _local_3 = String((this._progressBar.progress * 100));
                _local_6 = _local_3.split(".");
                if (_local_6.length != 1)
                {
                    _local_3 = ((_local_6[0] + ".") + String(_local_6[1]).substr(0, 2));
                };
            };
            this._progressBar.text = (_local_3 + "%");
        }

        private function showSplitSellBtn():void
        {
            if (this._sellSmallBg == null)
            {
                this._sellSmallBg = ComponentFactory.Instance.creatBitmap("asset.beadSystem.splitSellBg");
                addChild(this._sellSmallBg);
                this._sellSmallBg.height = 33;
                this._sellSmallBg.visible = false;
            };
            var _local_1:InventoryItemInfo = (this._beadBag.items[this.BeadBagStartPlace] as InventoryItemInfo);
            if (_local_1.beadExp > 0)
            {
                if (this._splitBtn)
                {
                    this._splitBtn.visible = true;
                }
                else
                {
                    this._splitBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.combineOneKey.splitBtn");
                    this._splitBtn.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.split");
                    this._splitBtn.addEventListener(MouseEvent.CLICK, this.splitBeadHandler);
                    addChild(this._splitBtn);
                };
            }
            else
            {
                if (this._splitBtn)
                {
                    this._splitBtn.visible = false;
                };
            };
            if (((this._splitBtn) && (this._splitBtn.visible)))
            {
                this._sellSmallBg.visible = true;
                this._sellSmallBg.y = (this._splitBtn.y - 5);
            }
            else
            {
                this._sellSmallBg.visible = false;
            };
        }

        private function splitBeadHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("beadSystem.bead.combineOnekey.splitBead.moneyTip", BeadManager.instance.beadConfig.GemSplit), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
            _local_2.addEventListener(FrameEvent.RESPONSE, this.onStack2, false, 0, true);
        }

        private function onStack2(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.onStack2);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if ((PlayerManager.Instance.Self.Money + PlayerManager.Instance.Self.DDTMoney) < BeadManager.instance.beadConfig.GemSplit)
                {
                    LeavePageManager.showFillFrame();
                    return;
                };
                SocketManager.Instance.out.sendBeadSplit();
            };
        }

        private function doSplitBeadHandler(_arg_1:Event):void
        {
            var _local_2:BeadCombineConfirmFrame = (_arg_1.currentTarget as BeadCombineConfirmFrame);
            _local_2.removeEventListener(BeadManager.BEAD_COMBINE_CONFIRM_RETURN_EVENT, this.doSplitBeadHandler);
            if (_local_2.isYes)
            {
                SocketManager.Instance.out.sendBeadSplit();
            };
        }

        private function sellBeadHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if ((this._beadBag.items[this.BeadBagStartPlace] as InventoryItemInfo).beadExp > 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("beadSystem.bead.combineOnekey.sellBead.expTip"));
                return;
            };
            var _local_2:InventoryItemInfo = (this._beadBag.items[this.BeadBagStartPlace] as InventoryItemInfo);
            var _local_3:int = BeadManager.instance.list[_local_2.Property2][_local_2.beadLevel.toString()].SellScore;
            var _local_4:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("beadSystem.bead.combineConfirm.tip5", BeadManager.instance.getBeadColorName(_local_2, true, true), _local_3), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
            _local_4.addEventListener(FrameEvent.RESPONSE, this.onStack3, false, 0, true);
        }

        private function onStack3(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.onStack3);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendBeadSell();
            };
        }

        private function doSellBeadHandler(_arg_1:Event):void
        {
            var _local_2:BeadCombineConfirmFrame = (_arg_1.currentTarget as BeadCombineConfirmFrame);
            _local_2.removeEventListener(BeadManager.BEAD_COMBINE_CONFIRM_RETURN_EVENT, this.doSellBeadHandler);
            if (_local_2.isYes)
            {
                SocketManager.Instance.out.sendBeadSell();
            };
        }

        private function hideSplitSellBtn():void
        {
            if (this._splitBtn)
            {
                this._splitBtn.visible = false;
            };
            if (this._sellSmallBg)
            {
                this._sellSmallBg.visible = false;
            };
        }

        public function showCombineOnekeyCellLight():void
        {
            this._combineOnekeyCellLight.visible = true;
            this._combineOnekeyCellLight.gotoAndPlay(1);
        }

        public function hideCombineOnekeyCellLight():void
        {
            this._combineOnekeyCellLight.visible = false;
            this._combineOnekeyCellLight.gotoAndStop(1);
        }

        public function getBeadBagBeadCount():int
        {
            var _local_1:int;
            var _local_2:int = (this.BeadBagStartPlace + 1);
            while (_local_2 <= this.BeadBagEndPlace)
            {
                if (this._beadBag.items[_local_2])
                {
                    _local_1++;
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function getBeadBagLockCount():int
        {
            var _local_1:int;
            var _local_2:int = (this.BeadBagStartPlace + 1);
            while (_local_2 <= this.BeadBagEndPlace)
            {
                if (!(!(this._beadBag.items[_local_2] is InventoryItemInfo)))
                {
                    if (this._beadBag.items[_local_2].beadIsLock == 1)
                    {
                        _local_1++;
                    }
                    else
                    {
                        if (this._beadBag.items[_local_2].beadLevel >= 30)
                        {
                            _local_1++;
                        };
                    };
                };
                _local_2++;
            };
            return (_local_1);
        }

        private function refreshBeadPowerTxt():void
        {
            var _local_9:InventoryItemInfo;
            var _local_1:DictionaryData = this._beadBag.items;
            var _local_2:int;
            var _local_3:String = "";
            var _local_4:String = "    ";
            var _local_5:String = "   ";
            var _local_6:String = "  ";
            var _local_7:Object = BeadManager.instance.list;
            var _local_8:int;
            while (_local_8 <= this.EquipBagEndPlace)
            {
                if (_local_1[_local_8])
                {
                    _local_9 = (_local_1[_local_8] as InventoryItemInfo);
                    if (_local_9.beadLevel == 30)
                    {
                        _local_2 = (_local_2 + int(_local_7[_local_9.Property2][30].Exp));
                    }
                    else
                    {
                        _local_2 = (_local_2 + _local_9.beadExp);
                    };
                    _local_3 = (_local_3 + LanguageMgr.GetTranslation("beadSystem.bead.name.color.html", BeadManager.instance.getBeadNameColor(_local_9), LanguageMgr.GetTranslation("beadSystem.bead.nameLevel", _local_9.Name, _local_9.beadLevel, "")));
                    if (((_local_9.Name.substr(0, 1) == "S") || (_local_9.Name.substr(0, 1) == "s")))
                    {
                        if (_local_9.beadLevel >= 10)
                        {
                            _local_3 = (_local_3 + _local_6);
                        }
                        else
                        {
                            _local_3 = (_local_3 + _local_5);
                        };
                    }
                    else
                    {
                        if (_local_9.beadLevel >= 10)
                        {
                            _local_3 = (_local_3 + _local_5);
                        }
                        else
                        {
                            _local_3 = (_local_3 + _local_4);
                        };
                    };
                    _local_3 = (_local_3 + (BeadManager.instance.getDescriptionStr(_local_9) + "\n"));
                };
                _local_8++;
            };
            this._beadPowerTxt.text = int((_local_2 / 10)).toString();
            this._beadPowerTxt.tipData = [LanguageMgr.GetTranslation("beadSystem.bead.beadPower.titleTip", this._beadPowerTxt.text), _local_3];
        }

        public function setCellInfo(_arg_1:int, _arg_2:InventoryItemInfo):void
        {
            this._beadList[String(_arg_1)].info = _arg_2;
            if (SavePointManager.Instance.isInSavePoint(71))
            {
                if ((!(BeadManager.instance.guildeStepI)))
                {
                    if (((_arg_1 == 12) && (_arg_2)))
                    {
                        BeadManager.instance.guildeStepI = true;
                        NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD, 0, "trainer.beadClick1", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                    };
                }
                else
                {
                    if (((_arg_1 == 0) && (_arg_2)))
                    {
                        NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAD);
                        BeadManager.instance.guildeStepI = false;
                        SavePointManager.Instance.setSavePoint(71);
                    };
                };
            };
        }

        private function startBeadDrag(_arg_1:InteractiveEvent):void
        {
            if (this._isLock)
            {
                return;
            };
            var _local_2:BeadCell = (_arg_1.currentTarget as BeadCell);
            if (((!(_local_2.locked)) && (_local_2.info)))
            {
                SoundManager.instance.play("008");
                _local_2.dragStart();
                NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_BEAD);
                if (SavePointManager.Instance.isInSavePoint(71))
                {
                    if ((!(this._beadList[12].info)))
                    {
                        NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD, 180, "trainer.beadClick4", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                    }
                    else
                    {
                        if ((!(this._beadList[0].info)))
                        {
                            NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD, -90, "trainer.beadClick3", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                        };
                    };
                };
            };
        }

        private function removeEvent():void
        {
            this._beadBag.removeEventListener(BagEvent.UPDATE, this.updateBeadCell);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__lockChange);
        }

        public function dispose():void
        {
            var _local_1:BeadCell;
            this.removeEvent();
            if (this._combineOnekeyCellLight)
            {
                this._combineOnekeyCellLight.gotoAndStop(1);
            };
            ObjectUtils.disposeObject(this._combineOnekeyCellLight);
            this._combineOnekeyCellLight = null;
            for each (_local_1 in this._beadList)
            {
                _local_1.removeEventListener(InteractiveEvent.CLICK, this.startBeadDrag);
                _local_1.removeEventListener(InteractiveEvent.DOUBLE_CLICK, this.doubleClickHandler);
                DoubleClickManager.Instance.disableDoubleClick(_local_1);
                if (_local_1)
                {
                    ObjectUtils.disposeObject(_local_1);
                };
            };
            this._beadList = null;
            ObjectUtils.disposeObject(this._beadPowerTxt);
            this._beadPowerTxt = null;
            ObjectUtils.disposeObject(this._progressBar);
            this._progressBar = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get isLock():Boolean
        {
            return (this._isLock);
        }

        public function set isLock(_arg_1:Boolean):void
        {
            this._isLock = _arg_1;
        }


    }
}//package bead.view

