// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bagAndInfo.info.FightPowerView

package bagAndInfo.info
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.controls.BaseButton;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.display.Shape;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import bagAndInfo.fightPower.FightPowerUpFrame;
    import com.greensock.TweenLite;
    import bagAndInfo.fightPower.FightPowerController;
    import com.pickgliss.utils.ObjectUtils;

    public class FightPowerView extends Sprite implements Disposeable 
    {

        private var _fightPowerArr:Array;
        private var _fightPowerTxt:FilterFrameText;
        private var _info:PlayerInfo;
        private var _bitWidth:int;
        private var _powerUpBtn:BaseButton;
        private var _upBmp:Bitmap;
        private var _fightPowerProgress:MovieClip;
        private var _fightPowerProgressMask:Shape;
        private var _saveFightPower:int;

        public function FightPowerView()
        {
            this.initView();
            this.initEvent();
        }

        private function initView():void
        {
            this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("personInfoViewFightPowerText");
            this._powerUpBtn = ComponentFactory.Instance.creatComponentByStylename("fightPowerUpButton");
            this._upBmp = ComponentFactory.Instance.creatBitmap("asset.hall.upBmp");
            this._fightPowerProgress = ComponentFactory.Instance.creat("asset.hall.fightPowerProgress");
            this._fightPowerProgressMask = new Shape();
            this._fightPowerProgressMask.graphics.beginFill(0, 0);
            this._fightPowerProgressMask.graphics.drawRect(0, 0, (this._fightPowerProgress.width * this.getFightPowerProgress()), this._fightPowerProgress.height);
            this._fightPowerProgressMask.graphics.endFill();
            PositionUtils.setPos(this._fightPowerProgress, "ddtbagAndInfo.fightPowerProgress.Pos");
            PositionUtils.setPos(this._fightPowerProgressMask, "ddtbagAndInfo.fightPowerProgress.Pos");
            addChild(this._powerUpBtn);
            this._powerUpBtn.addChild(this._fightPowerTxt);
            this._powerUpBtn.addChild(this._upBmp);
            this._powerUpBtn.addChild(this._fightPowerProgress);
            this._powerUpBtn.addChild(this._fightPowerProgressMask);
            this._fightPowerProgress.mask = this._fightPowerProgressMask;
            this._saveFightPower = PlayerManager.Instance.Self.FightPower;
        }

        private function initEvent():void
        {
            this._powerUpBtn.addEventListener(MouseEvent.CLICK, this.__clickPowerUpBtn);
        }

        private function removeEvent():void
        {
            this._powerUpBtn.removeEventListener(MouseEvent.CLICK, this.__clickPowerUpBtn);
        }

        private function __clickPowerUpBtn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:FightPowerUpFrame = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerUpFrame");
            _local_2.show();
        }

        public function setInfo(_arg_1:PlayerInfo):void
        {
            this._info = _arg_1;
            if (this._info == null)
            {
                return;
            };
            if (this._info.FightPower != this._saveFightPower)
            {
                this.showFightPowerProgressAnima();
            };
            this._fightPowerTxt.text = String(this._info.FightPower);
        }

        private function showFightPowerProgressAnima():void
        {
            TweenLite.killTweensOf(this._fightPowerProgressMask);
            var _local_1:Number = this.getFightPowerProgress();
            if (_local_1 < 1)
            {
                this._fightPowerProgress.gotoAndPlay(2);
            };
            TweenLite.to(this._fightPowerProgressMask, 1, {
                "width":int((this._fightPowerProgress.width * _local_1)),
                "onComplete":this.animaEnd
            });
            this._saveFightPower = this._info.FightPower;
        }

        private function getFightPowerProgress():Number
        {
            var _local_1:int = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.TOTAL_FIGHT_POWER).StandFigting;
            var _local_2:Number = (PlayerManager.Instance.Self.FightPower / _local_1);
            return ((_local_2 > 1) ? 1 : _local_2);
        }

        private function animaEnd():void
        {
            TweenLite.killTweensOf(this._fightPowerProgressMask);
            this._fightPowerProgress.gotoAndStop(1);
        }

        private function updatefightPower():void
        {
            var _local_4:Bitmap;
            var _local_5:int;
            if (this._fightPowerArr)
            {
                _local_5 = 0;
                while (_local_5 < this._fightPowerArr.length)
                {
                    ObjectUtils.disposeObject(this._fightPowerArr[_local_5]);
                    this._fightPowerArr[_local_5] = null;
                    _local_5++;
                };
            };
            var _local_1:int = ((this._info) ? this._info.FightPower : 0);
            if (_local_1 < 1)
            {
                return;
            };
            var _local_2:String = _local_1.toString();
            var _local_3:int;
            this._fightPowerArr = new Array();
            _local_3 = 0;
            while (_local_3 < _local_2.length)
            {
                _local_4 = ComponentFactory.Instance.creatBitmap((("bagAndInfo.fightingpower" + _local_2.charAt(_local_3)) + "Num"));
                addChild(_local_4);
                this._fightPowerArr.push(_local_4);
                _local_3++;
            };
            this._bitWidth = (_local_4.width - 4);
            this.updatePosition();
        }

        private function updatePosition():void
        {
            var _local_3:Bitmap;
            var _local_1:int = (this._fightPowerArr.length * this._bitWidth);
            var _local_2:int = int((-(_local_1) / 2));
            for each (_local_3 in this._fightPowerArr)
            {
                _local_3.x = _local_2;
                _local_2 = (_local_2 + this._bitWidth);
            };
        }

        public function setFightPowerEnable(_arg_1:Boolean):void
        {
            this._powerUpBtn.enable = _arg_1;
        }

        public function dispose():void
        {
            var _local_1:int;
            TweenLite.killTweensOf(this._fightPowerProgressMask);
            if (this._fightPowerArr)
            {
                _local_1 = 0;
                while (_local_1 < this._fightPowerArr.length)
                {
                    ObjectUtils.disposeObject(this._fightPowerArr[_local_1]);
                    this._fightPowerArr[_local_1] = null;
                    _local_1++;
                };
            };
            ObjectUtils.disposeObject(this._fightPowerTxt);
            this._fightPowerTxt = null;
            ObjectUtils.disposeObject(this._upBmp);
            this._upBmp = null;
            ObjectUtils.disposeObject(this._fightPowerProgress);
            this._fightPowerProgress = null;
            ObjectUtils.disposeObject(this._fightPowerProgressMask);
            this._fightPowerProgressMask = null;
            ObjectUtils.disposeObject(this._powerUpBtn);
            this._powerUpBtn = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package bagAndInfo.info

