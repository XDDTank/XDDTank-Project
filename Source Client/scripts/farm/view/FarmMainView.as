package farm.view
{
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.PlayerManager;
   import ddt.manager.SavePointManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TaskManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.event.FarmEvent;
   import farm.model.FieldVO;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.ui.Mouse;
   import trainer.data.ArrowType;
   import trainer.view.NewHandContainer;
   
   public class FarmMainView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _water:MovieClip;
      
      private var _water1:MovieClip;
      
      private var _waterwheel:MovieClip;
      
      private var _float:MovieClip;
      
      private var _pastureHouseBtn:MovieClip;
      
      private var _fengCheZhuanZhuan:MovieClip;
      
      private var _pastureHitArea:Sprite;
      
      private var _fireflyMC1:MovieClip;
      
      private var _fireflyMC2:MovieClip;
      
      private var _fireflyMC3:MovieClip;
      
      private var _fieldView:FarmFieldsView;
      
      private var _hostNameBmp:Bitmap;
      
      private var _seedButton:BaseButton;
      
      private var _farmName:FilterFrameText;
      
      private var _seedView:SeedSelectedView;
      
      private var _seedVo:FieldVO;
      
      public function FarmMainView()
      {
         super();
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.farm.mainViewBg");
         this.addChild(this._bg);
         this._water = ClassUtils.CreatInstance("asset.farm.water");
         PositionUtils.setPos(this._water,"farm.waterPos");
         this._water1 = ClassUtils.CreatInstance("asset.farm.water1");
         PositionUtils.setPos(this._water1,"farm.waterPos1");
         this._waterwheel = ClassUtils.CreatInstance("asset.farm.waterwheel");
         PositionUtils.setPos(this._waterwheel,"farm.waterwheelPos");
         this._float = ClassUtils.CreatInstance("asset.farm.float");
         PositionUtils.setPos(this._float,"farm.floatPos");
         this._fireflyMC1 = ClassUtils.CreatInstance("asset.farm.fireflyAsset");
         PositionUtils.setPos(this._fireflyMC1,"farm.fireflyPos1");
         this._fireflyMC2 = ClassUtils.CreatInstance("asset.farm.fireflyAsset");
         PositionUtils.setPos(this._fireflyMC2,"farm.fireflyPos2");
         this._fireflyMC3 = ClassUtils.CreatInstance("asset.farm.fireflyAsset");
         PositionUtils.setPos(this._fireflyMC3,"farm.fireflyPos3");
         this._water.mouseEnabled = this._water.mouseChildren = this._waterwheel.mouseEnabled = this._waterwheel.mouseChildren = this._float.mouseEnabled = this._float.mouseChildren = this._fireflyMC1.mouseEnabled = this._fireflyMC1.mouseChildren = this._fireflyMC2.mouseEnabled = this._fireflyMC2.mouseChildren = this._fireflyMC3.mouseEnabled = this._fireflyMC3.mouseChildren = this._water1.mouseEnabled = this._water1.mouseChildren = false;
         addChild(this._water);
         addChild(this._water1);
         addChild(this._waterwheel);
         addChild(this._float);
         addChild(this._fireflyMC1);
         addChild(this._fireflyMC2);
         addChild(this._fireflyMC3);
         this._pastureHouseBtn = ClassUtils.CreatInstance("asset.farm.pastureBtn");
         PositionUtils.setPos(this._pastureHouseBtn,"farm.pasturehousebtnPos");
         this._fengCheZhuanZhuan = ClassUtils.CreatInstance("asset.farm.windmill");
         PositionUtils.setPos(this._fengCheZhuanZhuan,"farm.fengCheZuanPos");
         this._pastureHouseBtn.mouseChildren = false;
         this._pastureHouseBtn.mouseEnabled = false;
         addChild(this._pastureHouseBtn);
         addChild(this._fengCheZhuanZhuan);
         this._hostNameBmp = ComponentFactory.Instance.creatBitmap("asset.farm.fieldHostName");
         this._hostNameBmp.x = (StageReferance.stageWidth - this._hostNameBmp.width) / 2;
         addChild(this._hostNameBmp);
         this._farmName = ComponentFactory.Instance.creatComponentByStylename("farm.mainView.hostName");
         addChild(this._farmName);
         this._farmName.text = FarmModelController.instance.model.currentFarmerName;
         this._seedView = ComponentFactory.Instance.creat("farm.seedView");
         this._seedView.viewType = SeedSelectedView.SEED;
         addChild(this._seedView);
         this.petFarmGuilde();
         this._seedButton = ComponentFactory.Instance.creat("asset.field.seedButton");
         addChild(this._seedButton);
         this._fieldView = new FarmFieldsView();
         PositionUtils.setPos(this._fieldView,"farm.fieldsView");
         addChild(this._fieldView);
      }
      
      private function petFarmGuilde() : void
      {
         if(SavePointManager.Instance.isInSavePoint(48) && !TaskManager.instance.isNewHandTaskCompleted(21))
         {
            NewHandContainer.Instance.showArrow(ArrowType.FARM_GUILDE,0,"trainer.farmFieldArrowPos","","");
         }
      }
      
      private function initEvent() : void
      {
         FarmModelController.instance.addEventListener(FarmEvent.FIELDS_INFO_READY,this.__enterFram);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__levelUp);
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         this._fieldView.addEventListener(FarmEvent.SEED,this.__beginSeed);
      }
      
      protected function __levelUp(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Grade"])
         {
            FarmModelController.instance.refreshFarm();
         }
      }
      
      protected function __progressPlay(param1:Event) : void
      {
      }
      
      protected function __beginSeed(param1:FarmEvent) : void
      {
         param1.stopImmediatePropagation();
         this._seedVo = param1.data as FieldVO;
         if(!this._seedVo)
         {
            return;
         }
         if(FarmModelController.instance._cell.itemInfo.Count <= 0)
         {
            FarmModelController.instance._cell.stopDrag();
         }
         FarmModelController.instance.sowSeed(this._seedVo.seedID,this._seedVo.fieldID);
         --FarmModelController.instance._cell.itemInfo.Count;
      }
      
      protected function __mouseClick(param1:MouseEvent) : void
      {
         var _loc2_:FarmFieldBlock = param1.target.parent as FarmFieldBlock;
         if(_loc2_ && _loc2_.isDig || param1.target == this._seedButton)
         {
            SoundManager.instance.play("008");
            this._seedView.isShow = true;
            setChildIndex(this._seedView,numChildren - 1);
         }
         else
         {
            this._seedView.isShow = false;
            if(SavePointManager.Instance.isInSavePoint(48) && !TaskManager.instance.isNewHandTaskCompleted(21))
            {
               NewHandContainer.Instance.showArrow(ArrowType.FARM_GUILDE,0,"trainer.farmFieldArrowPos","","");
            }
         }
      }
      
      protected function __pastureOut(param1:MouseEvent) : void
      {
         this._pastureHouseBtn.gotoAndStop(1);
      }
      
      protected function __pastureOver(param1:MouseEvent) : void
      {
         this._pastureHouseBtn.gotoAndStop(2);
      }
      
      protected function __enterFram(param1:FarmEvent) : void
      {
         this._farmName.text = FarmModelController.instance.model.currentFarmerName;
         this.petFarmGuilde();
      }
      
      private function removeEvent() : void
      {
         FarmModelController.instance.removeEventListener(FarmEvent.FIELDS_INFO_READY,this.__enterFram);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__levelUp);
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         this._fieldView.removeEventListener(FarmEvent.SEED,this.__beginSeed);
      }
      
      public function dispose() : void
      {
         Mouse.show();
         this.removeEvent();
         ObjectUtils.disposeObject(this._seedButton);
         this._seedButton = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._water)
         {
            ObjectUtils.disposeObject(this._water);
         }
         this._water = null;
         if(this._water1)
         {
            ObjectUtils.disposeObject(this._water1);
         }
         this._water1 = null;
         if(this._waterwheel)
         {
            ObjectUtils.disposeObject(this._waterwheel);
         }
         this._waterwheel = null;
         if(this._float)
         {
            ObjectUtils.disposeObject(this._float);
         }
         this._float = null;
         if(this._pastureHouseBtn)
         {
            ObjectUtils.disposeObject(this._pastureHouseBtn);
         }
         this._pastureHouseBtn = null;
         if(this._fireflyMC1)
         {
            ObjectUtils.disposeObject(this._fireflyMC1);
         }
         this._fireflyMC1 = null;
         if(this._fireflyMC2)
         {
            ObjectUtils.disposeObject(this._fireflyMC2);
         }
         this._fireflyMC2 = null;
         if(this._fireflyMC3)
         {
            ObjectUtils.disposeObject(this._fireflyMC3);
         }
         this._fireflyMC3 = null;
         if(this._fieldView)
         {
            ObjectUtils.disposeObject(this._fieldView);
         }
         this._fieldView = null;
         if(this._hostNameBmp)
         {
            ObjectUtils.disposeObject(this._hostNameBmp);
         }
         this._hostNameBmp = null;
         if(this._farmName)
         {
            ObjectUtils.disposeObject(this._farmName);
         }
         this._farmName = null;
         ObjectUtils.disposeObject(this._seedView);
         this._seedView = null;
         ObjectUtils.disposeObject(this._pastureHitArea);
         this._pastureHitArea = null;
         this._seedVo = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
