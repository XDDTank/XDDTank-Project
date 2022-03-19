// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.MapManager

package ddt.manager
{
    import flash.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import ddt.data.map.MapInfo;
    import ddt.data.map.OpenMapInfo;
    import ddt.data.map.DungeonInfo;
    import ddt.data.analyze.MapAnalyzer;
    import ddt.data.analyze.DungeonAnalyzer;
    import ddt.data.analyze.WeekOpenMapAnalyze;
    import __AS3__.vec.*;

    public class MapManager extends EventDispatcher 
    {

        public static const PVP_TRAIN_MAP:int = 1;
        public static const PVP_COMPECTI_MAP:int = 0;
        public static const PVE_EXPROL_MAP:int = 2;
        public static const PVE_BOSS_MAP:int = 3;
        public static const PVE_LINK_MAP:int = 4;
        public static const FIGHT_LIB:int = 5;
        public static const PVE_ACADEMY_MAP:int = 6;
        public static const PVE_CHANGE_MAP:int = 7;
        public static const PVE_MULTISHOOT:int = 20;
        public static const PVE_MAP:int = 5;
        public static const PVP_MAP:int = 6;
        private static var _list:Vector.<MapInfo>;
        private static var _openList:Vector.<OpenMapInfo>;
        private static var _radomMapInfo:MapInfo;
        private static var _defaultDungeon:DungeonInfo;
        private static var _pveList:Vector.<DungeonInfo>;
        private static var _pvpList:Vector.<MapInfo>;
        private static var _pveLinkList:Array;
        private static var _pveBossList:Vector.<DungeonInfo>;
        private static var _pveExplrolList:Vector.<DungeonInfo>;
        private static var _pvpComplectiList:Vector.<MapInfo>;
        private static var _fightLibList:Vector.<DungeonInfo>;
        private static var _pveAcademyList:Vector.<DungeonInfo>;
        private static var _pveSpecialList:Vector.<DungeonInfo>;
        private static var _pveMapCount:int;

        public function MapManager():void
        {
        }

        public static function getListByType(_arg_1:int=0):*
        {
            if (_arg_1 == PVP_TRAIN_MAP)
            {
                return (_list);
            };
            if (_arg_1 == PVE_MAP)
            {
                return (_pveList);
            };
            if (_arg_1 == PVE_LINK_MAP)
            {
                return (_pveLinkList);
            };
            if (_arg_1 == PVE_BOSS_MAP)
            {
                return (_pveBossList);
            };
            if (_arg_1 == PVE_EXPROL_MAP)
            {
                return (_pveExplrolList);
            };
            if (_arg_1 == PVP_COMPECTI_MAP)
            {
                return (_pvpComplectiList);
            };
            if (_arg_1 == PVP_MAP)
            {
                return (_pvpList);
            };
            if (_arg_1 == FIGHT_LIB)
            {
                return (_fightLibList);
            };
            if (_arg_1 == PVE_ACADEMY_MAP)
            {
                return (_pveAcademyList);
            };
            if (_arg_1 == PVE_CHANGE_MAP)
            {
                return (_pveSpecialList);
            };
            if (_arg_1 == PVE_MULTISHOOT)
            {
                return (_pveSpecialList);
            };
            return (null);
        }

        public static function setup():void
        {
        }

        public static function setupMapInfo(_arg_1:MapAnalyzer):void
        {
            _radomMapInfo = new MapInfo();
            _radomMapInfo.ID = 0;
            _radomMapInfo.isOpen = true;
            _radomMapInfo.canSelect = true;
            _radomMapInfo.Name = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
            _radomMapInfo.Description = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
            _list = _arg_1.list;
            _pvpList = _list.slice();
            _radomMapInfo = new MapInfo();
            _radomMapInfo.ID = 0;
            _radomMapInfo.isOpen = true;
            _radomMapInfo.canSelect = true;
            _radomMapInfo.Name = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
            _radomMapInfo.Description = LanguageMgr.GetTranslation("tank.manager.MapManager.random");
            _list.unshift(_radomMapInfo);
            _pvpComplectiList = new Vector.<MapInfo>();
            _pvpComplectiList.push(_radomMapInfo);
        }

        public static function setupDungeonInfo(_arg_1:DungeonAnalyzer):void
        {
            var _local_4:DungeonInfo;
            _defaultDungeon = new DungeonInfo();
            _defaultDungeon.ID = 10000;
            _defaultDungeon.Description = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
            _defaultDungeon.isOpen = true;
            _defaultDungeon.Name = LanguageMgr.GetTranslation("tank.manager.selectDuplicate");
            _defaultDungeon.Type = 4;
            _defaultDungeon.Ordering = -1;
            _pveList = _arg_1.list;
            _pveLinkList = [];
            _pveBossList = new Vector.<DungeonInfo>();
            _pveExplrolList = new Vector.<DungeonInfo>();
            _fightLibList = new Vector.<DungeonInfo>();
            _pveAcademyList = new Vector.<DungeonInfo>();
            _pveSpecialList = new Vector.<DungeonInfo>();
            var _local_2:int;
            while (_local_2 < _pveList.length)
            {
                _local_4 = _pveList[_local_2];
                if (_local_4.Type == PVE_LINK_MAP)
                {
                    _pveLinkList.push(_local_4);
                }
                else
                {
                    if (_local_4.Type == PVE_BOSS_MAP)
                    {
                        _pveBossList.push(_local_4);
                    }
                    else
                    {
                        if (_local_4.Type == PVE_EXPROL_MAP)
                        {
                            _pveExplrolList.push(_local_4);
                        }
                        else
                        {
                            if (_local_4.Type == FIGHT_LIB)
                            {
                                _fightLibList.push(_local_4);
                            }
                            else
                            {
                                if (_local_4.Type == PVE_ACADEMY_MAP)
                                {
                                    _pveAcademyList.push(_local_4);
                                }
                                else
                                {
                                    if (_local_4.Type == PVE_CHANGE_MAP)
                                    {
                                        _pveSpecialList.push(_local_4);
                                    }
                                    else
                                    {
                                        if (_local_4.Type == PVE_MULTISHOOT)
                                        {
                                            _pveSpecialList.push(_local_4);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
                _local_2++;
            };
            _pveLinkList.unshift(_defaultDungeon);
            _pveBossList.unshift(_defaultDungeon);
            _pveMapCount = 0;
            var _local_3:int;
            while (_local_3 < _pveLinkList.length)
            {
                if (_pveLinkList[_local_3].Ordering > -1)
                {
                    _pveMapCount++;
                };
                _local_3++;
            };
        }

        public static function setupOpenMapInfo(_arg_1:WeekOpenMapAnalyze):void
        {
            _openList = _arg_1.list;
            buildMap();
        }

        public static function buildMap():void
        {
            var _local_1:String;
            var _local_3:MapInfo;
            if ((((_openList == null) || (_list == null)) || (ServerManager.Instance.current == null)))
            {
                return;
            };
            var _local_2:uint;
            while (_local_2 < _openList.length)
            {
                if (_openList[_local_2].serverID == ServerManager.Instance.current.ID)
                {
                    _local_1 = _openList[_local_2].maps;
                };
                _local_2++;
            };
            if (((_openList) && (_list)))
            {
                for each (_local_3 in _list)
                {
                    if (_local_1)
                    {
                        _local_3.isOpen = (_local_1.indexOf(String(_local_3.ID)) > -1);
                    };
                };
                _list.splice(_list.indexOf(_radomMapInfo), 1);
                _list.unshift(_radomMapInfo);
            };
        }

        public static function isMapOpen(_arg_1:int):Boolean
        {
            return (getMapInfo(_arg_1).isOpen);
        }

        public static function getMapInfo(_arg_1:Number):MapInfo
        {
            var _local_2:MapInfo;
            for each (_local_2 in _list)
            {
                if (_local_2.ID == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public static function getDungeonInfo(_arg_1:int):DungeonInfo
        {
            var _local_2:DungeonInfo;
            for each (_local_2 in _pveList)
            {
                if (_local_2.ID == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public static function getDungeonInfoByFinalID(_arg_1:int):DungeonInfo
        {
            var _local_2:Array;
            var _local_3:DungeonInfo;
            var _local_4:int;
            for each (_local_3 in _pveList)
            {
                _local_2 = _local_3.FinalMissionIDs.split(",");
                for each (_local_4 in _local_2)
                {
                    if (_local_4 == _arg_1)
                    {
                        return (_local_3);
                    };
                };
            };
            return (null);
        }

        public static function getByOrderingDungeonInfo(_arg_1:int):DungeonInfo
        {
            var _local_2:DungeonInfo;
            for each (_local_2 in _pveLinkList)
            {
                if (_local_2.Ordering == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public static function getByOrderingSpecialDungeonInfo(_arg_1:int):DungeonInfo
        {
            var _local_2:DungeonInfo;
            for each (_local_2 in _pveSpecialList)
            {
                if (_local_2.Ordering == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public static function getFightLibList():Vector.<DungeonInfo>
        {
            return (_fightLibList);
        }

        public static function getMapName(_arg_1:int):String
        {
            var _local_2:DungeonInfo = getDungeonInfo(_arg_1);
            if (_local_2)
            {
                return (_local_2.Name);
            };
            var _local_3:MapInfo = getMapInfo(_arg_1);
            if (_local_3)
            {
                return (_local_3.Name);
            };
            return ("");
        }

        public static function getMapNameByFinalID(_arg_1:int):String
        {
            var _local_2:DungeonInfo = getDungeonInfoByFinalID(_arg_1);
            if (_local_2)
            {
                return (_local_2.Name);
            };
            return ("");
        }

        public static function get pveMapCount():int
        {
            return (_pveMapCount);
        }

        public static function get specialMapCount():int
        {
            return (_pveSpecialList.length);
        }

        public static function getRoomHardLevel(_arg_1:int):String
        {
            switch (_arg_1)
            {
                case 0:
                    return (LanguageMgr.GetTranslation("tank.room.difficulty.simple"));
                case 1:
                    return (LanguageMgr.GetTranslation("tank.room.difficulty.normal"));
                case 2:
                    return (LanguageMgr.GetTranslation("tank.room.difficulty.hard"));
                case 3:
                    return (LanguageMgr.GetTranslation("tank.room.difficulty.hero"));
            };
            return ("");
        }


        public function getMapIsOpen(_arg_1:int):Boolean
        {
            return (!(_openList.indexOf(_arg_1) == -1));
        }


    }
}//package ddt.manager

