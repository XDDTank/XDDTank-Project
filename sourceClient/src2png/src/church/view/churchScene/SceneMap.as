// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.churchScene.SceneMap

package church.view.churchScene
{
    import flash.display.Sprite;
    import ddt.view.scenePathSearcher.SceneScene;
    import road7th.data.DictionaryData;
    import church.player.ChurchPlayer;
    import flash.display.MovieClip;
    import church.vo.SceneMapVO;
    import church.model.ChurchRoomModel;
    import com.pickgliss.utils.ClassUtils;
    import church.events.WeddingRoomEvent;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import road7th.data.DictionaryEvent;
    import flash.geom.Point;
    import flash.utils.getTimer;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import ddt.manager.SocketManager;
    import church.view.churchFire.ChurchFireEffectPlayer;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import church.vo.PlayerVO;
    import flash.display.DisplayObject;

    public class SceneMap extends Sprite 
    {

        public static const SCENE_ALLOW_FIRES:int = 6;

        private const CLICK_INTERVAL:Number = 200;

        protected var articleLayer:Sprite;
        protected var meshLayer:Sprite;
        protected var bgLayer:Sprite;
        protected var skyLayer:Sprite;
        public var sceneScene:SceneScene;
        protected var _data:DictionaryData;
        protected var _characters:DictionaryData;
        protected var _selfPlayer:ChurchPlayer;
        private var last_click:Number;
        private var current_display_fire:int = 0;
        private var _mouseMovie:MovieClip;
        private var _currentLoadingPlayer:ChurchPlayer;
        private var _isShowName:Boolean = true;
        private var _isChatBall:Boolean = true;
        private var _clickInterval:Number = 200;
        private var _lastClick:Number = 0;
        private var _sceneMapVO:SceneMapVO;
        private var _model:ChurchRoomModel;
        protected var reference:ChurchPlayer;

        public function SceneMap(_arg_1:ChurchRoomModel, _arg_2:SceneScene, _arg_3:DictionaryData, _arg_4:Sprite, _arg_5:Sprite, _arg_6:Sprite=null, _arg_7:Sprite=null)
        {
            this._model = _arg_1;
            this.sceneScene = _arg_2;
            this._data = _arg_3;
            if (_arg_4 == null)
            {
                this.bgLayer = new Sprite();
            }
            else
            {
                this.bgLayer = _arg_4;
            };
            this.meshLayer = ((_arg_5 == null) ? new Sprite() : _arg_5);
            this.meshLayer.alpha = 0;
            this.articleLayer = ((_arg_6 == null) ? new Sprite() : _arg_6);
            this.skyLayer = ((_arg_7 == null) ? new Sprite() : _arg_7);
            this.addChild(this.meshLayer);
            this.addChild(this.bgLayer);
            this.addChild(this.articleLayer);
            this.addChild(this.skyLayer);
            this.init();
            this.addEvent();
        }

        public function get sceneMapVO():SceneMapVO
        {
            return (this._sceneMapVO);
        }

        public function set sceneMapVO(_arg_1:SceneMapVO):void
        {
            this._sceneMapVO = _arg_1;
        }

        protected function init():void
        {
            this._characters = new DictionaryData(true);
            var _local_1:Class = (ClassUtils.uiSourceDomain.getDefinition("asset.church.room.MouseClickMovie") as Class);
            this._mouseMovie = (new (_local_1)() as MovieClip);
            this._mouseMovie.mouseChildren = false;
            this._mouseMovie.mouseEnabled = false;
            this._mouseMovie.stop();
            this.bgLayer.addChild(this._mouseMovie);
            this.last_click = 0;
        }

        protected function addEvent():void
        {
            this._model.addEventListener(WeddingRoomEvent.PLAYER_NAME_VISIBLE, this.menuChange);
            this._model.addEventListener(WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE, this.menuChange);
            this._model.addEventListener(WeddingRoomEvent.PLAYER_FIRE_VISIBLE, this.menuChange);
            addEventListener(MouseEvent.CLICK, this.__click);
            addEventListener(Event.ENTER_FRAME, this.updateMap);
            this._data.addEventListener(DictionaryEvent.ADD, this.__addPlayer);
            this._data.addEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
        }

        private function menuChange(_arg_1:WeddingRoomEvent):void
        {
            switch (_arg_1.type)
            {
                case WeddingRoomEvent.PLAYER_NAME_VISIBLE:
                    this.nameVisible();
                    return;
                case WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE:
                    this.chatBallVisible();
                    return;
                case WeddingRoomEvent.PLAYER_FIRE_VISIBLE:
                    this.fireVisible();
                    return;
            };
        }

        public function nameVisible():void
        {
            var _local_1:ChurchPlayer;
            for each (_local_1 in this._characters)
            {
                _local_1.isShowName = this._model.playerNameVisible;
            };
        }

        public function chatBallVisible():void
        {
            var _local_1:ChurchPlayer;
            for each (_local_1 in this._characters)
            {
                _local_1.isChatBall = this._model.playerChatBallVisible;
            };
        }

        public function fireVisible():void
        {
        }

        protected function updateMap(_arg_1:Event):void
        {
            var _local_2:ChurchPlayer;
            if (((!(this._characters)) || (this._characters.length <= 0)))
            {
                return;
            };
            for each (_local_2 in this._characters)
            {
                _local_2.updatePlayer();
                _local_2.isChatBall = this._model.playerChatBallVisible;
                _local_2.isShowName = this._model.playerNameVisible;
            };
            this.BuildEntityDepth();
        }

        protected function __click(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            if ((!(this._selfPlayer)))
            {
                return;
            };
            _local_2 = this.globalToLocal(new Point(_arg_1.stageX, _arg_1.stageY));
            if ((getTimer() - this._lastClick) > this._clickInterval)
            {
                this._lastClick = getTimer();
                if ((!(this.sceneScene.hit(_local_2))))
                {
                    this._selfPlayer.playerVO.walkPath = this.sceneScene.searchPath(this._selfPlayer.playerPoint, _local_2);
                    this._selfPlayer.playerVO.walkPath.shift();
                    this._selfPlayer.playerVO.scenePlayerDirection = SceneCharacterDirection.getDirection(this._selfPlayer.playerPoint, this._selfPlayer.playerVO.walkPath[0]);
                    this._selfPlayer.playerVO.currentWalkStartPoint = this._selfPlayer.currentWalkStartPoint;
                    this.sendMyPosition(this._selfPlayer.playerVO.walkPath.concat());
                    this._mouseMovie.x = _local_2.x;
                    this._mouseMovie.y = _local_2.y;
                    this._mouseMovie.play();
                };
            };
        }

        public function sendMyPosition(_arg_1:Array):void
        {
            var _local_3:uint;
            var _local_2:Array = [];
            while (_local_3 < _arg_1.length)
            {
                _local_2.push(int(_arg_1[_local_3].x), int(_arg_1[_local_3].y));
                _local_3++;
            };
            var _local_4:String = _local_2.toString();
            SocketManager.Instance.out.sendChurchMove(_arg_1[(_arg_1.length - 1)].x, _arg_1[(_arg_1.length - 1)].y, _local_4);
        }

        public function useFire(_arg_1:int, _arg_2:int):void
        {
            var _local_3:ChurchFireEffectPlayer;
            if (this._characters[_arg_1] == null)
            {
                return;
            };
            if (this._characters[_arg_1])
            {
                if (_arg_1 == PlayerManager.Instance.Self.ID)
                {
                    this._model.fireEnable = false;
                    if ((!(this._model.playerFireVisible)))
                    {
                        MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.scene.SceneMap.lihua"));
                    };
                };
                _local_3 = new ChurchFireEffectPlayer(_arg_2);
                _local_3.addEventListener(Event.COMPLETE, this.fireCompleteHandler);
                _local_3.owerID = _arg_1;
                if (this._model.playerFireVisible)
                {
                    _local_3.x = (this._characters[_arg_1] as ChurchPlayer).x;
                    _local_3.y = ((this._characters[_arg_1] as ChurchPlayer).y - 190);
                    addChild(_local_3);
                };
                _local_3.firePlayer();
            };
        }

        protected function fireCompleteHandler(_arg_1:Event):void
        {
            var _local_2:ChurchFireEffectPlayer = (_arg_1.currentTarget as ChurchFireEffectPlayer);
            _local_2.removeEventListener(Event.COMPLETE, this.fireCompleteHandler);
            if (_local_2.owerID == PlayerManager.Instance.Self.ID)
            {
                this._model.fireEnable = true;
            };
            if (_local_2.parent)
            {
                _local_2.parent.removeChild(_local_2);
            };
            _local_2.dispose();
            _local_2 = null;
        }

        public function movePlayer(_arg_1:int, _arg_2:Array):void
        {
            var _local_3:ChurchPlayer;
            if (this._characters[_arg_1])
            {
                _local_3 = (this._characters[_arg_1] as ChurchPlayer);
                _local_3.playerVO.walkPath = _arg_2;
                _local_3.playerWalk(_arg_2);
            };
        }

        public function setCenter(_arg_1:SceneCharacterEvent=null):void
        {
            var _local_2:Number;
            var _local_3:Number;
            if (this.reference)
            {
                _local_2 = -(this.reference.x - (MoonSceneMap.GAME_WIDTH / 2));
                _local_3 = (-(this.reference.y - (MoonSceneMap.GAME_HEIGHT / 2)) + 50);
            }
            else
            {
                _local_2 = -(this._sceneMapVO.defaultPos.x - (MoonSceneMap.GAME_WIDTH / 2));
                _local_3 = (-(this._sceneMapVO.defaultPos.y - (MoonSceneMap.GAME_HEIGHT / 2)) + 50);
            };
            if (_local_2 > 0)
            {
                _local_2 = 0;
            };
            if (_local_2 < (MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW))
            {
                _local_2 = (MoonSceneMap.GAME_WIDTH - this._sceneMapVO.mapW);
            };
            if (_local_3 > 0)
            {
                _local_3 = 0;
            };
            if (_local_3 < (MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH))
            {
                _local_3 = (MoonSceneMap.GAME_HEIGHT - this._sceneMapVO.mapH);
            };
            x = _local_2;
            y = _local_3;
        }

        public function addSelfPlayer():void
        {
            var _local_1:PlayerVO;
            if ((!(this._selfPlayer)))
            {
                _local_1 = new PlayerVO();
                _local_1.playerInfo = PlayerManager.Instance.Self;
                this._currentLoadingPlayer = new ChurchPlayer(_local_1, this.addPlayerCallBack);
            };
        }

        protected function ajustScreen(_arg_1:ChurchPlayer):void
        {
            if (_arg_1 == null)
            {
                if (this.reference)
                {
                    this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
                    this.reference = null;
                };
                return;
            };
            if (this.reference)
            {
                this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
            };
            this.reference = _arg_1;
            this.reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
        }

        protected function __addPlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:PlayerVO = (_arg_1.data as PlayerVO);
            this._currentLoadingPlayer = new ChurchPlayer(_local_2, this.addPlayerCallBack);
        }

        private function addPlayerCallBack(_arg_1:ChurchPlayer, _arg_2:Boolean):void
        {
            if (((!(this.articleLayer)) || (!(_arg_1))))
            {
                return;
            };
            this._currentLoadingPlayer = null;
            _arg_1.sceneScene = this.sceneScene;
            _arg_1.setSceneCharacterDirectionDefault = (_arg_1.sceneCharacterDirection = _arg_1.playerVO.scenePlayerDirection);
            if (((!(this._selfPlayer)) && (_arg_1.playerVO.playerInfo.ID == PlayerManager.Instance.Self.ID)))
            {
                _arg_1.playerVO.playerPos = this._sceneMapVO.defaultPos;
                this._selfPlayer = _arg_1;
                this.articleLayer.addChild(this._selfPlayer);
                this.ajustScreen(this._selfPlayer);
                this.setCenter();
                this._selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
            }
            else
            {
                this.articleLayer.addChild(_arg_1);
            };
            _arg_1.playerPoint = _arg_1.playerVO.playerPos;
            _arg_1.sceneCharacterStateType = "natural";
            this._characters.add(_arg_1.playerVO.playerInfo.ID, _arg_1);
            _arg_1.isShowName = this._model.playerNameVisible;
            _arg_1.isChatBall = this._model.playerChatBallVisible;
        }

        private function playerActionChange(_arg_1:SceneCharacterEvent):void
        {
            var _local_2:String = _arg_1.data.toString();
            if (((_local_2 == "naturalStandFront") || (_local_2 == "naturalStandBack")))
            {
                this._mouseMovie.gotoAndStop(1);
            };
        }

        protected function __removePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:int = (_arg_1.data as PlayerVO).playerInfo.ID;
            var _local_3:ChurchPlayer = (this._characters[_local_2] as ChurchPlayer);
            this._characters.remove(_local_2);
            if (_local_3)
            {
                if (_local_3.parent)
                {
                    _local_3.parent.removeChild(_local_3);
                };
                _local_3.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
                _local_3.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
                _local_3.dispose();
            };
            _local_3 = null;
        }

        protected function BuildEntityDepth():void
        {
            var _local_3:DisplayObject;
            var _local_4:Number;
            var _local_5:int;
            var _local_6:Number;
            var _local_7:int;
            var _local_8:DisplayObject;
            var _local_9:Number;
            var _local_1:int = this.articleLayer.numChildren;
            var _local_2:int;
            while (_local_2 < (_local_1 - 1))
            {
                _local_3 = this.articleLayer.getChildAt(_local_2);
                _local_4 = this.getPointDepth(_local_3.x, _local_3.y);
                _local_6 = Number.MAX_VALUE;
                _local_7 = (_local_2 + 1);
                while (_local_7 < _local_1)
                {
                    _local_8 = this.articleLayer.getChildAt(_local_7);
                    _local_9 = this.getPointDepth(_local_8.x, _local_8.y);
                    if (_local_9 < _local_6)
                    {
                        _local_5 = _local_7;
                        _local_6 = _local_9;
                    };
                    _local_7++;
                };
                if (_local_4 > _local_6)
                {
                    this.articleLayer.swapChildrenAt(_local_2, _local_5);
                };
                _local_2++;
            };
        }

        protected function getPointDepth(_arg_1:Number, _arg_2:Number):Number
        {
            return ((this.sceneMapVO.mapW * _arg_2) + _arg_1);
        }

        public function setSalute(_arg_1:int):void
        {
        }

        protected function removeEvent():void
        {
            this._model.removeEventListener(WeddingRoomEvent.PLAYER_NAME_VISIBLE, this.menuChange);
            this._model.removeEventListener(WeddingRoomEvent.PLAYER_CHATBALL_VISIBLE, this.menuChange);
            this._model.removeEventListener(WeddingRoomEvent.PLAYER_FIRE_VISIBLE, this.menuChange);
            removeEventListener(MouseEvent.CLICK, this.__click);
            removeEventListener(Event.ENTER_FRAME, this.updateMap);
            this._data.removeEventListener(DictionaryEvent.ADD, this.__addPlayer);
            this._data.removeEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            if (this.reference)
            {
                this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
            };
            if (this._selfPlayer)
            {
                this._selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
            };
        }

        public function dispose():void
        {
            var p:ChurchPlayer;
            var i:int;
            var player:ChurchPlayer;
            this.removeEvent();
            this._data.clear();
            this._data = null;
            this._sceneMapVO = null;
            for each (p in this._characters)
            {
                if (p.parent)
                {
                    p.parent.removeChild(p);
                };
                p.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
                p.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
                p.dispose();
                p = null;
            };
            this._characters.clear();
            this._characters = null;
            if (this.articleLayer)
            {
                i = this.articleLayer.numChildren;
                while (i > 0)
                {
                    player = (this.articleLayer.getChildAt((i - 1)) as ChurchPlayer);
                    if (player)
                    {
                        player.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
                        player.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
                        if (player.parent)
                        {
                            player.parent.removeChild(player);
                        };
                        player.dispose();
                    };
                    player = null;
                    try
                    {
                        this.articleLayer.removeChildAt((i - 1));
                    }
                    catch(e:RangeError)
                    {
                    };
                    i = (i - 1);
                };
                if (((this.articleLayer) && (this.articleLayer.parent)))
                {
                    this.articleLayer.parent.removeChild(this.articleLayer);
                };
            };
            this.articleLayer = null;
            if (this._selfPlayer)
            {
                if (this._selfPlayer.parent)
                {
                    this._selfPlayer.parent.removeChild(this._selfPlayer);
                };
                this._selfPlayer.dispose();
            };
            this._selfPlayer = null;
            if (this._currentLoadingPlayer)
            {
                if (this._currentLoadingPlayer.parent)
                {
                    this._currentLoadingPlayer.parent.removeChild(this._currentLoadingPlayer);
                };
                this._currentLoadingPlayer.dispose();
            };
            this._currentLoadingPlayer = null;
            if (((this._mouseMovie) && (this._mouseMovie.parent)))
            {
                this._mouseMovie.parent.removeChild(this._mouseMovie);
            };
            this._mouseMovie = null;
            if (((this.meshLayer) && (this.meshLayer.parent)))
            {
                this.meshLayer.parent.removeChild(this.meshLayer);
            };
            this.meshLayer = null;
            if (((this.bgLayer) && (this.bgLayer.parent)))
            {
                this.bgLayer.parent.removeChild(this.bgLayer);
            };
            this.bgLayer = null;
            if (((this.skyLayer) && (this.skyLayer.parent)))
            {
                this.skyLayer.parent.removeChild(this.skyLayer);
            };
            this.skyLayer = null;
            this.sceneScene = null;
            if (parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package church.view.churchScene

