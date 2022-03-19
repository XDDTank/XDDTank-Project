// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.model.Pet

package game.model
{
    import flash.events.EventDispatcher;
    import pet.date.PetInfo;
    import flash.utils.Dictionary;
    import ddt.events.LivingEvent;

    public class Pet extends EventDispatcher 
    {

        private var _MP:int;
        private var _maxMP:int;
        private var _petInfo:PetInfo;
        private var _petBeatInfo:Dictionary = new Dictionary();

        public function Pet(_arg_1:PetInfo)
        {
            this._petInfo = _arg_1;
        }

        public function get petInfo():PetInfo
        {
            return (this._petInfo);
        }

        public function get MP():int
        {
            return (this._MP);
        }

        public function set MP(_arg_1:int):void
        {
            if (_arg_1 == this._MP)
            {
                return;
            };
            this._MP = _arg_1;
            dispatchEvent(new LivingEvent(LivingEvent.PET_MP_CHANGE));
        }

        public function get MaxMP():int
        {
            return (this._maxMP);
        }

        public function set MaxMP(_arg_1:int):void
        {
            this._maxMP = _arg_1;
        }

        public function get equipedSkillIDs():Array
        {
            return (this._petInfo.skills.list);
        }

        public function useSkill(_arg_1:int, _arg_2:Boolean):void
        {
            dispatchEvent(new LivingEvent(LivingEvent.USE_PET_SKILL, _arg_1));
        }

        public function get petBeatInfo():Dictionary
        {
            return (this._petBeatInfo);
        }


    }
}//package game.model

