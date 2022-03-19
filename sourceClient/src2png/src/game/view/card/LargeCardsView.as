// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.card.LargeCardsView

package game.view.card
{
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import room.RoomManager;
    import road7th.comm.PackageIn;
    import game.model.Player;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import com.pickgliss.ui.LayerManager;
    import flash.geom.Point;
    import ddt.manager.LanguageMgr;
    import com.greensock.TweenLite;
    import com.greensock.easing.Quint;
    import ddt.manager.GameInSocketOut;
    import com.pickgliss.utils.ObjectUtils;

    public class LargeCardsView extends SmallCardsView 
    {

        public static const LARGE_CARD_TIME:uint = 15;
        public static const LARGE_CARD_CNT:uint = 21;
        public static const LARGE_CARD_COLUMNS:uint = 7;
        public static const LARGE_CARD_VIEW_TIME:uint = 1;

        private var _systemToken:Boolean;
        private var _showCardInfos:Array;
        private var _instructionTxt:Bitmap;
        protected var _cardGetNote:DisplayObject;


        override protected function init():void
        {
            _countDownTime = LARGE_CARD_TIME;
            _cardCnt = LARGE_CARD_CNT;
            _cardColumns = LARGE_CARD_COLUMNS;
            _viewTime = LARGE_CARD_VIEW_TIME;
            super.init();
            PositionUtils.setPos(_title, "takeoutCard.LargeCardViewTitlePos");
            PositionUtils.setPos(_countDownView, "takeoutCard.LargeCardViewCountDownPos");
            this._instructionTxt = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.InstructionBitmap");
            addChild(this._instructionTxt);
            if (_gameInfo.selfGamePlayer.hasGardGet)
            {
                this.drawCardGetNote();
            };
        }

        private function drawCardGetNote():void
        {
            this._cardGetNote = addChild(ComponentFactory.Instance.creat("asset.core.payBuffAsset73.note"));
            PositionUtils.setPos(this._cardGetNote, "takeoutCard.LargeCardView.CardGetNotePos");
        }

        override protected function initEvent():void
        {
            super.initEvent();
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.SHOW_CARDS, this.__showAllCard);
            RoomManager.Instance.addEventListener(RoomManager.PAYMENT_TAKE_CARD, __disabledAllCards);
        }

        override protected function __takeOut(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn;
            var _local_3:Boolean;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:int;
            var _local_7:Boolean;
            var _local_8:Player;
            if (_cards.length > 0)
            {
                _local_2 = _arg_1.pkg;
                _local_3 = _local_2.readBoolean();
                if (((!(this._systemToken)) && (_local_3)))
                {
                    this._systemToken = true;
                    __disabledAllCards();
                };
                _local_4 = _local_2.readByte();
                if (_local_4 == 50)
                {
                    return;
                };
                _local_5 = _local_2.readInt();
                _local_6 = _local_2.readInt();
                _local_7 = _local_2.readBoolean();
                _local_8 = _gameInfo.findPlayer(_local_2.extend1);
                if (_local_2.clientId == _gameInfo.selfGamePlayer.playerInfo.ID)
                {
                    _local_8 = _gameInfo.selfGamePlayer;
                };
                if (_local_8)
                {
                    _cards[_local_4].play(_local_8, _local_5, _local_6, _local_7);
                    if (_local_8.isSelf)
                    {
                        _selectedCnt++;
                        _selectCompleted = (_selectedCnt >= _local_8.GetCardCount);
                        if (_selectedCnt == 2)
                        {
                            this.changeCardsToPayType();
                        };
                        if (_selectedCnt >= 3)
                        {
                            __disabledAllCards();
                            return;
                        };
                    };
                };
                if (_local_3)
                {
                    this.showAllCard();
                };
            }
            else
            {
                _resultCards.push(_arg_1);
            };
        }

        private function changeCardsToPayType():void
        {
            var _local_1:int;
            while (_local_1 < _cards.length)
            {
                _cards[_local_1].isPayed = true;
                _local_1++;
            };
        }

        private function __showAllCard(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:Object;
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            this._showCardInfos = [];
            var _local_4:uint;
            while (_local_4 < _local_3)
            {
                _local_5 = new Object();
                _local_5.index = _local_2.readByte();
                _local_5.templateID = _local_2.readInt();
                _local_5.count = _local_2.readInt();
                this._showCardInfos.push(_local_5);
                _local_4++;
            };
            this.showAllCard();
        }

        override protected function __timerForViewComplete(_arg_1:*=null):void
        {
            _timerForView.removeEventListener(TimerEvent.TIMER_COMPLETE, this.__timerForViewComplete);
            if (_gameInfo)
            {
                _gameInfo.resetResultCard();
            };
            _resultCards = null;
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function showAllCard():void
        {
            var _local_1:uint;
            LayerManager.Instance.clearnGameDynamic();
            if (((this._showCardInfos) && (this._showCardInfos.length > 0)))
            {
                _local_1 = 0;
                while (_local_1 < this._showCardInfos.length)
                {
                    _cards[uint(this._showCardInfos[_local_1].index)].play(null, int(this._showCardInfos[_local_1].templateID), this._showCardInfos[_local_1].count, false);
                    _local_1++;
                };
            };
            _timerForView.reset();
            _timerForView.start();
        }

        override protected function createCards():void
        {
            var _local_3:Point;
            var _local_4:LuckyCard;
            var _local_1:Point = new Point(18, 15);
            var _local_2:int;
            while (_local_2 < _cardCnt)
            {
                _local_3 = new Point();
                _local_4 = new LuckyCard(_local_2, LuckyCard.AFTER_GAME_CARD);
                _local_3.x = ((_local_2 % _cardColumns) * (_local_1.x + _local_4.width));
                _local_3.y = (int((_local_2 / _cardColumns)) * (_local_1.y + _local_4.height));
                _local_4.x = ((_local_1.x + _local_4.width) * 3);
                _local_4.y = (_local_1.y + _local_4.height);
                _local_4.allowClick = (_gameInfo.selfGamePlayer.GetCardCount > 0);
                _local_4.msg = LanguageMgr.GetTranslation("tank.gameover.DisableGetCard");
                addChild(_local_4);
                _posArr.push(_local_3);
                _cards.push(_local_4);
                _local_2++;
            };
        }

        override protected function startTween(_arg_1:Event=null):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.startTween);
            var _local_2:int;
            while (_local_2 < LARGE_CARD_CNT)
            {
                TweenLite.to(_cards[_local_2], 0.8, {
                    "startAt":{
                        "x":_posArr[10].x,
                        "y":_posArr[10].y
                    },
                    "x":_posArr[_local_2].x,
                    "y":_posArr[_local_2].y,
                    "ease":Quint.easeOut,
                    "onComplete":cardTweenComplete,
                    "onCompleteParams":[_cards[_local_2]]
                });
                _local_2++;
            };
        }

        override protected function __countDownComplete(_arg_1:Event):void
        {
            _countDownView.removeEventListener(Event.COMPLETE, this.__countDownComplete);
            GameInSocketOut.sendGameTakeOut(100);
            __disabledAllCards();
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._cardGetNote);
            this._cardGetNote = null;
            this._showCardInfos = null;
            ObjectUtils.disposeObject(this._instructionTxt);
            this._instructionTxt = null;
            super.dispose();
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.SHOW_CARDS, this.__showAllCard);
            RoomManager.Instance.removeEventListener(RoomManager.PAYMENT_TAKE_CARD, __disabledAllCards);
        }


    }
}//package game.view.card

