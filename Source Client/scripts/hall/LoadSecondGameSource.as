package hall
{
   import ddt.manager.BallManager;
   import game.model.GameNeedMovieInfo;
   
   public class LoadSecondGameSource
   {
       
      
      private var needMovieInfos:Vector.<GameNeedMovieInfo>;
      
      private var bombIDs:Array;
      
      public function LoadSecondGameSource()
      {
         this.bombIDs = [121,1212,1211,131,891];
         super();
         this.needMovieInfos = new Vector.<GameNeedMovieInfo>();
         this.addGameNeedMovieInfo(1,"bombs/61.swf","tank.resource.bombs.Bomb61");
         this.addGameNeedMovieInfo(2,"image/game/thing/BossBornBgAsset.swf","game.asset.living.BossBgAsset");
         this.addGameNeedMovieInfo(2,"image/game/thing/BossBornBgAsset.swf","game.asset.living.boguoLeaderAsset");
         this.addGameNeedMovieInfo(2,"image/game/living/Living002.swf","game.living.Living002");
         this.addGameNeedMovieInfo(2,"image/game/living/Living003.swf","game.living.Living003");
      }
      
      public function startLoad() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.bombIDs.length)
         {
            BallManager.findBall(this.bombIDs[_loc1_]).loadBombAsset();
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.needMovieInfos.length)
         {
            this.needMovieInfos[_loc2_].startLoad();
            _loc2_++;
         }
      }
      
      private function addGameNeedMovieInfo(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:GameNeedMovieInfo = new GameNeedMovieInfo();
         _loc4_.type = param1;
         _loc4_.path = param2;
         _loc4_.classPath = param3;
         this.needMovieInfos.push(_loc4_);
      }
   }
}
