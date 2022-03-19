﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.chat.ChatFastReplyItem

package ddt.view.chat
{
    import flash.display.Sprite;
    import flash.display.Bitmap;
    import flash.text.TextField;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.ComponentFactory;
    import flash.text.TextFormat;

    public class ChatFastReplyItem extends Sprite 
    {

        private var _bg:Bitmap;
        private var _contentTxt:TextField;
        private var _itemText:String;
        private var _isCustom:Boolean;
        private var _deleteBtn:SimpleBitmapButton;

        public function ChatFastReplyItem(_arg_1:String, _arg_2:Boolean=false)
        {
            this._itemText = _arg_1;
            this._isCustom = _arg_2;
            this.init();
            this.initEvent();
        }

        public function dispose():void
        {
            this.removeEvent();
            this._bg = null;
            this._contentTxt = null;
            this._deleteBtn.dispose();
            this._deleteBtn = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function get word():String
        {
            return (this._itemText);
        }

        private function __mouseOut(_arg_1:MouseEvent):void
        {
            this._bg.alpha = (this._deleteBtn.alpha = 0);
        }

        private function __mouseOver(_arg_1:MouseEvent):void
        {
            this._bg.alpha = (this._deleteBtn.alpha = 1);
        }

        private function init():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.chat.FastReplyItemBg");
            this._deleteBtn = ComponentFactory.Instance.creatComponentByStylename("chat.FastReplyDeleteBtn");
            this._bg.alpha = (this._deleteBtn.alpha = 0);
            this._contentTxt = new TextField();
            this._contentTxt.text = String(this._itemText);
            this._contentTxt.height = this._bg.height;
            this._contentTxt.width = this._bg.width;
            this._contentTxt.mouseEnabled = false;
            var _local_1:TextFormat = new TextFormat("Arial", 12, 0xFFFFFF);
            this._contentTxt.setTextFormat(_local_1);
            addChild(this._bg);
            addChild(this._contentTxt);
            if (this._isCustom)
            {
                addChild(this._deleteBtn);
                this._contentTxt.width = ((this._bg.width - this._deleteBtn.width) - 5);
            };
        }

        public function get deleteBtn():SimpleBitmapButton
        {
            return (this._deleteBtn);
        }

        private function initEvent():void
        {
            addEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
            this._deleteBtn.addEventListener(MouseEvent.CLICK, this.__delete);
        }

        private function removeEvent():void
        {
            removeEventListener(MouseEvent.MOUSE_OVER, this.__mouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, this.__mouseOut);
            this._deleteBtn.removeEventListener(MouseEvent.CLICK, this.__delete);
        }

        private function __delete(_arg_1:MouseEvent):void
        {
            dispatchEvent(new ChatEvent(ChatEvent.DELETE, this));
        }


    }
}//package ddt.view.chat

