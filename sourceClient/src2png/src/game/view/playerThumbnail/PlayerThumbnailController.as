// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.playerThumbnail.PlayerThumbnailController

package game.view.playerThumbnail
{
    import flash.display.Sprite;
    import game.model.GameInfo;
    import road7th.data.DictionaryData;
    import game.model.Living;
    import game.model.Player;
    import room.model.RoomInfo;
    import game.objects.GameLiving;
    import road7th.data.DictionaryEvent;
    import ddt.events.GameEvent;

    public class PlayerThumbnailController extends Sprite 
    {

        private var _info:GameInfo;
        private var _team1:DictionaryData;
        private var _team2:DictionaryData;
        private var _isConsortion1:Boolean = true;
        private var _isConsortion2:Boolean = true;
        private var _consortionId1:Array;
        private var _consortionId2:Array;
        private var _list1:PlayerThumbnailList;
        private var _list2:PlayerThumbnailList;
        private var _bossThumbnailContainer:BossThumbnail;

        public function PlayerThumbnailController(_arg_1:GameInfo)
        {
            this._info = _arg_1;
            this._team1 = new DictionaryData();
            this._team2 = new DictionaryData();
            this._consortionId1 = new Array();
            this._consortionId2 = new Array();
            super();
            this.init();
            this.initEvents();
        }

        private function init():void
        {
            this.initInfo();
            this._list1 = new PlayerThumbnailList(this._team1, -1, this._isConsortion1);
            this._list2 = new PlayerThumbnailList(this._team2, 1, this._isConsortion2);
            addChild(this._list1);
            this._list1.x = 246;
            this._list2.x = 360;
            addChild(this._list2);
        }

        private function initInfo():void
        {
            var _local_4:Living;
            var _local_1:DictionaryData = this._info.livings;
            var _local_2:int = -1;
            var _local_3:int = -1;
            for each (_local_4 in _local_1)
            {
                if ((_local_4 is Player))
                {
                    if (((!(this._info.roomType == RoomInfo.MATCH_ROOM)) || ((_local_4 as Player).playerInfo.ConsortiaID == 0)))
                    {
                        this._isConsortion1 = false;
                        this._isConsortion2 = false;
                    };
                    if (_local_4.team == 1)
                    {
                        this._team1.add((_local_4 as Player).playerInfo.ID, _local_4);
                        if ((!(this._isConsortion1))) continue;
                        if (((!(_local_2 == (_local_4 as Player).playerInfo.ConsortiaID)) && (_local_2 == -1)))
                        {
                            this._isConsortion1 = false;
                            _local_2 = (_local_4 as Player).playerInfo.ConsortiaID;
                        }
                        else
                        {
                            if (_local_2 != (_local_4 as Player).playerInfo.ConsortiaID)
                            {
                                this._isConsortion1 = false;
                            }
                            else
                            {
                                this._isConsortion1 = true;
                            };
                        };
                    }
                    else
                    {
                        if (this._info.gameMode != 5)
                        {
                            this._team2.add((_local_4 as Player).playerInfo.ID, _local_4);
                            if (!(!(this._isConsortion2)))
                            {
                                if (((!(_local_3 == (_local_4 as Player).playerInfo.ConsortiaID)) && (_local_3 == -1)))
                                {
                                    this._isConsortion2 = false;
                                    _local_3 = (_local_4 as Player).playerInfo.ConsortiaID;
                                }
                                else
                                {
                                    if (_local_3 != (_local_4 as Player).playerInfo.ConsortiaID)
                                    {
                                        this._isConsortion2 = false;
                                    }
                                    else
                                    {
                                        this._isConsortion2 = true;
                                    };
                                };
                            };
                        };
                    };
                };
            };
        }

        public function set currentBoss(_arg_1:Living):void
        {
            this.removeThumbnailContainer();
            if (_arg_1 == null)
            {
                return;
            };
            this._bossThumbnailContainer = new BossThumbnail(_arg_1);
            this._bossThumbnailContainer.x = (this._list1.x + 110);
            this._bossThumbnailContainer.y = -10;
            addChild(this._bossThumbnailContainer);
        }

        public function removeThumbnailContainer():void
        {
            if (this._bossThumbnailContainer)
            {
                this._bossThumbnailContainer.dispose();
            };
            this._bossThumbnailContainer = null;
        }

        public function addLiving(_arg_1:GameLiving):void
        {
            if (((((_arg_1.info.typeLiving == 4) || (_arg_1.info.typeLiving == 5)) || (_arg_1.info.typeLiving == 6)) || (_arg_1.info.typeLiving == 12)))
            {
                if (this._info.gameMode != 5)
                {
                    this.currentBoss = _arg_1.info;
                };
            }
            else
            {
                if (((_arg_1.info.typeLiving == 1) || (_arg_1.info.typeLiving == 2)))
                {
                    this._team2.add(_arg_1.info.LivingID, _arg_1);
                };
            };
        }

        private function initEvents():void
        {
            this._info.livings.addEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            this._list1.addEventListener(GameEvent.WISH_SELECT, this.__thumbnailListHandle);
            this._list2.addEventListener(GameEvent.WISH_SELECT, this.__thumbnailListHandle);
        }

        private function removeEvents():void
        {
            this._info.livings.removeEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            this._list1.removeEventListener(GameEvent.WISH_SELECT, this.__thumbnailListHandle);
            this._list2.removeEventListener(GameEvent.WISH_SELECT, this.__thumbnailListHandle);
        }

        private function __thumbnailListHandle(_arg_1:GameEvent):void
        {
            dispatchEvent(new GameEvent(GameEvent.WISH_SELECT, _arg_1.data));
        }

        private function __removePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:Player = (_arg_1.data as Player);
            if (_local_2 == null)
            {
                return;
            };
            if (_local_2.character)
            {
                _local_2.character.resetShowBitmapBig();
            };
            if (((this._bossThumbnailContainer) && (this._bossThumbnailContainer.Id == _local_2.LivingID)))
            {
                this._bossThumbnailContainer.dispose();
                this._bossThumbnailContainer = null;
            }
            else
            {
                if (_local_2.team == 1)
                {
                    this._team1.remove((_arg_1.data as Player).playerInfo.ID);
                }
                else
                {
                    this._team2.remove((_arg_1.data as Player).playerInfo.ID);
                };
            };
        }

        public function dispose():void
        {
            this.removeEvents();
            if (parent)
            {
                parent.removeChild(this);
            };
            this._info = null;
            this._team1 = null;
            this._team2 = null;
            this._consortionId1 = null;
            this._consortionId2 = null;
            this._list1.dispose();
            this._list2.dispose();
            if (this._bossThumbnailContainer)
            {
                this._bossThumbnailContainer.dispose();
            };
            this._bossThumbnailContainer = null;
            this._list1 = null;
            this._list2 = null;
        }


    }
}//package game.view.playerThumbnail

