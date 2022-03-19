// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.LoadBombManager

package ddt.manager
{
    import flash.utils.Dictionary;
    import room.model.RoomPlayer;
    import ddt.data.goods.ItemTemplateInfo;
    import ddt.data.BallInfo;
    import room.model.WeaponInfo;
    import ddt.loader.StartupResourceLoader;

    public class LoadBombManager 
    {

        public static const SpecialBomb:Array = [1];
        private static var _instance:LoadBombManager;

        private var _tempWeaponInfos:Dictionary;
        private var _tempCraterIDs:Dictionary;


        public static function get Instance():LoadBombManager
        {
            if (_instance == null)
            {
                _instance = new (LoadBombManager)();
            };
            return (_instance);
        }


        public function loadFullRoomPlayersBomb(_arg_1:Array):void
        {
            this.loadFullWeaponBombMovie(_arg_1);
            this.loadFullWeaponBombBitMap(_arg_1);
        }

        public function loadFullWeaponBombMovie(_arg_1:Array):void
        {
            var _local_2:RoomPlayer;
            var _local_3:ItemTemplateInfo;
            var _local_4:BallInfo;
            var _local_5:WeaponInfo;
            this._tempWeaponInfos = null;
            this._tempWeaponInfos = new Dictionary();
            for each (_local_2 in _arg_1)
            {
                if ((!(_local_2.isViewer)))
                {
                    if ((!(this._tempWeaponInfos[_local_2.currentWeapInfo.TemplateID])))
                    {
                        this._tempWeaponInfos[_local_2.currentWeapInfo.TemplateID] = _local_2.currentWeapInfo;
                    };
                    _local_3 = ItemManager.Instance.getTemplateById(_local_2.playerInfo.DeputyWeaponID);
                    if (_local_3)
                    {
                        _local_4 = BallManager.findBall(int(_local_3.Property7));
                        if (_local_4)
                        {
                            _local_4.loadBombAsset();
                        };
                    };
                };
            };
            if ((!(StartupResourceLoader.firstEnterHall)))
            {
                for each (_local_5 in this._tempWeaponInfos)
                {
                    this.loadBomb(_local_5);
                };
            };
        }

        public function loadFullWeaponBombBitMap(_arg_1:Array):void
        {
            var _local_2:RoomPlayer;
            var _local_3:WeaponInfo;
            var _local_4:BallInfo;
            var _local_5:int;
            this._tempCraterIDs = null;
            this._tempCraterIDs = new Dictionary();
            this._tempWeaponInfos = null;
            this._tempWeaponInfos = new Dictionary();
            for each (_local_2 in _arg_1)
            {
                if (((!(_local_2.isViewer)) && (!(this._tempWeaponInfos[_local_2.currentWeapInfo.TemplateID]))))
                {
                    this._tempWeaponInfos[_local_2.currentWeapInfo.TemplateID] = _local_2.currentWeapInfo;
                };
            };
            for each (_local_3 in this._tempWeaponInfos)
            {
                _local_5 = 0;
                while (_local_5 < _local_3.bombs.length)
                {
                    if ((!(this._tempCraterIDs[BallManager.findBall(_local_3.bombs[_local_5]).craterID])))
                    {
                        this._tempCraterIDs[BallManager.findBall(_local_3.bombs[_local_5]).craterID] = BallManager.findBall(_local_3.bombs[_local_5]);
                    };
                    _local_5++;
                };
            };
            for each (_local_4 in this._tempCraterIDs)
            {
                _local_4.loadCraterBitmap();
            };
        }

        private function loadBomb(_arg_1:WeaponInfo):void
        {
            var _local_2:int;
            while (_local_2 < _arg_1.bombs.length)
            {
                BallManager.findBall(_arg_1.bombs[_local_2]).loadBombAsset();
                _local_2++;
            };
        }

        public function getLoadBombComplete(_arg_1:WeaponInfo):Boolean
        {
            var _local_2:int;
            while (_local_2 < _arg_1.bombs.length)
            {
                if ((!(BallManager.findBall(_arg_1.bombs[_local_2]).isComplete())))
                {
                    return (false);
                };
                _local_2++;
            };
            return (true);
        }

        public function getLoadBombAssetComplete(_arg_1:WeaponInfo):Boolean
        {
            var _local_2:int;
            while (_local_2 < _arg_1.bombs.length)
            {
                if ((!(BallManager.findBall(_arg_1.bombs[_local_2]).bombAssetIsComplete())))
                {
                    return (false);
                };
                _local_2++;
            };
            return (true);
        }

        public function getUnloadedBombString(_arg_1:WeaponInfo):String
        {
            var _local_2:String = "";
            var _local_3:int;
            while (_local_3 < SpecialBomb.length)
            {
                if ((!(BallManager.findBall(_arg_1.bombs[_local_3]).isComplete())))
                {
                    _local_2 = (_local_2 + (SpecialBomb[_local_3] + ","));
                };
                _local_3++;
            };
            return (_local_2);
        }

        public function loadLivingBomb(_arg_1:int):void
        {
            BallManager.findBall(_arg_1).loadBombAsset();
            BallManager.findBall(_arg_1).loadCraterBitmap();
        }

        public function getLivingBombComplete(_arg_1:int):Boolean
        {
            return (BallManager.findBall(_arg_1).isComplete());
        }

        public function loadSpecialBomb():void
        {
            var _local_1:int;
            while (_local_1 < SpecialBomb.length)
            {
                BallManager.findBall(SpecialBomb[_local_1]).loadBombAsset();
                BallManager.findBall(SpecialBomb[_local_1]).loadCraterBitmap();
                _local_1++;
            };
        }

        public function getUnloadedSpecialBombString():String
        {
            var _local_1:String = "";
            var _local_2:int;
            while (_local_2 < SpecialBomb.length)
            {
                if ((!(BallManager.findBall(SpecialBomb[_local_2]).isComplete())))
                {
                    _local_1 = (_local_1 + (SpecialBomb[_local_2] + ","));
                };
                _local_2++;
            };
            return (_local_1);
        }

        public function getLoadSpecialBombComplete():Boolean
        {
            var _local_1:int;
            while (_local_1 < SpecialBomb.length)
            {
                if ((!(BallManager.findBall(SpecialBomb[_local_1]).isComplete())))
                {
                    return (false);
                };
                _local_1++;
            };
            return (true);
        }


    }
}//package ddt.manager

