package farm.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.*;
   import ddt.events.TimeEvents;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.model.FieldVO;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class FarmFieldsView extends Sprite implements Disposeable
   {
      
      private static var FAME_COUNT:int = 9;
       
      
      private var _fields:Vector.<FarmFieldBlock>;
      
      private var _fieldsContainer:Sprite;
      
      private var _openFlag:FieldOpenFlag;
      
      private var _alertFrame:BaseAlerFrame;
      
      private var _seedID:int;
      
      private var _plantSpeedButton:SimpleBitmapButton;
      
      private var _plantDeleteButton:SimpleBitmapButton;
      
      private var _farmRefreshMoney:int;
      
      private var __farmRefreshTrueMoney:int;
      
      private var block:FarmFieldBlock;
      
      public function FarmFieldsView()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         StageReferance.stage.addEventListener(MouseEvent.CLICK,this._MouseEventClick);
         FarmModelController.instance.addEventListener(FarmEvent.FIELDS_INFO_READY,this.__fieldInfoReady);
         FarmModelController.instance.addEventListener(FarmEvent.SEED,this.__seeding);
         FarmModelController.instance.addEventListener(FarmEvent.GAIN_FIELD,this.__gainField);
         FarmModelController.instance.addEventListener(FarmEvent.HAS_SEEDING,this.__hasSeeding);
         FarmModelController.instance.addEventListener(FarmEvent.PLANETDELETE,this.__seeding);
         FarmModelController.instance.addEventListener(FarmEvent.PLANTSPEED,this.__seeding);
         this._plantSpeedButton.addEventListener(MouseEvent.CLICK,this.__wantSpeed);
         this._plantDeleteButton.addEventListener(MouseEvent.CLICK,this.__wantDelete);
         TimeManager.addEventListener(TimeEvents.SECONDS,this.__updateByseconds);
         var _loc1_:int = 0;
         while(_loc1_ < 9)
         {
            this._fields[_loc1_].addEventListener(MouseEvent.CLICK,this.__ClickHandler);
            this._fields[_loc1_].addEventListener(MouseEvent.ROLL_OVER,this.__onRollOver);
            this._fields[_loc1_].addEventListener(MouseEvent.ROLL_OUT,this.__onRollOut);
            _loc1_++;
         }
      }
      
      private function __wantSpeed(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._alertFrame)
         {
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse1);
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse2);
         }
         ObjectUtils.disposeObject(this._alertFrame);
         this.__farmRefreshTrueMoney = Math.max(Math.ceil(this.block.info.restSecondTime / 60 / 30),1) * this._farmRefreshMoney;
         var _loc2_:AlertInfo = new AlertInfo();
         _loc2_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc2_.data = LanguageMgr.GetTranslation("store.StoreIIcompose.composeItemView.accelerateAlert1",this.__farmRefreshTrueMoney);
         _loc2_.enableHtml = true;
         _loc2_.moveEnable = false;
         this._alertFrame = AlertManager.Instance.alert("SimpleAlert",_loc2_,LayerManager.ALPHA_BLOCKGOUND);
         this._alertFrame.addEventListener(FrameEvent.RESPONSE,this.__frameResponse1);
      }
      
      private function __frameResponse1(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            if(PlayerManager.Instance.Self.totalMoney < this.__farmRefreshTrueMoney)
            {
               this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse1);
               this._alertFrame.dispose();
               LeavePageManager.showFillFrame();
               return;
            }
            if(this.block.info.isGrownUp)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.goFarm.hasGrownUP"));
               return;
            }
            FarmModelController.instance.farmPlantSpeed(this.block.info.fieldID,this.__farmRefreshTrueMoney);
         }
         this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse1);
         this._alertFrame.dispose();
      }
      
      private function __wantDelete(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._alertFrame)
         {
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse1);
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse2);
         }
         ObjectUtils.disposeObject(this._alertFrame);
         var _loc2_:AlertInfo = new AlertInfo();
         _loc2_.title = LanguageMgr.GetTranslation("AlertDialog.Info");
         _loc2_.data = LanguageMgr.GetTranslation("ddt.farms.killCropComfirmNumPnlTitle");
         _loc2_.enableHtml = true;
         _loc2_.moveEnable = false;
         this._alertFrame = AlertManager.Instance.alert("SimpleAlert",_loc2_,LayerManager.ALPHA_BLOCKGOUND);
         this._alertFrame.addEventListener(FrameEvent.RESPONSE,this.__frameResponse2);
      }
      
      private function __frameResponse2(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            FarmModelController.instance.farmPlantDelete(this.block.info.fieldID);
         }
         this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse2);
         this._alertFrame.dispose();
      }
      
      private function _MouseEventClick(param1:MouseEvent) : void
      {
         this._plantDeleteButton.visible = false;
         this._plantSpeedButton.visible = false;
      }
      
      private function __updateByseconds(param1:TimeEvents) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 9)
         {
            if(this._fields[_loc2_].info)
            {
               if(this._fields[_loc2_].info.seedID != 0 && this._fields[_loc2_].info.restSecondTime <= 0)
               {
                  if(this._fields[_loc2_].plantMovie)
                  {
                     if(this._fields[_loc2_].plantMovie.currentFrame == 1)
                     {
                        this._fields[_loc2_].info = this._fields[_loc2_].info;
                        if(!this._fields[_loc2_]._gainPlant)
                        {
                           this._fields[_loc2_].addGainMovice();
                        }
                     }
                  }
               }
            }
            _loc2_++;
         }
      }
      
      protected function __seeding(param1:FarmEvent) : void
      {
         this._fieldsContainer.mouseEnabled = true;
         this._fieldsContainer.mouseChildren = true;
         NewHandContainer.Instance.clearArrowByID(ArrowType.FARM_GUILDE);
         var _loc2_:FieldVO = param1.data as FieldVO;
         this._fields[_loc2_.fieldID].info = _loc2_;
      }
      
      protected function __gainField(param1:FarmEvent) : void
      {
         var _loc2_:FieldVO = null;
         this._fieldsContainer.mouseEnabled = true;
         this._fieldsContainer.mouseChildren = true;
         _loc2_ = param1.data as FieldVO;
         this._fields[_loc2_.fieldID].info.seedID = 0;
         if(this._fields[_loc2_.fieldID]._gainPlant)
         {
            this._fields[_loc2_.fieldID]._gainPlant.mouseEnabled = false;
            this._fields[_loc2_.fieldID]._gainPlant.mouseChildren = false;
            this._fields[_loc2_.fieldID]._gainPlant.visible = true;
            this._fields[_loc2_.fieldID]._gainPlant.gotoAndPlay(1);
         }
      }
      
      protected function __ClickHandler(param1:MouseEvent) : void
      {
         this.block = param1.currentTarget as FarmFieldBlock;
         if(!this.block || !this.block.isDig || this.block.isPlaying)
         {
            param1.stopImmediatePropagation();
            this._plantDeleteButton.visible = false;
            this._plantSpeedButton.visible = false;
            return;
         }
         SoundManager.instance.play("008");
         if(this.block.info.seedID != 0)
         {
            param1.stopImmediatePropagation();
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            if(this.block.info.isGrownUp)
            {
               FarmModelController.instance.getHarvest(this.block.info.fieldID);
               FarmModelController.instance.refreshFarm();
               this.initEvent();
            }
         }
         if(!this.block.info.isGrownUp && this.block.info.isGrow && this.block.plantMovie["chengzhan"].currentFrame == 73)
         {
            if(this._plantSpeedButton && this._plantDeleteButton)
            {
               this._plantDeleteButton.visible = true;
               this._plantSpeedButton.visible = true;
               PositionUtils.setPos(this._plantSpeedButton,"farm.fieldsView.fieldPos" + this.block.info.fieldID);
               this._plantSpeedButton.x += 35;
               this._plantSpeedButton.y -= 64;
               this._plantDeleteButton.x = this._plantSpeedButton.x + 53;
               this._plantDeleteButton.y = this._plantSpeedButton.y;
            }
         }
         else
         {
            this._plantDeleteButton.visible = false;
            this._plantSpeedButton.visible = false;
         }
      }
      
      protected function __onRollOver(param1:MouseEvent) : void
      {
         this.setFilters(false);
         var _loc2_:FarmFieldBlock = param1.target as FarmFieldBlock;
         if(_loc2_ && _loc2_.isDig)
         {
            _loc2_.showLight = true;
         }
         if(_loc2_)
         {
            if(_loc2_.info)
            {
               if(_loc2_.info.seedID != 0)
               {
                  _loc2_.upTips();
               }
            }
         }
      }
      
      protected function __onRollOut(param1:MouseEvent) : void
      {
         this.setFilters(false);
      }
      
      private function remvoeEvent() : void
      {
         FarmModelController.instance.removeEventListener(FarmEvent.FIELDS_INFO_READY,this.__fieldInfoReady);
         FarmModelController.instance.removeEventListener(FarmEvent.SEED,this.__seeding);
         FarmModelController.instance.removeEventListener(FarmEvent.GAIN_FIELD,this.__gainField);
         FarmModelController.instance.removeEventListener(FarmEvent.HAS_SEEDING,this.__hasSeeding);
         FarmModelController.instance.removeEventListener(FarmEvent.PLANTSPEED,this.__seeding);
         FarmModelController.instance.removeEventListener(FarmEvent.PLANETDELETE,this.__seeding);
         TimeManager.removeEventListener(TimeEvents.SECONDS,this.__updateByseconds);
         StageReferance.stage.removeEventListener(MouseEvent.CLICK,this._MouseEventClick);
         if(this._alertFrame)
         {
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse1);
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse2);
         }
         var _loc1_:int = 0;
         while(_loc1_ < FAME_COUNT)
         {
            this._fields[_loc1_].removeEventListener(MouseEvent.CLICK,this.__ClickHandler);
            this._fields[_loc1_].removeEventListener(MouseEvent.ROLL_OVER,this.__onRollOver);
            this._fields[_loc1_].removeEventListener(MouseEvent.ROLL_OUT,this.__onRollOut);
            _loc1_++;
         }
      }
      
      private function initView() : void
      {
         var _loc2_:FarmFieldBlock = null;
         this._fieldsContainer = new Sprite();
         this._fields = new Vector.<FarmFieldBlock>(FAME_COUNT);
         var _loc1_:int = 0;
         while(_loc1_ < FAME_COUNT)
         {
            _loc2_ = new FarmFieldBlock(_loc1_);
            PositionUtils.setPos(_loc2_,"farm.fieldsView.fieldPos" + _loc1_);
            this._fieldsContainer.addChild(_loc2_);
            this._fields[_loc1_] = _loc2_;
            _loc1_++;
         }
         addChild(this._fieldsContainer);
         this._openFlag = new FieldOpenFlag();
         this._openFlag.visible = false;
         addChild(this._openFlag);
         this._openFlag.mouseChildren = false;
         this._openFlag.mouseEnabled = false;
         this._plantSpeedButton = ComponentFactory.Instance.creatComponentByStylename("farm.button.speed");
         addChild(this._plantSpeedButton);
         this._plantDeleteButton = ComponentFactory.Instance.creatComponentByStylename("farm.button.delete");
         addChild(this._plantDeleteButton);
         this._plantDeleteButton.visible = false;
         this._plantSpeedButton.visible = false;
         this._plantSpeedButton.tipData = LanguageMgr.GetTranslation("singledungeon.expedition.frame.button.accelerate");
         this._plantDeleteButton.tipData = LanguageMgr.GetTranslation("ddt.farm.killCrop.sure");
         this._farmRefreshMoney = ServerConfigManager.instance.getFarmRefreshMoney();
      }
      
      private function setFilters(param1:Boolean) : void
      {
         var _loc2_:FarmFieldBlock = null;
         for each(_loc2_ in this._fields)
         {
            _loc2_.showLight = param1;
         }
      }
      
      protected function __fieldInfoReady(param1:FarmEvent) : void
      {
         this.upFields();
         this.upFlagPlace();
      }
      
      private function __hasSeeding(param1:FarmEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < FAME_COUNT)
         {
            if(this._fields[_loc2_].info.fieldID == FarmModelController.instance.model.seedingFieldInfo.fieldID)
            {
               this._fields[_loc2_].info = FarmModelController.instance.model.seedingFieldInfo;
               break;
            }
            _loc2_++;
         }
      }
      
      private function upFields() : void
      {
         var _loc4_:int = 0;
         this._fieldsContainer.mouseEnabled = true;
         this._fieldsContainer.mouseChildren = true;
         var _loc1_:Array = [0,1,2,3,4,5,6,7,8];
         var _loc2_:DictionaryData = FarmModelController.instance.model.fieldsInfo;
         var _loc3_:int = 0;
         while(_loc3_ < FAME_COUNT)
         {
            this._fields[_loc3_].info = _loc2_[_loc3_];
            _loc3_++;
         }
         _loc4_ = PlayerManager.Instance.Self.Grade;
         var _loc5_:int = ServerConfigManager.instance.getFarmFieldCount(_loc4_);
         if(_loc5_ < FAME_COUNT)
         {
            this._openFlag.x = this._fields[_loc5_].x + 40;
            this._openFlag.y = this._fields[_loc5_].y - 27;
            this._openFlag.level = ServerConfigManager.instance.getFarmOpenLevel(_loc4_);
            this._openFlag.visible = true;
         }
         else
         {
            this._openFlag.visible = false;
         }
      }
      
      private function upFlagPlace() : void
      {
         var _loc2_:DictionaryData = null;
         var _loc3_:int = 0;
         var _loc1_:Array = [3,4,5,6,7,8];
         if(FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
         {
            _loc2_ = FarmModelController.instance.model.fieldsInfo;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(_loc2_[_loc3_].fieldID >= 3 && (_loc2_[_loc3_].isDig || _loc2_[_loc3_].seedID != 0))
               {
                  _loc1_.splice(_loc1_.indexOf(_loc2_[_loc3_].fieldID),1);
               }
               _loc3_++;
            }
         }
      }
      
      public function dispose() : void
      {
         this.remvoeEvent();
         var _loc1_:int = 0;
         while(_loc1_ < FAME_COUNT)
         {
            if(this._fields[_loc1_])
            {
               ObjectUtils.disposeObject(this._fields[_loc1_]);
               this._fields[_loc1_] = null;
            }
            _loc1_++;
         }
         if(this._plantSpeedButton)
         {
            ObjectUtils.disposeObject(this._plantSpeedButton);
         }
         this._plantSpeedButton = null;
         if(this._plantDeleteButton)
         {
            ObjectUtils.disposeObject(this._plantDeleteButton);
         }
         this._plantDeleteButton = null;
         ObjectUtils.disposeObject(this._openFlag);
         this._openFlag = null;
         this._fields = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
