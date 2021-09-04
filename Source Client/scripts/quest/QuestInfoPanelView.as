package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.quest.QuestCondition;
   import ddt.data.quest.QuestInfo;
   import ddt.data.quest.QuestItemReward;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.manager.TaskManager;
   import ddt.states.StateType;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class QuestInfoPanelView extends Sprite implements Disposeable
   {
       
      
      private const CONDITION_HEIGHT:int = 32;
      
      private const CONDITION_Y:int = 0;
      
      private const PADDING_Y:int = 8;
      
      private var _info:QuestInfo;
      
      private var gotoCMoive:TextButton;
      
      private var container:VBox;
      
      private var panel:ScrollPanel;
      
      private var _extraFrame:Sprite;
      
      private var _items:Vector.<QuestInfoItemView>;
      
      private var _starLevel:int;
      
      private var _complete:Boolean;
      
      private var _isImprove:Boolean;
      
      private var _lastId:int;
      
      public function QuestInfoPanelView()
      {
         super();
         this._items = new Vector.<QuestInfoItemView>();
         this._isImprove = false;
         this.initView();
      }
      
      private function initView() : void
      {
         this.container = ComponentFactory.Instance.creatComponentByStylename("quest.questinfoPanelView.vbox");
         this.panel = ComponentFactory.Instance.creatComponentByStylename("core.quest.QuestInfoPanel");
         this.panel.setView(this.container);
         addChild(this.panel);
      }
      
      public function set info(param1:QuestInfo) : void
      {
         var _loc2_:QuestInfoItemView = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:QuestItemReward = null;
         var _loc10_:QuestCondition = null;
         var _loc11_:InventoryItemInfo = null;
         var _loc12_:QuestinfoTargetItemView = null;
         var _loc13_:QuestinfoTargetItemView = null;
         var _loc14_:QuestinfoAwardItemView = null;
         var _loc15_:QuestinfoAwardItemView = null;
         if(this._info == param1 && param1.QuestLevel == this._starLevel && param1.isCompleted == this._complete)
         {
            return;
         }
         TaskManager.instance.Model.itemAwardSelected = 0;
         this._isImprove = false;
         this._info = param1;
         if(this._starLevel != this._info.QuestLevel)
         {
            this._starLevel = this._info.QuestLevel;
            if(this._lastId == this._info.QuestID)
            {
               this._isImprove = true;
            }
         }
         this._lastId = this._info.QuestID;
         this._complete = this._info.isCompleted;
         for each(_loc2_ in this._items)
         {
            _loc2_.dispose();
         }
         this._items = new Vector.<QuestInfoItemView>();
         _loc3_ = false;
         _loc4_ = false;
         _loc5_ = false;
         _loc6_ = false;
         _loc7_ = 0;
         while(this._info._conditions[_loc7_])
         {
            _loc10_ = this._info._conditions[_loc7_];
            if(!_loc10_.isOpitional)
            {
               _loc3_ = true;
            }
            else
            {
               _loc4_ = true;
            }
            _loc7_++;
         }
         if(!_loc5_)
         {
            _loc5_ = this.info.hasOtherAward();
         }
         for each(_loc8_ in this._info.itemRewards)
         {
            _loc11_ = new InventoryItemInfo();
            _loc11_.TemplateID = _loc8_.itemID;
            ItemManager.fill(_loc11_);
            if(!(0 != _loc11_.NeedSex && this.getSexByInt(PlayerManager.Instance.Self.Sex) != _loc11_.NeedSex))
            {
               if(_loc8_.isOptional == 0)
               {
                  _loc5_ = true;
               }
               else if(_loc8_.isOptional == 1)
               {
                  _loc6_ = true;
               }
            }
         }
         if(_loc3_)
         {
            _loc12_ = new QuestinfoTargetItemView(false);
            _loc12_.isImprove = this._isImprove;
            this._items.push(_loc12_);
         }
         if(_loc4_)
         {
            _loc13_ = new QuestinfoTargetItemView(true);
            this._items.push(_loc13_);
         }
         if(_loc5_)
         {
            _loc14_ = new QuestinfoAwardItemView(false);
            _loc14_.isReward = true;
            this._items.push(_loc14_);
         }
         if(_loc6_)
         {
            _loc15_ = new QuestinfoAwardItemView(true);
            TaskManager.instance.Model.itemAwardSelected = -1;
            this._items.push(_loc15_);
         }
         var _loc9_:QuestinfoDescriptionItemView = new QuestinfoDescriptionItemView();
         this._items.push(_loc9_);
         for each(_loc2_ in this._items)
         {
            _loc2_.info = this._info;
            this.container.addChild(_loc2_);
         }
         if(this.info.QuestID == TaskManager.GUIDE_QUEST_ID)
         {
            this.canGotoConsortia(true);
         }
         else
         {
            this.canGotoConsortia(false);
         }
         this.panel.invalidateViewport();
      }
      
      private function __onGoToConsortia(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.gotoCMoive.removeEventListener(MouseEvent.CLICK,this.__onGoToConsortia);
         StateManager.setState(StateType.CONSORTIA);
      }
      
      private function getSexByInt(param1:Boolean) : int
      {
         return !!param1 ? int(1) : int(2);
      }
      
      public function canGotoConsortia(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.gotoCMoive == null)
            {
               this.gotoCMoive = ComponentFactory.Instance.creatComponentByStylename("core.quest.GoToConsortiaBtn");
               this.gotoCMoive.text = LanguageMgr.GetTranslation("tank.manager.TaskManager.GoToConsortia");
               this.gotoCMoive.addEventListener(MouseEvent.CLICK,this.__onGoToConsortia);
               addChild(this.gotoCMoive);
            }
         }
         else if(this.gotoCMoive)
         {
            this.gotoCMoive.removeEventListener(MouseEvent.CLICK,this.__onGoToConsortia);
            removeChild(this.gotoCMoive);
            this.gotoCMoive = null;
         }
      }
      
      public function get info() : QuestInfo
      {
         return this._info;
      }
      
      public function dispose() : void
      {
         while(this._items.length > 0)
         {
            this._items.shift().dispose();
         }
         this._items = null;
         ObjectUtils.disposeObject(this.gotoCMoive);
         this.gotoCMoive = null;
         ObjectUtils.disposeObject(this.container);
         this.container = null;
         ObjectUtils.disposeObject(this.panel);
         this.panel = null;
         ObjectUtils.disposeObject(this._extraFrame);
         this._extraFrame = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
