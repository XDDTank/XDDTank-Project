// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.FriendGroupFrame

package im
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.ComboBox;
    import __AS3__.vec.Vector;
    import im.info.CustomInfo;
    import flash.display.Bitmap;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.controls.list.VectorListModel;
    import ddt.manager.PlayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.events.ListItemEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class FriendGroupFrame extends Frame 
    {

        private var _confirm:TextButton;
        private var _close:TextButton;
        private var _combox:ComboBox;
        public var nickName:String;
        private var _customList:Vector.<CustomInfo>;

        public function FriendGroupFrame()
        {
            var _local_1:Bitmap;
            super();
            _local_1 = ComponentFactory.Instance.creatBitmap("asset.core.newFrame.titleBg");
            PositionUtils.setPos(_local_1, "friendGroupFrame.title.pos");
            var _local_2:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.titleLabel");
            _local_2.text = LanguageMgr.GetTranslation("ddt.friendGroup.LabelTxt");
            var _local_3:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.titleLabelI");
            _local_3.text = LanguageMgr.GetTranslation("ddt.friendGroup.LabelTxtI");
            titleText = LanguageMgr.GetTranslation("AlertDialog.Info");
            this._confirm = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.confirm");
            this._confirm.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
            this._close = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.close");
            this._close.text = LanguageMgr.GetTranslation("shop.PresentFrame.CancelBtnText");
            this._combox = ComponentFactory.Instance.creatComponentByStylename("friendGroupFrame.choose");
            addToContent(_local_1);
            addToContent(_local_2);
            addToContent(_local_3);
            addToContent(this._confirm);
            addToContent(this._close);
            addToContent(this._combox);
            this._combox.beginChanges();
            this._combox.selctedPropName = "text";
            var _local_4:VectorListModel = this._combox.listPanel.vectorListModel;
            _local_4.clear();
            this._customList = PlayerManager.Instance.customList;
            var _local_5:Array = new Array();
            var _local_6:int;
            while (_local_6 < (this._customList.length - 1))
            {
                _local_5.push(this._customList[_local_6].Name);
                _local_6++;
            };
            _local_4.appendAll(_local_5);
            this._combox.listPanel.list.updateListView();
            this._combox.commitChanges();
            this._combox.textField.text = this._customList[0].Name;
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._close.addEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._confirm.addEventListener(MouseEvent.CLICK, this.__confirmHandler);
            this._combox.button.addEventListener(MouseEvent.CLICK, this.__buttonClick);
            this._combox.listPanel.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
        }

        protected function __itemClick(_arg_1:ListItemEvent):void
        {
            SoundManager.instance.play("008");
        }

        protected function __confirmHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:int;
            while (_local_2 < this._customList.length)
            {
                if (this._customList[_local_2].Name == this._combox.textField.text)
                {
                    SocketManager.Instance.out.sendAddFriend(this.nickName, this._customList[_local_2].ID);
                    break;
                };
                _local_2++;
            };
            this.dispose();
        }

        protected function __clickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.dispose();
        }

        protected function __responseHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.ESC_CLICK:
                case FrameEvent.CLOSE_CLICK:
                    this.dispose();
                    return;
            };
        }

        protected function __buttonClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        override public function dispose():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            this._close.removeEventListener(MouseEvent.CLICK, this.__clickHandler);
            this._confirm.removeEventListener(MouseEvent.CLICK, this.__confirmHandler);
            this._combox.button.removeEventListener(MouseEvent.CLICK, this.__buttonClick);
            this._combox.listPanel.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
            this._customList = null;
            if (this._confirm)
            {
                ObjectUtils.disposeObject(this._confirm);
            };
            this._confirm = null;
            if (this._close)
            {
                ObjectUtils.disposeObject(this._close);
            };
            this._close = null;
            if (this._combox)
            {
                ObjectUtils.disposeObject(this._combox);
            };
            this._combox = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            IMController.Instance.clearGroupFrame();
        }


    }
}//package im

