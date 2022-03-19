// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.closeFriend.InviteAwardFrame

package platformapi.tencent.view.closeFriend
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import __AS3__.vec.Vector;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import com.pickgliss.events.FrameEvent;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import platformapi.tencent.TencentExternalInterfaceManager;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.LayerManager;
    import __AS3__.vec.*;

    public class InviteAwardFrame extends Frame 
    {

        private var _bg1:Scale9CornerImage;
        private var _bg2:Scale9CornerImage;
        private var _bg3:Scale9CornerImage;
        private var _inviteBtn:SimpleBitmapButton;
        private var _titleBitmap:Bitmap;
        private var _titleBGBitmap:Bitmap;
        private var _titleTipBitmap:Bitmap;
        private var _vLine:Bitmap;
        private var _textField1:FilterFrameText;
        private var _textField2:FilterFrameText;
        private var _getItemArray:Vector.<InviteAwardFrameGetItem>;

        public function InviteAwardFrame()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.title");
            this._bg1 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.BG1");
            this._bg2 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.BG2");
            this._bg3 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.BG3");
            this._inviteBtn = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.inviteBtn");
            this._titleBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.title");
            this._titleBGBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.titleBG");
            this._titleTipBitmap = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.inviteTip");
            this._vLine = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.vLine");
            this._textField1 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.txt1");
            this._textField2 = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.txt2");
            this._textField1.text = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.txt1");
            this._textField2.text = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.txt2");
            addToContent(this._bg1);
            addToContent(this._bg2);
            addToContent(this._bg3);
            addToContent(this._titleBGBitmap);
            addToContent(this._titleBitmap);
            addToContent(this._titleTipBitmap);
            addToContent(this._inviteBtn);
            addToContent(this._textField1);
            addToContent(this._textField2);
            addToContent(this._vLine);
            this.initCell();
        }

        private function initCell():void
        {
            var _local_3:uint;
            var _local_4:InviteAwardFrameGetItem;
            this._getItemArray = new Vector.<InviteAwardFrameGetItem>();
            var _local_1:String = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.txt4");
            var _local_2:Array = _local_1.split(",");
            _local_3 = 0;
            while (_local_3 < 8)
            {
                _local_4 = new InviteAwardFrameGetItem();
                _local_4.step = (_local_3 + 1);
                _local_4.setText((_local_3 + 1), _local_2[_local_3]);
                _local_4.x = (34 + (int((_local_3 / 4)) * 327));
                _local_4.y = (204 + ((_local_3 % 4) * 37));
                addToContent(_local_4);
                this._getItemArray.push(_local_4);
                this.updateBtn();
                _local_3++;
            };
        }

        public function updateBtn():void
        {
            var _local_1:InviteAwardFrameGetItem;
            for each (_local_1 in this._getItemArray)
            {
                if (_local_1.step <= PlayerManager.Instance.invitedAwardStep)
                {
                    _local_1.enable = false;
                    _local_1.taken = true;
                }
                else
                {
                    if (_local_1.step > (PlayerManager.Instance.invitedAwardStep + 1))
                    {
                        _local_1.enable = false;
                    }
                    else
                    {
                        _local_1.enable = true;
                    };
                };
            };
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            PlayerManager.Instance.addEventListener(Event.CHANGE, this.__onUpdate);
            if (this._inviteBtn)
            {
                this._inviteBtn.addEventListener(MouseEvent.CLICK, this.__inviteBtnClick);
            };
        }

        private function __inviteBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            TencentExternalInterfaceManager.invite();
        }

        private function __onUpdate(_arg_1:Event):void
        {
            this.updateBtn();
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.playButtonSound();
                ObjectUtils.disposeObject(this);
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            PlayerManager.Instance.removeEventListener(Event.CHANGE, this.__onUpdate);
        }

        override public function dispose():void
        {
            var _local_1:InviteAwardFrameGetItem;
            this.removeEvent();
            for each (_local_1 in this._getItemArray)
            {
                if (_local_1)
                {
                    ObjectUtils.disposeObject(_local_1);
                };
            };
            this._getItemArray = null;
            if (this._bg1)
            {
                ObjectUtils.disposeObject(this._bg1);
            };
            this._bg1 = null;
            if (this._bg2)
            {
                ObjectUtils.disposeObject(this._bg2);
            };
            this._bg2 = null;
            if (this._bg3)
            {
                ObjectUtils.disposeObject(this._bg3);
            };
            this._bg3 = null;
            if (this._inviteBtn)
            {
                ObjectUtils.disposeObject(this._inviteBtn);
            };
            this._inviteBtn = null;
            if (this._titleBitmap)
            {
                ObjectUtils.disposeObject(this._titleBitmap);
            };
            this._titleBitmap = null;
            if (this._titleBGBitmap)
            {
                ObjectUtils.disposeObject(this._titleBGBitmap);
            };
            this._titleBGBitmap = null;
            if (this._titleTipBitmap)
            {
                ObjectUtils.disposeObject(this._titleTipBitmap);
            };
            this._titleTipBitmap = null;
            if (this._textField1)
            {
                ObjectUtils.disposeObject(this._textField1);
            };
            this._textField1 = null;
            if (this._textField2)
            {
                ObjectUtils.disposeObject(this._textField2);
            };
            this._textField2 = null;
            if (this._vLine)
            {
                ObjectUtils.disposeObject(this._vLine);
            };
            this._vLine = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            super.dispose();
        }


    }
}//package platformapi.tencent.view.closeFriend

