package quest
{
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import ddt.data.BuffInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestImproveInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import flash.events.MouseEvent;
   
   public class QuestinfoAwardItemView extends QuestInfoItemView
   {
       
      
      private const ROW_HEIGHT:int = 24;
      
      private const ROW_X:int = 18;
      
      private const REWARDCELL_HEIGHT:int = 55;
      
      private var _isOptional:Boolean;
      
      private var _list:SimpleTileList;
      
      private var _items:Vector.<QuestRewardCell>;
      
      private var cardAsset:ScaleFrameImage;
      
      private var _improveBtn:BaseButton;
      
      private var _isReward:Boolean;
      
      private var _improveFrame:QuestImproveFrame;
      
      private var _rewardTxtList:Vector.<FilterFrameText>;
      
      private var _first:Boolean;
      
      public function QuestinfoAwardItemView(param1:Boolean)
      {
         this._isOptional = param1;
         this._first = true;
         this._items = new Vector.<QuestRewardCell>();
         super();
      }
      
      public function set isReward(param1:Boolean) : void
      {
         this._isReward = param1;
      }
      
      override public function set info(param1:QuestInfo) : void
      {
         var _loc2_:QuestItemReward = null;
         var _loc5_:InventoryItemInfo = null;
         var _loc6_:QuestRewardCell = null;
         this._rewardTxtList = new Vector.<FilterFrameText>();
         _info = param1;
         for each(_loc2_ in _info.itemRewards)
         {
            _loc5_ = new InventoryItemInfo();
            _loc5_.TemplateID = _loc2_.itemID;
            ItemManager.fill(_loc5_);
            _loc5_.ValidDate = _loc2_.ValidateTime;
            _loc5_.IsJudge = true;
            _loc5_.IsBinds = _loc2_.isBind;
            _loc5_.AttackCompose = _loc2_.AttackCompose;
            _loc5_.DefendCompose = _loc2_.DefendCompose;
            _loc5_.AgilityCompose = _loc2_.AgilityCompose;
            _loc5_.LuckCompose = _loc2_.LuckCompose;
            _loc5_.StrengthenLevel = _loc2_.StrengthenLevel;
            _loc5_.Count = _loc2_.count[_info.QuestLevel - 1];
            if(!(0 != _loc5_.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != _loc5_.NeedSex))
            {
               if(_loc2_.isOptional == this._isOptional)
               {
                  _loc6_ = new QuestRewardCell();
                  _loc6_.info = _loc5_;
                  if(_loc2_.isOptional)
                  {
                     _loc6_.canBeSelected();
                     _loc6_.addEventListener(RewardSelectedEvent.ITEM_SELECTED,this.__chooseItemReward);
                  }
                  this._list.addChild(_loc6_);
                  this._items.push(_loc6_);
               }
            }
         }
         _panel.invalidateViewport();
         if(this._isOptional)
         {
            return;
         }
         if(!_info.hasOtherAward())
         {
            this._list.y = 5;
         }
         var _loc3_:int = 0;
         var _loc4_:QuestInfo = this.newInfo(_info,_info.QuestLevel - 2,TaskManager.instance.improve);
         if(_loc4_.RewardGP > 0)
         {
            this.addReward("exp",_loc4_.RewardGP,_loc3_);
            _loc3_++;
         }
         if(_loc4_.RewardGold > 0)
         {
            this.addReward("gold",_loc4_.RewardGold,_loc3_);
            _loc3_++;
         }
         if(_loc4_.RewardMoney > 0)
         {
            this.addReward("coin",_loc4_.RewardMoney,_loc3_);
            _loc3_++;
         }
         if(_loc4_.RewardHonor > 0)
         {
            this.addReward("honor",_loc4_.RewardHonor,_loc3_);
            _loc3_++;
         }
         if(_loc4_.RewardMagicSoul > 0)
         {
            this.addReward("magicSoul",_loc4_.RewardMagicSoul,_loc3_);
            _loc3_++;
         }
         if(_info.RewardDailyActivity > 0)
         {
            this.addReward("liveness",_info.RewardDailyActivity,_loc3_);
            _loc3_++;
         }
         if(_info.RewardBindMoney > 0)
         {
            this.addReward("gift",_info.RewardBindMoney,_loc3_);
            _loc3_++;
         }
         if(_info.Rank != "")
         {
            this.addReward("rank",0,_loc3_,true,_info.Rank);
            _loc3_++;
         }
         if(_info.RewardOffer > 0)
         {
            this.addReward("RewardOffer",_info.RewardOffer,_loc3_);
            _loc3_++;
         }
         if(_info.RewardConsortiaGP > 0)
         {
            this.addReward("RewardConsortiaGP",_info.RewardConsortiaGP,_loc3_);
            _loc3_++;
         }
         if(_info.RewardConsortiaRiches > 0)
         {
            this.addReward("RewardConsortiaRiches",_info.RewardConsortiaRiches,_loc3_);
            _loc3_++;
         }
         if(this._isReward && this.getNeedMoney(_info) != -1)
         {
            this._improveBtn = ComponentFactory.Instance.creatComponentByStylename("quest.improve");
            if(height > 75)
            {
               this._improveBtn.y = height / 2 - 40;
            }
            else
            {
               this._improveBtn.y = 20;
            }
            _content.addChild(this._improveBtn);
            if(_info.QuestLevel >= 5)
            {
               this._improveBtn.enable = false;
            }
            this._improveBtn.addEventListener(MouseEvent.CLICK,this._activeimproveBtnClick);
         }
      }
      
      private function getNeedMoney(param1:QuestInfo) : int
      {
         if(param1.QuestLevel == 1)
         {
            return param1.Level2NeedMoney;
         }
         if(param1.QuestLevel == 2)
         {
            return param1.Level3NeedMoney;
         }
         if(param1.QuestLevel == 3)
         {
            return param1.Level4NeedMoney;
         }
         if(param1.QuestLevel == 4)
         {
            return param1.Level5NeedMoney;
         }
         return -1;
      }
      
      private function newInfo(param1:QuestInfo, param2:int, param3:QuestImproveInfo) : QuestInfo
      {
         var _loc4_:QuestInfo = null;
         if(param2 > -1)
         {
            _loc4_ = new QuestInfo();
            _loc4_.RewardMoney = Number(param3.bindMoneyRate[param2]) * param1.RewardMoney;
            _loc4_.RewardGP = Number(param3.expRate[param2]) * param1.RewardGP;
            _loc4_.RewardGold = Number(param3.goldRate[param2]) * param1.RewardGold;
            _loc4_.RewardHonor = Number(param3.exploitRate[param2]) * param1.RewardHonor;
            _loc4_.RewardHonor = param1.RewardHonor;
            return _loc4_;
         }
         return param1;
      }
      
      private function _activeimproveBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.getNeedMoney(_info) > PlayerManager.Instance.Self.Money)
         {
            LeavePageManager.showFillFrame();
            return;
         }
         this._improveFrame = ComponentFactory.Instance.creat("quest.improveFrame");
         this._improveFrame.isOptional = this._isOptional;
         this._improveFrame.spand = this.getNeedMoney(_info);
         this._improveFrame.questInfo = this.getImproveInfo(TaskManager.instance.improve,_info.QuestLevel - 1);
         LayerManager.Instance.addToLayer(this._improveFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function getImproveInfo(param1:QuestImproveInfo, param2:int) : QuestInfo
      {
         var _loc4_:QuestItemReward = null;
         var _loc3_:QuestInfo = new QuestInfo();
         ObjectUtils.copyProperties(_loc3_,_info);
         _loc3_.data = _info.data;
         _loc3_.RewardMoney *= Number(param1.bindMoneyRate[param2]);
         _loc3_.RewardGP *= Number(param1.expRate[param2]);
         _loc3_.RewardGold *= Number(param1.goldRate[param2]);
         _loc3_.RewardOffer *= Number(param1.exploitRate[param2]);
         for each(_loc4_ in _info.itemRewards)
         {
            _loc3_.addReward(_loc4_);
         }
         return _loc3_;
      }
      
      private function __chooseItemReward(param1:RewardSelectedEvent) : void
      {
         var _loc2_:QuestRewardCell = null;
         for each(_loc2_ in this._items)
         {
            _loc2_.selected = false;
         }
         param1.itemCell.selected = true;
      }
      
      private function getSexByInt(param1:Boolean) : int
      {
         return !!param1 ? int(1) : int(2);
      }
      
      private function addReward(param1:String, param2:int, param3:int, param4:Boolean = false, param5:String = "") : void
      {
         var _loc7_:FilterFrameText = null;
         var _loc8_:BuffInfo = null;
         var _loc9_:int = 0;
         var _loc6_:FilterFrameText = ComponentFactory.Instance.creat("core.quest.MCQuestRewardType");
         if(param3 > 3)
         {
            _loc6_.y += 20;
            if(this._first)
            {
               this._list.y += 20;
               this._first = false;
            }
         }
         _loc7_ = ComponentFactory.Instance.creat("core.quest.QuestItemRewardQuantity");
         if(param4)
         {
            _loc7_.text = param5;
         }
         else
         {
            _loc7_.text = String(param2);
         }
         switch(param1)
         {
            case "exp":
               _loc6_.text = LanguageMgr.GetTranslation("exp");
               break;
            case "gold":
               _loc6_.text = LanguageMgr.GetTranslation("gold");
               break;
            case "coin":
               _loc6_.text = LanguageMgr.GetTranslation("money");
               break;
            case "liveness":
               _loc6_.text = LanguageMgr.GetTranslation("ddt.liveness.livenessValueDesc.txt");
               break;
            case "honor":
               _loc6_.text = StringUtils.trim(LanguageMgr.GetTranslation("ddt.quest.Honor"));
               break;
            case "magicSoul":
               _loc6_.text = LanguageMgr.GetTranslation("magicSoul");
               break;
            case "gift":
               _loc6_.text = LanguageMgr.GetTranslation("gift");
               break;
            case "medal":
               _loc6_.text = LanguageMgr.GetTranslation("gift");
               break;
            case "rank":
               _loc6_.text = LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameII");
               break;
            case "RewardOffer":
               _loc8_ = PlayerManager.Instance.Self.buffInfo[BuffInfo.ADD_QUEST_RICHESOFFER];
               _loc9_ = 0;
               if(_loc8_)
               {
                  _loc9_ = _loc8_.Value;
                  _loc7_.text = _loc7_.text + " (" + LanguageMgr.GetTranslation("consortion.task.skillName") + "+" + _loc9_ + ")";
               }
               _loc6_.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.contribution.text");
               break;
            case "RewardConsortiaGP":
               _loc6_.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.Exp.text");
               break;
            case "RewardConsortiaRiches":
               _loc6_.text = LanguageMgr.GetTranslation("consortion.ConsortionCampaign.reward.money.text");
         }
         if(this._rewardTxtList.length > 0)
         {
            _loc6_.x = this._rewardTxtList[this._rewardTxtList.length - 1].x + this._rewardTxtList[this._rewardTxtList.length - 1].textWidth + this.ROW_X;
         }
         else
         {
            _loc6_.x = this.ROW_X;
         }
         _loc7_.x = _loc6_.x + _loc6_.textWidth + 5;
         _loc7_.y = _loc6_.y;
         this._rewardTxtList.push(_loc6_);
         this._rewardTxtList.push(_loc7_);
         _content.addChildAt(_loc6_,0);
         _content.addChildAt(_loc7_,0);
      }
      
      override protected function initView() : void
      {
         super.initView();
         _titleImg = ComponentFactory.Instance.creatComponentByStylename("core.quest.eligiblyWord");
         _titleImg.setFrame(!!this._isOptional ? int(1) : int(2));
         addChild(_titleImg);
         this._list = new SimpleTileList(2);
         if(!this._isOptional)
         {
            PositionUtils.setPos(this._list,"quest.awardPanel.listpos");
         }
         else
         {
            PositionUtils.setPos(this._list,"quest.awardPanel.listpos1");
         }
         _content.addChild(this._list);
      }
      
      override public function dispose() : void
      {
         var _loc1_:QuestRewardCell = null;
         for each(_loc1_ in this._items)
         {
            _loc1_.removeEventListener(RewardSelectedEvent.ITEM_SELECTED,this.__chooseItemReward);
            _loc1_.dispose();
         }
         this._items = null;
         ObjectUtils.disposeObject(this._list);
         if(this._improveBtn)
         {
            ObjectUtils.disposeObject(this._improveBtn);
         }
         this._improveBtn = null;
         this._list = null;
         ObjectUtils.disposeObject(this.cardAsset);
         this.cardAsset = null;
         ObjectUtils.disposeObject(this._improveFrame);
         this._improveFrame = null;
         ObjectUtils.disposeObject(this._rewardTxtList);
         this._rewardTxtList = null;
         super.dispose();
      }
   }
}
