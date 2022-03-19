// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.cell.LinkedBagCell

package bagAndInfo.cell
{
    import flash.display.Sprite;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.utils.DoubleClickManager;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import ddt.manager.PlayerManager;
    import ddt.events.CellEvent;
    import ddt.interfaces.IDragable;
    import ddt.data.goods.InventoryItemInfo;

    public class LinkedBagCell extends BagCell 
    {

        protected var _bagCell:BagCell;
        private var _lockBag:LockBagCell;
        public var DoubleClickEnabled:Boolean = true;

        public function LinkedBagCell(_arg_1:Sprite)
        {
            super(0, null, true, _arg_1);
        }

        override protected function init():void
        {
            addEventListener(InteractiveEvent.CLICK, this.__clickHandler);
            addEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(this);
            super.init();
        }

        private function __clickHandler(_arg_1:InteractiveEvent):void
        {
            if (((((_info) && (!(locked))) && (stage)) && (allowDrag)))
            {
                SoundManager.instance.play("008");
            };
            dragStart();
        }

        public function get lockBagCell():LockBagCell
        {
            return (this._lockBag);
        }

        public function set lockBagCell(_arg_1:LockBagCell):void
        {
            if (this._lockBag)
            {
                this._lockBag.removeEventListener(Event.CHANGE, this.__lockCellChanged);
                if (((this._lockBag.itemInfo) && (this._lockBag.itemInfo.BagType == 0)))
                {
                    PlayerManager.Instance.Self.Bag.unlockItem(this._lockBag.itemInfo);
                }
                else
                {
                    if (this._lockBag.itemInfo)
                    {
                        PlayerManager.Instance.Self.PropBag.unlockItem(this._lockBag.itemInfo);
                    };
                };
                this._lockBag.locked = false;
                info = null;
            };
            this._lockBag = _arg_1;
            if (this._lockBag)
            {
                this._lockBag.addEventListener(Event.CHANGE, this.__lockCellChanged);
                this.info = this._lockBag.info;
            };
        }

        public function get bagCell():BagCell
        {
            return (this._bagCell);
        }

        public function set bagCell(_arg_1:BagCell):void
        {
            if (this._bagCell)
            {
                this._bagCell.removeEventListener(Event.CHANGE, this.__changed);
                if (((this._bagCell.itemInfo) && (this._bagCell.itemInfo.BagType == 0)))
                {
                    PlayerManager.Instance.Self.Bag.unlockItem(this._bagCell.itemInfo);
                }
                else
                {
                    if (this._bagCell.itemInfo)
                    {
                        PlayerManager.Instance.Self.PropBag.unlockItem(this._bagCell.itemInfo);
                    };
                };
                this._bagCell.locked = false;
                info = null;
            };
            this._bagCell = _arg_1;
            if (this._bagCell)
            {
                this._bagCell.addEventListener(Event.CHANGE, this.__changed);
                this.info = this._bagCell.info;
            };
        }

        override public function get place():int
        {
            if (this._bagCell)
            {
                return (this._bagCell.itemInfo.Place);
            };
            if (this._lockBag)
            {
                return (this._lockBag.itemInfo.Place);
            };
            return (-1);
        }

        protected function __doubleClickHandler(_arg_1:InteractiveEvent):void
        {
            if ((!(this.DoubleClickEnabled)))
            {
                return;
            };
            if ((_arg_1.currentTarget as BagCell).info != null)
            {
                dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK, this, true));
            }
            else
            {
                if (((_arg_1.currentTarget as LockBagCell) && (!(_arg_1.currentTarget.info == null))))
                {
                    dispatchEvent(new CellEvent(CellEvent.DOUBLE_CLICK, this, true));
                };
            };
        }

        override public function dragStop(_arg_1:DragEffect):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                return;
            };
            if (this._bagCell)
            {
                if (((!(_arg_1.action == DragEffect.NONE)) || (_arg_1.target)))
                {
                    this._bagCell.dragStop(_arg_1);
                    this._bagCell.removeEventListener(Event.CHANGE, this.__changed);
                    this._bagCell = null;
                    info = null;
                }
                else
                {
                    this.locked = false;
                };
            }
            else
            {
                if (this._lockBag)
                {
                    this._lockBag.dragStop(_arg_1);
                    this._lockBag.removeEventListener(Event.CHANGE, this.__lockCellChanged);
                    this._lockBag = null;
                    info = null;
                };
            };
        }

        private function __changed(_arg_1:Event):void
        {
            this.info = ((this._bagCell == null) ? null : this._bagCell.info);
            if (((this._bagCell == null) || (this._bagCell.info == null)))
            {
                this.clearLinkCell();
            }
            else
            {
                this._bagCell.locked = true;
            };
        }

        private function __lockCellChanged(_arg_1:Event):void
        {
            this.info = ((this._lockBag == null) ? null : this._lockBag.info);
            if (((this._lockBag == null) || (this._lockBag.info == null)))
            {
                this.clearLinkCell();
            }
            else
            {
                this._lockBag.locked = true;
            };
        }

        override public function getSource():IDragable
        {
            return ((this._lockBag == null) ? this._bagCell : this._lockBag);
        }

        public function clearLinkCell():void
        {
            if (this._bagCell)
            {
                this._bagCell.removeEventListener(Event.CHANGE, this.__changed);
                if (((this._bagCell.itemInfo) && (this._bagCell.itemInfo.lock)))
                {
                    if (((this._bagCell.itemInfo) && (this._bagCell.itemInfo.BagType == 0)))
                    {
                        PlayerManager.Instance.Self.Bag.unlockItem(this._bagCell.itemInfo);
                    }
                    else
                    {
                        PlayerManager.Instance.Self.PropBag.unlockItem(this._bagCell.itemInfo);
                    };
                };
                this._bagCell.locked = false;
            }
            else
            {
                if (this._lockBag)
                {
                    this._lockBag.removeEventListener(Event.CHANGE, this.__lockCellChanged);
                    if (((this._lockBag.itemInfo) && (this._lockBag.itemInfo.lock)))
                    {
                        if (((this._lockBag.itemInfo) && (this._lockBag.itemInfo.BagType == 0)))
                        {
                            PlayerManager.Instance.Self.Bag.unlockItem(this._lockBag.itemInfo);
                        }
                        else
                        {
                            PlayerManager.Instance.Self.PropBag.unlockItem(this._lockBag.itemInfo);
                        };
                    };
                    this._lockBag.locked = false;
                };
            };
            this.bagCell = null;
            this.lockBagCell = null;
        }

        override public function set locked(_arg_1:Boolean):void
        {
        }

        override public function dispose():void
        {
            removeEventListener(InteractiveEvent.CLICK, this.__clickHandler);
            removeEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(this);
            this.clearLinkCell();
            if ((info is InventoryItemInfo))
            {
                info["lock"] = false;
            };
            super.dispose();
            this.bagCell = null;
            this.lockBagCell = null;
        }


    }
}//package bagAndInfo.cell

