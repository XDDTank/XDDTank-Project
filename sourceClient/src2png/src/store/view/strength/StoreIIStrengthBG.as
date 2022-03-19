// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.StoreIIStrengthBG

package store.view.strength
{
    import flash.display.Sprite;
    import store.IStoreViewBG;
    import store.StoreDragInArea;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.effect.IEffect;
    import com.pickgliss.ui.image.MutipleImage;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import store.ShowSuccessExp;
    import flash.display.MovieClip;
    import ddt.view.common.BuyItemButton;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.command.QuickBuyFrame;
    import store.StoreCell;
    import ddt.manager.VipPrivilegeConfigManager;
    import ddt.data.VipConfigInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import com.pickgliss.effect.EffectManager;
    import com.pickgliss.effect.EffectTypes;
    import com.pickgliss.effect.EffectColorType;
    import com.pickgliss.utils.ClassUtils;
    import store.events.StoreIIEvent;
    import ddt.data.StoneType;
    import flash.events.Event;
    import ddt.data.EquipType;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import store.data.StoreEquipExperience;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.SocketManager;
    import ddt.data.BagInfo;
    import store.StoneCell;
    import ddt.manager.MessageTipManager;
    import ddt.manager.ItemManager;
    import bagAndInfo.cell.BagCell;
    import flash.utils.Dictionary;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.data.goods.EquipStrengthInfo;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import store.view.ConsortiaRateManager;
    import flash.utils.getTimer;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import flash.display.DisplayObject;
    import store.HelpFrame;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.*;

    public class StoreIIStrengthBG extends Sprite implements IStoreViewBG 
    {

        private var _area:StoreDragInArea;
        private var _items:Array;
        private var _strength_btn:BaseButton;
        private var _strength_btn_shineEffect:IEffect;
        private var _bg:MutipleImage;
        private var _pointArray:Vector.<Point>;
        private var _strthShine:MovieImage;
        private var _startStrthTip:MutipleImage;
        private var _consortiaSmith:MySmithLevel;
        private var _strengthenEquipmentCellText:FilterFrameText;
        private var _isInjectSelect:SelectedCheckButton;
        private var _progressLevel:StoreStrengthProgress;
        private var _lastStrengthTime:int = 0;
        private var _showSuccessExp:ShowSuccessExp;
        private var _starMovie:MovieClip;
        private var _weaponUpgrades:MovieClip;
        private var _weaponUpgradesI:MovieClip;
        private var _sBuyStrengthStoneCell:BuyItemButton;
        private var _vipDiscountTxt:FilterFrameText;
        private var _vipDiscountBg:Image;
        private var _vipDiscountIcon:Image;
        private var _neededGoldTipText:FilterFrameText;
        private var _gold_txt:FilterFrameText;
        private var _goldIcon:Image;
        private var _strengthLevel:FilterFrameText;
        private var _strengthLevelStr:String;
        private var _aler:StrengthSelectNumAlertFrame;
        private var _goldAlertFrame:BaseAlerFrame;
        private var _quickBuyFrame:QuickBuyFrame;

        public function StoreIIStrengthBG()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            var _local_7:StoreCell;
            var _local_1:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(2);
            this._vipDiscountBg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.VipDiscountBg");
            this._vipDiscountTxt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.VipDiscountTxt");
            this._vipDiscountTxt.text = LanguageMgr.GetTranslation("store.Strength.VipDiscountDesc");
            this._vipDiscountIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.VipDiscountIcon");
            addChild(this._vipDiscountBg);
            addChild(this._vipDiscountIcon);
            addChild(this._vipDiscountTxt);
            this._strengthenEquipmentCellText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellText");
            this._strengthenEquipmentCellText.text = LanguageMgr.GetTranslation("store.Strength.StrengthenCurrentEquipmentCellText");
            PositionUtils.setPos(this._strengthenEquipmentCellText, "ddtstore.StoreIIStrengthBG.StrengthenEquipmentCellTextPos");
            addChild(this._strengthenEquipmentCellText);
            this._items = new Array();
            this._area = new StoreDragInArea(this._items);
            addChildAt(this._area, 0);
            this._neededGoldTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.NeededGoldTipText");
            this._neededGoldTipText.text = LanguageMgr.GetTranslation("store.Transfer.NeededGoldTipText");
            addChild(this._neededGoldTipText);
            this._gold_txt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITarnsferBG.NeedMoneyText");
            addChild(this._gold_txt);
            this._goldIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.GoldIcon");
            addChild(this._goldIcon);
            PositionUtils.setPos(this._neededGoldTipText, "asset.ddtstore.strengthMoneyPos1");
            PositionUtils.setPos(this._gold_txt, "asset.ddtstore.strengthMoneyPos2");
            PositionUtils.setPos(this._goldIcon, "asset.ddtstore.strengthMoneyPos3");
            this._strength_btn = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.StrengthenBtn");
            addChild(this._strength_btn);
            this._strength_btn_shineEffect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION, this._strength_btn, {"color":EffectColorType.GOLD});
            this._startStrthTip = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBG.ArrowHeadTip");
            addChild(this._startStrthTip);
            this._isInjectSelect = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrength.isInjectSelect");
            addChild(this._isInjectSelect);
            this._isInjectSelect.selected = true;
            this._strengthLevel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIStrengthBg.strengthLevel");
            this._strengthLevelStr = LanguageMgr.GetTranslation("store.StoreIIComposeBG.strengthLevelText");
            this._strengthLevel.visible = false;
            addChild(this._strengthLevel);
            if ((!(this._weaponUpgradesI)))
            {
                this._weaponUpgradesI = ClassUtils.CreatInstance("asset.strength.weaponUpgradesI");
            };
            PositionUtils.setPos(this._weaponUpgradesI, "ddtstore.StoreIIStrengthBG.weaponUpgradesPointI");
            addChild(this._weaponUpgradesI);
            this._weaponUpgradesI.visible = false;
            this._weaponUpgradesI.stop();
            this._progressLevel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreStrengthProgress");
            this._progressLevel.tipStyle = "ddt.view.tips.OneLineTip";
            this._progressLevel.tipDirctions = "3,7,6";
            this._progressLevel.tipGapV = 4;
            addChild(this._progressLevel);
            this._progressLevel.addEventListener(StoreIIEvent.UPGRADES_PLAY, this.weaponUpgradesPlay);
            this.getCellsPoint();
            var _local_2:int;
            while (_local_2 < this._pointArray.length)
            {
                switch (_local_2)
                {
                    case 0:
                        _local_7 = new StrengthStone([StoneType.STRENGTH, StoneType.STRENGTH_1], _local_2);
                        break;
                    case 1:
                        _local_7 = new StreangthItemCell(_local_2);
                        break;
                };
                _local_7.addEventListener(Event.CHANGE, this.__itemInfoChange);
                this._items[_local_2] = _local_7;
                _local_7.x = this._pointArray[_local_2].x;
                _local_7.y = this._pointArray[_local_2].y;
                addChild(_local_7);
                _local_2++;
            };
            this._sBuyStrengthStoneCell = ComponentFactory.Instance.creat("ddtstore.StoreIIStrengthBG.StoneBuyBtn");
            this._sBuyStrengthStoneCell.setup(EquipType.STRENGTH_STONE_NEW, 1, true);
            this._sBuyStrengthStoneCell.tipData = null;
            this._sBuyStrengthStoneCell.tipStyle = null;
            addChild(this._sBuyStrengthStoneCell);
            this.hide();
            this.hideArr();
            this._showSuccessExp = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.ShowSuccessExp");
            this._showSuccessExp.showVIPRate();
            var _local_3:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.StrengthenStonStripExp");
            var _local_4:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.ConsortiaAddStripExp");
            var _local_5:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.VIPAddStripExp");
            var _local_6:String = LanguageMgr.GetTranslation("store.StoreIIComposeBG.AllNumStrip");
            if (PlayerManager.Instance.Self.ConsortiaID == 0)
            {
                _local_4 = LanguageMgr.GetTranslation("tank.view.store.consortiaRateI");
            };
            if ((!(PlayerManager.Instance.Self.IsVIP)))
            {
                _local_5 = LanguageMgr.GetTranslation("store.StoreIIComposeBG.NoVIPAddStrip");
            };
            this._showSuccessExp.showAllTips(_local_3, _local_4, _local_6);
            this._showSuccessExp.showVIPTip(_local_5);
            addChild(this._showSuccessExp);
        }

        private function initEvent():void
        {
            this._isInjectSelect.addEventListener(MouseEvent.CLICK, this.__isInjectSelectClick);
            this._strength_btn.addEventListener(MouseEvent.CLICK, this.__strengthClick);
        }

        private function removeEvents():void
        {
            this._isInjectSelect.removeEventListener(MouseEvent.CLICK, this.__isInjectSelectClick);
            this._strength_btn.removeEventListener(MouseEvent.CLICK, this.__strengthClick);
            this._items[0].removeEventListener(Event.CHANGE, this.__itemInfoChange);
            this._items[1].removeEventListener(Event.CHANGE, this.__itemInfoChange);
            this._progressLevel.removeEventListener(StoreIIEvent.UPGRADES_PLAY, this.weaponUpgradesPlay);
        }

        private function userGuide():void
        {
        }

        private function exeStoneTip():Boolean
        {
            return (this._items[0].info);
        }

        private function finStoneTip():void
        {
            this.disposeUserGuide();
        }

        private function disposeUserGuide():void
        {
            NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
        }

        private function getCellsPoint():void
        {
            this._pointArray = new Vector.<Point>();
            var _local_1:Point = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.Strengthpoint0");
            this._pointArray.push(_local_1);
            var _local_2:Point = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIStrengthBG.Strengthpoint1");
            this._pointArray.push(_local_2);
        }

        public function get isAutoStrength():Boolean
        {
            return (this._isInjectSelect.selected);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.currentTarget.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        public function get area():Array
        {
            return (this._items);
        }

        private function updateProgress(_arg_1:InventoryItemInfo):void
        {
            if (_arg_1)
            {
                if (StoreEquipExperience.expericence)
                {
                    this._progressLevel.setProgress(_arg_1);
                };
            };
        }

        private function isAdaptToItem(_arg_1:InventoryItemInfo):Boolean
        {
            if (this._items[1].info == null)
            {
                return (true);
            };
            if (this._items[1].info.RefineryLevel > 0)
            {
                if (_arg_1.Property1 == "35")
                {
                    return (true);
                };
                return (false);
            };
            if (_arg_1.Property1 == "35")
            {
                return (false);
            };
            return (true);
        }

        private function isAdaptToStone(_arg_1:InventoryItemInfo):Boolean
        {
            if (((!(this._items[0].info == null)) && (!(this._items[0].info.Property1 == _arg_1.Property1))))
            {
                return (false);
            };
            return (true);
        }

        private function itemIsAdaptToStone(_arg_1:InventoryItemInfo):Boolean
        {
            if (_arg_1.RefineryLevel > 0)
            {
                if (((!(this._items[0].info == null)) && (!(this._items[0].info.Property1 == "35"))))
                {
                    return (false);
                };
                return (true);
            };
            if (((!(this._items[0].info == null)) && (this._items[0].info.Property1 == "35")))
            {
                return (false);
            };
            return (true);
        }

        private function showNumAlert(_arg_1:InventoryItemInfo, _arg_2:int):void
        {
            this._aler = ComponentFactory.Instance.creat("ddtstore.StrengthSelectNumAlertFrame");
            this._aler.addExeFunction(this.sellFunction, this.notSellFunction);
            this._aler.goodsinfo = _arg_1;
            this._aler.index = _arg_2;
            this._aler.show(_arg_1.Count);
        }

        private function sellFunction(_arg_1:int, _arg_2:InventoryItemInfo, _arg_3:int):void
        {
            SocketManager.Instance.out.sendMoveGoods(_arg_2.BagType, _arg_2.Place, BagInfo.STOREBAG, _arg_3, _arg_1, true);
            if (this._aler)
            {
                this._aler.dispose();
            };
            if (((this._aler) && (this._aler.parent)))
            {
                removeChild(this._aler);
            };
            this._aler = null;
        }

        private function notSellFunction():void
        {
            if (this._aler)
            {
                this._aler.dispose();
            };
            if (((this._aler) && (this._aler.parent)))
            {
                removeChild(this._aler);
            };
            this._aler = null;
        }

        public function setCell(_arg_1:BagCell):void
        {
            var _local_3:StoreCell;
            if (_arg_1 == null)
            {
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.info as InventoryItemInfo);
            for each (_local_3 in this._items)
            {
                if (_local_3.info == _local_2)
                {
                    _local_3.info = null;
                    _arg_1.locked = false;
                    return;
                };
            };
            for each (_local_3 in this._items)
            {
                if (_local_3)
                {
                    if ((_local_3 is StoneCell))
                    {
                        if (_local_3.info == null)
                        {
                            if ((((_local_3 as StoneCell).types.indexOf(_local_2.Property1) > -1) && (_local_2.CategoryID == 11)))
                            {
                                if (this.isAdaptToStone(_local_2))
                                {
                                    if (_local_2.Count == 1)
                                    {
                                        SocketManager.Instance.out.sendMoveGoods(_local_2.BagType, _local_2.Place, BagInfo.STOREBAG, _local_3.index, 1, true);
                                    }
                                    else
                                    {
                                        this.showNumAlert(_local_2, _local_3.index);
                                    };
                                    return;
                                };
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                            };
                        };
                    }
                    else
                    {
                        if ((_local_3 is StreangthItemCell))
                        {
                            if (_local_2.getRemainDate() <= 0)
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                            }
                            else
                            {
                                if (((_arg_1.info.CanStrengthen) && (_local_2.StrengthenLevel >= ItemManager.Instance.getEquipLimitLevel(_local_2.TemplateID))))
                                {
                                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
                                    return;
                                };
                                if (_arg_1.info.CanStrengthen)
                                {
                                    SocketManager.Instance.out.sendMoveGoods(_local_2.BagType, _local_2.Place, BagInfo.STOREBAG, _local_3.index, 1);
                                    StreangthItemCell(this._items[1]).actionState = true;
                                    return;
                                };
                            };
                        };
                    };
                };
            };
            if (EquipType.isStrengthStone(_local_2))
            {
                for each (_local_3 in this._items)
                {
                    if ((((_local_3 is StoneCell) && ((_local_3 as StoneCell).types.indexOf(_local_2.Property1) > -1)) && (_local_2.CategoryID == 11)))
                    {
                        if (this.isAdaptToStone(_local_2))
                        {
                            if (_local_2.Count == 1)
                            {
                                SocketManager.Instance.out.sendMoveGoods(_local_2.BagType, _local_2.Place, BagInfo.STOREBAG, _local_3.index, 1, true);
                            }
                            else
                            {
                                this.showNumAlert(_local_2, _local_3.index);
                            };
                            return;
                        };
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                    };
                };
            };
        }

        private function _responseII(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this._responseII);
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        private function showArr():void
        {
            this._startStrthTip.visible = true;
            this._strength_btn_shineEffect.play();
        }

        private function hideArr():void
        {
            this._startStrthTip.visible = false;
            this._strength_btn_shineEffect.stop();
        }

        public function refreshData(_arg_1:Dictionary):void
        {
            var _local_2:String;
            var _local_3:int;
            for (_local_2 in _arg_1)
            {
                _local_3 = int(_local_2);
                if (this._items.hasOwnProperty(_local_3))
                {
                    this._items[_local_3].info = PlayerManager.Instance.Self.StoreBag.items[_local_3];
                };
            };
        }

        public function updateData():void
        {
            if (PlayerManager.Instance.Self.StoreBag.items[1])
            {
                if ((((!(this._items[1].info.ItemID == PlayerManager.Instance.Self.StoreBag.items[1].ItemID)) || (!(this._items[1].info.StrengthenExp == PlayerManager.Instance.Self.StoreBag.items[1].StrengthenExp))) || (!(this._items[1].info.StrengthenLevel == PlayerManager.Instance.Self.StoreBag.items[1].StrengthenLevel))))
                {
                    this._items[1].info = PlayerManager.Instance.Self.StoreBag.items[1];
                };
            }
            else
            {
                this._items[1].info = null;
            };
            var _local_1:InventoryItemInfo = PlayerManager.Instance.Self.Bag.findItemsByTempleteID(EquipType.STRENGTH_STONE_NEW)[0];
            if (_local_1)
            {
                this._items[0].info = _local_1;
                this._items[0].setCount(PlayerManager.Instance.Self.findItemCount(EquipType.STRENGTH_STONE_NEW));
            }
            else
            {
                this._items[0].info = null;
            };
        }

        public function startShine(_arg_1:int):void
        {
            if (_arg_1 < 2)
            {
                this._items[_arg_1].startShine();
            };
        }

        public function stopShine():void
        {
            this._items[0].stopShine();
            this._items[1].stopShine();
        }

        public function show():void
        {
            this.visible = true;
            this.updateData();
            this.userGuide();
        }

        public function hide():void
        {
            this.visible = false;
            this.disposeUserGuide();
        }

        private function __isInjectSelectClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.updateGoldText();
        }

        private function updateGoldText():void
        {
            var _local_1:InventoryItemInfo;
            var _local_2:EquipmentTemplateInfo;
            var _local_3:EquipStrengthInfo;
            var _local_4:VipConfigInfo;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Number;
            var _local_8:int;
            var _local_9:int;
            if (((StreangthItemCell(this._items[1]).info) && (StrengthStone(this._items[0]).info)))
            {
                _local_1 = (StreangthItemCell(this._items[1]).info as InventoryItemInfo);
                _local_2 = ItemManager.Instance.getEquipTemplateById(_local_1.TemplateID);
                if (_local_1.StrengthenLevel == _local_2.StrengthLimit)
                {
                    this._gold_txt.text = "0";
                    return;
                };
                _local_3 = ItemManager.Instance.getEquipStrengthInfoByLevel((_local_1.StrengthenLevel + 1), _local_2.QualityID);
                _local_4 = VipPrivilegeConfigManager.Instance.getById(2);
                _local_5 = int(StrengthStone(this._items[0]).info.Property2);
                if (PlayerManager.Instance.Self.IsVIP)
                {
                    _local_6 = int(((_local_5 * _local_4[("Level" + PlayerManager.Instance.Self.VIPLevel)]) / 100));
                };
                if (PlayerManager.Instance.Self.IsVIP)
                {
                    _local_7 = (_local_5 + _local_6);
                }
                else
                {
                    _local_7 = _local_5;
                };
                _local_8 = int(((_local_3.Exp - _local_1.StrengthenExp) / _local_7));
                if (((_local_3.Exp - _local_1.StrengthenExp) % _local_7) > 0)
                {
                    _local_8 = (_local_8 + 1);
                };
                _local_9 = 100;
                if (((this._isInjectSelect.selected) && (this._items[0].info)))
                {
                    if (_local_8 < StrengthStone(this._items[0]).itemInfo.Count)
                    {
                        this._gold_txt.text = (_local_9 * _local_8).toString();
                    }
                    else
                    {
                        this._gold_txt.text = (_local_9 * StrengthStone(this._items[0]).itemInfo.Count).toString();
                    };
                }
                else
                {
                    this._gold_txt.text = _local_9.toString();
                };
            }
            else
            {
                this._gold_txt.text = "0";
            };
        }

        private function __strengthClick(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            var _local_3:BaseAlerFrame;
            _arg_1.stopImmediatePropagation();
            NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
            SoundManager.instance.play("008");
            if (this._showDontClickTip())
            {
                return;
            };
            if (this._items[1].info != null)
            {
                if (this._items[1].info.StrengthenLevel >= ItemManager.Instance.getEquipLimitLevel(this._items[1].info.TemplateID))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
                    return;
                };
            };
            if (this.checkTipBindType())
            {
                _local_3 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("store.StoreIIStrengthBG.use"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                _local_3.moveEnable = false;
                _local_3.info.enableHtml = true;
                _local_3.info.mutiline = true;
                _local_3.addEventListener(FrameEvent.RESPONSE, this._bingResponse);
            }
            else
            {
                if ((!(this._progressLevel.getStarVisible())))
                {
                    this.sendSocket();
                };
            };
        }

        private function _responseV(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            (_arg_1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this._responseV);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.okFastPurchaseGold();
            };
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        private function okFastPurchaseGold():void
        {
            var _local_1:QuickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
            _local_1.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _local_1.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_local_1, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function _bingResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this._bingResponse);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this.sendSocket();
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function sendSocket():void
        {
            if ((!(this.checkLevel())))
            {
                return;
            };
            if (PlayerManager.Instance.Self.Gold < int(this._gold_txt.text))
            {
                this._goldAlertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.GoldInadequate"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                this._goldAlertFrame.moveEnable = false;
                this._goldAlertFrame.addEventListener(FrameEvent.RESPONSE, this.__quickBuyResponse);
                return;
            };
            var _local_1:Boolean;
            var _local_2:int = ConsortiaRateManager.instance.rate;
            if (((!(PlayerManager.Instance.Self.ConsortiaID == 0)) && (_local_2 > 0)))
            {
                _local_1 = true;
            };
            var _local_3:int = getTimer();
            if ((_local_3 - this._lastStrengthTime) > 1200)
            {
                SocketManager.Instance.out.sendItemStrength(_local_1, this._isInjectSelect.selected);
                this._lastStrengthTime = _local_3;
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.storeIIStrength.startStrengthClickTimerMsg"));
            };
        }

        private function __quickBuyResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            this._goldAlertFrame.removeEventListener(FrameEvent.RESPONSE, this.__quickBuyResponse);
            this._goldAlertFrame.dispose();
            this._goldAlertFrame = null;
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                this._quickBuyFrame = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                this._quickBuyFrame.itemID = EquipType.GOLD_BOX;
                this._quickBuyFrame.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                LayerManager.Instance.addToLayer(this._quickBuyFrame, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            };
        }

        private function checkTipBindType():Boolean
        {
            if (((this._items[1].itemInfo) && (this._items[1].itemInfo.IsBinds)))
            {
                return (false);
            };
            if (((this._items[0].itemInfo) && (this._items[0].itemInfo.IsBinds)))
            {
                return (true);
            };
            return (false);
        }

        private function checkLevel():Boolean
        {
            var _local_1:StreangthItemCell = (this._items[1] as StreangthItemCell);
            var _local_2:InventoryItemInfo = (_local_1.info as InventoryItemInfo);
            if (_local_2.StrengthenLevel >= ItemManager.Instance.getEquipLimitLevel(_local_2.TemplateID))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.StrengthItemCell.up"));
                return (false);
            };
            return (true);
        }

        private function __itemInfoChange(_arg_1:Event):void
        {
            var _local_2:StreangthItemCell;
            var _local_3:InventoryItemInfo;
            this.updateGoldText();
            if ((_arg_1.currentTarget is StreangthItemCell))
            {
                _local_2 = (_arg_1.currentTarget as StreangthItemCell);
                _local_3 = (_local_2.info as InventoryItemInfo);
                if (_local_3)
                {
                    if (StreangthItemCell(this._items[1]).actionState)
                    {
                        this._progressLevel.initProgress(_local_3);
                        StreangthItemCell(this._items[1]).actionState = false;
                        if (this._starMovie)
                        {
                            this.removeStarMovie();
                        };
                        if (this._weaponUpgrades)
                        {
                            this.removeWeaponUpgradesMovie();
                        };
                    }
                    else
                    {
                        this.updateProgress(_local_3);
                    };
                    this._strengthLevel.visible = true;
                    this._strengthLevel.text = (this._strengthLevelStr + _local_3._StrengthenLevel.toString());
                    if ((((SavePointManager.Instance.isInSavePoint(9)) && (!(TaskManager.instance.isNewHandTaskCompleted(7)))) || ((SavePointManager.Instance.isInSavePoint(16)) && (!(TaskManager.instance.isNewHandTaskCompleted(12))))))
                    {
                        dispatchEvent(new StoreIIEvent(StoreIIEvent.WEAPON_READY));
                    }
                    else
                    {
                        NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
                        NewHandContainer.Instance.clearArrowByID(ArrowType.STRENG_CHOOSE_WEAPON);
                    };
                }
                else
                {
                    if ((((SavePointManager.Instance.isInSavePoint(9)) && (!(TaskManager.instance.isNewHandTaskCompleted(7)))) || ((SavePointManager.Instance.isInSavePoint(16)) && (!(TaskManager.instance.isNewHandTaskCompleted(12))))))
                    {
                        dispatchEvent(new StoreIIEvent(StoreIIEvent.WEAPON_REMOVE));
                    };
                    this._gold_txt.text = "0";
                    this._progressLevel.resetProgress();
                    this._strengthLevel.visible = false;
                };
                dispatchEvent(new Event(Event.CHANGE));
            };
            this.getCountExpI();
            if (this._items[0].info == null)
            {
                this._items[0].stoneType = (this._items[1].stoneType = "");
            };
            if (this._items[1].info == null)
            {
                this._items[0].itemType = -1;
            }
            else
            {
                this._items[0].itemType = this._items[1].info.RefineryLevel;
            };
            if ((((this._items[1].info == null) || (this._items[0].info == null)) || (this._items[1].itemInfo.StrengthenLevel >= 9)))
            {
                this.hideArr();
                return;
            };
        }

        private function _showDontClickTip():Boolean
        {
            if (this._items[1].info == null)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.strength.dontStrengthI"));
                return (true);
            };
            if (this._items[0].info == null)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.strength.dontStrengthII"));
                return (true);
            };
            return (false);
        }

        private function getCountExpI():void
        {
            var _local_1:Number = 0;
            var _local_2:Number = 0;
            var _local_3:Number = 0;
            var _local_4:Number = 0;
            var _local_5:VipConfigInfo = VipPrivilegeConfigManager.Instance.getById(2);
            if (this._items[0].info != null)
            {
                _local_1 = (_local_1 + this._items[0].info.Property2);
            };
            if (((ConsortiaRateManager.instance.rate > 0) && (!(this._items[0].info == null))))
            {
                _local_2 = ((ConsortiaRateManager.instance.getConsortiaStrengthenEx(PlayerManager.Instance.Self.consortiaInfo.SmithLevel) / 100) * _local_1);
            };
            if (((PlayerManager.Instance.Self.IsVIP) && (!(this._items[0].info == null))))
            {
                _local_4 = ((_local_1 * _local_5[("Level" + PlayerManager.Instance.Self.VIPLevel)]) / 100);
            };
            _local_3 = (_local_1 + _local_4);
            this._showSuccessExp.showAllNum(_local_1, _local_2, _local_4, _local_3);
        }

        public function getStrengthItemCellInfo():InventoryItemInfo
        {
            return ((this._items[1] as StreangthItemCell).itemInfo);
        }

        public function openHelp():void
        {
            var _local_1:DisplayObject = ComponentFactory.Instance.creat("ddtstore.StrengthHelpPrompt");
            var _local_2:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
            _local_2.setView(_local_1);
            _local_2.titleText = LanguageMgr.GetTranslation("store.StoreIIStrengthBG.say");
            LayerManager.Instance.addToLayer(_local_2, LayerManager.STAGE_DYANMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        public function starMoviePlay():void
        {
            if (this.isAutoStrength)
            {
                return;
            };
            if ((!(this._starMovie)))
            {
                this._starMovie = ClassUtils.CreatInstance("accet.strength.starMovie");
            };
            this._starMovie.gotoAndPlay(1);
            this._starMovie.addEventListener(Event.ENTER_FRAME, this.__starMovieFrame);
            PositionUtils.setPos(this._starMovie, "ddtstore.StoreIIStrengthBG.starMoviePoint");
            addChild(this._starMovie);
        }

        private function __starMovieFrame(_arg_1:Event):void
        {
            if (this._starMovie)
            {
                if (this._starMovie.currentFrame == this._starMovie.totalFrames)
                {
                    this.removeStarMovie();
                };
            };
        }

        private function removeStarMovie():void
        {
            if (this._starMovie.hasEventListener(Event.ENTER_FRAME))
            {
                this._starMovie.removeEventListener(Event.ENTER_FRAME, this.__starMovieFrame);
            };
            if (this.contains(this._starMovie))
            {
                this.removeChild(this._starMovie);
            };
        }

        private function weaponUpgradesPlay(_arg_1:Event):void
        {
            this._weaponUpgradesI.visible = true;
            this._weaponUpgradesI.gotoAndPlay(1);
            this._weaponUpgradesI.addEventListener(Event.ENTER_FRAME, this.__weaponUpgradesFrameI);
            if ((!(this._weaponUpgrades)))
            {
                this._weaponUpgrades = ClassUtils.CreatInstance("asset.strength.weaponUpgrades");
            };
            this._weaponUpgrades.gotoAndPlay(1);
            this._weaponUpgrades.addEventListener(Event.ENTER_FRAME, this.__weaponUpgradesFrame);
            PositionUtils.setPos(this._weaponUpgrades, "ddtstore.StoreIIStrengthBG.weaponUpgradesPoint");
            addChild(this._weaponUpgrades);
            this.dispatchEvent(new Event(StoreIIEvent.UPGRADES_PLAY));
        }

        private function __weaponUpgradesFrame(_arg_1:Event):void
        {
            if (this._weaponUpgrades)
            {
                if (this._weaponUpgrades.currentFrame == this._weaponUpgrades.totalFrames)
                {
                    this.removeWeaponUpgradesMovie();
                };
            };
        }

        private function __weaponUpgradesFrameI(_arg_1:Event):void
        {
            if (this._weaponUpgradesI)
            {
                if (this._weaponUpgradesI.currentFrame == this._weaponUpgradesI.totalFrames)
                {
                    this.removeWeaponUpgradesMovie();
                };
            };
        }

        private function removeWeaponUpgradesMovie():void
        {
            if (this._weaponUpgrades.hasEventListener(Event.ENTER_FRAME))
            {
                this._weaponUpgrades.removeEventListener(Event.ENTER_FRAME, this.__weaponUpgradesFrame);
            };
            if (this.contains(this._weaponUpgrades))
            {
                this.removeChild(this._weaponUpgrades);
            };
            if (this._weaponUpgrades)
            {
                this._weaponUpgrades.stop();
                ObjectUtils.disposeObject(this._weaponUpgrades);
                this._weaponUpgrades = null;
            };
            this._weaponUpgradesI.visible = false;
            this._weaponUpgradesI.stop();
        }

        public function dispose():void
        {
            var _local_1:Disposeable;
            this.removeEvents();
            this.disposeUserGuide();
            if (this._area)
            {
                ObjectUtils.disposeObject(this._area);
            };
            this._area = null;
            for each (_local_1 in this._items)
            {
                _local_1.dispose();
            };
            this._items.length = 0;
            this._items = null;
            EffectManager.Instance.removeEffect(this._strength_btn_shineEffect);
            this._strength_btn_shineEffect = null;
            ObjectUtils.disposeObject(this._strengthenEquipmentCellText);
            this._strengthenEquipmentCellText = null;
            this._pointArray.length = 0;
            this._pointArray = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._strength_btn)
            {
                ObjectUtils.disposeObject(this._strength_btn);
            };
            this._strength_btn = null;
            if (this._strthShine)
            {
                ObjectUtils.disposeObject(this._strthShine);
            };
            this._strthShine = null;
            if (this._startStrthTip)
            {
                ObjectUtils.disposeObject(this._startStrthTip);
            };
            this._startStrthTip = null;
            if (this._showSuccessExp)
            {
                ObjectUtils.disposeObject(this._showSuccessExp);
            };
            this._showSuccessExp = null;
            if (this._consortiaSmith)
            {
                ObjectUtils.disposeObject(this._consortiaSmith);
            };
            this._consortiaSmith = null;
            if (this._gold_txt)
            {
                ObjectUtils.disposeObject(this._gold_txt);
            };
            this._gold_txt = null;
            if (this._progressLevel)
            {
                ObjectUtils.disposeObject(this._progressLevel);
            };
            this._progressLevel = null;
            if (this._isInjectSelect)
            {
                ObjectUtils.disposeObject(this._isInjectSelect);
            };
            this._isInjectSelect = null;
            if (this._aler)
            {
                ObjectUtils.disposeObject(this._aler);
            };
            this._aler = null;
            ObjectUtils.disposeObject(this._vipDiscountBg);
            this._vipDiscountBg = null;
            ObjectUtils.disposeObject(this._vipDiscountIcon);
            this._vipDiscountIcon = null;
            ObjectUtils.disposeObject(this._vipDiscountTxt);
            this._vipDiscountTxt = null;
            if (this._goldIcon)
            {
                ObjectUtils.disposeObject(this._goldIcon);
            };
            this._goldIcon = null;
            if (this._neededGoldTipText)
            {
                ObjectUtils.disposeObject(this._neededGoldTipText);
            };
            this._neededGoldTipText = null;
            if (this._strengthLevel)
            {
                ObjectUtils.disposeObject(this._strengthLevel);
            };
            this._strengthLevel = null;
            if (this._starMovie)
            {
                if (this._starMovie.hasEventListener(Event.ENTER_FRAME))
                {
                    this._starMovie.removeEventListener(Event.ENTER_FRAME, this.__starMovieFrame);
                };
                ObjectUtils.disposeObject(this._starMovie);
                this._starMovie = null;
            };
            if (this._weaponUpgrades)
            {
                if (this._weaponUpgrades.hasEventListener(Event.ENTER_FRAME))
                {
                    this._weaponUpgrades.removeEventListener(Event.ENTER_FRAME, this.__weaponUpgradesFrame);
                };
                ObjectUtils.disposeObject(this._weaponUpgrades);
                this._weaponUpgrades = null;
            };
            if (this._weaponUpgradesI)
            {
                if (this._weaponUpgradesI.hasEventListener(Event.ENTER_FRAME))
                {
                    this._weaponUpgradesI.removeEventListener(Event.ENTER_FRAME, this.__weaponUpgradesFrameI);
                };
                ObjectUtils.disposeObject(this._weaponUpgradesI);
                this._weaponUpgradesI = null;
            };
            if (this._sBuyStrengthStoneCell)
            {
                ObjectUtils.disposeObject(this._sBuyStrengthStoneCell);
            };
            this._sBuyStrengthStoneCell = null;
            if (this._goldAlertFrame)
            {
                ObjectUtils.disposeObject(this._goldAlertFrame);
            };
            this._goldAlertFrame = null;
            if (this._quickBuyFrame)
            {
                ObjectUtils.disposeObject(this._quickBuyFrame);
            };
            this._quickBuyFrame = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.strength

