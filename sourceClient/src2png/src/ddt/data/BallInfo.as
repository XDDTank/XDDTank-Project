// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.BallInfo

package ddt.data
{
    import flash.geom.Point;
    import com.pickgliss.loader.ModuleLoader;
    import ddt.manager.BallManager;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import com.pickgliss.loader.LoaderEvent;

    public class BallInfo 
    {

        public var ID:int = 2;
        public var Name:String;
        public var Mass:Number = 1;
        public var Power:Number;
        public var Radii:Number;
        public var SpinV:Number = 1000;
        public var SpinVA:Number = 1;
        public var Amount:Number = 1;
        public var Wind:int;
        public var Weight:int;
        public var DragIndex:int;
        public var Shake:Boolean;
        public var ShootSound:String;
        public var BombSound:String;
        public var ActionType:int;
        public var blastOutID:int;
        public var craterID:int;
        public var FlyingPartical:int;


        public function getCarrayBall():Point
        {
            return (new Point(0, 90));
        }

        public function loadBombAsset():void
        {
            if (((!(ModuleLoader.hasDefinition(BallManager.solveBulletMovieName(this.ID)))) && (!(ModuleLoader.hasDefinition(BallManager.solveShootMovieMovieName(this.ID))))))
            {
                LoadResourceManager.instance.creatAndStartLoad(PathManager.solveBlastOut(this.ID), BaseLoader.MODULE_LOADER);
            };
            if ((!(ModuleLoader.hasDefinition(BallManager.solveBlastOutMovieName(this.blastOutID)))))
            {
                LoadResourceManager.instance.creatAndStartLoad(PathManager.solveBullet(this.blastOutID), BaseLoader.MODULE_LOADER);
            };
        }

        public function loadCraterBitmap():void
        {
            var _local_1:BaseLoader;
            var _local_2:BaseLoader;
            if ((!(BallManager.hasBombAsset(this.craterID))))
            {
                if (this.craterID != 0)
                {
                    _local_1 = LoadResourceManager.instance.createLoader(PathManager.solveCrater(this.craterID), BaseLoader.BITMAP_LOADER);
                    _local_1.addEventListener(LoaderEvent.COMPLETE, this.__craterComplete);
                    LoadResourceManager.instance.startLoad(_local_1);
                    _local_2 = LoadResourceManager.instance.createLoader(PathManager.solveCraterBrink(this.craterID), BaseLoader.BITMAP_LOADER);
                    _local_2.addEventListener(LoaderEvent.COMPLETE, this.__craterBrinkComplete);
                    LoadResourceManager.instance.startLoad(_local_2);
                };
            };
        }

        private function __craterComplete(_arg_1:LoaderEvent):void
        {
            (_arg_1.currentTarget as BaseLoader).removeEventListener(LoaderEvent.COMPLETE, this.__craterComplete);
            BallManager.addBombAsset(this.craterID, _arg_1.loader.content, BallManager.CRATER);
        }

        private function __craterBrinkComplete(_arg_1:LoaderEvent):void
        {
            (_arg_1.currentTarget as BaseLoader).removeEventListener(LoaderEvent.COMPLETE, this.__craterBrinkComplete);
            BallManager.addBombAsset(this.craterID, _arg_1.loader.content, BallManager.CREATER_BRINK);
        }

        public function isComplete():Boolean
        {
            if (((BallManager.hasBombAsset(this.craterID)) && (this.getHasDefinition(this))))
            {
                return (true);
            };
            if (((this.craterID == 0) && (this.getHasDefinition(this))))
            {
                return (true);
            };
            return (false);
        }

        public function bombAssetIsComplete():Boolean
        {
            if (((BallManager.hasBombAsset(this.craterID)) || (this.craterID == 0)))
            {
                return (true);
            };
            return (false);
        }

        public function getHasDefinition(_arg_1:BallInfo):Boolean
        {
            if ((!(ModuleLoader.hasDefinition(BallManager.solveBlastOutMovieName(_arg_1.blastOutID)))))
            {
            };
            if ((!(ModuleLoader.hasDefinition(BallManager.solveBulletMovieName(_arg_1.ID)))))
            {
            };
            if ((!(ModuleLoader.hasDefinition(BallManager.solveShootMovieMovieName(_arg_1.ID)))))
            {
            };
            return ((ModuleLoader.hasDefinition(BallManager.solveBlastOutMovieName(_arg_1.blastOutID))) && (ModuleLoader.hasDefinition(BallManager.solveBulletMovieName(_arg_1.ID))));
        }


    }
}//package ddt.data

