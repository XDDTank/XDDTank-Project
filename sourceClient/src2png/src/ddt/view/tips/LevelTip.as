﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.tips.LevelTip

package ddt.view.tips
{
    import com.pickgliss.ui.tip.BaseTip;
    import com.pickgliss.ui.tip.ITip;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import flash.display.Bitmap;
    import flash.display.Sprite;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import game.GameManager;
    import com.pickgliss.utils.ObjectUtils;

    public class LevelTip extends BaseTip implements ITip 
    {

        private static var _instance:LevelTip;

        private var _bg:ScaleBitmapImage;
        private var _lv:Bitmap;
        private var _repute:Repute;
        private var _winRate:WinRate;
        private var _battle:Battle;
        private var _exploit:Exploit;
        private var _tipContainer:Sprite;
        private var _level:int;
        private var _reputeCount:int;
        private var _win:int;
        private var _total:int;
        private var _enableTip:Boolean;
        private var _tip:Sprite;
        private var _tipInfo:Object;
        private var _battleNum:int;
        private var _exploitValue:int;
        private var _bgH:int;

        public function LevelTip()
        {
            if ((!(_instance)))
            {
                super();
                _instance = this;
            };
        }

        public static function get instance():LevelTip
        {
            if ((!(instance)))
            {
                _instance = new (LevelTip)();
            };
            return (_instance);
        }


        override protected function init():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.GoodsTipBg");
            this._tipbackgound = this._bg;
            this._lv = ComponentFactory.Instance.creatBitmap("asset.core.leveltip.LevelTipLv");
            this.createLevelTip();
            super.init();
        }

        override protected function addChildren():void
        {
            super.addChildren();
            addChild(this._lv);
            addChild(this._tipContainer);
            this.updateWH();
        }

        public function get txtPos():Point
        {
            var _local_1:Point = new Point();
            if (this._lv)
            {
                _local_1.x = ((this._lv.x + this._lv.width) + 3);
                _local_1.y = (this._lv.y + 4);
            };
            return (_local_1);
        }

        override public function get tipData():Object
        {
            return (this._tipInfo);
        }

        override public function set tipData(_arg_1:Object):void
        {
            if ((_arg_1 is LevelTipInfo))
            {
                this.visible = true;
                this.makeTip(_arg_1);
            }
            else
            {
                this.visible = false;
            };
            this._tipInfo = _arg_1;
        }

        private function updateWH():void
        {
            _width = this._bg.width;
            _height = this._bg.height;
        }

        private function createLevelTip():void
        {
            this._tipContainer = new Sprite();
            this._repute = new Repute(this._reputeCount, this._level);
            this._repute.align = Repute.LEFT;
            this._winRate = new WinRate(this._win, this._total);
            this._battle = new Battle(this._battleNum);
            this._exploit = new Exploit(this._exploitValue);
            this._repute.x = (this._winRate.x = (this._battle.x = (this._exploit.x = 10)));
            this._repute.y = 27;
            this._winRate.y = 52;
            this._battle.y = 77;
            this._exploit.y = 102;
            this._tipContainer.addChild(this._repute);
            this._tipContainer.addChild(this._winRate);
            this._tipContainer.addChild(this._battle);
        }

        private function makeTip(_arg_1:Object):void
        {
            if (_arg_1)
            {
                this.resetLevelTip(_arg_1.Level, _arg_1.Repute, _arg_1.Win, _arg_1.Total, _arg_1.Battle, _arg_1.exploit, _arg_1.enableTip, _arg_1.team);
            };
        }

        private function resetLevelTip(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:Boolean=true, _arg_8:int=1):void
        {
            this._level = _arg_1;
            this._reputeCount = _arg_2;
            this._win = _arg_3;
            this._total = _arg_4;
            this._exploitValue = _arg_6;
            this._enableTip = _arg_7;
            this.visible = this._enableTip;
            if ((!(this._enableTip)))
            {
                return;
            };
            this.setRepute(this._level, this._reputeCount);
            this.setRate(_arg_3, _arg_4);
            this.setBattle(_arg_5);
            this.setExploit(this._exploitValue);
            if (this._bgH == 0)
            {
                this._bgH = this._bg.height;
            };
            if ((((((StateManager.isInFight) || (StateManager.currentStateType == StateType.TRAINER1)) || (StateManager.currentStateType == StateType.TRAINER2)) || (StateManager.currentStateType == StateType.FIGHT_LIB_GAMEVIEW)) || (StateManager.currentStateType == StateType.GAME_LOADING)))
            {
                if (_arg_8 != GameManager.Instance.Current.selfGamePlayer.team)
                {
                    this._battle.visible = false;
                    this._exploit.y = 77;
                    this._bg.height = (this._bgH - 20);
                }
                else
                {
                    this._battle.visible = true;
                    this._exploit.y = 102;
                    this._bg.height = this._bgH;
                };
            }
            else
            {
                this._battle.visible = true;
                this._exploit.y = 102;
                this._bg.height = this._bgH;
            };
            this.updateTip();
        }

        private function setRepute(_arg_1:int, _arg_2:int):void
        {
            this._repute.level = _arg_1;
            this._repute.setRepute(_arg_2);
        }

        private function setRate(_arg_1:int, _arg_2:int):void
        {
            this._winRate.setRate(_arg_1, _arg_2);
        }

        private function setBattle(_arg_1:int):void
        {
            this._battle.BattleNum = _arg_1;
        }

        private function setExploit(_arg_1:int):void
        {
            this._exploit.exploitNum = _arg_1;
        }

        private function updateTip():void
        {
            if (this._tip)
            {
                this.removeChild(this._tip);
            };
            this._tip = new Sprite();
            LevelPicCreater.creatLevelPicInContainer(this._tip, this._level, int(this.txtPos.x), int(this.txtPos.y));
            addChild(this._tip);
            this._bg.width = (this._tipContainer.width + 15);
            this.updateWH();
        }

        override public function dispose():void
        {
            if (this._tip)
            {
                if (this._tip.parent)
                {
                    this._tip.parent.removeChild(this._tip);
                };
            };
            this._tip = null;
            if (this._tipContainer)
            {
                if (this._tipContainer.parent)
                {
                    this._tipContainer.parent.removeChild(this._tipContainer);
                };
            };
            this._tipContainer = null;
            ObjectUtils.disposeObject(this._repute);
            this._repute = null;
            ObjectUtils.disposeObject(this._winRate);
            this._winRate = null;
            ObjectUtils.disposeObject(this._battle);
            this._battle = null;
            ObjectUtils.disposeObject(this._exploit);
            this._exploit = null;
            if (this._lv)
            {
                ObjectUtils.disposeObject(this._lv);
            };
            this._lv = null;
            ObjectUtils.disposeObject(this);
            _instance = null;
            super.dispose();
        }


    }
}//package ddt.view.tips
