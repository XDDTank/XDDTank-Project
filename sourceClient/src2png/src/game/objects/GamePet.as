// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.objects.GamePet

package game.objects
{
    import com.pickgliss.loader.BaseLoader;
    import flash.display.MovieClip;
    import game.petAI.PetAI;
    import flash.geom.Rectangle;
    import game.model.Living;
    import game.model.PetLiving;
    import pet.date.PetInfo;
    import com.pickgliss.loader.LoaderEvent;
    import ddt.manager.PetInfoManager;
    import com.pickgliss.loader.ModuleLoader;
    import ddt.events.LivingEvent;
    import pet.date.PetSkillInfo;
    import ddt.manager.PetSkillManager;
    import ddt.display.BitmapLoaderProxy;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.LoadResourceManager;
    import phy.object.PhysicsLayer;
    import phy.object.SmallObject;
    import game.view.map.MapView;
    import phy.maps.Map;
    import ddt.data.FightBuffInfo;
    import road.game.resource.ActionMovieEvent;
    import com.pickgliss.utils.ObjectUtils;
    import game.actions.pet.PetBlinkAction;
    import flash.geom.Point;
    import game.actions.pet.PetWalkAction;
    import game.actions.pet.CloseToMasterAction;

    public class GamePet extends GameLiving 
    {

        protected var _effectLoader:BaseLoader;
        protected var _advanceEffect:MovieClip;
        protected var _ai:PetAI;
        private var _master:GamePlayer;
        public var isDefence:Boolean;

        public function GamePet(_arg_1:Living, _arg_2:GamePlayer)
        {
            super(_arg_1);
            this._master = _arg_2;
            _testRect = new Rectangle(-3, 3, 6, 3);
            _mass = 5;
            _gravityFactor = 50;
        }

        public function get petInfo():PetInfo
        {
            return ((_info as PetLiving).livingPetInfo);
        }

        protected function __onEffectComplete(_arg_1:LoaderEvent):void
        {
            var _local_3:Class;
            this._effectLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onEffectComplete);
            this._effectLoader = null;
            var _local_2:String = PetInfoManager.instance.getAdvanceEffectUrl(this.petInfo);
            if (ModuleLoader.hasDefinition(("asset.game.pet." + _local_2)))
            {
                _local_3 = (ModuleLoader.getDefinition(("asset.game.pet." + _local_2)) as Class);
                this._advanceEffect = new (_local_3)();
                addChild(this._advanceEffect);
            };
        }

        public function get master():GamePlayer
        {
            return (this._master);
        }

        override protected function initListener():void
        {
            super.initListener();
            _info.addEventListener(LivingEvent.USE_PET_SKILL, this.__usePetSkill);
        }

        private function __usePetSkill(_arg_1:LivingEvent):void
        {
            var _local_2:PetSkillInfo;
            if (_arg_1.paras[0])
            {
                _local_2 = PetSkillManager.instance.getSkillByID(_arg_1.value);
                if (_local_2 == null)
                {
                    throw (new Error(("找不到技能，技能ID为：" + _arg_1.value)));
                };
                if (_local_2.isActiveSkill)
                {
                    _propArray.push(new BitmapLoaderProxy(PathManager.solveSkillPicUrl(_local_2.Pic), new Rectangle(0, 0, 40, 40)));
                    doUseItemAnimation();
                };
            };
        }

        override protected function removeListener():void
        {
            super.removeListener();
            _info.removeEventListener(LivingEvent.USE_PET_SKILL, this.__usePetSkill);
        }

        override protected function initView():void
        {
            var _local_1:String;
            var _local_2:Class;
            super.initView();
            initMovie();
            if (((_bloodStripBg) && (_bloodStripBg.parent)))
            {
                _bloodStripBg.parent.removeChild(_bloodStripBg);
            };
            if (((_HPStrip) && (_HPStrip.parent)))
            {
                _HPStrip.parent.removeChild(_HPStrip);
            };
            _nickName.x = (_nickName.x + 20);
            _nickName.y = (_nickName.y - 20);
            if (this.petInfo.OrderNumber >= 10)
            {
                _local_1 = PetInfoManager.instance.getAdvanceEffectUrl(this.petInfo);
                if (ModuleLoader.hasDefinition(("asset.game.pet." + _local_1)))
                {
                    _local_2 = (ModuleLoader.getDefinition(("asset.game.pet." + _local_1)) as Class);
                    this._advanceEffect = new (_local_2)();
                    addChild(this._advanceEffect);
                }
                else
                {
                    this._effectLoader = LoadResourceManager.instance.createLoader(PathManager.solvePetAdvanceEffect(_local_1), BaseLoader.MODULE_LOADER);
                    this._effectLoader.addEventListener(LoaderEvent.COMPLETE, this.__onEffectComplete);
                    LoadResourceManager.instance.startLoad(this._effectLoader);
                };
            };
        }

        override public function get layer():int
        {
            return (PhysicsLayer.GameLiving);
        }

        override public function get smallView():SmallObject
        {
            return (null);
        }

        override protected function initSmallMapObject():void
        {
        }

        override public function setMap(_arg_1:Map):void
        {
            super.setMap(_arg_1);
            if (_arg_1)
            {
                if (this._ai == null)
                {
                    this._ai = new PetAI(this, MapView(_arg_1));
                };
                __posChanged(null);
            };
        }

        override protected function __playEffect(_arg_1:ActionMovieEvent):void
        {
            if (_arg_1.data)
            {
                if (ModuleLoader.hasDefinition(("asset.game.skill.effect." + _arg_1.data.effect)))
                {
                    this._master.showEffect(("asset.game.skill.effect." + _arg_1.data.effect));
                }
                else
                {
                    this._master.showEffect(FightBuffInfo.DEFUALT_EFFECT);
                };
            };
        }

        override public function update(_arg_1:Number):void
        {
            super.update(_arg_1);
            if (this._ai)
            {
                this._ai.excute();
            };
        }

        public function prepareForShow():void
        {
            info.excuteAtOnce();
            info.direction = this._master.info.direction;
            this._ai.puased = true;
        }

        override public function dispose():void
        {
            super.dispose();
            if (this._effectLoader)
            {
                this._effectLoader.removeEventListener(LoaderEvent.COMPLETE, this.__onEffectComplete);
            };
            this._effectLoader = null;
            ObjectUtils.disposeObject(this._advanceEffect);
            this._advanceEffect = null;
            this._ai.dispose();
            this._ai = null;
            this._master = null;
        }

        public function endShow():void
        {
            this._ai.puased = false;
        }

        public function blinkTo(_arg_1:Point):void
        {
            act(new PetBlinkAction(this, _arg_1));
        }

        public function standby():void
        {
            if ((!(this.isDefence)))
            {
                doAction("standA");
            };
        }

        public function walkTo(_arg_1:Point):void
        {
            if (Math.abs((_arg_1.x - pos.x)) < stepX)
            {
                return;
            };
            act(new PetWalkAction(this, _arg_1));
        }

        public function walkToRandom():void
        {
            this.walkTo(this._ai.getRandomPoint());
        }

        public function colseToMaster():void
        {
            if (PetLiving(info))
            {
                act(new CloseToMasterAction(this, PetLiving(info).master.pos));
            };
        }


    }
}//package game.objects

