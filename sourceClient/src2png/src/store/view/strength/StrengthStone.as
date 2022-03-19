// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.strength.StrengthStone

package store.view.strength
{
    import store.StoneCell;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.BagInfo;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.SocketManager;
    import ddt.manager.DragManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;

    public class StrengthStone extends StoneCell 
    {

        private var _stoneType:String = "";
        private var _itemType:int = -1;
        private var _aler:StrengthSelectNumAlertFrame;

        public function StrengthStone(_arg_1:Array, _arg_2:int)
        {
            super(_arg_1, _arg_2);
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            if (_arg_1 == null)
            {
            };
            super.info = _arg_1;
        }

        public function setCount(_arg_1:int):void
        {
            _tbxCount.text = _arg_1.toString();
        }

        public function set itemType(_arg_1:int):void
        {
            this._itemType = _arg_1;
        }

        public function get itemType():int
        {
            return (this._itemType);
        }

        public function get stoneType():String
        {
            return (this._stoneType);
        }

        public function set stoneType(_arg_1:String):void
        {
            this._stoneType = _arg_1;
        }

        override public function dragStart():void
        {
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:InventoryItemInfo = (_arg_1.data as InventoryItemInfo);
            if (((_local_2.BagType == BagInfo.STOREBAG) && (!(info == null))))
            {
                return;
            };
            if (_local_2.CategoryID == 40)
            {
                return;
            };
            if (((_local_2) && (!(_arg_1.action == DragEffect.SPLIT))))
            {
                _arg_1.action = DragEffect.NONE;
                if (((this._stoneType == "") || (this._stoneType == _local_2.Property1)))
                {
                    this._stoneType = _local_2.Property1;
                    if (_local_2.Count == 1)
                    {
                        SocketManager.Instance.out.sendMoveGoods(_local_2.BagType, _local_2.Place, BagInfo.STOREBAG, index, 1, true);
                    }
                    else
                    {
                        this.showNumAlert(_local_2, index);
                    };
                    DragManager.acceptDrag(this, DragEffect.NONE);
                    this.reset();
                }
                else
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("store.view.strength.typeUnpare"));
                };
            };
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

        private function reset():void
        {
            this._stoneType = "";
            this._itemType = -1;
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._aler)
            {
                ObjectUtils.disposeObject(this._aler);
            };
            this._aler = null;
        }


    }
}//package store.view.strength

