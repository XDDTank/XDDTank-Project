package petsBag.view
{
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PetBagManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import petsBag.data.PetBagModel;
   import petsBag.event.PetItemEvent;
   import petsBag.view.list.PetInfoList;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class PetInfoFrame extends PetBaseFrame
   {
      
      public static const MOVE_SPEED:Number = 0.5;
       
      
      private var _bg:Bitmap;
      
      private var _bgI:Scale9CornerImage;
      
      private var _btnBg:Scale9CornerImage;
      
      private var _scroll:ScrollPanel;
      
      private var _petInfoList:PetInfoList;
      
      private var _infoView:PetInfoView;
      
      private var _skillBtn:BaseButton;
      
      private var _changeBtn:BaseButton;
      
      private var _advanceBtn:BaseButton;
      
      private var _transformBtn:BaseButton;
      
      private var _rightFrame:PetRightBaseFrame;
      
      private var _model:PetBagModel;
      
      private var _infoWidth:Number;
      
      private var _titleBmp:Bitmap;
      
      private var _lastClick:BaseButton;
      
      public function PetInfoFrame(param1:PetBagModel)
      {
         this._model = param1;
         super();
         this.initEvent();
         this.update();
         this._petInfoList.selectedIndex = this.findDefaultIndex();
      }
      
      override protected function init() : void
      {
         super.init();
         this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.pet.title");
         addToContent(this._titleBmp);
         this._bgI = ComponentFactory.Instance.creatComponentByStylename("asset.newpetsBag.leftBgI");
         addToContent(this._bgI);
         this._bg = ComponentFactory.Instance.creatBitmap("asset.newpetsBag.leftBg");
         addToContent(this._bg);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("asset.newpetsBag.btnBg");
         addToContent(this._btnBg);
         this._petInfoList = ComponentFactory.Instance.creat("petsBag.view.petInfoList",[7]);
         addToContent(this._petInfoList);
         this._scroll = ComponentFactory.Instance.creat("petsBag.view.list.petInfoList.scroll");
         this._scroll.setView(this._petInfoList);
         addToContent(this._scroll);
         this._infoView = ComponentFactory.Instance.creat("petsBag.view.petInfoView");
         addToContent(this._infoView);
         this._skillBtn = ComponentFactory.Instance.creat("petsBag.view.infoFrame.skillBtn");
         addToContent(this._skillBtn);
         this._changeBtn = ComponentFactory.Instance.creat("petsBag.view.infoFrame.changeBtn");
         addToContent(this._changeBtn);
         this._advanceBtn = ComponentFactory.Instance.creat("petsBag.view.infoFrame.advanceBtn");
         this._advanceBtn.visible = false;
         addToContent(this._advanceBtn);
         this._transformBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.view.infoFrame.transformBtn");
         addToContent(this._transformBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
         this._petInfoList.addEventListener(PetItemEvent.ITEM_CHANGE,this.__itemChange);
         this._skillBtn.addEventListener(MouseEvent.CLICK,this.__openFrame);
         this._changeBtn.addEventListener(MouseEvent.CLICK,this.__magicChange);
         this._advanceBtn.addEventListener(MouseEvent.CLICK,this.__openFrame);
         this._transformBtn.addEventListener(MouseEvent.CLICK,this.__openFrame);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__response);
         this._petInfoList.removeEventListener(PetItemEvent.ITEM_CHANGE,this.__itemChange);
         this._skillBtn.removeEventListener(MouseEvent.CLICK,this.__openFrame);
         this._changeBtn.removeEventListener(MouseEvent.CLICK,this.__magicChange);
         this._advanceBtn.removeEventListener(MouseEvent.CLICK,this.__openFrame);
         this._transformBtn.removeEventListener(MouseEvent.CLICK,this.__openFrame);
      }
      
      private function showWeakGuilde() : void
      {
         if(!SavePointManager.Instance.savePoints[72] && TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(591)))
         {
            NewHandContainer.Instance.showArrow(ArrowType.CLICK_PET,0,"trainer.petClick1","","",LayerManager.Instance.getLayerByType(LayerManager.BLCAK_BLOCKGOUND));
         }
      }
      
      protected function __itemChange(param1:PetItemEvent) : void
      {
         if(this._rightFrame)
         {
            this._rightFrame.reset();
         }
         this.update();
      }
      
      protected function __magicChange(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:PetInfo = this.getCurrentPet();
         if(_loc2_)
         {
            if(this._model.selfInfo.Bag.getItemCountByTemplateId(_loc2_.ItemId) > 0)
            {
               SocketManager.Instance.out.sendPetMagic(this.getCurrentPet().Place);
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.view.petInfoFrame.noMagicStone"));
            }
         }
      }
      
      protected function __openFrame(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         SoundManager.instance.play("008");
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_PET);
         if(!this.getCurrentPet())
         {
            return;
         }
         if(this._lastClick != param1.currentTarget)
         {
            switch(param1.currentTarget)
            {
               case this._skillBtn:
                  this.showFrame(0);
                  break;
               case this._advanceBtn:
                  this.showFrame(1);
                  break;
               case this._transformBtn:
                  this.showFrame(2);
            }
            this._lastClick = param1.currentTarget as BaseButton;
         }
         else
         {
            this.hideFrame();
            this._lastClick = null;
         }
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         this._infoWidth = param1;
      }
      
      public function showFrame(param1:int) : void
      {
         var _loc2_:String = null;
         if(this._rightFrame)
         {
            this.releaseRight(this._rightFrame);
            this._rightFrame = null;
         }
         switch(param1)
         {
            case 0:
               _loc2_ = "petsBag.view.skillFrame";
               break;
            case 1:
               _loc2_ = "petsBag.view.advanceFrame";
               break;
            case 2:
               _loc2_ = "petsBag.view.transformFrame";
         }
         this._rightFrame = ComponentFactory.Instance.creat(_loc2_);
         this._rightFrame.info = this.getCurrentPet();
         this._rightFrame.addEventListener(FrameEvent.RESPONSE,this.__onclose);
         addChildAt(this._rightFrame,0);
         var _loc3_:int = this._infoWidth + this._rightFrame.width;
         TweenLite.to(this,MOVE_SPEED,{"x":(StageReferance.stage.stageWidth - _loc3_) / 2});
         TweenLite.to(this._rightFrame,MOVE_SPEED,{"x":this._infoWidth});
      }
      
      public function setIndex(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 < this._petInfoList.items.length)
         {
            this._petInfoList.selectedIndex = param1;
         }
      }
      
      protected function __onclose(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.hideFrame();
               this._lastClick = null;
               break;
            case FrameEvent.HELP_CLICK:
               this._rightFrame.showHelp();
         }
      }
      
      public function hideFrame() : void
      {
         TweenLite.to(this,MOVE_SPEED,{"x":(StageReferance.stage.stageWidth - this._infoWidth) / 2});
         TweenLite.to(this._rightFrame,MOVE_SPEED,{
            "x":0,
            "onComplete":this.releaseRight,
            "onCompleteParams":[this._rightFrame]
         });
         this._rightFrame = null;
      }
      
      private function releaseRight(param1:PetBaseFrame) : void
      {
         if(param1)
         {
            param1.removeEventListener(FrameEvent.RESPONSE,this.__onclose);
         }
         ObjectUtils.disposeObject(param1);
      }
      
      protected function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.HELP_CLICK:
               showHelp();
         }
      }
      
      public function show(param1:int) : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         switch(param1)
         {
            case 0:
               this._skillBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 1:
               this._advanceBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
               break;
            case 2:
               this._transformBtn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
         this.showWeakGuilde();
      }
      
      public function getCurrentPet() : PetInfo
      {
         if(this._petInfoList.selectedIndex > -1 && this._petInfoList.selectedIndex < this._petInfoList.items.length)
         {
            return this._petInfoList.items[this._petInfoList.selectedIndex];
         }
         return null;
      }
      
      private function findDefaultIndex() : int
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._petInfoList.items.length)
         {
            if(this._petInfoList.items[_loc1_].Place == 0)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return 0;
      }
      
      public function update() : void
      {
         this._petInfoList.items = this._model.getpetListSorted();
         var _loc1_:PetInfo = this.getCurrentPet();
         this._infoView.info = _loc1_;
         this._scroll.invalidateViewport();
         if(this._rightFrame)
         {
            this._rightFrame.info = _loc1_;
         }
         if(_loc1_ && _loc1_.MagicLevel > 0)
         {
            this._changeBtn.visible = false;
            this._advanceBtn.visible = true;
         }
         else
         {
            this._changeBtn.visible = true;
            this._advanceBtn.visible = false;
         }
         if(_loc1_)
         {
            ShowTipManager.Instance.removeTip(this._changeBtn);
            this._changeBtn.enable = _loc1_.Level >= this._model.PetMagicLevel1;
            if(_loc1_.Level < 30)
            {
               this._changeBtn.enable = false;
               this._changeBtn.tipStyle = "ddt.view.tips.OneLineTip";
               this._changeBtn.tipData = LanguageMgr.GetTranslation("petsBag.view.petInfoFrame.changeBtnTip1");
            }
            else
            {
               this._changeBtn.enable = true;
               this._changeBtn.tipStyle = "petsBag.view.MagicTip";
               this._changeBtn.tipData = _loc1_;
            }
            ShowTipManager.Instance.addTip(this._changeBtn);
            if(_loc1_.MagicLevel > 0)
            {
               this._transformBtn.enable = true;
               ShowTipManager.Instance.removeTip(this._transformBtn);
            }
            else
            {
               this._transformBtn.enable = false;
               this._transformBtn.tipStyle = "ddt.view.tips.OneLineTip";
               this._transformBtn.tipData = LanguageMgr.GetTranslation("petsBag.view.petInfoFrame.transformBtnTip1");
               ShowTipManager.Instance.addTip(this._transformBtn);
            }
         }
      }
      
      override public function dispose() : void
      {
         NewHandContainer.Instance.clearArrowByID(ArrowType.CLICK_PET);
         this.removeEvent();
         PetBagManager.instance().closePetFrame();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._bgI);
         this._bgI = null;
         ObjectUtils.disposeObject(this._btnBg);
         this._btnBg = null;
         ObjectUtils.disposeObject(this._petInfoList);
         this._petInfoList = null;
         ObjectUtils.disposeObject(this._scroll);
         this._scroll = null;
         ObjectUtils.disposeObject(this._infoView);
         this._infoView = null;
         ObjectUtils.disposeObject(this._skillBtn);
         this._skillBtn = null;
         ObjectUtils.disposeObject(this._changeBtn);
         this._changeBtn = null;
         ObjectUtils.disposeObject(this._advanceBtn);
         this._advanceBtn = null;
         ObjectUtils.disposeObject(this._rightFrame);
         this._rightFrame = null;
         ObjectUtils.disposeObject(this._transformBtn);
         this._transformBtn = null;
         if(this._titleBmp)
         {
            ObjectUtils.disposeObject(this._titleBmp);
         }
         this._titleBmp = null;
         this._model = null;
         super.dispose();
      }
   }
}
