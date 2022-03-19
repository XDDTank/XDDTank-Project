// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.StoreCell

package store
{
    import bagAndInfo.cell.BagCell;
    import ddt.command.ShineObject;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.Sprite;
    import com.pickgliss.events.InteractiveEvent;
    import com.pickgliss.utils.DoubleClickManager;
    import ddt.manager.SocketManager;
    import ddt.data.BagInfo;
    import ddt.manager.SoundManager;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import flash.display.MovieClip;
    import ddt.utils.PositionUtils;

    public class StoreCell extends BagCell 
    {

        protected var _shiner:ShineObject;
        protected var _shinerPos:Point;
        protected var _index:int;
        public var DoubleClickEnabled:Boolean = true;
        public var mouseSilenced:Boolean = false;

        public function StoreCell(_arg_1:Sprite, _arg_2:int)
        {
            super(0, null, false, _arg_1);
            this._index = _arg_2;
            this._shiner = new ShineObject(ComponentFactory.Instance.creat("asset.ddtstore.cellShine"));
            this._shiner.addToBottom = false;
            this._shiner.visible = false;
            addChild(this._shiner);
            this._shiner.mouseChildren = (this._shiner.mouseEnabled = false);
            if (_cellMouseOverBg)
            {
                ObjectUtils.disposeObject(_cellMouseOverBg);
            };
            _cellMouseOverBg = null;
            tipDirctions = "7,5,2,6,4,1";
            PicPos = new Point(-2, -2);
            this._shinerPos = new Point(16, 28);
        }

        override protected function createChildren():void
        {
            super.createChildren();
            if (_tbxCount)
            {
                ObjectUtils.disposeObject(_tbxCount);
            };
            _tbxCount = ComponentFactory.Instance.creat("ddtstore.StoneCountText");
            _tbxCount.mouseEnabled = false;
            addChild(_tbxCount);
        }

        override protected function initEvent():void
        {
            super.initEvent();
            addEventListener(InteractiveEvent.CLICK, this.__clickHandler);
            addEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
            DoubleClickManager.Instance.enableDoubleClick(this);
        }

        override protected function removeEvent():void
        {
            super.removeEvent();
            removeEventListener(InteractiveEvent.CLICK, this.__clickHandler);
            removeEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(this);
        }

        protected function __doubleClickHandler(_arg_1:InteractiveEvent):void
        {
            if ((!(this.DoubleClickEnabled)))
            {
                return;
            };
            if (info == null)
            {
                return;
            };
            if ((_arg_1.currentTarget as BagCell).info != null)
            {
                SocketManager.Instance.out.sendMoveGoods(BagInfo.STOREBAG, this.index, this.itemBagType, -1);
                if ((!(this.mouseSilenced)))
                {
                    SoundManager.instance.play("008");
                };
            };
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:EquipmentTemplateInfo;
            super.info = _arg_1;
            updateCount();
            checkOverDate();
            if ((info is InventoryItemInfo))
            {
                this.locked = this.info["lock"];
            };
            if (info == null)
            {
                _local_2 = null;
                this.seteuipQualityBg(0);
            };
            if (info != null)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(info.TemplateID);
            };
            if (((!(_local_2 == null)) && (info.Property8 == "0")))
            {
                this.seteuipQualityBg(_local_2.QualityID);
            }
            else
            {
                this.seteuipQualityBg(0);
            };
        }

        override public function seteuipQualityBg(_arg_1:int):void
        {
            if (_euipQualityBg == null)
            {
                _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
            };
            _euipQualityBg.width = 68;
            _euipQualityBg.height = 68;
            _euipQualityBg.x = -4;
            _euipQualityBg.y = -1;
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

        protected function __clickHandler(_arg_1:InteractiveEvent):void
        {
            if (((((_info) && (!(locked))) && (stage)) && (allowDrag)))
            {
                SoundManager.instance.play("008");
            };
            dragStart();
        }

        public function get itemBagType():int
        {
            if (((info) && (((info.CategoryID == 10) || (info.CategoryID == 11)) || (info.CategoryID == 12))))
            {
                return (BagInfo.PROPBAG);
            };
            return (BagInfo.EQUIPBAG);
        }

        public function get index():int
        {
            return (this._index);
        }

        public function setShiner(_arg_1:MovieClip):void
        {
            ObjectUtils.disposeObject(this._shiner);
            this._shiner = null;
            if (_arg_1)
            {
                this._shiner = new ShineObject(_arg_1);
                this._shiner.addToBottom = false;
                this._shiner.visible = false;
                this._shiner.mouseChildren = (this._shiner.mouseEnabled = false);
                addChild(this._shiner);
            };
        }

        public function get shinerPos():Point
        {
            return (this._shinerPos);
        }

        public function set shinerPos(_arg_1:Point):void
        {
            this._shinerPos = _arg_1;
        }

        public function startShine():void
        {
            if (this._shiner)
            {
                this._shiner.visible = true;
                setChildIndex(this._shiner, (numChildren - 1));
                PositionUtils.setPos(this._shiner, this._shinerPos);
                this._shiner.shine();
            };
        }

        public function stopShine():void
        {
            if (this._shiner)
            {
                this._shiner.visible = false;
                this._shiner.stopShine();
            };
        }

        override public function dispose():void
        {
            super.dispose();
            removeEventListener(InteractiveEvent.CLICK, this.__clickHandler);
            removeEventListener(InteractiveEvent.DOUBLE_CLICK, this.__doubleClickHandler);
            DoubleClickManager.Instance.disableDoubleClick(this);
            if (this._shiner)
            {
                ObjectUtils.disposeObject(this._shiner);
            };
            this._shiner = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store

