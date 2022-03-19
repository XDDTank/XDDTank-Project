// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.SellGoodsBtn

package bagAndInfo.bag
{
    import com.pickgliss.ui.controls.TextButton;
    import ddt.interfaces.IDragable;
    import flash.filters.ColorMatrixFilter;
    import bagAndInfo.cell.LockBagCell;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.Bitmap;
    import ddt.manager.DragManager;
    import bagAndInfo.cell.DragEffect;
    import ddt.interfaces.ICell;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.data.EquipType;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import flash.events.Event;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import baglocked.BagLockedController;
    import baglocked.SetPassEvent;

    public class SellGoodsBtn extends TextButton implements IDragable 
    {

        public static const StopSell:String = "stopsell";

        public var isActive:Boolean = false;
        private var sellFrame:SellGoodsFrame;
        private var lightingFilter:ColorMatrixFilter;
        private var _dragTarget:LockBagCell;

        public function SellGoodsBtn()
        {
            this.init();
        }

        override protected function init():void
        {
            buttonMode = true;
            super.init();
        }

        public function dragStart(_arg_1:Number, _arg_2:Number):void
        {
            this.isActive = true;
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.sellIconAsset");
            DragManager.startDrag(this, this, _local_3, _arg_1, _arg_2, DragEffect.MOVE, false);
        }

        public function dragStop(_arg_1:DragEffect):void
        {
            var _local_2:LockBagCell;
            this.isActive = false;
            if (((PlayerManager.Instance.Self.bagLocked) && (_arg_1.target is ICell)))
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (((_arg_1.action == DragEffect.MOVE) && (_arg_1.target is ICell)))
            {
                _local_2 = (_arg_1.target as LockBagCell);
                if (((_local_2) && (_local_2.info)))
                {
                    if (EquipType.isValuableEquip(_local_2.info))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip1"));
                        _local_2.locked = false;
                        dispatchEvent(new Event(StopSell));
                    }
                    else
                    {
                        if (EquipType.isEmbed(_local_2.info))
                        {
                            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.SellGoodsBtn.CantSellEquip2"));
                            _local_2.locked = false;
                            dispatchEvent(new Event(StopSell));
                        }
                        else
                        {
                            if (EquipType.isPetSpeciallFood(_local_2.info))
                            {
                                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
                                _local_2.locked = false;
                                dispatchEvent(new Event(StopSell));
                            }
                            else
                            {
                                if ((!(_local_2.info.CanDelete)))
                                {
                                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.bagAndInfo.sell.CanNotSell"));
                                    _local_2.locked = false;
                                    dispatchEvent(new Event(StopSell));
                                }
                                else
                                {
                                    this._dragTarget = _local_2;
                                    this.showSellFrame();
                                };
                            };
                        };
                    };
                }
                else
                {
                    dispatchEvent(new Event(StopSell));
                };
            }
            else
            {
                dispatchEvent(new Event(StopSell));
            };
        }

        private function showSellFrame():void
        {
            SoundManager.instance.play("008");
            if (this.sellFrame == null)
            {
                this.sellFrame = ComponentFactory.Instance.creatComponentByStylename("sellGoodsFrame");
                this.sellFrame.itemInfo = this._dragTarget.itemInfo;
                this.sellFrame.addEventListener(SellGoodsFrame.CANCEL, this.cancelBack);
                this.sellFrame.addEventListener(SellGoodsFrame.OK, this.confirmBack);
            };
            LayerManager.Instance.addToLayer(this.sellFrame, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        public function getSource():IDragable
        {
            return (this);
        }

        public function getDragData():Object
        {
            return (this);
        }

        private function confirmBack(_arg_1:Event):void
        {
            if (stage)
            {
                this.dragStart(stage.mouseX, stage.mouseY);
            };
            this.__disposeSellFrame();
        }

        private function setUpLintingFilter():void
        {
            var _local_1:Array = new Array();
            _local_1 = _local_1.concat([1, 0, 0, 0, 25]);
            _local_1 = _local_1.concat([0, 1, 0, 0, 25]);
            _local_1 = _local_1.concat([0, 0, 1, 0, 25]);
            _local_1 = _local_1.concat([0, 0, 0, 1, 0]);
            this.lightingFilter = new ColorMatrixFilter(_local_1);
        }

        override public function dispose():void
        {
            if (this._dragTarget)
            {
                this._dragTarget.locked = false;
            };
            PlayerManager.Instance.Self.Bag.unLockAll();
            this.__disposeSellFrame();
            super.dispose();
        }

        private function __cancelBtn(_arg_1:SetPassEvent):void
        {
            BagLockedController.Instance.removeEventListener(SetPassEvent.CANCELBTN, this.__cancelBtn);
            this._dragTarget = null;
            this.__disposeSellFrame();
        }

        private function __disposeSellFrame():void
        {
            if (this.sellFrame)
            {
                this.sellFrame.removeEventListener(SellGoodsFrame.CANCEL, this.cancelBack);
                this.sellFrame.removeEventListener(SellGoodsFrame.OK, this.confirmBack);
                this.sellFrame.dispose();
            };
            this.sellFrame = null;
        }

        private function cancelBack(_arg_1:Event):void
        {
            if (this._dragTarget)
            {
                this._dragTarget.locked = false;
            };
            if (stage)
            {
                this.dragStart(stage.mouseX, stage.mouseY);
            };
            this.__disposeSellFrame();
        }


    }
}//package bagAndInfo.bag

