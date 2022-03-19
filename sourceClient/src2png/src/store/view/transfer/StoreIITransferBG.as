// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.transfer.StoreIITransferBG

package store.view.transfer
{
    import flash.display.Sprite;
    import store.IStoreViewBG;
    import com.pickgliss.ui.image.MutipleImage;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.image.MovieImage;
    import flash.geom.Point;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Image;
    import store.view.StoneCellFrame;
    import com.pickgliss.effect.IEffect;
    import flash.display.Bitmap;
    import ddt.view.tips.OneLineTip;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.effect.EffectManager;
    import com.pickgliss.effect.EffectTypes;
    import com.pickgliss.effect.EffectColorType;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import store.StoreController;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;
    import ddt.data.BagInfo;
    import bagAndInfo.cell.BagCell;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.data.EquipType;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.command.QuickBuyFrame;
    import flash.external.ExternalInterface;
    import flash.net.navigateToURL;
    import flash.net.URLRequest;
    import ddt.manager.PathManager;
    import flash.utils.Dictionary;
    import store.HelpPrompt;
    import store.HelpFrame;
    import flash.utils.setTimeout;
    import ddt.manager.DropGoodsManager;
    import __AS3__.vec.*;

    public class StoreIITransferBG extends Sprite implements IStoreViewBG 
    {

        private var _bg:MutipleImage;
        private var _area:TransferDragInArea;
        private var _items:Vector.<TransferItemCell>;
        private var _transferBtnAsset:BaseButton;
        private var transShine:MovieImage;
        private var transArr:MutipleImage;
        private var _pointArray:Vector.<Point>;
        private var gold_txt:FilterFrameText;
        private var _goldIcon:Image;
        private var _transferBefore:Boolean = false;
        private var _transferAfter:Boolean = false;
        private var _equipmentCell1:StoneCellFrame;
        private var _equipmentCell2:StoneCellFrame;
        private var _neededGoldTipText:FilterFrameText;
        private var _transferBtnAsset_shineEffect:IEffect;
        private var _preExpText:FilterFrameText;
        private var _preExp:FilterFrameText;
        private var _preSaveExpText:FilterFrameText;
        private var _preSaveExp:FilterFrameText;
        private var _turnExpText:FilterFrameText;
        private var _turnExp:FilterFrameText;
        private var _turnSaveExpText:FilterFrameText;
        private var _turnSaveExp:FilterFrameText;
        private var _memoryExpBg1:Bitmap;
        private var _memoryExpBg2:Bitmap;
        private var _sprite1:Sprite;
        private var _sprite2:Sprite;
        private var _expTips:OneLineTip;
        private var _transferSuccessMc:MovieClip;
        private var _transferSuccessMcI:MovieClip;

        public function StoreIITransferBG()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            var _local_1:int;
            var _local_2:TransferItemCell;
            this._memoryExpBg1 = ComponentFactory.Instance.creatBitmap("asset.ddtstore.Transfer.memoryExp.bg");
            PositionUtils.setPos(this._memoryExpBg1, "asset.ddtstore.Transfer.memoryExp.bg.pos1");
            addChild(this._memoryExpBg1);
            this._sprite1 = new Sprite();
            this._sprite1.graphics.beginFill(0, 0);
            this._sprite1.graphics.drawRect(0, 0, this._memoryExpBg1.width, this._memoryExpBg1.height);
            this._sprite1.graphics.endFill();
            this._sprite1.x = this._memoryExpBg1.x;
            this._sprite1.y = this._memoryExpBg1.y;
            addChild(this._sprite1);
            this._memoryExpBg2 = ComponentFactory.Instance.creatBitmap("asset.ddtstore.Transfer.memoryExp.bg");
            PositionUtils.setPos(this._memoryExpBg2, "asset.ddtstore.Transfer.memoryExp.bg.pos2");
            addChild(this._memoryExpBg2);
            this._sprite2 = new Sprite();
            this._sprite2.graphics.beginFill(0, 0);
            this._sprite2.graphics.drawRect(0, 0, this._memoryExpBg2.width, this._memoryExpBg2.height);
            this._sprite2.graphics.endFill();
            this._sprite2.x = this._memoryExpBg2.x;
            this._sprite2.y = this._memoryExpBg2.y;
            addChild(this._sprite2);
            this._equipmentCell1 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIITransferBG.EquipmentCell1");
            this._equipmentCell2 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIITransferBG.EquipmentCell2");
            this._equipmentCell1.label = (this._equipmentCell2.label = LanguageMgr.GetTranslation("store.Strength.StrengthenEquipmentCellText"));
            addChild(this._equipmentCell1);
            addChild(this._equipmentCell2);
            this._preExpText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.preExpText");
            this._preExpText.text = LanguageMgr.GetTranslation("store.Transfer.strengthExp");
            addChild(this._preExpText);
            this._preExp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.preExp");
            this._preExp.text = "0";
            addChild(this._preExp);
            this._preSaveExpText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.preSaveExpText");
            this._preSaveExpText.text = LanguageMgr.GetTranslation("store.Transfer.saveExp");
            addChild(this._preSaveExpText);
            this._preSaveExp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.preSaveExp");
            this._preSaveExp.text = "0";
            addChild(this._preSaveExp);
            this._turnExpText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.turnExpText");
            this._turnExpText.text = LanguageMgr.GetTranslation("store.Transfer.strengthExp");
            addChild(this._turnExpText);
            this._turnExp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.turnExp");
            this._turnExp.text = "0";
            this._turnExp.visible = false;
            addChild(this._turnExp);
            this._turnSaveExpText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.turnSaveExpText");
            this._turnSaveExpText.text = LanguageMgr.GetTranslation("store.Transfer.saveExp");
            addChild(this._turnSaveExpText);
            this._turnSaveExp = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.turnSaveExp");
            this._turnSaveExp.text = "0";
            this._turnSaveExp.visible = false;
            addChild(this._turnSaveExp);
            this._transferBtnAsset = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.TransferBtn");
            addChild(this._transferBtnAsset);
            this._transferBtnAsset_shineEffect = EffectManager.Instance.creatEffect(EffectTypes.Linear_SHINER_ANIMATION, this._transferBtnAsset, {"color":EffectColorType.BLUE});
            this._neededGoldTipText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.NeededGoldTipText");
            this._neededGoldTipText.text = LanguageMgr.GetTranslation("store.Transfer.NeededGoldTipText");
            addChild(this._neededGoldTipText);
            this.gold_txt = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITarnsferBG.NeedMoneyText");
            addChild(this.gold_txt);
            this._goldIcon = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIITransferBG.GoldIcon");
            addChild(this._goldIcon);
            this._expTips = new OneLineTip();
            this._expTips.tipData = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.expTips");
            this._expTips.visible = false;
            addChild(this._expTips);
            if ((!(this._transferSuccessMcI)))
            {
                this._transferSuccessMcI = ClassUtils.CreatInstance("asset.ddtstore.transferSuccessI");
            };
            PositionUtils.setPos(this._transferSuccessMcI, "ddtstore.StoreIITransferBG.weaponUpgradesPointI");
            addChild(this._transferSuccessMcI);
            this._transferSuccessMcI.visible = false;
            this._transferSuccessMcI.stop();
            this.getCellsPoint();
            this._items = new Vector.<TransferItemCell>();
            _local_1 = 0;
            while (_local_1 < 2)
            {
                _local_2 = new TransferItemCell(_local_1);
                _local_2.addEventListener(Event.CHANGE, this.__itemInfoChange);
                _local_2.x = this._pointArray[_local_1].x;
                _local_2.y = this._pointArray[_local_1].y;
                addChild(_local_2);
                this._items.push(_local_2);
                _local_1++;
            };
            this._area = new TransferDragInArea(this._items);
            addChildAt(this._area, 0);
            if ((!(this._transferSuccessMc)))
            {
                this._transferSuccessMc = ClassUtils.CreatInstance("asset.ddtstore.transferSuccess");
            };
            PositionUtils.setPos(this._transferSuccessMc, "ddtstore.StoreIITransferBG.weaponUpgradesPoint");
            addChild(this._transferSuccessMc);
            this._transferSuccessMc.visible = false;
            this._transferSuccessMc.stop();
            this.showExpPre(false);
            this.showExpTurn(false);
            this.hideArr();
            this.hide();
        }

        private function getCellsPoint():void
        {
            var _local_2:Point;
            this._pointArray = new Vector.<Point>();
            var _local_1:int;
            while (_local_1 < 2)
            {
                _local_2 = ComponentFactory.Instance.creatCustomObject(("ddtstore.StoreIITransferBG.Transferpoint" + _local_1));
                this._pointArray.push(_local_2);
                _local_1++;
            };
        }

        private function initEvent():void
        {
            this._transferBtnAsset.addEventListener(MouseEvent.CLICK, this.__transferHandler);
            this._sprite1.addEventListener(MouseEvent.MOUSE_OVER, this.__showExpTips);
            this._sprite2.addEventListener(MouseEvent.MOUSE_OVER, this.__showExpTips);
            this._sprite1.addEventListener(MouseEvent.MOUSE_OUT, this.__hideExpTips);
            this._sprite2.addEventListener(MouseEvent.MOUSE_OUT, this.__hideExpTips);
            StoreController.instance.addEventListener(StoreController.TRANSFER_SUCCESS, this.__playMc);
        }

        private function removeEvent():void
        {
            this._transferBtnAsset.removeEventListener(MouseEvent.CLICK, this.__transferHandler);
            this._sprite1.removeEventListener(MouseEvent.MOUSE_OVER, this.__showExpTips);
            this._sprite2.removeEventListener(MouseEvent.MOUSE_OVER, this.__showExpTips);
            this._sprite1.removeEventListener(MouseEvent.MOUSE_OUT, this.__hideExpTips);
            this._sprite2.removeEventListener(MouseEvent.MOUSE_OUT, this.__hideExpTips);
            StoreController.instance.removeEventListener(StoreController.TRANSFER_SUCCESS, this.__playMc);
        }

        private function __playMc(_arg_1:Event):void
        {
            this._transferSuccessMc.visible = true;
            this._transferSuccessMcI.visible = true;
            this._transferSuccessMc.gotoAndPlay(1);
            this._transferSuccessMcI.gotoAndPlay(1);
            this._transferSuccessMc.addEventListener(Event.ENTER_FRAME, this.__transferFrame);
            this._transferSuccessMcI.addEventListener(Event.ENTER_FRAME, this.__transferFrameI);
        }

        private function __transferFrame(_arg_1:Event):void
        {
            if (this._transferSuccessMc)
            {
                if (this._transferSuccessMc.currentFrame == this._transferSuccessMc.totalFrames)
                {
                    this._transferSuccessMc.removeEventListener(Event.ENTER_FRAME, this.__transferFrame);
                    this.removeMovie();
                };
            };
        }

        private function __transferFrameI(_arg_1:Event):void
        {
            if (this._transferSuccessMcI)
            {
                if (this._transferSuccessMcI.currentFrame == this._transferSuccessMcI.totalFrames)
                {
                    this._transferSuccessMcI.removeEventListener(Event.ENTER_FRAME, this.__transferFrameI);
                    this.removeMovie();
                };
            };
        }

        private function removeMovie():void
        {
            this._transferSuccessMc.visible = false;
            this._transferSuccessMcI.visible = false;
            this._transferSuccessMc.stop();
            this._transferSuccessMcI.stop();
            this.clearTransferItemCell();
        }

        public function startShine(_arg_1:int):void
        {
            this._items[_arg_1].startShine();
        }

        public function stopShine():void
        {
            var _local_1:int;
            while (_local_1 < 2)
            {
                this._items[_local_1].stopShine();
                _local_1++;
            };
        }

        private function showArr():void
        {
            if (((SavePointManager.Instance.isInSavePoint(67)) && (!(TaskManager.instance.isNewHandTaskCompleted(28)))))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.TRANSFER_CHOOSE_WEAPON);
                NewHandContainer.Instance.showArrow(ArrowType.STR_WEAPON, 0, "trainer.storeTranSureArrowPos", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
            };
            this._transferBtnAsset_shineEffect.play();
        }

        private function hideArr():void
        {
            NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
            this._transferBtnAsset_shineEffect.stop();
        }

        public function get area():Vector.<TransferItemCell>
        {
            return (this._items);
        }

        public function setCell(_arg_1:BagCell):void
        {
            var _local_4:TransferItemCell;
            var _local_5:EquipmentTemplateInfo;
            var _local_6:EquipmentTemplateInfo;
            if (_arg_1 == null)
            {
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.info as InventoryItemInfo);
            var _local_3:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_local_2.TemplateID);
            for each (_local_4 in this._items)
            {
                if (_local_4.info == null)
                {
                    if (this._items[0].info)
                    {
                        _local_5 = ItemManager.Instance.getEquipTemplateById(this._items[0].info.TemplateID);
                        if (_local_5.TemplateType != _local_3.TemplateType)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                            return;
                        };
                    }
                    else
                    {
                        if (this._items[1].info)
                        {
                            _local_6 = ItemManager.Instance.getEquipTemplateById(this._items[1].info.TemplateID);
                            if (_local_6.TemplateType != _local_3.TemplateType)
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.TransferItemCell.put"));
                                return;
                            };
                        };
                    };
                    SocketManager.Instance.out.sendMoveGoods(_local_2.BagType, _local_2.Place, BagInfo.STOREBAG, _local_4.index, 1);
                    return;
                };
            };
        }

        private function getMaxExpByLevel(_arg_1:int, _arg_2:int):Number
        {
            var _local_3:Number = 0;
            var _local_4:int = 1;
            while (_local_4 <= _arg_1)
            {
                _local_3 = (_local_3 + ItemManager.Instance.getEquipStrengthInfoByLevel(_local_4, _arg_2).Exp);
                _local_4++;
            };
            return (_local_3);
        }

        private function __transferHandler(_arg_1:MouseEvent):void
        {
            var _local_4:String;
            var _local_5:BaseAlerFrame;
            var _local_6:BaseAlerFrame;
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            var _local_2:TransferItemCell = (this._items[0] as TransferItemCell);
            var _local_3:TransferItemCell = (this._items[1] as TransferItemCell);
            if (this._showDontClickTip())
            {
                return;
            };
            if (((_local_2.info) && (_local_3.info)))
            {
                if (PlayerManager.Instance.Self.Gold < Number(this.gold_txt.text))
                {
                    _local_6 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.room.RoomIIView2.notenoughmoney.title"), LanguageMgr.GetTranslation("tank.view.GoldInadequate"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_6.moveEnable = false;
                    _local_6.addEventListener(FrameEvent.RESPONSE, this._responseV);
                    return;
                };
                this.hideArr();
                this._transferBefore = (this._transferAfter = false);
                _local_4 = "";
                if (((((((EquipType.isArm(_local_2.info)) || (EquipType.isCloth(_local_2.info))) || (EquipType.isHead(_local_2.info))) || (EquipType.isArm(_local_3.info))) || (EquipType.isCloth(_local_3.info))) || (EquipType.isHead(_local_3.info))))
                {
                    _local_4 = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.sure2");
                }
                else
                {
                    _local_4 = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.sure");
                };
                _local_5 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), _local_4, LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.ALPHA_BLOCKGOUND);
                _local_5.addEventListener(FrameEvent.RESPONSE, this._responseII);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.EmptyItem"));
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

        private function _response(_arg_1:FrameEvent):void
        {
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                this.depositAction();
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function _responseII(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = BaseAlerFrame(_arg_1.currentTarget);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this._responseII);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                this._transferBefore = (this._transferAfter = true);
                StoreController.instance.Model.transWeaponReady = false;
                this.sendSocket();
            }
            else
            {
                this.cannel();
            };
            ObjectUtils.disposeObject(_arg_1.target);
        }

        private function cannel():void
        {
            this.showArr();
        }

        private function depositAction():void
        {
            if (ExternalInterface.available)
            {
                ExternalInterface.call("setFlashCall");
            };
            navigateToURL(new URLRequest(PathManager.solveFillPage()), "_blank");
        }

        private function isComposeStrengthen(_arg_1:BagCell):Boolean
        {
            if (((_arg_1.itemInfo.StrengthenExp > 0) || (_arg_1.itemInfo.StrengthenLevel > 0)))
            {
                return (true);
            };
            return (false);
        }

        private function sendSocket():void
        {
            SocketManager.Instance.out.sendItemTransfer(this._transferBefore, this._transferAfter);
        }

        private function __itemInfoChange(_arg_1:Event):void
        {
            var _local_4:EquipmentTemplateInfo;
            var _local_5:EquipmentTemplateInfo;
            NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
            this.gold_txt.text = "0";
            var _local_2:TransferItemCell = this._items[0];
            var _local_3:TransferItemCell = this._items[1];
            if (_local_2.info)
            {
                this.showExpPre(true);
                _local_4 = ItemManager.Instance.getEquipTemplateById(_local_2.info.TemplateID);
                if (((_local_2.info["StrengthenLevel"] == _local_4.StrengthLimit) && (_local_2.info["StrengthenExp"] > 0)))
                {
                    this._preExp.text = this.getMaxExpByLevel(_local_4.StrengthLimit, _local_4.QualityID).toString();
                    this._preSaveExp.text = _local_2.info["StrengthenExp"].toString();
                }
                else
                {
                    this._preExp.text = (this.getMaxExpByLevel(_local_2.info["StrengthenLevel"], _local_4.QualityID) + _local_2.info["StrengthenExp"]).toString();
                    this._preSaveExp.text = "0";
                };
                _local_2.TemplateType = -1;
                if (_local_3.info)
                {
                    _local_2.TemplateType = _local_4.TemplateType;
                };
                _local_3.TemplateType = _local_4.TemplateType;
                NewHandContainer.Instance.clearArrowByID(ArrowType.TRANSFER_CHOOSE_WEAPON);
            }
            else
            {
                this.showExpPre(false);
                _local_3.TemplateType = -1;
                if (_local_3.info)
                {
                    _local_2.TemplateType = ItemManager.Instance.getEquipTemplateById(_local_3.info.TemplateID).TemplateType;
                }
                else
                {
                    _local_2.TemplateType = -1;
                };
            };
            if (_local_3.info)
            {
                this.showExpTurn(true);
                _local_5 = ItemManager.Instance.getEquipTemplateById(_local_3.info.TemplateID);
                if (((_local_3.info["StrengthenLevel"] == _local_5.StrengthLimit) && (_local_3.info["StrengthenExp"] > 0)))
                {
                    this._turnExp.text = this.getMaxExpByLevel(_local_5.StrengthLimit, _local_5.QualityID).toString();
                    this._turnSaveExp.text = _local_3.info["StrengthenExp"].toString();
                }
                else
                {
                    this._turnExp.text = (this.getMaxExpByLevel(_local_3.info["StrengthenLevel"], _local_5.QualityID) + _local_3.info["StrengthenExp"]).toString();
                    this._turnSaveExp.text = "0";
                };
                NewHandContainer.Instance.clearArrowByID(ArrowType.TRANSFER_CHOOSE_WEAPON);
            }
            else
            {
                this.showExpTurn(false);
            };
            if (_local_2.info)
            {
                _local_2.Refinery = (_local_3.Refinery = _local_2.info.RefineryLevel);
            }
            else
            {
                if (_local_3.info)
                {
                    _local_2.Refinery = (_local_3.Refinery = _local_3.info.RefineryLevel);
                }
                else
                {
                    _local_2.Refinery = (_local_3.Refinery = -1);
                };
            };
            if (((_local_2.info) && (_local_3.info)))
            {
                if (_local_4.TemplateType != _local_5.TemplateType)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.put"));
                    return;
                };
                if (((this.isComposeStrengthen(_local_2)) || (this.isComposeStrengthen(_local_3))))
                {
                    this.goldMoney();
                    this.showArr();
                }
                else
                {
                    this.hideArr();
                };
            }
            else
            {
                this.hideArr();
            };
            if (((_local_2.info) && (!(_local_3.info))))
            {
                StoreController.instance.Model.transWeaponReady = true;
                StoreController.instance.sendTransferShowLightEvent(_local_2.info, true);
            }
            else
            {
                if (((_local_3.info) && (!(_local_2.info))))
                {
                    StoreController.instance.Model.transWeaponReady = true;
                    StoreController.instance.sendTransferShowLightEvent(_local_3.info, true);
                }
                else
                {
                    StoreController.instance.Model.transWeaponReady = false;
                    StoreController.instance.sendTransferShowLightEvent(null, false);
                };
            };
        }

        private function showExpPre(_arg_1:Boolean):void
        {
            this._preExp.visible = _arg_1;
            this._preExpText.visible = _arg_1;
            this._preSaveExpText.visible = _arg_1;
            this._preSaveExp.visible = _arg_1;
            this._memoryExpBg1.visible = _arg_1;
            this._sprite1.visible = _arg_1;
        }

        private function showExpTurn(_arg_1:Boolean):void
        {
            this._turnExp.visible = _arg_1;
            this._turnExpText.visible = _arg_1;
            this._turnSaveExp.visible = _arg_1;
            this._turnSaveExpText.visible = _arg_1;
            this._memoryExpBg2.visible = _arg_1;
            this._sprite2.visible = _arg_1;
        }

        private function _showDontClickTip():Boolean
        {
            var _local_1:TransferItemCell = this._items[0];
            var _local_2:TransferItemCell = this._items[1];
            if (((_local_1.info == null) && (_local_2.info == null)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.NoItem"));
                return (true);
            };
            if (((_local_1.info == null) || (_local_2.info == null)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.transfer.EmptyItem"));
                return (true);
            };
            if (((!(this.isComposeStrengthen(_local_1))) && (!(this.isComposeStrengthen(_local_2)))))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.showTips.transfer.dontTransferII"));
                return (true);
            };
            return (false);
        }

        private function goldMoney():void
        {
            this.gold_txt.text = "10000";
        }

        public function show():void
        {
            this.initEvent();
            this.visible = true;
            this.updateData();
        }

        public function refreshData(_arg_1:Dictionary):void
        {
            var _local_2:String;
            var _local_3:int;
            for (_local_2 in _arg_1)
            {
                _local_3 = int(_local_2);
                if (_local_3 < this._items.length)
                {
                    this._items[_local_3].info = PlayerManager.Instance.Self.StoreBag.items[_local_3];
                };
            };
        }

        public function updateData():void
        {
            var _local_1:int;
            while (_local_1 < 2)
            {
                this._items[_local_1].info = PlayerManager.Instance.Self.StoreBag.items[_local_1];
                _local_1++;
            };
        }

        public function hide():void
        {
            this.removeEvent();
            if (((this._items[0].info) || (this._items[1].info)))
            {
                StoreController.instance.sendTransferShowLightEvent(null, false);
            };
            this.visible = false;
        }

        public function openHelp():void
        {
            var _local_1:HelpPrompt = ComponentFactory.Instance.creat("ddtstore.TransferHelpPrompt");
            var _local_2:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
            _local_2.setView(_local_1);
            _local_2.titleText = LanguageMgr.GetTranslation("store.view.transfer.StoreIITransferBG.move");
            LayerManager.Instance.addToLayer(_local_2, LayerManager.STAGE_DYANMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        public function clearTransferItemCell():void
        {
            var _local_1:TransferItemCell = this._items[0];
            var _local_2:TransferItemCell = this._items[1];
            if (SavePointManager.Instance.isInSavePoint(67))
            {
                if (((_local_1.info.TemplateID == 400218) || (_local_2.info.TemplateID == 400218)))
                {
                    setTimeout(this.dropGoods, 1000, 400218);
                }
                else
                {
                    if (((_local_1.info.TemplateID == 400219) || (_local_2.info.TemplateID == 400219)))
                    {
                        setTimeout(this.dropGoods, 1000, 400219);
                    };
                };
            };
            if (_local_1.info != null)
            {
                SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG, _local_1.index, _local_1.itemBagType, -1);
            };
            if (_local_2.info != null)
            {
                SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG, _local_2.index, _local_2.itemBagType, -1);
            };
        }

        private function dropGoods(_arg_1:int):void
        {
            DropGoodsManager.showTipByTemplateID(_arg_1);
        }

        private function __showExpTips(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            var _local_2:Object = _arg_1.target;
            this._expTips.visible = true;
            this._expTips.x = ((_local_2.x - this._expTips.width) - 5);
            this._expTips.y = (_local_2.y - 3);
        }

        private function __hideExpTips(_arg_1:MouseEvent):void
        {
            this._expTips.visible = false;
        }

        public function dispose():void
        {
            this.removeEvent();
            var _local_1:int;
            while (_local_1 < this._items.length)
            {
                this._items[_local_1].removeEventListener(Event.CHANGE, this.__itemInfoChange);
                this._items[_local_1].dispose();
                _local_1++;
            };
            this._items = null;
            EffectManager.Instance.removeEffect(this._transferBtnAsset_shineEffect);
            this._pointArray = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._neededGoldTipText)
            {
                ObjectUtils.disposeObject(this._neededGoldTipText);
            };
            this._neededGoldTipText = null;
            if (this._goldIcon)
            {
                ObjectUtils.disposeObject(this._goldIcon);
            };
            this._goldIcon = null;
            if (this._equipmentCell1)
            {
                ObjectUtils.disposeObject(this._equipmentCell1);
            };
            this._equipmentCell1 = null;
            if (this._equipmentCell2)
            {
                ObjectUtils.disposeObject(this._equipmentCell2);
            };
            this._equipmentCell2 = null;
            if (this._area)
            {
                ObjectUtils.disposeObject(this._area);
            };
            this._area = null;
            if (this._transferBtnAsset)
            {
                ObjectUtils.disposeObject(this._transferBtnAsset);
            };
            this._transferBtnAsset = null;
            if (this.transShine)
            {
                ObjectUtils.disposeObject(this.transShine);
            };
            this.transShine = null;
            if (this.transArr)
            {
                ObjectUtils.disposeObject(this.transArr);
            };
            this.transArr = null;
            if (this.gold_txt)
            {
                ObjectUtils.disposeObject(this.gold_txt);
            };
            this.gold_txt = null;
            if (this._transferSuccessMc)
            {
                if (this._transferSuccessMc.hasEventListener(Event.ENTER_FRAME))
                {
                    this._transferSuccessMc.removeEventListener(Event.ENTER_FRAME, this.__transferFrame);
                };
                ObjectUtils.disposeObject(this._transferSuccessMc);
                this._transferSuccessMc = null;
            };
            if (this._transferSuccessMcI)
            {
                if (this._transferSuccessMcI.hasEventListener(Event.ENTER_FRAME))
                {
                    this._transferSuccessMcI.removeEventListener(Event.ENTER_FRAME, this.__transferFrameI);
                };
                ObjectUtils.disposeObject(this._transferSuccessMcI);
                this._transferSuccessMcI = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
            ObjectUtils.disposeObject(this._memoryExpBg1);
            this._memoryExpBg1 = null;
            ObjectUtils.disposeObject(this._memoryExpBg2);
            this._memoryExpBg2 = null;
            ObjectUtils.disposeObject(this._turnExp);
            this._turnExp = null;
            ObjectUtils.disposeObject(this._turnSaveExp);
            this._turnSaveExp = null;
            ObjectUtils.disposeObject(this._turnExpText);
            this._turnExpText = null;
            ObjectUtils.disposeObject(this._turnSaveExpText);
            this._turnSaveExpText = null;
            ObjectUtils.disposeObject(this._preExp);
            this._preExp = null;
            ObjectUtils.disposeObject(this._preSaveExp);
            this._preSaveExp = null;
            ObjectUtils.disposeObject(this._preExpText);
            this._preExpText = null;
            ObjectUtils.disposeObject(this._preSaveExpText);
            this._preSaveExpText = null;
            ObjectUtils.disposeObject(this._sprite1);
            this._sprite1 = null;
            ObjectUtils.disposeObject(this._sprite2);
            this._sprite2 = null;
            ObjectUtils.disposeObject(this._expTips);
            this._expTips = null;
        }


    }
}//package store.view.transfer

