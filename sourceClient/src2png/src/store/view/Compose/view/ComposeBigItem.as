// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.Compose.view.ComposeBigItem

package store.view.Compose.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.image.ScaleUpDownImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import flash.geom.Point;
    import store.view.Compose.ComposeController;
    import store.view.Compose.ComposeType;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.geom.IntPoint;
    import store.view.Compose.ComposeEvents;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.filters.ColorMatrixFilter;

    public class ComposeBigItem extends Sprite implements Disposeable 
    {

        private var _num:int;
        private var _selected:Boolean;
        private var _selectedMiddleNum:int = -1;
        private var _bigItemDic:DictionaryData;
        private var _middleItemDic:DictionaryData;
        private var _smallItemDic:DictionaryData;
        private var _bg:ScaleFrameImage;
        private var _bgSelected2:ScaleUpDownImage;
        private var _icon:Bitmap;
        private var _textPic:ScaleFrameImage;
        private var _itemVbox:VBox;
        private var _scrollPanel:ScrollPanel;
        private var _pos2:Point;
        private var _enable:Boolean = true;

        public function ComposeBigItem(_arg_1:int)
        {
            this._num = _arg_1;
            this._bigItemDic = ComposeController.instance.model.composeBigDic;
            this._middleItemDic = ComposeController.instance.model.composeMiddelDic;
            this._smallItemDic = ComposeController.instance.model.composeSmallDic;
            this.initView();
            this.initEvent();
        }

        private function get selectedMiddleNum():int
        {
            this._selectedMiddleNum = ComposeController.instance.model.getSeletedPageMiddle(this.num);
            if (((this._selectedMiddleNum == -1) && (this.num == ComposeType.EQUIP)))
            {
                this._selectedMiddleNum = (this._middleItemDic[this._bigItemDic[this._num]].length - 1);
            };
            return (this._selectedMiddleNum);
        }

        public function get num():int
        {
            return (this._num);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._selected == _arg_1)
            {
                return;
            };
            this._selected = _arg_1;
            this._bg.setFrame(((_arg_1 == true) ? 1 : 2));
            this._textPic.setFrame(((_arg_1 == true) ? 1 : 2));
            if (this._selected)
            {
                this.initFollowView();
            }
            else
            {
                this.removeFollowView();
            };
            this.initBg();
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        private function initView():void
        {
            this._pos2 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.composeItemsView.pos2");
            this._bgSelected2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtstore.composeItemsView.big.selected.mid");
            this._bgSelected2.visible = false;
            addChild(this._bgSelected2);
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.composeItemsView.big.bg");
            this._bg.setFrame(2);
            this._bg.buttonMode = true;
            addChild(this._bg);
            this._icon = ComponentFactory.Instance.creatBitmap(("asset.ddtstore.composeItemsView.big.Icon." + this._bigItemDic[this._num]));
            addChild(this._icon);
            this._textPic = ComponentFactory.Instance.creatComponentByStylename(("asset.ddtstore.composeItemsView.big.select.Text." + this._bigItemDic[this._num]));
            this._textPic.setFrame(2);
            this._textPic.buttonMode = true;
            addChild(this._textPic);
        }

        private function initFollowView():void
        {
            var _local_3:int;
            var _local_4:ComposeMiddelItem;
            var _local_5:int;
            var _local_6:ComposeSmallItem;
            if (this._scrollPanel)
            {
                this.removeFollowView();
            };
            this._scrollPanel = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.bigItem.ScrollPanel");
            this._itemVbox = new VBox();
            var _local_1:IntPoint = new IntPoint();
            var _local_2:int;
            if (this._middleItemDic[this._bigItemDic[this._num]])
            {
                _local_3 = 0;
                while (_local_3 < this._middleItemDic[this._bigItemDic[this._num]].length)
                {
                    _local_4 = new ComposeMiddelItem(_local_3, this._num);
                    _local_4.addEventListener(ComposeEvents.CLICK_MIDDLE_ITEM, this.__clickMiddleItem);
                    if (((this._selected) && (_local_4.num == this.selectedMiddleNum)))
                    {
                        _local_4.selected = true;
                        _local_2 = _local_3;
                    }
                    else
                    {
                        _local_4.selected = false;
                    };
                    this._itemVbox.spacing = 4;
                    this._itemVbox.addChild(_local_4);
                    _local_3++;
                };
                this._scrollPanel.setView(this._itemVbox);
            }
            else
            {
                if (this._smallItemDic.length > 0)
                {
                    _local_5 = 0;
                    while (_local_5 < this._smallItemDic[this._num][0].length)
                    {
                        _local_6 = new ComposeSmallItem(_local_5, 0, this._num);
                        addChild(_local_6);
                        _local_5++;
                    };
                };
            };
            if (this._itemVbox.numChildren > 0)
            {
                _local_1.x = this._itemVbox.getChildAt(_local_2).x;
                _local_1.y = this._itemVbox.getChildAt(_local_2).y;
                this._scrollPanel.invalidateViewport();
                this._scrollPanel.viewPort.viewPosition = _local_1;
                addChild(this._scrollPanel);
            };
        }

        private function __clickMiddleItem(_arg_1:ComposeEvents):void
        {
            var _local_2:int = _arg_1.num;
            this._selectedMiddleNum = _local_2;
            this.initFollowView();
        }

        private function initBg():void
        {
            if (this._selected)
            {
                this._bgSelected2.x = -3;
                this._bgSelected2.y = -2;
                this._bgSelected2.height = (this.height - this._bg.height);
                this._bgSelected2.height = ((this._bgSelected2.height > this._pos2.y) ? (this._pos2.y + 90) : (this._bgSelected2.height + 90));
                this._bgSelected2.visible = true;
            }
            else
            {
                this._bgSelected2.visible = false;
            };
        }

        private function initEvent():void
        {
            this._bg.addEventListener(MouseEvent.CLICK, this.__clickHandle);
            this._textPic.addEventListener(MouseEvent.CLICK, this.__clickHandle);
        }

        private function __clickHandle(_arg_1:MouseEvent):void
        {
            if ((!(this._enable)))
            {
                return;
            };
            SoundManager.instance.playButtonSound();
            dispatchEvent(new ComposeEvents(ComposeEvents.CLICK_BIG_ITEM));
        }

        private function removeFollowView():void
        {
            if (this._itemVbox)
            {
                this._itemVbox.disposeAllChildren();
            };
            if (this._scrollPanel)
            {
                ObjectUtils.disposeObject(this._scrollPanel);
                this._scrollPanel = null;
            };
        }

        public function get enable():Boolean
        {
            return (this._enable);
        }

        public function set enable(_arg_1:Boolean):void
        {
            this._enable = _arg_1;
            if (this._enable)
            {
                this.useHandCursor = true;
                this.filters = [];
            }
            else
            {
                this.useHandCursor = false;
                this.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])];
            };
        }

        public function removeEvent():void
        {
            this._bg.removeEventListener(MouseEvent.CLICK, this.__clickHandle);
            this._textPic.removeEventListener(MouseEvent.CLICK, this.__clickHandle);
        }

        public function dispose():void
        {
            this.removeEvent();
            this.removeFollowView();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg = null;
            };
            if (this._bgSelected2)
            {
                ObjectUtils.disposeObject(this._bgSelected2);
                this._bgSelected2 = null;
            };
            if (this._icon)
            {
                ObjectUtils.disposeObject(this._icon);
                this._icon = null;
            };
            if (this._textPic)
            {
                ObjectUtils.disposeObject(this._textPic);
                this._textPic = null;
            };
        }


    }
}//package store.view.Compose.view

