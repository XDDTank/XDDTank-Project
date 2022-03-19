// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.playerThumbnail.PlayerThumbnailList

package game.view.playerThumbnail
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import road7th.data.DictionaryData;
    import ddt.view.tips.PlayerThumbnailTip;
    import ddt.events.GameEvent;
    import flash.events.Event;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.utils.PositionUtils;
    import flash.geom.Point;
    import com.pickgliss.ui.LayerManager;
    import flash.display.DisplayObject;
    import road7th.data.DictionaryEvent;
    import game.model.Player;

    public class PlayerThumbnailList extends Sprite implements Disposeable 
    {

        private var _info:DictionaryData;
        private var _players:DictionaryData;
        private var _dirct:int;
        private var _isConsortionType:Boolean;
        private var _thumbnailTip:PlayerThumbnailTip;

        public function PlayerThumbnailList(_arg_1:DictionaryData, _arg_2:int=1, _arg_3:Boolean=true)
        {
            this._dirct = _arg_2;
            this._info = _arg_1;
            this._isConsortionType = _arg_3;
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_1:int;
            var _local_2:String;
            var _local_3:PlayerThumbnail;
            this._players = new DictionaryData();
            if (this._info)
            {
                _local_1 = 0;
                for (_local_2 in this._info)
                {
                    _local_3 = new PlayerThumbnail(this._info[_local_2], this._dirct, this._isConsortionType);
                    _local_3.addEventListener("playerThumbnailEvent", this.__onTipClick);
                    _local_3.addEventListener(GameEvent.WISH_SELECT, this.__thumbnailHandle);
                    this._players.add(_local_2, _local_3);
                    addChild(_local_3);
                };
            };
            this.arrange();
        }

        private function __onTipClick(e:Event):void
        {
            var __addTip:Function;
            __addTip = function (_arg_1:Event):void
            {
                if ((_arg_1.currentTarget as PlayerThumbnailTip).tipDisplay)
                {
                    (_arg_1.currentTarget as PlayerThumbnailTip).tipDisplay.recoverTip();
                };
            };
            this._thumbnailTip = (ShowTipManager.Instance.getTipInstanceByStylename("ddt.view.tips.PlayerThumbnailTip") as PlayerThumbnailTip);
            if (this._thumbnailTip == null)
            {
                this._thumbnailTip = ShowTipManager.Instance.createTipByStyleName("ddt.view.tips.PlayerThumbnailTip");
                this._thumbnailTip.addEventListener("playerThumbnailTipItemClick", __addTip);
            };
            this._thumbnailTip.tipDisplay = (e.currentTarget as PlayerThumbnail);
            this._thumbnailTip.x = this.mouseX;
            this._thumbnailTip.y = ((e.currentTarget.height + e.currentTarget.y) + 12);
            PositionUtils.setPos(this._thumbnailTip, localToGlobal(new Point(this._thumbnailTip.x, this._thumbnailTip.y)));
            LayerManager.Instance.addToLayer(this._thumbnailTip, LayerManager.GAME_DYNAMIC_LAYER, false);
        }

        private function __thumbnailHandle(_arg_1:GameEvent):void
        {
            dispatchEvent(new GameEvent(GameEvent.WISH_SELECT, _arg_1.data));
        }

        private function arrange():void
        {
            var _local_2:DisplayObject;
            var _local_1:int;
            while (_local_1 < numChildren)
            {
                _local_2 = getChildAt(_local_1);
                if (this._dirct < 0)
                {
                    _local_2.x = (((_local_1 + 1) * (_local_2.width + 4)) * this._dirct);
                }
                else
                {
                    _local_2.x = ((_local_1 * (_local_2.width + 4)) * this._dirct);
                };
                _local_1++;
            };
        }

        private function initEvents():void
        {
            this._info.addEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            this._info.addEventListener(DictionaryEvent.ADD, this.__addLiving);
        }

        private function removeEvents():void
        {
            this._info.removeEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            this._info.removeEventListener(DictionaryEvent.ADD, this.__addLiving);
        }

        private function __addLiving(_arg_1:DictionaryEvent):void
        {
        }

        public function __removePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:Player = (_arg_1.data as Player);
            if (((_local_2) && (_local_2.playerInfo)))
            {
                if (this._players[_local_2.playerInfo.ID])
                {
                    this._players[_local_2.playerInfo.ID].removeEventListener("playerThumbnailEvent", this.__onTipClick);
                    this._players[_local_2.playerInfo.ID].removeEventListener(GameEvent.WISH_SELECT, this.__thumbnailHandle);
                    this._players[_local_2.playerInfo.ID].dispose();
                    delete this._players[_local_2.playerInfo.ID];
                };
            };
        }

        public function dispose():void
        {
            var _local_1:String;
            this.removeEvents();
            for (_local_1 in this._players)
            {
                if (this._players[_local_1])
                {
                    this._players[_local_1].removeEventListener("playerThumbnailEvent", this.__onTipClick);
                    this._players[_local_1].removeEventListener(GameEvent.WISH_SELECT, this.__thumbnailHandle);
                    this._players[_local_1].dispose();
                };
            };
            this._players = null;
            if (this._thumbnailTip)
            {
                this._thumbnailTip.tipDisplay = null;
            };
            this._thumbnailTip = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.playerThumbnail

