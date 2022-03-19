// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.states.BaseStoreView

package store.states
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import store.StoreController;
    import store.data.StoreModel;
    import store.StoreMainView;
    import store.StoreTips;
    import store.view.storeBag.StoreBagController;
    import flash.utils.Timer;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.events.CellEvent;
    import store.events.StoreDargEvent;
    import store.events.ChoosePanelEvnet;
    import store.events.StoreIIEvent;
    import store.view.ConsortiaRateManager;
    import flash.events.TimerEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import store.view.storeBag.StoreBagCell;
    import bagAndInfo.cell.BagCell;
    import store.IStoreViewBG;
    import ddt.data.BagInfo;
    import store.view.strength.StoreIIStrengthBG;
    import store.view.Compose.StoreIIComposeBG;
    import store.view.refining.StoreRefiningBG;
    import ddt.data.EquipType;
    import ddt.data.StoneType;
    import store.view.embed.StoreEmbedBG;
    import store.view.transfer.StoreIITransferBG;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.TaskManager;
    import flash.events.Event;
    import ddt.manager.SharedManager;
    import ddt.manager.MessageTipManager;
    import consortion.ConsortionModelControl;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;

    public class BaseStoreView extends Sprite implements Disposeable 
    {

        protected var _controller:StoreController;
        protected var _model:StoreModel;
        public var _storeview:StoreMainView;
        protected var _tip:StoreTips;
        protected var _storeBag:StoreBagController;
        private var _soundTimer:Timer;
        protected var _guideEmbed:MovieClip;
        private var _type:String;
        private var _consortiaManagerBtn:TextButton;
        private var _consortiaBtnEffect:MovieImage;
        private var _tipFlag:Boolean;

        public function BaseStoreView(_arg_1:StoreController, _arg_2:int)
        {
            this._controller = _arg_1;
            this._model = this._controller.Model;
            this.init();
            this.initEvent();
            this.type = _arg_2;
            this._soundTimer = new Timer(7500, 1);
        }

        private function init():void
        {
            this._consortiaManagerBtn = ComponentFactory.Instance.creat("ddtstore.BagStoreFrame.GuildManagerBtn");
            this._consortiaManagerBtn.text = LanguageMgr.GetTranslation("store.view.GuildManagerText");
            this._consortiaManagerBtn.visible = false;
            this._storeview = ComponentFactory.Instance.creat("ddtstore.MainView");
            addChild(this._storeview);
            this._storeBag = new StoreBagController(this._model);
            addChild(this._storeBag.getView());
            this._tip = ComponentFactory.Instance.creat("ddtstore.storeTip");
            addChild(this._tip);
        }

        protected function initEvent():void
        {
            this._consortiaManagerBtn.addEventListener(MouseEvent.CLICK, this.assetBtnClickHandler);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_STRENGTH, this.__showTip);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_TRANSFER, this.__showTipsIII);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_REFINERY, this.__showTipsIII);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ITEM_EMBED, this.__showTipsIII);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OPEN_FIVE_SIX_HOLE_EMEBED, this.__openHoleComplete);
            this._storeBag.getView().addEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
            this._storeBag.getView().addEventListener(StoreDargEvent.START_DARG, this.startShine);
            this._storeBag.getView().addEventListener(StoreDargEvent.STOP_DARG, this.stopShine);
            this._storeview.addEventListener(ChoosePanelEvnet.CHOOSEPANELEVENT, this.refresh);
            this._storeview.addEventListener(StoreIIEvent.EMBED_CLICK, this.embedClickHandler);
            this._storeview.addEventListener(StoreIIEvent.EMBED_INFORCHANGE, this.embedInfoChangeHandler);
            this._storeview.addEventListener(StoreIIEvent.WEAPON_READY, this.__weaponReady);
            this._storeview.addEventListener(StoreIIEvent.WEAPON_REMOVE, this.__weaponRemove);
            ConsortiaRateManager.instance.addEventListener(ConsortiaRateManager.CHANGE_CONSORTIA, this._changeConsortia);
            this._storeview.StrengthPanel.addEventListener(StoreIIEvent.UPGRADES_PLAY, this.__weaponUpgradesPlay);
            this._model.addEventListener(StoreIIEvent.STONE_UPDATE, this.__updateStone);
        }

        protected function removeEvent():void
        {
            this._consortiaManagerBtn.removeEventListener(MouseEvent.CLICK, this.assetBtnClickHandler);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_STRENGTH, this.__showTip);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_TRANSFER, this.__showTipsIII);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_REFINERY, this.__showTipsIII);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ITEM_EMBED, this.__showTipsIII);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.OPEN_FIVE_SIX_HOLE_EMEBED, this.__openHoleComplete);
            this._storeBag.getView().removeEventListener(CellEvent.DOUBLE_CLICK, this.__cellDoubleClick);
            this._storeBag.getView().removeEventListener(StoreDargEvent.START_DARG, this.startShine);
            this._storeBag.getView().removeEventListener(StoreDargEvent.STOP_DARG, this.stopShine);
            this._storeview.removeEventListener(ChoosePanelEvnet.CHOOSEPANELEVENT, this.refresh);
            this._storeview.removeEventListener(StoreIIEvent.EMBED_CLICK, this.embedClickHandler);
            this._storeview.removeEventListener(StoreIIEvent.EMBED_INFORCHANGE, this.embedInfoChangeHandler);
            this._storeview.removeEventListener(StoreIIEvent.WEAPON_READY, this.__weaponReady);
            this._storeview.removeEventListener(StoreIIEvent.WEAPON_REMOVE, this.__weaponRemove);
            ConsortiaRateManager.instance.removeEventListener(ConsortiaRateManager.CHANGE_CONSORTIA, this._changeConsortia);
            this._storeview.StrengthPanel.removeEventListener(StoreIIEvent.UPGRADES_PLAY, this.__weaponUpgradesPlay);
            this._model.removeEventListener(StoreIIEvent.STONE_UPDATE, this.__updateStone);
            this._soundTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__soundComplete);
        }

        private function __updateStone(_arg_1:StoreIIEvent):void
        {
            this._storeview.StrengthPanel.updateData();
        }

        private function __weaponReady(_arg_1:StoreIIEvent):void
        {
            this._storeBag.model.dispatchEvent(new StoreIIEvent(StoreIIEvent.WEAPON_READY));
        }

        private function __weaponRemove(_arg_1:StoreIIEvent):void
        {
            this._storeBag.model.dispatchEvent(new StoreIIEvent(StoreIIEvent.WEAPON_REMOVE));
        }

        public function setAutoLinkNum(_arg_1:int):void
        {
            this._model.NeedAutoLink = _arg_1;
        }

        private function refresh(_arg_1:ChoosePanelEvnet):void
        {
            this._model.currentPanel = _arg_1.currentPanle;
            this._storeBag.setList(this._model);
            this._storeBag.changeMsg((this._model.currentPanel + 1));
        }

        private function __cellDoubleClick(_arg_1:CellEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (PlayerManager.Instance.Self.bagLocked)
            {
                SoundManager.instance.play("008");
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:BagCell = (_arg_1.data as StoreBagCell);
            var _local_3:IStoreViewBG = this._storeview.currentPanel;
            _local_3.setCell(_local_2);
        }

        private function autoLink(_arg_1:int, _arg_2:int):void
        {
            var _local_3:BagCell;
            var _local_4:IStoreViewBG = this._storeview.currentPanel;
            if (_arg_1 == BagInfo.EQUIPBAG)
            {
                _local_3 = this._storeBag.getEquipCell(_arg_2);
            }
            else
            {
                _local_3 = this._storeBag.getPropCell(_arg_2);
            };
            _local_4.setCell(_local_3);
        }

        private function startShine(_arg_1:StoreDargEvent):void
        {
            var _local_3:StoreIIStrengthBG;
            var _local_4:StoreIIComposeBG;
            var _local_5:StoreRefiningBG;
            var _local_2:IStoreViewBG = this._storeview.currentPanel;
            if ((_local_2 is StoreIIStrengthBG))
            {
                _local_3 = (_local_2 as StoreIIStrengthBG);
                if (_arg_1.sourceInfo.CanEquip)
                {
                    _local_3.startShine(1);
                }
                else
                {
                    if (EquipType.isStrengthStone(_arg_1.sourceInfo))
                    {
                        _local_3.startShine(0);
                    };
                };
            }
            else
            {
                if ((_local_2 is StoreIIComposeBG))
                {
                    _local_4 = (_local_2 as StoreIIComposeBG);
                    if (_arg_1.sourceInfo.CanEquip)
                    {
                        _local_4.startShine(1);
                    }
                    else
                    {
                        if (_arg_1.sourceInfo.Property1 == StoneType.LUCKY)
                        {
                            _local_4.startShine(0);
                        };
                    };
                }
                else
                {
                    if ((_local_2 is StoreEmbedBG))
                    {
                        if (_arg_1.sourceInfo.CanEquip)
                        {
                            (_local_2 as StoreEmbedBG).startShine();
                        }
                        else
                        {
                            (_local_2 as StoreEmbedBG).startEmbedShine();
                        };
                    }
                    else
                    {
                        if ((_local_2 is StoreRefiningBG))
                        {
                            _local_5 = (_local_2 as StoreRefiningBG);
                            if (_arg_1.sourceInfo.CanEquip)
                            {
                                _local_5.startShine();
                            };
                        };
                    };
                };
            };
        }

        private function stopShine(_arg_1:StoreDargEvent):void
        {
            if ((this._storeview.currentPanel is StoreIIStrengthBG))
            {
                (this._storeview.currentPanel as StoreIIStrengthBG).stopShine();
            }
            else
            {
                if ((this._storeview.currentPanel is StoreIIComposeBG))
                {
                    (this._storeview.currentPanel as StoreIIComposeBG).stopShine();
                }
                else
                {
                    if (((this._storeview.currentPanel is StoreIITransferBG) && (!(StoreController.instance.isShine))))
                    {
                        (this._storeview.currentPanel as StoreIITransferBG).stopShine();
                    }
                    else
                    {
                        if ((this._storeview.currentPanel is StoreEmbedBG))
                        {
                            (this._storeview.currentPanel as StoreEmbedBG).stopShine();
                        }
                        else
                        {
                            if ((this._storeview.currentPanel is StoreRefiningBG))
                            {
                                (this._storeview.currentPanel as StoreRefiningBG).stopShine();
                            };
                        };
                    };
                };
            };
        }

        private function __weaponUpgradesPlay(_arg_1:Event):void
        {
            var _local_3:InventoryItemInfo;
            var _local_2:StoreIIStrengthBG = this._storeview.StrengthPanel;
            TaskManager.instance.checkHighLight();
            this._tip.showStrengthSuccess(_local_2.getStrengthItemCellInfo(), this._tipFlag);
            if (this._tipFlag)
            {
                _local_3 = _local_2.getStrengthItemCellInfo();
                this.appearHoleTips(_local_3);
                this.checkHasStrengthLevelThree(_local_3);
            };
        }

        private function __showTip(_arg_1:CrazyTankSocketEvent):void
        {
            this._tip.isDisplayerTip = true;
            var _local_2:int = _arg_1.pkg.readByte();
            this._tipFlag = _arg_1.pkg.readBoolean();
            var _local_3:StoreIIStrengthBG = (this._storeview.currentPanel as StoreIIStrengthBG);
            if (_local_2 != 0)
            {
                if (_local_2 == 1)
                {
                    _local_3.starMoviePlay();
                }
                else
                {
                    if (_local_2 == 2)
                    {
                        this._tip.showFiveFail();
                    }
                    else
                    {
                        if (_local_2 == 3)
                        {
                            ConsortiaRateManager.instance.reset();
                        };
                    };
                };
            };
        }

        private function checkHasStrengthLevelThree(_arg_1:InventoryItemInfo):void
        {
            if ((((PlayerManager.Instance.Self.Grade < 15) && (SharedManager.Instance.hasStrength3[PlayerManager.Instance.Self.ID] == undefined)) && (_arg_1.StrengthenLevel == 3)))
            {
                SharedManager.Instance.hasStrength3[PlayerManager.Instance.Self.ID] = true;
                SharedManager.Instance.save();
            };
        }

        private function __itemCompose(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:int = _arg_1.pkg.readInt();
            if (_local_2 > 0)
            {
                this._tip.isDisplayerTip = true;
                this._tip.showSuccess(StoreTips.COMPOSE);
            };
        }

        private function __showTipsIII(_arg_1:CrazyTankSocketEvent):void
        {
            this._tip.isDisplayerTip = true;
            var _local_2:int = _arg_1.pkg.readByte();
            if (_local_2 == 0)
            {
                switch (_arg_1.type)
                {
                    case CrazyTankSocketEvent.ITEM_TRANSFER:
                        this._tip.showSuccess(StoreTips.TRANSFER);
                        StoreController.instance.dispatchEvent(new Event(StoreController.TRANSFER_SUCCESS));
                        break;
                    case CrazyTankSocketEvent.ITEM_EMBED:
                        this._tip.showSuccess(StoreTips.EMBED);
                        break;
                    default:
                        this._tip.showSuccess();
                };
            }
            else
            {
                if (_local_2 == 1)
                {
                    this._tip.showFail();
                }
                else
                {
                    if (_local_2 == 3)
                    {
                        ConsortiaRateManager.instance.reset();
                    };
                };
            };
        }

        private function __openHoleComplete(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:StoreEmbedBG;
            this._tip.isDisplayerTip = true;
            var _local_2:int = _arg_1.pkg.readByte();
            var _local_3:Boolean = _arg_1.pkg.readBoolean();
            var _local_4:int = _arg_1.pkg.readInt();
            if (_local_2 == 0)
            {
                _local_5 = (this._storeview.currentPanel as StoreEmbedBG);
                if (_local_3)
                {
                    SoundManager.instance.pauseMusic();
                    SoundManager.instance.play("063", false, false);
                    this._soundTimer.reset();
                    this._soundTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__soundComplete);
                    this._soundTimer.start();
                };
            }
            else
            {
                if (_local_2 == 1)
                {
                    this._tip.showFail();
                };
            };
        }

        private function __soundComplete(_arg_1:TimerEvent):void
        {
            this._soundTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__soundComplete);
            SoundManager.instance.resumeMusic();
            SoundManager.instance.stop("063");
            SoundManager.instance.stop("064");
        }

        private function appearHoleTips(_arg_1:InventoryItemInfo):void
        {
            SoundManager.instance.play("1001");
        }

        private function showHoleTip(_arg_1:InventoryItemInfo):void
        {
            if (_arg_1.CategoryID == 1)
            {
                if ((((_arg_1.StrengthenLevel == 3) || (_arg_1.StrengthenLevel == 9)) || (_arg_1.StrengthenLevel == 12)))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.hatOpenProperty"));
                };
                if (_arg_1.StrengthenLevel == 6)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.hatOpenDefense"));
                };
            };
            if (_arg_1.CategoryID == 5)
            {
                if ((((_arg_1.StrengthenLevel == 3) || (_arg_1.StrengthenLevel == 9)) || (_arg_1.StrengthenLevel == 12)))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.clothOpenProperty"));
                };
                if (_arg_1.StrengthenLevel == 6)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.clothOpenDefense"));
                };
            };
            if (_arg_1.CategoryID == 7)
            {
                if (_arg_1.StrengthenLevel == 3)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.weaponOpenAttack"));
                };
                if ((((_arg_1.StrengthenLevel == 6) || (_arg_1.StrengthenLevel == 9)) || (_arg_1.StrengthenLevel == 12)))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.states.weaponOpenProperty"));
                };
            };
        }

        private function assetBtnClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            ConsortionModelControl.Instance.alertManagerFrame();
        }

        protected function matteGuideEmbed():void
        {
            this._guideEmbed = ComponentFactory.Instance.creat("asset.ddtstore.TutorialStepAsset");
            this._guideEmbed.gotoAndStop(1);
            LayerManager.Instance.addToLayer(this._guideEmbed, LayerManager.GAME_TOP_LAYER);
        }

        private function embedClickHandler(_arg_1:StoreIIEvent):void
        {
            if (this._guideEmbed)
            {
                this._guideEmbed.gotoAndStop(6);
            };
        }

        private function embedInfoChangeHandler(_arg_1:StoreIIEvent):void
        {
            var _local_2:BaseAlerFrame;
            if (this._guideEmbed)
            {
                this._guideEmbed.gotoAndStop(11);
                _arg_1.stopImmediatePropagation();
                _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("store.states.embedTitle"), LanguageMgr.GetTranslation("tank.view.store.matteTips"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, true, LayerManager.ALPHA_BLOCKGOUND);
                _local_2.info.showCancel = false;
                _local_2.moveEnable = false;
                _local_2.addEventListener(FrameEvent.RESPONSE, this._response);
            };
        }

        private function _response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this._response);
            if ((((((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)) || (_arg_1.responseCode == FrameEvent.CANCEL_CLICK)))
            {
                this.okFunction();
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function okFunction():void
        {
            if (this._guideEmbed)
            {
                ObjectUtils.disposeObject(this._guideEmbed);
            };
            this._guideEmbed = null;
        }

        public function set type(_arg_1:int):void
        {
            this._consortiaManagerBtn.visible = ((PlayerManager.Instance.Self.ConsortiaID != 0) ? true : false);
            this._storeview.changeTabByIndex(_arg_1);
        }

        private function _changeConsortia(_arg_1:Event):void
        {
            this._consortiaManagerBtn.visible = ((PlayerManager.Instance.Self.ConsortiaID != 0) ? true : false);
        }

        public function openHelp():void
        {
            this._storeview.openHelp();
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._storeview)
            {
                ObjectUtils.disposeObject(this._storeview);
            };
            this._storeview = null;
            if (this._tip)
            {
                ObjectUtils.disposeObject(this._tip);
            };
            this._tip = null;
            if (this._consortiaManagerBtn)
            {
                ObjectUtils.disposeObject(this._consortiaManagerBtn);
            };
            this._consortiaManagerBtn = null;
            if (this._consortiaBtnEffect)
            {
                ObjectUtils.disposeObject(this._consortiaBtnEffect);
            };
            this._consortiaBtnEffect = null;
            if (this._guideEmbed)
            {
                ObjectUtils.disposeObject(this._guideEmbed);
            };
            this._guideEmbed = null;
            if (this._storeBag)
            {
                ObjectUtils.disposeObject(this._storeBag);
            };
            this._storeBag = null;
            this._controller = null;
            this._model.currentPanel = StoreMainView.STRENGTH;
            this._model = null;
            this._soundTimer.stop();
            this._soundTimer = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.states

