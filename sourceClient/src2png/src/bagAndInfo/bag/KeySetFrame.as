// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.bag.KeySetFrame

package bagAndInfo.bag
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.controls.container.HBox;
    import flash.utils.Dictionary;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SharedManager;
    import flash.events.Event;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.events.ItemEvent;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.manager.ItemManager;
    import ddt.view.PropItemView;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.utils.ObjectUtils;

    public class KeySetFrame extends BaseAlerFrame 
    {

        private var _list:HBox;
        private var _defaultSetPalel:KeyDefaultSetPanel;
        private var _currentSet:KeySetItem;
        private var _tempSets:Dictionary;
        private var numberAccect:Bitmap;
        private var _submit:TextButton;
        private var _cancel:TextButton;
        private var _imageRectString:String;

        public function KeySetFrame()
        {
            titleText = LanguageMgr.GetTranslation("tank.view.bagII.KeySetFrame.titleText");
            this.initContent();
            this.addEvent();
            this.escEnable = true;
        }

        private function initContent():void
        {
            var _local_1:String;
            this.numberAccect = ComponentFactory.Instance.creatBitmap("bagAndInfo.bag.keySetNumAsset");
            this._list = ComponentFactory.Instance.creatComponentByStylename("keySetHBox");
            this._tempSets = new Dictionary();
            for (_local_1 in SharedManager.Instance.GameKeySets)
            {
                this._tempSets[_local_1] = SharedManager.Instance.GameKeySets[_local_1];
            };
            this._submit = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.KeySet.SubmitButton");
            this._submit.text = LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm");
            addToContent(this._submit);
            this._cancel = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.bag.KeySet.CancelButton");
            this._cancel.text = LanguageMgr.GetTranslation("tank.view.DefyAfficheView.cancel");
            addToContent(this._cancel);
            this.creatCell();
            addToContent(this._list);
            addToContent(this.numberAccect);
            this._defaultSetPalel = new KeyDefaultSetPanel();
            this._defaultSetPalel.visible = false;
            this._defaultSetPalel.addEventListener(Event.SELECT, this.onItemSelected);
            this._defaultSetPalel.addEventListener(Event.REMOVED_FROM_STAGE, this.__ondefaultSetRemove);
            if (this._imageRectString != null)
            {
                MutipleImage(_backgound).imageRectString = this._imageRectString;
            };
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._submit.addEventListener(MouseEvent.CLICK, this.__onSubmit);
            this._cancel.addEventListener(MouseEvent.CLICK, this.__onCancel);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._submit.removeEventListener(MouseEvent.CLICK, this.__onSubmit);
            this._cancel.removeEventListener(MouseEvent.CLICK, this.__onCancel);
        }

        private function __onSubmit(_arg_1:MouseEvent):void
        {
            dispatchEvent(new FrameEvent(FrameEvent.ENTER_CLICK));
        }

        private function __onCancel(_arg_1:MouseEvent):void
        {
            dispatchEvent(new FrameEvent(FrameEvent.ESC_CLICK));
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.cancelClick();
                    return;
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    this.okClick();
                    return;
            };
        }

        private function okClick():void
        {
            var _local_1:String;
            for (_local_1 in this._tempSets)
            {
                SharedManager.Instance.GameKeySets[_local_1] = this._tempSets[_local_1];
            };
            SharedManager.Instance.save();
        }

        private function onItemClick(_arg_1:ItemEvent):void
        {
            _arg_1.stopImmediatePropagation();
            SoundManager.instance.play("008");
            this._currentSet = (_arg_1.currentTarget as KeySetItem);
            if (this._defaultSetPalel.parent)
            {
                removeChild(this._defaultSetPalel);
            };
            this._defaultSetPalel.visible = true;
            this._currentSet.glow = true;
            this._defaultSetPalel.x = (_arg_1.currentTarget.x + 2);
            this._defaultSetPalel.y = (this._list.y - this._defaultSetPalel.height);
            addChild(this._defaultSetPalel);
        }

        private function cancelClick():void
        {
            var _local_1:String;
            this._tempSets = new Dictionary();
            for (_local_1 in SharedManager.Instance.GameKeySets)
            {
                this._tempSets[_local_1] = SharedManager.Instance.GameKeySets[_local_1];
            };
            this.clearItemList();
        }

        private function __ondefaultSetRemove(_arg_1:Event):void
        {
            if (this._currentSet)
            {
                this._currentSet.glow = false;
            };
        }

        private function creatCell():void
        {
            var _local_1:String;
            var _local_2:ItemTemplateInfo;
            var _local_3:KeySetItem;
            this.clearItemList();
            for (_local_1 in this._tempSets)
            {
                _local_2 = ItemManager.Instance.getTemplateById(this._tempSets[_local_1]);
                if (_local_1 == "9")
                {
                    return;
                };
                if (_local_2)
                {
                    _local_3 = new KeySetItem(int(_local_1), int(_local_1), this._tempSets[_local_1], PropItemView.createView(_local_2.Pic, 40, 40));
                    _local_3.addEventListener(ItemEvent.ITEM_CLICK, this.onItemClick);
                    _local_3.setClick(true, false, true);
                    this._list.addChild(_local_3);
                };
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
            StageReferance.stage.focus = this;
        }

        private function clearItemList(_arg_1:Boolean=false):void
        {
            var _local_2:int;
            var _local_3:KeySetItem;
            if (this._list)
            {
                _local_2 = 0;
                while (_local_2 < this._list.numChildren)
                {
                    _local_3 = KeySetItem(this._list.getChildAt(_local_2));
                    _local_3.removeEventListener(ItemEvent.ITEM_CLICK, this.onItemClick);
                    _local_3.dispose();
                    _local_3 = null;
                    _local_2++;
                };
                ObjectUtils.disposeAllChildren(this._list);
                if (_arg_1)
                {
                    if (this._list.parent)
                    {
                        this._list.parent.removeChild(this._list);
                    };
                    this._list = null;
                };
            };
        }

        public function close():void
        {
            this._defaultSetPalel.hide();
            this.removeEvent();
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        private function onItemSelected(_arg_1:Event):void
        {
            if (stage)
            {
                stage.focus = this;
            };
            var _local_2:ItemTemplateInfo = ItemManager.Instance.getTemplateById(this._defaultSetPalel.selectedItemID);
            this._currentSet.setItem(PropItemView.createView(_local_2.Pic, 40, 40), false);
            this._currentSet.propID = this._defaultSetPalel.selectedItemID;
            this._tempSets[this._currentSet.index] = this._defaultSetPalel.selectedItemID;
        }

        override public function dispose():void
        {
            this.removeEvent();
            this.clearItemList(true);
            this._defaultSetPalel.removeEventListener(Event.SELECT, this.onItemSelected);
            this._defaultSetPalel.removeEventListener(Event.REMOVED_FROM_STAGE, this.__ondefaultSetRemove);
            this._defaultSetPalel.dispose();
            this._defaultSetPalel = null;
            ObjectUtils.disposeObject(this.numberAccect);
            this.numberAccect = null;
            ObjectUtils.disposeObject(this._submit);
            this._submit = null;
            ObjectUtils.disposeObject(this._cancel);
            this._cancel = null;
            if (this._currentSet)
            {
                this._currentSet.removeEventListener(ItemEvent.ITEM_CLICK, this.onItemClick);
                this._currentSet.dispose();
                this._currentSet = null;
            };
            if (parent)
            {
                parent.removeChild(this);
            };
            ObjectUtils.disposeObject(this._list);
            this._list = null;
            super.dispose();
        }

        public function set imageRectString(_arg_1:String):void
        {
            this._imageRectString = _arg_1;
            if (_backgound)
            {
                MutipleImage(_backgound).imageRectString = this._imageRectString;
            };
        }

        public function get imageRectString():String
        {
            return (this._imageRectString);
        }


    }
}//package bagAndInfo.bag

