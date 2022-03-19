// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopLeftView

package shop.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import shop.ShopController;
    import shop.ShopModel;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.view.character.CharactoryFactory;
    import ddt.view.character.RoomCharacter;
    import ddt.utils.PositionUtils;
    import ddt.data.goods.ShopCarItemInfo;
    import shop.ShopEvent;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import ddt.data.EquipType;
    import ddt.data.player.PlayerInfo;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.SavePointManager;
    import ddt.view.ColorEditor;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.LayerManager;
    import flash.utils.getTimer;
    import ddt.manager.ShopManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.data.goods.InventoryItemInfo;

    public class ShopLeftView extends Sprite implements Disposeable 
    {

        public static const SHOW_CART:uint = 1;
        public static const SHOW_COLOR:uint = 1;
        public static const SHOW_DRESS:uint = 0;
        public static const SHOW_WEALTH:uint = 0;
        public static const COLOR:uint = 1;
        public static const SKIN:uint = 2;
        private static const MALE:uint = 1;
        private static const FEMALE:uint = 2;

        private var _controller:ShopController;
        private var _model:ShopModel;
        private var prop:ShopLeftViewPropCollection;
        private var _isUsed:Boolean = false;
        private var latestRandom:int = 0;
        private var _isVisible:Boolean = false;

        public function ShopLeftView()
        {
            this.prop = new ShopLeftViewPropCollection();
            this.prop.setup();
            this.prop.addChildrenTo(this);
        }

        public function adjustBottomView(_arg_1:uint):void
        {
            var _local_2:ShopPlayerCell;
            this.prop.middlePanelBg.setFrame((_arg_1 + 1));
            this.prop.panelBtnGroup.selectIndex = _arg_1;
            if (_arg_1 == SHOW_WEALTH)
            {
                this._isVisible = false;
                this.prop.purchaseView.visible = true;
                this.prop.colorEditor.visible = false;
                for each (_local_2 in this.prop.playerCells)
                {
                    _local_2.hideLight();
                };
            };
            if (_arg_1 == SHOW_COLOR)
            {
                this._isVisible = true;
                this.prop.purchaseView.visible = false;
                this.prop.colorEditor.visible = true;
                this.__updateColorEditor();
                this.showShine();
            };
        }

        public function getColorEditorVisble():Boolean
        {
            return (this.prop.colorEditor.visible);
        }

        public function adjustUpperView(_arg_1:uint):void
        {
            if (_arg_1 == SHOW_DRESS)
            {
                if (this.prop.middlePanelBg.getFrame == (SHOW_WEALTH + 1))
                {
                    this.prop.purchaseView.visible = true;
                };
                this.prop.dressView.visible = true;
                this.prop.cartScroll.visible = false;
            };
            if (_arg_1 == SHOW_CART)
            {
                ObjectUtils.modifyVisibility(true, this.prop.cartScroll);
                ObjectUtils.modifyVisibility(false, this.prop.dressView);
                this.adjustBottomView(SHOW_WEALTH);
            };
        }

        public function refreshCharater():void
        {
            if ((!(this.prop.maleCharacter)))
            {
                this.prop.maleCharacter = (CharactoryFactory.createCharacter(this._model.manModelInfo, "room") as RoomCharacter);
                this.prop.maleCharacter.show(false, -1);
                this.prop.maleCharacter.showGun = false;
                this.prop.maleCharacter.LightVible = false;
                PositionUtils.setPos(this.prop.maleCharacter, "ddtshop.PlayerCharacterPos");
                this.prop.dressView.addChild(this.prop.maleCharacter);
            };
            if ((!(this.prop.femaleCharacter)))
            {
                this.prop.femaleCharacter = (CharactoryFactory.createCharacter(this._model.womanModelInfo, "room") as RoomCharacter);
                this.prop.femaleCharacter.show(false, -1);
                this.prop.femaleCharacter.showGun = false;
                this.prop.femaleCharacter.LightVible = false;
                PositionUtils.setPos(this.prop.femaleCharacter, "ddtshop.PlayerCharacterPos");
                this.prop.dressView.addChild(this.prop.femaleCharacter);
            };
            this.__fittingSexChanged();
        }

        public function setup(_arg_1:ShopController, _arg_2:ShopModel):void
        {
            this._controller = _arg_1;
            this._model = _arg_2;
            this.initEvent();
            this.refreshCharater();
        }

        private function __addCarEquip(_arg_1:ShopEvent):void
        {
            this.addCarEquip((_arg_1.param as ShopCarItemInfo));
        }

        private function __clearClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._controller.revertToDefault();
        }

        private function __clearLastClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._model.removeLatestItem();
            this.clearHighLight();
            this.__fittingSexChanged();
        }

        private function clearHighLight():void
        {
            var _local_1:ShopPlayerCell;
            for each (_local_1 in this.prop.playerCells)
            {
                _local_1.hideLight();
            };
        }

        private function __conditionChange(_arg_1:Event):void
        {
            this._controller.updateCost();
        }

        private function __deleteItem(_arg_1:Event):void
        {
            var _local_2:ShopCartItem = (_arg_1.currentTarget as ShopCartItem);
            this._controller.removeFromCar((_local_2.shopItemInfo as ShopCarItemInfo));
            if (this.prop.cartList.contains(_local_2))
            {
                this.prop.cartList.removeChild(_local_2);
            };
        }

        private function __addTempEquip(_arg_1:ShopEvent):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_2:ShopCarItemInfo = (_arg_1.param as ShopCarItemInfo);
            if (EquipType.isProp(_local_2.TemplateInfo))
            {
                return;
            };
            if (((EquipType.dressAble(_local_2.TemplateInfo)) && (!(_local_2.CategoryID == EquipType.CHATBALL))))
            {
                _local_3 = EquipType.CategeryIdToPlace(_local_2.CategoryID)[0];
                _local_4 = this._model.getBagItems(_local_3, true);
                this.prop.playerCells[_local_4].shopItemInfo = _local_2;
                _local_2.place = _local_3;
                this._model.currentModel.setPartStyle(_local_2.TemplateInfo, _local_2.TemplateInfo.NeedSex, _local_2.TemplateID, _local_2.Color);
            };
            this.__updateCar(_arg_1);
            this.updateButtons();
            this.prop.lastItem.shopItemInfo = _local_2;
            this.__updateColorEditor();
            if ((!(this.prop.panelBtnGroup.selectIndex == 1)))
            {
                if (_local_2.TemplateInfo.NeedSex == MALE)
                {
                    this.prop.addedManNewEquip++;
                }
                else
                {
                    if (_local_2.TemplateInfo.NeedSex == FEMALE)
                    {
                        this.prop.addedWomanNewEquip++;
                    };
                };
            };
        }

        private function __fittingSexChanged(_arg_1:ShopEvent=null):void
        {
            var _local_3:ShopCarItemInfo;
            var _local_4:Array;
            var _local_5:int;
            var _local_6:ShopEvent;
            this.prop.femaleCharacter.visible = ((this._model.fittingSex) ? false : true);
            this.prop.maleCharacter.visible = ((this._model.fittingSex) ? true : false);
            this.prop.muteLock = true;
            this.prop.cbHideGlasses.selected = this._model.currentModel.getGlassHide();
            this.prop.cbHideHat.selected = this._model.currentModel.getHatHide();
            this.prop.cbHideSuit.selected = this._model.currentModel.getSuitesHide();
            this.prop.cbHideWings.selected = this._model.currentModel.wingHide;
            this.prop.muteLock = false;
            var _local_2:int;
            while (_local_2 < this.prop.playerCells.length)
            {
                _local_5 = this._model.getBagItems(_local_2);
                if (this._model.currentModel.Bag.items[_local_5])
                {
                    this.prop.playerCells[_local_2].info = this._model.currentModel.Bag.items[_local_5];
                    this.prop.playerCells[_local_2].locked = true;
                }
                else
                {
                    this.prop.playerCells[_local_2].shopItemInfo = null;
                };
                _local_2++;
            };
            for each (_local_3 in this._model.currentTempList)
            {
                _local_6 = new ShopEvent("shop", _local_3);
                this.__addTempEquip(_local_6);
            };
            this.updateButtons();
            _local_4 = this._model.currentTempList;
            if (_local_4.length > 0)
            {
                this.prop.lastItem.shopItemInfo = _local_4[(_local_4.length - 1)];
            }
            else
            {
                this.prop.lastItem.shopItemInfo = null;
            };
        }

        private function __hideGlassChange(_arg_1:Event):void
        {
            this._model.currentModel.setGlassHide(this.prop.cbHideGlasses.selected);
        }

        private function __hideHatChange(_arg_1:Event):void
        {
            this._model.currentModel.setHatHide(this.prop.cbHideHat.selected);
        }

        private function __hideSuitesChange(_arg_1:Event):void
        {
            this._model.currentModel.setSuiteHide(this.prop.cbHideSuit.selected);
        }

        private function __hideWingClickHandler(_arg_1:Event):void
        {
            this._model.currentModel.wingHide = this.prop.cbHideWings.selected;
        }

        private function __originClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._controller.restoreAllItemsOnBody();
        }

        private function __panelBtnClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.adjustBottomView(this.prop.panelBtnGroup.selectIndex);
            this.__update(null);
        }

        private function __propertyChange(_arg_1:PlayerPropertyEvent):void
        {
            if ((((_arg_1.changedProperties[PlayerInfo.MONEY]) || (_arg_1.changedProperties[PlayerInfo.DDT_MONEY])) || (_arg_1.changedProperties[PlayerInfo.MEDAL])))
            {
                this.prop.playerMoneyView.setInfo(this._model.Self);
                this.prop.playerGiftView.setInfo(this._model.Self);
            };
        }

        private function __removeCarEquip(_arg_1:ShopEvent):void
        {
            var _local_3:ShopCartItem;
            var _local_2:ShopCarItemInfo = (_arg_1.param as ShopCarItemInfo);
            var _local_4:uint;
            while (this.prop.cartList.numChildren > 0)
            {
                _local_3 = (this.prop.cartList.getChildAt(_local_4) as ShopCartItem);
                if (_local_3.shopItemInfo == _local_2) break;
                _local_4++;
            };
            if (_local_3)
            {
                _local_3.removeEventListener(ShopCartItem.DELETE_ITEM, this.__deleteItem);
                this.prop.cartList.removeChild(_local_3);
            };
            this.prop.cartScroll.invalidateViewport();
        }

        private function __selectedColorChanged(_arg_1:*):void
        {
            var _local_2:Object = new Object();
            if (this.prop.colorEditor.selectedType == COLOR)
            {
                this.setColorLayer(this.prop.colorEditor.selectedColor);
                _local_2.color = this.prop.colorEditor.selectedColor;
            }
            else
            {
                this.setSkinColor(String(this.prop.colorEditor.selectedSkin));
                _local_2.color = this.prop.colorEditor.selectedSkin;
            };
            _local_2.item = this.prop.lastItem.shopItemInfo;
            _local_2.type = this.prop.colorEditor.selectedType;
            dispatchEvent(new ShopEvent(ShopEvent.COLOR_SELECTED, _local_2));
        }

        private function __topBtnClick(_arg_1:MouseEvent=null):void
        {
            SoundManager.instance.play("008");
        }

        private function __update(_arg_1:ShopEvent):void
        {
            this.prop.leftMoneyPanelBuyBtn.enable = (this._model.allItemsCount > 0);
            this.prop.purchaseBtn.enable = (this._model.allItemsCount > 0);
            if (this.prop.purchaseBtn.enable)
            {
                this.prop.purchaseEffet.play();
            }
            else
            {
                this.prop.purchaseEffet.stop();
            };
            if ((!(SavePointManager.Instance.savePoints[15])))
            {
                this.prop.presentBtn.enable = false;
            }
            else
            {
                this.prop.presentBtn.enable = (this._model.allItemsCount > 0);
                if (this.prop.presentBtn.enable)
                {
                    this.prop.presentEffet.play();
                }
                else
                {
                    this.prop.presentEffet.stop();
                };
            };
        }

        private function __updateColorEditor(_arg_1:ShopEvent=null):void
        {
            this.prop.colorEditor.skinEditable = false;
            if (this._model.canChangSkin())
            {
                this.prop.colorEditor.selectedType = SKIN;
                if (((this.prop.lastItem.shopItemInfo) && (this.prop.lastItem.shopItemInfo.CategoryID == EquipType.FACE)))
                {
                    this.prop.colorEditor.skinEditable = true;
                };
                this.setSkinColor(this._model.currentSkin);
                this.prop.colorEditor.editSkin(this.prop.colorEditor.selectedSkin);
            }
            else
            {
                this.prop.colorEditor.skinEditable = false;
                this.prop.colorEditor.resetSkin();
            };
            if (((this.prop.lastItem.shopItemInfo) && (EquipType.isEditable(this.prop.lastItem.shopItemInfo.TemplateInfo))))
            {
                this.prop.colorEditor.selectedType = COLOR;
                this.prop.colorEditor.colorEditable = true;
                this.prop.colorEditor.editColor(int(this.prop.lastItem.shopItemInfo.colorValue));
            }
            else
            {
                this.prop.colorEditor.colorEditable = false;
            };
        }

        private function addCarEquip(_arg_1:ShopCarItemInfo):void
        {
            var _local_2:ShopCartItem = new ShopCartItem();
            _local_2.shopItemInfo = _arg_1;
            this.prop.cartList.addChild(_local_2);
            _local_2.addEventListener(ShopCartItem.DELETE_ITEM, this.__deleteItem);
            _local_2.addEventListener(ShopCartItem.CONDITION_CHANGE, this.__conditionChange);
            this.prop.cartScroll.invalidateViewport(true);
        }

        private function checkShiner(_arg_1:Event=null):void
        {
            if ((((this.prop.colorEditor.colorEditable) || (this.prop.colorEditor.skinEditable)) && (!(this.prop.lastItem.info == null))))
            {
                this.prop.panelColorBtn.enable = true;
                this._isUsed = true;
                if (((this.prop.panelBtnGroup.selectIndex == SHOW_WEALTH) && (this.prop.canShine)))
                {
                    this.prop.canShine = false;
                };
            }
            else
            {
                this.prop.panelColorBtn.enable = false;
                this._isUsed = false;
            };
        }

        private function initEvent():void
        {
            addEventListener(Event.ENTER_FRAME, this.checkShiner);
            this._controller.rightView.addEventListener(ShopRightView.SHOW_LIGHT, this._showLight);
            this.prop.colorEditor.addEventListener(Event.CHANGE, this.__selectedColorChanged);
            this.prop.colorEditor.addEventListener(ColorEditor.REDUCTIVE_COLOR, this.__reductiveColor);
            this.prop.colorEditor.addEventListener(ColorEditor.CHANGE_COLOR, this._changeColor);
            this.prop.lastItem.addEventListener(ShopEvent.ITEMINFO_CHANGE, this.__updateColorEditor);
            this.prop.btnClearLastEquip.addEventListener(MouseEvent.CLICK, this.__clearLastClick);
            this.prop.cbHideHat.addEventListener(Event.SELECT, this.__hideHatChange);
            this.prop.cbHideGlasses.addEventListener(Event.SELECT, this.__hideGlassChange);
            this.prop.cbHideSuit.addEventListener(Event.SELECT, this.__hideSuitesChange);
            this.prop.cbHideWings.addEventListener(Event.SELECT, this.__hideWingClickHandler);
            this._model.addEventListener(ShopEvent.ADD_TEMP_EQUIP, this.__addTempEquip);
            this._model.addEventListener(ShopEvent.COST_UPDATE, this.__update);
            this._model.addEventListener(ShopEvent.ADD_CAR_EQUIP, this.__addCarEquip);
            this._model.addEventListener(ShopEvent.FITTINGMODEL_CHANGE, this.__fittingSexChanged);
            this._model.addEventListener(ShopEvent.REMOVE_CAR_EQUIP, this.__removeCarEquip);
            this._model.addEventListener(ShopEvent.SELECTEDEQUIP_CHANGE, this.__selectedEquipChange);
            this._model.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
            this._model.addEventListener(ShopEvent.REMOVE_TEMP_EQUIP, this.__removeTempEquip);
            this.prop.lastItem.addEventListener(ShopEvent.ITEMINFO_CHANGE, this.__itemInfoChange);
            this.prop.panelCartBtn.addEventListener(MouseEvent.CLICK, this.__panelBtnClickHandler);
            this.prop.panelColorBtn.addEventListener(MouseEvent.CLICK, this.__panelBtnClickHandler);
            this.prop.presentBtn.addEventListener(MouseEvent.CLICK, this.__presentClick);
            this.prop.purchaseBtn.addEventListener(MouseEvent.CLICK, this.__purchaseClick);
            this.prop.leftMoneyPanelBuyBtn.addEventListener(MouseEvent.CLICK, this.__purchaseClick);
            this.prop.randomBtn.addEventListener(MouseEvent.CLICK, this.__random);
            this.prop.saveFigureBtn.addEventListener(MouseEvent.CLICK, this.__saveFigureClick);
            this._model.addEventListener(ShopEvent.UPDATE_CAR, this.__updateCar);
            var _local_1:int;
            while (_local_1 < this.prop.playerCells.length)
            {
                this.prop.playerCells[_local_1].addEventListener(MouseEvent.CLICK, this.__cellClick);
                _local_1++;
            };
        }

        private function __cellClick(_arg_1:MouseEvent):void
        {
            var _local_3:ShopCarItemInfo;
            var _local_4:ShopPlayerCell;
            SoundManager.instance.play("047");
            var _local_2:ShopPlayerCell = (_arg_1.currentTarget as ShopPlayerCell);
            if (_local_2.locked)
            {
                return;
            };
            if (_local_2.shopItemInfo != null)
            {
                if (((((((_local_2.shopItemInfo.CategoryID == EquipType.HEAD) || (_local_2.shopItemInfo.CategoryID == EquipType.GLASS)) || (_local_2.shopItemInfo.CategoryID == EquipType.HAIR)) || (_local_2.shopItemInfo.CategoryID == EquipType.EFF)) || (_local_2.shopItemInfo.CategoryID == EquipType.CLOTH)) || (_local_2.shopItemInfo.CategoryID == EquipType.FACE)))
                {
                    _local_3 = _local_2.shopItemInfo;
                    for each (_local_4 in this.prop.playerCells)
                    {
                        if (_local_4.shopItemInfo == _local_3)
                        {
                            _local_4.showLight();
                        }
                        else
                        {
                            _local_4.hideLight();
                        };
                    };
                };
            };
            this._controller.setSelectedEquip(_local_2.shopItemInfo);
            this.prop.lastItem.shopItemInfo = _local_2.shopItemInfo;
        }

        private function __updateCar(_arg_1:ShopEvent):void
        {
            var _local_5:ShopCartItem;
            var _local_7:uint;
            var _local_2:ShopCarItemInfo = (_arg_1.param as ShopCarItemInfo);
            var _local_3:Array = this._model.allItems;
            var _local_4:Array = new Array();
            var _local_6:int;
            while (_local_6 < this.prop.cartList.numChildren)
            {
                _local_5 = (this.prop.cartList.getChildAt(_local_6) as ShopCartItem);
                _local_4.push(_local_5.shopItemInfo);
                _local_6++;
            };
            if (_local_4.length < _local_3.length)
            {
                this.addCarEquip(_local_2);
            }
            else
            {
                if (_local_4.length == _local_3.length)
                {
                    _local_7 = 0;
                    while (_local_7 < _local_4.length)
                    {
                        if (_local_3.indexOf(_local_4[_local_7]) < 0)
                        {
                            (this.prop.cartList.getChildAt(_local_7) as ShopCartItem).shopItemInfo = _local_2;
                            break;
                        };
                        _local_7++;
                    };
                }
                else
                {
                    if (_local_4.length > _local_3.length)
                    {
                        _local_7 = 0;
                        while (_local_7 < _local_4.length)
                        {
                            if (_local_3.indexOf(_local_4[_local_7]) < 0)
                            {
                                _local_6 = 0;
                                while (_local_6 < this.prop.cartList.numChildren)
                                {
                                    _local_5 = (this.prop.cartList.getChildAt(_local_6) as ShopCartItem);
                                    if (_local_5.shopItemInfo == _local_4[_local_7])
                                    {
                                        _local_5.removeEventListener(ShopCartItem.DELETE_ITEM, this.__deleteItem);
                                        _local_5.removeEventListener(ShopCartItem.CONDITION_CHANGE, this.__conditionChange);
                                        _local_5.dispose();
                                        break;
                                    };
                                    _local_6++;
                                };
                            };
                            _local_7++;
                        };
                    };
                };
            };
            this.prop.cartScroll.invalidateViewport();
        }

        private function removeEvents():void
        {
            removeEventListener(Event.ENTER_FRAME, this.checkShiner);
            this._controller.rightView.removeEventListener(ShopRightView.SHOW_LIGHT, this._showLight);
            this.prop.colorEditor.removeEventListener(Event.CHANGE, this.__selectedColorChanged);
            this.prop.colorEditor.removeEventListener(ColorEditor.REDUCTIVE_COLOR, this.__reductiveColor);
            this.prop.colorEditor.removeEventListener(ColorEditor.CHANGE_COLOR, this._changeColor);
            this.prop.lastItem.removeEventListener(ShopEvent.ITEMINFO_CHANGE, this.__updateColorEditor);
            this.prop.btnClearLastEquip.removeEventListener(MouseEvent.CLICK, this.__clearLastClick);
            this.prop.cbHideHat.removeEventListener(Event.SELECT, this.__hideHatChange);
            this.prop.cbHideGlasses.removeEventListener(Event.SELECT, this.__hideGlassChange);
            this.prop.cbHideSuit.removeEventListener(Event.SELECT, this.__hideSuitesChange);
            this.prop.cbHideWings.removeEventListener(Event.SELECT, this.__hideWingClickHandler);
            this._model.removeEventListener(ShopEvent.ADD_TEMP_EQUIP, this.__addTempEquip);
            this._model.removeEventListener(ShopEvent.COST_UPDATE, this.__update);
            this._model.removeEventListener(ShopEvent.ADD_CAR_EQUIP, this.__addCarEquip);
            this._model.removeEventListener(ShopEvent.FITTINGMODEL_CHANGE, this.__fittingSexChanged);
            this._model.removeEventListener(ShopEvent.REMOVE_CAR_EQUIP, this.__removeCarEquip);
            this._model.removeEventListener(ShopEvent.SELECTEDEQUIP_CHANGE, this.__selectedEquipChange);
            this._model.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__propertyChange);
            this._model.removeEventListener(ShopEvent.REMOVE_TEMP_EQUIP, this.__removeTempEquip);
            this.prop.lastItem.removeEventListener(ShopEvent.ITEMINFO_CHANGE, this.__itemInfoChange);
            this.prop.panelCartBtn.removeEventListener(MouseEvent.CLICK, this.__panelBtnClickHandler);
            this.prop.panelColorBtn.removeEventListener(MouseEvent.CLICK, this.__panelBtnClickHandler);
            this.prop.presentBtn.removeEventListener(MouseEvent.CLICK, this.__presentClick);
            this.prop.purchaseBtn.removeEventListener(MouseEvent.CLICK, this.__purchaseClick);
            this.prop.leftMoneyPanelBuyBtn.removeEventListener(MouseEvent.CLICK, this.__purchaseClick);
            this.prop.saveFigureBtn.removeEventListener(MouseEvent.CLICK, this.__saveFigureClick);
            this._model.removeEventListener(ShopEvent.UPDATE_CAR, this.__updateCar);
            this.prop.randomBtn.removeEventListener(MouseEvent.CLICK, this.__random);
        }

        private function __purchaseClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (((((this._model.totalMoney > 0) || (this._model.totalGift > 0)) || (this._model.totalMedal > 0)) && (PlayerManager.Instance.Self.bagLocked)))
            {
                BaglockedManager.Instance.show();
                return;
            };
            this.clearHighLight();
            this.prop.checkOutPanel.setup(this._controller, this._model, this._model.allItems, ShopCheckOutView.PURCHASE);
            LayerManager.Instance.addToLayer(this.prop.checkOutPanel, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __random(_arg_1:MouseEvent):void
        {
            var _local_2:ShopPlayerCell;
            SoundManager.instance.play("008");
            if ((getTimer() - this.latestRandom) < 1500)
            {
                return;
            };
            this.latestRandom = getTimer();
            for each (_local_2 in this.prop.playerCells)
            {
                _local_2.hideLight();
            };
            this.prop.cbHideGlasses.selected = false;
            this.prop.cbHideHat.selected = false;
            this.prop.cbHideWings.selected = false;
            this.prop.cbHideSuit.selected = true;
            this._controller.model.random();
        }

        private function __saveFigureClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.clearHighLight();
            this.prop.checkOutPanel.setup(this._controller, this._model, this._model.currentTempList, ShopCheckOutView.SAVE);
            LayerManager.Instance.addToLayer(this.prop.checkOutPanel, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function __presentClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.clearHighLight();
            var _local_2:Array = ShopManager.Instance.moneyGoods(this._model.allItems, this._model.Self);
            if (_local_2.length > 0)
            {
                this.prop.checkOutPanel.setup(this._controller, this._model, _local_2, ShopCheckOutView.PRESENT);
                LayerManager.Instance.addToLayer(this.prop.checkOutPanel, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("shop.view.cantPresent"));
            };
        }

        private function __itemInfoChange(_arg_1:Event):void
        {
            this.prop.canShine = true;
            this.__updateColorEditor();
        }

        private function __removeTempEquip(_arg_1:ShopEvent):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:InventoryItemInfo;
            var _local_2:ShopCarItemInfo = (_arg_1.param as ShopCarItemInfo);
            if (this.prop.lastItem.shopItemInfo == _local_2)
            {
                this.prop.lastItem.shopItemInfo = null;
            };
            this.__updateColorEditor();
            if (_local_2.TemplateInfo.NeedSex == MALE)
            {
                if ((this.prop.addedManNewEquip > 0))
                {
                    this.prop.addedManNewEquip--;
                }
                else
                {
                    this.prop.addedManNewEquip = 0;
                };
            }
            else
            {
                if (_local_2.TemplateInfo.NeedSex == FEMALE)
                {
                    if ((this.prop.addedWomanNewEquip > 0))
                    {
                        this.prop.addedWomanNewEquip--;
                    }
                    else
                    {
                        this.prop.addedWomanNewEquip = 0;
                    };
                };
            };
            if (_arg_1.model == this._model.currentModel)
            {
                _local_3 = _local_2.place;
                _local_4 = this._model.getBagItems(_local_3, true);
                _local_5 = this._model.currentModel.Bag.items[_local_3];
                if (_local_5)
                {
                    this.prop.playerCells[_local_4].info = _local_5;
                    this.prop.playerCells[_local_4].locked = true;
                }
                else
                {
                    this.prop.playerCells[_local_4].info = null;
                };
                this.updateButtons();
            };
            this.__updateCar(_arg_1);
        }

        private function __selectedEquipChange(_arg_1:ShopEvent):void
        {
            this.prop.lastItem.shopItemInfo = (_arg_1.param as ShopCarItemInfo);
            this.updateButtons();
            this.__updateColorEditor();
        }

        private function setColorLayer(_arg_1:int):void
        {
            var _local_3:int;
            var _local_4:int;
            var _local_5:Array;
            var _local_2:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
            if ((((_local_2) && (EquipType.isEditable(_local_2.TemplateInfo))) && (!(int(_local_2.colorValue) == _arg_1))))
            {
                _local_3 = (this.prop.lastItem.editLayer - 1);
                _local_4 = EquipType.CategeryIdToPlace(_local_2.CategoryID)[0];
                _local_5 = _local_2.Color.split("|");
                _local_5[_local_3] = String(_arg_1);
                _local_2.Color = _local_5.join("|");
                this.prop.lastItem.setColor(_local_2.Color);
                this._model.currentModel.setPartColor(_local_2.CategoryID, _local_2.Color);
            };
        }

        private function setSkinColor(_arg_1:String):void
        {
            var _local_2:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
            if (((_local_2) && (_local_2.CategoryID == EquipType.FACE)))
            {
                _local_2.skin = _arg_1;
            };
            this.prop.lastItem.setSkinColor(_arg_1);
            this._model.currentModel.Skin = _arg_1;
        }

        protected function __reductiveColor(_arg_1:Event):void
        {
            var _local_2:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
            if (this.prop.colorEditor.selectedType == COLOR)
            {
                if (((_local_2) && (EquipType.isEditable(_local_2.TemplateInfo))))
                {
                    _local_2.Color = "";
                    this._model.currentModel.setPartColor(_local_2.CategoryID, null);
                };
            }
            else
            {
                _local_2.skin = "";
                this._model.currentModel.setSkinColor("");
            };
        }

        private function _changeColor(_arg_1:Event):void
        {
            this.showShine();
        }

        private function _showLight(_arg_1:Event):void
        {
            if (this._isVisible)
            {
                this.showShine();
            };
        }

        private function showShine():void
        {
            var _local_2:ShopPlayerCell;
            var _local_1:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
            for each (_local_2 in this.prop.playerCells)
            {
                if (_local_2.shopItemInfo == _local_1)
                {
                    _local_2.showLight();
                }
                else
                {
                    _local_2.hideLight();
                };
            };
        }

        public function hideLight():void
        {
            var _local_2:ShopPlayerCell;
            var _local_1:ShopCarItemInfo = this.prop.lastItem.shopItemInfo;
            for each (_local_2 in this.prop.playerCells)
            {
                _local_2.hideLight();
            };
        }

        private function updateButtons():void
        {
            this.prop.saveFigureBtn.enable = ((this._model.isSelfModel) && (!(this._model.currentTempList.length == 0)));
            if (this.prop.saveFigureBtn.enable)
            {
                this.prop.saveFigureEffet.play();
            }
            else
            {
                this.prop.saveFigureEffet.stop();
            };
        }

        public function dispose():void
        {
            this.removeEvents();
            this.prop.disposeAllChildrenFrom(this);
            this.prop = null;
            this._controller = null;
            this._model = null;
        }


    }
}//package shop.view

