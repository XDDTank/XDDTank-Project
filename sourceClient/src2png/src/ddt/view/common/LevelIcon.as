// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.common.LevelIcon

package ddt.view.common
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.ITipedDisplay;
    import com.pickgliss.ui.core.Disposeable;
    import flash.utils.Dictionary;
    import ddt.view.tips.LevelTipInfo;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.SoundManager;
    import flash.events.MouseEvent;
    import flash.display.DisplayObject;
    import flash.display.Bitmap;
    import road7th.utils.MathUtils;
    import flash.display.MovieClip;
    import flash.display.BlendMode;
    import com.pickgliss.ui.ComponentFactory;

    public class LevelIcon extends Sprite implements ITipedDisplay, Disposeable 
    {

        public static const MAX_LEVEL:int = 70;
        public static const MIN_LEVEL:int = 1;
        public static const SIZE_BIG:int = 0;
        public static const SIZE_SMALL:int = 1;
        private static const LEVEL_EFFECT_CLASSPATH:String = "asset.LevelIcon.LevelEffect_";
        private static const LEVEL_ICON_CLASSPATH:String = "asset.LevelIcon.Level_";

        private var _isBitmap:Boolean;
        private var _level:int;
        private var _levelBitmaps:Dictionary;
        private var _levelEffects:Dictionary;
        private var _levelTipInfo:LevelTipInfo;
        private var _tipDirctions:String;
        private var _tipGapH:int;
        private var _tipGapV:int;
        private var _tipStyle:String;
        private var _size:int;
        private var _bmContainer:Sprite;

        public function LevelIcon()
        {
            this._levelBitmaps = new Dictionary();
            this._levelEffects = new Dictionary();
            this._levelTipInfo = new LevelTipInfo();
            this._tipStyle = "core.LevelTips";
            this._tipGapV = 5;
            this._tipGapH = 5;
            this._tipDirctions = "7,6,5";
            this._size = SIZE_BIG;
            mouseChildren = true;
            mouseEnabled = false;
            this._bmContainer = new Sprite();
            this._bmContainer.buttonMode = false;
            addChild(this._bmContainer);
            ShowTipManager.Instance.addTip(this);
        }

        private function __click(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            var _local_1:String;
            var _local_2:Bitmap;
            this._bmContainer.removeEventListener(MouseEvent.CLICK, this.__click);
            ShowTipManager.Instance.removeTip(this);
            this.clearnDisplay();
            for (_local_1 in this._levelBitmaps)
            {
                _local_2 = this._levelBitmaps[_local_1];
                _local_2.bitmapData.dispose();
                delete this._levelBitmaps[_local_1];
            };
            this._levelBitmaps = null;
            this._levelEffects = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function setInfo(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:Boolean=true, _arg_8:Boolean=true, _arg_9:int=1):void
        {
            var _local_10:Boolean = (!(this._level == _arg_1));
            this._level = MathUtils.getValueInRange(_arg_1, MIN_LEVEL, MAX_LEVEL);
            this._isBitmap = _arg_8;
            this._levelTipInfo.Level = this._level;
            this._levelTipInfo.Battle = _arg_5;
            this._levelTipInfo.Win = _arg_3;
            this._levelTipInfo.Repute = _arg_2;
            this._levelTipInfo.Total = _arg_4;
            this._levelTipInfo.exploit = _arg_6;
            this._levelTipInfo.enableTip = _arg_7;
            this._levelTipInfo.team = _arg_9;
            if (_local_10)
            {
                this.updateView();
            };
        }

        public function setSize(_arg_1:int):void
        {
            this._size = _arg_1;
            this.updateSize();
        }

        public function get tipData():Object
        {
            return (this._levelTipInfo);
        }

        public function set tipData(_arg_1:Object):void
        {
            this._levelTipInfo = (_arg_1 as LevelTipInfo);
        }

        public function get tipDirctions():String
        {
            return (this._tipDirctions);
        }

        public function set tipDirctions(_arg_1:String):void
        {
            this._tipDirctions = _arg_1;
        }

        public function get tipGapH():int
        {
            return (this._tipGapH);
        }

        public function set tipGapH(_arg_1:int):void
        {
            this._tipGapH = _arg_1;
        }

        public function get tipGapV():int
        {
            return (this._tipGapV);
        }

        public function set tipGapV(_arg_1:int):void
        {
            this._tipGapV = _arg_1;
        }

        public function get tipStyle():String
        {
            return (this._tipStyle);
        }

        public function set tipStyle(_arg_1:String):void
        {
            this._tipStyle = _arg_1;
        }

        public function allowClick():void
        {
            this._bmContainer.addEventListener(MouseEvent.CLICK, this.__click);
        }

        private function addCurrentLevelBitmap():void
        {
            addChild(this._bmContainer);
            this._bmContainer.addChild(this.creatLevelBitmap(this._level));
        }

        private function addCurrentLevelEffect():void
        {
            var _local_1:MovieClip;
            if (this._isBitmap)
            {
                return;
            };
            _local_1 = this.creatLevelEffect(this._level);
            if (_local_1)
            {
                _local_1.mouseChildren = (_local_1.mouseEnabled = false);
                _local_1.play();
                if (this._level > 40)
                {
                    _local_1.blendMode = BlendMode.ADD;
                };
                addChild(_local_1);
            };
        }

        private function clearnDisplay():void
        {
            var _local_1:MovieClip;
            while (this._bmContainer.numChildren > 0)
            {
                this._bmContainer.removeChildAt(0);
            };
            while (numChildren > 0)
            {
                _local_1 = (getChildAt(0) as MovieClip);
                if (_local_1)
                {
                    _local_1.stop();
                };
                removeChildAt(0);
            };
        }

        private function creatLevelBitmap(_arg_1:int):Bitmap
        {
            if (this._levelBitmaps[_arg_1])
            {
                return (this._levelBitmaps[_arg_1]);
            };
            var _local_2:Bitmap = ComponentFactory.Instance.creatBitmap((LEVEL_ICON_CLASSPATH + _arg_1.toString()));
            _local_2.smoothing = true;
            this._levelBitmaps[_arg_1] = _local_2;
            return (_local_2);
        }

        private function creatLevelEffect(_arg_1:int):MovieClip
        {
            var _local_2:int;
            if (MathUtils.isInRange(_arg_1, 10, 20))
            {
                _local_2 = 1;
            };
            if (MathUtils.isInRange(_arg_1, 20, 30))
            {
                _local_2 = 2;
            };
            if (MathUtils.isInRange(_arg_1, 30, 40))
            {
                _local_2 = 3;
            };
            if (MathUtils.isInRange(_arg_1, 40, 50))
            {
                _local_2 = 4;
            };
            if (MathUtils.isInRange(_arg_1, 50, 60))
            {
                _local_2 = 5;
            };
            if (MathUtils.isInRange(_arg_1, 60, 70))
            {
                _local_2 = 6;
            };
            if (_local_2 == 0)
            {
                return (null);
            };
            if (this._levelEffects[_local_2])
            {
                return (this._levelEffects[_local_2]);
            };
            var _local_3:MovieClip = ComponentFactory.Instance.creat((LEVEL_EFFECT_CLASSPATH + _local_2.toString()));
            _local_3.stop();
            this._levelEffects[_local_2] = _local_3;
            return (_local_3);
        }

        private function updateView():void
        {
            this.clearnDisplay();
            this.addCurrentLevelBitmap();
            this.addCurrentLevelEffect();
            this.updateSize();
        }

        private function updateSize():void
        {
            if (this._size == SIZE_SMALL)
            {
                scaleX = (scaleY = 0.6);
            }
            else
            {
                if (this._size == SIZE_BIG)
                {
                    scaleX = (scaleY = 0.75);
                };
            };
        }


    }
}//package ddt.view.common

