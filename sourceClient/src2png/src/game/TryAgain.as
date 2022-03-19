// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.TryAgain

package game
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.DisplayObject;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.utils.Timer;
    import flash.utils.Dictionary;
    import flash.display.Shape;
    import game.model.MissionAgainInfo;
    import ddt.data.BuffInfo;
    import room.RoomManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.toplevel.StageReferance;
    import ddt.manager.PlayerManager;
    import flash.display.Graphics;
    import flash.display.BitmapData;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import ddt.events.GameEvent;
    import flash.geom.Matrix;
    import ddt.manager.SoundManager;
    import ddt.manager.LeavePageManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.GameInSocketOut;
    import com.pickgliss.utils.ObjectUtils;

    [Event(name="timeOut", type="ddt.events.GameEvent")]
    [Event(name="tryagain", type="ddt.events.GameEvent")]
    [Event(name="giveup", type="ddt.events.GameEvent")]
    public class TryAgain extends Sprite implements Disposeable 
    {

        private var _back:DisplayObject;
        private var _tryagain:BaseButton;
        private var _giveup:BaseButton;
        private var _titleField:FilterFrameText;
        private var _valueField:FilterFrameText;
        private var _valueBack:DisplayObject;
        private var _timer:Timer;
        private var _numDic:Dictionary = new Dictionary();
        private var _markshape:Shape;
        private var _container:Sprite;
        private var _info:MissionAgainInfo;
        private var _buffNote:DisplayObject;
        private var _buffInfo:BuffInfo;

        public function TryAgain(_arg_1:MissionAgainInfo)
        {
            this._info = _arg_1;
            super();
            this._timer = new Timer(1000, 10);
            this.creatNums();
            this.configUI();
            this.addEvent();
        }

        public function show():void
        {
            if (RoomManager.Instance.current.selfRoomPlayer.isViewer)
            {
                switch (GameManager.Instance.TryAgain)
                {
                    case GameManager.MissionAgain:
                        this.tryagain();
                        break;
                    case GameManager.MissionGiveup:
                        this.__giveup(null);
                        break;
                    case GameManager.MissionTimeout:
                        this.timeOut();
                        break;
                };
            }
            else
            {
                this._timer.start();
            };
        }

        private function configUI():void
        {
            this.drawBlack();
            this._container = new Sprite();
            addChild(this._container);
            this._back = ComponentFactory.Instance.creatBitmap("asset.game.tryagain.back");
            this._container.addChild(this._back);
            this._tryagain = ComponentFactory.Instance.creatComponentByStylename("GameTryAgain");
            this._tryagain.enable = RoomManager.Instance.current.selfRoomPlayer.isHost;
            this._container.addChild(this._tryagain);
            this._giveup = ComponentFactory.Instance.creatComponentByStylename("GameGiveUp");
            this._giveup.enable = RoomManager.Instance.current.selfRoomPlayer.isHost;
            this._container.addChild(this._giveup);
            this._titleField = ComponentFactory.Instance.creatComponentByStylename("GameTryAgainTitle");
            this._container.addChild(this._titleField);
            this._titleField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.title", this._info.host);
            this._valueBack = ComponentFactory.Instance.creatBitmap("asset.game.tryagain.text");
            this._container.addChild(this._valueBack);
            this._valueField = ComponentFactory.Instance.creatComponentByStylename("GameTryAgainValue");
            this._container.addChild(this._valueField);
            this._markshape = new Shape();
            this._markshape.y = 80;
            if ((!(RoomManager.Instance.current.selfRoomPlayer.isViewer)))
            {
                this.drawMark(this._timer.repeatCount);
            };
            this._container.addChild(this._markshape);
            this._container.x = ((StageReferance.stageWidth - this._container.width) >> 1);
            this._container.y = ((StageReferance.stageHeight - this._container.height) >> 1);
            this._buffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.Level_Try];
            if (this._buffInfo)
            {
                if (this._buffInfo.ValidCount > 0)
                {
                    this.drawLevelAgainBuff();
                    this._valueField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.value", 0);
                }
                else
                {
                    this._valueField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.value", this._info.value);
                };
            }
            else
            {
                this._valueField.htmlText = LanguageMgr.GetTranslation("tnak.game.tryagain.value", this._info.value);
            };
        }

        private function drawLevelAgainBuff():void
        {
            this._buffNote = addChild(ComponentFactory.Instance.creat("asset.core.payBuffAsset72.note"));
        }

        private function drawBlack():void
        {
            var _local_1:Graphics = graphics;
            _local_1.clear();
            _local_1.beginFill(0, 0.4);
            _local_1.drawRect(0, 0, 2000, 1000);
            _local_1.endFill();
        }

        private function creatNums():void
        {
            var _local_1:BitmapData;
            var _local_2:int;
            while (_local_2 < 10)
            {
                _local_1 = ComponentFactory.Instance.creatBitmapData(("asset.game.mark.Blue" + _local_2));
                this._numDic[("Blue" + _local_2)] = _local_1;
                _local_2++;
            };
        }

        private function addEvent():void
        {
            this._tryagain.addEventListener(MouseEvent.CLICK, this.__tryagainClick);
            this._giveup.addEventListener(MouseEvent.CLICK, this.__giveup);
            this._timer.addEventListener(TimerEvent.TIMER, this.__mark);
            this._timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timeComplete);
            GameManager.Instance.addEventListener(GameEvent.MISSIONAGAIN, this.__missionAgain);
        }

        private function __missionAgain(_arg_1:GameEvent):void
        {
            var _local_2:int = _arg_1.data;
            switch (_local_2)
            {
                case GameManager.MissionAgain:
                    this.tryagain();
                    return;
                case GameManager.MissionGiveup:
                    this.__giveup(null);
                    return;
                case GameManager.MissionTimeout:
                    this.timeOut();
                    return;
            };
        }

        private function timeOut():void
        {
            dispatchEvent(new GameEvent(GameEvent.TIMEOUT, null));
        }

        private function __timeComplete(_arg_1:TimerEvent):void
        {
            switch (GameManager.Instance.TryAgain)
            {
                case GameManager.MissionAgain:
                    this.tryagain();
                    return;
                case GameManager.MissionGiveup:
                    this.__giveup(null);
                    return;
                case GameManager.MissionTimeout:
                    this.timeOut();
                    return;
            };
        }

        private function drawMark(_arg_1:int):void
        {
            var _local_3:BitmapData;
            var _local_5:String;
            var _local_6:int;
            var _local_2:Graphics = this._markshape.graphics;
            _local_2.clear();
            var _local_4:String = _arg_1.toString();
            if (_arg_1 == 10)
            {
                _local_6 = 0;
                while (_local_6 < _local_4.length)
                {
                    _local_5 = ("Blue" + _local_4.substr(_local_6, 1));
                    _local_3 = this._numDic[_local_5];
                    _local_2.beginBitmapFill(_local_3, new Matrix(1, 0, 0, 1, this._markshape.width));
                    _local_2.drawRect(this._markshape.width, 0, _local_3.width, _local_3.height);
                    _local_2.endFill();
                    _local_6++;
                };
                this._markshape.x = (((this._back.width - _local_3.width) >> 1) - 20);
            }
            else
            {
                _local_3 = this._numDic[("Blue" + _local_4)];
                _local_2.beginBitmapFill(_local_3);
                _local_2.drawRect(0, 0, _local_3.width, _local_3.height);
                _local_2.endFill();
                this._markshape.x = ((this._back.width - _local_3.width) >> 1);
            };
        }

        private function __mark(_arg_1:TimerEvent):void
        {
            SoundManager.instance.play("014");
            this.drawMark((this._timer.repeatCount - this._timer.currentCount));
        }

        private function __tryagainClick(_arg_1:MouseEvent):void
        {
            if (_arg_1)
            {
                SoundManager.instance.play("008");
            };
            if (RoomManager.Instance.current.selfRoomPlayer.isHost)
            {
                if (PlayerManager.Instance.Self.IsVIP)
                {
                    if (((this._buffInfo) && (this._buffInfo.ValidCount <= 0)))
                    {
                        if (((!(this._info.hasLevelAgain)) && (this._info.value > PlayerManager.Instance.Self.totalMoney)))
                        {
                            LeavePageManager.showFillFrame();
                            return;
                        };
                    };
                }
                else
                {
                    if (((!(this._info.hasLevelAgain)) && (this._info.value > PlayerManager.Instance.Self.totalMoney)))
                    {
                        LeavePageManager.showFillFrame();
                        return;
                    };
                };
                if (PlayerManager.Instance.Self.NeedFatigue > PlayerManager.Instance.Self.Fatigue)
                {
                    MessageTipManager.getInstance().show("活力值不足，无法续关");
                }
                else
                {
                    GameInSocketOut.sendMissionTryAgain(GameManager.MissionAgain, true);
                };
            };
        }

        private function tryagain():void
        {
            dispatchEvent(new GameEvent(GameEvent.TRYAGAIN, null));
        }

        private function __giveup(_arg_1:MouseEvent):void
        {
            if (_arg_1)
            {
                SoundManager.instance.play("008");
            };
            dispatchEvent(new GameEvent(GameEvent.GIVEUP, null));
        }

        private function removeEvent():void
        {
            this._tryagain.removeEventListener(MouseEvent.CLICK, this.__tryagainClick);
            this._giveup.removeEventListener(MouseEvent.CLICK, this.__giveup);
            this._timer.removeEventListener(TimerEvent.TIMER, this.__mark);
            this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timeComplete);
            GameManager.Instance.removeEventListener(GameEvent.MISSIONAGAIN, this.__missionAgain);
        }

        public function dispose():void
        {
            var _local_1:String;
            this.removeEvent();
            for (_local_1 in this._numDic)
            {
                ObjectUtils.disposeObject(this._numDic[_local_1]);
                delete this._numDic[_local_1];
            };
            ObjectUtils.disposeObject(this._buffNote);
            this._buffNote = null;
            ObjectUtils.disposeObject(this._markshape);
            this._markshape = null;
            ObjectUtils.disposeObject(this._valueField);
            this._valueField = null;
            ObjectUtils.disposeObject(this._valueBack);
            this._valueBack = null;
            ObjectUtils.disposeObject(this._titleField);
            this._titleField = null;
            ObjectUtils.disposeObject(this._giveup);
            this._giveup = null;
            ObjectUtils.disposeObject(this._tryagain);
            this._tryagain = null;
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game

