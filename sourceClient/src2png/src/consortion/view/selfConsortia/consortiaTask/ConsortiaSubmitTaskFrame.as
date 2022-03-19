// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.consortiaTask.ConsortiaSubmitTaskFrame

package consortion.view.selfConsortia.consortiaTask
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.events.FrameEvent;
    import consortion.ConsortionModelControl;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SocketManager;
    import ddt.manager.LeavePageManager;

    public class ConsortiaSubmitTaskFrame extends BaseAlerFrame 
    {

        private static var RESET_MONEY:int = 500;
        private static var SUBMIT_RICHES:int = 5000;

        private var _myResetBtn:TextButton;
        private var _myOkBtn:TextButton;
        private var _itemTxtI:FilterFrameText;
        private var _itemTxtII:FilterFrameText;
        private var _itemTxtIII:FilterFrameText;

        public function ConsortiaSubmitTaskFrame()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_1:AlertInfo = new AlertInfo();
            _local_1.submitLabel = LanguageMgr.GetTranslation("consortia.task.releaseTable");
            _local_1.title = LanguageMgr.GetTranslation("consortia.task.releasetitle");
            _local_1.showCancel = false;
            _local_1.showSubmit = false;
            _local_1.enterEnable = false;
            _local_1.escEnable = false;
            info = _local_1;
            var _local_2:ScaleBitmapImage = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTaskBG");
            this._myResetBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.reset");
            this._myOkBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.ok");
            this._myResetBtn.text = LanguageMgr.GetTranslation("consortia.task.resetTable");
            this._myOkBtn.text = LanguageMgr.GetTranslation("consortia.task.okTable");
            this._itemTxtI = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.itemTxtI");
            this._itemTxtII = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.itemTxtII");
            this._itemTxtIII = ComponentFactory.Instance.creatComponentByStylename("consortion.submitTask.itemTxtIII");
            addToContent(_local_2);
            addToContent(this._myResetBtn);
            addToContent(this._myOkBtn);
            addToContent(this._itemTxtI);
            addToContent(this._itemTxtII);
            addToContent(this._itemTxtIII);
        }

        private function initEvents():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__response);
            ConsortionModelControl.Instance.TaskModel.addEventListener(ConsortiaTaskEvent.GETCONSORTIATASKINFO, this.__getTaskInfo);
            this._myResetBtn.addEventListener(MouseEvent.CLICK, this.__resetClick);
            this._myOkBtn.addEventListener(MouseEvent.CLICK, this.__okClick);
        }

        private function removeEvents():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__response);
            ConsortionModelControl.Instance.TaskModel.removeEventListener(ConsortiaTaskEvent.GETCONSORTIATASKINFO, this.__getTaskInfo);
            this._myResetBtn.removeEventListener(MouseEvent.CLICK, this.__resetClick);
            this._myOkBtn.removeEventListener(MouseEvent.CLICK, this.__okClick);
        }

        private function __response(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                ObjectUtils.disposeObject(this);
            };
        }

        private function __resetClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("consortia.task.resetTable"), LanguageMgr.GetTranslation("consortia.task.resetContent"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, LayerManager.ALPHA_BLOCKGOUND);
            _local_2.moveEnable = false;
            _local_2.addEventListener(FrameEvent.RESPONSE, this._responseI);
        }

        private function __okClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.SUMBIT_TASK);
        }

        private function _responseI(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame;
            (_arg_1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE, this._responseI);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.Money < RESET_MONEY)
                {
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.consortia.consortiashop.ConsortiaShopItem.Money"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"));
                    _local_2.addEventListener(FrameEvent.RESPONSE, this.__onNoMoneyResponse);
                }
                else
                {
                    SocketManager.Instance.out.sendReleaseConsortiaTask(ConsortiaTaskModel.RESET_TASK);
                };
            };
            ObjectUtils.disposeObject((_arg_1.currentTarget as BaseAlerFrame));
        }

        private function __onNoMoneyResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onNoMoneyResponse);
            _local_2.disposeChildren = true;
            _local_2.dispose();
            _local_2 = null;
            if (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)
            {
                LeavePageManager.leaveToFillPath();
            };
        }

        private function __getTaskInfo(_arg_1:ConsortiaTaskEvent):void
        {
            if (_arg_1.value == ConsortiaTaskModel.RESET_TASK)
            {
                this.taskInfo = ConsortionModelControl.Instance.TaskModel.taskInfo;
            }
            else
            {
                if (_arg_1.value == ConsortiaTaskModel.SUMBIT_TASK)
                {
                    ObjectUtils.disposeObject(this);
                };
            };
        }

        public function set taskInfo(_arg_1:ConsortiaTaskInfo):void
        {
            this._itemTxtI.text = ("1 .  " + _arg_1.itemList[0]["content"]);
            this._itemTxtII.text = ("2 .  " + _arg_1.itemList[1]["content"]);
            this._itemTxtIII.text = ("3 .  " + _arg_1.itemList[2]["content"]);
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        override public function dispose():void
        {
            this.removeEvents();
            if (this._myResetBtn)
            {
                ObjectUtils.disposeObject(this._myResetBtn);
            };
            this._myResetBtn = null;
            if (this._myOkBtn)
            {
                ObjectUtils.disposeObject(this._myOkBtn);
            };
            this._myOkBtn = null;
            if (this._itemTxtI)
            {
                ObjectUtils.disposeObject(this._itemTxtI);
            };
            this._itemTxtI = null;
            if (this._itemTxtII)
            {
                ObjectUtils.disposeObject(this._itemTxtII);
            };
            this._itemTxtII = null;
            if (this._itemTxtIII)
            {
                ObjectUtils.disposeObject(this._itemTxtIII);
            };
            this._itemTxtIII = null;
            super.dispose();
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia.consortiaTask

