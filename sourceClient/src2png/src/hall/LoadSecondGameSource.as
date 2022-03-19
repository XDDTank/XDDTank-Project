// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hall.LoadSecondGameSource

package hall
{
    import __AS3__.vec.Vector;
    import game.model.GameNeedMovieInfo;
    import ddt.manager.BallManager;
    import __AS3__.vec.*;

    public class LoadSecondGameSource 
    {

        private var needMovieInfos:Vector.<GameNeedMovieInfo>;
        private var bombIDs:Array = [121, 1212, 1211, 131, 891];

        public function LoadSecondGameSource()
        {
            this.needMovieInfos = new Vector.<GameNeedMovieInfo>();
            this.addGameNeedMovieInfo(1, "bombs/61.swf", "tank.resource.bombs.Bomb61");
            this.addGameNeedMovieInfo(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.BossBgAsset");
            this.addGameNeedMovieInfo(2, "image/game/thing/BossBornBgAsset.swf", "game.asset.living.boguoLeaderAsset");
            this.addGameNeedMovieInfo(2, "image/game/living/Living002.swf", "game.living.Living002");
            this.addGameNeedMovieInfo(2, "image/game/living/Living003.swf", "game.living.Living003");
        }

        public function startLoad():void
        {
            var _local_1:int;
            while (_local_1 < this.bombIDs.length)
            {
                BallManager.findBall(this.bombIDs[_local_1]).loadBombAsset();
                _local_1++;
            };
            var _local_2:int;
            while (_local_2 < this.needMovieInfos.length)
            {
                this.needMovieInfos[_local_2].startLoad();
                _local_2++;
            };
        }

        private function addGameNeedMovieInfo(_arg_1:int, _arg_2:String, _arg_3:String):void
        {
            var _local_4:GameNeedMovieInfo = new GameNeedMovieInfo();
            _local_4.type = _arg_1;
            _local_4.path = _arg_2;
            _local_4.classPath = _arg_3;
            this.needMovieInfos.push(_local_4);
        }


    }
}//package hall

