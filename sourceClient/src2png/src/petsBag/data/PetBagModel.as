// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.data.PetBagModel

package petsBag.data
{
    import flash.events.EventDispatcher;
    import ddt.data.player.SelfInfo;
    import __AS3__.vec.Vector;
    import ddt.manager.PlayerManager;
    import ddt.data.goods.InventoryItemInfo;
    import ddt.data.PetExperienceManager;
    import pet.date.PetInfo;
    import ddt.manager.PetInfoManager;
    import __AS3__.vec.*;

    public class PetBagModel extends EventDispatcher 
    {

        public static const PET_BAG_START_INDEX:int = 10;

        private var _selfInfo:SelfInfo;
        private var _petsBagList:Array;
        public var petOpenLevel:int;
        public var PetMagicLevel1:int;
        public var PetMagicLevel2:int;
        public var AdvanceStoneTemplateId:int;
        public var petAddPropertyRate:Vector.<Number>;
        public var petAddLifeRate:Vector.<Number>;
        private var _spaceLevel:int = 1;

        public function PetBagModel()
        {
            this._selfInfo = PlayerManager.Instance.Self;
        }

        public function getAddProperty(_arg_1:int):Number
        {
            return (this.petAddPropertyRate[int((_arg_1 / 10))]);
        }

        public function getAddLife(_arg_1:int):Number
        {
            var _local_2:int = int(int((_arg_1 / 10)));
            if (((_local_2 < 0) || (_local_2 >= this.petAddLifeRate.length)))
            {
                return (0);
            };
            return (this.petAddLifeRate[int((_arg_1 / 10))]);
        }

        public function initPetPropertyRate(_arg_1:String):void
        {
            this.petAddPropertyRate = new Vector.<Number>();
            var _local_2:Array = _arg_1.split("|");
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3].length > 0)
                {
                    this.petAddPropertyRate.push(_local_2[_local_3]);
                };
                _local_3++;
            };
        }

        public function initPetLifeRate(_arg_1:String):void
        {
            this.petAddLifeRate = new Vector.<Number>();
            var _local_2:Array = _arg_1.split("|");
            var _local_3:int;
            while (_local_3 < _local_2.length)
            {
                if (_local_2[_local_3].length > 0)
                {
                    this.petAddLifeRate.push(_local_2[_local_3]);
                };
                _local_3++;
            };
        }

        public function getAdvanceStoneCount():int
        {
            var _local_3:InventoryItemInfo;
            var _local_1:Array = this.selfInfo.Bag.findItemsByTempleteID(this.AdvanceStoneTemplateId);
            var _local_2:int;
            for each (_local_3 in _local_1)
            {
                _local_2 = (_local_2 + _local_3.Count);
            };
            return (_local_2);
        }

        public function get spaceLevel():int
        {
            return (this._spaceLevel);
        }

        public function set spaceLevel(_arg_1:int):void
        {
            if (_arg_1 < 1)
            {
                this._spaceLevel = 1;
            }
            else
            {
                if (_arg_1 > PetExperienceManager.MAX_LEVEL)
                {
                    this._spaceLevel = PetExperienceManager.MAX_LEVEL;
                }
                else
                {
                    this._spaceLevel = _arg_1;
                };
            };
        }

        public function checkHasPet(_arg_1:int):Boolean
        {
            var _local_2:PetInfo;
            for each (_local_2 in this._selfInfo.pets)
            {
                if (PetInfoManager.instance.checkIsSamePetBase(_local_2.TemplateID, _arg_1))
                {
                    return (true);
                };
            };
            return (false);
        }

        public function get selfInfo():SelfInfo
        {
            return (this._selfInfo);
        }

        public function getPetInfoByID(_arg_1:int):PetInfo
        {
            var _local_2:PetInfo;
            for each (_local_2 in this._selfInfo.pets)
            {
                if (_local_2.ID == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function getpetListSorted():Vector.<PetInfo>
        {
            var petInfo:PetInfo;
            var result:Vector.<PetInfo> = new Vector.<PetInfo>();
            var i:int;
            for each (petInfo in this._selfInfo.pets)
            {
                result.push(petInfo);
            };
            result.sort(function (_arg_1:PetInfo, _arg_2:PetInfo):int
            {
                return ((_arg_1.ID > _arg_2.ID) ? 1 : -1);
            });
            return (result);
        }


    }
}//package petsBag.data

