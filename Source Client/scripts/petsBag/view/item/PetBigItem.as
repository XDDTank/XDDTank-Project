package petsBag.view.item
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.manager.PathManager;
   import ddt.manager.PetBagManager;
   import ddt.manager.PetInfoManager;
   import ddt.utils.Helpers;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getTimer;
   import pet.date.PetInfo;
   import road.game.resource.ActionMovie;
   import road.game.resource.ActionMovieEvent;
   
   public class PetBigItem extends PetBaseItem
   {
       
      
      protected var _bg:DisplayObject;
      
      protected var _movieContainer:Sprite;
      
      protected var _petMovie:ActionMovie;
      
      protected var ACTIONS:Array;
      
      protected var _petIcon:BitmapLoaderProxy;
      
      protected var _locked:Boolean;
      
      protected var _loader:BaseLoader;
      
      protected var _effectLoader:BaseLoader;
      
      protected var _advanceEffect:MovieClip;
      
      private var _dragImg:Bitmap;
      
      protected var _lastTime:uint = 0;
      
      public function PetBigItem(param1:DisplayObject = null)
      {
         this.ACTIONS = ["standA","walkA","walkB"];
         this._bg = Boolean(param1) ? param1 : this.getDefaultBg();
         super();
         this.initTips();
      }
      
      override public function set info(param1:PetInfo) : void
      {
         var _loc2_:Class = null;
         var _loc3_:String = null;
         var _loc4_:Class = null;
         super.info = param1;
         tipData = param1;
         if(_info)
         {
            if(!_info || !_lastInfo || _info.TemplateID != _lastInfo.TemplateID)
            {
               if(this._loader)
               {
                  this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
               }
               if(this._petMovie)
               {
                  this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END,this.doNextAction);
                  this._petMovie.dispose();
                  this._petMovie = null;
               }
               if(ModuleLoader.hasDefinition("pet.asset.game." + param1.GameAssetUrl))
               {
                  _loc2_ = ModuleLoader.getDefinition("pet.asset.game." + param1.GameAssetUrl) as Class;
                  this._petMovie = new _loc2_();
                  this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
                  this._petMovie.addEventListener(ActionMovieEvent.ACTION_END,this.doNextAction);
                  this._petMovie.visible = !this._locked;
                  this._movieContainer.addChild(this._petMovie);
               }
               else
               {
                  this._loader = LoadResourceManager.instance.createLoader(PathManager.solvePetGameAssetUrl(param1.GameAssetUrl),BaseLoader.MODULE_LOADER);
                  this._loader.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
                  LoadResourceManager.instance.startLoad(this._loader);
               }
               ObjectUtils.disposeObject(this._petIcon);
               this._petIcon = new BitmapLoaderProxy(PathManager.solvePetIconUrl(PetBagManager.instance().getPicStr(_info)),null,true);
            }
            if(!_info || !_lastInfo || int(_info.OrderNumber / 10) != int(_lastInfo.OrderNumber / 10))
            {
               _loc3_ = PetInfoManager.instance.getAdvanceEffectUrl(param1);
               if(this._advanceEffect)
               {
                  ObjectUtils.disposeObject(this._advanceEffect);
               }
               if(_info.OrderNumber >= 10)
               {
                  if(ModuleLoader.hasDefinition("asset.game.pet." + _loc3_))
                  {
                     _loc4_ = ModuleLoader.getDefinition("asset.game.pet." + _loc3_) as Class;
                     this._advanceEffect = new _loc4_();
                     addChild(this._advanceEffect);
                  }
                  else
                  {
                     if(this._effectLoader)
                     {
                        this._effectLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onEffectComplete);
                     }
                     this._effectLoader = LoadResourceManager.instance.createLoader(PathManager.solvePetAdvanceEffect(_loc3_),BaseLoader.MODULE_LOADER);
                     this._effectLoader.addEventListener(LoaderEvent.COMPLETE,this.__onEffectComplete);
                     LoadResourceManager.instance.startLoad(this._effectLoader);
                  }
               }
            }
         }
         else
         {
            ObjectUtils.disposeObject(this._petIcon);
            this._petIcon = null;
            if(this._petMovie)
            {
               this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END,this.doNextAction);
               this._petMovie.dispose();
               this._petMovie = null;
            }
            if(this._loader)
            {
               this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
               this._loader = null;
            }
            if(this._advanceEffect)
            {
               ObjectUtils.disposeObject(this._advanceEffect);
               this._advanceEffect = null;
            }
            if(this._effectLoader)
            {
               this._effectLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onEffectComplete);
               this._effectLoader = null;
            }
            ObjectUtils.disposeObject(this._petIcon);
            this._petIcon = null;
         }
      }
      
      protected function initTips() : void
      {
         tipStyle = "ddt.view.tips.PetInfoTip";
         tipDirctions = "5,2,7,1,6,4";
         ShowTipManager.Instance.addTip(this);
      }
      
      override public function get height() : Number
      {
         return this._bg.height;
      }
      
      override public function get width() : Number
      {
         return this._bg.width;
      }
      
      override protected function initView() : void
      {
         addChild(this._bg);
         this._movieContainer = new Sprite();
         addChild(this._movieContainer);
      }
      
      private function getDefaultBg() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(-30,-50,60,60);
         return _loc1_;
      }
      
      private function __onComplete(param1:LoaderEvent) : void
      {
         var _loc2_:Class = null;
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         if(ModuleLoader.hasDefinition("pet.asset.game." + _info.GameAssetUrl))
         {
            _loc2_ = ModuleLoader.getDefinition("pet.asset.game." + _info.GameAssetUrl) as Class;
            this._petMovie = new _loc2_();
            this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
            this._petMovie.addEventListener(ActionMovieEvent.ACTION_END,this.doNextAction);
            this._petMovie.visible = !this._locked;
            this._movieContainer.addChild(this._petMovie);
         }
      }
      
      private function __onEffectComplete(param1:LoaderEvent) : void
      {
         var _loc3_:Class = null;
         this._effectLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onEffectComplete);
         if(!_info)
         {
            return;
         }
         var _loc2_:String = PetInfoManager.instance.getAdvanceEffectUrl(_info);
         if(ModuleLoader.hasDefinition("asset.game.pet." + _loc2_))
         {
            _loc3_ = ModuleLoader.getDefinition("asset.game.pet." + _loc2_) as Class;
            this._advanceEffect = new _loc3_();
            addChild(this._advanceEffect);
         }
      }
      
      private function doNextAction(param1:ActionMovieEvent) : void
      {
         if(this._petMovie)
         {
            if(getTimer() - this._lastTime > 40)
            {
               this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
            }
            this._lastTime = getTimer();
         }
      }
      
      override public function dispose() : void
      {
         ShowTipManager.Instance.removeTip(this);
         super.dispose();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         if(this._petMovie)
         {
            this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END,this.doNextAction);
         }
         ObjectUtils.disposeObject(this._petMovie);
         this._petMovie = null;
         ObjectUtils.disposeObject(this._movieContainer);
         this._movieContainer = null;
         _info = null;
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         }
         this._loader = null;
         if(this._effectLoader)
         {
            this._effectLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onEffectComplete);
         }
         this._effectLoader = null;
         ObjectUtils.disposeObject(this._advanceEffect);
         this._advanceEffect = null;
         ObjectUtils.disposeObject(this._petIcon);
         this._petIcon = null;
         ObjectUtils.disposeObject(this._dragImg);
         this._dragImg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      override public function set locked(param1:Boolean) : void
      {
         super.locked = param1;
      }
      
      override protected function createDragImg() : DisplayObject
      {
         ObjectUtils.disposeObject(this._dragImg);
         this._dragImg = null;
         if(this._petIcon && this._petIcon.width > 0 && this._petIcon.height > 0)
         {
            this._dragImg = new Bitmap(new BitmapData(this._petIcon.width / this._petIcon.scaleX,this._petIcon.height / this._petIcon.scaleY,true,0));
            this._dragImg.bitmapData.draw(this._petIcon);
         }
         return this._dragImg;
      }
   }
}
