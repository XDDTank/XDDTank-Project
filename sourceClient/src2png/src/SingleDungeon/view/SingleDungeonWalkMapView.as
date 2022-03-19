// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//SingleDungeon.view.SingleDungeonWalkMapView

package SingleDungeon.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import SingleDungeon.SingleDungeonSenceStateView;
    import SingleDungeon.model.SingleDungeonWalkMapModel;
    import ddt.view.scenePathSearcher.SceneScene;
    import ddt.view.chat.ChatView;
    import flash.display.Bitmap;
    import ddt.view.PlayerPortraitView;
    import ddt.view.common.LevelIcon;
    import ddt.manager.ChatManager;
    import ddt.manager.PlayerManager;
    import ddt.data.player.SelfInfo;
    import com.pickgliss.ui.ComponentFactory;
    import SingleDungeon.event.SingleDungeonEvent;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.ui.LayerManager;
    import flash.display.MovieClip;
    import ddt.view.scenePathSearcher.PathMapHitTester;
    import ddt.manager.SoundManager;
    import flash.geom.Point;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import ddt.manager.DialogManager;
    import church.vo.SceneMapVO;
    import ddt.manager.LanguageMgr;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import flash.events.Event;
    import ddt.view.MainToolBar;
    import com.pickgliss.utils.ObjectUtils;

    public class SingleDungeonWalkMapView extends Sprite implements Disposeable 
    {

        public static const MAP_SIZEII:Array = [5000, 5000];

        private var _stateView:SingleDungeonSenceStateView;
        private var _walkMapModel:SingleDungeonWalkMapModel;
        private var _sceneScene:SceneScene;
        private var _sceneMap:SingleDungeonSenceMap;
        private var _chatFrame:ChatView;
        private var _headBoxBitm:Bitmap;
        private var _headBox:Sprite;
        private var _playerHeadView:PlayerPortraitView;
        private var _levelIcon:LevelIcon;

        public function SingleDungeonWalkMapView(_arg_1:SingleDungeonSenceStateView, _arg_2:SingleDungeonWalkMapModel)
        {
            this._stateView = _arg_1;
            this._walkMapModel = _arg_2;
            this.initialize();
        }

        private function initialize():void
        {
            this._sceneScene = new SceneScene();
            ChatManager.Instance.state = ChatManager.CHAT_WORLDBOS_ROOM;
            this._chatFrame = ChatManager.Instance.view;
            addChild(this._chatFrame);
            ChatManager.Instance.setFocus();
            this.setMap();
            this.setHeadBox();
        }

        private function setHeadBox():void
        {
            this._headBox = new Sprite();
            var _local_1:SelfInfo = PlayerManager.Instance.Self;
            this._headBoxBitm = ComponentFactory.Instance.creatBitmap("asset.singleDungeon.headBox");
            this._headBox.addChild(this._headBoxBitm);
            var _local_2:Sprite = this.headMask();
            this._playerHeadView = ComponentFactory.Instance.creatCustomObject("singledungeon.sencemap.PortraitView", ["right"]);
            this._playerHeadView.info = _local_1;
            this._playerHeadView.isShowFrame = false;
            this._playerHeadView.mask = _local_2;
            this._headBox.addChild(this._playerHeadView);
            this._headBox.addChild(_local_2);
            this._headBox.x = 12;
            this._headBox.y = 12;
            this.addChild(this._headBox);
            SingleDungeonEvent.dispatcher.addEventListener(SingleDungeonEvent.WALKMAP_EXIT, this._upArrow);
        }

        private function _upArrow(_arg_1:SingleDungeonEvent):void
        {
            NewHandContainer.Instance.showArrow(ArrowType.BACK_GUILDE, -45, "singleDungeon.missionbackArrowPos", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_UI_LAYER));
        }

        private function headMask():Sprite
        {
            var _local_1:Sprite = new Sprite();
            _local_1.graphics.beginFill(0);
            _local_1.graphics.drawCircle(47, 43, 38);
            _local_1.graphics.endFill();
            return (_local_1);
        }

        public function setMap(_arg_1:Point=null):void
        {
            this.clearMap();
            var _local_2:MovieClip = (ComponentFactory.Instance.creat(("singleDungeon.walkScene.map" + this._walkMapModel._mapSceneModel.ID)) as MovieClip);
            var _local_3:Sprite = (_local_2.getChildByName("mesh") as Sprite);
            var _local_4:Sprite = (_local_2.getChildByName("bg") as Sprite);
            MAP_SIZEII[0] = _local_4.width;
            MAP_SIZEII[1] = _local_4.height;
            this._sceneScene.setHitTester(new PathMapHitTester(_local_3));
            if ((!(this._sceneMap)))
            {
                this._sceneMap = new SingleDungeonSenceMap(this._sceneScene, this._walkMapModel.getPlayers(), this._walkMapModel.getObjects(), _local_4, _local_3);
                addChildAt(this._sceneMap, 0);
            };
            this._sceneMap.sceneMapVO = this.getSceneMapVO();
            if (_arg_1)
            {
                this._sceneMap.sceneMapVO.defaultPos = _arg_1;
            };
            this._sceneMap.addSelfPlayer();
            this._sceneMap.setCenter();
            SoundManager.instance.playMusic(("map" + this._walkMapModel._mapSceneModel.ID));
        }

        private function showGuide():void
        {
            if ((((this._walkMapModel._mapSceneModel.ID == 2) && (SavePointManager.Instance.isInSavePoint(11))) && (!(TaskManager.instance.isNewHandTaskCompleted(3)))))
            {
                LayerManager.Instance.addToLayer(DialogManager.Instance.DialogBox, LayerManager.STAGE_TOP_LAYER);
                NewHandContainer.Instance.showArrow(ArrowType.TIP_CHEST, -135, "trainer.posChest2", "", "", this._sceneMap.getLayerByIndex(0));
            };
        }

        public function getSceneMapVO():SceneMapVO
        {
            var _local_1:SceneMapVO = new SceneMapVO();
            _local_1.mapName = LanguageMgr.GetTranslation("church.churchScene.WeddingMainScene");
            _local_1.mapW = MAP_SIZEII[0];
            _local_1.mapH = MAP_SIZEII[1];
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
                this._sceneMap.updatePlayersStauts(_arg_1, _arg_2, _arg_3);
            };
        }

        public function updateSelfStatus(_arg_1:int):void
        {
            this._sceneMap.updateSelfStatus(_arg_1);
        }

        private function _leaveRoom(_arg_1:Event):void
        {
            StateManager.setState(StateType.SINGLEDUNGEON);
            this._stateView.dispose();
        }

        private function clearMap():void
        {
            if (this._sceneMap)
            {
                if (this._sceneMap.parent)
                {
                    this._sceneMap.parent.removeChild(this._sceneMap);
                };
                this._sceneMap.dispose();
            };
            this._sceneMap = null;
        }

        public function show():void
        {
            this._stateView.addChild(this);
            this.showGuide();
        }

        public function dispose():void
        {
            SingleDungeonEvent.dispatcher.removeEventListener(SingleDungeonEvent.WALKMAP_EXIT, this._upArrow);
            MainToolBar.Instance.setReturnEnable(true);
            ObjectUtils.disposeAllChildren(this);
            this._sceneScene = null;
            this._sceneMap = null;
            this._chatFrame = null;
            if (this._headBoxBitm)
            {
                ObjectUtils.disposeObject(this._headBoxBitm);
            };
            this._headBoxBitm = null;
            if (this._headBox)
            {
                ObjectUtils.disposeObject(this._headBox);
            };
            this._headBox = null;
            if (this._playerHeadView)
            {
                ObjectUtils.disposeObject(this._playerHeadView);
            };
            this._playerHeadView = null;
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
}//package SingleDungeon.view

