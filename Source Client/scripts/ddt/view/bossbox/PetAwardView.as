package ddt.view.bossbox
{
   import bagAndInfo.BagAndInfoManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.DropGoodsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetInfoManager;
   import ddt.manager.SoundManager;
   import pet.date.PetEggInfo;
   import pet.date.PetInfo;
   import petsBag.view.item.PetBigItem;
   import petsBag.view.item.PetSmallItem;
   
   public class PetAwardView extends BaseAlerFrame
   {
       
      
      private var _bg:MutipleImage;
      
      private var _petbg:MutipleImage;
      
      private var _typeTip:FilterFrameText;
      
      private var _bestWayTip:FilterFrameText;
      
      private var _typeTxt:FilterFrameText;
      
      private var _bestWayTxt:FilterFrameText;
      
      private var _nameTxt:FilterFrameText;
      
      private var _petSkillListTxt:FilterFrameText;
      
      private var _properBaseTitle:FilterFrameText;
      
      private var _properGrowTitle:FilterFrameText;
      
      private var _petItem:PetBigItem;
      
      private var _propertyList:Vector.<PetPropertyItem>;
      
      private var _propertyView:VBox;
      
      private var _skillList:Vector.<PetAwardSkillItem>;
      
      private var _skillBox:HBox;
      
      private var _petInfo:PetInfo;
      
      public function PetAwardView()
      {
         super();
         this.initEvent();
      }
      
      override protected function init() : void
      {
         super.init();
         titleText = LanguageMgr.GetTranslation("bossbox.petAwardView.title");
         this._bg = ComponentFactory.Instance.creat("bossbox.petAwardView.bg");
         addToContent(this._bg);
         this._petbg = ComponentFactory.Instance.creat("bossbox.petAwardView.petbg");
         addToContent(this._petbg);
         this._typeTip = ComponentFactory.Instance.creat("bossbox.petAwardView.typeTip");
         this._typeTip.text = LanguageMgr.GetTranslation("bossbox.petAwardView.typeTxt");
         addToContent(this._typeTip);
         this._bestWayTip = ComponentFactory.Instance.creat("bossbox.petAwardView.bestWayTip");
         this._bestWayTip.text = LanguageMgr.GetTranslation("bossbox.petAwardView.bestWayTxt");
         addToContent(this._bestWayTip);
         this._typeTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.typeTxt");
         addToContent(this._typeTxt);
         this._bestWayTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.bestWayTxt");
         addToContent(this._bestWayTxt);
         this._nameTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.nameTxt");
         addToContent(this._nameTxt);
         this._petItem = ComponentFactory.Instance.creat("bossbox.petAwardView.petItem");
         addToContent(this._petItem);
         this._properBaseTitle = ComponentFactory.Instance.creat("bossbox.petAwardView.propertyBaseTitle");
         this._properBaseTitle.text = "初始值";
         addToContent(this._properBaseTitle);
         this._properGrowTitle = ComponentFactory.Instance.creat("bossbox.petAwardView.propertyGrowTitle");
         this._properGrowTitle.text = "成长值";
         addToContent(this._properGrowTitle);
         this.createProperty();
         this.createSkill();
         this._petSkillListTxt = ComponentFactory.Instance.creat("bossbox.petAwardView.skillListTxt");
         this._petSkillListTxt.text = LanguageMgr.GetTranslation("bossbox.petAwardView.skillListTxt");
         addToContent(this._petSkillListTxt);
      }
      
      private function createProperty() : void
      {
         var _loc2_:PetPropertyItem = null;
         this._propertyList = new Vector.<PetPropertyItem>();
         this._propertyView = ComponentFactory.Instance.creat("bossbox.petAwardView.propertyView");
         this._propertyView.beginChanges();
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new PetPropertyItem(_loc1_);
            _loc2_.setValue(0,0);
            this._propertyList.push(_loc2_);
            this._propertyView.addChild(_loc2_);
            _loc1_++;
         }
         this._propertyView.commitChanges();
         addToContent(this._propertyView);
      }
      
      private function createSkill() : void
      {
         var _loc2_:PetAwardSkillItem = null;
         this._skillList = new Vector.<PetAwardSkillItem>();
         this._skillBox = ComponentFactory.Instance.creat("bossbox.petAwardView.skillListView");
         this._skillBox.beginChanges();
         var _loc1_:int = 0;
         while(_loc1_ < 5)
         {
            _loc2_ = new PetAwardSkillItem();
            this._skillList.push(_loc2_);
            this._skillBox.addChild(_loc2_);
            _loc1_++;
         }
         this._skillBox.commitChanges();
         addToContent(this._skillBox);
      }
      
      protected function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      protected function __response(param1:FrameEvent) : void
      {
         var _loc2_:PetSmallItem = null;
         SoundManager.instance.play("008");
         _loc2_ = new PetSmallItem(null,this._petInfo);
         _loc2_.mouseEnabled = false;
         _loc2_.mouseChildren = false;
         DropGoodsManager.petPlay(_loc2_);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               BagAndInfoManager.Instance.hideBagAndInfo();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
         }
         this.dispose();
      }
      
      override public function set info(param1:AlertInfo) : void
      {
         var _loc3_:int = 0;
         super.info = param1;
         this._petInfo = PetInfoManager.instance.getPetInfoByTemplateID(int(info.data));
         this._petItem.info = this._petInfo;
         if(!this._petInfo)
         {
            return;
         }
         this._typeTxt.text = this._petInfo.Charcacter;
         this._bestWayTxt.text = this._petInfo.BestUseType;
         this._nameTxt.text = LanguageMgr.GetTranslation("bossbox.petAwardView.nameTxt",this._petInfo.Name);
         this.setProperyText(this._propertyList[0],this._petInfo.Blood,this._petInfo.BloodGrow);
         this.setProperyText(this._propertyList[1],this._petInfo.Attack,this._petInfo.AttackGrow);
         this.setProperyText(this._propertyList[2],this._petInfo.Defence,this._petInfo.DefenceGrow);
         this.setProperyText(this._propertyList[3],this._petInfo.Agility,this._petInfo.AgilityGrow);
         this.setProperyText(this._propertyList[4],this._petInfo.Luck,this._petInfo.LuckGrow);
         var _loc2_:int = this.getMaxPropertyIndex(this._petInfo);
         _loc3_ = 1;
         while(_loc3_ < 5)
         {
            this._propertyList[_loc3_].setHighLight(_loc3_ == _loc2_);
            _loc3_++;
         }
         var _loc4_:Vector.<PetEggInfo> = PetInfoManager.instance.getPetEggListByKind(this._petInfo.KindID);
         if(_loc4_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               this._skillList[_loc3_].eggInfo = _loc4_[_loc3_];
               _loc3_++;
            }
         }
      }
      
      private function setProperyText(param1:PetPropertyItem, param2:int, param3:int) : void
      {
         param1.setValue(int(param2 / 100),param3 / 100);
      }
      
      private function getMaxPropertyIndex(param1:PetInfo) : int
      {
         var _loc2_:int = 1;
         var _loc3_:int = param1.Attack;
         if(_loc3_ < param1.Defence)
         {
            _loc2_ = 2;
            _loc3_ = param1.Defence;
         }
         if(_loc3_ < param1.Agility)
         {
            _loc2_ = 3;
            _loc3_ = param1.Agility;
         }
         if(_loc3_ < param1.Luck)
         {
            _loc2_ = 4;
            _loc3_ = param1.Luck;
         }
         return _loc2_;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._petbg);
         this._petbg = null;
         ObjectUtils.disposeObject(this._typeTip);
         this._typeTip = null;
         ObjectUtils.disposeObject(this._bestWayTip);
         this._bestWayTip = null;
         ObjectUtils.disposeObject(this._typeTxt);
         this._typeTxt = null;
         ObjectUtils.disposeObject(this._bestWayTxt);
         this._bestWayTxt = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._petSkillListTxt);
         this._petSkillListTxt = null;
         ObjectUtils.disposeObject(this._petItem);
         this._petItem = null;
         ObjectUtils.disposeObject(this._propertyList);
         this._propertyList = null;
         ObjectUtils.disposeObject(this._propertyView);
         this._propertyView = null;
         while(this._skillList.length > 0)
         {
            this._skillList.shift().dispose();
         }
         this._skillList = null;
         ObjectUtils.disposeObject(this._skillBox);
         this._skillBox = null;
         this._petInfo = null;
         super.dispose();
      }
   }
}
