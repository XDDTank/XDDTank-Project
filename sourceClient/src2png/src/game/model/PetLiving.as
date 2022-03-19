// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.PetLiving

package game.model
{
    import pet.date.PetInfo;
    import com.pickgliss.utils.StringUtils;
    import com.pickgliss.loader.ModuleLoader;
    import ddt.events.LivingEvent;
    import ddt.manager.PetSkillManager;
    import pet.date.PetSkillInfo;

    public class PetLiving extends Living 
    {

        private var _petinfo:PetInfo;
        private var _master:Player;
        private var _usedSkill:Array;
        private var _mp:int;
        private var _maxMp:int;

        public function PetLiving(_arg_1:PetInfo, _arg_2:Player, _arg_3:int, _arg_4:int, _arg_5:int)
        {
            super(-1, _arg_4, _arg_5);
            this._petinfo = _arg_1;
            this._master = _arg_2;
            this._mp = 0;
            this._usedSkill = [];
        }

        public function get skills():Array
        {
            return (this._petinfo.skills.list);
        }

        public function get equipedSkillIDs():Array
        {
            return (this._petinfo.skills.list);
        }

        public function get master():Player
        {
            return (this._master);
        }

        override public function get name():String
        {
            return (this._petinfo.Name);
        }

        override public function get actionMovieName():String
        {
            return ("pet.asset.game." + StringUtils.trim(this._petinfo.GameAssetUrl));
        }

        public function get assetUrl():String
        {
            return (StringUtils.trim(this._petinfo.GameAssetUrl));
        }

        public function get assetReady():Boolean
        {
            return (ModuleLoader.hasDefinition(this.actionMovieName));
        }

        public function get MP():int
        {
            return (this._mp);
        }

        public function set MP(_arg_1:int):void
        {
            if (this._mp == _arg_1)
            {
                return;
            };
            this._mp = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.PET_MP_CHANGE));
        }

        public function set MaxMP(_arg_1:int):void
        {
            this._maxMp = _arg_1;
        }

        public function get MaxMP():int
        {
            return (this._maxMp);
        }

        public function get livingPetInfo():PetInfo
        {
            return (this._petinfo);
        }

        public function useSkill(_arg_1:int, _arg_2:Boolean):void
        {
            var _local_3:PetSkillInfo = PetSkillManager.instance.getSkillByID(_arg_1);
            if (((_local_3) && (_arg_2)))
            {
                this.MP = (this.MP - _local_3.CostMP);
            };
            dispatchEvent(new LivingEvent(LivingEvent.USE_PET_SKILL, _arg_1, 0, _arg_2));
        }


    }
}//package game.model

