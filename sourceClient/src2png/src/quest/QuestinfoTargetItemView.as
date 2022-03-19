// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//quest.QuestinfoTargetItemView

package quest
{
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.TextButton;
    import ddt.data.quest.QuestCondition;
    import ddt.manager.ServerConfigManager;
    import ddt.manager.TaskManager;
    import ddt.manager.PlayerManager;
    import ddt.data.quest.QuestInfo;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SoundManager;
    import baglocked.BaglockedManager;
    import ddt.manager.LeavePageManager;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SocketManager;

    public class QuestinfoTargetItemView extends QuestInfoItemView 
    {

        private var _targets:VBox;
        private var _isOptional:Boolean;
        private var _starLevel:QuestStarListView;
        private var _completeButton:TextButton;
        private var _spand:int;
        private var _sLevel:int;
        public var isImprove:Boolean;

        public function QuestinfoTargetItemView(_arg_1:Boolean)
        {
            this._isOptional = _arg_1;
            super();
        }

        public function set sLevel(_arg_1:int):void
        {
            if (_arg_1 < 1)
            {
                _arg_1 = 1;
            };
            this._sLevel = _arg_1;
            this._starLevel.level(this._sLevel, this.isImprove);
        }

        override public function set info(_arg_1:QuestInfo):void
        {
            var _local_4:QuestCondition;
            var _local_5:QuestConditionView;
            _info = _arg_1;
            var _local_2:int;
            while (_info._conditions[_local_2])
            {
                _local_4 = _info._conditions[_local_2];
                if (_local_4.isOpitional == this._isOptional)
                {
                    _local_5 = new QuestConditionView(_local_4);
                    _local_5.status = _info.conditionStatus[_local_2];
                    if (_info.progress[_local_2] <= 0)
                    {
                        _local_5.isComplete = true;
                    };
                    this._targets.addChild(_local_5);
                };
                _local_2++;
            };
            if (_info.QuestID == ServerConfigManager.instance.getEmailQuestID())
            {
                this._targets.addChild(new InfoCollectViewMail());
            }
            else
            {
                if (_info.QuestID == ServerConfigManager.instance.getCellphoneQuestID())
                {
                    this._targets.addChild(new InfoCollectView());
                };
            };
            this._spand = _info.OneKeyFinishNeedMoney;
            this.sLevel = _info.QuestLevel;
            var _local_3:int = ((TaskManager.instance.improve.canOneKeyFinishTime + int(ServerConfigManager.instance.VIPQuestFinishDirect[(PlayerManager.Instance.Self.VIPLevel - 1)])) - PlayerManager.Instance.Self.uesedFinishTime);
        }

        override protected function initView():void
        {
            super.initView();
            _titleImg = ComponentFactory.Instance.creatComponentByStylename("quest.targetPanel.titleImg");
            _titleImg.setFrame(((this._isOptional) ? 1 : 2));
            addChild(_titleImg);
            this._targets = ComponentFactory.Instance.creatComponentByStylename("quest.targetPanel.vbox");
            _content.addChild(this._targets);
            this._starLevel = ComponentFactory.Instance.creatCustomObject("quest.complete.starLevel");
            this._starLevel.tipData = LanguageMgr.GetTranslation("tank.manager.TaskManager.viptip");
        }

        private function isInLimitTimes():int
        {
            var _local_1:int = TaskManager.instance.improve.canOneKeyFinishTime;
            if (PlayerManager.Instance.Self.IsVIP)
            {
                _local_1 = (_local_1 + int(ServerConfigManager.instance.VIPQuestFinishDirect[(PlayerManager.Instance.Self.VIPLevel - 1)]));
            };
            return (_local_1 - PlayerManager.Instance.Self.uesedFinishTime);
        }

        private function _activeGetBtnClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (this._spand > PlayerManager.Instance.Self.Money)
            {
                LeavePageManager.showFillFrame();
                return;
            };
            if (this.isInLimitTimes() <= 0)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.TaskManager.oneKeyCompleteTimesOver"));
                return;
            };
            var _local_2:String = LanguageMgr.GetTranslation("tank.manager.TaskManager.completeText", this._spand);
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), _local_2, LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, true, 1);
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
        }

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            if (_local_2.parent)
            {
                _local_2.parent.removeChild(_local_2);
            };
            ObjectUtils.disposeObject(_local_2);
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                SocketManager.Instance.out.sendQuestOneToFinish(_info.QuestID);
            };
        }

        override public function dispose():void
        {
            if (this._completeButton)
            {
                this._completeButton.removeEventListener(MouseEvent.CLICK, this._activeGetBtnClick);
                ObjectUtils.disposeObject(this._completeButton);
                this._completeButton = null;
            };
            ObjectUtils.disposeObject(this._targets);
            this._targets = null;
            if (this._starLevel)
            {
                ObjectUtils.disposeObject(this._starLevel);
            };
            this._starLevel = null;
            super.dispose();
        }


    }
}//package quest

