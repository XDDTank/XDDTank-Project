// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//arena.view.ArenaStateObjectView

package arena.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.view.scenePathSearcher.SceneScene;
    import flash.display.MovieClip;
    import arena.object.ArenaScenePlayer;
    import road7th.data.DictionaryData;
    import arena.model.ArenaScenePlayerInfo;
    import flash.geom.Point;
    import arena.ArenaManager;
    import ddt.manager.PlayerManager;
    import arena.model.ArenaPlayerStates;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.scenePathSearcher.PathMapHitTester;
    import road7th.data.DictionaryEvent;
    import arena.model.ArenaEvent;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import church.view.churchScene.MoonSceneMap;
    import church.vo.SceneMapVO;

    public class ArenaStateObjectView extends Sprite implements Disposeable 
    {

        public static const MAP_SIZE:Array = [3208, 2000];

        private var _sceneScene:SceneScene;
        private var _mapLayer:Sprite;
        private var _playerLayer:Sprite;
        private var _maskLayer:Sprite;
        private var _mouseMovie:MovieClip;
        private var _currentLoadingPlayer:ArenaScenePlayer;
        private var _selfPlayer:ArenaScenePlayer;
        private var _playerDic:DictionaryData;
        private var _loadingPlayerInfo:ArenaScenePlayerInfo;
        private var _lastPoint:Point = new Point();
        private var _initPlayer:ArenaScenePlayer;
        protected var _reference:ArenaScenePlayer;

        public function ArenaStateObjectView()
        {
            this._playerDic = new DictionaryData();
            this._sceneScene = new SceneScene();
            this._mapLayer = new Sprite();
            addChild(this._mapLayer);
            this._playerLayer = new Sprite();
            this._playerLayer.mouseChildren = true;
            this._playerLayer.mouseEnabled = true;
            addChild(this._playerLayer);
            this._maskLayer = new Sprite();
            this._maskLayer.mouseEnabled = false;
            this._maskLayer.mouseChildren = false;
            addChild(this._maskLayer);
            this.initView();
            this.initEvent();
            this.addSelfPlayer();
        }

        public function update():void
        {
            var _local_1:ArenaScenePlayer;
            if ((!(this._loadingPlayerInfo)))
            {
                this._loadingPlayerInfo = this.getLoadPlayerInfo();
            };
            this.initPlayer();
            for each (_local_1 in this._playerDic)
            {
                if (ArenaManager.instance.model.playerDic.hasKey(_local_1.playerInfo.ID))
                {
                    _local_1.updatePlayer();
                }
                else
                {
                    if (((_local_1.defaultBody) && (this._playerLayer.contains(_local_1.defaultBody))))
                    {
                        this._playerLayer.removeChild(_local_1.defaultBody);
                    };
                    if (this._playerLayer.contains(_local_1))
                    {
                        this._playerLayer.removeChild(_local_1);
                    };
                    this._playerDic.remove(_local_1.playerInfo.ID);
                    _local_1 = null;
                };
            };
            this.checkHit();
            this.updatePlayerLevel();
        }

        private function getLoadPlayerInfo():ArenaScenePlayerInfo
        {
            var _local_1:ArenaScenePlayerInfo;
            var _local_3:ArenaScenePlayerInfo;
            var _local_2:DictionaryData = ArenaManager.instance.model.playerDic;
            for each (_local_3 in _local_2)
            {
                if (_local_3.playerInfo.ID != PlayerManager.Instance.Self.ID)
                {
                    if (!this._playerDic.hasKey(_local_3.playerInfo.ID))
                    {
                        _local_1 = _local_2[_local_3.playerInfo.ID];
                        break;
                    };
                };
            };
            return (_local_1);
        }

        private function checkHit():void
        {
            var _local_1:ArenaScenePlayer = ArenaManager.instance.model.targetPlayer;
            if (_local_1 != null)
            {
                if (((this.selfPlayer) && (this.selfPlayer.hitTestObject(_local_1))))
                {
                    this.selfPlayer.fight(_local_1);
                    ArenaManager.instance.model.targetPlayer = null;
                };
            };
        }

        public function set selfPlayer(_arg_1:ArenaScenePlayer):void
        {
            this._selfPlayer = _arg_1;
        }

        public function get selfPlayer():ArenaScenePlayer
        {
            return (this._selfPlayer);
        }

        public function moveTo(_arg_1:Point):void
        {
            if (((!(this._sceneScene.hit(_arg_1))) && (this.selfPlayer)))
            {
                if (_arg_1.x != this._lastPoint.x)
                {
                    this.playerMove(this.selfPlayer.playerPoint, _arg_1);
                    this._lastPoint = _arg_1;
                };
            };
        }

        private function playerMove(_arg_1:Point, _arg_2:Point):void
        {
            if (((this.selfPlayer.arenaPlayerInfo.playerStauts == ArenaPlayerStates.NORMAL) || (this.selfPlayer.arenaPlayerInfo.playerStauts == ArenaPlayerStates.INVINSIBLE)))
            {
                this.selfPlayer.scenePlayerInfo.walkPath = this._sceneScene.searchPath(_arg_1, _arg_2);
                this.selfPlayer.scenePlayerInfo.walkPath.shift();
                this.selfPlayer.scenePlayerInfo.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint, this.selfPlayer.scenePlayerInfo.walkPath[0]);
                this.selfPlayer.scenePlayerInfo.currenWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
                this.sendMyPosition(this.selfPlayer.scenePlayerInfo.walkPath.concat());
                this._mouseMovie.x = _arg_2.x;
                this._mouseMovie.y = _arg_2.y;
                this._mouseMovie.play();
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
            ArenaManager.instance.sendMove(_arg_1[(_arg_1.length - 1)].x, _arg_1[(_arg_1.length - 1)].y, _local_4);
        }

        private function initView():void
        {
            var _local_2:Sprite;
            var _local_3:Sprite;
            var _local_4:MovieClip;
            var _local_5:MovieClip;
            var _local_1:MovieClip = (ComponentFactory.Instance.creat("arena.scene.mapMc") as MovieClip);
            _local_2 = (_local_1.getChildByName("mesh") as Sprite);
            _local_3 = (_local_1.getChildByName("bg") as Sprite);
            _local_4 = (_local_1.getChildByName("plantArea") as MovieClip);
            _local_5 = (_local_1.getChildByName("plantArea") as MovieClip);
            _local_5.alpha = 0.5;
            this._mouseMovie = (ComponentFactory.Instance.creat("asset.walkScene.MouseClickMovie") as MovieClip);
            this._mouseMovie.mouseChildren = false;
            this._mouseMovie.mouseEnabled = false;
            this._mouseMovie.stop();
            this._mapLayer.addChild(_local_3);
            this._mapLayer.addChild(_local_2);
            this._mapLayer.addChild(this._mouseMovie);
            this._mapLayer.addChild(_local_4);
            _local_2.alpha = 0;
            this._maskLayer.addChild(_local_5);
            this._sceneScene.setHitTester(new PathMapHitTester(_local_2));
        }

        private function initEvent():void
        {
            ArenaManager.instance.model.playerDic.addEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            ArenaManager.instance.model.playerDic.addEventListener(DictionaryEvent.UPDATE, this.__updatePlayer);
            ArenaManager.instance.model.addEventListener(ArenaEvent.UPDATE_SELF, this.__updateSelf);
            addEventListener(MouseEvent.CLICK, this.__mouseClick);
        }

        protected function __mouseClick(_arg_1:MouseEvent):void
        {
            if (Mouse.cursor == MouseCursor.BUTTON)
            {
                return;
            };
            var _local_2:Point = new Point(_arg_1.stageX, _arg_1.stageY);
            var _local_3:Point = globalToLocal(_local_2);
            this.moveTo(_local_3);
            if ((!(_arg_1.target as ArenaScenePlayer)))
            {
                ArenaManager.instance.model.targetPlayer = null;
            };
        }

        private function updatePlayerLevel():void
        {
            var _local_3:DisplayObject;
            var _local_4:int;
            var _local_5:DisplayObject;
            var _local_1:int = this._playerLayer.numChildren;
            var _local_2:int;
            while (_local_2 < (_local_1 - 1))
            {
                _local_3 = this._playerLayer.getChildAt(_local_2);
                _local_4 = (_local_2 + 1);
                while (_local_4 < _local_1)
                {
                    _local_5 = this._playerLayer.getChildAt(_local_4);
                    if (_local_3.hitTestObject(_local_5))
                    {
                        if (_local_3.y > _local_5.y)
                        {
                            if (this._playerLayer.getChildIndex(_local_3) < this._playerLayer.getChildIndex(_local_5))
                            {
                                this._playerLayer.swapChildren(_local_3, _local_5);
                            };
                        };
                    };
                    _local_4++;
                };
                _local_2++;
            };
        }

        private function initPlayer():void
        {
            if (this._loadingPlayerInfo)
            {
                if (((this._initPlayer == null) || (!(this._initPlayer.playerInfo.ID == this._loadingPlayerInfo.playerInfo.ID))))
                {
                    if (this._playerDic.hasKey(this._loadingPlayerInfo.playerInfo.ID))
                    {
                        this._initPlayer = this._playerDic[this._loadingPlayerInfo.playerInfo.ID];
                        this._playerDic.remove(this._initPlayer);
                        ObjectUtils.disposeObject(this._initPlayer);
                        this._initPlayer = null;
                    };
                    if (ArenaManager.instance.model.playerDic.hasKey(this._loadingPlayerInfo.playerInfo.ID))
                    {
                        this._initPlayer = new ArenaScenePlayer(this._loadingPlayerInfo, this.addPlayerCallBack);
                        this._playerLayer.addChild(this._initPlayer.defaultBody);
                    };
                };
            };
        }

        private function addSelfPlayer():void
        {
            var _local_1:ArenaScenePlayerInfo;
            var _local_2:ArenaScenePlayer;
            if ((!(this.selfPlayer)))
            {
                _local_1 = ArenaManager.instance.model.selfInfo;
                _local_2 = new ArenaScenePlayer(_local_1, this.addPlayerCallBack);
                this.ajustScreen(_local_2);
                this.setCenter();
            };
        }

        private function __addPlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:ArenaScenePlayerInfo = (_arg_1.data as ArenaScenePlayerInfo);
            if (_local_2.playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
                return;
            };
            var _local_3:ArenaScenePlayer = new ArenaScenePlayer(_local_2, this.addPlayerCallBack);
            this._playerLayer.addChild(_local_3.defaultBody);
        }

        private function __removePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:ArenaScenePlayerInfo = (_arg_1.data as ArenaScenePlayerInfo);
            var _local_3:ArenaScenePlayer = this._playerDic[_local_2.playerInfo.ID];
            this._playerDic.remove(_local_2.playerInfo.ID);
            ObjectUtils.disposeObject(_local_3);
            _local_3 = null;
        }

        private function __updatePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:ArenaScenePlayerInfo = (_arg_1.data as ArenaScenePlayerInfo);
            if (this._playerDic.hasKey(_local_2.playerInfo.ID))
            {
                this._playerDic[_local_2.playerInfo.ID].arenaPlayerInfo = _local_2;
                if (_local_2.playerInfo.ID == PlayerManager.Instance.Self.ID)
                {
                    this.selfPlayer.arenaPlayerInfo = _local_2;
                    this.selfPlayer.playerPoint = _local_2.playerPos;
                    this.setCenter();
                };
            };
        }

        private function __updateSelf(_arg_1:ArenaEvent):void
        {
            this.selfPlayer.arenaPlayerInfo = ArenaManager.instance.model.selfInfo;
            this.selfPlayer.playerPoint = ArenaManager.instance.model.selfInfo.playerPos;
            this.setCenter();
        }

        private function addPlayerCallBack(_arg_1:ArenaScenePlayer, _arg_2:Boolean):void
        {
            if (((!(this._playerLayer)) || (!(_arg_1))))
            {
                return;
            };
            this._currentLoadingPlayer = null;
            _arg_1.sceneScene = this._sceneScene;
            _arg_1.setSceneCharacterDirectionDefault = (_arg_1.sceneCharacterDirection = _arg_1.scenePlayerInfo.scenePlayerDirection);
            if (((!(this.selfPlayer)) && (_arg_1.scenePlayerInfo.playerInfo.ID == PlayerManager.Instance.Self.ID)))
            {
                _arg_1.scenePlayerInfo.playerPos = _arg_1.scenePlayerInfo.playerPos;
                this.selfPlayer = _arg_1;
                this.selfPlayer.scenePlayerInfo = ArenaManager.instance.model.selfInfo;
                this._playerLayer.addChild(this.selfPlayer);
                this.ajustScreen(this.selfPlayer);
                this.setCenter();
                this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.__playerActionChange);
                ArenaManager.instance.sendUpdate();
                ArenaManager.instance.model.addPlayerInfoRightNow(this.selfPlayer.playerInfo.ID, this.selfPlayer.arenaPlayerInfo);
                ArenaManager.instance.model.dispatchEvent(new ArenaEvent(ArenaEvent.ENTER_SCENE));
            }
            else
            {
                if (((_arg_1.defaultBody) && (this._playerLayer.contains(_arg_1.defaultBody))))
                {
                    this._playerLayer.removeChild(_arg_1.defaultBody);
                };
                if (this._playerLayer.contains(_arg_1))
                {
                    this._playerLayer.removeChild(_arg_1);
                };
                if (ArenaManager.instance.model.playerDic.hasKey(_arg_1.playerInfo.ID))
                {
                    this._playerLayer.addChild(_arg_1);
                };
            };
            _arg_1.playerPoint = _arg_1.scenePlayerInfo.playerPos;
            _arg_1.sceneCharacterStateType = "natural";
            this._loadingPlayerInfo = null;
            this._initPlayer = null;
            if (ArenaManager.instance.model.playerDic.hasKey(_arg_1.playerInfo.ID))
            {
                this._playerDic.add(_arg_1.scenePlayerInfo.playerInfo.ID, _arg_1);
            };
        }

        private function __playerActionChange(_arg_1:SceneCharacterEvent):void
        {
            var _local_2:String = _arg_1.data.toString();
            if (((_local_2 == "naturalStandFront") || (_local_2 == "naturalStandBack")))
            {
                this._mouseMovie.gotoAndStop(1);
            };
        }

        protected function ajustScreen(_arg_1:ArenaScenePlayer):void
        {
            if (_arg_1 == null)
            {
                if (this._reference)
                {
                    this._reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
                    this._reference = null;
                };
                return;
            };
            if (this._reference)
            {
                this._reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
            };
            this._reference = _arg_1;
            this._reference.addEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
        }

        public function setCenter(_arg_1:SceneCharacterEvent=null):void
        {
            var _local_2:Number;
            var _local_3:Number;
            if (this._reference)
            {
                _local_2 = -(this._reference.x - (MoonSceneMap.GAME_WIDTH / 2));
                _local_3 = (-(this._reference.y - (MoonSceneMap.GAME_HEIGHT / 2)) + 50);
            };
            if (_local_2 > 0)
            {
                _local_2 = 0;
            };
            if (_local_2 < (MoonSceneMap.GAME_WIDTH - this.sceneMapVO.mapW))
            {
                _local_2 = (MoonSceneMap.GAME_WIDTH - this.sceneMapVO.mapW);
            };
            if (_local_3 > 0)
            {
                _local_3 = 0;
            };
            if (_local_3 < (MoonSceneMap.GAME_HEIGHT - this.sceneMapVO.mapH))
            {
                _local_3 = (MoonSceneMap.GAME_HEIGHT - this.sceneMapVO.mapH);
            };
            x = _local_2;
            y = _local_3;
        }

        public function get sceneMapVO():SceneMapVO
        {
            var _local_1:SceneMapVO = new SceneMapVO();
            _local_1.mapW = MAP_SIZE[0];
            _local_1.mapH = MAP_SIZE[1];
            _local_1.defaultPos = new Point(100, 100);
            return (_local_1);
        }

        private function removePlayer():void
        {
            var _local_1:ArenaScenePlayer;
            var _local_2:int = this._playerDic.length;
            var _local_3:int;
            while (_local_3 < _local_2)
            {
                _local_1 = this._playerDic.list[0];
                this._playerDic.remove(_local_1.playerInfo.ID);
                ObjectUtils.disposeObject(_local_1);
                _local_1 = null;
                _local_3++;
            };
            this._initPlayer = null;
            this._playerDic = null;
        }

        private function removeEvent():void
        {
            ArenaManager.instance.model.playerDic.removeEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            ArenaManager.instance.model.playerDic.removeEventListener(DictionaryEvent.UPDATE, this.__updatePlayer);
            ArenaManager.instance.model.removeEventListener(ArenaEvent.UPDATE_SELF, this.__updateSelf);
            removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            if (this.selfPlayer)
            {
                this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.__playerActionChange);
            };
        }

        private function removeView():void
        {
            this._sceneScene = null;
            ObjectUtils.disposeAllChildren(this._mapLayer);
            ObjectUtils.disposeObject(this._mapLayer);
            this._mapLayer = null;
            ObjectUtils.disposeAllChildren(this._playerLayer);
            ObjectUtils.disposeObject(this._playerLayer);
            this._playerLayer = null;
            ObjectUtils.disposeAllChildren(this._maskLayer);
            ObjectUtils.disposeObject(this._maskLayer);
            this._maskLayer = null;
            ObjectUtils.disposeObject(this._mouseMovie);
            this._mouseMovie = null;
        }

        public function dispose():void
        {
            this._loadingPlayerInfo = null;
            this.removeEvent();
            this.removePlayer();
            this.removeView();
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package arena.view

