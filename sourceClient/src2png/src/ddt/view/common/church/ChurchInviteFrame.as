// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.church.ChurchInviteFrame

package ddt.view.common.church
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Bitmap;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.SocketManager;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ChurchInviteFrame extends BaseAlerFrame 
    {

        private var _inviteName:String;
        private var _roomid:int;
        private var _password:String;
        private var _sceneIndex:int;
        private var _name_txt:FilterFrameText;
        private var _bmTitle:Bitmap;
        private var _bmMsg:Bitmap;
        private var _alertInfo:AlertInfo;

        public function ChurchInviteFrame()
        {
            this.initialize();
        }

        private function initialize():void
        {
            this._alertInfo = new AlertInfo();
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        private function confirmSubmit():void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendEnterRoom(this._roomid, this._password, this._sceneIndex);
            this.dispose();
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    SoundManager.instance.play("008");
                    this.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    SoundManager.instance.play("008");
                    this.confirmSubmit();
                    return;
            };
        }

        public function set msgInfo(_arg_1:Object):void
        {
            this._inviteName = _arg_1["inviteName"];
            this._roomid = _arg_1["roomID"];
            this._password = _arg_1["pwd"];
            this._sceneIndex = _arg_1["sceneIndex"];
            this._name_txt = ComponentFactory.Instance.creatComponentByStylename("common.church.ChurchInviteFrameInfoAsset");
            this._name_txt.text = this._inviteName;
            addToContent(this._name_txt);
            this._bmTitle = ComponentFactory.Instance.creatBitmap("asset.church.churchInviteTitleAsset");
            addToContent(this._bmTitle);
            this._bmMsg = ComponentFactory.Instance.creatBitmap("asset.church.churchInviteMsgAsset");
            addToContent(this._bmMsg);
            this._bmMsg.x = ((this._name_txt.textWidth + this._name_txt.x) + 10);
            var _local_2:int = ((this._name_txt.textWidth + this._bmMsg.width) + 60);
            width = _local_2;
            this._bmTitle.x = (((_local_2 - this._bmTitle.width) / 2) - 30);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.STAGE_TOP_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            super.dispose();
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._alertInfo = null;
            ObjectUtils.disposeObject(this._name_txt);
            this._name_txt = null;
            ObjectUtils.disposeObject(this._bmTitle);
            this._bmTitle = null;
            ObjectUtils.disposeObject(this._bmMsg);
            this._bmMsg = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package ddt.view.common.church

