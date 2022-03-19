// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//platformapi.tencent.view.closeFriend.InviteAwardFrameGetItem

package platformapi.tencent.view.closeFriend
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class InviteAwardFrameGetItem extends Sprite implements Disposeable 
    {

        private var _textField:FilterFrameText;
        private var _hLine:Bitmap;
        private var _getBtn:SimpleBitmapButton;
        private var _takenTip:Bitmap;
        private var _step:uint;

        public function InviteAwardFrameGetItem()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._textField = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.txt3");
            this._hLine = ComponentFactory.Instance.creatBitmap("asset.IM.inviteFrame.hLine");
            this._getBtn = ComponentFactory.Instance.creatComponentByStylename("IMFrame.inviteAward.getBtn");
            this._takenTip = ComponentFactory.Instance.creatBitmap("asset.IM.levelUpFrame.levelGift.GOT");
            this._takenTip.visible = false;
            addChild(this._textField);
            addChild(this._hLine);
            addChild(this._getBtn);
            addChild(this._takenTip);
            this.taken = false;
        }

        public function setText(_arg_1:int, _arg_2:int):void
        {
            var _local_3:String = LanguageMgr.GetTranslation("tank.view.im.InviteAwardFrame.txt3");
            var _local_4:String = (("<font color='#f5a10e'><b>" + _arg_2.toString()) + "</b></font>");
            _local_3 = _local_3.replace("{0}", _arg_1.toString());
            _local_3 = _local_3.replace("{1}", _local_4);
            this._textField.htmlText = _local_3;
        }

        public function set step(_arg_1:uint):void
        {
            this._step = _arg_1;
        }

        public function get step():uint
        {
            return (this._step);
        }

        public function set taken(_arg_1:Boolean):void
        {
            this._takenTip.visible = _arg_1;
        }

        public function set enable(_arg_1:Boolean):void
        {
            this._getBtn.enable = _arg_1;
        }

        private function initEvent():void
        {
            this._getBtn.addEventListener(MouseEvent.CLICK, this.__onGetBtnClicked);
        }

        private function removeEvent():void
        {
            this._getBtn.removeEventListener(MouseEvent.CLICK, this.__onGetBtnClicked);
        }

        private function __onGetBtnClicked(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            SocketManager.Instance.out.sendInvitedFriendAward(0, this._step, 0);
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._textField)
            {
                ObjectUtils.disposeObject(this._textField);
            };
            this._textField = null;
            if (this._hLine)
            {
                ObjectUtils.disposeObject(this._hLine);
            };
            this._hLine = null;
            if (this._getBtn)
            {
                ObjectUtils.disposeObject(this._getBtn);
            };
            this._getBtn = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package platformapi.tencent.view.closeFriend

