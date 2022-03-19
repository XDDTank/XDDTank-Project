// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//shop.view.ShopPresentClearingFrame

package shop.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.view.NameInputDropListTarget;
    import com.pickgliss.ui.controls.list.DropList;
    import ddt.view.chat.ChatFriendListPanel;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.TextArea;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.manager.SoundManager;
    import ddt.manager.LeavePageManager;
    import flash.geom.Point;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PlayerManager;
    import consortion.ConsortionModelControl;

    public class ShopPresentClearingFrame extends Frame 
    {

        private var _titleTxt:FilterFrameText;
        private var _BG:Image;
        private var _BG1:ScaleBitmapImage;
        private var _textAreaBg:Image;
        private var _comboBoxLabel:FilterFrameText;
        private var _chooseFriendBtn:BaseButton;
        private var _nameInput:NameInputDropListTarget;
        private var _dropList:DropList;
        private var _friendList:ChatFriendListPanel;
        private var _cancelBtn:TextButton;
        private var _okBtn:TextButton;
        private var _textArea:TextArea;

        public function ShopPresentClearingFrame()
        {
            this.initView();
            this.initEvent();
        }

        public function get nameInput():NameInputDropListTarget
        {
            return (this._nameInput);
        }

        public function get presentBtn():BaseButton
        {
            return (this._okBtn);
        }

        public function get textArea():TextArea
        {
            return (this._textArea);
        }

        private function initView():void
        {
            escEnable = true;
            this.titleText = LanguageMgr.GetTranslation("shop.view.present");
            this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("shop.PresentFrame.titleText");
            this._titleTxt.text = LanguageMgr.GetTranslation("shop.PresentFrame.titleText");
            this._BG = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrameBg1");
            this._comboBoxLabel = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.ComboBoxLabel");
            this._comboBoxLabel.text = LanguageMgr.GetTranslation("shop.PresentFrame.ComboBoxLabel");
            this._chooseFriendBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.ChooseFriendBtn");
            this._nameInput = ComponentFactory.Instance.creatCustomObject("ddtshop.ClearingInterface.nameInput");
            this._dropList = ComponentFactory.Instance.creatComponentByStylename("droplist.SimpleDropList");
            this._dropList.targetDisplay = this._nameInput;
            this._dropList.x = this._nameInput.x;
            this._dropList.y = (this._nameInput.y + this._nameInput.height);
            this._friendList = new ChatFriendListPanel();
            this._friendList.setup(this.selectName);
            this._textArea = ComponentFactory.Instance.creatComponentByStylename("ddtshop.PresentClearingTextArea");
            this._textArea.maxChars = 200;
            this._textAreaBg = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.TextAreaBg");
            this._cancelBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.CancelBtn");
            this._cancelBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("core.ddtshop.PresentFrame.OkBtn");
            this._okBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
            addToContent(this._titleTxt);
            addToContent(this._BG);
            addToContent(this._comboBoxLabel);
            addToContent(this._chooseFriendBtn);
            addToContent(this._nameInput);
            addToContent(this._textArea);
            this._textArea.addChild(this._textAreaBg);
            addToContent(this._cancelBtn);
            addToContent(this._okBtn);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function selectName(_arg_1:String, _arg_2:int=0):void
        {
            this.setName(_arg_1);
            this._friendList.setVisible = false;
        }

        public function setName(_arg_1:String):void
        {
            this._nameInput.text = _arg_1;
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._nameInput.addEventListener(Event.CHANGE, this.__onReceiverChange);
            this._chooseFriendBtn.addEventListener(MouseEvent.CLICK, this.__showFramePanel);
            this._cancelBtn.addEventListener(MouseEvent.CLICK, this.__cancelPresent);
            StageReferance.stage.addEventListener(MouseEvent.CLICK, this.__hideDropList);
        }

        private function __cancelPresent(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new FrameEvent(FrameEvent.CANCEL_CLICK));
            this.dispose();
        }

        private function __buyMoney(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            LeavePageManager.leaveToFillPath();
        }

        private function __showFramePanel(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:Point = this._chooseFriendBtn.localToGlobal(new Point(0, 0));
            this._friendList.x = (_local_2.x - 95);
            this._friendList.y = (_local_2.y + this._chooseFriendBtn.height);
            this._friendList.setVisible = true;
            LayerManager.Instance.addToLayer(this._friendList, LayerManager.GAME_DYNAMIC_LAYER);
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                this.dispose();
            };
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            if (this._nameInput)
            {
                this._nameInput.removeEventListener(Event.CHANGE, this.__onReceiverChange);
            };
            if (this._chooseFriendBtn)
            {
                this._chooseFriendBtn.removeEventListener(MouseEvent.CLICK, this.__showFramePanel);
            };
            if (this._cancelBtn)
            {
                this._cancelBtn.removeEventListener(MouseEvent.CLICK, this.__buyMoney);
            };
            StageReferance.stage.removeEventListener(MouseEvent.CLICK, this.__hideDropList);
        }

        protected function __hideDropList(_arg_1:Event):void
        {
            if ((_arg_1.target is FilterFrameText))
            {
                return;
            };
            if (((this._dropList) && (this._dropList.parent)))
            {
                this._dropList.parent.removeChild(this._dropList);
            };
        }

        override public function dispose():void
        {
            this.removeEvent();
            super.dispose();
            if (this._dropList)
            {
                this._dropList = null;
            };
            if (this._friendList)
            {
                ObjectUtils.disposeObject(this._friendList);
            };
            this._friendList = null;
            this._titleTxt = null;
            this._BG = null;
            this._comboBoxLabel = null;
            this._chooseFriendBtn = null;
            this._nameInput = null;
            this._dropList = null;
            this._cancelBtn = null;
            this._okBtn = null;
            ObjectUtils.disposeObject(this._textAreaBg);
            this._textAreaBg = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }

        protected function __onReceiverChange(_arg_1:Event):void
        {
            if (this._nameInput.text == "")
            {
                this._dropList.dataList = null;
                return;
            };
            var _local_2:Array = PlayerManager.Instance.onlineFriendList.concat(PlayerManager.Instance.offlineFriendList).concat(ConsortionModelControl.Instance.model.onlineConsortiaMemberList).concat(ConsortionModelControl.Instance.model.offlineConsortiaMemberList);
            this._dropList.dataList = this.filterSearch(this.filterRepeatInArray(_local_2), this._nameInput.text);
        }

        private function filterRepeatInArray(_arg_1:Array):Array
        {
            var _local_4:int;
            var _local_2:Array = new Array();
            var _local_3:int;
            while (_local_3 < _arg_1.length)
            {
                if (_local_3 == 0)
                {
                    _local_2.push(_arg_1[_local_3]);
                };
                _local_4 = 0;
                while (_local_4 < _local_2.length)
                {
                    if (_local_2[_local_4].NickName == _arg_1[_local_3].NickName) break;
                    if (_local_4 == (_local_2.length - 1))
                    {
                        _local_2.push(_arg_1[_local_3]);
                    };
                    _local_4++;
                };
                _local_3++;
            };
            return (_local_2);
        }

        private function filterSearch(_arg_1:Array, _arg_2:String):Array
        {
            var _local_3:Array = [];
            var _local_4:int;
            while (_local_4 < _arg_1.length)
            {
                if (_arg_1[_local_4].NickName.indexOf(_arg_2) != -1)
                {
                    _local_3.push(_arg_1[_local_4]);
                };
                _local_4++;
            };
            return (_local_3);
        }


    }
}//package shop.view

