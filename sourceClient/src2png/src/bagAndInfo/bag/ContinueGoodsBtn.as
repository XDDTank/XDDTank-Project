// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.ContinueGoodsBtn

package bagAndInfo.bag
{
    import com.pickgliss.ui.controls.TextButton;
    import ddt.interfaces.IDragable;
    import flash.events.MouseEvent;
    import flash.display.Bitmap;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.DragManager;
    import bagAndInfo.cell.DragEffect;
    import bagAndInfo.cell.LockBagCell;
    import ddt.data.EquipType;
    import ddt.manager.ShopManager;
    import ddt.view.goods.AddPricePanel;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;

    public class ContinueGoodsBtn extends TextButton implements IDragable 
    {

        public var _isContinueGoods:Boolean;

        public function ContinueGoodsBtn()
        {
            this._isContinueGoods = false;
            this.addEvt();
        }

        private function addEvt():void
        {
            this.addEventListener(MouseEvent.CLICK, this.clickthis);
        }

        private function removeEvt():void
        {
            this.removeEventListener(MouseEvent.CLICK, this.clickthis);
        }

        private function clickthis(_arg_1:MouseEvent):void
        {
            var _local_2:Bitmap;
            SoundManager.instance.play("008");
            if (this._isContinueGoods == false)
            {
                this._isContinueGoods = true;
                _local_2 = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.continueIconAsset");
                DragManager.startDrag(this, this, _local_2, _arg_1.stageX, _arg_1.stageY, DragEffect.MOVE, false);
            }
            else
            {
                this._isContinueGoods = false;
            };
        }

        public function getSource():IDragable
        {
            return (this);
        }

        public function dragStop(_arg_1:DragEffect):void
        {
            var _local_2:LockBagCell;
            if (((this._isContinueGoods) && (_arg_1.target is LockBagCell)))
            {
                _local_2 = (_arg_1.target as LockBagCell);
                _local_2.locked = false;
                this._isContinueGoods = false;
                if ((((ShopManager.Instance.canAddPrice(_local_2.itemInfo.TemplateID)) && (!(_local_2.itemInfo.getRemainDate() == int.MAX_VALUE))) && (!(EquipType.isProp(_local_2.itemInfo)))))
                {
                    AddPricePanel.Instance.setInfo(_local_2.itemInfo, false);
                    AddPricePanel.Instance.show();
                    return;
                };
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.bagII.cantAddPrice"));
                return;
            };
            this._isContinueGoods = false;
        }

        public function get isContinueGoods():Boolean
        {
            return (this._isContinueGoods);
        }


    }
}//package bagAndInfo.bag

