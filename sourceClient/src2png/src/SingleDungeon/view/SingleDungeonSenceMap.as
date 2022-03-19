// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.view.SingleDungeonSenceMap

package SingleDungeon.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.view.scenePathSearcher.SceneScene;
    import road7th.data.DictionaryData;
    import SingleDungeon.player.WalkMapPlayer;
    import flash.display.MovieClip;
    import church.vo.SceneMapVO;
    import flash.geom.Point;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import road7th.data.DictionaryEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import SingleDungeon.event.SingleDungeonEvent;
    import com.pickgliss.utils.ObjectUtils;
    import road7th.comm.PackageIn;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import ddt.data.goods.ItemTemplateInfo;
    import bagAndInfo.cell.BaseCell;
    import game.view.DropGoods;
    import ddt.data.EquipType;
    import ddt.manager.ItemManager;
    import SingleDungeon.model.WalkMapObject;
    import com.pickgliss.loader.QueueLoader;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import church.view.churchScene.MoonSceneMap;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import SingleDungeon.model.SingleDungeonPlayerInfo;
    import SingleDungeon.SingleDungeonManager;
    import ddt.manager.PlayerManager;
    import flash.utils.setInterval;
    import flash.utils.clearInterval;
    import flash.display.DisplayObject;
    import worldboss.WorldBossManager;

    public class SingleDungeonSenceMap extends Sprite implements Disposeable 
    {

        public static const SCENE_ALLOW_FIRES:int = 6;

        private const CLICK_INTERVAL:Number = 200;

        protected var articleLayer:Sprite;
        protected var meshLayer:Sprite;
        protected var objLayer:Sprite;
        protected var bgLayer:Sprite;
        public var sceneScene:SceneScene;
        protected var _data:DictionaryData;
        protected var _characters:DictionaryData;
        public var selfPlayer:WalkMapPlayer;
        private var last_click:Number;
        private var current_display_fire:int = 0;
        private var _mouseMovie:MovieClip;
        private var _currentLoadingPlayer:WalkMapPlayer;
        private var _isShowName:Boolean = true;
        private var _isChatBall:Boolean = true;
        private var _clickInterval:Number = 200;
        private var _lastClick:Number = 0;
        private var _sceneMapVO:SceneMapVO;
        public var armyPos:Point;
        protected var _mapObjs:DictionaryData;
        private var dropGoodsList:Array = new Array();
        private var player:WalkMapPlayer;
        public var clickedBox:MapObjView;
        public var collectionMC:MovieClip;
        public var isCollecting:Boolean;
        private var dictionary:DictionaryData = new DictionaryData();
        private var endPoint:Point = new Point();
        protected var reference:WalkMapPlayer;
        private var intervalIdDic:DictionaryData = new DictionaryData();

        public function SingleDungeonSenceMap(_arg_1:SceneScene, _arg_2:DictionaryData, _arg_3:DictionaryData, _arg_4:Sprite, _arg_5:Sprite)
        {
            this.sceneScene = _arg_1;
            this._data = _arg_2;
            this._mapObjs = _arg_3;
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
            this.articleLayer = new Sprite();
            this.objLayer = new Sprite();
            this.addChild(this.bgLayer);
            this.addChild(this.meshLayer);
            this.addChild(this.objLayer);
            this.addChild(this.articleLayer);
            this.articleLayer.mouseEnabled = false;
            this.articleLayer.mouseChildren = false;
            this.init();
            this.addEvent();
            this.addObject();
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
            var _local_1:Class = (ClassUtils.uiSourceDomain.getDefinition("asset.singleDungeon.walkScene.MouseClickMovie") as Class);
            this._mouseMovie = (new (_local_1)() as MovieClip);
            this._mouseMovie.mouseChildren = false;
            this._mouseMovie.mouseEnabled = false;
            this._mouseMovie.stop();
            this.bgLayer.addChild(this._mouseMovie);
            this.last_click = 0;
            this.collectionMC = ClassUtils.CreatInstance("asset.singleDungeon.collectionMC");
            this.collectionMC.x = 350;
            this.collectionMC.y = 480;
        }

        protected function addEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__click);
            addEventListener(Event.ENTER_FRAME, this.updateMap);
            this._data.addEventListener(DictionaryEvent.ADD, this.__addPlayer);
            this._data.addEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.WALKSCENE_OBJECT_CLICK, this.__onObjClickComplete);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.DROP_GOODS, this.__onDropItemComplete);
            this.addEventListener(SingleDungeonEvent.START_COLLECT, this.__startCollect);
        }

        private function __startCollect(_arg_1:SingleDungeonEvent):void
        {
            if (_arg_1.data[0] == null)
            {
                if (this.dictionary[this.clickedBox])
                {
                    ObjectUtils.disposeObject(this.dictionary[this.clickedBox]);
                };
            };
            this.clickedBox = (_arg_1.data[0] as MapObjView);
            this.isCollecting = (_arg_1.data[1] as Boolean);
        }

        private function __onObjClickComplete(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = _arg_1.pkg;
            var _local_3:int = _local_2.readInt();
            var _local_4:Boolean = _local_2.readBoolean();
            if (NewHandContainer.Instance.hasArrow(ArrowType.TIP_CHEST))
            {
                NewHandContainer.Instance.clearArrowByID(ArrowType.TIP_CHEST);
            };
        }

        private function __onDropItemComplete(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_7:int;
            var _local_8:int;
            var _local_9:int;
            var _local_10:int;
            var _local_11:ItemTemplateInfo;
            var _local_12:Sprite;
            var _local_13:BaseCell;
            var _local_14:Point;
            var _local_15:DropGoods;
            var _local_2:PackageIn = _arg_1.pkg;
            if (_local_2.bytesAvailable < 1)
            {
                return;
            };
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            var _local_6:int;
            while (_local_6 < _local_5)
            {
                _local_7 = _local_2.readInt();
                _local_8 = 0;
                while (_local_8 < _local_7)
                {
                    _local_9 = _local_2.readInt();
                    _local_10 = _local_2.readInt();
                    _local_9 = EquipType.filterEquiqItemId(_local_9);
                    _local_11 = ItemManager.Instance.getTemplateById(_local_9);
                    _local_12 = new Sprite();
                    _local_13 = new BaseCell(_local_12, _local_11);
                    _local_13.setContentSize(40, 40);
                    _local_14 = new Point(650, 540);
                    _local_15 = new DropGoods(this, _local_13, this.armyPos, globalToLocal(_local_14), _local_10);
                    _local_15.start(_local_15.CHESTS_DROP);
                    this.dropGoodsList.push(_local_15);
                    _local_8++;
                };
                _local_6++;
            };
        }

        protected function addObject():void
        {
            var _local_2:WalkMapObject;
            var _local_1:QueueLoader = new QueueLoader();
            for each (_local_2 in this._mapObjs)
            {
                _local_1.addLoader(LoadResourceManager.instance.createLoader(PathManager.solveWalkSceneMapobjectsPath(_local_2.Path), BaseLoader.MODULE_LOADER));
            };
            _local_1.addEventListener(Event.COMPLETE, this.__onLoadComplete);
            _local_1.start();
        }

        private function __onLoadComplete(_arg_1:Event):void
        {
            var _local_3:WalkMapObject;
            var _local_4:MovieClip;
            var _local_5:MapObjView;
            var _local_6:Array;
            var _local_7:Sprite;
            var _local_2:QueueLoader = (_arg_1.currentTarget as QueueLoader);
            if (_local_2.completeCount == this._mapObjs.length)
            {
                _local_2.removeEvent();
                for each (_local_3 in this._mapObjs)
                {
                    _local_4 = ClassUtils.CreatInstance(("walkscene.mapobject." + _local_3.Path));
                    _local_5 = new MapObjView(this, this.collectionMC);
                    _local_5.mapObjInfo = _local_3;
                    _local_5.dispChild = _local_4;
                    this.objLayer.addChild(_local_5);
                    _local_6 = _local_3.MapXY.split(",");
                    _local_5.x = _local_6[0];
                    _local_5.y = _local_6[1];
                    _local_7 = new Sprite();
                    _local_7.graphics.beginFill(0xFF0000);
                    _local_7.graphics.drawRect(_local_5.x, _local_5.y, (_local_5.width + 20), (_local_5.height + 20));
                    _local_7.graphics.endFill();
                    _local_7.y = (_local_7.y - (_local_5.height - 20));
                    _local_7.x = (_local_7.x - (_local_7.width / 2));
                    this.meshLayer.addChild(_local_7);
                    this.dictionary.add(_local_5, _local_7);
                };
            };
        }

        protected function updateMap(_arg_1:Event):void
        {
            var _local_2:WalkMapPlayer;
            if (((!(this._characters)) || (this._characters.length <= 0)))
            {
                return;
            };
            for each (_local_2 in this._characters)
            {
                _local_2.updatePlayer();
            };
            this.BuildEntityDepth();
        }

        protected function __click(_arg_1:MouseEvent):void
        {
            if ((!(this.selfPlayer)))
            {
                return;
            };
            if (this.isCollecting)
            {
                return;
            };
            if (Mouse.cursor == MouseCursor.BUTTON)
            {
                return;
            };
            var _local_2:Point = new Point(_arg_1.stageX, _arg_1.stageY);
            var _local_3:Point = this.globalToLocal(_local_2);
            if (((this.clickedBox) && (this.clickedBox.hitTestPoint(_arg_1.stageX, _arg_1.stageY))))
            {
                this.playerMove(this.selfPlayer.playerPoint, _local_3);
                return;
            };
            this.clickedBox = null;
            if ((!(this.sceneScene.hit(_local_3))))
            {
                if (_local_2.x != this.endPoint.x)
                {
                    this.playerMove(this.selfPlayer.playerPoint, _local_3);
                    this.endPoint = _local_2;
                };
            };
        }

        private function playerMove(_arg_1:Point, _arg_2:Point):void
        {
            this.selfPlayer.singleDungeonPlayerInfo.walkPath = this.sceneScene.searchPath(_arg_1, _arg_2);
            this.selfPlayer.singleDungeonPlayerInfo.walkPath.shift();
            this.selfPlayer.singleDungeonPlayerInfo.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint, this.selfPlayer.singleDungeonPlayerInfo.walkPath[0]);
            this.selfPlayer.singleDungeonPlayerInfo.currentWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
            this.sendMyPosition(this.selfPlayer.singleDungeonPlayerInfo.walkPath.concat());
            this._mouseMovie.x = _arg_2.x;
            this._mouseMovie.y = _arg_2.y;
            this._mouseMovie.play();
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
            SocketManager.Instance.out.sendWalkScenePlayerMove(_arg_1[(_arg_1.length - 1)].x, _arg_1[(_arg_1.length - 1)].y, _local_4);
        }

        public function updatePlayersStauts(_arg_1:int, _arg_2:int, _arg_3:Point):void
        {
            var _local_4:WalkMapPlayer;
            if (this._characters[_arg_1])
            {
                _local_4 = (this._characters[_arg_1] as WalkMapPlayer);
                if (((_arg_2 == 1) && (_local_4.singleDungeonPlayerInfo.playerStauts == 3)))
                {
                    _local_4.singleDungeonPlayerInfo.playerStauts = _arg_2;
                }
                else
                {
                    if (_arg_2 == 2)
                    {
                        _local_4.singleDungeonPlayerInfo.playerStauts = 1;
                        _local_4.singleDungeonPlayerInfo.playerStauts = _arg_2;
                        _local_4.singleDungeonPlayerInfo.walkPath = [_arg_3];
                    }
                    else
                    {
                        _local_4.singleDungeonPlayerInfo.playerStauts = _arg_2;
                    };
                };
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
            var _local_1:SingleDungeonPlayerInfo;
            if ((!(this.selfPlayer)))
            {
                _local_1 = new SingleDungeonPlayerInfo();
                _local_1.playerPos = SingleDungeonManager.Instance.SelfPoint;
                _local_1.playerInfo = PlayerManager.Instance.Self;
                this._currentLoadingPlayer = new WalkMapPlayer(_local_1, this.addPlayerCallBack);
                this.player = this._currentLoadingPlayer;
                this.articleLayer.addChild(this.player.defaultBody);
                _local_1.playerPos = _local_1.playerPos;
                this.ajustScreen(this.player);
                this.setCenter();
            };
        }

        protected function ajustScreen(_arg_1:WalkMapPlayer):void
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
            var _local_2:SingleDungeonPlayerInfo = (_arg_1.data as SingleDungeonPlayerInfo);
            this._currentLoadingPlayer = new WalkMapPlayer(_local_2, this.addPlayerCallBack);
            this.articleLayer.addChild(this._currentLoadingPlayer.defaultBody);
        }

        private function addPlayerCallBack(_arg_1:WalkMapPlayer, _arg_2:Boolean):void
        {
            var _local_3:uint;
            if (((!(this.articleLayer)) || (!(_arg_1))))
            {
                return;
            };
            this._currentLoadingPlayer = null;
            _arg_1.sceneScene = this.sceneScene;
            _arg_1.setSceneCharacterDirectionDefault = (_arg_1.sceneCharacterDirection = _arg_1.singleDungeonPlayerInfo.scenePlayerDirection);
            if (((!(this.selfPlayer)) && (_arg_1.singleDungeonPlayerInfo.playerInfo.ID == PlayerManager.Instance.Self.ID)))
            {
                _arg_1.singleDungeonPlayerInfo.playerPos = _arg_1.singleDungeonPlayerInfo.playerPos;
                this.selfPlayer = _arg_1;
                this.articleLayer.addChild(this.selfPlayer);
                this.ajustScreen(this.selfPlayer);
                this.setCenter();
                this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
            }
            else
            {
                this.articleLayer.addChild(_arg_1);
            };
            _arg_1.playerPoint = _arg_1.singleDungeonPlayerInfo.playerPos;
            _arg_1.sceneCharacterStateType = "natural";
            this._characters.add(_arg_1.singleDungeonPlayerInfo.playerInfo.ID, _arg_1);
            _arg_1.isShowName = true;
            if (_arg_1.isRobot)
            {
                _arg_1.playerPoint = this.getRobotinitPos();
                _local_3 = setInterval(this.moveRobot, int(((Math.random() * 2000) + 3000)), _arg_1.singleDungeonPlayerInfo.playerInfo.ID);
                this.intervalIdDic.add(_arg_1.singleDungeonPlayerInfo.playerInfo.ID, _local_3);
            };
            if (_arg_1.defaultBody)
            {
                ObjectUtils.disposeObject(_arg_1.defaultBody);
                _arg_1.defaultBody = null;
            };
        }

        private function getRobotinitPos():Point
        {
            var _local_1:Point = new Point();
            while (1)
            {
                _local_1.x = (((Math.random() * this.bgLayer.width) / 2) + 200);
                _local_1.y = (((Math.random() * this.bgLayer.height) / 2) + 200);
                if ((!(this.sceneScene.hit(_local_1)))) break;
            };
            return (_local_1);
        }

        private function moveRobot(_arg_1:int):void
        {
            var _local_2:int = ((Math.random() * 300) + 100);
            var _local_3:Array = [[0, _local_2], [0, -(_local_2)], [-(_local_2), 0], [_local_2, 0], [(-(_local_2) / 2), (_local_2 / 2)], [(_local_2 / 2), (-(_local_2) / 2)], [(-(_local_2) / 2), (-(_local_2) / 2)], [(_local_2 / 2), (_local_2 / 2)]];
            var _local_4:int = (Math.random() * 8);
            var _local_5:Point = this._characters[_arg_1].playerPoint;
            var _local_6:Point = new Point((_local_3[_local_4][0] + _local_5.x), (_local_3[_local_4][1] + _local_5.y));
            var _local_7:Array = this.sceneScene.searchPath(_local_5, _local_6);
            if ((((((!(this.sceneScene.hit(_local_6))) && (_local_6.x > 0)) && (_local_6.x < this.bgLayer.width)) && (_local_6.y > 0)) && (_local_6.y < this.bgLayer.height)))
            {
                this.movePlayer(_arg_1, _local_7);
            };
        }

        public function movePlayer(_arg_1:int, _arg_2:Array):void
        {
            var _local_3:WalkMapPlayer;
            if (this._characters[_arg_1])
            {
                _local_3 = (this._characters[_arg_1] as WalkMapPlayer);
                _local_3.singleDungeonPlayerInfo.playerStauts = 1;
                _local_3.singleDungeonPlayerInfo.walkPath = _arg_2;
                _local_3.playerWalk(_arg_2);
            };
        }

        private function playerActionChange(_arg_1:SceneCharacterEvent):void
        {
            var _local_3:Point;
            var _local_2:String = _arg_1.data.toString();
            if (((_local_2 == "naturalStandFront") || (_local_2 == "naturalStandBack")))
            {
                this._mouseMovie.gotoAndStop(1);
                if (((this.clickedBox) && (!(this.isCollecting))))
                {
                    _local_3 = this.localToGlobal(new Point(this.selfPlayer.playerPoint.x, (this.selfPlayer.playerPoint.y + 50)));
                    if (((this.dictionary[this.clickedBox].hitTestPoint(_local_3.x, _local_3.y)) || (this.dictionary[this.clickedBox].hitTestObject(this.selfPlayer))))
                    {
                        this.clickedBox.openBox();
                    };
                };
            };
        }

        protected function __removePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:int = (_arg_1.data as SingleDungeonPlayerInfo).playerInfo.ID;
            var _local_3:WalkMapPlayer = (this._characters[_local_2] as WalkMapPlayer);
            this._characters.remove(_local_2);
            clearInterval(this.intervalIdDic[_local_2]);
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

        protected function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__click);
            removeEventListener(Event.ENTER_FRAME, this.updateMap);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.WALKSCENE_OBJECT_CLICK, this.__onObjClickComplete);
            if (this._data)
            {
                this._data.removeEventListener(DictionaryEvent.ADD, this.__addPlayer);
                this._data.removeEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            };
            if (this.reference)
            {
                this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
            };
            if (this.selfPlayer)
            {
                this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
            };
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.DROP_GOODS, this.__onDropItemComplete);
        }

        public function updateSelfStatus(_arg_1:int):void
        {
            if (this.selfPlayer.singleDungeonPlayerInfo.playerStauts == 3)
            {
                this.selfPlayer.singleDungeonPlayerInfo.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
                this.ajustScreen(this.selfPlayer);
                this.setCenter();
            };
            this.selfPlayer.singleDungeonPlayerInfo.playerStauts = _arg_1;
        }

        public function getLayerByIndex(_arg_1:uint):Sprite
        {
            switch (_arg_1)
            {
                case 0:
                    return (this.bgLayer);
                case 1:
                    return (this.meshLayer);
                case 2:
                    return (this.objLayer);
                case 3:
                    return (this.articleLayer);
            };
            return (new Sprite());
        }

        private function clearAllPlayer():void
        {
            var p:WalkMapPlayer;
            var i:int;
            var player:WalkMapPlayer;
            if (this.articleLayer)
            {
                i = this.articleLayer.numChildren;
                while (i > 0)
                {
                    player = (this.articleLayer.getChildAt((i - 1)) as WalkMapPlayer);
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
            for each (p in this._characters)
            {
                p.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
                p.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
                p.dispose();
                ObjectUtils.disposeObject(p);
                p = null;
            };
            this._characters.clear();
            this._characters = null;
        }

        public function dispose():void
        {
            var _local_1:uint;
            var _local_2:DropGoods;
            this.removeEvent();
            for each (_local_1 in this.intervalIdDic)
            {
                clearInterval(_local_1);
            };
            this.intervalIdDic.clear();
            this.intervalIdDic = null;
            if (this._mapObjs)
            {
                this._mapObjs.clear();
                this._mapObjs = null;
            };
            if (this.collectionMC)
            {
                ObjectUtils.disposeObject(this.collectionMC);
                this.collectionMC = null;
            };
            for each (_local_2 in this.dropGoodsList)
            {
                if (_local_2)
                {
                    _local_2.dispose();
                };
            };
            this.dropGoodsList.length = 0;
            this.dropGoodsList = null;
            if (this.dictionary)
            {
                this.dictionary.clear();
                this.dictionary = null;
            };
            if (this._data)
            {
                this._data.clear();
                this._data = null;
            };
            this.clearAllPlayer();
            ObjectUtils.disposeObject(this.selfPlayer);
            this.selfPlayer = null;
            ObjectUtils.disposeObject(this._currentLoadingPlayer);
            this._currentLoadingPlayer = null;
            ObjectUtils.disposeObject(this.player);
            this.player = null;
            ObjectUtils.disposeObject(this._mouseMovie);
            this._mouseMovie = null;
            ObjectUtils.disposeObject(this.meshLayer);
            this.meshLayer = null;
            ObjectUtils.disposeObject(this.bgLayer);
            this.bgLayer = null;
            ObjectUtils.disposeObject(this.clickedBox);
            this.clickedBox = null;
            ObjectUtils.disposeObject(this.objLayer);
            this.objLayer = null;
            ObjectUtils.disposeObject(this.sceneScene);
            this.sceneScene = null;
            ObjectUtils.disposeAllChildren(this);
            this._sceneMapVO = null;
            this.armyPos = null;
            if (parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package SingleDungeon.view

