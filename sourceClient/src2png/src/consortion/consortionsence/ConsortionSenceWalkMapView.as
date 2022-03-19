// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.consortionsence.ConsortionSenceWalkMapView

package consortion.consortionsence
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import ddt.states.BaseStateView;
    import ddt.view.scenePathSearcher.SceneScene;
    import consortion.IConsortionState;
    import ddt.view.chat.ChatView;
    import ddt.view.common.LevelIcon;
    import consortion.view.monsterReflash.MonsterRankView;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.controls.BaseButton;
    import ddt.manager.ChatManager;
    import ddt.view.chat.ChatOutputView;
    import consortion.managers.ConsortionMonsterManager;
    import consortion.event.ConsortionMonsterEvent;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.PlayerManager;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import flash.display.MovieClip;
    import consortion.ConsortionModel;
    import consortion.transportSence.TransportSenceMap;
    import consortion.transportSence.TransportManager;
    import ddt.view.scenePathSearcher.PathMapHitTester;
    import flash.geom.Point;
    import ddt.manager.SoundManager;
    import church.vo.SceneMapVO;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import flash.events.Event;
    import com.pickgliss.utils.ObjectUtils;
    import ddt.manager.SocketManager;
    import ddt.view.MainToolBar;

    public class ConsortionSenceWalkMapView extends Sprite implements Disposeable 
    {

        public static const MAP_SIZE:Array = [5000, 5000];

        private var _stateView:BaseStateView;
        private var _scenScene:SceneScene;
        private var _sceneMap:IConsortionState;
        private var _chatFrame:ChatView;
        private var _levelIcon:LevelIcon;
        private var _senceType:int = 0;
        private var _monsterRankView:MonsterRankView;
        private var _Gradebg:Bitmap;
        private var _consortionName:FilterFrameText;
        private var _level:ScaleFrameImage;
        private var _transportBtn:BaseButton;

        public function ConsortionSenceWalkMapView(_arg_1:BaseStateView, _arg_2:int)
        {
            this._stateView = _arg_1;
            this._senceType = _arg_2;
            this.initialize();
        }

        private function initialize():void
        {
            this._scenScene = new SceneScene();
            ChatManager.Instance.output.channel = ChatOutputView.CHAT_OUPUT_CURRENT;
            ChatManager.Instance.view.bg = false;
            this._chatFrame = ChatManager.Instance.view;
            addChild(this._chatFrame);
            ChatManager.Instance.setFocus();
            ConsortionMonsterManager.Instance.addEventListener(ConsortionMonsterEvent.MONSTER_ACTIVE_START, this.__onActiveStarted);
            this.setMap();
        }

        private function createGradeInfo():void
        {
            this._Gradebg = ComponentFactory.Instance.creatBitmap("asset.consortionMap.GradeBg");
            this._consortionName = ComponentFactory.Instance.creatComponentByStylename("ConsorionMap.nameText");
            this._consortionName.text = PlayerManager.Instance.Self.ConsortiaName;
            this._level = ComponentFactory.Instance.creatComponentByStylename("consortion.level");
            this._level.scaleX = 0.5;
            this._level.scaleY = 0.5;
            this._level.setFrame(PlayerManager.Instance.Self.consortiaInfo.Level);
            PositionUtils.setPos(this._level, "asset.consortionMap.pos");
            this._transportBtn = ComponentFactory.Instance.creatComponentByStylename("consortion.transportBtn");
            this._transportBtn.addEventListener(MouseEvent.CLICK, this.__clickTransportBtn);
            addChild(this._Gradebg);
            addChild(this._consortionName);
            addChild(this._level);
            addChild(this._transportBtn);
        }

        public function setMap(_arg_1:Point=null):void
        {
            var _local_2:MovieClip;
            var _local_3:Sprite;
            var _local_4:Sprite;
            var _local_5:MovieClip;
            var _local_6:MovieClip;
            var _local_7:MovieClip;
            var _local_8:MovieClip;
            var _local_9:Sprite = new Sprite();
            if ((!(this._sceneMap)))
            {
                switch (this._senceType)
                {
                    case ConsortionModel.CONSORTION_SENCE:
                        ChatManager.Instance.state = ChatManager.CHAT_CONSORTIA_VIEW;
                        _local_2 = (ComponentFactory.Instance.creat("consortion.walkScene.map1") as MovieClip);
                        _local_3 = (_local_2.getChildByName("mesh") as Sprite);
                        _local_4 = (_local_2.getChildByName("bg") as Sprite);
                        _local_5 = (_local_2.getChildByName("hallMouse") as MovieClip);
                        _local_6 = (_local_2.getChildByName("shopMouse") as MovieClip);
                        _local_7 = (_local_2.getChildByName("skillMouse") as MovieClip);
                        _local_8 = (_local_2.getChildByName("plantArea") as MovieClip);
                        _local_9.addChild(_local_8);
                        this._sceneMap = new ConsortionSenceMap(this._scenScene, ConsortionManager.Instance._consortionWalkMode.getPlayers(), ConsortionManager.Instance._consortionWalkMode.getObjects(), _local_4, _local_3, _local_5, _local_6, _local_7, _local_9);
                        this._monsterRankView = new MonsterRankView();
                        PositionUtils.setPos(this._monsterRankView, "consortion.monsterRankPos");
                        if (ConsortionMonsterManager.Instance.ActiveState)
                        {
                            this._monsterRankView.visible = true;
                            this.playBackMusic(3);
                        }
                        else
                        {
                            this._monsterRankView.visible = false;
                            this.playBackMusic(1);
                        };
                        addChild(this._monsterRankView);
                        this.createGradeInfo();
                        break;
                    case ConsortionModel.CONSORTION_TRANSPORT:
                        ChatManager.Instance.state = ChatManager.CHAT_CONSORTIA_TRANSPORT_VIEW;
                        _local_2 = (ComponentFactory.Instance.creat("singleDungeon.walkScene.map6") as MovieClip);
                        _local_3 = (_local_2.getChildByName("mesh") as Sprite);
                        _local_4 = (_local_2.getChildByName("bg") as Sprite);
                        this.playBackMusic(2);
                        this._sceneMap = new TransportSenceMap(this._scenScene, TransportManager.Instance.transportModel.getPlayers(), TransportManager.Instance.transportModel.getObjects(), _local_4, _local_3);
                        break;
                };
                addChildAt((this._sceneMap as Sprite), 0);
            };
            MAP_SIZE[0] = _local_4.width;
            MAP_SIZE[1] = _local_4.height;
            this._scenScene.setHitTester(new PathMapHitTester(_local_3));
            this._sceneMap.sceneMapVO = this.getSceneMapVO();
            if (_arg_1)
            {
                this._sceneMap.sceneMapVO.defaultPos = _arg_1;
            };
            this._sceneMap.addSelfPlayer();
            this._sceneMap.setCenter();
        }

        private function playBackMusic(_arg_1:int):void
        {
            switch (_arg_1)
            {
                case 1:
                    SoundManager.instance.playMusic("sceneofthesociety");
                    return;
                case 2:
                    SoundManager.instance.playMusic("robberypath");
                    return;
                case 3:
                    SoundManager.instance.playMusic("monsterinvasion");
                    return;
            };
        }

        public function getSceneMapVO():SceneMapVO
        {
            var _local_1:SceneMapVO = new SceneMapVO();
            _local_1.mapW = MAP_SIZE[0];
            _local_1.mapH = MAP_SIZE[1];
            _local_1.defaultPos = new Point(100, 100);
            return (_local_1);
        }

        public function movePlayer(_arg_1:int, _arg_2:Array):void
        {
            if (this._sceneMap)
            {
                this._sceneMap.movePlayer(_arg_1, _arg_2);
            };
        }

        public function updatePlayerStauts(_arg_1:int, _arg_2:int, _arg_3:Point=null):void
        {
            if (this._sceneMap)
            {
                this._sceneMap.updatePlayerStauts(_arg_1, _arg_2, _arg_3);
            };
        }

        public function updateSelfStatus(_arg_1:int):void
        {
            this._sceneMap.updateSelfStatus(_arg_1);
        }

        private function _leaveRoom(_arg_1:Event):void
        {
            StateManager.setState(StateType.CONSORTIA);
            this._stateView.dispose();
        }

        private function clearMap():void
        {
            if (this._sceneMap)
            {
                ObjectUtils.disposeObject(this._sceneMap);
            };
            this._sceneMap = null;
        }

        public function show():void
        {
            this._stateView.addChild(this);
        }

        private function __onActiveStarted(_arg_1:ConsortionMonsterEvent):void
        {
            if (this._monsterRankView)
            {
                this._monsterRankView.visible = (_arg_1.data as Boolean);
                this.playBackMusic(3);
            };
        }

        private function __clickTransportBtn(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.SendenterConsortionTransport();
        }

        public function dispose():void
        {
            ConsortionMonsterManager.Instance.removeEventListener(ConsortionMonsterEvent.MONSTER_ACTIVE_START, this.__onActiveStarted);
            MainToolBar.Instance.setReturnEnable(true);
            ObjectUtils.disposeAllChildren(this);
            this._scenScene = null;
            this._sceneMap = null;
            this._chatFrame = null;
            this._monsterRankView = null;
            this._Gradebg = null;
            this._consortionName = null;
            this._level = null;
            ObjectUtils.disposeObject(this._transportBtn);
            this._transportBtn = null;
            if (this._levelIcon)
            {
                ObjectUtils.disposeObject(this._levelIcon);
            };
            this._levelIcon = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package consortion.consortionsence

