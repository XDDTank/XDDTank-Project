// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.embed.StoreEmbedBG

package store.view.embed
{
    import flash.display.Sprite;
    import store.IStoreViewBG;
    import ddt.interfaces.IDragable;
    import ddt.interfaces.IAcceptDrag;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.container.HBox;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.data.goods.InventoryItemInfo;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.geom.Rectangle;
    import ddt.manager.ServerConfigManager;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import flash.events.MouseEvent;
    import store.events.EmbedEvent;
    import flash.events.Event;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import flash.ui.Mouse;
    import ddt.manager.DragManager;
    import com.pickgliss.toplevel.StageReferance;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import road7th.comm.PackageIn;
    import ddt.manager.MessageTipManager;
    import com.greensock.TweenMax;
    import com.greensock.easing.Back;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.command.QuickBuyFrame;
    import ddt.data.EquipType;
    import com.pickgliss.ui.LayerManager;
    import bagAndInfo.cell.BagCell;
    import ddt.data.BagInfo;
    import store.view.storeBag.StoreBagCell;
    import flash.utils.Dictionary;
    import flash.display.DisplayObject;
    import store.HelpFrame;
    import __AS3__.vec.*;

    public class StoreEmbedBG extends Sprite implements IStoreViewBG, IDragable, IAcceptDrag 
    {

        public static const MAX_HOLE:int = 4;

        private var _removeBtn:BaseButton;
        private var _embedTextTip:FilterFrameText;
        private var _embedEquipCell:EmbedItemCell;
        private var _embedHoleCount:int;
        private var _embedStoneList:Vector.<EmbedStoneCell>;
        private var _lastEmbedList:Vector.<EmbedStoneCell>;
        private var _hbox:HBox;
        private var _lastHbox:HBox;
        private var _hboxContainer:Sprite;
        private var _hboxMask:Sprite;
        private var _embedOpenPanel:EmbedOpenPanel;
        private var _equipBgMC:MovieClip;
        private var _embedSuccessMc:MovieClip;
        private var _hboxPos:Point;
        private var _alert:BaseAlerFrame;
        private var _lastItemID:int;
        private var _info:InventoryItemInfo;
        private var _alertCall:Function;
        private var _removeGold:Array;
        private var _needGold:int;
        private var _tipBg:Bitmap;

        public function StoreEmbedBG()
        {
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._removeBtn = ComponentFactory.Instance.creat("ddtstore.embed.embedBg.removeBtn");
            addChild(this._removeBtn);
            this._equipBgMC = ComponentFactory.Instance.creat("ddtstore.embedBg.equipBgMC");
            this._equipBgMC.stop();
            this._equipBgMC.visible = false;
            addChild(this._equipBgMC);
            this._embedSuccessMc = ComponentFactory.Instance.creat("ddtstore.embedBg.embedSuccessMc");
            this._embedSuccessMc.stop();
            this._embedSuccessMc.visible = false;
            addChild(this._embedSuccessMc);
            this._embedTextTip = ComponentFactory.Instance.creat("ddtstore.embed.embedBg.embedTextTip");
            this._embedTextTip.text = LanguageMgr.GetTranslation("ddt.store.embedBG.embedTipText");
            addChild(this._embedTextTip);
            this._embedEquipCell = ComponentFactory.Instance.creat("ddtstore.embed.embedBg.embedCell", [0]);
            addChild(this._embedEquipCell);
            this._embedOpenPanel = new EmbedOpenPanel();
            this._embedOpenPanel.visible = false;
            addChild(this._embedOpenPanel);
            this._hboxContainer = new Sprite();
            this._hboxMask = new Sprite();
            var _local_1:Rectangle = ComponentFactory.Instance.creat("ddtstore.embedBg.maskRect");
            this._hboxMask.graphics.beginFill(0xFF);
            this._hboxMask.graphics.drawRect(_local_1.x, _local_1.y, _local_1.width, _local_1.height);
            this._hboxMask.graphics.endFill();
            this._hboxContainer.cacheAsBitmap = true;
            this._hboxContainer.mask = this._hboxMask;
            addChild(this._hboxMask);
            addChild(this._hboxContainer);
            this._hboxPos = ComponentFactory.Instance.creat("ddtstore.embedBg.hboxPos");
            this._removeGold = ServerConfigManager.instance.findInfoByName(ServerConfigManager.REMOVAL_RUNE_NEED_GOLD).Value.split("|");
            this._tipBg = ComponentFactory.Instance.creatBitmap("asset.ddtstore.EmbedBG.embedTipBM");
            this._tipBg.visible = true;
            addChild(this._tipBg);
        }

        private function initEvent():void
        {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HOLE_EQUIP, this.__openHoleResponse);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.MOSAIC_EQUIP, this.__embedResponse);
            this._removeBtn.addEventListener(MouseEvent.CLICK, this.__removeBtnClick);
            this._embedEquipCell.addEventListener(EmbedEvent.MOVE, this.__moveEquip);
        }

        private function removeEvent():void
        {
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HOLE_EQUIP, this.__openHoleResponse);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.MOSAIC_EQUIP, this.__embedResponse);
            this._removeBtn.removeEventListener(MouseEvent.CLICK, this.__removeBtnClick);
            this._embedSuccessMc.removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            this._embedEquipCell.removeEventListener(EmbedEvent.MOVE, this.__moveEquip);
            if (this._alert)
            {
                this._alert.removeEventListener(FrameEvent.RESPONSE, this.__alertResponse);
                this._alert.removeEventListener(FrameEvent.RESPONSE, this.__bindAlertResponse);
            };
        }

        protected function __removeBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            Mouse.hide();
            DragManager.startDrag(this, null, ComponentFactory.Instance.creat("asset.ddtstore.EmbedBG.removeIcon"), StageReferance.stage.mouseX, StageReferance.stage.mouseY, DragEffect.MOVE, false);
        }

        protected function __moveEquip(_arg_1:EmbedEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            this._tipBg.visible = false;
            var _local_2:InventoryItemInfo = _arg_1.data;
            this.sendMoveItem(_local_2);
        }

        public function dragStop(_arg_1:DragEffect):void
        {
            Mouse.show();
        }

        public function getSource():IDragable
        {
            return (this);
        }

        protected function __openHoleResponse(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:Boolean = _local_2.readBoolean();
            if (((_local_4) && (this._embedStoneList)))
            {
                this._embedStoneList[_local_3].shineSuccessMC();
            };
        }

        protected function __embedResponse(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:Boolean = _local_2.readBoolean();
            if (_local_5)
            {
                switch (_local_3)
                {
                    case 1:
                        this.showEmbedMovie();
                        SoundManager.instance.pauseMusic();
                        SoundManager.instance.play("063", false, false);
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.successmsg"));
                        break;
                    case 2:
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.failmsg"));
                        break;
                    case 3:
                        this.showEmbedMovie();
                        SoundManager.instance.pauseMusic();
                        SoundManager.instance.play("063", false, false);
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.changemsg"));
                        break;
                };
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.errormsg"));
            };
        }

        private function showEmbedMovie():void
        {
            this._equipBgMC.stop();
            this._equipBgMC.visible = false;
            this._embedSuccessMc.visible = true;
            this._embedSuccessMc.gotoAndPlay(1);
            this._embedSuccessMc.addEventListener(Event.ENTER_FRAME, this.__enterFrame);
        }

        protected function __enterFrame(_arg_1:Event):void
        {
            if (this._embedSuccessMc.currentFrame == 20)
            {
                this._equipBgMC.gotoAndPlay(1);
                this._equipBgMC.visible = false;
            }
            else
            {
                if (this._embedSuccessMc.currentFrame >= this._embedSuccessMc.totalFrames)
                {
                    this._embedSuccessMc.stop();
                    this._embedSuccessMc.removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
                    this._embedSuccessMc.visible = false;
                    this._equipBgMC.visible = true;
                };
            };
        }

        private function createEmbedList(_arg_1:int):void
        {
            var _local_2:EmbedStoneCell;
            this.removeOldCells();
            if (this._hbox)
            {
                TweenMax.killTweensOf(this._hbox);
                this._hbox.x = this._hboxPos.x;
                this._hbox.y = this._hboxPos.y;
                this._lastHbox = this._hbox;
                this._lastEmbedList = this._embedStoneList;
                this._lastHbox.mouseEnabled = false;
                this._lastHbox.mouseChildren = false;
                TweenMax.to(this._lastHbox, 0.5, {
                    "x":-(this._lastHbox.width),
                    "ease":Back.easeInOut,
                    "onComplete":this.removeOldCells
                });
            };
            this._hbox = ComponentFactory.Instance.creat("asset.ddtstore.EmbedBG.embedHBox");
            this._hboxContainer.addChild(this._hbox);
            this._embedStoneList = new Vector.<EmbedStoneCell>();
            this._hbox.beginChanges();
            var _local_3:int;
            while (_local_3 < _arg_1)
            {
                _local_2 = new EmbedStoneCell(_local_3);
                _local_2.addEventListener(EmbedEvent.EMBED, this.__onEmbed);
                this._embedStoneList.push(_local_2);
                this._hbox.addChild(_local_2);
                _local_3++;
            };
            this._hbox.commitChanges();
            TweenMax.to(this._hbox, 0.5, {
                "x":(this._hboxPos.x - (this._hbox.width / 2)),
                "y":this._hboxPos.y,
                "ease":Back.easeInOut,
                "onComplete":this.removeOldCells
            });
        }

        private function removeOldCells():void
        {
            var _local_1:EmbedStoneCell;
            while (((this._lastEmbedList) && (this._lastEmbedList.length > 0)))
            {
                _local_1 = this._lastEmbedList.shift();
                _local_1.removeEventListener(EmbedEvent.EMBED, this.__onEmbed);
                _local_1.dispose();
            };
            this._lastEmbedList = null;
            TweenMax.killTweensOf(this._lastHbox);
            ObjectUtils.disposeObject(this._lastHbox);
            this._lastHbox = null;
        }

        protected function __onEmbed(event:EmbedEvent):void
        {
            var cell:EmbedStoneCell;
            var equipInfo:EquipmentTemplateInfo;
            var eInfo:EquipmentTemplateInfo;
            var result:int;
            SoundManager.instance.play("008");
            if (BaglockedManager.Instance.isBagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            this._tipBg.visible = false;
            cell = (event.target as EmbedStoneCell);
            if (this._alert)
            {
                this._alertCall = null;
                this._alert.removeEventListener(FrameEvent.RESPONSE, this.__alertResponse);
                this._alert.removeEventListener(FrameEvent.RESPONSE, this.__bindAlertResponse);
                ObjectUtils.disposeObject(this._alert);
                this._alert = null;
            };
            this._needGold = this._removeGold[cell.index];
            if (event.data)
            {
                equipInfo = ItemManager.Instance.getEquipTemplateById(event.data.TemplateID);
                if (((equipInfo) && (equipInfo.TemplateType == 12)))
                {
                    if (cell.holeID < 0)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.noOpenmsg"));
                        return;
                    };
                    eInfo = ItemManager.Instance.getEquipTemplateById(event.data.TemplateID);
                    result = this.checkCanEmbed(cell.index, eInfo);
                    switch (result)
                    {
                        case 1:
                            if (cell.info)
                            {
                                this._alertCall = function ():void
                                {
                                    SocketManager.Instance.out.sendItemEmbed(3, cell.index, event.data.Place);
                                };
                                if ((((this._info.IsBinds) && (!(event.data.IsBinds))) || ((!(this._info.IsBinds)) && (event.data.IsBinds))))
                                {
                                    this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.bindmsg"), LanguageMgr.GetTranslation("yes"), LanguageMgr.GetTranslation("no"), false, true);
                                    this._alert.addEventListener(FrameEvent.RESPONSE, this.__bindAlertResponse);
                                }
                                else
                                {
                                    this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.msg", this._needGold), LanguageMgr.GetTranslation("yes"), LanguageMgr.GetTranslation("no"), false, true);
                                    this._alert.addEventListener(FrameEvent.RESPONSE, this.__alertResponse);
                                };
                            }
                            else
                            {
                                SocketManager.Instance.out.sendItemEmbed(1, cell.index, event.data.Place);
                            };
                            break;
                        case 0:
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.samemsg"));
                            break;
                        case -1:
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.errormsg"));
                            break;
                    };
                }
                else
                {
                    this.sendMoveItem(event.data);
                };
            }
            else
            {
                if (cell.info)
                {
                    this._alertCall = function ():void
                    {
                        SocketManager.Instance.out.sendItemEmbed(2, cell.index, 0);
                    };
                    this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.store.embedBG.removeStone.msg", this._needGold), LanguageMgr.GetTranslation("yes"), LanguageMgr.GetTranslation("no"), false, true);
                    this._alert.addEventListener(FrameEvent.RESPONSE, this.__alertResponse);
                };
            };
        }

        protected function __bindAlertResponse(_arg_1:FrameEvent):void
        {
            this._alert.removeEventListener(FrameEvent.RESPONSE, this.__alertResponse);
            this._alert.removeEventListener(FrameEvent.RESPONSE, this.__bindAlertResponse);
            ObjectUtils.disposeObject(this._alert);
            this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.msg", this._needGold), LanguageMgr.GetTranslation("yes"), LanguageMgr.GetTranslation("no"), false, true);
            this._alert.addEventListener(FrameEvent.RESPONSE, this.__alertResponse);
        }

        private function __alertResponse(_arg_1:FrameEvent):void
        {
            var _local_2:QuickBuyFrame;
            this._alert.removeEventListener(FrameEvent.RESPONSE, this.__alertResponse);
            this._alert.removeEventListener(FrameEvent.RESPONSE, this.__bindAlertResponse);
            ObjectUtils.disposeObject(this._alert);
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    if (PlayerManager.Instance.Self.Gold < this._needGold)
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.changeStone.lessGoldmsg"));
                        _local_2 = ComponentFactory.Instance.creatComponentByStylename("ddtcore.QuickFrame");
                        _local_2.itemID = EquipType.GOLD_BOX;
                        _local_2.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
                        LayerManager.Instance.addToLayer(_local_2, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
                    }
                    else
                    {
                        if (this._alertCall != null)
                        {
                            this._alertCall();
                        };
                    };
            };
            this._alertCall = null;
        }

        private function findEmbedIndex(_arg_1:InventoryItemInfo):int
        {
            var _local_3:int;
            var _local_4:int;
            var _local_2:EquipmentTemplateInfo = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
            if ((!(_local_2)))
            {
                throw (new Error(("装备列表找不到该符文 id:" + _arg_1.TemplateID)));
            };
            if ((!(this._info)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.noEquipmsg"));
                return (-1);
            };
            if (_local_2.TemplateType != EquipType.EMBED_TYPE)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.errorTypemsg"));
                return (-1);
            };
            _local_3 = 0;
            while (_local_3 < MAX_HOLE)
            {
                if (this._info[("Hole" + (_local_3 + 1))] == 1)
                {
                    _local_4 = this.checkCanEmbed(_local_3, _local_2);
                    switch (_local_4)
                    {
                        case 1:
                            return (_local_3);
                        case 0:
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.samemsg"));
                            return (-1);
                        case -1:
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.errormsg"));
                            return (-1);
                    };
                };
                _local_3++;
            };
            if (_local_3 < EquipType.getEmbedHoleCount(this._info))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.openHolemsg"));
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.fullmsg"));
            };
            return (-1);
        }

        private function checkCanEmbed(_arg_1:int, _arg_2:EquipmentTemplateInfo):int
        {
            var _local_3:EquipmentTemplateInfo;
            var _local_4:int;
            if ((!(this._info)))
            {
                return (-1);
            };
            if (this._info[("Hole" + (_arg_1 + 1))] > 0)
            {
                _local_4 = 0;
                while (_local_4 < MAX_HOLE)
                {
                    if (_local_4 != _arg_1)
                    {
                        _local_3 = ItemManager.Instance.getEquipTemplateById(this._info[("Hole" + (_local_4 + 1))]);
                        if (_local_3)
                        {
                            if ((((_local_3.MainProperty1ID == _arg_2.MainProperty1ID) && (_local_3.MainProperty2ID == _arg_2.MainProperty2ID)) || ((_local_3.MainProperty1ID == _arg_2.MainProperty2ID) && (_local_3.MainProperty2ID == _arg_2.MainProperty1ID))))
                            {
                                return (0);
                            };
                        };
                    };
                    _local_4++;
                };
                return (1);
            };
            return (-1);
        }

        public function get info():InventoryItemInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:InventoryItemInfo):void
        {
            var _local_3:int;
            var _local_4:int;
            this._info = _arg_1;
            var _local_2:Boolean = ((this._info) && (!(this._lastItemID == this._info.ItemID)));
            this._embedEquipCell.info = this._info;
            if (this._info)
            {
                this._tipBg.visible = false;
                this._lastItemID = this._info.ItemID;
                if (_local_2)
                {
                    this._embedHoleCount = EquipType.getEmbedHoleCount(this._info);
                    this.createEmbedList(this._embedHoleCount);
                };
                _local_3 = 0;
                while (_local_3 < this._embedHoleCount)
                {
                    this._embedStoneList[_local_3].holeID = this._info[("Hole" + (_local_3 + 1))];
                    _local_3++;
                };
                _local_4 = this.getFisrtUnOpenHole(this._info, this._embedHoleCount);
                if (_local_4 < 0)
                {
                    this._embedOpenPanel.visible = false;
                }
                else
                {
                    this._embedOpenPanel.x = ((((this._embedStoneList[_local_4].x + this._hboxPos.x) - (this._hbox.width / 2)) - 8) + 20);
                    this._embedOpenPanel.y = ((this._hboxPos.y + this._hbox.height) + 7);
                    this._embedOpenPanel.index = _local_4;
                    this._embedOpenPanel.info = this._info;
                    this._embedOpenPanel.visible = true;
                };
                this._hbox.visible = true;
                this._equipBgMC.gotoAndPlay(1);
                this._equipBgMC.visible = true;
            }
            else
            {
                if (this._hbox)
                {
                    this._hbox.visible = false;
                };
                this._tipBg.visible = true;
                this._equipBgMC.stop();
                this._equipBgMC.visible = false;
                this._embedOpenPanel.visible = false;
            };
        }

        public function setCell(_arg_1:BagCell):void
        {
            var _local_3:EquipmentTemplateInfo;
            var _local_4:int;
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if ((!(_arg_1)))
            {
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.info as InventoryItemInfo);
            if ((!(_local_2)))
            {
                return;
            };
            this._tipBg.visible = false;
            if (_local_2.CategoryID == EquipType.EQUIP)
            {
                _local_3 = ItemManager.Instance.getEquipTemplateById(_local_2.TemplateID);
                if (_local_3.TemplateType == 12)
                {
                    if ((!(this._info)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.noEquipmsg"));
                        return;
                    };
                    _local_4 = this.findEmbedIndex(_local_2);
                    if (_local_4 > -1)
                    {
                        SocketManager.Instance.out.sendItemEmbed(1, _local_4, _local_2.Place);
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.openHole.fullmsg"));
                    };
                }
                else
                {
                    this.sendMoveItem(_local_2);
                };
            };
        }

        private function sendMoveItem(_arg_1:InventoryItemInfo):void
        {
            var _local_2:EquipmentTemplateInfo;
            if ((!(_arg_1)))
            {
                return;
            };
            if (_arg_1.CategoryID == EquipType.EQUIP)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(_arg_1.TemplateID);
                if (_local_2.TemplateType != 12)
                {
                    if (_arg_1)
                    {
                        if (_arg_1.getRemainDate() < 0)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.fusion.AccessoryDragInArea.overdue"));
                        };
                        if (EquipType.getEmbedHoleCount(_arg_1) == 0)
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.store.embedBG.cannotEmbed"));
                        }
                        else
                        {
                            if (_arg_1.CanEquip)
                            {
                                SocketManager.Instance.out.sendMoveGoods(_arg_1.BagType, _arg_1.Place, BagInfo.STOREBAG, 0, 1);
                            };
                        };
                    };
                };
            };
        }

        public function dragDrop(_arg_1:DragEffect):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:StoreBagCell = (_arg_1.source as StoreBagCell);
            if ((!(_local_2)))
            {
                return;
            };
            var _local_3:InventoryItemInfo = (_local_2.info as InventoryItemInfo);
            this.sendMoveItem(_local_3);
            _arg_1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
        }

        private function getFisrtUnOpenHole(_arg_1:InventoryItemInfo, _arg_2:int):int
        {
            var _local_3:int;
            while (_local_3 < _arg_2)
            {
                if (this._info[("Hole" + (_local_3 + 1))] == -1)
                {
                    return (_local_3);
                };
                _local_3++;
            };
            return (-1);
        }

        public function refreshData(_arg_1:Dictionary):void
        {
            this._embedSuccessMc.stop();
            this._embedSuccessMc.removeEventListener(Event.ENTER_FRAME, this.__enterFrame);
            this._embedSuccessMc.visible = false;
            this.info = PlayerManager.Instance.Self.StoreBag.items[0];
        }

        public function updateData():void
        {
        }

        public function startShine():void
        {
            this._embedEquipCell.shinerPos = new Point(2, 2);
            this._embedEquipCell.startShine();
        }

        public function startEmbedShine():void
        {
            var _local_1:EmbedStoneCell;
            if (this._embedStoneList)
            {
                for each (_local_1 in this._embedStoneList)
                {
                    if (_local_1.holeID > 0)
                    {
                        _local_1.startShine();
                    };
                };
            };
        }

        public function stopShine():void
        {
            var _local_1:EmbedStoneCell;
            this._embedEquipCell.stopShine();
            for each (_local_1 in this._embedStoneList)
            {
                _local_1.stopShine();
            };
        }

        public function show():void
        {
            this.visible = true;
            this.refreshData(null);
        }

        public function hide():void
        {
            this.visible = false;
        }

        public function dispose():void
        {
            var _local_1:EmbedStoneCell;
            this.removeEvent();
            SoundManager.instance.resumeMusic();
            SoundManager.instance.stop("063");
            SoundManager.instance.stop("064");
            ObjectUtils.disposeObject(this._removeBtn);
            this._removeBtn = null;
            ObjectUtils.disposeObject(this._embedEquipCell);
            this._embedEquipCell = null;
            ObjectUtils.disposeObject(this._embedTextTip);
            this._embedTextTip = null;
            this.removeOldCells();
            while (((this._embedStoneList) && (this._embedStoneList.length > 0)))
            {
                _local_1 = this._embedStoneList.shift();
                _local_1.removeEventListener(EmbedEvent.EMBED, this.__onEmbed);
                _local_1.dispose();
            };
            this._embedStoneList = null;
            TweenMax.killTweensOf(this._hbox);
            ObjectUtils.disposeObject(this._hbox);
            this._hbox = null;
            ObjectUtils.disposeObject(this._hboxContainer);
            this._hboxContainer = null;
            ObjectUtils.disposeObject(this._hboxMask);
            this._hboxMask = null;
            ObjectUtils.disposeObject(this._embedOpenPanel);
            this._embedOpenPanel = null;
            ObjectUtils.disposeObject(this._equipBgMC);
            this._equipBgMC = null;
            ObjectUtils.disposeObject(this._embedSuccessMc);
            this._embedSuccessMc = null;
            ObjectUtils.disposeObject(this._alert);
            this._alert = null;
            this._info = null;
            this._alertCall = null;
            this._removeGold.length = 0;
            this._removeGold = null;
        }

        public function openHelp():void
        {
            var _local_1:DisplayObject = ComponentFactory.Instance.creat("ddtstore.EmbedHelpPrompt");
            var _local_2:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
            _local_2.setView(_local_1);
            _local_2.titleText = LanguageMgr.GetTranslation("store.StoreIIEmbedBG.say");
            LayerManager.Instance.addToLayer(_local_2, LayerManager.STAGE_DYANMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }


    }
}//package store.view.embed

