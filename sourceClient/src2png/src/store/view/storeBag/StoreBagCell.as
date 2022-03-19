// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.storeBag.StoreBagCell

package store.view.storeBag
{
    import bagAndInfo.cell.BagCell;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.Sprite;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.manager.PlayerManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.SocketManager;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.DragManager;
    import store.events.StoreDargEvent;
    import store.StoreController;
    import store.events.StoreIIEvent;
    import baglocked.BaglockedManager;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.data.BagInfo;
    import com.greensock.TweenMax;

    public class StoreBagCell extends BagCell 
    {

        private var _light:Boolean;

        public function StoreBagCell(_arg_1:int, _arg_2:ItemTemplateInfo=null, _arg_3:Boolean=true, _arg_4:Sprite=null)
        {
            super(_arg_1, _arg_2, _arg_3, ((_arg_4) ? _arg_4 : ComponentFactory.Instance.creatComponentByStylename("core.ddtStore.bagCellBgAsset")));
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:EquipmentTemplateInfo;
            super.info = _arg_1;
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
            };
            updateCount();
        }

        private function initeuipQualityBg(_arg_1:int):void
        {
            if (_euipQualityBg == null)
            {
                _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
                _euipQualityBg.width = 45;
                _euipQualityBg.height = 45;
            };
            if (_arg_1 == 0)
            {
                _euipQualityBg.visible = false;
            }
            else
            {
                if (_arg_1 == 1)
                {
                    addChildAt(_euipQualityBg, 1);
                    _euipQualityBg.setFrame(_arg_1);
                    _euipQualityBg.visible = true;
                }
                else
                {
                    if (_arg_1 == 2)
                    {
                        addChildAt(_euipQualityBg, 1);
                        _euipQualityBg.setFrame(_arg_1);
                        _euipQualityBg.visible = true;
                    }
                    else
                    {
                        if (_arg_1 == 3)
                        {
                            addChildAt(_euipQualityBg, 1);
                            _euipQualityBg.setFrame(_arg_1);
                            _euipQualityBg.visible = true;
                        }
                        else
                        {
                            if (_arg_1 == 4)
                            {
                                addChildAt(_euipQualityBg, 1);
                                _euipQualityBg.setFrame(_arg_1);
                                _euipQualityBg.visible = true;
                            }
                            else
                            {
                                if (_arg_1 == 5)
                                {
                                    addChildAt(_euipQualityBg, 1);
                                    _euipQualityBg.setFrame(_arg_1);
                                    _euipQualityBg.visible = true;
                                };
                            };
                        };
                    };
                };
            };
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if ((!(this.checkBagType(_local_2))))
            {
                return;
            };
            SocketManager.Instance.out.sendMoveGoods(_local_2.BagType, _local_2.Place, bagType, this.getPlace(_local_2), 1);
            _arg_1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
        }

        override public function dragStart():void
        {
            if ((((_info) && (!(locked))) && (stage)))
            {
                if (DragManager.startDrag(this, _info, createDragImg(), stage.mouseX, stage.mouseY, DragEffect.MOVE, true, false, true))
                {
                    locked = true;
                    dispatchEvent(new StoreDargEvent(this.info, StoreDargEvent.START_DARG, true));
                };
                if (StoreController.instance.transform)
                {
                    StoreController.instance.Model.dispatchEvent(new StoreIIEvent(StoreIIEvent.TRANSFER_LIGHT, StoreController.instance.transform, false));
                };
            };
        }

        override public function dragStop(_arg_1:DragEffect):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                _arg_1.action = DragEffect.NONE;
                super.dragStop(_arg_1);
                BaglockedManager.Instance.show();
                dispatchEvent(new StoreDargEvent(this.info, StoreDargEvent.STOP_DARG, true));
                return;
            };
            if (((_arg_1.action == DragEffect.MOVE) && (_arg_1.target == null)))
            {
                locked = false;
                sellItem();
            }
            else
            {
                if (((_arg_1.action == DragEffect.SPLIT) && (_arg_1.target == null)))
                {
                    locked = false;
                }
                else
                {
                    super.dragStop(_arg_1);
                };
            };
            if (this.info)
            {
                if (((SavePointManager.Instance.isInSavePoint(67)) && (!(TaskManager.instance.isNewHandTaskCompleted(28)))))
                {
                    NewHandContainer.Instance.clearArrowByID(ArrowType.STR_WEAPON);
                };
            };
            if (StoreController.instance.isShine)
            {
                StoreController.instance.Model.dispatchEvent(new StoreIIEvent(StoreIIEvent.TRANSFER_LIGHT, StoreController.instance.transform, true));
            };
            dispatchEvent(new StoreDargEvent(this.info, StoreDargEvent.STOP_DARG, true));
        }

        private function getPlace(_arg_1:InventoryItemInfo):int
        {
            return (-1);
        }

        private function checkBagType(_arg_1:InventoryItemInfo):Boolean
        {
            if (_arg_1 == null)
            {
                return (false);
            };
            if (_arg_1.BagType == bagType)
            {
                return (false);
            };
            if (bagType == BagInfo.EQUIPBAG)
            {
                return (true);
            };
            return (false);
        }

        public function set light(_arg_1:Boolean):void
        {
            this._light = _arg_1;
            if (_arg_1)
            {
                this.showEffect();
            }
            else
            {
                this.hideEffect();
            };
        }

        public function get light():Boolean
        {
            return (this._light);
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

        override public function dispose():void
        {
            TweenMax.killChildTweensOf(this.parent, false);
            this.filters = null;
            super.dispose();
        }


    }
}//package store.view.storeBag

