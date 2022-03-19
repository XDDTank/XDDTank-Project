// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.Compose.view.ComposeSmallItem

package store.view.Compose.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import store.view.Compose.ComposeController;
    import com.pickgliss.ui.ComponentFactory;
    import store.data.ComposeItemInfo;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;
    import store.view.Compose.ComposeEvents;
    import ddt.events.BagEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ComposeSmallItem extends Sprite implements Disposeable 
    {

        private var _num:int;
        private var _parent:int;
        private var _topParent:int;
        private var _selected:Boolean;
        private var _bigItemDic:DictionaryData;
        private var _smallItemDic:DictionaryData;
        private var _itemTextSelected:FilterFrameText;
        private var _itemText:FilterFrameText;
        private var _numTextSeletecd:FilterFrameText;
        private var _numText:FilterFrameText;
        private var _linePic:Bitmap;
        private var _mouseOver:Bitmap;

        public function ComposeSmallItem(_arg_1:int, _arg_2:int, _arg_3:int)
        {
            this._num = _arg_1;
            this._parent = _arg_2;
            this._topParent = _arg_3;
            this._bigItemDic = ComposeController.instance.model.composeBigDic;
            this._smallItemDic = ComposeController.instance.model.composeSmallDic;
            this.initView();
            this.initEvent();
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._selected == _arg_1)
            {
                return;
            };
            this._selected = _arg_1;
            if (this._selected)
            {
                ComposeController.instance.model.saveSelectedPageSmall(this._topParent, this._num);
            };
            this._itemTextSelected.visible = (_arg_1 == true);
            this._itemText.visible = (_arg_1 == false);
            this.setCountText();
        }

        private function initView():void
        {
            this._mouseOver = ComponentFactory.Instance.creatBitmap("asset.ddtstore.composeItemsView.small.mouseOver");
            this._mouseOver.visible = false;
            addChild(this._mouseOver);
            this._itemTextSelected = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.smallItem.text");
            this._itemText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.smallItem.text2");
            this._numTextSeletecd = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.smallItem.textNum");
            this._numText = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.smallItem.textNum2");
            this._itemTextSelected.text = (this._itemText.text = this._smallItemDic[this._bigItemDic[this._topParent]][this._parent][this._num].Name);
            this.setCountText();
            this._itemTextSelected.visible = false;
            this._itemText.visible = true;
            addChild(this._itemText);
            addChild(this._itemTextSelected);
            addChild(this._numText);
            addChild(this._numTextSeletecd);
            this._linePic = ComponentFactory.Instance.creatBitmap("asset.ddtstore.composeItemsView.small.linePic");
            addChild(this._linePic);
        }

        private function setCountText():void
        {
            var _local_1:int = this.getComposeCount();
            this._numTextSeletecd.visible = ((!(_local_1 == 0)) && (this._selected));
            this._numText.visible = ((!(_local_1 == 0)) && (!(this._selected)));
            this._numTextSeletecd.text = (this._numText.text = (("(" + _local_1.toString()) + ")"));
        }

        private function getComposeCount():int
        {
            var _local_4:int;
            var _local_5:int;
            var _local_6:int;
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:int;
            var _local_1:int = 9999;
            var _local_2:int = this._smallItemDic[this._bigItemDic[this._topParent]][this._parent][this._num].TemplateID;
            var _local_3:ComposeItemInfo = ComposeController.instance.model.composeItemInfoDic[_local_2];
            if (((_local_3) && (_local_3.Material1ID)))
            {
                _local_4 = PlayerManager.Instance.Self.findItemCount(_local_3.Material1ID);
                _local_5 = _local_3.NeedCount1;
                _local_1 = int((((_local_4 / _local_5) > _local_1) ? _local_1 : int((_local_4 / _local_5))));
            };
            if (((_local_3) && (_local_3.Material2ID)))
            {
                _local_6 = PlayerManager.Instance.Self.findItemCount(_local_3.Material2ID);
                _local_7 = _local_3.NeedCount2;
                _local_1 = int((((_local_6 / _local_7) > _local_1) ? _local_1 : int((_local_6 / _local_7))));
            };
            if (((_local_3) && (_local_3.Material3ID)))
            {
                _local_8 = PlayerManager.Instance.Self.findItemCount(_local_3.Material3ID);
                _local_9 = _local_3.NeedCount3;
                _local_1 = int((((_local_8 / _local_9) > _local_1) ? _local_1 : int((_local_8 / _local_9))));
            };
            if (((_local_3) && (_local_3.Material4ID)))
            {
                _local_10 = PlayerManager.Instance.Self.findItemCount(_local_3.Material4ID);
                _local_11 = _local_3.NeedCount4;
                _local_1 = int((((_local_10 / _local_11) > _local_1) ? _local_1 : int((_local_10 / _local_11))));
            };
            return (_local_1);
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__clickHandle);
            ComposeController.instance.model.addEventListener(ComposeEvents.CLICK_SMALL_ITEM, this.__selected);
            PlayerManager.Instance.Self.Bag.addEventListener(BagEvent.UPDATE, this.__updateCount);
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        private function __clickHandle(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            ComposeController.instance.model.currentItem = this._smallItemDic[this._bigItemDic[this._topParent]][this._parent][this._num];
        }

        private function __selected(_arg_1:ComposeEvents):void
        {
            if (ComposeController.instance.model.currentItem)
            {
                this.selected = (ComposeController.instance.model.currentItem.TemplateID == this._smallItemDic[this._bigItemDic[this._topParent]][this._parent][this._num].TemplateID);
            };
        }

        private function __updateCount(_arg_1:BagEvent):void
        {
            this.setCountText();
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            this._mouseOver.visible = true;
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            this._mouseOver.visible = false;
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__clickHandle);
            ComposeController.instance.model.removeEventListener(ComposeEvents.CLICK_SMALL_ITEM, this.__selected);
            PlayerManager.Instance.Self.Bag.removeEventListener(BagEvent.UPDATE, this.__updateCount);
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._itemText);
            this._itemText = null;
            ObjectUtils.disposeObject(this._itemTextSelected);
            this._itemTextSelected = null;
            ObjectUtils.disposeObject(this._linePic);
            this._linePic = null;
        }


    }
}//package store.view.Compose.view

