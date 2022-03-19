// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatFastReplyPanel

package ddt.view.chat
{
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.container.VBox;
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Shape;
    import ddt.manager.ChatManager;
    import ddt.manager.SoundManager;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.SharedManager;
    import ddt.utils.FilterWordManager;
    import com.pickgliss.toplevel.StageReferance;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.FocusEvent;
    import flash.events.KeyboardEvent;
    import flash.events.TextEvent;
    import flash.ui.Keyboard;
    import __AS3__.vec.*;

    public class ChatFastReplyPanel extends ChatBasePanel 
    {

        public static const SELECTED_INGAME:String = "selectedingame";
        private static const FASTREPLYS:Array = [LanguageMgr.GetTranslation("chat.fastRepley.Message0"), LanguageMgr.GetTranslation("chat.fastRepley.Message1"), LanguageMgr.GetTranslation("chat.fastRepley.Message2"), LanguageMgr.GetTranslation("chat.fastRepley.Message3"), LanguageMgr.GetTranslation("chat.fastRepley.Message4")];

        private var _bg:ScaleBitmapImage;
        private var _box:VBox;
        private var _inGame:Boolean;
        private var _items:Vector.<ChatFastReplyItem>;
        private var _selected:String;
        private var _boundary:Bitmap;
        private var _inputBg:Bitmap;
        private var _enterBtn:SimpleBitmapButton;
        private var _inputBox:FilterFrameText;
        private var _defaultStr:String;
        private var _customCnt:uint;
        private var _isDeleting:Boolean;
        private var _customBg:Shape;
        private var _tempText:String;
        private var _isEditing:Boolean;

        public function ChatFastReplyPanel(_arg_1:Boolean=false)
        {
            this._inGame = _arg_1;
            super();
        }

        public function get isEditing():Boolean
        {
            return (this._isEditing);
        }

        public function set isEditing(_arg_1:Boolean):void
        {
            this._isEditing = _arg_1;
        }

        public function get selectedWrod():String
        {
            return (this._selected);
        }

        override public function set setVisible(_arg_1:Boolean):void
        {
            super.setVisible = _arg_1;
            if (_arg_1)
            {
                if (ChatManager.Instance.isInGame)
                {
                    this.isEditing = true;
                };
                this.fixVerticalPos();
                this._tempText = this._inputBox.text;
                this._inputBox.text = this._defaultStr;
                this._inputBox.scrollH = 0;
            };
        }

        public function setText():void
        {
            visible = true;
            this._inputBox.text = this._tempText;
            y = (y + ((this._items.length - 5) * 21));
            this.isEditing = false;
        }

        private function __itemClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:ChatFastReplyItem = (_arg_1.currentTarget as ChatFastReplyItem);
            this._selected = _local_2.word;
            if (this._inGame)
            {
                dispatchEvent(new Event(SELECTED_INGAME));
            }
            else
            {
                dispatchEvent(new Event(Event.SELECT));
            };
        }

        private function __mouseClick(_arg_1:*):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            switch (_arg_1.currentTarget)
            {
                case this._inputBox:
                    if (this._inputBox.text == this._defaultStr)
                    {
                        this._inputBox.text = "";
                    };
                    return;
                case this._enterBtn:
                    this.createCustomItem();
                    return;
                default:
                    if (this._isDeleting)
                    {
                        this._isDeleting = false;
                        return;
                    };
            };
        }

        private function __deleteItem(_arg_1:ChatEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:ChatFastReplyItem = (_arg_1.data as ChatFastReplyItem);
            var _local_3:uint = this._items.indexOf(_local_2);
            _local_2.removeEventListener(MouseEvent.CLICK, this.__itemClick);
            _local_2.dispose();
            this._items.splice(_local_3, 1);
            ChatManager.Instance.model.customFastReply.splice((_local_3 - 5), 1);
            delete SharedManager.Instance.fastReplys[_local_2.word];
            SharedManager.Instance.save();
            this._customCnt--;
            this.updatePos(-1);
            this._isDeleting = true;
        }

        private function createCustomItem():void
        {
            if (((this._inputBox.text == "") || (this._inputBox.text == this._defaultStr)))
            {
                return;
            };
            if (this._customCnt >= 5)
            {
                ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("chat.FastReplyCustomCountLimit"));
                return;
            };
            var _local_1:String = FilterWordManager.filterWrod(this._inputBox.text);
            var _local_2:ChatFastReplyItem = new ChatFastReplyItem(_local_1, true);
            _local_2.addEventListener(MouseEvent.CLICK, this.__itemClick);
            _local_2.addEventListener(ChatEvent.DELETE, this.__deleteItem);
            this._items.push(_local_2);
            ChatManager.Instance.model.customFastReply.push(_local_2.word);
            this._box.addChild(_local_2);
            SharedManager.Instance.fastReplys[_local_2.word] = _local_2.word;
            SharedManager.Instance.save();
            this._customCnt++;
            this.updatePos(1);
            this._inputBox.text = this._defaultStr;
            this._inputBox.scrollH = 0;
            StageReferance.stage.focus = null;
        }

        private function updatePos(_arg_1:int):void
        {
            this._inputBg.y = (this._box.height + 10);
            this._enterBtn.y = (this._inputBg.y + 2);
            this._inputBox.y = (this._enterBtn.y + 2);
            this._bg.height = ((this._inputBox.y + this._inputBox.height) + 6);
            this._customBg.y = ((this._boundary.y + this._boundary.height) + 8);
            if (this._customCnt == 0)
            {
                this._customBg.height = 0;
            }
            else
            {
                this._customBg.height = ((this._box.height - this._customBg.y) + 8);
            };
            y = (y - (21 * _arg_1));
        }

        private function fixVerticalPos():void
        {
            var _local_1:uint = (this._items.length - 5);
            y = (y - (_local_1 * 21));
        }

        override protected function init():void
        {
            var _local_2:String;
            var _local_3:ChatFastReplyItem;
            var _local_4:ChatFastReplyItem;
            super.init();
            this._defaultStr = LanguageMgr.GetTranslation("chat.FastReplyDefaultStr");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.FastReplyBg");
            this._box = ComponentFactory.Instance.creatComponentByStylename("chat.FastReplyList");
            this._boundary = ComponentFactory.Instance.creatBitmap("asset.chat.FastReplyBoundary");
            this._inputBg = ComponentFactory.Instance.creatBitmap("asset.chat.FastReplyInputBg");
            this._enterBtn = ComponentFactory.Instance.creatComponentByStylename("chat.FastReplyEnterBtn");
            this._inputBox = ComponentFactory.Instance.creatComponentByStylename("chat.FastReplyInputTxt");
            this._customBg = new Shape();
            this._customBg.graphics.beginFill(12166, 0.4);
            this._customBg.graphics.drawRect(5, 0, 168, 1);
            this._customBg.graphics.endFill();
            this._items = new Vector.<ChatFastReplyItem>();
            var _local_1:int;
            while (_local_1 < FASTREPLYS.length)
            {
                _local_3 = new ChatFastReplyItem(FASTREPLYS[_local_1]);
                _local_3.addEventListener(MouseEvent.CLICK, this.__itemClick);
                this._items.push(_local_3);
                this._box.addChild(_local_3);
                _local_1++;
            };
            this._box.addChild(this._boundary);
            for (_local_2 in SharedManager.Instance.fastReplys)
            {
                _local_4 = new ChatFastReplyItem(SharedManager.Instance.fastReplys[_local_2], true);
                _local_4.addEventListener(MouseEvent.CLICK, this.__itemClick);
                _local_4.addEventListener(ChatEvent.DELETE, this.__deleteItem);
                ChatManager.Instance.model.customFastReply.push(_local_4.word);
                this._items.push(_local_4);
                this._box.addChild(_local_4);
                this._customCnt++;
            };
            this._inputBox.maxChars = 20;
            this._inputBox.text = this._defaultStr;
            this._selected = "";
            this.updatePos(0);
            this.fixVerticalPos();
            addChild(this._bg);
            addChild(this._customBg);
            addChild(this._box);
            addChild(this._inputBg);
            addChild(this._enterBtn);
            addChild(this._inputBox);
        }

        override protected function initEvent():void
        {
            super.initEvent();
            this._inputBox.addEventListener(FocusEvent.FOCUS_OUT, this.__focusOut);
            this._inputBox.addEventListener(KeyboardEvent.KEY_DOWN, this.__creatItem);
            this._inputBox.addEventListener(MouseEvent.CLICK, this.__mouseClick);
            this._inputBox.addEventListener(TextEvent.TEXT_INPUT, this.__checkMaxChars);
            this._enterBtn.addEventListener(MouseEvent.CLICK, this.__mouseClick);
            addEventListener(MouseEvent.CLICK, this.__spriteClick);
        }

        private function __spriteClick(_arg_1:MouseEvent):void
        {
            this.isEditing = false;
        }

        private function __checkMaxChars(_arg_1:TextEvent):void
        {
            if (this._inputBox.length >= 20)
            {
                ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("chat.FastReplyCustomTextLengthLimit"));
            };
        }

        private function __creatItem(_arg_1:KeyboardEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                SoundManager.instance.play("008");
                this.createCustomItem();
            };
        }

        private function __focusOut(_arg_1:FocusEvent):void
        {
            if (((_arg_1.currentTarget.text == "") || (_arg_1.currentTarget.text == this._defaultStr)))
            {
                _arg_1.currentTarget.text = this._defaultStr;
            };
        }


    }
}//package ddt.view.chat

