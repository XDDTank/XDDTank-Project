package ddt.manager
{
   import ddt.data.BallInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.loader.StartupResourceLoader;
   import flash.utils.Dictionary;
   import room.model.RoomPlayer;
   import room.model.WeaponInfo;
   
   public class LoadBombManager
   {
      
      public static const SpecialBomb:Array = [1];
      
      private static var _instance:LoadBombManager;
       
      
      private var _tempWeaponInfos:Dictionary;
      
      private var _tempCraterIDs:Dictionary;
      
      public function LoadBombManager()
      {
         super();
      }
      
      public static function get Instance() : LoadBombManager
      {
         if(_instance == null)
         {
            _instance = new LoadBombManager();
         }
         return _instance;
      }
      
      public function loadFullRoomPlayersBomb(param1:Array) : void
      {
         this.loadFullWeaponBombMovie(param1);
         this.loadFullWeaponBombBitMap(param1);
      }
      
      public function loadFullWeaponBombMovie(param1:Array) : void
      {
         var _loc2_:RoomPlayer = null;
         var _loc3_:ItemTemplateInfo = null;
         var _loc4_:BallInfo = null;
         var _loc5_:WeaponInfo = null;
         this._tempWeaponInfos = null;
         this._tempWeaponInfos = new Dictionary();
         for each(_loc2_ in param1)
         {
            if(!_loc2_.isViewer)
            {
               if(!this._tempWeaponInfos[_loc2_.currentWeapInfo.TemplateID])
               {
                  this._tempWeaponInfos[_loc2_.currentWeapInfo.TemplateID] = _loc2_.currentWeapInfo;
               }
               _loc3_ = ItemManager.Instance.getTemplateById(_loc2_.playerInfo.DeputyWeaponID);
               if(_loc3_)
               {
                  _loc4_ = BallManager.findBall(int(_loc3_.Property7));
                  if(_loc4_)
                  {
                     _loc4_.loadBombAsset();
                  }
               }
            }
         }
         if(!StartupResourceLoader.firstEnterHall)
         {
            for each(_loc5_ in this._tempWeaponInfos)
            {
               this.loadBomb(_loc5_);
            }
         }
      }
      
      public function loadFullWeaponBombBitMap(param1:Array) : void
      {
         var _loc2_:RoomPlayer = null;
         var _loc3_:WeaponInfo = null;
         var _loc4_:BallInfo = null;
         var _loc5_:int = 0;
         this._tempCraterIDs = null;
         this._tempCraterIDs = new Dictionary();
         this._tempWeaponInfos = null;
         this._tempWeaponInfos = new Dictionary();
         for each(_loc2_ in param1)
         {
            if(!_loc2_.isViewer && !this._tempWeaponInfos[_loc2_.currentWeapInfo.TemplateID])
            {
               this._tempWeaponInfos[_loc2_.currentWeapInfo.TemplateID] = _loc2_.currentWeapInfo;
            }
         }
         for each(_loc3_ in this._tempWeaponInfos)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc3_.bombs.length)
            {
               if(!this._tempCraterIDs[BallManager.findBall(_loc3_.bombs[_loc5_]).craterID])
               {
                  this._tempCraterIDs[BallManager.findBall(_loc3_.bombs[_loc5_]).craterID] = BallManager.findBall(_loc3_.bombs[_loc5_]);
               }
               _loc5_++;
            }
         }
         for each(_loc4_ in this._tempCraterIDs)
         {
            _loc4_.loadCraterBitmap();
         }
      }
      
      private function loadBomb(param1:WeaponInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.bombs.length)
         {
            BallManager.findBall(param1.bombs[_loc2_]).loadBombAsset();
            _loc2_++;
         }
      }
      
      public function getLoadBombComplete(param1:WeaponInfo) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.bombs.length)
         {
            if(!BallManager.findBall(param1.bombs[_loc2_]).isComplete())
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function getLoadBombAssetComplete(param1:WeaponInfo) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.bombs.length)
         {
            if(!BallManager.findBall(param1.bombs[_loc2_]).bombAssetIsComplete())
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function getUnloadedBombString(param1:WeaponInfo) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < SpecialBomb.length)
         {
            if(!BallManager.findBall(param1.bombs[_loc3_]).isComplete())
            {
               _loc2_ += SpecialBomb[_loc3_] + ",";
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function loadLivingBomb(param1:int) : void
      {
         BallManager.findBall(param1).loadBombAsset();
         BallManager.findBall(param1).loadCraterBitmap();
      }
      
      public function getLivingBombComplete(param1:int) : Boolean
      {
         return BallManager.findBall(param1).isComplete();
      }
      
      public function loadSpecialBomb() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < SpecialBomb.length)
         {
            BallManager.findBall(SpecialBomb[_loc1_]).loadBombAsset();
            BallManager.findBall(SpecialBomb[_loc1_]).loadCraterBitmap();
            _loc1_++;
         }
      }
      
      public function getUnloadedSpecialBombString() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < SpecialBomb.length)
         {
            if(!BallManager.findBall(SpecialBomb[_loc2_]).isComplete())
            {
               _loc1_ += SpecialBomb[_loc2_] + ",";
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getLoadSpecialBombComplete() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < SpecialBomb.length)
         {
            if(!BallManager.findBall(SpecialBomb[_loc1_]).isComplete())
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
   }
}
