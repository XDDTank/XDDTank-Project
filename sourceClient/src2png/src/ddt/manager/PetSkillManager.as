// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.PetSkillManager

package ddt.manager
{
    import flash.utils.Dictionary;
    import ddt.data.analyze.PetCommonSkillAnalyzer;
    import ddt.data.analyze.PetSkillInfoAnalyzer;
    import ddt.data.analyze.PetSkillTemplateInfoAnalyzer;
    import pet.date.PetSkillTemplateInfo;
    import pet.date.PetCommonSkill;
    import com.pickgliss.utils.ObjectUtils;
    import pet.date.PetSkillInfo;
    import pet.date.PetBaseSkillInfo;
    import pet.date.PetInfo;

    public class PetSkillManager 
    {

        private static var _instance:PetSkillManager;

        private var _commonSkillList:Dictionary;
        private var _infoList:Dictionary;
        private var _templateInfoList:Dictionary;
        private var _defaultSkillList:Dictionary;


        public static function get instance():PetSkillManager
        {
            return (_instance = ((_instance) || (new (PetSkillManager)())));
        }


        public function setupCommonSkillList(_arg_1:PetCommonSkillAnalyzer):void
        {
            this._commonSkillList = _arg_1.list;
        }

        public function setupInfoList(_arg_1:PetSkillInfoAnalyzer):void
        {
            this._infoList = _arg_1.list;
        }

        public function setupTemplatenfoList(_arg_1:PetSkillTemplateInfoAnalyzer):void
        {
            this._templateInfoList = _arg_1.list;
            this.initDefaultList();
        }

        private function initDefaultList():void
        {
            var _local_1:PetSkillTemplateInfo;
            this._defaultSkillList = new Dictionary();
            for each (_local_1 in this._templateInfoList)
            {
                if (_local_1.SkillLevel == 1)
                {
                    this._defaultSkillList[((_local_1.SkillPlace * 100) + _local_1.KindID)] = _local_1;
                };
            };
        }

        public function getCommonSkillByID(_arg_1:int):PetCommonSkill
        {
            var _local_3:PetCommonSkill;
            var _local_2:PetCommonSkill = this._commonSkillList[_arg_1];
            if (_local_2)
            {
                _local_3 = new PetCommonSkill();
                ObjectUtils.copyProperties(_local_3, _local_2);
                return (_local_3);
            };
            return (null);
        }

        public function getSkillBaseInfo(_arg_1:int):PetBaseSkillInfo
        {
            var _local_3:PetSkillInfo;
            var _local_4:PetCommonSkill;
            var _local_2:PetBaseSkillInfo = new PetBaseSkillInfo();
            if (_arg_1 < 1000)
            {
                _local_3 = this.getSkillByID(_arg_1);
                _local_2.SkillID = _local_3.ID;
                _local_2.Name = _local_3.Name;
                _local_2.Decription = _local_3.Description;
                _local_2.Pic = _local_3.Pic;
            }
            else
            {
                _local_4 = this.getCommonSkillByID(_arg_1);
                _local_2.SkillID = _local_4.SkillID;
                _local_2.Name = _local_4.Name;
                _local_2.Decription = _local_4.SkillLable;
                _local_2.Pic = _local_4.Pic;
            };
            return (_local_2);
        }

        public function getSkillByID(_arg_1:int):PetSkillInfo
        {
            var _local_3:PetSkillInfo;
            var _local_2:PetSkillInfo = this._infoList[_arg_1];
            if (_local_2)
            {
                _local_3 = new PetSkillInfo();
                ObjectUtils.copyProperties(_local_3, _local_2);
                return (_local_3);
            };
            return (null);
        }

        public function getTemplateInfoByID(_arg_1:int):PetSkillTemplateInfo
        {
            var _local_3:PetSkillTemplateInfo;
            var _local_2:PetSkillTemplateInfo = this._templateInfoList[_arg_1];
            if (_local_2)
            {
                _local_3 = new PetSkillTemplateInfo();
                ObjectUtils.copyProperties(_local_3, _local_2);
                return (_local_3);
            };
            return (null);
        }

        public function getPreSkill(_arg_1:PetSkillTemplateInfo):Dictionary
        {
            var _local_6:Array;
            var _local_7:Array;
            var _local_8:String;
            var _local_2:Dictionary = new Dictionary();
            var _local_3:int = _arg_1.SkillID;
            if (_local_3 < 1000)
            {
                _local_2["name"] = this.getSkillByID(_local_3).Name;
            }
            else
            {
                _local_2["name"] = this.getCommonSkillByID(_local_3).Name;
            };
            var _local_4:PetSkillTemplateInfo = this.getTemplateInfoByID(_local_3);
            var _local_5:PetSkillTemplateInfo = this.getTemplateInfoByID(_local_4.NextSkillId);
            _local_6 = _local_4.BeforeSkillId.split(",");
            _local_7 = [];
            for each (_local_8 in _local_6)
            {
                _local_3 = int(_local_8);
                if (_local_3 < 0)
                {
                    _local_7.push("都可以");
                }
                else
                {
                    if (_local_3 > 0)
                    {
                        _local_7.push(this.getSkillBaseInfo(_local_3));
                    };
                };
            };
            _local_2["c"] = _local_7;
            _local_6 = _local_5.BeforeSkillId.split(",");
            _local_7 = [];
            for each (_local_8 in _local_6)
            {
                _local_3 = int(_local_8);
                if (_local_3 < 0)
                {
                    _local_7.push("都可以");
                }
                else
                {
                    if (_local_3 > 0)
                    {
                        _local_7.push(this.getSkillBaseInfo(_local_3));
                    };
                };
            };
            _local_2["n"] = _local_7;
            return (_local_2);
        }

        public function checkCanUpgrade(_arg_1:int, _arg_2:PetInfo):Boolean
        {
            var _local_3:PetSkillTemplateInfo = this.getTemplateInfoByID(_arg_1);
            if ((!(_local_3)))
            {
                return (false);
            };
            var _local_4:PetSkillTemplateInfo = this.getTemplateInfoByID(_local_3.NextSkillId);
            if ((!(_local_4)))
            {
                return (false);
            };
            var _local_5:PetSkillTemplateInfo = ((_arg_2.skills[_local_3.SkillPlace]) ? _local_4 : _local_3);
            if (_local_5.MinLevel > _arg_2.Level)
            {
                return (false);
            };
            if (_local_5.SkillLevel > _local_5.SkillMaxLevel)
            {
                return (false);
            };
            if (_local_5.MagicSoul > PlayerManager.Instance.Self.magicSoul)
            {
                return (false);
            };
            return (this.checkBeforeSkill(_local_5, _arg_2));
        }

        public function checkBeforeSkill(_arg_1:PetSkillTemplateInfo, _arg_2:PetInfo):Boolean
        {
            var _local_3:Boolean;
            var _local_5:int;
            var _local_4:Array = _arg_1.BeforeSkillId.split(",");
            if (_local_4[0] != -1)
            {
                for each (_local_5 in _arg_2.skills)
                {
                    if (_local_4.indexOf(String(_local_5)) != -1)
                    {
                        _local_3 = true;
                        break;
                    };
                };
            }
            else
            {
                return (_local_3 = true);
            };
            return (_local_3);
        }

        public function getSkillID(_arg_1:int, _arg_2:int):int
        {
            var _local_3:PetSkillInfo;
            var _local_4:PetSkillTemplateInfo = this._defaultSkillList[((_arg_1 * 100) + _arg_2)];
            if (_local_4)
            {
                return (_local_4.SkillID);
            };
            return (-1);
        }


    }
}//package ddt.manager

