// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.cell.LockBagCell

package bagAndInfo.cell
{
    import flash.display.Bitmap;
    import flash.utils.Timer;
    import ddt.data.goods.BagCellInfo;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import ddt.data.goods.InventoryItemInfo;
    import bagAndInfo.bag.SellGoodsFrame;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.DisplayObject;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import petsBag.view.item.SkillItem;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.manager.DragManager;
    import ddt.manager.SocketManager;
    import ddt.data.BagInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.data.EquipType;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import bagAndInfo.bag.SellGoodsBtn;
    import bagAndInfo.bag.ContinueGoodsBtn;
    import bagAndInfo.bag.BreakGoodsBtn;
    import ddt.manager.SoundManager;
    import ddt.events.CellEvent;
    import flash.geom.Point;
    import farm.view.FarmFieldBlock;
    import baglocked.BagLockedController;
    import baglocked.SetPassEvent;
    import flash.events.Event;
    import com.pickgliss.ui.vo.AlertInfo;
    import flash.display.Sprite;
    import flash.filters.ColorMatrixFilter;
    import com.greensock.TweenMax;
    import com.pickgliss.utils.ObjectUtils;

    public class LockBagCell extends BaseCell 
    {

        private static var NEXT_FRAM:int = 33;
        private static var OVER_FRAM:int = 58;
        private static var STRAT_FRAM:int = 1;

        protected var _place:int;
        protected var _bgOverDate:Bitmap;
        protected var _cellMouseOverBg:Bitmap;
        protected var _cellMouseOverFormer:Bitmap;
        private var _mouseOverEffBoolean:Boolean;
        protected var _bagType:int;
        private var _bagIndex:int;
        private var _lastTime:Date;
        private var time:int = 20;
        private var _oneFrame:Number;
        private var _currentFrame:int = 0;
        private var _timer:Timer;
        private var bagCellinfo:BagCellInfo;
        private var _euipQualityBg:ScaleFrameImage;
        private var _isLighting:Boolean;
        protected var temInfo:InventoryItemInfo;
        private var _sellFrame:SellGoodsFrame;

        public function LockBagCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:DisplayObject=null, _arg_5:Boolean=true)
        {
            this._mouseOverEffBoolean = _arg_5;
            this._place = _arg_1;
            super(((_arg_4) ? _arg_4 : ComponentFactory.Instance.creatComponentByStylename("core.bagAndInfo.bagCellBgAsset")), _arg_2, _arg_3);
        }

        public function set mouseOverEffBoolean(_arg_1:Boolean):void
        {
            this._mouseOverEffBoolean = _arg_1;
        }

        public function get bagType():int
        {
            return (this._bagType);
        }

        public function set bagType(_arg_1:int):void
        {
            this._bagType = _arg_1;
        }

        override protected function createChildren():void
        {
            super.createChildren();
            locked = false;
            this._bgOverDate = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.overDateBgAsset");
            if (this._mouseOverEffBoolean == true)
            {
                this._cellMouseOverBg = ComponentFactory.Instance.creatBitmap("bagAndInfo.cell.bagCellOverBgAsset");
                this._cellMouseOverFormer = ComponentFactory.Instance.creatBitmap("core.bagAndInfo.bagCellOverBgAsset");
                this._cellMouseOverFormer.x = -10;
                this._cellMouseOverFormer.y = -10;
                addChild(this._cellMouseOverFormer);
            };
            addChild(this._bgOverDate);
            _tbxCount = ComponentFactory.Instance.creatComponentByStylename("BagCellCountText");
            _tbxCount.mouseEnabled = false;
            addChild(_tbxCount);
            this.updateCount();
            this.checkOverDate();
            this.updateBgVisible(false);
        }

        public function initeuipQualityBg(_arg_1:int):void
        {
            if (this._euipQualityBg == null)
            {
                this._euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
                this._euipQualityBg.width = 43;
                this._euipQualityBg.height = 43;
            };
            if (_arg_1 == 0)
            {
                this._euipQualityBg.visible = false;
            }
            else
            {
                if (_arg_1 == 1)
                {
                    addChildAt(this._euipQualityBg, 1);
                    this._euipQualityBg.setFrame(_arg_1);
                    this._euipQualityBg.visible = true;
                }
                else
                {
                    if (_arg_1 == 2)
                    {
                        addChildAt(this._euipQualityBg, 1);
                        this._euipQualityBg.setFrame(_arg_1);
                        this._euipQualityBg.visible = true;
                    }
                    else
                    {
                        if (_arg_1 == 3)
                        {
                            addChildAt(this._euipQualityBg, 1);
                            this._euipQualityBg.setFrame(_arg_1);
                            this._euipQualityBg.visible = true;
                        }
                        else
                        {
                            if (_arg_1 == 4)
                            {
                                addChildAt(this._euipQualityBg, 1);
                                this._euipQualityBg.setFrame(_arg_1);
                                this._euipQualityBg.visible = true;
                            }
                            else
                            {
                                if (_arg_1 == 5)
                                {
                                    addChildAt(this._euipQualityBg, 1);
                                    this._euipQualityBg.setFrame(_arg_1);
                                    this._euipQualityBg.visible = true;
                                };
                            };
                        };
                    };
                };
            };
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:EquipmentTemplateInfo;
            super.info = _arg_1;
            this.updateCount();
            this.checkOverDate();
            if ((info is InventoryItemInfo))
            {
                this.locked = this.info["lock"];
            };
            if (info == null)
            {
                _local_2 = null;
                this.initeuipQualityBg(0);
            };
            if (info != null)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(info.TemplateID);
            };
            if (((!(_local_2 == null)) && (info.Property8 == "0")))
            {
                this.initeuipQualityBg(_local_2.QualityID);
            }
            else
            {
                this.initeuipQualityBg(0);
            };
        }

        override protected function onMouseClick(_arg_1:MouseEvent):void
        {
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
            super.onMouseOver(_arg_1);
            this.updateBgVisible(true);
        }

        override protected function onMouseOut(_arg_1:MouseEvent):void
        {
            super.onMouseOut(_arg_1);
            this.updateBgVisible(false);
        }

        public function onParentMouseOver(_arg_1:Bitmap):void
        {
            if ((!(this._cellMouseOverBg)))
            {
                this._cellMouseOverBg = _arg_1;
                addChild(this._cellMouseOverBg);
                super.setChildIndex(this._cellMouseOverBg, 0);
                this.updateBgVisible(true);
            };
        }

        public function onParentMouseOut():void
        {
            if (this._cellMouseOverBg)
            {
                this.updateBgVisible(false);
                this._cellMouseOverBg = null;
            };
        }

        protected function updateBgVisible(_arg_1:Boolean):void
        {
            if (this._cellMouseOverBg)
            {
                this._cellMouseOverBg.visible = _arg_1;
                this._cellMouseOverFormer.visible = _arg_1;
                setChildIndex(this._cellMouseOverFormer, (numChildren - 1));
            };
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            var _local_3:InventoryItemInfo;
            var _local_4:InventoryItemInfo;
            var _local_5:EquipmentTemplateInfo;
            var _local_6:BaseAlerFrame;
            if ((_arg_1.source is SkillItem))
            {
                return;
            };
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                _arg_1.action = DragEffect.NONE;
                super.dragStop(_arg_1);
                return;
            };
            var _local_2:int = PlayerManager.Instance.Self.bagVibleType;
            if ((_arg_1.data as InventoryItemInfo))
            {
                _local_3 = (_arg_1.data as InventoryItemInfo);
                if ((((((_local_2 == 1) || (_local_2 == 2)) || (_local_2 == 3)) || (_local_2 == 4)) && (_local_3.Place > 30)))
                {
                    _arg_1.action = DragEffect.NONE;
                    return;
                };
            };
            if ((_arg_1.data is InventoryItemInfo))
            {
                _local_4 = (_arg_1.data as InventoryItemInfo);
                if (locked)
                {
                    if (_local_4 == this.info)
                    {
                        this.locked = false;
                        DragManager.acceptDrag(this);
                    }
                    else
                    {
                        DragManager.acceptDrag(this, DragEffect.NONE);
                    };
                }
                else
                {
                    if (((this._bagType == 11) || (_local_4.BagType == 11)))
                    {
                        if (_arg_1.action == DragEffect.SPLIT)
                        {
                            _arg_1.action = DragEffect.NONE;
                        }
                        else
                        {
                            if (this._bagType != 11)
                            {
                                SocketManager.Instance.out.sendMoveGoods(BagInfo.CONSORTIA, _local_4.Place, this._bagType, this.place, _local_4.Count);
                                _arg_1.action = DragEffect.NONE;
                            }
                            else
                            {
                                if (this._bagType == _local_4.BagType)
                                {
                                    if (this.place >= (PlayerManager.Instance.Self.consortiaInfo.StoreLevel * 10))
                                    {
                                        _arg_1.action = DragEffect.NONE;
                                    }
                                    else
                                    {
                                        SocketManager.Instance.out.sendMoveGoods(_local_4.BagType, _local_4.Place, _local_4.BagType, this.place, _local_4.Count);
                                    };
                                }
                                else
                                {
                                    if (PlayerManager.Instance.Self.consortiaInfo.StoreLevel < 1)
                                    {
                                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.cellDoubleClick"));
                                        _arg_1.action = DragEffect.NONE;
                                    }
                                    else
                                    {
                                        SocketManager.Instance.out.sendMoveGoods(_local_4.BagType, _local_4.Place, this._bagType, this.place, _local_4.Count);
                                        _arg_1.action = DragEffect.NONE;
                                    };
                                };
                            };
                        };
                    }
                    else
                    {
                        if (_local_4.BagType == this._bagType)
                        {
                            if ((!(this.itemInfo)))
                            {
                                if (_local_4.isMoveSpace)
                                {
                                    PlayerManager.Instance.Self.bagVibleType = 0;
                                    SocketManager.Instance.out.sendMoveGoods(_local_4.BagType, _local_4.Place, _local_4.BagType, this.place, _local_4.Count);
                                };
                                _arg_1.action = DragEffect.NONE;
                                return;
                            };
                            _local_5 = ItemManager.Instance.getEquipTemplateById(this.itemInfo.TemplateID);
                            if (((_local_5) && (_local_4.Place <= 30)))
                            {
                                if (_local_4.NeedLevel > PlayerManager.Instance.Self.Grade)
                                {
                                    return (MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.data.player.SelfInfo.need")));
                                };
                            };
                            if ((((((_local_4.CategoryID == this.itemInfo.CategoryID) && (_local_4.Place <= 30)) && (((_local_4.BindType == 1) || (_local_4.BindType == 2)) || (_local_4.BindType == 3))) && (this.itemInfo.IsBinds == false)) && (EquipType.canEquip(_local_4))))
                            {
                                _local_6 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.view.bagII.BagIIView.BindsInfo"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND);
                                _local_6.addEventListener(FrameEvent.RESPONSE, this.__onCellResponse);
                                this.temInfo = _local_4;
                            }
                            else
                            {
                                if (EquipType.isHealStone(_local_4))
                                {
                                    if (PlayerManager.Instance.Self.Grade >= int(_local_4.Property1))
                                    {
                                        SocketManager.Instance.out.sendMoveGoods(_local_4.BagType, _local_4.Place, _local_4.BagType, this.place, _local_4.Count);
                                        _arg_1.action = DragEffect.NONE;
                                    }
                                    else
                                    {
                                        if (_arg_1.action == DragEffect.MOVE)
                                        {
                                            if ((_arg_1.source is BagCell))
                                            {
                                                BagCell(_arg_1.source).locked = false;
                                            };
                                        }
                                        else
                                        {
                                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade", _local_4.Property1));
                                        };
                                    };
                                }
                                else
                                {
                                    SocketManager.Instance.out.sendMoveGoods(_local_4.BagType, _local_4.Place, _local_4.BagType, this.place, _local_4.Count);
                                    _arg_1.action = DragEffect.NONE;
                                };
                            };
                        }
                        else
                        {
                            if (_local_4.BagType == BagInfo.STOREBAG)
                            {
                                if (((_local_4.CategoryID == EquipType.TEXP) || (_local_4.CategoryID == EquipType.FOOD)))
                                {
                                    SocketManager.Instance.out.sendMoveGoods(_local_4.BagType, _local_4.Place, this._bagType, -1, _local_4.Count);
                                };
                                _arg_1.action = DragEffect.NONE;
                            }
                            else
                            {
                                _arg_1.action = DragEffect.NONE;
                            };
                        };
                    };
                    DragManager.acceptDrag(this);
                };
            }
            else
            {
                if ((_arg_1.data is SellGoodsBtn))
                {
                    if ((((!(locked)) && (_info)) && (!(this._bagType == 11))))
                    {
                        locked = true;
                        DragManager.acceptDrag(this);
                    };
                }
                else
                {
                    if ((_arg_1.data is ContinueGoodsBtn))
                    {
                        if ((((!(locked)) && (_info)) && (!(this._bagType == 11))))
                        {
                            locked = true;
                            DragManager.acceptDrag(this, DragEffect.NONE);
                        };
                    }
                    else
                    {
                        if ((_arg_1.data is BreakGoodsBtn))
                        {
                            if (((!(locked)) && (_info)))
                            {
                                DragManager.acceptDrag(this);
                            };
                        };
                    };
                };
            };
        }

        private function sendDefy():void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.canEquip(this.temInfo))
            {
                SocketManager.Instance.out.sendMoveGoods(this.temInfo.BagType, this.temInfo.Place, this.temInfo.BagType, this.place, this.temInfo.Count);
            };
        }

        override public function dragStart():void
        {
            super.dragStart();
            if (((_info) && (_pic.numChildren > 0)))
            {
                dispatchEvent(new CellEvent(CellEvent.DRAGSTART, this.info, true));
            };
        }

        public function getStagePos():Point
        {
            return (this.localToGlobal(new Point(0, 0)));
        }

        override public function dragStop(_arg_1:DragEffect):void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new CellEvent(CellEvent.DRAGSTOP, null, true));
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (((_arg_1.action == DragEffect.MOVE) && (_arg_1.target == null)))
            {
                if (((_local_2) && (_local_2.BagType == 11)))
                {
                    _arg_1.action = DragEffect.NONE;
                    super.dragStop(_arg_1);
                }
                else
                {
                    if (((_local_2) && (_local_2.BagType == 12)))
                    {
                        locked = false;
                    }
                    else
                    {
                        if (((_local_2) && (_local_2.BagType == 21)))
                        {
                            locked = false;
                        }
                        else
                        {
                            locked = false;
                            this.sellItem();
                        };
                    };
                };
            }
            else
            {
                if (((_arg_1.action == DragEffect.SPLIT) && (_arg_1.target == null)))
                {
                    locked = false;
                }
                else
                {
                    if ((_arg_1.target is FarmFieldBlock))
                    {
                        locked = false;
                        if (_local_2.Property1 != "31")
                        {
                            this.sellItem();
                        }
                        else
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.beadSystem.beadCanntDestory"));
                        };
                    }
                    else
                    {
                        super.dragStop(_arg_1);
                    };
                };
            };
        }

        public function dragCountStart(_arg_1:int):void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:String;
            if (((((_info) && (!(locked))) && (stage)) && (!(_arg_1 == 0))))
            {
                _local_2 = this.itemInfo;
                _local_3 = DragEffect.MOVE;
                if (_arg_1 != this.itemInfo.Count)
                {
                    _local_2 = new InventoryItemInfo();
                    _local_2.ItemID = this.itemInfo.ItemID;
                    _local_2.BagType = this.itemInfo.BagType;
                    _local_2.Place = this.itemInfo.Place;
                    _local_2.IsBinds = this.itemInfo.IsBinds;
                    _local_2.BeginDate = this.itemInfo.BeginDate;
                    _local_2.ValidDate = this.itemInfo.ValidDate;
                    _local_2.Count = _arg_1;
                    _local_2.NeedSex = this.itemInfo.NeedSex;
                    _local_3 = DragEffect.SPLIT;
                };
                if (DragManager.startDrag(this, _local_2, createDragImg(), stage.mouseX, stage.mouseY, _local_3))
                {
                    locked = true;
                };
            };
        }

        public function sellItem():void
        {
            if (EquipType.isValuableEquip(info))
            {
                if (PlayerManager.Instance.Self.bagPwdState)
                {
                    if (PlayerManager.Instance.Self.bagLocked)
                    {
                        BaglockedManager.Instance.show();
                        BagLockedController.Instance.addEventListener(SetPassEvent.CANCELBTN, this.__cancelBtn);
                        return;
                    };
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip1"));
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip1"));
                    return;
                };
            }
            else
            {
                if (EquipType.isEmbed(info))
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip2"));
                }
                else
                {
                    if (EquipType.isPetSpeciallFood(info))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
                    }
                    else
                    {
                        if ((!(info.CanDelete)))
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
                        }
                        else
                        {
                            if (PlayerManager.Instance.Self.bagLocked)
                            {
                                BaglockedManager.Instance.show();
                                return;
                            };
                            this.showSellFrame();
                        };
                    };
                };
            };
        }

        private function showSellFrame():void
        {
            if (this._sellFrame == null)
            {
                this._sellFrame = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame");
                this._sellFrame.addEventListener(SellGoodsFrame.CANCEL, this.disposeSellFrame);
                this._sellFrame.addEventListener(SellGoodsFrame.OK, this.disposeSellFrame);
                this._sellFrame.itemInfo = InventoryItemInfo(info);
            };
            LayerManager.Instance.addToLayer(this._sellFrame, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function disposeSellFrame(_arg_1:Event):void
        {
            if (this._sellFrame)
            {
                this._sellFrame.dispose();
            };
            this._sellFrame = null;
        }

        protected function __onCellResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (EquipType.isHealStone(info))
                {
                    if (PlayerManager.Instance.Self.Grade >= int(info.Property1))
                    {
                        this.sendDefy();
                    }
                    else
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.HealStone.ErrorGrade", info.Property1));
                    };
                }
                else
                {
                    this.sendDefy();
                };
            };
        }

        private function getAlertInfo():AlertInfo
        {
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.autoDispose = true;
            _local_1.showCancel = (_local_1.showSubmit = true);
            _local_1.enterEnable = true;
            _local_1.escEnable = true;
            _local_1.moveEnable = false;
            _local_1.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _local_1.data = LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.sure").replace("{0}", ((InventoryItemInfo(_info).Count * _info.ReclaimValue) + ((_info.ReclaimType == 1) ? LanguageMgr.GetTranslation("shop.ShopIIShoppingCarItem.gold") : ((_info.ReclaimType == 2) ? LanguageMgr.GetTranslation("tank.gameover.takecard.gifttoken") : ""))));
            return (_local_1);
        }

        private function confirmCancel():void
        {
            locked = false;
        }

        public function get place():int
        {
            return (this._place);
        }

        public function get bagIndex():int
        {
            return (this._bagIndex);
        }

        public function get lastTime():Date
        {
            return (this._lastTime);
        }

        override public function get itemInfo():InventoryItemInfo
        {
            return (_info as InventoryItemInfo);
        }

        public function replaceBg(_arg_1:Sprite):void
        {
            _bg = _arg_1;
        }

        public function updateCount():void
        {
            if (_tbxCount)
            {
                if ((((_info) && (this.itemInfo)) && (this.itemInfo.MaxCount > 1)))
                {
                    _tbxCount.text = String(this.itemInfo.Count);
                    _tbxCount.visible = true;
                    addChild(_tbxCount);
                }
                else
                {
                    _tbxCount.visible = false;
                };
            };
        }

        public function checkOverDate():void
        {
            if (this._bgOverDate)
            {
                if (((this.itemInfo) && (this.itemInfo.getRemainDate() <= 0)))
                {
                    this._bgOverDate.visible = true;
                    addChild(this._bgOverDate);
                    _pic.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])];
                }
                else
                {
                    this._bgOverDate.visible = false;
                    if (_pic)
                    {
                        _pic.filters = [];
                    };
                };
            };
        }

        public function set BGVisible(_arg_1:Boolean):void
        {
            _bg.visible = _arg_1;
        }

        private function __cancelBtn(_arg_1:SetPassEvent):void
        {
            BagLockedController.Instance.removeEventListener(SetPassEvent.CANCELBTN, this.__cancelBtn);
            this.disposeSellFrame(null);
        }

        public function set light(_arg_1:Boolean):void
        {
            this._isLighting = _arg_1;
            if (_arg_1)
            {
                this.showEffect();
            }
            else
            {
                this.hideEffect();
            };
        }

        private function showEffect():void
        {
            TweenMax.to(this, 0.5, {
                "repeat":-1,
                "yoyo":true,
                "glowFilter":{
                    "color":16777011,
                    "alpha":1,
                    "blurX":8,
                    "blurY":8,
                    "strength":3,
                    "inner":true
                }
            });
        }

        private function hideEffect():void
        {
            TweenMax.killChildTweensOf(this.parent, false);
            this.filters = null;
        }

        public function get isLighting():Boolean
        {
            return (this._isLighting);
        }

        override public function dispose():void
        {
            if (_tbxCount)
            {
                ObjectUtils.disposeObject(_tbxCount);
            };
            _tbxCount = null;
            if (this._bgOverDate)
            {
                ObjectUtils.disposeObject(this._bgOverDate);
            };
            this._bgOverDate = null;
            if (this._cellMouseOverBg)
            {
                ObjectUtils.disposeObject(this._cellMouseOverBg);
            };
            this._cellMouseOverBg = null;
            if (this._cellMouseOverFormer)
            {
                ObjectUtils.disposeObject(this._cellMouseOverFormer);
            };
            this._cellMouseOverFormer = null;
            if (this._euipQualityBg)
            {
                ObjectUtils.disposeObject(this._euipQualityBg);
            };
            this._euipQualityBg = null;
            TweenMax.killChildTweensOf(this.parent, false);
            super.dispose();
        }


    }
}//package bagAndInfo.cell

