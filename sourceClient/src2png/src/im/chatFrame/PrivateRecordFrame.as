// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.chatFrame.PrivateRecordFrame

package im.chatFrame
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.text.TextArea;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.TextButton;
    import __AS3__.vec.Vector;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.controls.TextInput;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import ddt.manager.SoundManager;
    import flash.ui.Keyboard;
    import flash.events.Event;
    import ddt.manager.SharedManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PrivateRecordFrame extends Frame 
    {

        public static const PAGE_MESSAGE:int = 20;
        public static const CLOSE:String = "close";

        private var _content:TextArea;
        private var _contentBG:ScaleBitmapImage;
        private var _close:TextButton;
        private var _messages:Vector.<Object>;
        private var _totalPage:int = 1;
        private var _currentPage:int;
        private var _pageBG:Bitmap;
        private var _firstPage:SimpleBitmapButton;
        private var _prePage:SimpleBitmapButton;
        private var _nextPage:SimpleBitmapButton;
        private var _lastPage:SimpleBitmapButton;
        private var _pageInput:TextInput;
        private var _pageWord:FilterFrameText;

        public function PrivateRecordFrame()
        {
            _titleText = LanguageMgr.GetTranslation("IM.ChatFrame.recordFrame.title");
            this._contentBG = ComponentFactory.Instance.creatComponentByStylename("recordFrame.contentBG");
            this._content = ComponentFactory.Instance.creatComponentByStylename("recordFrame.content");
            this._close = ComponentFactory.Instance.creatComponentByStylename("recordFrame.close");
            this._close.text = LanguageMgr.GetTranslation("tank.invite.InviteView.close");
            this._pageBG = ComponentFactory.Instance.creatBitmap("asset.recordFrame.pageBG");
            this._firstPage = ComponentFactory.Instance.creatComponentByStylename("recordFrame.first");
            this._prePage = ComponentFactory.Instance.creatComponentByStylename("recordFrame.pre");
            this._nextPage = ComponentFactory.Instance.creatComponentByStylename("recordFrame.next");
            this._lastPage = ComponentFactory.Instance.creatComponentByStylename("recordFrame.last");
            this._pageInput = ComponentFactory.Instance.creatComponentByStylename("recordFrame.input");
            this._pageWord = ComponentFactory.Instance.creatComponentByStylename("recordFrame.word");
            addToContent(this._contentBG);
            addToContent(this._content);
            addToContent(this._close);
            addToContent(this._pageBG);
            addToContent(this._firstPage);
            addToContent(this._prePage);
            addToContent(this._nextPage);
            addToContent(this._lastPage);
            addToContent(this._pageInput);
            addToContent(this._pageWord);
            this._pageInput.textField.maxChars = 4;
            this._pageInput.textField.restrict = "0-9";
            this._close.addEventListener(MouseEvent.CLICK, this.__closeHandler);
            this._pageInput.addEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownHandler);
            this._firstPage.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._prePage.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._nextPage.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._lastPage.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._messages = new Vector.<Object>();
        }

        protected function __clickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.currentTarget)
            {
                case this._firstPage:
                    this.showPage(this._totalPage);
                    return;
                case this._prePage:
                    if (this._currentPage < this._totalPage)
                    {
                        this.showPage((this._currentPage + 1));
                    };
                    return;
                case this._nextPage:
                    if (this._currentPage > 1)
                    {
                        this.showPage((this._currentPage - 1));
                    };
                    return;
                case this._lastPage:
                    this.showPage(1);
                    return;
            };
        }

        protected function __keyDownHandler(_arg_1:KeyboardEvent):void
        {
            var _local_2:int;
            if (_arg_1.keyCode == Keyboard.ENTER)
            {
                SoundManager.instance.play("008");
                _local_2 = parseInt(this._pageInput.text);
                if (_local_2 > this._totalPage)
                {
                    _local_2 = this._totalPage;
                }
                else
                {
                    if (_local_2 < 1)
                    {
                        _local_2 = 1;
                    };
                };
                this.showPage(((this._totalPage + 1) - _local_2));
            };
        }

        protected function __closeHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            dispatchEvent(new Event(CLOSE));
        }

        public function set playerId(_arg_1:int):void
        {
            if (SharedManager.Instance.privateChatRecord[_arg_1])
            {
                this._messages = SharedManager.Instance.privateChatRecord[_arg_1];
            }
            else
            {
                this._messages = new Vector.<Object>();
            };
            this._totalPage = (((this._messages.length % PAGE_MESSAGE) == 0) ? int((this._messages.length / PAGE_MESSAGE)) : int((int((this._messages.length / PAGE_MESSAGE)) + 1)));
            this._totalPage = ((this._totalPage == 0) ? 1 : this._totalPage);
            this._pageWord.text = LanguageMgr.GetTranslation("IM.ChatFrame.recordFrame.pageWord", this._totalPage);
            this.showPage(1);
        }

        private function showPage(_arg_1:int):void
        {
            if (_arg_1 == 1)
            {
                this._lastPage.enable = false;
                this._nextPage.enable = false;
            }
            else
            {
                this._lastPage.enable = true;
                this._nextPage.enable = true;
            };
            if (_arg_1 == this._totalPage)
            {
                this._firstPage.enable = false;
                this._prePage.enable = false;
            }
            else
            {
                this._firstPage.enable = true;
                this._prePage.enable = true;
            };
            this._pageInput.text = ((this._totalPage + 1) - _arg_1).toString();
            this._currentPage = _arg_1;
            var _local_2:String = "";
            var _local_3:int = ((this._totalPage - this._currentPage) * PAGE_MESSAGE);
            var _local_4:int = (((this._totalPage - this._currentPage) + 1) * PAGE_MESSAGE);
            _local_3 = ((_local_3 < 0) ? 0 : _local_3);
            _local_4 = ((_local_4 > this._messages.length) ? this._messages.length : _local_4);
            var _local_5:int = _local_3;
            while (_local_5 < _local_4)
            {
                _local_2 = (_local_2 + (String(this._messages[_local_5]) + "<br/>"));
                _local_5++;
            };
            this._content.htmlText = _local_2;
            this._content.textField.setSelection((this._content.text.length - 1), (this._content.text.length - 1));
            this._content.upScrollArea();
        }

        override public function dispose():void
        {
            super.dispose();
            this._close.removeEventListener(MouseEvent.CLICK, this.__closeHandler);
            this._pageInput.removeEventListener(KeyboardEvent.KEY_DOWN, this.__keyDownHandler);
            this._firstPage.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._prePage.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._nextPage.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._lastPage.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._messages = null;
            if (this._content)
            {
                ObjectUtils.disposeObject(this._content);
            };
            this._content = null;
            if (this._contentBG)
            {
                ObjectUtils.disposeObject(this._contentBG);
            };
            this._contentBG = null;
            if (this._close)
            {
                ObjectUtils.disposeObject(this._close);
            };
            this._close = null;
            if (this._pageBG)
            {
                ObjectUtils.disposeObject(this._pageBG);
            };
            this._pageBG = null;
            if (this._firstPage)
            {
                ObjectUtils.disposeObject(this._firstPage);
            };
            this._firstPage = null;
            if (this._prePage)
            {
                ObjectUtils.disposeObject(this._prePage);
            };
            this._prePage = null;
            if (this._nextPage)
            {
                ObjectUtils.disposeObject(this._nextPage);
            };
            this._nextPage = null;
            if (this._lastPage)
            {
                ObjectUtils.disposeObject(this._lastPage);
            };
            this._lastPage = null;
            if (this._pageInput)
            {
                ObjectUtils.disposeObject(this._pageInput);
            };
            this._pageInput = null;
            if (this._pageWord)
            {
                ObjectUtils.disposeObject(this._pageWord);
            };
            this._pageWord = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package im.chatFrame

