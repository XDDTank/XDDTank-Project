package farm.view
{
   import bagAndInfo.cell.DragEffect;
   import baglocked.BaglockedManager;
   import com.greensock.TweenLite;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.DisplayLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.TimeEvents;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.TimeManager;
   import farm.event.FarmEvent;
   import farm.model.FieldVO;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class FarmFieldBlock extends Sprite implements Disposeable, IAcceptDrag, ITipedDisplay
   {
       
      
      private var _fieldId:int;
      
      private var _loadEnd:Function;
      
      private var _loadCount:int = 1;
      
      private var _gainPic:MovieClip;
      
      private var _info:FieldVO;
      
      private var _picPath:String;
      
      private var _field:ScaleFrameImage;
      
      private var _loader:DisplayLoader;
      
      private var _plant:BaseButton;
      
      private var _isDig:Boolean;
      
      private var _lightFilter:Array;
      
      private var _handlerMc:MovieClip;
      
      public var _gainPlant:MovieClip;
      
      private var _isPlaying:Boolean;
      
      private var _plantMovie:MovieClip;
      
      private var _plantTimeShow:Bitmap;
      
      private var _plantTimeCount:FilterFrameText;
      
      private var _playCount:int = 0;
      
      protected var _tipData:Object;
      
      protected var _tipDirction:String;
      
      protected var _tipGapV:int;
      
      protected var _tipGapH:int;
      
      protected var _tipStyle:String;
      
      private var _tipDirctions:String;
      
      public function FarmFieldBlock(param1:int)
      {
         super();
         this._fieldId = param1;
         this.initView();
         this.initEvent();
      }
      
      public function get fieldId() : int
      {
         return this._fieldId;
      }
      
      public function set fieldId(param1:int) : void
      {
         this._fieldId = param1;
      }
      
      public function get plantMovie() : MovieClip
      {
         return this._plantMovie;
      }
      
      public function get info() : FieldVO
      {
         return this._info;
      }
      
      public function set info(param1:FieldVO) : void
      {
         ShowTipManager.Instance.removeTip(this);
         this._info = param1;
         buttonMode = param1 && param1.isDig;
         this.releaseMc();
         if(this._info)
         {
            this.isDig = true;
            if(this._info.seedID != 0)
            {
               this.upTips();
            }
         }
         else
         {
            this.isDig = false;
         }
         this.showPlant();
      }
      
      private function loadPic(param1:String, param2:Function) : void
      {
         if(this._loader)
         {
            this._loadEnd = null;
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         }
         this._loadEnd = param2;
         this._loader = LoadResourceManager.instance.createLoader(PathManager.solveFieldPlantPath(param1,FieldVO.GAIN_TIME),BaseLoader.MODULE_LOADER);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__complete);
         LoadResourceManager.instance.startLoad(this._loader);
      }
      
      protected function __complete(param1:LoaderEvent) : void
      {
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         if(this._loadEnd != null)
         {
            this._loadEnd();
         }
      }
      
      public function addGainMovice() : void
      {
         this._gainPlant = ComponentFactory.Instance.creat("farm.adoptView.gainPlant");
         addChild(this._gainPlant);
         this._gainPlant.visible = false;
         this._gainPlant.addEventListener(Event.ENTER_FRAME,this._gainPlayStop);
      }
      
      public function upTips() : void
      {
         var _loc1_:String = null;
         if(this._info && this._info.seedID != 0)
         {
            _loc1_ = this._info.seed.Name;
            this.tipData = LanguageMgr.GetTranslation("ddt.farm.goods.name",_loc1_);
            this.tipGapV = -270;
            this.tipGapH = -150;
            ShowTipManager.Instance.addTip(this);
         }
         else
         {
            this.tipData = null;
         }
      }
      
      private function initView() : void
      {
         this._field = ComponentFactory.Instance.creatComponentByStylename("farm.fieldbg");
         addChild(this._field);
         this._field.buttonMode = true;
         this._plant = ComponentFactory.Instance.creatComponentByStylename("farm.plant");
         addChild(this._plant);
         this._lightFilter = ComponentFactory.Instance.creatFilters("lightFilter");
         this.tipStyle = "ddt.view.tips.OneLineTip";
         this.tipDirctions = "1,2,3";
         this.tipGapH = -60;
         this._gainPlant = ComponentFactory.Instance.creat("farm.adoptView.gainPlant");
         addChild(this._gainPlant);
         this._gainPlant.visible = false;
         this._plantTimeShow = ComponentFactory.Instance.creatBitmap("asset.field.plantTimeCount");
         this._plantTimeCount = ComponentFactory.Instance.creatComponentByStylename("farm.plantTimeTxt");
         addChild(this._plantTimeShow);
         addChild(this._plantTimeCount);
         this._plantTimeShow.visible = false;
         this._plantTimeCount.visible = false;
      }
      
      private function initEvent() : void
      {
         this._gainPlant.addEventListener(Event.ENTER_FRAME,this._gainPlayStop);
      }
      
      private function _gainPlayStop(param1:Event) : void
      {
         if(this._gainPlant.currentFrame == this._gainPlant.totalFrames && this._gainPlant.visible)
         {
            this._gainPlant.removeEventListener(Event.ENTER_FRAME,this._gainPlayStop);
            if(this._gainPlant)
            {
               ObjectUtils.disposeObject(this._gainPlant);
            }
            this._gainPlant = null;
         }
      }
      
      private function removeEvent() : void
      {
         this._playCount = 0;
         if(this._plantMovie)
         {
            this._plantMovie.removeEventListener(Event.ENTER_FRAME,this.__onMovieStop);
         }
         if(this._gainPlant)
         {
            this._gainPlant.removeEventListener(Event.ENTER_FRAME,this._gainPlayStop);
         }
         TimeManager.removeEventListener(TimeEvents.SECONDS,this._upPlantTime);
      }
      
      private function releaseMc() : void
      {
         if(this._handlerMc)
         {
            this._handlerMc.removeEventListener(Event.COMPLETE,this.__completeHandler);
         }
         ObjectUtils.disposeObject(this._handlerMc);
         this._handlerMc = null;
      }
      
      public function showPlant() : void
      {
         var _loc1_:Class = null;
         this.releaseMc();
         if(this._info && this._info.seedID != 0)
         {
            if(ModuleLoader.hasDefinition("asset.farm.crops." + this._info.seed.Pic))
            {
               this._isPlaying = false;
               this.releaseMc();
               _loc1_ = ModuleLoader.getDefinition("asset.farm.crops." + this._info.seed.Pic) as Class;
               this._gainPic = new _loc1_();
               this._gainPic.mouseEnabled = false;
               this._plant.backgound = this._gainPic;
               this._plant.visible = true;
               this._plant.alpha = 1;
               this._plantMovie = this._plant.backgound as MovieClip;
               if(this._info.restSecondTime <= 0)
               {
                  if(this._plantMovie.currentFrame != 2)
                  {
                     this._plantMovie.gotoAndStop(2);
                     return;
                  }
               }
               if(this._info.restSecondTime > 0 && this._info.restSecondTime <= this._info.gainTime * 60 - 4)
               {
                  this._plantMovie["chengzhan"].gotoAndStop("chengzhang");
               }
               this._plantMovie.addEventListener(Event.ENTER_FRAME,this.__onMovieStop);
            }
            else if(this._loadCount <= 3)
            {
               this.loadPic(this._info.seed.Pic,this.showSeed);
               ++this._loadCount;
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.loader.LoadingPlainInfoFailure"));
            }
         }
         else if(this._plant.visible == true || this._plant.backgound)
         {
            TweenLite.to(this._plant,1,{"alpha":0});
            this._plant.mouseEnabled = false;
         }
      }
      
      public function showSeed() : void
      {
         this.showPlant();
      }
      
      private function addPlantCount() : void
      {
         this._playCount = 0;
         if(this._plantMovie)
         {
            this._plantMovie.removeEventListener(Event.ENTER_FRAME,this.__onMovieStop);
         }
         if(this._plantTimeShow)
         {
            this._plantTimeShow.visible = true;
         }
         if(this._plantTimeCount)
         {
            this._plantTimeCount.visible = true;
         }
         if(this._plantMovie)
         {
            TimeManager.addEventListener(TimeEvents.SECONDS,this._upPlantTime);
         }
      }
      
      private function __onMovieStop(param1:Event) : void
      {
         ++this._playCount;
         if(this._playCount > 45)
         {
            this.addPlantCount();
         }
      }
      
      private function _upPlantTime(param1:TimeEvents) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(!this._info)
         {
            TimeManager.removeEventListener(TimeEvents.SECONDS,this._upPlantTime);
            return;
         }
         if(this._info.restSecondTime <= 0)
         {
            TimeManager.removeEventListener(TimeEvents.SECONDS,this._upPlantTime);
            this._plantTimeShow.visible = false;
            this._plantTimeCount.visible = false;
            this._plantTimeCount.text = "";
            return;
         }
         if(this.info.restTime / 60 < 10)
         {
            _loc2_ = "0" + String(int(this.info.restTime / 60));
         }
         else
         {
            _loc2_ = String(int(this.info.restTime / 60));
         }
         if(this._info.restTime % 60 < 10)
         {
            _loc3_ = ":0" + String(this.info.restTime % 60);
         }
         else
         {
            _loc3_ = ":" + String(this.info.restTime % 60);
         }
         if(this._info.restSecondTime % 60 < 10)
         {
            _loc4_ = ":0" + String(this.info.restSecondTime % 60);
         }
         else
         {
            _loc4_ = ":" + String(this.info.restSecondTime % 60);
         }
         this._plantTimeCount.text = _loc2_ + _loc3_ + _loc4_;
      }
      
      private function showField() : void
      {
         if(this._info && this._info.seedID != 0)
         {
            this._plant.visible = true;
            this._plant.alpha = 1;
         }
         else
         {
            TweenLite.to(this._plant,0.5,{
               "alpha":0,
               "visible":0
            });
         }
      }
      
      public function showGain() : void
      {
         this.showPlant();
      }
      
      private function seeding(param1:DisplayObject) : void
      {
         param1.scaleX = 0;
         param1.scaleY = 0;
         param1.alpha = 0;
         TweenLite.to(param1,1.5,{
            "scaleX":1,
            "scaleY":1,
            "alpha":1
         });
         this._handlerMc = ComponentFactory.Instance.creat("farm.field.seedMc");
         addChild(this._handlerMc);
         this._handlerMc.addEventListener(Event.COMPLETE,this.__completeHandler);
      }
      
      protected function __completeHandler(param1:Event) : void
      {
         this.releaseMc();
         this._isPlaying = false;
         this.showField();
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         var _loc3_:FieldVO = new FieldVO();
         _loc3_.seedID = _loc2_.TemplateID;
         _loc3_.fieldID = this._info.fieldID;
         if(this._info && this._info.seedID == 0 && this._isDig && _loc2_.CategoryID == EquipType.SEED && _loc2_.Count > 0)
         {
            dispatchEvent(new FarmEvent(FarmEvent.SEED,_loc3_));
            DragManager.acceptDrag(this);
         }
      }
      
      public function dispose() : void
      {
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__complete);
         }
         this._loader = null;
         this.removeEvent();
         ShowTipManager.Instance.removeTip(this);
         this.releaseMc();
         this._gainPic = null;
         this._info = null;
         if(this._plantTimeShow)
         {
            ObjectUtils.disposeObject(this._plantTimeShow);
         }
         this._plantTimeShow = null;
         if(this._plantTimeCount)
         {
            ObjectUtils.disposeObject(this._plantTimeCount);
         }
         this._plantTimeCount = null;
         if(this._plant)
         {
            ObjectUtils.disposeObject(this._plant);
         }
         this._plant = null;
         ObjectUtils.disposeObject(this._gainPic);
         this._gainPic = null;
         if(this._field)
         {
            ObjectUtils.disposeObject(this._field);
         }
         this._field = null;
         if(this._gainPlant)
         {
            ObjectUtils.disposeObject(this._gainPlant);
         }
         this._gainPlant = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function set isDig(param1:Boolean) : void
      {
         this._isDig = param1;
         this._field.setFrame(!!this._isDig ? int(1) : int(2));
      }
      
      public function get isDig() : Boolean
      {
         return this._isDig;
      }
      
      public function set showLight(param1:Boolean) : void
      {
         filters = param1 && this._isDig ? this._lightFilter : null;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function get tipData() : Object
      {
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
   }
}
