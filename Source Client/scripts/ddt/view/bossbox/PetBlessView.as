package ddt.view.bossbox
{
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetInfoManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import pet.date.PetInfo;
   import petsBag.view.item.PetBigItem;
   
   public class PetBlessView extends BaseAlerFrame
   {
       
      
      private var _bg:MutipleImage;
      
      private var _titleMc:MovieClip;
      
      private var _petBg:MovieClip;
      
      private var _downTip:MovieClip;
      
      private var _blessBg:MovieClip;
      
      private var _blessShine:MovieClip;
      
      private var _nameTxt:FilterFrameText;
      
      private var _newNameTxt:FilterFrameText;
      
      private var _hpTxt:FilterFrameText;
      
      private var _attackTxt:FilterFrameText;
      
      private var _defenceTxt:FilterFrameText;
      
      private var _agilityTxt:FilterFrameText;
      
      private var _luckTxt:FilterFrameText;
      
      private var _addhpNum:PetBlessAddNumView;
      
      private var _addattackNum:PetBlessAddNumView;
      
      private var _adddefenceNum:PetBlessAddNumView;
      
      private var _addagilityNum:PetBlessAddNumView;
      
      private var _addluckNum:PetBlessAddNumView;
      
      private var _bloodShine:MovieClip;
      
      private var _attackShine:MovieClip;
      
      private var _defenceShine:MovieClip;
      
      private var _agilityShine:MovieClip;
      
      private var _luckShine:MovieClip;
      
      private var _petBigNameTxt:FilterFrameText;
      
      private var _petItem:PetBigItem;
      
      private var _newPetItem:PetBigItem;
      
      private var _confirmTxt:FilterFrameText;
      
      private var _frameCount:int;
      
      private var _petInfo:PetInfo;
      
      private var _newPetInfo:PetInfo;
      
      private var _itemInfo:InventoryItemInfo;
      
      public function PetBlessView()
      {
         super();
         this.initEvent();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.bg");
         addToContent(this._bg);
         this._titleMc = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.title");
         addToContent(this._titleMc);
         this._petBg = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.petBg");
         addToContent(this._petBg);
         this._downTip = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.downTip");
         this._downTip.stop();
         addToContent(this._downTip);
         this._petItem = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.petItem");
         addToContent(this._petItem);
         this._nameTxt = ComponentFactory.Instance.creat("ddtbagAndInfo.PetBlessView.nameTxt");
         addToContent(this._nameTxt);
         this._newNameTxt = ComponentFactory.Instance.creat("ddtbagAndInfo.PetBlessView.nameTxt");
         this._newNameTxt.alpha = 0;
         this._newNameTxt.y += 16;
         addToContent(this._newNameTxt);
         this._hpTxt = ComponentFactory.Instance.creat("ddtbagAndInfo.PetBlessView.hpTxt");
         addToContent(this._hpTxt);
         this._attackTxt = ComponentFactory.Instance.creat("ddtbagAndInfo.PetBlessView.attackTxt");
         addToContent(this._attackTxt);
         this._defenceTxt = ComponentFactory.Instance.creat("ddtbagAndInfo.PetBlessView.defenceTxt");
         addToContent(this._defenceTxt);
         this._agilityTxt = ComponentFactory.Instance.creat("ddtbagAndInfo.PetBlessView.agilityTxt");
         addToContent(this._agilityTxt);
         this._luckTxt = ComponentFactory.Instance.creat("ddtbagAndInfo.PetBlessView.luckTxt");
         addToContent(this._luckTxt);
         this._addhpNum = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.bloodNum");
         this._addhpNum.visible = false;
         addToContent(this._addhpNum);
         this._addattackNum = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.attackNum");
         this._addattackNum.visible = false;
         addToContent(this._addattackNum);
         this._adddefenceNum = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.defenceNum");
         this._adddefenceNum.visible = false;
         addToContent(this._adddefenceNum);
         this._addagilityNum = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.agilityNum");
         this._addagilityNum.visible = false;
         addToContent(this._addagilityNum);
         this._addluckNum = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.luckNum");
         this._addluckNum.visible = false;
         addToContent(this._addluckNum);
         this._bloodShine = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.bloodShine");
         this._bloodShine.visible = false;
         addToContent(this._bloodShine);
         this._attackShine = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.blueShine1");
         this._attackShine.visible = false;
         addToContent(this._attackShine);
         this._defenceShine = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.blueShine2");
         this._defenceShine.visible = false;
         addToContent(this._defenceShine);
         this._agilityShine = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.blueShine3");
         this._agilityShine.visible = false;
         addToContent(this._agilityShine);
         this._luckShine = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.blueShine4");
         this._luckShine.visible = false;
         addToContent(this._luckShine);
         this._confirmTxt = ComponentFactory.Instance.creat("ddtbagAndInfo.PetBlessView.confirmTxt");
         this._confirmTxt.text = LanguageMgr.GetTranslation("ddtbagAndInfo.usePetBlessAlertMsg");
         addToContent(this._confirmTxt);
         this._petBigNameTxt = ComponentFactory.Instance.creat("ddtbagAndInfo.PetBlessView.petBigNameTxt");
         addToContent(this._petBigNameTxt);
         var _loc1_:AlertInfo = new AlertInfo("",LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,true);
         _loc1_.customPos = ComponentFactory.Instance.creat("asset.bagAndInfo.petBless.pos");
         info = _loc1_;
      }
      
      protected function initEvent() : void
      {
         this._downTip.addEventListener("next step",this.__onNextStep);
         this._downTip.addEventListener(Event.COMPLETE,this.__onComplete);
         addEventListener(FrameEvent.RESPONSE,this.__onRespose);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_BLESS,this.__petBlessed);
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         this._downTip.removeEventListener("next step",this.__onNextStep);
         this._downTip.removeEventListener(Event.COMPLETE,this.__onComplete);
         removeEventListener(FrameEvent.RESPONSE,this.__onRespose);
         this._addhpNum.removeEventListener(Event.COMPLETE,this.__onAddComplete);
         this._addattackNum.removeEventListener(Event.COMPLETE,this.__onAddComplete);
         this._adddefenceNum.removeEventListener(Event.COMPLETE,this.__onAddComplete);
         this._addagilityNum.removeEventListener(Event.COMPLETE,this.__onAddComplete);
         this._addluckNum.removeEventListener(Event.COMPLETE,this.__onAddComplete);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_BLESS,this.__petBlessed);
      }
      
      protected function __onRespose(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this._itemInfo)
               {
                  SocketManager.Instance.out.sendUseCard(this._itemInfo.BagType,this._itemInfo.Place,[this._itemInfo.TemplateID],this._itemInfo.PayType);
               }
               break;
            default:
               this.dispose();
         }
      }
      
      protected function __onNextStep(param1:Event) : void
      {
         if(!this._blessBg)
         {
            this._blessBg = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.petBlessBg");
            addToContent(this._blessBg);
         }
         if(!this._blessShine)
         {
            this._blessShine = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.petBlessShine");
            addToContent(this._blessShine);
         }
         this._blessBg.gotoAndPlay(1);
         this._blessShine.gotoAndPlay(1);
         if(!this._newPetItem)
         {
            this._newPetItem = ComponentFactory.Instance.creat("bagAndInfo.petBlessView.petItem");
            this._newPetItem.info = this._newPetInfo;
            addToContent(this._newPetItem);
         }
         this._frameCount = 0;
         addEventListener(Event.ENTER_FRAME,this.__onEnterFrame);
         this._newNameTxt.text = this._newPetInfo.Name;
         TweenLite.to(this._newNameTxt,1,{
            "alpha":1,
            "y":this._newNameTxt.y - 16
         });
         TweenLite.to(this._nameTxt,0.5,{"alpha":0});
         TweenLite.to(this._petItem,0.5,{"alpha":0});
         this._newPetItem.scaleX = 0;
         this._newPetItem.scaleY = 0;
         this._newPetItem.alpha = 0;
         TweenLite.to(this._newPetItem,1,{
            "scaleX":1,
            "scaleY":1,
            "alpha":1
         });
      }
      
      protected function __onComplete(param1:Event) : void
      {
      }
      
      protected function __onEnterFrame(param1:Event) : void
      {
         if(this._frameCount == 10)
         {
            this._addhpNum.visible = true;
            this._addhpNum.TweenTo(0,(this._newPetInfo.Blood - this._petInfo.Blood) / 100,20);
            this._addhpNum.addEventListener(Event.COMPLETE,this.__onAddComplete);
         }
         if(this._frameCount == 15)
         {
            this._addattackNum.visible = true;
            this._addattackNum.TweenTo(0,(this._newPetInfo.Attack - this._petInfo.Attack) / 100,20);
            this._addattackNum.addEventListener(Event.COMPLETE,this.__onAddComplete);
            this._petBigNameTxt.alpha = 0;
            TweenLite.to(this._petBigNameTxt,0.5,{"alpha":1});
         }
         if(this._frameCount == 20)
         {
            this._adddefenceNum.visible = true;
            this._adddefenceNum.TweenTo(0,(this._newPetInfo.Defence - this._petInfo.Defence) / 100,20);
            this._adddefenceNum.addEventListener(Event.COMPLETE,this.__onAddComplete);
         }
         if(this._frameCount == 25)
         {
            this._addagilityNum.visible = true;
            this._addagilityNum.TweenTo(0,(this._newPetInfo.Agility - this._petInfo.Agility) / 100,20);
            this._addagilityNum.addEventListener(Event.COMPLETE,this.__onAddComplete);
         }
         if(this._frameCount == 30)
         {
            this._addluckNum.visible = true;
            this._addluckNum.TweenTo(0,(this._newPetInfo.Luck - this._petInfo.Luck) / 100,20);
            this._addluckNum.addEventListener(Event.COMPLETE,this.__onAddComplete);
         }
         this._hpTxt.text = int(this._petInfo.Blood / 100) + int(this._addhpNum.currentNum) + "";
         this._attackTxt.text = int(this._petInfo.Attack / 100) + int(this._addattackNum.currentNum) + "";
         this._defenceTxt.text = int(this._petInfo.Defence / 100) + int(this._adddefenceNum.currentNum) + "";
         this._agilityTxt.text = int(this._petInfo.Agility / 100) + int(this._addagilityNum.currentNum) + "";
         this._luckTxt.text = int(this._petInfo.Luck / 100) + int(this._addluckNum.currentNum) + "";
         ++this._frameCount;
      }
      
      protected function __onAddComplete(param1:Event) : void
      {
         switch(param1.target)
         {
            case this._addhpNum:
               this._bloodShine.visible = true;
               this._bloodShine.gotoAndPlay(1);
               break;
            case this._addattackNum:
               this._attackShine.visible = true;
               this._attackShine.gotoAndPlay(1);
               break;
            case this._adddefenceNum:
               this._defenceShine.visible = true;
               this._defenceShine.gotoAndPlay(1);
               break;
            case this._addagilityNum:
               this._agilityShine.visible = true;
               this._agilityShine.gotoAndPlay(1);
               break;
            case this._addluckNum:
               this._luckShine.visible = true;
               this._luckShine.gotoAndPlay(1);
         }
      }
      
      protected function __petBlessed(param1:CrazyTankSocketEvent) : void
      {
         this.play();
      }
      
      public function get petInfo() : PetInfo
      {
         return this._petInfo;
      }
      
      public function set petInfo(param1:PetInfo) : void
      {
         this._petInfo = param1;
         this._petItem.info = this._petInfo;
         if(this._petInfo)
         {
            this._nameTxt.text = this._petInfo.Name.toString();
            this._hpTxt.text = this._petInfo.Blood / 100 + "";
            this._attackTxt.text = this._petInfo.Attack / 100 + "";
            this._defenceTxt.text = this._petInfo.Defence / 100 + "";
            this._agilityTxt.text = this._petInfo.Agility / 100 + "";
            this._luckTxt.text = this._petInfo.Luck / 100 + "";
            this._newPetInfo = PetInfoManager.instance.getBlessedPetInfo(this._petInfo);
            this._newNameTxt.text = this._newPetInfo.Name;
            this._petBigNameTxt.text = this._newPetInfo.Name;
         }
      }
      
      public function play() : void
      {
         this._confirmTxt.visible = false;
         _submitButton.visible = false;
         _cancelButton.visible = false;
         this._downTip.gotoAndPlay(1);
      }
      
      public function get itemInfo() : InventoryItemInfo
      {
         return this._itemInfo;
      }
      
      public function set itemInfo(param1:InventoryItemInfo) : void
      {
         this._itemInfo = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._titleMc);
         this._titleMc = null;
         ObjectUtils.disposeObject(this._petBg);
         this._petBg = null;
         ObjectUtils.disposeObject(this._downTip);
         this._downTip = null;
         ObjectUtils.disposeObject(this._blessBg);
         this._blessBg = null;
         ObjectUtils.disposeObject(this._blessShine);
         this._blessShine = null;
         ObjectUtils.disposeObject(this._nameTxt);
         this._nameTxt = null;
         ObjectUtils.disposeObject(this._newNameTxt);
         this._newNameTxt = null;
         ObjectUtils.disposeObject(this._hpTxt);
         this._hpTxt = null;
         ObjectUtils.disposeObject(this._attackTxt);
         this._attackTxt = null;
         ObjectUtils.disposeObject(this._defenceTxt);
         this._defenceTxt = null;
         ObjectUtils.disposeObject(this._agilityTxt);
         this._agilityTxt = null;
         ObjectUtils.disposeObject(this._luckTxt);
         this._luckTxt = null;
         ObjectUtils.disposeObject(this._addhpNum);
         this._addhpNum = null;
         ObjectUtils.disposeObject(this._addattackNum);
         this._addattackNum = null;
         ObjectUtils.disposeObject(this._adddefenceNum);
         this._adddefenceNum = null;
         ObjectUtils.disposeObject(this._addagilityNum);
         this._addagilityNum = null;
         ObjectUtils.disposeObject(this._addluckNum);
         this._addluckNum = null;
         ObjectUtils.disposeObject(this._bloodShine);
         this._bloodShine = null;
         ObjectUtils.disposeObject(this._attackShine);
         this._attackShine = null;
         ObjectUtils.disposeObject(this._defenceShine);
         this._defenceShine = null;
         ObjectUtils.disposeObject(this._agilityShine);
         this._agilityShine = null;
         ObjectUtils.disposeObject(this._luckShine);
         this._luckShine = null;
         ObjectUtils.disposeObject(this._petItem);
         this._petItem = null;
         ObjectUtils.disposeObject(this._newPetItem);
         this._newPetItem = null;
         ObjectUtils.disposeObject(this._petBigNameTxt);
         this._petBigNameTxt = null;
         ObjectUtils.disposeObject(this._confirmTxt);
         this._confirmTxt = null;
         this._petInfo = null;
         this._newPetInfo = null;
      }
   }
}
