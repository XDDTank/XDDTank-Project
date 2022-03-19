// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//pet.date.PetInfo

package pet.date
{
    import road7th.data.DictionaryData;
    import flash.events.Event;
    import ddt.manager.PlayerManager;
    import game.GameManager;
    import com.pickgliss.loader.ModuleLoader;
    import __AS3__.vec.Vector;
    import flash.utils.describeType;
    import __AS3__.vec.*;

    public class PetInfo extends PetTemplateInfo 
    {

        public static const HUNGER_CHANGED:String = "hunger";
        public static const GP_CHANGED:String = "gp";
        public static const SKILL_COUNT:int = 6;
        public static const FULL_MAX_VALUE:int = 10000;

        public var ID:int;
        public var UserID:int;
        private var _skills:DictionaryData;
        public var Bless:int;
        public var OrderNumber:int;
        public var Level:int;
        private var _gp:int;
        public var MaxGP:int;
        private var _hunger:int;
        public var MaxActiveSkillCount:int;
        public var MaxStaticSkillCount:int;
        public var MaxSkillCount:int;
        public var PaySkillCount:int;
        public var Place:int;
        public var FightPower:int = 100;
        public var ActivationPlace:int;
        public var MagicLevel:int;
        public var PetHappyStar:int;

        public function PetInfo()
        {
            this._skills = new DictionaryData();
        }

        public function set GP(_arg_1:int):void
        {
            if (this._gp == _arg_1)
            {
                return;
            };
            this._gp = _arg_1;
            dispatchEvent(new Event(GP_CHANGED));
        }

        public function get GP():int
        {
            return (this._gp);
        }

        public function set Hunger(_arg_1:int):void
        {
            if (_arg_1 == this._hunger)
            {
                return;
            };
            this._hunger = _arg_1;
            dispatchEvent(new Event(HUNGER_CHANGED));
        }

        public function get Hunger():int
        {
            return (this._hunger);
        }

        public function get IsEquip():Boolean
        {
            return (this.Place == 0);
        }

        public function get IsActive():Boolean
        {
            return ((this.Place > 0) && (this.Place < 5));
        }

        public function get skills():DictionaryData
        {
            return (this._skills);
        }

        public function addSkill(_arg_1:int, _arg_2:int):void
        {
            this._skills.add(_arg_1, _arg_2);
            if (PlayerManager.Instance.Self.ID == this.UserID)
            {
            };
        }

        public function clearSkills():void
        {
            this._skills.clear();
            if (PlayerManager.Instance.Self.ID == this.UserID)
            {
            };
        }

        public function removeSkillByID(_arg_1:int):void
        {
            this._skills.remove(_arg_1);
            if (PlayerManager.Instance.Self.ID == this.UserID)
            {
            };
        }

        public function hasSkill(_arg_1:int):Boolean
        {
            return (Boolean(this._skills[_arg_1]));
        }

        public function get actionMovieName():String
        {
            return ("pet.asset.game." + GameAssetUrl);
        }

        public function get assetReady():Boolean
        {
            return ((ModuleLoader.hasDefinition(this.actionMovieName)) || (GameManager.Instance.Current.selfGamePlayer.isBoss));
        }

        public function get fightSkills():Vector.<int>
        {
            var skillID:int;
            var list:Vector.<int> = new Vector.<int>();
            for each (skillID in this.skills)
            {
                if (((skillID > 0) && (skillID < 1000)))
                {
                    list.push(skillID);
                };
            };
            list.sort(function (_arg_1:int, _arg_2:int):Number
            {
                return ((_arg_1 < _arg_2) ? -1 : 1);
            });
            return (list);
        }

        public function equal(_arg_1:PetInfo):Boolean
        {
            var _local_3:XML;
            var _local_4:String;
            if ((!(_arg_1)))
            {
                return (false);
            };
            var _local_2:XML = describeType(this);
            for each (_local_3 in _local_2.variable)
            {
                _local_4 = _local_3.@name;
                if (((!(_local_4 == "Place")) && (!(this[_local_4] == _arg_1[_local_4]))))
                {
                    return (false);
                };
            };
            return (true);
        }


    }
}//package pet.date

