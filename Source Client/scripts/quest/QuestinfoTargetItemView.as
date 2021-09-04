package quest
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestCondition;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.events.MouseEvent;
   
   public class QuestinfoTargetItemView extends QuestInfoItemView
   {
       
      
      private var _targets:VBox;
      
      private var _isOptional:Boolean;
      
      private var _starLevel:QuestStarListView;
      
      private var _completeButton:TextButton;
      
      private var _spand:int;
      
      private var _sLevel:int;
      
      public var isImprove:Boolean;
      
      public function QuestinfoTargetItemView(param1:Boolean)
      {
         this._isOptional = param1;
         super();
      }
      
      public function set sLevel(param1:int) : void
      {
         if(param1 < 1)
         {
            param1 = 1;
         }
         this._sLevel = param1;
         this._starLevel.level(this._sLevel,this.isImprove);
      }
      
      override public function set info(param1:QuestInfo) : void
      {
         var _loc4_:QuestCondition = null;
         var _loc5_:QuestConditionView = null;
         _info = param1;
         var _loc2_:int = 0;
         while(_info._conditions[_loc2_])
         {
            _loc4_ = _info._conditions[_loc2_];
            if(_loc4_.isOpitional == this._isOptional)
            {
               _loc5_ = new QuestConditionView(_loc4_);
               _loc5_.status = _info.conditionStatus[_loc2_];
               if(_info.progress[_loc2_] <= 0)
               {
                  _loc5_.isComplete = true;
               }
               this._targets.addChild(_loc5_);
            }
            _loc2_++;
         }
         if(_info.QuestID == ServerConfigManager.instance.getEmailQuestID())
         {
            this._targets.addChild(new InfoCollectViewMail());
         }
         else if(_info.QuestID == ServerConfigManager.instance.getCellphoneQuestID())
         {
            this._targets.addChild(new InfoCollectView());
         }
         this._spand = _info.OneKeyFinishNeedMoney;
         this.sLevel = _info.QuestLevel;
         var _loc3_:int = TaskManager.instance.improve.canOneKeyFinishTime + int(ServerConfigManager.instance.VIPQuestFinishDirect[PlayerManager.Instance.Self.VIPLevel - 1]) - PlayerManager.Instance.Self.uesedFinishTime;
      }
      
      override protected function initView() : void
      {
         super.initView();
         _titleImg = ComponentFactory.Instance.creatComponentByStylename("quest.targetPanel.titleImg");
         _titleImg.setFrame(!!this._isOptional ? int(1) : int(2));
         addChild(_titleImg);
         this._targets = ComponentFactory.Instance.creatComponentByStylename("quest.targetPanel.vbox");
         _content.addChild(this._targets);
         this._starLevel = ComponentFactory.Instance.creatCustomObject("quest.complete.starLevel");
         this._starLevel.tipData = LanguageMgr.GetTranslation("tank.manager.TaskManager.viptip");
      }
      
      private function isInLimitTimes() : int
      {
         var _loc1_:int = TaskManager.instance.improve.canOneKeyFinishTime;
         if(PlayerManager.Instance.Self.IsVIP)
         {
            _loc1_ += int(ServerConfigManager.instance.VIPQuestFinishDirect[PlayerManager.Instance.Self.VIPLevel - 1]);
         }
         return int(_loc1_ - PlayerManager.Instance.Self.uesedFinishTime);
      }
      
      private function _activeGetBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this._spand > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         if(this.isInLimitTimes() <= 0)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.manager.TaskManager.oneKeyCompleteTimesOver"));
            return;
         }
         var _loc2_:String = LanguageMgr.GetTranslation("tank.manager.TaskManager.completeText",this._spand);
         var _loc3_:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),_loc2_,LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,1);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         if(_loc2_.parent)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         ObjectUtils.disposeObject(_loc2_);
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            SocketManager.Instance.out.sendQuestOneToFinish(_info.QuestID);
         }
      }
      
      override public function dispose() : void
      {
         if(this._completeButton)
         {
            this._completeButton.removeEventListener(MouseEvent.CLICK,this._activeGetBtnClick);
            ObjectUtils.disposeObject(this._completeButton);
            this._completeButton = null;
         }
         ObjectUtils.disposeObject(this._targets);
         this._targets = null;
         if(this._starLevel)
         {
            ObjectUtils.disposeObject(this._starLevel);
         }
         this._starLevel = null;
         super.dispose();
      }
   }
}
