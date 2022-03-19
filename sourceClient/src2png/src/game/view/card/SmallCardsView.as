// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.card.SmallCardsView

package game.view.card
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import game.model.GameInfo;
    import room.model.RoomInfo;
    import flash.utils.Timer;
    import flash.display.Bitmap;
    import flash.events.TimerEvent;
    import game.GameManager;
    import room.RoomManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import flash.events.Event;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.GameInSocketOut;
    import ddt.manager.LanguageMgr;
    import road7th.comm.PackageIn;
    import game.model.Player;
    import com.greensock.TweenLite;
    import com.greensock.easing.Quint;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class SmallCardsView extends Sprite implements Disposeable 
    {

        public static const SMALL_CARD_TIME:uint = 5;
        public static const SMALL_CARD_CNT:uint = 9;
        public static const SMALL_CARD_COLUMNS:uint = 3;
        public static const SMALL_CARD_MAX_SELECTED_CNT:uint = 1;
        public static const SMALL_CARD_REQUEST_CARD:uint = 100;
        public static const SMALL_CARD_VIEW_TIME:uint = 1;
        public static const ON_ALL_COMPLETE_CNT:uint = 2;

        protected var _cards:Vector.<LuckyCard>;
        protected var _posArr:Vector.<Point>;
        protected var _gameInfo:GameInfo;
        protected var _roomInfo:RoomInfo;
        protected var _resultCards:Array;
        protected var _selectedCnt:int;
        protected var _selectCompleted:Boolean;
        protected var _countDownView:CardCountDown;
        protected var _countDownTime:int = 5;
        protected var _cardCnt:int = 9;
        protected var _cardColumns:int = 3;
        protected var _viewTime:int = 1;
        protected var _timerForView:Timer;
        protected var _title:Bitmap;
        protected var _onAllComplete:int;
        protected var _canTakeOut:Boolean;

        public function SmallCardsView()
        {
            this.init();
        }

        protected function init():void
        {
            this._selectedCnt = 0;
            this._selectCompleted = false;
            this._timerForView = new Timer(1000, this._viewTime);
            this._timerForView.addEventListener(TimerEvent.TIMER_COMPLETE, this.__timerForViewComplete);
            this._cards = new Vector.<LuckyCard>();
            this._posArr = new Vector.<Point>();
            this._gameInfo = GameManager.Instance.Current;
            this._roomInfo = RoomManager.Instance.current;
            this._resultCards = this._gameInfo.resultCard.concat();
            this._title = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.TitleBitmap");
            this._countDownView = new CardCountDown();
            PositionUtils.setPos(this._countDownView, "takeoutCard.SmallCardViewCountDownPos");
            addChild(this._countDownView);
            this._countDownView.tick(this._countDownTime);
            addChild(this._title);
            this.createCards();
            var _local_1:int;
            while (_local_1 < this._resultCards.length)
            {
                this.__takeOut(this._resultCards[_local_1]);
                _local_1++;
            };
            this.initEvent();
        }

        protected function initEvent():void
        {
            addEventListener(Event.ADDED_TO_STAGE, this.startTween);
            if (this._countDownView)
            {
                this._countDownView.addEventListener(Event.COMPLETE, this.__countDownComplete);
            };
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT, this.__takeOut);
        }

        protected function removeEvents():void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.startTween);
            if (this._countDownView)
            {
                this._countDownView.removeEventListener(Event.COMPLETE, this.__countDownComplete);
            };
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_TAKE_OUT, this.__takeOut);
            this._timerForView.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerForViewComplete);
        }

        protected function __countDownComplete(_arg_1:Event):void
        {
            this._onAllComplete++;
            if (this._countDownView)
            {
                this._countDownView.removeEventListener(Event.COMPLETE, this.__countDownComplete);
            };
            if ((!(this._canTakeOut)))
            {
                this._timerForView.start();
                return;
            };
            if (((!(this._selectCompleted)) && (this._canTakeOut)))
            {
                GameInSocketOut.sendBossTakeOut(SMALL_CARD_REQUEST_CARD);
                return;
            };
            if (this._onAllComplete == ON_ALL_COMPLETE_CNT)
            {
                this._timerForView.start();
            };
        }

        protected function __timerForViewComplete(_arg_1:*=null):void
        {
            if (this._gameInfo)
            {
                this._gameInfo.resetResultCard();
            };
            this._resultCards = null;
            this._timerForView.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerForViewComplete);
            if ((!(this._canTakeOut)))
            {
                dispatchEvent(new Event(Event.COMPLETE));
            };
            if (this._onAllComplete == ON_ALL_COMPLETE_CNT)
            {
                dispatchEvent(new Event(Event.COMPLETE));
            };
        }

        protected function createCards():void
        {
            var _local_3:Point;
            var _local_4:LuckyCard;
            var _local_1:Point = new Point(26, 15);
            var _local_2:int;
            while (_local_2 < this._cardCnt)
            {
                _local_3 = new Point();
                if ((((this._roomInfo.type == RoomInfo.DUNGEON_ROOM) || (this._roomInfo.type == RoomInfo.MULTI_DUNGEON)) || (this._roomInfo.type == RoomInfo.FRESHMAN_ROOM)))
                {
                    _local_4 = new LuckyCard(_local_2, LuckyCard.WITHIN_GAME_CARD);
                    _local_4.allowClick = (this._canTakeOut = (this._gameInfo.selfGamePlayer.BossCardCount > 0));
                }
                else
                {
                    _local_4 = new LuckyCard(_local_2, LuckyCard.AFTER_GAME_CARD);
                    _local_4.allowClick = (this._canTakeOut = (this._gameInfo.selfGamePlayer.GetCardCount > 0));
                };
                _local_3.x = (((_local_2 % this._cardColumns) * (_local_1.x + _local_4.width)) + 80);
                _local_3.y = ((int((_local_2 / this._cardColumns)) * (_local_1.y + _local_4.height)) + 38);
                _local_4.x = ((_local_1.x + _local_4.width) + 80);
                _local_4.y = ((_local_1.y + _local_4.height) + 38);
                _local_4.msg = LanguageMgr.GetTranslation("tank.gameover.DisableGetCard");
                addChild(_local_4);
                this._posArr.push(_local_3);
                this._cards.push(_local_4);
                _local_2++;
            };
        }

        protected function __takeOut(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_3:Boolean;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Player;
            if (this._cards.length > 0)
            {
                _local_2 = _arg_1.pkg;
                _local_3 = _local_2.readBoolean();
                _local_4 = _local_2.readByte();
                if (_local_4 == 50)
                {
                    return;
                };
                _local_5 = _local_2.readInt();
                _local_6 = _local_2.readInt();
                _local_7 = this._gameInfo.findPlayer(_local_2.extend1);
                if (_local_7)
                {
                    this._cards[_local_4].play(_local_7, _local_5, _local_6, false);
                    if (_local_7.isSelf)
                    {
                        this._onAllComplete++;
                        this._selectedCnt++;
                        this._selectCompleted = (this._selectedCnt >= SMALL_CARD_MAX_SELECTED_CNT);
                        if (this._selectCompleted)
                        {
                            this.__disabledAllCards();
                        };
                        if (this._onAllComplete == ON_ALL_COMPLETE_CNT)
                        {
                            this._timerForView.start();
                        };
                    };
                };
            }
            else
            {
                this._resultCards.push(_arg_1);
            };
        }

        protected function __disabledAllCards(_arg_1:Event=null):void
        {
            var _local_2:int;
            while (_local_2 < this._cards.length)
            {
                this._cards[_local_2].enabled = false;
                _local_2++;
            };
        }

        protected function startTween(_arg_1:Event=null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.startTween);
            var _local_2:int;
            while (_local_2 < SMALL_CARD_CNT)
            {
                TweenLite.to(this._cards[_local_2], 0.8, {
                    "startAt":{
                        "x":this._posArr[4].x,
                        "y":this._posArr[4].y
                    },
                    "x":this._posArr[_local_2].x,
                    "y":this._posArr[_local_2].y,
                    "ease":Quint.easeOut,
                    "onComplete":this.cardTweenComplete,
                    "onCompleteParams":[this._cards[_local_2]]
                });
                _local_2++;
            };
        }

        protected function cardTweenComplete(_arg_1:LuckyCard):void
        {
            TweenLite.killTweensOf(_arg_1);
            _arg_1.enabled = true;
        }

        public function dispose():void
        {
            var _local_1:LuckyCard;
            this.removeEvents();
            for each (_local_1 in this._cards)
            {
                _local_1.dispose();
            };
            ObjectUtils.disposeObject(this._countDownView);
            ObjectUtils.disposeObject(this._title);
            if (this._timerForView)
            {
                this._timerForView.stop();
                this._timerForView = null;
            };
            this._title = null;
            this._cards = null;
            this._posArr = null;
            this._gameInfo = null;
            this._roomInfo = null;
            this._resultCards = null;
            this._countDownView = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.card

