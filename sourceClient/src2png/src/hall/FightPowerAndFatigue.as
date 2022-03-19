// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//hall.FightPowerAndFatigue

package hall
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.view.PlayerPortraitView;
    import ddt.view.tips.OneLineTip;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Shape;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.PlayerManager;
    import ddt.manager.LanguageMgr;
    import flash.geom.Point;
    import flash.events.MouseEvent;
    import ddt.events.PlayerPropertyEvent;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import flash.events.Event;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.MessageTipManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import baglocked.BaglockedManager;
    import ddt.manager.SocketManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;
    import bagAndInfo.fightPower.FightPowerUpFrame;
    import com.greensock.TweenLite;
    import flash.utils.setTimeout;
    import bagAndInfo.fightPower.FightPowerController;
    import flash.utils.clearTimeout;

    public class FightPowerAndFatigue extends Sprite implements Disposeable 
    {

        private static var _instance:FightPowerAndFatigue;

        private var _bg:Bitmap;
        private var _fightPowerProgress:MovieClip;
        private var _fatigueProgress:Bitmap;
        private var _addFatigueBtn:BaseButton;
        private var _portrait:PlayerPortraitView;
        private var _fatigueTips:OneLineTip;
        private var _fightPowerTxt:FilterFrameText;
        private var _fatigueTxt:FilterFrameText;
        private var _fatigueProgressMask:Shape;
        private var _fightPowerProgressMask:Shape;
        private var _tipsHitArea:Sprite;
        private var _fightPowerBtn:BaseButton;
        private var _upBmp:Bitmap;
        private var _saveFightPower:int;
        private var _fightPowerMovie:MovieClip;
        private var _fightPowerTimeout:Number;


        public static function get Instance():FightPowerAndFatigue
        {
            if ((!(_instance)))
            {
                _instance = new (FightPowerAndFatigue)();
            };
            return (_instance);
        }


        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.hall.fightPowerBG");
            this._fightPowerBtn = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerUpButton");
            this._upBmp = ComponentFactory.Instance.creatBitmap("asset.hall.upBmp");
            this._fightPowerProgress = ComponentFactory.Instance.creat("asset.hall.fightPowerProgress");
            this._fatigueProgress = ComponentFactory.Instance.creatBitmap("asset.hall.fatigueProgress");
            this._addFatigueBtn = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerAndFatigue.buyFatigueBtn");
            this._portrait = ComponentFactory.Instance.creatCustomObject("hall.fightPowerAndFatigue.selfPortrait", ["right"]);
            this._fightPowerTxt = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerAndFatigue.fightPowerTxt");
            this._fatigueTxt = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerAndFatigue.fatigueTxt");
            PositionUtils.setPos(this._upBmp, "hall.fightPowerUpBmp.Pos");
            PositionUtils.setPos(this._fightPowerProgress, "hall.fightPowerProgress.Pos");
            this._portrait.info = PlayerManager.Instance.Self;
            this._portrait.isShowFrame = false;
            var _local_1:int = PlayerManager.Instance.Self.FightPower;
            this._fightPowerTxt.text = String(_local_1);
            this._saveFightPower = _local_1;
            if (PlayerManager.Instance.Self.Fatigue > 100)
            {
                this._fatigueTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightPowerAndFatigue.fatigueVal.red", PlayerManager.Instance.Self.Fatigue);
                this._addFatigueBtn.enable = false;
            }
            else
            {
                this._fatigueTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightPowerAndFatigue.fatigueVal.white", PlayerManager.Instance.Self.Fatigue);
                if (PlayerManager.Instance.Self.Fatigue == 100)
                {
                    this._addFatigueBtn.enable = false;
                }
                else
                {
                    this._addFatigueBtn.enable = true;
                };
            };
            this._fatigueProgressMask = new Shape();
            this._fatigueProgressMask.graphics.beginFill(0, 0);
            this._fatigueProgressMask.graphics.drawRect(0, 0, this._fatigueProgress.width, this._fatigueProgress.height);
            this._fatigueProgressMask.graphics.endFill();
            PositionUtils.setPos(this._fatigueProgressMask, new Point(this._fatigueProgress.x, this._fatigueProgress.y));
            this._fatigueProgressMask.width = int(((this._fatigueProgress.width * PlayerManager.Instance.Self.Fatigue) / 100));
            this._tipsHitArea = new Sprite();
            this._tipsHitArea.graphics.beginFill(0, 0);
            this._tipsHitArea.graphics.drawRect(0, 0, this._fatigueProgress.width, this._fatigueProgress.height);
            this._tipsHitArea.graphics.endFill();
            PositionUtils.setPos(this._tipsHitArea, new Point(this._fatigueProgress.x, this._fatigueProgress.y));
            this._fightPowerProgressMask = new Shape();
            this._fightPowerProgressMask.graphics.beginFill(0, 0);
            this._fightPowerProgressMask.graphics.drawRect(0, 0, this._fightPowerProgress.width, this._fightPowerProgress.height);
            this._fightPowerProgressMask.graphics.endFill();
            PositionUtils.setPos(this._fightPowerProgressMask, new Point(this._fightPowerProgress.x, this._fightPowerProgress.y));
            this.reflashFightPower();
            addChild(this._bg);
            addChild(this._fightPowerBtn);
            this._fightPowerBtn.addChild(this._fightPowerProgress);
            this._fightPowerBtn.addChild(this._fightPowerProgressMask);
            this._fightPowerBtn.addChild(this._upBmp);
            this._fightPowerBtn.addChild(this._fightPowerTxt);
            this._fightPowerProgress.mask = this._fightPowerProgressMask;
            addChild(this._fatigueProgress);
            addChild(this._fatigueProgressMask);
            this._fatigueProgress.mask = this._fatigueProgressMask;
            addChild(this._portrait);
            addChild(this._addFatigueBtn);
            addChild(this._fatigueTxt);
            addChild(this._tipsHitArea);
            this._fatigueTips = new OneLineTip();
            this._fatigueTips.tipData = LanguageMgr.GetTranslation("ddthall.fatigue.tips");
            this._fatigueTips.visible = false;
            addChild(this._fatigueTips);
        }

        private function addEvent():void
        {
            this._tipsHitArea.addEventListener(MouseEvent.ROLL_OVER, this.__onFatigueMouseOver);
            this._tipsHitArea.addEventListener(MouseEvent.ROLL_OUT, this.__onFatigueMouseOut);
            this._addFatigueBtn.addEventListener(MouseEvent.CLICK, this.__onBuyFatigueClick);
            PlayerManager.Instance.addEventListener(PlayerManager.BUY_FATIUE, this.__FatigueChange);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__FatigueChange);
            TimeManager.addEventListener(TimeEvents.MINUTES, this.__FatigueChange);
            this._fightPowerBtn.addEventListener(MouseEvent.CLICK, this.__showFightPowerFrame);
        }

        private function removeEvent():void
        {
            this._tipsHitArea.removeEventListener(MouseEvent.ROLL_OVER, this.__onFatigueMouseOver);
            this._tipsHitArea.removeEventListener(MouseEvent.ROLL_OUT, this.__onFatigueMouseOut);
            this._addFatigueBtn.removeEventListener(MouseEvent.CLICK, this.__onBuyFatigueClick);
            PlayerManager.Instance.removeEventListener(PlayerManager.BUY_FATIUE, this.__FatigueChange);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.__FatigueChange);
            TimeManager.removeEventListener(TimeEvents.MINUTES, this.__FatigueChange);
            this._fightPowerBtn.removeEventListener(MouseEvent.CLICK, this.__showFightPowerFrame);
            if (this._fightPowerMovie)
            {
                this._fightPowerMovie.removeEventListener(Event.COMPLETE, this.__pointMovieEnd);
            };
        }

        private function __onFatigueMouseOver(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if (this._fatigueTips)
            {
                this._fatigueTips.visible = true;
                LayerManager.Instance.addToLayer(this._fatigueTips, LayerManager.GAME_TOP_LAYER);
                _local_2 = this._fatigueProgress.localToGlobal(new Point(0, 0));
                this._fatigueTips.x = ((_local_2.x + this._fatigueProgress.width) - 70);
                this._fatigueTips.y = ((_local_2.y + this._fatigueProgress.height) + 5);
            };
        }

        private function __onFatigueMouseOut(_arg_1:MouseEvent):void
        {
            if (this._fatigueTips)
            {
                this._fatigueTips.visible = false;
            };
        }

        private function __onBuyFatigueClick(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.getRestBuyFatigueCount > 0)
            {
                AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("ddt.buyFatigue.tipInfo", PlayerManager.Instance.Self.getBuyFatigueMoney()), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, true, true, LayerManager.ALPHA_BLOCKGOUND).addEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            }
            else
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.fatigue.maxCountTip"));
            };
        }

        private function __FatigueChange(_arg_1:Event):void
        {
            if ((!(this._fatigueTxt)))
            {
                return;
            };
            var _local_2:int = PlayerManager.Instance.Self.Fatigue;
            if (_local_2 > 100)
            {
                this._fatigueTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightPowerAndFatigue.fatigueVal.red", _local_2);
                this._addFatigueBtn.enable = false;
            }
            else
            {
                this._fatigueTxt.htmlText = LanguageMgr.GetTranslation("ddt.fightPowerAndFatigue.fatigueVal.white", _local_2);
                if (_local_2 == 100)
                {
                    this._addFatigueBtn.enable = false;
                }
                else
                {
                    this._addFatigueBtn.enable = true;
                };
            };
            this._fatigueProgressMask.width = int(((this._fatigueProgress.width * _local_2) / 100));
            if ((_arg_1 is PlayerPropertyEvent))
            {
                if ((_arg_1 as PlayerPropertyEvent).changedProperties["FightPower"])
                {
                    this.reflashFightPower();
                };
            };
        }

        private function reflashFightPower():void
        {
            var _local_1:int = PlayerManager.Instance.Self.FightPower;
            if (_local_1 > this._saveFightPower)
            {
                this.showAnima();
            }
            else
            {
                this._fightPowerProgressMask.width = (this._fightPowerProgress.width * this.getFightPowerProgress());
                this._fightPowerTxt.text = String(PlayerManager.Instance.Self.FightPower);
            };
            this._saveFightPower = _local_1;
        }

        private function __frameEvent(_arg_1:FrameEvent):void
        {
            var _local_3:int;
            var _local_4:BaseAlerFrame;
            var _local_5:BaseAlerFrame;
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__frameEvent);
            _local_2.dispose();
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                _local_3 = PlayerManager.Instance.Self.getBuyFatigueMoney();
                if (((PlayerManager.Instance.Self.DDTMoney == 0) && (_local_3 > PlayerManager.Instance.Self.Money)))
                {
                    _local_4 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("poorNote"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                    _local_4.moveEnable = false;
                    _local_4.addEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
                }
                else
                {
                    if ((PlayerManager.Instance.Self.DDTMoney + PlayerManager.Instance.Self.Money) < _local_3)
                    {
                        _local_5 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("poorNote"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.BLCAK_BLOCKGOUND);
                        _local_5.moveEnable = false;
                        _local_5.addEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
                    }
                    else
                    {
                        SocketManager.Instance.out.sendBuyFatigue();
                    };
                };
            };
        }

        private function __poorManResponse(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__poorManResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                LeavePageManager.leaveToFillPath();
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function __showFightPowerFrame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:FightPowerUpFrame = ComponentFactory.Instance.creatComponentByStylename("hall.fightPowerUpFrame");
            _local_2.show();
        }

        public function show():void
        {
            if (this.parent)
            {
                return;
            };
            this.initView();
            this.addEvent();
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER);
        }

        public function hide():void
        {
            if ((!(this.parent)))
            {
                return;
            };
            this.dispose();
        }

        public function reflashFatigue():void
        {
            if ((!(this.parent)))
            {
                return;
            };
            this.__FatigueChange(new Event(Event.CHANGE));
        }

        private function showAnima():void
        {
            TweenLite.killTweensOf(this._fightPowerProgressMask);
            if (SoundManager.instance.isPlaying("201"))
            {
                SoundManager.instance.stop("201");
            };
            if (this.parent != LayerManager.Instance.getLayerByType(LayerManager.STAGE_TOP_LAYER))
            {
                this.parent.removeChild(this);
                LayerManager.Instance.addToLayer(this, LayerManager.STAGE_TOP_LAYER);
            };
            if (this._fightPowerMovie)
            {
                this._fightPowerMovie.removeEventListener(Event.COMPLETE, this.__pointMovieEnd);
                ObjectUtils.disposeObject(this._fightPowerMovie);
            };
            this._fightPowerMovie = ComponentFactory.Instance.creat("asset.hall.fightPowerPointMovie");
            PositionUtils.setPos(this._fightPowerMovie, "hall.fightPowerPointMovie.Pos");
            LayerManager.Instance.addToLayer(this._fightPowerMovie, LayerManager.STAGE_TOP_LAYER);
            this._fightPowerMovie.addEventListener(Event.COMPLETE, this.__pointMovieEnd);
            SoundManager.instance.play("201");
        }

        private function __pointMovieEnd(_arg_1:Event):void
        {
            this._fightPowerMovie.removeEventListener(Event.COMPLETE, this.__pointMovieEnd);
            ObjectUtils.disposeObject(this._fightPowerMovie);
            this._fightPowerMovie = null;
            this.showFightPowerProgressAnima();
        }

        private function showFightPowerProgressAnima():void
        {
            var _local_1:Number = this.getFightPowerProgress();
            if (_local_1 < 1)
            {
                this._fightPowerProgress.gotoAndPlay(2);
            };
            TweenLite.to(this._fightPowerProgressMask, 1, {
                "width":int((this._fightPowerProgress.width * _local_1)),
                "onUpdate":this.numMove,
                "onComplete":this.animaEnd
            });
        }

        private function animaEnd():void
        {
            TweenLite.killTweensOf(this._fightPowerProgressMask);
            this._fightPowerProgress.gotoAndStop(1);
            this._fightPowerTimeout = setTimeout(this.moveBack, 1000);
            this._fightPowerTxt.text = String(PlayerManager.Instance.Self.FightPower);
        }

        private function moveBack():void
        {
            this.parent.removeChild(this);
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_UI_LAYER);
        }

        private function getFightPowerProgress():Number
        {
            var _local_1:int = FightPowerController.Instance.getCurrentLevelValueByType(FightPowerController.TOTAL_FIGHT_POWER).StandFigting;
            var _local_2:Number = (PlayerManager.Instance.Self.FightPower / _local_1);
            return ((_local_2 > 1) ? 1 : _local_2);
        }

        private function numMove():void
        {
            var _local_1:int = PlayerManager.Instance.Self.FightPower;
            var _local_2:int = int(this._fightPowerTxt.text);
            if (_local_2 < _local_1)
            {
                this._fightPowerTxt.text = String(((_local_2 + int(((_local_1 - _local_2) / 5))) + Math.round((Math.random() * 5))));
            }
            else
            {
                this._fightPowerTxt.text = String(PlayerManager.Instance.Self.FightPower);
            };
        }

        public function set fightPowerBtnEnable(_arg_1:Boolean):void
        {
            this._fightPowerBtn.enable = _arg_1;
        }

        public function dispose():void
        {
            this.removeEvent();
            clearTimeout(this._fightPowerTimeout);
            TweenLite.killTweensOf(this._fightPowerProgressMask);
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._fightPowerProgress);
            this._fightPowerProgress = null;
            ObjectUtils.disposeObject(this._fatigueProgress);
            this._fatigueProgress = null;
            ObjectUtils.disposeObject(this._addFatigueBtn);
            this._addFatigueBtn = null;
            ObjectUtils.disposeObject(this._portrait);
            this._portrait = null;
            ObjectUtils.disposeObject(this._fightPowerTxt);
            this._fightPowerTxt = null;
            ObjectUtils.disposeObject(this._fatigueTxt);
            this._fatigueTxt = null;
            ObjectUtils.disposeObject(this._fightPowerProgressMask);
            this._fightPowerProgressMask = null;
            ObjectUtils.disposeObject(this._fatigueProgressMask);
            this._fatigueProgressMask = null;
            ObjectUtils.disposeObject(this._tipsHitArea);
            this._tipsHitArea = null;
            ObjectUtils.disposeObject(this._upBmp);
            this._upBmp = null;
            ObjectUtils.disposeObject(this._fightPowerBtn);
            this._fightPowerBtn = null;
            ObjectUtils.disposeObject(this._fightPowerMovie);
            this._fightPowerMovie = null;
            ObjectUtils.disposeObject(this._fatigueTips);
            this._fatigueTips = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package hall

