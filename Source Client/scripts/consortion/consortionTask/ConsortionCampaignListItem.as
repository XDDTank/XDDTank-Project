package consortion.consortionTask
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import ddt.data.quest.QuestInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class ConsortionCampaignListItem extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _type:int;
      
      private var _itemBG:ScaleFrameImage;
      
      private var _icon:MutipleImage;
      
      private var _iconBG:ScaleBitmapImage;
      
      private var _verticalLine:ScaleBitmapImage;
      
      private var _line:MutipleImage;
      
      private var _rewardBmp:MutipleImage;
      
      private var _nameText:FilterFrameText;
      
      private var _describeText:FilterFrameText;
      
      private var _rewardText:FilterFrameText;
      
      private var _joinBtn:TextButton;
      
      private var _statusText:FilterFrameText;
      
      private var _taskComplete:MutipleImage;
      
      private var _isMaster:Boolean;
      
      private var _chooseLevelView:ConsortionTaskViewFrame;
      
      private var _unableText:FilterFrameText;
      
      public function ConsortionCampaignListItem(param1:int)
      {
         super();
         this.init();
         this._type = param1;
         this.update();
      }
      
      private function init() : void
      {
         this._itemBG = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionCampaign.ItemBG");
         this._iconBG = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionCampaign.iconBG");
         this._rewardBmp = ComponentFactory.Instance.creatComponentByStylename("consortion.CampaignReward.bmpTxt");
         this._nameText = ComponentFactory.Instance.creatComponentByStylename("consortion.CampaignNameTxt");
         this._describeText = ComponentFactory.Instance.creatComponentByStylename("consortion.CampaignDescribeTxt");
         this._rewardText = ComponentFactory.Instance.creatComponentByStylename("consortion.CampaignRewardTxt1");
         this._verticalLine = ComponentFactory.Instance.creatComponentByStylename("consortion.CampaignItem.VerticalLine");
         this._unableText = ComponentFactory.Instance.creatComponentByStylename("consortion.CampaignItem.unableText.text");
         addChild(this._itemBG);
         addChild(this._iconBG);
         addChild(this._rewardBmp);
         addChild(this._verticalLine);
      }
      
      private function update() : void
      {
         switch(this._type)
         {
            case ConsortionModel.CONSORTION_TASK:
               this._icon = ComponentFactory.Instance.creatComponentByStylename("consortion.CampaignReward.taskIcon");
               this._nameText.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.taskTitle.text");
               this._describeText.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.taskDescribe.text");
               this._rewardText.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.Exp.text") + "、" + LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText6");
               this._taskComplete = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionCampaign.taskComplete");
               this._isMaster = ConsortionModelControl.Instance.model.isMaster;
               if(ConsortionModelControl.Instance.model.canAcceptTask)
               {
                  this.createMemberBtn();
               }
               else if(this._isMaster)
               {
                  this.createMasterBtn();
               }
               else
               {
                  this.createMemberBtn();
               }
               this._taskComplete.visible = false;
               addChild(this._taskComplete);
               this.checkBtnEnable();
               break;
            case ConsortionModel.CONSORTION_CONVOY:
               this._icon = ComponentFactory.Instance.creatComponentByStylename("consortion.CampaignReward.convoyIcon");
               this._nameText.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.convoyTitle.text");
               this._describeText.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.convoyDescribe.text");
               this._rewardText.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.money.text") + "、" + LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText6");
               this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.ConsortionCampaign.goTransportBtn");
               this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.goTransportBtn.text");
               break;
            case ConsortionModel.MONSTER_REFLASH:
               this._icon = ComponentFactory.Instance.creatComponentByStylename("consortion.CampaignReward.monsterReflashIcon");
               this._nameText.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.monsterReflashTitle.text");
               this._describeText.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.monsterDescribe.text");
               this._rewardText.text = LanguageMgr.GetTranslation("consortion.ConsortiaAssetManagerFrame.contributionText6");
               this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.ConsortionCampaign.goTransportBtn");
               this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.goTransportBtn.text");
         }
         addChild(this._icon);
         addChild(this._nameText);
         addChild(this._describeText);
         addChild(this._rewardText);
         if(!this._joinBtn.parent)
         {
            addChild(this._joinBtn);
         }
         this._joinBtn.addEventListener(MouseEvent.CLICK,this.__itemClick);
      }
      
      public function setBtnEnable(param1:Boolean = true) : void
      {
         this._joinBtn.enable = param1;
      }
      
      private function checkBtnEnable() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:QuestInfo = null;
         if(!ConsortionModelControl.Instance.model.canAcceptTask)
         {
            if(!this._isMaster && ConsortionModelControl.Instance.model.currentTaskLevel == 0 || ConsortionModelControl.Instance.model.consortiaQuestCount >= ServerConfigManager.instance.getConsortiaTaskAcceptMax() || ConsortionModelControl.Instance.model.remainPublishTime == 0 && this._isMaster && ConsortionModelControl.Instance.model.currentTaskLevel != 0 || ConsortionModelControl.Instance.model.receivedQuestCount >= ConsortionModelControl.Instance.model.getLevelData(PlayerManager.Instance.Self.consortiaInfo.Level).Count * 5)
            {
               this._joinBtn.enable = false;
               _loc1_ = false;
               for each(_loc2_ in TaskManager.instance.allCurrentQuest)
               {
                  if(_loc2_.Type == 9)
                  {
                     _loc1_ = true;
                     break;
                  }
               }
               if(!_loc1_ && ConsortionModelControl.Instance.model.currentTaskLevel != 0)
               {
                  this._joinBtn.visible = false;
                  this._taskComplete.visible = true;
               }
            }
         }
      }
      
      private function createMasterBtn() : void
      {
         this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.ConsortionCampaign.publishBtn");
         this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.publishBtn.text");
      }
      
      private function createMemberBtn() : void
      {
         this._joinBtn = ComponentFactory.Instance.creatComponentByStylename("asset.consortion.ConsortionCampaign.getMissionBtn");
         this._joinBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.getMissionBtn.text");
      }
      
      public function reflashBtnByTpye(param1:Boolean) : void
      {
         if(this._type != ConsortionModel.CONSORTION_TASK)
         {
            return;
         }
         removeChild(this._joinBtn);
         this._joinBtn = null;
         if(param1)
         {
            this.createMasterBtn();
         }
         else
         {
            this.createMemberBtn();
            if(this._chooseLevelView)
            {
               if(this._chooseLevelView.parent)
               {
                  this._chooseLevelView.dispose();
               }
            }
         }
         addChild(this._joinBtn);
         this.checkBtnEnable();
         this._joinBtn.addEventListener(MouseEvent.CLICK,this.__itemClick);
      }
      
      private function __itemClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(this._type)
         {
            case ConsortionModel.CONSORTION_TASK:
               if(ConsortionModelControl.Instance.model.canAcceptTask)
               {
                  SocketManager.Instance.out.sendRequestConsortionQuest(ConsortionModelControl.Instance.model.currentTaskLevel);
               }
               else if(this._isMaster)
               {
                  if(PlayerManager.Instance.Self.bagPwdState)
                  {
                     if(PlayerManager.Instance.Self.bagLocked)
                     {
                        BaglockedManager.Instance.show();
                        return;
                     }
                     this.showQuestChooseFrame();
                  }
                  else
                  {
                     this.showQuestChooseFrame();
                  }
               }
               break;
            case ConsortionModel.CONSORTION_CONVOY:
               SocketManager.Instance.out.SendenterConsortionTransport();
               break;
            case ConsortionModel.MONSTER_REFLASH:
               SocketManager.Instance.out.SendenterConsortion(true);
         }
      }
      
      private function showQuestChooseFrame() : void
      {
         this._chooseLevelView = ComponentFactory.Instance.creatComponentByStylename("consortion.ConsortionTaskViewFrame");
         this._chooseLevelView.show();
      }
      
      public function setListCellStatus(param1:List, param2:Boolean, param3:int) : void
      {
      }
      
      public function getCellValue() : *
      {
         return this._type;
      }
      
      public function setCellValue(param1:*) : void
      {
         this._type = param1;
         this.update();
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      override public function get width() : Number
      {
         return this._itemBG.width;
      }
      
      override public function get height() : Number
      {
         return this._itemBG.height;
      }
      
      public function dispose() : void
      {
         this._joinBtn.removeEventListener(MouseEvent.CLICK,this.__itemClick);
         ObjectUtils.disposeObject(this._itemBG);
         this._itemBG = null;
         ObjectUtils.disposeObject(this._icon);
         this._icon = null;
         ObjectUtils.disposeObject(this._iconBG);
         this._iconBG = null;
         ObjectUtils.disposeObject(this._line);
         this._line = null;
         ObjectUtils.disposeObject(this._rewardBmp);
         this._rewardBmp = null;
         ObjectUtils.disposeObject(this._nameText);
         this._nameText = null;
         ObjectUtils.disposeObject(this._describeText);
         this._describeText = null;
         ObjectUtils.disposeObject(this._rewardText);
         this._rewardText = null;
         ObjectUtils.disposeObject(this._joinBtn);
         this._joinBtn = null;
         ObjectUtils.disposeObject(this._statusText);
         this._statusText = null;
         ObjectUtils.disposeObject(this._unableText);
         this._unableText = null;
      }
   }
}
