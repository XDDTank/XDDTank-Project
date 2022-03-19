// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.BallManager

package ddt.manager
{
    import __AS3__.vec.Vector;
    import ddt.data.BallInfo;
    import flash.utils.Dictionary;
    import ddt.data.analyze.BallInfoAnalyzer;
    import game.objects.BombAsset;
    import flash.display.Bitmap;
    import com.pickgliss.utils.ClassUtils;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import com.pickgliss.loader.DisplayLoader;

    public class BallManager 
    {

        public static const DEFAULT_BOMB_ID:int = 888888;
        private static var _list:Vector.<BallInfo>;
        private static var _gameInBombAssets:Dictionary;
        public static const CRATER:int = 0;
        public static const CREATER_BRINK:int = 1;


        public static function setup(_arg_1:BallInfoAnalyzer):void
        {
            _list = _arg_1.list;
            _gameInBombAssets = new Dictionary();
        }

        public static function addBombAsset(_arg_1:int, _arg_2:Bitmap, _arg_3:int):void
        {
            if (_gameInBombAssets[_arg_1] == null)
            {
                _gameInBombAssets[_arg_1] = new BombAsset();
            };
            if (_arg_3 == CRATER)
            {
                if (_gameInBombAssets[_arg_1].crater == null)
                {
                    _gameInBombAssets[_arg_1].crater = _arg_2;
                };
            }
            else
            {
                if (_arg_3 == CREATER_BRINK)
                {
                    if (_gameInBombAssets[_arg_1].craterBrink == null)
                    {
                        _gameInBombAssets[_arg_1].craterBrink = _arg_2;
                    };
                };
            };
        }

        public static function hasBombAsset(_arg_1:int):Boolean
        {
            return (!(_gameInBombAssets[_arg_1] == null));
        }

        public static function getBombAsset(_arg_1:int):BombAsset
        {
            return (_gameInBombAssets[_arg_1]);
        }

        public static function get ready():Boolean
        {
            return (!(_list == null));
        }

        public static function findBall(_arg_1:int):BallInfo
        {
            var _local_2:BallInfo;
            var _local_3:BallInfo;
            for each (_local_3 in _list)
            {
                if (_local_3.ID == _arg_1)
                {
                    _local_2 = _local_3;
                    break;
                };
            };
            return (_local_2);
        }

        public static function solveBallAssetName(_arg_1:int):String
        {
            return ("tank.resource.bombs.Bomb" + _arg_1);
        }

        public static function solveBallWeaponMovieName(_arg_1:int):String
        {
            return ("tank.resource.bombs.BombMovie" + _arg_1);
        }

        public static function createBallWeaponMovie(_arg_1:int):MovieClip
        {
            return (ClassUtils.CreatInstance(solveBallWeaponMovieName(_arg_1)) as MovieClip);
        }

        public static function createBallAsset(_arg_1:int):Sprite
        {
            return (ClassUtils.CreatInstance(solveBallAssetName(_arg_1)) as Sprite);
        }

        public static function solveBlastOutMovieName(_arg_1:int):String
        {
            return ("blastOutMovie" + _arg_1);
        }

        public static function solveBulletMovieName(_arg_1:int):String
        {
            return ("bullet" + _arg_1);
        }

        public static function solveShootMovieMovieName(_arg_1:int):String
        {
            return ("shootMovie" + _arg_1);
        }

        public static function createBlastOutMovie(_arg_1:int):MovieClip
        {
            if (DisplayLoader.Context.applicationDomain.hasDefinition(solveBlastOutMovieName(_arg_1)))
            {
                return (ClassUtils.CreatInstance(solveBlastOutMovieName(_arg_1)) as MovieClip);
            };
            return (ClassUtils.CreatInstance(solveBlastOutMovieName(DEFAULT_BOMB_ID)) as MovieClip);
        }

        public static function createBulletMovie(_arg_1:int):MovieClip
        {
            if (DisplayLoader.Context.applicationDomain.hasDefinition(solveBulletMovieName(_arg_1)))
            {
                return (ClassUtils.CreatInstance(solveBulletMovieName(_arg_1)) as MovieClip);
            };
            return (ClassUtils.CreatInstance(solveBulletMovieName(DEFAULT_BOMB_ID)) as MovieClip);
        }

        public static function createShootMovieMovie(_arg_1:int):MovieClip
        {
            if (DisplayLoader.Context.applicationDomain.hasDefinition(solveShootMovieMovieName(_arg_1)))
            {
                return (ClassUtils.CreatInstance(solveShootMovieMovieName(_arg_1)) as MovieClip);
            };
            return (ClassUtils.CreatInstance(solveShootMovieMovieName(DEFAULT_BOMB_ID)) as MovieClip);
        }

        public static function clearAsset():void
        {
            var _local_1:String;
            for (_local_1 in _gameInBombAssets)
            {
                _gameInBombAssets[_local_1].dispose();
                delete _gameInBombAssets[_local_1];
            };
        }


    }
}//package ddt.manager

