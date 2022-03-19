// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.HitsNumView

package game.view
{
    import flash.display.MovieClip;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    import com.greensock.TweenLite;
    import flash.display.BitmapData;
    import game.GameManager;
    import com.greensock.easing.Bounce;
    import com.pickgliss.utils.ObjectUtils;

    public class HitsNumView extends MovieClip implements Disposeable 
    {

        private var hitsbg:Bitmap;
        private var hits11:Bitmap;
        private var glassFlake1:Bitmap;
        private var glassFlake2:Bitmap;
        private var good:Bitmap;
        private var cool:Bitmap;
        private var great:Bitmap;
        private var perfect:Bitmap;
        private var pics:Sprite;
        private var setTimeoutId:uint;
        private var hitsNumArr:Array = new Array();
        private var rankV:Array = [3, 6, 9, 12];
        private var rankS:Array;
        private var currentRank:Bitmap;
        private var currentGlassFlake:Bitmap;

        public function HitsNumView()
        {
            this.init();
        }

        private function init():void
        {
            this.hitsbg = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.hitsbg");
            this.hits11 = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.hits11");
            this.glassFlake1 = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.glassFlake1");
            this.glassFlake2 = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.glassFlake2");
            this.good = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.good");
            this.cool = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.cool");
            this.great = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.great");
            this.perfect = ComponentFactory.Instance.creatBitmap("asset.game.hitsView.perfect");
            this.rankS = [this.good, this.cool, this.great, this.perfect];
            this.y = 300;
            this.x = -500;
            this.addChild(this.hitsbg);
            this.addChild(this.hits11);
            this.pics = new Sprite();
            this.addChild(this.pics);
        }

        public function setHitsNum(_arg_1:int):void
        {
            if (_arg_1 > 0)
            {
                this.hitsNumArr.push(_arg_1);
            };
        }

        public function start():void
        {
            clearTimeout(this.setTimeoutId);
            if (this.hitsNumArr[0])
            {
                this.hitsNum(this.hitsNumArr.shift());
            };
            if (this.hitsNumArr.length == 0)
            {
                this.setTimeoutId = setTimeout(this.resetView, 1200);
            };
        }

        public function resetView():void
        {
            this.hitsNumArr = new Array();
            TweenLite.to(this, 1, {"x":-500});
            clearTimeout(this.setTimeoutId);
        }

        private function hitsNum(_arg_1:int):void
        {
            var _local_6:BitmapData;
            var _local_7:Bitmap;
            if (_arg_1 < 2)
            {
                return;
            };
            this.x = 0;
            while (this.pics.numChildren > 0)
            {
                this.pics.removeChildAt(0);
            };
            var _local_2:String = String(_arg_1);
            var _local_3:int = _local_2.length;
            var _local_4:Array = new Array();
            var _local_5:int;
            while (_local_5 < _local_3)
            {
                _local_6 = GameManager.Instance.numCreater.whiteData[int(_local_2.charAt(_local_5))];
                _local_7 = new Bitmap(_local_6);
                _local_4.push(_local_7);
                _local_5++;
            };
            if (_local_4.length == 1)
            {
                this.pics.addChild(_local_4[0]);
                this.pics.x = 30;
            }
            else
            {
                if (_local_4.length == 2)
                {
                    this.pics.addChild(_local_4[0]);
                    this.pics.addChild(_local_4[1]);
                    _local_4[1].x = 30;
                    this.pics.x = 20;
                }
                else
                {
                    if (_local_4.length == 3)
                    {
                        this.pics.addChild(_local_4[0]);
                        this.pics.addChild(_local_4[1]);
                        this.pics.addChild(_local_4[2]);
                        _local_4[2].x = 50;
                        _local_4[1].x = 20;
                        _local_4[0].x = -10;
                        this.pics.x = 10;
                    };
                };
            };
            this.pics.y = 111;
            this.pics.alpha = 0.1;
            this.pics.scaleX = 2;
            this.pics.scaleY = 2;
            TweenLite.to(this.pics, 0.15, {
                "alpha":1,
                "scaleX":1,
                "scaleY":1
            });
            this.setRankText(_arg_1);
            _local_4 = null;
        }

        private function setRankText(_arg_1:int):void
        {
            var _local_2:int = 3;
            while (_local_2 >= 0)
            {
                if (_arg_1 >= this.rankV[_local_2])
                {
                    if (this.currentRank == this.rankS[_local_2]) break;
                    if (((this.currentRank) && (this.contains(this.currentRank))))
                    {
                        this.removeChild(this.currentRank);
                    };
                    if (((this.currentGlassFlake) && (this.contains(this.currentGlassFlake))))
                    {
                        this.removeChild(this.currentGlassFlake);
                    };
                    if (_local_2 > 2)
                    {
                        this.currentGlassFlake = this.glassFlake2;
                    }
                    else
                    {
                        this.currentGlassFlake = this.glassFlake1;
                    };
                    this.addChild(this.currentGlassFlake);
                    TweenLite.to(this.currentGlassFlake, 0.3, {
                        "y":5,
                        "ease":Bounce.easeIn
                    });
                    this.currentRank = this.rankS[_local_2];
                    this.addChild(this.currentRank);
                    this.currentRank.x = 60;
                    this.currentRank.y = 53;
                    this.currentRank.alpha = 0.2;
                    this.currentRank.scaleX = 1.8;
                    this.currentRank.scaleY = 1.8;
                    TweenLite.to(this.currentRank, 0.3, {
                        "alpha":1,
                        "scaleX":1,
                        "scaleY":1
                    });
                    return;
                };
                if (((this.currentRank) && (this.contains(this.currentRank))))
                {
                    this.removeChild(this.currentRank);
                };
                if (((this.currentGlassFlake) && (this.contains(this.currentGlassFlake))))
                {
                    this.removeChild(this.currentGlassFlake);
                };
                _local_2--;
            };
        }

        public function dispose():void
        {
            var _local_1:int;
            GameManager.Instance.hitsNum = 0;
            ObjectUtils.disposeObject(this.pics);
            this.pics = null;
            ObjectUtils.disposeObject(this.hitsbg);
            this.hitsbg = null;
            ObjectUtils.disposeObject(this.hits11);
            this.hits11 = null;
            ObjectUtils.disposeObject(this.currentGlassFlake);
            this.currentGlassFlake = null;
            ObjectUtils.disposeObject(this.glassFlake1);
            this.glassFlake1 = null;
            ObjectUtils.disposeObject(this.glassFlake2);
            this.glassFlake2 = null;
            ObjectUtils.disposeObject(this.currentRank);
            this.currentRank = null;
            if (((this.rankS) && (this.rankS.length > 0)))
            {
                _local_1 = 0;
                while (_local_1 < this.rankS.length)
                {
                    this.rankS[_local_1] = null;
                    _local_1++;
                };
            };
            this.rankS = null;
            clearTimeout(this.setTimeoutId);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view

