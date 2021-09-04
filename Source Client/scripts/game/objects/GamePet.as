package game.objects
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoadResourceManager;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.FightBuffInfo;
   import ddt.display.BitmapLoaderProxy;
   import ddt.events.LivingEvent;
   import ddt.manager.PathManager;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PetSkillManager;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import game.actions.pet.CloseToMasterAction;
   import game.actions.pet.PetBlinkAction;
   import game.actions.pet.PetWalkAction;
   import game.model.Living;
   import game.model.PetLiving;
   import game.petAI.PetAI;
   import game.view.map.MapView;
   import pet.date.PetInfo;
   import pet.date.PetSkillInfo;
   import phy.maps.Map;
   import phy.object.PhysicsLayer;
   import phy.object.SmallObject;
   import road.game.resource.ActionMovieEvent;
   
   public class GamePet extends GameLiving
   {
       
      
      protected var _effectLoader:BaseLoader;
      
      protected var _advanceEffect:MovieClip;
      
      protected var _ai:PetAI;
      
      private var _master:GamePlayer;
      
      public var isDefence:Boolean;
      
      public function GamePet(param1:Living, param2:GamePlayer)
      {
         super(param1);
         this._master = param2;
         _testRect = new Rectangle(-3,3,6,3);
         _mass = 5;
         _gravityFactor = 50;
      }
      
      public function get petInfo() : PetInfo
      {
         return (_info as PetLiving).livingPetInfo;
      }
      
      protected function __onEffectComplete(param1:LoaderEvent) : void
      {
         var _loc3_:Class = null;
         this._effectLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onEffectComplete);
         this._effectLoader = null;
         var _loc2_:String = PetInfoManager.instance.getAdvanceEffectUrl(this.petInfo);
         if(ModuleLoader.hasDefinition("asset.game.pet." + _loc2_))
         {
            _loc3_ = ModuleLoader.getDefinition("asset.game.pet." + _loc2_) as Class;
            this._advanceEffect = new _loc3_();
            addChild(this._advanceEffect);
         }
      }
      
      public function get master() : GamePlayer
      {
         return this._master;
      }
      
      override protected function initListener() : void
      {
         super.initListener();
         _info.addEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
      }
      
      private function __usePetSkill(param1:LivingEvent) : void
      {
         var _loc2_:PetSkillInfo = null;
         if(param1.paras[0])
         {
            _loc2_ = PetSkillManager.instance.getSkillByID(param1.value);
            if(_loc2_ == null)
            {
               throw new Error("找不到技能，技能ID为：" + param1.value);
            }
            if(_loc2_.isActiveSkill)
            {
               _propArray.push(new BitmapLoaderProxy(PathManager.solveSkillPicUrl(_loc2_.Pic),new Rectangle(0,0,40,40)));
               doUseItemAnimation();
            }
         }
      }
      
      override protected function removeListener() : void
      {
         super.removeListener();
         _info.removeEventListener(LivingEvent.USE_PET_SKILL,this.__usePetSkill);
      }
      
      override protected function initView() : void
      {
         var _loc1_:String = null;
         var _loc2_:Class = null;
         super.initView();
         initMovie();
         if(_bloodStripBg && _bloodStripBg.parent)
         {
            _bloodStripBg.parent.removeChild(_bloodStripBg);
         }
         if(_HPStrip && _HPStrip.parent)
         {
            _HPStrip.parent.removeChild(_HPStrip);
         }
         _nickName.x += 20;
         _nickName.y -= 20;
         if(this.petInfo.OrderNumber >= 10)
         {
            _loc1_ = PetInfoManager.instance.getAdvanceEffectUrl(this.petInfo);
            if(ModuleLoader.hasDefinition("asset.game.pet." + _loc1_))
            {
               _loc2_ = ModuleLoader.getDefinition("asset.game.pet." + _loc1_) as Class;
               this._advanceEffect = new _loc2_();
               addChild(this._advanceEffect);
            }
            else
            {
               this._effectLoader = LoadResourceManager.instance.createLoader(PathManager.solvePetAdvanceEffect(_loc1_),BaseLoader.MODULE_LOADER);
               this._effectLoader.addEventListener(LoaderEvent.COMPLETE,this.__onEffectComplete);
               LoadResourceManager.instance.startLoad(this._effectLoader);
            }
         }
      }
      
      override public function get layer() : int
      {
         return PhysicsLayer.GameLiving;
      }
      
      override public function get smallView() : SmallObject
      {
         return null;
      }
      
      override protected function initSmallMapObject() : void
      {
      }
      
      override public function setMap(param1:Map) : void
      {
         super.setMap(param1);
         if(param1)
         {
            if(this._ai == null)
            {
               this._ai = new PetAI(this,MapView(param1));
            }
            __posChanged(null);
         }
      }
      
      override protected function __playEffect(param1:ActionMovieEvent) : void
      {
         if(param1.data)
         {
            if(ModuleLoader.hasDefinition("asset.game.skill.effect." + param1.data.effect))
            {
               this._master.showEffect("asset.game.skill.effect." + param1.data.effect);
            }
            else
            {
               this._master.showEffect(FightBuffInfo.DEFUALT_EFFECT);
            }
         }
      }
      
      override public function update(param1:Number) : void
      {
         super.update(param1);
         if(this._ai)
         {
            this._ai.excute();
         }
      }
      
      public function prepareForShow() : void
      {
         info.excuteAtOnce();
         info.direction = this._master.info.direction;
         this._ai.puased = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._effectLoader)
         {
            this._effectLoader.removeEventListener(LoaderEvent.COMPLETE,this.__onEffectComplete);
         }
         this._effectLoader = null;
         ObjectUtils.disposeObject(this._advanceEffect);
         this._advanceEffect = null;
         this._ai.dispose();
         this._ai = null;
         this._master = null;
      }
      
      public function endShow() : void
      {
         this._ai.puased = false;
      }
      
      public function blinkTo(param1:Point) : void
      {
         act(new PetBlinkAction(this,param1));
      }
      
      public function standby() : void
      {
         if(!this.isDefence)
         {
            doAction("standA");
         }
      }
      
      public function walkTo(param1:Point) : void
      {
         if(Math.abs(param1.x - pos.x) < stepX)
         {
            return;
         }
         act(new PetWalkAction(this,param1));
      }
      
      public function walkToRandom() : void
      {
         this.walkTo(this._ai.getRandomPoint());
      }
      
      public function colseToMaster() : void
      {
         if(PetLiving(info))
         {
            act(new CloseToMasterAction(this,PetLiving(info).master.pos));
         }
      }
   }
}
