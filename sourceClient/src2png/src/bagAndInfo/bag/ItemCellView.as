// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.ItemCellView

package bagAndInfo.bag
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObject;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.events.ItemEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import com.greensock.TweenMax;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.view.PropItemView;
    import game.GameManager;
    import flash.filters.ColorMatrixFilter;

    [Event(name="itemClick", type="tank.view.items.ItemEvent")]
    [Event(name="itemOver", type="tank.view.items.ItemEvent")]
    [Event(name="itemOut", type="tank.view.items.ItemEvent")]
    [Event(name="itemMove", type="tank.view.items.ItemEvent")]
    public class ItemCellView extends Sprite implements Disposeable 
    {

        public static const RIGHT_PROP:String = "rightPropView";
        public static const PROP_SHORT:String = "propShortCutView";

        protected var _item:DisplayObject;
        protected var _asset:Bitmap;
        private var _index:uint;
        private var _clickAble:Boolean;
        private var _isDisable:Boolean;
        private var _isGray:Boolean;
        private var _container:Sprite;
        private var _letterTip:Bitmap;
        private var _effectType:String;

        public function ItemCellView(_arg_1:uint=0, _arg_2:DisplayObject=null, _arg_3:Boolean=false, _arg_4:String="")
        {
            this._effectType = _arg_4;
            this._container = new Sprite();
            addChild(this._container);
            this._index = _arg_1;
            this.initItemBg();
            this._container.addChild(this._asset);
            this._asset.x = (-(this._asset.width) / 2);
            this._asset.y = (-(this._asset.height) / 2);
            this._container.x = (this._asset.width / 2);
            this._container.y = (this._asset.height / 2);
            this.setItem(_arg_2, false);
            this.setEffectType(_arg_4);
        }

        public function setClick(_arg_1:Boolean, _arg_2:Boolean, _arg_3:Boolean):void
        {
            this._clickAble = _arg_1;
            this.setGrayII(_arg_2, _arg_3);
        }

        protected function initItemBg():void
        {
            this._asset = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.propItemBgAssetAsset");
        }

        private function setEffectType(_arg_1:String):void
        {
            switch (_arg_1)
            {
                case RIGHT_PROP:
                    this._letterTip = ComponentFactory.Instance.creatBitmap(("asset.game.itemCell.tip" + (this.index + 1)));
                    break;
                case PROP_SHORT:
                    this._letterTip = ComponentFactory.Instance.creatBitmap(("asset.game.itemCell.letter" + (this.index + 1)));
                    break;
            };
            if (this._letterTip)
            {
                this._container.addChild(this._letterTip);
                this._letterTip.x = ((this._asset.x + this._asset.width) - this._letterTip.width);
                this._letterTip.y = this._asset.y;
            };
        }

        override public function get height():Number
        {
            return (this._asset.height);
        }

        private function __click(_arg_1:MouseEvent):void
        {
            stage.focus = this;
            if (((this._clickAble) && (this._item)))
            {
                dispatchEvent(new ItemEvent(ItemEvent.ITEM_CLICK, this.item, this._index));
            };
        }

        public function mouseClick():void
        {
            if (((this._isDisable) || (!(visible))))
            {
                return;
            };
            this.__click(null);
        }

        private function __over(_arg_1:Event):void
        {
            if ((((!(this._isGray)) && (this._item)) && (!(this._effectType == ""))))
            {
                this.showEffect();
            };
            if (((!(this._isGray)) && (this._item)))
            {
                dispatchEvent(new ItemEvent(ItemEvent.ITEM_OVER, this.item, this._index));
            };
        }

        private function __out(_arg_1:Event):void
        {
            this.hideEffect();
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_OUT, this.item, this._index));
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
                    "strength":3
                }
            });
            TweenMax.to(this._container, 0.1, {
                "scaleX":1.2,
                "scaleY":1.2
            });
        }

        private function hideEffect():void
        {
            TweenMax.killChildTweensOf(this.parent);
            this.filters = null;
            this._container.scaleX = 1;
            this._container.scaleY = 1;
        }

        private function __effectEnd():void
        {
        }

        private function __move(_arg_1:MouseEvent):void
        {
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_MOVE, this.item, this._index));
        }

        public function get item():DisplayObject
        {
            return (this._item);
        }

        public function setItem(_arg_1:DisplayObject, _arg_2:Boolean):void
        {
            var _local_3:Sprite;
            if (this._item)
            {
                this.removeEvent();
                ObjectUtils.disposeObject(this._item);
            };
            this._item = _arg_1;
            if (this._item)
            {
                mouseEnabled = true;
                buttonMode = true;
                this.addEvent();
                _local_3 = new Sprite();
                this._container.addChild(_local_3);
                _local_3.addChild(this._item);
                if (this._letterTip)
                {
                    this._container.swapChildren(_local_3, this._letterTip);
                };
                _local_3.x = -20;
                _local_3.y = -20;
                if ((this._item is PropItemView))
                {
                    this.setGrayII(_arg_2, PropItemView(this._item).isExist);
                }
                else
                {
                    this.setGrayII(_arg_2, true);
                };
            }
            else
            {
                buttonMode = false;
                mouseEnabled = false;
            };
            this.setItemWidthAndHeight();
        }

        protected function setItemWidthAndHeight():void
        {
        }

        private function addEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__click);
            this.item.addEventListener(PropItemView.OVER, this.__over);
            this.item.addEventListener(PropItemView.OUT, this.__out);
            addEventListener(MouseEvent.MOUSE_MOVE, this.__move);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__click);
            if (this.item)
            {
                this.item.removeEventListener(PropItemView.OVER, this.__over);
                this.item.removeEventListener(PropItemView.OUT, this.__out);
            };
            removeEventListener(MouseEvent.MOUSE_MOVE, this.__move);
        }

        public function seleted(_arg_1:Boolean):void
        {
        }

        public function disable():void
        {
            if (GameManager.Instance.Current.selfGamePlayer.isAttacking)
            {
                this.removeEvent();
                this._isDisable = true;
                this.setGrayII(false, false);
            };
        }

        public function get index():int
        {
            return (this._index);
        }

        public function setBackgroundVisible(_arg_1:Boolean):void
        {
            this._asset.alpha = ((_arg_1) ? 1 : 0);
        }

        public function setGrayII(_arg_1:Boolean, _arg_2:Boolean):void
        {
            if (this.item)
            {
                this._isGray = _arg_1;
                if (((!(_arg_1)) && (_arg_2)))
                {
                    if (this._isDisable)
                    {
                        this.addEvent();
                        this._isDisable = false;
                    };
                    this.item.filters = null;
                }
                else
                {
                    this.hideEffect();
                    this.item.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0.3086, 0.6094, 0.082, 0, 0, 0, 0, 0, 1, 0])];
                };
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._asset)
            {
                if (this._asset.parent)
                {
                    this._asset.parent.removeChild(this._asset);
                };
                if (this._asset.bitmapData)
                {
                    this._asset.bitmapData.dispose();
                };
            };
            if (this._letterTip)
            {
                ObjectUtils.disposeObject(this._letterTip);
            };
            this._letterTip = null;
            if (this._container)
            {
                ObjectUtils.disposeObject(this._container);
            };
            this._container = null;
            this._asset = null;
            ObjectUtils.disposeObject(this._item);
            this._item = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package bagAndInfo.bag

