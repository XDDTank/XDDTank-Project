package quest
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import com.pickgliss.utils.StringUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class QuestImproveFrame extends BaseAlerFrame
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _textFieldStyle:String;
      
      protected var _textField:FilterFrameText;
      
      private var _contian:Sprite;
      
      private var _questInfo:QuestInfo;
      
      private var _isOptional:Boolean;
      
      private var _list:SimpleTileList;
      
      private var _items:Vector.<QuestRewardCell>;
      
      private var _spand:int;
      
      private var _first:Boolean;
      
      public function QuestImproveFrame()
      {
         super();
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"));
         _loc1_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc1_.moveEnable = false;
         info = _loc1_;
         this._first = true;
         this._items = new Vector.<QuestRewardCell>();
         addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         this.initView();
      }
      
      public function set spand(param1:int) : void
      {
         this._spand = param1;
         this._textField.htmlText = LanguageMgr.GetTranslation("tank.manager.TaskManager.improveText",this._spand);
      }
      
      public function set isOptional(param1:Boolean) : void
      {
         this._isOptional = param1;
      }
      
      private function initView() : void
      {
         this._contian = new Sprite();
         this._contian.y = 40;
         addToContent(this._contian);
         this._textField = ComponentFactory.Instance.creat("core.quest.QuestSpandText");
         addToContent(this._textField);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.questBack.bg");
         this._contian.addChild(this._bg);
         this._list = new SimpleTileList(2);
         if(!this._isOptional)
         {
            PositionUtils.setPos(this._list,"quest.awardPanel.listposr");
         }
         else
         {
            PositionUtils.setPos(this._list,"quest.awardPanel.listposr1");
         }
         this._contian.addChild(this._list);
      }
      
      public function set questInfo(param1:QuestInfo) : void
      {
         var _loc2_:QuestItemReward = null;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:int = 0;
         var _loc6_:QuestRewardCell = null;
         this._questInfo = param1;
         for each(_loc2_ in this._questInfo.itemRewards)
         {
            _loc4_ = new InventoryItemInfo();
            _loc4_.TemplateID = _loc2_.itemID;
            ItemManager.fill(_loc4_);
            _loc4_.ValidDate = _loc2_.ValidateTime;
            _loc4_.IsJudge = true;
            _loc4_.IsBinds = _loc2_.isBind;
            _loc4_.AttackCompose = _loc2_.AttackCompose;
            _loc4_.DefendCompose = _loc2_.DefendCompose;
            _loc4_.AgilityCompose = _loc2_.AgilityCompose;
            _loc4_.LuckCompose = _loc2_.LuckCompose;
            _loc4_.StrengthenLevel = _loc2_.StrengthenLevel;
            if(this._questInfo.QuestLevel > 4)
            {
               _loc5_ = 4;
            }
            else
            {
               _loc5_ = this._questInfo.QuestLevel;
            }
            _loc4_.Count = _loc2_.count[_loc5_];
            if(!(0 != _loc4_.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != _loc4_.NeedSex))
            {
               if(_loc2_.isOptional == this._isOptional)
               {
                  _loc6_ = new QuestRewardCell();
                  _loc6_.info = _loc4_;
                  if(_loc2_.isOptional)
                  {
                     _loc6_.canBeSelected();
                  }
                  this._list.addChild(_loc6_);
                  this._items.push(_loc6_);
               }
            }
         }
         if(this._isOptional)
         {
            return;
         }
         if(!this._questInfo.hasOtherAward())
         {
            this._list.y = 5;
         }
         var _loc3_:int = 0;
         if(this._questInfo.RewardGP > 0)
         {
            this.addReward("exp",this._questInfo.RewardGP,_loc3_);
            _loc3_++;
         }
         if(this._questInfo.RewardGold > 0)
         {
            this.addReward("gold",this._questInfo.RewardGold,_loc3_);
            _loc3_++;
         }
         if(this._questInfo.RewardMoney > 0)
         {
            this.addReward("coin",this._questInfo.RewardMoney,_loc3_);
            _loc3_++;
         }
         if(this._questInfo.RewardHonor > 0)
         {
            this.addReward("honor",this._questInfo.RewardHonor,_loc3_);
            _loc3_++;
         }
         if(this._questInfo.RewardBindMoney > 0)
         {
            this.addReward("gift",this._questInfo.RewardBindMoney,_loc3_);
            _loc3_++;
         }
         if(this._questInfo.Rank != "")
         {
            this.addReward("rank",0,_loc3_,true,this._questInfo.Rank);
            _loc3_++;
         }
         this._textField.x = (this._contian.width - this._textField.width) / 2;
         this._bg.height = this._contian.height + 12;
         height = 140 + this._contian.height;
      }
      
      private function getSexByInt(param1:Boolean) : int
      {
         return !!param1 ? int(1) : int(2);
      }
      
      private function addReward(param1:String, param2:int, param3:int, param4:Boolean = false, param5:String = "") : void
      {
         var _loc6_:FilterFrameText = ComponentFactory.Instance.creat("core.quest.MCQuestRewardImprove");
         if(param3 > 2)
         {
            _loc6_.y += 20;
            if(this._first)
            {
               this._list.y += 20;
               this._first = false;
            }
         }
         var _loc7_:FilterFrameText = ComponentFactory.Instance.creat("core.quest.QuestItemRewardQuantity");
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
            case "rich":
               _loc6_.text = LanguageMgr.GetTranslation("consortia.Money");
               break;
            case "honor":
               _loc6_.text = StringUtils.trim(LanguageMgr.GetTranslation("ddt.quest.Honor"));
               break;
            case "gift":
               _loc6_.text = LanguageMgr.GetTranslation("gift");
               break;
            case "medal":
               _loc6_.text = LanguageMgr.GetTranslation("consortion.skillFrame.richesText3");
               break;
            case "rank":
               _loc6_.text = LanguageMgr.GetTranslation("tank.view.effort.EffortRigthItemView.honorNameII");
         }
         _loc6_.x = param3 % 3 * 90 + 18;
         _loc7_.x = _loc6_.x + _loc6_.textWidth + 5;
         _loc7_.y = _loc6_.y;
         if(param4)
         {
            _loc7_.text = param5;
         }
         else
         {
            _loc7_.text = String(param2);
         }
         this._contian.addChild(_loc6_);
         this._contian.addChild(_loc7_);
      }
      
      private function __confirmResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
               break;
            case FrameEvent.CANCEL_CLICK:
               this.dispose();
               break;
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
               SocketManager.Instance.out.sendImproveQuest(this._questInfo.id);
               this.dispose();
               break;
            case FrameEvent.SUBMIT_CLICK:
               SocketManager.Instance.out.sendImproveQuest(this._questInfo.id);
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         ObjectUtils.disposeObject(this._textField);
         this._textField = null;
         if(this._contian)
         {
            ObjectUtils.disposeObject(this._contian);
         }
         this._contian = null;
         if(this._list)
         {
            ObjectUtils.disposeObject(this._list);
         }
         this._list = null;
         super.dispose();
      }
   }
}
