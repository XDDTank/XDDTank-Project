// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.church.ChurchDialogueAgreePropose

package ddt.view.common.church
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import flash.display.Bitmap;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.ChurchManager;
    import church.controller.ChurchRoomListController;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.events.Event;

    public class ChurchDialogueAgreePropose extends BaseAlerFrame 
    {

        private var _bg:Bitmap;
        public var isShowed:Boolean = true;
        private var _alertInfo:AlertInfo;
        private var _msgInfo:String;
        private var _name_txt:FilterFrameText;

        public function ChurchDialogueAgreePropose()
        {
            this.initialize();
        }

        public function get msgInfo():String
        {
            return (this._msgInfo);
        }

        public function set msgInfo(_arg_1:String):void
        {
            this._msgInfo = _arg_1;
            this._name_txt.text = this._msgInfo;
            this.isShowed = false;
        }

        private function initialize():void
        {
            this._alertInfo = new AlertInfo();
            this._alertInfo.title = LanguageMgr.GetTranslation("tank.view.common.church.ProposeResponseFrame.titleText");
            this._alertInfo.submitLabel = LanguageMgr.GetTranslation("tank.view.common.church.DialogueAgreePropose.okLabel");
            this._alertInfo.cancelLabel = LanguageMgr.GetTranslation("tank.view.common.church.DialogueAgreePropose.cancelLabel");
            this._alertInfo.moveEnable = false;
            info = this._alertInfo;
            this.escEnable = true;
            this._bg = ComponentFactory.Instance.creatBitmap("asset.church.AgreeProposeAsset");
            addToContent(this._bg);
            this._name_txt = ComponentFactory.Instance.creat("common.church.churchDialogueAgreeProposeUserNameAsset");
            addToContent(this._name_txt);
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
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

        private function confirmSubmit():void
        {
            SoundManager.instance.play("008");
            ChurchManager.instance.showChurchlist(ChurchRoomListController.Instance.setup, UIModuleTypes.DDTCHURCH_ROOM_LIST);
            this.dispose();
        }

        public function show():void
        {
            SoundManager.instance.play("018");
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            this.isShowed = true;
        }

        override public function dispose():void
        {
            super.dispose();
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this._alertInfo = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._name_txt);
            this._name_txt = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            dispatchEvent(new Event(Event.CLOSE));
        }


    }
}//package ddt.view.common.church

