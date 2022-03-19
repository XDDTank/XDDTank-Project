// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.Compose.view.ComposeMaterialCell

package store.view.Compose.view
{
    import bagAndInfo.cell.BaseCell;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.manager.PlayerManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.ItemManager;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.events.BagEvent;

    public class ComposeMaterialCell extends BaseCell 
    {

        private var _countText:FilterFrameText;
        private var _count:int;
        private var _time:int = 1;
        private var _haveCount:int;
        private var _canUseCount:int;
        private var _enough:Boolean;
        private var _LargestTime:int;
        private var _isBind:Boolean;
        private var _euipQualityBg:ScaleFrameImage;

        public function ComposeMaterialCell()
        {
            super(ComponentFactory.Instance.creatBitmap("asset.ddtstore.materialCellBg"));
            _bg.visible = false;
            setContentSize(56, 56);
            PicPos = new Point(9, 8);
        }

        public function get canUseCount():int
        {
            return (this._canUseCount);
        }

        public function get haveCount():int
        {
            return (this._haveCount);
        }

        public function get isNotBind():Boolean
        {
            return (PlayerManager.Instance.Self.Bag.getItemBindsByTemplateID(info.TemplateID));
        }

        public function set count(_arg_1:int):void
        {
            if (info)
            {
                this._haveCount = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(info.TemplateID);
            }
            else
            {
                this._haveCount = 0;
            };
            this._count = _arg_1;
            this.updateEnough();
            if (_arg_1 == 0)
            {
                this._countText.visible = false;
            }
            else
            {
                if (this._haveCount >= (this._count * this._time))
                {
                    this._countText.text = ((this._haveCount.toString() + "/") + (this._count * this._time).toString());
                }
                else
                {
                    this._countText.htmlText = ((("<font color='#ff0000'>" + this._haveCount.toString()) + "</font>/") + (this._count * this._time).toString());
                };
                this._countText.visible = true;
            };
        }

        private function updateEnough():void
        {
            var _local_2:Array;
            var _local_3:Boolean;
            var _local_4:InventoryItemInfo;
            var _local_5:int;
            var _local_1:int;
            if (_info)
            {
                _local_2 = PlayerManager.Instance.Self.Bag.getItemsByTempleteID(info.TemplateID);
                for each (_local_4 in _local_2)
                {
                    _local_3 = false;
                    _local_5 = 1;
                    while (_local_5 <= 4)
                    {
                        if (_local_4[("Hole" + _local_5)] > 1)
                        {
                            _local_3 = true;
                            break;
                        };
                        _local_5++;
                    };
                    if ((!(_local_3)))
                    {
                        _local_1 = (_local_1 + _local_4.Count);
                    };
                };
            };
            this._canUseCount = _local_1;
            this._enough = (_local_1 >= (this._count * this._time));
        }

        public function addCount():void
        {
            this._time = (this._time + 1);
            this.count = this._count;
        }

        public function reduceCount():void
        {
            this._time = (this._time - 1);
            if (this._time <= 0)
            {
                this._time = 1;
                return;
            };
            this.count = this._count;
        }

        public function get LargestTime():int
        {
            return (this._LargestTime = (this._haveCount / this._count));
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:EquipmentTemplateInfo;
            super.info = _arg_1;
            if (this._countText)
            {
                if (this._countText)
                {
                    ObjectUtils.disposeObject(this._countText);
                };
                this._countText = null;
            };
            this._countText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.composeView.countText");
            addChild(this._countText);
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
            this.setTime(1);
        }

        private function seteuipQualityBg(_arg_1:int):void
        {
            if (this._euipQualityBg == null)
            {
                this._euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
            };
            this._euipQualityBg.width = 55;
            this._euipQualityBg.height = 55;
            this._euipQualityBg.x = 9;
            this._euipQualityBg.y = 8;
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

        public function setTime(_arg_1:int):void
        {
            this._time = _arg_1;
            this.count = this._count;
        }

        public function get enough():Boolean
        {
            return (this._enough);
        }

        override protected function initEvent():void
        {
            super.initEvent();
            PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE, this.__updateCount);
            PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE, this.__updateCount);
            PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.AFTERDEL, this.__updateCount);
            PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.AFTERDEL, this.__updateCount);
        }

        private function __updateCount(_arg_1:BagEvent):void
        {
            this.count = this._count;
        }

        override public function dispose():void
        {
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE, this.__updateCount);
            PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.UPDATE, this.__updateCount);
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.AFTERDEL, this.__updateCount);
            PlayerManager.Instance.Self.PropBag.removeEventListener(BagEvent.AFTERDEL, this.__updateCount);
            super.dispose();
            if (this._countText)
            {
                ObjectUtils.disposeObject(this._countText);
            };
            this._countText = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package store.view.Compose.view

