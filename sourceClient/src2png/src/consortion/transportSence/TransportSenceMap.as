// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.transportSence.TransportSenceMap

package consortion.transportSence
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import consortion.IConsortionState;
    import ddt.view.scenePathSearcher.SceneScene;
    import road7th.data.DictionaryData;
    import consortion.consortionsence.ConsortionWalkPlayer;
    import flash.display.MovieClip;
    import church.vo.SceneMapVO;
    import flash.geom.Point;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.LanguageMgr;
    import ddt.manager.SharedManager;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import consortion.event.ConsortionEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import road7th.data.DictionaryEvent;
    import game.GameManager;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.StateManager;
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
    import ddt.view.sceneCharacter.SceneCharacterDirection;
    import church.view.churchScene.MoonSceneMap;
    import ddt.view.sceneCharacter.SceneCharacterEvent;
    import consortion.consortionsence.ConsortionWalkPlayerInfo;
    import room.RoomManager;
    import ddt.manager.GameInSocketOut;
    import room.model.RoomInfo;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import roomList.pvpRoomList.RoomListBGView;
    import com.pickgliss.utils.ObjectUtils;
    import flash.display.DisplayObject;
    import worldboss.WorldBossManager;

    public class TransportSenceMap extends Sprite implements Disposeable, IConsortionState 
    {

        protected var articleLayer:Sprite;
        protected var meshLayer:Sprite;
        protected var objLayer:Sprite;
        protected var bgLayer:Sprite;
        public var sceneScene:SceneScene;
        protected var _data:DictionaryData;
        protected var _characters:DictionaryData;
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
        private var _remainPanel:TransportRemainPanel;
        private var _infoPanel:TransportInfoPanel;
        private var _waitTime:TransportHijackWaitTime;
        private var _playerLastY:int;
        private var _filterBtnGroup:SelectedButtonGroup;
        private var _filterBtnVBox:VBox;
        private var endPoint:Point = new Point();
        protected var reference:ConsortionWalkPlayer;

        public function TransportSenceMap(_arg_1:SceneScene, _arg_2:DictionaryData, _arg_3:DictionaryData, _arg_4:Sprite, _arg_5:Sprite)
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
            this.addOjbect();
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
            this._playerLastY = 0;
            this._characters = new DictionaryData(true);
            var _local_1:Class = (ClassUtils.uiSourceDomain.getDefinition("asset.walkScene.MouseClickMovie") as Class);
            this._mouseMovie = (new (_local_1)() as MovieClip);
            this._mouseMovie.mouseChildren = false;
            this._mouseMovie.mouseEnabled = false;
            this._mouseMovie.stop();
            this.bgLayer.addChild(this._mouseMovie);
            this._filterBtnGroup = new SelectedButtonGroup();
            this.last_click = 0;
            this.createUI();
        }

        private function createUI():void
        {
            var _local_2:SelectedCheckButton;
            this._remainPanel = ComponentFactory.Instance.creat("asset.transportSence.transportRemainPanel");
            LayerManager.Instance.addToLayer(this._remainPanel, LayerManager.GAME_UI_LAYER);
            this._remainPanel.__updateMyInfo();
            this._infoPanel = ComponentFactory.Instance.creat("asset.transportSence.transportInfoPanel");
            LayerManager.Instance.addToLayer(this._infoPanel, LayerManager.GAME_UI_LAYER);
            this._filterBtnVBox = ComponentFactory.Instance.creatComponentByStylename("consortion.transportSence.filterBtnVBox");
            LayerManager.Instance.addToLayer(this._filterBtnVBox, LayerManager.GAME_UI_LAYER);
            var _local_1:uint;
            while (_local_1 < 2)
            {
                _local_2 = ComponentFactory.Instance.creatComponentByStylename("consortion.transportSence.filterBtn");
                if ((_local_1 == 0))
                {
                    _local_2.text = LanguageMgr.GetTranslation("ddt.transport.filterBtn.showCanHijack.txt");
                }
                else
                {
                    _local_2.text = LanguageMgr.GetTranslation("ddt.transport.filterBtn.showAll.txt");
                };
                this._filterBtnGroup.addSelectItem(_local_2);
                this._filterBtnVBox.addChild(_local_2);
                _local_1++;
            };
            this._filterBtnGroup.selectIndex = SharedManager.Instance.hijackCarFilter;
        }

        protected function addEvent():void
        {
            addEventListener(MouseEvent.CLICK, this.__mouseClick);
            addEventListener(Event.ENTER_FRAME, this.__updateMap);
            TransportManager.Instance.addEventListener(ConsortionEvent.TRANSPORT_ADD_CAR, this.__addNewCar);
            TransportManager.Instance.addEventListener(ConsortionEvent.TRANSPORT_REMOVE_CAR, this.__removeCar);
            TransportManager.Instance.addEventListener(ConsortionEvent.ENABLE_SENDCAR_BTN, this.__enableSendCarBtn);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.HIJACK_ANSWER, this.__hijackAnswer);
            this._data.addEventListener(DictionaryEvent.ADD, this.__addPlayer);
            this._data.addEventListener(DictionaryEvent.REMOVE, this.__removePlayer);
            GameManager.Instance.addEventListener(GameManager.START_LOAD, this.__startLoading, false, 1);
            this._filterBtnGroup.addEventListener(Event.CHANGE, this.__filterBtnGroupChange);
        }

        private function __filterBtnGroupChange(_arg_1:Event):void
        {
            var _local_2:TransportCar;
            var _local_3:TransportCar;
            SoundManager.instance.play("008");
            SharedManager.Instance.hijackCarFilter = this._filterBtnGroup.selectIndex;
            SharedManager.Instance.save();
            if (this._filterBtnGroup.selectIndex == 0)
            {
                for each (_local_2 in this._mapObjs)
                {
                    if (((!(_local_2.canHijack)) && (!(_local_2.info.ownerId == PlayerManager.Instance.Self.ID))))
                    {
                        _local_2.visible = false;
                    };
                };
            }
            else
            {
                for each (_local_3 in this._mapObjs)
                {
                    _local_3.visible = true;
                };
            };
        }

        private function __hijackAnswer(_arg_1:CrazyTankSocketEvent):void
        {
            if (this._waitTime)
            {
                this._waitTime.dispose();
                this._waitTime = null;
            };
        }

        private function __startLoading(_arg_1:Event):void
        {
            _arg_1.stopImmediatePropagation();
            if (this._waitTime)
            {
                this._waitTime.dispose();
                this._waitTime = null;
            };
            StateManager.getInGame_Step_6 = true;
            if (GameManager.Instance.Current == null)
            {
                return;
            };
            LayerManager.Instance.clearnGameDynamic();
            GameManager.Instance.gotoRoomLoading();
            StateManager.getInGame_Step_7 = true;
            this.dispose();
        }

        protected function addOjbect():void
        {
            var _local_1:TransportCar;
            var _local_2:uint;
            var _local_3:uint;
            for each (_local_1 in this._mapObjs)
            {
                _local_1.createCarByType();
                _local_1.x = ((TransportCar.MOVE_DISTANCE * _local_1.info.movePercent) + 85);
                _local_1.y = ((Math.random() * 300) + 230);
                this.objLayer.addChild(_local_1);
                if ((((this._filterBtnGroup.selectIndex == 0) && (!(_local_1.canHijack))) && (!(_local_1.info.ownerId == PlayerManager.Instance.Self.ID))))
                {
                    _local_1.visible = false;
                };
            };
            _local_2 = 0;
            while (_local_2 < this._mapObjs.list.length)
            {
                _local_3 = (this._mapObjs.list.length - 1);
                while (_local_3 > _local_2)
                {
                    if (this._mapObjs.list[(_local_3 - 1)].y > this._mapObjs.list[_local_3].y)
                    {
                        this.objLayer.swapChildren(this._mapObjs.list[(_local_3 - 1)], this._mapObjs.list[_local_3]);
                    };
                    _local_3--;
                };
                _local_2++;
            };
        }

        private function __addNewCar(_arg_1:ConsortionEvent):void
        {
            var _local_2:TransportCar;
            var _local_4:uint;
            if ((!(this._mapObjs)))
            {
                return;
            };
            _local_2 = (_arg_1.data as TransportCar);
            _local_2.createCarByType();
            _local_2.x = ((TransportCar.MOVE_DISTANCE * _local_2.info.movePercent) + 85);
            _local_2.y = ((Math.random() * 300) + 230);
            this._mapObjs.add(_local_2.info.ownerId, _local_2);
            this.objLayer.addChild(_local_2);
            var _local_3:uint;
            while (_local_3 < this._mapObjs.list.length)
            {
                _local_4 = (this._mapObjs.list.length - 1);
                while (_local_4 > _local_3)
                {
                    if (this._mapObjs.list[(_local_4 - 1)].y > this._mapObjs.list[_local_4].y)
                    {
                        this.objLayer.swapChildren(this._mapObjs.list[(_local_4 - 1)], this._mapObjs.list[_local_4]);
                    };
                    _local_4--;
                };
                _local_3++;
            };
            if (_local_2.info.guarderId == PlayerManager.Instance.Self.ID)
            {
                this._remainPanel.setBeginBtnEnable(false);
                this.selfPlayer.playerPoint = new Point(_local_2.x, (_local_2.y + 50));
                this.selfPlayer.consortionPlayerInfo.walkPath = [new Point(_local_2.x, (_local_2.y + 50))];
                this.setCenter();
            };
            if ((((this._filterBtnGroup.selectIndex == 0) && (!(_local_2.canHijack))) && (!(_local_2.info.ownerId == PlayerManager.Instance.Self.ID))))
            {
                _local_2.visible = false;
            };
        }

        private function __removeCar(_arg_1:ConsortionEvent):void
        {
            if ((!(this._mapObjs)))
            {
                return;
            };
            var _local_2:TransportCar = (_arg_1.data as TransportCar);
            if (this._mapObjs.hasKey(_local_2.info.ownerId))
            {
                this._mapObjs.remove(_local_2.info.ownerId);
                this.objLayer.removeChild(_local_2);
                _local_2.dispose();
            };
        }

        protected function __updateMap(_arg_1:Event):void
        {
            var _local_2:ConsortionWalkPlayer;
            var _local_3:int;
            var _local_4:uint;
            var _local_5:uint;
            if (((!(this._characters)) || (this._characters.length <= 0)))
            {
                return;
            };
            for each (_local_2 in this._characters)
            {
                _local_2.updatePlayer();
            };
            if (this._playerLastY != this.selfPlayer.y)
            {
                this._playerLastY = this.selfPlayer.y;
                _local_3 = this.objLayer.numChildren;
                _local_4 = 0;
                while (_local_4 < _local_3)
                {
                    _local_5 = (_local_3 - 1);
                    while (_local_5 > _local_4)
                    {
                        if (this.objLayer.getChildAt((_local_5 - 1)).y > this.objLayer.getChildAt(_local_5).y)
                        {
                            this.objLayer.swapChildren(this.objLayer.getChildAt((_local_5 - 1)), this.objLayer.getChildAt(_local_5));
                        };
                        _local_5--;
                    };
                    _local_4++;
                };
            };
            this.BuildEntityDepth();
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
            this._mouseMovie.x = _arg_2.x;
            this._mouseMovie.y = _arg_2.y;
            this._mouseMovie.play();
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
        }

        public function addSelfPlayer():void
        {
            var _local_1:Point;
            var _local_2:TransportCar;
            var _local_3:ConsortionWalkPlayerInfo;
            if ((!(this.selfPlayer)))
            {
                _local_1 = new Point(274, 615);
                for each (_local_2 in this._mapObjs)
                {
                    if (_local_2.info.ownerId == PlayerManager.Instance.Self.ID)
                    {
                        _local_1 = new Point(_local_2.x, (_local_2.y + 50));
                    };
                };
                _local_3 = new ConsortionWalkPlayerInfo();
                _local_3.playerPos = _local_1;
                _local_3.playerInfo = PlayerManager.Instance.Self;
                this._currentLoadingPlayer = new ConsortionWalkPlayer(_local_3, this.addPlayerCallBack);
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
                this.objLayer.addChild(this.selfPlayer);
                this.ajustScreen(this.selfPlayer);
                this.setCenter();
                this.selfPlayer.addEventListener(SceneCharacterEvent.CHARACTER_ACTION_CHANGE, this.playerActionChange);
            };
            _arg_1.playerPoint = _arg_1.consortionPlayerInfo.playerPos;
            _arg_1.sceneCharacterStateType = "natural";
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
            var _local_3:TransportCar;
            var _local_4:Point;
            var _local_2:String = _arg_1.data.toString();
            if (((_local_2 == "naturalStandFront") || (_local_2 == "naturalStandBack")))
            {
                this._mouseMovie.gotoAndStop(1);
                _local_3 = TransportManager.Instance.currentCar;
                if (_local_3)
                {
                    _local_4 = this.localToGlobal(new Point(this.selfPlayer.playerPoint.x, (this.selfPlayer.playerPoint.y + 50)));
                    if (((_local_3.hitTestPoint(_local_4.x, _local_4.y)) || (_local_3.hitTestObject(this.selfPlayer))))
                    {
                        this.showConfirmAlert();
                    };
                };
            };
        }

        private function __gameStart(_arg_1:CrazyTankSocketEvent):void
        {
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
            GameInSocketOut.sendGameRoomSetUp(0, RoomInfo.HIJACK_CAR, false, "", "", 3, 1, 0, false, RoomManager.Instance.current.ID);
        }

        private function __onSetupChanged(_arg_1:CrazyTankSocketEvent):void
        {
            this._waitTime = new TransportHijackWaitTime();
            LayerManager.Instance.addToLayer(this._waitTime, LayerManager.GAME_TOP_LAYER);
            RoomManager.Instance.removeEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
            SocketManager.Instance.out.SendHijackCar(TransportManager.Instance.currentCar.info.ownerId, RoomManager.Instance.current.ID);
            TransportManager.Instance.currentCar = null;
        }

        private function showConfirmAlert():void
        {
            SoundManager.instance.play("008");
            var _local_1:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("consortion.ConsortionTransport.confirmHijack.alert.txt", TransportManager.Instance.currentCar.info.ownerName, TransportManager.Instance.currentCar.info.nickName), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
            _local_1.moveEnable = false;
            _local_1.addEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
        }

        private function __confirmResponse(_arg_1:FrameEvent):void
        {
            var _local_3:BaseAlerFrame;
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.checkExpedition())
                {
                    _local_3 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tips"), LanguageMgr.GetTranslation("ddt.consortion.ConsortionTransport.stopExpedition"), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, true, false, LayerManager.BLCAK_BLOCKGOUND);
                    _local_3.moveEnable = false;
                    _local_3.addEventListener(FrameEvent.RESPONSE, this.__confirmResponse2);
                }
                else
                {
                    RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
                    RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
                    GameInSocketOut.sendCreateRoom(RoomListBGView.PREWORD[int((Math.random() * RoomListBGView.PREWORD.length))], RoomInfo.HIJACK_CAR, 3);
                };
            };
            if ((((_arg_1.responseCode == FrameEvent.ESC_CLICK) || (_arg_1.responseCode == FrameEvent.CANCEL_CLICK)) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)))
            {
                TransportManager.Instance.currentCar = null;
            };
            ObjectUtils.disposeObject(_local_2);
        }

        private function __confirmResponse2(_arg_1:FrameEvent):void
        {
            var _local_2:BaseAlerFrame = (_arg_1.currentTarget as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__confirmResponse);
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                SocketManager.Instance.out.sendExpeditionCancle();
                RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_CREATE, this.__gameStart);
                RoomManager.Instance.addEventListener(CrazyTankSocketEvent.GAME_ROOM_SETUP_CHANGE, this.__onSetupChanged);
                GameInSocketOut.sendCreateRoom(RoomListBGView.PREWORD[int((Math.random() * RoomListBGView.PREWORD.length))], RoomInfo.HIJACK_CAR, 3);
            };
            if ((((_arg_1.responseCode == FrameEvent.CANCEL_CLICK) || (_arg_1.responseCode == FrameEvent.CLOSE_CLICK)) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                TransportManager.Instance.currentCar = null;
            };
            ObjectUtils.disposeObject(_local_2);
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

        private function __enableSendCarBtn(_arg_1:ConsortionEvent):void
        {
            if (this._remainPanel)
            {
                this._remainPanel.setBeginBtnEnable(true);
            };
        }

        protected function removeEvent():void
        {
            removeEventListener(MouseEvent.CLICK, this.__mouseClick);
            removeEventListener(Event.ENTER_FRAME, this.__updateMap);
            TransportManager.Instance.removeEventListener(ConsortionEvent.TRANSPORT_ADD_CAR, this.__addNewCar);
            TransportManager.Instance.removeEventListener(ConsortionEvent.TRANSPORT_REMOVE_CAR, this.__removeCar);
            TransportManager.Instance.removeEventListener(ConsortionEvent.ENABLE_SENDCAR_BTN, this.__enableSendCarBtn);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.HIJACK_ANSWER, this.__hijackAnswer);
            GameManager.Instance.removeEventListener(GameManager.START_LOAD, this.__startLoading);
            this._filterBtnGroup.removeEventListener(Event.CHANGE, this.__filterBtnGroupChange);
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
            this._characters.clear();
            this._characters = null;
        }

        public function dispose():void
        {
            var _local_1:TransportCar;
            this.removeEvent();
            for each (_local_1 in this._mapObjs)
            {
                _local_1.dispose();
            };
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
            ObjectUtils.disposeObject(this._remainPanel);
            this._remainPanel = null;
            ObjectUtils.disposeObject(this._infoPanel);
            this._infoPanel = null;
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
            ObjectUtils.disposeObject(this._filterBtnGroup);
            this._filterBtnGroup = null;
            ObjectUtils.disposeAllChildren(this);
            this._sceneMapVO = null;
            if (parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.transportSence

