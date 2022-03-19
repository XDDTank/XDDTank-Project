// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.consortionsence.ConsortionSenceMap

package consortion.consortionsence
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import consortion.IConsortionState;
    import flash.display.MovieClip;
    import ddt.view.scenePathSearcher.SceneScene;
    import road7th.data.DictionaryData;
    import church.vo.SceneMapVO;
    import flash.geom.Point;
    import com.pickgliss.ui.controls.BaseButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.Event;
    import road7th.data.DictionaryEvent;
    import consortion.managers.ConsortionMonsterManager;
    import ddt.manager.SocketManager;
    import consortion.view.selfConsortia.SelfConsortiaViewFrame;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import consortion.ConsortionModelControl;
    import ddt.manager.MessageTipManager;
    import consortion.view.selfConsortia.ConsortionSkillFrame;
    import com.pickgliss.ui.LayerManager;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import consortion.objects.ConsortionMonster;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import church.view.churchScene.MoonSceneMap;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import consortion.data.MonsterInfo;
    import flash.display.DisplayObject;
    import worldboss.WorldBossManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ConsortionSenceMap extends Sprite implements Disposeable, IConsortionState 
    {

        protected var articleLayer:Sprite;
        protected var meshLayer:Sprite;
        protected var topLayer:Sprite;
        protected var objLayer:Sprite;
        protected var bgLayer:Sprite;
        protected var hallLayer:MovieClip;
        protected var shopLayer:MovieClip;
        protected var skillLayer:MovieClip;
        public var sceneScene:SceneScene;
        protected var _data:DictionaryData;
        protected var _characters:DictionaryData;
        protected var _monsters:DictionaryData;
        public var selfPlayer:ConsortionWalkPlayer;
        private var last_click:Number;
        private var _mouseMovie:MovieClip;
        private var _currentLoadingPlayer:ConsortionWalkPlayer;
        private var _clickInterval:Number = 200;
        private var _lastClick:Number = 0;
        private var _sceneMapVO:SceneMapVO;
        public var armyPos:Point;
        protected var _mapObjs:DictionaryData;
        private var player:ConsortionWalkPlayer;
        private var _shopBuild:MovieClip;
        private var _skillBuild:MovieClip;
        private var _hallBuild:MovieClip;
        private var _hallBtn:BaseButton;
        private var _shopBtn:BaseButton;
        private var _skillBtn:BaseButton;
        private var endPoint:Point = new Point();
        protected var reference:ConsortionWalkPlayer;

        public function ConsortionSenceMap(_arg_1:SceneScene, _arg_2:DictionaryData, _arg_3:DictionaryData, _arg_4:Sprite, _arg_5:Sprite, _arg_6:MovieClip=null, _arg_7:MovieClip=null, _arg_8:MovieClip=null, _arg_9:Sprite=null)
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
            this.hallLayer = ((_arg_6 == null) ? new MovieClip() : _arg_6);
            this.shopLayer = ((_arg_7 == null) ? new MovieClip() : _arg_7);
            this.skillLayer = ((_arg_8 == null) ? new MovieClip() : _arg_8);
            this.articleLayer = new Sprite();
            this.objLayer = new Sprite();
            this.topLayer = _arg_9;
            this.addChild(this.bgLayer);
            this.addChild(this.meshLayer);
            this.addChild(this.objLayer);
            this.addChild(this.hallLayer);
            this.addChild(this.shopLayer);
            this.addChild(this.skillLayer);
            this.addChild(this.articleLayer);
            this.addChild(_arg_9);
            this._hallBtn = ComponentFactory.Instance.creatComponentByStylename("consortionWalkMap.hallBtn");
            this._shopBtn = ComponentFactory.Instance.creatComponentByStylename("consortionWalkMap.shopBtn");
            this._skillBtn = ComponentFactory.Instance.creatComponentByStylename("consortionWalkMap.skillBtn");
            this.addChild(this._hallBtn);
            this.addChild(this._shopBtn);
            this.addChild(this._skillBtn);
            var _local_10:Object = new Object();
            _local_10["title"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.hallbuild.title");
            _local_10["content"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.hallbuild.content");
            this._hallBtn.tipData = _local_10;
            var _local_11:Object = new Object();
            _local_11["title"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.shopbuild.title");
            _local_11["content"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.shopbuild.content");
            this._shopBtn.tipData = _local_11;
            var _local_12:Object = new Object();
            _local_12["title"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.skillbuild.title");
            _local_12["content"] = LanguageMgr.GetTranslation("ddt.consortionWalkMap.skillbuild.content");
            this._skillBtn.tipData = _local_12;
            this.topLayer.mouseEnabled = false;
            this.topLayer.mouseChildren = false;
            this.articleLayer.mouseEnabled = true;
            this.articleLayer.mouseChildren = true;
            this.init();
            this.initPlayers();
            this.initBuild();
            this.addOjbect();
            this.addEvent();
        }

        private function initPlayers():void
        {
            var _local_1:ConsortionWalkPlayerInfo;
            for each (_local_1 in this._data)
            {
                if ((!(this._characters.hasKey(_local_1.playerInfo.ID))))
                {
                    this._currentLoadingPlayer = new ConsortionWalkPlayer(_local_1, this.addPlayerCallBack);
                    this.articleLayer.addChild(this._currentLoadingPlayer.defaultBody);
                };
            };
        }

        private function initBuild():void
        {
            if (((!(this.bgLayer == null)) && (!(this.articleLayer == null))))
            {
                this._hallBuild = this.hallLayer;
                this._hallBtn.addEventListener(MouseEvent.MOUSE_OVER, this.__hallOver);
                this._hallBtn.addEventListener(MouseEvent.MOUSE_OUT, this.__hallOut);
                this._hallBtn.addEventListener(MouseEvent.CLICK, this.__openHall);
                this._hallBuild.gotoAndStop(1);
                this._shopBuild = this.shopLayer;
                this._shopBtn.addEventListener(MouseEvent.MOUSE_OVER, this.__shopOver);
                this._shopBtn.addEventListener(MouseEvent.MOUSE_OUT, this.__shopOut);
                this._shopBtn.addEventListener(MouseEvent.CLICK, this.__openShop);
                this._shopBuild.gotoAndStop(1);
                this._skillBuild = this.skillLayer;
                this._skillBtn.addEventListener(MouseEvent.MOUSE_OVER, this.__skillOver);
                this._skillBtn.addEventListener(MouseEvent.MOUSE_OUT, this.__skillOut);
                this._skillBtn.addEventListener(MouseEvent.CLICK, this.__openSkill);
                this._skillBuild.gotoAndStop(1);
            };
        }

        private function __hallOver(_arg_1:MouseEvent):void
        {
            this._hallBuild.gotoAndStop(2);
        }

        private function __hallOut(_arg_1:MouseEvent):void
        {
            this._hallBuild.gotoAndStop(1);
        }

        private function __shopOver(_arg_1:MouseEvent):void
        {
            this._shopBuild.gotoAndStop(2);
        }

        private function __shopOut(_arg_1:MouseEvent):void
        {
            this._shopBuild.gotoAndStop(1);
        }

        private function __skillOver(_arg_1:MouseEvent):void
        {
            this._skillBuild.gotoAndStop(2);
        }

        private function __skillOut(_arg_1:MouseEvent):void
        {
            this._skillBuild.gotoAndStop(1);
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
            this._monsters = new DictionaryData(true);
            var _local_1:Class = (ClassUtils.uiSourceDomain.getDefinition("asset.walkScene.MouseClickMovie") as Class);
            this._mouseMovie = (new (_local_1)() as MovieClip);
            this._mouseMovie.mouseChildren = false;
            this._mouseMovie.mouseEnabled = false;
            this._mouseMovie.stop();
            this.bgLayer.addChild(this._mouseMovie);
            this.last_click = 0;
        }

        protected function addEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__mouseClick);
            addEventListener(Event.ENTER_FRAME, this.__updateMap);
            this._data.addEventListener(DictionaryEvent.ADD, this.__addPlayer);
            this._data.addEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            this._mapObjs.addEventListener(DictionaryEvent.ADD, this.__addMonster);
            this._mapObjs.addEventListener(DictionaryEvent.UPDATE, this.__onMonsterUpdate);
            this._mapObjs.addEventListener(DictionaryEvent.REMOVE, this.__removeMonster);
        }

        protected function addOjbect():void
        {
            if (ConsortionMonsterManager.Instance.ActiveState)
            {
                SocketManager.Instance.out.sendAddMonsterRequest();
            };
        }

        protected function __updateMap(_arg_1:Event):void
        {
            var _local_2:ConsortionWalkPlayer;
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

        private function __openHall(_arg_1:MouseEvent):void
        {
            var _local_2:SelfConsortiaViewFrame;
            SoundManager.instance.play("008");
            _local_2 = ComponentFactory.Instance.creatComponentByStylename("SelfConsortiaViewFrame");
            _local_2.show();
        }

        private function __openShop(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.consortionStatus)
            {
                SocketManager.Instance.out.sendShopRefreshGood();
                ConsortionModelControl.Instance.alertShopFrame();
            }
            else
            {
                return (MessageTipManager.getInstance().show("你的公会财富维持费不够,不能使用该建筑"));
            };
        }

        private function __openSkill(_arg_1:MouseEvent):void
        {
            var _local_2:ConsortionSkillFrame;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.consortionStatus)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("consortionSkillFrame");
                LayerManager.Instance.addToLayer(_local_2, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            }
            else
            {
                return (MessageTipManager.getInstance().show("你的公会财富维持费不够,不能使用该建筑"));
            };
        }

        protected function __mouseClick(_arg_1:MouseEvent):void
        {
            if ((!(this.selfPlayer)))
            {
                return;
            };
            if (Mouse.cursor == MouseCursor.BUTTON)
            {
                return;
            };
            var _local_2:Point = new Point(_arg_1.stageX, _arg_1.stageY);
            var _local_3:Point = this.globalToLocal(_local_2);
            var _local_4:ConsortionMonster = ConsortionMonsterManager.Instance.curMonster;
            if ((((_local_4) && (_local_4.hitTestPoint(_arg_1.stageX, _arg_1.stageY))) && (_local_4.visible)))
            {
                this.playerMove(this.selfPlayer.playerPoint, _local_3);
                return;
            };
            ConsortionMonsterManager.Instance.curMonster = null;
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
            this.selfPlayer.consortionPlayerInfo.walkPath = this.sceneScene.searchPath(_arg_1, _arg_2);
            this.selfPlayer.consortionPlayerInfo.walkPath.shift();
            this.selfPlayer.consortionPlayerInfo.scenePlayerDirection = SceneCharacterDirection.getDirection(this.selfPlayer.playerPoint, this.selfPlayer.consortionPlayerInfo.walkPath[0]);
            this.selfPlayer.consortionPlayerInfo.currenWalkStartPoint = this.selfPlayer.currentWalkStartPoint;
            this.sendMyPosition(this.selfPlayer.consortionPlayerInfo.walkPath.concat());
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
            SocketManager.Instance.out.SendConsortionWalkScenePlayeMove(_arg_1[(_arg_1.length - 1)].x, _arg_1[(_arg_1.length - 1)].y, _local_4);
        }

        public function updatePlayerStauts(_arg_1:int, _arg_2:int, _arg_3:Point):void
        {
            var _local_4:ConsortionWalkPlayer;
            if (this._characters[_arg_1])
            {
                _local_4 = (this._characters[_arg_1] as ConsortionWalkPlayer);
                if (((_arg_2 == 1) && (_local_4.consortionPlayerInfo.playerStauts == 3)))
                {
                    _local_4.consortionPlayerInfo.playerStauts = _arg_2;
                }
                else
                {
                    if (_arg_2 == 2)
                    {
                        _local_4.consortionPlayerInfo.playerStauts = 1;
                        _local_4.consortionPlayerInfo.playerStauts = _arg_2;
                        _local_4.consortionPlayerInfo.walkPath = [_arg_3];
                    }
                    else
                    {
                        _local_4.consortionPlayerInfo.playerStauts = _arg_2;
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

        protected function __addPlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:ConsortionWalkPlayerInfo = (_arg_1.data as ConsortionWalkPlayerInfo);
            this._currentLoadingPlayer = new ConsortionWalkPlayer(_local_2, this.addPlayerCallBack);
            this.articleLayer.addChild(this._currentLoadingPlayer.defaultBody);
        }

        private function __addMonster(_arg_1:DictionaryEvent):void
        {
            var _local_2:MonsterInfo = (_arg_1.data as MonsterInfo);
            var _local_3:ConsortionMonster = new ConsortionMonster(_local_2, _local_2.MonsterPos);
            this._monsters.add(_local_2.ID, _local_3);
            this.articleLayer.addChild(_local_3);
        }

        private function __onMonsterUpdate(_arg_1:DictionaryEvent):void
        {
            var _local_2:MonsterInfo = (_arg_1.data as MonsterInfo);
            var _local_3:ConsortionMonster = (this._monsters[_local_2.ID] as ConsortionMonster);
            if (_local_3)
            {
                this._monsters.remove(_local_2.ID);
                _local_3.dispose();
            };
            var _local_4:ConsortionMonster = new ConsortionMonster(_local_2, _local_2.MonsterPos);
            this._monsters.add(_local_2.ID, _local_4);
            this.articleLayer.addChild(_local_4);
        }

        private function __removeMonster(_arg_1:DictionaryEvent):void
        {
            var _local_2:MonsterInfo = (_arg_1.data as MonsterInfo);
            var _local_3:ConsortionMonster = (this._monsters[_local_2.ID] as ConsortionMonster);
            this._monsters.remove(_local_2.ID);
            _local_3.dispose();
        }

        public function addSelfPlayer():void
        {
            var _local_1:ConsortionWalkPlayerInfo;
            if ((!(this.selfPlayer)))
            {
                _local_1 = new ConsortionWalkPlayerInfo();
                _local_1.playerPos = ConsortionManager.Instance.SelfPoint;
                _local_1.playerInfo = PlayerManager.Instance.Self;
                this._currentLoadingPlayer = new ConsortionWalkPlayer(_local_1, this.addPlayerCallBack);
                this.player = this._currentLoadingPlayer;
                this.ajustScreen(this.player);
                this.setCenter();
            };
        }

        protected function ajustScreen(_arg_1:ConsortionWalkPlayer):void
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

        private function addPlayerCallBack(_arg_1:ConsortionWalkPlayer, _arg_2:Boolean):void
        {
            if (((!(this.articleLayer)) || (!(_arg_1))))
            {
                return;
            };
            this._currentLoadingPlayer = null;
            _arg_1.sceneScene = this.sceneScene;
            _arg_1.setSceneCharacterDirectionDefault = (_arg_1.sceneCharacterDirection = _arg_1.consortionPlayerInfo.scenePlayerDirection);
            if (((!(this.selfPlayer)) && (_arg_1.consortionPlayerInfo.playerInfo.ID == PlayerManager.Instance.Self.ID)))
            {
                _arg_1.consortionPlayerInfo.playerPos = _arg_1.consortionPlayerInfo.playerPos;
                this.selfPlayer = _arg_1;
                this.articleLayer.addChild(this.selfPlayer);
                this.ajustScreen(this.selfPlayer);
                this.setCenter();
                this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
            }
            else
            {
                this.articleLayer.removeChild(_arg_1.defaultBody);
                this.articleLayer.addChild(_arg_1);
            };
            _arg_1.playerPoint = _arg_1.consortionPlayerInfo.playerPos;
            _arg_1.sceneCharacterStateType = "natural";
            _arg_1.sceneCharacterActionType = "naturalStandFront";
            this._characters.add(_arg_1.consortionPlayerInfo.playerInfo.ID, _arg_1);
        }

        public function movePlayer(_arg_1:int, _arg_2:Array):void
        {
            var _local_3:ConsortionWalkPlayer;
            if (this._characters[_arg_1])
            {
                _local_3 = (this._characters[_arg_1] as ConsortionWalkPlayer);
                _local_3.consortionPlayerInfo.playerStauts = 1;
                _local_3.consortionPlayerInfo.walkPath = _arg_2;
                _local_3.playerWalk(_arg_2);
            };
        }

        private function playerActionChange(_arg_1:SceneCharacterEvent):void
        {
            var _local_3:ConsortionMonster;
            var _local_4:Point;
            var _local_2:String = _arg_1.data.toString();
            if (((_local_2 == "naturalStandFront") || (_local_2 == "naturalStandBack")))
            {
                this._mouseMovie.gotoAndStop(1);
                _local_3 = ConsortionMonsterManager.Instance.curMonster;
                if (((_local_3) && (_local_3.MonsterState == MonsterInfo.LIVIN)))
                {
                    _local_4 = this.localToGlobal(new Point(this.selfPlayer.playerPoint.x, (this.selfPlayer.playerPoint.y + 50)));
                    if (((_local_3.hitTestPoint(_local_4.x, _local_4.y)) || (_local_3.hitTestObject(this.selfPlayer))))
                    {
                        _local_3.StartFight();
                    };
                };
            };
        }

        protected function __removePlayer(_arg_1:DictionaryEvent):void
        {
            var _local_2:int = (_arg_1.data as ConsortionWalkPlayerInfo).playerInfo.ID;
            var _local_3:ConsortionWalkPlayer = (this._characters[_local_2] as ConsortionWalkPlayer);
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

        protected function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            removeEventListener(Event.ENTER_FRAME, this.__updateMap);
            if (this._data)
            {
                this._data.removeEventListener(DictionaryEvent.ADD, this.__addPlayer);
                this._data.removeEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            };
            if (this._mapObjs)
            {
                this._mapObjs.removeEventListener(DictionaryEvent.ADD, this.__addMonster);
                this._mapObjs.removeEventListener(DictionaryEvent.UPDATE, this.__onMonsterUpdate);
                this._mapObjs.removeEventListener(DictionaryEvent.REMOVE, this.__removeMonster);
            };
            if (this.reference)
            {
                this.reference.removeEventListener(SceneCharacterEvent.CHARACTER_MOVEMENT, this.setCenter);
            };
            if (this.selfPlayer)
            {
                this.selfPlayer.removeEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
            };
        }

        public function updateSelfStatus(_arg_1:int):void
        {
            if (this.selfPlayer.consortionPlayerInfo.playerStauts == 3)
            {
                this.selfPlayer.consortionPlayerInfo.playerPos = WorldBossManager.Instance.bossInfo.playerDefaultPos;
                this.ajustScreen(this.selfPlayer);
                this.setCenter();
            };
            this.selfPlayer.consortionPlayerInfo.playerStauts = _arg_1;
        }

        private function clearAllPlayer():void
        {
            var p:ConsortionWalkPlayer;
            var o:ConsortionMonster;
            var i:int;
            var player:ConsortionWalkPlayer;
            if (this.articleLayer)
            {
                i = this.articleLayer.numChildren;
                while (i > 0)
                {
                    player = (this.articleLayer.getChildAt((i - 1)) as ConsortionWalkPlayer);
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
                ObjectUtils.disposeObject(p);
                p = null;
            };
            for each (o in this._monsters)
            {
                o.dispose();
                o = null;
            };
            this._monsters.clear();
            this._characters.clear();
            this._characters = null;
        }

        public function dispose():void
        {
            this.removeEvent();
            if (this._mapObjs)
            {
                this._mapObjs.clear();
                this._mapObjs = null;
            };
            if (this._data)
            {
                this._data.clear();
                this._data = null;
            };
            this.clearAllPlayer();
            ObjectUtils.disposeObject(this.topLayer);
            this.topLayer = null;
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
            ObjectUtils.disposeObject(this.objLayer);
            this.objLayer = null;
            ObjectUtils.disposeObject(this.sceneScene);
            this.sceneScene = null;
            ObjectUtils.disposeAllChildren(this);
            this._sceneMapVO = null;
            if (parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.consortionsence

