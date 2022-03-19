// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.consortiaTask.ConsortiaReleaseTaskFrame

package consortion.view.selfConsortia.consortiaTask
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import consortion.ConsortionModelControl;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.ServerConfigManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SocketManager;

    public class ConsortiaReleaseTaskFrame extends BaseAlerFrame 
    {

        private var _arr:Array = [3, 3, 5, 5, 8, 8, 10, 10, 12, 12];
        private var _releaseContentTextScale9BG:Scale9CornerImage;
        private var _content:MovieImage;

        public function ConsortiaReleaseTaskFrame()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.submitLabel = LanguageMgr.GetTranslation("consortia.task.releaseTable");
            _local_1.title = LanguageMgr.GetTranslation("consortia.task.releaseTable.title");
            _local_1.showCancel = false;
            info = _local_1;
            this._releaseContentTextScale9BG = ComponentFactory.Instance.creatComponentByStylename("consortion.releaseContentTextScale9BG");
            this._content = ComponentFactory.Instance.creatComponentByStylename("conortion.releaseContentText");
            addToContent(this._releaseContentTextScale9BG);
            addToContent(this._content);
        }

        private function initEvents():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
        }

        private function removeEvents():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__response);
        }

        private function __response(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                if (ConsortionModelControl.Instance.TaskModel.isHaveTask_noRelease)
                {
                    ConsortionModelControl.Instance.TaskModel.isHaveTask_noRelease = false;
                    ObjectUtils.disposeObject(this);
                }
                else
                {
                    this.__okClick();
                    ObjectUtils.disposeObject(this);
                };
            }
            else
            {
                ObjectUtils.disposeObject(this);
            };
        }

        private function __okClick():void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_1:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.okTable"), LanguageMgr.GetTranslation("consortia.task.OKContent", ServerConfigManager.instance.MissionRiches[(PlayerManager.Instance.Self.consortiaInfo.Level - 1)]), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.ALPHA_BLOCKGOUND);
            _local_1.moveEnable = false;
            _local_1.addEventListener(FrameEvent.RESPONSE, this._responseII);
        }

        private function _responseII(_arg_1:FrameEvent):void
        {
            (_arg_1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this._responseII);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.consortiaInfo.Riches < ServerConfigManager.instance.MissionRiches[(PlayerManager.Instance.Self.consortiaInfo.Level - 1)])
                {
                    this.__openRichesTip();
                }
                else
                {
                    SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.RELEASE_TASK);
                    SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.SUMBIT_TASK);
                    ObjectUtils.disposeObject(this);
                };
            };
            ObjectUtils.disposeObject((_arg_1.currentTarget as BaseAlerFrame));
        }

        private function __openRichesTip():void
        {
            var _local_1:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.consortion.skillItem.click.enough1"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
            _local_1.addEventListener(FrameEvent.RESPONSE, this.__noEnoughHandler);
        }

        private function __noEnoughHandler(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.SUBMIT_CLICK:
                case FrameEvent.ENTER_CLICK:
                    ConsortionModelControl.Instance.alertTaxFrame();
                    break;
            };
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__noEnoughHandler);
            _local_2.dispose();
            _local_2 = null;
        }

        override public function dispose():void
        {
            this.removeEvents();
            this._releaseContentTextScale9BG = null;
            this._content = null;
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia.consortiaTask

