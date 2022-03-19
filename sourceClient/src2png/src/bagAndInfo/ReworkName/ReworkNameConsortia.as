// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.ReworkName.ReworkNameConsortia

package bagAndInfo.ReworkName
{
    import ddt.manager.LanguageMgr;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.ComponentFactory;
    import road7th.utils.StringHelper;
    import flash.events.Event;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import ddt.utils.FilterWordManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SocketManager;
    import ddt.manager.PlayerManager;
    import ddt.data.analyze.ReworkNameAnalyzer;

    public class ReworkNameConsortia extends ReworkNameFrame 
    {

        public function ReworkNameConsortia()
        {
            _path = "ConsortiaNameCheck.ashx";
            _nicknameDetail = LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert");
        }

        override protected function configUi():void
        {
            super.configUi();
            titleText = LanguageMgr.GetTranslation("tank.view.ReworkNameView.consortiaReworkName");
            _tittleField.text = LanguageMgr.GetTranslation("tank.view.ReworkNameView.consortiaInputName");
            _resultField.text = LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert");
            if (_nicknameInput)
            {
                ObjectUtils.disposeObject(_nicknameInput);
                _nicknameInput = null;
            };
            _nicknameInput = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.reworkname.ConsortiaInput");
            addToContent(_nicknameInput);
        }

        override protected function __onInputChange(_arg_1:Event):void
        {
            super.__onInputChange(_arg_1);
            StringHelper.checkTextFieldLength(_nicknameInput, 18);
        }

        override protected function nameInputCheck():Boolean
        {
            var _local_1:BaseAlerFrame;
            if (_nicknameInput.text != "")
            {
                if (FilterWordManager.isGotForbiddenWords(_nicknameInput.text, "name"))
                {
                    _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.RenameFrame.Consortia.FailWord"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_1.addEventListener(FrameEvent.RESPONSE, __onAlertResponse);
                    return (false);
                };
                if (FilterWordManager.IsNullorEmpty(_nicknameInput.text))
                {
                    _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.RenameFrame.Consortia.space"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_1.addEventListener(FrameEvent.RESPONSE, __onAlertResponse);
                    return (false);
                };
                if (FilterWordManager.containUnableChar(_nicknameInput.text))
                {
                    _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.RenameFrame.Consortia.string"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_1.addEventListener(FrameEvent.RESPONSE, __onAlertResponse);
                    return (false);
                };
                return (true);
            };
            _local_1 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.RenameFrame.Consortia.input"), LanguageMgr.GetTranslation("ok"), "", false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            _local_1.addEventListener(FrameEvent.RESPONSE, __onAlertResponse);
            return (false);
        }

        override protected function setCheckTxt(_arg_1:String):void
        {
            if (_arg_1 == LanguageMgr.GetTranslation("tank.view.ConsortiaReworkNameView.consortiaNameAlert4"))
            {
                state = Aviable;
                _isCanRework = true;
            }
            else
            {
                state = Unavialbe;
            };
            _resultField.text = _arg_1;
        }

        override protected function submitCheckCallBack(_arg_1:ReworkNameAnalyzer):void
        {
            var _local_3:String;
            complete = true;
            var _local_2:XML = _arg_1.result;
            this.setCheckTxt(_local_2.@message);
            if (((this.nameInputCheck()) && (_isCanRework)))
            {
                _local_3 = _nicknameInput.text;
                SocketManager.Instance.out.sendUseConsortiaReworkName(PlayerManager.Instance.Self.ConsortiaID, _bagType, _place, _local_3);
                reworkNameComplete();
            };
        }


    }
}//package bagAndInfo.ReworkName

