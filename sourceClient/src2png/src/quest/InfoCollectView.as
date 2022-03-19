// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.InfoCollectView

package quest
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import road7th.utils.StringHelper;
    import flash.events.FocusEvent;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;
    import flash.events.Event;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;

    public class InfoCollectView extends Sprite implements Disposeable 
    {

        public var Type:int = 2;
        protected var _dataLabel:FilterFrameText;
        protected var _validateLabel:FilterFrameText;
        protected var _inputData:FilterFrameText;
        protected var _inputValidate:FilterFrameText;
        protected var _dataAlert:FilterFrameText;
        protected var _valiAlert:FilterFrameText;
        private var _submitBtn:TextButton;
        private var _sendBtn:TextButton;

        public function InfoCollectView()
        {
            this.init();
        }

        private function init():void
        {
            this.addLabel();
            this._inputData = ComponentFactory.Instance.creat("core.quest.infoCollect.InputData");
            this._sendBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.infoCollect.SubmitBtn");
            this._sendBtn.text = LanguageMgr.GetTranslation("im.InviteDialogFrame.send");
            this._dataLabel.y = this._inputData.y;
            this._sendBtn.y = (this._dataLabel.y - 1);
            this._dataAlert = ComponentFactory.Instance.creat("core.quest.infoCollect.Alert");
            this._inputValidate = ComponentFactory.Instance.creat("core.quest.infoCollect.InputValidate");
            this._validateLabel = ComponentFactory.Instance.creat("core.quest.infoCollect.Label");
            this._validateLabel.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.validate");
            this._submitBtn = ComponentFactory.Instance.creatComponentByStylename("core.quest.infoCollect.CheckBtn");
            this._submitBtn.text = StringHelper.trimAll(LanguageMgr.GetTranslation("core.quest.valid"));
            this._validateLabel.y = this._inputValidate.y;
            this._submitBtn.y = (this._validateLabel.y - 1);
            this._valiAlert = ComponentFactory.Instance.creat("core.quest.infoCollect.Result");
            addChild(this._inputData);
            addChild(this._dataLabel);
            addChild(this._inputValidate);
            addChild(this._dataAlert);
            addChild(this._validateLabel);
            addChild(this._sendBtn);
            addChild(this._submitBtn);
            addChild(this._valiAlert);
            this._inputData.addEventListener(FocusEvent.FOCUS_OUT, this.__onDataFocusOut);
            this._sendBtn.addEventListener(MouseEvent.CLICK, this.__onSendBtn);
            this._submitBtn.addEventListener(MouseEvent.CLICK, this._onSubmitBtn);
            this.modifyView();
        }

        protected function modifyView():void
        {
            this._inputData.restrict = "0-9";
        }

        protected function addLabel():void
        {
            this._dataLabel = ComponentFactory.Instance.creat("core.quest.infoCollect.Label");
            this._dataLabel.text = LanguageMgr.GetTranslation("ddt.quest.collectInfo.phone");
        }

        protected function validate():void
        {
            this.alert("ddt.quest.collectInfo.validateSend");
        }

        protected function __onSendBtn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            if (this._inputData.text.length < 1)
            {
                this.alert("ddt.quest.collectInfo.noPhone");
                return;
            };
            if (this._inputData.text.length > 11)
            {
                this.alert("ddt.quest.collectInfo.phoneNumberError");
                return;
            };
            this.sendData();
        }

        protected function _onSubmitBtn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.playButtonSound();
            this.sendValidate();
        }

        protected function sendData():void
        {
            var _local_1:Number = PlayerManager.Instance.Self.ID;
            var _local_2:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_2["selfid"] = _local_1;
            _local_2["input"] = this._inputData.text;
            _local_2["rnd"] = Math.random();
            this.fillArgs(_local_2);
            var _local_3:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("SendActiveKeySystem.ashx"), BaseLoader.REQUEST_LOADER, _local_2);
            _local_3.addEventListener(LoaderEvent.COMPLETE, this.__onDataLoad);
            LoadResourceManager.instance.startLoad(_local_3);
        }

        protected function fillArgs(_arg_1:URLVariables):URLVariables
        {
            _arg_1["phone"] = _arg_1["input"];
            return (_arg_1);
        }

        private function __onDataLoad(_arg_1:LoaderEvent):void
        {
            var _local_2:XML = XML(_arg_1.loader.content);
            var _local_3:String = _local_2.@value;
            if (_local_3 == "true")
            {
            };
            this.dalert(_local_2.@message);
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
        }

        private function __onDataFocusOut(_arg_1:Event):void
        {
            this.alert(this.updateHelper(this._inputData.text));
        }

        protected function updateHelper(_arg_1:String):String
        {
            if (_arg_1.length > 11)
            {
                return ("ddt.quest.collectInfo.phoneNumberError");
            };
            return ("");
        }

        protected function dalert(_arg_1:String):void
        {
            this._dataAlert.text = _arg_1;
        }

        protected function alert(_arg_1:String):void
        {
            this._dataAlert.text = LanguageMgr.GetTranslation(_arg_1);
        }

        protected function dalertVali(_arg_1:String):void
        {
            this._valiAlert.text = _arg_1;
        }

        protected function alertVali(_arg_1:String):void
        {
            this._valiAlert.text = LanguageMgr.GetTranslation(_arg_1);
        }

        private function sendValidate():void
        {
            if (this._inputValidate.text.length < 1)
            {
                this.alertVali("ddt.quest.collectInfo.noValidate");
                return;
            };
            if (this._inputValidate.text.length < 6)
            {
                this.alertVali("ddt.quest.collectInfo.validateError");
                return;
            };
            if (this._inputValidate.text.length > 6)
            {
                this.alertVali("ddt.quest.collectInfo.validateError");
                return;
            };
            SocketManager.Instance.out.sendCollectInfoValidate(this.Type, this._inputValidate.text);
        }

        public function dispose():void
        {
            this._inputData.removeEventListener(FocusEvent.FOCUS_OUT, this.__onDataFocusOut);
            this._sendBtn.removeEventListener(MouseEvent.CLICK, this.__onSendBtn);
            this._submitBtn.removeEventListener(MouseEvent.CLICK, this._onSubmitBtn);
            ObjectUtils.disposeObject(this._dataLabel);
            this._dataLabel = null;
            ObjectUtils.disposeObject(this._validateLabel);
            this._validateLabel = null;
            ObjectUtils.disposeObject(this._inputData);
            this._inputData = null;
            ObjectUtils.disposeObject(this._inputValidate);
            this._inputValidate = null;
            ObjectUtils.disposeObject(this._valiAlert);
            this._valiAlert = null;
            ObjectUtils.disposeObject(this._submitBtn);
            this._submitBtn = null;
            ObjectUtils.disposeObject(this._sendBtn);
            this._sendBtn = null;
        }


    }
}//package quest

