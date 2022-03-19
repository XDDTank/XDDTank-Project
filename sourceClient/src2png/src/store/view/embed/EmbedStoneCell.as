// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.embed.EmbedStoneCell

package store.view.embed
{
    import store.StoreCell;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.ComponentFactory;
    import flash.display.MovieClip;
    import flash.geom.Point;
    import bagAndInfo.cell.DragEffect;
    import ddt.manager.DragManager;
    import store.events.EmbedEvent;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.goods.EquipmentTemplateInfo;
    import ddt.manager.ItemManager;
    import flash.events.Event;
    import ddt.data.goods.ItemTemplateInfo;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.events.InteractiveEvent;

    public class EmbedStoneCell extends StoreCell 
    {

        public static const Close:int = -1;
        public static const Empty:int = 0;
        public static const Full:int = 1;
        public static const ATTACK:int = 1;
        public static const DEFENSE:int = 2;
        public static const ATTRIBUTE:int = 3;
        public static const BEAD_STATE_CHANGED:String = "beadEmbed";

        private var _state:int = -1;
        private var _bgImage:ScaleFrameImage = ComponentFactory.Instance.creat("asset.ddtstore.EmbedBG.embedStoneBg");
        private var _successMc:MovieClip;
        private var _holeID:int;

        public function EmbedStoneCell(_arg_1:int)
        {
            this._bgImage.setFrame(1);
            super(this._bgImage, _arg_1);
            PicPos = new Point(11, 12);
            setContentSize(51, 51);
            _allowDrag = false;
            setShiner(ComponentFactory.Instance.creat("ddtstore.EmbedStoneCell.shine"));
            shinerPos = ComponentFactory.Instance.creat("ddtstore.embedBg.embedStoneCell.shinerPos");
            tipGapV = 0;
            tipGapH = 0;
        }

        override public function get width():Number
        {
            return (this._bgImage.width);
        }

        override public function get height():Number
        {
            return (this._bgImage.height);
        }

        override public function dragDrop(_arg_1:DragEffect):void
        {
            _arg_1.action = DragEffect.NONE;
            DragManager.acceptDrag(this);
            dispatchEvent(new EmbedEvent(EmbedEvent.EMBED, (_arg_1.data as InventoryItemInfo)));
        }

        override public function set info(_arg_1:ItemTemplateInfo):void
        {
            var _local_2:EquipmentTemplateInfo;
            if (((_info == _arg_1) && (!(_info))))
            {
                return;
            };
            super.info = _arg_1;
            if ((_info is InventoryItemInfo))
            {
                this.locked = this._info["lock"];
            };
            if (_info == null)
            {
                _local_2 = null;
                this.seteuipQualityBg(0);
            };
            if (_info != null)
            {
                _local_2 = ItemManager.Instance.getEquipTemplateById(_info.TemplateID);
            };
            if (((!(_local_2 == null)) && (_info.Property8 == "0")))
            {
                this.seteuipQualityBg(_local_2.QualityID);
            }
            else
            {
                this.seteuipQualityBg(0);
            };
            dispatchEvent(new Event(Event.CHANGE));
        }

        override public function seteuipQualityBg(_arg_1:int):void
        {
            if (_euipQualityBg == null)
            {
                _euipQualityBg = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.euipQuality.ViewTwo");
            };
            _euipQualityBg.width = 51;
            _euipQualityBg.height = 51;
            _euipQualityBg.x = 10;
            _euipQualityBg.y = 11;
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

        public function shineSuccessMC():void
        {
            if (this._successMc)
            {
                this._successMc.stop();
                this._successMc.removeEventListener(Event.ENTER_FRAME, this.__onComplete);
                ObjectUtils.disposeObject(this._successMc);
            };
            this._successMc = ComponentFactory.Instance.creat("asset.ddtstore.EmbedBg.openHoleMc");
            this._successMc.addEventListener(Event.COMPLETE, this.__onComplete);
            addChild(this._successMc);
        }

        protected function __onComplete(_arg_1:Event):void
        {
            this._successMc.stop();
            this._successMc.removeEventListener(Event.ENTER_FRAME, this.__onComplete);
            ObjectUtils.disposeObject(this._successMc);
            this._successMc = null;
        }

        override protected function __doubleClickHandler(_arg_1:InteractiveEvent):void
        {
            if ((!(DoubleClickEnabled)))
            {
                return;
            };
            dispatchEvent(new EmbedEvent(EmbedEvent.EMBED, (info as InventoryItemInfo)));
        }

        override public function dispose():void
        {
            super.dispose();
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get state():int
        {
            return (this._state);
        }

        public function set state(_arg_1:int):void
        {
            this._state = _arg_1;
            switch (this._state)
            {
                case Close:
                    this._bgImage.setFrame(1);
                    return;
                case Empty:
                    this._bgImage.setFrame(2);
                    return;
                case Full:
                    this._bgImage.setFrame(2);
                    return;
            };
        }

        public function get holeID():int
        {
            return (this._holeID);
        }

        public function set holeID(_arg_1:int):void
        {
            this._holeID = _arg_1;
            if (this._holeID > 1)
            {
                this.state = Full;
                this.info = ItemManager.Instance.getTemplateById(this._holeID);
            }
            else
            {
                if (this._holeID == -1)
                {
                    this.state = Close;
                }
                else
                {
                    if (this._holeID == 1)
                    {
                        this.state = Empty;
                    };
                };
                this.info = null;
            };
        }


    }
}//package store.view.embed

